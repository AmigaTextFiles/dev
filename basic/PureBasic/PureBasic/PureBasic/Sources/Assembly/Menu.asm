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
; 10/09/2005
;   -Doobrey-
; Ooops, forgot about functions in base trashing regs!
; LW aligned functions in base
;
; 20/03/2005
;    -Doobrey-
;      Small mods to comply with API style reg use\save
;      Added a few more lib flags for future use.
;      Now compiles with OPT 3 .. replaced the hardcoded base offsets with label offsets
;      ... ie funcoffset= l_funcoffset - LibBase .. so simple it should have been obvious ;)
;
; TODO... Needs reg checking in base functions !
;
; PureBasic 'Menu' library
;
; ----------------------- WARNING compiles with OPT=0 ---------------------
;
;
;
; 01/06/2001
;   Converted to PhxAss
;
; 03/05/2001
;   Fixed a big bug in CreateMenu(): forget to clear d1 before FillMenuStruct
;
; 20/01/2000
;   Added a check in FreeMenus() in case of InitMenu() isn't called..
;
; 02/09/2000
;   Finally removed the last bug found in this lib    Thx to MuForce   
;
; 08/07/2000
;  Recoded much of code to support litteral strings entry (MemoryPool added...)
;
; 15/07/1999
;  FirstVersion
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16

TAG_USER   = 1 << 31
TAG_MORE   = 2

CHECKIT     = $0001  ; set to indicate checkmarkable item */
ITEMTEXT    = $0002  ; set if textual, clear if graphical item */
COMMSEQ     = $0004  ; set if there's an command sequence */
MENUTOGGLE  = $0008  ; set for toggling checks (else mut. exclude) */
ITEMENABLED = $0010  ; set if this item is enabled */

NM_TITLE =   1   ; Menu header */
NM_ITEM  =   2   ; Textual menu item */
NM_SUB   =   3   ; Textual menu sub-item */

GT_TagBase  =  TAG_USER + $80000

GTMN_TextAttr = GT_TagBase+49 ; MenuItem font TextAttr */
GTMN_FrontPen = GT_TagBase+50 ; MenuItem text pen color */


_GadTools = 0
_ObjNum   =  _GadTools+4
_MemPtr   =  _ObjNum+4

_CurMenuNum =  _MemPtr+4
_MenuSize   =  _CurMenuNum+4
_MenuStruct =  _MenuSize+4

_VisualInfo =  _MenuStruct+4
_MemoryPool =  _VisualInfo+4

_NbItem     =  _MemoryPool+4  ; Must be together
_NbToggle   =  _NbItem+4      ;

_NbSubItem   =  _NbToggle+4
_NbSubToggle =  _NbSubItem+4

_MenuTag1    =  _NbSubToggle+4
_Tag1        =  _MenuTag1+4


GetPosition   = l_GetPosition - LibBase 
FreeMenu      = l_FreeMenu - LibBase    
WriteToggle   = l_WriteToggle - LibBase 
InitITEM      = l_InitITEM - LibBase    
InitITEM2     = l_InitITEM2 - LibBase   
InitSUBITEM   = l_InitSUBITEM - LibBase
FillMenuStruct= l_FillMenuStruct - LibBase


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

 initlib "Menu", "Menu", "FreeMenus", 0, 1, 0

;
; Now do the functions...
;

