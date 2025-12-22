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
; PureBasic 'String' library
;
; 18/03/2005 
;   Inlined Asc
;   Added NoBase to all funcs, saved regs etc.   
;
; 16/08/2003
;   Added all the string base stuff, as it has changed to support v3.80 compiler
;   Added Trim()
;
; 31/01/2001
;   Fixed the Str() 16 bit limitation (now uses AmigaOS function..)
;   Added Bin() and Hex() - Thanks to Richard !
;
; 03/06/2000
;   Fixed a bug in Left()
;
; 15/01/2000
;   Fixed a bug in Mid() - Mid(Text$,1,x) fails...
;
; 27/11/1999
;   Fixed a big bug in FindString()
;
; 22/11/1999
;   Added Mid(), FindString(), Val(), StripLead(), StripTrail()
;
; 04/10/1999
;   Adapted for PhxAss
;
; 26/09/1999
;   Added Right(), Left(), UCase(), LCase() and Len()  
;
; 20/06/1999
;   Fixed a satanic BLITZ2    bug inside the Str() function.
;   MOVE.b #val, (a0) generate BAD code    
;
; 15/06/1999
;   Added Chr() and Asc()
;
; 13/06/1999
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
;   + Number of functions in this lib. MUST be changed manually at each add.
;

 initlib "String", "String", "", 0, 1, 0

;
; Now do the functions...
;

;---------------------------------------------------------------------------------------

 name      "Str", "(Value)"
 flags      StringResult | NoBase
 amigalibs _ExecBase, a6
 params     d0_l
 debugger   1

  MOVE.l   a2,-(a7)
  CLR.b    (a3)
  LEA.l    FormatString(pc),a0
  LEA.l    FormatValue(pc),a1
  MOVE.l   d0,(a1)
  LEA.l    SubRoutine(pc),a2
  JSR     _RawDoFmt(a6)
GotoEnd:
  MOVE.b   (a3)+,d0
  BNE      GotoEnd
  SUBQ.l   #1,a3
  MOVE.l   (a7)+,a2
  RTS

SubRoutine:
  MOVE.b   d0,(a3)+
  RTS

  CNOP 0,4	;-- LW align it.
FormatValue:
  Dc.l     0

FormatString
  Dc.b     "%ld",0

Even

 endfunc    1

;---------------------------------------------------------------------------------------
 name      "Chr", "(Ascii value)"
 flags      StringResult | InLine | NoBase
 amigalibs
 params     d0_b
 debugger   2

  MOVE.b   d0,(a3)+
  CLR.b    (a3)
  I_RTS

 endfunc    2

;---------------------------------------------------------------------------------------
 name      "Asc", "(String)"
 flags	LongResult | InLine | NoBase
 amigalibs
 params     a0_l
 debugger   3

  MOVEQ.l    #0, d0
  MOVE.b   (a0), d0
  I_RTS

 endfunc    3

;---------------------------------------------------------------------------------------

 name      "Len", "(String)"
 flags      LongResult | NoBase
 amigalibs
 params     a0_l
 debugger   4

  MOVEQ.l    #-1,d0
_LenLoop:
  ADDQ.l   #1,d0
  MOVE.b   (a0)+,d1
  BNE     _LenLoop
  RTS

 endfunc    4
;---------------------------------------------------------------------------------------

 name      "Left", "(String, Length)"
 flags      StringResult | NoBase
 amigalibs
 params     a0_l,  d0_w
 debugger   5

  MOVE.l  4(a7), a3     ; Restore the real a3 base in case of re-entrant string operations
  TST.w    d0
  BLE     _LeftSkip
  SUBQ.w   #1,d0
_LeftLoop:
  MOVE.b   (a0)+,d1
  BEQ     _LeftSkip
  MOVE.b   d1,(a3)+
  DBRA     d0,_LeftLoop
_LeftSkip:
  CLR.b    (a3)
_LeftEnd:
  RTS

 endfunc    5

