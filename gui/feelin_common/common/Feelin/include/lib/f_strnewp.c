#define NO_TAG_CALL

#include <stdarg.h>
#include <proto/feelin.h>
#include <feelin/machine.h>

STRPTR F_StrNewP(APTR Pool, uint32 *Length,STRPTR Fmt,...)
{
    va_list msg;
    va_start(msg,Fmt);

    return IFEELIN F_StrNewPA(Pool, Length, Fmt, (int32 *) msg);
}

