/*
 * dlib/ums/UMSReadMsgTags.c
 *
 * Varargs stub for ums.library/UMSReadMsg()
 *
 */

#include <clib/ums_protos.h>
#include <pragmas/ums_pragmas.h>
extern struct Library *UMSBase;

BOOL UMSReadMsgTags(UMSAccount Account, Tag Tag1, ...)
{
 return(UMSReadMsg(Account, (struct TagItem *) &Tag1));
}
