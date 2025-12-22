/*
 * dlib/ums/UMSLog.c
 *
 * Varargs stub for ums.library/UMSVLog()
 *
 */

#include <clib/ums_protos.h>
#include <pragmas/ums_pragmas.h>
extern struct Library *UMSBase;

void UMSLog(UMSAccount Account, LONG Level, STRPTR Format, ...)
{
 UMSVLog(Account, Level, Format, ((ULONG *) &Format) + 1);
}
