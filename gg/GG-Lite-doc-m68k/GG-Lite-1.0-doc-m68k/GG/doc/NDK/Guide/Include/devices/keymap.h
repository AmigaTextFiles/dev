@DATABASE "gg:doc/NDK/Guide/Include/devices/keymap.h"
@MASTER   "gg:os-include/devices/keymap.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:29
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/keymap.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/keymap.h" LINK File}


@{b}Structures@{ub}

@{"KeyMap" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 21}  @{"KeyMapNode" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 32}  @{"KeyMapResource" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 38}


@{b}#defines@{ub}

@{"DP_2DFACSHIFT" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 72}  @{"DP_2DINDEXMASK" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 71}  @{"DPB_DEAD" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 68}    @{"DPB_MOD" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 66}     @{"DPF_DEAD" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 69}
@{"DPF_MOD" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 67}        @{"KC_NOQUAL" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 44}       @{"KC_VANILLA" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 45}  @{"KCB_ALT" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 48}     @{"KCB_CONTROL" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 50}
@{"KCB_DEAD" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 55}       @{"KCB_DOWNUP" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 52}      @{"KCB_NOP" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 61}     @{"KCB_SHIFT" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 46}   @{"KCB_STRING" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 58}
@{"KCF_ALT" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 49}        @{"KCF_CONTROL" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 51}     @{"KCF_DEAD" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 56}    @{"KCF_DOWNUP" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 53}  @{"KCF_NOP" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 62}
@{"KCF_SHIFT" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 47}      @{"KCF_STRING" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 59}      

@ENDNODE
@NODE File "devices/keymap.h"
#ifndef DEVICES_KEYMAP_H
#define DEVICES_KEYMAP_H
/*
**      $VER: keymap.h 36.3 (13.4.1990)
**      Includes Release 45.1
**
**      key map definitions for keymap.resource, @{"keymap.library" LINK "gg:doc/NDK/Guide/keymap/MAIN"}, and
**      @{"console.device" LINK "gg:doc/NDK/Guide/console/MAIN"}
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif
#ifndef EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif

struct   KeyMap {
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *km_LoKeyMapTypes;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   *km_LoKeyMap;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *km_LoCapsable;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *km_LoRepeatable;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *km_HiKeyMapTypes;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   *km_HiKeyMap;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *km_HiCapsable;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *km_HiRepeatable;
};

struct  KeyMapNode {
    @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} kn_Node;        /* including name of keymap */
    @{"struct KeyMap" LINK File 21} kn_KeyMap;
};

/* the structure of keymap.resource */
struct  KeyMapResource {
    @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} kr_Node;
    @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} kr_List;        /* a list of KeyMapNodes */
};

/* Key Map Types */
#define  KC_NOQUAL   0
#define  KC_VANILLA  7          /* note that SHIFT+ALT+CTRL is VANILLA */
#define  KCB_SHIFT   0
#define  KCF_SHIFT   0x01
#define  KCB_ALT     1
#define  KCF_ALT     0x02
#define  KCB_CONTROL 2
#define  KCF_CONTROL 0x04
#define  KCB_DOWNUP  3
#define  KCF_DOWNUP  0x08

#define  KCB_DEAD    5          /* may be dead or modified by dead key: */
#define  KCF_DEAD    0x20       /*   use dead prefix bytes              */

#define  KCB_STRING  6
#define  KCF_STRING  0x40

#define  KCB_NOP     7
#define  KCF_NOP     0x80


/* Dead Prefix Bytes */
#define DPB_MOD 0
#define DPF_MOD 0x01
#define DPB_DEAD        3
#define DPF_DEAD        0x08

#define DP_2DINDEXMASK  0x0f    /* mask for index for 1st of two dead keys */
#define DP_2DFACSHIFT   4       /* shift for factor for 1st of two dead keys */

#endif  /* DEVICES_KEYMAP_H */
@ENDNODE
