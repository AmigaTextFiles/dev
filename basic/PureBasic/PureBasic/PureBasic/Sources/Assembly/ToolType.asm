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
; Version 1.01

; 10/09/2005
;     -Doobrey-  Just preserved d2-d7/a2-a7 in all commands + debug checks (oops!)
;
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"


 initlib "ToolType", "ToolType", "FreeToolTypes", 0, 1, 0

;--------------------------------------------------------------------------------------------------

 name      "FreeToolTypes","()"
 flags     ; No Return Value
 amigalibs _DosBase,d7,_ExecBase,a6
 params
 debugger  1

.PB_FreeToolTypes

  MOVEM.l d2/d5-d6/a2/a5-a6,-(a7) ; Save registers  
  MOVE.l  (a5)+,d6           ; get objbase
  BEQ.w   quit0              ; ...

  MOVE.l  (a5)+,d5           ; get icon
  BEQ.w   l2                 ; ...

  MOVE.w  4(a5),d2           ; get nr_obj
  MOVE.l  d6,a2              ; use objbase
  EXG.l   d5,a6              ; use icon

loop0
  MOVE.l  (a2),d0            ; any diskobject to free
  BEQ.w   l0                 ; nop

  MOVE.l  d0,a0              ; arg1.
  JSR    _FreeDiskObject(a6) ; (diskobject) - a0

l0
  ADD.w   #16,a2             ; inc info ptr
  DBRA    d2,loop0           ; dec counter

  EXG.l   d7,a6              ; use dosbase

  MOVE.l  (a5),d1            ; arg1.
  BEQ.w   l1                 ; ...

  JSR    _CurrentDir(a6)     ; (lock) - d1

l1
  MOVE.l  d5,a6              ; use execbase

  MOVE.l  d7,a1              ; arg1.
  JSR    _CloseLibrary(a6)   ; (libbase) - a1

l2
  MOVE.l  d6,a1              ; arg1.
  JSR    _FreeVec(a6)        ; (memptr) - a1

quit0
  MOVEM.l (a7)+,d2/d5-d6/a2/a5-a6 ; Restore registers  
  RTS

 endfunc 1

;--------------------------------------------------------------------------------------------------

 name      "InitToolType","(#Infos.l)"
 flags     LongResult ; Return iconbase or diskobject
 amigalibs _DosBase,d7,_ExecBase,a6
 params    d0_l
 debugger  2,Error1

.PB_InitToolType

  MOVEM.l d6/a2/a5-a6,-(a7)  ; Save registers
  MOVE.w  d0,12(a5)          ; set nr_obj

  ADDQ.w  #1,d0              ; at least one Info
  LSL.w   #4,d0              ; arg1.
  MOVEQ   #1,d1              ; } ...
  SWAP    d1                 ; } arg2.
  JSR    _AllocVec(a6)       ; (size, requirements) - d0/d1
  MOVE.l  d0,(a5)+           ; set objbase
  BEQ.w   quit11             ; quit if no mem

  LEA IconName(PC),a1        ; a smidge smaller
  CLR.l   d0                 ; arg2.
  JSR    _OpenLibrary(a6)    ; (libname, version) - a1/d0
  MOVE.l  d0,(a5)+           ; set icon
  BEQ.w   quit11             ; quit if lib couldn't be open

  MOVE.l  20(a4),d6          ; get wbmsg
  BLE.w   quit11             ; quit if none

  MOVE.l  d6,a0              ; use wbmsg

  MOVE.l  36(a0),a2          ; use first wbarg
  MOVE.l  d7,a6              ; use dosbase

  MOVE.l  (a2)+,d1           ; arg1.
  JSR    _CurrentDir(a6)     ; (lock) - d1
  MOVE.l  d0,(a5)            ; set curr_dir

  MOVE.l  -(a5),a6           ; use icon

  MOVE.l  (a2),a0            ; arg1.
  JSR    _GetDiskObject(a6)  ; (name) - a0

  MOVE.l  -(a5),a2           ; use objbase
  MOVE.l  d0,(a2)+           ; set Info\DiskInfo
  BEQ.w   quit10             ; quit if no diskobject

  MOVE.l  d0,a0              ; use DiskInfo
  ADD.w   #54,a0             ; now ptr to do_ToolTypes
  MOVE.l  a0,(a2)+           ; set Info\Tool_Array
  MOVE.l  (a0),a0            ; use do_ToolTypes

  MOVEQ   #-1,d1             ; tooltype counter

loop10
  ADDQ.w  #1,d1              ; inc tooltype counter
  TST.l   (a0)+              ; test if any tooltype
  BNE.w   loop10             ; loop again, yep

  MOVE.w  d1,(a2)+           ; set Info\Nr_ToolObj
  CLR.w   (a2)               ; zero to Info\Curr_Tool

