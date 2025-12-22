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
; PureBasic 'AmigaSprite' library
;
;
; 04/09/2005 -Doobrey-
;  Changed addressing code in base to not use hard coded maths!
;    All commands now obey saving d2-d7/a2-a7 if used.
;    Padded data structs at end of some commands with CNOP 0,4 ..slight speedup reading on 040+ ?
;
;   -To do: LoadSprite still has one use of Move.l $4,a6 to get execbase..might move to libbase for small speedup.
;
;--------------------------------------------------------------------------------------------------
;
; 09/03/2000
;   Removed unused functions
;
; 05/03/2000
;   Added a RethinkDisplay() for all screen and it seems to
;   fix the sprite 0 bug. Now we can have 7 sprites. The last
;   one is not available... Why ?
;   Added one more space to handle the eight sprites (if it works)
;   ++++ The eight sprite was not available because a bad overscan
;   configuration in WB mode !! Incredible :-(.
;
; 27/02/2000
;   Added LoadSprite() ! Very cool :*). Works for any sprites
;   Optimized the function GetNumPerLine() ;-)
;
; 26/02/2000
;   FirstVersion
;
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16
MEMF_CHIP = 2

BMF_CLEAR = 1
BMF_DISPLAYABLE = 2
BMF_INTERLEAVED = 4

FORM = $464F524D   ; Constants need to handle IFF pictures
ILBM = $494C424D   ;
BMHD = $424D4844   ;
CMAP = $434D4150   ;
BODY = $424F4459   ;


SPRITEA_Width       = $81000000
GSTAG_SPRITE_NUM    = $82000020
VTAG_SPRITERESN_SET = $80000031

ObjectShift = 2

_Sprite     = 0
_ViewPort   = _Sprite+4
_ObjNum     = _ViewPort+4
_MemPtr     = _ObjNum+4
_Screen     = _MemPtr+4

;-- Optimisation could make code in base smaller, use labels instead!
;-_GetPositionBase = _Screen+4
;-_FreeSpriteBase  = _GetPositionBase+14

_GetPositionBase =l_GetPositionBase-LibBase
_FreeSpriteBase  =l_FreeSpriteBase -LibBase

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

 initlib "AmigaSprite", "AmigaSprite", "FreeAmigaSprites", 0, 1, 0

;
; Now do the functions...
;
;-------------------------------------------------------------------------------------------------------------
 name      "InitAmigaSprites", "(#MaxNumberAmigaSprites)"
 flags      LongResult
 amigalibs  _ExecBase,  a6
 params     d0_l
 debugger   1

  ADDQ.l   #1, d0              ; Needed to have the correct number  
  MOVE.l   d0, _ObjNum(a5)     ; Set the Objects Numbers
  LSL.l    #ObjectShift, d0    ; d0*16
  MOVE.l   #MEMF_CLEAR, d1     ; Fill memory of '0'
  JSR     _AllocVec(a6)        ; (d0,d1)
  MOVE.l   d0, _MemPtr(a5)     ; Set *MemPtr
  RTS

 endfunc   1

;-------------------------------------------------------------------------------------------------------------
;-- Doob- changed gfxbase to a6 instead of d5.
;         added ExecBase to amigalibs instead of move. $4,a6
;         Saves d2/d4 according to new lib reg rules.
;
 name      "FreeAmigaSprites", "()"
 flags
 amigalibs  _GraphicsBase,  a6 , _ExecBase, d5
 params
 debugger   2

  MOVEM.l  d2/d4/a6,-(a7)     ; save regs!
  MOVE.l  _ObjNum(a5), d4     ; Num Objects
  BNE     _LoopFreeSprites
  MOVEM.l (a7)+,d2/d4/a6      ; restore used regs
  RTS

_LoopFreeSprites:             ; Close all the opened palette
  SUBQ.l   #1, d4             ;
  MOVE.l   d4, d0             ;
  JSR     _FreeSpriteBase(a5) ; No need for a6 loaded stuffs
  TST.l    d4                 ;
  BNE     _LoopFreeSprites    ; Repeat:Until d4 = 0

  MOVEQ.w  #6,d2              ;
_LoopFreeSprites2:            ;
  MOVE.w   d2,d0              ; Free the six channels...
  JSR     _FreeSprite(a6)     ;
  SUBQ.w   #1,d2              ;
  BNE     _LoopFreeSprites2   ;

  MOVEA.l d5,a6
  MOVEA.l _MemPtr(a5), a1     ;
  JSR     _FreeVec(a6)        ; (*Memory) -a1
  MOVEM.l  (a7)+,d2/d4/a6     ; Restore used regs
  RTS

 endfunc   2

