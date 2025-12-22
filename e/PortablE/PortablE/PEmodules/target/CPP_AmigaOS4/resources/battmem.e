/* $Id: battmem.h,v 1.10 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS
{#include <resources/battmem.h>}
NATIVE {RESOURCES_BATTMEM_H} CONST

NATIVE {BATTMEMNAME} CONST
#define BATTMEMNAME battmemname
STATIC battmemname = 'battmem.resource'
