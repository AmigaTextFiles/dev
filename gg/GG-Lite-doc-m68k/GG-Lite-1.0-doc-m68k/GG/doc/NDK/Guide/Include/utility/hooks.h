@DATABASE "gg:doc/NDK/Guide/Include/utility/hooks.h"
@MASTER   "gg:os-include/utility/hooks.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:32
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "utility/hooks.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"utility/hooks.h" LINK File}


@{b}Structures@{ub}

@{"Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28}


@{b}Typedefs@{ub}

@{"HOOKFUNC" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 39}

@ENDNODE
@NODE File "utility/hooks.h"
#ifndef UTILITY_HOOKS_H
#define UTILITY_HOOKS_H
/*
**      $VER: hooks.h 39.2 (16.6.1993)
**      Includes Release 45.1
**
**      Callback hooks
**
**      (C) Copyright 1989-2001 Amiga, Inc.
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


struct Hook
{
    @{"struct MinNode" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 31} h_MinNode;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}          (*h_Entry)();        /* assembler entry point */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}          (*h_SubEntry)();     /* often HLL entry point */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}           h_Data;              /* owner specific        */
};

/* Useful definition for casting function pointers:
 * hook.h_SubEntry = (@{"HOOKFUNC" LINK File 39})AFunction
 */
typedef unsigned long (*HOOKFUNC)();

/* Hook calling conventions.
 *
 * The function pointed to by Hook.h_Entry is called with the following
 * parameters:
 *
 *      A0 - pointer to hook data structure itself
 *      A1 - pointer to parameter structure ("message")
 *      A2 - Hook specific address data ("object")
 *
 * Control will be passed to the routine h_Entry.  For many
 * High-Level Languages (HLL), this will be an assembly language
 * stub which pushes registers on the stack, does other setup,
 * and then calls the function at h_SubEntry.
 *
 * The standard C receiving code is:
 *
 *    HookFunc(@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *hook, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} object, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} message)
 *
 * Note that register natural order differs from this convention for C
 * parameter order, which is A0,A2,A1.
 *
 * The assembly language stub for "vanilla" C parameter conventions
 * could be:
 *
 * _hookEntry:
 *      move.l  a1,-(sp)                ; push message packet pointer
 *      move.l  a2,-(sp)                ; push object pointer
 *      move.l  a0,-(sp)                ; push hook pointer
 *      move.l  h_SubEntry(a0),a0       ; fetch C entry point ...
 *      jsr     (a0)                    ; ... and call it
 *      lea     12(sp),sp               ; fix stack
 *      rts
 *
 * With this function as your interface stub, you can write a Hook setup
 * function as:
 *
 * InitHook(@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *hook, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} (*c_function)(), @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} userdata)
 * {
 * @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} (*hookEntry)();
 *
 *     hook->h_Entry    = hookEntry;
 *     hook->h_SubEntry = c_function;
 *     hook->h_Data     = userdata;
 * }
 *
 * With a compiler capable of registerized parameters, such as SAS C, you
 * can put the C function in the h_Entry field directly. For example, for
 * SAS C:
 *
 *   @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} __saveds __asm HookFunc(register __a0 @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *hook,
 *                                 register __a2 @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}         object,
 *                                 register __a1 @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}         message);
 *
 */


/*****************************************************************************/


#endif /* UTILITY_HOOKS_H */
@ENDNODE
