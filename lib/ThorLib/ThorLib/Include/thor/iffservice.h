/*************************************************************************
 ** THOR.lib                                                            **
 ** Version 1.00  6th December 1995     © 1995 THOR-Software inc        **
 **                                                                     **
 **---------------------------------------------------------------------**
 **                                                                     **
 ** Serviceprocedures for iff & ILBM                                    **
 **                                                                     **
 *************************************************************************/

#ifndef IFFSERVICE_H
#define IFFSERVICE_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef INTUITION_SCREENS_H
#include <intuition/screens.h>
#endif

#ifndef IFF_IFFPARSE_H
#include <libraries/iffparse.h>
#endif

/* Get standard name of iff-error, see defines below */
void __regargs GetIFFError(LONG error,char *out);

/* Setup iff as stream for reading or writing via ThorIO */
struct IFFHandle __regargs *SetupIFFAs(char *filename,BOOL write,LONG *error);
/* Close iff stream */
void __regargs CleanupIFF(struct IFFHandle *iff);

/* Correct invalid CAMG of V33 programs */
void __regargs Correct_CAMG(register ULONG *modeid,UWORD width,UWORD height,UWORD depth);

/* private iff-errorcodes */
#define IFFERR_OPEN     -20             /*error on open */
#define IFFERR_DONE     -21             /*error already printed */
#define IFFERR_NEEDED   -22             /*needed chunk missing */
#define IFFERR_NOHEADER -22             /* same difference... */
#define IFFERR_NOPOSITION -23           /* no position chunk available */
#define IFFERR_NODISPLAY -24            /* display not available */

/* get 8 bit color of 4 bits */
#define FULLC(a)        ((FIXED)(((a)<<8)|(a)))
/* get 16 bit THOR-color of 4 bits */
#define FULLF(a)        ((FIXED)((UWORD)(a)*(UWORD)(0x1111)))

/* standard chunk IDs */
#define FORM_ID         MAKE_ID('F','O','R','M')
#define ILBM_ID         MAKE_ID('I','L','B','M')
#define BMHD_ID         MAKE_ID('B','M','H','D')
#define CAMG_ID         MAKE_ID('C','A','M','G')
#define CMAP_ID         MAKE_ID('C','M','A','P')
#define BODY_ID         MAKE_ID('B','O','D','Y')
#define CRNG_ID         MAKE_ID('C','R','N','G')
#define DRNG_ID         MAKE_ID('D','R','N','G')


/* 2nd Cache mechanism */ 
/* Prepare buffer for I/O */
void __regargs PrepBuf(void);

/* Read from buffer */
LONG __regargs ReadBuf(struct IFFHandle *iff,register char *dest,register ULONG len);

/* Write buffer */
LONG __regargs WriteBuf(struct IFFHandle *iff,register char *source,register ULONG len);

/* Flush buffer */
LONG __regargs FlushBuf(struct IFFHandle *iff);

/* Stucture for Reading/Writing bodies, fill out before reading & writings
   ILBMs */
struct BodyBM {
        ULONG   bb_Height;              /* Height of bitmap destination */
        ULONG   bb_FileHeight;          /* Height of file */
        ULONG   bb_Modulo;
        ULONG   bb_BytesPerRow;         /* need not to be the same */
        ULONG   bb_FileBytesPerRow;     /* bytes per row in the file */
        ULONG   bb_Depth;               /* Destination Depth: Map down to this depth */
        ULONG   bb_FileDepth;           /* Source File Depth while loading */
        LONG    bb_PutMaskTo;           /* if >=0: Put last Plane of file into this plane */
        UBYTE   **bb_PlaneArray;        /* pointer to array containing PlanePtrs, usually part of the bitmap */
};

/* Bitmap-Writers */
LONG __regargs WriteBodyCompressed(struct IFFHandle *iff,struct BodyBM *bb);
LONG __regargs WriteBodyUnCompressed(struct IFFHandle *iff,struct BodyBM *bb);

/* Bitmap-Readers */
LONG __regargs ReadBodyCompressed(struct IFFHandle *iff,struct BodyBM *bb);
LONG __regargs ReadBodyUnCompressed(struct IFFHandle *iff,struct BodyBM *bb);

/* Save the CMAP and CAMG of a screen */
LONG __regargs SaveCMAP(struct IFFHandle *iff,struct Screen *scr);
LONG __regargs SaveScreenCAMG(struct IFFHandle *iff,struct Screen *scr);

/* Shortcuts for reading & writing blocks, define the variable "error" as well */
#define WriteBlock(source,length)       {                       \
        if ((error=WriteChunkBytes(iff,source,(length)))!=(length))     \
                        return (error<0)?error:IFFERR_WRITE;    \
                }

/* Push a beginning of a block */
#define Push(type,size) {                               \
        if (error=PushChunk(iff,0,type,size))           \
                return error;                           \
        }

/* Read a block */
#define ReadBlock(dest,length)          {                       \
        if ((error=ReadChunkBytes(iff,dest,length))!=length)    \
                        return (error<0)?error:IFFERR_EOF;      \
                }

/*****************************************************************
 ** Definitions, standard chunks...                             **
 *****************************************************************/

/* BMHD-Chunk */
typedef UBYTE Masking;          /* Choice of masking technique */

#define mskNone         0
#define mskHasMask      1
#define mskHasTransparentColor  2
#define mskLasso        3

typedef UBYTE Compression;      /* Choice of compression algorithm
        applied to the rows of all source and mask planes. "cmpByteRun1"
        is the byte run encoding described in ARCRM-Appendix C. Do not
        compress across rows! */

#define cmpNone         0
#define cmpByteRun1     1

/* Bitmap - header */
typedef struct {
        UWORD   w,h;            /* Raster width & height in pixels */
        WORD    x,y;            /* pixel position for this image */
        UBYTE   nPlanes;        /* # of source bitplanes (w/o mask) */
        Masking masking;
        Compression compression;
        UBYTE   pad1;
        UWORD   transparentColor;       /* transparent "color number" (sort of) */
        UBYTE   xAspect,yAspect;        /* pixel aspect, a ratio width:height */
        WORD    pageWidth,pageHeight;   /* source "page" size in pixels */
} BitmapHeader;

/* CMAP-Chunk */

typedef struct {
        UBYTE red,green,blue;           /* color intensities 0...255 */
} ColorRegister;                        /* take n of these */

/* CRNG-Chunk for V3 DPaint color cycling */
typedef struct {
        WORD pad1;                      /* reserved for future use, store 0 here */
        WORD rate;                      /* color cycle rate 16384=60/sec */
        WORD flags;                     /* see below */
        UBYTE low,high;                 /* lower and upper color registers selected */
} CRange;

#define RNG_ACTIVE      1
#define RNG_REVERSE     2


/* DRNG-Chunk for V4 DPaint color cycling */
typedef struct {
        UBYTE min;              /* min cell value */
        UBYTE max;              /* max cell value */
        SHORT rate;             /* color cycling rate, 16384=60 steps/second */
        SHORT flags;            /* 1=RNG_ACTIVE,4=RNG_DP_RESERVED */
        UBYTE ntrue;            /* number of DColor structs to follow */
        UBYTE nregs;            /* number of DIndex structs to follow */
} DRange;

typedef struct {UBYTE cell;UBYTE r,g,b;} DColor;        /* true color cell */
typedef struct {UBYTE cell;UBYTE index;} DIndex;        /* color register cell */

#endif
