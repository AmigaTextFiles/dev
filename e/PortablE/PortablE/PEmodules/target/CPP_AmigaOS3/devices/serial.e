/* $VER: serial.h 33.6 (6.11.1990) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/io'
MODULE 'target/exec/types'
{
#define DEVICES_SERIAL_H_OBSOLETE
#include <devices/serial.h>
}
NATIVE {DEVICES_SERIAL_H} CONST
NATIVE {DEVICES_SERIAL_H_OBSOLETE} CONST
#define DEVICES_SERIAL_H_OBSOLETE

		   /* array of termination char's */
		   /* to use,see serial.doc setparams */

NATIVE {IOTArray} OBJECT termarray
	{TermArray0}	ta0	:ULONG
	{TermArray1}	ta1	:ULONG
ENDOBJECT


NATIVE {SER_DEFAULT_CTLCHAR} CONST SER_DEFAULT_CTLCHAR = $11130000	/* default chars for xON,xOFF */
/* You may change these via SETPARAMS.	At this time, parity is not
   calculated for xON/xOFF characters.	You must supply them with the
   desired parity. */

/******************************************************************/
/* CAUTION !!  IF YOU ACCESS the serial.device, you MUST (!!!!) use an
   IOExtSer-sized structure or you may overlay innocent memory !! */
/******************************************************************/

NATIVE {IOExtSer} OBJECT ioextser
	{IOSer}	iostd	:iostd

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
*  1F	BYTE	 io_Error
*     STRUCT   IOStdExt
*  20	ULONG	 io_Actual
*  24	ULONG	 io_Length
*  28	APTR	 io_Data
*  2C	ULONG	 io_Offset
*
*  30
*/

   {io_CtlChar}	ctlchar	:ULONG	  /* control char's (order = xON,xOFF,INQ,ACK) */
   {io_RBufLen}	rbuflen	:ULONG	  /* length in bytes of serial port's read buffer */
   {io_ExtFlags}	extflags	:ULONG   /* additional serial flags (see bitdefs below) */
   {io_Baud}	baud	:ULONG	  /* baud rate requested (true baud) */
   {io_BrkTime}	brktime	:ULONG	  /* duration of break signal in MICROseconds */
   {io_TermArray}	termarray	:termarray /* termination character array */
   {io_ReadLen}	readlen	:UBYTE	  /* bits per read character (# of bits) */
   {io_WriteLen}	writelen	:UBYTE   /* bits per write character (# of bits) */
   {io_StopBits}	stopbits	:UBYTE   /* stopbits for read (# of bits) */
   {io_SerFlags}	serflags	:UBYTE   /* see SerFlags bit definitions below  */
   {io_Status}	status	:UINT
ENDOBJECT

/* status of serial port, as follows:
*		   BIT	ACTIVE	FUNCTION
*		    0	 ---	reserved
*		    1	 ---	reserved
*		    2	 high	Connected to parallel "select" on the A1000.
*				Connected to both the parallel "select" and
*				serial "ring indicator" pins on the A500
*				& A2000.  Take care when making cables.
*		    3	 low	Data Set Ready
*		    4	 low	Clear To Send
*		    5	 low	Carrier Detect
*		    6	 low	Ready To Send
*		    7	 low	Data Terminal Ready
*		    8	 high	read overrun
*		    9	 high	break sent
*		   10	 high	break received
*		   11	 high	transmit x-OFFed
*		   12	 high	receive x-OFFed
*		13-15		reserved
*/

NATIVE {SDCMD_QUERY}		CONST SDCMD_QUERY		= CMD_NONSTD	/* $09 */
NATIVE {SDCMD_BREAK}	       CONST SDCMD_BREAK	       = (CMD_NONSTD+1)	/* $0A */
NATIVE {SDCMD_SETPARAMS}      CONST SDCMD_SETPARAMS      = (CMD_NONSTD+2)	/* $0B */


