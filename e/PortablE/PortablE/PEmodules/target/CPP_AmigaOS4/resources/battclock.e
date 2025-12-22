/* $Id: battclock.h,v 1.10 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS
{#include <resources/battclock.h>}
NATIVE {RESOURCES_BATTCLOCK_H} CONST

NATIVE {BATTCLOCKNAME} CONST
#define BATTCLOCKNAME battclockname
STATIC battclockname = 'battclock.resource'
