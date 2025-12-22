#define NO_TAG_CALL

#include <stdarg.h>
#include <proto/feelin.h>
#include <feelin/machine.h>

uint32 F_ClassDo(FClass *Class,FObject Obj,uint32 Method,...)
{
    va_list msg;
    va_start(msg,Method);
    
    return IFEELIN F_ClassDoA(Class,Obj,Method,(APTR) msg);
}

