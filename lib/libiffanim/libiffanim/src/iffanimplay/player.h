/*
player class using "libiffanim", and "SDL" (Simple DirectMedia Layer)
Author:  Markus Wolf
Version: look at preprocessor definition below
Date:    look at preprocessor definition below
*/


#ifndef _player_H_
#define _player_H_

using namespace std;

#include <iffanim.h>   //has no special depencies


#include <SDL.h>

//avoids byte order problems with SDL surfaces
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
  #define RMASK  0xff000000
  #define GMASK  0x00ff0000
  #define BMASK  0x0000ff00
  #define AMASK  0x000000ff
#else
  #define RMASK  0x000000ff
  #define GMASK  0x0000ff00
  #define BMASK  0x00ff0000
  #define AMASK  0xff000000
#endif



#define IFFANIMPLAY_VERSION "1.01, 30-Mar-2007"


#define IFFANIMPLAY_NONE 0     //does nothing
#define IFFANIMPLAY_QUIT 1     //quit event

#define IFFANIMPLAY_SMPBUFSIZE 2048  //sample buffer in samples (sampleframes for stereo?), 512 very accurate -> buffer underun on some systems





class AnimPlayer
{
 protected:
   SDL_Surface *screen;    //screen surface
   SDL_Surface *dispimg;   //scaled image
   
   int  numframes;   // number of frames
   int  curframe;    // current frame number (starting with 0)   

   bool  audioinitialized; //"true" if audio is initialized, else "false"
   int   audiolen;   // byte len of audio data
   int   audiopos;   // current byte position in audio data
   char *audiodata;  // audio data array
   
   bool playing;     // "true" if playing, "false" if paused
   bool ended;       // "true" end reached, "false" if end not reached
   bool loop;        // loops animation if set to "true"
   bool loopanim;    // handles loop animations with the 2 first and 2 last frames beeing the same
   bool fixtime;     // fixed time delay for every frame
   int  fixtimeval;  // fixed time delay in ms

   int  w_disp;      // display width in pixels
   int  h_disp;      // display height
   int  w_org;       // original width
   int  h_org;       // original height
   int  pitch;       // length of a scanline of the decoded/convertd image in bytes
   int  bpp;         // bits per pixel of the decoded/convertd image (8/24)
   int  lentime;     // length of animation in ms 

   class IffAnim anim;  // animation class (libiffanim)

 //>>>>>>>> internal methods
 protected:
  //set window title with information, title update
   void SetCaption();
  //save each frame as bmp file (audio as raw, interleaved data)
   int  Extract(char *outpath);
  //wait for event (event handling), or until time has passed for current frame
   int  Wait(int delay);
  //resize window
   void Resize(int w, int h);
   
  //generic scale methods
   void ScaleBitmap24(char *dst, int dstw, int dsth, int dstpitch, char *src, int srcw, int srch, int srcpitch);
   void ScaleBitmap8(char *dst, int dstw, int dsth, int dstpitch, char *src, int srcw, int srch, int srcpitch);
      
  //generate numbered file name
   int  mkfname(int val, int ndigits, char *fname, char *prefix, char *ext); 
  //print command line help
   int  printhelp();
   
  //static audio callback function
   static void audio_callback(void *userdata, Uint8 *stream, int len);


 //>>>>>>>>> interface methods
 public:
  //main method
   int  main(int argc, char **argv);
};

#endif
