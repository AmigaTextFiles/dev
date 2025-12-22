/* $VER: rxslib.h 1.6 (8.11.1991) */
OPT NATIVE, PREPROCESS
MODULE 'target/rexx/storage'
MODULE 'target/exec/libraries', 'target/exec/types', 'target/exec/ports', 'target/exec/lists'
{#include <rexx/rxslib.h>}
NATIVE {REXX_RXSLIB_H} CONST

NATIVE {RXSNAME}  CONST
#define RXSNAME rxsname
STATIC rxsname  = 'rexxsyslib.library'

NATIVE {RXSDIR}	 CONST
#define RXSDIR rxsdir
STATIC rxsdir	 = 'REXX'

NATIVE {RXSTNAME} CONST
#define RXSTNAME rxstname
STATIC rxstname = 'ARexx'

/* The REXX systems library structure.	This should be considered as	*/
/* semi-private and read-only, except for documented exceptions.	*/

NATIVE {RxsLib} OBJECT rxslib
   {rl_Node}	lib	:lib	       /* EXEC library node		*/
   {rl_Flags}	flags	:UBYTE		       /* global flags			*/
   {rl_Shadow}	shadow	:UBYTE		       /* shadow flags			*/
   {rl_SysBase}	sysbase	:APTR	       /* EXEC library base		*/
   {rl_DOSBase}	dosbase	:APTR	       /* DOS library base		*/
   {rl_IeeeDPBase}	ieeedpbase	:APTR	       /* IEEE DP math library base	*/
   {rl_SegList}	seglist	:VALUE	       /* library seglist		*/
   {rl_NIL}	nil	:VALUE		       /* global NIL: filehandle	*/
   {rl_Chunk}	chunk	:VALUE		       /* allocation quantum		*/
   {rl_MaxNest}	maxnest	:VALUE	       /* maximum expression nesting	*/
   {rl_NULL}	null	:PTR TO nexxstr	       /* static string: NULL		*/
   {rl_FALSE}	false	:PTR TO nexxstr	       /* static string: FALSE		*/
   {rl_TRUE}	true	:PTR TO nexxstr	       /* static string: TRUE		*/
   {rl_REXX}	rexx	:PTR TO nexxstr	       /* static string: REXX		*/
   {rl_COMMAND}	command	:PTR TO nexxstr	       /* static string: COMMAND	*/
   {rl_STDIN}	stdin	:PTR TO nexxstr	       /* static string: STDIN		*/
   {rl_STDOUT}	stdout	:PTR TO nexxstr	       /* static string: STDOUT	*/
   {rl_STDERR}	stderr	:PTR TO nexxstr	       /* static string: STDERR	*/
   {rl_Version}	version	:/*STRPTR*/ ARRAY OF CHAR	       /* version string		*/

   {rl_TaskName}	taskname	:/*STRPTR*/ ARRAY OF CHAR	       /* name string for tasks	*/
   {rl_TaskPri}	taskpri	:VALUE	       /* starting priority		*/
   {rl_TaskSeg}	taskseg	:VALUE	       /* startup seglist		*/
   {rl_StackSize}	stacksize	:VALUE	       /* stack size			*/
   {rl_RexxDir}	rexxdir	:/*STRPTR*/ ARRAY OF CHAR	       /* REXX directory		*/
   {rl_CTABLE}	ctable	:/*STRPTR*/ ARRAY OF CHAR	       /* character attribute table	*/
   {rl_Notice}	notice	:/*STRPTR*/ ARRAY OF CHAR	       /* copyright notice		*/

   {rl_RexxPort}	rexxport	:mp	       /* REXX public port		*/
   {rl_ReadLock}	readlock	:UINT	       /* lock count			*/
   {rl_TraceFH}	tracefh	:VALUE	       /* global trace console		*/
   {rl_TaskList}	tasklist	:lh	       /* REXX task list		*/
   {rl_NumTask}	numtask	:INT	       /* task count			*/
   {rl_LibList}	liblist	:lh	       /* Library List header		*/
   {rl_NumLib}	numlib	:INT	       /* library count		*/
   {rl_ClipList}	cliplist	:lh	       /* ClipList header		*/
   {rl_NumClip}	numclip	:INT	       /* clip node count		*/
   {rl_MsgList}	msglist	:lh	       /* pending messages		*/
   {rl_NumMsg}	nummsg	:INT	       /* pending count		*/
   {rl_PgmList}	pgmlist	:lh	       /* cached programs		*/
   {rl_NumPgm}	numpgm	:INT	       /* program count		*/

   {rl_TraceCnt}	tracecnt	:UINT	       /* usage count for trace console */
   {rl_avail}	avail	:INT
   ENDOBJECT

/* Global flag bit definitions for RexxMaster				*/
NATIVE {RLFB_TRACE} CONST RLFB_TRACE = RTFB_TRACE	       /* interactive tracing?		*/
NATIVE {RLFB_HALT}  CONST RLFB_HALT  = RTFB_HALT	       /* halt execution?		*/
NATIVE {RLFB_SUSP}  CONST RLFB_SUSP  = RTFB_SUSP	       /* suspend execution?		*/
NATIVE {RLFB_STOP}  CONST RLFB_STOP  = 6		       /* deny further invocations	*/
NATIVE {RLFB_CLOSE} CONST RLFB_CLOSE = 7		       /* close the master		*/

NATIVE {RLFMASK}    CONST RLFMASK    = (1 SHL RLFB_TRACE) OR (1 SHL RLFB_HALT) OR (1 SHL RLFB_SUSP)

/* Initialization constants						*/
NATIVE {RXSCHUNK}   CONST RXSCHUNK   = 1024	       /* allocation quantum		*/
NATIVE {RXSNEST}    CONST RXSNEST    = 32		       /* expression nesting limit	*/
NATIVE {RXSTPRI}    CONST RXSTPRI    = 0		       /* task priority		*/
NATIVE {RXSSTACK}   CONST RXSSTACK   = 4096	       /* stack size			*/

/* Character attribute flag bits used in REXX.				*/
NATIVE {CTB_SPACE}   CONST CTB_SPACE   = 0		       /* white space characters	*/
NATIVE {CTB_DIGIT}   CONST CTB_DIGIT   = 1		       /* decimal digits 0-9		*/
NATIVE {CTB_ALPHA}   CONST CTB_ALPHA   = 2		       /* alphabetic characters	*/
NATIVE {CTB_REXXSYM} CONST CTB_REXXSYM = 3		       /* REXX symbol characters	*/
NATIVE {CTB_REXXOPR} CONST CTB_REXXOPR = 4		       /* REXX operator characters	*/
NATIVE {CTB_REXXSPC} CONST CTB_REXXSPC = 5		       /* REXX special symbols		*/
NATIVE {CTB_UPPER}   CONST CTB_UPPER   = 6		       /* UPPERCASE alphabetic		*/
NATIVE {CTB_LOWER}   CONST CTB_LOWER   = 7		       /* lowercase alphabetic		*/

/* Attribute flags							*/
NATIVE {CTF_SPACE}   CONST CTF_SPACE   = (1 SHL CTB_SPACE)
NATIVE {CTF_DIGIT}   CONST CTF_DIGIT   = (1 SHL CTB_DIGIT)
NATIVE {CTF_ALPHA}   CONST CTF_ALPHA   = (1 SHL CTB_ALPHA)
NATIVE {CTF_REXXSYM} CONST CTF_REXXSYM = (1 SHL CTB_REXXSYM)
NATIVE {CTF_REXXOPR} CONST CTF_REXXOPR = (1 SHL CTB_REXXOPR)
NATIVE {CTF_REXXSPC} CONST CTF_REXXSPC = (1 SHL CTB_REXXSPC)
NATIVE {CTF_UPPER}   CONST CTF_UPPER   = (1 SHL CTB_UPPER)
NATIVE {CTF_LOWER}   CONST CTF_LOWER   = (1 SHL CTB_LOWER)
