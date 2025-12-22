;
; PhxAss macros definition for PureBasic libraries...
;
; 22/02/2000
;   Added EVEN to 'endfunc' (to prevent bugs...)
;
; 20/09/1999
;   Finished the work
;
; 19/09/1999
;   First version
;


 INCLUDE "PureBasic:Library SDK/PhxAss/AmigaLibs.asm"

_ExecBase      = 1
_GraphicsBase  = 2
_IntuitionBase = 3
_DosBase       = 4

byte     = 1
word     = 1 << 1
long     = 1 << 2
llist    = 1 << 3
listelem = 1 << 4
array    = 1 << 5
string   = 1 << 6


 macro PB_BuildConstD
d\1_b = \1 << 8 + byte
d\1_w = \1 << 8 + word
d\1_l = \1 << 8 + long
 endm


 macro PB_BuildConstA
a\1_b = (\1+8) << 8 + byte
a\1_w = (\1+8) << 8 + word
a\1_l = (\1+8) << 8 + long
a\1_list     = (\1+8) << 8 + llist
a\1_listelem = (\1+8) << 8 + listelem
 endm

 PB_BuildConstD 0
 PB_BuildConstD 1
 PB_BuildConstD 2
 PB_BuildConstD 3
 PB_BuildConstD 4
 PB_BuildConstD 5
 PB_BuildConstD 6
 PB_BuildConstD 7

 PB_BuildConstA 0
 PB_BuildConstA 1
 PB_BuildConstA 2
 PB_BuildConstA 3
 PB_BuildConstA 4
 PB_BuildConstA 5
 PB_BuildConstA 6
 PB_BuildConstA 7

d0 = 0
d1 = 1
d2 = 2
d3 = 3
d4 = 4
d5 = 5
d6 = 6
d7 = 7

a0 = 8
a1 = 9
a2 = 10
a3 = 11
a4 = 12
a5 = 13
a6 = 14
a7 = 15

;
; Possible Flags:
; ---------------
;

NoBase       = 1
InLine       = 1 << 1
ByteResult   = 1 << 2
LongResult   = 1 << 3
StringResult = 1 << 4

 macro initlib
  dc.l 'PBLI'
  dc.l 1        ; Library ID (not used)
  dc.b \1, 0    ; Name of the library
  dc.b \2, 0    ; Filename of the helpfile of this lib
  dc.b \3, 0    ; end function Name
  Even
  dc.w \4       ; Priority of the end call
  dc.b \5, \6   ; Version, Revision (ie: V0.12)
 endm


 macro name
  Dc.b \1, 0
  Dc.b \2, 0
  Even
 endm


 macro flags
  IFGT NARG
    Dc.b \1
  ELSE
    Dc.b 0
  ENDIF
 endm


 macro amigalibs
  Dc.b NARG/2     ; number of parameter of the macro/2

  IFGT NARG - 1   ; Equal to the line: 'IF NARG-1'
    Dc.b \1, \2
  ENDIF

  IFGT NARG - 3
    Dc.b \3, \4
  ENDIF

  IFGT NARG - 5
    Dc.b \5, \6
  ENDIF

  IFGT NARG - 7
    Dc.b \7, \8
  ENDIF
 endm


 macro params
  Dc.w NARG                        ; Set NbArg number..

  IFGT NARG
    Dc.w \1
  ENDIF

  IFGT NARG - 1
    Dc.w \2
  ENDIF

  IFGT NARG - 2
    Dc.w \3
  ENDIF

  IFGT NARG - 3
    Dc.w \4
  ENDIF

  IFGT NARG - 4
    Dc.w \5
  ENDIF

  IFGT NARG - 5
    Dc.w \6
  ENDIF

  IFGT NARG - 6
    Dc.w \7
  ENDIF

  IFGT NARG - 7
    Dc.w \8
  ENDIF
 endm


 macro debugger  ; Number of the debugger routine
  IFGT NARG-1
    LEA.l _PB_StartDebuggerPart(pc),a0
    LEA.l \2(pc),a0
  ELSE
    Dc.w 0,0
    Dc.w 0,0
  ENDIF

  LEA.l _PB_Label_FL_\1(pc),a0 ; Was NUMFUNC
 endm


 macro endfunc
 EVEN
_PB_Label_FL_\1:
 endm


 macro base
  Dc.b "_P_",0
  LEA.l _PB_BaseLabel(pc),a0
 endm

 macro endlib
  Even
_PB_BaseLabel:
 endm


 macro startdebugger
  LEA.l _PB_EndDebuggerPart(pc),a0
_PB_StartDebuggerPart:
 endm


 macro enddebugger
  Even
_PB_EndDebuggerPart:
  Dc.l "ENDG"
 endm


 macro debugerror
  LEA.l   _PB_ErrorText\@,a0
  MOVE.l   a0,16(a4)
  MOVE.l   #8,4(a4)
  RTS

_PB_ErrorText\@:

  Dc.b \1,0
  Even
 endm

 RTS
