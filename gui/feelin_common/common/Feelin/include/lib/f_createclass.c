#define NO_TAG_CALL

#include <stdarg.h>
#include <proto/feelin.h>
#include <feelin/machine.h>

FClass * F_CreateClass(STRPTR Name,...)
{
    va_list msg;
    va_start(msg,Name);
    
    return IFEELIN F_CreateClassA(Name,(struct TagItem *) msg);
}

