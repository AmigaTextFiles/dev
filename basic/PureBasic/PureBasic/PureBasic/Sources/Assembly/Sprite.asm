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
; Sprite:
; ======
; Width.w : Height.w : Depth.w : BltSize.w
; ebWidth.w : xHandle.w : yHandle.w : MemSort.w
; SpriteSize.l (*2) : Data.l : Cookie.l
; Pad.b[4]
; (Size = 32 byte)
;
; ServerSprite:
; ============
;
; One of  > BlitID.w : RealBitMapPtr.l : Shape.l : x.w
; these.. > BlitID.w : RealBitMapPtr.l : Shape.l : Pad.w
; (Size = 12 byte)
;
; Buffer:
; ======
;
; Gfx.l (Chip always) : Info.l (Chip|Fast)
; InfoPos.l : BitMap.l : LineLen.w
; (Size = 32 byte)
;
; Gfx:        holds the background.
; InfoBuffer: holds info about Gfx.
; InfoPos:    pos inside InfoBuffer.
; BitMap:     ptr to BitMap.
; LineLen:    calculated from BitMap.
;
; Info:
; ====
; BitMapPtr.l : GfxPtr.l
; BitMapMod.w : BltSize.w
; (Size = 12 byte)
;
; BitMapPtr: points to destination (real pos) inside BitMap.
; GfxPtr:    points to source in the Gfx.
; BltSize:   is taken from #Sprite.
; BitMapMod: must be calculated.
;
; (Written by SaveBackGround and Read by RestoreBackGrond)
;

; To add.
; ------
; Clipped Sprite ??, Stencil ??
; Remove R_Setup
;


 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16
MEMF_CHIP  = 1 << 1

FORM = $464F524D
ILBM = $494C424D
BMHD = $424D4844
CMAP = $434D4150
BODY = $424F4459

BLIT_STRUCT_SIZE = 12  ; 1^4 = 16


_R_Setup              = l_Setup-LibBase
_R_StartBlock1        = _l_BaseFuncAddresses-LibBase
_R_StartBlit1         = _R_StartBlock1+4
_R_SaveBackGround1    = _R_StartBlit1+4
_R_RestoreBackGround1 = _R_SaveBackGround1+4




_B_ObjNum_Sprite  = _R_RestoreBackGround1+4
_B_MemPtr_Sprite  = _B_ObjNum_Sprite+4
_B_ObjNum_Sprite2 = _B_MemPtr_Sprite+4
_B_MemPtr_Sprite2 = _B_ObjNum_Sprite2+4
_B_ObjNum_Buffer  = _B_MemPtr_Sprite2+4
_B_MemPtr_Buffer  = _B_ObjNum_Buffer+4
_B_ActPos         = _B_MemPtr_Buffer+4
_B_LastPos        = _B_ActPos+4
_B_IsBusy         = _B_LastPos+4
_B_RBG_Busy       = _B_IsBusy+2
_B_Chip           = _B_RBG_Busy+2
_B_Info           = _B_Chip+4
_B_InfoPos        = _B_Info+4
_B_BitMap         = _B_InfoPos+4
_B_Buffer         = _B_BitMap+4
_B_LineLength     = _B_Buffer+4
_B_Interrupt      = _B_LineLength+2
_B_OldInt         = _B_Interrupt+22
_B_Custom         = _B_OldInt+4
_B_ICode          = _B_Custom+4


 initlib "Sprite", "Sprite", "FreeSprites", 250, 1, 0

;------------------------------------------------------------------------------------------------

 name      "InitSprite", "(#MaxSprites, #MaxDisplayedSprites, #MaxSpriteBuffers)"
 flags      LongResult
 amigalibs _ExecBase, a6
 params     d0_l, d2_l, d3_l
 debugger   1, Error_InitSprite

  MOVEM.l  d2-d3/a5-a6,-(a7)	     ; Save registers
  
  JSR      (a5)                      ; call _R_Setup 

  MOVE.l   d0, _B_ObjNum_Sprite(a5)  ; ...
  MOVE.l   d2, _B_ObjNum_Sprite2(a5) ; ...
  MOVE.l   d3, _B_ObjNum_Buffer(a5)  ; ...

  ADDQ.l   #1,d0                     ; inc MaxSprites
  LSL.l    #5,d0                     ; MaxSprites * objsize (32 byte)

  ADDQ.l   #1,d2                     ; inc MaxDisplayedSprites
  MULU.w   #BLIT_STRUCT_SIZE, d2     ; MaxDisplayedSprites * objsize (12 byte)

  ADDQ.l   #1,d3                     ; inc MaxSpriteBuffer
  LSL.l    #5,d3                     ; MaxSpriteBuffer * objsize (32 byte)

  ADD.l    d2,d0                     ; calc size of whole..
  ADD.l    d3,d0                     ; memory bank
  MOVE.l   #MEMF_CLEAR, d1           ; ...
  JSR     _AllocVec(a6)              ; (Size, Flags) - d0/d1
  BEQ      IS_End                    ; no mem

  MOVE.l   d0, _B_MemPtr_Sprite2(a5) ; ...
  ADD.l    d2, d0                    ; ...
  MOVE.l   d0, _B_MemPtr_Buffer(a5)  ; ...
  ADD.l    d3, d0                    ; ...
  MOVE.l   d0, _B_MemPtr_Sprite(a5)  ; ...

  LEA.l    IntTitle(pc),a0           ; ...
  LEA.l   _B_ActPos(a5),a1           ; ...
  LEA.l   _B_ICode(a5),a6            ; ...
  LEA.l   _B_Interrupt+10(a5),a5     ; ...
  MOVEM.l  a0-a1/a6,(a5)             ; set is_Title, is_Data, is_Code

IS_End
  MOVEM.l (a7)+,d2-d3/a5-a6	     ; Restore registers
  RTS

IntTitle:  Dc.b "PureBasic Sprite",0,0

 endfunc 1

;------------------------------------------------------------------------------------------------

 name      "FreeSprites", "()"
 flags
 amigalibs _ExecBase,a6, _GraphicsBase,d7
 params
 debugger   2

   MOVEM.l d2/d7/a2,-(a7)		; Save registers

FSs_loop0
;  SUB.l     a1, a1         ; NULL Value
;  JSR      _FindTask(a6)   ; (*TaskName) - a1
;  MOVE.l    d0, a1
;  MOVEQ.l   #-1, d0
;  JSR      _SetTaskPri(a6) ; (a1/d0)

  TST.l   _B_IsBusy(a5)              ; test both IsBusy & RBG_Busy
  BNE      FSs_loop0                 ; loop until FALSE

  MOVE.l  _B_OldInt(a5),d1           ; was spriteserver started
  BEQ      FSs_l0                    ; nope

  MOVE.w   #64,$dff09a               ; ...
  MOVEQ    #6,d0                     ; arg1.
  MOVE.l   d1,a1                     ; arg2.
  JSR     _SetIntVector(a6)          ; (intnumber, *Interrupt) - d0/a1

  EXG.l    d7,a6                     ; use GfxBase
  JSR     _DisownBlitter(a6)         ; Release the Blitter
  MOVE.l   d7,a6                     ; use ExecBase

FSs_l0
  MOVE.l  _B_MemPtr_Sprite2(a5),d7   ; anything to free
  BEQ      FSs_End                   ; nop

  MOVE.l  _B_ObjNum_Buffer(a5), d2   ; First..
  MOVE.l  _B_MemPtr_Buffer(a5), a2   ; free all allocated SpriteBuffers

_FreeAllSpriteBuffers:
  MOVE.l   (a2)+,d0                  ; get #Buffer\Gfx
  BEQ      FSs_l1                    ; ...

  MOVE.l   d0,a1                     ; arg1.
  JSR     _FreeVec(a6)               ; (*Memory) - a1
  MOVE.l   (a2),a1                   ; arg1.
  JSR     _FreeVec(a6)               ; (*Memory) - a1

FSs_l1
  LEA.l    28(a2),a2                 ; next #Buffer
  DBRA     d2,_FreeAllSpriteBuffers  ; ...

  MOVE.l  _B_ObjNum_Sprite(a5), d2   ; Next, free all the Sprites..
  MOVE.l  _B_MemPtr_Sprite(a5), a2   ; located in chip or fast

_FreeAllSprites:
  MOVE.l   20(a2),a1                 ; arg1.
  JSR     _FreeVec(a6)               ; (*Memory) - a1
  LEA.l    32(a2),a2                 ; ...
  DBRA     d2,_FreeAllSprites        ; ...

  MOVE.l   d7,a1                     ; arg1.
  JSR     _FreeVec(a6)               ; (*Memory) - a1

FSs_End
  MOVEM.l (a7)+,d2/d7/a2	     ; Restore registers
  RTS

 endfunc 2

;------------------------------------------------------------------------------------------------

 name      "FreeSprite", "(#Sprite)"
 flags
 amigalibs _ExecBase, a6
 params     d0_l
 debugger   3, Error_FreeSprite

  MOVE.l  _B_MemPtr_Sprite(a5),a0    ;
  LSL.l    #5,d0                     ;  Inlined GetPosition() for speed...
  ADD.l    d0,a0                     ;
  LEA.l    20(a0),a0                 ; Fast ADD.l #14,a0
  MOVE.l   (a0),a1                   ; Get the *SpriteData pointer
  CLR.l    (a0)                      ; Tell the system than this position is free.
  JMP     _FreeVec(a6)               ; (*Memory) - a1

 endfunc 3

;------------------------------------------------------------------------------------------------

 name      "FreeSpriteBuffer", "(#Buffer)"
 flags
 amigalibs _ExecBase, a6
 params     d0_l
 debugger   4, Error_FreeSpriteBuffer

  MOVE.l a2,-(a7)			; Save registers

  LSL.l    #5,d0                     ; ...
  ADD.l   _B_MemPtr_Buffer(a5),d0    ; ...
  MOVE.l   d0,a2                     ; - A2 hold #Buffer

  CMP.l   _B_Buffer(a5),d0             ; is current buffer the same
  BNE      FSB_l0                    ; nope

  CLR.l   _B_Buffer(a5)                ; ...

FSB_l0
  MOVE.l   (a2),a1                   ; arg1.
  JSR     _FreeVec(a6)               ; (*Memory) - a1

  CLR.l    (a2)+                     ; clear \Gfx

  MOVE.l   (a2),a1                   ; arg1.
  MOVE.l (a7)+,a2			; Restore registers
  JMP     _FreeVec(a6)               ; (mem) - a1

 endfunc 4

