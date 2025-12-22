/* $VER: storage.h 1.4 (8.11.1991) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/nodes', 'target/exec/lists', 'target/exec/ports', 'target/exec/libraries'
{#include <rexx/storage.h>}
NATIVE {REXX_STORAGE_H} CONST

/* The NexxStr structure is used to maintain the internal strings in REXX.
 * It includes the buffer area for the string and associated attributes.
 * This is actually a variable-length structure; it is allocated for a
 * specific length string, and the length is never modified thereafter
 * (since it's used for recycling).
 */

NATIVE {NexxStr} OBJECT nexxstr
   {ns_Ivalue}	ivalue	:VALUE		       /* integer value		*/
   {ns_Length}	length	:UINT		       /* length in bytes (excl null)	*/
   {ns_Flags}	flags	:UBYTE		       /* attribute flags		*/
   {ns_Hash}	hash	:UBYTE		       /* hash code			*/
   {ns_Buff}	buff[8]	:ARRAY OF /*BYTE*/ CHAR	       /* buffer area for strings	*/
   ENDOBJECT				       /* size: 16 bytes (minimum)	*/

NATIVE {NXADDLEN} CONST NXADDLEN = 9		       /* offset plus null byte	*/
NATIVE {IVALUE} CONST	->IVALUE(nsPtr) (nsPtr->ns_Ivalue)

/* String attribute flag bit definitions				*/
NATIVE {NSB_KEEP}     CONST NSB_KEEP     = 0		       /* permanent string?		*/
NATIVE {NSB_STRING}   CONST NSB_STRING   = 1		       /* string form valid?		*/
NATIVE {NSB_NOTNUM}   CONST NSB_NOTNUM   = 2		       /* non-numeric?			*/
NATIVE {NSB_NUMBER}   CONST NSB_NUMBER   = 3		       /* a valid number?		*/
NATIVE {NSB_BINARY}   CONST NSB_BINARY   = 4		       /* integer value saved?		*/
NATIVE {NSB_FLOAT}    CONST NSB_FLOAT    = 5		       /* floating point format?	*/
NATIVE {NSB_EXT}      CONST NSB_EXT      = 6		       /* an external string?		*/
NATIVE {NSB_SOURCE}   CONST NSB_SOURCE   = 7		       /* part of the program source?	*/

/* The flag form of the string attributes				*/
NATIVE {NSF_KEEP}     CONST NSF_KEEP     = (1 SHL NSB_KEEP  )
NATIVE {NSF_STRING}   CONST NSF_STRING   = (1 SHL NSB_STRING)
NATIVE {NSF_NOTNUM}   CONST NSF_NOTNUM   = (1 SHL NSB_NOTNUM)
NATIVE {NSF_NUMBER}   CONST NSF_NUMBER   = (1 SHL NSB_NUMBER)
NATIVE {NSF_BINARY}   CONST NSF_BINARY   = (1 SHL NSB_BINARY)
NATIVE {NSF_FLOAT}    CONST NSF_FLOAT    = (1 SHL NSB_FLOAT )
NATIVE {NSF_EXT}      CONST NSF_EXT      = (1 SHL NSB_EXT   )
NATIVE {NSF_SOURCE}   CONST NSF_SOURCE   = (1 SHL NSB_SOURCE)

/* Combinations of flags						*/
NATIVE {NSF_INTNUM}   CONST NSF_INTNUM   = (NSF_NUMBER OR NSF_BINARY OR NSF_STRING)
NATIVE {NSF_DPNUM}    CONST NSF_DPNUM    = (NSF_NUMBER OR NSF_FLOAT)
NATIVE {NSF_ALPHA}    CONST NSF_ALPHA    = (NSF_NOTNUM OR NSF_STRING)
NATIVE {NSF_OWNED}    CONST NSF_OWNED    = (NSF_SOURCE OR NSF_EXT    OR NSF_KEEP)
NATIVE {KEEPSTR}      CONST KEEPSTR      = (NSF_STRING OR NSF_SOURCE OR NSF_NOTNUM)
NATIVE {KEEPNUM}      CONST KEEPNUM      = (NSF_STRING OR NSF_SOURCE OR NSF_NUMBER OR NSF_BINARY)

/* The RexxArg structure is identical to the NexxStr structure, but
 * is allocated from system memory rather than from internal storage.
 * This structure is used for passing arguments to external programs.
 * It is usually passed as an "argstring", a pointer to the string buffer.
 */

NATIVE {RexxArg} OBJECT rexxarg
   {ra_Size}	size	:VALUE		       /* total allocated length	*/
   {ra_Length}	length	:UINT		       /* length of string		*/
   {ra_Flags}	flags	:UBYTE		       /* attribute flags		*/
   {ra_Hash}	hash	:UBYTE		       /* hash code			*/
   {ra_Buff}	buff[8]	:ARRAY OF /*BYTE*/ CHAR	       /* buffer area			*/
   ENDOBJECT				       /* size: 16 bytes (minimum)	*/

