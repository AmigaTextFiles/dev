#define NO_TAG_CALL

#include <stdarg.h>
#include <proto/feelin.h>
#include <feelin/machine.h>

STRPTR F_StrFmt(STRPTR Buf,STRPTR Fmt,...)
{
    va_list msg;
    va_start(msg,Fmt);

    return IFEELIN F_StrFmtA(Buf,Fmt,(int32 *) msg);
}

