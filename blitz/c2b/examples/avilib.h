/*
**      $VER: avilib.h 1.0 (12.12.2003)
**
**      main include file for avilib.library
*/

#ifndef LIBRARIES_AVILIB_H
#define LIBRARIES_AVILIB_H

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

struct AvilibBase {
  struct Library LibNode;
};

#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <inttypes.h>
#include <limits.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>


#define AVI_MAX_TRACKS 8

typedef struct
{
  off_t key;
  off_t pos;
  off_t len;
} video_index_entry;

typedef struct
{
   off_t pos;
   off_t len;
   off_t tot;
} audio_index_entry;


// Index types


#define AVI_INDEX_OF_INDEXES 0x00             // when each entry in aIndex
                                              // array points to an index chunk
#define AVI_INDEX_OF_CHUNKS  0x01             // when each entry in aIndex
                                              // array points to a chunk in the file
#define AVI_INDEX_IS_DATA    0x80             // when each entry is aIndex is
                                              // really the data
// bIndexSubtype codes for INDEX_OF_CHUNKS
//
#define AVI_INDEX_2FIELD     0x01             // when fields within frames
                                              // are also indexed



typedef struct _avisuperindex_entry {
    unsigned long long qwOffset;           // absolute file offset
    unsigned long dwSize;                  // size of index chunk at this offset
    unsigned long dwDuration;              // time span in stream ticks
} avisuperindex_entry;

typedef struct _avistdindex_entry {
    unsigned long dwOffset;                // qwBaseOffset + this is absolute file offset
    unsigned long dwSize;                  // bit 31 is set if this is NOT a keyframe
} avistdindex_entry;


// Base Index Form 'indx'
typedef struct _avisuperindex_chunk {
    char           fcc[4];
    unsigned long  dwSize;                 // size of this chunk
    unsigned short wLongsPerEntry;         // size of each entry in aIndex array (must be 8 for us)
    unsigned char  bIndexSubType;          // future use. must be 0
    unsigned char  bIndexType;             // one of AVI_INDEX_* codes
    unsigned long  nEntriesInUse;          // index of first unused member in aIndex array
    char           dwChunkId[4];           // fcc of what is indexed
    unsigned long  dwReserved[3];          // meaning differs for each index type/subtype.
                                           // 0 if unused
    avisuperindex_entry *aIndex;
} avisuperindex_chunk;
    
// Standard index 
typedef struct _avistdindex_chunk {
    char           fcc[4];                 // ix##
    unsigned long  dwSize;                 // size of this chunk
    unsigned short wLongsPerEntry;         // must be sizeof(aIndex[0])/sizeof(DWORD)
    unsigned char  bIndexSubType;          // must be 0
    unsigned char  bIndexType;             // must be AVI_INDEX_OF_CHUNKS
    unsigned long  nEntriesInUse;          //
    char           dwChunkId[4];           // '##dc' or '##db' or '##wb' etc..
    unsigned long long qwBaseOffset;       // all dwOffsets in aIndex array are relative to this
    unsigned long  dwReserved3;            // must be 0
    avistdindex_entry *aIndex;
} avistdindex_chunk;
    



typedef struct track_s
{

    long   a_fmt;             /* Audio format, see #defines below */
    long   a_chans;           /* Audio channels, 0 for no audio */
    long   a_rate;            /* Rate in Hz */
    long   a_bits;            /* bits per audio sample */
    long   mp3rate;           /* mp3 bitrate kbs*/
    long   a_vbr;             /* 0 == no Variable BitRate */

    long   audio_strn;        /* Audio stream number */
    off_t  audio_bytes;       /* Total number of bytes of audio data */
    long   audio_chunks;      /* Chunks of audio data in the file */

    char   audio_tag[4];      /* Tag of audio data */
    long   audio_posc;        /* Audio position: chunk */
    long   audio_posb;        /* Audio position: byte within chunk */
 
    off_t  a_codech_off;       /* absolut offset of audio codec information */ 
    off_t  a_codecf_off;       /* absolut offset of audio codec information */ 

    audio_index_entry *audio_index;
    avisuperindex_chunk *audio_superindex;

} track_t;

