/* $Id: utility.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/libraries', 'target/dos/dos'
{#include <utility/utility.h>}
NATIVE {UTILITY_UTILITY_H} CONST

NATIVE {UTILITYNAME}	CONST
#define UTILITYNAME utilityname
STATIC utilityname	= 'utility.library'

NATIVE {UtilityBase} OBJECT utilitybase
    {ub_LibNode}	lib	:lib
    {ub_Language}	language	:UBYTE
    {ub_Reserved}	reserved	:UBYTE
ENDOBJECT
