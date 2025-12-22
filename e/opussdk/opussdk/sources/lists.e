/*****************************************************************************

 List management

 *****************************************************************************/
OPT MODULE
OPT EXPORT

MODULE 'exec/nodes', 'exec/lists', 'exec/semaphores'

OBJECT att_List
    list:lh                     -> List structure
    lock:ss                     -> Semaphore for locking
    flags:LONG                  -> Flags
    memory:PTR TO LONG          -> Memory pool
    current:PTR TO att_Node     -> Current node (application use)
ENDOBJECT

SET LISTF_LOCK,      -> List requires locking
    LISTF_POOL       -> Use memory pooling

OBJECT att_Node
    node:ln                -> Node structure
    list:PTR TO att_List   -> Pointer back to list
    data:LONG              -> User data
ENDOBJECT

CONST ADDNODEF_SORT       = 1       -> Sort names
CONST ADDNODEF_EXCLUSIVE  = 2       -> Exclusive entry
CONST ADDNODEF_NUMSORT    = 4       -> Numerical name sort
CONST ADDNODEF_PRI        = 8       -> Priority insertion

CONST REMLISTF_FREEDATA   = 1       -> FreeVec data when freeing list
CONST REMLISTF_SAVELIST   = 2       -> Don't free list itself

/*****************************************************************************

 Semaphore management

 *****************************************************************************/

OBJECT listLock
    list:lh
    lock:ss
ENDOBJECT

CONST SEMF_SHARED         = 0
CONST SEMF_EXCLUSIVE      = 1
CONST SEMF_ATTEMPT        = 2
