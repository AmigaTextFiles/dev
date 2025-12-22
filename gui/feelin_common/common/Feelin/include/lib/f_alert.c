#define NO_TAG_CALL

#include <stdarg.h>
#include <proto/feelin.h>
#include <feelin/machine.h>

void F_Alert(STRPTR Title,STRPTR Body,...)
{
    va_list msg;
    va_start(msg,Body);
    
    IFEELIN F_AlertA(Title,Body,(int32 *) msg);
}

