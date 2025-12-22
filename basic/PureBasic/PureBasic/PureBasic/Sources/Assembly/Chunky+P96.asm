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
; PB Chunky Lib
;
;  31/03/2001
;    Added all that have to do with chunkysprites and chunkyspritebuffers
;    + debugger support and also updated some functions to go along with
;    that. Some minor bugs corrected in chunkybuffer stuff.
;
;  13/01/2001
;    Added Debugger support
;
;  19/01/2000
;    Changed the ChunkyToPlanar syntax.
;    Optimized the library, especially the function ChunkyBlit()
;    ChunkyCls() is now 3x faster !! See the loop, thanks to the 32 bytes aligned buffer
;    Aligned the memory address to 16 !
;
;  08/12/1999
;    Adapted to PhxAss - Converted for PureBasic
;
;

; To Do:
;
; A function to display the chunky buffer on gfxcard, like
; ShowChunkyBuffer().
;
; Have more flexible Load and Save, like loading from anywhere
; and any number from a file and also saveing more to an old file.
;


 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16

_LibBase      = 0
_ChunkyPtr    = _LibBase
_ObjNum1      = _ChunkyPtr+4
_ObjNum2      = _ObjNum1+4
_ObjNum3      = _ObjNum2+4
_MemPtr1      = _ObjNum3+4
_MemPtr2      = _MemPtr1+4
_MemPtr3      = _MemPtr2+4
_ChunkyCache  = _MemPtr3+4
_BufferPtr    = _ChunkyCache+4
_CurrPos      = _BufferPtr+4
_CurrSprBuf   = _CurrPos+4
_ChunkyBufWid = _CurrSprBuf+4

_P96Base      = _ChunkyBufWid+4
_P96Screen    = _P96Base+4

GetPosition   = _P96Screen+4

; ChunkySprite
; ============
; SprWid.w  : SprHeig.w
; xHandle.w : yHandle.w
; SprSize.l : SprData.l
;
_ChunkySprite       = 0
_SprWid             = _ChunkySprite
_SprHeig            = _SprWid+2
_xHandle            = _SprHeig+2
_yHandle            = _xHandle+2
_SprSize            = _yHandle+2
_SprData            = _SprSize+4

; ChunkySpriteBuffer
; ==================
; Buffer.l : CurrentPos.l ;: ? >> Width.l << ?
;
_ChunkySpriteBuffer = 0
_Buffer             = _ChunkySpriteBuffer
_CurrentPos         = _Buffer+4

; CSB_Item
; --------
; Addr.l : Width.w : Height.w
; Data.b[?]
; PrevItem.l
;
_CSB_Item           = 0
_Addr               = _CSB_Item
_Width              = _Addr+4
_Height             = _Width+4
_Data               = _Height+4
_PrevItem           = 0

; ChunkyBuffer
; ============
; ChunkyBuffer.l : ChunkyBufferPtr.l
; ChunkyCache.l
;
_ChunkyBuffer       = 0
_ChunkyBuf          = _ChunkyBuffer
_ChunkyBufPtr       = _ChunkyBuf+4
_ChunkyCatch        = _ChunkyBufPtr+4


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


 initlib "Chunky", "Chunky", "FreeChunkys", 0, 1, 0

;
; The functions...
;

 name      "FreeChunkys", "()"
 flags
 amigalibs _ExecBase, a6
 params
 debugger   0

  ADDQ.l   #4,a5            ; ...

  MOVE.l  _MemPtr1-4(a5),d7 ; ...
  BEQ      FCs_End          ; ...

  MOVE.l   (a5)+,d2         ; get objnum1
  MOVE.l   d7,a2            ; ...

FCs_loop0
  MOVE.l   12(a2),a1        ; arg1.
  JSR     _FreeVec(a6)      ; (mem) - a1
  ADDA.w   #16,a2           ; ...
  DBRA     d2,FCs_loop0     ; until out of ChunkySprites

  MOVE.l   (a5)+,d2         ; get objnum2

FCs_loop1
  MOVE.l   0(a2),a1         ; arg1.
  JSR     _FreeVec(a6)      ; (mem) - a1
  ADDA.w   #8,a2            ; ...
  DBRA     d2,FCs_loop1     ; until out of ChunkySpriteBuffers

  MOVE.l   (a5)+,d2         ; get objnum3

FCs_loop2                   ; Free all buffers...
  MOVE.l   4(a2),a1         ; arg1.
  JSR     _FreeVec(a6)      ; (mem) - a1
  MOVE.l   8(a2),a1         ; arg1.
  JSR     _FreeVec(a6)      ; (mem) - a1
  ADDA.w   #16,a2           ; ...
  DBRA     d2,FCs_loop2     ; until out of CunkyBuffers

  MOVE.l   d7,a1            ; arg1.
  JSR     _FreeVec(a6)      ; (mem) - a1

; ----- Picasso 96 -----

  MOVE.l  _P96Base-16(a5),d0 ; ...
  BEQ      FCs_End           ; ...

  MOVE.l   d0,a1             ; arg1.
  JMP     _CloseLibrary(a6)  ; (lib) - a1

FCs_End
  RTS

 endfunc   0


 name      "InitChunky", "(#MaxChunkySprites,#MaxChunkySpriteBuffers,#MaxChunkyBuffers)"
 flags
 amigalibs _ExecBase, a6
 params     d2_l, d3_l, d4_l
 debugger   1,_InitChunky_Check

  ADDQ.l   #4,a5            ; ...

  MOVE.l   d2,(a5)+         ; set objnum1
  ADDQ.l   #1,d2            ; ...
  LSL.l    #4,d2            ; ...

  MOVE.l   d3,(a5)+         ; set objnum2
  ADDQ.l   #1,d3            ; ...
  LSL.l    #3,d3            ; ...

  MOVE.l   d4,(a5)+         ; set objnum3
  ADDQ.l   #1,d4            ; ...
  LSL.l    #4,d4            ; ...

  MOVE.l   d2,d0            ; arg1.
  ADD.l    d3,d0            ; add spritebuffers
  ADD.l    d4,d0            ; add chunkybuffers
  MOVE.l   #MEMF_CLEAR, d1  ; Fill memory of '0'
  JSR     _AllocVec(a6)     ; (size,req) - d0/d1

  MOVE.l   d0,(a5)+         ; set memptr1
  BEQ      IC_End           ; ...

  ADD.l    d0,d2            ; ...
  MOVE.l   d2,(a5)+         ; set memptr2
  ADD.l    d2,d3            ; ...
  MOVE.l   d3,(a5)          ; set memptr3

; ----- Picasso 96 -----

  LEA      libname(pc),a1     ; arg1.
  MOVEQ    #2,d0              ; arg2.
  JSR     _OpenLibrary(a6)    ; (name,version) - a1/d0

  MOVE.l   d0,_P96Base-24(a5) ; ...
  BNE      IC_End             ; ...
  MOVEQ    #1,d0              ; ...

IC_End
  RTS

libname: Dc.b "Picasso96API.library",0,0

 endfunc   1

;--------- Picasso96 --------------------------------------------------------

_P96GetBitMapAttr equ  -$2a
_P96LockBitMap    equ  -$30
_P96UnlockBitMap  equ  -$36
_P96OpenScreen    equ  -$5a
_P96CloseScreen   equ  -$60

 name      "OpenP96Screen", "()"
 flags      LongResult
 amigalibs
 params
 debugger   100

  MOVE.l  _P96Base(a5),d0       ; ...
  BEQ      OP96S_End            ; ...

  MOVE.l   d0,a6                ; ...

  LEA      tags(pc),a0          ; arg1.
  JSR     _P96OpenScreen(a6)    ; (tags) - a0

  MOVE.l   d0,_P96Screen(a5)    ; ...

OP96S_End
  RTS

P96SA_Width      equ  (1<<31)+$20000+96+$03
P96SA_Height     equ  (1<<31)+$20000+96+$04
P96SA_Depth      equ  (1<<31)+$20000+96+$05
P96SA_ShowTitle  equ  (1<<31)+$20000+96+$14

tags: Dc.l P96SA_Width,   320
      Dc.l P96SA_Height,  240
      Dc.l P96SA_Depth,     8
      Dc.l P96SA_ShowTitle, Title
      Dc.l 0,0

Title: Dc.b "PureBasic... :)",0

 endfunc 100


 name      "CloseP96Screen", "()"
 flags
 amigalibs
 params
 debugger   101

  MOVE.l  _P96Screen(a5),d0     ; ...
  BEQ      CP96S_End            ; ...

  MOVE.l  _P96Base(a5),a6       ; ...

  MOVE.l   d0,a0                ; arg1.
  JMP     _P96CloseScreen(a6)   ; (p96screen) - a0

CP96S_End
  RTS

 endfunc 101


 name      "ChunkyBufferToP96Screen", "()"
 flags
 amigalibs
 params
 debugger   102

  MOVE.l  _P96Screen(a5),d0     ; ...
  BEQ      CBTP96S_End          ; ...

  MOVE.l   d0,a0                ; use P96Screen
  MOVE.l   88(a0),d7            ; get P96Screen\BitMap ptr
  MOVE.l  _P96Base(a5),a6       ; ...

  MOVE.l   d7,a0                ; arg1.
  SUB.l    a1,a1                ; arg2.
  MOVEQ    #0,d0                ; arg3.
  JSR     _P96LockBitMap(a6)    ; (bitmap,buffer,size) - a0/a1/d0
  MOVE.l   d0,d6                ; save lock

  MOVE.l   d7,a0                ; arg1.
  MOVE.l   #3,d0                ; arg2.
  JSR     _P96GetBitMapAttr(a6) ; (bitmap,attribute_num) - a0/d0

  MOVE.l   #20480,d5            ; loop counter, 320*256/4
  MOVE.l  _ChunkyBuffer(a5),a0  ; get current chunkybuffer
  MOVE.l   d0,a1                ; use memptr from P96GetBitMapAttr

