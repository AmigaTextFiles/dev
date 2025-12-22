@DATABASE "gg:doc/NDK/Guide/Include/libraries/resource.h"
@MASTER   "gg:os-include/libraries/resource.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:00
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "libraries/resource.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"libraries/resource.h" LINK File}


@{b}Typedefs@{ub}

@{"RESOURCEFILE" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 17}  @{"RESOURCEID" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 18}


@{b}#defines@{ub}

@{"RL_GADGETID()" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 27}  @{"RL_GADGETMASK" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 25}  @{"RL_GROUPID()" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 28}  @{"RL_GROUPMASK" LINK "gg:doc/NDK/Guide/Include/libraries/resource.h/File" 26}

@ENDNODE
@NODE File "libraries/resource.h"
#ifndef LIBRARIES_RESOURCE_H
#define LIBRARIES_RESOURCE_H
/*
**      $VER: resource.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      @{"resource.library" LINK "gg:doc/NDK/Guide/resource/MAIN"} definitions
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

typedef @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} RESOURCEFILE;
typedef @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} RESOURCEID;

/* A gadget ID (Tag @{"GA_ID" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 87}) may contain the ID and the group ID
   ored together. The following definitions must be used to extract
   the original gadget ID (1024 different IDs are possible) and the
   group id (63 different group IDs are possible).
*/
#define RL_GADGETMASK 0x03FF
#define RL_GROUPMASK  0xFC00
#define RL_GADGETID(x) ((x) & @{"RL_GADGETMASK" LINK File 25})
#define RL_GROUPID(x) (((x) & @{"RL_GROUPMASK" LINK File 26}) >> 10)

#endif /* LIBRARIES_RESOURCE_H */
@ENDNODE
