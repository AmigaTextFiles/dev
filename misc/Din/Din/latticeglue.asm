*==================================================*
*                                                  *
*       din library glue code                      *
*       (for Lattice C)                            *
*                                                  *
*       Copyright © 1990 by Jorrit Tyberghein      *
*                                                  *
*==================================================*

*--------------------------------------------------------------------*
*                                                                    *
*    To assemble the SMALL_CODE version :                            *
*      asm -oLIB:dinSCglue.o -iINCLUDE: -dSMALL_CODE latticeglue.asm *
*                                                                    *
*    To assemble the LARGE_CODE version :                            *
*      asm -oLIB:dinLCglue.o -iINCLUDE: -dLARGE_CODE latticeglue.asm *
*                                                                    *
*    To use, link with 'LIB:dinSCglue.o' or 'LIB:dinLCglue.o'        *
*                                                                    *
*    (based on ARP glue code, thanks arp (and Nico François) :-)     *
*                                                                    *
*--------------------------------------------------------------------*

         IFND LIBRARIES_DIN_LIB_I
         include "libraries/din_lib.i"
         ENDC

* First some macros

GLUEDEF  MACRO
         XDEF _\1
_\1:
THIS_LIB SET _LVO\1           ; Set the offset to call
         ENDM

*
*        Set SMALL_CODE=1 for a4 addressing...
*        Set LARGE_CODE=1 for absolute addressing...
*        if neither, just cause an error...
*

CALLDIN MACRO
        move.l  a6,-(a7)        ; Save a6...

        IFD     SMALL_CODE
        move.l  _DinBase(a4),a6 ; If a4 addressing....
        ENDC

        IFD     LARGE_CODE
        move.l  _DinBase,a6     ; If not a4 addressing...
        ENDC

        IFND    SMALL_CODE
        IFND    LARGE_CODE
        moveq.l #12323,a0       ; Cause an error!
        ENDC
        ENDC

        jsr     THIS_LIB(a6)

        move.l  (a7)+,a6
        ENDM

* Now for the actual glue routines

        XREF    _DinBase

        SECTION "DinGlue",CODE

*    ULONG NotifyDinLinks (struct DinObject *, ULONG);
*    D0                    A0                  D0

        GLUEDEF NotifyDinLinks
        move.l  4(a7),a0
        move.l  8(a7),d0
        CALLDIN
        rts

*    void ResetDinLinkFlags (struct DinLink *);
*                            A0

        GLUEDEF ResetDinLinkFlags
        move.l  4(a7),a0
        CALLDIN
        rts

*    struct DinObject *MakeDinObject (char *, UWORD, ULONG, APTR, ULONG);
*    D0                               A0      D0     D1     A1    D2

        GLUEDEF MakeDinObject
        move.l  d2,-(a7)
        move.l  4+4(a7),a0
        movem.l 4+8(a7),d0-d1/a1
        move.l  4+20(a7),d2
        CALLDIN
        move.l  (a7)+,d2
        rts

*    BOOL EnableDinObject (struct DinObject *);
*    D0                    A0

        GLUEDEF EnableDinObject
        move.l  4(a7),a0
        CALLDIN
        rts

*    BOOL DisableDinObject (struct DinObject *);
*    D0                     A0

        GLUEDEF DisableDinObject
        move.l  4(a7),a0
        CALLDIN
        rts

*    BOOL PropagateDinObject (struct DinObject *, struct Task *);
*    D0                       A0                  A1

        GLUEDEF PropagateDinObject
        movem.l 4(a7),a0-a1
        CALLDIN
        rts

*    BOOL RemoveDinObject (struct DinObject *);
*    D0                    A0

        GLUEDEF RemoveDinObject
        move.l  4(a7),a0
        CALLDIN
        rts

*    BOOL LockDinObject (struct DinObject *);
*    D0                  A0

        GLUEDEF LockDinObject
        move.l  4(a7),a0
        CALLDIN
        rts

*    BOOL UnlockDinObject (struct DinObject *);
*    D0                    A0

        GLUEDEF UnlockDinObject
        move.l  4(a7),a0
        CALLDIN
        rts

*    struct DinObject *FindDinObject (char *);
*    D0                               A0

        GLUEDEF FindDinObject
        move.l  4(a7),a0
        CALLDIN
        rts

*    struct DinLink *MakeDinLink (struct DinObject *, char *);
*    D0                           A0                  A1

        GLUEDEF MakeDinLink
        movem.l 4(a7),a0-a1
        CALLDIN
        rts

*    void RemoveDinLink (struct DinLink *);
*                        A0

        GLUEDEF RemoveDinLink
        move.l  4(a7),a0
        CALLDIN
        rts

*    BOOL ReadLockDinObject (struct DinObject *);
*    D0                      A0

        GLUEDEF ReadLockDinObject
        move.l  4(a7),a0
        CALLDIN
        rts

*    void ReadUnlockDinObject (struct DinObject *);
*                              A0

        GLUEDEF ReadUnlockDinObject
        move.l  4(a7),a0
        CALLDIN
        rts

*    BOOL WriteLockDinObject (struct DinObject *);
*    D0                       A0

        GLUEDEF WriteLockDinObject
        move.l  4(a7),a0
        CALLDIN
        rts

*    void WriteUnlockDinObject (struct DinObject *);
*                               A0

        GLUEDEF WriteUnlockDinObject
        move.l  4(a7),a0
        CALLDIN
        rts

*    void LockDinBase (void);
*

        GLUEDEF LockDinBase
        CALLDIN
        rts

*    void UnlockDinBase (void);
*

        GLUEDEF UnlockDinBase
        CALLDIN
        rts

*    struct InfoDinObject *InfoDinObject (struct DinObject *);
*    D0                                   A0

        GLUEDEF InfoDinObject
        move.l  4(a7),a0
        CALLDIN
        rts

*    void FreeInfoDinObject (struct InfoDinObject *);
*                            A0

        GLUEDEF FreeInfoDinObject
        move.l  4(a7),a0
        CALLDIN
        rts

        END
