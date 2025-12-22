@DATABASE "gg:doc/NDK/Guide/Include/devices/gameport.h"
@MASTER   "gg:os-include/devices/gameport.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:23
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/gameport.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/gameport.h" LINK File}


@{b}Structures@{ub}

@{"GamePortTrigger" LINK "gg:doc/NDK/Guide/Include/devices/gameport.h/File" 36}


@{b}#defines@{ub}

@{"GPCT_ABSJOYSTICK" LINK "gg:doc/NDK/Guide/Include/devices/gameport.h/File" 49}  @{"GPCT_ALLOCATED" LINK "gg:doc/NDK/Guide/Include/devices/gameport.h/File" 44}  @{"GPCT_MOUSE" LINK "gg:doc/NDK/Guide/Include/devices/gameport.h/File" 47}       @{"GPCT_NOCONTROLLER" LINK "gg:doc/NDK/Guide/Include/devices/gameport.h/File" 45}
@{"GPCT_RELJOYSTICK" LINK "gg:doc/NDK/Guide/Include/devices/gameport.h/File" 48}  @{"GPD_ASKCTYPE" LINK "gg:doc/NDK/Guide/Include/devices/gameport.h/File" 23}    @{"GPD_ASKTRIGGER" LINK "gg:doc/NDK/Guide/Include/devices/gameport.h/File" 25}   @{"GPD_READEVENT" LINK "gg:doc/NDK/Guide/Include/devices/gameport.h/File" 22}
@{"GPD_SETCTYPE" LINK "gg:doc/NDK/Guide/Include/devices/gameport.h/File" 24}      @{"GPD_SETTRIGGER" LINK "gg:doc/NDK/Guide/Include/devices/gameport.h/File" 26}  @{"GPDERR_SETCTYPE" LINK "gg:doc/NDK/Guide/Include/devices/gameport.h/File" 53}  @{"GPTB_DOWNKEYS" LINK "gg:doc/NDK/Guide/Include/devices/gameport.h/File" 31}
@{"GPTB_UPKEYS" LINK "gg:doc/NDK/Guide/Include/devices/gameport.h/File" 33}       @{"GPTF_DOWNKEYS" LINK "gg:doc/NDK/Guide/Include/devices/gameport.h/File" 32}   @{"GPTF_UPKEYS" LINK "gg:doc/NDK/Guide/Include/devices/gameport.h/File" 34}      

@ENDNODE
@NODE File "devices/gameport.h"
#ifndef DEVICES_GAMEPORT_H
#define DEVICES_GAMEPORT_H
/*
**      $VER: gameport.h 36.1 (5.11.1990)
**      Includes Release 45.1
**
**      GamePort device command definitions
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include        <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef EXEC_IO_H
#include        <@{"exec/io.h" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File"}>
#endif

/******  GamePort commands ******/
#define  @{"GPD_READEVENT" LINK "gg:doc/NDK/Guide/gameport/GPD_READEVENT"}     (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+0)
#define  @{"GPD_ASKCTYPE" LINK "gg:doc/NDK/Guide/gameport/GPD_ASKCTYPE"}      (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+1)
#define  @{"GPD_SETCTYPE" LINK "gg:doc/NDK/Guide/gameport/GPD_SETCTYPE"}      (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+2)
#define  @{"GPD_ASKTRIGGER" LINK "gg:doc/NDK/Guide/gameport/GPD_ASKTRIGGER"}    (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+3)
#define  @{"GPD_SETTRIGGER" LINK "gg:doc/NDK/Guide/gameport/GPD_SETTRIGGER"}    (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+4)

/******  GamePort structures ******/

/* gpt_Keys */
#define  GPTB_DOWNKEYS     0
#define  GPTF_DOWNKEYS     (1<<0)
#define  GPTB_UPKEYS       1
#define  GPTF_UPKEYS       (1<<1)

struct GamePortTrigger {
   @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} gpt_Keys;         /* key transition triggers */
   @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} gpt_Timeout;      /* time trigger (vertical blank units) */
   @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} gpt_XDelta;       /* X distance trigger */
   @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} gpt_YDelta;       /* Y distance trigger */
};

/****** Controller Types ******/
#define  GPCT_ALLOCATED    -1    /* allocated by another user */
#define  GPCT_NOCONTROLLER 0

#define  GPCT_MOUSE        1
#define  GPCT_RELJOYSTICK  2
#define  GPCT_ABSJOYSTICK  3


/****** Errors ******/
#define  GPDERR_SETCTYPE   1     /* this controller not valid at this time */

#endif  /* DEVICES_GAMEPORT_H */
@ENDNODE
