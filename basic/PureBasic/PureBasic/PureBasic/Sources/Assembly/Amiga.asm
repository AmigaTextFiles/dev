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
; Amiga development file for PureBasic
;
; 14/03/2005 Doobrey, added NoBase to AmigaChipSet()
;     .. also changed MOVE.l 4,a6 to just have execbase as a6 in the lib ..should be slightly quicker
;     .. checked for d2-d7/a2-a7 use.
;     .. changed byte results to longresult .. should be quicker ??


 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"


; Init the library stuffs
; -----------------------
;
; In the Order:
;   * Name of the library
;   * Name of the help file in which are documented all the functions
;   * Name of the function which will be called automatically when the program end
;   * Priority of this call (small numbers = the faster it will be called)
;   * Version of the library
;   * Revision of the library (ie: 0.12 here)
;

 initlib "Amiga", "Amiga", "", 0, 1, 0

;
; The functions...
;
;------------------------------------------------------------------------------------------
 name      "AmigaChipSet", "() - Return the version of the Amigas chipset"
 flags  NoBase | LongResult
 amigalibs
 params
 debugger  1

  MOVEQ    #0,d0
  MOVE.w   $dff07c,d0  ; Code Here
  BEQ      AmigaChipSet_End
  SUB.w    #$F6,d0
AmigaChipSet_End:
  RTS

 endfunc   1
;------------------------------------------------------------------------------------------

;
; AttnFlags returns the following:
;
; Bit
;  0  68010
;  1  68020
;  2  68030
;  3  68040
;  4  68881 (FPU)
;  5  68882 (FPU)
;  6  68851 (MMU)
;  7  68060
;
;------------------------------------------------------------------------------------------
 name      "Processor", "()"
 flags     NoBase | LongResult
 amigalibs  _ExecBase,  a6
 params
 debugger  2

   MOVE.w 296(a6), d1   ; get AttnFlags

   ; Test processors

   MOVEQ  #0, d0        ; => MC68000

   BTST.b #7, d1
   BEQ.s  NoMC68060
   MOVEQ  #6, d0
   RTS
NoMC68060:

   BTST.b #3, d1
   BEQ.s  NoMC68040
   MOVEQ  #4, d0
   RTS
NoMC68040:

   BTST.b #2, d1
   BEQ.s  NoMC68030
   MOVEQ  #3, d0
   RTS
NoMC68030:

   BTST.b #1, d1
   BEQ.s  NoMC68020
   MOVEQ  #2, d0
   RTS
NoMC68020:

   BTST.b #0, d1
   BEQ.s  NoMC68010
   MOVEQ  #1, d0
NoMC68010:

   RTS

 endfunc   2
;------------------------------------------------------------------------------------------
;
; Here's the FPU function
;
; return values:
; 0 => no FPU
; 1 => 68881
; 2 => 68882
;
;------------------------------------------------------------------------------------------
 name      "FPU", "()"
 flags     NoBase | LongResult
 amigalibs  _ExecBase,  a6
 params
 debugger  3

   MOVE.w 296(a6), d1   ; get AttnFlags

   MOVEQ  #0, d0        ; => no FPU

   BTST.b #5, d1
   BEQ    NoMC68882
   MOVEQ  #2, d0
   RTS
NoMC68882:

   BTST.b #4, d1
   BEQ    NoMC68881
   MOVEQ  #1, d0
NoMC68881:

   RTS

 endfunc   3
;------------------------------------------------------------------------------------------
;
; And here's the MMU function
;
; return values:
;  0 => MMU not available
; -1 => MMU available
;
;------------------------------------------------------------------------------------------
 name      "MMU", "()"
 flags     NoBase | LongResult
 amigalibs _ExecBase,  a6
 params
 debugger  4

   MOVE.w  296(a6), d1   ; get AttnFlags

   MOVEQ.l #0, d0        ; => no MMU

   BTST.b  #6, d1
   BEQ     NoMMU
   MOVEQ.l #-1, d0
NoMMU:

   RTS

 endfunc   4
;------------------------------------------------------------------------------------------
;
; And the common part
;

 base

 endlib
;------------------------------------------------------------------------------------------

 startdebugger
 enddebugger