;------------------------------------------------------------------------------------------------

 name      "StartSpriteServer", "()"
 flags      LongResult
 amigalibs _GraphicsBase,a6 , _ExecBase, a2
 params
 debugger   5, Error_StartSpriteServer

  JSR     _OwnBlitter(a6)            ; Get the blitter chip for us
  JSR     _WaitBlit(a6)              ; Wait for any previous blit..

  MOVE.l  _B_MemPtr_Sprite2(a5),d0   ; Take the last free position
  LEA.l   _B_ActPos(a5), a0          ; ...
  MOVE.l   d0, (a0)+                 ; Set ActPos
  MOVE.l   d0, (a0)                  ; Set LastPos
  MOVE.w   #64,$dff09a               ; intena
  EXG.l    a2,a6		     ; a2=gfx a6=exec
  MOVEQ    #6,d0                     ; arg1.
  LEA     _B_Interrupt(a5),a1        ; arg2.
  JSR     _SetIntVector(a6)          ; (intnumber, *Interrupt) - d0/a1
  EXG.l    a2,a6		     ; a6=gfx a2=exec.. no need to push/pull regs on stack
  MOVE.l   d0,_B_OldInt(a5)          ; ...
  MOVE.w   #32832,$dff09a            ; ...
  RTS

 endfunc 5

;------------------------------------------------------------------------------------------------

 name      "StopSpriteServer", "()"
 flags
 amigalibs _ExecBase,a6, _GraphicsBase,d3
 params
 debugger   6, Error_StopSpriteServer

  MOVE.w   #64,$dff09a               ;
  MOVEQ    #6,d0                     ;
  MOVE.l  _B_OldInt(a5),a1           ;
  CLR.l   _B_OldInt(a5)              ;
  JSR     _SetIntVector(a6)          ; (intnumber, *Interrupt) - d0/a1

  EXG.l   d3,a6
  JSR     _DisownBlitter(a6)         ; Release the Blitter
  EXG.l   d3,a6			     ;
  RTS				     ;

 endfunc 6

;------------------------------------------------------------------------------------------------

 name      "WaitSpriteServer", "()"
 flags	   InLine
 amigalibs
 params
 debugger   7, Error_WaitSpriteServer

_NWQB_Loop:
  TST.l   _B_IsBusy(a5)              ; test both IsBusy & RBG_Busy
  BNE     _NWQB_Loop                 ; loop until FALSE
  I_RTS

 endfunc 7

;------------------------------------------------------------------------------------------------

 name      "ResetSpriteServer", "()"
 flags	   InLine
 amigalibs
 params
 debugger   8, Error_ResetSpriteServer

  MOVE.l  _B_MemPtr_Sprite2(a5),d0   ; Take the last free position
  LEA.l   _B_ActPos(a5), a0          ; ...
  MOVE.l   d0, (a0)+                 ; Set ActPos
  MOVE.l   d0, (a0)                  ; Set LastPos
  I_RTS

 endfunc 8

;------------------------------------------------------------------------------------------------

 name      "CreateSpriteBuffer", "(#Buffer, Size, BitMapID)"
 flags
 amigalibs _ExecBase,a6
 params     d0_l, d1_l, d6_l
 debugger   9, Error_CreateSpriteBuffer

  MOVEM.l  d3-d6/a2,-(a7)		; Save registers
 
  MOVEA.l _B_MemPtr_Buffer(a5),a2    ; ...
  LSL.l    #5, d0                    ; ...
  ADD.l    d0, a2                    ; - A2 hold #Buffer

  MOVE.l   d1, d0                    ; arg1.
  MOVEQ    #MEMF_CHIP,d1             ; arg2.
  JSR     _AllocVec(a6)              ; Allocate our buffer

  MOVE.l   d0,d3                     ; ...
  BEQ      CSB_End2                  ; no chipmem

  MOVE.l  _B_ObjNum_Sprite2(a5),d0   ; ...
  ADDQ.l   #8,d0                     ; ...
  MULU.w   #12,d0                    ; arg1.
  MOVEQ    #1,d1                     ; arg2.
  SWAP     d1                        ; ...
  JSR     _AllocVec(a6)              ; (size, req) - d0/d1

  MOVE.l   d0,d4                     ; ...
  BEQ      CSB_End1                  ; no mem at all

  MOVE.l   d4,d5                     ; ...
  MOVEM.l  d3-d6,(a2)                ; set \Gfx, \Info, \InfoPos, \BitMap

  MOVE.l   d6,a0                     ; use BitMap
  MOVEQ.l  #0,d1                     ; ...
  MOVE.w   (a0),d1                   ; get BitMap\BytesPerRow
  MOVEQ.l  #0,d2                     ; ...
  MOVE.b   5(a0),d2                  ; get BitMap\Depth
  DIVU.w   d2,d1                     ; BytesPerRow / Depth
  MOVE.w   d1,16(a2)                 ; set \LineLength

  MOVEM.l  d3-d6/a2,_B_Chip(a5)      ; set all in one (Current Buffer)
  MOVE.w   d1,_B_LineLength(a5)      ; ...
  BRA      CSB_End2                  ; ...

CSB_End1:
  MOVEA.l  d3,a1                     ; arg1.
  JSR     _FreeVec(a6)               ; (mem) - a1

  MOVEQ    #0,d0                     ; return false
  MOVE.l   d0,(a2)                   ; clear \Gfx

CSB_End2:
  MOVEM.l (a7)+,d3-d6/a2		; Restore registers
  RTS

 endfunc 9

;------------------------------------------------------------------------------------------------

 name      "UseSpriteBuffer", "(#Buffer)"
 flags
 amigalibs
 params     d0_l
 debugger   10, Error_UseSpriteBuffer

  MOVE.l   a5,-(a7)			; Save registers
  LSL.l    #5, d0                    ; ...
  ADD.l   _B_MemPtr_Buffer(a5),d0    ; ...
  MOVE.l   d0, a0                    ; - A0 hold #Buffer

  MOVE.l  _B_Buffer(a5),a1           ; ...
  MOVE.l  _B_InfoPos(a5),8(a1)       ; set \InfoPos

  LEA     _B_Chip(a5),a5             ; ...
  MOVE.l   (a0)+,(a5)+               ; set _B_Chip
  MOVE.l   (a0)+,(a5)+               ; set _B_Info
  MOVE.l   (a0)+,(a5)+               ; set _B_InfoPos
  MOVE.l   (a0)+,(a5)+               ; set _B_BitMap
  MOVE.l    d0  ,(a5)+               ; set _B_Buffer
  MOVE.w   (a0) ,(a5)                ; set _B_LineLength

  MOVE.l (a7)+,a5		     ; Restore registers
  RTS

 endfunc 10

;------------------------------------------------------------------------------------------------

 name      "FlushSpriteBuffer", "(#Buffer)"
 flags
 amigalibs
 params     d0_l
 debugger   11, Error_FlushSpriteBuffer

  MOVEA.l _B_MemPtr_Buffer(a5),a0    ; ...
  LSL.l    #5, d0                    ; ...
  ADD.l    d0, a0                    ; - A0 hold #Buffer

  MOVE.l   4(a0),8(a0)               ; restore \InfoPos
  RTS

 endfunc 11

;------------------------------------------------------------------------------------------------

 name      "RestoreBackGround", "()"
 flags
 amigalibs
 params
 debugger   12, Error_RestoreBackGround

  MOVE.l  _B_InfoPos(a5),d0          ; ...
  CMP.l   _B_Info(a5),d0             ; ...
  BEQ      RBG_End                   ; nothing to do

  MOVE.l  _B_Buffer(a5),a0           ; ...
  MOVE.l   (a0),_B_Chip(a5)          ; restore Chip

  ADDQ.w   #1,_B_RBG_Busy(a5)          ; ...
  MOVEA.l _R_RestoreBackGround1(a5),a0 ; ...
  JMP      (a0)                        ; ...

RBG_End:
  RTS

 endfunc 12

;------------------------------------------------------------------------------------------------
; Doobrey: Just preserved regs - Unfinished.. Check on R_Start_Blit ?

 name      "AddSprite", "(#Sprite, x, y)"
 flags      LongResult
 amigalibs
 params     d0_l, d1_l, d2_l
 debugger   13, Error_AddSprite

  MOVEM.l d2-d3,-(a7)		     ; Save registers

  LSL.l    #5,d0                     ; ...
  ADD.l   _B_MemPtr_Sprite(a5),d0    ; ...

  MOVE.l   d0,a0                     ; ...
  SUB.w    10(a0),d1                 ; x - xHandle
  SUB.w    12(a0),d2                 ; y - yHandle

  MOVE.l  _B_BitMap(a5),a0           ; ...
  MOVE.w   d1, d3                    ; Save 'x'

  MULU.w   (a0), d2                  ; y * byte/raster_row
  LSR.l    #3,d1                     ; x / 8
  ADD.l    d2,d1                     ; add xbyte to ybyte = displacement.
  ADD.l    8(a0),d1                  ; Add the BitMap\FirstBitPlane to have the real position

  MOVE.l  _B_LastPos(a5), a0         ; Take the last free position

  MOVE.w   #2, (a0)+                 ; Blit identification
  MOVE.l   d1, (a0)+                 ; Position inside the BitMap
  MOVE.l   d0, (a0)+                 ; Sprite
  MOVE.w   d3, (a0)+                 ; x

  MOVE.l   a0,_B_LastPos(a5)         ; set new lastpos

  TST.w   _B_IsBusy(a5)              ; is server busy or this is second sprite
  BNE      AQB_End                   ; yep

  ADDQ.w   #1,_B_IsBusy(a5)          ; set IsBusy

  TST.w   _B_RBG_Busy(a5)            ; is server busy restoreing background..
  BNE      AQB_End                   ; yep

  MOVE.l  _R_StartBlit1(a5),a0       ; ...
  JMP      (a0)                      ; ...

AQB_End:
  RTS

 endfunc 13

