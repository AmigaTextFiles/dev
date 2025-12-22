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
; PureBasic 'Palette' library
;
; ToDo: LoadPalette still reads execbase from $4 :(
;
; 19/03/2005
;   -Doobrey-
;     CreatePalette has no error check on AllocVec !!
;
;
; NOTE: MUST BE COMPILED WITH OPTIMIZATION ON !
;
; 27/02/2000
;   Converted to PhxAss
;   Optimized a bit...
;   Added LoadPalette()
;
; 03/08/1999
;   Added debugger support
;
; 14/07/1999
;   FirstVersion
;
;
; To do: Maybe some optimization.
;


 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16

FORM = $464F524D   ; Constants need to handle IFF pictures
ILBM = $494C424D   ;
BMHD = $424D4844   ;
CMAP = $434D4150   ;
BODY = $424F4459   ;

_PalPtr    = 0
_ObjNum    = _PalPtr+4
_MemPtr    = _ObjNum+4
_TaskPtr   = _MemPtr+4
_Quit      = _TaskPtr+4
_FadeState = _Quit+1
_SigNum    = _FadeState+1
_Mask      = _SigNum+2
_Param1    = _Mask+4
_Param2    = _Param1+4
_Param3    = _Param2+4
_Param4    = _Param3+4
_Param5    = _Param4+4
_FadeCode  = _Param5+4

;-- The old way..
;GetPosition     = _FadeCode+4
;GetColComponent = GetPosition+12
;FreePalette     = GetColComponent+16

; Le nouveau funky poulet.
GetPosition     = l_GetPosition - LibBase
GetColComponent = l_GetColComponent-LibBase
FreePalette     = l_FreePalette-LibBase

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

 initlib "Palette", "Palette", "FreePalettes", 0, 1, 0

;
; Now do the functions...
;
;------------------------------------------------------------------------------------------
 name      "InitPalette", "(#MaxPalettes)"
 flags      LongResult
 amigalibs _ExecBase,a6, _GraphicsBase, d7
 params     d0_l
 debugger   1

  MOVEM.l  d2-d3/a2-a3,-(a7)         ; ...

  ADDQ.l   #1, d0              ; Needed to have the correct number
  MOVE.l   d0, _ObjNum(a5)     ; Set the Objects Numbers
  LSL.l    #2, d0              ; d0*4
  MOVE.l   d0,d2               ; ...
  ADD.l    #476,d0             ; TCB & Stack size
  MOVE.l   #MEMF_CLEAR, d1     ; Fill memory of '0'
  JSR     _AllocVec(a6)        ; (d0,d1)

  MOVE.l   d0, _MemPtr(a5)     ; Set *MemPtr
  BEQ      IP_End              ; ...

  ADD.l    d0,d2               ; calc ptr to TCB
  LEA      base1(pc),a0        ; ...
  MOVEM.l  d7/a5-a6,(a0)       ; set base1/2/3
  LEA      12(a0),a0           ; ...
  MOVE.l   d2,a1               ; ...
  MOVE.b   #1,8(a1)            ; set \Type (NT_TASK)
  MOVE.l   a0,10(a1)           ; set \Name

  MOVEQ    #92,d1              ; size of TCB
  ADD.l    d1,d2               ; calc ptr to Stack
  MOVE.l   d2,d3               ; ...
  ADD.w    #291,d1             ; ...
  ADD.l    d1,d2               ; ...
  MOVE.l   a1,d1               ; ...
  LEA      54(a1),a1           ; -> \SPReg
  MOVE.l   d2,(a1)+            ; set \SPReg
  MOVE.l   d3,(a1)+            ; set \SPLower
  MOVE.l   d2,(a1)             ; set \SPUpper

  MOVE.l   d1,a1               ; arg1.
  LEA      TaskCode(pc),a2     ; arg2.
  LEA      TaskQuit(pc),a3     ; arg3.
  JSR     _AddTask(a6)         ; (task,taskcode,quitcode) - a1/a2/a3

  MOVE.l   d0, _TaskPtr(a5)    ; set taskptr
  BEQ      IP_End              ; ...

  MOVE.l   d0,d2               ; ...
  EXG.l  d7,a6      ;a6=gfxbase d7=execbase

IP_loop0
  JSR     _WaitTOF(a6)         ; ()
  TST.l   _Mask(a5)            ; is mask set
  BEQ      IP_loop0            ; nope

  EXG.l  d7,a6           ; a6=execbase, d7=gfxbase

  MOVE.l   d2,d0               ; ...

IP_End
  MOVEM.l  (a7)+,d2-d3/a2-a3         ; ...
  RTS

 CNOP 0,4  ; Align code

TaskCode:
 MOVE.l  base3(pc),a6          ; use ExecBase
 MOVEQ   #-1,d0                ; arg1.
 JSR    _AllocSignal(a6)       ; (signum) - d0
 EXT.w   d0                    ; ...

 MOVEQ   #1,d1                 ; ...
 LSL.l   d0,d1                 ; ...
 MOVE.l  base2(pc),a5          ; get palbase
 MOVE.w  d0, _SigNum(a5)       ; set signum
 MOVE.l  d1, _Mask(a5)         ; set mask

TaskCode_l0
 MOVE.l  base3(pc),a6          ; use ExecBase
 MOVE.l _Mask(a5),d0           ; get mask
 JSR    _Wait(a6)              ; (sigmask) - d0

TaskCode_loop0
 TST.b  _Quit(a5)              ; is quit set
 BNE     TaskCode_End          ; yep

 MOVE.l _FadeCode(a5),a4       ; use fadecode ptr
 MOVE.l  base1(pc),a6          ; use GfxBase
 JSR     (a4)                  ; call the fade

 BRA     TaskCode_l0           ; ...

TaskCode_End
 RTS

TaskQuit:
 MOVE.l  base3(pc),a6          ; use ExecBase
 MOVE.w _SigNum(a5),d0         ; arg1.
 JSR    _FreeSignal(a6)        ; (signum) - d0

 CLR.b  _Quit(a5)              ; clr quit

 SUB.l   a1,a1                 ; arg1.
 JMP    _RemTask(a6)           ; (task) - a1

 CNOP 0,4 ; Align data

base1:    Dc.l 0
base2:    Dc.l 0
base3:    Dc.l 0
TaskName: Dc.b "PureBasic Palette Fade.",0

 endfunc   1
;------------------------------------------------------------------------------------------

 name      "FreePalettes", "()"
 flags  NoResult
 amigalibs _ExecBase,a6, _GraphicsBase,d7
 params
 debugger   2

  MOVE.b   #1, _Quit(a5)       ; set quit
  MOVE.l  _TaskPtr(a5),a1      ; arg1.
  MOVE.l  _Mask(a5),d0         ; arg2.
  JSR     _Signal(a6)          ; (task,sigmask) - a1/d0

  EXG.l    d7,a6               ; use GfxBase

FPs_loop0
  JSR     _WaitTOF(a6)         ; ()
  TST.b   _Quit(a5)            ; is quit set
  BNE      FPs_loop0           ; yep

  EXG.l    d7,a6       ; Preserve the blooming registers..
  MOVE.l   d4,-(a7)
  MOVE.l  _ObjNum(a5), d4      ; Num Objects
  BNE     _LoopFreePalettes    ; ...
  MOVE.l  (a7)+,d4
  RTS

_LoopFreePalettes:             ; Close all the opened palette
  SUBQ     #1, d4              ; ...
  MOVE.l   d4, d0              ; ...
  JSR      FreePalette(a5)     ; ...
  TST.l    d4                  ; ...
  BNE     _LoopFreePalettes    ; Repeat:Until d4 = d0

  MOVEA.l _MemPtr(a5), a1      ;
  MOVE.l   (a7)+,d4
  JMP     _FreeVec(a6)         ; (a1)

 endfunc   2

;------------------------------------------------------------------------------------------

 name      "FreePalette", "(#Palette)"
 flags  NoResult | InLine
 amigalibs _ExecBase,  a6
 params
 debugger   3, _ExistCheck

  I_JSR       FreePalette(a5)

 endfunc    3

;------------------------------------------------------------------------------------------

 name      "UsePalette", "(#Palette)"
 flags      NoResult
 amigalibs
 params     d0_l
 debugger   4, _ExistCheck

  MOVEA.l  _MemPtr(a5), a0      ; Inlined GetPosition() - No need to save arguments
  LSL.l     #2, d0              ; a2/a3 on the Stack. No jump needed. FASTER :*)
  ADD.l     d0, a0              ;
  MOVE.l    (a0), d0            ;
  BEQ      _EndUsePalette       ;
  MOVE.l    d0, _PalPtr(a5)     ; *Palette
_EndUsePalette:
  RTS

 endfunc    4

;------------------------------------------------------------------------------------------
 name      "FadeOut", "(#Palette, ScreenID, Step, NbLoop)"
 flags
 amigalibs _GraphicsBase,  a6
 params     d0_l,  a0_l,  d1_l,  d2_l
 debugger   5, _ExistCheck

  MOVEM.l  d2-d7/a2-a3,-(a7)
  JSR      GetPosition(a5)
  MOVE.l   a0, a3        ; Get ViewPort
  ADD.w    #44, a3       ;
  MOVE.l   a1, a2        ; Get Palette object pointer..
  MOVE.w   d2, d3        ; NbLoop
  MOVE.w   d1, d2        ; Step

  MOVE.w   (a2), d6      ; Get NbColors...
  MULU     #3, d6        ;

  MOVEQ.l  #4, d7        ; We CACHE the #4 value in d7 for
                         ; some extra speed (not a lot but...)
  MOVEQ.l  #0,d5
_MainLoop:
  MOVE.l   a2, a1
  ADD.w    d7, a1
  MOVE.w   d6, d4
_LoopFadeOut2:
  MOVE.b   (a1), d5
  BEQ     _SkipColor
  SUB.w    d2, d5
  BGT     _SkipColor
  MOVEQ    #0,d5
_SkipColor:
  MOVE.b   d5, (a1)
  ADD      d7, a1
  DBF      d4, _LoopFadeOut2

  MOVE.l   a3, a0
  MOVE.l   a2, a1
  JSR     _LoadRGB32(a6)
  JSR     _WaitTOF(a6)

  DBF      d3, _MainLoop
  MOVEM.l  (a7)+,d2-d7/a2-a3
  RTS

 endfunc   5

;------------------------------------------------------------------------------------------

 name      "ScreenRGB", "(ScreenID(), ColorIndex, R, G, B)"
 flags
 amigalibs _GraphicsBase,  a6
 params     a0_l,  d0_w,  d1_b,  d2_b,  d3_b
 debugger   6

  ADD.w    #44, a0
  LEA.l   _RgbBuf(pc), a1
  MOVE.w   d0,  2(a1)
  MOVE.b   d1,  4(a1)
  MOVE.b   d2,  8(a1)
  MOVE.b   d3, 12(a1)
  JMP     _LoadRGB32(a6)
 
  CNOP 0,4 ; Align

_RgbBuf:
  Dc.w 1, 0
  Dc.l $00ffffff
  Dc.l $00ffffff
  Dc.l $00ffffff
  Dc.l 0

 endfunc   6

;------------------------------------------------------------------------------------------

 name      "CreatePalette", "(#Palette, NbColors)"
 flags  LongResult
 amigalibs _ExecBase,  a6
 params     d0_l,  d1_w
 debugger   7, _MaxiCheck

  MOVEM.l  d4-d5/a2-a3,-(a7)
  JSR      GetPosition(a5)
  MOVE.w   d1, d0
  MOVE.w   d0, d4           ; Save this number
  MULU     #12,d0
  MOVE.w   d0, d5
  ADDQ     #8, d0
  MOVE.l   #MEMF_CLEAR, d1
  JSR     _AllocVec(a6)
  MOVE.l   d0, (a3)
  BEQ   _EndCreatePalette

  MOVE.l   d0, a0
  MOVE.w   d4, (a0)+
  ADD.w    #2, a0
_FillMem:
  SUBQ.l   #4, d5
  MOVE.l   #$00ffffff, (a0)+
  TST.w    d5
  BNE     _FillMem
  MOVE.l   d0, _PalPtr(a5)

_EndCreatePalette:
  MOVEM.l  (a7)+,d4-d5/a2-a3
  RTS

 endfunc   7

;------------------------------------------------------------------------------------------

 name      "GetScreenPalette", "(#Palette, ScreenID())"
 flags  LongResult
 amigalibs _GraphicsBase,  d2,  _ExecBase,  a6
 params     d0_l,  a0_l
 debugger   8, _MaxiCheck

  MOVEM.l  d4/a2-a3,-(a7)
  JSR      GetPosition(a5)
  MOVE.l   a0, a2
  MOVE.b   189(a2), d1      ; Get Screen Depth
  MOVEQ    #1, d0           ;
  LSL.w    d1, d0           ; Get Real Colour Number
  MOVE.l   d0, d4           ; Save this number
  MULU     #12, d0
  ADDQ     #8, d0
  MOVE.l   #MEMF_CLEAR, d1
  JSR     _AllocVec(a6)
  MOVE.l   48(a2), a0       ; Get Screen\ColorMap address
  MOVE.l   d0, a1
  MOVE.w   d4, (a1)
  ADD.w    #4, a1
  MOVE.l   d0, a2
  MOVE.l   d0, (a3)
  EXG.l    d2,a6
  MOVEQ    #0, d0
  MOVE.l   d4, d1
  JSR     _GetRGB32(a6) ; - a0,d0,d1,a1
  EXG.l d2,a6

  MOVE.l   a2, d0
  MOVE.l   d0, _PalPtr(a5)
  MOVEM.l  (a7)+,d4/a2-a3
  RTS

 endfunc   8

;------------------------------------------------------------------------------------------

 name      "ScreenRed", "(ColourIndex)"
 flags      InLine
 amigalibs
 params     d0_w
 debugger   9, _CurrentCheck

._Red:
  MOVEQ     #4, d1
  I_JSR       GetColComponent(a5)    ; RTS is automagically done

 endfunc    9

;------------------------------------------------------------------------------------------

 name      "ScreenGreen", "(ColourIndex)"
 flags      InLine
 amigalibs
 params     d0_w
 debugger   10, _CurrentCheck

._Green:
  MOVEQ     #8, d1
  I_JSR       GetColComponent(a5)    ; RTS is automagically done

 endfunc    10

;------------------------------------------------------------------------------------------

 name      "ScreenBlue", "(ColourIndex)"
 flags      InLine
 amigalibs
 params     d0_w
 debugger   11, _CurrentCheck

._Blue:
  MOVEQ     #12, d1
  I_JSR       GetColComponent(a5)    ; RTS is automagically done

 endfunc    11

;------------------------------------------------------------------------------------------

 name      "DisplayPalette", "(#Palette, ScreenID())"
 flags
 amigalibs _GraphicsBase,  a6
 params     d0_l,  a0_l
 debugger   12, _ExistCheck

  MOVEA.l  _MemPtr(a5), a1    ; Inlined Function for Speed (loss 2 bytes for exec size... :*)
  LSL.l     #2, d0            ;
  ADD.l     d0, a1            ;
  MOVE.l    (a1), a1          ;
  ADD.w     #44, a0           ; Get ViewPort Addr...
  JMP      _LoadRGB32(a6)     ; (*ViewPort, *ColorMap) - a0/a1

 endfunc    12

;------------------------------------------------------------------------------------------

 name      "PaletteRgb", "(ColorIndex, R, G, B)"
 flags
 amigalibs
 params     d0_l,  d1_w,  d2_w,  d3_w
 debugger   13, _CurrentCheck

  MOVE.l   _PalPtr(a5), a0
  MULU      #12, d0
  ADD.w     d0, a0
  MOVE.b    d1,  4(a0)
  MOVE.b    d2,  8(a0)
  MOVE.b    d3, 12(a0)
  RTS

 endfunc    13

;------------------------------------------------------------------------------------------

 name      "GetPicturePalette", "(#Palette, PictureID())"
 flags
 amigalibs _ExecBase,  a6
 params     d0_l,  d1_l
 debugger   14, _MaxiCheck

  MOVEM.l  d2-d7/a2-a3,-(a7)
  MOVE.l   d0, d2
  MOVE.l   d1, d0
  MOVE.l   #CMAP, d1
  BSR     _GetIFFChunk
  TST.l    d0
  BEQ     _NGPP_End

  MOVE.l   (a0)+, d0  ; Get the size of the CHUNK (look the GetIFFChunk function..)
  DIVU     #3, d0

  MOVE.l   a0, a2     ; Preserve the register

  MOVE.l   d0, d7

  MOVE.l   d2, d0     ; Number palette
  MOVE.l   d7, d1     ; Number of colour
  MOVE.l   a6, d2     ; Pass the Exec ptr

;
; Here is 'CreatePalette()' -> Not optimized :-(
;
  MOVEM.l  a2-a3,-(a7)
  JSR      GetPosition(a5)
  MOVE.w   d1, d0
  MOVE.w   d0, d4           ; Save this number
  MULU     #12,d0
  MOVE.w   d0, d5
  ADDQ     #8, d0
  MOVE.l   #MEMF_CLEAR, d1
  JSR     _AllocVec(a6)
  MOVE.l   d0, (a3)
  MOVE.l   d0, a0
  MOVE.w   d4, (a0)+
  ADD.w    #2, a0
_FillMem2:
  SUBQ.l   #4, d5
  MOVE.l   #$00ffffff, (a0)+
  TST.w    d5
  BNE     _FillMem2
  MOVE.l   d0, _PalPtr(a5)

  MOVEM.l  (a7)+,a2-a3
; End 'CreatePalette()'

  TST      d0
  BEQ     _NGPP_End

  MOVE.l   d0, a0

  MULU     #3, d7
  SUBQ     #1, d7

  ADD.w    #4, a0 ; Skip the first 4 bytes which contain colour info (NbColour)
_CopyPal:
  MOVE.b   (a2)+, (a0)
  ADD.w    #4, a0
  DBF      d7, _CopyPal

_NGPP_End:
  MOVEM.l  (a7)+,d2-d7/a2-a3
  RTS


; Flush d0/d1-a0/a1
;
_GetIFFChunk:
  MOVE.l   d2,-(a7)
  MOVE.l   d0, a0
  MOVE.l   d0, a1
  MOVE.l   4(a0), d0  ; Get length of IFF file
  ADD.l    d0, a1     ; Add it to the addr, to have the max addr to not overtake

  ADD.w    #12, a0    ; Position on the first chunk

_LoopGetChunk:
  MOVE.l   (a0)+, d0  ; Get the Chunk value

  CMP.l    d0, d1     ; If the chunkID is found, cool.
  BEQ     _ChunkFound ;
                      ;
  MOVE.l   (a0)+, d0
  MOVE.l   d0, d2
  ANDI.w   #%00000001, d2 ; Check if the Width is EVEN
  TST.w    d2
  BEQ     _OkChunkSize
  ADDQ.l   #1,d0          ; Make it EVEN
_OkChunkSize:

  ADD.l    d0, a0        ; Else, ADD the chunk size To the Addr
  CMP.l    a0, a1        ; Check if the EOF is reached
  BLE     _ChunkNotFound ;
  BRA     _LoopGetChunk  ;

_ChunkFound:
  MOVE.l   a0, d0
  ADDQ.l   #4, d0       ; To skip the chunk size
  BRA     _GetIFFChunkEnd

_ChunkNotFound:
  MOVEQ    #0,d0

_GetIFFChunkEnd:

  MOVE.l   (a7)+,d2
  RTS

 endfunc   14
;------------------------------------------------------------------------------------------

 name      "Fade", "(#Palette1, #Palette2, ScreenID(), Step, NbLoop)"
 flags  NoResult
 amigalibs  _GraphicsBase,  a6
 params     d0_l,  d1_l,  a0_l,  d2_w,  d3_w
 debugger   15, _ExistCheck

; Notes:
;
; Rate in 'd3'
; Step in 'd2'
;
  MOVEM.l  d4-d7/a2-a3/a5,-(a7)
  JSR      GetPosition(a5)
  MOVE.l   a1, a2
  MOVE.l   d1, d0
  JSR      GetPosition(a5)
  MOVE.l   a1, a5
  MOVE.l   a0, a3        ; Store Screen ViewPort in 'a3'
  ADD.w    #44, a3       ;
  MOVE.w   (a2), d6      ; Get NbColors palette 1...
  MOVE.w   (a5), d5      ; Get NbColors palette 2...
  CMP.w    d6,d5         ;
  ;BCS     _SkipNbColour  ; Get the less of colours...
  ;MOVE.w   d5,d6         ;
  BNE _NNNEnd_
_SkipNbColour:
  MULU.w   #3, d6        ;
  MOVEQ    #0, d5        ; Needed because if > 255, you can't
  MOVEQ    #4, d7        ; We CACHE the #4 value in d7 for
  ADD.w    d7, a5        ; Maximum speed later...
  JSR     _WaitTOF(a6)
_NFI_MainLoop:
  MOVE.l   a2, a1
  ADD.w    d7, a1        ; Use our cache to add #4
  MOVE.l   a5, a0
  MOVE.w   d6, d4
  MOVEQ    #0,d0         ; Need for sign checking
_NFI_Loop2:
  MOVE.b   (a1), d5  ; Get Palette 1 colour
  MOVE.b   (a0), d0  ; Get Palette 2 colour
  CMP.b    d5, d0        ;
  BEQ     _NFI_SkipColor
  BCS     _NFI_Decrease  ; Unsigned d0 < d5
  ADD.w    d2, d5
  CMP.w    d5, d0        ; Unsigned d0 >= d5
  BCC     _NFI_SkipColor ;
  MOVE.b   d0, d5        ; Limit the Palette index to the upper value
  BRA     _NFI_SkipColor
_NFI_Decrease
  SUB.w    d2, d5
  CMP.w    d5, d0        ; Unsigned Lower or Same
  BLE     _NFI_SkipColor ;
  MOVE.w   d0, d5        ; Limit the Palette index to the upper value
_NFI_SkipColor:
  MOVE.b   d5, (a1)
  ADD.w    d7, a0        ; Use our cache to add #4
  ADD.w    d7, a1        ; Use our cache to add #4
  DBF      d4, _NFI_Loop2
  MOVE.l   a3, a0
  MOVE.l   a2, a1
  JSR     _LoadRGB32(a6)
  JSR     _WaitTOF(a6)
  DBF      d3, _NFI_MainLoop
_NNNEnd_
  MOVEM.l  (a7)+,d4-d7/a2-a3/a5
  RTS

 endfunc    15

;------------------------------------------------------------------------------------------

 name      "NbColour", "()"
 flags  LongResult
 amigalibs
 params
 debugger   16, _CurrentCheck

  MOVEA.l  _PalPtr(a5), a0
  MOVEQ.l   #0,d0
  MOVE.w    (a0), d0       ; Get NbColors...
  I_RTS

 endfunc    16
;------------------------------------------------------------------------------------------

 name      "ASyncFadeOut", "(#Palette, ScreenID, Step, NbLoop)"
 flags
 amigalibs _ExecBase,a6
 params     d0_l,a0_l,d1_l,d2_l
 debugger   17

  
  ;--MOVEM.l  d2-d5/a2-a4,-(a7)

  MOVE.b   #1, _FadeState(a5)     ;

  MOVEM.l  d0-d2/a0, _Param1(a5)  ; pass param1/2/3/4
  LEA      FadeCode1(pc),a0       ; ...
  MOVE.l   a0, _FadeCode(a5)      ; ...

  MOVE.l  _TaskPtr(a5),a1         ; arg1.
  MOVE.l  _Mask(a5),d0            ; arg2.
  JMP     _Signal(a6)             ; (task,sigmask) - a1/d0

  CNOP 0,4

FadeCode1:
  MOVEM.l _Param1(a5),d0/d2/d7/a2 ; get param1/2/3/4

  MOVEA.l _MemPtr(a5), a3  ; ...
  LSL.l    #2, d0          ; ...
  ADD.l    d0, a3          ; ...
  MOVE.l   (a3), a3        ; ...

  MOVEQ    #0,d0           ;
  MOVE.w   (a3), d3        ; Get NbColors...
  MULU     #3, d3          ; ...
  MOVEQ    #4,d4           ; ...
  ADD.w    #44, a2         ; -> \ViewPort
  MOVE.l   a3,a4           ; ...
  ADD.l    d4,a4           ; ...

FC1_loop0
  TST.b   _Quit(a5)        ; is quit set
  BNE      FC1_End         ; yep

  MOVE.w   d3,d5         ;
  MOVE.l   a4,a0         ;

FC1_loop1
  MOVE.b   (a0), d0      ;
  BEQ      FC1_l0        ;
  SUB.w    d2,d0         ;
  BGT      FC1_l0        ;
  MOVEQ    #0,d0         ;

FC1_l0
  MOVE.b   d0,(a0)       ;
  ADD.l    d4,a0         ;
  DBF      d5,FC1_loop1  ;

  MOVE.l   a2,a0         ; arg1.
  MOVE.l   a3,a1         ; arg2.
  JSR     _LoadRGB32(a6) ; (viewport,table) - a0/a1
  JSR     _WaitTOF(a6)   ; ()

  DBF      d7,FC1_loop0  ; ...

FC1_End
  CLR.b   _FadeState(a5) ; ...
  ;--MOVEM.l (a7)+,d2-d5/a2-a4
  RTS

 endfunc   17
;------------------------------------------------------------------------------------------

 name      "ASyncFade", "(#Palette, #Palette, ScreenID, Step, NbLoop)"
 flags
 amigalibs _ExecBase,a6
 params     d0_l,d1_l,a0_l,d2_l,d3_l
 debugger   99

  ;--MOVEM.l  d3-d7/a2-a4,-(a7)

  MOVE.b   #1, _FadeState(a5)     ;

  MOVEM.l  d0-d3/a0, _Param1(a5)  ; pass param1/2/3/4/5
  LEA      FadeCode2(pc),a0       ; ...
  MOVE.l   a0, _FadeCode(a5)      ; ...

  MOVE.l  _TaskPtr(a5),a1         ; arg1.
  MOVE.l  _Mask(a5),d0            ; arg2.
  JMP     _Signal(a6)             ; (task,sigmask) - a1/d0

  CNOP 0,4

FadeCode2:
  MOVEM.l _Param1(a5),d0-d2/d7/a2 ; get param1/2/3/4/5

  MOVEA.l _MemPtr(a5), a3  ; ...
  MOVE.l   a3,a4           ; ...
  LSL.l    #2, d0          ; ...
  ADD.l    d0, a3          ; ...
  MOVE.l   (a3), a3        ; ...
  LSL.l    #2, d1          ; ...
  ADD.l    d1, a4          ; ...
  MOVE.l   (a4), a4        ; ...

  ADD.w    #44, a2         ; -> \ViewPort
  MOVE.w   (a3), d3        ; Get NbColors palette 1...
  CMP.w    (a4),d3         ; Get NbColors palette 2...
  BNE      FC2_End         ; ...

  MOVEQ    #0,d0           ; ...
  MULU.w   #3, d3          ; ...
  MOVE.l   a3, d4          ; ...
  MOVEQ    #4, d5          ; ...
  ADDQ.l   #4, a3          ; ...
  ADDQ.l   #4, a4          ; Maximum speed later...

FC2_loop0
  TST.b   _Quit(a5)        ; is quit set
  BNE      FC2_End         ; yep

  MOVEQ    #0,d1           ; Need for sign checking
  MOVE.w   d3, d6          ; ...
  MOVE.l   a3, a0          ; ...
  MOVE.l   a4, a1          ; ...

FC2_loop1
  MOVE.b   (a0), d0        ; Get Palette 1 colour
  MOVE.b   (a1), d1        ; Get Palette 2 colour
  CMP.b    d0, d1          ; ...
  BEQ      FC2_l1          ; ...
  BCS      FC2_l0          ; Unsigned d0 < d5
  ADD.w    d2, d0          ; ...
  CMP.w    d0, d1          ; Unsigned d0 >= d5
  BCC      FC2_l1          ; ...
  MOVE.b   d1, d0          ; Limit the Palette index to the upper value
  BRA      FC2_l1          ;

FC2_l0
  SUB.w    d2, d0          ; ...
  CMP.w    d0, d1          ; Unsigned Lower or Same
  BLE      FC2_l1          ; ...
  MOVE.w   d1, d0          ; Limit the Palette index to the upper value

FC2_l1
  MOVE.b   d0, (a0)        ; ...
  ADD.l    d5, a0          ; Use our cache to add #4
  ADD.l    d5, a1          ; Use our cache to add #4
  DBF      d6, FC2_loop1   ; ...

  MOVE.l   a2, a0          ; arg1.
  MOVE.l   d4, a1          ; arg2.
  JSR     _LoadRGB32(a6)   ; (viewport,table) - a0/a1
  JSR     _WaitTOF(a6)     ; ()

  DBF      d7, FC2_loop0   ; ...

FC2_End
  CLR.b   _FadeState(a5)   ; ...
  ;--MOVEM.l  (a7)+,d3-d7/a2-a4
  RTS

 endfunc 99

;------------------------------------------------------------------------------------------

 name      "ASyncFadeStatus", "()"
 flags  LongResult | InLine
 amigalibs
 params
 debugger   18

  MOVEQ    #0,d0
  MOVE.b  _FadeState(a5), d0
  I_RTS

 endfunc    18
;------------------------------------------------------------------------------------------

 name      "LoadPalette", "(#Palette, FileName$)"
 flags      LongResult
 amigalibs _DosBase,  d3, _ExecBase, a6
 params     d0_l,  d1_l
 debugger   19, _MaxiCheck

  MOVEM.l  d2-d7/a2-a3,-(a7)

  MOVE.l   d1, d4
  JSR      GetPosition(a5)  ; a3 will store the palette pointer...

  MOVE.l   #5000, d0
  MOVE.l   #MEMF_CLEAR, d1
  JSR     _AllocVec(a6)
  MOVE.l   d0, d6

  MOVE.l   d3, a6
  MOVE.l   d4, d1
  MOVE.l   #1005, d2  ; Mode Read
  JSR     _Open(a6)   ; (FileName$, Mode) - d1/d2
  TST.l    d0         ;
  BEQ     _Error1_LoadPalette   ; File not found
  MOVE.l   d0, d5     ; Store the file ptr in 'd5'

  MOVE.l   d5, d1         ; Read the Header of the file...
  MOVE.l   d6, d2         ; into our buffer
  MOVE.l   #5000, d3      ;
  JSR     _Read(a6)       ; (*File, *Buffer, Size) - d1,d2,d3

  MOVE.l   d5, d1    ; Close the file
  JSR     _Close(a6) ; d1

  MOVE.l   d6, a0
  MOVE.l   (a0), d0     ; Should be #FORM
  CMP.l    #FORM, d0    ; Do the comparaison to be sure...
  BNE     _Error2_LoadPalette

  MOVE.l   d0, d2
  MOVE.l   d6, d0
  MOVE.l   #CMAP, d1
  BSR     _GetIFFChunk2
  TST.l    d0
  BEQ     _Error3_LoadPalette

  MOVE.l   (a0)+, d7  ; Get the Chunk Size
  MOVE.l   d7, d1     ;
  DIVU     #3, d1     ; Get the real number of colour
  MOVE.l   a0, a2     ; Preserve the register
  MOVE.l   d2, d0     ; #Palette
;
; Here is 'CreatePalette()'
;
  MOVE.l   $4, a6
  MOVE.w   d1, d0           ; Number of Colours
  MOVE.w   d1, d4           ; Save this number
  MULU     #12,d0           ; 12 bytes for each colours ! (R,G,B 4 bytes each... Yes ! 32 bit for each component ! 96 bit Palet
;:))
  MOVE.l   d0, d5
  ADDQ.l   #8, d0           ; To handle the header/queue
  MOVE.l   #MEMF_CLEAR, d1
  JSR     _AllocVec(a6)
  TST.l    d0               ; If we can't allocate the needed memory, just quit...
  BEQ     _End_LoadPalette  ;
  MOVE.l   d0, (a3)         ; Our new palette
  MOVE.l   d0, _PalPtr(a5)
  MOVE.l   d0, a0
  MOVE.w   d4, (a0)         ; Set the number of colours of this palette
  ADDQ.w   #4, a0
