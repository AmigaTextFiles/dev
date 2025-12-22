/*
 iff anim decoder

 purpose: handles decoding of IFF animation files known from the Amiga
 Version: look at preprocessor definition below
 Date:    look at preprocessor definition below
 Author:  Markus Wolf


 This class provides neccessary methods for decompressing IFF-ANIM animations.
 It can easily be implemented in any player or converter.



Internal frame Management:
-----------------
 The Animation data is read to memory completely, into a frame list:
   -> frames are decoded faster (delta compression is kept in memory)
   -> verification of data before playing -> no file reading errors during play (except compression errors)
   - I haven't seen an iff animation with more than 10MB, so this shouldn't be a problem.

 Frame data:
   There is the "current frame" and the "previous frame" in bitplanar format representing a kind of double buffer
   When a frame is decoded, the delta frame information modifies the previous frame always. After that the "previous frame"
   is swapped with the "current frame".
   The "current frame" can be converted to a useful output format (chunky), to a display suitable frame
   When opening a file, the first bit planar frame is decoded (frame 0).
   A call to "NextFrame" decodes the next frame (frame 1).



Output formats
--------------
The old bitplanar format isn't useable for today's graphic systems, so the animation frames can be converted to chunky formats.
 - 1..8 bit are converted to 8 bit, with a "r,g,b,0" palette (byte order exactly as mentioned)
 - HAM and 24 bit frames are converted to 24 bit "r,g,b" images (byte order as mentioned)
 - pitch for a scanline can be defined



Notes for a player:
---------------------
 While waiting the delay of a frame, it is useful to decode the next frame already.
 Add the used time for the decoding to your "already waited time".
 You'll need a timer with a resolution of at least 1/60 seconds.



File format support:
--------------------

ANIM file is currently only supported in it's standart structure:
 - I haven't seen any other structure so far

 FORM ANIM
  FORM ILBM        first frame (frame 0)
    BMHD             normal type IFF data
    ANHD             optional animation header (chunk for timing of 1st frame)
    ...            
    CMAP             optional cmap
    BODY             normal iff pixel data
  FORM ILBM        frame 1
    ANHD             animation header chunk
    DLTA             delta mode data
  FORM ILBM        frame 2
    ANHD
    DLTA
    ....

known delta compression modes (current decoding support is marked with '*'):
  - ANIM-0 * ILBM BODY (no delta compression)
  - ANIM-1   ILBM XOR
  - ANIM-2   Long Delta mode
  - ANIM-3   Short Delta mode
  - ANIM-4   General Delta mode
  - ANIM-5 * Byte Vertical Delta mode (most common)
  - ANIM-6   Stereo Byte Delta mode
  - ANIM-7 * Anim-5 compression using LONG/WORD data
  - ANIM-8 * Anim-5 compression using LONG/WORD data
  - ANIM-J * Eric Grahams compression format (Sculpt 3D / Sculpt 4D, by "Byte by Byte")
  
 "dctv" animations aren't supported, due to lacking format information.



History:
--------
 * 30-mar-2007:
   - "GetPrevFrame()" added

 * 20-nov-2006:
   - first release


*/



#ifndef _iffanim_H_
#define _iffanim_H_

using namespace std;

#include <iostream>
#include <fstream>
#include <stdint.h>    //integer type definitions


#define IFFANIM_VERSION "1.01, 30-Mar-2007"


#define IFFANIM_FORMATINFO_BUFSIZE  1000  //size of string buffer for returning information about ANIM file
#define IFFANIM_ERRORSTRING_BUFSIZE 1000  //for string containing error information
#define IFFANIM_PITCH  (32 / 8)           //pitch of scanline for frame output ("GetFrame()") can be set: multiple of 1, 2, 3 or 4 bytes



//struct for a single frame, used in a memory frame list
// contains needed anim header information for decompression
// some fields are not used currently
typedef struct iffanim_frame
{
 int   delta_compression;  //determines compression type
 int   mask;       //for XOR mode only

 int   w;          //XOR mode only
 int   h;          //XOR mode only
 int   x;          //XOR mode only
 int   y;          //XOR mode only

 int      reltime;    //relative display time in 1/60 sec
 int      interleave; //indicates how many frames back the data is to modify
 uint32_t bits;       //options for some compressions as flags
 
 char *cmap;          //original cmap (if exists), else NULL, number of color entries depends on bits per pixel resolution
 char *data;          //original pixel data from file (maybe compressed)
 int  datasize;       //size of data in bytes
};


