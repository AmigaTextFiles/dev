@DATABASE "gg:doc/NDK/Guide/Include/devices/parallel.h"
@MASTER   "gg:os-include/devices/parallel.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:31
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/parallel.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/parallel.h" LINK File}


@{b}Structures@{ub}

@{"IOExtPar" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 27}  @{"IOPArray" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 17}


@{b}#defines@{ub}

@{"IOPARB_ABORT" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 74}     @{"IOPARB_ACTIVE" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 76}     @{"IOPARB_QUEUED" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 72}    @{"IOPARF_ABORT" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 75}
@{"IOPARF_ACTIVE" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 77}    @{"IOPARF_QUEUED" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 73}     @{"IOPTB_PAPEROUT" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 84}   @{"IOPTB_PARBUSY" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 86}
@{"IOPTB_PARSEL" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 80}     @{"IOPTB_RWDIR" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 78}       @{"IOPTF_PAPEROUT" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 85}   @{"IOPTF_PARBUSY" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 87}
@{"IOPTF_PARSEL" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 81}     @{"IOPTF_RWDIR" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 79}       @{"PARALLELNAME" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 90}     @{"PARB_ACKMODE" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 66}
@{"PARB_EOFMODE" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 69}     @{"PARB_FASTMODE" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 61}     @{"PARB_RAD_BOOGIE" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 63}  @{"PARB_SHARED" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 57}
@{"PARB_SLOWMODE" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 59}    @{"ParErr_BufTooBig" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 96}  @{"ParErr_DevBusy" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 95}   @{"ParErr_InitErr" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 101}
@{"ParErr_InvParam" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 97}  @{"ParErr_LineErr" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 98}    @{"ParErr_NotOpen" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 99}   @{"ParErr_PortReset" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 100}
@{"PARF_ACKMODE" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 67}     @{"PARF_EOFMODE" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 70}      @{"PARF_FASTMODE" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 62}    @{"PARF_RAD_BOOGIE" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 64}
@{"PARF_SHARED" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 58}      @{"PARF_SLOWMODE" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 60}     @{"PDCMD_QUERY" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 92}      @{"PDCMD_SETPARAMS" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 93}

@ENDNODE
@NODE File "devices/parallel.h"
#ifndef DEVICES_PARALLEL_H
#define DEVICES_PARALLEL_H
/*
**      $VER: parallel.h 36.1 (10.5.1990)
**      Includes Release 45.1
**
**      @{"parallel.device" LINK "gg:doc/NDK/Guide/parallel/MAIN"} I/O request structure information
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All rights reserved.
*/

#ifndef   EXEC_IO_H
#include <@{"exec/io.h" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File"}>
#endif   /* !EXEC_IO_H */

struct IOPArray {
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} PTermArray0;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} PTermArray1;
};

/******************************************************************/
/* CAUTION !!  IF YOU ACCESS the @{"parallel.device" LINK "gg:doc/NDK/Guide/parallel/MAIN"}, you MUST (!!!!) use
   an IOExtPar-sized structure or you may overlay innocent memory !! */
/******************************************************************/

struct IOExtPar {
        @{"struct   IOStdReq" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 27} IOPar;

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
*  1F   @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}    io_Error
*     STRUCT   IOStdExt
*  20   @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}    io_Actual
*  24   @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}    io_Length
*  28   @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}     io_Data
*  2C   @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}    io_Offset
*  30
*/
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   io_PExtFlags;    /* (not used) flag extension area */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   io_Status;       /* status of parallel port and registers */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   io_ParFlags;     /* see PARFLAGS bit definitions below */
        @{"struct  IOPArray" LINK File 17} io_PTermArray; /* termination character array */
};

#define PARB_SHARED     5          /* ParFlags non-exclusive access bit */
#define PARF_SHARED     (1<<5)     /*    "     non-exclusive access mask */
#define PARB_SLOWMODE   4          /*    "     slow printer bit */
#define PARF_SLOWMODE   (1<<4)     /*    "     slow printer mask */
#define PARB_FASTMODE   3          /*    "     fast I/O mode selected bit */
#define PARF_FASTMODE   (1<<3)     /*    "     fast I/O mode selected mask */
#define PARB_RAD_BOOGIE 3          /*    "     for backward compatibility */
#define PARF_RAD_BOOGIE (1<<3)     /*    "     for backward compatibility */

#define PARB_ACKMODE    2          /*    "     ACK interrupt handshake bit */
#define PARF_ACKMODE    (1<<2)     /*    "     ACK interrupt handshake mask */

#define PARB_EOFMODE    1          /*    "     EOF mode enabled bit */
#define PARF_EOFMODE    (1<<1)     /*    "     EOF mode enabled mask */

#define IOPARB_QUEUED   6          /* IO_FLAGS rqst-queued bit */
#define IOPARF_QUEUED   (1<<6)     /*    "     rqst-queued mask */
#define IOPARB_ABORT    5          /*    "     rqst-aborted bit */
#define IOPARF_ABORT    (1<<5)     /*    "     rqst-aborted mask */
#define IOPARB_ACTIVE   4          /*    "     rqst-qued-or-current bit */
#define IOPARF_ACTIVE   (1<<4)     /*    "     rqst-qued-or-current mask */
#define IOPTB_RWDIR     3          /* IO_STATUS read=0,write=1 bit */
#define IOPTF_RWDIR     (1<<3)     /*    "     read=0,write=1 mask */
#define IOPTB_PARSEL    2          /*    "     printer selected on the A1000 */
#define IOPTF_PARSEL    (1<<2)     /* printer selected & serial "Ring Indicator"
                                      on the A500 & A2000.  Be careful when
                                      making cables */
#define IOPTB_PAPEROUT 1           /*    "     paper out bit */
#define IOPTF_PAPEROUT (1<<1)      /*    "     paper out mask */
#define IOPTB_PARBUSY  0           /*    "     printer in busy toggle bit */
#define IOPTF_PARBUSY  (1<<0)      /*    "     printer in busy toggle mask */
/* Note: previous versions of this include files had bits 0 and 2 swapped */

#define PARALLELNAME            "parallel.device"

#define @{"PDCMD_QUERY" LINK "gg:doc/NDK/Guide/parallel/PDCMD_QUERY"}             (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59})
#define @{"PDCMD_SETPARAMS" LINK "gg:doc/NDK/Guide/parallel/PDCMD_SETPARAMS"} (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+1)

#define ParErr_DevBusy                  1
#define ParErr_BufTooBig        2
#define ParErr_InvParam 3
#define ParErr_LineErr          4
#define ParErr_NotOpen          5
#define ParErr_PortReset        6
#define ParErr_InitErr                  7

#endif  /* DEVICES_PARALLEL_H */
@ENDNODE
