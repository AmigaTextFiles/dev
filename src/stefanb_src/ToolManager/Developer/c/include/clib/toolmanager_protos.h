#ifndef CLIB_TOOLMANAGER_PROTOS_H
#define CLIB_TOOLMANAGER_PROTOS_H

/*
 * clib/toolmanager_protos.h  V3.1
 *
 * Prototypes for toolmanager.library functions
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
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
