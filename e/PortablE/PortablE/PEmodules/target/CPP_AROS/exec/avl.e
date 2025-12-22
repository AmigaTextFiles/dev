OPT NATIVE
MODULE 'target/exec/types', 'target/aros/asmcall'
{#include <exec/avl.h>}
NATIVE {EXEC_AVL_H} CONST

TYPE AVLKey IS NATIVE {AVLKey} PTR
TYPE AVLNODECOMP IS NATIVE {AVLNODECOMP} APTR
TYPE AVLKEYCOMP IS NATIVE {AVLKEYCOMP} APTR


/* The base node in an AVL tree.  Embed this within your object a-la exec ListNode. */
NATIVE {AVLNode} OBJECT avlnode
    {avl_link}	link[2]	:ARRAY OF PTR TO avlnode
    {avl_parent}	parent	:PTR TO avlnode
    {avl_balance}	balance	:VALUE
ENDOBJECT

/* The key type, it's content is only intepreted by the key comparison function */
NATIVE {AVLKey} CONST

/* Compare two nodes */
NATIVE {AVLNODECOMP} CONST

/* Compare a node to a key */
NATIVE {AVLKEYCOMP} CONST
