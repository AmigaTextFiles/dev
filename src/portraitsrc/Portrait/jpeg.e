OPT MODULE
OPT EXPORT

MODULE 'utility/tagitem'

OBJECT jpegdechandle
  ptr:LONG
ENDOBJECT
OBJECT jpegcomhandle
  ptr:LONG
ENDOBJECT

ENUM JPCS_UNKNOWN,JPCS_GRAYSCALE,JPCS_RGB,JPCS_YCBCR,JPCS_CMYK,JPCS_YCCK

CONST JPG_TB=TAG_USER+$80000

/* Jpeg tags */
CONST JPG_SRCMEMSTREAM=JPG_TB + 1 /* Pointer to stream data in memory (UBYTE *) */
CONST JPG_SRCMEMSTREAMSIZE=JPG_TB + 2 /* Length in bytes of data stream (ULONG) */
CONST JPG_DESTMEMSTREAM=JPG_TB + 3 /* Pointer to a pointer to created data in memory (UBYTE **) */
CONST JPG_DESTMEMSTREAMSIZE=JPG_TB + 4 /* Pointer to take size of created data (ULONG *) */
CONST JPG_SRCFILE=JPG_TB + 5 /* Pointer to an open file (BPTR) */
CONST JPG_DESTFILE=JPG_TB + 6 /* Pointer to an open file (BPTR) */
CONST JPG_DESTRGBBUFFER=JPG_TB + 7 /* Pointer to a memory block (UBYTE *) */
CONST JPG_DECOMPRESSHOOK=JPG_TB + 8 /* Pointer to a function to store scan lines */
CONST JPG_DECOMPRESSUSERDATA=JPG_TB + 9 /* Pointer to user data (void *) */
CONST JPG_SRCRGBBUFFER=JPG_TB + 12 /* Pointer to a memory block (UBYTE *) */
CONST JPG_COMPRESSHOOK=JPG_TB + 13 /* POINTER TO A FUNCTION TO STORE SCAN LINES */
CONST JPG_COMPRESSUSERDATA=JPG_TB + 14 /* Pointer to user data (void *) */

/* Jpeg tags affecting image size and quality */
CONST JPG_SCALENUM=JPG_TB + 10 /* Numerator for scaling (ULONG) */
CONST JPG_SCALEDENOM=JPG_TB + 11 /* Denomenator for scaling (ULONG) */
CONST JPG_WIDTH=JPG_TB + 20 /* Width of image in pixels (ULONG *) */
CONST JPG_HEIGHT=JPG_TB + 21 /* Height of image in pixels (ULONG *) */
CONST JPG_BYTESPERPIXEL=JPG_TB + 22 /* Number of bytes per image pixel (ULONG *) */
CONST JPG_ROWSIZE=JPG_TB + 23 /* SIZE OF ONE ROW (ULONG *) [GET ONLY] */
CONST JPG_COLOURSPACE=JPG_TB + 24 /* Type of image data (UBYTE *) */
CONST JPG_QUALITY=JPG_TB + 25 /* Save quality of jpeg (1-100) () */
CONST JPG_SMOOTHING=JPG_TB + 26 /* Save smoothing amount (0-100) () */

/*========================================================================*/
/* Defined error return codes */
CONST JPGERR_NONE=0 /* No error */
CONST JPGERR_NOMEMORY=1 /* Insufficient memory */
CONST JPGERR_NOHANDLE=2 /* No jpeg handle supplied */
CONST JPGERR_CREATEOBJECT=3 /* Failed to create JPEG object */
CONST JPGERR_DECOMPFAILURE=4 /* Failed to decompress */
CONST JPGERR_NOSRCSTREAM=5 /* No source stream to decode */
CONST JPGERR_NODESTBUFFE=6 /* No destination rgb buffer/hook */
CONST JPGERR_DECOMPABORTED=7 /* Decompression aborted by user hook */
CONST JPGERR_NODESTSTREAM=8 /* No destination stream pointers */
CONST JPGERR_COMPFAILURE=9 /* Failed to compress */
CONST JPGERR_COMPABORTED=10 /* Compression aborted by user hook */
CONST JPGERR_NOIMAGESIZE=11 /* No image size supplied */
CONST JPGERR_ALREADYDECOMP=12 /* Handle has already been decompressed */
CONST JPGERR_ALREADYCOMP=13 /* Handle has already been compressed */

