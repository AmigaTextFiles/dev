@DATABASE "gg:doc/NDK/Guide/Include/devices/keyboard.h"
@MASTER   "gg:os-include/devices/keyboard.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:28
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/keyboard.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/keyboard.h" LINK File}


@{b}#defines@{ub}

@{"KBD_ADDRESETHANDLER" LINK "gg:doc/NDK/Guide/Include/devices/keyboard.h/File" 19}   @{"KBD_READEVENT" LINK "gg:doc/NDK/Guide/Include/devices/keyboard.h/File" 17}  @{"KBD_READMATRIX" LINK "gg:doc/NDK/Guide/Include/devices/keyboard.h/File" 18}  @{"KBD_REMRESETHANDLER" LINK "gg:doc/NDK/Guide/Include/devices/keyboard.h/File" 20}
@{"KBD_RESETHANDLERDONE" LINK "gg:doc/NDK/Guide/Include/devices/keyboard.h/File" 21}  

@ENDNODE
@NODE File "devices/keyboard.h"
#ifndef DEVICES_KEYBOARD_H
#define DEVICES_KEYBOARD_H
/*
**      $VER: keyboard.h 36.0 (1.5.1990)
**      Includes Release 45.1
**
**      Keyboard device command definitions
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef  EXEC_IO_H
#include <@{"exec/io.h" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File"}>
#endif

#define  @{"KBD_READEVENT" LINK "gg:doc/NDK/Guide/keyboard/KBD_READEVENT"}        (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+0)
#define  @{"KBD_READMATRIX" LINK "gg:doc/NDK/Guide/keyboard/KBD_READMATRIX"}       (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+1)
#define  @{"KBD_ADDRESETHANDLER" LINK "gg:doc/NDK/Guide/keyboard/KBD_ADDRESETHANDLER"}  (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+2)
#define  @{"KBD_REMRESETHANDLER" LINK "gg:doc/NDK/Guide/keyboard/KBD_REMRESETHANDLER"}  (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+3)
#define  @{"KBD_RESETHANDLERDONE" LINK "gg:doc/NDK/Guide/keyboard/KBD_RESETHANDLERDONE"} (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+4)

#endif  /* DEVICES_KEYBOARD_H */
@ENDNODE
