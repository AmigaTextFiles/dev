/*
 * dlib/ums/UMSWriteConfigTags.c
 *
 * Varargs stub for ums.library/UMSWriteConfig()
 *
 */

#include <clib/ums_protos.h>
#include <pragmas/ums_pragmas.h>
extern struct Library *UMSBase;

BOOL UMSWriteConfigTags(UMSAccount Account, Tag Tag1, ...)
{
 return(UMSWriteConfig(Account, (struct TagItem *) &Tag1));
}