_FillMem_LoadPalette:          ;
  MOVE.l   #$00ffffff, (a0)+   ; Fill the memory area with $00ffffff (Full blank palette)
  SUBQ.l   #4, d5              ;
  BNE     _FillMem_LoadPalette ;
;
; End 'CreatePalette()'
;
  MOVE.l   d0, a0  ; Start of the *Palette
  ADDQ.w   #4, a0  ; Skip the first 4 bytes which contain colour info (NbColour)
  SUBQ.l   #1, d7  ; NumberOfColours-1
_Copy_LoadPalette:
  MOVE.b   (a2)+, (a0)
  ADDQ.w   #4, a0
  DBF      d7, _Copy_LoadPalette
  BRA     _End_LoadPalette

_Error1_LoadPalette:
  MOVEQ.l  #-1, d0
  BRA     _End_LoadPalette

_Error2_LoadPalette:
  MOVEQ.l  #-2, d0
  BRA     _End_LoadPalette

_Error3_LoadPalette:
  MOVEQ.l  #-3, d0

_End_LoadPalette:
  MOVE.l   d0, d2
  MOVE.l   $4, a6   ;Doobrey: EEEEP
  MOVE.l   d6, a1
  JSR     _FreeVec(a6)  ; (*Memory) - a1
  MOVE.l   d2, d0
  MOVEM.l  (a7)+,d2-d7/a2-a3
  RTS

 CNOP 0,4

