#define NO_TAG_CALL

#include <stdarg.h>
#include <proto/feelin.h>
#include <feelin/machine.h>

#undef NO_TAG_CALL

uint32 F_SuperDo(FClass *Class,FObject Obj,uint32 Method,...)
{
    va_list msg;
    va_start(msg,Method);

    return IFEELIN F_SuperDoA(Class, Obj, Method, (APTR) msg);
}