CBTP96S_loop0
  MOVE.l   (a0)+,(a1)+          ; move one long to gfxmem, maybe :)
  SUBQ.l   #1,d5                ; ...
  BNE      CBTP96S_loop0        ; ...

  MOVE.l   d7,a0                ; arg1.
  MOVE.l   d6,d0                ; arg2.
  JMP     _P96UnlockBitMap(a6)  ; (bitmap,lock) - a0/d0

CBTP96S_End
  RTS

 endfunc 102

;----------------------------------------------------------------------------

 name      "LoadChunkySprites","(#ChunkySprite,#ChunkySprite,FileName$)"
 flags      LongResult
 amigalibs _DosBase,a6, _ExecBase,d7
 params     d0_l,d1_l,d2_l
 debugger   2,_LoadChunkySprites_Check

  MOVEM.l   a2-a3,-(a7)     ; ...

  MOVE.l   _MemPtr1(a5),a2  ; ...
  MOVE.l    a2,a3           ; ...
  LSL.l     #4,d0           ; ...
  LSL.l     #4,d1           ; ...
  ADD.l     d0,a2           ; - A2 hold #Sprite (start)
  ADD.l     d1,a3           ; - A3 hold #Sprite  (end)

  MOVE.l    d2,d1           ; arg1.
  MOVE.l    #1005,d2        ; arg2.
  JSR      _Open(a6)        ; (filename,mode) - d1/d2

  MOVE.l    d0,d6           ; save filehandle
  BEQ       LCS_End1        ; ...

  CLR.l     d5              ; sprite counter

LCS_loop0
  MOVE.l    d6,d1           ; arg1.
  MOVE.l    a2,d2           ; arg2.
  MOVEQ     #16,d3          ; arg3.
  JSR      _Read(a6)        ; (file,buffer,length) - d1/d2/d3

  TST.l     12(a2)          ; any sprite gfx, \SprData
  BEQ       LCS_l0          ; nope

  EXG.l     d7,a6           ; use execbase
  MOVE.l    8(a2),d3        ; ...
  SUBQ.l    #8,d3           ; ...
  SUBQ.l    #4,d3           ; ...

  MOVE.l    d3,d0           ; arg1.
  MOVE.l    #MEMF_CLEAR,d1  ; arg2.
  JSR      _AllocVec(a6)    ; (size,req) - d0/d1

  EXG.l     d7,a6           ; use dosbase
  MOVE.l    d0,12(a2)       ; set \SprData
  BEQ       LCS_End0        ; ...

  MOVE.l    d6,d1           ; arg1.
  MOVE.l    d0,d2           ; arg2.
  MOVE.l    d3,d3           ; arg3.
  JSR      _Read(a6)        ; (file,buffer,length) - d1/d2/d3

  ADDQ.l    #1,d5           ; inc sprite counter

LCS_l0
  CMPA.l    a3,a2           ; any more sprite to load
  BGE       LCS_End0        ; nope

  LEA       16(a2),a2       ; inc #Sprite
  BRA       LCS_loop0       ; ...

LCS_End0
  MOVE.l    d6,d1           ; arg1.
  JSR      _Close(a6)       ; (file) - d1

  MOVE.l    d5,d0           ; return sprite counter

LCS_End1
  MOVEM.l   (a7)+,a2-a3     ; ...
  RTS

 endfunc 2


 name      "SaveChunkySprites","(#ChunkySprite,#ChunkySprite,FileName$)"
 flags      LongResult
 amigalibs _DosBase,a6
 params     d0_l,d1_l,d2_l
 debugger   3,_SaveChunkySprites_Check

  MOVEM.l   a2-a3,-(a7)     ; ...

  MOVE.l   _MemPtr1(a5),a2  ; ...
  MOVE.l    a2,a3           ; ...
  LSL.l     #4,d0           ; ...
  LSL.l     #4,d1           ; ...
  ADD.l     d0,a2           ; - A2 hold #Sprite (start)
  ADD.l     d1,a3           ; - A3 hold #Sprite  (end)

  MOVE.l    d2,d1           ; arg1.
  MOVE.l    #1006,d2        ; arg2.
  JSR      _Open(a6)        ; (filename,mode) - d1/d2

  MOVE.l    d0,d7           ; save filehandle
  BEQ       SCS_End1        ; ...

  CLR.l     d6              ; sprite counter

SCS_loop0
  MOVE.l    d7,d1           ; arg1.
  MOVE.l    a2,d2           ; arg2.
  MOVEQ     #16,d3          ; arg3.
  JSR      _Write(a6)       ; (file,buffer,length) - d1/d2/d3

  MOVE.l    12(a2),d0       ; get \SprData
  BEQ       SCS_l0          ; ...

  MOVE.l    d7,d1           ; arg1.
  MOVE.l    d0,d2           ; arg2.
  MOVE.l    8(a2),d3        ; arg3.
  SUBQ.l    #8,d3           ; ...
  SUBQ.l    #4,d3           ; ...
  JSR      _Write(a6)       ; (file,buffer,length) - d1/d2/d3

  ADDQ.l    #1,d6           ; inc sprite counter

SCS_l0
  CMPA.l    a3,a2           ; any more sprite to save
  BGE       SCS_End0        ; nope

  LEA       16(a2),a2       ; inc #Sprite
  BRA       SCS_loop0       ; ...

SCS_End0
  MOVE.l    d7,d1           ; arg1.
  JSR      _Close(a6)       ; (file) - d1

  MOVE.l    d6,d0           ; return sprite counter

SCS_End1
  MOVEM.l   (a7)+,a2-a3     ; ...
  RTS

 endfunc 3


 name      "GrabChunkySprite","(#ChunkySprite,BitMapID,x,y,Width,Height)"
 flags      LongResult
 amigalibs _ExecBase,a6
 params     d0_l,d1_l,d2_l,d3_l,d4_l,d5_l
 debugger   4,_GrabChunkySprite_Check

  MOVEM.l  a2-a3,-(a7)      ; ...

  MOVE.l  _MemPtr1(a5),a2   ; get memptr1
  LSL.l    #4,d0            ; calc offset
  ADD.l    d0,a2            ; - A2 hold #ChunkySprite

  MOVE.l   d1,a3            ; use BitMapID
  MOVE.w   d4,d6            ; ...
  MULU.w   d5,d6            ; ...
  ADDQ.l   #1,d6            ; ...
  ANDI.w   #$fffe,d6        ; make it word align

  MOVE.l   d6,d0            ; arg1.
  MOVE.l   #MEMF_CLEAR,d1   ; arg2.
  JSR     _AllocVec(a6)     ; (size,req) - d0/d1

  MOVE.w   d4,(a2)+         ; set \SprWid
  MOVE.w   d5,(a2)+         ; set \SprHeig
  CLR.l    (a2)+            ; clr \xHandle and \yHandle
  MOVEQ    #12,d1           ; CBS_Item size
  ADD.l    d1,d6            ; ...
  MOVE.l   d6,(a2)+         ; set \SprSize
  MOVE.l   d0,(a2)          ; set \SprData
  BEQ      GCS_End          ; ...

  LEA      GCS_Data(pc),a0  ; ...
  CLR.l    (a0)+            ; clr offset1

  MOVE.w   0(a3),d0         ; get \BytesPerRow
  MOVE.l   d2,d1            ; ...
  LSR.l    #3,d1            ; x / 8
  MULU.w   d0,d3            ; y * \BytesPerRow
  ADD.l    d1,d3            ; + x bytes
  MOVE.l   d3,(a0)+         ; set offset2

  SUBQ.w   #1,d5            ; Height - 1
  MOVE.w   d5,(a0)+         ; set height

  MOVE.l   d1,d5            ; ...
  LSL.l    #3,d5            ; ...
  MOVE.l   d2,d6            ; use x
  SUB.l    d5,d6            ; pixel pos
  MOVE.l   d4,d5            ; use Width
  ADDQ.l   #7,d5            ; + 7
  ADD.l    d6,d5            ; + pixel pos
  LSR.l    #3,d5            ; / 8
  SUBQ.w   #1,d5            ; ...
  MOVE.w   d5,(a0)+         ; set bytes
  ADDQ.l   #4,a0            ; ...
  MOVE.b   d6,(a0)+         ; set shift

  TST.w    d5               ; ...
  BNE      GCS_l0           ; ...

  MOVE.w   d4,d7            ; use Width
  SUBQ.w   #1,d7            ; ...
  BRA      GCS_l1           ; ...

GCS_l0
  MOVEQ    #7,d7            ; ...
  SUB.b    d6,d7            ; ...

GCS_l1
  MOVE.b   d7,(a0)+         ; set bytewid1

  MOVE.l   d5,d3            ; use later in loop

  LSL.l    #3,d3            ; ...
  ADD.l    d2,d3            ; ...
  ANDI.w   #$fff8,d3        ; ...
  ADD.l    d2,d4            ; ...
  SUB.l    d3,d4            ; ...
  SUBQ.w   #1,d4            ; ...
  MOVE.b   d4,(a0)+         ; set bytewid2

  MOVE.b   #1,(a0)          ; set pixelpos

  MOVE.l   d5,d3            ; ...
  MOVEQ    #0,d7            ; ...
  MOVE.b   5(a3),d7         ; get \Depth
  SUBQ.l   #1,d7            ; depth counter
  LEA      GCS_Data(pc),a0  ; ...

GCS_loop0
  MOVE.l   (a0)+,d0         ; get offset1
  MOVE.l   8(a3,d0),d0      ; get a bitmap ptr
  ADD.l    (a0)+,d0         ; bitmap ptr + offset2
  MOVE.l   d0,4(a0)         ; set realptr
  MOVE.w   (a0),d6          ; get height
  MOVE.l   (a2),a1          ; get \Data