;-----------------------------------------------------------------------------------------------------
 name      "InitMenu", "(#MaxMenus, #MaxItems)"
 flags      NoResult
 amigalibs  _ExecBase,  a6
 params     d0_l,  d2_l
 debugger   1
  
  ADDQ.l   #1, d0              ; Needed to have the correct number  
  ADDQ.l   #1, d2              ;

  MOVE.l   d0, _ObjNum(a5)     ; Set MaxMenu number
  LSL.l    #4, d0
  MOVE.l   #MEMF_CLEAR, d1     ;
  JSR     _AllocVec(a6)        ; (d0,d1)
  MOVE.l   d0, _MemPtr(a5)     ; Set *MemPtr

  MOVE.l   d2, _MenuSize(a5)   ;
  MULU     #20, d2             ;
  MOVE.l   d2, d0              ;
  MOVE.l   #MEMF_CLEAR, d1     ;
  JSR     _AllocVec(a6)        ; (d0,d1)
  MOVE.l   d0, _MenuStruct(a5) ; Set *MenuStruct

  MOVEQ.l  #0,d0               ; MemType
  MOVE.l   #512,d1             ; Puddle
  MOVE.l   d0,d2               ; Max Puddle
  JSR     _CreatePool(a6)      ; Create the pool for the first menulist (to store the assiociated strings)
  MOVE.l   d0,_MemoryPool(a5)  ;

  LEA.l   _GadTools_Name(pc),a1; Library name
  MOVEQ    #36, d0             ; Version
  JSR     _OpenLibrary(a6)     ; (*Name$, Version) - a1/d0
  MOVE.l   d0, _GadTools(a5)   ; Set *GadTools
  RTS


_GadTools_Name:
 Dc.b "gadtools.library",0
 Even

 endfunc   1
;-----------------------------------------------------------------------------------------------------

 name      "FreeMenus", "()"
 flags      NoResult
 amigalibs  _ExecBase,  a6
 params
 debugger  2

  MOVE.l   d4,-(a7)
  MOVE.l  _ObjNum(a5), d4     ; Num of Menus
  BEQ     _FreeMenusNoFree
_LoopFreeMenus:               ; Free all menulists
  SUBQ     #1, d4
  MOVE.l   d4, d0
  JSR      FreeMenu(a5)       ; Input a1, No Result - a3 is need to put #0 a6=execbase
  TST.l    d4
  BNE     _LoopFreeMenus      ; Repeat:Until d4 = d0

  MOVE.l   a6,d4              ; Preserve ExecBase
  MOVEA.l _VisualInfo(a5), a0 ;
  MOVEA.l _GadTools(a5), a6   ;
  JSR     _FreeVisualInfo(a6) ; - a0
  MOVE.l   d4,a6              ; Restore ExecBase
  MOVEA.l _GadTools(a5), a1   ;
  JSR     _CloseLibrary(a6)   ; (*Library) - a1

  MOVE.l   (a7)+,d4

  MOVEA.l _MemoryPool(a5),a0  ;
  JSR     _DeletePool(a6)     ; (*Pool) - a0
  MOVEA.l _MemPtr(a5), a1     ; FreeMenus
  JSR     _FreeVec(a6)        ; (a1)
  MOVEA.l _MenuStruct(a5), a1 ; Free Menu Struct
  JMP     _FreeVec(a6)        ; (a1)

_FreeMenusNoFree:
  MOVE.l  (a7)+,d4
  RTS

 endfunc   2

;-----------------------------------------------------------------------------------------------------

 name      "FreeMenu", "()"
 flags  NoResult | InLine
 amigalibs  _ExecBase,  a6
 params     d0_l
 debugger   3

  I_JSR      FreeMenu(a5)

 endfunc    3

;-----------------------------------------------------------------------------------------------------

 name      "MenuTitle", "(Label$)"
 flags
 amigalibs  _ExecBase,a6
 params     d0_l
 debugger   4
  
  MOVEM.l  d2-d5,-(a7)    ;
  JSR      WriteToggle(a5)    ; Check if we need to write the Toggle mutual exclude fields..
  CLR.l   _NbItem(a5)         ; Put the actual num of menu item to 0
  MOVE.l   d0, d1
  CLR.l    d0
  CLR.l    d2
  CLR.l    d3
  MOVEQ    #NM_TITLE, d6
  JSR      FillMenuStruct(a5) ; -NB trashes  d2,d4,d5 a0,a1
  MOVEM.l  (a7)+,d2-d5    ;
  RTS

 endfunc   4

;-----------------------------------------------------------------------------------------------------

 name      "MenuItem", "(#Item, Label$, HotKey$)"
 flags
 amigalibs  _ExecBase,a6
 params     d0_l,  d1_l,  d2_l
 debugger  5

  MOVEM.l   d2-d6,-(a7)   ;
  JSR      InitITEM(a5)   ; NB this trashes d4,d6,a0
  MOVEQ.l  #0,d3
  JSR      FillMenuStruct(a5) ; NB trashes  d2,d4,d5 a0,a1
  MOVEM.l   (a7)+,d2-d6   ;
  RTS
 
 endfunc   5

