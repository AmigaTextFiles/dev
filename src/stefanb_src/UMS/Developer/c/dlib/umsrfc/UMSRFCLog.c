/*
 * umsrfclog.c
 *
 * Varargs stub for umsrfc.library/UMSRFCVLog()
 *
 */

#include <clib/umsrfc_protos.h>
#include <pragmas/umsrfc_pragmas.h>
extern struct Library *UMSRFCBase;

void UMSRFCLog(struct UMSRFCData *urd, const char *format, ...)
{
 UMSRFCVLog(urd, format, ((ULONG *) &format) + 1);
}
