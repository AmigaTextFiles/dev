@DATABASE "gg:doc/NDK/Guide/Include/devices/bootblock.h"
@MASTER   "gg:os-include/devices/bootblock.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:17
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/bootblock.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/bootblock.h" LINK File}


@{b}Structures@{ub}

@{"BootBlock" LINK "gg:doc/NDK/Guide/Include/devices/bootblock.h/File" 17}


@{b}#defines@{ub}

@{"BBID_DOS" LINK "gg:doc/NDK/Guide/Include/devices/bootblock.h/File" 25}  @{"BBID_KICK" LINK "gg:doc/NDK/Guide/Include/devices/bootblock.h/File" 26}  @{"BBNAME_DOS" LINK "gg:doc/NDK/Guide/Include/devices/bootblock.h/File" 28}  @{"BBNAME_KICK" LINK "gg:doc/NDK/Guide/Include/devices/bootblock.h/File" 29}  @{"BOOTSECTS" LINK "gg:doc/NDK/Guide/Include/devices/bootblock.h/File" 23}

@ENDNODE
@NODE File "devices/bootblock.h"
#ifndef DEVICES_BOOTBLOCK_H
#define DEVICES_BOOTBLOCK_H
/*
**      $VER: bootblock.h 36.6 (5.11.1990)
**      Includes Release 45.1
**
**      floppy @{"BootBlock" LINK "gg:doc/NDK/Guide/Include/libraries/hdwrench.h/File" 79} definition
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include        <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

struct BootBlock {
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   bb_id[4];               /* 4 character identifier */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    bb_chksum;              /* boot block checksum (balance) */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    bb_dosblock;            /* reserved for DOS patch */
};

#define         BOOTSECTS       2       /* 1K bootstrap */

#define BBID_DOS        { 'D', 'O', 'S', '\\0' }
#define BBID_KICK       { 'K', 'I', 'C', 'K' }

#define BBNAME_DOS      0x444F5300      /* 'DOS\\0' */
#define BBNAME_KICK     0x4B49434B      /* 'KICK' */

#endif  /* DEVICES_BOOTBLOCK_H */
@ENDNODE
