/* $Id: tasks.h,v 1.20 2005/11/10 15:33:07 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/lists', 'target/utility/tagitem'
MODULE 'target/exec/types', 'target/exec/ports'
{#include <exec/tasks.h>}
NATIVE {EXEC_TASKS_H} CONST

->no such object!
OBJECT etask
	mn       :mn
	parent   :PTR TO tc
	uniqueid :VALUE
	children :mlh
	trapalloc:INT
	trapable :INT
	result1  :VALUE
	result2  :VALUE
	taskmsgport:mp
ENDOBJECT

CONST CHILD_NOTNEW   = 1
CONST CHILD_NOTFOUND = 2
CONST CHILD_EXITED   = 3
CONST CHILD_ACTIVE   = 4

CONST SYS_TRAPALLOC = $8000
CONST SYS_SIGALLOC  = $FFFF

/* Please use Exec functions to modify task structure fields,
 * where available.
 */
NATIVE {Task} OBJECT tc
    {tc_Node}	ln	:ln
    {tc_Flags}	flags	:UBYTE
    {tc_State}	state	:UBYTE
    {tc_IDNestCnt}	idnestcnt	:BYTE  /* intr disabled nesting*/
    {tc_TDNestCnt}	tdnestcnt	:BYTE  /* task disabled nesting*/
    {tc_SigAlloc}	sigalloc	:ULONG   /* sigs allocated */
    {tc_SigWait}	sigwait	:ULONG    /* sigs we are waiting for */
    {tc_SigRecvd}	sigrecvd	:ULONG   /* sigs we have received */
    {tc_SigExcept}	sigexcept	:ULONG  /* sigs we will take excepts for */

    /*
    ** The following field used to be this
    ** UWORD   tc_TrapAlloc;
    ** UWORD   tc_TrapAble;
    ** It was replaced by a pointer to an extended task structure.
    ** This structure is private, and msut *NOT* be accessed.
    ** There's no guarantee that it's even there, or what exactly
    ** it points to... you have been warned..
    ** Note: Contrary to what V36 does, this fields is *always* a pointer.
    ** The appropriate flag is implicit in V50.
    */
    {tc_ETask}	etask	:APTR      /* Extended task pointer */
    {tc_ExceptData}	exceptdata	:APTR /* points to except data */
    {tc_ExceptCode}	exceptcode	:APTR /* points to except code */
    {tc_TrapData}	trapdata	:APTR   /* points to trap data */
    {tc_TrapCode}	trapcode	:APTR   /* points to trap code */
    {tc_SPReg}	spreg	:APTR      /* stack pointer */
    {tc_SPLower}	splower	:APTR    /* stack lower bound */
    {tc_SPUpper}	spupper	:APTR    /* stack upper bound + 2*/
    {tc_Switch}	switch	:NATIVE {VOID      (*)()} PTR  /* task losing CPU */
    {tc_Launch}	launch	:NATIVE {VOID      (*)()} PTR  /* task getting CPU */
    {tc_MemEntry}	mementry	:lh   /* Allocated memory. Freed by RemTask() */
    {tc_UserData}	userdata	:APTR   /* For use by the task; no restrictions! */
ENDOBJECT


/****************************************************************************/

/*
 * Stack swap structure as passed to StackSwap()
 */
NATIVE {StackSwapStruct} OBJECT stackswapstruct
    {stk_Lower}	lower	:APTR   /* Lowest byte of stack */
    {stk_Upper}	upper	:ULONG   /* Upper end of stack (size + Lowest) */
    {stk_Pointer}	pointer	:APTR /* Stack pointer at switch point */
ENDOBJECT

/****************************************************************************/

/*----- Flag Bits ------------------------------------------*/
NATIVE {enTaskFlagsBits} DEF
NATIVE {TB_PROCTIME} CONST TB_PROCTIME = 0
NATIVE {TB_ETASK}    CONST TB_ETASK    = 3
NATIVE {TB_STACKCHK} CONST TB_STACKCHK = 4
NATIVE {TB_EXCEPT}   CONST TB_EXCEPT   = 5
NATIVE {TB_SWITCH}   CONST TB_SWITCH   = 6
NATIVE {TB_LAUNCH}   CONST TB_LAUNCH   = 7


NATIVE {enTaskFlags} DEF
NATIVE {TF_PROCTIME} CONST TF_PROCTIME = $1
NATIVE {TF_ETASK}    CONST TF_ETASK    = $8
NATIVE {TF_STACKCHK} CONST TF_STACKCHK = $10
NATIVE {TF_EXCEPT}   CONST TF_EXCEPT   = $20
NATIVE {TF_SWITCH}   CONST TF_SWITCH   = $40
NATIVE {TF_LAUNCH}   CONST TF_LAUNCH   = $80



/*----- Task States ----------------------------------------*/
NATIVE {enTaskState} DEF
NATIVE {TS_INVALID}   CONST TS_INVALID   = 0
NATIVE {TS_ADDED}     CONST TS_ADDED     = 1
NATIVE {TS_RUN}       CONST TS_RUN       = 2
NATIVE {TS_READY}     CONST TS_READY     = 3
NATIVE {TS_WAIT}      CONST TS_WAIT      = 4
NATIVE {TS_EXCEPT}    CONST TS_EXCEPT    = 5
NATIVE {TS_REMOVED}   CONST TS_REMOVED   = 6
NATIVE {TS_CRASHED}   CONST TS_CRASHED   = 7
NATIVE {TS_SUSPENDED} CONST TS_SUSPENDED = 8


/*----- Predefined Signals -------------------------------------*/
NATIVE {enTaskSignalBits} DEF
NATIVE {SIGB_ABORT}     CONST SIGB_ABORT     = 0
NATIVE {SIGB_CHILD}     CONST SIGB_CHILD     = 1
NATIVE {SIGB_BLIT}      CONST SIGB_BLIT      = 4 /* Note: same as SINGLE */
NATIVE {SIGB_SINGLE}    CONST SIGB_SINGLE    = 4 /* Note: same as BLIT */
NATIVE {SIGB_INTUITION} CONST SIGB_INTUITION = 5
NATIVE {SIGB_NET}       CONST SIGB_NET       = 7
NATIVE {SIGB_DOS}       CONST SIGB_DOS       = 8


NATIVE {enTaskSignal} DEF
NATIVE {SIGF_ABORT}     CONST SIGF_ABORT     = $1
NATIVE {SIGF_CHILD}     CONST SIGF_CHILD     = $2
NATIVE {SIGF_BLIT}      CONST SIGF_BLIT      = $10
NATIVE {SIGF_SINGLE}    CONST SIGF_SINGLE    = $10
NATIVE {SIGF_INTUITION} CONST SIGF_INTUITION = $20
NATIVE {SIGF_NET}       CONST SIGF_NET       = $80
NATIVE {SIGF_DOS}       CONST SIGF_DOS       = $100


/****************************************************************************/

NATIVE {enSuspendBits} DEF
NATIVE {STB_CRASHED} CONST STB_CRASHED = 0


NATIVE {enSuspendFlags} DEF
NATIVE {STF_CRASHED} CONST STF_CRASHED = $1
