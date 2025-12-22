/* $Id: utility.h,v 1.11 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/libraries', 'target/utility/data_structures', 'target/utility/date', 'target/utility/hooks', 'target/utility/message_digest', 'target/utility/name', 'target/utility/pack', 'target/utility/random', 'target/utility/tagitem'
{#include <utility/utility.h>}
NATIVE {UTILITY_UTILITY_H} CONST

NATIVE {UTILITYNAME} CONST
#define UTILITYNAME utilityname
STATIC utilityname = 'utility.library'

/****************************************************************************/

NATIVE {UtilityBase} OBJECT utilitybase
    {ub_LibNode}	lib	:lib
    {ub_Language}	language	:UBYTE /* Private, for lowlevel.library */
    {ub_Reserved}	reserved	:UBYTE
ENDOBJECT