;------------------------------------------------------------------------------------------------

 name      "AddBufferedSprite", "(#Sprite, x, y)"
 flags      LongResult
 amigalibs
 params     d0_l, d1_l, d2_l
 debugger   14, Error_AddBufferedSprite

  LSL.l    #5,d0                     ; ...
  ADD.l   _B_MemPtr_Sprite(a5),d0    ; ...

  MOVE.l   d0,a0                     ; ...
  SUB.w    10(a0),d1                 ; x - xHandle
  SUB.w    12(a0),d2                 ; y - yHandle

  MOVE.l  _B_BitMap(a5),a0           ; ...
  MOVE.w   d1, d3                    ; Save 'x'

  MULU.w   (a0), d2                  ; y * byte/raster_row
  LSR.l    #3,d1                     ; x / 8
  ADD.l    d2,d1                     ; add xbyte to ybyte = displacement.
  ADD.l    8(a0),d1                  ; Add the BitMap\FirstBitPlane to have the real position

  MOVE.l  _B_LastPos(a5),a0          ; Take the last free position

  MOVE.w   #3, (a0)+                 ; Blit identification
  MOVE.l   d1, (a0)+                 ; Position inside the BitMap
  MOVE.l   d0, (a0)+                 ; Sprite
  MOVE.w   d3, (a0)+                 ; x

  MOVE.l   a0,_B_LastPos(a5)         ; set new lastpos

  TST.w   _B_IsBusy(a5)              ; is server busy..
  BNE      ABB_End                   ; yep

  ADDQ.w   #1,_B_IsBusy(a5)          ; set IsBusy

  TST.w   _B_RBG_Busy(a5)            ; is server busy restoreing background..
  BNE      ABB_End                   ; yep

  MOVE.l  _R_SaveBackGround1(a5),a0  ; ...
  JMP      (a0)                      ; ...

ABB_End:
  RTS

 endfunc 14

;------------------------------------------------------------------------------------------------

 name      "AddBlockSprite", "(#Sprite, x, y)"
 flags      LongResult
 amigalibs
 params     d0_l, d1_l, d2_l
 debugger   15, Error_AddBlockSprite

  LSL.l    #5,d0                     ; ...
  ADD.l   _B_MemPtr_Sprite(a5),d0    ; ...

  MOVE.l  _B_BitMap(a5),a0           ; ...

  MULU.w   (a0), d2                  ; y  * byte/raster_row
  LSR.l    #3,d1                     ; x / 8
  ADD.l    d2,d1                     ; add xbyte to ybyte = displacement.
  ADD.l    8(a0),d1                  ; Add the BitMap\FirstBitPlane to have the real position

  LEA.l   _B_LastPos(a5), a0         ; Take the last free position
  MOVE.l   (a0), a1                  ; ...

  MOVE.w   #1, (a1)+                 ; Blit identification
  MOVE.l   d1, (a1)+                 ; Real position of the shape inside the bitmap
  MOVE.l   d0, (a1)                  ; Sprite

  ADD.l    #BLIT_STRUCT_SIZE,(a0)    ; Now, ActPos points to next free node.

  TST.w   _B_IsBusy(a5)              ; is server busy..
  BNE      AQBlock_End               ; yep

  ADDQ.w   #1,_B_IsBusy(a5)          ; set IsBusy

  TST.w   _B_RBG_Busy(a5)            ; is server busy restoreing background..
  BNE      AQBlock_End               ; yep

  MOVE.l  _R_StartBlock1(a5),a0      ; ...
  JMP      (a0)                      ; ...

AQBlock_End:
  RTS

 endfunc 15

;------------------------------------------------------------------------------------------------

 name      "SpriteWidth", "(#Sprite)"
 flags
 amigalibs
 params     d1_l
 debugger   16, Error_SpriteWidth

  MOVE.l  _B_MemPtr_Sprite(a5),a0    ;
  LSL.l    #5,d1                     ; Inlined GetPosition() for speed...
  MOVEQ.l  #0, d0                    ; For long result under PureBasic
  MOVE.w   0(a0,d1), d0              ;
  RTS

 endfunc 16


;------------------------------------------------------------------------------------------------

 name      "SpriteHeight", "(#Sprite)"
 flags
 amigalibs
 params     d1_l
 debugger   17, Error_SpriteHeight

  MOVE.l  _B_MemPtr_Sprite(a5),a0    ;
  LSL.l    #5,d1                     ; Inlined GetPosition() for speed...
  MOVEQ.l  #0, d0                    ; For long result under PureBasic
  MOVE.w   2(a0,d1), d0              ;
  RTS

 endfunc 17

;------------------------------------------------------------------------------------------------

 name      "SpriteDepth", "(#Sprite)"
 flags
 amigalibs
 params     d1_l
 debugger   18, Error_SpriteDepth

  MOVE.l  _B_MemPtr_Sprite(a5),a0    ;
  LSL.l    #5,d1                     ; Inlined GetPosition() for speed...
  MOVEQ.l  #0, d0                    ; For long result under PureBasic
  MOVE.w   4(a0,d1), d0              ;
  RTS

 endfunc 18

;------------------------------------------------------------------------------------------------

 name      "SpriteHandle", "(#Sprite, x, y)"
 flags
 amigalibs
 params     d0_l,d1_w,d2_w
 debugger   19, Error_SpriteHandle

  MOVE.l  _B_MemPtr_Sprite(a5),a0    ; ...
  LSL.l    #5,d0                     ; ...
  ADD.l    d0,a0                     ; - A0 hold #Sprite

  MOVE.w   d1,10(a0)                 ; set \yHandle
  MOVE.w   d2,12(a0)                 ; set \xHandle
  RTS

 endfunc 19

;------------------------------------------------------------------------------------------------

 name      "LoadSprites", "(#Sprite, #Sprite, FileName$, Chip/Fast)"
 flags
 amigalibs _DosBase,a6, _ExecBase,d7
 params     d0_l,d1_l,d2_l,d4_l
 debugger   20, Error_LoadSprites

  MOVEM.l  a2-a3,-(a7)               ; ...

  MOVE.l  _B_MemPtr_Sprite(a5),a2    ; ...
  MOVE.l   a2,a3                     ; ...
  LSL.l    #5,d0                     ; ...
  LSL.l    #5,d1                     ; ...
  ADD.l    d0,a2                     ; - A2 hold #Sprite (start)
  ADD.l    d1,a3                     ; - A3 hold #Sprite  (end)

  MOVE.l   d2,d1                     ; arg1.
  MOVE.l   #1005,d2                  ; arg2.
  JSR     _Open(a6)                  ; (filename,mode) - d1/d2

  MOVE.l   d0,d6                     ; save filehandle
  BEQ      LS_End1                   ; ...

  CLR.l    d5                        ; sprite counter

LS_loop0
  MOVE.l   d6,d1                     ; arg1.
  MOVE.l   a2,d2                     ; arg2.
  MOVEQ    #32,d3                    ; arg3.
  JSR     _Read(a6)                  ; (file,buffer,length) - d1/d2/d3

  TST.l    20(a2)                    ; any sprite gfx, \Data
  BEQ      LS_l0                     ; nope

  EXG.l    d7,a6                     ; use execbase
  MOVE.w   d4,14(a2)                 ; set \MemSort
  MOVE.l   16(a2),d3                 ; get \SpriteSize

  MOVE.l   d3,d0                     ; arg1.
  MOVE.l   d4,d1                     ; arg2.
  JSR     _AllocVec(a6)              ; (size,req) - d0/d1

  EXG.l    d7,a6                     ; use dosbase

  MOVE.l   d0,20(a2)                 ; set \Data
  BEQ      LS_End0                   ; ...

  MOVE.l   d3,d1                     ; ...
  LSR.l    #1,d1                     ; size of cookie
  ADD.l    d0,d1                     ; ...
  MOVE.l   d1,24(a2)                 ; set \Cookie

  MOVE.l   d6,d1                     ; arg1.
  MOVE.l   d0,d2                     ; arg2.
  MOVE.l   d3,d3                     ; arg3.
  JSR     _Read(a6)                  ; (file,buffer,length) - d1/d2/d3

  ADDQ.l   #1,d5                     ; inc sprite counter

LS_l0
  CMPA.l   a3,a2                     ; any more sprite to load
  BGE      LS_End0                   ; nop

  LEA      32(a2),a2                 ; inc #Sprite
  BRA      LS_loop0                  ; ...

LS_End0
  MOVE.l   d6,d1                     ; arg1.
  JSR     _Close(a6)                 ; (file) - d1

LS_End1
  MOVE.l   d5,d0                     ; return sprite counter
  MOVEM.l  (a7)+,a2-a3               ; ...
  RTS

 endfunc 20

;------------------------------------------------------------------------------------------------

 name      "SaveSprites", "(#Sprite, #Sprite, FileName$)"
 flags
 amigalibs _DosBase, a6
 params     d0_l,d1_l,d2_l
 debugger   21, Error_SaveSprites

  MOVEM.l  a2-a3,-(a7)               ; ...

  MOVE.l  _B_MemPtr_Sprite(a5),a2    ; ...
  MOVE.l   a2,a3                     ; ...
  LSL.l    #5,d0                     ; ...
  LSL.l    #5,d1                     ; ...
  ADD.l    d0,a2                     ; - A2 hold #Sprite (start)
  ADD.l    d1,a3                     ; - A3 hold #Sprite  (end)

  MOVE.l   d2,d1                     ; arg1.
  MOVE.l   #1006,d2                  ; arg2.
  JSR     _Open(a6)                  ; (filename,mode) - d1/d2

  MOVE.l   d0,d7                     ; save filehandle
  BEQ      SS_End1                   ; ...

  CLR.l    d6                        ; sprite counter

SS_loop0
  MOVE.l   d7,d1                     ; arg1.
  MOVE.l   a2,d2                     ; arg2.
  MOVEQ    #32,d3                    ; arg3.
  JSR     _Write(a6)                 ; (file,buffer,length) - d1/d2/d3

  TST.l    20(a2)                    ; test \Data
  BEQ      SS_l0                     ; ...

  MOVE.l   d7,d1                     ; arg1.
  MOVE.l   20(a2),d2                 ; arg2.
  MOVE.l   16(a2),d3                 ; arg3.
  JSR     _Write(a6)                 ; (file,buffer,length) - d1/d2/d3

  ADDQ.l  #1,d6                      ; inc sprite counter

SS_l0
  CMPA.l   a3,a2                     ; any more sprite to save
  BGE      SS_End0                   ; nop

  LEA      32(a2),a2                 ; inc #Sprite
  BRA      SS_loop0                  ; ...

SS_End0
  MOVE.l   d7,d1                     ; arg1.
  JSR     _Close(a6)                 ; (file) - d1

  MOVE.l   d6,d0                     ; return sprite counter

SS_End1
  MOVEM.l  (a7)+,a2-a3               ; ...
  RTS

 endfunc 21

;------------------------------------------------------------------------------------------------

 name      "CopySprite", "(#Sprite, #Sprite, Chip/Fast)"
 flags
 amigalibs _ExecBase,a6
 params     d0_l,d1_l,d3_l
 debugger   22, Error_CopySprite

  MOVE.l   a3,d7                     ; ...
  MOVE.l   a2,d6                     ; ...

  MOVE.l  _B_MemPtr_Sprite(a5),a2    ; ...
  MOVE.l   a2,a3                     ; ...
  LSL.l    #5,d0                     ; ...
  LSL.l    #5,d1                     ; ...
  ADD.l    d0,a2                     ; - A2 hold #Sprite
  ADD.l    d1,a3                     ; - A3 hold #Sprite

  MOVEQ    #4,d0                     ; ...

