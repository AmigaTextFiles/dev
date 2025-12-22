#ifndef CLIB_TOOLMANAGER_PROTOS_H
#define CLIB_TOOLMANAGER_PROTOS_H

/*
 * toolmanager_protos.h  V2.1
 *
 * Prototypes for toolmanager.library functions
 *
 * (c) 1990-1993 Stefan Becker
 */

#ifndef LIBRARIES_TOOLMANAGER_H
#include <libraries/toolmanager.h>
#endif

/* library functions */
void *AllocTMHandle        (void);
BOOL  ChangeTMObjectTagList(void *, char *, struct TagItem *);
BOOL  CreateTMObjectTagList(void *, char *, ULONG,           struct TagItem *);
BOOL  DeleteTMObject       (void *, char *);
void  FreeTMHandle         (void *);
void  QuitToolManager      (void);

/* varargs stubs */
BOOL ChangeTMObjectTags(void *, char *, ULONG, ...);
BOOL CreateTMObjectTags(void *, char *, ULONG, ULONG, ...);

#endif /* CLIB_TOOLMANAGER_PROTOS_H */
