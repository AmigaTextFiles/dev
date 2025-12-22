@DATABASE "gg:doc/NDK/Guide/Include/devices/clipboard.h"
@MASTER   "gg:os-include/devices/clipboard.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:20
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/clipboard.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/clipboard.h" LINK File}


@{b}Structures@{ub}

@{"ClipboardUnitPartial" LINK "gg:doc/NDK/Guide/Include/devices/clipboard.h/File" 34}  @{"ClipHookMsg" LINK "gg:doc/NDK/Guide/Include/devices/clipboard.h/File" 63}  @{"IOClipReq" LINK "gg:doc/NDK/Guide/Include/devices/clipboard.h/File" 41}  @{"SatisfyMsg" LINK "gg:doc/NDK/Guide/Include/devices/clipboard.h/File" 57}


@{b}#defines@{ub}

@{"CBD_CHANGEHOOK" LINK "gg:doc/NDK/Guide/Include/devices/clipboard.h/File" 29}    @{"CBD_CURRENTREADID" LINK "gg:doc/NDK/Guide/Include/devices/clipboard.h/File" 27}  @{"CBD_CURRENTWRITEID" LINK "gg:doc/NDK/Guide/Include/devices/clipboard.h/File" 28}  @{"CBD_POST" LINK "gg:doc/NDK/Guide/Include/devices/clipboard.h/File" 26}
@{"CBERR_OBSOLETEID" LINK "gg:doc/NDK/Guide/Include/devices/clipboard.h/File" 31}  @{"PRIMARY_CLIP" LINK "gg:doc/NDK/Guide/Include/devices/clipboard.h/File" 55}       

@ENDNODE
@NODE File "devices/clipboard.h"
#ifndef     DEVICES_CLIPBOARD_H
#define     DEVICES_CLIPBOARD_H
/*
**      $VER: clipboard.h 36.5 (2.11.1990)
**      Includes Release 45.1
**
**      @{"clipboard.device" LINK "gg:doc/NDK/Guide/clipboard/MAIN"} structure definitions
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif
#ifndef EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif
#ifndef EXEC_PORTS_H
#include <@{"exec/ports.h" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File"}>
#endif

#define @{"CBD_POST" LINK "gg:doc/NDK/Guide/clipboard/CBD_POST"}                (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+0)
#define @{"CBD_CURRENTREADID" LINK "gg:doc/NDK/Guide/clipboard/CBD_CURRENTREADID"}       (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+1)
#define @{"CBD_CURRENTWRITEID" LINK "gg:doc/NDK/Guide/clipboard/CBD_CURRENTWRITEID"}      (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+2)
#define @{"CBD_CHANGEHOOK" LINK "gg:doc/NDK/Guide/clipboard/CBD_CHANGEHOOK"}          (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+3)

#define CBERR_OBSOLETEID        1


struct ClipboardUnitPartial {
    @{"struct  Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} cu_Node;       /* list of units */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   cu_UnitNum;         /* unit number for this unit */
    /* the remaining unit data is private to the device */
};


struct IOClipReq {
    @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47} io_Message;
    @{"struct Device" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 24} *io_Device;   /* device node pointer  */
    @{"struct ClipboardUnitPartial" LINK File 34} *io_Unit; /* unit node pointer */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   io_Command;         /* device command */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   io_Flags;           /* including QUICK and SATISFY */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    io_Error;           /* error or warning num */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   io_Actual;          /* number of bytes transferred */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   io_Length;          /* number of bytes requested */
    @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}  io_Data;            /* either clip stream or post port */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   io_Offset;          /* offset in clip stream */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    io_ClipID;          /* ordinal clip identifier */
};

#define PRIMARY_CLIP    0       /* primary clip unit */

struct SatisfyMsg {
    @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47} sm_Msg;      /* the length will be 6 */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   sm_Unit;            /* which clip unit this is */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    sm_ClipID;          /* the clip identifier of the post */
};

struct ClipHookMsg {
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   chm_Type;           /* zero for this structure format */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    chm_ChangeCmd;      /* command that caused this hook invocation: */
                                /*   either @{"CMD_UPDATE" LINK "gg:doc/NDK/Guide/audio/CMD_UPDATE"} or @{"CBD_POST" LINK "gg:doc/NDK/Guide/clipboard/CBD_POST"} */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    chm_ClipID;         /* the clip identifier of the new data */
};

#endif  /* DEVICES_CLIPBOARD_H */
@ENDNODE