CS_loop0
  MOVE.l   (a2)+,(a3)+               ; ...
  DBRA     d0,CS_loop0               ; ...

  MOVE.l   -4(a3),d2                 ; get \SpriteSize
  MOVE.w   d3,-6(a3)                 ; set \MemSort

  MOVE.l   d2,d0                     ; arg1.
  MOVE.l   d3,d1                     ; arg2.
  JSR     _AllocVec(a6)              ; (size,req) - d0/d1

  MOVE.l   d0,(a3)                   ; set \Data
  BEQ      CS_End                    ; return FALSE

  MOVE.l   (a2),a0                   ; get \Data
  MOVE.l   d0,a1                     ; use \Data

  LSR.l    #1,d2                     ; size of cookie
  ADD.l    d2,d0                     ; ...
  MOVE.l   d0,4(a3)                  ; set \Cookie

  SUBQ.l   #1,d2                     ; ...

CS_loop1
  MOVE.w   (a0)+,(a1)+               ; move a gfx word
  DBRA     d2,CS_loop1               ; ...

CS_End
  MOVE.l   d6,a2                     ; ...
  MOVE.l   d7,a3                     ; ...
  RTS

 endfunc 22


;----------------------------------------------------------------------------

 name      "LoadSprite", "(#Sprite, FileName$)"
 flags      LongResult
 amigalibs _DosBase, a6
 params     d0_l, d1_l
 debugger   23, Error_LoadSprite

  MOVEM.l  a2-a3,-(a7)
  MOVE.l   $4,d4

  MOVEA.l _B_MemPtr_Sprite(a5), a3
  LSL.l    #5, d0
  ADD.l    d0, a3

  LEA.l   _IFFTmp(pc), a5

  MOVE.l   #1005, d2  ; Mode Read
  JSR     _Open(a6)   ; (FileName$, Mode) - d1/d2
  MOVE.l   d0, d5     ; Store the file ptr in 'd5'
  BEQ      LS_End     ; File not found

  MOVE.l   d5, d1         ; Read the 12 first bytes
  MOVE.l   a5, d2         ;
  MOVEQ    #12, d3        ;
  JSR     _Read(a6)       ; - d1,d2,d3

  ADDQ.l   #4,a5        ;
  SUBQ.l   #4,(a5)      ;
  MOVE.l   (a5),d6      ; Get the file size
  EXG.l    d4,a6        ;

  MOVE.l   d6,d0
  MOVEQ    #0,d1
  JSR     _AllocVec(a6) ; - d0,d1
  MOVE.l   d0, d7       ; Dest buffer
  BEQ      LS_End

  MOVE.l   d0,8(a5)
  EXG.l    d4,a6

  MOVE.l   d5, d1    ; File ptr
  MOVE.l   d7, d2    ; Dest buffer
  MOVE.l   d6, d3    ; Size of Read
  JSR     _Read(a6)  ; - d1,d2,d3

  MOVE.l   d5, d1    ; Close the file
  JSR     _Close(a6) ; d1

  MOVE.l   d4,a6


  ; fix BMHD

  MOVE.l   d7, d0          ; Try to get the BMHD Chunk
  MOVE.l   #BMHD, d1       ; If not, quit.
  BSR      GetIFFChunk     ; Flush d0/d1-a0/a1
  TST.l    d0              ;
  BEQ      LS_End

  MOVEQ    #0, d0
  MOVEQ    #0, d3
  MOVE.w    (a0)+, d0     ; Get IFF Width
  MOVE.w    (a0)+, d2     ; Get IFF Height
  MOVE.b   4(a0),  d3     ; Get IFF Depth
  MOVE.b   6(a0),  12(a5) ; Get compression mode

  MOVE.w   d0,(a3)+ ; Width
  MOVE.w   d2,(a3)+ ; Height
  MOVE.w   d3,(a3)+ ; Depth

  MOVE.l   d0,d4    ;

  ADD.w    #15,d0   ;
  LSR.w    #4,d0    ;
  ADDQ.w   #1,d0    ;
  MOVE.w   d2,d1    ;
  LSL.w    #6,d1    ; Calculate the BlitSize (directly usable into the
  MULU.w   d3,d1    ;
  ADD.w    d0,d1    ; BlitSize = Height*64*Depth + Width (Width is the nearest 16 aligned value) (see above)
  MOVE.w   d1,(a3)+ ; set \BltSize

  ADDQ.w   #7, d4   ;
  AND.b    #$f8, d4 ; Fast round to the next 8
  LSR.w    #3, d4   ; Divide by 8 quietly
  ADDQ.w   #1, d4   ; Make the result even !
  AND.b    #$fe, d4 ;
  MOVE.w   d4,(a3)+ ; set \ebWidth

  MOVE.l   d4,d5    ; ...
  MULU.w   d2,d5    ; Calculate the number of bytes per bitplane.
  MULU.w   d3,d5    ; SpriteLength = PlaneLength * Depth
  MOVE.l   d5,d6    ; ...
  ADD.l    d6,d6    ; ...
  CLR.l    (a3)+    ; set \HandleX , \HandleY

  MOVE.l   d6,d0         ; arg1.
  MOVEQ.l  #MEMF_CHIP,d1 ; arg2.
  MOVE.w   d1,(a3)+      ; set \MemSort
  MOVE.l   d6,(a3)+      ; set \SpriteSize
  JSR     _AllocVec(a6)  ; (Size, Flags) - d0/d1

  MOVE.l   d0,(a3)  ; set \Data
  BEQ      LS_End   ;

  ADD.l    d0,d5    ;
  MOVE.l   d5,4(a3) ; set \Cookie.

  MOVE.l   d0,a2    ; use later


  ; fix BODY

  MOVE.l   d7, d0        ;
  MOVE.l   #BODY, d1     ;
  BSR      GetIFFChunk   ; Flush d0/d1-a0/a1
  TST.l    d0            ;
  BEQ      LS_End        ;

  SUBQ.l   #1, d2        ; Height   (Setup numbers for fast loops...)
  SUBQ.l   #1, d4        ; ebWidth

  MOVE.b  _Compression(pc),d0
  BNE     _IsCompressed
  BSR     _NotCompressed

  BRA     _BuildCookie

_IsCompressed:
  CMP.b    #1, d0
  BNE      LS_End
  BSR     _ByteRunCompressed


_BuildCookie:
  MOVE.l   (a3),a2 ; Get *Data
  MOVE.l  4(a3),a1 ; Get *Cookie

  MOVE.l  d4,d5    ; EbWidth
  ADDQ.l  #1,d5    ;

  MOVE.l  d5,d4    ; The Lenght of one line - 1.
  MULU.w  d3,d4    ;
  SUB.l   d5,d4    ;
  
  MOVE.w  -18(a3),d7 ; The Height !

_ProcessHeight:
  MOVE.l  d5,d6

_FillCookie:
  MOVE.l  a2,a0  ; Get *SpriteBase
  MOVE.l  d3,d1  ; Get the Depth
  MOVEQ.b #0,d0

_DepthLoop1:
  MOVE.b  (a0),d2
  OR.b    d2,d0
  ADD.l   d5,a0       ; Add OneBitMapLength, to get the next plane pointer
  SUBQ.l  #1,d1       ;
  BNE    _DepthLoop1  ; Process  all the planes

  MOVEQ.l #0,d1
  MOVE.l  d3,d2        ; Get the depth..

_FillLine:
  MOVE.b  d0,0(a1,d1)  ; Set the Or'ed result to the cookie
  ADD.l   d5,d1
  SUBQ.l  #1,d2
  BNE    _FillLine

  ADDQ.l  #1,a1
  ADDQ.l  #1,a2       ; Get the next pixel
  SUBQ.l  #1,d6       ; Process all the pixels
  BNE    _FillCookie  ;

  ADD.l   d4,a1         ; Do it for the whole sprite...
  ADD.l   d4,a2         ;
  SUBQ.w  #1,d7         ;
  BNE    _ProcessHeight ;

  MOVE.l  a3,d0         ; Return the *Sprite pointer

LS_End:
  MOVE.l   d0,d2               ;
  MOVE.l   8(a5),a1            ; free the buffer memory...
  CLR.l    8(a5)               ; Set the data to 0, for next use..
  JSR     _FreeVec(a6)         ;
  MOVE.l   d2,d0               ;
  MOVEM.l  (a7)+,a2-a3         ;
  RTS


GetIFFChunk:
  MOVE.l   d0, a0        ;
  MOVE.l   d0, a1        ;
  ADDA.l   (a5), a1      ; Get length of IFF file

_LoopGetChunk:
  CMP.l   (a0)+, d1      ; Get the Chunk value
  BEQ     _ChunkFound    ;
                         ;
  MOVE.l   (a0)+, d0
  ADDQ.w   #1, d0        ; Make it even !
  AND.b    #$fe, d0      ;

  ADD.l    d0, a0        ; Else, ADD the chunk size To the Addr
  CMP.l    a0, a1        ; Check if the EOF is reached
  BGT     _LoopGetChunk  ;

  MOVEQ    #0,d0
  RTS

_ChunkFound:
  MOVE.l   a0, d0        ;
  ADDQ.l   #4, a0        ; To skip the chunk size
  RTS


;
; BODY Decompression (no compression)
;

_NotCompressed:
  MOVE.l   a2, a1        ; Get *SpriteData

_Loop3:
  MOVEQ    #0,d1         ; Our bitplane counter

_Loop2:
  MOVE.w   d4, d0        ; Get Number of pixel per line and

_Loop1:                  ; fill the bitmap
  MOVE.b  (a0)+, (a1)+   ;
  DBF      d0, _Loop1    ;

  ADDQ.l   #1, d1        ; Add the plane counter..
  CMP.w    d1, d3        ;
  BNE     _Loop2         ;

  DBF      d2, _Loop3    ; Process it for all the picture Height !
  RTS


;
; IFF/ILBM body decompression routine (RunLenght compressed)
;
_ByteRunCompressed:
  MOVE.l   a2, a1        ; Get the sprite data

_LLoop3:
  MOVEQ    #0,d1         ; Our bitplane counter

_LLoop2:
  MOVE.w   d4, d0        ; Get Number of pixel per line and

