@DATABASE "gg:doc/NDK/Guide/Include/exec/devices.h"
@MASTER   "gg:os-include/exec/devices.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:10
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "exec/devices.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"exec/devices.h" LINK File}


@{b}Structures@{ub}

@{"Device" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 24}  @{"Unit" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 31}


@{b}#defines@{ub}

@{"UNITF_ACTIVE" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 40}  @{"UNITF_INTASK" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 41}

@ENDNODE
@NODE File "exec/devices.h"
#ifndef EXEC_DEVICES_H
#define EXEC_DEVICES_H
/*
**      $VER: devices.h 39.0 (15.10.1991)
**      Includes Release 45.1
**
**      Include file for use by Exec device drivers
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif /* EXEC_LIBRARIES_H */

#ifndef EXEC_PORTS_H
#include <@{"exec/ports.h" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File"}>
#endif /* EXEC_PORTS_H */


/****** Device ******************************************************/

struct Device {
    @{"struct  Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} dd_Library;
};


/****** Unit ********************************************************/

struct Unit {
    @{"struct  MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} unit_MsgPort;       /* queue for unprocessed messages */
                                        /* instance of msgport is recommended */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   unit_flags;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   unit_pad;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   unit_OpenCnt;               /* number of active opens */
};


#define UNITF_ACTIVE    (1<<0)
#define UNITF_INTASK    (1<<1)

#endif  /* EXEC_DEVICES_H */
@ENDNODE
