/*
 * create.c  V3.1
 *
 * VarArgs stub for CreateTMObjectTagList
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

BOOL CreateTMObjectTags(void *handle, char *obj, ULONG type, ULONG tag1, ...)
{
 return(CreateTMObjectTagList(handle, obj, type, (struct TagItem *) &tag1));
}