//struct for embedded audio, created with Amiga software "Wave Tracer DS" by ""
typedef struct iffanim_audio
{
 int   freq;      //playback sample frequency 
 int   nch;       //number of channels: 0 no audio, 1 mono, 2 stereo (left, right interleaved), other values aren't supported
 int   bps;       //bits per sample point
 float volume;    //volume: 0..1

 int   n;          //equal to nframes (the last frame data may contain 2 SBDY chunks, or somewhere else for joined animations)
 char *data;       //audio buffer (Big Endian byte order, signed)
 int  *dataoffset; //list of audio sample start, which starts playing at current frame (for every frame), in bytes, begins on full frames
 int   datasize;   //total audio data size in bytes
};







class IffAnim
{
 //>>>>>>>> attributes
 protected:
  //animation attributes
  int  w,h,bpp;         //width, height, bits per pixel of anim (original format)
  int  mask;            //indicates mask type defined in BMHD chunk (0,1,2,3)
  bool ham;             //"true" if ham mode
  bool ehb;             //"true" if extra half bright palette
  int  compressed;      //indicates compression type of first frame (0 or 1, only byterun is supported) (other frames have delta compression)
  unsigned char dcompressions[32]; //bit array indicates which delta compression methods are used in the anim (there may be mixed compression modes)
 
  int    nframes;       //number of frames
  int    lentime;       //overall length of animation in 1/60 seconds (original format)
  struct iffanim_frame *frame;  //list containing all frames (original format, still delta compressed)

  //decoded image in common format ready for output
  int   disp_bpp;       //display format (doesn't change), in common supported format: (1..8 bit converted to 8, ham to 24 bpp)
  int   disp_pitch;     //number of byte per scanline (size of dispframe in bytes: h * disp_pitch), can be considered as always 0

  char *disp_frame;     //decoded frame, display ready converted (a line padded to full 32 bit)
  char *disp_cmap;      //cmap, if 8 bit display mode (for all frames the same), else NULL

  char *prev_disp_frame; //previous display frame (a player may need this for double buffering with resize handling without creating an extra frame copy)
  char *prev_disp_cmap;  //previous display frame map


  //current state (frame attributes)
  char *prevframe;   //frame before current (internal/original frame format)
  char *prevcmap;    //pointer to cmap of previous frame
  char *curframe;    //buffer for decoded frame, in original format (multiplanar)
  char *curcmap;     //ptr to cmap in frame list, can be redefined for a frame
  int   framesize;   //size of a decoded frame in bytes (each scanline has a multiple of 16 bit -> number of bytes is even)
  int   frameno;     //current frame (as number)

  iffanim_audio audio;  //contains audio data, if supported
//  char *xor_buffer;     //used for XOR delta compression (mode 1) only, can hold a RLE decompressed XOR map

  int  num_disp_frames;   //number of frames converted to display format (set to 0 after loading)
  bool loopanim;          //if set, when looping, the next frame of the last frame is frame 2, else frame 0
  bool loop;              //if unset, there is an error when trying to load the next frame of the last frame, else the animation restarts
  bool file_loaded;       //indicates if a file is currently loaded
  char formatinfo[IFFANIM_FORMATINFO_BUFSIZE];   //buffer for returning format information
  char errorstring[IFFANIM_ERRORSTRING_BUFSIZE]; //buffer for error information




  //>>>>>>>> internal methods
 protected:
  //init attributes to default values (after closing, object creation)  
   void InitAttributes();
   
  //decode compressed data ("static" to make sure functions contain portable code only)
   static int DecodeByteRun(void *dst, void *data, int datasize, int w, int h, int bpp, int mask);  //ILBM byte run (RLE), commonly used for the first frame (key frame)
   static int DecodeByteVerticalDelta(char *dst, void *data, int w, int bpp);                       //delta compression method 5 (byte vertical delta with skip)
   static int DecodeLSVerticalDelta7(char *dst, void *data_, int w, int bpp,  bool long_data);      //delta compression method 7 (long/short vertical delta)(with 16 or 32 bit words)
   static int DecodeLSVerticalDelta8(char *dst, void *data_, int w, int bpp,  bool long_data);      //delta compression method 8 (long/short vertical delta)(with 16 or 32 bit words)
   static int DecodeDeltaJ(char *dst, void *data_, int  w, int  h, int  bpp);                       //delta compression method 'J' (74) by Eric Graham
   