/* The RexxMsg structure is used for all communications with REXX
 * programs.  It is an EXEC message with a parameter block appended.
 */

NATIVE {RexxMsg} OBJECT rexxmsg
   {rm_Node}	mn	:mn	       /* EXEC message structure	*/
   {rm_TaskBlock}	taskblock	:APTR	       /* global structure (private)	*/
   {rm_LibBase}	libbase	:APTR	       /* library base (private)	*/
   {rm_Action}	action	:VALUE		       /* command (action) code	*/
   {rm_Result1}	result1	:VALUE	       /* primary result (return code)	*/
   {rm_Result2}	result2	:VALUE	       /* secondary result		*/
   {rm_Args}	args[16]	:ARRAY OF /*STRPTR*/ ARRAY OF CHAR	       /* argument block (ARG0-ARG15)	*/

   {rm_PassPort}	passport	:PTR TO mp        /* forwarding port		*/
   {rm_CommAddr}	commaddr	:/*STRPTR*/ ARRAY OF CHAR	       /* host address (port name)	*/
   {rm_FileExt}	fileext	:/*STRPTR*/ ARRAY OF CHAR	       /* file extension		*/
   {rm_Stdin}	stdin	:VALUE		       /* input stream (filehandle)	*/
   {rm_Stdout}	stdout	:VALUE		       /* output stream (filehandle)	*/
   {rm_avail}	avail	:VALUE		       /* future expansion		*/
   ENDOBJECT				       /* size: 128 bytes		*/

/* Field definitions							*/
NATIVE {ARG0} CONST	->ARG0(rmp) (rmp->rm_Args[0])    /* start of argblock		*/
NATIVE {ARG1} CONST	->ARG1(rmp) (rmp->rm_Args[1])    /* first argument		*/
NATIVE {ARG2} CONST	->ARG2(rmp) (rmp->rm_Args[2])    /* second argument		*/

NATIVE {MAXRMARG}  CONST MAXRMARG  = 15		       /* maximum arguments		*/

/* Command (action) codes for message packets				*/
NATIVE {RXCOMM}	  CONST RXCOMM	  = $01000000	       /* a command-level invocation	*/
NATIVE {RXFUNC}	  CONST RXFUNC	  = $02000000	       /* a function call		*/
NATIVE {RXCLOSE}   CONST RXCLOSE   = $03000000	       /* close the REXX server	*/
NATIVE {RXQUERY}   CONST RXQUERY   = $04000000	       /* query for information	*/
NATIVE {RXADDFH}   CONST RXADDFH   = $07000000	       /* add a function host		*/
NATIVE {RXADDLIB}  CONST RXADDLIB  = $08000000	       /* add a function library	*/
NATIVE {RXREMLIB}  CONST RXREMLIB  = $09000000	       /* remove a function library	*/
NATIVE {RXADDCON}  CONST RXADDCON  = $0A000000	       /* add/update a ClipList string	*/
NATIVE {RXREMCON}  CONST RXREMCON  = $0B000000	       /* remove a ClipList string	*/
NATIVE {RXTCOPN}   CONST RXTCOPN   = $0C000000	       /* open the trace console	*/
NATIVE {RXTCCLS}   CONST RXTCCLS   = $0D000000	       /* close the trace console	*/

/* Command modifier flag bits						*/
NATIVE {RXFB_NOIO}    CONST RXFB_NOIO    = 16	       /* suppress I/O inheritance?	*/
NATIVE {RXFB_RESULT}  CONST RXFB_RESULT  = 17	       /* result string expected?	*/
NATIVE {RXFB_STRING}  CONST RXFB_STRING  = 18	       /* program is a "string file"?	*/
NATIVE {RXFB_TOKEN}   CONST RXFB_TOKEN   = 19	       /* tokenize the command line?	*/
NATIVE {RXFB_NONRET}  CONST RXFB_NONRET  = 20	       /* a "no-return" message?	*/

/* The flag form of the command modifiers				*/
NATIVE {RXFF_NOIO}    CONST RXFF_NOIO    = (1 SHL RXFB_NOIO  )
NATIVE {RXFF_RESULT}  CONST RXFF_RESULT  = (1 SHL RXFB_RESULT)
NATIVE {RXFF_STRING}  CONST RXFF_STRING  = (1 SHL RXFB_STRING)
NATIVE {RXFF_TOKEN}   CONST RXFF_TOKEN   = (1 SHL RXFB_TOKEN )
NATIVE {RXFF_NONRET}  CONST RXFF_NONRET  = (1 SHL RXFB_NONRET)

NATIVE {RXCODEMASK}   CONST RXCODEMASK   = $FF000000
NATIVE {RXARGMASK}    CONST RXARGMASK    = $0000000F

