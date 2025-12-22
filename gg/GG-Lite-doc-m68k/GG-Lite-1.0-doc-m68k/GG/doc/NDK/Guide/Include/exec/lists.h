@DATABASE "gg:doc/NDK/Guide/Include/exec/lists.h"
@MASTER   "gg:os-include/exec/lists.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:15
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "exec/lists.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"exec/lists.h" LINK File}


@{b}Structures@{ub}

@{"List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20}  @{"MinList" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 31}


@{b}#defines@{ub}

@{"IsListEmpty()" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 50}  @{"IsMsgPortEmpty()" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 53}

@ENDNODE
@NODE File "exec/lists.h"
#ifndef EXEC_LISTS_H
#define EXEC_LISTS_H
/*
**      $VER: lists.h 39.0 (15.10.1991)
**      Includes Release 45.1
**
**      Definitions and macros for use with Exec lists
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif /* EXEC_NODES_H */

/*
 *  Full featured list header.
 */
struct List {
   @{"struct  Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *lh_Head;
   @{"struct  Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *lh_Tail;
   @{"struct  Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *lh_TailPred;
   @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   lh_Type;
   @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   l_pad;
};      /* word aligned */

/*
 * Minimal List Header - no type checking
 */
struct MinList {
   @{"struct  MinNode" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 31} *mlh_Head;
   @{"struct  MinNode" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 31} *mlh_Tail;
   @{"struct  MinNode" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 31} *mlh_TailPred;
};      /* longword aligned */


/*
 *      Check for the presence of any nodes on the given list.  These
 *      macros are even safe to use on lists that are modified by other
 *      tasks.  However; if something is simultaneously changing the
 *      list, the result of the test is unpredictable.
 *
 *      Unless you first arbitrated for ownership of the list, you can't
 *      _depend_ on the contents of the list.  Nodes might have been added
 *      or removed during or after the macro executes.
 *
 *              if( @{"IsListEmpty" LINK File 50}(list) )         @{"printf" LINK "gg:doc/NDK/Guide/amiga_lib/printf"}("List is empty\\n");
 */
#define IsListEmpty(x) \\
        ( ((x)->lh_TailPred) == (@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *)(x) )

#define IsMsgPortEmpty(x) \\
        ( ((x)->mp_MsgList.lh_TailPred) == (@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *)(&(x)->mp_MsgList) )


#endif  /* EXEC_LISTS_H */
@ENDNODE
