#ifndef	EXEC_INTERRUPTS_H
#define	EXEC_INTERRUPTS_H

#ifndef EXEC_NODES_H
MODULE  'exec/nodes'
#endif 
#ifndef EXEC_LISTS_H
MODULE  'exec/lists'
#endif 
OBJECT Interrupt
 
       Node:Node
    Data:LONG		    
    Code:LONG	    
ENDOBJECT

OBJECT IntVector
 		
    Data:LONG
    Code:LONG
       Node:PTR TO Node
ENDOBJECT

OBJECT SoftIntList
 		
      List:List
    Pad:UWORD
ENDOBJECT

#define SIH_PRIMASK $($f0)

#define INTB_NMI	15
#define INTF_NMI	(1<<15)
#endif	
