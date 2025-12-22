;
; ** $VER: serial.h 33.6 (6.11.90)
; ** Includes Release 40.15
; **
; ** external declarations for the serial device
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;


IncludePath   "PureInclude:"
XIncludeFile "exec/io.pb"

     ;  array of termination char's
     ;  to use,see serial.doc setparams

Structure  IOTArray
 TermArray0.l
 TermArray1.l
EndStructure


#SER_DEFAULT_CTLCHAR = $11130000 ;  default chars for xON,xOFF
;  You may change these via SETPARAMS. At this time, parity is not
;    calculated for xON/xOFF characters. You must supply them with the
;    desired parity.

; ****************************************************************
;  CAUTION !!  IF YOU ACCESS the serial.device, you MUST (!!!!) use an
;    IOExtSer-sized structure or you may overlay innocent memory !!
; ****************************************************************

 Structure  IOExtSer
 IOSer.IOStdReq

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
; *
; *  30
   io_CtlChar.l   ;  control char's (order = xON,xOFF,INQ,ACK)
   io_RBufLen.l   ;  length in bytes of serial port's read buffer
   io_ExtFlags.l   ;  additional serial flags (see bitdefs below)
   io_Baud.l   ;  baud rate requested (true baud)
   io_BrkTime.l   ;  duration of break signal in MICROseconds
   io_TermArray.IOTArray ;  termination character array
   io_ReadLen.b   ;  bits per read character (# of bits)
   io_WriteLen.b   ;  bits per write character (# of bits)
   io_StopBits.b   ;  stopbits for read (# of bits)
   io_SerFlags.b   ;  see SerFlags bit definitions below
   io_Status.w
EndStructure
   ;  status of serial port, as follows:
; *     BIT ACTIVE FUNCTION
; *      0  --- reserved
; *      1  --- reserved
; *      2  high Connected to parallel "select" on the A1000.
; *    Connected to both the parallel "select" and
; *    serial "ring indicator" pins on the A500
; *    & A2000.  Take care when making cables.
; *      3  low Data Set Ready
; *      4  low Clear To Send
; *      5  low Carrier Detect
; *      6  low Ready To Send
; *      7  low Data Terminal Ready
; *      8  high read overrun
; *      9  high break sent
; *     10  high break received
; *     11  high transmit x-OFFed
; *     12  high receive x-OFFed
; *  13-15  reserved
;

#SDCMD_QUERY   = #CMD_NONSTD  ; $09 */
#SDCMD_BREAK     =   (#CMD_NONSTD+1) ; $0A */
#SDCMD_SETPARAMS  =    (#CMD_NONSTD+2) ; $0B */


#SERB_XDISABLED = 7 ; io_SerFlags xOn-xOff feature disabled bit */
#SERF_XDISABLED = (1  <<  7)  ;    "     xOn-xOff feature disabled mask */
#SERB_EOFMODE  =6 ;    "     EOF mode enabled bit */
#SERF_EOFMODE = (1  <<  6)  ;    "     EOF mode enabled mask */
#SERB_SHARED =5 ;    "     non-exclusive access bit */
#SERF_SHARED =(1  <<  5)  ;    "     non-exclusive access mask */
#SERB_RAD_BOOGIE =4 ;    "     high-speed mode active bit */
#SERF_RAD_BOOGIE =(1  <<  4)  ;    "     high-speed mode active mask */
#SERB_QUEUEDBRK  =3 ;    "     queue this Break ioRqst */
#SERF_QUEUEDBRK  =(1  <<  3)  ;    "     queue this Break ioRqst */
#SERB_7WIRE  =2 ;    "     RS232 7-wire protocol */
#SERF_7WIRE  =(1  <<  2)  ;    "     RS232 7-wire protocol */
#SERB_PARTY_ODD = 1 ;    "     parity feature enabled bit */
#SERF_PARTY_ODD = (1  <<  1)  ;    "     parity feature enabled mask */
#SERB_PARTY_ON =0 ;    "     parity-enabled bit */
#SERF_PARTY_ON =(1  <<  0)  ;    "     parity-enabled mask */

; These now refect the actual bit positions in the io_Status UWORD */
#IO_STATB_XOFFREAD =12     ; io_Status receive currently xOFF'ed bit */
#IO_STATF_XOFFREAD =(1  <<  12)  ;  "     receive currently xOFF'ed mask */
#IO_STATB_XOFFWRITE= 11    ;  "     transmit currently xOFF'ed bit */
#IO_STATF_XOFFWRITE= (1  <<  11) ;  "     transmit currently xOFF'ed mask */
#IO_STATB_READBREAK= 10    ;  "     break was latest input bit */
#IO_STATF_READBREAK= (1  <<  10) ;  "     break was latest input mask */
#IO_STATB_WROTEBREAK =9    ;  "     break was latest output bit */
#IO_STATF_WROTEBREAK =(1  <<  9) ;  "     break was latest output mask */
#IO_STATB_OVERRUN =8     ;  "     status word RBF overrun bit */
#IO_STATF_OVERRUN =(1  <<  8)    ;  "     status word RBF overrun mask */


#SEXTB_MSPON =1 ; io_ExtFlags. Use mark-space parity, */
        ;      instead of odd-Even. */
#SEXTF_MSPON =(1  <<  1)  ;    "     mark-space parity mask */
#SEXTB_MARK  =0 ;    "     if mark-space, use mark */
#SEXTF_MARK  =(1  <<  0)  ;    "     if mark-space, use mark mask */


#SerErr_DevBusy      =   1
#SerErr_BaudMismatch =   2 ; baud rate NOT supported by hardware */
#SerErr_BufErr       = 4 ; Failed To allocate new Read Buffer */
#SerErr_InvParam     =   5
#SerErr_LineErr      =   6
#SerErr_ParityErr    =   9
#SerErr_TimerErr     =  11 ;(See the serial/OpenDevice autodoc)*/
#SerErr_BufOverflow  =  12
#SerErr_NoDSR        =13
#SerErr_DetectedBreak=  15


#SerErr_InvBaud      =   3  ; unused */
#SerErr_NotOpen      =   7  ; unused */
#SerErr_PortReset    =   8  ; unused */
#SerErr_InitErr      =  10  ; unused */
#SerErr_NoCTS        = 14  ; unused */

; These defines refer To the HIGH ORDER byte of io_Status.  They have
;   been replaced by the new, corrected ones above */
#IOSTB_XOFFREAD = 4 ; iost_hob receive currently xOFF'ed bit */
#IOSTF_XOFFREAD = (1  <<  4)  ;    "     receive currently xOFF'ed mask */
#IOSTB_XOFFWRITE= 3 ;    "     transmit currently xOFF'ed bit */
#IOSTF_XOFFWRITE= (1  <<  3)  ;    "     transmit currently xOFF'ed mask */
#IOSTB_READBREAK= 2 ;    "     break was latest input bit */
#IOSTF_READBREAK= (1  <<  2)  ;    "     break was latest input mask */
#IOSTB_WROTEBREAK= 1  ;    "     break was latest output bit */
#IOSTF_WROTEBREAK= (1  <<  1) ;    "     break was latest output mask */
#IOSTB_OVERRUN =0 ;    "     status word RBF overrun bit */
#IOSTF_OVERRUN =(1  <<  0)  ;    "     status word RBF overrun mask */

#IOSERB_BUFRREAD= 7 ; io_Flags from Read Buffer bit */
#IOSERF_BUFRREAD= (1  <<  7)  ;    "     from read buffer mask */
#IOSERB_QUEUED =6 ;    "     rqst-queued bit */
#IOSERF_QUEUED =(1  <<  6)  ;    "     rqst-queued mask */
#IOSERB_ABORT  =5 ;    "     rqst-aborted bit */
#IOSERF_ABORT  =(1  <<  5)  ;    "     rqst-aborted mask */
#IOSERB_ACTIVE =4 ;    "     rqst-qued-or-current bit */
#IOSERF_ACTIVE =(1  <<  4)  ;    "     rqst-qued-or-current mask */

;#SERIALNAME     "serial.device"