;-------------------------------------------------------------------------------------------------------------

 name      "FreeAmigaSprite", "(#AmigaSprite)"
 flags      InLine
 amigalibs  _GraphicsBase,  a6
 params     d0_l
 debugger   3, _ExistCheck

  JMP     _FreeSpriteBase(a5)

 endfunc   3

;-------------------------------------------------------------------------------------------------------------

 name      "LoadAmigaSprite", "(#AmigaSprite, FileName$)"
 flags      LongResult
 amigalibs _GraphicsBase,d7, _DosBase,a6 , _ExecBase,d6
 params     d0_l,  d1_l
 debugger  5, _MaxiCheck

  MOVEM.l  d2-d7/a2-a3,-(a7)
  
  MOVEA.l  _MemPtr(a5), a3    ; Inlined function for speed.
  LSL.l     #ObjectShift, d0  ; Get the object position
  ADD.l     d0, a3            ;

  MOVE.l    #1005, d2         ; Mode Read
  JSR      _Open(a6)          ; (FileName$, Mode) - d1/d2
  TST.l     d0                ;
  BEQ      _Error1_LoadSprite ; File not found
  MOVE.l    d0, d5            ; Store the file ptr in 'd5'

  MOVE.l    d5, d1            ; Read the 12 first bytes
  LEA.l    _IFFTmp(pc), a2    ; of the file in our buffer
  MOVE.l    a2, d2            ;
  MOVEQ     #12, d3           ;
  JSR      _Read(a6)          ; - d1,d2,d3

  MOVE.l    (a2)+, d0         ; Should be #FORM
  MOVE.l    (a2)+, d4         ; Get the file size
  MOVE.l    (a2) , d1         ; Should be #ILBM

  CMP.l     #FORM, d0         ; Do the comparaison to be sure...
  BNE      _Error2_LoadSprite ; - Not an IFF File
  CMP.l     #ILBM, d1         ;
  BNE      _Error2_LoadSprite ;

  ADDQ.l    #8,d4             ; Add space for #FORM, #ILBM
  MOVE.l    a6,d2             ; Preserve *DosBase
  MOVEA.l   d6,a6             ; 
  MOVE.l    d4,d0             ;
  MOVEQ.l   #0,d1             ;
  JSR      _AllocVec(a6)      ; (Size, Flags) - d0,d1
  TST.l     d0
  BEQ      _End_LoadSprite    ; - Not enough memory
  LEA.l    _IsFileRead(pc),a0 ; The buffer has been allocated, so we must free it
  MOVE.l    d0,(a0)           ; at end...
  MOVE.l    d0, d6            ; Dest buffer

  MOVE.l    d2, a6            ; Restore *DosBase
  MOVE.l    d5,d1             ; Go to the begin of File...
  MOVEQ     #0,d2             ;
  MOVEQ     #-1,d3            ;
  JSR      _Seek(a6)          ;
  MOVE.l    d5, d1            ; File ptr
  MOVE.l    d6, d2            ; Dest buffer
  MOVE.l    d4, d3            ; Size of Read
  JSR      _Read(a6)          ; (*File, *Buffer, Size) - d1,d2,d3
  MOVE.l    d5, d1            ;
  JSR      _Close(a6)         ; (*File) - d1
  MOVE.l    d7, a6            ; Restore *GraphicsBase

  MOVE.l    d6, d0            ; Try to get the BMHD Chunk
  MOVE.l    #BMHD, d1         ; If not, quit.
  BSR      _GetIFFChunk       ; Flush d0/d1-a0/a1
  TST.l     d0                ;
  BEQ      _Error4_LoadSprite ; - Corrupted IFF/ILBM File
  MOVE.l    d0, a2            ; a2 store the *BitMapHeader

  MOVE.l    d6, d0            ;
  MOVE.l    #BODY, d1         ;
  BSR      _GetIFFChunk       ; Flush d0/d1-a0/a1
  TST.l     d0                ;
  BEQ      _Error4_LoadSprite ; - Corrupted IFF/ILBM File
  MOVE.l    d0, d7

  MOVEQ.l   #0,d0                ; Clear all the registers as AllocBitMap need ULONG !
  MOVEQ.l   #0,d1                ;
  MOVEQ.l   #0,d2                ;
  MOVE.w    (a2), d0             ;
  MOVE.w   2(a2), d1             ;
  MOVE.b   8(a2), d2             ;
  MOVEQ.l   #BMF_CLEAR,d3        ;
  SUB.l     a0, a0               ;
  JSR      _AllocBitMap(a6)      ; (Width,Height,Depth,Flags,FriendBitMap) d0,d1,d2,d3,a0
  TST.l     d0                   ;
  BEQ      _End_LoadSprite       ;
  MOVE.l    d0, d4

  MOVE.l    d2, d3     ; Get Depth
  MOVEQ.l   #0, d0     ;
  MOVE.w    (a2), d0   ; Get IFF Width
  MOVE.w   2(a2), d2   ; Get IFF Height
  MOVE.b  10(a2), d5   ; Get compression mode

  MOVE.l    d4, a2     ; a2 now is the *BitMap

  LEA.l    _SpriteTagList(pc),a1 ;
  MOVE.w    d0, 6(a1)            ; Set the Width Tag

  BSR      _GetNumPerLine ; Flush d0/d1
  MOVE.w    d0, d4        ; Number of byte per line of each bitplane

  MOVE.l    d7, a0        ; Restore *BODY
  SUBQ.l    #1, d2        ; Right setup numbers for fast loops...
  SUBQ.l    #1, d4        ;
  TST.b     d5
  BNE      _IsCompressed
  BSR      _NotCompressed
  BRA      _Next_LoadSprite
