/*
 * create.c  V2.1
 *
 * VarArgs stub for CreateTMObjectTagList
 *
 * (c) 1990-1993 Stefan Becker
 */

#include <clib/toolmanager_protos.h>
extern struct Library *ToolManagerBase;
#include <pragmas/toolmanager_pragmas.h>

BOOL CreateTMObjectTags(void *tmhandle, char *object, ULONG type,
                        ULONG tag1, ...)
{
 return(CreateTMObjectTagList(tmhandle,object,type,(struct TagItem *) &tag1));
}
