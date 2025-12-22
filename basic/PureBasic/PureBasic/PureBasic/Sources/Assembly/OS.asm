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
; PureBasic 'OS' library
;
; 14/03/05
;	Doobrey.. just checked over.. changed RTS to the inline RTS macro, can be compiled either way..
;
; 30/05/2001
;   PhxAss conversion
;
; 13/07/1999
;  FirstVersion
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

 initlib "OS", "OS", "", 0, 1, 0

;
; Now do the functions...
;
;------------------------------------------------------------------------------------------
 name      "ExecBase", "() - Return the exec.library base pointer"
 flags      LongResult | NoBase | InLine
 amigalibs  _ExecBase,  d0
 params
 debugger   1

  I_RTS

 endfunc    1
;------------------------------------------------------------------------------------------

 name      "GraphicsBase", "() - Return the graphics.library base pointer"
 flags      LongResult | NoBase | InLine
 amigalibs  _GraphicsBase,  d0
 params
 debugger   2

  I_RTS

 endfunc    2
;------------------------------------------------------------------------------------------

 name      "DosBase", "() - Return the dos.library base pointer"
 flags      LongResult | NoBase | InLine
 amigalibs  _DosBase,  d0
 params
 debugger   3

  I_RTS

 endfunc    3

;------------------------------------------------------------------------------------------
 name      "IntuitionBase", "() - Return the intuition.library base pointer"
 flags      LongResult | NoBase | InLine
 amigalibs  _IntuitionBase,  d0
 params
 debugger   4

  I_RTS

 endfunc    4
;------------------------------------------------------------------------------------------

 base
 endlib
;------------------------------------------------------------------------------------------
 startdebugger

 enddebugger