typedef struct
{
  
  long   fdes;              /* File descriptor of AVI file */
  long   mode;              /* 0 for reading, 1 for writing */
  
  long   width;             /* Width  of a video frame */
  long   height;            /* Height of a video frame */
  double fps;               /* Frames per second */
  char   compressor[8];     /* Type of compressor, 4 bytes + padding for 0 byte */
  char   compressor2[8];     /* Type of compressor, 4 bytes + padding for 0 byte */
  long   video_strn;        /* Video stream number */
  long   video_frames;      /* Number of video frames */
  char   video_tag[4];      /* Tag of video data */
  long   video_pos;         /* Number of next frame to be read
			       (if index present) */
  
  unsigned long max_len;    /* maximum video chunk present */
  
  track_t track[AVI_MAX_TRACKS];  // up to AVI_MAX_TRACKS audio tracks supported
  
  off_t  pos;               /* position in file */
  long   n_idx;             /* number of index entries actually filled */
  long   max_idx;           /* number of index entries actually allocated */
  
  off_t  v_codech_off;      /* absolut offset of video codec (strh) info */ 
  off_t  v_codecf_off;      /* absolut offset of video codec (strf) info */ 
  
  unsigned char (*idx)[16]; /* index entries (AVI idx1 tag) */

  video_index_entry *video_index;
  avisuperindex_chunk *video_superindex;  /* index of indices */
  int is_opendml;           /* set to 1 if this is an odml file with multiple index chunks */
  
  off_t  last_pos;          /* Position of last frame written */
  unsigned long last_len;          /* Length of last frame written */
  int must_use_index;              /* Flag if frames are duplicated */
  off_t  movi_start;
  
  int anum;            // total number of audio tracks 
  int aptr;            // current audio working track 
  int comment_fd;      // Read avi header comments from this fd
  char *index_file;    // read the avi index from this file
  
} avi_t;

#define AVI_MODE_WRITE  0
#define AVI_MODE_READ   1

/* The error codes delivered by avi_open_input_file */

#define AVI_ERR_SIZELIM      1     /* The write of the data would exceed
                                      the maximum size of the AVI file.
                                      This is more a warning than an error
                                      since the file may be closed safely */

#define AVI_ERR_OPEN         2     /* Error opening the AVI file - wrong path
                                      name or file nor readable/writable */

#define AVI_ERR_READ         3     /* Error reading from AVI File */

#define AVI_ERR_WRITE        4     /* Error writing to AVI File,
                                      disk full ??? */

#define AVI_ERR_WRITE_INDEX  5     /* Could not write index to AVI file
                                      during close, file may still be
                                      usable */

#define AVI_ERR_CLOSE        6     /* Could not write header to AVI file
                                      or not truncate the file during close,
                                      file is most probably corrupted */

#define AVI_ERR_NOT_PERM     7     /* Operation not permitted:
                                      trying to read from a file open
                                      for writing or vice versa */

#define AVI_ERR_NO_MEM       8     /* malloc failed */

#define AVI_ERR_NO_AVI       9     /* Not an AVI file */

#define AVI_ERR_NO_HDRL     10     /* AVI file has no has no header list,
                                      corrupted ??? */

#define AVI_ERR_NO_MOVI     11     /* AVI file has no has no MOVI list,
                                      corrupted ??? */

#define AVI_ERR_NO_VIDS     12     /* AVI file contains no video data */

#define AVI_ERR_NO_IDX      13     /* The file has been opened with
                                      getIndex==0, but an operation has been
                                      performed that needs an index */

/* Possible Audio formats */

#ifndef WAVE_FORMAT_PCM
#define WAVE_FORMAT_UNKNOWN             (0x0000)
#define WAVE_FORMAT_PCM                 (0x0001)
#define WAVE_FORMAT_ADPCM               (0x0002)
#define WAVE_FORMAT_IBM_CVSD            (0x0005)
#define WAVE_FORMAT_ALAW                (0x0006)
#define WAVE_FORMAT_MULAW               (0x0007)
#define WAVE_FORMAT_OKI_ADPCM           (0x0010)
#define WAVE_FORMAT_DVI_ADPCM           (0x0011)
#define WAVE_FORMAT_DIGISTD             (0x0015)
#define WAVE_FORMAT_DIGIFIX             (0x0016)
#define WAVE_FORMAT_YAMAHA_ADPCM        (0x0020)
#define WAVE_FORMAT_DSP_TRUESPEECH      (0x0022)
#define WAVE_FORMAT_GSM610              (0x0031)
#define IBM_FORMAT_MULAW                (0x0101)
#define IBM_FORMAT_ALAW                 (0x0102)
#define IBM_FORMAT_ADPCM                (0x0103)
#endif

struct riff_struct 
{
  unsigned char id[4];   /* RIFF */
  unsigned long len;
  unsigned char wave_id[4]; /* WAVE */
};


struct chunk_struct 
{
	unsigned char id[4];
	unsigned long len;
};

struct common_struct 
{
	unsigned short wFormatTag;
	unsigned short wChannels;
	unsigned long dwSamplesPerSec;
	unsigned long dwAvgBytesPerSec;
	unsigned short wBlockAlign;
	unsigned short wBitsPerSample;  /* Only for PCM */
};

struct wave_header 
{
	struct riff_struct   riff;
	struct chunk_struct  format;
	struct common_struct common;
	struct chunk_struct  data;
};

struct AVIStreamHeader {
  long  fccType;
  long  fccHandler;
  long  dwFlags;
  long  dwPriority;
  long  dwInitialFrames;
  long  dwScale;
  long  dwRate;
  long  dwStart;
  long  dwLength;
  long  dwSuggestedBufferSize;
  long  dwQuality;
  long  dwSampleSize;
};

#endif /* LIBRARIES_AVILIB_H */
