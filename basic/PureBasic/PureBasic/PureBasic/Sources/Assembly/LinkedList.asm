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
; PureBasic 'LinkedList' library
;
; Doobrey: Inlined a few
;    Todo : AddElement needs an error check on AllocPooled !
;
; 18/03/2005
;   Done the save regs d2-d7/a2-a7 ..
;   Several functions now uses the execbase flag instead of MOVE.l $4,a6  
;   .. also ready for the inline stuff .
;
; 04/06/2001
;   Fixed ChangeCurrentElement()
;
; 10/09/2000
;   Fixed a big bug in AddElement() (a2 wasn't preserved)
;
; 15/01/2000
;   Added ChangeCurrentElement()
;
; 23/11/1999
;   Added InsertElement(), Added PreviousElement()
;
; 21/11/1999
;   Converted to PhxAss for maximum performances
;   Rewritten to support PooledMemory allocation
;
; 16/07/1999
;   Added CountList() and ListIndex()
;
; 11/07/1999
;   FirstVersion
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16

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

 initlib "LinkedList", "LinkedList", "", 0, 1, 0

;
; Now do the functions...
;

;---------------------------------------------------------------------------------------

 name      "NextElement", "()"
 flags      NoBase | LongResult
 amigalibs
 params    a0_listelem
 debugger  1

_NextElement:
  MOVE.l   (a0),d0
  BEQ     _PB_NextElementEnd
  MOVE.l   d0,a1
  MOVE.l   (a1),d1
  BEQ     _PB_NextElementEnd   ; Strange routine because a linked
  MOVE.l   d1,a1               ; list on the AmigaOS has tail
  MOVE.l   (a1),d0             ; item (ie: 1 more)
  BEQ     _PB_NextElementEnd   ;
  MOVE.l   d1,(a0)
  RTS
_PB_NextElementEnd:
  MOVEQ    #0,d0
  RTS

 endfunc  1

;---------------------------------------------------------------------------------------

 name      "FirstElement", "()"
 flags      NoBase | InLine
 amigalibs
 params    a0_list
 debugger  2

_FirstElement:
  MOVE.l   (a0),a1
  MOVE.l   (a1),4(a0)
  I_RTS

 endfunc   2

;---------------------------------------------------------------------------------------

 name      "LastElement", "()"
 flags      NoBase | InLine
 amigalibs
 params    a0_list
 debugger  3

_LastElement:
  MOVE.l   (a0),a1
  MOVE.l   8(a1),4(a0)
  I_RTS

 endfunc 3
;---------------------------------------------------------------------------------------


 name      "ResetList", "()"
 flags      NoBase | InLine
 amigalibs
 params    a0_list
 debugger  4

_ResetList:
  MOVE.l   (a0),4(a0)
  I_RTS

 endfunc   4
;---------------------------------------------------------------------------------------


 name      "AddElement", "()"
 flags      NoBase
 amigalibs  _ExecBase,a6
 params    a0_list
 debugger  5

_AddElement:
  MOVEM.l   d2/a2-a3,-(a7)
  MOVE.l    a0,a3
  MOVE.l   (a3),a0   ; Get the List structure
  MOVE.l   -4(a0),d0 ; Get the structure list size
  ADDQ.l   #8,d0
  MOVE.l   14(a0),a0 ; Get the PoolHeader
  JSR     _AllocPooled(a6) ; (*PoolHeader,Size) - a0/d0
  MOVE.l   d0,d2
  MOVE.l   (a3),a0
  MOVE.l   d0,a1
  MOVE.l   4(a3),a2
  JSR     _Insert(a6)
  MOVE.l   d2,4(a3)
  MOVEM.l   (a7)+,d2/a2-a3
  RTS

 endfunc   5
;---------------------------------------------------------------------------------------


 name      "KillElement", "()"
 flags      NoBase | NoResult
 amigalibs  _ExecBase,a6
 params    a0_listelem
 debugger  6

_KillElement:
  MOVEM.l  d3/a5,-(a7)
  MOVE.l   a0,a5
  MOVE.l   (a5),d0
  BEQ     _PB_KillElementEnd
  MOVE.l   d0,a1
  MOVE.l   4(a1),d2
  JSR     _Remove(a6)
  MOVE.l   (a5),a1        ; Get Memory zone to free
  MOVE.l  -4(a5),a0       ; Get List Header
  MOVE.l  -4(a0),d0       ; Get Structure Size
  ADDQ.l   #8,d0          ;
  MOVE.l   14(a0),a0      ; Get Pool Header
  JSR     _FreePooled(a6) ; (PoolHeader, *Memory, Size) a0-a1/d0
  MOVE.l   d2,(a5)
_PB_KillElementEnd:
  MOVEM.l  (a7)+,d3/a5
  RTS

 endfunc   6
;---------------------------------------------------------------------------------------


 name      "ListBase", "()"
 flags     NoBase |  LongResult | InLine
 amigalibs
 params    a0_list
 debugger  7

_ListBase:
  MOVE.l   (a0),d0
  I_RTS

 endfunc   7

;---------------------------------------------------------------------------------------

 name      "CountList", "()"
 flags     NoBase |  LongResult
 amigalibs
 params    a0_list
 debugger  8

_CountList:
  MOVEQ    #0,d0
_CountListLoop
  MOVE.l   (a0),d1
  BEQ     _CountListEnd
  MOVE.l   d1,a0
  ADDQ.l   #1,d0
  BRA     _CountListLoop
_CountListEnd:
  SUBQ.l   #2,d0   ; To have the right number of elems...
  RTS

 endfunc   8

;---------------------------------------------------------------------------------------

 name      "ListIndex", "()"
 flags     NoBase |  LongResult
 amigalibs
 params    a0_list
 debugger  9

_ListIndex:
  MOVEM.l  d2-d3,-(a7)
  
  MOVEQ    #0,d0
  MOVE.l   4(a0), d3  ; Get current element address
  BEQ     _ListIndexEnd
  MOVE.l   (a0), a0   ; Get the listbase
  MOVE.l   8(a0), d2  ; Get Last element address..
  BEQ     _ListIndexEnd
_ListIndexLoop
  MOVE.l   (a0),d1    ; Get the first and next elements..
  BEQ     _ListIndexEnd
  ADDQ.l   #1,d0
  CMP.l    d1,d3      ; If it's the right one, quit..
  BEQ     _ListIndexEnd
  MOVE.l   d1,a0
  BRA     _ListIndexLoop
_ListIndexEnd:
  MOVEM.l  (a7)+,d2-d3
  RTS

 endfunc   9
;---------------------------------------------------------------------------------------


 name      "ClearList", "()"
 flags     NoBase | NoResult
 amigalibs _ExecBase,a6
 params    a0_list
 debugger  10

_ClearList:
  MOVEM.l  d3-d4/a2,-(a7)

  MOVE.l   a0,a2      ; For later use
  MOVE.l   (a0),a0    ; Free the old Pool...
  MOVE.l  -4(a0),d4   ; Get the old size of the elements
  MOVE.l   14(a0),a0  ;
  JSR     -702(a6)    ;

  JSR     _PB_CreatePool
  MOVE.l   d0,d3
  MOVE.l   d0,a0      ; Re-Build the List.
  MOVEQ    #22,d0     ;
  JSR     -708(a6)    ;
  MOVE.l   d0,a0
  MOVE.l   d4,(a0)+   ; Set the size of each element
  MOVE.l   a0,(a2)+
  CLR.l    (a2)
  MOVE.l   a0,8(a0)
  MOVE.l   a0,d0
  ADDQ.l   #4,d0
  MOVE.l   d0,(a0)
  MOVE.l   d3,14(a0)
  MOVEM.l  (a7)+,d3-d4/a2
  RTS

_PB_CreatePool:
  MOVE.l #65536,d0   ; Create a brand new pool
  MOVEQ #127, d1     ;
  MOVE.l d1,d2       ;
  JMP -696(a6)       ; CreatePool() - d0,d1,d2

 endfunc   10

;---------------------------------------------------------------------------------------

 name      "InsertElement", "()"
 flags      NoBase | LongResult
 amigalibs  _ExecBase,a6
 params     a0_list
 debugger   11

_InsertElement:
  MOVEM.l  d2-d3/a2-a3,-(a7)

  MOVE.l   a2,d3     ; Save the register in 'd3'
  MOVE.l   a0,a3
  MOVE.l   (a5),a0   ; Get the List structure
  MOVE.l   -4(a0),d0 ; Get the structure list size
  ADDQ.l   #8,d0
  MOVE.l   14(a0),a0 ; Get the PoolHeader
  JSR     _AllocPooled(a6) ; (*PoolHeader,Size) - a0/d0
  MOVE.l   d0,d2
  MOVE.l   (a3),a0
  MOVE.l   d0,a1
  MOVE.l   4(a3),a2
  MOVE.l   a2,d0               ; No element in the list ?
  BEQ     _InsertElement_Next
  MOVE.l   4(a2),a2            ; Get the previous node
  CMP.l    (a3),a2             ; Check if the previous node was the list header...
  BNE     _InsertElement_Next  ; No ? Ok, insert it...
  SUB.l    a2,a2               ; Else Insert a the head of list by passing '0' in a2
_InsertElement_Next:
  JSR     _Insert(a6)          ; (*List, *Node, *PreviousNode) - a0/a1/a2
  MOVE.l   d2,4(a3)
  MOVE.l   d3,a2      ; Restore the register
  MOVEM.l  (a7)+,d2-d3/a2-a3
  RTS

 endfunc   11

;---------------------------------------------------------------------------------------

 name      "PreviousElement", "()"
 flags      NoBase | LongResult
 amigalibs
 params     a0_list
 debugger   12

_PreviousElement:
  MOVE.l    (a0)+,d1            ; (a0)+ -> Optimization for later write
  MOVE.l    (a0),a1            
  MOVE.l    a1,d0
  BEQ      _PreviousElement_End ; If the current element doesn't exist (list empty), quit.
  MOVE.l   4(a1),d0             ; Get the previous element address...
  CMP.l     d0,d1               ; If the previous element is the list header, quit.
  BEQ      _PreviousElement_End ;
  MOVE.l    d0,(a0)             ; Set the previous element as current and return it's address.
  RTS
_PreviousElement_End:
  MOVEQ     #0,d0
  RTS

 endfunc    12
;---------------------------------------------------------------------------------------


 name      "ChangeCurrentElement", "()"
 flags      NoBase | LongResult | InLine
 amigalibs
 params     a0_listelem, d0_l
 debugger   13

  SUBQ.l    #8,d0
  MOVE.l    d0,(a0)
  I_RTS

 endfunc    13
;---------------------------------------------------------------------------------------


 base
Base:

 endlib
;---------------------------------------------------------------------------------------

 startdebugger

 enddebugger

