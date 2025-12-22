@DATABASE "gg:doc/NDK/Guide/Include/libraries/nonvolatile.h"
@MASTER   "gg:os-include/libraries/nonvolatile.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:16:58
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "libraries/nonvolatile.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"libraries/nonvolatile.h" LINK File}


@{b}Structures@{ub}

@{"NVEntry" LINK "gg:doc/NDK/Guide/Include/libraries/nonvolatile.h/File" 39}  @{"NVInfo" LINK "gg:doc/NDK/Guide/Include/libraries/nonvolatile.h/File" 29}


@{b}#defines@{ub}

@{"NVEB_APPNAME" LINK "gg:doc/NDK/Guide/Include/libraries/nonvolatile.h/File" 51}  @{"NVEB_DELETE" LINK "gg:doc/NDK/Guide/Include/libraries/nonvolatile.h/File" 50}  @{"NVEF_APPNAME" LINK "gg:doc/NDK/Guide/Include/libraries/nonvolatile.h/File" 54}     @{"NVEF_DELETE" LINK "gg:doc/NDK/Guide/Include/libraries/nonvolatile.h/File" 53}   @{"NVERR_BADNAME" LINK "gg:doc/NDK/Guide/Include/libraries/nonvolatile.h/File" 61}
@{"NVERR_FAIL" LINK "gg:doc/NDK/Guide/Include/libraries/nonvolatile.h/File" 63}    @{"NVERR_FATAL" LINK "gg:doc/NDK/Guide/Include/libraries/nonvolatile.h/File" 64}  @{"NVERR_WRITEPROT" LINK "gg:doc/NDK/Guide/Include/libraries/nonvolatile.h/File" 62}  @{"SizeNVData()" LINK "gg:doc/NDK/Guide/Include/libraries/nonvolatile.h/File" 71}  

@ENDNODE
@NODE File "libraries/nonvolatile.h"
#ifndef LIBRARIES_NONVOLATILE_H
#define LIBRARIES_NONVOLATILE_H

/*
**      $VER: nonvolatile.h 40.8 (30.7.1993)
**      Includes Release 45.1
**
**      @{"nonvolatile.library" LINK "gg:doc/NDK/Guide/nonvolatile/MAIN"} interface structures and defintions.
**
**      (C) Copyright 1992-2001 Amiga, Inc.
**      All Rights Reserved
*/

/*****************************************************************************/


#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif


/*****************************************************************************/


struct NVInfo
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} nvi_MaxStorage;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} nvi_FreeStorage;
};


/*****************************************************************************/


struct NVEntry
{
    @{"struct MinNode" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 31} nve_Node;
    @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}         nve_Name;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}          nve_Size;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}          nve_Protection;
};

/* bit definitions for mask in @{"SetNVProtection()" LINK "gg:doc/NDK/Guide/nonvolatile/SetNVProtection"}.  Also used for
 * NVEntry.nve_Protection.
 */
#define NVEB_DELETE  0
#define NVEB_APPNAME 31

#define NVEF_DELETE  (1<<@{"NVEB_DELETE" LINK File 50})
#define NVEF_APPNAME (1<<@{"NVEB_APPNAME" LINK File 51})


/*****************************************************************************/


/* errors from @{"StoreNV()" LINK "gg:doc/NDK/Guide/nonvolatile/StoreNV"} */
#define NVERR_BADNAME   1
#define NVERR_WRITEPROT 2
#define NVERR_FAIL      3
#define NVERR_FATAL     4


/*****************************************************************************/


/* determine the size of data returned by this library */
#define SizeNVData(DataPtr) ((((@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *) DataPtr)[-1]) - 4)


/*****************************************************************************/


#endif /* LIBRARIES_NONVOLATILE_H */
@ENDNODE
