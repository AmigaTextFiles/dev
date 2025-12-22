@DATABASE "gg:doc/NDK/Guide/Include/libraries/configvars.h"
@MASTER   "gg:os-include/libraries/configvars.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:16:38
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "libraries/configvars.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"libraries/configvars.h" LINK File}


@{b}Structures@{ub}

@{"ConfigDev" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 32}  @{"CurrentBinding" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 61}


@{b}#defines@{ub}

@{"CDB_BADMEMORY" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 49}  @{"CDB_CONFIGME" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 48}   @{"CDB_PROCESSED" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 50}  @{"CDB_SHUTUP" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 47}  @{"CDF_BADMEMORY" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 54}
@{"CDF_CONFIGME" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 53}   @{"CDF_PROCESSED" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 55}  @{"CDF_SHUTUP" LINK "gg:doc/NDK/Guide/Include/libraries/configvars.h/File" 52}     

@ENDNODE
@NODE File "libraries/configvars.h"
#ifndef LIBRARIES_CONFIGVARS_H
#define LIBRARIES_CONFIGVARS_H
/*
**      $VER: configvars.h 36.14 (22.4.1991)
**      Includes Release 45.1
**
**      Software structures used by AutoConfig (tm) boards
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif  /* EXEC_TYPES_H */

#ifndef EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif /* EXEC_NODES_H */

#ifndef LIBRARIES_CONFIGREGS_H
#include <@{"libraries/configregs.h" LINK "gg:doc/NDK/Guide/Include/libraries/configregs.h/File"}>
#endif /* LIBRARIES_CONFIGREGS_H */

/*
** At early system startup time, one ConfigDev structure is created for
** each board found in the system.  Software may seach for ConfigDev
** structures by vendor & product ID number.  For debugging and diagnostic
** use, the entire list can be accessed.  See the @{"expansion.library" LINK "gg:doc/NDK/Guide/expansion/MAIN"} document
** for more information.
*/
struct ConfigDev {
    @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22}         cd_Node;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}               cd_Flags;       /* (read/write) */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}               cd_Pad;         /* reserved */
    @{"struct ExpansionRom" LINK "gg:doc/NDK/Guide/Include/libraries/configregs.h/File" 46} cd_Rom;         /* copy of board's expansion ROM */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}                cd_BoardAddr; /* where in memory the board was placed */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               cd_BoardSize;   /* size of board in bytes */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}               cd_SlotAddr;    /* which slot number (PRIVATE) */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}               cd_SlotSize;    /* number of slots (PRIVATE) */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}                cd_Driver;      /* pointer to node of driver */
    struct ConfigDev *  cd_NextCD;      /* linked list of drivers to config */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               cd_Unused[4];   /* for whatever the driver wants */
};

/* cd_Flags */
#define CDB_SHUTUP      0       /* this board has been shut up */
#define CDB_CONFIGME    1       /* this board needs a driver to claim it */
#define CDB_BADMEMORY   2       /* this board contains bad memory */
#define CDB_PROCESSED   3       /* private flag */

#define CDF_SHUTUP      0x01
#define CDF_CONFIGME    0x02
#define CDF_BADMEMORY   0x04
#define CDF_PROCESSED   0x08

/*
** Boards are usually "bound" to software drivers.
** This structure is used by @{"GetCurrentBinding()" LINK "gg:doc/NDK/Guide/expansion/GetCurrentBinding"} and @{"SetCurrentBinding()" LINK "gg:doc/NDK/Guide/expansion/SetCurrentBinding"}
*/
struct CurrentBinding {
    @{"struct ConfigDev" LINK File 32} *  cb_ConfigDev;           /* first configdev in chain */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *             cb_FileName;            /* file name of driver */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *             cb_ProductString;       /* product # string */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} **            cb_ToolTypes;           /* tooltypes from disk object */
};


#endif /* LIBRARIES_CONFIGVARS_H */
@ENDNODE