;---------------------------------------------------------------------------------------

 name      "Right", "(String, Length)"
 flags      StringResult | NoBase
 amigalibs
 params     a0_l,  d0_w
 debugger   6

  MOVEM.l d2-d3,-(a7)	; Save registers
	
  MOVE.l  12(a7), a3     ; Restore the real a3 base in case of re-entrant string operations
  MOVE.l   a0, d2       ; Save string pointer
  MOVEQ    #-1,d1
_RightGetSize:
  ADDQ.w   #1,d1
  MOVE.b   (a0)+,d3
  BNE     _RightGetSize
  MOVE.l   d2, a0       ; Restore original string pointer
  MOVE.l   d1, d2
  CMP.w    d1, d0
  BLE     _RightNext    ; If StrLen < num to take
  EXG      d0, d1       ; set the number bytes to copy to StrLen
_RightNext:
  TST.w    d0
  BLE     _RightEnd
  SUB.w    d0, d2
  ADD.w    d2, a0
  SUBQ.w   #1,d0
_RightLoop:
  MOVE.b   (a0)+, (a3)+
  DBRA     d0, _RightLoop
_RightEnd:
  CLR.b    (a3)
  MOVEM.l (a7)+,d2/d3
  RTS

 endfunc    6

;---------------------------------------------------------------------------------------

 name      "UCase", "(String)"
 flags      StringResult | NoBase
 amigalibs
 params     a0_l
 debugger   7


  MOVE.l  4(a7), a3     ; Restore the real a3 base in case of re-entrant string operations
_UCaseLoop:
  MOVE.b   (a0)+, d0
  BEQ     _UCaseEnd

  CMP.b    #223, d0      ; Check if d0 > 191, si oui, accent check
  BHI     _UCaseChange   ; Optimized a lot because of the position of the chars (at the end)

  CMP.b    #96, d0       ; Check if d0 >= "a"
  BLE     _UCaseNoChange
  CMP.b    #122, d0      ; Check if d0 =< "z"
  BHI     _UCaseNoChange
_UCaseChange:
  SUB.b    #32, d0
_UCaseNoChange
  MOVE.b   d0,(a3)+
  BRA     _UCaseLoop

_UCaseEnd:
  CLR.b    (a3)
  RTS

 endfunc    7

;---------------------------------------------------------------------------------------

 name      "LCase", "(String)"
 flags      StringResult | NoBase
 amigalibs
 params     a0_l
 debugger   8

  MOVE.l  4(a7), a3     ; Restore the real a3 base in case of re-entrant string operations
_LCaseLoop:
  MOVE.b   (a0)+, d0
  BEQ     _LCaseEnd

  CMP.b    #191, d0     ; Check if d0 > 191, si oui, accent check
  BHI     _NLC_Accent

  CMP.b    #64, d0      ; Check if d0 >= "a"
  BLE     _LCaseNext
  CMP.b    #90, d0      ; Check if d0 =< "z"
  BHI     _LCaseNext
  ADD.b    #32, d0      ; Ok, add it  

_LCaseNext:
  MOVE.b   d0,(a3)+
  BRA     _LCaseLoop

_NLC_Accent:
  CMP.b    #223, d0     ;
  BHI     _LCaseNext
  ADD.b    #32, d0
  BRA     _LCaseNext

_LCaseEnd:
  CLR.b    (a3)
  RTS

 endfunc    8

;---------------------------------------------------------------------------------------

 name      "Mid", "(String, StartPos, Length)"
 flags      StringResult | NoBase
 amigalibs
 params     a0_l,  d0_w, d1_w
 debugger   9

  MOVE.l   d2,-(a7)	; Save registers

  MOVE.l  8(a7), a3     ; Restore the real a3 base in case of re-entrant string operations
  TST.w    d0
  BLE     _SkipLoop1
  SUBQ.w   #1,d0
_MidLoop1:
  MOVE.b   (a0)+,d2     ; Reach the right position
  BEQ     _MidSkip      ;
  DBRA     d0,_MidLoop1 ; Repeat : Until d0=0
  SUBQ.l   #1,a0
