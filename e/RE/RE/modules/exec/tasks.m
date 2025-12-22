#ifndef	EXEC_TASKS_H
#define	EXEC_TASKS_H

#ifndef EXEC_NODES_H
MODULE  'exec/nodes'
#endif 
#ifndef EXEC_LISTS_H
MODULE  'exec/lists'
#endif 

OBJECT Task
 
       Node:Node
    Flags:UBYTE
    State:UBYTE
    IDNestCnt:BYTE	    
    TDNestCnt:BYTE	    
    SigAlloc:LONG	    
    SigWait:LONG	    
    SigRecvd:LONG	    
    SigExcept:LONG	    
    TrapAlloc:UWORD	    
    TrapAble:UWORD	    
    ExceptData:LONG	    
    ExceptCode:LONG	    
    TrapData:LONG	    
    TrapCode:LONG	    
    SPReg:LONG		    
    SPLower:LONG	    
    SPUpper:LONG	    
    Switch:LONG	    
    Launch:LONG	    
       MemEntry:List	    
    UserData:LONG	    
ENDOBJECT


OBJECT StackSwapStruct
 
	Lower:LONG	
	Upper:LONG	
	Pointer:LONG	
ENDOBJECT


#define TB_PROCTIME	0
#define TB_ETASK	3
#define TB_STACKCHK	4
#define TB_EXCEPT	5
#define TB_SWITCH	6
#define TB_LAUNCH	7
#define TF_PROCTIME	(1<<0)
#define TF_ETASK	(1<<3)
#define TF_STACKCHK	(1<<4)
#define TF_EXCEPT	(1<<5)
#define TF_SWITCH	(1<<6)
#define TF_LAUNCH	(1<<7)

#define TS_INVALID	0
#define TS_ADDED	1
#define TS_RUN		2
#define TS_READY	3
#define TS_WAIT	4
#define TS_EXCEPT	5
#define TS_REMOVED	6

#define SIGB_ABORT	0
#define SIGB_CHILD	1
#define SIGB_BLIT	4	
#define SIGB_SINGLE	4	
#define SIGB_INTUITION	5
#define	SIGB_NET	7
#define SIGB_DOS	8
#define SIGF_ABORT	(1<<0)
#define SIGF_CHILD	(1<<1)
#define SIGF_BLIT	(1<<4)
#define SIGF_SINGLE	(1<<4)
#define SIGF_INTUITION	(1<<5)
#define	SIGF_NET	(1<<7)
#define SIGF_DOS	(1<<8)
#endif	
