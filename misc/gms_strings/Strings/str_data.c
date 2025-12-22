/* Module Header
** -------------
** This object file must be linked right at the start of the output file.
** It is very important that the "struct ModHeader" part stays at the top,
** or the module will not work.
*/

#define DPKNOBASE 1

#include <proto/dpkernel.h>

#define STRMOD_VERSION  1
#define STRMOD_REVISION 0

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
  JumpTableV1,      /* Pointer to function list */
  CPU_68000,        /* The type of CPU that this module is compiled for */
  STRMOD_VERSION,   /* Version of this module */
  STRMOD_REVISION,  /* Revision of this module */
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

struct ModPublic *Public;
struct DPKBase   *DPKBase;
struct GVBase    *GVBase;
struct STRBase   *STRBase;

