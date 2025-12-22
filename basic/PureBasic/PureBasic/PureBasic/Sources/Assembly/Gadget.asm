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
; PureBasic Gadget Library (Amiga)
;
; 10/10/2005
;  -Doobrey- Just preserved regs, LW aligned taglists and removed hard coded base function offsets.
;
;---------------------------------------------------------------------------------------
;
; 08/06/2001
;   See Done below.
;
; 17/05/2001
;   Added GetGadgetText(), SetGadgetText() and GetGadgetState()
;   and it works perfect except for the first two when its a
;   text gadget. Changed params in SetGadgetFont() from (@ta)
;   to (Font$,Size), there could only be one call else all
;   buttons get the font that was in last call.
;
; 14/05/2001
;   Added SetGadgetTagList() and removed TagList param
;   from all Gadget() functions.
;
; 13/05/2001
;   Converted source to PhxAss. Assembled okey but example
;   Gadget.pb didn't work. (It was base aligned bug.)
;
; 05/05/2001
;   Used the new PB_AllocateString routine
;
; 20/01/2001
;   Fixed FreeGadget() (Was bugged when Init() wasn't called..
;
; 15/01/2001
;   Added GetCheckBoxState()
;
; 29/07/2000
;   Changed a bit 'OptionGadget()'
;
; 02/07/2000
;   Changed lot of things.
;   All strings are allocated in it's own pool
;   Now, all the labels are supported in a predefined order...
;
; 01/04/2000
;   Fixed a big bug when using UseGadgetList() ('a3' was destroyed)
;   Fixed a minor bug (in AttachGadgetList(), replaced 0 by -1 for pos & end gadget)
;
; 20/01/2000
;   Fixed a bug in ActivateGadget()
;
; 02/06/1999
;   Fixed a big bug ! (d6 wasn't loaded for other gadget than button)
;
; 15/05/1999
;  FirstVersion
;

; To Do.
; =====
;
; *  Optimize GetGadgetText(), SetGadgetText(), SetGadgetState()
;    and GetGadgetState() with code moved to libbase.
; ?? Add a GadgetList Lib, but only compatible between
;    AmigaOS and Linux. (Later)
; ?  Lables of like CycleGadget() copyed, don't know.
;

; Done.
; ====
; *  Moved DeatacheGadgetList() to Gadget Lib, from Window Lib.
; *  Add 60 sub 60, to gadget id, must remain
; *  Rename SetGadgetAttrs() to SetGadgetAttributes() and take
;    a TagList as a param, instead of one tag.
; *  BevelBox() moved to gadget lib.
; *  SetGadgetFont(FontID)
; *  Remove SetGadgetFlags().
; *  GetGadgetText() should work with no textbased gadgets also
;    but return "".
; *  GetGadgetValue() and SetGadgetValue() will be replaced by
;    GetGadgetState() and SetGadgetState().
; *  Change to CreateGadgetList()
; ** Change to InitGadget(#MaxGadgets) and dynamically allocate
;    gadgetlists.
; *  Remove all that have to do with gadgetlists.
; *  Add top and right border to gadgets x and y pos.
; ** Fix BevelBox() and renamed to GadgetBevelBox().
; *  FreeGadget() with -1 to free all gadgets on current window
;    else remove a single gadget. (was DeatacheGadgetList())
;    A single gadget free is not quit good, it just remove it
;    from the gadgetlist and it will stay in memory.
; *  RefreshGadget() with -1 to refresh whole gadgetlist of the
;    current window else refresh a single gadget.
; *  GadgetXXX() functions could add a new gadget to any window
;    that have gadgets from befor. (RefreshGadget(-1) must bee done)
;
; *  Fixed and extended error check, was trashing used regs.


 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

TAG_MORE          = 02

BUTTON_KIND       = 01
CHECKBOX_KIND     = 02
INTEGER_KIND      = 03
LISTVIEW_KIND     = 04
MX_KIND           = 05
NUMBER_KIND       = 06
CYCLE_KIND        = 07
PALETTE_KIND      = 08
SCROLLER_KIND     = 09
SLIDER_KIND       = 11
STRING_KIND       = 12
TEXT_KIND         = 13

PLACETEXT_LEFT    = $0001
PLACETEXT_RIGHT   = $0002
PLACETEXT_ABOVE   = $0004
PLACETEXT_IN      = $0010

GA_Immediate      = $80030000+$15
GA_RelVerify      = $80030000+$16
GA_Disabled       = $80030000+$0e

GTCB_Checked      = $80080000+04
GTLV_Labels       = $80080000+06
GTMX_Labels       = $80080000+09
GTMX_Active       = $80080000+10
GTTX_Text         = $80080000+11
GTNM_Number       = $80080000+13
GTCY_Labels       = $80080000+14
GTCY_Active       = $80080000+15
GTPA_Depth        = $80080000+16
GTPA_Color        = $80080000+17
GTSC_Top          = $80080000+21
GTSC_Total        = $80080000+22
GTSC_Visible      = $80080000+23
GTSL_Min          = $80080000+38
GTSL_Max          = $80080000+39
GTSL_Level        = $80080000+40
GTST_String       = $80080000+45
GTST_MaxChars     = $80080000+46
GTIN_Number       = $80080000+47
GTBB_Recessed     = $80080000+51
GT_VisualInfo     = $80080000+52
GTLV_ShowSelected = $80080000+53
GTLV_Selected     = $80080000+54
GTTX_Boarder      = $80080000+57

_LibBase          = 0
_GTBase           = _LibBase
_ObjNum           = _GTBase+4
_MemPtr           = _ObjNum+4
_MemPtr2          = _MemPtr+4
_GListPos         = _MemPtr2+4
_CurrGList        = _GListPos+4
_CurrWin          = _CurrGList+4
_TagList          = _CurrWin+4
_NewGadget        = _TagList+4
_NewGadText       = _NewGadget+8
_NewGadFont       = _NewGadText+4
_NewGadFlags      = _NewGadFont+6
_VisualInfo       = _NewGadFlags+4

_B_GTFillStruct=l_GTFillStruct-LibBase


_GadgetList       = 0
_FirstGadget      = _GadgetList
_LastGadget       = _FirstGadget+4
_WindowPtr        = _LastGadget+4
_MemPool          = _WindowPtr+4
_GL_Size          = _MemPool+4

_Gadget           = 0
_GadgetPtr        = _Gadget
_G_Size           = _GadgetPtr+4

_G_CurrWin        = 72

; Init the library stuff
; ----------------------
;
; In the Order:
;   + Name of the library
;   + Name of the help file in which are documented all the functions
;   + Name of the 'End Function' automatically called
;   + Version of the library
;   + Priority of the library
;   + Revision of the library (ie: 1.00 here)
;   + Number of functions in this lib. MUST be changed manually at each add.
;

 initlib  "Gadget","Gadget","FreeGadgets",500,1,0

;-------------------------------------------------------------------------------

 name      "FreeGadgets","()"
 flags
 amigalibs _ExecBase,d7
 params
 debugger   0

  MOVEM.l d4/a7/a2/a6,-(a7)       ; Save registers
  MOVE.l  _MemPtr(a5),d0          ; get MemPtr
  BEQ      FGs_End                ; ...

  MOVE.l  _ObjNum(a5),d4          ; get ObjNum
  MOVE.l   d0,a2                  ; ...
  MOVE.l  _GTBase(a5),a6          ; get gtbase

FGs_loop0
  MOVE.l  _FirstGadget(a2),d0     ; ...
  BEQ      FGs_l0                 ; ...

  MOVE.l   d0, a0                 ; arg1.
  JSR     _FreeGadgets(a6)        ; (glist) - a0
  EXG.l    d7,a6                  ; use execbase
  MOVE.l  _MemPool(a2),a0         ; arg1.
  JSR     _DeletePool(a6)         ; (mempool) - a0
  EXG.l    d7,a6                  ; use gtbase

FGs_l0
  LEA      16(a2),a2              ; next one
  DBRA     d4,FGs_loop0           ; ...

  MOVE.l  _VisualInfo(a5),a0      ; arg1.
  JSR     _FreeVisualInfo(a6)     ; (vinfo) - a0
  MOVE.l   a6,a1                  ; arg1.
  MOVE.l   d7,a6                  ; use execbase
  JSR     _CloseLibrary(a6)       ; (*Library) - a1

FGs_End
  MOVEM.l (a7)+,d4/d7/a2/a6       ; Restore registers
  RTS

 endfunc 0

;-------------------------------------------------------------------------------

 name      "InitGadget","(#MaxGadgets)"
 flags      LongResult
 amigalibs _ExecBase,a6, _IntuitionBase,d7
 params     d2_l
 debugger   1,_InitGadget_Check

  MOVE.l   a5,-(a7)               ; Save registers
  ADDQ.l   #4,a5                  ; ...
  MOVEQ    #7,d0                  ; ...
  MOVE.l   d0,(a5)+               ; set ObjNum
  ADDQ.l   #1,d0                  ; fix number
  LSL.l    #4,d0                  ; ...
  PB_AllocMem A0                  ; (size) - d0
  MOVE.l   d0,(a5)+               ; set MemPtr
  BEQ      IG_End                 ; ...

  MOVE.l   d2,d0                  ; ...
  ADDQ.l   #1,d0                  ; ...
  LSL.l    #2,d0                  ; ...
  PB_AllocMem A0                  ; (size) - d0
  MOVE.l   d0,(a5)                ; set MemPtr2
  BEQ      IG_End                 ; ...

  LEA.l   _GadTools_Name(pc),a1   ; Library name
  MOVEQ    #36, d0                ; Version
  JSR     _OpenLibrary(a6)        ; (*Name$, Version) - a1/d0
  MOVE.l   d0,_GTBase-12(a5)      ; set GTBase

IG_End
  MOVEA.l (a7)+,a5                ; Restore registers.
  RTS

_GadTools_Name
  Dc.b "gadtools.library",0,0

 endfunc 1

;-------------------------------------------------------------------------------

 name      "CreateGadgetList","()"
 flags      LongResult
 amigalibs _ExecBase,d7, _IntuitionBase,d6
 params
 debugger   2,_InitCheck

  MOVEM.l  d2-d3/d7/a2/a6,-(a7)   ; Save registers

  MOVE.l  _GListPos(a5),d0        ; loop counter
  MOVE.l   d0,d2                  ; for later use
  SUBQ.l   #1,d0                  ; ...
  MOVE.l  _MemPtr(a5),a2          ; ...

CGL_loop0
  TST.l   _FirstGadget(a2)        ; is glist free
  BEQ      CGL_l0                 ; yep
  LEA      16(a2),a2              ; next one
  DBRA     d0,CGL_loop0           ; loop unilt -1

CGL_l0
  TST.w    d0                     ; out of glists
  BPL      CGL_l2                 ; nope

  LEA     _ObjNum(a5),a2          ; for later use
  ADDQ.l   #1,_GListPos(a5)       ; ...

  CMP.l    (a2),d2                ; time to realloc
  BLT      CGL_l1                 ; nope

  ADDQ.l   #8,(a2)                ; inc objnum
  MOVE.l   (a2)+,d0               ; get objnum
  ADDQ.l   #1,d0                  ; fix number
  MOVE.l   (a2),a0                ; param1
  LSL.l    #4,d0                  ; param2
  PB_ReAllocMem A1                ; (memptr,newsize) - a0/d0
  MOVE.l   d0,(a2)                ; set memptr
  BEQ      CGL_End                ; ...

CGL_l1
  MOVE.l  _MemPtr(a5),a2          ; ...
  LSL.l    #4,d2                  ; ...
  ADD.l    d2,a2                  ; ...

CGL_l2
  MOVE.l  _G_CurrWin(a4),d3       ; get current window
  MOVE.l   d3,_CurrWin(a5)        ; ...
  MOVE.l   a2,_CurrGList(a5)      ; ...

  MOVE.l  _GTBase(a5), a6         ; ...
  TST.l   _VisualInfo(a5)         ; ...
  BNE     _SkipVisualInfo         ; ...
  MOVE.l   d3,a0                  ; ...
  MOVE.l   46(a0), a0             ; arg1.
  SUB.l    a1, a1                 ; arg2.
  JSR     _GetVisualInfoA(a6)     ; (Screen,NULL) - a0/a1
  MOVE.l   d0, _VisualInfo(a5)    ; Set VisualInfo in the newgadget struct
_SkipVisualInfo
  LEA.l   _NewGadget(a5), a0      ; ...
  MOVE.l   a0,a1                  ; ...
  CLR.l    (a1)+                  ; Clear the gadget zone.
  CLR.l    (a1)+                  ; ...
  CLR.l    (a1)+                  ; ...
  CLR.l    (a1)+                  ; ...
  CLR.w    (a1)+                  ; ...
  CLR.l    (a1)                   ; ...
  JSR     _CreateContext(a6)      ; (newgad) - a0
  MOVE.l   d0, (a2)+              ; set FirstGadget
  MOVE.l   d0, (a2)+              ; set LastGadget
  MOVE.l   d3, (a2)+              ; set WindowPtr
  MOVE.l   d7,a6                  ; use execbase
  MOVEQ.l  #0,d0                  ; arg1.
  MOVE.l   #512,d1                ; arg2.
  MOVE.l   d0,d2                  ; arg3.
  JSR     _CreatePool(a6)         ; (flags,puddle,maxpuddle) - d0/d1/d2
  MOVE.l   d0, (a2)               ; set MemPool

  MOVE.l   d0,d7                  ; ...
  MOVE.l   d6,a6                  ; use intuibase

  MOVE.l   d3,a0                  ; arg1.
  MOVE.l  _LastGadget-12(a2),a1   ; arg2.
  MOVEQ    #-1,d0                 ; arg3.
  MOVEQ    #-1,d1                 ; arg4.
  SUB.l    a2,a2                  ; arg5.
  JSR     _AddGList(a6)           ; (win,gad,pos,numgad,req) - a0/a1/d0/d1/a2

  MOVE.l   d7,d0                  ; ...

CGL_End
  MOVEM.l  (a7)+,d2-d3/d7/a2/a6,-(a7)   ; Restore registers
  RTS

 endfunc 2

;-------------------------------------------------------------------------------

 name      "ButtonGadget","(#Gadget,x,y,Width,Height,Text$)"
 flags      LongResult | InLine
 amigalibs
 params     d0_l,d1_w,d2_w,d3_w,d4_w,d5_l
 debugger   3,_ExistCheck

  MOVE.l  d6,-(a7) ; Restored in _B_GTFillStruct
  MOVE.l   #PLACETEXT_IN, _NewGadFlags(a5) ; Set the right flag for a button.
  MOVEQ    #BUTTON_KIND, d6       ;
  I_JSR     _B_GTFillStruct(a5)     ; Use sub routine to fill the structure

 endfunc 3

;-------------------------------------------------------------------------------

 name      "CheckBoxGadget","(#Gadget,x,y,Width,Height,Text$)"
 flags      LongResult | InLine
 amigalibs
 params     d0_l,d1_w,d2_w,d3_w,d4_w,d5_l
 debugger   4,_ExistCheck

  MOVE.l  d6,-(a7) ; restored in _B_GTFillStruct
  MOVE.l   #PLACETEXT_RIGHT, _NewGadFlags(a5) ; Set the right flag for the check box.
  MOVEQ    #CHECKBOX_KIND, d6     ;
  I_JSR     _B_GTFillStruct(a5)     ; Use sub routine to fill the structure

 endfunc 4

;-------------------------------------------------------------------------------

 name      "IntegerGadget","(#Gadget,x,y,Width,Height,Text$,Content)"
 flags      LongResult
 amigalibs
 params     d0_l,d1_w,d2_w,d3_w,d4_w,d5_l,d6_l
 debugger   5,_ExistCheck

  MOVE.l  d6,-(a7)                ; Restored in _B_GTFillStruct
  MOVE.l   #PLACETEXT_LEFT, _NewGadFlags(a5) ;
  LEA      IG_Tags(pc),a0         ;
  MOVE.l   d6, 4(a0)              ; Set the number..
  MOVE.l  _TagList(a5),12(a0)     ; Add the user taglist if any
  MOVE.l   a0,_TagList(a5)        ; We use our own taglist now..
  MOVEQ    #INTEGER_KIND, d6      ;
  JMP     _B_GTFillStruct(a5)     ; Use sub routine to fill the structure

  CNOP 0,4 ; Align

IG_Tags
  Dc.l GTIN_Number, 0
  Dc.l TAG_MORE   , 0
  Dc.l 0,0          

 endfunc 5

;-------------------------------------------------------------------------------

 name      "ListViewGadget","(#Gadget,x,y,Width,Height,Text$,ListBase)"
 flags      LongResult
 amigalibs
 params     d0_l,d1_w,d2_w,d3_w,d4_w,d5_l,d6_l
 debugger   6,_ExistCheck

  MOVE.l  d6,-(a7)                ; Restored in _B_GTFillStruct
  MOVE.l   #PLACETEXT_ABOVE, _NewGadFlags(a5) ;
  LEA.l    ListViewTagList(pc),a0 ;
  MOVE.l   d6, 12(a0)             ; Set the listbase..
  MOVE.l  _TagList(a5),20(a0)     ; Add the user taglist if any
  MOVE.l   a0,_TagList(a5)        ; We use our own taglist now..
  MOVEQ    #LISTVIEW_KIND, d6     ;
  JMP     _B_GTFillStruct(a5)     ; Use sub routine to fill the structure

  CNOP 0,4 ; Align

ListViewTagList
  Dc.l GTLV_ShowSelected, 0
  Dc.l GTLV_Labels      , 0
  Dc.l TAG_MORE         , 0
  Dc.l 0,0

 endfunc 6

;-------------------------------------------------------------------------------

 name      "OptionGadget","(#Gadget,x,y,Width,Height,Labels())"
 flags      LongResult
 amigalibs
 params     d0_l,d1_w,d2_w,d3_w,d4_w,d5_l
 debugger   7,_ExistCheck

  MOVE.l  d6,-(a7)                ; Restored in _B_GTFillStruct
  MOVE.l   #PLACETEXT_RIGHT, _NewGadFlags(a5) ;
  LEA.l    OptionTagList(pc),a0   ;
  MOVE.l   d5,4(a0)               ; Set the labels table..
  MOVE.l  _TagList(a5),12(a0)     ; Add the user taglist if any
  MOVE.l   a0,_TagList(a5)        ; We use our own taglist now.
  MOVEQ    #0,d5                  ;
  MOVEQ    #MX_KIND, d6           ;
  JMP     _B_GTFillStruct(a5)     ; Use sub routine to fill the structure

  CNOP 0,4 ; Align

OptionTagList
  Dc.l GTMX_Labels, 0
  Dc.l TAG_MORE   , 0
  Dc.l 0,0

 endfunc 7

;-------------------------------------------------------------------------------

 name      "NumberGadget","(#Gadget,x,y,Width,Height,Text$,Content)"
 flags      LongResult
 amigalibs
 params     d0_l,d1_w,d2_w,d3_w,d4_w,d5_l,d6_l
 debugger   8,_ExistCheck

  MOVE.l  d6,-(a7)                ; Restored in _B_GTFillStruct
  MOVE.l   #PLACETEXT_LEFT, _NewGadFlags(a5) ;
  LEA      NG_Tags(pc),a0         ;
  MOVE.l   d6,4(a0)               ; Set the number..
  MOVE.l  _TagList(a5),12(a0)     ; Add the user taglist if any
  MOVE.l   a0,_TagList(a5)        ; We use our own taglist now..
  MOVEQ    #NUMBER_KIND, d6       ;
  JMP     _B_GTFillStruct(a5)     ; Use sub routine to fill the structure

  CNOP 0,4 ; Align
NG_Tags
 Dc.l GTNM_Number, 0
 Dc.l TAG_MORE   , 0
 Dc.l 0,0

 endfunc 8

;-------------------------------------------------------------------------------

 name      "CycleGadget","(#Gadget,x,y,Width,Height,Text$,Labels())"
 flags      LongResult
 amigalibs
 params     d0_l,d1_w,d2_w,d3_w,d4_w,d5_l,d6_l
 debugger   9,_ExistCheck

  MOVE.l   d6,-(a7)               ; Restored in _B_GTFillStruct
  MOVE.l   #PLACETEXT_LEFT, _NewGadFlags(a5) ;
  LEA.l    CycleTagList(pc),a0    ;
  MOVE.l   d6, 4(a0)              ; Set the labels table..
  MOVE.l  _TagList(a5),12(a0)     ; Add the user taglist if any
  MOVE.l   a0,_TagList(a5)        ; We use our own taglist now..
  MOVEQ    #CYCLE_KIND, d6        ;
  JMP     _B_GTFillStruct(a5)     ; Use sub routine to fill the structure

  CNOP 0,4 ; Align

CycleTagList
  Dc.l GTCY_Labels, 0
  Dc.l TAG_MORE   , 0
  Dc.l 0,0

 endfunc 9

;-------------------------------------------------------------------------------

 name      "PaletteGadget","(#Gadget,x,y,Width,Height,Text$,Depth)"
 flags      LongResult
 amigalibs
 params     d0_l,d1_w,d2_w,d3_w,d4_w,d5_l,d6_l
 debugger   10,_ExistCheck

  MOVE.l   d6,-(a7)               ; Restored in _B_GTFillStruct
  MOVE.l   #PLACETEXT_ABOVE, _NewGadFlags(a5) ;
  LEA.l    PaletteTagList(pc),a0  ;
  MOVE.l   d6, 4(a0)              ; Set the palette depth..
  MOVE.l   _TagList(a5),12(a0)    ; Add the user taglist if any
  MOVE.l   a0,_TagList(a5)        ; We use our own taglist now..
  MOVEQ    #PALETTE_KIND, d6      ;
  JMP      _B_GTFillStruct(a5)    ; Use sub routine to fill the structure

  CNOP 0,4 ; Align

PaletteTagList
  Dc.l GTPA_Depth, 0
  Dc.l TAG_MORE  , 0
  Dc.l 0,0

 endfunc 10

;-------------------------------------------------------------------------------

 name      "ScrollerGadget","(#Gadget,x,y,Width,Height,Text$,Total,Visible)"
 flags      LongResult
 amigalibs
 params     d0_l,d1_w,d2_w,d3_w,d4_w,d5_l,d6_l,d7_l
 debugger   11,_ExistCheck

  MOVE.l   d6,-(a7)               ; Restored in _B_GTFillStruct
  LEA      Scroller_Tags(pc),a0   ;
  MOVE.l   d6,12(a0)              ; Set the total..
  MOVE.l   d7,20(a0)              ; Set the visible..
  MOVE.l   _TagList(a5),28(a0)    ; Add the user taglist if any
  MOVE.l   a0,_TagList(a5)        ; We use our own taglist now..
  MOVEQ    #SCROLLER_KIND, d6     ;
  JMP      _B_GTFillStruct(a5)    ; Use sub routine to fill the structure

  CNOP 0,4

Scroller_Tags
 Dc.l GA_RelVerify, 1
 Dc.l GTSC_Total  , 0
 Dc.l GTSC_Visible, 0
 Dc.l TAG_MORE    , 0
 Dc.l 0,0

 endfunc 11

;-------------------------------------------------------------------------------

 name      "SliderGadget","(#Gadget,x,y,Width,Height,Text$,Min,Max)"
 flags      LongResult
 amigalibs
 params     d0_l,d1_w,d2_w,d3_w,d4_w,d5_l,d6_l,d7_l
 debugger   12,_ExistCheck

  MOVE.l   d6,-(a7)               ; Restored in _B_GTFillStruct
  LEA      Slider_Tags(pc),a0     ;
  MOVE.l   d6,12(a0)              ; Set the min..
  MOVE.l   d7,20(a0)              ; Set the max..
  MOVE.l   _TagList(a5),28(a0)    ; Add the user taglist if any
  MOVE.l   a0,_TagList(a5)        ; We use our own taglist now..
  MOVEQ    #SLIDER_KIND, d6       ;
  JMP      _B_GTFillStruct(a5)    ; Use sub routine to fill the structure

  CNOP 0,4 ; Align

Slider_Tags
  Dc.l GA_RelVerify, 1
  Dc.l GTSL_Min    , 0
  Dc.l GTSL_Max    , 0
  Dc.l TAG_MORE    , 0
  Dc.l 0,0

 endfunc 12

;-------------------------------------------------------------------------------

 name      "StringGadget","(#Gadget,x,y,Width,Height,Text$,Content$)"
 flags      LongResult
 amigalibs
 params     d0_l,d1_w,d2_w,d3_w,d4_w,d5_l,d6_l
 debugger   13,_ExistCheck

  MOVE.l   d6,-(a7)               ; Restored in _B_GTFillStruct
  MOVE.l   #PLACETEXT_LEFT, _NewGadFlags(a5) ;
  LEA.l    StringTagList(pc),a0   ;
  MOVE.l   d6, 4(a0)              ; Set the string..
  MOVE.l  _TagList(a5),28(a0)     ; Add the user taglist if any
  MOVE.l   a0,_TagList(a5)        ; We use our own taglist now..
  MOVEQ    #STRING_KIND, d6       ;
  JMP     _B_GTFillStruct(a5)     ; Use sub routine to fill the structure

  CNOP 0,4 ; Align

StringTagList
  Dc.l GTST_String  , 0
  Dc.l GTST_MaxChars, 1000
  Dc.l GA_Immediate , 1
  Dc.l TAG_MORE     , 0
  Dc.l 0,0

 endfunc 13

;-------------------------------------------------------------------------------

 name      "TextGadget","(#Gadget,x,y,Width,Height,Text$,Content$)"
 flags      LongResult
 amigalibs
 params     d0_l,d1_w,d2_w,d3_w,d4_w,d5_l,d6_l
 debugger   14,_ExistCheck

  MOVE.l  d6,-(a7)                ; Restored in _B_GTFillStruct
  CLR.l   _NewGadFlags(a5)        ;
  LEA      TG_Tags(pc),a0         ;
  MOVE.l   d6,4(a0)               ; Set the string..
  MOVE.l  _TagList(a5),12(a0)     ; Add the user taglist if any
  MOVE.l   a0,_TagList(a5)        ; We use our own taglist now.
  MOVEQ    #TEXT_KIND, d6         ;
  JMP     _B_GTFillStruct(a5)     ; Use sub routine to fill the structure

  CNOP 0,4 ; Align

TG_Tags
  Dc.l GTTX_Text, 0
  Dc.l TAG_MORE , 0
  Dc.l 0,0

 endfunc 14

;-------------------------------------------------------------------------------

 name      "GadgetBevelBox","(x,y,Width,Height,Style)"
 flags
 amigalibs
 params     d0_w,d1_w,d2_w,d3_w,d6_w
 debugger   15

  MOVEM.l  d7/a6,-(a7)            ; Save registers
  MOVE.l  _G_CurrWin(a4),a0       ; ...
  MOVEQ    #0,d7                  ; ...
  MOVE.b   54(a0),d7              ; get \BorderLeft
  ADD.w    d7,d0                  ; update x
  MOVE.b   55(a0),d7              ; get \BorderTop
  ADD.w    d7,d1                  ; update y\

  LEA     _BevelBoxTags(pc),a1    ; ...
  MOVE.l  _VisualInfo(a5),4(a1)   ; ...
  CLR.l    8(a1)                  ; clr style
  TST.w    d6                     ; what style
  BEQ     _BevelBoxNext           ; ...
  MOVE.l   #GTBB_Recessed,8(a1)   ; set style
  MOVE.w   d6,14(a1)              ; ...

_BevelBoxNext
  MOVE.l   50(a0),a0              ; arg1.
  MOVE.l  _GTBase(a5),a6          ; use gtbase
  JSR     _DrawBevelBoxA(a6)      ; (RastPort,x,y,width,height,TagList) - a0/d0/d1/d2/d3/a1
  MOVEM.l  (a7)+,d7/a6            ; Restore registers
  RTS

  CNOP 0,4 ; Align

_BevelBoxTags
  Dc.l GT_VisualInfo, 0
  Dc.l 0, 0
  Dc.l 0,0

 endfunc 15

;-------------------------------------------------------------------------------

 name      "SetGadgetFont","(FontID)"
 flags
 amigalibs
 params     a0_l
 debugger   16,_InitCheck

  LEA      SGF_TextAttr(pc),a1    ;
  MOVE.l   10(a0),0(a1)           ;
  MOVE.w   20(a0),4(a1)           ;
  MOVE.l   a1,_NewGadFont(a5)     ;
  RTS
 
 CNOP 0,4 ; Align

SGF_TextAttr
 Ds.l 2

 endfunc 16
;-------------------------------------------------------------------------------

 name      "SetGadgetTagList","(TagListID)"
 flags      InLine
 amigalibs
 params     d0_l
 debugger   17

  MOVE.l   d0,_TagList(a5)        ; ...
  I_RTS

 endfunc 17

;-------------------------------------------------------------------------------

 name      "NoGadgetBorder","(#Gadget)"
 flags
 amigalibs
 params     d0_l
 debugger   18,_ExistCheck2

  MOVE.l  _MemPtr2(a5),a0         ; get MemPtr2
  LSL.l    #2,d0                  ; calc offset
  ADD.l    d0,a0                  ; #Gadget
  MOVE.l  _GadgetPtr(a0),a0       ; use GadgetPtr
  CLR.l    18(a0)                 ; GadgetRender
  RTS

 endfunc 18

;-------------------------------------------------------------------------------

 name      "GetGadgetState","(#Gadget)"
 flags      LongResult
 amigalibs
 params     d0_l
 debugger   19,_ExistCheck2

  MOVEM.l  d5-d7/a2-a4/a6,-(a7)            ; ...
  MOVE.l  _MemPtr2(a5),a0         ; get MemPtr2
  LSL.l    #2,d0                  ; calc offset
  ADD.l    d0,a0                  ; #Gadget

  MOVE.l  _GadgetPtr(a0),a0       ; ...
  MOVE.l   a0,d5                  ; ...
  MOVE.l   40(a0),a0              ; use UserData
  MOVE.l  _WindowPtr(a0),d6       ; get WindowPtr
  MOVEQ    #8,d7                  ; loop counter
  LEA      GGS_State(pc),a0       ; ...
  LEA      GGS_Tags+4(pc),a1      ; ...
  MOVE.l   a0,(a1)                ; ...
  CLR.l    (a0)                   ; ...
  SUB.l    a2,a2                  ; arg3.
  LEA      GGS_Tags(pc),a3        ; arg4.
  LEA      GGS_Types(pc),a4       ; ...
  MOVE.l  _GTBase(a5),a6          ; use GTBase

GGS_loop0
  MOVE.l   d5,a0                  ; arg1.
  MOVE.l   d6,a1                  ; arg2.
  MOVE.l   (a4)+,(a3)             ; ...
  JSR     _GT_GetGadgetAttrsA(a6) ; (gad,win,req,tag) - a0/a1/a2/a3
  TST.l    d0                     ; valid gadget
  BNE      GGS_l0                 ; yep
  DBRA     d7,GGS_loop0           ; ...

GGS_l0
  MOVE.l   GGS_State(pc),d0       ; ...

GGS_End
  MOVEM.l  (a7)+,d5-d7/a2-a4/a6   ; ...
  RTS

  CNOP 0,4

GGS_Tags
  Dc.l 0, 0
  Dc.l 0,0

GGS_State: Dc.l 0

GGS_Types
 Dc.l GTCB_Checked, GTCY_Active, GTIN_Number, GTLV_Selected, GTMX_Active
 Dc.l GTNM_Number, GTPA_Color, GTSC_Top, GTSL_Level

 endfunc 19

;-------------------------------------------------------------------------------

 name      "SetGadgetState","(#Gadget,State)"
 flags      LongResult
 amigalibs
 params     d0_l,d4_l
 debugger   20,_ExistCheck2

  MOVEM.l  d5-d7/a2-a4/a6,-(a7)            ; ...
  MOVE.l  _MemPtr2(a5),a0         ; get MemPtr2
  LSL.l    #2,d0                  ; calc offset
  ADD.l    d0,a0                  ; #Gadget

  MOVE.l  _GadgetPtr(a0),a0       ; ...
  MOVE.l   a0,d5                  ; ...
  MOVE.l   40(a0),a0              ; use UserData
  MOVE.l  _WindowPtr(a0),d6       ; get WindowPtr
  MOVEQ    #8,d7                  ; loop counter
  LEA      SGS_State(pc),a0       ; ...
  LEA      SGS_Tags+4(pc),a1      ; ...
  MOVE.l   a0,(a1)                ; ...
  SUB.l    a2,a2                  ; arg3.
  LEA      SGS_Tags(pc),a3        ; arg4.
  LEA      SGS_Types(pc),a4       ; ...
  MOVE.l  _GTBase(a5),a6          ; use GTBase

SGS_loop0
  MOVE.l   d5,a0                  ; arg1.
  MOVE.l   d6,a1                  ; arg2.
  MOVE.l   (a4)+,(a3)             ; ...
  JSR     _GT_GetGadgetAttrsA(a6) ; (gad,win,req,tag) - a0/a1/a2/a3
  TST.l    d0                     ; valid gadget
  BNE      SGS_l0                 ; yep
  DBRA     d7,SGS_loop0           ; ...

  BRA      SGS_End                ; ...

SGS_l0
  MOVE.l   d5,a0                  ; arg1.
  MOVE.l   d6,a1                  ; arg2.
  MOVE.l   d4,4(a3)               ; ...
  JSR     _GT_SetGadgetAttrsA(a6) ; (gad,win,req,tag) - a0/a1/a2/a3
  MOVEQ    #1,d0                  ; ...

SGS_End
  MOVEM.l  (a7)+,d5-d7/a2-a4/a6            ; ...
  RTS

  CNOP 0,4

SGS_Tags
  Dc.l 0, 0
  Dc.l 0,0

SGS_State: Dc.l 0

SGS_Types
 Dc.l GTCB_Checked, GTCY_Active, GTIN_Number, GTLV_Selected, GTMX_Active
 Dc.l GTNM_Number, GTPA_Color, GTSC_Top, GTSL_Level

 endfunc 20

;-------------------------------------------------------------------------------

 name      "GetGadgetText","(#Gadget)"
 flags      StringResult
 amigalibs
 params     d0_l
 debugger   21,_ExistCheck2

  MOVEM.l  d6-d7/a2-a3/a6,-(a7)            ; ...
  MOVE.l  _MemPtr2(a5),a0         ; get MemPtr2
  LSL.l    #2,d0                  ; calc offset
  ADD.l    d0,a0                  ; #Gadget

  MOVE.l  _GadgetPtr(a0),a0       ; ...
  MOVE.l   a0,d6                  ; ...
  MOVE.l   40(a0),a0              ; use UserData
  MOVE.l  _WindowPtr(a0),d7       ; get WindowPtr
  LEA      GGT_String(pc),a0      ; ...
  LEA      GGT_Tags+4(pc),a1      ; ...
  MOVE.l   a0,(a1)                ; ...
  SUB.l    a2,a2                  ; arg3.
  LEA      GGT_Tags(pc),a3        ; arg4.
  MOVE.l  _GTBase(a5),a6          ; use GTBase

  MOVE.l   d6,a0                  ; arg1.
  MOVE.l   d7,a1                  ; arg2.
  MOVE.l   #GTST_String,(a3)      ; ...
  JSR     _GT_GetGadgetAttrsA(a6) ; (gad,win,req,tag) - a0/a1/a2/a3
  TST.l    d0                     ; string gadget
  BNE      GGT_l0                 ; yep

  MOVE.l   d6,a0                  ; arg1.
  MOVE.l   d7,a1                  ; arg2.
  MOVE.l   #GTTX_Text,(a3)        ; ...
  JSR     _GT_GetGadgetAttrsA(a6) ; (gad,win,req,tag) - a0/a1/a2/a3
  TST.l    d0                     ; text gadget
  BEQ      GGT_End                ; nope

GGT_l0
  MOVEM.l  (a7)+,d6-d7/a2-a3/a6            ; ...
  MOVE.l   GGT_String(pc),a0      ; ...

GGT_loop0
  MOVE.b   (a0)+,(a3)+            ; ...
  BNE      GGT_loop0              ; ...
  SUBQ.l   #1,a3                  ; ...
  RTS

GGT_End
  MOVEM.l  (a7)+,d6-d7/a2-a3/a6            ; ...
  CLR.b    (a3)                   ; ...
  RTS

  CNOP 0,4 ; Align

GGT_Tags
  Dc.l 0, 0
  Dc.l 0,0

GGT_String: Dc.l 0

 endfunc 21

;-------------------------------------------------------------------------------

 name      "SetGadgetText","(#Gadget,Text$)"
 flags
 amigalibs
 params     d0_l,d5_l
 debugger   22,_ExistCheck2

  MOVEM.l  d6-d7/a2-a3/a6,-(a7)            ; ...
  MOVE.l  _MemPtr2(a5),a0         ; get MemPtr2
  LSL.l    #2,d0                  ; calc offset
  ADD.l    d0,a0                  ; #Gadget

  MOVE.l  _GadgetPtr(a0),a0       ; ...
  MOVE.l   a0,d6                  ; ...
  MOVE.l   40(a0),a0              ; use UserData
  MOVE.l  _WindowPtr(a0),d7       ; get WindowPtr
  LEA      SGT_String(pc),a0      ; ...
  LEA      SGT_Tags+4(pc),a1      ; ...
  MOVE.l   a0,(a1)                ; ...
  SUB.l    a2,a2                  ; arg3.
  LEA      SGT_Tags(pc),a3        ; arg4.
  MOVE.l  _GTBase(a5),a6          ; use GTBase

  MOVE.l   d6,a0                  ; arg1.
  MOVE.l   d7,a1                  ; arg2.
  MOVE.l   #GTST_String,(a3)      ; ...
  JSR     _GT_GetGadgetAttrsA(a6) ; (gad,win,req,tag) - a0/a1/a2/a3
  TST.l    d0                     ; string gadget
  BNE      SGT_l0                 ; yep

  MOVE.l   d6,a0                  ; arg1.
  MOVE.l   d7,a1                  ; arg2.
  MOVE.l   #GTTX_Text,(a3)        ; ...
  JSR     _GT_GetGadgetAttrsA(a6) ; (gad,win,req,tag) - a0/a1/a2/a3
  TST.l    d0                     ; text gadget
  BEQ      SGT_End                ; nope

SGT_l0
  MOVE.l   d6,a0                  ; arg1.
  MOVE.l   d7,a1                  ; arg2.
  MOVE.l   d5,4(a3)               ; ...
  JSR     _GT_SetGadgetAttrsA(a6) ; (gad,win,req,tag) - a0/a1/a2/a3
  MOVEQ    #1,d0                  ; ...

SGT_End
  MOVEM.l  (a7)+,d6-d7/a2-a3/a6            ; ...
  RTS

  CNOP 0,4

SGT_Tags
  Dc.l 0, 0
  Dc.l 0,0

SGT_String: Dc.l 0

 endfunc 22

;-------------------------------------------------------------------------------

 name      "SetGadgetAttribute","(#Gadget,TagListID)"
 flags
 amigalibs
 params     d0_l,d1_l
 debugger   23,_ExistCheck2

  MOVEM.l a2-a3/a6,-(a7)          ; Save registers
  MOVE.l  _MemPtr2(a5),a0         ; get MemPtr2
  LSL.l    #2,d0                  ; calc offset
  ADD.l    d0,a0                  ; #Gadget

  LEA.l   _AttrsTag+4(pc),a1      ; ...
  MOVE.l   d1,(a1)                ; ...

  MOVE.l  _GadgetPtr(a0),a0       ; arg1.
  MOVE.l   40(a0),a1              ; use UserData
  MOVE.l  _WindowPtr(a1),a1       ; arg2.
  SUB.l    a2, a2                 ; arg3.
  LEA.l   _AttrsTag(pc), a3       ; arg4.
  MOVE.l  _GTBase(a5), a6         ; get GTBase
  JSR     _GT_SetGadgetAttrsA(a6) ; (gad,win,req,tag) - a0/a1/a2/a3
  MOVEM.l (a7)+,a2-a3/a6
  RTS

  CNOP 0,4

_AttrsTag
  Dc.l TAG_MORE, 0
  Dc.l 0

 endfunc 23

;-------------------------------------------------------------------------------

 name      "DisableGadget","(#Gadget,State)"
 flags
 amigalibs
 params     d0_l,d1_w
 debugger   24,_ExistCheck2

  MOVEM.l  a2-a3/a6,-(a7)            ; ...a6 was missing

  MOVE.l  _MemPtr2(a5),a0         ; get MemPtr2
  LSL.l    #2,d0                  ; calc offset
  ADD.l    d0,a0                  ; #Gadget

  LEA.l   _DisableValue(pc),a1    ; Load and set the Tag
  MOVE.w   d1, (a1)               ; ...

  MOVE.l  _GadgetPtr(a0),a0       ; arg1.
  MOVE.l   40(a0),a1              ; use UserData
  MOVE.l  _WindowPtr(a1),a1       ; arg2.
  SUB.l    a2,a2                  ; arg3.
  LEA.l   _DisableTag(pc), a3     ; arg4.
  MOVE.l  _GTBase(a5), a6         ; get GTBase
  JSR     _GT_SetGadgetAttrsA(a6) ; (gad,win,req,tag) - a0/a1/a2/a3
  MOVEM.l  (a7)+,a2-a3/a6            ; ...
  RTS

  CNOP 0,4 ; Align

_DisableTag
  Dc.l GA_Disabled
  Dc.w 0
_DisableValue
  Dc.w 0
  Dc.l 0
                                                                                                                              
 endfunc 24

;-------------------------------------------------------------------------------


 name      "ActivateGadget","(#Gadget)"
 flags
 amigalibs _IntuitionBase,a6
 params     d0_l
 debugger   25,_ExistCheck2

  MOVE.l  a2,-(a7)
  MOVE.l  _MemPtr2(a5),a0         ; get MemPtr2
  LSL.l    #2,d0                  ; calc offset
  ADD.l    d0,a0                  ; #Gadget

  MOVE.l  _GadgetPtr(a0),a0       ; arg1.
  MOVE.l   40(a0),a1              ; use UserData
  MOVE.l  _WindowPtr(a1),a1       ; arg2.
  SUB.l    a2, a2                 ; arg3.
  JSR     _ActivateGadget(a6)     ; (gad,win,req) - a0/a1/a2
  MOVE.l (a7)+,a2                 ; Restore registers
  RTS

 endfunc 25

;-------------------------------------------------------------------------------

 name      "RefreshGadget","(#Gadget)"
 flags
 amigalibs _IntuitionBase,a6
 params     d0_l
 debugger   26,_InitCheck

  MOVEM.l  d7/a2-a3/a6,-(a7)            ; ...

  TST.l    d0                     ; a singel gadget
  BMI      RG_l0                  ; nope

  MOVE.l  _MemPtr2(a5),a0         ; get MemPtr2
  LSL.l    #2,d0                  ; calc offset
  ADD.l    d0,a0                  ; #Gadget

  MOVE.l  _GadgetPtr(a0),a0       ; arg1.
  MOVE.l   40(a0),a1              ; use UserData
  MOVE.l  _WindowPtr(a1),a1       ; arg2.
  SUB.l    a2, a2                 ; arg3.
  MOVEQ    #1, d0                 ; ...
  JSR     _RefreshGList(a6)       ; (gad,win,req,NumGads) - a0/a1/a2/d0

  BRA      RG_End                 ; ...

RG_l0
  MOVE.l  _G_CurrWin(a4),d7       ; get current window
  MOVE.l   d7,a0                  ; ...

  MOVE.l   62(a0),a0              ; arg1.
  MOVE.l   d7,a1                  ; arg2.
  SUB.l    a2,a2                  ; arg3.
  MOVEQ    #-1,d0                 ; arg4.
  JSR     _RefreshGList(a6)       ; (gad,win,req,numgad) - a0/a1/a2/d0

  MOVE.l  _GTBase(a5),a6          ; use gtbase
  MOVE.l   d7,a0                  ; arg1.
  SUB.l    a1,a1                  ; arg2.
  JSR     _GT_RefreshWindow(a6)   ; (win,req) - a0/a1

RG_End
  MOVEM.l  (a7)+,d7/a2-a3/a6      ;
  RTS

 endfunc 26

;-------------------------------------------------------------------------------

 name      "FreeGadget","(#Gadget)"
 flags
 amigalibs _IntuitionBase,a6, _ExecBase,d7
 params     d0_l
 debugger   27,_InitCheck

  MOVEM.l  d2-d4/d7/a2/a6,-(a7)   ; Save registers.
  TST.l    d0                     ; single gadget
  BGE      FG_l3                  ; yep

  MOVE.l   a2,d6                  ; save a2
  MOVE.l  _ObjNum(a5),d0          ; get objnum
  MOVE.l  _G_CurrWin(a4),d2       ; ...
  MOVE.l  _MemPtr(a5),a2          ; get memptr

FG_loop0
  CMP.l   _WindowPtr(a2),d2       ; a legal WindowID
  BEQ      FG_l0                  ; yep
  LEA      16(a2),a2              ; next one
  DBRA     d0,FG_loop0            ; loop until -1

  BRA      FG_End                 ; ...

FG_l0
  MOVEQ    #0,d3                  ; clr flag
  MOVE.l   d2,a0                  ; use WindowID
  MOVE.l   62(a0), a1             ; Get Window\FirstGadget

FG_loop1
  MOVE.l   a1,d0                  ; fast cmp
  BEQ      FG_l2                  ; ...
  MOVE.w   16(a1),d0              ; get \GadgetType
  BTST     #8,d0                  ; its a GadTools gadget..
  BEQ      FG_l1                  ; nope
  MOVE.l   d2,a0                  ; arg1.
  MOVE.l   a1,d4                  ; save gadptr
  JSR     _RemoveGadget(a6)       ; (win,gad) - a0/a1

  ADDQ.l   #1,d3                  ; inc flag
  MOVE.l   d4,a1                  ; restore gadptr

FG_l1
  MOVE.l   (a1),a1                ; Get Gadget\NextGadget
  BRA      FG_loop1               ; ...

FG_l2
  TST.l    d3                     ; any gadget to free
  BEQ      FG_End                 ; nope

  MOVE.l  _GTBase(a5),a6          ; use gtbase

  MOVE.l  _FirstGadget(a2),a0     ; arg1.
  JSR     _FreeGadgets(a6)        ; (glist) - a0
  CLR.l   _FirstGadget(a2)        ; ...
  MOVE.l   d7,a6                  ; use execbase
  MOVE.l  _MemPool(a2),a0         ; arg1.
  JSR     _DeletePool(a6)         ; (mempool) - a0

  BRA      FG_End                 ; ...

FG_l3
  MOVE.l  _MemPtr2(a5),a0         ; ...
  LSL.l    #2,d0                  ; ...
  ADD.l    d0,a0                  ; ...
  MOVE.l  _GadgetPtr(a0),a0       ; ...
  MOVE.l   a0,d7                  ; ...
  MOVE.l   40(a0),a0              ; use UserData

  MOVE.l  _WindowPtr(a0),a0       ; arg1.
  MOVE.l   d7,a1                  ; arg2.
  JSR     _RemoveGadget(a6)       ; (win,gad) - a0/a1

FG_End
  MOVEM.l  (a7)+,d2-d4/d7/a2/a6    ; Restore registers.
  RTS

 endfunc 27

;-------------------------------------------------------------------------------

; name      "GadgetBasePtr","()"
; flags
; amigalibs
; params
; debugger   99
;
;   MOVE.l  a5,d0
;   RTS
;
; endfunc 99



 base
LibBase:
 Dc.l 0                           ; GTBase
 Dc.l 0                           ; ObjNum
 Dc.l 0                           ; MemPtr
 Dc.l 0                           ; MemPtr2
 Dc.l 0                           ; GListPos
 Dc.l 0                           ; CurrGList
 Dc.l 0                           ; CurrWin
 Dc.l 0                           ; TagList

 Dc.l 0,0                         ; NewGadget/x,y,Width,Height
 Dc.l 0                           ; NewGadText
 Dc.l 0                           ; NewGadFont
 Dc.w 0                           ; NewGadgetID
 Dc.l 0                           ; NewGadFlags
 Dc.l 0                           ; NewVisualInfo
 Dc.l 0                           ; NewGadUserData

;---------------------------------
; GTFillStruct(#Gadget)
; Input:  d0,d1,d2,d3,d4,d5,d6
; Output: d0
;---------------------------------

; preserve regs.. org d6 is on stack from calling command.

l_GTFillStruct:
  MOVEM.l  d2/d7/a2-a3/a6,-(a7)            ; ...
  MOVE.l   d0,d7                  ; ...

  MOVE.l  _G_CurrWin(a4),d0       ; get current window
  CMP.l   _CurrWin(a5),d0         ; same as this
  BEQ      GTFS_l1                ; yep

  MOVE.l   d1,-(a7)               ; save d1
  MOVE.l  _GListPos(a5),d1        ; loop counter
  SUBQ.l   #1,d1                  ; ...
  MOVE.l  _MemPtr(a5),a0          ; ...

GTFS_loop0
  CMP.l   _WindowPtr(a0),d0       ; ...
  BEQ      GTFS_l0                ; ...
  LEA      16(a0),a0              ; ...
  DBRA     d1,GTFS_loop0          ; ...

  MOVEQ    #0,d0                  ; ...
  ADDQ.l   #4,a7                  ; restore stack
  BRA      GTFS_End               ; ...

GTFS_l0
  MOVE.l  (a7)+,d1                ; restore d1
  MOVE.l  d0,_CurrWin(a5)         ; ...
  MOVE.l  a0,_CurrGList(a5)       ; ...

GTFS_l1
  MOVE.l   d0,a2                  ; use currwin
  MOVEQ    #0,d0                  ; ...
  MOVE.b   54(a2),d0              ; get \BorderLeft
  ADD.w    d0,d1                  ; update x
  MOVE.b   55(a2),d0              ; get \BorderTop
  ADD.w    d0,d2                  ; update y

  MOVE.l  _CurrGList(a5),a3       ; ...
  LEA.l   _NewGadget(a5),a6       ; ...
  MOVE.w   d1,(a6)+               ; x
  MOVE.w   d2,(a6)+               ; y
  MOVE.w   d3,(a6)+               ; Width
  MOVE.w   d4,(a6)+               ; Height
  MOVE.l   d5,(a6)                ; Set Text..
  BEQ     _SkipAlloc              ; ...

  MOVE.l   d5,a0                  ; param1.
  MOVE.l  _MemPool(a3),a1         ; param2.
  PB_AllocString A2               ; (str,mempool)  - a0/a1
  MOVE.l   d0,(a6)                ; set text

_SkipAlloc
  MOVE.l  _GTBase(a5), a6         ; use GTBase
  MOVE.l   d6, d0                 ; arg1.
  MOVE.l  _LastGadget(a3), a0     ; arg2.
  LEA.l   _NewGadget(a5), a1      ; arg3.
  MOVE.l  _TagList(a5),a2         ; arg4.
  JSR     _CreateGadgetA(a6)      ; (#KIND,*PrevGad,ng,Tag) - d0/a0/a1/a2
  MOVE.l   d0,_LastGadget(a3)     ; ...
  MOVE.l   d0,a0                  ; ...
  MOVE.l   d7,d0                  ; ...
  ADD.w    #60,d7                 ; ...
  MOVE.w   d7,38(a0)              ; set \GadgetID
  MOVE.l   a3,40(a0)              ; set \UserData
  CLR.l   _TagList(a5)            ; ...
  MOVE.l  _MemPtr2(a5),a2         ; ...
  LSL.l    #2,d0                  ; ...
  ADD.l    d0,a2                  ; ...
  MOVE.l   a0,_GadgetPtr(a2)      ; ...
  MOVE.l   a0,d0                  ; ...

GTFS_End
  MOVEM.l  (a7)+,d2/d7/a2-a3/a6            ; ...
  MOVE.l   (a7)+,d6               ; Restore original d6 (from entry to command)
  RTS

  Even

 endlib

;-------------------------------------------------------------------------------

 startdebugger

_InitGadget_Check
  LEA      ObjNum2(pc),a0
  MOVE.l   d2,(a0)
  RTS

_InitCheck
  TST.l   _MemPtr(a5)
  BEQ      Error0
  TST.l   _MemPtr2(a5)
  BEQ      Error0
  RTS

;_MaxiObjCheck
;  CMP.l   _ObjNum(a5),d0
;  BGE      Error1
;  RTS

_ExistCheck
  TST.l   _MemPtr(a5)
  BEQ      Error0
  TST.l   _MemPtr2(a5)
  BEQ      Error0
  LEA      ObjNum2(pc), a0
  CMP.l    (a0), d0
  BGT      Error1
  MOVE.l   d0,-(a7)
  MOVE.l  _MemPtr2(a5), a0
  LSL.l    #2, d0
  ADD.l    d0, a0
  MOVE.l   (a7)+,d0
  TST.l    (a0)
  BNE      Error2
  RTS

_ExistCheck2
  TST.l   _MemPtr(a5)
  BEQ      Error0
  TST.l   _MemPtr2(a5)
  BEQ      Error0
  LEA      ObjNum2(pc), a0
  CMP.l    (a0), d0
  BGT      Error1
  MOVE.l   d0,-(a7)
  MOVE.l  _MemPtr2(a5), a0
  LSL.l    #2, d0
  ADD.l    d0, a0
  MOVE.l   (a7)+,d0
  TST.l    (a0)
  BEQ      Error3
  RTS


ObjNum2: Dc.l 0

Error0: debugerror "Must call InitGadget() first"
Error1: debugerror "#MaxGadgets is reached"
Error2: debugerror "#Gadget is already initialized"
Error3: debugerror "#Gadget is not initialized"

 enddebugger

