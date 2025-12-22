/* $Id: cia.h,v 1.10 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS
{#include <resources/cia.h>}
NATIVE {RESOURCES_CIA_H} CONST

NATIVE {CIAANAME} CONST
#define CIAANAME ciaaname
STATIC ciaaname = 'ciaa.resource'
NATIVE {CIABNAME} CONST
#define CIABNAME ciabname
STATIC ciabname = 'ciab.resource'
