;
; ** $VER: parallel.h 36.1 (10.5.90)
; ** Includes Release 40.15
; **
; ** parallel.device I/O request structure information
; **
; ** (C) Copyright 1985-1993 Commodore Amiga Inc.
; **     All rights reserved.
;

IncludePath   "PureInclude:"
XIncludeFile "exec/io.pb"


Structure  IOPArray
 PTermArray0.l
 PTermArray1.l
EndStructure

; ****************************************************************
;  CAUTION !!  IF YOU ACCESS the parallel.device, you MUST (!!!!) use
;    an IOExtPar-sized structure or you may overlay innocent memory !!
; ****************************************************************

 Structure   IOExtPar
 IOPar.IOStdReq

;      STRUCT MsgNode
; *   0 APTR  Succ
; *   4 APTR  Pred
; *   8 UBYTE  Type
; *   9 UBYTE  Pri
; *   A APTR  Name
; *   E APTR  ReplyPort
; *  12 UWORD  MNLength
; *     STRUCT   IOExt
; *  14 APTR  io_Device
; *  18 APTR  io_Unit
; *  1C UWORD  io_Command
; *  1E UBYTE  io_Flags
; *  1F UBYTE  io_Error
; *     STRUCT   IOStdExt
; *  20 ULONG  io_Actual
; *  24 ULONG  io_Length
; *  28 APTR  io_Data
; *  2C ULONG  io_Offset
; *  30
 io_PExtFlags.l  ;  (not used) flag extension area
 io_Status.b  ;  status of parallel port and registers
 io_ParFlags.b  ;  see PARFLAGS bit definitions below
 io_PTermArray.IOPArray ;  termination character array
EndStructure

#PARB_SHARED = 5    ;  ParFlags non-exclusive access bit
#PARF_SHARED = (1 << 5)    ;   "     non-exclusive access mask
#PARB_SLOWMODE = 4    ;   "     slow printer bit
#PARF_SLOWMODE = (1 << 4)    ;   "     slow printer mask
#PARB_FASTMODE = 3    ;   "     fast I/O mode selected bit
#PARF_FASTMODE = (1 << 3)    ;   "     fast I/O mode selected mask
#PARB_RAD_BOOGIE = 3    ;   "     for backward compatibility
#PARF_RAD_BOOGIE = (1 << 3)    ;   "     for backward compatibility

#PARB_ACKMODE = 2    ;   "     ACK interrupt handshake bit
#PARF_ACKMODE = (1 << 2)    ;   "     ACK interrupt handshake mask

#PARB_EOFMODE = 1    ;   "     EOF mode enabled bit
#PARF_EOFMODE = (1 << 1)    ;   "     EOF mode enabled mask

#IOPARB_QUEUED = 6    ;  IO_FLAGS rqst-queued bit
#IOPARF_QUEUED = (1 << 6)    ;   "     rqst-queued mask
#IOPARB_ABORT = 5    ;   "     rqst-aborted bit
#IOPARF_ABORT = (1 << 5)    ;   "     rqst-aborted mask
#IOPARB_ACTIVE = 4    ;   "     rqst-qued-or-current bit
#IOPARF_ACTIVE = (1 << 4)    ;   "     rqst-qued-or-current mask
#IOPTB_RWDIR = 3    ;  IO_STATUS read=0,write=1 bit
#IOPTF_RWDIR = (1 << 3)    ;   "     read=0,write=1 mask
#IOPTB_PARSEL = 2    ;   "     printer selected on the A1000
#IOPTF_PARSEL = (1 << 2)    ;  printer selected & serial "Ring Indicator"
;           on the A500 & A2000.  Be careful when
;           making cables
#IOPTB_PAPEROUT = 1    ;   "     paper out bit
#IOPTF_PAPEROUT = (1 << 1)    ;   "     paper out mask
#IOPTB_PARBUSY  = 0    ;   "     printer in busy toggle bit
#IOPTF_PARBUSY  = (1 << 0)    ;   "     printer in busy toggle mask
;  Note: previous versions of this include files had bits 0 and 2 swapped

;#PARALLELNAME  = "parallel\device"

#PDCMD_QUERY  = (#CMD_NONSTD)
#PDCMD_SETPARAMS = (#CMD_NONSTD+1)

#ParErr_DevBusy   = 1
#ParErr_BufTooBig = 2
#ParErr_InvParam = 3
#ParErr_LineErr  = 4
#ParErr_NotOpen  = 5
#ParErr_PortReset = 6
#ParErr_InitErr   = 7

