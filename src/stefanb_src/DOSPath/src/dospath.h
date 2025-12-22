/*
 * dospath.h  V1.0
 *
 * Main include file
 *
 * (c) 1996 Stefan Becker
 */

/* OS include files */
#include <exec/libraries.h>
#include <exec/memory.h>
#include <exec/resident.h>
#include <exec/semaphores.h>
#include <libraries/dospath.h>
#include <workbench/startup.h>

/* OS function prototypes */
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/utility_protos.h>

/* OS function inline calls */
#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/utility_pragmas.h>

/* Revision number */
#define DOSPATH_REVISION 0

/* Library base */
struct DOSPathBase {
 struct Library  dpb_Library;
 UWORD           dpb_Pad;
 struct Library *dpb_DOSBase;
 struct Library *dpb_UtilityBase;
};

/* Global data */
extern struct Library *SysBase;

/* Function prototypes */
__geta4 struct PathListEntry *BuildPathListTagList(
                                                 __A0 struct PathListEntry **,
                                                 __A1 struct TagItem *,
                                                 __A6 struct DOSPathBase *);
__geta4 struct PathListEntry *CopyPathList      (__A0 struct PathListEntry *,
                                                 __A1 struct PathListEntry **,
                                                 __A6 struct DOSPathBase *);
__geta4 struct PathListEntry *CopyWorkbenchPathList(__A0 struct WBStartup *,
                                                 __A1 struct PathListEntry **,
                                                 __A6 struct DOSPathBase *);
__geta4 void                  FreePathList      (__A0 struct PathListEntry *,
                                                 __A6 struct DOSPathBase *);
__geta4 BPTR                  FindFileInPathList(__A0 struct PathListEntry **,
                                                 __A1 const char *,
                                                 __A6 struct DOSPathBase *);
__geta4 struct PathListEntry *GetProcessPathList(__A0 struct Process *);
__geta4 struct PathListEntry *RemoveFromPathList(__A0 struct PathListEntry *,
                                                 __A1 BTPR,
                                                 __A6 struct DOSPathBase *);
__geta4 struct PathListEntry *SetProcessPathList(__A0 struct Process *,
                                                 __A1 struct PathListEntry *);

/* Debugging */
#ifdef DEBUG
void kprintf(char *, ...);
#define DEBUGLOG(x) x
#else
#define DEBUGLOG(X)
#endif
