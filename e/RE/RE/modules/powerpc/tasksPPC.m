#ifndef POWERPC_TASKSPPC_H
#define POWERPC_TASKSPPC_H
#ifndef POWERPC_PORTSPPC_H
MODULE  'powerpc/portsPPC'
#endif
#ifndef EXEC_TASKS_H
MODULE  'exec/tasks'
#endif
#ifndef UTILITY_TAGITEM_H
MODULE  'utility/tagitem'
#endif

OBJECT TaskLink
 
         Node:MinNode
        Task:LONG
        Sig:LONG
        Used:UWORD
ENDOBJECT


OBJECT TaskPPC
 
         Task:Task                    
        StackSize:LONG                     
        StackMem:LONG
        ContextMem:LONG
        TaskPtr:LONG
        Flags:LONG                         
         Link:TaskLink
        BATStorage:LONG
        Core:LONG
         TableLink:MinNode
        Table:LONG                          
        DebugData:LONG                     
        Pad:UWORD
        Timestamp:LONG
        Timestamp2:LONG
        Elapsed:LONG
        Elapsed2:LONG
        Totalelapsed:LONG
        Quantum:LONG
        Priority:LONG
        Prioffset:LONG
        PowerPCBase:LONG
        Desired:LONG
        CPUusage:LONG                      
        Busy:LONG                          
        Activity:LONG                      
        Id:LONG                            
        Nice:LONG                          
         Msgport:PTR TO MsgPortPPC          
         TaskPools:List               
ENDOBJECT
#define NT_PPCTASK 100

#define TS_CHANGING      7

#define TASKPPCB_SYSTEM    0
#define TASKPPCB_BAT       1
#define TASKPPCB_THROW     2
#define TASKPPCB_CHOWN     3
#define TASKPPCB_ATOMIC    4
#define TASKPPCF_SYSTEM    (1<<0)
#define TASKPPCF_BAT       (1<<1)
#define TASKPPCF_THROW     (1<<2)
#define TASKPPCF_CHOWN     (1<<3)
#define TASKPPCF_ATOMIC    (1<<4)

#define TASKATTR_TAGS       (TAG_USER+$100000)
#define TASKATTR_CODE       (TASKATTR_TAGS+0)   
#define TASKATTR_EXITCODE   (TASKATTR_TAGS+1)   
#define TASKATTR_NAME       (TASKATTR_TAGS+2)   
#define TASKATTR_PRI        (TASKATTR_TAGS+3)   
#define TASKATTR_STACKSIZE  (TASKATTR_TAGS+4)   
#define TASKATTR_R2         (TASKATTR_TAGS+5)   
#define TASKATTR_R3         (TASKATTR_TAGS+6)   
#define TASKATTR_R4         (TASKATTR_TAGS+7)
#define TASKATTR_R5         (TASKATTR_TAGS+8)
#define TASKATTR_R6         (TASKATTR_TAGS+9)
#define TASKATTR_R7         (TASKATTR_TAGS+10)
#define TASKATTR_R8         (TASKATTR_TAGS+11)
#define TASKATTR_R9         (TASKATTR_TAGS+12)
#define TASKATTR_R10        (TASKATTR_TAGS+13)
#define TASKATTR_SYSTEM     (TASKATTR_TAGS+14)  
#define TASKATTR_MOTHERPRI  (TASKATTR_TAGS+15)  
#define TASKATTR_BAT        (TASKATTR_TAGS+16)  
#define TASKATTR_NICE       (TASKATTR_TAGS+17)  
#define TASKATTR_INHERITR2  (TASKATTR_TAGS+18)  
#define TASKATTR_ATOMIC     (TASKATTR_TAGS+_19) 

OBJECT TaskPtr
 
         Node:Node
        Task:LONG
ENDOBJECT


#define CHSTACK_SUCCESS  -1
#define CHSTACK_NOMEM    0

#define CHMMU_STANDARD   1
#define CHMMU_BAT        2

#define SNOOP_TAGS          (TAG_USER+$103000)
#define SNOOP_CODE          (SNOOP_TAGS+0)      
#define SNOOP_DATA          (SNOOP_TAGS+1)      
#define SNOOP_TYPE          (SNOOP_TAGS+2)      

#define SNOOP_START     1                       
#define SNOOP_EXIT      2                       

#define CREATOR_PPC     1
#define CREATOR_68K     2
#endif
