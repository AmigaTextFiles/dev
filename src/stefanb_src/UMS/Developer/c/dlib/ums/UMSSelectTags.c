/*
 * dlib/ums/UMSSelectTags.c
 *
 * Varargs stub for ums.library/UMSSelect()
 *
 */

#include <clib/ums_protos.h>
#include <pragmas/ums_pragmas.h>
extern struct Library *UMSBase;

UMSMsgNum UMSSelectTags(UMSAccount Account, Tag Tag1, ...)
{
 return(UMSSelect(Account, (struct TagItem *) &Tag1));
}
