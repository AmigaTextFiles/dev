@DATABASE "gg:doc/NDK/Guide/Include/gadgets/tapedeck.h"
@MASTER   "gg:os-include/gadgets/tapedeck.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:46
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/tapedeck.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/tapedeck.h" LINK File}


@{b}#defines@{ub}

@{"BUT_BEGIN" LINK "gg:doc/NDK/Guide/Include/gadgets/tapedeck.h/File" 44}     @{"BUT_END" LINK "gg:doc/NDK/Guide/Include/gadgets/tapedeck.h/File" 46}     @{"BUT_FORWARD" LINK "gg:doc/NDK/Guide/Include/gadgets/tapedeck.h/File" 41}   @{"BUT_FRAME" LINK "gg:doc/NDK/Guide/Include/gadgets/tapedeck.h/File" 45}           @{"BUT_PAUSE" LINK "gg:doc/NDK/Guide/Include/gadgets/tapedeck.h/File" 43}
@{"BUT_PLAY" LINK "gg:doc/NDK/Guide/Include/gadgets/tapedeck.h/File" 40}      @{"BUT_REWIND" LINK "gg:doc/NDK/Guide/Include/gadgets/tapedeck.h/File" 39}  @{"BUT_STOP" LINK "gg:doc/NDK/Guide/Include/gadgets/tapedeck.h/File" 42}      @{"TDECK_CurrentFrame" LINK "gg:doc/NDK/Guide/Include/gadgets/tapedeck.h/File" 33}  @{"TDECK_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/tapedeck.h/File" 21}
@{"TDECK_Frames" LINK "gg:doc/NDK/Guide/Include/gadgets/tapedeck.h/File" 29}  @{"TDECK_Mode" LINK "gg:doc/NDK/Guide/Include/gadgets/tapedeck.h/File" 22}  @{"TDECK_Paused" LINK "gg:doc/NDK/Guide/Include/gadgets/tapedeck.h/File" 23}  @{"TDECK_Tape" LINK "gg:doc/NDK/Guide/Include/gadgets/tapedeck.h/File" 25}          

@ENDNODE
@NODE File "gadgets/tapedeck.h"
#ifndef GADGETS_TAPEDECK_H
#define GADGETS_TAPEDECK_H
/*
**      $VER: tapedeck.h 40.0 (12.3.1993)
**      Includes Release 45.1
**
**      Definitions for the tapedeck BOOPSI class
**
**      (C) Copyright 1992-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

/*****************************************************************************/

#define TDECK_Dummy             (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+0x05000000)
#define TDECK_Mode              (@{"TDECK_Dummy" LINK File 21} + 1)
#define TDECK_Paused            (@{"TDECK_Dummy" LINK File 21} + 2)

#define TDECK_Tape              (@{"TDECK_Dummy" LINK File 21} + 3)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Indicate whether tapedeck or animation controls.  Defaults
         * to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define TDECK_Frames            (@{"TDECK_Dummy" LINK File 21} + 11)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Number of frames in animation.  Only valid when using
         * animation controls. */

#define TDECK_CurrentFrame      (@{"TDECK_Dummy" LINK File 21} + 12)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Current frame.  Only valid when using animation controls. */

/*****************************************************************************/

/* Possible values for @{"TDECK_Mode" LINK File 22} */
#define BUT_REWIND      0
#define BUT_PLAY        1
#define BUT_FORWARD     2
#define BUT_STOP        3
#define BUT_PAUSE       4
#define BUT_BEGIN       5
#define BUT_FRAME       6
#define BUT_END         7

/*****************************************************************************/

#endif /* GADGETS_TAPEDECK_H */
@ENDNODE