_IsCompressed:
  CMP.b     #1, d5
  BNE      _End_LoadSprite
  BSR      _ByteRunCompressed

_Next_LoadSprite:
  LEA.l    _SpriteTagList(pc),a1
  JSR      _AllocSpriteDataA(a6) ; (*BitMap, *TagList) - a2/a1 - Allocate an Extended Sprite... AGA & ECS/OCS support
  MOVE.l    d0, (a3)
  MOVE.l    a2, a0
  JSR      _FreeBitMap(a6)       ; (*BitMap) - a0
  MOVE.l    (a3), d0
  BRA      _End_LoadSprite

_Error4_LoadSprite:
  MOVEQ.l   #-3, d0  ; - Corrupted IFF/ILBM File
  BRA      _End_LoadSprite

_Error2_LoadSprite
  MOVE.l    d5, d1            ; Close the file, still opened...
  JSR      _Close(a6)         ; (*File) - d1
  MOVEQ.l   #-2, d0  ; - Not an IFF/ILBM File
  BRA      _End_LoadSprite

_Error1_LoadSprite
  MOVEQ.l   #-1, d0  ; - File not found

_End_LoadSprite:
  MOVE.l    d0, d2   ; If d0=0 - Out of memory
  MOVE.l    $4, a6
  LEA.l    _IsFileRead(pc),a0
  MOVE.l    (a0),a1
  CLR.l     (a0)
  JSR      _FreeVec(a6)
  MOVE.l    d2, d0
  MOVEM.l   (a7)+,d2-d7/a2-a3
  RTS


; GetNumberOfBytesPerLine **************************************
;
; Entry : d0: Picture width
; Flush : d0
;
_GetNumPerLine:
  ADDQ.w   #7, d0   ;
  AND.b    #$f8, d0 ; Fast round to the next 8
  LSR.w    #3, d0   ; Divide by 8 quietly
  ADDQ.w   #1, d0   ; Make the result even !
  AND.b    #$fe, d0 ;
  RTS


; ByteRun decompression routine for IFF/ILBM *****************************
;
; Entry: a0: *Picture (BODY chunk)
;        a2: *BitMap
;        d2: Picture height
;        d3: Picture depth
;        d4: Number of bytes per lines.
;
; Flush: d0,d1,d2,d5,d6,d7 - a0,a1

_ByteRunCompressed:

  MOVEQ    #0,d5
_LLoop3:
  MOVEQ    #0,d1         ; Our bitplane counter
_LLoop2:
  ; *p = *MyBitmap\Planes[l]+m*BMLine

  MOVE.l   a2, a1        ; Get 1st plane addr

  MOVE.w   d1, d0        ; Get right plane addr
  LSL.w    #2, d0        ;

  MOVE.l   8(a1,d0), a1  ;
  ADD.l    d5, a1

  MOVE.w   d4, d0        ; Get Number of pixel per line and
_LLoop1:                 ; fill the bitmap

  ; a = !ReadByte        ;

  MOVE.b  (a0)+, d6      ;

  ; If a >= 0

  CMP.b    #0, d6
  BGE     _Case1         ; Read the n next byte without change

  CMP.b    #-128, d6
  BEQ     _Next2         ; Ignore this byte

  ; g = -a
  ; a = !ReadByte
  ; k+g
  ; For o = 0 To g
  ;   NPokeB *p, a
  ;   *p+1
  ; Next

  NEG.b    d6            ; Change the sign

  SUB.b    d6, d0        ; Read the next byte and copy it n times
  MOVE.b   (a0)+, d7     ;
