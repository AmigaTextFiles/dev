/* $Id: name.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/types'
{#include <utility/name.h>}
NATIVE {UTILITY_NAME_H} CONST

NATIVE {NamedObject} OBJECT namedobject
    {no_Object}	object	:APTR
ENDOBJECT

/* AllocNamedObject() Tags */
NATIVE {ANO_NameSpace} CONST ANO_NAMESPACE = 4000
NATIVE {ANO_UserSpace} CONST ANO_USERSPACE = 4001
NATIVE {ANO_Priority}  CONST ANO_PRIORITY  = 4002
NATIVE {ANO_Flags}     CONST ANO_FLAGS     = 4003 /* see below */

/* ANO_Flags */
NATIVE {NSB_NODUPS}      CONST NSB_NODUPS      = 0
NATIVE {NSF_NODUPS} CONST NSF_NODUPS = $1
NATIVE {NSB_CASE}        CONST NSB_CASE        = 1
NATIVE {NSF_CASE}   CONST NSF_CASE   = $2
