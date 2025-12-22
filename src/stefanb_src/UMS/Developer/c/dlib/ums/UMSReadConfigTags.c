/*
 * dlib/ums/UMSReadConfigTags.c
 *
 * Varargs stub for ums.library/UMSReadConfig()
 *
 */

#include <clib/ums_protos.h>
#include <pragmas/ums_pragmas.h>
extern struct Library *UMSBase;

STRPTR UMSReadConfigTags(UMSAccount Account, Tag Tag1, ...)
{
 return(UMSReadConfig(Account, (struct TagItem *) &Tag1));
}
