/* $VER: utility.h 39.2 (18.9.1992) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/libraries'
{#include <utility/utility.h>}
NATIVE {UTILITY_UTILITY_H} CONST

NATIVE {UTILITYNAME} CONST
#define UTILITYNAME utilityname
STATIC utilityname = 'utility.library'


NATIVE {UtilityBase} OBJECT utilitybase
    {ub_LibNode}	lib	:lib
    {ub_Language}	language	:UBYTE
    {ub_Reserved}	reserved	:UBYTE
ENDOBJECT