quit10
quit11
  MOVEM.l (a7)+,d6/a2/a5-a6  ; Restore registers
  RTS

IconName:
  Dc.b "icon.library",0
 endfunc 2

;--------------------------------------------------------------------------------------------------

 name      "ReadToolTypeDiskInfo","(#Info.w,IconName$)"
 flags     LongResult ; Return diskobject
 amigalibs
 params    d0_w,d1_l
 debugger  3,Error3

.PB_ReadToolTypeDiskInfo

  MOVEM.l  a2/a6,-(a7)     ; Save registers

  MOVE.l  (a5)+,a2           ; calc item..
  LSL.w   #4,d0              ; adress
  ADD.w   d0,a2              ; - A2 hold ptr to Info

  MOVE.l  (a5),a6            ; use icon

  MOVE.l  d1,a0              ; arg1.
  JSR    _GetDiskObject(a6)  ; (name) - a0
  MOVE.l  d0,(a2)+           ; set Info\DiskInfo
  BEQ.w   quit20             ; quit if no diskobject

  MOVE.l  d0,a0              ; use DiskInfo
  ADD.w   #54,a0             ; now ptr to do_ToolTypes
  MOVE.l  a0,(a2)+           ; set Info\Tool_Array
  MOVE.l  (a0),a0            ; use do_ToolTypes

  MOVEQ   #-1,d1             ; tooltype counter

loop20
  ADDQ.w  #1,d1              ; inc tooltype counter
  TST.l   (a0)+              ; test if any tooltype
  BNE.w   loop20             ; loop again, yep

  MOVE.w  d1,(a2)+           ; set Info\Nr_Tools
  CLR.w   (a2)               ; zero to Info\Curr_Tool

quit20
  MOVEM.l (a7)+,a2/a6        ; Restore registers
  RTS

 endfunc 3

;--------------------------------------------------------------------------------------------------

 name      "WriteToolTypeDiskInfo","(#Info.w,Array(),IconName$)"
 flags     ; Return True/False
 amigalibs _ExecBase,a6
 params    d0_w,d1_l,d2_l
 debugger  4,Error5

.PB_WriteToolTypeDiskInfo
  MOVEM.l d3-d5/a2-a3,-(a7)  ; Save registers

  MOVE.l  (a5)+,a2           ; calc item..
  LSL.w   #4,d0              ; adress
  ADD.w   d0,a2              ; - A2 hold ptr to Info

  MOVE.l  d1,a3              ; use ptr to array
  MOVE.l  (a5),d5            ; get icon

  MOVE.l  -6(a3),d0          ; get length of array (PB)

  MOVE.l  d0,d3              ; save length
  ADDQ.l  #2,d0              ; add two extra

  LSL.l   #2,d0              ; arg1.
  MOVEQ   #0,d1              ; arg2.
  JSR    _AllocVec(a6)       ; (size, requierment) - d0/d1
  MOVE.l  d0,d4              ; save ptr to fake ToolType array
  BEQ.w   quit30             ; ...

  MOVE.l  d0,a1              ; use ptr to fake ToolType array

loop30
  MOVE.l  (a3)+,a0           ; get ptr to string
  TST.b   (a0)               ; see if string contain data
  BEQ.w   l30                ; nop

  MOVE.l  a0,(a1)+           ; put string ptr in fake ToolType array

l30
  DBRA    d3,loop30          ; dec counter

  CLR.l   (a1)               ; zero at end of ToolType array

  MOVE.l  d2,a0              ; arg1.
  MOVE.l  (a2)+,a1           ; arg2.

  MOVE.l  (a2),a2            ; use Tool_Array
  MOVE.l  (a2),d3            ; save old do_ToolType
  MOVE.l  d4,(a2)            ; set new do_ToolType

  EXG.l   d5,a6              ; use icon
  JSR    _PutDiskObject(a6)  ; (name, diskobject) - a0/a1

  MOVE.l  d5,a6              ; use execbase

  MOVE.l  d4,a1              ; arg1
  JSR    _FreeVec(a6)        ; (memptr) - a1

  MOVE.l  d3,(a2)            ; restore do_ToolType
  MOVEQ   #1,d0              ; indicate success

quit30
  MOVEM.l (a7)+,d3-d5/a2-a3  ; Restore registers
  RTS

 endfunc 4

;--------------------------------------------------------------------------------------------------

 name      "FreeToolType","(#Info.w)"
 flags     ; No Return Value
 amigalibs
 params    d0_w
 debugger  5,Error3

.PB_FreeToolType
  MOVE.l  a6,-(a7)           ; Save a6
  MOVE.l  (a5)+,a0           ; calc item..
  LSL.w   #4,d0              ; adress
  ADD.w   d0,a0              ; - A0 hold ptr to Info

  MOVE.l  (a5),a6            ; use icon

  MOVE.l  (a0),d0            ; any diskobject to free
  BEQ.w   quit40             ; nop

  CLR.l   (a0)               ; now Info is unused

  MOVE.l  d0,a0              ; arg1.
  JSR    _FreeDiskObject(a6) ; (diskobject) - a0