GCS_loop1
  MOVEQ    #0,d0            ; ...
  MOVE.w   bytes(pc),d5     ; width_in_bytes counter
  MOVE.l   realptr(pc),a0   ; get realptr

GCS_loop2
  MOVE.b   (a0)+,d1         ; get one gfx byte
  MOVEQ    #7,d4            ; byte_width counter

  CMP.w    d3,d5            ; is it start byte
  BNE      GCS_l2           ; nope

  MOVE.b   shift(pc),d0     ; get shift
  LSL.b    d0,d1            ; put it right
  MOVE.b   bytewid1(pc),d4  ; new byte_width counter
  BRA      GCS_l3           ; ...

GCS_l2
  CMPI.w   #0,d5            ; is it stop byte
  BNE      GCS_loop3        ; nope
  MOVE.b   bytewid2(pc),d4  ; new byte_width counter

GCS_l3
  MOVE.b   pixelpos(pc),d0  ; chunkypixel pos

GCS_loop3
  LSL.b    #1,d1            ; extract one pixel
  MOVEQ    #0,d2            ; clr from old pixel
  ROXL.b   d0,d2            ; put pixel in place
  OR.b     d2,(a1)+         ; add to chunky pixel
  DBRA     d4,GCS_loop3     ; dec byte_width counter

  DBRA     d5,GCS_loop2     ; dec width_in_bytes

  LEA      realptr(pc),a0   ; ...
  MOVE.w   0(a3),d0         ; get \BytesPerRow
  EXT.l    d0               ; ...
  ADD.l    d0,(a0)          ; inc to next row
  DBRA     d6,GCS_loop1     ; dec height

  LEA      GCS_Data(pc),a0  ; ...
  ADDQ.l   #4,(a0)          ; inc offset1
  ADDQ.b   #1,19(a0)        ; inc pixelpos
  DBRA     d7,GCS_loop0     ; dec depth

  MOVE.l   a2,d0            ; return #ChunkySprite

GCS_End
  MOVEM.l  (a7)+,a2-a3      ; ...
  RTS

GCS_Data
offset1:  Dc.l  0
offset2:  Dc.l  0
height:   Dc.w  0
bytes:    Dc.w  0
realptr:  Dc.l  0
shift:    Dc.b  0
bytewid1: Dc.b  0
bytewid2: Dc.b  0
pixelpos: Dc.b  0

 endfunc 4


 name      "CopyChunkySprite","(#ChunkySprite,#ChunkySprite)"
 flags      LongResult
 amigalibs _ExecBase,a6
 params     d0_l,d1_l
 debugger   5,_CopyChunkySprite_Check

  MOVEM.l  a2-a3,-(a7)     ; save A2 A3

  MOVE.l  _MemPtr1(a5),a2  ; get memptr1
  MOVE.l   a2,a3           ; get memptr1
  LSL.l    #4,d0           ; calc offset
  LSL.l    #4,d1           ; calc offset
  ADD.l    d0,a2           ; A2 hold #ChunkySprite
  ADD.l    d1,a3           ; A3 hold #ChunkySprite

  MOVEM.w  (a2)+,d2-d3     ; get \SprWid and \SprHeig
  MOVEM.w  d2-d3,(a3)      ; set \SprWid and \SprHeig
  ADDQ.l   #4,a3           ; ...
  MOVE.l   (a2)+,(a3)+     ; copy \xHandle and \yHandle

  MOVE.l   (a2)+,d0        ; arg1.
  MOVE.l   d0,(a3)+        ; set \SprSize
  SUBQ.l   #8,d0           ; ...
  SUBQ.l   #4,d0           ; ...
  MOVE.l   #MEMF_CLEAR,d1  ; arg2.
  JSR     _AllocVec(a6)    ; (size,req) - d0/d1

  MOVE.l   d0,(a3)         ; set \SprData
  BEQ      CCS_End         ; ...

  MULU.w   d2,d3           ; calc num of bytes
  SUBQ.w   #1,d3           ; fix byte counter
  MOVE.l   (a2),a0         ; use \SprData
  MOVE.l   d0,a1           ; ...

CCS_loop0
  MOVE.b   (a0)+,(a1)+     ; move a chunky pix
  DBRA     d3,CCS_loop0    ; until out of bytes

CCS_End
  MOVEM.l  (a7)+,a2-a3     ; restore A2 A3
  RTS

 endfunc 5


 name      "ChunkySpriteWidth","(#ChunkySprite)"
 flags
 amigalibs _ExecBase,a6
 params     d0_l
 debugger   6,_ChunkySpriteWidth_Check

  MOVE.l  _MemPtr1(a5),a0  ; ...
  LSL.l    #4,d0           ; ...
  ADD.l    d0,a0           ; ...
  MOVE.w   0(a0),d0        ; get /SprWid
  RTS

 endfunc 6


 name      "ChunkySpriteHeight","(#ChunkySprite)"
 flags
 amigalibs _ExecBase,a6
 params     d0_l
 debugger   7,_ChunkySpriteHeight_Check

  MOVE.l  _MemPtr1(a5),a0  ; ...
  LSL.l    #4,d0           ; ...
  ADD.l    d0,a0           ; ...
  MOVE.w   2(a0),d0        ; get /SprHeig
  RTS

 endfunc 7


 name      "ChunkySpriteHandle","(#ChunkySprite,x,y)"
 flags
 amigalibs _ExecBase,a6
 params     d0_l,d1_w,d2_w
 debugger   8,_ChunkySpriteHandle_Check

  MOVE.l  _MemPtr1(a5),a0  ; ...
  LSL.l    #4,d0           ; ...
  ADD.l    d0,a0           ; ...
  MOVEM.w  d1-d2,4(a0)     ; set \xHandle and \yHandle
  RTS

 endfunc 8


 name      "DisplayChunkySpriteBlock","(#ChunkySprite,x,y)"
 flags
 amigalibs
 params     d0_l,d1_l,d2_l
 debugger   9,_DisplayChunkySpriteBlock_Check

  MOVE.l  _MemPtr1(a5),a0   ; get memptr1
  LSL.l    #4,d0            ; calc offset
  ADD.l    d0,a0            ; - A0 hold #ChunkySprite

  MOVEA.l _ChunkyPtr(a5),a1 ; ...
  MOVEQ    #0,d4            ; ...
  MOVE.w   -4(a1),d4        ; Get the ChunkyWidth
  MULU.w   d4,d2            ; calc y
  ADD.l    d2,a1            ; add y
  ANDI.w   #$fff8,d1        ; x is long align
  ADD.l    d1,a1            ; add x

  MOVE.w   (a0)+,d2         ; get \SprWid
  SUB.w    d2,d4            ; calc chunky modulo
  LSR.w    #2,d2            ; sprwid / 4
  SUBQ.w   #1,d2            ; fix long counter
  MOVE.w   (a0),d7          ; get \SprHeig
  SUBQ.w   #1,d7            ; fix height counter
  MOVE.l  _SprData-2(a0),a0 ; get \SprData

DCBS_loop0
  MOVE.w   d2,d6            ; ...

DCBS_loop1
  MOVE.l   (a0)+,(a1)+      ; put four chunky pixel
  DBRA     d6,DCBS_loop1    ; until out of longs

  ADD.l    d4,a1            ; next line
  DBRA     d7,DCBS_loop0    ; until out of rows

  RTS

 endfunc 9


 name      "DisplayTransparantChunkySprite","(#ChunkySprite,x,y)"
 flags
 amigalibs
 params     d0_l,d1_l,d2_l
 debugger   10,_DisplayTransparantChunkySprite_Check

  MOVE.l  _MemPtr1(a5),a0   ; get memptr1
  LSL.l    #4,d0            ; calc offset
  ADD.l    d0,a0            ; - A0 hold #ChunkySprite

  MOVE.w   (a0)+,d3         ; get \SprWid
  MOVE.w   (a0)+,d7         ; get \SprHeig
  SUBQ.w   #1,d7            ; fix height counter

  SUB.w    (a0)+,d1         ; x - \xHandle
  SUB.w    (a0),d2          ; y - \yHandle

  MOVEA.l _ChunkyPtr(a5),a1 ; ...
  MOVEQ    #0,d4            ; ...
  MOVE.w   -4(a1),d4        ; Get the ChunkyWidth
  MULU.w   d4,d2            ; calc y
  ADD.l    d1,a1            ; add x
  ADD.l    d2,a1            ; add y

  SUB.w    d3,d4            ; calc modulo
  SUBQ.w   #1,d3            ; fix width counter
  MOVE.l  _SprData-6(a0),a0 ; get \SprData

DTCS_loop0
  MOVE.w   d3,d6            ; use width counter

DTCS_loop1
  MOVE.b   (a0)+,(a1)+      ; put one chunky pixel
  DBRA     d6,DTCS_loop1    ; until out of bytes

  ADD.l    d4,a1            ; next line
  DBRA     d7,DTCS_loop0    ; until out of rows

  RTS

 endfunc 10


 name      "DisplayChunkySprite","(#ChunkySprite,x,y)"
 flags
 amigalibs
 params     d0_l,d1_l,d2_l
 debugger   11,_DisplayChunkySprite_Check

  MOVE.l  _MemPtr1(a5),a0   ; get memptr1
  LSL.l    #4,d0            ; calc offset
  ADD.l    d0,a0            ; - A0 hold #ChunkySprite

  MOVE.w   (a0)+,d3         ; get \SprWid
  SUBQ.w   #1,d3            ; fix width counter
  MOVE.w   (a0)+,d7         ; get \SprHeig
  SUBQ.w   #1,d7            ; fix height counter

  SUB.w    (a0)+,d1         ; x - \xHandle
  SUB.w    (a0),d2          ; y - \yHandle

  MOVEA.l _ChunkyPtr(a5),a1 ; ...
  MOVEQ    #0,d4            ; ...
  MOVE.w   -4(a1),d4        ; Get the ChunkyWidth
  MULU.w   d4,d2            ; calc y
  ADD.l    d1,a1            ; add x
  ADD.l    d2,a1            ; add y
  MOVE.l  _SprData-6(a0),a0 ; get \SprData

