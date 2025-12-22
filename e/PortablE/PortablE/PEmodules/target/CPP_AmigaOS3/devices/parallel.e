/* $VER: parallel.h 36.1 (10.5.1990) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/io'
MODULE 'target/exec/types'
{#include <devices/parallel.h>}
NATIVE {DEVICES_PARALLEL_H} CONST

NATIVE {IOPArray} OBJECT ioparray
	{PTermArray0}	ptermarray0	:ULONG
	{PTermArray1}	ptermarray1	:ULONG
ENDOBJECT

/******************************************************************/
/* CAUTION !!  IF YOU ACCESS the parallel.device, you MUST (!!!!) use
   an IOExtPar-sized structure or you may overlay innocent memory !! */
/******************************************************************/

NATIVE {IOExtPar} OBJECT ioextpar
	{IOPar}	iostd	:iostd

/*     STRUCT	MsgNode
*   0	APTR	 Succ
*   4	APTR	 Pred
*   8	UBYTE	 Type
*   9	UBYTE	 Pri
*   A	APTR	 Name
*   E	APTR	 ReplyPort
*  12	UWORD	 MNLength
*     STRUCT   IOExt
*  14	APTR	 io_Device
*  18	APTR	 io_Unit
*  1C	UWORD	 io_Command
*  1E	UBYTE	 io_Flags
*  1F	UBYTE	 io_Error
*     STRUCT   IOStdExt
*  20	ULONG	 io_Actual
*  24	ULONG	 io_Length
*  28	APTR	 io_Data
*  2C	ULONG	 io_Offset
*  30
*/
	{io_PExtFlags}	pextflags	:ULONG	 /* (not used) flag extension area */
	{io_Status}	parstatus	:UBYTE	 /* status of parallel port and registers */
	{io_ParFlags}	parflags	:UBYTE	 /* see PARFLAGS bit definitions below */
	{io_PTermArray}	ptermarray	:ioparray /* termination character array */
ENDOBJECT

NATIVE {PARB_SHARED}	CONST PARB_SHARED	= 5	   /* ParFlags non-exclusive access bit */
NATIVE {PARF_SHARED}	CONST PARF_SHARED	= $20	   /*	 "     non-exclusive access mask */
NATIVE {PARB_SLOWMODE}	CONST PARB_SLOWMODE	= 4	   /*	 "     slow printer bit */
NATIVE {PARF_SLOWMODE}	CONST PARF_SLOWMODE	= $10	   /*	 "     slow printer mask */
NATIVE {PARB_FASTMODE}	CONST PARB_FASTMODE	= 3	   /*	 "     fast I/O mode selected bit */
NATIVE {PARF_FASTMODE}	CONST PARF_FASTMODE	= $8	   /*	 "     fast I/O mode selected mask */
NATIVE {PARB_RAD_BOOGIE}	CONST PARB_RAD_BOOGIE	= 3	   /*	 "     for backward compatibility */
NATIVE {PARF_RAD_BOOGIE}	CONST PARF_RAD_BOOGIE	= $8	   /*	 "     for backward compatibility */

NATIVE {PARB_ACKMODE}	CONST PARB_ACKMODE	= 2	   /*	 "     ACK interrupt handshake bit */
NATIVE {PARF_ACKMODE}	CONST PARF_ACKMODE	= $4	   /*	 "     ACK interrupt handshake mask */

NATIVE {PARB_EOFMODE}	CONST PARB_EOFMODE	= 1	   /*	 "     EOF mode enabled bit */
NATIVE {PARF_EOFMODE}	CONST PARF_EOFMODE	= $2	   /*	 "     EOF mode enabled mask */

NATIVE {IOPARB_QUEUED}	CONST IOPARB_QUEUED	= 6	   /* IO_FLAGS rqst-queued bit */
NATIVE {IOPARF_QUEUED}	CONST IOPARF_QUEUED	= $40	   /*	 "     rqst-queued mask */
NATIVE {IOPARB_ABORT}	CONST IOPARB_ABORT	= 5	   /*	 "     rqst-aborted bit */
NATIVE {IOPARF_ABORT}	CONST IOPARF_ABORT	= $20	   /*	 "     rqst-aborted mask */
NATIVE {IOPARB_ACTIVE}	CONST IOPARB_ACTIVE	= 4	   /*	 "     rqst-qued-or-current bit */
NATIVE {IOPARF_ACTIVE}	CONST IOPARF_ACTIVE	= $10	   /*	 "     rqst-qued-or-current mask */
NATIVE {IOPTB_RWDIR}	CONST IOPTB_RWDIR	= 3	   /* IO_STATUS read=0,write=1 bit */
NATIVE {IOPTF_RWDIR}	CONST IOPTF_RWDIR	= $8	   /*	 "     read=0,write=1 mask */
NATIVE {IOPTB_PARSEL}	CONST IOPTB_PARSEL	= 2	   /*	 "     printer selected on the A1000 */
NATIVE {IOPTF_PARSEL}	CONST IOPTF_PARSEL	= $4	   /* printer selected & serial "Ring Indicator"
				      on the A500 & A2000.  Be careful when
				      making cables */
NATIVE {IOPTB_PAPEROUT} CONST IOPTB_PAPEROUT = 1	   /*	 "     paper out bit */
NATIVE {IOPTF_PAPEROUT} CONST IOPTF_PAPEROUT = $2	   /*	 "     paper out mask */
NATIVE {IOPTB_PARBUSY}  CONST IOPTB_PARBUSY  = 0	   /*	 "     printer in busy toggle bit */
NATIVE {IOPTF_PARBUSY}  CONST IOPTF_PARBUSY  = $1	   /*	 "     printer in busy toggle mask */
/* Note: previous versions of this include files had bits 0 and 2 swapped */

NATIVE {PARALLELNAME}		CONST
#define PARALLELNAME parallelname
STATIC parallelname		= 'parallel.device'

NATIVE {PDCMD_QUERY}		CONST PDCMD_QUERY		= (CMD_NONSTD)
NATIVE {PDCMD_SETPARAMS}	CONST PDCMD_SETPARAMS	= (CMD_NONSTD+1)

NATIVE {ParErr_DevBusy}			CONST PARERR_DEVBUSY			= 1
NATIVE {ParErr_BufTooBig}	CONST PARERR_BUFTOOBIG	= 2
NATIVE {ParErr_InvParam}	CONST PARERR_INVPARAM	= 3
NATIVE {ParErr_LineErr}		CONST PARERR_LINEERR		= 4
NATIVE {ParErr_NotOpen}		CONST PARERR_NOTOPEN		= 5
NATIVE {ParErr_PortReset}	CONST PARERR_PORTRESET	= 6
NATIVE {ParErr_InitErr}			CONST PARERR_INITERR			= 7
