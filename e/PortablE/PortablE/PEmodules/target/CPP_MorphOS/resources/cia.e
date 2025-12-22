/* $VER: cia.h 36.4 (9.1.1991) */
OPT NATIVE, PREPROCESS
{#include <resources/cia.h>}
NATIVE {DEVICES_CIA_H} CONST

NATIVE {CIAANAME} CONST
#define CIAANAME ciaaname
STATIC ciaaname = 'ciaa.resource'
NATIVE {CIABNAME} CONST
#define CIABNAME ciabname
STATIC ciabname = 'ciab.resource'
