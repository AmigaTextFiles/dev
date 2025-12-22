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
; PureBasic 'App' library
;
; 11/09/2005
;    -Doobrey- Just preserved regs..mand AppNumFiles inline-able..
;
; 30/05/2001
;   PhxAss convertion
;
; 01/08/1999
;   Finished
;
; 23/07/1999
;   FirstVersion
;
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16

_Workbench = 0
_App       =  _Workbench+4
_ObjNum    =  _App+4
_MemPtr    =  _ObjNum+4

_AppMsgPort =  _MemPtr+4
_BufPtr     =  _AppMsgPort+4

_CurMsg  =  _BufPtr+4
_ArgList =  _CurMsg+4
_AppNumArgs =  _ArgList+4
_CurArg     =  _AppNumArgs+4

GetPosition = l_GetPosition-LibBase


APPBUFSIZE = 1000

; Init the library stuff
; ----------------------
;
; In the order:
;   + Name of the library
;   + Name of the help file in which are documented all the functions
;   + Name of the 'end function' automatically called
;   + Priority of the 'end function' (high number say it will be called sooner)
;   + Version of the library
;   + Revision of the library (ie: 0.12 here)
;

 initlib "App", "App", "FreeApps", 0, 1, 0

;
; Now do the functions...
;
;---------------------------------------------------------------------------------------

 name      "InitApp", "()"
 flags
 amigalibs  _ExecBase,  a6
 params     d0_l
 debugger   1

  ADDQ     #1, d0              ; Needed to have the correct number  
  MOVE.l   d0, _ObjNum(a5)     ; Set ObjNum
  LSL.l    #2, d0              ; d0*4
  MOVE.l   #MEMF_CLEAR, d1     ;
  JSR     _AllocVec(a6)        ; (d0,d1)
  MOVE.l   d0, _MemPtr(a5)     ; Set *MemPtr
  LEA.l   _WorkbenchName(pc),a1; Library name
  MOVEQ    #37, d0             ; Version
  JSR     _OpenLibrary(a6)     ; (*Name$, Version) - a1/d0
  MOVE.l   d0, _Workbench(a5)  ; Set *Workbench

  JSR     _CreateMsgPort(a6)
  TST.l    d0
  BEQ     _NIA_End
  MOVE.l   d0, _AppMsgPort(a5)

  MOVE.l   #APPBUFSIZE, d0     ; Buffer to handle locks..
  MOVE.l   #MEMF_CLEAR, d1     ;
  JSR     _AllocVec(a6)        ; (d0,d1)
  MOVE.l   d0, _BufPtr(a5)     ; Set *BufPtr

_NIA_End:
  RTS

_WorkbenchName:
  Dc.b "workbench.library",0
  Even

 endfunc  1
;---------------------------------------------------------------------------------------


 name      "FreeApps", "()"
 flags  NoResult
 amigalibs  _ExecBase,  a6
 params
 debugger   2

._FreeApps:
  MOVEA.l _Workbench(a5), a1  ;
  JSR     _CloseLibrary(a6)   ; (*Library) - a1
  MOVEA.l _MemPtr(a5), a1     ;
  JSR     _FreeVec(a6)        ; (a1)

  MOVEA.l _CurMsg(a5), a1     ; If the message doens't have
  MOVE.l   a1,d0              ; been replyied, reply it.
  BEQ     _NFA_Skip1          ;
  JSR     _ReplyMsg(a6)       ; - a1
_NFA_Skip1:

  MOVE.l  _AppMsgPort(a5), d0
  BEQ     _NFA_End

  ;Repeat
  ;  *msg = GetMsg_(*awport)  ; Reply all msg before
  ;  If *msg                  ; close the port..
  ;    ReplyMsg_ *msg         ;
  ;  EndIf                    ;
  ;Until *msg = 0             ;

  MOVE.l   d0, a0
  JSR     _DeleteMsgPort(a6)  ; - a0

  MOVE.l  _BufPtr(a5), a1     ; Get TmpBuf Address and free it.
  JMP     _FreeVec(a6)        ; - a1
_NFA_End:
  RTS

 endfunc  2
;---------------------------------------------------------------------------------------


 name      "AddAppWindow", "( appID, WindowID())"
 flags
 amigalibs
 params    d0_l,  d1_l
 debugger  3

._AddAppWindow:
  MOVEM.l  d2/a2-a3/a6,-(a7)   ;
  MOVE.l   d0, d2
  JSR      GetPosition(a5)     ; Input d0, Result a1 - a3 store the current pos.
  MOVEA.l _Workbench(a5), a6   ;
  MOVE.l   d2, d0              ; Fill ID
  MOVE.l   d1, a0              ; Fill *Window
  MOVEQ    #0, d1              ; No user data
  MOVEA.l _AppMsgPort(a5), a1  ;
  SUB.l    a2, a2              ; No tags
  JSR     _AddAppWindowA(a6)   ; - d0/d1/a0/a1/a2
  MOVE.l   d0, (a3)
  MOVEM.l  (a7)+,d2/a2-a3/a6   
  RTS

 endfunc   3
;---------------------------------------------------------------------------------------


 name      "RemoveAppWindow", "( appID)"
 flags
 amigalibs  _ExecBase,  a6
 params     d0_l
 debugger   4


.__RemoveAppWindow:
  MOVEM.l   a3/a6,-(a7)    
  JSR      GetPosition(a5)       ; Input d0, Result a1 - a3 store the current pos.
  MOVEA.l _Workbench(a5), a6     ;
  MOVE.l   a1, a0                ;
  JSR     _RemoveAppWindow(a6)   ; - a0 - Pass #0 value works.
  CLR.l    (a3)                  ; Put #0 instead of menu addr
  MOVEM.l   (a7)+,a3/a6    
  RTS

 endfunc   4