; GetIFFChunk **********************************************
;
; d0 = *Picture
; d1 = ChunkID
;
_GetIFFChunk2:
  MOVE.l   d0, a0
  MOVE.l   d0, a1
  MOVE.l   4(a0), d0  ; Get length of IFF file
  ADD.l    d0, a1     ; Add it to the addr, to have the max addr to not overtake

  ADD.w    #12, a0    ; Position on the first chunk

_LoopGetChunk2:
  MOVE.l   (a0)+, d0  ; Get the Chunk value

  CMP.l    d0, d1     ; If the chunkID is found, cool.
  BEQ     _ChunkFound2 ;
                      ;
  MOVE.l   (a0)+, d0
  ADDQ.w   #1, d0     ; Make it even !
  AND.b    #$fe, d0   ;

  ADD.l    d0, a0        ; Else, ADD the chunk size To the Addr
  CMP.l    a0, a1        ; Check if the EOF is reached
  BLE     _ChunkNotFound2;
  BRA     _LoopGetChunk2  ;

_ChunkFound2:
  MOVE.l   a0, d0
  ADDQ.l   #4, d0       ; To skip the chunk size
  BRA     _GetIFFChunkEnd2

_ChunkNotFound2:
  MOVEQ    #0,d0

_GetIFFChunkEnd2:
  RTS

 endfunc   19
