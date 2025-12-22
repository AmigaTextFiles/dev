/* $VER: name.h 39.5 (11.8.1993) */
OPT NATIVE
MODULE 'target/exec/types'
{#include <utility/name.h>}
NATIVE {UTILITY_NAME_H} CONST

/* The named object structure */
NATIVE {NamedObject} OBJECT namedobject
    {no_Object}	object	:APTR	/* Your pointer, for whatever you want */
ENDOBJECT

/* Tags for AllocNamedObject() */
NATIVE {ANO_NameSpace}	CONST ANO_NAMESPACE	= 4000	/* Tag to define namespace	*/
NATIVE {ANO_UserSpace}	CONST ANO_USERSPACE	= 4001	/* tag to define userspace	*/
NATIVE {ANO_Priority}	CONST ANO_PRIORITY	= 4002	/* tag to define priority	*/
NATIVE {ANO_Flags}	CONST ANO_FLAGS	= 4003	/* tag to define flags		*/

/* Flags for tag ANO_Flags */
NATIVE {NSB_NODUPS}	CONST NSB_NODUPS	= 0
NATIVE {NSB_CASE}	CONST NSB_CASE	= 1

NATIVE {NSF_NODUPS}	CONST NSF_NODUPS	= $1	/* Default allow duplicates */
NATIVE {NSF_CASE}	CONST NSF_CASE	= $2	/* Default to caseless... */
