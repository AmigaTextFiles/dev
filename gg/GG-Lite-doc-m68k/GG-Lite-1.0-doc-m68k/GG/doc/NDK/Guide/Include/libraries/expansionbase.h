@DATABASE "gg:doc/NDK/Guide/Include/libraries/expansionbase.h"
@MASTER   "gg:os-include/libraries/expansionbase.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:16:40
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "libraries/expansionbase.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"libraries/expansionbase.h" LINK File}


@{b}Structures@{ub}

@{"BootNode" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 33}  @{"ExpansionBase" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 44}


@{b}#defines@{ub}

@{"EBB_BADMEM" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 70}      @{"EBB_CLOGGED" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 66}   @{"EBB_DOSFLAG" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 72}      @{"EBB_KICKBACK33" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 74}
@{"EBB_KICKBACK36" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 76}  @{"EBB_SHORTMEM" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 68}  @{"EBB_SILENTSTART" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 81}  @{"EBB_START_CC0" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 85}
@{"EBF_BADMEM" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 71}      @{"EBF_CLOGGED" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 67}   @{"EBF_DOSFLAG" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 73}      @{"EBF_KICKBACK33" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 75}
@{"EBF_KICKBACK36" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 77}  @{"EBF_SHORTMEM" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 69}  @{"EBF_SILENTSTART" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 82}  @{"EBF_START_CC0" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 86}
@{"EE_BADMEM" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 63}       @{"EE_LASTBOARD" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 59}  @{"EE_NOBOARD" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 62}       @{"EE_NOEXPANSION" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 60}
@{"EE_NOMEMORY" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 61}     @{"EE_OK" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 58}         

@ENDNODE
@NODE File "libraries/expansionbase.h"
#ifndef LIBRARIES_EXPANSIONBASE_H
#define LIBRARIES_EXPANSIONBASE_H
/*
**      $VER: expansionbase.h 36.15 (21.10.1991)
**      Includes Release 45.1
**
**      Definitions for the expansion library base
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif  /* EXEC_TYPES_H */

#ifndef EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif  /* EXEC_LIBRARIES_H */

#ifndef EXEC_SEMAPHORES_H
#include <@{"exec/semaphores.h" LINK "gg:doc/NDK/Guide/Include/exec/semaphores.h/File"}>
#endif  /* EXEC_SEMAPHORES_H */

#ifndef LIBRARIES_CONFIGVARS_H
#include <@{"libraries/configvars.h" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File"}>
#endif  /* LIBRARIES_CONFIGVARS_H */


/* BootNodes are scanned by @{"dos.library" LINK "gg:doc/NDK/Guide/dos/MAIN"} at startup.  Items found on the
   list are started by dos. BootNodes are added with the @{"AddDosNode()" LINK "gg:doc/NDK/Guide/expansion/AddDosNode"} or
   the V36 @{"AddBootNode()" LINK "gg:doc/NDK/Guide/expansion/AddBootNode"} calls. */
struct BootNode
{
        @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} bn_Node;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bn_Flags;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    bn_DeviceNode;
};


/* @{"expansion.library" LINK "gg:doc/NDK/Guide/expansion/MAIN"} has functions to manipulate most of the information in
   ExpansionBase.  Direct access is not permitted.  Use @{"FindConfigDev()" LINK "gg:doc/NDK/Guide/expansion/FindConfigDev"}
   to scan the board list. */
struct  ExpansionBase
{
        @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34}  LibNode;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   Flags;                          /* read only (see below) */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   eb_Private01;                   /* private */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   eb_Private02;                   /* private */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   eb_Private03;                   /* private */
        @{"struct  CurrentBinding" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 61}  eb_Private04;   /* private */
        @{"struct  List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20}    eb_Private05;           /* private */
        @{"struct  List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20}    MountList;      /* contains @{"struct BootNode" LINK "gg:doc/NDK/Guide/Include/libraries/expansionbase.h/File" 33} entries */
        /* private */
};

/* error codes */
#define EE_OK           0
#define EE_LASTBOARD    40  /* could not shut him up */
#define EE_NOEXPANSION  41  /* not enough expansion mem; board shut up */
#define EE_NOMEMORY     42  /* not enough normal memory */
#define EE_NOBOARD      43  /* no board at that address */
#define EE_BADMEM       44  /* tried to add bad memory card */

/* Flags */
#define EBB_CLOGGED     0       /* someone could not be shutup */
#define EBF_CLOGGED     (1<<0)
#define EBB_SHORTMEM    1       /* ran out of expansion mem */
#define EBF_SHORTMEM    (1<<1)
#define EBB_BADMEM      2       /* tried to add bad memory card */
#define EBF_BADMEM      (1<<2)
#define EBB_DOSFLAG     3       /* reserved for use by AmigaDOS */
#define EBF_DOSFLAG     (1<<3)
#define EBB_KICKBACK33  4       /* reserved for use by AmigaDOS */
#define EBF_KICKBACK33  (1<<4)
#define EBB_KICKBACK36  5       /* reserved for use by AmigaDOS */
#define EBF_KICKBACK36  (1<<5)
/* If the following flag is set by a floppy's bootblock code, the initial
   open of the initial shell window will be delayed until the first output
   to that shell.  Otherwise the 1.3 compatible behavior applies. */
#define EBB_SILENTSTART 6
#define EBF_SILENTSTART (1<<6)

/* Magic kludge for CC0 use */
#define EBB_START_CC0   7
#define EBF_START_CC0   (1<<7)


#endif  /* LIBRARIES_EXPANSIONBASE_H */
@ENDNODE
