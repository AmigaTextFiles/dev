****h* SysHardAsm/SysHardAsm.asm ************************************
*
* NAME
*    SysHardAsm.asm
*
* DESCRIPTION
*    Get some information about the CACR values.
*
* NOTES
*    $VER: SysHardAsm.asm 1.0 (14-Feb-2001) by J.T. Steichen
*********************************************************************
*
*

     XDEF _GetCacheReg
     XDEF _GetMMUsrReg
     XDEF _GetCACR
     XDEF _GetMMUsr

GETCACHEREG EQU $4E7A0002 ; In case asm can't handle 68040 instructions
GETMMUSRREG EQU $4E7A0805

* Called by the exec function Supervisor():

_GetCacheReg:

     DC.L    GETCACHEREG
*     MOVEC.L CACR,D0 ; $4E7A, $0002
     RTE

_GetMMUsrReg:

     DC.L    GETMMUSRREG
*     MOVEC.L MMUSR,D0 ;$4E7A, $0805
     RTE 

**************************************************************

_GetCACR:
     MOVE.L 4,A6
     JSR    -150(A6)     ; SuperState

     DC.L   GETCACHEREG
*     MOVEC  CACR,D0      ; Get the CACR register into D0.
     MOVE.L D0,save_cacr ; save it in case UserState trashes D0.

     MOVE.L 4,A6
     JSR    -156(A6)     ; UserState

     MOVE.L save_cacr,D0 ; Restore save_cacr

     RTS

_GetMMUsr:
     MOVE.L 4,A6
     JSR    -150(A6)      ; SuperState

     DC.L   GETMMUSRREG
*     MOVEC  MMUSR,D0      ; Get the CACR register into D0.
     MOVE.L D0,save_MMUSR ; save it in case UserState trashes D0.

     MOVE.L 4,A6
     JSR    -156(A6)      ; UserState

     MOVE.L save_MMUSR,D0 ; Restore save_MMUSR

     RTS

save_cacr   DC.L   00000000
save_MMUSR  DC.L   00000000

     END
