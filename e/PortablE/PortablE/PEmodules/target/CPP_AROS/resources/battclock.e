/* $Id: battclock.h 14582 2002-05-15 15:59:21Z falemagn $ */
OPT NATIVE, PREPROCESS
{#include <resources/battclock.h>}
NATIVE {RESOURCES_BATTCLOCK_H} CONST

NATIVE {BATTCLOCKNAME}   CONST
#define BATTCLOCKNAME battclockname
STATIC battclockname   = 'battclock.resource'
