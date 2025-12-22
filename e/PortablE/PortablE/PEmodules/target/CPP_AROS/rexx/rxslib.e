OPT NATIVE, PREPROCESS
MODULE 'target/exec/execbase', 'target/rexx/storage'
MODULE 'target/exec/libraries', 'target/exec/types', 'target/dos/dos', 'target/dos/dosextens', 'target/exec/ports', 'target/exec/lists'
{#include <rexx/rxslib.h>}
NATIVE {REXX_RXSLIB_H} CONST

NATIVE {RXSNAME}  CONST
STATIC rxsname  = 'rexxsyslib.library'
#define RXSNAME rxsname

NATIVE {RXSDIR}	 CONST
STATIC rxsdir	 = 'REXX'
#define RXSDIR rxsdir

NATIVE {RXSTNAME} CONST
STATIC rxstname = 'ARexx'
#define RXSTNAME rxstname

/* RxsLib is only here to provide backwards compatibility with Amiga
 * programs. This structure should be considered read-only as a whole.
 * Only use the functions of rexxsyslib.library or send the appropriate
 * command to the REXX port if you want to change something in
 * this structure.
 */
NATIVE {RxsLib} OBJECT rxslib
	{rl_Node}	lib	:lib
	{rl_Flags}	flags	:UBYTE
	{rl_Shadow}	shadow	:UBYTE
	{rl_SysBase}	sysbase	:PTR TO execbase
	{rl_DOSBase}	dosbase	:PTR /*TO DOSBase*/
	{rl_Unused1}	unused1	:PTR TO lib /* rl_IeeeCDBase */
	{rl_SegList}	seglist	:BPTR
	{rl_Unused2}	unused2	:PTR TO filehandle /* rl_NIL */
	{rl_Unused3}	unused3	:VALUE /* rl_Chunk */
	{rl_Unused4}	unused4	:VALUE /* rl_MaxNest */
	{rl_Unused5}	unused5	:APTR /* rl_NULL */
	{rl_Unused6}	unused6	:APTR /* rl_FALSE */
	{rl_Unused7}	unused7	:APTR /* rl_TRUE */
	{rl_Unused8}	unused8	:APTR /* rl_REXX */
	{rl_Unused9}	unused9	:APTR /* rl_COMMAND */
	{rl_Unused10}	unused10	:APTR /* rl_STDIN */
	{rl_Unused11}	unused11	:APTR /* rl_STDOUT */
	{rl_Unused12}	unused12	:APTR /* rl_STDERR */
	{rl_Version}	version	:/*STRPTR*/ ARRAY OF CHAR
	{rl_Unused13}	unused13	:/*STRPTR*/ ARRAY OF CHAR /* rl_TaskName */
	{rl_Unused14}	unused14	:VALUE /* rl_TaskPri */
	{rl_Unused15}	unused15	:VALUE /* rl_TaskSeg */
	{rl_Unused16}	unused16	:VALUE /* rl_StackSize */
	{rl_Unused17}	unused17	:/*STRPTR*/ ARRAY OF CHAR /* rl_RexxDir */
	{rl_Unused18}	unused18	:/*STRPTR*/ ARRAY OF CHAR /* rl_CTABLE */
	{rl_Notice}	notice	:/*STRPTR*/ ARRAY OF CHAR /* The copyright notice */
	{rl_Unused19}	unused19	:mp /* rl_REXX public port */
	{rl_Unused20}	unused20	:UINT /* rl_ReadLock */
	{rl_Unused21}	unused21	:VALUE /* rl_TraceFH */
	{rl_Unused22}	unused22	:lh /* rl_TaskList */
	{rl_Unused23}	unused23	:INT /* rl_NumTask */
	{rl_LibList}	liblist	:lh /* Library list header */
	{rl_NumLib}	numlib	:INT /* Nodes count in library list */
	{rl_ClipList}	cliplist	:lh /* Clip list header */
	{rl_NumClip}	numclip	:INT /* Nodes count in clip list */
	{rl_Unused24}	unused24	:lh /* rl_MsgList */
	{rl_Unused25}	unused25	:INT /* rl_NumMsg */
	{rl_Unused26}	unused26	:lh /* rl_PgmList */
	{rl_Unused27}	unused27	:INT /* rl_NumPgm */
	{rl_Unused28}	unused28	:UINT /* rl_TraceCnt */
	{rl_Unused29}	unused29	:INT /* rl_Avail */
ENDOBJECT

/* These are not necessary for client program either I think
NATIVE {RLFB_TRACE}  CONST RLFB_TRACE  = RTFB_TRACE
NATIVE {RLFB_HALT}   CONST RLFB_HALT   = RTFB_HALT
NATIVE {RLFB_SUSP}   CONST RLFB_SUSP   = RTFB_SUSP
NATIVE {RLFB_STOP}   CONST RLFB_STOP   = 6
NATIVE {RLFB_CLOSE}  CONST RLFB_CLOSE  = 7

NATIVE {RLFMASK}     CONST RLFMASK     = ((1 SHL RLFB_TRACE) OR (1 SHL RLFB_HALT) OR (1 SHL RLFB_SUSP))

NATIVE {RXSCHUNK}    CONST RXSCHUNK    = 1024
NATIVE {RXSNEST}     CONST RXSNEST     = 32
NATIVE {RXSTPRI}     CONST RXSTPRI     = 0
NATIVE {RXSSTACK}    CONST RXSSTACK    = 4096
*/

/* I'm not sure about these ones but let's dissable them for now
NATIVE {CTB_SPACE}   CONST CTB_SPACE   = 0
NATIVE {CTB_DIGIT}   CONST CTB_DIGIT   = 1
NATIVE {CTB_ALPHA}   CONST CTB_ALPHA   = 2
NATIVE {CTB_REXXSYM} CONST CTB_REXXSYM = 3
NATIVE {CTB_REXXOPR} CONST CTB_REXXOPR = 4
NATIVE {CTB_REXXSPC} CONST CTB_REXXSPC = 5
NATIVE {CTB_UPPER}   CONST CTB_UPPER   = 6
NATIVE {CTB_LOWER}   CONST CTB_LOWER   = 7

NATIVE {CTF_SPACE}   CONST CTF_SPACE   = (1 SHL CTB_SPACE)
NATIVE {CTF_DIGIT}   CONST CTF_DIGIT   = (1 SHL CTB_DIGIT)
NATIVE {CTF_ALPHA}   CONST CTF_ALPHA   = (1 SHL CTB_ALPHA)
NATIVE {CTF_REXXSYM} CONST CTF_REXXSYM = (1 SHL CTB_REXXSYM)
NATIVE {CTF_REXXOPR} CONST CTF_REXXOPR = (1 SHL CTB_REXXOPR)
NATIVE {CTF_REXXSPC} CONST CTF_REXXSPC = (1 SHL CTB_REXXSPC)
NATIVE {CTF_UPPER}   CONST CTF_UPPER   = (1 SHL CTB_UPPER)
NATIVE {CTF_LOWER}   CONST CTF_LOWER   = (1 SHL CTB_LOWER
*/
