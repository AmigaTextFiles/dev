#ifndef UTILITY_HOOKS_H
#define UTILITY_HOOKS_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef EXEC_NODES_H
MODULE  'exec/nodes'
#endif

OBJECT Hook

      MinNode:MinNode
    Entry:LONG	
    SubEntry:LONG	
    Data:LONG		
ENDOBJECT


  
#define long unsigned (*HOOKFUNC)()



#endif 
