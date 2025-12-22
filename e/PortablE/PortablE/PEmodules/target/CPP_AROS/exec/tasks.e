/* $Id: tasks.h 20558 2004-01-08 22:13:16Z stegerg $ */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/lists', 'target/exec/ports', 'target/utility/tagitem'
MODULE 'target/exec/types'
{#include <exec/tasks.h>}
NATIVE {EXEC_TASKS_H} CONST

CONST SYS_TRAPALLOC = $8000
CONST SYS_SIGALLOC  = $FFFF

/* You must use Exec functions to modify task structure fields. */
NATIVE {Task} OBJECT tc
    {tc_Node}	ln	:ln
    {tc_Flags}	flags	:UBYTE
    {tc_State}	state	:UBYTE
    {tc_IDNestCnt}	idnestcnt	:BYTE	/* Interrupt disabled nesting */
    {tc_TDNestCnt}	tdnestcnt	:BYTE	/* Task disabled nesting */
    {tc_SigAlloc}	sigalloc	:ULONG	/* Allocated signals */
    {tc_SigWait}	sigwait	:ULONG	/* Signals we are waiting for */
    {tc_SigRecvd}	sigrecvd	:ULONG	/* Received signals */
    {tc_SigExcept}	sigexcept	:ULONG	/* Signals we will take exceptions for */
	{tc_UnionETask.tc_ETrap.tc_ETrapAlloc}	trapalloc	:UINT   /* Allocated traps */
	{tc_UnionETask.tc_ETrap.tc_ETrapAble}	trapable	:UINT    /* Enabled traps */
	{tc_UnionETask.tc_ETask}	etask	:APTR	   /* Valid if TF_ETASK is set */
    {tc_ExceptData}	exceptdata	:APTR	/* Exception data */
    {tc_ExceptCode}	exceptcode	:APTR	/* Exception code */
    {tc_TrapData}	trapdata	:APTR	/* Trap data */
    {tc_TrapCode}	trapcode	:APTR	/* Trap code */
    {tc_SPReg}	spreg	:APTR	/* Stack pointer */
    {tc_SPLower}	splower	:APTR	/* Stack lower bound */
    {tc_SPUpper}	spupper	:APTR	/* Stack upper bound */
    {tc_Switch}	switch	:NATIVE {VOID     (*)()} PTR   /* Task loses CPU */
    {tc_Launch}	launch	:NATIVE {VOID     (*)()} PTR   /* Task gets CPU */
    {tc_MemEntry}	mementry	:lh	/* Allocated memory. Freed by RemTask(). */
    {tc_UserData}	userdata	:APTR	/* For use by the task; no restrictions! */
ENDOBJECT

NATIVE {tc_TrapAlloc}	    CONST
NATIVE {tc_TrapAble}	    CONST

/* Macros */
NATIVE {GetTrapAlloc} PROC	->GetTrapAlloc(t) ((((struct Task *)t)->tc_Flags & TF_ETASK) ? ((struct ETask *)(((struct Task *)t)->tc_UnionETask.tc_ETask))-> et_TrapAlloc : ((struct Task *)t)->tc_UnionETask.tc_ETrap.tc_ETrapAlloc)
NATIVE {GetTrapAble} PROC	->GetTrapAble(t) ((((struct Task *)t)->tc_Flags & TF_ETASK) ? ((struct ETask *)(((struct Task *)t)->tc_UnionETask.tc_ETask))-> et_TrapAble : ((struct Task *)t)->tc_UnionETask.tc_ETrap.tc_ETrapAble)
NATIVE {GetETask} PROC	->GetETask(t) ((((struct Task *)t)->tc_Flags & TF_ETASK) ? ((struct ETask *)(((struct Task *)t)->tc_UnionETask.tc_ETask)) : NULL )
NATIVE {GetETaskID} PROC	->GetETaskID(t) (   (((struct Task *)(t))->tc_Flags & TF_ETASK) ? (((struct ETask *) (((struct Task *)(t))->tc_UnionETask.tc_ETask))->et_UniqueID) : 0UL )


/* Stack swap structure as passed to StackSwap() */
NATIVE {StackSwapStruct} OBJECT stackswapstruct
    {stk_Lower}	lower	:APTR   /* Lowest byte of stack */
    {stk_Upper}	upper	:APTR   /* Upper end of stack (size + Lowest) */
    {stk_Pointer}	pointer	:APTR /* Stack pointer at switch point */
ENDOBJECT

/* tc_Flags Bits */
NATIVE {TB_PROCTIME}	CONST TB_PROCTIME	= 0
NATIVE {TB_ETASK}	CONST TB_ETASK	= 3
NATIVE {TB_STACKCHK}	CONST TB_STACKCHK	= 4
NATIVE {TB_EXCEPT}	CONST TB_EXCEPT	= 5
NATIVE {TB_SWITCH}	CONST TB_SWITCH	= 6
NATIVE {TB_LAUNCH}	CONST TB_LAUNCH	= 7

NATIVE {TF_PROCTIME}	CONST TF_PROCTIME	= $1
NATIVE {TF_ETASK}	CONST TF_ETASK	= $8
NATIVE {TF_STACKCHK}	CONST TF_STACKCHK	= $10
NATIVE {TF_EXCEPT}	CONST TF_EXCEPT	= $20
NATIVE {TF_SWITCH}	CONST TF_SWITCH	= $40
NATIVE {TF_LAUNCH}	CONST TF_LAUNCH	= $80

/* Task States (tc_State) */
NATIVE {TS_INVALID}	CONST TS_INVALID	= 0
NATIVE {TS_ADDED}	CONST TS_ADDED	= 1
NATIVE {TS_RUN}		CONST TS_RUN		= 2
NATIVE {TS_READY}	CONST TS_READY	= 3
NATIVE {TS_WAIT}		CONST TS_WAIT		= 4
NATIVE {TS_EXCEPT}	CONST TS_EXCEPT	= 5
NATIVE {TS_REMOVED}	CONST TS_REMOVED	= 6

/* Predefined Signals */
NATIVE {SIGB_ABORT}	CONST SIGB_ABORT	= 0
NATIVE {SIGB_CHILD}	CONST SIGB_CHILD	= 1
NATIVE {SIGB_BLIT}	CONST SIGB_BLIT	= 4	/* Note: same as SIGB_SINGLE */
NATIVE {SIGB_SINGLE}	CONST SIGB_SINGLE	= 4	/* Note: same as SIGB_BLIT */
NATIVE {SIGB_INTUITION}	CONST SIGB_INTUITION	= 5
NATIVE {SIGB_NET}	CONST SIGB_NET	= 7
NATIVE {SIGB_DOS}	CONST SIGB_DOS	= 8

NATIVE {SIGF_ABORT}	CONST SIGF_ABORT	= $1
NATIVE {SIGF_CHILD}	CONST SIGF_CHILD	= $2
NATIVE {SIGF_BLIT}	CONST SIGF_BLIT	= $10
NATIVE {SIGF_SINGLE}	CONST SIGF_SINGLE	= $10
NATIVE {SIGF_INTUITION}	CONST SIGF_INTUITION	= $20
NATIVE {SIGF_NET}	CONST SIGF_NET	= $80
NATIVE {SIGF_DOS}	CONST SIGF_DOS	= $100

/* Extended Task structure */
NATIVE {ETask} OBJECT etask
    {et_Message}	mn:mn
    {et_Parent}	parent	:APTR	    /* Pointer to task */
    {et_UniqueID}	uniqueid	:ULONG
    {et_Children}	children	:mlh     /* List of children */
    {et_TrapAlloc}	trapalloc	:UINT
    {et_TrapAble}	trapable	:UINT
    {et_Result1}	result1	:ULONG	    /* First result */
    {et_Result2}	result2	:APTR	    /* Result data pointer (AllocVec) */
    {et_TaskMsgPort}	taskmsgport	:mp

    /* Internal fields follow */
ENDOBJECT

/* Return codes from new child functions */
NATIVE {CHILD_NOTNEW}   CONST CHILD_NOTNEW   = 1 /* Function not called from a new style task */
NATIVE {CHILD_NOTFOUND} CONST CHILD_NOTFOUND = 2 /* Child not found */
NATIVE {CHILD_EXITED}   CONST CHILD_EXITED   = 3 /* Child has exited */
NATIVE {CHILD_ACTIVE}   CONST CHILD_ACTIVE   = 4 /* Child is currently active and running */

/* Tags for NewAddTask() */

NATIVE {TASKTAG_Dummy}	CONST TASKTAG_DUMMY	= (TAG_USER + $100000)
NATIVE {TASKTAG_ARG1}	CONST TASKTAG_ARG1	= (TASKTAG_DUMMY + 16)
NATIVE {TASKTAG_ARG2}	CONST TASKTAG_ARG2	= (TASKTAG_DUMMY + 17)
NATIVE {TASKTAG_ARG3}	CONST TASKTAG_ARG3	= (TASKTAG_DUMMY + 18)
NATIVE {TASKTAG_ARG4}	CONST TASKTAG_ARG4	= (TASKTAG_DUMMY + 19)
NATIVE {TASKTAG_ARG5}	CONST TASKTAG_ARG5	= (TASKTAG_DUMMY + 20)
NATIVE {TASKTAG_ARG6}	CONST TASKTAG_ARG6	= (TASKTAG_DUMMY + 21)
NATIVE {TASKTAG_ARG7}	CONST TASKTAG_ARG7	= (TASKTAG_DUMMY + 22)
NATIVE {TASKTAG_ARG8}	CONST TASKTAG_ARG8	= (TASKTAG_DUMMY + 23)
