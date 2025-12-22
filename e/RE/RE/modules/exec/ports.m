#ifndef	EXEC_PORTS_H
#define	EXEC_PORTS_H

#ifndef EXEC_NODES_H
MODULE  'exec/nodes'
#endif 
#ifndef EXEC_LISTS_H
MODULE  'exec/lists'
#endif 
#ifndef EXEC_TASKS_H
MODULE  'exec/tasks'
#endif 

OBJECT MsgPort
 
       Node:Node
    Flags:UBYTE
    SigBit:UBYTE		
    SigTask:PTR TO LONG		
       MsgList:List	
ENDOBJECT

#define mp_SoftInt mp_SigTask	

#define PF_ACTION	3	
#define PA_SIGNAL	0	
#define PA_SOFTINT	1	
#define PA_IGNORE	2	

OBJECT Message
 
       Node:Node
       ReplyPort:PTR TO MsgPort  
    Length:UWORD		    
				    
				    
ENDOBJECT

#endif	
