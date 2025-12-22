; --------------------------------------------------------------------------------------
;
; This source file is part of PureBasic
; For the latest info, see http://www.purebasic.com/
; 
; Copyright (c) 1998-2006 Fantaisie Software
;
; This program is free software; you can redistribute it and/or modify it under
; the terms of the GNU Lesser General Public License as published by the Free Software
; Foundation; either version 2 of the License, or (at your option) any later
; version.
;
; This program is distributed in the hope that it will be useful, but WITHOUT
; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
; FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
;
; You should have received a copy of the GNU Lesser General Public License along with
; this program; if not, write to the Free Software Foundation, Inc., 59 Temple
; Place - Suite 330, Boston, MA 02111-1307, USA, or go to
; http://www.gnu.org/copyleft/lesser.txt.
;
; Note: As PureBasic is a compiler, the programs created with PureBasic are not
; covered by the LGPL license, but are fully free, license free and royality free
; software.
;
; --------------------------------------------------------------------------------------
;
; PhxAss macros definition for PureBasic libraries...

; 20/02/2005
;   -Doobrey-
;   Added error checking and reporting to the compile process.
;   Stops things getting added in the wrong order...
;   ..needed when idiots like me build userlibs !
;
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



;---------------------------------------------------------------------
; Silly little macro for Inline JSR and RTS .. means less work if Inline 
; doesn`t get implemented.

; eg. if the last instruction in the lib was JMP _LVO(a6)
;    use   I_JSR _LVO(a6)
;
;  


 MACRO I_RTS
  IFND INLINE_MODE
	RTS
  ENDIF
 ENDM


 MACRO I_JSR
   IFND INLINE_MODE
	JMP  \1
   ELSE
	JSR  \1
   ENDIF
 ENDM


;---------------------------------------------------------------------
; Various stuff added for error checking when building a userlib.

PB_FuncOpen	SET 1
PB_LibInit	SET 0
PB_LibState SET 0
PB_DebugState SET 0
PB_LastOpen  SET 0

 MACRO PB_BuildError
	ECHO \1
	ECHO ""
	FAIL
 ENDM

 MACRO PB_TestInit
   IFEQ PB_LibInit
   	PB_BuildError "Error: 'initlib' not declared !"
   ENDIF
 ENDM

 MACRO PB_TestState
  IFNE (\1 - PB_LibState)
     PB_BuildError \2
  ELSE
PB_LibState SET (PB_LibState+1)
  ENDIF
 ENDM

;---------------------------------------------------------------------
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
d\1_s = \1 << 8 + string
 endm


 macro PB_BuildConstA
a\1_b = (\1+8) << 8 + byte
a\1_w = (\1+8) << 8 + word
a\1_l = (\1+8) << 8 + long
a\1_s = (\1+8) << 8 + string
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
NoResult	     = 0

NoBase           = 1
InLine           = 1 << 1
ByteResult       = 1 << 2
LongResult       = 1 << 3
StringResult     = 1 << 4
FloatReturn      = 1 << 5
FpuFunction      = 1 << 6

InternalFunction = 1 << 7
DebuggerCheck    = 1 << 8

InitFunction     = (1 << 9)|LongResult


;--------------------------------------------------------------------

 macro initlib
  IF PB_LibInit
     PB_BuildError "Error: 'initlib' already declared !"
  ENDIF

  dc.l 'PBLI'
  dc.l 1        ; Library ID (not used)
  dc.b \1, 0    ; Name of the library
  dc.b \2, 0    ; Filename of the helpfile of this lib
  dc.b \3, 0    ; end function Name
  Even
  dc.w \4       ; Priority of the end call
  dc.b \5, \6   ; Version, Revision (ie: V0.12)
PB_LibInit	SET	1		;## Doob..error checking .
 endm

;--------------------------------------------------------------------

 macro name
  PB_TestInit
  PB_TestState 0, "Error: 'name' declared out of place."
  Dc.b \1, 0
  Dc.b \2, 0
  Even
 endm

;--------------------------------------------------------------------

 macro flags
  PB_TestInit
  PB_TestState 1, "Error: 'flags' declared out of place."
  IFGT NARG
    Dc.w \1
  ELSE
    Dc.w 0
  ENDIF
 endm

;--------------------------------------------------------------------

 macro amigalibs
  PB_TestInit
  PB_TestState 2, "Error: 'amigalibs' declared out of place."
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

  Even
 endm

;--------------------------------------------------------------------

 macro params
 PB_TestInit
 PB_TestState 3, "Error: 'params' declared out of place."
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

;--------------------------------------------------------------------
;-D- Auto incrementing and checking..

 macro debugger  ; Number of the debugger routine
  PB_TestInit
  PB_TestState 4, "Error: 'debugger' declared out of place."" 

  IFD PB_OPEN\1
    PB_BuildError "Function # already used"
  ENDIF 

  IFGT NARG-1
    LEA.l _PB_StartDebuggerPart(pc),a0
    LEA.l \2(pc),a0
  ELSE
    Dc.w 0,0
    Dc.w 0,0
  ENDIF


PB_OPEN\1 SET 1
PB_LastOpen SET \1

  LEA.l _PB_Label_FL_\1(pc),a0 ; Was NUMFUNC
 endm

;--------------------------------------------------------------------

 macro endfunc
  PB_TestInit
  PB_TestState 5, "Error: 'endfunc' declared out of place."
  IFNE (PB_LastOpen-\1)
    PB_BuildError "Mismatched endfunc #"
  ENDIF

 ;-D-EVEN
 CNOP 0,4 ;-LW Align
_PB_Label_FL_\1:

PB_LibState SET 0
PB_LibInit  SET 2	 
 endm

;--------------------------------------------------------------------

 macro base
  PB_TestInit
  IFNE (PB_LibInit-2)
    IFEQ (PB_LibInit-1)
     PB_BuildError "Error: 'base' declared inside a function!"
    ELSE
     PB_BuildError "Error: 'base' declared after 'endlib' !!"
    ENDIF
  ENDIF

  Dc.b "_P_",0
  LEA.l _PB_BaseLabel(pc),a0
 endm

;--------------------------------------------------------------------

 macro endlib
  PB_TestInit
  IFNE (PB_LibInit-2)
     PB_BuildError "Error: 'endlib' called out of line!"
  ELSE
PB_LibInit SET 3
  ENDIF

  ;-D- Even
  CNOP 0,4	;-LW
_PB_BaseLabel:
 endm

;----------------------------------------------------------------------

 macro startdebugger
  PB_TestInit
  IFNE (PB_LibInit-3)
    PB_BuildError "Error: 'startdebugger' declared before 'endlib'."
  ENDIF

PB_DebugState SET 1
  LEA.l _PB_EndDebuggerPart(pc),a0
_PB_StartDebuggerPart:
 endm

;----------------------------------------------------------------------

 macro enddebugger
  PB_TestInit
  IFEQ (PB_DebugState)
    PB_BuildError "Error: 'enddebugger' declared without a previous 'startdebugger'"
  ENDIF
  IFEQ (PB_DebugState-1)
	ECHO	"Warning: No debugger functions found."
  ENDIF

  ;-D-Even
  CNOP 0,4	;-LW Align?
_PB_EndDebuggerPart:
  Dc.l "ENDG"
 endm

;----------------------------------------------------------------------

 macro debugerror
  PB_TestInit

  IFEQ (PB_DebugState)
    PB_BuildError "Error: 'debugerror' declared without a previous 'startdebugger'"
  ELSE
PB_DebugState SET 2
  ENDIF

  LEA.l   _PB_ErrorText\@,a0
  MOVE.l   a0,16(a4)
  MOVE.l   #8,4(a4)
  RTS

_PB_ErrorText\@:

  Dc.b \1,0
  ;-D- Even
  CNOP 0,4	;-LW
 endm

;----------------------------------------------------------------------

  macro PB_AllocMem
    MOVE.l   40(a4),\1
    JSR (\1)
  endm


  macro PB_AllocString
    MOVE.l   60(a4),\1
    JSR (\1)
  endm


  macro PB_FreeString
    MOVE.l   64(a4),\1
    JSR (\1)
  endm


  macro PB_ReAllocMem
    MOVE.l   68(a4),\1
    JSR (\1)
  endm

;-----------------------------------------------------------------------
 RTS
