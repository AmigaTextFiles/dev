/* Module Header
** -------------
** This object file must be linked right at the start of the output file.
** It is very important that the "struct ModHeader" part stays at the top,
** or the module will not work.
*/

#define DPKNOBASE 1

#include <proto/dpkernel.h>

extern BYTE ModAuthor[];
extern BYTE ModDate[];
extern BYTE ModCopyright[];
extern BYTE ModName[];
extern struct Function JumpTableV1[];

extern LIBFUNC LONG (CMDInit)(mreg(__a0) struct Module *, mreg(__a1) APTR DPKBase,
                     mreg(__a2) struct GVBase *, mreg(__d0) LONG dpkVersion,
                     mreg(__d1) LONG dpkRevision);
extern LIBFUNC void (CMDClose)(mreg(__a0) struct Module *);
extern LIBFUNC LONG (CMDExpunge)(void);
extern LIBFUNC LONG (CMDOpen)(mreg(__a0) struct Module *);

struct ModHeader ModHeader = {
  MODULE_HEADER_V1, /* Version of this structure */
  CMDInit,          /* Init() */
  CMDClose,         /* Close() */
  CMDExpunge,       /* Expunge() */
  JMP_LVO,          /* Type of module table to be generated for our own use */
  0,                /* Reserved */
  ModAuthor,        /* Author that wrote the module */
  JumpTableV1,      /* Pointer to function list that we want to use */
  CPU_68000,        /* The type of CPU that this module is compiled for */
  SND_ModVersion,   /* Version of this module */
  SND_ModRevision,  /* Revision of this module */
  DPKVersion,       /* Required DPK Version */
  DPKRevision,      /* Required DPK Revision */
  CMDOpen,          /* Open() */
  0,                /* Reserved */
  ModCopyright,     /* Copyright and Company information */
  ModDate,          /* The date of module compilation */
  ModName,          /* The name of this module */
  JMP_LVO,          /* The dpkernel jump table that we want */
  0                 /* Reserved */
};

WORD Octaves[] = {
  68,72,76,80,85,90,95,101,107,113,120,127,135,143,151,160,170,
  180,190,202,214,226,240,254,269,285,302,320,339,360,381,404,
  428,453,480,508,538,570,604,640,678,720,762,808,856,906,960,1016,
  1076,1140,1208,1280,1356,1440,1524,1616,1712,1812,1920,2032,
  2152,2280,2416,2560,2712,2880,3048,3232,3424,3624,3840,4064,
  4304,4560,4832,5120,5424,5760,6096,6464,6848,7248,7680,8128,
  8608,9120,9664,10240,10848,11520,12192,12928,13696,14496,15360,16256,
  17216,18240,19328,20480,21696,23040,24384,25856,27392,28992,30720
};

/* This table is used to speed up the formula X*64/100 (Volume conversion) */

WORD Volumes[] = {
   0,1,1,2,3,3,4,4,5,6,           /*  00 - 09 */
   6,7,8,8,9,10,10,11,12,12,      /*  10 - 19 */
  13,13,14,15,15,16,17,17,18,19,  /*  20 - 29 */
  19,20,20,21,22,22,23,24,24,25,  /*  30 - 39 */
  26,26,27,28,28,29,29,30,31,31,  /*  40 - 49 */
  32,33,33,34,35,35,36,36,37,38,  /*  50 - 59 */
  38,39,40,40,41,42,42,43,44,44,  /*  60 - 69 */
  45,45,46,47,47,48,49,49,50,51,  /*  70 - 79 */
  51,52,52,53,54,54,55,56,56,57,  /*  80 - 89 */
  58,58,59,60,60,61,61,62,63,63,  /*  90 - 99 */
  64                              /* 100      */
};

APTR DPKBase;
struct GVBase    *GVBase;
struct SysObject *SndObject;
struct ModPublic *Public;
struct Module    *FileMod;
WORD SoundCount = NULL;
APTR SysBase;
APTR FILBase;
LONG SndAlloc;

