@DATABASE "gg:doc/NDK/Guide/Include/exec/avl.h"
@MASTER   "gg:os-include/exec/avl.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:10
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "exec/avl.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"exec/avl.h" LINK File}


@{b}Structures@{ub}

@{"AVLNode" LINK "gg:doc/NDK/Guide/Include/exec/avl.h/File" 20}


@{b}Typedefs@{ub}

@{"AVLKey" LINK "gg:doc/NDK/Guide/Include/exec/avl.h/File" 26}  @{"avlkey" LINK "gg:doc/NDK/Guide/Include/exec/avl.h/File" 34}  @{"AVLKEYCOMP" LINK "gg:doc/NDK/Guide/Include/exec/avl.h/File" 37}  @{"avlnode2" LINK "gg:doc/NDK/Guide/Include/exec/avl.h/File" 33}  @{"AVLNODECOMP" LINK "gg:doc/NDK/Guide/Include/exec/avl.h/File" 36}

@ENDNODE
@NODE File "exec/avl.h"
#ifndef EXEC_AVL_H
#define EXEC_AVL_H
/*
**      $VER: avl.h 45.4 (27.2.2001)
**      Includes Release 45.1
**
**      AVL tree data structure definitions
**
**      (C) Copyright 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif /* EXEC_TYPES_H */

/* Don't even think about the contents of this structure. Just embed it
 * and reference it
 */
struct AVLNode
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} reserved[4];
};

/* Note that this is really a totally abstract 32 bit value */
typedef void * AVLKey;

/* Callback functions for the AVL tree handling. They will have to return
 * strcmp like results for the given arguments (<0/0/>0).
 * You can compare to nodes or a node with a key.
 */
#ifdef __SASC
typedef @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} (* __asm AVLNODECOMP)(register __a0 @{"struct AVLNode" LINK File 20} *avlnode1, register __a1 struct AVLNode *avlnode2);
typedef @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} (* __asm AVLKEYCOMP)(register __a0 @{"struct AVLNode" LINK File 20} *avlnode1, register __a1 AVLKey avlkey);
#else
typedef @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} AVLNODECOMP;
typedef @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} AVLKEYCOMP;
#endif /* __SASC */

#endif /* EXEC_AVL_H */
@ENDNODE