;------------------------------------------------------------------------------------------

 base
LibBase:
  Dc.l 0    ; _PalPtr
  Dc.l 0    ; _ObjNum
  Dc.l 0    ; _MemPtr
  Dc.l 0    ; _TaskPtr
  Dc.b 0    ; _Quit
  Dc.b 0    ; _FadeState
  Dc.w 0    ; _SigNum
  Dc.l 0    ; _Mask
  Dc.l 0    ; _Param1
  Dc.l 0    ; _Param2
  Dc.l 0    ; _Param3
  Dc.l 0    ; _Param4
  Dc.l 0    ; _Param5
  Dc.l 0    ; _FadeCode

 CNOP 0,4

; GetPosition() *************************************************
;
l_GetPosition:
  MOVEA.l _MemPtr(a5), a3
  LSL.l    #2, d0
  ADD.l    d0, a3
  MOVE.l   (a3), a1
  RTS

 CNOP 0,4

; GetColComponent() *********************************************
;
l_GetColComponent:
  MOVE.l  _PalPtr(a5), a0
  MULU.w   #12, d0
  ADD.w    d1, a0
  ADD.w    d0, a0
  MOVEQ    #0, d0
  MOVE.b   (a0), d0
  RTS

  CNOP 0,4

; FreePalette() *************************************************
; A6 must be ExecBase on entry

