@DATABASE "gg:doc/NDK/Guide/Include/devices/serial.h"
@MASTER   "gg:os-include/devices/serial.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:42
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/serial.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/serial.h" LINK File}


@{b}Structures@{ub}

@{"IOExtSer" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 36}  @{"IOTArray" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 20}


@{b}#defines@{ub}

@{"IO_STATB_OVERRUN" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 127}    @{"IO_STATB_READBREAK" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 123}    @{"IO_STATB_WROTEBREAK" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 125}
@{"IO_STATB_XOFFREAD" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 119}   @{"IO_STATB_XOFFWRITE" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 121}    @{"IO_STATF_OVERRUN" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 128}
@{"IO_STATF_READBREAK" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 124}  @{"IO_STATF_WROTEBREAK" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 126}   @{"IO_STATF_XOFFREAD" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 120}
@{"IO_STATF_XOFFWRITE" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 122}  @{"IOSERB_ABORT" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 174}          @{"IOSERB_ACTIVE" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 176}
@{"IOSERB_BUFRREAD" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 170}     @{"IOSERB_QUEUED" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 172}         @{"IOSERF_ABORT" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 175}
@{"IOSERF_ACTIVE" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 177}       @{"IOSERF_BUFRREAD" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 171}       @{"IOSERF_QUEUED" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 173}
@{"IOSTB_OVERRUN" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 167}       @{"IOSTB_READBREAK" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 163}       @{"IOSTB_WROTEBREAK" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 165}
@{"IOSTB_XOFFREAD" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 159}      @{"IOSTB_XOFFWRITE" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 161}       @{"IOSTF_OVERRUN" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 168}
@{"IOSTF_READBREAK" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 164}     @{"IOSTF_WROTEBREAK" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 166}      @{"IOSTF_XOFFREAD" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 160}
@{"IOSTF_XOFFWRITE" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 162}     @{"SDCMD_BREAK" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 97}           @{"SDCMD_QUERY" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 96}
@{"SDCMD_SETPARAMS" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 98}     @{"SER_DEFAULT_CTLCHAR" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 26}   @{"SERB_7WIRE" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 111}
@{"SERB_EOFMODE" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 103}        @{"SERB_PARTY_ODD" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 113}        @{"SERB_PARTY_ON" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 115}
@{"SERB_QUEUEDBRK" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 109}      @{"SERB_RAD_BOOGIE" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 107}       @{"SERB_SHARED" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 105}
@{"SERB_XDISABLED" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 101}      @{"SerErr_BaudMismatch" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 139}   @{"SerErr_BufErr" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 140}
@{"SerErr_BufOverflow" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 145}  @{"SerErr_DetectedBreak" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 147}  @{"SerErr_DevBusy" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 138}
@{"SerErr_InitErr" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 154}      @{"SerErr_InvBaud" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 151}        @{"SerErr_InvParam" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 141}
@{"SerErr_LineErr" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 142}      @{"SerErr_NoCTS" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 155}          @{"SerErr_NoDSR" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 146}
@{"SerErr_NotOpen" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 152}      @{"SerErr_ParityErr" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 143}      @{"SerErr_PortReset" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 153}
@{"SerErr_TimerErr" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 144}     @{"SERF_7WIRE" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 112}            @{"SERF_EOFMODE" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 104}
@{"SERF_PARTY_ODD" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 114}      @{"SERF_PARTY_ON" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 116}         @{"SERF_QUEUEDBRK" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 110}
@{"SERF_RAD_BOOGIE" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 108}     @{"SERF_SHARED" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 106}           @{"SERF_XDISABLED" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 102}
@{"SERIALNAME" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 180}          @{"SEXTB_MARK" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 134}            @{"SEXTB_MSPON" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 131}
@{"SEXTF_MARK" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 135}          @{"SEXTF_MSPON" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 133}           

@ENDNODE
@NODE File "devices/serial.h"
#ifndef DEVICES_SERIAL_H
#define DEVICES_SERIAL_H
/*
**      $VER: serial.h 33.6 (6.11.1990)
**      Includes Release 45.1
**
**      external declarations for the serial device
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef   EXEC_IO_H
#include <@{"exec/io.h" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File"}>
#endif /* EXEC_IO_H */

                   /* array of termination char's */
                   /* to use,see serial.doc setparams */

struct IOTArray {
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} TermArray0;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} TermArray1;
};


