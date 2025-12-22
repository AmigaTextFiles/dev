/*
 * change.c  V3.1
 *
 * VarArgs stub for ChangeTMObjectTagList
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

#include <clib/toolmanager_protos.h>
#include <pragmas/toolmanager_pragmas.h>
extern struct Library *ToolManagerBase;

BOOL ChangeTMObjectTags(void *handle, char *obj, ULONG tag1, ...)
{
 return(ChangeTMObjectTagList(handle, obj, (struct TagItem *) &tag1));
}