;---------------------------------------------------------------------------------------


 name      "AddAppMenu", "( appID, Label$)"
 flags
 amigalibs
 params     d0_l,  a0_l
 debugger   5

  MOVEM.l  d2/a2-a3/a6,-(a7)  
  MOVE.l   d0, d2
  JSR      GetPosition(a5)     ; Input d0, Result a1 - a3 store the current pos.
  MOVEA.l _Workbench(a5), a6   ;
  MOVE.l   d2, d0              ;
  MOVEQ    #0, d1              ; No user data
  MOVEA.l _AppMsgPort(a5), a1  ;
  SUB.l    a2, a2              ; No tags
  JSR     _AddAppMenuItemA(a6) ; - d0/d1/a0/a1/a2
  MOVE.l   d0, (a3)
  MOVEM.l  (a7)+,d2/a2-a3/a6  
  RTS

 endfunc   5
;---------------------------------------------------------------------------------------


 name      "RemoveAppMenu", "( appID)"
 flags
 amigalibs
 params     d0_l
 debugger   6

  MOVEM.l   a3/a6,-(a7)          ; Save regs
  JSR      GetPosition(a5)       ; Input d0, Result a1 - a3 store the current pos.
  MOVEA.l _Workbench(a5), a6     ;
  MOVE.l   a1, a0                ;
  JSR     _RemoveAppMenuItem(a6) ; - a0 - Pass #0 value works.
  CLR.l    (a3)                  ; Put #0 instead of menu addr
  MOVEM.l   (a7)+,a3/a6          ; Restore regs
  RTS

 endfunc   6
;---------------------------------------------------------------------------------------


 name      "AppEvent", "()"
 flags      LongResult
 amigalibs  _ExecBase,  a6
 params
 debugger   7

  MOVE.l   d2,-(a7)            ; Save
  MOVEQ    #-1, d2            ; MsgResult

  LEA.l   _AppNumArgs(a5), a0
  CLR.l    (a0)+              ; Clear AppNumArg
  CLR.l    (a0)               ; Clear CurArg

  MOVEA.l _CurMsg(a5), a1     ; If the message doens't have
  MOVE.l   a1,d0              ; been replyied, reply it.
  BEQ     _NAE_Skip1          ;
  JSR     _ReplyMsg(a6)       ; - a1
_NAE_Skip1:
  MOVEA.l _AppMsgPort(a5), a0
  JSR     _GetMsg(a6)         ; - a0
  LEA.l   _CurMsg(a5), a1     ; If the message doens't have
  MOVE.l   d0, (a1)+          ; Store the new Msg value

  TST.l    d0                 ; If no messages, quit.
  BEQ     _NAE_End            ;
  MOVE.l   d0, a0
  MOVE.l   34(a0), (a1)+      ; Set ArgList
  MOVE.l   30(a0), (a1)       ; Set AppNumArgs
  MOVE.l   26(a0), d2         ; Get MsgID
_NAE_End:
  MOVE.l   d2, d0
  MOVE.l  (a7)+,d2            ; Restore
  RTS

 endfunc   7
;---------------------------------------------------------------------------------------


 name      "AppNumFiles", "()"
 flags  InLine
 amigalibs  _ExecBase,  a6
 params
 debugger   8

  MOVE.l  _AppNumArgs(a5), d0
  I_RTS

 endfunc    8
;---------------------------------------------------------------------------------------


 name      "NextAppFile", "()"
 flags      StringResult
 amigalibs  _DosBase,  a6
 params
 debugger   9

  MOVEM.l   d2-d4/a2,-(a7)  ; Save
  CLR.l    d4
  MOVE.l  _CurArg(a5), d1
  MOVE.l  _AppNumArgs(a5), d2
  CMP.l    d1, d2
  BLE     _NNAF_End
  MOVEA.l _ArgList(a5), a2  ;
  LSL      #3, d1           ; Get the right list pos.
  ADD.l    d1, a2           ; LSL #3, because SizeOf .WBArg = 8

  MOVE.l   (a2)+, d1
  MOVE.l   a3, d2
  MOVE.l   #4096, d3
  JSR     _NameFromLock(a6) ; - d1/d2/d3

_NNAF_Loop1:
  MOVE.b   (a3)+, d0
  BNE     _NNAF_Loop1

  CLR.b    -(a3) ; Small SUB.w #1,a3

  MOVE.b   -1(a3), d0
  CMP.b    #":", d0
  BEQ     _NNAF_NoPutSlash
  MOVE.b   #"/", (a3)+
_NNAF_NoPutSlash:

  MOVE.l   (a2), a1
_NNAF_Loop2:
  MOVE.b   (a1)+, (a3)+
  BNE     _NNAF_Loop2

  ADD.l    #1, _CurArg(a5)
_NNAF_End:
  MOVEM.l   (a7)+,d2-d4/a2  ; Restore
  RTS

 endfunc  9
;---------------------------------------------------------------------------------------


 base
LibBase:

 Dc.l 0   ; *Workbench

 Dc.l 0   ; App

 Dc.l 0   ; Number of max objects
 Dc.l 0   ; *MemPtr

 Dc.l 0   ; AppMsgPort
 Dc.l 0   ; BufPtr

; Must be keep in this order because of fast mem write (a0)+

 Dc.l 0   ; *CurMsg
 Dc.l 0   ; ArgList
 Dc.l 0   ; AppNumArgs
 Dc.l 0   ; CurArg


; GetPosition **********************************************
;
;
l_GetPosition:
  MOVEA.l _MemPtr(a5), a3
  LSL.l    #2, d0
  ADD.l    d0, a3
  MOVE.l   (a3), a1
  RTS

 endlib

;---------------------------------------------------------------------------------------

 startdebugger

 enddebugger

