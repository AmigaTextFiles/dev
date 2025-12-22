@DATABASE "gg:doc/NDK/Guide/Include/exec/interrupts.h"
@MASTER   "gg:os-include/exec/interrupts.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:13
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "exec/interrupts.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"exec/interrupts.h" LINK File}


@{b}Structures@{ub}

@{"Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22}  @{"IntVector" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 29}  @{"SoftIntList" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 36}


@{b}#defines@{ub}

@{"INTB_NMI" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 44}  @{"INTF_NMI" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 45}  @{"SIH_PRIMASK" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 41}

@ENDNODE
@NODE File "exec/interrupts.h"
#ifndef EXEC_INTERRUPTS_H
#define EXEC_INTERRUPTS_H
/*
**      $VER: interrupts.h 39.1 (18.9.1992)
**      Includes Release 45.1
**
**      Callback structures used by hardware & software interrupts
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif /* EXEC_NODES_H */

#ifndef EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif /* EXEC_LISTS_H */


struct Interrupt {
    @{"struct  Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} is_Node;
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    is_Data;                /* server data segment  */
    @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24}    (*is_Code)();           /* server code entry    */
};


struct IntVector {              /* For EXEC use ONLY! */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    iv_Data;
    @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24}    (*iv_Code)();
    @{"struct  Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *iv_Node;
};


struct SoftIntList {            /* For EXEC use ONLY! */
    @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} sh_List;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}  sh_Pad;
};

#define SIH_PRIMASK (0xf0)

/* this is a fake INT definition, used only for @{"AddIntServer" LINK "gg:doc/NDK/Guide/exec/AddIntServer"} and the like */
#define INTB_NMI        15
#define INTF_NMI        (1L<<15)

#endif  /* EXEC_INTERRUPTS_H */
@ENDNODE
