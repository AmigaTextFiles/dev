OPT NATIVE
MODULE 'target/exec/types', 'target/exec/ports', 'target/dos/dosextens'
MODULE 'target/exec/nodes', 'target/exec/libraries'
{#include <rexx/storage.h>}
NATIVE {REXX_STORAGE_H} CONST

NATIVE {RexxMsg} OBJECT rexxmsg
	{rm_Node}	mn	:mn
	{rm_Private1}	private1	:IPTR /* Was rm_TaskBlock */
	{rm_Private2}	private2	:IPTR /* Was rm_LibBase */
	{rm_Action}	action	:VALUE /* What to do ? */
	{rm_Result1}	result1	:VALUE /* The first result as a number */
	{rm_Result2}	result2	:IPTR /* The second result, most of the time an argstring */
	{rm_Args}	args[16]	:ARRAY OF IPTR /* 16 possible arguments for function calls */
	{rm_PassPort}	passport	:PTR TO mp
	{rm_CommAddr}	commaddr	:/*STRPTR*/ ARRAY OF CHAR /* The starting host environment */
	{rm_FileExt}	fileext	:/*STRPTR*/ ARRAY OF CHAR /* The file extension for macro files */
	{rm_Stdin}	stdin	:PTR TO filehandle /* Input filehandle to use */
	{rm_Stdout}	stdout	:PTR TO filehandle /* Output filehandle to use */
	{rm_Unused1}	unused1	:VALUE /* Was rm_avail */
ENDOBJECT
/* AROS comment: rm_Private1 and rm_Private2 are implementation specific.
 * When sending a message that is meant to be handled in the same environment as
 * another message one received from somewhere, these fields have to be copied
 * to the new message.
 */

/* Shortcuts for the arguments */
NATIVE {ARG0} CONST	->ARG0(msg) ((UBYTE *)msg->rm_Args[0])
NATIVE {ARG1} CONST	->ARG1(msg) ((UBYTE *)msg->rm_Args[1])
NATIVE {ARG2} CONST	->ARG2(msg) ((UBYTE *)msg->rm_Args[2])
NATIVE {RXARG} CONST	->RXARG(msg,n) ((UBYTE *)msg->rm_Args[n])

/* The command for in rm_Action */
NATIVE {RXCOMM}   CONST RXCOMM   = $01000000
NATIVE {RXFUNC}   CONST RXFUNC   = $02000000
NATIVE {RXCLOSE}  CONST RXCLOSE  = $03000000
NATIVE {RXQUERY}  CONST RXQUERY  = $04000000
NATIVE {RXADDFH}  CONST RXADDFH  = $07000000
NATIVE {RXADDLIB} CONST RXADDLIB = $08000000
NATIVE {RXREMLIB} CONST RXREMLIB = $09000000
NATIVE {RXADDCON} CONST RXADDCON = $0A000000
NATIVE {RXREMCON} CONST RXREMCON = $0B000000
NATIVE {RXTCOPN}  CONST RXTCOPN  = $0C000000
NATIVE {RXTCCLS}  CONST RXTCCLS  = $0D000000

/* Some commands added for AROS and regina only */
NATIVE {RXADDRSRC}  CONST RXADDRSRC  = $F0000000 /* Will register a resource node to call the clean up function
			      * from when the rexx script finishes
			      * The rexx implementation is free to use the list node fields
			      * for their own purpose. */
NATIVE {RXREMRSRC}  CONST RXREMRSRC  = $F1000000 /* Will unregister an earlier registered resource node */
NATIVE {RXCHECKMSG} CONST RXCHECKMSG = $F2000000 /* Check if private fields are from the Rexx interpreter */
NATIVE {RXSETVAR}   CONST RXSETVAR   = $F3000000 /* Set a variable with a given to a given value */
NATIVE {RXGETVAR}   CONST RXGETVAR   = $F4000000 /* Get the value of a variable with the given name */

NATIVE {RXCODEMASK} CONST RXCODEMASK = $FF000000
NATIVE {RXARGMASK}  CONST RXARGMASK  = $0000000F

/* Flags that can be combined with the commands */
NATIVE {RXFB_NOIO}     CONST RXFB_NOIO     = 16
NATIVE {RXFB_RESULT}   CONST RXFB_RESULT   = 17
NATIVE {RXFB_STRING}   CONST RXFB_STRING   = 18
NATIVE {RXFB_TOKEN}    CONST RXFB_TOKEN    = 19
NATIVE {RXFB_NONRET}   CONST RXFB_NONRET   = 20
NATIVE {RXFB_FUNCLIST} CONST RXFB_FUNCLIST = 5

/* Convert from bit number to number */
NATIVE {RXFF_NOIO}	CONST RXFF_NOIO	= (1 SHL RXFB_NOIO)
NATIVE {RXFF_RESULT}	CONST RXFF_RESULT	= (1 SHL RXFB_RESULT)
NATIVE {RXFF_STRING}	CONST RXFF_STRING	= (1 SHL RXFB_STRING)
NATIVE {RXFF_TOKEN}	CONST RXFF_TOKEN	= (1 SHL RXFB_TOKEN)
NATIVE {RXFF_NONRET}	CONST RXFF_NONRET	= (1 SHL RXFB_NONRET)

NATIVE {RexxArg} OBJECT rexxarg
	{ra_Size}	size	:VALUE
	{ra_Length}	length	:UINT
	{ra_Depricated1}	flags	:UBYTE /* Was ra_Flags but not used anymore */
	{ra_Depricated2}	hash	:UBYTE /* Was ra_Hash but not used anymore */
	{ra_Buff}	buff[8]	:ARRAY OF BYTE
ENDOBJECT

NATIVE {RexxRsrc} OBJECT rexxrsrc
	{rr_Node}	ln	:ln
	{rr_Func}	func	:INT /* Library offset of clean up function */
	{rr_Base}	base	:APTR /* Library base of clean up function */
	{rr_Size}	size	:VALUE /* Total size of structure */
	{rr_Arg1}	arg1	:VALUE /* Meaning depends on type of Resource */
	{rr_Arg2}	arg2	:VALUE /* Meaning depends on type of Resource */
ENDOBJECT

/* Types for the resource nodes */
NATIVE {RRT_ANY}   CONST RRT_ANY   = 0
NATIVE {RRT_LIB}   CONST RRT_LIB   = 1  /* A function library */
/*#define RRT_PORT  2  Not used */
/*#define RRT_FILE  3  Not used */
NATIVE {RRT_HOST}  CONST RRT_HOST  = 4  /* A function host */
NATIVE {RRT_CLIP}  CONST RRT_CLIP  = 5  /* A clip on the clip list */
