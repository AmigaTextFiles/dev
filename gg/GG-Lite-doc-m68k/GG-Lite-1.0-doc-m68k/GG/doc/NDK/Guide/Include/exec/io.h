@DATABASE "gg:doc/NDK/Guide/Include/exec/io.h"
@MASTER   "gg:os-include/exec/io.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:13
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "exec/io.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"exec/io.h" LINK File}


@{b}Structures@{ub}

@{"IORequest" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 18}  @{"IOStdReq" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 27}


@{b}#defines@{ub}

@{"CMD_CLEAR" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 54}    @{"CMD_FLUSH" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 57}    @{"CMD_INVALID" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 49}  @{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}  @{"CMD_READ" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 51}
@{"CMD_RESET" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 50}    @{"CMD_START" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 56}    @{"CMD_STOP" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 55}     @{"CMD_UPDATE" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 53}  @{"CMD_WRITE" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 52}
@{"DEV_ABORTIO" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 42}  @{"DEV_BEGINIO" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 41}  @{"IOB_QUICK" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 45}    @{"IOF_QUICK" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 46}   

@ENDNODE
@NODE File "exec/io.h"
#ifndef EXEC_IO_H
#define EXEC_IO_H
/*
**      $VER: io.h 39.0 (15.10.1991)
**      Includes Release 45.1
**
**      Message structures used for device communication
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_PORTS_H
#include <@{"exec/ports.h" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File"}>
#endif /* EXEC_PORTS_H */


struct IORequest {
    @{"struct  Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47} io_Message;
    @{"struct  Device" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 24}  *io_Device;     /* device node pointer  */
    @{"struct  Unit" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 31}    *io_Unit;       /* unit (driver private)*/
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   io_Command;     /* device command */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   io_Flags;
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    io_Error;               /* error or warning num */
};

struct IOStdReq {
    @{"struct  Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47} io_Message;
    @{"struct  Device" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 24}  *io_Device;     /* device node pointer  */
    @{"struct  Unit" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 31}    *io_Unit;       /* unit (driver private)*/
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   io_Command;     /* device command */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   io_Flags;
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    io_Error;               /* error or warning num */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   io_Actual;              /* actual number of bytes transferred */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   io_Length;              /* requested number bytes transferred*/
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    io_Data;                /* points to data area */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   io_Offset;              /* offset for block structured devices */
};

/* library vector offsets for device reserved vectors */
#define DEV_BEGINIO     (-30)
#define DEV_ABORTIO     (-36)

/* io_Flags defined bits */
#define IOB_QUICK       0
#define IOF_QUICK       (1<<0)


#define @{"CMD_INVALID" LINK "gg:doc/NDK/Guide/printer/CMD_INVALID"}     0
#define @{"CMD_RESET" LINK "gg:doc/NDK/Guide/audio/CMD_RESET"}       1
#define @{"CMD_READ" LINK "gg:doc/NDK/Guide/audio/CMD_READ"}        2
#define @{"CMD_WRITE" LINK "gg:doc/NDK/Guide/audio/CMD_WRITE"}       3
#define @{"CMD_UPDATE" LINK "gg:doc/NDK/Guide/audio/CMD_UPDATE"}      4
#define @{"CMD_CLEAR" LINK "gg:doc/NDK/Guide/audio/CMD_CLEAR"}       5
#define @{"CMD_STOP" LINK "gg:doc/NDK/Guide/audio/CMD_STOP"}        6
#define @{"CMD_START" LINK "gg:doc/NDK/Guide/audio/CMD_START"}       7
#define @{"CMD_FLUSH" LINK "gg:doc/NDK/Guide/audio/CMD_FLUSH"}       8

#define CMD_NONSTD      9

#endif  /* EXEC_IO_H */
@ENDNODE
