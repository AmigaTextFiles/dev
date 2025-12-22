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
; 14/03/2005
;	Doobrey.. some of these can be inlined..
;		 .. also needs a dynamic bank system...     
;		 .. changetag could do with some tag matching ??
;		 .. added NoResult to some funcs..just needs Freds magic touch on the compiler ;)
;
; Tag List Library for PureBasic
;
; 02/01/2000
;   Fixed a big bug (Used MEMCLEAR instead of #MEMCLEAR)
;
; 20/09/1999
;   Recoded for PhxAss
;
; 03/08/1999
;   Added the debugger support
;
; 14/07/1999
;   Optimized a lot
;
; 10/05/1999
;   Removed the use of any forbidden registers (a2,a3,a4...)
;
; 10/04/1999
;   Added different return type (Byte, Word, Long)
;   Fixed a little bug
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16

_MemPtr = 0
_CurPtr = _MemPtr+4

; Init the library stuff
; ----------------------
;
; In the Order:
;   + Name of the library
;   + Name of the help file in which are documented all the functions
;   + Version of the library
;   + Revision of the library (ie: 0.12 here)
;

 initlib "TagList", "TagList", "FreeTagList", 0, 1, 0

;
; Now do the functions...
;
;------------------------------------------------------------------------------------------

 name      "InitTagList", "()"
 flags     LongResult
 amigalibs _ExecBase, a6
 params    d0_l
 debugger  1

   ADDQ.l   #2, d0              ; Needed to have the correct number + 1
   LSL.l    #3, d0              ; d0*8
   MOVE.l   #MEMF_CLEAR, d1     ;
   JSR     _AllocVec(a6)        ; (d0,d1)
   MOVE.l   d0, (a5)            ; Set *MemPtr
   RTS

 endfunc   1
;------------------------------------------------------------------------------------------


 name      "FreeTagList", "()"
 flags	NoResult | InLine
 amigalibs _ExecBase, a6
 params
 debugger  2

   MOVE.l   (a5), a1           ; Get *MemPtr
   I_JSR     _FreeVec(a6)        ; (a1)

 endfunc   2

;------------------------------------------------------------------------------------------

 name      "AddTag", "(tag,data)"
 flags	NoResult
 amigalibs
 params    d0_l, d1_l
 debugger  3, _CurrentCheck

   LEA.l   _CurPtr(a5), a0
   MOVE.l   (a0), a1
   MOVE.l   d0, (a1)+  ; Put the 2 new tags
   MOVE.l   d1, (a1)+  ;
   MOVE.l   a1, (a0)   ; Set the new value...
   CLR.l    (a1)+      ; And finish the taglist
   CLR.l    (a1)       ;
   RTS

 endfunc   3
;------------------------------------------------------------------------------------------


 name      "TagListID", "()"
 flags     LongResult |	InLine
 amigalibs
 params
 debugger  4, _CurrentCheck

   MOVE.l   (a5), d0  ; Get TagPtr
   I_RTS

 endfunc   4
;------------------------------------------------------------------------------------------


 name      "ResetTagList", "(tag,data)"
 flags	NoResult
 amigalibs
 params    d0_l, d1_l
 debugger  5, _InitCheck

   LEA.l   _CurPtr(a5), a0
   MOVE.l   (a5), (a0)     ; Get TagPtr
   MOVE.l   (a0), a1
   MOVE.l   d0, (a1)+  ; Put the 2 new tags
   MOVE.l   d1, (a1)+  ;
   MOVE.l   a1, (a0)   ; Set the new value...
   CLR.l    (a1)+      ; And finish the taglist
   CLR.l    (a1)       ;
   RTS

 endfunc   5
;------------------------------------------------------------------------------------------

 name      "ChangeTag", "(#tagnum,tag,data)"
 flags	NoResult
 amigalibs
 params    d0_l, d1_l, d2_l
 debugger  6, _CurrentCheck

   MOVEA.l  (a5), a0   ; Get TagPtr
   LSL.l    #3, d0
   ADD.l    d0, a0
   MOVE.l   d1, (a0)+  ; Put the 2 new tags
   MOVE.l   d2, (a0)   ;
   RTS

 endfunc   6
;------------------------------------------------------------------------------------------

;
; And the common part
;

 base
  Dc.l 0
  Dc.l 0

 endlib

;------------------------------------------------------------------------------------------

 startdebugger

_InitCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  RTS


_CurrentCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  TST.l   _CurPtr(a5)
  BEQ      Error2
  RTS


Error0: debugerror "InitTagList() hasn't been called before or can't be correctly setup"
Error2: debugerror "ResetTagList() must be called at least one time before"

 enddebugger