DCS_loop0
  MOVEQ    #0,d2            ; ...
  MOVE.w   d3,d6            ; use width counter

DCS_loop1
  MOVE.b   (a0)+,d1         ; get one chunky pixel
  BEQ      DCS_l0           ; its transparent color
  MOVE.b   d1,0(a1,d2)      ; put pixel in chunkybuffer

DCS_l0
  ADDQ.l   #1,d2            ; ...
  DBRA     d6,DCS_loop1     ; until out of bytes

  ADD.l    d4,a1            ; next line
  DBRA     d7,DCS_loop0     ; until out of rows

  RTS

 endfunc 11


 name      "DisplayBufferedChunkySprite","(#ChunkySprite,x,y)"
 flags
 amigalibs
 params     d0_l,d1_l,d2_l
 debugger   12,_DisplayBufferedChunkySprite_Check

  MOVE.l   a2,-(a7)         ; ...

  MOVE.l  _MemPtr1(a5),a2   ; get memptr1
  LSL.l    #4,d0            ; calc offset
  ADD.l    d0,a2            ; - A2 hold #ChunkySprite

  MOVE.w   (a2)+,d3         ; get \SprWid
  MOVE.w   (a2)+,d7         ; get \SprHeig
  SUBQ.w   #1,d7            ; ...

  SUB.w    (a2)+,d1         ; x - \xHandler
  SUB.w    (a2)+,d2         ; y - \yHandler

  MOVEA.l _ChunkyPtr(a5),a0 ; ...
  MOVE.l   a0,d6            ; ...
  MOVEQ    #0,d4            ; ...
  MOVE.w   -4(a0),d4        ; Get the ChunkyWidth
  MULU.w   d4,d2            ; calc y
  ADD.l    d1,d6            ; add x
  ADD.l    d2,d6            ; add y

  MOVE.l   d4,d5            ; modulo2
  SUB.w    d3,d4            ; calc modulo1

  MOVE.l  _CurrPos(a5),a0   ; ...
  MOVE.l   a0,a1            ; ...
  ADD.l    (a2)+,a1         ; add \SprSize
  MOVE.l   a0,(a1)+         ; ...
  MOVE.l   a1,_CurrPos(a5)  ; ...
  MOVE.l   (a2),a2          ; get \SprData

  MOVE.l   d6,(a0)+         ; ...
  MOVE.w   d3,(a0)+         ; ...
  SUBQ.w   #1,d3            ; ...
  MOVE.w   d7,(a0)+         ; ...

  MOVE.l   d7,d2            ; ...
  MOVE.l   d6,a1            ; ...

DBCS_loop0
  MOVE.w   d3,d1            ; width counter

DBCS_loop1
  MOVE.b   (a1)+,(a0)+      ; save one chunky pixel
  DBRA     d1,DBCS_loop1    ; until out of bytes

  ADD.l    d4,a1            ; next line
  DBRA     d2,DBCS_loop0    ; until out of rows

  MOVE.l   d6,a1            ; ...

DBCS_loop2
  MOVEQ    #0,d1            ; ...
  MOVE.w   d3,d4            ; width counter

DBCS_loop3
  MOVE.b   (a2)+,d2         ; get one chunky pixel
  BEQ      DBCS_l0          ; its transparent color
  MOVE.b   d2,0(a1,d1)      ; put pixel in chunkybuffer

DBCS_l0
  ADDQ.l   #1,d1            ; ...
  DBRA     d4,DBCS_loop3    ; until out of bytes

  ADD.l    d5,a1            ; next line
  DBRA     d7,DBCS_loop2    ; until out of rows

  MOVE.l   (a7)+,a2         ; ...
  RTS

 endfunc 12


 name      "FreeChunkySprite","(#ChunkySprite)"
 flags      LongResult
 amigalibs _ExecBase,a6
 params     d0_l
 debugger   13,_FreeChunkySprite_Check

  MOVE.l  _MemPtr1(a5),a0   ; ...
  LSL.l    #4,d0            ; ...
  ADD.l    d0,a0            ; ...

  MOVE.l  _SprData(a0),a1   ; arg1.
  CLR.l   _SprData(a0)      ; clr \SprData
  JMP     _FreeVec(a6)      ; (mem) - a1

 endfunc 13


 name      "CreateChunkySpriteBuffer","(#ChunkySpriteBuffer,Size)"
 flags      LongResult
 amigalibs _ExecBase,a6
 params     d0_l,d1_l
 debugger   14,_CreateChunkySpriteBuffer_Check

  MOVE.l   a2,d7            ; ...

  LSL.l    #3,d0            ; calc offset
  MOVE.l  _MemPtr2(a5),a2   ; get memptr2
  ADD.l    d0,a2            ; - A2 hold #ChunkySpriteBuffer

  MOVE.l   d1,d0            ; arg1.
  MOVE.l   #MEMF_CLEAR,d1   ; arg2.
  JSR     _AllocVec(a6)     ; (size,flags) - d0/d1
  MOVE.l   d0,(a2)          ; set \Buffer
  BEQ      CCSB_End         ; no mem

  MOVE.l   d0,_CurrentPos(a2) ; set \CurrentPos
  MOVE.l   d0,_BufferPtr(a5)  ; set bufferptr
  MOVE.l   d0,_CurrPos(a5)    ; set currpos
  MOVE.l   a2,_CurrSprBuf(a5) ; set currsprbuf

CCSB_End
  MOVE.l   d7,a2            ; ...
  RTS

 endfunc 14


 name      "UseChunkySpriteBuffer","(#ChunkySpriteBuffer)"
 flags      LongResult
 amigalibs
 params     d0_l
 debugger   15,_UseChunkySpriteBuffer_Check

  LSL.l    #3,d0            ; ...
  MOVE.l  _MemPtr2(a5),a0   ; ...
  ADD.l    d0,a0            ; ...

  MOVEM.l  (a0),d0-d1                  ; ...

  MOVE.l  _CurrSprBuf(a5),a1           ; get currsprbuf
  MOVE.l  _CurrPos(a5),_CurrentPos(a1) ; set \CurrentPos

  MOVEM.l  d0-d1/a0,_BufferPtr(a5)     ; ...
  RTS

 endfunc 15


 name      "FlushChunkySpriteBuffer","(#ChunkySpriteBuffer)"
 flags
 amigalibs
 params     d0_l
 debugger   16,_FlushChunkySpriteBuffer_Check

  LSL.l    #3,d0                       ; ...
  MOVE.l  _MemPtr2(a5),a0              ; ...
  ADD.l    d0,a0                       ; ...

  MOVE.l   (a0),_CurrentPos(a0)        ; ...

  CMPA.l  _CurrSprBuf(a5),a0           ; ...
  BNE      FCSB_End                    ; ...
  MOVE.l   (a0),_CurrPos(a5)           ; ...

FCSB_End
  RTS

 endfunc 16


 name      "FreeChunkySpriteBuffer","(#ChunkySpriteBuffer)"
 flags
 amigalibs _ExecBase,a6
 params     d0_l
 debugger   17,_FreeChunkySpriteBuffer_Check

  LSL.l    #3,d0             ; ...
  MOVE.l  _MemPtr2(a5),a0    ; ...
  ADD.l    d0,a0             ; ...

  CMPA.l  _CurrSprBuf(a5),a0 ; ...
  BNE      FCSB_l0           ; ...
  CLR.l   _CurrSprBuf(a5)    ; ...

FCSB_l0
  MOVE.l   (a0),a1           ; arg1.
  CLR.l    (a0)              ; clr \Buffer
  JMP     _FreeVec(a6)       ; (memptr) - a1

 endfunc 17


 name      "AllocateChunkyBuffer", "(#ChunkyBuffer, Width, Height)"
 flags      LongResult
 amigalibs _ExecBase, a6
 params     d0_l, d2_w, d3_w
 debugger   18, _NewCheck

  MOVE.l   a3,-(a7)            ;
  JSR      GetPosition(a5)     ;
  MOVE.w   d3,d0               ;
  MULU     d2,d0               ; Get Buffer Lenght
  ADD.l    #56,d0              ; Extra Buffer Size (32 for alignement and 4 for width/height)
  MOVE.l   #MEMF_CLEAR, d1     ;
  JSR     _AllocVec(a6)        ; (Size, Flags) - d0/d1
  MOVE.l   d0,4(a3)            ; Set Buffer PTR
  BEQ      ACB_End1            ; ...

  ADD.l    #19,d0              ; Align to 16 (15+4)
  AND.b    #$F0,d0             ;
  MOVE.l   d0,a1               ;
  SUBQ.l   #4,a1               ;
  MOVE.w   d2,(a1)+            ; Use previously saved Width
  MOVE.w   d3,(a1)+            ; Use previously saved Height
  MOVE.l   a1,_ChunkyPtr(a5)   ; Set Current Buffer PTR
  MOVE.l   a1,(a3)             ;
  EXT.l    d3                  ;
  MOVE.l   d3,d0               ; Number of line * 4
  LSL.l    #2,d0               ; Now, allocate our special buffer which store the address of each line in
  MOVEQ.l  #0, d1              ; the chunky buffer (to avoid mulu in point(), plot(), chunkyBlit...)
  JSR     _AllocVec(a6)        ; (Size, Flags) - d0/d1
  MOVE.l   d0,8(a3)            ; Store the cache pointer to the bank
  BEQ      ACB_End0            ;

  MOVE.l   d0,_ChunkyCache(a5) ;
  MOVE.l   d0,a0               ;
  MOVE.l   (a3),d0             ;
  MOVE.l   d0,d1               ;