_LoopCase2:              ;
  MOVE.b   d7, (a1)+     ;
  SUBQ.l   #1, d6        ;
  TST.b    d6        ;
  BGE     _LoopCase2     ;
  BRA     _Next          ;

  ; g.w = a
  ; k+g
  ; For o = 0 To g
  ;   a = !ReadByte
  ;   NPokeB *p, a             ;
  ;   *p+1
  ; Next

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

  ADDQ.l   #1, d1        ; Add the plane counter..
  CMP.b    d1, d3        ;
  BNE     _LLoop2        ;

  ADD.w    (a2), d5      ; Add the plane offset for next bitplane write (*BitMap\BytesPerRows)

  DBF      d2, _LLoop3    ; Process it for all the picture Height !
  RTS


; Decompression routine for raw IFF/ILBM *****************************
;
; Entry: a0: *Picture (BODY chunk)
;        a2: *BitMap
;        d2: Picture height
;        d3: Picture depth
;        d4: Number of bytes per lines.
;
; Flush: d0,d1,d2,d5 - a0,a1

_NotCompressed:
  MOVEQ    #0,d5         ; Our offset inside a bitplane (displacement)
_Loop3:                  ;
  MOVEQ    #0,d1         ; Our bitplane counter
_Loop2:                  ;
  MOVE.l   a2, a1        ; Get 1st plane addr
  MOVE.w   d1, d0        ; Get right plane addr
  LSL.w    #2, d0        ;
  MOVE.l   8(a1,d0), a1  ;
  ADD.l    d5, a1        ;
  MOVE.w   d4, d0        ; Get Number of pixel per line and
_Loop1:                  ; fill the bitmap
  MOVE.b  (a0)+, (a1)+   ;
  DBF      d0, _Loop1    ;
  ADDQ.l   #1, d1        ; Add the plane counter..
  CMP.w    d1, d3        ;
  BNE     _Loop2         ;
  ADD.w    (a2), d5      ; Add *BitMap\BytesPerRows
  DBF      d2, _Loop3    ; Process it for all the picture Height !
  RTS


; GetIFFChunk **********************************************
;
; Entry: d0: *IFF_Picture
;        d1: ChunkID (ie: BODY, BMHD...)
;
; Flush: d0 - a0,a1
;
_GetIFFChunk:
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
  ADDQ.w   #1, d0     ; Make it even !
  AND.b    #$fe, d0   ;

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
  RTS

  CNOP 0,4  ; LW Align

_IFFTmp:
  Dc.l 0,0,0

_IsFileRead:
  Dc.l 0

_SpriteTagList:
  Dc.l SPRITEA_Width, 32
  Dc.l 0

 endfunc   5

;-------------------------------------------------------------------------------------------------------------

 name      "DisplayAmigaSprite", "(#AmigaSprite, SpriteChannel, x, y)"
 flags
 amigalibs _GraphicsBase, a6
 params     d0_l, d4_w, d2_w, d3_w
 debugger   6, _ExistCheck

  MOVEM.l  a2/a5,-(a7)       ; Save used regs.
  MOVEA.l _MemPtr(a5), a0    ; Inlined function for speed.
  LSL.l    #ObjectShift, d0  ; Get the object position
  ADD.l    d0,a0             ;
  MOVE.l   (a0), a2          ;

  MOVE.l  _ViewPort(a5), d5

  LEA.l    OldSprites(pc), a5
  MOVE.w   d4, d0
  LSL.w    #2, d0
  ADD.w    d0, a5
  MOVE.l   (a5), d0
  BEQ     _SkipMoveSprite
  MOVE.l   d5, a0
  MOVE.l   d0, a1
  MOVE.w   d2, d0
  MOVE.w   d3, d1
  JSR     _MoveSprite(a6)    ; (*ViewPort, *Sprite, x, y) a0/a1/d0/d1
_SkipMoveSprite:

  MOVE.w   d4, d0
  JSR     _FreeSprite(a6)    ; (SpriteNumber) - d0

  LEA.l    DisplayTagList(pc),a1
  MOVE.w   d4, 6(a1)
  JSR     _GetExtSpriteA(a6) ; (*Sprite, *TagList) - a2/a1

  MOVE.l   a2,(a5)           ; Set this sprite to OldSprite...
  MOVE.l   d5, a0            ; Set *ViewPort
  MOVE.l   a2, a1            ; Set *Sprite
  MOVE.w   d2, d0            ; x
  MOVE.w   d3, d1            ; y
  MOVEM.l (a7)+,a2/a5        ; Restore registers
  JMP     _MoveSprite(a6)    ; (*ViewPort, *Sprite, x, y) a0/a1/d0/d1

  CNOP 0,4 ; LW Align Struct.