_LLoop1:                 ; fill the bitmap
  MOVE.b   (a0)+, d6     ; a = !ReadByte

  CMP.b    #0, d6        ; If a >= 0,
  BGE     _Case1         ; read the n next byte without change

  CMP.b    #-128, d6     ;
  BEQ     _Next2         ; Ignore this byte

  NEG.b    d6            ; Change the sign

  SUB.b    d6, d0        ; Read the next byte and copy it n times
  MOVE.b   (a0)+, d7     ;

_LoopCase2:              ;
  MOVE.b   d7, (a1)+     ;
  SUBQ.l   #1, d6        ;
  TST.b    d6            ;
  BGE     _LoopCase2     ;
  BRA     _Next          ;

_Case1:                  ; Read the n next byte without change
  SUB.b    d6, d0        ;

_LoopCase1:              ;
  MOVE.b   (a0)+, (a1)+  ;
  SUBQ.l   #1, d6        ;
  TST.b    d6            ;
  BGE     _LoopCase1     ;

_Next:
  SUBQ.l   #1, d0

_Next2:
  TST.w    d0
  BGE     _LLoop1        ;

  ADDQ.b   #1, d1        ; Add the plane counter.. (Depth counter)
  CMP.b    d1, d3        ;
  BNE     _LLoop2        ;

  DBF      d2, _LLoop3    ; Process it for all the picture Height !
  RTS


_IFFTmp:
 Dc.l 0,0,0

_FileBuffer:
 Dc.l 0

_Compression:
 dc.w 0

 endfunc 23

;----------------------------------------------------------------------------


 name      "GrabSprite", "(#Sprite, BitMapID, X, Y, Width, Height)"
 flags      LongResult
 amigalibs _ExecBase,a6
 params     d0_l,d1_l,d2_l,d3_l,d4_l,d5_l
 debugger   24, Error_GrabSprite

  MOVEM.l  a2-a3,-(a7)               ; ...

  MOVE.l  _B_MemPtr_Sprite(a5),a2    ; ...
  LSL.l    #5,d0                     ; ...
  ADD.l    d0,a2                     ; #Sprite
  MOVE.l   d1,a3                     ; #BitMap

  MOVE.w   d4,(a2)+                  ; set \Width
  MOVE.w   d5,(a2)+                  ; set \Height
  CLR.w    d0                        ; ...
  MOVE.b   5(a3),d0                  ; get \Depth
  MOVE.w   d0,(a2)+                  ; set \Depth

  ADD.w    #15,d4                    ; Width + 15..
  LSR.w    #4,d4                     ; / 16
  MOVE.w   d4,d6                     ; save words
  MULU.w   d0,d5                     ; Height * Depth
  MOVE.w   d5,d7                     ;  save word size
  ADDQ.w   #1,d4                     ; add ext word
  LSL.w    #6,d7                     ; ...
  OR.w     d4,d7                     ; ...
  MOVE.w   d7,(a2)+                  ; set \BltSize

  ADD.w    d6,d6                     ; words to bytes
  MOVE.w   d6,(a2)+                  ; set \ebWidth
  CLR.l    (a2)+                     ; set \xHandle and \yHandle

  MULU.w   d5,d6                     ; word size * ebWidth
  MOVE.l   d6,d7                     ; save sprite size
  ADD.l    d7,d7                     ; calc sprite+cookie size

  MOVE.l   d7,d0                     ; arg1.
  MOVE.l   #65538,d1                 ; arg2.
  MOVE.w   d1,(a2)+                  ; set \MemSort
  MOVE.l   d7,(a2)+                  ; set \SpriteSize
  JSR     _AllocVec(a6)              ; (size,req) - d0/d1

  MOVE.l   d0,(a2)+                  ; set \Data
  BEQ      GS_End                    ; ...

  ADD.l    d0,d6                     ; ...
  MOVE.l   d6,(a2)                   ; set \Cookie
  SUB.w    #24,a2                    ; ...

  MOVE.l   d2,d1                     ; ...
  ANDI.w   #$f,d2                    ; ...

  LSR.w    #4,d1                     ; x / 16
  ADD.w    d1,d1                     ; words to bytes

  MULU.w   (a3),d3                   ; y * BytePerRow
  ADD.l    d1,d3                     ; + even bytes
  ADD.l    8(a3),d3                  ; + BitMap ptr
  MOVE.l   d3, a0                    ; = bitmap offset

  MOVE.l   d0,a1                     ; sprdata

  MOVE.w   (a2),d3                   ; get \Width
  ADD.w    d2,d3                     ; x in word + width
  ADD.w    #15,d3                    ; + 15
  LSR.w    #4,d3                     ; / 16

  CMPI.w   #1,d3                     ; only one word
  BGT      GS_l0                     ; nope

  ADDQ.w   #1,d3                     ; add extra word

GS_l0
  MOVE.w   6(a2),d4                  ; get \BltSize
  LSR.w    #6,d4                     ; / 64

  MOVEQ    #-1,d5                    ; mask
  MOVE.w   (a2)+,d0                  ; get \Width
  CMPI.w   #15,d0                    ; ...
  BGT      GS_l1                     ; ...

  MOVEQ    #16,d1                    ; mask width
  SUB.w    d0,d1                     ; ...
  LSL.w    d1,d5                     ; fwmask lsl width

GS_l1
  LSR.w    d2,d5                     ; fwmask lsr x

  MOVEQ    #-1,d6                    ; mask
  ADD.w    d2,d0                     ; x + width
  MOVE.w   d3,d7                     ; ...
  LSL.w    #4,d7                     ; even words * 16
  SUB.w    d0,d7                     ; epixels - totalwidth
  LSL.w    d7,d6                     ; lwmask lsl ?

  CLR.l    d1                        ; ...
  CLR.l    d7                        ; ...
  MOVE.w    (a3),d7                  ; get \BytePerRow
  MOVE.b   5(a3),d1                  ; get \Depth
  DIVU.w   d1,d7                     ; BytePerRow / Depth
  MOVE.w   d3,d1                     ; use even words
  ADD.w    d1,d1                     ; words to bytes
  SUB.w    d1,d7                     ; ...

  SUBQ.w   #1,d3                     ; bltwid - 1
  LEA      bltwid(pc),a3             ; ...
  MOVE.w   d3,(a3)                   ; ...
  MOVE.w   d1,d3                     ; ...

  MOVE.w   6(a2),d1                  ; ...
  CMPI.w   #2,d1                     ; ...
  BEQ      GS_l2                     ; ...

  SUB.w    d1,d3                     ; ...
  BNE      GS_loop0                  ; ...

  MOVEQ    #4,d1                     ; ...

GS_l2
  MOVE.w   d1,d3                     ; ...

;-----------------------------------------------------------------
; d2=xpos, d3=sprmod, d4=bltheig, d5=fwmask, d6=lwmask, d7=bplmod
; a0=bitmap ptr, a1=sprite data ptr
;-----------------------------------------------------------------
GS_loop0
  CLR.l    d0                        ; ...
  MOVE.w   (a0)+,d0                  ; first data word..
  AND.w    d5,d0                     ; anded with fwmask
  LSL.w    d2,d0                     ; shift left
  MOVE.w   d0,(a1)                   ; write first sprite word

  MOVE.w   bltwid(pc),d1             ; use bltwid

GS_loop1
  CLR.l    d0                        ; ...
  MOVE.w   (a0)+,d0                  ; get data word

  SUBQ.w   #1,d1                     ; dec bltwid
  BLE      GS_l3                     ; ...

  LSL.l    d2,d0                     ; shift left
  OR.l     d0,(a1)                   ; write sprite word
  ADDQ.l   #2,a1                     ; inc to next sprite word
  BRA      GS_loop1                  ; ...

GS_l3
  AND.w    d6,d0                     ; anded with lwmask
  LSL.l    d2,d0                     ; shift left
  OR.l     d0,(a1)                   ; write last sprite word
  ADD.w    d3,a1                     ; inc to next sprite word  ADDQ.l #2

  ADD.l    d7,a0                     ; add modulo
  DBRA     d4,GS_loop0               ; dec blthigh

  ; cookie constuction

  MOVE.w    (a2)+,d7                 ; get \Height
  MOVE.w    (a2),d6                  ; get \Depth
  MOVE.w   4(a2),d5                  ; get \ebWidth
  MOVE.w   d5,d4                     ; ...
  MULU.w   d6,d4                     ; line size
  SUB.w    d5,d4                     ; ...
  EXT.l    d4                        ; ...

  SUBQ.l   #1,d7                     ; height - 1
  SUBQ.l   #1,d6                     ; depth - 1

  MOVE.l   16(a2),a0                 ; get \Data
  MOVE.l   20(a2),a1                 ; get \Cookie

GS_loop2
  MOVE.w   d5,d2                     ; use ebwidth
  LSR.w    #1,d2                     ; now words
  SUBQ.w   #1,d2                     ; ...

GS_loop3
  CLR.w    d0                        ; ...
  MOVE.w   d6,d1                     ; use depth
  CLR.w    d3                        ; offset

GS_loop4
  OR.w     0(a0,d3.w),d0             ; ...
  ADD.w    d5,d3                     ; ...
  DBRA     d1,GS_loop4               ; ...

  MOVE.w   d6,d1                     ; use depth
  CLR.w    d3                        ; offset

GS_loop5
  MOVE.w   d0,0(a1,d3.w)             ; ...
  ADD.w    d5,d3                     ; ...
  DBRA     d1,GS_loop5               ; ...

  ADDQ.l   #2,a0                     ; next word
  ADDQ.l   #2,a1                     ; next word
  DBRA     d2,GS_loop3               ; ...

  ADD.l    d4,a0                     ; data + linesize
  ADD.l    d4,a1                     ; cookie + linesize
  DBRA     d7,GS_loop2               ; dec height

  MOVE.l   a2,d0                     ; ...

GS_End
  MOVEM.l  (a7)+,a2-a3               ; restore a2 & a3
  RTS

bltwid: dc.w 0

 endfunc 24

;------------------------------------------------------------------------------------------------

 name      "RemoveCookie", "(#Sprite)"
 flags      LongResult
 amigalibs _ExecBase,a6
 params     d0_l
 debugger   25, Error_RemoveCookie

  MOVE.l   a2,d7                     ; ...

  MOVE.l  _B_MemPtr_Sprite(a5),a2    ; ...
  LSL.l    #5,d0                     ; ...
  ADD.l    d0,a2                     ; #Sprite

  MOVE.l   16(a2),d6                 ; get \SpriteSize
  LSR.w    #1,d6                     ; / 2

  MOVE.l   d6,d0                     ; arg1.
  MOVE.w   14(a2),d1                 ; arg2.
  EXT.l    d1                        ; ...
  JSR     _AllocVec(a6)              ; (size,req) - d0/d1

  MOVE.l   d0,d5                     ; ...
  BEQ      RC_End                    ; ...

  MOVE.l   20(a2),d4                 ; get \Data
  MOVE.l   d5,20(a2)                 ; set \Data
  MOVE.l   d6,16(a2)                 ; set \SpriteSize

  LSR.w    #1,d6                     ; byte to word
  SUBQ.w   #1,d6                     ; ...

  MOVE.l   d4,a0                     ; use old \Data
  MOVE.l   d5,a1                     ; use new \Data

