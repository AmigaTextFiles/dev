/* $VER: rxslib.h 1.6 (8.11.1991) */
OPT NATIVE, PREPROCESS
MODULE 'target/rexx/storage'
MODULE 'target/exec/libraries', 'target/exec/types', 'target/exec/ports', 'target/exec/lists'
{MODULE 'rexx/rxslib'}

NATIVE {RXSNAME}  CONST
#define RXSNAME rxsname
STATIC rxsname  = 'rexxsyslib.library'

NATIVE {RXSDIR}	 CONST
#define RXSDIR rxsdir
STATIC rxsdir	 = 'REXX'

NATIVE {RXSTNAME} CONST
#define RXSTNAME rxstname
STATIC rxstname = 'ARexx'


NATIVE {rxslib} OBJECT rxslib
   {lib}	lib	:lib	       /* EXEC library node		*/
   {flags}	flags	:UBYTE		       /* global flags			*/
   {shadow}	shadow	:UBYTE		       /* shadow flags			*/
   {sysbase}	sysbase	:APTR	       /* EXEC library base		*/
   {dosbase}	dosbase	:APTR	       /* DOS library base		*/
   {ieeedpbase}	ieeedpbase	:APTR	       /* IEEE DP math library base	*/
   {seglist}	seglist	:VALUE	       /* library seglist		*/
   {nil}	nil	:VALUE		       /* global NIL: filehandle	*/
   {chunk}	chunk	:VALUE		       /* allocation quantum		*/
   {maxnest}	maxnest	:VALUE	       /* maximum expression nesting	*/
   {null}	null	:PTR TO nexxstr	       /* static string: NULL		*/
   {false}	false	:PTR TO nexxstr	       /* static string: FALSE		*/
   {true}	true	:PTR TO nexxstr	       /* static string: TRUE		*/
   {rexx}	rexx	:PTR TO nexxstr	       /* static string: REXX		*/
   {command}	command	:PTR TO nexxstr	       /* static string: COMMAND	*/
   {stdin}	stdin	:PTR TO nexxstr	       /* static string: STDIN		*/
   {stdout}	stdout	:PTR TO nexxstr	       /* static string: STDOUT	*/
   {stderr}	stderr	:PTR TO nexxstr	       /* static string: STDERR	*/
   {version}	version	:/*STRPTR*/ ARRAY OF CHAR	       /* version string		*/

   {taskname}	taskname	:/*STRPTR*/ ARRAY OF CHAR	       /* name string for tasks	*/
   {taskpri}	taskpri	:VALUE	       /* starting priority		*/
   {taskseg}	taskseg	:VALUE	       /* startup seglist		*/
   {stacksize}	stacksize	:VALUE	       /* stack size			*/
   {rexxdir}	rexxdir	:/*STRPTR*/ ARRAY OF CHAR	       /* REXX directory		*/
   {ctable}	ctable	:/*STRPTR*/ ARRAY OF CHAR	       /* character attribute table	*/
   {notice}	notice	:/*STRPTR*/ ARRAY OF CHAR	       /* copyright notice		*/

   {rexxport}	rexxport	:mp	       /* REXX public port		*/
   {readlock}	readlock	:UINT	       /* lock count			*/
   {tracefh}	tracefh	:VALUE	       /* global trace console		*/
   {tasklist}	tasklist	:lh	       /* REXX task list		*/
   {numtask}	numtask	:INT	       /* task count			*/
   {liblist}	liblist	:lh	       /* Library List header		*/
   {numlib}	numlib	:INT	       /* library count		*/
   {cliplist}	cliplist	:lh	       /* ClipList header		*/
   {numclip}	numclip	:INT	       /* clip node count		*/
   {msglist}	msglist	:lh	       /* pending messages		*/
   {nummsg}	nummsg	:INT	       /* pending count		*/
   {pgmlist}	pgmlist	:lh	       /* cached programs		*/
   {numpgm}	numpgm	:INT	       /* program count		*/

   {tracecnt}	tracecnt	:UINT	       /* usage count for trace console */
   {avail}	avail	:INT
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
