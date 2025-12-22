/*
 * dlib/ums/UMSMatchConfigTags.c
 *
 * Varargs stub for ums.library/UMSMatchConfig()
 *
 */

#include <clib/ums_protos.h>
#include <pragmas/ums_pragmas.h>
extern struct Library *UMSBase;

BOOL UMSMatchConfigTags(UMSAccount Account, Tag Tag1, ...)
{
 return(UMSMatchConfig(Account, (struct TagItem *) &Tag1));
}