#define SER_DEFAULT_CTLCHAR 0x11130000  /* default chars for xON,xOFF */
/* You may change these via SETPARAMS.  At this time, parity is not
   calculated for xON/xOFF characters.  You must supply them with the
   desired parity. */

/******************************************************************/
/* CAUTION !!  IF YOU ACCESS the @{"serial.device" LINK "gg:doc/NDK/Guide/serial/MAIN"}, you MUST (!!!!) use an
   IOExtSer-sized structure or you may overlay innocent memory !! */
/******************************************************************/

struct IOExtSer {
        @{"struct   IOStdReq" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 27} IOSer;

/*     STRUCT   MsgNode
*   0   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     Succ
*   4   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     Pred
*   8   @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}    Type
*   9   @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}    Pri
*   A   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     Name
*   E   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     ReplyPort
*  12   @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}    MNLength
*     STRUCT   IOExt
*  14   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     io_Device
*  18   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     io_Unit
*  1C   @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}    io_Command
*  1E   @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}    io_Flags
*  1F   @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}     io_Error
*     STRUCT   IOStdExt
*  20   @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}    io_Actual
*  24   @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}    io_Length
*  28   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     io_Data
*  2C   @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}    io_Offset
*
*  30
*/

   @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   io_CtlChar;    /* control char's (order = xON,xOFF,INQ,ACK) */
   @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   io_RBufLen;    /* length in bytes of serial port's read buffer */
   @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   io_ExtFlags;   /* additional serial flags (see bitdefs below) */
   @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   io_Baud;       /* baud rate requested (true baud) */
   @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   io_BrkTime;    /* duration of break signal in MICROseconds */
   @{"struct  IOTArray" LINK File 20} io_TermArray; /* termination character array */
   @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   io_ReadLen;    /* bits per read character (# of bits) */
   @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   io_WriteLen;   /* bits per write character (# of bits) */
   @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   io_StopBits;   /* stopbits for read (# of bits) */
   @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   io_SerFlags;   /* see SerFlags bit definitions below  */
   @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   io_Status;
};

/* status of serial port, as follows:
*                  BIT  ACTIVE  FUNCTION
*                   0    ---    reserved
*                   1    ---    reserved
*                   2    high   Connected to parallel "select" on the A1000.
*                               Connected to both the parallel "select" and
*                               serial "ring indicator" pins on the A500
*                               & A2000.  Take care when making cables.
*                   3    low    Data Set Ready
*                   4    low    Clear To Send
*                   5    low    Carrier Detect
*                   6    low    Ready To Send
*                   7    low    Data Terminal Ready
*                   8    high   read overrun
*                   9    high   break sent
*                  10    high   break received
*                  11    high   transmit x-OFFed
*                  12    high   receive x-OFFed
*               13-15           reserved
*/

#define   @{"SDCMD_QUERY" LINK "gg:doc/NDK/Guide/serial/SDCMD_QUERY"}           @{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}      /* $09 */
#define   @{"SDCMD_BREAK" LINK "gg:doc/NDK/Guide/serial/SDCMD_BREAK"}          (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+1)   /* $0A */
#define   @{"SDCMD_SETPARAMS" LINK "gg:doc/NDK/Guide/serial/SDCMD_SETPARAMS"}      (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+2)   /* $0B */


#define SERB_XDISABLED  7       /* io_SerFlags xOn-xOff feature disabled bit */
#define SERF_XDISABLED  (1<<7)  /*    "     xOn-xOff feature disabled mask */
#define SERB_EOFMODE    6       /*    "     EOF mode enabled bit */
#define SERF_EOFMODE    (1<<6)  /*    "     EOF mode enabled mask */
#define SERB_SHARED     5       /*    "     non-exclusive access bit */
#define SERF_SHARED     (1<<5)  /*    "     non-exclusive access mask */
#define SERB_RAD_BOOGIE 4       /*    "     high-speed mode active bit */
#define SERF_RAD_BOOGIE (1<<4)  /*    "     high-speed mode active mask */
#define SERB_QUEUEDBRK  3       /*    "     queue this Break ioRqst */
#define SERF_QUEUEDBRK  (1<<3)  /*    "     queue this Break ioRqst */
#define SERB_7WIRE      2       /*    "     RS232 7-wire protocol */
#define SERF_7WIRE      (1<<2)  /*    "     RS232 7-wire protocol */
#define SERB_PARTY_ODD  1       /*    "     parity feature enabled bit */
#define SERF_PARTY_ODD  (1<<1)  /*    "     parity feature enabled mask */
#define SERB_PARTY_ON   0       /*    "     parity-enabled bit */
#define SERF_PARTY_ON   (1<<0)  /*    "     parity-enabled mask */