;-----------------------------------------------------------------------------------------------------

 name      "MenuSubItem", "(#Item, Label$, HotKey$)"
 flags
 amigalibs  _ExecBase,a6
 params     d0_l,  d1_l,  d2_l
 debugger  6

  MOVEM.l   d2-d6,-(a7) ;
  JSR      InitSUBITEM(a5)  ; NB trashes d4,d6,a0
  MOVEQ.l  #0,d3
  JSR      FillMenuStruct(a5) ; -NB trashes  d2,d4,d5 a0,a1
  MOVEM.l   (a7)+,d2-d6 ;
  RTS

 endfunc   6

;-----------------------------------------------------------------------------------------------------

 name      "MenuCheckItem", "(#Item, Label$, HotKey$, State)"
 flags
 amigalibs  _ExecBase,a6
 params     d0_l,  d1_l,  d2_l,  d3_l
 debugger  7

  MOVEM.l   d2-d6,-(a7)   ;
  JSR      InitITEM(a5)     ; Trashes d4,d6,a0
  LSL.l    #8, d3                       ; If State is enable, do it #CHECKED (256)
  ADD.w    #CHECKIT | MENUTOGGLE, d3   
  JSR      FillMenuStruct(a5)   ;-NB trashes  d2,d4,d5 a0,a1
  MOVEM.l   (a7)+,d2-d6   ;
  RTS

 endfunc   7

;-----------------------------------------------------------------------------------------------------

 name      "MenuSubCheckItem", "(#Item, Label$, HotKey$, State)"
 flags
 amigalibs  _ExecBase,a6
 params     d0_l,  d1_l,  d2_l,  d3_l
 debugger  8

  MOVEM.l   d2-d6,-(a7)   ;
  JSR      InitSUBITEM(a5)    ; Trashes d4,d6,a0
  LSL.l    #8, d3                       ; If State is enable, do it #CHECKED (256)
  ADD.w    #CHECKIT | MENUTOGGLE, d3   
  JSR      FillMenuStruct(a5)   ; -NB trashes  d2,d4,d5 a0,a1
  MOVEM.l   (a7)+,d2-d6   ;
  RTS

 endfunc   8

;-----------------------------------------------------------------------------------------------------

 name      "MenuToggleItem", "(#Item, Label$, HotKey$, State)"
 flags  NoResult 
 amigalibs  _ExecBase,a6
 params     d0_l,  d1_l,  d2_l,  d3_l
 debugger   9

._MenuToggleItem:
  MOVEM.l  d3-d4/d6,-(a7)   ;
  MOVE.l  _NbSubToggle(a5), d4
  BEQ     _SkipWrite
  JSR      WriteToggle(a5)
_SkipWrite:
  MOVEQ.l  #1, d4               ; Fast 'ADD.l #1, _NbItem'
  ADD.l    d4, _NbToggle(a5)    ;
  JSR      InitITEM2(a5)        ; Trashes d4,d6,a0
  LSL.l    #8, d3                      ; If State is enable, do it #CHECKED (256)
  ADD.w    #CHECKIT | MENUTOGGLE, d3   ;
  JSR      FillMenuStruct(a5)
  MOVEM.l  (a7)+,d3-d4/d6   ;
  RTS

 endfunc   9
;-----------------------------------------------------------------------------------------------------

 name      "MenuSubToggleItem", "(#Item, Label$, HotKey$, State)"
 flags  NoResult ; ???
 amigalibs  _ExecBase,a6
 params     d0_l,  d1_l,  d2_l,  d3_l
 debugger   10

  MOVEM.l  d2-d6,-(a7)
  MOVEQ.l  #1, d4            ; Small 'ADD.l #1, _NbSubItem'
  LEA.l   _NbSubItem(a5), a0 ;       'ADD.l #1, _NbSubToggle'
  ADD.l    d4, (a0)+         ;
  ADD.l    d4, (a0)          ;
  MOVEQ    #NM_SUB, d6
  LSL.l    #8, d3                     ; If State is enable, do it #CHECKED (256)
  ADD.w    #CHECKIT | MENUTOGGLE, d3   
  JSR      FillMenuStruct(a5)   ; -NB trashes  d2,d4,d5 a0,a1
  MOVEM.l  (a7)+,d2-d6
  RTS

 endfunc   10