  //decode frame from frame list to dstframe (bitplanar, multiple of 16 bit per plane), excludes possible mask plane
   int  DecodeFrame(char *dstframe, int index);
  //convert image in bitplanar format to chunky
   int  BitplanarToChunky(void *dst_, void *src_,  int w, int h, int bitssrc, int bitsdst, int dst_pitch);
  //convert HAM6 and HAM8 (hold and modify) to 24 bits per pixel RGB / chunky
   int  ConvertHamTo24bpp(void *dst_, void *src_, void *cmap_, int w, int h, int bpp, int dst_pitch);
  //find a requested chunk in iff file
   int  FindChunk(fstream *file, char *idreq, int len);
  //get number of frames
   int  GetNumFrames(fstream *file);
  //read anim frames and info to buffer (calculates "lentime")
   int  ReadFrames(fstream *file);
  //print file format information to info string
   void PrintInfo();     
  //read chunks to mem
   void read_ANHD(fstream *file, iffanim_frame *frame);     //read information from animation header chunk to "frame" (list entry)
   void read_CMAP(fstream *file, iffanim_frame *frame);     //read color map from chunk to to "frame"
   int  read_SBDY(fstream *file, int searchlen, char **audiobuf, int *audiobufsize); //read audio data
  //interleave audio from separate channels (8 or 16 bit only), returns new array or NULL on error
   int  InterleaveStereo(char *data, int datasize, int bps);



 //>>>>>>>>> interface methods
 public:    
       IffAnim();         //constructor
      ~IffAnim();         //destructor
  void Close();           //frees all buffers   
  int  Open(char *fname); //open and read anim file to memory, returs 0 on success, -1 on error, file is closed after reading data
  bool is_open();         //returns true if a animation is loaded

  int  Reset();           //reset state to frame 0, also called once after opening a file
        
  int  NextFrame();       //decompress next frame to internal buffer (get new cmap), incr. frame counter
  int  ConvertFrame();    //convert decoded frame (and cmap) to display format onto display image, buffer is swapped with previously converted frame
  int  GetDelayTime();    //get the display time of the current frame in millisec
  int  GetDelayTimeOriginal();  //get delay time in 1/60 seconds (original format stored in the file)

  bool SetLoopAnim(bool state);  //Can only be manually set (is false by default), useful for loopanimations with the 2 first frames and the 2 last beeing the same
                                 // the animation won't stop at the end but continue with frame 2, the 2 last frames are considered to be the first ones after the end is reached
  void SetLoop(bool state);      //the animation won't loop by itself, if deactivated, but looping can also be controlled by the host programm via "Reset()"
                                 // looping is always activated by default
                                    
  char *GetInfo();               //return information string about the anim file
  char *GetError();              //return newest error string

  char *GetFramePlanar(int *framesize);   //return decoded bitplanar frame (don't modify the array), framesize is passed to the pointer                              
  void *GetFrame();              //return pointer to last converted frame (display format), 8 or 24 bit (order: r,g,b,r,g,b,...)
  void *GetCmap();               //return cmap pointer of last converted frame (display format), format is: r,g,b,0 (4 bytes per entry)
  void *GetPrevFrame();          //return previous display frame
  void *GetPrevCmap();           //return previous display frame cmap
  int   GetInfo(int *w, int *h, int *bpp, int *pitch, int *numframes, int *mslentime);  //get format (display/decoding format), length of animation in ms, enter NULL for unrequested parameters        
  int   CurrentFrameIndex();     //return current frame number (starting at 0)

  int   GetAudioFormat(int *nch, int *bps, int *freq);  //returns 0 if audio is available, else -1, parameters with NULL are ignored
  char *GetAudioData(int *size);       //returns pointer to audio data array, NULL if not available, stores size in bytes to the pointer
  int   GetAudioOffset(int index);     //returns byte offset in audio data array to specific frame
  int   GetAudioOffset(int index, int msoffs); //return the audio offset of: the frame relating to the "index" + "msoffs" (in millisec), "msoffs" may be < 0 and also return value, useful to resynchronize audio to video
  int   GetAudioFrameSize(int index);  //return audio data size in bytes for specific video frame, size of data which is played during the video frame
};



#endif