NATIVE {SERB_XDISABLED}	CONST SERB_XDISABLED	= 7	/* io_SerFlags xOn-xOff feature disabled bit */
NATIVE {SERF_XDISABLED}	CONST SERF_XDISABLED	= $80	/*    "     xOn-xOff feature disabled mask */
NATIVE {SERB_EOFMODE}	CONST SERB_EOFMODE	= 6	/*    "     EOF mode enabled bit */
NATIVE {SERF_EOFMODE}	CONST SERF_EOFMODE	= $40	/*    "     EOF mode enabled mask */
NATIVE {SERB_SHARED}	CONST SERB_SHARED	= 5	/*    "     non-exclusive access bit */
NATIVE {SERF_SHARED}	CONST SERF_SHARED	= $20	/*    "     non-exclusive access mask */
NATIVE {SERB_RAD_BOOGIE} CONST SERB_RAD_BOOGIE = 4	/*    "     high-speed mode active bit */
NATIVE {SERF_RAD_BOOGIE} CONST SERF_RAD_BOOGIE = $10	/*    "     high-speed mode active mask */
NATIVE {SERB_QUEUEDBRK}	CONST SERB_QUEUEDBRK	= 3	/*    "     queue this Break ioRqst */
NATIVE {SERF_QUEUEDBRK}	CONST SERF_QUEUEDBRK	= $8	/*    "     queue this Break ioRqst */
NATIVE {SERB_7WIRE}	CONST SERB_7WIRE	= 2	/*    "     RS232 7-wire protocol */
NATIVE {SERF_7WIRE}	CONST SERF_7WIRE	= $4	/*    "     RS232 7-wire protocol */
NATIVE {SERB_PARTY_ODD}	CONST SERB_PARTY_ODD	= 1	/*    "     parity feature enabled bit */
NATIVE {SERF_PARTY_ODD}	CONST SERF_PARTY_ODD	= $2	/*    "     parity feature enabled mask */
NATIVE {SERB_PARTY_ON}	CONST SERB_PARTY_ON	= 0	/*    "     parity-enabled bit */
NATIVE {SERF_PARTY_ON}	CONST SERF_PARTY_ON	= $1	/*    "     parity-enabled mask */

/* These now refect the actual bit positions in the io_Status UWORD */
NATIVE {IO_STATB_XOFFREAD} CONST IO_STATB_XOFFREAD = 12	   /* io_Status receive currently xOFF'ed bit */
NATIVE {IO_STATF_XOFFREAD} CONST IO_STATF_XOFFREAD = $1000  /*	 "     receive currently xOFF'ed mask */
NATIVE {IO_STATB_XOFFWRITE} CONST IO_STATB_XOFFWRITE = 11	   /*	 "     transmit currently xOFF'ed bit */
NATIVE {IO_STATF_XOFFWRITE} CONST IO_STATF_XOFFWRITE = $800 /*	 "     transmit currently xOFF'ed mask */
NATIVE {IO_STATB_READBREAK} CONST IO_STATB_READBREAK = 10	   /*	 "     break was latest input bit */
NATIVE {IO_STATF_READBREAK} CONST IO_STATF_READBREAK = $400 /*	 "     break was latest input mask */
NATIVE {IO_STATB_WROTEBREAK} CONST IO_STATB_WROTEBREAK = 9	   /*	 "     break was latest output bit */
NATIVE {IO_STATF_WROTEBREAK} CONST IO_STATF_WROTEBREAK = $200 /*	 "     break was latest output mask */
NATIVE {IO_STATB_OVERRUN} CONST IO_STATB_OVERRUN = 8	   /*	 "     status word RBF overrun bit */
NATIVE {IO_STATF_OVERRUN} CONST IO_STATF_OVERRUN = $100	   /*	 "     status word RBF overrun mask */


NATIVE {SEXTB_MSPON}	CONST SEXTB_MSPON	= 1	/* io_ExtFlags. Use mark-space parity, */
				/*	    instead of odd-even. */
NATIVE {SEXTF_MSPON}	CONST SEXTF_MSPON	= $2	/*    "     mark-space parity mask */
NATIVE {SEXTB_MARK}	CONST SEXTB_MARK	= 0	/*    "     if mark-space, use mark */
NATIVE {SEXTF_MARK}	CONST SEXTF_MARK	= $1	/*    "     if mark-space, use mark mask */


