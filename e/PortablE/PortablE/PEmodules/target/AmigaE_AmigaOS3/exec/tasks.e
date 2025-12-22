/* $VER: tasks.h 39.3 (18.9.1992) */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/lists'
MODULE 'target/exec/ports', 'target/exec/types'
{MODULE 'exec/tasks'}

NATIVE {etask} OBJECT etask PUBLIC
	{mn}          mn       :mn
	{parent}      parent   :PTR TO tc
	{uniqueid}    uniqueid :VALUE
	{children}    children :mlh
	{trapalloc}   trapalloc:INT
	{trapable}    trapable :INT
	{result1}     result1  :VALUE
	{result2}     result2  :VALUE
	{taskmsgport} taskmsgport:mp
ENDOBJECT

NATIVE {CHILD_NOTNEW}   CONST CHILD_NOTNEW   = 1
NATIVE {CHILD_NOTFOUND} CONST CHILD_NOTFOUND = 2
NATIVE {CHILD_EXITED}   CONST CHILD_EXITED   = 3
NATIVE {CHILD_ACTIVE}   CONST CHILD_ACTIVE   = 4

NATIVE {SYS_TRAPALLOC} CONST SYS_TRAPALLOC = $8000
NATIVE {SYS_SIGALLOC}  CONST SYS_SIGALLOC  = $FFFF


/* Please use Exec functions to modify task structure fields, where available.
 */
NATIVE {tc} OBJECT tc
    {ln}	ln	:ln
    {flags}	flags	:UBYTE
    {state}	state	:UBYTE
    {idnestcnt}	idnestcnt	:BYTE	    /* intr disabled nesting*/
    {tdnestcnt}	tdnestcnt	:BYTE	    /* task disabled nesting*/
    {sigalloc}	sigalloc	:ULONG	    /* sigs allocated */
    {sigwait}	sigwait	:ULONG	    /* sigs we are waiting for */
    {sigrecvd}	sigrecvd	:ULONG	    /* sigs we have received */
    {sigexcept}	sigexcept	:ULONG	    /* sigs we will take excepts for */
	->              etask     :PTR TO etask		->no such member (but appears to be a union with trapalloc+trapable)
    {trapalloc}	trapalloc	:UINT	    /* traps allocated */
    {trapable}	trapable	:UINT	    /* traps enabled */
    {exceptdata}	exceptdata	:APTR	    /* points to except data */
    {exceptcode}	exceptcode	:APTR	    /* points to except code */
    {trapdata}	trapdata	:APTR	    /* points to trap data */
    {trapcode}	trapcode	:APTR	    /* points to trap code */
    {spreg}	spreg	:APTR		    /* stack pointer	    */
    {splower}	splower	:APTR	    /* stack lower bound    */
    {spupper}	spupper	:APTR	    /* stack upper bound + 2*/
    {switch}	switch	:PTR /*VOID    (*tc_Switch)()*/	    /* task losing CPU	  */
    {launch}	launch	:PTR /*VOID    (*tc_Launch)()*/	    /* task getting CPU  */
    {mementry}	mementry	:lh	    /* Allocated memory. Freed by RemTask() */
    {userdata}	userdata	:APTR	    /* For use by the task; no restrictions! */
ENDOBJECT

/*
 * Stack swap structure as passed to StackSwap()
 */
NATIVE {stackswapstruct} OBJECT stackswapstruct
	{lower}	lower	:APTR	/* Lowest byte of stack */
	{upper}	upper	:ULONG	/* Upper end of stack (size + Lowest) */
	{pointer}	pointer	:APTR	/* Stack pointer at switch point */
ENDOBJECT

/*----- Flag Bits ------------------------------------------*/
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

/*----- Task States ----------------------------------------*/
NATIVE {TS_INVALID}	CONST TS_INVALID	= 0
NATIVE {TS_ADDED}	CONST TS_ADDED	= 1
NATIVE {TS_RUN}		CONST TS_RUN		= 2
NATIVE {TS_READY}	CONST TS_READY	= 3
NATIVE {TS_WAIT}	CONST TS_WAIT	= 4
NATIVE {TS_EXCEPT}	CONST TS_EXCEPT	= 5
NATIVE {TS_REMOVED}	CONST TS_REMOVED	= 6

/*----- Predefined Signals -------------------------------------*/
NATIVE {SIGB_ABORT}	CONST SIGB_ABORT	= 0
NATIVE {SIGB_CHILD}	CONST SIGB_CHILD	= 1
NATIVE {SIGB_BLIT}	CONST SIGB_BLIT	= 4	/* Note: same as SINGLE */
NATIVE {SIGB_SINGLE}	CONST SIGB_SINGLE	= 4	/* Note: same as BLIT */
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