_SkipLoop1:
  TST.w    d1
  BLE     _MidSkip
  SUBQ.w   #1,d1
_MidLoop2:
  MOVE.b   (a0)+,d0      ;
  BEQ     _MidSkip        ; If 'd0=0' Then quit (before the length)
  MOVE.b   d0,(a3)+      ;
  DBRA     d1,_MidLoop2  ; Repeat : Until d1=0
_MidSkip:
  CLR.b    (a3)          ; Put a Null caracter to finish th string
  MOVE.l (a7)+,d2		 ;
  RTS

 endfunc  9

;---------------------------------------------------------------------------------------

 name      "FindString", "(String$, StringToFind$, StartPos)"
 flags     LongResult | NoBase
 amigalibs
 params     d2_l,  d1_l, d0_w
 debugger   10

  MOVEM.l   d2-d5,-(a7)	 ; Save registers.

  MOVE.l   d2,a0         ; To fix a compiler bug...
  MOVE.l   d1,a1         ;
  TST.w    d0
  BLE     _SkipFindLoop1
  MOVE.l   d0,d5         ; Save the StartPosition for later ADD
_FindLoop1:
  SUBQ.w   #1,d0
  BEQ     _SkipFindLoop1
  MOVE.b   (a0)+,d1      ; Reach the right position
  BEQ     _FindEnd       ;
  BRA     _FindLoop1     ; Repeat : Until d0=0
_SkipFindLoop1:

  MOVE.l   a0,d4 ; Save the original addr to perform the 'SUB' at the end...
  MOVE.l   a1,d3
  MOVE.l   a0,d2
_FindLoop2:

_FindLoop3:
  MOVE.b   (a0)+,d0
  MOVE.b   (a1)+,d1
  BEQ     _FindOk    ; Si on a atteint la fin du string recherché...
  CMP.b    d0,d1
  BEQ     _FindLoop3

  ;TST.b    d1       ; Si on a atteint la fin du String à trouver..
  ;BEQ     _FindOk   ;

  TST.b    d0       ; Si on a atteint la fin du String, on quit
  BEQ     _FindEnd  ;

  ADDQ.l   #1,d2    ; ADD #1 to the actual search point
  MOVE.l   d2,a0    ; Restore the 2 string address
  MOVE.l   d3,a1    ;

  BRA     _FindLoop2

_FindEnd:
  MOVEQ    #0,d0
  MOVEM.l (a7)+,d2-d5	;
  RTS

_FindOk:
  MOVEQ    #0,d0    ; To respect the '32 bit return'
  SUB.l    d4,d2
  MOVE.w   d2,d0
  ADD.w    d5,d0   	 ; Add 'StartPosition'
  MOVEM.l (a7)+,d2-d5    ;
  RTS

 endfunc   10
;---------------------------------------------------------------------------------------


 name      "Val", "(String$)"
 flags      LongResult | NoBase
 amigalibs _DosBase, a6
 params     d1_l
 debugger   11
  
  MOVE.l   d2,-(a7)	;
  LEA.l    _ValBuffer(pc),a0
  MOVE.l    a0,d2
  JSR      _StrToLong(a6) ; (*String, *LongBuffer) d1/d2
  LEA.l    _ValBuffer(pc),a0
  MOVE.l    (a0),d0
  MOVE.l	(a7)+,d2	;
  RTS

_ValBuffer:
 DC.l       0

 endfunc   11

;---------------------------------------------------------------------------------------

 name      "LTrim", "(String$)"
 flags      StringResult | NoBase
 amigalibs
 params     a0_l
 debugger   12

 MOVE.l     4(a7), a3     ; Restore the real a3 base in case of re-entrant string operations
 MOVE.l     a0,d0         ; Protection against a null string
 BEQ       _StripLeadEnd
_StripLeadLoop:
 MOVE.b     (a0)+,d0
 CMP.b      #32,d0
 BEQ       _StripLeadLoop
 SUB.l      #1,a0
_StripLeadCopy:
 MOVE.b     (a0)+,(a3)+
 BNE       _StripLeadCopy
 SUBQ.l     #1,a3
