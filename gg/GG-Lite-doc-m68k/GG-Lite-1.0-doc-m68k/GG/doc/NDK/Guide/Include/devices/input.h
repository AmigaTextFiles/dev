@DATABASE "gg:doc/NDK/Guide/Include/devices/input.h"
@MASTER   "gg:os-include/devices/input.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:25
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/input.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/input.h" LINK File}


@{b}#defines@{ub}

@{"IND_ADDHANDLER" LINK "gg:doc/NDK/Guide/Include/devices/input.h/File" 17}  @{"IND_REMHANDLER" LINK "gg:doc/NDK/Guide/Include/devices/input.h/File" 18}  @{"IND_SETMPORT" LINK "gg:doc/NDK/Guide/Include/devices/input.h/File" 22}   @{"IND_SETMTRIG" LINK "gg:doc/NDK/Guide/Include/devices/input.h/File" 24}
@{"IND_SETMTYPE" LINK "gg:doc/NDK/Guide/Include/devices/input.h/File" 23}    @{"IND_SETPERIOD" LINK "gg:doc/NDK/Guide/Include/devices/input.h/File" 21}   @{"IND_SETTHRESH" LINK "gg:doc/NDK/Guide/Include/devices/input.h/File" 20}  @{"IND_WRITEEVENT" LINK "gg:doc/NDK/Guide/Include/devices/input.h/File" 19}

@ENDNODE
@NODE File "devices/input.h"
#ifndef DEVICES_INPUT_H
#define DEVICES_INPUT_H
/*
**      $VER: input.h 36.0 (1.5.1990)
**      Includes Release 45.1
**
**      input device command definitions
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_IO_H
#include <@{"exec/io.h" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File"}>
#endif

#define  @{"IND_ADDHANDLER" LINK "gg:doc/NDK/Guide/input/IND_ADDHANDLER"}    (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+0)
#define  @{"IND_REMHANDLER" LINK "gg:doc/NDK/Guide/input/IND_REMHANDLER"}    (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+1)
#define  @{"IND_WRITEEVENT" LINK "gg:doc/NDK/Guide/input/IND_WRITEEVENT"}    (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+2)
#define  @{"IND_SETTHRESH" LINK "gg:doc/NDK/Guide/input/IND_SETTHRESH"}     (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+3)
#define  @{"IND_SETPERIOD" LINK "gg:doc/NDK/Guide/input/IND_SETPERIOD"}     (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+4)
#define  @{"IND_SETMPORT" LINK "gg:doc/NDK/Guide/input/IND_SETMPORT"}      (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+5)
#define  @{"IND_SETMTYPE" LINK "gg:doc/NDK/Guide/input/IND_SETMTYPE"}      (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+6)
#define  @{"IND_SETMTRIG" LINK "gg:doc/NDK/Guide/input/IND_SETMTRIG"}      (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+7)

#endif  /* DEVICES_INPUT_H */
@ENDNODE