DisplayTagList:
  Dc.l GSTAG_SPRITE_NUM, 0
  Dc.l 0

OldSprites:
  Dc.l 0,0,0,0,0,0,0,0 ; Eight old sprites...

 endfunc   6
;-------------------------------------------------------------------------------------------------------------

 name      "AmigaSpriteScreen", "(ScreenID)"
 flags
 amigalibs _IntuitionBase, a6
 params     a0_l
 debugger   7

  MOVE.l      a0, _Screen(a5)
  LEA.l    44(a0), a0
  MOVE.l      a0, _ViewPort(a5)
  JMP        _RethinkDisplay(a6)         ;

 endfunc    7

;-------------------------------------------------------------------------------------------------------------

 name      "ChangeAmigaSpriteResolution", "(NewResolution) - 1=LowRes, 2=HighRes, 3=SuperHighRes"
 flags
 amigalibs _GraphicsBase, a6, _IntuitionBase, d2
 params     d0_w
 debugger   9

  MOVE.l   _ViewPort(a5), a0
  MOVEA.l   4(a0),a0                   ; Get *ViewPort\ColorMap
  LEA.l    _ChangeResolutionTag(pc),a1
  MOVE.w    d0, 6(a1)
  JSR      _VideoControl(a6)           ; (*ColorMap, *TagList) - a0/a1
  EXG.l     d2,a6
  MOVE.l   _Screen(a5), a0             ;
  JSR      _MakeScreen(a6)             ; (*Screen) - a0
  JSR      _RethinkDisplay(a6)         ;
  EXG.l   d2,a6
  RTS
  
  CNOP 0,4  ; LW align structure!

_ChangeResolutionTag:
  Dc.l VTAG_SPRITERESN_SET, 0
  Dc.l 0

 endfunc   9

;-------------------------------------------------------------------------------------------------------------
 base
LibBase:
 DC.l 0   ; _Sprite
 DC.l 0   ; _ViewPort
 DC.l 0   ; _ObjNum
 DC.l 0   ; _MemPtr
 DC.l 0   ; _Screen


; GetPosition ***********************************************
;
; Flush: d0 - a1/a3
;
l_GetPositionBase:
  MOVEA.l _MemPtr(a5), a3
  LSL.l    #ObjectShift, d0
  ADD.l    d0,a3
  MOVE.l   (a3), a1   ;
  MOVE.l   a1, d0           ; 15/11/1998 added to allow fast TST.l instead of CMP.l #0, a1
  RTS

  CNOP 0,4   ; LW align next code..better for 68040+ CPU

; FreeSprite ************************************************
;
; Must have gfxbase in a6 , 
;
l_FreeSpriteBase:
  MOVEM.l  a2-a3,-(a7)
  JSR     _GetPositionBase(a5) ; Input d0, Result a1 - a3 store the current pos.
  TST.l    d0                  ;
  BEQ     _EndFreeSprite
  CLR.l    (a3)+                ;
  MOVE.l   a1, a2
  JSR     _FreeSpriteData(a6)  ; (*Sprite) - a2
_EndFreeSprite:
  MOVEM.l  (a7)+,a2-a3
  RTS

 endlib
;-------------------------------------------------------------------------------------------------------------
 startdebugger

_InitCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  RTS


_MaxiCheck:
  TST.l   _MemPtr(a5)     ; If the lib wasn't initialized..
  BEQ      Error0         ;
  TST.l    d0             ; If  BitMap < 0
  BMI      Error1         ;
  ;ADDQ.l   #1,d0          ;
  CMP.l   _ObjNum(a5),d0  ; If  BitMap > #NumMax
  BGE      Error1         ;
  ;SUBQ.l   #1,d0          ;
  RTS


_CurrentCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  TST.l   _Sprite(a5)
  BEQ      Error2
  RTS


_ExistCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  CMP.l   _ObjNum(a5), d0
  BGE      Error1
  MOVEA.l _MemPtr(a5), a0           ; Now see if the given number
  MOVE.l   d0, d1                   ; is really initialized
  LSL.l    #ObjectShift, d1         ;
  ADD.l    d1, a0
  MOVE.l   (a0), d1
  BEQ      Error3
  RTS


Error0:  debugerror "InitBitMap() doesn't have been called before"
Error1:  debugerror "Maximum 'BitMap' objects reached"
Error2:  debugerror "There is no current used 'BitMap'"
Error3:  debugerror "Specified  BitMap object number isn't initialized"

 enddebugger