RC_loop0
  MOVE.w   (a0)+,(a1)+               ; move a gfx word
  DBRA     d6,RC_loop0               ; ...

  MOVE.l   d4,a1                     ; arg1.
  JSR     _FreeVec(a6)               ; (memblock) a1

RC_End
  MOVE.l   d7,a2                     ; ...
  RTS

 endfunc 25


;-------------------------- For test purpose --------------------------------
 name      "DataAddr", "()"
 flags      LongResult
 amigalibs
 params
 debugger   99

  LEA      _B_ObjNum_Sprite(a5),a0
  MOVE.l    a0,d0
  RTS

 endfunc 99
;----------------------------------------------------------------------------

;------------------------------------------------------------------------------------------------

 base
LibBase:
l_Setup:
  LEA.l  _StartBlock1(pc),a0           ; }
  MOVE.l  a0,_R_StartBlock1(a5)        ; }
                                       ; }
  LEA.l  _StartBlit1(pc),a0            ; }
  MOVE.l  a0,_R_StartBlit1(a5)         ; }
                                       ; }
  LEA.l  _SaveBackGround1(pc),a0       ; }
  MOVE.l  a0,_R_SaveBackGround1(a5)    ; }
                                       ; } Remove when all work
  LEA.l  _RestoreBackGround1(pc),a0    ; } like it should.
  MOVE.l  a0,_R_RestoreBackGround1(a5) ; }
                                       ; }
  RTS                                  ; }
  CNOP 0,4			       ; Align

_l_BaseFuncAddresses:                  ; }
 Dc.l 0 ; StartBlock1                  ; }
 Dc.l 0 ; StartBlit1                   ; }
 Dc.l 0 ; SaveBackGround1              ; }
 Dc.l 0 ; RestoreBackGround1           ; }

;------------------------------------------

_ObjNum_Sprite:
  Dc.l 0
_MemPtr_Sprite:
  Dc.l 0

_ObjNum_Sprite2:
  Dc.l 0
_MemPtr_Sprite2:
  Dc.l 0

_ObjNum_Buffer:
 Dc.l 0
_MemPtr_Buffer:
 Dc.l 0

ActPos:
 Dc.l 0
LastPos:
 Dc.l 0

IsBusy:
 Dc.w 0
RBG_Busy:
 Dc.w 0

_Chip:       ; gfx buffer
 Dc.l 0

_Infos:      ; info buffer
 Dc.l 0

_InfoPos:    ; pos in info
 Dc.l 0

_BitMap:     ; ptr to bitmap
 Dc.l 0

_Buffer:     ; #Buffer
 Dc.l 0

_LineLength: ; ...
 Dc.w 0

interrupt:
 Dc.l  0
 Dc.l  0
 Dc.b  2
 Dc.b  0
 Dc.l  0

 Dc.l  0  ; is_Data
 Dc.l  0  ; is_Code

oldint:
 Dc.l  0

Custom:
 Dc.l  $dff000


icode:
;----------------------------------------------------------------------------
  LSR.w    10(a1)             ; is server busy restoreing the background..
  BNE     _RestoreBackGround2 ; yep

  MOVEA.l  ActPos(pc), a5     ; get ActPos
  CMPA.l   LastPos(pc),a5     ; check if at end of server que..
  BNE     _StartBlit          ; Nope, Perform the next blit

  CLR.w    8(a1)              ; zero to IsBusy
  MOVE.w   #64,$9c(a0)        ; clean up in intreq
  RTS

_StartBlit:
  SUBQ.w   #1,(a5)            ; dec que ID
  BEQ     _StartBlock2        ; is ID block blit

  CMPI.w   #2,(a5)+           ; is ID save background
  BEQ     _SaveBackGround2    ; yep, do that
  BRA     _StartBlit2         ; nope, its sprite blit
;----------------------------------------------------------------------------


_StartBlock1:
;----------------------------------------------------------------------------
  MOVE.l   Custom(pc),a0           ; get CustomBase
  LEA      ActPos(pc),a1           ; ...
  MOVEA.l  (a1), a5                ; get ActPos

_StartBlock2:
  ADD.l    #BLIT_STRUCT_SIZE, (a1) ; ...

  MOVE.l   2(a5), $54(a0)          ; BltDPtr = *MyBitMap\FirstPlanes
  MOVE.l   6(a5), a1               ; Shape

  MOVE.l   #$9f00000, $40(a0)      ; BLTCON0 & BLTCON1
  MOVE.l   #$ffffffff, $44(a0)     ;  BLTFWM & BLTLWM

  MOVE.l   20(a1), $50(a0)         ; Set the 'A' source pointer (BLTAPT)
  CLR.w    $64(a0)                 ; BltAMod = 0

  MOVE.w  _LineLength(pc),d0       ; ...
  SUB.w    8(a1), d0               ; ...
  MOVE.w   d0, $66(a0)             ; BltDMod = dmod

  MOVE.w   #64,$9c(a0)             ; clean up in intreq
  MOVE.w   6(a1), d0               ; Fix the Blitz2 internal Blit size !
  SUBQ.w   #1, d0                  ; ...
  MOVE.w   d0, $58(a0)             ; BltSize (Start Blitter)
  RTS
;----------------------------------------------------------------------------


_StartBlit1:
;----------------------------------------------------------------------------
  MOVE.l   Custom(pc),a0           ; get CustomBase
  LEA      ActPos(pc),a1           ; ...
  MOVEA.l  (a1),a5                 ; get ActPos
  ADDQ.l   #2,a5                   ; Skip 'BlitMode' (Block or Blit)

_StartBlit2:
  ADD.l    #BLIT_STRUCT_SIZE, (a1) ; ...

  MOVE.l   (a5)+, d0               ; BitMap
  MOVE.l   (a5)+, a1               ; Shape

  MOVE.l   d0, $48(a0)             ; BltCPtr    bitmap_data
  MOVEQ    #-2,d1                  ; modulo for a and b
  SWAP     d1                      ; ...
  MOVE.l   d0, $54(a0)             ; BltDPtr    bitmap_data

  MOVEQ    #15,d0                  ; ...

  MOVE.w  _LineLength(pc),d1       ; ...
  SUB.w    8(a1),d1                ; Sub the ebWidth
  SUBQ.w   #2,d1                   ; ..c and d.
  MOVE.l   d1,$64(a0)              ; modulo a and d.
  SWAP     d1                      ; ...
  MOVE.l   d1,$60(a0)              ; modulo c och b.

  AND.w    (a5), d0                ; sort out x low bits
  ROR.w    #4 ,d0                  ; and bltcon1.
  MOVE.w   d0,$42(a0)              ; BltCon1.
  ORI.w    #4042,d0                ; cookie , enable a,b,c,d = 4042
  MOVE.w   d0,$40(a0)              ; BltCon0.

  MOVE.l   #$ffff0000,$44(a0)      ; BLTFWM and BLTLWM

  MOVE.w   #64,$9c(a0)             ; clean up in intreq
  MOVE.l   20(a1), $4C(a0)         ; BltBPtr (Source *SpriteData).
  MOVE.l   24(a1), $50(a0)         ; BltAPtr = *cookiedata
  MOVE.w    6(a1), $58(a0)         ; BltSize = start blitter
  RTS
;----------------------------------------------------------------------------


_SaveBackGround1:
;----------------------------------------------------------------------------
  MOVE.l   Custom(pc),a0           ; get CustomBase
  LEA      ActPos(pc),a1           ; ...
  MOVEA.l  (a1),a5                 ; get ActPos
  MOVE.w   #2,(a5)+                ; ... (was SUBQ.w   #1,(a5)+ ; dec id)

_SaveBackGround2:
  MOVE.l   (a5)+,d0                ; get source (BitMap)
  MOVE.l   (a5),a5                 ; get Shape

  MOVE.l   20(a1),a6               ; get InfoPos

  MOVE.l   #$9f00000, $40(a0)      ; BLTCON0 & BLTCON1
  MOVE.l   #$ffffffff,$44(a0)      ;  BLTFWM & BLTLWM

  MOVE.l   d0,$50(a0)              ; set source (BitMap)
  MOVE.l   d0,(a6)+                ; set BitMap in Info

  MOVE.l  _Chip(pc),d0             ; to save in info buffer
  MOVE.l   16(a5),d1               ; <- <- <-
  ADD.l    d1,12(a1)               ; ptr to next free pos in gfx buffer

  MOVE.l   d0,$54(a0)              ; set destination (Buffer)
  MOVE.l   d0,(a6)+                ; set Buffer in Info

  MOVE.w  _LineLength(pc),d0       ; ...
  SUB.w    8(a5),d0                ; Sub the ebWidth
  SUBQ.w   #2,d0                   ; ...

  MOVE.w   d0,$64(a0)              ; modulo for BitMap
  SWAP     d0                      ; ...
  CLR.w    $66(a0)                 ; no modulo in buffer

  MOVE.w   6(a5),d0                ; get \BltSize

  MOVE.l   d0,(a6)+                ; set BltSize & BitMapMod
  MOVE.l   a6,20(a1)               ; update InfoPos ptr

  MOVE.w   #64,$9c(a0)             ; clean up in intreq
  MOVE.w   d0,$58(a0)              ; start Blitter
  RTS
;----------------------------------------------------------------------------


_RestoreBackGround1:
;----------------------------------------------------------------------------
  MOVE.l   Custom(pc),a0           ; get CustomBase
  LEA      ActPos(pc),a1           ; ...

  MOVE.l   #$9f00000, $40(a0)      ; BLTCON0 & BLTCON1
  MOVE.l   #$ffffffff,$44(a0)      ;  BLTFWM & BLTLWM

_RestoreBackGround2:
  SUB.l    #12,20(a1)              ; dec InfoPos

  MOVE.l  _InfoPos(pc),a5          ; get InfoPos
  CMPA.l  _Infos(pc),a5            ; any more gfx to restore
  BEQ      RBG_l0                  ; nop

  ADDQ.w   #1,10(a1)               ; inc RBG_Busy