_FillCache:                    ;
  MOVE.l   d1,(a0)+            ; Fill the cache with suited values, so we could access a particular line like
  ADD.l    d2,d1               ; this: MOVEA.l cache(a5),a0 : MOVEA.l nbline*4(a0),a0
  SUBQ.l   #1,d3               ; instead of a bad MULU
  BNE     _FillCache           ;
  BRA      ACB_End1            ;

ACB_End0
  MOVE.l   4(a3),a1            ; arg1.
  CLR.l    4(a3)               ; ...
  JSR     _FreeVec(a6)         ; (mem) - a1
  MOVEQ    #0,d0               ; ...

ACB_End1
  MOVE.l   (a7)+,a3            ;
  RTS

 endfunc   18


 name      "UseChunkyBuffer", "(#ChunkyBuffer)"
 flags
 amigalibs
 params     d0_w
 debugger   19, _ExistCheck

  MOVE.l   a3,-(a7)
  JSR      GetPosition(a5)
  MOVE.l   (a3),d0
  MOVE.l   d0,_ChunkyPtr(a5)  ; ChunkyBuf PTR
  MOVE.l   (a7)+, a3
  RTS

 endfunc    19


 name      "ChunkyBufferID", "()"
 flags      LongResult
 amigalibs
 params
 debugger   20

  MOVE.l  _ChunkyPtr(a5), d0
  RTS

 endfunc    20


 name      "RestoreChunkyBuffer","()"
 flags
 amigalibs
 params
 debugger   21,_RestoreChunkyBuffer_Check

  MOVE.l   a2,d7               ; ...

  MOVE.l  _ChunkyPtr(a5),a0    ; ...
  MOVE.w   -4(a0),d6           ; ...
  EXT.l    d6                  ; ...

  LEA     _BufferPtr(a5),a5    ; ...
  MOVEM.l  (a5),d5/a2          ; ...

RCB_loop0
  CMP.l    a2,d5               ; ...
  BEQ      RCB_End             ; ...

  MOVE.l   -4(a2),a2           ; ...

  MOVE.l   a2,a0               ; ...
  MOVE.l   (a0)+,a1            ; ...
  MOVE.l   d6,d2               ; ...
  MOVE.w   (a0)+,d1            ; ...
  SUB.w    d1,d2               ; ...
  SUBQ.w   #1,d1               ; ...
  MOVE.w   (a0)+,d4            ; ...

RCB_loop1
  MOVE.w   d1,d3               ; ...

RCB_loop2
  MOVE.b   (a0)+,(a1)+         ; restore one chunky pixel
  DBRA     d3,RCB_loop2        ; until out of bytes

  ADD.l    d2,a1               ; next line
  DBRA     d4,RCB_loop1        ; until out of rows

  BRA      RCB_loop0           ; ...

RCB_End
  ADDQ.l   #4,a5               ; ...
  MOVE.l   a2,(a5)+            ; ...
  MOVE.l   (a5),a0             ; ...
  MOVE.l   a2,_CurrentPos(a0)  ; ...

  MOVE.l   d7,a2               ; ...
  RTS

 endfunc 21


 name      "ShowChunkyBuffer","()"
 flags      LongResult
 amigalibs
 params
 debugger   22

  RTS

 endfunc 22


 name      "FreeChunkyBuffer", "(#ChunkyBuffer)"
 flags
 amigalibs _ExecBase, a6
 params     d0_w
 debugger   23, _ExistCheck

  MOVE.l   a3,-(a7)            ;
  JSR      GetPosition(a5)     ; Input: d0 - Output: a1 = *Buf, a3 store the current pos.
  ADDQ.l   #4,a3               ;
  MOVE.l   (a3), a1            ;
  CLR.l    (a3)+               ;
  JSR     _FreeVec(a6)         ; - a1
  MOVE.l   (a3), a1            ;
  CLR.l    (a3)                ;
  MOVE.l   (a7)+,a3            ;
  JMP     _FreeVec(a6)         ; - a1

 endfunc    23


 name      "ChunkyCls", "(Color)"
 flags
 amigalibs
 params     d0_w
 debugger   24, _CurrentCheck

  MOVEA.l _ChunkyPtr(a5)   , a0
  MOVE.w  -4(a0), d1  ;
  MOVE.w  -2(a0), d2  ;
  MULU.w   d1, d2                ; Calculate Buffer Lenght

  MOVE.l   d0, d3
  LSL.l    #8, d3
  OR.b     d0, d3
  LSL.l    #8, d3
  OR.b     d0, d3
  LSL.l    #8, d3
  OR.b     d0, d3
  LSL.l    #8, d3
  OR.b     d0, d3

_Loop:
  MOVE.l   d3, (a0)+              ; Whow, mega loop, 32 bytes aligned which provide
  MOVE.l   d3, (a0)+              ; a great speed increase about a standard loop
  MOVE.l   d3, (a0)+              ; (about 3 times faster).
  MOVE.l   d3, (a0)+              ;
  MOVE.l   d3, (a0)+              ;
  MOVE.l   d3, (a0)+              ;
  MOVE.l   d3, (a0)+              ;
  MOVE.l   d3, (a0)+              ;
  SUB.l    #32, d2                ;
  BGT     _Loop                   ;
  RTS

 endfunc    24


 name      "ChunkyPlot", "(x, y, Color)"
 flags
 amigalibs
 params     d0_w, d1_w, d2_w
 debugger   25, _CurrentCheck

  MOVEA.l _ChunkyPtr(a5), a0
  MOVE.w  -4(a0), d3
  MULU.w   d3, d1              ; Get X,Y pos
  ADD.l    d1, a0              ;
  ADD.w    d0, a0              ;
  MOVE.b   d2, (a0)
  RTS

 endfunc    25


 name      "FastChunkyPlot", "(x, y, colour)"
 flags
 amigalibs
 params     d0_w, d1_l, d2_w
 debugger   26, _CurrentCheck

  MOVEA.l _ChunkyCache(a5), a0
  LSL.l    #2,d1
  ADD.l    d1,a0
  MOVE.l   (a0), a0
  ADD.w    d0, a0
  MOVE.b   d2, (a0)
  RTS

 endfunc    26


 name      "ChunkyToPlanar", "(ChunkyID, BitMapID, Height)"
 flags
 amigalibs
 params     a0_l, d0_l, d1_w
 debugger   27

C2P.020_030.1.1.256c:
    movem.l a2-a5,-(a7)
    ADD.l   #40, d0             ; BitMapID()+40
    MULU.w  #320, d1            ;
    LSR.l   #5, d1              ; Right calculation (Width*Height/32)-2
    SUBQ.w  #2, d1              ;
    LEA.l   Screen(pc),a1       ;
    MOVE.l  d0,(a1)+            ; Screen
    MOVE.l  a0,(a1)+            ; CnkScreen
    MOVE.w  d1, (a1) ; Size
    ;lea CnkScreen,a0
    move.l  Screen(pc),a1    ; was screen+4
    add.l   #320*256/8*4,a1

    move.l  #$f0f0f0f0,d6
    move.l  #$cccccccc,a4
    move.l  #$ff00ff00,a5
    move.l  #$aaaaaaaa,a6

