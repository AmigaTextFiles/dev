@DATABASE "gg:doc/NDK/Guide/Include/prefs/serial.h"
@MASTER   "gg:os-include/prefs/serial.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:57
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "prefs/serial.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"prefs/serial.h" LINK File}


@{b}Structures@{ub}

@{"SerialPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/serial.h/File" 31}


@{b}#defines@{ub}

@{"HSHAKE_NONE" LINK "gg:doc/NDK/Guide/Include/prefs/serial.h/File" 58}  @{"HSHAKE_RTS" LINK "gg:doc/NDK/Guide/Include/prefs/serial.h/File" 57}   @{"HSHAKE_XON" LINK "gg:doc/NDK/Guide/Include/prefs/serial.h/File" 56}  @{"ID_SERL" LINK "gg:doc/NDK/Guide/Include/prefs/serial.h/File" 28}       @{"PARITY_EVEN" LINK "gg:doc/NDK/Guide/Include/prefs/serial.h/File" 50}
@{"PARITY_MARK" LINK "gg:doc/NDK/Guide/Include/prefs/serial.h/File" 52}  @{"PARITY_NONE" LINK "gg:doc/NDK/Guide/Include/prefs/serial.h/File" 49}  @{"PARITY_ODD" LINK "gg:doc/NDK/Guide/Include/prefs/serial.h/File" 51}  @{"PARITY_SPACE" LINK "gg:doc/NDK/Guide/Include/prefs/serial.h/File" 53}  

@ENDNODE
@NODE File "prefs/serial.h"
#ifndef PREFS_SERIAL_H
#define PREFS_SERIAL_H
/*
**      $VER: serial.h 38.2 (10.7.1991)
**      Includes Release 45.1
**
**      File format for serial preferences
**
**      (C) Copyright 1991-2001 Amiga, Inc.
**      All Rights Reserved
*/

/*****************************************************************************/


#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif


/*****************************************************************************/


#define ID_SERL @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('S','E','R','L')


struct SerialPrefs
{
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  sp_Reserved[3];               /* System reserved                  */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} sp_Unit0Map;                  /* What unit 0 really refers to     */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} sp_BaudRate;                  /* Baud rate                        */

    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} sp_InputBuffer;               /* Input buffer: 0 - 65536          */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} sp_OutputBuffer;              /* Future: Output: 0 - 65536        */

    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} sp_InputHandshake;            /* Input handshaking                */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} sp_OutputHandshake;           /* Future: Output handshaking       */

    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} sp_Parity;                    /* Parity                           */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} sp_BitsPerChar;               /* I/O bits per character           */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} sp_StopBits;                  /* Stop bits                        */
};

/* constants for SerialPrefs.sp_Parity */
#define PARITY_NONE     0
#define PARITY_EVEN     1
#define PARITY_ODD      2
#define PARITY_MARK     3               /* Future enhancement */
#define PARITY_SPACE    4               /* Future enhancement */

/* constants for SerialPrefs.sp_Input/OutputHandshaking */
#define HSHAKE_XON      0
#define HSHAKE_RTS      1
#define HSHAKE_NONE     2


/*****************************************************************************/


#endif /* PREFS_SERIAL_H */
@ENDNODE