l_FreePalette:
  MOVE.l  a3,-(a7)
  JSR      GetPosition(a5)    ; Input d0, Result a1 - a3 store the current pos.
  MOVE.l   a1,d0
  BEQ     _EndFreePalette
  CLR.l    (a3)
  JSR     _FreeVec(a6)        ; Free it  
_EndFreePalette:
  MOVE.l  (a7)+,a3
  RTS


  Even

 endlib
;------------------------------------------------------------------------------------------
.Debugger

 startdebugger

_InitCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  RTS


_MaxiCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  CMP.l   _ObjNum(a5),d0
  BGE      Error1
  RTS


_CurrentCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  TST.l   _PalPtr(a5)
  BEQ      Error2
  RTS


_ExistCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  CMP.l   _ObjNum(a5), d0
  BGE      Error1
  MOVEA.l _MemPtr(a5), a0           ; Now see if the given number
  MOVE.l   d0, d1                   ; is really initialized
  LSL.l    #2, d1                   ;
  ADD.l    d1, a0
  MOVE.l   (a0), d1
  BEQ      Error3
  RTS


Error0:  debugerror "InitPalette() doesn't have been called before"
Error1:  debugerror "Maximum 'Palette' objects reached"
Error2:  debugerror "There is no current used 'Palette'"
Error3:  debugerror "Specified #Palette object number isn't initialized"

 enddebugger

