#ifndef	EXEC_NODES_H
#define	EXEC_NODES_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif 

OBJECT Node
 
       Succ:PTR TO Node	
       Pred:PTR TO Node	
    Type:UBYTE
    Pri:BYTE		
    Name:LONG		
ENDOBJECT

OBJECT MinNode
 
      Succ:PTR TO MinNode
      Pred:PTR TO MinNode
ENDOBJECT



#define NT_UNKNOWN	0
#define NT_TASK		1	
#define NT_INTERRUPT	2
#define NT_DEVICE	3
#define NT_MSGPORT	4
#define NT_MESSAGE	5	
#define NT_FREEMSG	6
#define NT_REPLYMSG	7	
#define NT_RESOURCE	8
#define NT_LIBRARY	9
#define NT_MEMORY	10
#define NT_SOFTINT	11	
#define NT_FONT		12
#define NT_PROCESS	13	
#define NT_SEMAPHORE	14
#define NT_SIGNALSEM	15	
#define NT_BOOTNODE	16
#define NT_KICKMEM	17
#define NT_GRAPHICS	18
#define NT_DEATHMESSAGE	19
#define NT_USER		254	
#define NT_EXTENDED	255
#endif	