NATIVE {SerErr_DevBusy}	       CONST SERERR_DEVBUSY	       = 1
NATIVE {SerErr_BaudMismatch}    CONST SERERR_BAUDMISMATCH    = 2 /* baud rate not supported by hardware */
NATIVE {SerErr_BufErr}	       CONST SERERR_BUFERR	       = 4 /* Failed to allocate new read buffer */
NATIVE {SerErr_InvParam}        CONST SERERR_INVPARAM        = 5
NATIVE {SerErr_LineErr}	       CONST SERERR_LINEERR	       = 6
NATIVE {SerErr_ParityErr}       CONST SERERR_PARITYERR       = 9
NATIVE {SerErr_TimerErr}       CONST SERERR_TIMERERR       = 11 /*(See the serial/OpenDevice autodoc)*/
NATIVE {SerErr_BufOverflow}    CONST SERERR_BUFOVERFLOW    = 12
NATIVE {SerErr_NoDSR}	      CONST SERERR_NODSR	      = 13
NATIVE {SerErr_DetectedBreak}  CONST SERERR_DETECTEDBREAK  = 15


#ifdef DEVICES_SERIAL_H_OBSOLETE
NATIVE {SerErr_InvBaud}	       CONST SERERR_INVBAUD	       = 3	/* unused */
NATIVE {SerErr_NotOpen}	       CONST SERERR_NOTOPEN	       = 7	/* unused */
NATIVE {SerErr_PortReset}       CONST SERERR_PORTRESET       = 8	/* unused */
NATIVE {SerErr_InitErr}	      CONST SERERR_INITERR	      = 10	/* unused */
NATIVE {SerErr_NoCTS}	      CONST SERERR_NOCTS	      = 14	/* unused */

/* These defines refer to the HIGH ORDER byte of io_Status.  They have
   been replaced by the new, corrected ones above */
NATIVE {IOSTB_XOFFREAD}	CONST IOSTB_XOFFREAD	= 4	/* iost_hob receive currently xOFF'ed bit */
NATIVE {IOSTF_XOFFREAD}	CONST IOSTF_XOFFREAD	= $10	/*    "     receive currently xOFF'ed mask */
NATIVE {IOSTB_XOFFWRITE} CONST IOSTB_XOFFWRITE = 3	/*    "     transmit currently xOFF'ed bit */
NATIVE {IOSTF_XOFFWRITE} CONST IOSTF_XOFFWRITE = $8	/*    "     transmit currently xOFF'ed mask */
NATIVE {IOSTB_READBREAK} CONST IOSTB_READBREAK = 2	/*    "     break was latest input bit */
NATIVE {IOSTF_READBREAK} CONST IOSTF_READBREAK = $4	/*    "     break was latest input mask */
NATIVE {IOSTB_WROTEBREAK} CONST IOSTB_WROTEBREAK = 1	/*    "     break was latest output bit */
NATIVE {IOSTF_WROTEBREAK} CONST IOSTF_WROTEBREAK = $2 /*    "     break was latest output mask */
NATIVE {IOSTB_OVERRUN}	CONST IOSTB_OVERRUN	= 0	/*    "     status word RBF overrun bit */
NATIVE {IOSTF_OVERRUN}	CONST IOSTF_OVERRUN	= $1	/*    "     status word RBF overrun mask */

NATIVE {IOSERB_BUFRREAD} CONST IOSERB_BUFRREAD = 7	/* io_Flags from read buffer bit */
NATIVE {IOSERF_BUFRREAD} CONST IOSERF_BUFRREAD = $80	/*    "     from read buffer mask */
NATIVE {IOSERB_QUEUED}	CONST IOSERB_QUEUED	= 6	/*    "     rqst-queued bit */
NATIVE {IOSERF_QUEUED}	CONST IOSERF_QUEUED	= $40	/*    "     rqst-queued mask */
NATIVE {IOSERB_ABORT}	CONST IOSERB_ABORT	= 5	/*    "     rqst-aborted bit */
NATIVE {IOSERF_ABORT}	CONST IOSERF_ABORT	= $20	/*    "     rqst-aborted mask */
NATIVE {IOSERB_ACTIVE}	CONST IOSERB_ACTIVE	= 4	/*    "     rqst-qued-or-current bit */
NATIVE {IOSERF_ACTIVE}	CONST IOSERF_ACTIVE	= $10	/*    "     rqst-qued-or-current mask */
#undefine DEVICES_SERIAL_H_OBSOLETE
#endif

NATIVE {SERIALNAME}     CONST
#define SERIALNAME serialname
STATIC serialname     = 'serial.device'
