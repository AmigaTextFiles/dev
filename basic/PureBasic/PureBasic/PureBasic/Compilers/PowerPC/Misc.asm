#
#
#            Misc - OS dependant routines
#            ----------------------------
#
#
# 02/06/2001
#   First version
#

#.set PB_NeedAllocateMultiArray, 1
#.set PB_Debugger, 1

#.set PB_GlobalBankSize, 100
#.set PB_GraphicsOffset, 20
#.set PB_DebuggerPort  , 10
#.set PB_SourceAddr    , 100


 .macro InitProgram

    .file "PureBasic_PPC.asm"

    .extern _PowerPCBase
    .extern _SysBase

    .include "PureBasic:Compilers/PowerPC/PPCMacros.pasm"
    .include "PureBasic:Compilers/PowerPC/Extras_ppcmacros.pasm"

    .sdreg r2
    .text
    .global __ppc_startup
    .align 3

__ppc_startup:
    prolog

    liw r4,PB_GlobalBankSize
    liw r5,65536
    li r6,0
    CALLPOWERPC AllocVecPPC
    mr r14,r3

 .endm


 .macro QuitProgram

   CALLPOWERPC FreeAllMem

   li r3,0
   epilog

 .endm


 .macro SubRoutines

 .endm


# InitProgram
# QuitProgram
# SubRoutines
