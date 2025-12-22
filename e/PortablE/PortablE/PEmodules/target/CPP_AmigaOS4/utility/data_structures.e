/* $Id: data_structures.h,v 1.10 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types'
{#include <utility/data_structures.h>}
NATIVE {UTILITY_DATA_STRUCTURES_H} CONST

/* Lists with probabilistic balancing */
NATIVE {SkipList} OBJECT skiplist
    {sl_Error}	error	:VALUE /* If an insertion fails, here is why */
ENDOBJECT

NATIVE {SkipNode} OBJECT skipnode
    {sn_Reserved}	reserved	:APTR
    {sn_Key}	key	:APTR      /* Unique key associated with this node */
ENDOBJECT

/*****************************************************************************/

/* Self-organizing binary trees */
NATIVE {SplayTree} OBJECT splaytree
    {st_Error}	error	:VALUE /* If an insertion fails, here is why */
ENDOBJECT

NATIVE {SplayNode} OBJECT splaynode
    {sn_UserData}	userdata	:APTR /* Points to user data area for this node */
ENDOBJECT

/*****************************************************************************/

/* Error codes that may be returned by the insertion functions. */
NATIVE {enErrorCodes} DEF
NATIVE {INSERTNODE_OUT_OF_MEMORY} CONST INSERTNODE_OUT_OF_MEMORY = 1 /* Not enough memory */
NATIVE {INSERTNODE_DUPLICATE_KEY} CONST INSERTNODE_DUPLICATE_KEY = 2 /* Key is not unique */
NATIVE {INSERTNODE_TOO_SHORT}     CONST INSERTNODE_TOO_SHORT     = 3 /* Node size must be at least
                                     as large as
                                     sizeof(struct SkipNode). */
