/*
 * change.c  V2.1
 *
 * VarArgs stub for ChangeTMObjectTagList
 *
 * (c) 1990-1993 Stefan Becker
 */

#include <clib/toolmanager_protos.h>
extern struct Library *ToolManagerBase;
#include <pragmas/toolmanager_pragmas.h>

BOOL ChangeTMObjectTags(void *tmhandle, char *object, ULONG tag1, ...)
{
 return(ChangeTMObjectTagList(tmhandle,object,(struct TagItem *) &tag1));
}
