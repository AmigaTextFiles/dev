/*
 * build.c  V1.0
 *
 * VarArgs stub for BuildPathListTagList
 *
 * (c) 1996 Stefan Becker
 */

#include <clib/dospath_protos.h>
extern struct Library *DOSPathBase;
#include <pragmas/dospath_pragmas.h>

struct PathListEntry *BuildPathListTags(struct PathListEntry **anchor,
                                        Tag tag1, ...)
{
 return(BuildPathListTagList(anchor, (struct TagItem *) &tag1));
}