;-----------------------------------------------------------------------------------------------------

 name      "MenuBar", "()"
 flags  NoResult
 amigalibs  _ExecBase,a6
 params
 debugger  11

  MOVEM.l  d2-d6,-(a7)   ;
  JSR      InitITEM(a5)  ; Trashes d4,d6,a0
  MOVEQ.l  #-1, d0       ; -1 for both
  MOVE.l   d0, d1        ;
  CLR.l    d2
  CLR.l    d3
  JSR      FillMenuStruct(a5) ; -NB trashes  d2,d4,d5 a0,a1
  MOVEM.l  (a7)+,d2-d6   ;
  RTS

 endfunc   11

;-----------------------------------------------------------------------------------------------------

 name      "MenuSubBar", "()"
 flags  NoResult
 amigalibs  _ExecBase,a6
 params
 debugger  12

  MOVEM.l  d2-d6,-(a7)   ;
  JSR      InitSUBITEM(a5) ;  Trashes d4,d6,a0
  MOVEQ.l  #-1, d0       ; -1 for both
  MOVE.l   d0, d1        ;
  CLR.l    d2
  CLR.l    d3
  JSR      FillMenuStruct(a5) ; Trashes  d2,d4,d5 a0,a1
  MOVEM.l  (a7)+,d2-d6   ;
  RTS

 endfunc   12

;-----------------------------------------------------------------------------------------------------

 name      "CreateMenu", "(#Menu, ScreenID())"
 flags  LongResult
 amigalibs  _ExecBase,d5
 params     d0_l,  d1_l
 debugger  13

  MOVEM.l  d2/d4-d7/a2-a3,-(a7) ;
  MOVE.l   d0, a2
  JSR      WriteToggle(a5)
  MOVE.l   d1, d7
  CLR.l    d1                   ; Inform FillMenuStruct() than it's the last item
  CLR.l    d6                   ; #END_MENU tag
  MOVE.l   d5,-(a7)       ; Save the ExecBase pointer
  MOVE.l   d5,a6        ; Ensure the ExecBase is in a6 for FillMenuStruct
  JSR      FillMenuStruct(a5)   ; -NB trashes  d2,d4,d5 a0,a1
  MOVE.l   (a7)+,d5       ; Restore the ExecBase pointer
  MOVEA.l _GadTools(a5), a6     ;
  MOVEA.l _MenuStruct(a5), a0   ;
  LEA.l   _MenuTag1(a5), a1     ;
  JSR     _CreateMenusA(a6)     ; (*Menu, TagList) - a0, a1
  MOVE.l   d0, d2
  MOVE.l   a2, d0               ;
  JSR      GetPosition(a5)          ; a3 = position
  MOVE.l   d2, (a3)             ; Put it in the bank
  LEA.l   _VisualInfo(a5), a2
  TST.l    (a2)                 ; CMP #0, (a2) - WARNING if d6 changes...
  BNE     _SkipVisualInfo
  MOVE.l   d7, a0
  SUB.l    a1, a1               ; Quick CLEAR
  JSR     _GetVisualInfoA(a6)   ; (*Screen, NULL) - a0, a1
  MOVE.l   d0, (a2)             ; Set VisualInfo in the newgadget struct
