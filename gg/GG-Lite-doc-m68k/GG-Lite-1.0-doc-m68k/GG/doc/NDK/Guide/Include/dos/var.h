@DATABASE "gg:doc/NDK/Guide/Include/dos/var.h"
@MASTER   "gg:os-include/dos/var.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:07
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "dos/var.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"dos/var.h" LINK File}


@{b}Structures@{ub}

@{"LocalVar" LINK "gg:doc/NDK/Guide/Include/dos/var.h/File" 25}


@{b}#defines@{ub}

@{"GVB_BINARY_VAR" LINK "gg:doc/NDK/Guide/Include/dos/var.h/File" 51}  @{"GVB_DONT_NULL_TERM" LINK "gg:doc/NDK/Guide/Include/dos/var.h/File" 53}  @{"GVB_GLOBAL_ONLY" LINK "gg:doc/NDK/Guide/Include/dos/var.h/File" 47}     @{"GVB_LOCAL_ONLY" LINK "gg:doc/NDK/Guide/Include/dos/var.h/File" 49}
@{"GVB_SAVE_VAR" LINK "gg:doc/NDK/Guide/Include/dos/var.h/File" 58}    @{"GVF_BINARY_VAR" LINK "gg:doc/NDK/Guide/Include/dos/var.h/File" 52}      @{"GVF_DONT_NULL_TERM" LINK "gg:doc/NDK/Guide/Include/dos/var.h/File" 54}  @{"GVF_GLOBAL_ONLY" LINK "gg:doc/NDK/Guide/Include/dos/var.h/File" 48}
@{"GVF_LOCAL_ONLY" LINK "gg:doc/NDK/Guide/Include/dos/var.h/File" 50}  @{"GVF_SAVE_VAR" LINK "gg:doc/NDK/Guide/Include/dos/var.h/File" 59}        @{"LV_ALIAS" LINK "gg:doc/NDK/Guide/Include/dos/var.h/File" 39}            @{"LV_VAR" LINK "gg:doc/NDK/Guide/Include/dos/var.h/File" 38}
@{"LVB_IGNORE" LINK "gg:doc/NDK/Guide/Include/dos/var.h/File" 41}      @{"LVF_IGNORE" LINK "gg:doc/NDK/Guide/Include/dos/var.h/File" 42}          

@ENDNODE
@NODE File "dos/var.h"
#ifndef DOS_VAR_H
#define DOS_VAR_H
/*
**
**      $VER: var.h 36.11 (2.6.1992)
**      Includes Release 45.1
**
**      include file for dos local and environment variables
**
**      (C) Copyright 1989-2001 Amiga, Inc.
**          All Rights Reserved
**
*/


#ifndef EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif

/* the structure in the pr_LocalVars list */
/* Do @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} allocate yourself, use @{"SetVar()" LINK "gg:doc/NDK/Guide/dos/SetVar"}!!! This structure may grow in */
/* future releases!  The list should be left in alphabetical order, and */
/* may have multiple entries with the same name but different types.    */

struct LocalVar {
        @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} lv_Node;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   lv_Flags;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *lv_Value;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   lv_Len;
};

/*
 * The lv_Flags bits are available to the application.  The unused
 * lv_Node.ln_Pri bits are reserved for system use.
 */

/* bit definitions for lv_Node.ln_Type: */
#define LV_VAR                  0       /* an variable */
#define LV_ALIAS                1       /* an alias */
/* to be or'ed into type: */
#define LVB_IGNORE              7       /* ignore this entry on @{"GetVar" LINK "gg:doc/NDK/Guide/dos/GetVar"}, etc */
#define LVF_IGNORE              0x80

/* definitions of flags passed to @{"GetVar()" LINK "gg:doc/NDK/Guide/dos/GetVar"}/@{"SetVar()" LINK "gg:doc/NDK/Guide/dos/SetVar"}/@{"DeleteVar()" LINK "gg:doc/NDK/Guide/dos/DeleteVar"} */
/* bit defs to be OR'ed with the type: */
/* item will be treated as a single line of text unless BINARY_VAR is used */
#define GVB_GLOBAL_ONLY         8
#define GVF_GLOBAL_ONLY         0x100
#define GVB_LOCAL_ONLY          9
#define GVF_LOCAL_ONLY          0x200
#define GVB_BINARY_VAR          10              /* treat variable as binary */
#define GVF_BINARY_VAR          0x400
#define GVB_DONT_NULL_TERM      11      /* only with @{"GVF_BINARY_VAR" LINK File 52} */
#define GVF_DONT_NULL_TERM      0x800

/* this is only supported in >= V39 dos.  V37 dos ignores this. */
/* this causes @{"SetVar" LINK "gg:doc/NDK/Guide/dos/SetVar"} to affect ENVARC: as well as ENV:.        */
#define GVB_SAVE_VAR            12      /* only with GVF_GLOBAL_VAR */
#define GVF_SAVE_VAR            0x1000

#endif /* DOS_VAR_H */
@ENDNODE