quit40
  MOVEA.l (a7)+,a6	    ; Restore a6
  RTS

 endfunc 5

;--------------------------------------------------------------------------------------------------

 name      "GetNumberOfToolTypes","(#Info.w)"
 flags     ; Return number of ToolTypes
 amigalibs
 params    d0_w
 debugger  6,Error4

.PB_GetNumberOfToolTypes
  MOVE.l  (a5),a0            ; calc item..
  LSL.w   #4,d0              ; adress
  ADD.w   d0,a0              ; - A0 hold ptr to Info

  MOVEQ   #0,d0              ; indicate no Tools in unused Info

  TST.l   (a0)               ; is Info in use
  BEQ.w   quit50             ; nop

  MOVE.w  8(a0),d0           ; get Nr_Tools

quit50
  RTS

 endfunc 6

;--------------------------------------------------------------------------------------------------

 name      "GetNextToolTypeString","(#Info.w)"
 flags     StringResult ; Return whole ToolType string
 amigalibs
 params    d0_w
 debugger  7,Error4

.PB_GetNextToolTypeString
  MOVE.l a2,-(a7)           ; Save registers
  MOVE.l  (a5),a0            ; calc item..
  LSL.w   #4,d0              ; adress
  ADD.w   d0,a0              ; - A0 hold ptr to Info

  ADDQ.w  #4,a0              ; ptr to Tool_Array
  MOVE.l  (a0),a1            ; use Tool_Array
  MOVE.l  (a1),a1            ; use ptr to tooltype

  ADDQ.w  #6,a0              ; ptr to Curr_Tool
  MOVE.w  (a0),d0            ; get Curr_Tool
  LSL.w   #2,d0              ; Curr_Tool * 4
  ADD.w   d0,a1              ; calculate ptr to next toolstr ptr
  MOVE.l  (a1)+,a2           ; get ptr to toolstr

loop60
  MOVE.b  (a2)+,(a3)+        ; move one char
  BNE.w   loop60             ; loop again if not at end, yep

  SUBQ.l  #1,a3              ; <<<< just for Pure Basic
  MOVEA.l (a7)+,a2           ; Restore registers
  TST.l   (a1)               ; any more ToolType
  BEQ.w   quit60             ; nop

  ADDQ.w  #1,(a0)            ; inc Curr_Tool
  RTS

quit60
  CLR.w   (a0)               ; clr Curr_Tool
  RTS

 endfunc 7

;--------------------------------------------------------------------------------------------------

 name      "MatchToolType","(#Info.w,ToolName$,Value$)"
 flags     ByteResult ; Return True/False
 amigalibs
 params    d0_w,d1_l,d2_l
 debugger  8,Error4

.PB_MatchToolType
  MOVE.l a6,-(a7)            ; Save a6
  MOVE.l  (a5)+,a0           ; calc item..
  LSL.w   #4,d0              ; adress
  ADD.w   d0,a0              ; - A0 hold ptr to Info

  MOVE.l  (a5),a6            ; use icon

  MOVE.l  4(a0),a0           ; use Tool_Array
  MOVE.l  (a0),a0            ; arg1.
  MOVE.l  d1,a1              ; arg2.
  JSR    _FindToolType(a6)   ; (tooltypearray, toolname) - a0/a1

  TST.l   d0                 ; is tool exist
  BEQ.w   quit80             ; nop

  MOVE.l  d0,a0              ; arg1.
  MOVE.l  d2,a1              ; arg2.
  JSR    _MatchToolValue(a6) ; (tooltype, value) - a0/a1
  MOVEA.l (a7)+,a6
  RTS

quit80
  MOVEA.l (a7)+,a6           ; Restore a6
  MOVEQ   #-1,d0             ; indicate ToolType didn't exist
  RTS

 endfunc 8

;--------------------------------------------------------------------------------------------------

 name      "MatchToolTypeString","(String$,ToolName$,Value$)"
 flags     ByteResult ; Return True/False
 amigalibs
 params    d0_l,d1_l,d2_l
 debugger  9,Error2

.PB_MatchToolTypeString
  MOVE.l  a6,-(a7)           ; Save a6
  MOVE.l  4(a5),a6           ; use icon

  CLR.l   -(a7)              ; zero at end of fake array
  MOVE.l  d0,-(a7)           ; ptr to Pure Basic string

  MOVE.l  a7,a0              ; arg1.
  MOVE.l  d1,a1              ; arg2.
  JSR    _FindToolType(a6)   ; (tooltypearray, toolname) - a0/a1

  ADDQ.w  #8,a7              ; restore stackptr

  TST.l   d0                 ; see if tool exist
  BEQ.w   quit70             ; nop

  MOVE.l  d0,a0              ; arg1.
  MOVE.l  d2,a1              ; arg2.
  JSR    _MatchToolValue(a6) ; (tooltype, value) - a0/a1
  MOVEA.l (a7)+,a6           ;
  RTS                        ;