_SkipVisualInfo:
  MOVE.l   (a3)+, a0
  MOVEA.l _VisualInfo(a5), a1   ;
  SUB.l    a2, a2               ; Quick CLEAR
  JSR     _LayoutMenusA(a6)     ; (*Menu, vi, TagList) - a0,a1,a2
  CLR.l   _CurMenuNum(a5)

  MOVE.l  _MemoryPool(a5),(a3)  ; Save the menu memory pool to the menu bank

  MOVE.l   d5,a6    
  MOVEQ.l  #0,d0               ; MemType
  MOVE.l   #512,d1             ; Puddle
  MOVE.l   d0,d2               ; Max Puddle
  JSR     _CreatePool(a6)      ; Create the pool for the next menulist (to store the assiociated strings)
  MOVE.l   d0,_MemoryPool(a5)  ;
  MOVEM.l  (a7)+,d2/d4-d7/a2-a3 
  RTS

 endfunc   13

;-----------------------------------------------------------------------------------------------------
 name      "AttachMenu", "(#Menu, WindowID())"
 flags  ; <<-- Check result..
 amigalibs  _IntuitionBase,  a6
 params     d0_l,  a0_l
 debugger   14

  MOVE.l   a3,-(a7)
  JSR      GetPosition(a5)
  MOVE.l   (a7)+,a3
  JMP     _SetMenuStrip(a6)     ; (*Win, *Menu) - a0, a1

 endfunc   14
;-----------------------------------------------------------------------------------------------------

 name      "SetMenuColour", "()"
 flags  NoResult | InLine
 amigalibs
 params     d0_l
 debugger  15

  MOVE.l   d0, _Tag1(a5)
  I_RTS

 endfunc   15

;-----------------------------------------------------------------------------------------------------

 base
LibBase:


 Dc.l 0  ; *GadTools
 Dc.l 0  ; ObjNum
 Dc.l 0  ; MemPtr

 Dc.l 0  ; CurMenuNum
 Dc.l 0  ; MenuSize
 Dc.l 0  ; MenuStruct

 Dc.l 0  ; VisualInfo
 Dc.l 0  ; MemoryPool

 Dc.l 0  ; NbItem    ; Must be together
 Dc.l 0  ; NbToggle  ;

 Dc.l 0  ; NbSubItem
 Dc.l 0  ; NbSubToggle

 Dc.l GTMN_FrontPen   ; Menu Taglist
 Dc.l 1               ;
 Dc.l 0               ;

 CNOP 0,4
;------------------------------------------------------------
; GetPosition
; - NB. trashes a3

l_GetPosition:
  MOVEA.l _MemPtr(a5), a3
  LSL.l    #4, d0
  ADD.l    d0, a3
  MOVE.l   (a3), a1
  RTS
  CNOP 0,4
;------------------------------------------------------------
; FreeMenus    
; Execbase must be in a6 on entry 

l_FreeMenu:
  MOVEM.l   a3/a6,-(a7)
  JSR      GetPosition(a5)
  MOVEA.l _GadTools(a5), a6
  MOVE.l   a1, a0
  JSR     _FreeMenus(a6)     ; - a0 - Passing NULL is SAFE
  CLR.l    (a3)+
  MOVEA.l  (a3),a0
  MOVEM.l  (a7)+,a3/a6
  JMP     _DeletePool(a6)    ; (*Pool) - a0

  CNOP 0,4
;-------------------------------------------------------------
; WriteToggle
; 

l_WriteToggle:
  MOVEM.l  d0-d4/a0,-(a7)

  MOVE.l  _NbSubToggle(a5), d1
  TST.l    d1
  BNE     _BuildSub

  MOVE.l  _NbToggle(a5), d1
  TST.l    d1
  BEQ     _End
  CLR.l   _NbToggle(a5)    ; Reset to 0
  MOVE.l  _NbItem(a5), d3
  BRA     _Next
_BuildSub:
  MOVE.l  _NbSubItem(a5), d3
  CLR.l   _NbSubToggle(a5)
_Next
  SUB.l    d1, d3     ; To have only the number of item BEFORE the toggles...
  MOVE.l   d1, d2     ;
  SUBQ     #1, d1     ;
  MOVEA.l _MenuStruct(a5), a0
  MOVE.l  _CurMenuNum(a5), d0
  ADD.l    d0, a0
  ;LEA.l   _mytmp(a5), a0
  MOVEQ    #20, d4
