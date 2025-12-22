         xref     _LVODisable,_LVOEnable
         xref     _LVOSuperState
         xref     _LVOUserState
         xref     _VBR
         xref     _SSP
         xdef     _ReadVBR

_ReadVBR:
         movem.l  d0-d7/a0-a6,-(a7)
         move.l   $4,a6
         jsr      _LVODisable(a6)      ; Disable interrupts
         jsr      _LVOSuperState(a6)   ; go to supervisor mode
         move.l   d0,d7
MagicCode:
         ; VBRRegister -> C variables
;         movec    VBR,d0
         dc.w     $4e7a,$0801

         move.l   d0,_VBR
         move.l   a7,_SSP              ; SSP

         move.l   d7,d0                ; go to user mode
         jsr      _LVOUserState(a6)
         jsr      _LVOEnable(a6)       ; Enable interrrupts
End:     movem.l  (a7)+,d0-d7/a0-a6
         rts

         END