** Demarage de la boucle

    move.l  (a0)+,d0
    and.l   d6,d0
    move.l  (a0)+,d5
    and.l   d6,d5
    lsr.l   #4,d5
    or.l    d5,d0           ;d0 = AEBFCGDH 8765

    move.l  (a0)+,d1
    and.l   d6,d1
    move.l  (a0)+,d5
    and.l   d6,d5
    lsr.l   #4,d5
    or.l    d5,d1           ;d1 = IMJNKOLP 8765

    move.l  (a0)+,d2
    and.l   d6,d2
    move.l  (a0)+,d5
    and.l   d6,d5
    lsr.l   #4,d5
    or.l    d5,d2           ;d2 = A'E'B'F'C'G'D'H' 8765

    move.l  (a0)+,d3
    and.l   d6,d3
    move.l  (a0)+,d5
    and.l   d6,d5
    lsr.l   #4,d5
    or.l    d5,d3           ;d3 = I'M'J'N'K'O'L'P' 8765

    swap    d2
    swap    d3
    eor.w   d0,d2
    eor.w   d1,d3
    eor.w   d2,d0
    eor.w   d3,d1
    eor.w   d0,d2
    eor.w   d1,d3
    swap    d2          ;d2 = CGDHC'G'D'H' 8765
    swap    d3          ;d3 = KOLPK'O'L'P' 8765

    move.l  a4,d5           ;chargement du masque

    move.l  d0,d4
    lsl.l   #2,d4
    eor.l   d2,d4
    and.l   d5,d4
    eor.l   d4,d2           ;d2 = ACEGBDFHA'C'E'G'B'D'F'H' 65
    lsr.l   #2,d4
    eor.l   d4,d0           ;d0 = ACEGBDFHA'C'E'G'B'D'F'H' 87

    move.l  d1,d4
    lsl.l   #2,d4
    eor.l   d3,d4
    and.l   d5,d4
    eor.l   d4,d3           ;d3 = IKMOJLNPI'K'M'O'J'L'N'P' 65
    lsr.l   #2,d4
    eor.l   d4,d1           ;d1 = IKMOJLNPI'K'M'O'J'L'N'P' 87

    move.l  a5,d5           ;chargement du masque

    move.l  d0,d4
    lsl.l   #8,d4
    eor.l   d1,d4
    and.l   d5,d4
    eor.l   d4,d1           ;d1 = BDFHJLNPB'D'F'H'J'L'N'P' 87
    lsr.l   #8,d4
    eor.l   d4,d0           ;d0 = ACEGIKMOA'C'E'G'I'K'M'O' 87

    move.l  d2,d4
    lsl.l   #8,d4
    eor.l   d3,d4
    and.l   d5,d4
    eor.l   d4,d3           ;d3 = BDFHJLNPB'D'F'H'J'L'N'P' 65
    lsr.l   #8,d4
    eor.l   d4,d2           ;d2 = ACEGIKMOA'C'E'G'I'K'M'O' 65

    move.l  a6,d5           ;chargement du masque

    move.l  d0,d4
    add.l   d4,d4
    eor.l   d1,d4
    and.l   d5,d4
    eor.l   d4,d1           ;d1 = ABCDEFGHIJKLMNOP(idem avec') 7
    lsr.l   #1,d4

    move.l  d1,(320*256*2/8)(a1)

    eor.l   d4,d0           ;d0 = ABCDEFGHIJKLMNOP(idem avec') 8

    move.l  d2,d4
    move.l  d0,a2
    add.l   d4,d4
    eor.l   d3,d4
    and.l   d5,d4
    eor.l   d4,d3           ;d3 = ABCDEFGHIJKLMNOP(idem avec') 5
    lsr.l   #1,d4
    move.l  d3,a3
    eor.l   d2,d4           ;d4 = ABCDEFGHIJKLMNOP(idem avec') 6

    move.w  Size(pc),d7

    ;CALIGN

.loop.pass1_C2P.020_030.1.1.256c:
    move.l  (a0)+,d0
    and.l   d6,d0
    move.l  (a0)+,d5
    and.l   d6,d5
    lsr.l   #4,d5
    or.l    d5,d0           ;d0 = AEBFCGDH 8765

    move.l  (a0)+,d1
    and.l   d6,d1
    move.l  (a0)+,d5
    and.l   d6,d5
    lsr.l   #4,d5
    or.l    d5,d1           ;d1 = IMJNKOLP 8765

    move.l  (a0)+,d2
    and.l   d6,d2
    move.l  (a0)+,d5
    and.l   d6,d5
    lsr.l   #4,d5
    or.l    d5,d2           ;d2 = A'E'B'F'C'G'D'H' 8765

    move.l  (a0)+,d3
    and.l   d6,d3
    move.l  (a0)+,d5

    move.l  d4,(320*256*1/8)(a1)

    and.l   d6,d5
    lsr.l   #4,d5
    or.l    d5,d3           ;d3 = I'M'J'N'K'O'L'P' 8765

    swap    d2
    swap    d3
    eor.w   d0,d2
    eor.w   d1,d3
    eor.w   d2,d0
    eor.w   d3,d1
    eor.w   d0,d2
    eor.w   d1,d3
    swap    d2          ;d2 = CGDHC'G'D'H' 8765
    swap    d3          ;d3 = KOLPK'O'L'P' 8765

    move.l  a4,d5           ;chargement du masque

    move.l  d0,d4
    lsl.l   #2,d4

    move.l  a3,(a1)+

    eor.l   d2,d4
    and.l   d5,d4
    eor.l   d4,d2           ;d2 = ACEGBDFHA'C'E'G'B'D'F'H' 65
    lsr.l   #2,d4
    eor.l   d4,d0           ;d0 = ACEGBDFHA'C'E'G'B'D'F'H' 87

    move.l  d1,d4
    lsl.l   #2,d4
    eor.l   d3,d4
    and.l   d5,d4
    eor.l   d4,d3           ;d3 = IKMOJLNPI'K'M'O'J'L'N'P' 65
    lsr.l   #2,d4
    eor.l   d4,d1           ;d1 = IKMOJLNPI'K'M'O'J'L'N'P' 87

    move.l  a5,d5           ;chargement du masque

    move.l  d0,d4
    lsl.l   #8,d4
    eor.l   d1,d4

    move.l  a2,(320*256*3/8-4)(a1)

    and.l   d5,d4
    eor.l   d4,d1           ;d1 = BDFHJLNPB'D'F'H'J'L'N'P' 87
    lsr.l   #8,d4
    eor.l   d4,d0           ;d0 = ACEGIKMOA'C'E'G'I'K'M'O' 87

    move.l  d2,d4
    lsl.l   #8,d4
    eor.l   d3,d4
    and.l   d5,d4
    eor.l   d4,d3           ;d3 = BDFHJLNPB'D'F'H'J'L'N'P' 65
    lsr.l   #8,d4
    eor.l   d4,d2           ;d2 = ACEGIKMOA'C'E'G'I'K'M'O' 65

    move.l  a6,d5           ;chargement du masque

    move.l  d0,d4
    add.l   d4,d4
    eor.l   d1,d4
    and.l   d5,d4
    eor.l   d4,d1           ;d1 = ABCDEFGHIJKLMNOP(idem avec') 7

    move.l  d1,(320*256*2/8)(a1)

    lsr.l   #1,d4
    eor.l   d4,d0           ;d0 = ABCDEFGHIJKLMNOP(idem avec') 8

    move.l  d2,d4

    move.l  d0,a2

    add.l   d4,d4
    eor.l   d3,d4
    and.l   d5,d4
    eor.l   d4,d3           ;d3 = ABCDEFGHIJKLMNOP(idem avec') 5
    lsr.l   #1,d4

    move.l  d3,a3

    eor.l   d2,d4           ;d4 = ABCDEFGHIJKLMNOP(idem avec') 6

    dbf d7,.loop.pass1_C2P.020_030.1.1.256c

** Seconde partie de la conversion

    MOVEA.l CnkScreen(pc),a0  ; Changed here.. was 'Lea'
    not.l   d6

** Demarage de la seconde boucle et fin de la premiere

    move.l  (a0)+,d0
    and.l   d6,d0
    lsl.l   #4,d0
    move.l  (a0)+,d5
    and.l   d6,d5
    or.l    d5,d0           ;d0 = AEBFCGDH 4321

    move.l  (a0)+,d1
    and.l   d6,d1
    lsl.l   #4,d1
    move.l  (a0)+,d5
    and.l   d6,d5
    or.l    d5,d1           ;d1 = IMJNKOLP 4321

    move.l  (a0)+,d2
    and.l   d6,d2
    lsl.l   #4,d2
    move.l  (a0)+,d5
    and.l   d6,d5
    or.l    d5,d2           ;d2 = A'E'B'F'C'G'D'H' 4321

    move.l  (a0)+,d3
    and.l   d6,d3
    lsl.l   #4,d3
    move.l  (a0)+,d5

    move.l  d4,(320*256*1/8)(a1)

    and.l   d6,d5
    or.l    d5,d3           ;d3 = I'M'J'N'K'O'L'P' 4321

    swap    d2
    swap    d3
    eor.w   d0,d2
    eor.w   d1,d3
    eor.w   d2,d0
    eor.w   d3,d1
    eor.w   d0,d2
    eor.w   d1,d3
    swap    d2          ;d2 = CGDHC'G'D'H' 4321
    swap    d3          ;d3 = KOLPK'O'L'P' 4321

    move.l  a4,d5           ;chargement du masque

    move.l  d0,d4
    lsl.l   #2,d4

    move.l  a3,(a1)

    eor.l   d2,d4
    and.l   d5,d4
    eor.l   d4,d2           ;d2 = ACEGBDFHA'C'E'G'B'D'F'H' 21
    lsr.l   #2,d4
    eor.l   d4,d0           ;d0 = ACEGBDFHA'C'E'G'B'D'F'H' 43

    move.l  d1,d4
    lsl.l   #2,d4
    eor.l   d3,d4
    and.l   d5,d4
    eor.l   d4,d3           ;d3 = IKMOJLNPI'K'M'O'J'L'N'P' 21
    lsr.l   #2,d4
    eor.l   d4,d1           ;d1 = IKMOJLNPI'K'M'O'J'L'N'P' 43

    move.l  a5,d5           ;chargement du masque

    move.l  d0,d4
    lsl.l   #8,d4
    eor.l   d1,d4

    move.l  a2,(320*256*3/8)(a1)

    and.l   d5,d4
    eor.l   d4,d1           ;d1 = BDFHJLNPB'D'F'H'J'L'N'P' 43
    lsr.l   #8,d4
    eor.l   d4,d0           ;d0 = ACEGIKMOA'C'E'G'I'K'M'O' 43

    move.l  d2,d4
    lsl.l   #8,d4
    eor.l   d3,d4
    and.l   d5,d4
    eor.l   d4,d3           ;d3 = BDFHJLNPB'D'F'H'J'L'N'P' 21
    lsr.l   #8,d4
    eor.l   d4,d2           ;d2 = ACEGIKMOA'C'E'G'I'K'M'O' 21

    move.l  a6,d5           ;chargement du masque

    move.l  d0,d4
    add.l   d4,d4

    move.l  Screen(pc),a1

    eor.l   d1,d4
    and.l   d5,d4
    eor.l   d4,d1           ;d1 = ABCDEFGHIJKLMNOP(idem avec') 3

    move.l  d1,(320*256*2/8)(a1)

    lsr.l   #1,d4
    eor.l   d4,d0           ;d0 = ABCDEFGHIJKLMNOP(idem avec') 4

    move.l  d2,d4

    move.l  d0,a2

    add.l   d4,d4
    eor.l   d3,d4
    and.l   d5,d4
    eor.l   d4,d3           ;d3 = ABCDEFGHIJKLMNOP(idem avec') 1
    lsr.l   #1,d4

    move.l  d3,a3

    eor.l   d2,d4           ;d4 = ABCDEFGHIJKLMNOP(idem avec') 2

    move.w  Size(pc),d7

;    CALIGN


.loop.pass2_C2P.020_030.1.1.256c:
    move.l  (a0)+,d0
    and.l   d6,d0
    lsl.l   #4,d0
    move.l  (a0)+,d5
    and.l   d6,d5
    or.l    d5,d0           ;d0 = AEBFCGDH 4321

    move.l  (a0)+,d1
    and.l   d6,d1
    lsl.l   #4,d1
    move.l  (a0)+,d5
    and.l   d6,d5
    or.l    d5,d1           ;d1 = IMJNKOLP 4321

    move.l  (a0)+,d2
    and.l   d6,d2
    lsl.l   #4,d2
    move.l  (a0)+,d5
    and.l   d6,d5
    or.l    d5,d2           ;d2 = A'E'B'F'C'G'D'H' 4321

    move.l  (a0)+,d3
    and.l   d6,d3
    lsl.l   #4,d3
    move.l  (a0)+,d5

    move.l  d4,(320*256*1/8)(a1)

    and.l   d6,d5
    or.l    d5,d3           ;d3 = I'M'J'N'K'O'L'P' 4321

    swap    d2
    swap    d3
    eor.w   d0,d2
    eor.w   d1,d3
    eor.w   d2,d0
    eor.w   d3,d1
    eor.w   d0,d2
    eor.w   d1,d3
    swap    d2          ;d2 = CGDHC'G'D'H' 4321
    swap    d3          ;d3 = KOLPK'O'L'P' 4321

    move.l  a4,d5           ;chargement du masque

    move.l  d0,d4
    lsl.l   #2,d4

    move.l  a3,(a1)+

    eor.l   d2,d4
    and.l   d5,d4
    eor.l   d4,d2           ;d2 = ACEGBDFHA'C'E'G'B'D'F'H' 21
    lsr.l   #2,d4
    eor.l   d4,d0           ;d0 = ACEGBDFHA'C'E'G'B'D'F'H' 43

    move.l  d1,d4
    lsl.l   #2,d4
    eor.l   d3,d4
    and.l   d5,d4
    eor.l   d4,d3           ;d3 = IKMOJLNPI'K'M'O'J'L'N'P' 21
    lsr.l   #2,d4
    eor.l   d4,d1           ;d1 = IKMOJLNPI'K'M'O'J'L'N'P' 43

    move.l  a5,d5           ;chargement du masque

    move.l  d0,d4
    lsl.l   #8,d4
    eor.l   d1,d4

    move.l  a2,(320*256*3/8-4)(a1)

    and.l   d5,d4
    eor.l   d4,d1           ;d1 = BDFHJLNPB'D'F'H'J'L'N'P' 43
    lsr.l   #8,d4
    eor.l   d4,d0           ;d0 = ACEGIKMOA'C'E'G'I'K'M'O' 43

    move.l  d2,d4
    lsl.l   #8,d4
    eor.l   d3,d4
    and.l   d5,d4
    eor.l   d4,d3           ;d3 = BDFHJLNPB'D'F'H'J'L'N'P' 21
    lsr.l   #8,d4
    eor.l   d4,d2           ;d2 = ACEGIKMOA'C'E'G'I'K'M'O' 21

    move.l  a6,d5           ;chargement du masque

    move.l  d0,d4
    add.l   d4,d4
    eor.l   d1,d4
    and.l   d5,d4
    eor.l   d4,d1           ;d1 = ABCDEFGHIJKLMNOP(idem avec') 3

    move.l  d1,(320*256*2/8)(a1)

    lsr.l   #1,d4
    eor.l   d4,d0           ;d0 = ABCDEFGHIJKLMNOP(idem avec') 4

    move.l  d2,d4

    move.l  d0,a2

    add.l   d4,d4
    eor.l   d3,d4
    and.l   d5,d4
    eor.l   d4,d3           ;d3 = ABCDEFGHIJKLMNOP(idem avec') 1
    lsr.l   #1,d4

    move.l  d3,a3

    eor.l   d2,d4           ;d4 = ABCDEFGHIJKLMNOP(idem avec') 2

    dbf d7,.loop.pass2_C2P.020_030.1.1.256c

    move.l  d4,(320*256*1/8)(a1)
    move.l  a3,(a1)
    move.l  a2,(320*256*3/8)(a1)

    movem.l (a7)+,a2-a5
    rts

Screen:    dc.l 0
CnkScreen: dc.l 0
Size:      dc.w 0

 endfunc    27


 base

 Dc.l 0  ; ChunkyPtr
 Dc.l 0  ; ObjNum1
 Dc.l 0  ; ObjNum2
 Dc.l 0  ; ObjNum3
 Dc.l 0  ; MemPtr1
 Dc.l 0  ; MemPtr2
 Dc.l 0  ; MemPtr3
 Dc.l 0  ; ChunkyCache
 Dc.l 0  ; BufferPtr
 Dc.l 0  ; CurrPos
 Dc.l 0  ; CurrSprBuf
 Dc.l 0  ; ChunkyBufWid

; ----- Picasso96 -----

 Dc.l 0  ; P96Base
 Dc.l 0  ; P96Screen

;
; GetPosition (#ChunkyBuffer)
;
  MOVEA.l _MemPtr3(a5), a3
  LSL.l    #4, d0
  ADD.l    d0, a3
  MOVE.l   (a3), a1
  RTS

 endlib


 startdebugger

_InitChunky_Check
  TST.l   d2
  BMI     Error1
  TST.l   d3
  BMI     Error2
  TST.l   d4
  BMI     Error3
  RTS

; ------- ChunkySprites -------

_LoadChunkySprites_Check
  TST.l  _MemPtr1(a5)
  BEQ     Error4
  MOVE.l  d0,d6
  BMI     Error5
  MOVE.l  d1,d7
  BMI     Error5
  CMP.l  _ObjNum1(a5),d6
  BGT     Error5
  CMP.l  _ObjNum1(a5),d7
  BGT     Error5
  MOVE.l _MemPtr1(a5),a0
  MOVE.l  a0,a1
  LSL.l   #4,d6
  LSL.l   #4,d7
  ADD.l   d6,a0
  ADD.l   d7,a1
_LCS_Cl0
  TST.l  _SprData(a0)
  BNE     Error7
  ADD.l   #16,a0
  CMP.l   a0,a1
  BGE    _LCS_Cl0
  RTS

_SaveChunkySprites_Check
  TST.l  _MemPtr1(a5)
  BEQ     Error4
  TST.l   d0
  BMI     Error5
  TST.l   d1
  BMI     Error5
  CMP.l  _ObjNum1(a5),d0
  BGT     Error5
  CMP.l  _ObjNum1(a5),d1
  BGT     Error5
  RTS

_GrabChunkySprite_Check
  TST.l  _MemPtr1(a5)
  BEQ     Error4
  MOVE.l  d0,d6
  BMI     Error5
  CMP.l  _ObjNum1(a5),d6
  BGT     Error5
  MOVE.l _MemPtr1(a5),a0
  LSL.l   #4,d6
  ADD.l   d6,a0
  TST.l  _SprData(a0)
  BNE     Error7
  RTS

_CopyChunkySprite_Check
  TST.l  _MemPtr1(a5)
  BEQ     Error4
  MOVE.l  d0,d6
  BMI     Error5
  MOVE.l  d1,d7
  BMI     Error5
  CMP.l  _ObjNum1(a5),d6
  BGT     Error5
  CMP.l  _ObjNum1(a5),d7
  BGT     Error5
  MOVE.l _MemPtr1(a5),a0
  MOVE.l  a0,a1
  LSL.l   #4,d6
  LSL.l   #4,d7
  ADD.l   d6,a0
  ADD.l   d7,a1
  TST.l  _SprData(a0)
  BEQ     Error6
  TST.l  _SprData(a1)
  BNE     Error7
  RTS

_ChunkySpriteWidth_Check
_ChunkySpriteHeight_Check
_ChunkySpriteHandle_Check
  TST.l  _MemPtr1(a5)
  BEQ     Error4
  MOVE.l  d0,d6
  BMI     Error5
  CMP.l  _ObjNum1(a5),d6
  BGT     Error5
  MOVE.l _MemPtr1(a5),a0
  LSL.l   #4,d6
  ADD.l   d6,a0
  TST.l  _SprData(a0)
  BEQ     Error6
  RTS

_DisplayChunkySpriteBlock_Check
  TST.l  _MemPtr1(a5)
  BEQ     Error4
  MOVE.l  d0,d6
  BMI     Error5
  CMP.l  _ObjNum1(a5),d6
  BGT     Error5
  MOVE.l _MemPtr1(a5),a0
  LSL.l   #4,d6
  ADD.l   d6,a0
  TST.l  _SprData(a0)
  BEQ     Error6
  MOVE.l _ChunkyPtr(a5),d6
  BEQ     Error2
  MOVE.l  d6,a1
  MOVE.l  d1,d6
  ANDI.w  #$fff8,d6
  BMI     Error8
  MOVE.l  d2,d7
  BMI     Error9
  ADD.w  _SprWid(a0),d6
  ADD.w  _SprHeig(a0),d7
  CMP.w   -4(a1),d6
  BGT     Error8
  CMP.w   -2(a1),d7
  BGT     Error9
  RTS

_DisplayTransparantChunkySprite_Check
_DisplayChunkySprite_Check
  TST.l  _MemPtr1(a5)
  BEQ     Error4
  MOVE.l  d0,d6
  BMI     Error5
  CMP.l  _ObjNum1(a5),d6
  BGT     Error5
  MOVE.l _MemPtr1(a5),a0
  LSL.l   #4,d6
  ADD.l   d6,a0
  TST.l  _SprData(a0)
  BEQ     Error6
  MOVE.l _ChunkyPtr(a5),d6
  BEQ     Error2
  MOVE.l  d6,a1
  MOVE.l  d1,d6
  SUB.w  _xHandle(a0),d6
  BMI     Error8
  MOVE.l  d2,d7
  SUB.w  _yHandle(a0),d7
  BMI     Error9
  ADD.w  _SprWid(a0),d6
  ADD.w  _SprHeig(a0),d7
  CMP.w   -4(a1),d6
  BGT     Error8
  CMP.w   -2(a1),d7
  BGT     Error9
  RTS

_DisplayBufferedChunkySprite_Check
  TST.l  _MemPtr1(a5)
  BEQ     Error4
  MOVE.l  d0,d6
  BMI     Error5
  CMP.l  _ObjNum1(a5),d6
  BGT     Error5
  MOVE.l _MemPtr1(a5),a0
  LSL.l   #4,d6
  ADD.l   d6,a0
  TST.l  _SprData(a0)
  BEQ     Error6
  MOVE.l _ChunkyPtr(a5),d6
  BEQ     Error2
  MOVE.l  d6,a1
  MOVE.l  d1,d6
  SUB.w  _xHandle(a0),d6
  BMI     Error8
  MOVE.l  d2,d7
  SUB.w  _yHandle(a0),d7
  BMI     Error9
  ADD.w  _SprWid(a0),d6
  ADD.w  _SprHeig(a0),d7
  CMP.w   -4(a1),d6
  BGT     Error8
  CMP.w   -2(a1),d7
  BGT     Error9
  TST.l  _CurrSprBuf(a5)
  BEQ     Error13
  MOVE.l _BufferPtr(a5),d6
  MOVE.l _SprSize(a0),d7
  MOVE.l _BufferPtr(a5),a0
  ADD.l   -4(a0),d6
  ADD.l  _CurrPos(a5),d7
  ADDQ.l  #4,d7
  CMP.l   d6,d7
  BGE     Error14
  RTS

_FreeChunkySprite_Check
  TST.l  _MemPtr1(a5)
  BEQ     Error4
  MOVE.l  d0,d6
  BMI     Error5
  CMP.l  _ObjNum1(a5),d6
  BGT     Error5
  MOVE.l _MemPtr1(a5),a0
  LSL.l   #4,d6
  ADD.l   d6,a0
  TST.l  _SprData(a0)
  BEQ     Error6
  RTS

; ------- ChunkySpriteBuffer -------

_CreateChunkySpriteBuffer_Check
  TST.l  _MemPtr2(a5)
  BEQ     Error4
  MOVE.l  d0,d6
  BMI     Error10
  CMP.l  _ObjNum2(a5),d6
  BGT     Error10
  MOVE.l _MemPtr2(a5),a0
  LSL.l   #3,d6
  ADD.l   d6,a0
  TST.l  _Buffer(a0)
  BNE     Error12
  RTS

_UseChunkySpriteBuffer_Check
  TST.l  _MemPtr2(a5)
  BEQ     Error4
  MOVE.l  d0,d6
  BMI     Error10
  CMP.l  _ObjNum2(a5),d6
  BGT     Error10
  TST.l  _CurrSprBuf(a5)
  BEQ     Error13
  MOVE.l _MemPtr2(a5),a0
  LSL.l   #3,d6
  ADD.l   d6,a0
  TST.l  _Buffer(a0)
  BEQ     Error11
  RTS

_FlushChunkySpriteBuffer_Check
_FreeChunkySpriteBuffer_Check
  TST.l  _MemPtr2(a5)
  BEQ     Error4
  MOVE.l  d0,d6
  BMI     Error10
  CMP.l  _ObjNum2(a5),d6
  BGT     Error10
  MOVE.l _MemPtr2(a5),a0
  LSL.l   #3,d6
  ADD.l   d6,a0
  TST.l  _Buffer(a0)
  BEQ     Error11
  RTS

; ------- ChunkyBuffer -------

_InitCheck:
  TST.l   _MemPtr3(a5)
  BEQ      Error4
  RTS

_MaxiObjCheck:
  TST.w    d0                 ; If #ChunkyBuffer is < 0
  BMI      Error15
  MOVE.l  _ObjNum3(a5),d1
  CMP.w    d1,d0              ; if #ChunkyBuffer is > ObjMax..
  BGT      Error15
  RTS

_CurrentCheck:
  TST.l   _MemPtr3(a5)
  BEQ      Error4
  TST.l    (a5)
  BEQ      Error16
  RTS

_ExistCheck:
  EXT.l    d0
  TST.l   _MemPtr3(a5)        ; Init check
  BEQ      Error4
  TST.w    d0                 ; If #ChunkyBuffer is < 0
  BMI      Error15
  MOVE.l  _ObjNum3(a5),d1
  CMP.w    d1,d0              ; if #ChunkyBuffer is > ObjMax..
  BGT      Error15
  MOVEA.l _MemPtr3(a5), a0    ; Now see if the given number
  MOVE.l   d0, d1             ; is really initialized
  LSL.l    #4, d1             ;
  ADD.l    d1, a0
  MOVE.l   (a0), d1
  BEQ      Error17
  RTS

_NewCheck:
  EXT.l    d0
  TST.l   _MemPtr3(a5)        ; Init check
  BEQ      Error4
  TST.w    d0                 ; If #ChunkyBuffer is < 0
  BMI      Error15
  MOVE.l  _ObjNum3(a5),d1
  CMP.w    d1,d0              ; if #ChunkyBuffer is > ObjMax..
  BGT      Error15
  MOVEA.l _MemPtr3(a5), a0    ; Now see if the given number
  MOVE.l   d0, d1             ; is not initialized
  LSL.l    #4, d1             ;
  ADD.l    d1, a0
  MOVE.l   (a0), d1
  BNE      Error18
  RTS

_RestoreChunkyBuffer_Check
  TST.l  _MemPtr3(a5)
  BEQ     Error4
  TST.l  _ChunkyPtr(a5)
  BEQ     Error16
  TST.l  _CurrSprBuf(a5)
  BEQ     Error13
  RTS


Error1: debugerror "#MaxChunkySprites out of Range"
Error2: debugerror "#MaxChunkySpriteBuffers out of Range"
Error3: debugerror "#MaxChunkyBuffers out of Range"

Error4: debugerror "Must Call InitChunky() First"
Error5: debugerror "#ChunkySprite out of Range"
Error6: debugerror "#ChunkySprite is not Initialized"
Error7: debugerror "#ChunkySprite is already Initialized"
Error8: debugerror "#ChunkySprite outside of ChunkyBuffer, x axis"
Error9: debugerror "#ChunkySprite outside of ChunkyBuffer, y axis"

Error10: debugerror "#ChunkySpriteBuffer out of Range"
Error11: debugerror "#ChunkySpriteBuffer is not Initialized"
Error12: debugerror "#ChunkySpriteBuffer is already Initialized"
Error13: debugerror "No current used ChunkySpriteBuffer"
Error14: debugerror "#ChunkySpriteBuffer OverFlow"

Error15: debugerror "#ChunkyBuffer out of range"
Error16: debugerror "No current used ChunkyBuffer"
Error17: debugerror "#ChunkyBuffer isn't initialized"
Error18: debugerror "#ChunkyBuffer is already initialized"

 enddebugger


;----------------------------------------------------------------------------
;
; name      "ChunkyBlit", "(ShapeWidth, ShapeHeight, ShapeSource, x, y)"
; flags
; amigalibs
; params     d0_w, d1_w, a0_l, d3_l, d4_w
; debugger   2, _CurrentCheck
;
;; a0 = Source Shape Adresse
;; a1 = DestChunky, at position X,Y
;; d0 = ShapeWidth
;; d1 = ShapeHeight
;; d3 = X compt
;; d4 = Y compt
;
;  MOVEA.l _ChunkyPtr(a5), a1
;  MOVE.w  -4(a1), d5           ; Get the ChunkyWidth
;  EXT.l    d5
;  MULU.w   d5, d4              ; Get X,Y pos
;  ADD.l    d4, a1              ;
;  ADD.l    d3, a1
;_YLine:
;  MOVEQ.l  #0, d2
;_XLine:
;  MOVE.b   (a0)+,d6       ;
;  BEQ     _Plot_Done      ; Colour 0 Transparent
;  MOVE.b   d6, 0(a1,d2)   ;
;_Plot_Done:
;  ADDQ.w   #1, d2
;  CMP.w    d0, d2         ; If d2 < d1
;  BLT     _XLine          ;
;  ADD.l    d5, a1         ; Next Line
;  SUBQ.w   #1, d1
;  BNE     _YLine
;  RTS
;
; endfunc   2
;
;
; name      "ChunkyBlock", "(ShapeWidth, ShapeHeight, ShapeSource, x, y)"
; flags
; amigalibs
; params     d0_w, d1_w, a0_l, d3_l, d4_w
; debugger   3, _CurrentCheck
;
;; a0 = Source Shape Adresse
;; a1 = DestChunky, at position X,Y
;; d0 = ShapeWidth
;; d1 = ShapeHeight
;; d3 = X compt
;; d4 = Y compt
;
;  MOVEA.l _ChunkyPtr(a5), a1
;  MOVE.w  -4(a1), d5           ; Get the Width
;  MULU.w   d5, d4              ; Get X,Y pos
;  ADD.l    d4, a1              ;
;  ADD.l    d3, a1              ;
;  SUB.w    d0,d5          ; d5 = ChunkyWidth-SpriteWidth
;  SUBQ.w   #3,d5
;_YLine4:
;  MOVE.w   d0,d2
;_XLine4:
;  MOVE.l   (a0)+, (a1)+
;  SUBQ.w   #4, d2
;  BGT     _XLine4         ;
;  ADD.w    d5, a1         ; Next Line
;  SUBQ.w   #1, d1
;  BNE     _YLine4
;  RTS
;
; endfunc   3
;
;----------------------------------------------------------------------------