_Loop:
  SUB.l    d4, a0     ; Quick (small) Sub.l #20, a0
  MOVEQ    #1, d0     ;
  LSL.l    d2, d0     ;
  SUBQ     #1, d0     ; Do correct mask %111     %110
  BCHG     d1, d0     ; Change the correct bit   %101
  LSL.l    d3, d0     ;                          %011
  MOVE.l   d0, 12(a0) ; Fill MutualExclude field..
  ;MOVE.l   d0, (a0)+ ; Fill MutualExclude field..
  DBF      d1, _Loop  ;
_End
  MOVEM.l  (a7)+,d0-d4/a0
  RTS

 CNOP 0,4
;--------------------------------------------------------------------
; InitITEM
; -NB as with InitITEM2, trashes d4,d6,a0

l_InitITEM:
  JSR      WriteToggle(a5)    ; Check if we need to write the Toggle mutual exclude fields..
  ;- NB runs through into InitITEM2 !

;---------------------------------------------------------------------
;InitITEM2
; -NB trashes d4,d6,a0

l_InitITEM2:

  CLR.l   _NbSubItem(a5)  ; Clear the NbSubItem
  MOVEQ.l  #1,  d4        ;
  LEA.l   _NbItem(a5), a0 ; Small 'ADD.l #1, _NbItem'
  ADD.l    d4, (a0)       ;
  MOVEQ.l  #NM_ITEM, d6   ;
  RTS
  CNOP 0,4
;---------------------------------------------------------------------
; InitSUBITEM
; -NB trashes d4,d6,a0

l_InitSUBITEM:
  JSR      WriteToggle(a5)       ; Check if we need to write the Toggle mutual exclude fields..
  MOVEQ.l  #1,  d4           ;
  LEA.l   _NbSubItem(a5), a0 ; Small 'ADD.l #1, _NbSubItem'
  ADD.l    d4, (a0)          ;
  MOVEQ.l  #NM_SUB, d6
  RTS
  CNOP 0,4

;---------------------------------------------------------------------
; FillMenuStruct     
; Execbase must be in a6 
; -NB trashes  d2,d4,d5 a0,a1

l_FillMenuStruct:
  TST.l    d1
  BLE     _AllIsOk   ; This is a SeparatorBar() like menu
  MOVE.l   d1,a0
  MOVEQ.l  #-1,d4
_GetStringSize:
  ADDQ.l   #1,d4
  TST.b    (a0)+
  BNE     _GetStringSize

  MOVEM.l  d0-d1,-(a7)
  MOVE.l   d1, -(a7)
  MOVEA.l _MemoryPool(a5), a0
  MOVE.l   d4, d0
  ADDQ.l   #3, d0
  JSR     _AllocPooled(a6)

  MOVE.l   (a7)+, a0
  MOVE.l   d0, a1
_CopyString:
  MOVE.b   (a0)+, (a1)+
  BNE     _CopyString

  MOVE.l   d0, d1
  ADD.l    d4, d0
  ADDQ.l   #1, d0
  MOVE.l   d0, a0
  TST.l    d2
  BEQ     _NoShortCut
  MOVE.l   d2, a1
  MOVE.b   (a1), d2
  TST.b    d2
  BEQ     _NoShortCut
  MOVE.b   d2,(a0)
  CLR.b    1(a0)
  MOVE.l   a0,d2
  BRA     _Next1

_NoShortCut:
  MOVEQ.l  #0,d2

_Next1:
  MOVEM.l  (a7)+,d0-d1

_AllIsOk:
  MOVEA.l _MenuStruct(a5), a0
  MOVE.l  _CurMenuNum(a5), d5
  ADD.l    d5, a0
  MOVE.b   d6, (a0)+  ; Type
  CLR.b    (a0)+      ; Pad
  MOVE.l   d1, (a0)+  ; MenuLabel
  MOVE.l   d2, (a0)+  ; CommKey
  MOVE.w   d3, (a0)+  ; Flags
  CLR.l    (a0)+      ; Mutual exclude
  MOVE.l   d0, (a0)   ; MenuID
  ADD.w    #20, d5
  MOVE.l   d5, _CurMenuNum(a5)
  RTS

 endlib

;---------------------------------------------------------------------

 startdebugger

 enddebugger

