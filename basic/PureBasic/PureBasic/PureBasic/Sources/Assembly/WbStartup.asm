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
; PureBasic 'WbStartup' library
;
; 13/03/2005
;   Doobrey - Added save/restore D2 in WBStartup()
;           - FreeWB is now NoResult..
;	
; 08/07/2000
;   Changed the shared pointer (20(a4))
;
; 03/06/2000
;   Changed the code to support the new shared memory bank (position 8(a4) for WbStartup)
;
; 25/11/1999
;   Changed some stuffs..
;
; 29/10/1999
;   Adapted to PhxAss and optimzed a bit
;
; 12/07/1999
;   FirstVersion
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

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

 initlib "WbStartup", "WbStartup", "FreeWbStartup", 1, 1, 0

;
; Now do the functions...
;
;------------------------------------------------------------------------------------------
 name      "WbStartup", "()"
 flags      LongResult | NoBase
 amigalibs _ExecBase, a6
 params
 debugger   1

  SUB.l    a1,a1        ; Fast clear
  JSR     _FindTask(a6)
  MOVE.l   d0, a0
  MOVE.l   172(a0), d0  ; \pr_CLI
  BEQ     _GetWBMessage
  MOVEQ    #0,d0
  RTS

_GetWBMessage:
  MOVE.l d2,-(a7)		; Save D2
  ADD.l    #92, a0      ; \pr_MsgPort
  MOVE.l   a0,d2
  JSR     _WaitPort(a6) ; (*port) - a0
  MOVE.l   d2, a0
  JSR     _GetMsg(a6)   ; (*port) - a0
  MOVE.l   d0, 20(a4)    ; Store the WBMessage
  MOVE.l (a7)+,d2		; Restore D2 ...
_EndWBStartup
  RTS

 endfunc    1

;------------------------------------------------------------------------------------------
 name      "FreeWbStartup", "()"
 flags      NoBase | NoResult
 amigalibs _ExecBase, a6
 params
 debugger  2

  MOVE.l   20(a4), a1
  MOVE.l   a1, d0
  BEQ     _End
  JSR     _Forbid(a6)
  JSR     _ReplyMsg(a6)  ; (*Message) - a1
  JMP     _Permit(a6)
_End:
  RTS

 endfunc   2
;------------------------------------------------------------------------------------------
 base

 endlib
;------------------------------------------------------------------------------------------
 startdebugger

 enddebugger

