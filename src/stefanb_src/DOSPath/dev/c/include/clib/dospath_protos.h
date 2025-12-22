#ifndef CLIB_DOSPATH_PROTOS_H
#define CLIB_DOSPATH_PROTOS_H

/*
 * dospath_protos.h  V1.0
 *
 * Prototypes for dospath.library functions
 *
 * (c) 1996 Stefan Becker
 */

#ifndef LIBRARIES_DOSPATH_H
#include <libraries/dospath.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef WORKBENCH_STARTUP_H
#include <workbench/startup.h>
#endif

/* Library functions */
void                  FreePathList         (struct PathListEntry *);
struct PathListEntry *CopyPathList         (struct PathListEntry *,
                                            struct PathListEntry **);
struct PathListEntry *BuildPathListTagList (struct PathListEntry **,
                                            struct TagItem *);
struct PathListEntry *BuildPathListTags    (struct PathListEntry **, Tag, ...);
struct PathListEntry *CopyWorkbenchPathList(struct WBStartup *,
                                            struct PathListEntry **);
BPTR                  FindFileInPathList   (struct PathListEntry **,
                                            const char *);
struct PathListEntry *GetProcessPathList   (struct Process *);
struct PathListEntry *RemoveFromPathList   (struct PathListEntry *, BPTR);
struct PathListEntry *SetProcessPathList   (struct Process *,
                                            struct PathListEntry *);

#endif /* CLIB_DOSPATH_PROTOS_H */