/* The RexxRsrc structure is used to manage global resources.  Each node
 * has a name string created as a RexxArg structure, and the total size
 * of the node is saved in the "rr_Size" field.  The REXX systems library
 * provides functions to allocate and release resource nodes.  If special
 * deletion operations are required, an offset and base can be provided in
 * "rr_Func" and "rr_Base", respectively.  This "autodelete" function will
 * be called with the base in register A6 and the node in A0.
 */

NATIVE {RexxRsrc} OBJECT rexxrsrc
   {rr_Node}	ln	:ln
   {rr_Func}	func	:INT		       /* "auto-delete" offset		*/
   {rr_Base}	base	:APTR		       /* "auto-delete" base		*/
   {rr_Size}	size	:VALUE		       /* total size of node		*/
   {rr_Arg1}	arg1	:VALUE		       /* available ...		*/
   {rr_Arg2}	arg2	:VALUE		       /* available ...		*/
   ENDOBJECT				       /* size: 32 bytes		*/

/* Resource node types							*/
NATIVE {RRT_ANY}      CONST RRT_ANY      = 0		       /* any node type ...		*/
NATIVE {RRT_LIB}      CONST RRT_LIB      = 1		       /* a function library		*/
NATIVE {RRT_PORT}     CONST RRT_PORT     = 2		       /* a public port		*/
NATIVE {RRT_FILE}     CONST RRT_FILE     = 3		       /* a file IoBuff		*/
NATIVE {RRT_HOST}     CONST RRT_HOST     = 4		       /* a function host		*/
NATIVE {RRT_CLIP}     CONST RRT_CLIP     = 5		       /* a Clip List node		*/

/* The RexxTask structure holds the fields used by REXX to communicate with
 * external processes, including the client task.  It includes the global
 * data structure (and the base environment).  The structure is passed to
 * the newly-created task in its "wake-up" message.
 */

NATIVE {GLOBALSZ}  CONST GLOBALSZ  = 200		       /* total size of GlobalData	*/

NATIVE {RexxTask} OBJECT rexxtask
   {rt_Global}	global[GLOBALSZ]	:ARRAY OF BYTE       /* global data structure	*/
   {rt_MsgPort}	msgport	:mp	       /* global message port		*/
   {rt_Flags}	flags	:UBYTE		       /* task flag bits		*/
   {rt_SigBit}	sigbit	:BYTE		       /* signal bit			*/

   {rt_ClientID}	clientid	:APTR	       /* the client's task ID		*/
   {rt_MsgPkt}	msgpkt	:APTR		       /* the packet being processed	*/
   {rt_TaskID}	taskid	:APTR		       /* our task ID			*/
   {rt_RexxPort}	port	:APTR	       /* the REXX public port		*/

   {rt_ErrTrap}	errtrap	:APTR	       /* Error trap address		*/
   {rt_StackPtr}	stackptr	:APTR	       /* stack pointer for traps	*/

   {rt_Header1}	header1	:lh	       /* Environment list		*/
   {rt_Header2}	header2	:lh	       /* Memory freelist		*/
   {rt_Header3}	header3	:lh	       /* Memory allocation list	*/
   {rt_Header4}	header4	:lh	       /* Files list			*/
   {rt_Header5}	header5	:lh	       /* Message Ports List		*/
   ENDOBJECT

/* Definitions for RexxTask flag bits					*/
NATIVE {RTFB_TRACE}   CONST RTFB_TRACE   = 0		       /* external trace flag		*/
NATIVE {RTFB_HALT}    CONST RTFB_HALT    = 1		       /* external halt flag		*/
NATIVE {RTFB_SUSP}    CONST RTFB_SUSP    = 2		       /* suspend task?		*/
NATIVE {RTFB_TCUSE}   CONST RTFB_TCUSE   = 3		       /* trace console in use?	*/
NATIVE {RTFB_WAIT}    CONST RTFB_WAIT    = 6		       /* waiting for reply?		*/
NATIVE {RTFB_CLOSE}   CONST RTFB_CLOSE   = 7		       /* task completed?		*/

/* Definitions for memory allocation constants				*/
NATIVE {MEMQUANT}  CONST MEMQUANT  = 16		       /* quantum of memory space	*/
NATIVE {MEMMASK}   CONST MEMMASK   = $FFFFFFF0	       /* mask for rounding the size	*/

NATIVE {MEMQUICK}  CONST MEMQUICK  = $1	       /* EXEC flags: MEMF_PUBLIC	*/
NATIVE {MEMCLEAR}  CONST MEMCLEAR  = $10000	       /* EXEC flags: MEMF_CLEAR	*/

/* The SrcNode is a temporary structure used to hold values destined for
 * a segment array.  It is also used to maintain the memory freelist.
 */

NATIVE {SrcNode} OBJECT srcnode
   {sn_Succ}	succ	:PTR TO srcnode	       /* next node			*/
   {sn_Pred}	pred	:PTR TO srcnode	       /* previous node		*/
   {sn_Ptr}	ptr	:APTR		       /* pointer value		*/
   {sn_Size}	size	:VALUE		       /* size of object		*/
   ENDOBJECT				       /* size: 16 bytes		*/