quit70
  MOVEA.l (a7)+,a6           ; Restore a6
  MOVEQ   #-1,d0             ; indicate ToolType didn't exist
  RTS

 endfunc 9

;--------------------------------------------------------------------------------------------------

 name      "GetToolTypeValue","(#Info.w,ToolName$)"
 flags     StringResult ; Return ToolType value
 amigalibs
 params    d0_w,d1_l
 debugger  10,Error4

.PB_GetToolTypeValue
  MOVE.l  a6,-(a7)           ; Save registers
  MOVE.l  (a5)+,a0           ; calc item..
  LSL.w   #4,d0              ; adress
  ADD.w   d0,a0              ; - A0 hold ptr to Info

  MOVE.l  (a5),a6            ; use icon

  MOVE.l  4(a0),a0           ; use Tool_Array
  MOVE.l  (a0),a0            ; arg1.
  MOVE.l  d1,a1              ; arg2.
  JSR    _FindToolType(a6)   ; (tooltypearray, toolname) - a0/a1

  CLR.b   (a3)               ; make a zerostring

  TST.l   d0                 ; is tool exist
  BEQ.w   quit90             ; nop

  MOVE.l  d0,a0              ; use ptr to toolvalue

loop90
  MOVE.b  (a0)+,(a3)+        ; move one char
  BNE.w   loop90             ; loop again if not at end, yep

  SUBQ.l  #1,a3              ; <<<< just for Pure Basic

quit90
  MOVEA.l (a7)+,a6           ; Restore a6
  RTS

 endfunc 10

;--------------------------------------------------------------------------------------------------

 base

objbase:  Dc.l 0
icon:     Dc.l 0
curr_dir: Dc.l 0
nr_obj:   Dc.w 0

 endlib

;--------------------------------------------------------------------------------------------------

 startdebugger

Error1 ; Check if Infos is out of range.
  TST.l  d0
  BMI.w  Err1
  CMPI.l #2046,d0
  BGT.w  Err1
  RTS

Error2 ; Check if Lib is correctly initialized.
  TST.l  (a5)
  BEQ.w  Err2
  TST.l  4(a5)
  BEQ.w  Err2
  RTS

Error3 ; Error2 + Check if a Info is out of range.
  TST.l  (a5)
  BEQ.w  Err2
  TST.l  4(a5)
  BEQ.w  Err2

  TST.w  d0
  BMI.w  Err3
  CMP.w  12(a5),d0
  BGT.w  Err3
  RTS

Error4 ; Error2 + Error3 + Check if a Info is initialized.
  TST.l  (a5)
  BEQ.w  Err2
  TST.l  4(a5)
  BEQ.w  Err2

  TST.w  d0
  BMI.w  Err3
  CMP.w  12(a5),d0
  BGT.w  Err3

  ; Doobrey: Changed to preserved regs.
  ;MOVE.w d0,d7
  ;LSL.w  #4,d7
  ;MOVE.l (a5),a0
  ;ADD.w  d7,a0

  MOVE.l d0,-(a7)
  LSL.w #4,d0
  MOVE.l (a5),a0
  ADD.w d0,a0
  MOVE.l (a7)+,d0

  TST.l  (a0)
  BEQ.w  Err4
  RTS

Error5 ; Error2 + Error3 + Error4 + Check if it's a string array.
  TST.l  (a5)
  BEQ.w  Err2
  TST.l  4(a5)
  BEQ.w  Err2

  TST.w  d0
  BMI.w  Err3
  CMP.w  12(a5),d0
  BGT.w  Err3

  ; Doobrey: Changed to preserve regs
  ;MOVE.w d0,d7
  ;LSL.w  #4,d7
  ;MOVE.l (a5),a0
  ;ADD.w  d7,a0

  MOVE.l d0,-(a7)
  LSL.w #4,d0
  MOVE.l (a5),a0
  ADD.w  d0,a0
  MOVE.l (a7)+,d0

  TST.l  (a0)
  BEQ.w  Err4

  MOVE.l d1,a0
  CMP.w  #8,-2(a0)
  BNE.w  Err5
  RTS


Err1: DebugError "#Infos out of Range"
Err2: DebugError "Incorrect InitCode or Lack of ErrorTest"
Err3: DebugError "#Info out of Range"
Err4: DebugError "#Info isn't Initialized"
Err5: DebugError "Must be a String Array"

 enddebugger

