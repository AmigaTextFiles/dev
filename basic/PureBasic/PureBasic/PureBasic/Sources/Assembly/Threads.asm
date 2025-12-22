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
; PureBasic 'Threads' library
;
; Todo : Add debugger checks to params..
;        Add command to alloc mem for threadsafe stringbuffer
;
; 14/03/05
;	Doobrey - just checked over for reg use, added NoBase to CreateThread..
;       and changed  ?ProcedureName to @ProcedureName() in the cmd help.
;
;
; 19/02/2000
;   First version
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

TAG_USER   = 1 << 31

NP_Dummy = TAG_USER + 1000

NP_Entry     = NP_Dummy + 3
NP_StackSize = NP_Dummy + 11
NP_Name      = NP_Dummy + 12
NP_Priority  = NP_Dummy + 13


; Init the library stuff
; ----------------------
;
; In the Order:
;   + Name of the library
;   + Name of the help file in which are documented all the functions
;   + Version of the library
;   + Priority of the library
;   + Revision of the library (ie: 1.00 here)
;

 initlib "Thread", "Thread", "", 0, 1, 0
;------------------------------------------------------------------------------------------
 name      "CreateThread", "(@ProcedureName(), ThreadName, Priority, Stack)"
 flags      LongResult | NoBase
 amigalibs _DosBase,  a6
 params     d0_l, d2_l, d3_l, d4_l
 debugger   1

  LEA.l    _CreateThreadTags(pc),a0
  MOVE.l    a0, d1
  MOVE.l    d0,  4(a0)
  MOVE.l    d2, 12(a0)
  MOVE.l    d3, 20(a0)
  MOVE.l    d4, 28(a0)
  JMP      _CreateNewProc(a6)  ; (*TagList) - d1

   CNOP 0,4

_CreateThreadTags:
  Dc.l NP_Entry     , 0
  Dc.l NP_Name      , 0
  Dc.l NP_StackSize , 0
  Dc.l NP_Priority  , 0
  Dc.l 0

 endfunc    1
;------------------------------------------------------------------------------------------
 base

 endlib
;------------------------------------------------------------------------------------------
 startdebugger

 enddebugger
