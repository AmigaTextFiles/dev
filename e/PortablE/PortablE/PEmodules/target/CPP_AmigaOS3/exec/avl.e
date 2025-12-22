/* $VER: avl.h 45.4 (27.2.2001) */
OPT NATIVE
MODULE 'target/exec/types'
{#include <exec/avl.h>}
NATIVE {EXEC_AVL_H} CONST

TYPE AVLKey IS NATIVE {AVLKey} PTR


/* Don't even think about the contents of this structure. Just embed it
 * and reference it
 */
NATIVE {AVLNode} OBJECT avlnode
	{reserved}	reserved[4]	:ARRAY OF ULONG
ENDOBJECT

/* Note that this is really a totally abstract 32 bit value */
NATIVE {AVLKey} CONST

/* Callback functions for the AVL tree handling. They will have to return
 * strcmp like results for the given arguments (<0/0/>0).
 * You can compare to nodes or a node with a key.
 */
NATIVE {AVLNODECOMP} CONST
NATIVE {AVLKEYCOMP} CONST
