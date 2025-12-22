/*
 * dlib/ums/WriteUMSMsgTags.c
 *
 * Varargs stub for ums.library/WriteUMSMsg()
 *
 */

#include <clib/ums_protos.h>
#include <pragmas/ums_pragmas.h>
extern struct Library *UMSBase;

UMSMsgNum UMSWriteMsgTags(UMSAccount Account, Tag Tag1, ...)
{
 return(UMSWriteMsg(Account, (struct TagItem *) &Tag1));
}
