/*
 * dlib/ums/UMSSearchTags.c
 *
 * Varargs stub for ums.library/UMSSearch()
 *
 */

#include <clib/ums_protos.h>
#include <pragmas/ums_pragmas.h>
extern struct Library *UMSBase;

UMSMsgNum UMSSearchTags(UMSAccount Account, Tag Tag1, ...)
{
 return(UMSSearch(Account, (struct TagItem *) &Tag1));
}