RBG_l0
  MOVE.l   (a5)+,$54(a0)           ; set destination (BitMap)
  MOVE.l   (a5)+,$50(a0)           ; set source (Buffer)

  CLR.w    $64(a0)                 ; no modulo in Buffer
  MOVE.w   (a5)+,$66(a0)           ; modulo for BitMap

  MOVE.w   #64,$9c(a0)             ; clean up in intreq
  MOVE.w   (a5),$58(a0)            ; start Blitter
  RTS
;----------------------------------------------------------------------------

 endlib

;------------------------------------------------------------------------------------------------

 startdebugger

Error_InitSprite:
 TST.l    d0
 BMI      ErrTxt18
 TST.l    d2
 BMI      ErrTxt19
 TST.l    d3
 BMI      ErrTxt20
 RTS

Error_FreeSprite:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d0
 BMI      ErrTxt1

 MOVE.l  _B_ObjNum_Sprite(a5),d7
 CMP.l    d0,d7
 BLT      ErrTxt1

 MOVE.l   d0,d7
 LSL.l    #5,d7
 MOVE.l  _B_MemPtr_Sprite(a5),a0
 ADD.l    d7,a0
 TST.l    20(a0)
 BEQ      ErrTxt2
 RTS

Error_FreeSpriteBuffer:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d0
 BMI      ErrTxt4

 MOVE.l  _B_ObjNum_Buffer(a5),d7
 CMP.l    d0,d7
 BLT      ErrTxt4

 MOVE.l   d0,d7
 LSL.l    #5,d7
 MOVE.l  _B_MemPtr_Buffer(a5),a0
 ADD.l    d7,a0
 TST.l    (a0)
 BEQ      ErrTxt5
 RTS

Error_StartSpriteServer:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l   _B_OldInt(a5)
 BNE      ErrTxt22
 RTS

Error_StopSpriteServer:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l   _B_OldInt(a5)
 BEQ      ErrTxt21
 RTS

Error_WaitSpriteServer:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0
 RTS

Error_ResetSpriteServer:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0
 RTS

Error_CreateSpriteBuffer:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d0
 BMI      ErrTxt4

 MOVE.l  _B_ObjNum_Buffer(a5),d7
 CMP.l    d0,d7
 BLT      ErrTxt4

 MOVE.l   d0,d7
 LSL.l    #5,d7
 MOVE.l  _B_MemPtr_Buffer(a5),a0
 ADD.l    d7,a0
 TST.l    (a0)
 BNE      ErrTxt6
 RTS

Error_UseSpriteBuffer:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d0
 BMI      ErrTxt4

 MOVE.l  _B_ObjNum_Buffer(a5),d7
 CMP.l    d0,d7
 BLT      ErrTxt4

 MOVE.l   d0,d7
 LSL.l    #5,d7
 MOVE.l  _B_MemPtr_Buffer(a5),a0
 ADD.l    d7,a0
 TST.l    (a0)
 BEQ      ErrTxt5
 RTS

Error_FlushSpriteBuffer:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d0
 BMI      ErrTxt4

 MOVE.l  _B_ObjNum_Buffer(a5),d7
 CMP.l    d0,d7
 BLT      ErrTxt4

 MOVE.l   d0,d7
 LSL.l    #5,d7
 MOVE.l  _B_MemPtr_Buffer(a5),a0
 ADD.l    d7,a0
 TST.l    (a0)
 BEQ      ErrTxt5
 RTS

Error_RestoreBackGround:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l   _B_Buffer(a5)
 BEQ      ErrTxt7
 RTS

Error_AddSprite:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d0
 BMI      ErrTxt1

 MOVE.l  _B_ObjNum_Sprite(a5),d7
 CMP.l    d0,d7
 BLT      ErrTxt1

 MOVE.l   d0,d7
 LSL.l    #5,d7
 MOVE.l  _B_MemPtr_Sprite(a5),a0
 ADD.l    d7,a0
 TST.l    20(a0)
 BEQ      ErrTxt2

 TST.l   _B_Buffer(a5)
 BEQ      ErrTxt7

 MOVE.l  _B_LastPos(a5),d6
 ADD.l    #12,d6
 MOVE.l  _B_ObjNum_Sprite2(a5),d7
 ADDQ     #1,d7
 MULU.w   #12,d7
 ADD.l   _B_MemPtr_Sprite2(a5),d7
 CMP.l    d6,d7
 BLT      ErrTxt8

 MOVE.l   d0,d3
 MOVE.l  _B_MemPtr_Sprite(a5),a0
 LSL.l    #5,d3
 ADD.l    d3,a0

 MOVE.l  _B_BitMap(a5),a1

 MOVE.l   d1,d3
 SUB.w    10(a0),d3
 EXT.l    d3
 BMI      ErrTxt11
 MOVE.l   d2,d4
 SUB.w    12(a0),d4
 EXT.l    d4
 BMI      ErrTxt12

 MOVE.w  _B_LineLength(a5),d6
 MULU.w   #8,d6
 MOVE.w   2(a1),d7
 EXT.l    d7

 MOVE.w   0(a0),d5
 EXT.l    d5
 ADD.l    d5,d3
 CMP.l    d3,d6
 BLT      ErrTxt11

 MOVE.w   2(a0),d5
 EXT.l    d5
 ADD.l    d5,d4
 CMP.l    d4,d7
 BLT      ErrTxt12

 CMPI.w   #4,14(a0)
 BEQ      ErrTxt13
 RTS

Error_AddBufferedSprite:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d0
 BMI      ErrTxt1

 MOVE.l  _B_ObjNum_Sprite(a5),d7
 CMP.l    d0,d7
 BLT      ErrTxt1

 MOVE.l   d0,d7
 LSL.l    #5,d7
 MOVE.l  _B_MemPtr_Sprite(a5),a0
 ADD.l    d7,a0
 TST.l    20(a0)
 BEQ      ErrTxt2

 TST.l   _B_Buffer(a5)
 BEQ      ErrTxt7

 MOVE.l  _B_LastPos(a5),d6
 ADD.l    #12,d6
 MOVE.l  _B_ObjNum_Sprite2(a5),d7
 ADDQ     #1,d7
 MULU.w   #12,d7
 ADD.l   _B_MemPtr_Sprite2(a5),d7
 CMP.l    d6,d7
 BLT      ErrTxt8

 MOVE.l  _B_InfoPos(a5),d6
 ADD.l    #12,d6
 MOVE.l  _B_Info(a5),d7
 MOVE.l   d7,a0
 ADD.l    -4(a0),d7
 CMP.l    d6,d7
 BLT      ErrTxt9

 MOVE.l   d0,d3
 MOVE.l  _B_MemPtr_Sprite(a5),a0
 LSL.l    #5,d3
 ADD.l    d3,a0
 MOVE.l  _B_Chip(a5),d6
 ADD.l    16(a0),d6
 MOVE.l  _B_Buffer(a5),a0
 MOVE.l   (a0),d7
 MOVE.l   d7,a1
 ADD.l    -4(a1),d7
 CMP.l    d6,d7
 BLT      ErrTxt10

 MOVE.l   d0,d3
 MOVE.l  _B_MemPtr_Sprite(a5),a0
 LSL.l    #5,d3
 ADD.l    d3,a0

 MOVE.l  _B_BitMap(a5),a1

 MOVE.l   d1,d3
 SUB.w    10(a0),d3
 EXT.l    d3
 BMI      ErrTxt11
 MOVE.l   d2,d4
 SUB.w    12(a0),d4
 EXT.l    d4
 BMI      ErrTxt12

 MOVE.w  _B_LineLength(a5),d6
 MULU.w   #8,d6
 MOVE.w   2(a1),d7
 EXT.l    d7

 MOVE.w   0(a0),d5
 EXT.l    d5
 ADD.l    d5,d3
 CMP.l    d3,d6
 BLT      ErrTxt11

 MOVE.w   2(a0),d5
 EXT.l    d5
 ADD.l    d5,d4
 CMP.l    d4,d7
 BLT      ErrTxt12

 CMPI.w   #4,14(a0)
 BEQ      ErrTxt13

 RTS

Error_AddBlockSprite:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d0
 BMI      ErrTxt1

 MOVE.l  _B_ObjNum_Sprite(a5),d7
 CMP.l    d0,d7
 BLT      ErrTxt1

 MOVE.l   d0,d7
 LSL.l    #5,d7
 MOVE.l  _B_MemPtr_Sprite(a5),a0
 ADD.l    d7,a0
 TST.l    20(a0)
 BEQ      ErrTxt2

 TST.l   _B_Buffer(a5)
 BEQ      ErrTxt7

 MOVE.l  _B_LastPos(a5),d6
 ADD.l    #12,d6
 MOVE.l  _B_ObjNum_Sprite2(a5),d7
 ADDQ     #1,d7
 MULU.w   #12,d7
 ADD.l   _B_MemPtr_Sprite2(a5),d7
 CMP.l    d6,d7
 BLT      ErrTxt8

 MOVE.l   d0,d3
 MOVE.l  _B_MemPtr_Sprite(a5),a0
 LSL.l    #5,d3
 ADD.l    d3,a0

 MOVE.l  _B_BitMap(a5),a1

 MOVE.l   d1,d3
 BMI      ErrTxt11
 MOVE.l   d2,d4
 BMI      ErrTxt12

 MOVE.w  _B_LineLength(a5),d6
 MULU.w   #8,d6
 MOVE.w   2(a1),d7
 EXT.l    d7

 MOVE.w   0(a0),d5
 EXT.l    d5
 ADD.l    d5,d3
 CMP.l    d3,d6
 BLT      ErrTxt11

 MOVE.w   2(a0),d5
 EXT.l    d5
 ADD.l    d5,d4
 CMP.l    d4,d7
 BLT      ErrTxt12

 CMPI.w   #4,14(a0)
 BEQ      ErrTxt13
 RTS

Error_SpriteWidth:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d1
 BMI      ErrTxt1

 MOVE.l  _B_ObjNum_Sprite(a5),d7
 CMP.l    d1,d7
 BLT      ErrTxt1

 MOVE.l   d1,d7
 LSL.l    #5,d7
 MOVE.l  _B_MemPtr_Sprite(a5),a0
 ADD.l    d7,a0
 TST.l    20(a0)
 BEQ      ErrTxt2
 RTS

Error_SpriteHeight:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d1
 BMI      ErrTxt1

 MOVE.l  _B_ObjNum_Sprite(a5),d7
 CMP.l    d1,d7
 BLT      ErrTxt1

 MOVE.l   d1,d7
 LSL.l    #5,d7
 MOVE.l  _B_MemPtr_Sprite(a5),a0
 ADD.l    d7,a0
 TST.l    20(a0)
 BEQ      ErrTxt2
 RTS

