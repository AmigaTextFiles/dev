@DATABASE "gg:doc/NDK/Guide/Include/exec/libraries.h"
@MASTER   "gg:os-include/exec/libraries.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:14
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "exec/libraries.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"exec/libraries.h" LINK File}


@{b}Structures@{ub}

@{"Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34}


@{b}#defines@{ub}

@{"lh_Flags" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 56}     @{"lh_IdString" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 62}   @{"lh_NegSize" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 58}    @{"lh_Node" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 55}       @{"lh_OpenCnt" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 64}
@{"lh_pad" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 57}       @{"lh_PosSize" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 59}    @{"lh_Revision" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 61}   @{"lh_Sum" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 63}        @{"lh_Version" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 60}
@{"LIB_BASE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 21}     @{"LIB_CLOSE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 27}     @{"LIB_EXPUNGE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 28}   @{"LIB_EXTFUNC" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 29}   @{"LIB_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 23}
@{"LIB_OPEN" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 26}     @{"LIB_RESERVED" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 20}  @{"LIB_USERDEF" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 22}   @{"LIB_VECTSIZE" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 19}  @{"LIBF_CHANGED" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 49}
@{"LIBF_DELEXP" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 51}  @{"LIBF_SUMMING" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 48}  @{"LIBF_SUMUSED" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 50}  

@ENDNODE
@NODE File "exec/libraries.h"
#ifndef EXEC_LIBRARIES_H
#define EXEC_LIBRARIES_H
/*
**      $VER: libraries.h 39.2 (10.4.1992)
**      Includes Release 45.1
**
**      Definitions for use when creating or using Exec libraries
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif /* EXEC_NODES_H */


/*------ Special Constants ---------------------------------------*/
#define LIB_VECTSIZE    6       /* Each library entry takes 6 bytes */
#define LIB_RESERVED    4       /* Exec reserves the first 4 vectors */
#define LIB_BASE        (-@{"LIB_VECTSIZE" LINK File 19})
#define LIB_USERDEF     (@{"LIB_BASE" LINK File 21}-(@{"LIB_RESERVED" LINK File 20}*@{"LIB_VECTSIZE" LINK File 19}))
#define LIB_NONSTD      (@{"LIB_USERDEF" LINK File 22})

/*------ Standard Functions --------------------------------------*/
#define LIB_OPEN        (-6)
#define LIB_CLOSE       (-12)
#define LIB_EXPUNGE     (-18)
#define LIB_EXTFUNC     (-24)   /* for future expansion */


/*------ Library Base Structure ----------------------------------*/
/* Also used for Devices and some Resources */
struct Library {
    @{"struct  Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} lib_Node;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   lib_Flags;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   lib_pad;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   lib_NegSize;            /* number of bytes before library */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   lib_PosSize;            /* number of bytes after library */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   lib_Version;            /* major */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   lib_Revision;           /* minor */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    lib_IdString;           /* ASCII identification */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   lib_Sum;                /* the checksum itself */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   lib_OpenCnt;            /* number of current opens */
};      /* Warning: size is not a longword multiple! */

/* lib_Flags bit definitions (all others are system reserved) */
#define LIBF_SUMMING    (1<<0)      /* we are currently checksumming */
#define LIBF_CHANGED    (1<<1)      /* we have just changed the lib */
#define LIBF_SUMUSED    (1<<2)      /* set if we should bother to sum */
#define LIBF_DELEXP     (1<<3)      /* delayed expunge */


/* Temporary Compatibility */
#define lh_Node lib_Node
#define lh_Flags        lib_Flags
#define lh_pad          lib_pad
#define lh_NegSize      lib_NegSize
#define lh_PosSize      lib_PosSize
#define lh_Version      lib_Version
#define lh_Revision     lib_Revision
#define lh_IdString     lib_IdString
#define lh_Sum          lib_Sum
#define lh_OpenCnt      lib_OpenCnt

#endif  /* EXEC_LIBRARIES_H */
@ENDNODE
