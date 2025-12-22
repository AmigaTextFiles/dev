@DATABASE "gg:doc/NDK/Guide/Include/resources/filesysres.h"
@MASTER   "gg:os-include/resources/filesysres.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:24
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "resources/filesysres.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"resources/filesysres.h" LINK File}


@{b}Structures@{ub}

@{"FileSysEntry" LINK "gg:doc/NDK/Guide/Include/resources/filesysres.h/File" 31}  @{"FileSysResource" LINK "gg:doc/NDK/Guide/Include/resources/filesysres.h/File" 25}


@{b}#defines@{ub}

@{"FSRNAME" LINK "gg:doc/NDK/Guide/Include/resources/filesysres.h/File" 23}

@ENDNODE
@NODE File "resources/filesysres.h"
#ifndef RESOURCES_FILESYSRES_H
#define RESOURCES_FILESYSRES_H
/*
**      $VER: filesysres.h 36.4 (3.5.1990)
**      Includes Release 45.1
**
**      @{"FileSystem.resource" LINK "gg:doc/NDK/Guide/filesysres/MAIN"} description
**
**      (C) Copyright 1988-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_NODES_H
#include        <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif
#ifndef EXEC_LISTS_H
#include        <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif
#ifndef DOS_DOS_H
#include        <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif

#define FSRNAME "FileSystem.resource"

struct FileSysResource {
    @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} fsr_Node;               /* on resource list */
    char   *fsr_Creator;                /* name of creator of this resource */
    @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} fsr_FileSysEntries;     /* list of FileSysEntry structs */
};

struct FileSysEntry {
    @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} fse_Node;       /* on fsr_FileSysEntries list */
                                /* ln_Name is of creator of this entry */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fse_DosType;        /* DosType of this FileSys */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fse_Version;        /* Version of this FileSys */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fse_PatchFlags;     /* bits set for those of the following that */
                                /*   need to be substituted into a standard */
                                /*   device node for this file system: e.g. */
                                /*   0x180 for substitute SegList & GlobalVec */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fse_Type;           /* device node type: zero */
    @{"CPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 85}    fse_Task;           /* standard dos "task" field */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    fse_Lock;           /* not used for devices: zero */
    @{"BSTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 131}    fse_Handler;        /* filename to loadseg (if SegList is null) */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fse_StackSize;      /* stacksize to use when starting task */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    fse_Priority;       /* task priority when starting task */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    fse_Startup;        /* startup msg: FileSysStartupMsg for disks */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    fse_SegList;        /* code to run to start new task */
    @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    fse_GlobalVec;      /* BCPL global vector when starting task */
    /* no more entries need exist than those implied by fse_PatchFlags */
};

#endif  /* RESOURCES_FILESYSRES_H */
@ENDNODE