Error_SpriteDepth:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d1
 BMI      ErrTxt1

 MOVE.l  _B_ObjNum_Sprite(a5),d7
 CMP.l    d1,d7
 BLT      ErrTxt1

 MOVE.l   d1,d7
 LSL.l    #5,d7
 MOVE.l  _B_MemPtr_Sprite(a5),a0
 ADD.l    d7,a0
 TST.l    20(a0)
 BEQ      ErrTxt2
 RTS

Error_SpriteHandle:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d0
 BMI      ErrTxt1

 MOVE.l  _B_ObjNum_Sprite(a5),d7
 CMP.l    d0,d7
 BLT      ErrTxt1

 MOVE.l   d0,d7
 LSL.l    #5,d7
 MOVE.l  _B_MemPtr_Sprite(a5),a0
 ADD.l    d7,a0
 TST.l    20(a0)
 BEQ      ErrTxt2
 RTS

Error_LoadSprites:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d0
 BMI      ErrTxt15
 TST.l    d1
 BMI      ErrTxt16

 MOVE.l  _B_ObjNum_Sprite(a5),d6
 CMP.l    d0,d6
 BLT      ErrTxt15
 CMP.l    d1,d6
 BLT      ErrTxt16

 MOVE.l   d0,d6
 LSL.l    #5,d6
 MOVE.l  _B_MemPtr_Sprite(a5),a0
 ADD.l    d6,a0
 MOVE.l   d1,d6
 SUB.l    d0,d6

Error_LS_loop0
 TST.l    20(a0)
 BNE      ErrTxt3
 ADD.w    #32,a0
 DBRA     d6,Error_LS_loop0

 CMPI.l   #2,d4
 BEQ      Error_LoadSprites_End
 CMPI.l   #4,d4
 BNE      ErrTxt17

Error_LoadSprites_End
 RTS

Error_SaveSprites:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d0
 BMI      ErrTxt15
 TST.l    d1
 BMI      ErrTxt16

 MOVE.l  _B_ObjNum_Sprite(a5),d7
 CMP.l    d0,d7
 BLT      ErrTxt15
 CMP.l    d1,d7
 BLT      ErrTxt16
 RTS

Error_CopySprite:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d0
 BMI      ErrTxt15
 TST.l    d1
 BMI      ErrTxt16

 MOVE.l  _B_ObjNum_Sprite(a5),d7
 CMP.l    d0,d7
 BLT      ErrTxt15
 CMP.l    d1,d7
 BLT      ErrTxt16

 MOVE.l   d0,d7
 MOVE.l  _B_MemPtr_Sprite(a5),a0
 MOVE.l   a0,a1
 LSL.l    #5,d7
 ADD.l    d7,a0
 MOVE.l   d1,d7
 LSL.l    #5,d7
 ADD.l    d7,a1

 TST.l    20(a0)
 BEQ      ErrTxt2
 TST.l    20(a1)
 BNE      ErrTxt3

 CMPI.l   #2,d3
 BEQ      Error_CopySprite_End
 CMPI.l   #4,d3
 BNE      ErrTxt17

Error_CopySprite_End
 RTS

Error_LoadSprite:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d0
 BMI      ErrTxt1

 MOVE.l  _B_ObjNum_Sprite(a5),d7
 CMP.l    d0,d7
 BLT      ErrTxt1

 MOVE.l   d0,d7
 LSL.l    #5,d7
 MOVE.l  _B_MemPtr_Sprite(a5),a0
 ADD.l    d7,a0
 TST.l    20(a0)
 BNE      ErrTxt3
 RTS

Error_GrabSprite:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d0
 BMI      ErrTxt1

 MOVE.l  _B_ObjNum_Sprite(a5),d7
 CMP.l    d0,d7
 BLT      ErrTxt1

 MOVE.l   d0,d7
 LSL.l    #5,d7
 MOVE.l  _B_MemPtr_Sprite(a5),a0
 ADD.l    d7,a0
 TST.l    20(a0)
 BNE      ErrTxt3
 RTS

Error_RemoveCookie:
 TST.l   _B_MemPtr_Sprite(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Sprite2(a5)
 BEQ      ErrTxt0
 TST.l   _B_MemPtr_Buffer(a5)
 BEQ      ErrTxt0

 TST.l    d0
 BMI      ErrTxt1

 MOVE.l  _B_ObjNum_Sprite(a5),d7
 CMP.l    d0,d7
 BLT      ErrTxt1

 MOVE.l   d0,d7
 LSL.l    #5,d7
 MOVE.l  _B_MemPtr_Sprite(a5),a0
 ADD.l    d7,a0
 TST.l    20(a0)
 BEQ      ErrTxt2
 RTS

ErrTxt0:  debugerror "Call InitSprite() First or No Error Checking Done"
ErrTxt1:  debugerror "#Sprite out of Range"
ErrTxt2:  debugerror "#Sprite is not Initialized"
ErrTxt3:  debugerror "#Sprite is already Initialized"
ErrTxt4:  debugerror "#Buffer out of Range"
ErrTxt5:  debugerror "#Buffer is not Initialized"
ErrTxt6:  debugerror "#Buffer is already Initialized"
ErrTxt7:  debugerror "No Current SpriteBuffer"
ErrTxt8:  debugerror "MaxDisplayedSprites OverFlow"
ErrTxt9:  debugerror "SpriteBuffer is Full (MaxDisplayedSprites OverFlow)"
ErrTxt10: debugerror "SpriteBuffer is Full (Graphic Data OverFlow) "
ErrTxt11: debugerror "Sprite outside of BitMap (X Axis)"
ErrTxt12: debugerror "Sprite outside of BitMap (Y Axis)"
ErrTxt13: debugerror "Sprite in FastMem, Impossible to Blit"
; ErrTxt14: debugerror ""
ErrTxt15: debugerror "#Sprite out of Range (Param1)"
ErrTxt16: debugerror "#Sprite out of Range (Param2)"
ErrTxt17: debugerror "Chip/Fast should bee #MEMF_CHIP or #MEMF_FAST (2 or 4)"
ErrTxt18: debugerror "#MaxSprites out of Range"
ErrTxt19: debugerror "#MaxDisplayedSprites out of Range"
ErrTxt20: debugerror "#MaxSpriteBuffers out of Range"
ErrTxt21: debugerror "Call StartSpriteServer() First"
ErrTxt22: debugerror "Call StopSpriteServer() First"

 enddebugger


;--------- GrabSprite() -----------------------------------------------------
;  MOVE.l   Gfx(pc),a6          ; use GfxBase
;
;  JSR     _OwnBlitter(a6)      ; ()
;  JSR     _WaitBlit(a6)        ; ()
;
;  MOVE.l   #$dff000, a0        ; CustomBase
;
;  MOVE.l   x(pc),d0      ; ...
;  ANDI.w   #$f,d0        ; ...
;
;  MOVE.w   (a2),d1       ; get \Width
;  ADD.w    d0,d1         ; x in word + width
;  ADD.w    #15,d1        ; ...
;  LSR.w    #4,d1         ; / 16
;
;  CMPI.w   #1,d1         ; only one word
;  BGT      GS_l1         ; nope
;
;  ADDQ.w   #1,d1         ; add extra word
;
;GS_l1
;  MOVE.w   d1,d4         ; get even words
;  ADD.w    d4,d4         ; even words * 2
;  SUBQ.w   #2,d4         ; even bytes - 2
;
;  LSR.w    #4,d2         ; x / 16
;  ADD.w    d2,d2         ; even words to bytes
;  ADD.w    d4,d2         ; + even bytes
;  MOVEQ    #40,d4        ; byte per row
;  SUB.w    d2,d4         ; - x byte pos
;  ADD.w    2(a2),d3      ; y + Height
;  MULU.w   (a3),d3       ; * BytePerRow
;  SUB.l    d4,d3         ; y offset - x offset
;  ADD.l    8(a3),d3      ; BitMap ptr + offset
;  MOVE.l   d3, $50(a0)   ; set BLTAPTR
;
;  MOVEQ    #-1,d4        ; mask
;  MOVE.w   (a2),d2       ; get \Width
;  CMPI.w   #15,d2        ; ...
;  BGT      GS_l0         ; ...
;
;  MOVEQ    #16,d3        ; mask width
;  SUB.w    d2,d3         ; ...
;  LSL.w    d3,d4         ; fwmask lsl width
;
;GS_l0:
;  LSR.w    d0,d4         ; fwmask lsr x
;  SWAP     d4            ; ...
;
;  ADD.w    d0,d2         ; x + width
;  MOVE.w   d1,d3         ; ...
;  LSL.w    #4,d3         ; even words * 16
;  SUB.w    d2,d3         ; epixels - totalwidth
;  LSL.w    d3,d4         ; lwmask lsl ?
;
;  ROR.l    #4,d0               ; ...
;  OR.l     #$bfa0002,d0        ; ...
;  MOVE.l   d0, $40(a0)         ; BLTCON0 & BLTCON1
;
;  SWAP     d4                  ; ...
;  MOVE.l   d4, $44(a0)         ;  BLTFWM & BLTLWM
;
;  MOVE.w  _B_LineLength(a5),d0 ; ...
;  MOVE.w   d1,d7               ; ...
;  ADD.w    d1,d1               ; word to byte
;  SUB.w    d1, d0              ; ...
;  MOVE.w   d0, $64(a0)         ; set BLTAMOD
;
;  MOVE.l   14(a2),d4           ; get \Data
;
;  MOVE.w   8(a2),d0            ; get \ebWidth
;  SUB.w    d1,d0               ; ebWidth - real bwidth
;  MOVE.w   d0,28(a2)
;  BMI      GS_l2               ; ...
;
;  SUB.l    #2,d4               ; ...
;
;GS_l2
;  MOVE.l   d4, $48(a0)         ; set BLTCPTR
;  MOVE.l   d4, $54(a0)         ; set BLTDPTR
;
;  MOVE.w   d0, $60(a0)         ; set BLTCMOD
;  MOVE.w   d0, $66(a0)         ; set BLTDMOD
;
;  MOVE.w   #$ffc0,d0     ; ...
;  AND.w    6(a2),d0      ; get \BltSize
;  OR.w     d7,d0         ; new BltSize
;  MOVE.w   d0, $58(a0)   ; set BLTSIZE
;
;  JSR     _WaitBlit(a6)        ; ()
;  JSR     _DisownBlitter(a6)   ; ()
;----------------------------------------------------------------------------