/* These now refect the actual bit positions in the io_Status @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} */
#define IO_STATB_XOFFREAD 12       /* io_Status receive currently xOFF'ed bit */
#define IO_STATF_XOFFREAD (1<<12)  /*    "     receive currently xOFF'ed mask */
#define IO_STATB_XOFFWRITE 11      /*    "     transmit currently xOFF'ed bit */
#define IO_STATF_XOFFWRITE (1<<11) /*    "     transmit currently xOFF'ed mask */
#define IO_STATB_READBREAK 10      /*    "     break was latest input bit */
#define IO_STATF_READBREAK (1<<10) /*    "     break was latest input mask */
#define IO_STATB_WROTEBREAK 9      /*    "     break was latest output bit */
#define IO_STATF_WROTEBREAK (1<<9) /*    "     break was latest output mask */
#define IO_STATB_OVERRUN 8         /*    "     status word RBF overrun bit */
#define IO_STATF_OVERRUN (1<<8)    /*    "     status word RBF overrun mask */


#define SEXTB_MSPON     1       /* io_ExtFlags. Use mark-space parity, */
                                /*          instead of odd-even. */
#define SEXTF_MSPON     (1<<1)  /*    "     mark-space parity mask */
#define SEXTB_MARK      0       /*    "     if mark-space, use mark */
#define SEXTF_MARK      (1<<0)  /*    "     if mark-space, use mark mask */


#define SerErr_DevBusy         1
#define SerErr_BaudMismatch    2 /* baud rate not supported by hardware */
#define SerErr_BufErr          4 /* Failed to allocate new read buffer */
#define SerErr_InvParam        5
#define SerErr_LineErr         6
#define SerErr_ParityErr       9
#define SerErr_TimerErr       11 /*(See the serial/@{"OpenDevice" LINK "gg:doc/NDK/Guide/exec/OpenDevice"} autodoc)*/
#define SerErr_BufOverflow    12
#define SerErr_NoDSR          13
#define SerErr_DetectedBreak  15


#ifdef DEVICES_SERIAL_H_OBSOLETE
#define SerErr_InvBaud         3        /* unused */
#define SerErr_NotOpen         7        /* unused */
#define SerErr_PortReset       8        /* unused */
#define SerErr_InitErr        10        /* unused */
#define SerErr_NoCTS          14        /* unused */

/* These defines refer to the HIGH ORDER byte of io_Status.  They have
   been replaced by the new, corrected ones above */
#define IOSTB_XOFFREAD  4       /* iost_hob receive currently xOFF'ed bit */
#define IOSTF_XOFFREAD  (1<<4)  /*    "     receive currently xOFF'ed mask */
#define IOSTB_XOFFWRITE 3       /*    "     transmit currently xOFF'ed bit */
#define IOSTF_XOFFWRITE (1<<3)  /*    "     transmit currently xOFF'ed mask */
#define IOSTB_READBREAK 2       /*    "     break was latest input bit */
#define IOSTF_READBREAK (1<<2)  /*    "     break was latest input mask */
#define IOSTB_WROTEBREAK 1      /*    "     break was latest output bit */
#define IOSTF_WROTEBREAK (1<<1) /*    "     break was latest output mask */
#define IOSTB_OVERRUN   0       /*    "     status word RBF overrun bit */
#define IOSTF_OVERRUN   (1<<0)  /*    "     status word RBF overrun mask */

#define IOSERB_BUFRREAD 7       /* io_Flags from read buffer bit */
#define IOSERF_BUFRREAD (1<<7)  /*    "     from read buffer mask */
#define IOSERB_QUEUED   6       /*    "     rqst-queued bit */
#define IOSERF_QUEUED   (1<<6)  /*    "     rqst-queued mask */
#define IOSERB_ABORT    5       /*    "     rqst-aborted bit */
#define IOSERF_ABORT    (1<<5)  /*    "     rqst-aborted mask */
#define IOSERB_ACTIVE   4       /*    "     rqst-qued-or-current bit */
#define IOSERF_ACTIVE   (1<<4)  /*    "     rqst-qued-or-current mask */
#endif

#define SERIALNAME     "serial.device"

#endif /* DEVICES_SERIAL_H */
@ENDNODE