_StripLeadEnd:
 RTS

 endfunc   12

;---------------------------------------------------------------------------------------

 name      "RTrim", "(String$)"
 flags      StringResult | NoBase
 amigalibs
 params     a0_l
 debugger   13

 MOVE.l     4(a7), a3    ; Restore the real a3 base in case of re-entrant string operations
 MOVE.l     a0,d0        ; Protection against a null string
 BEQ       _StripTrailEnd
 MOVE.l     a0,a1
_StripTrailLoop1:
 MOVE.b     (a0)+,d0
 BNE       _StripTrailLoop1
 SUBQ.l     #1,a0           ; Quick SUB
 CMP.l      a0,a1           ; A null String ?
 BEQ       _StripTrailEnd   ; Quit...
_StripTrailLoop2:
 MOVE.b    -(a0),d0
 CMP.b      #32,d0
 BEQ       _StripTrailLoop2
 ADDQ.l     #1,a0
 CMP.l      a0,a1
 BEQ       _StripTrailEnd
_Loop23:
 MOVE.b     (a1)+,(a3)+
 CMP.l      a0,a1
 BNE       _Loop23
_StripTrailEnd:
 CLR.b      (a3)
 RTS

 endfunc    13

;---------------------------------------------------------------------------------------

 name      "Hex", "(Value)"
 flags     StringResult | NoBase
 amigalibs
 params    d0_l
 debugger  14

 ;MOVEQ   #7,d7
 MOVEM.l   d2-d3,-(a7) ;
 MOVEQ   #7,d3   	     
 
H_loop0
 ROL.l   #4,d0
 MOVE.b  d0,d1
 ANDI.b  #15,d1
 MOVEQ   #48,d2

 CMPI.b  #9,d1
 BLE     H_l0

 MOVEQ   #87,d2

H_l0
 ADD.b   d1,d2
 MOVE.b  d2,(a3)+
 DBRA    d3,H_loop0 

 CLR.b   (a3)
 MOVEM.l   (a7)+,d2-d3
 RTS

 endfunc 14

;---------------------------------------------------------------------------------------

 name      "Bin", "(Value)"
 flags     StringResult | NoBase
 amigalibs
 params    d1_l
 debugger  15

 MOVE.l   d7,-(a7)	; Save registers
 MOVEQ   #31,d7

B_loop0
 MOVEQ   #48,d0
 ROL.l   #1,d1
 BCC     B_l0

 MOVEQ   #49,d0

B_l0
 MOVE.b  d0,(a3)+
 DBRA    d7,B_loop0

 CLR.b   (a3)
 MOVE.l   (a7)+,d7
 RTS

 endfunc 15

;---------------------------------------------------------------------------------------


 name      "Trim", "(String$)"
 flags      StringResult | NoBase
 amigalibs 
 params     a0_l
 debugger   16

 MOVE.l     4(a7), a3     ; Restore the real a3 base in case of re-entrant string operations
 MOVE.l     a0,d0         ; Protection against a null string
 BEQ       .End

.Loop1:
 MOVE.b     (a0)+,d0
 CMP.b      #32,d0
 BEQ       .Loop1
 SUB.l      #1,a0
 MOVE.l     a0,a1

.Loop2:
 MOVE.b     (a0)+,d0
 BNE       .Loop2
 SUBQ.l     #1,a0           ; Quick SUB
 CMP.l      a0,a1           ; A null String ?
 BEQ       .End             ; Quit...

.Loop3:
 MOVE.b    -(a0),d0
 CMP.b      #32,d0
 BEQ       .Loop3
 ADDQ.l     #1,a0
 CMP.l      a0,a1
 BEQ       .End

.Loop4:
 MOVE.b     (a1)+,(a3)+
 CMP.l      a0,a1
 BNE       .Loop4
.End:
 CLR.b      (a3)
 RTS

 endfunc   16
;---------------------------------------------------------------------------------------

 base

 endlib
;---------------------------------------------------------------------------------------

 startdebugger

 enddebugger

