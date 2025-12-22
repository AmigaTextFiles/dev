
;-- 68000/68020 MULS.l and DIVS.l macro
;-- NB. When compiling for 68020+ the compiler MUST define CPU68000 otherwise it`ll default to 68020 mode.
;--     Also, must have a defined value for PB_UtilityBase as it`s needed for 68000 mode.

; LVOs used.
_OpenLibrary   = -$228
_CloseLibrary  = -$19e
_SMult32       = -$8a
_SDivMod32     = -$96

;----------------------------------------------------------------------
 MACRO PB_OpenUtility
  IFD CPU68000
   LEA PB_UtilityName(pc),a1
   MOVEQ #36,d0
   JSR _OpenLibrary(a6)
   MOVE.l d0,PB_UtilityBase(a4)
   BEQ PB_QuitProgram
   BRA PB_OpenUtilEnd
PB_UtilityName:
   dc.b "utility.library",0
   EVEN 
PB_OpenUtilEnd:
    
  ENDIF
 ENDM

;----------------------------------------------------------------------
 MACRO PB_CloseUtility
  IFD CPU68000
    MOVEA.l PB_UtilityBase(a4),a1
    JSR _CloseLibrary(a6)
  ENDIF
 ENDM

;----------------------------------------------------------------------
;--  support macro to put the right args in the right regs for 68000.
;--  Self optimising too ;)

 MACRO PB_MATHS_PREP_REGS
  IFC "\2","d1"
   IFC "\1","d0"
    ; eg .Gonna do a Muls.l d0,d1 !!
    EXG.l d0,d1
   ELSE
     ; Do \2 (d1) first..     
     MOVE.l d1,d0
     MOVE.l \1,d1
   ENDIF
  ELSE
    ; Std swap..
    IFNC "\1","d1"
      MOVE.l \1,d1
    ENDIF
    IFNC "\2","d0"
      MOVE.l \2,d0
    ENDIF
  ENDIF
 ENDM

;-- Use these as you would the normal Muls.l or Divs.l
;-- eg.  PB_MULSL #7,d0 ,PB_MULSL d3,d1 PB_DIVSL #3,d0

;-- WARNING: Trashes d0/d1 ..

;----------------------------------------------------------------------
 MACRO PB_MULSL
   IFD CPU68000

     ;- 68000 Mode
     MOVEA.l a6,-(a7)
     MOVEA.l PB_UtilityBase(a4),a6
     PB_MATHS_PREP_REGS \1,\2
     JSR _SMult32(a6)
     IFNC "\2","d0"
         MOVE.l d0,\2
     ENDIF
     MOVEA.l (a7)+,a6

   ELSE

     ;- 68020+
     Muls.l \1,\2

   ENDIF
 ENDM

;----------------------------------------------------------------------
 MACRO PB_DIVSL
   IFD CPU68000

     ;- 68000 Mode
     MOVE.l a6,-(a7)
     MOVEA.l PB_UtilityBase(a4),a6
     PB_MATHS_PREP_REGS \1,\2
     JSR _SDivMod32(a6)
     IFNC "\2","d0"
       MOVE.l d0,\2
     ENDIF
     MOVE.l (a7)+,a6

   ELSE
     ;-68020+
     Divs.l \1,\2
   ENDIF
 ENDM
