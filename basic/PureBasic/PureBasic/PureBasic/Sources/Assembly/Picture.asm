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
; PureBasic 'Picture' library
;
;
; 10/09/2005
;  -Doobrey-  Ooops, changed one of the debugger checks to preserve regs.
;
; 04/09/2005
;  -Doobrey-  Ignore the warning below, can compile with OPT 3 now ;) (hint: Don't hardcode offsets to routines in lib base!!)
;             Several small changes on branching to exit command, when MOVEM.l (a7)+,xxx:RTS only adds a little to the size.
;             Now all commands support the API style of reg usage..ie only trash d0-d1/a0-a1.
;
;  Todo :Check potential bug in GetNumberOfBytesPerLine routine.. in PictureToBitMap()
;
;
; -------------------------------------------------------
;
; WARNING WARNING WARNING WARNING WARNING WARNING WARNING
;
; Compile with OPT=0
;
; WARNING WARNING WARNING WARNING WARNING WARNING WARNING
;
; -------------------------------------------------------
;
; 09/03/2000
;   Recompiled successfully under PhxAss.
;   This library support both interleaved or normal bitmaps !
;
; 03/08/1999
;   Added debugger support
;
; 22/07/1999
;   Protected the a2/a3 registers
;
; 21/07/1999
;   Fixed a bug in the 'GetNumPerLine' subroutine
;   Fixed a bug in 'GetIFFChunk' routine
;
; 15/07/1999
;   FirstVersion
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16

FORM = $464F524D   ; Constants need to handle IFF pictures
ILBM = $494C424D   ;
BMHD = $424D4844   ;
CMAP = $434D4150   ;
BODY = $424F4459   ;

_PicturePtr = 0
_ObjNum     =  _PicturePtr+4
_MemPtr     =  _ObjNum+4

GetPosition = l_GetPosition - LibBase 
FreePicture = l_FreePicture - LibBase 
GetIFFChunk = l_GetIFFChunk - LibBase 

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

 initlib "Picture", "Picture", "FreePictures", 0, 1, 0

;
; Now do the functions...
;
;------------------------------------------------------------------------------------------------------
 name      "InitPicture", "()"
 flags      LongResult
 amigalibs  _ExecBase,  a6
 params     d0_l
 debugger   1

  ADDQ.l   #1, d0              ; Needed to have the correct number  
  MOVE.l   d0, _ObjNum(a5)     ; Set the Objects Numbers
  LSL.l    #2, d0              ; d0*4
  MOVE.l   #MEMF_CLEAR, d1     ; Fill memory of '0'
  JSR     _AllocVec(a6)        ; (d0,d1)
  MOVE.l   d0, _MemPtr(a5)     ; Set *MemPtr
  RTS

 endfunc    1

;------------------------------------------------------------------------------------------------------
;-- trashes d4.. FreePictures(a5) saves regs itself ;)

 name      "FreePictures", "()"
 flags
 amigalibs _ExecBase,  a6
 params
 debugger   2

  MOVE.l  d4,-(a7)          ; Save it
  MOVE.l  _ObjNum(a5), d4   ; Num Objects
  BNE     _LoopFreePictures
  MOVE.l (a7)+,d4           ; Restore it.
  RTS

_LoopFreePictures:            ; Close all the opened palette
  SUBQ     #1, d4
  MOVE.l   d4, d0
  JSR      FreePicture(a5)
  TST.l    d4
  BNE     _LoopFreePictures   ; Repeat:Until d4 = 0

  MOVE.l (a7)+,d4             ; Restore d4
  MOVEA.l _MemPtr(a5), a1     ;
  JMP     _FreeVec(a6)        ; (a1/d0) - RTS is automagiclly done (MEGA Optim :-)

 endfunc   2

;------------------------------------------------------------------------------------------------------

 name      "FreePicture", "(#Picture)"
 flags     InLine
 amigalibs _ExecBase,  a6
 params     d0_l
 debugger   3, _ExistCheck

  JMP       FreePicture(a5)

 endfunc    3

;------------------------------------------------------------------------------------------------------

 name      "UsePicture", "(#Picture)"
 flags      LongResult
 amigalibs
 params     d0_l
 debugger   4, _ExistCheck

  MOVE.l   a3,-(a7)
  JSR      GetPosition(a5)      ; Input d0, Result a1 - a3 store the current pos.
  MOVE.l   a1,d0
  BEQ     _EndUsePicture        ; Hmm, shouldn't it set _PicturePtr to 0 if failed ?
  MOVE.l   a1, _PicturePtr(a5)  ;
_EndUsePicture:
  MOVE.l   (a7)+,a3
  RTS

 endfunc    4

;------------------------------------------------------------------------------------------------------
;    ExecBase is in d2, no longer Move.l $4,a6 !
;    Changed branches to exit to  MOVEM.l xxxx :RTS ..a bit quicker, only adds a little to code size.
;

 name      "LoadPicture", "(#Picture, FileName$)"
 flags      LongResult
 amigalibs _DosBase,  a6 ,_ExecBase,d2
 params     d0_l,  d1_l
 debugger   5, _MaxiCheck

  MOVEM.l d2-d7/a3,-(a7)  ; Save registers.
  MOVEA.l  d2,a3                ; Use a3 to swap between Dos and Exec

  MOVE.l   d0, d7

  MOVE.l   #1005, d2  ; Mode Read
  JSR     _Open(a6)   ; (FileName$, Mode) - d1/d2
  TST.l    d0         ;
  BEQ     _LPFault1   ; File not found
  MOVE.l   d0, d5     ; Store the file ptr in 'd5'

  MOVE.l   d5, d1         ; Read the 12 first bytes
  LEA.l   _IFFTmp(pc), a0 ; of the file in our buffer
  MOVE.l   a0, d2         ;
  MOVEQ    #12, d3        ;
  JSR     _Read(a6)       ; - d1,d2,d3

  MOVE.l   d2, a0
  MOVE.l   (a0)+, d0    ; Should be #FORM
  MOVE.l   (a0)+, d4    ; Get the file size
  MOVE.l   (a0) , d1    ; Should be #ILBM

  CMP.l    #FORM, d0    ;
  BNE     _LPFault2     ;
  CMP.l    #ILBM, d1    ;
  BNE     _LPFault2     ;

  ADDQ.l   #8, d4       ;

  EXG.l a3,a6                ; Swap lib bases

  MOVE.l   d4,d0
  MOVEQ    #0,d1
  JSR     _AllocVec(a6)      ; - d0,d1
  EXG.l    a3,a6       ; Swap lib bases back.
  TST.l    d0
  BEQ     _LPFault3
  MOVE.l   d0, d6    ; Dest buffer

  MOVE.l   d5,d1     ; Go to the begin of File...
  MOVEQ    #0,d2     ;
  MOVEQ    #-1,d3    ;
  JSR     _Seek(a6)  ;

  MOVE.l   d5, d1    ; File ptr
  MOVE.l   d6, d2    ; Dest buffer
  MOVE.l   d4, d3    ; Size of Read
  JSR     _Read(a6)  ; - d1,d2,d3

  MOVE.l   d5, d1    ; Close the file
  JSR     _Close(a6) ; d1

  MOVE.l   d7, d0
  JSR      GetPosition(a5)
  MOVE.l   d2, (a3)+           ; Set *Picture
  MOVE.l   d2, _PicturePtr(a5) ;

  MOVE.l   d2, d0    ; Return the mem pointer
  MOVEM.l (a7)+,d2-d7/a3  ; Restore registers.
  RTS

_LPFault1:
  MOVEQ    #-1, d0   ; File not found
  MOVEM.l (a7)+,d2-d7/a3  ; Restore registers.
  RTS

_LPFault2:
  MOVEQ    #-2, d0   ; Not an IFF/ILBM file
  MOVEM.l (a7)+,d2-d7/a3  ; Restore registers.
  RTS

_LPFault3:
  MOVEQ    #-3, d0   ; Not enough memory free
                     ;
_NLP_End:
  MOVEM.l (a7)+,d2-d7/a3  ; Restore registers.
  RTS

 CNOP 0,4 ; Align
  
_IFFTmp:
 Dc.l 0,0,0

 endfunc   5

;------------------------------------------------------------------------------------------------------

 name      "PictureWidth", "()"
 flags
 amigalibs
 params
 debugger   6, _CurrentCheck

  MOVE.l  _PicturePtr(a5), d0
  MOVE.l   #BMHD, d1     ; If not, quit.
  JSR      GetIFFChunk(a5)   ; Input d0,d1 - Flush d0/d1-a0/a1
  TST.l    d0            ;
  BEQ     _EndIFFWidth   ; Not valid IFF file, return '0'
  MOVE.l   d0, a0        ;
  MOVEQ    #0,d0         ;
  MOVE.w   (a0), d0      ; Get IFF Width
_EndIFFWidth:
  RTS

 endfunc   6

;------------------------------------------------------------------------------------------------------

 name      "PictureHeight", "()"
 flags
 amigalibs
 params
 debugger   7, _CurrentCheck

  MOVE.l  _PicturePtr(a5), d0
  MOVE.l   #BMHD, d1     ; If not, quit.
  JSR      GetIFFChunk(a5)   ; Input d0,d1 - Flush d0/d1-a0/a1
  TST.l    d0            ;
  BEQ     _EndIFFHeight  ; Not valid IFF file, return '0'
  MOVE.l   d0, a0        ;
  MOVEQ    #0,d0         ;
  MOVE.w   2(a0), d0     ; Get IFF Height
_EndIFFHeight:
  RTS

 endfunc    7

;------------------------------------------------------------------------------------------------------

 name      "PictureDepth", "()"
 flags
 amigalibs
 params
 debugger   8, _CurrentCheck

  MOVE.l  _PicturePtr(a5), d0
  MOVE.l   #BMHD, d1     ; If not, quit.
  JSR      GetIFFChunk(a5) ; Input d0,d1 - Flush d0/d1-a0/a1
  TST.l    d0            ;
  BEQ     _EndIFFDepth   ; Not valid IFF file, return '0'
  MOVE.l   d0, a0        ;
  MOVEQ    #0,d0         ;
  MOVE.b   8(a0), d0     ; Get IFF Width
_EndIFFDepth:
  RTS

 endfunc    8

;------------------------------------------------------------------------------------------------------

 name      "PictureToBitMap", "(#Picture, BitMapID())"
 flags
 amigalibs
 params     d0_l,  d1_l
 debugger   9, _ExistCheck

  ; d1 is the plane counter
  ; d2 is the height decreased at each loop
  ; d3 is the IFF Picture depth
  ; d4 is the IFF Picture number of bytes per lines...
  ; d5 is the plane offset
  ;
  ; a1, a2 = Bitmap struct Addr

  MOVEM.l  d2-d7/a2-a3,-(a7)  ; Save registers
  JSR      GetPosition(a5) ; Get Picture addr

  MOVE.l   a1, a3        ;
  MOVE.l   d1, a2        ; Bitmap Addr

  MOVE.l   a3, d0          ; Try to get the BMHD Chunk
  MOVE.l   #BMHD, d1       ; If not, quit.
  JSR      GetIFFChunk(a5) ; Flush d0/d1-a0/a1
  TST.l    d0              ;
  BEQ     _Fault1

  MOVE.l   d0, a0
  MOVE.w   2(a0), d2     ; Get IFF Height
  MOVE.b   8(a0), d3     ; Get IFF Depth
  MOVE.w   (a0), d0      ; Get IFF Width

  BSR     _GetNumPerLine ; Flush d0/d1
  MOVE.w   d0, d4        ; Number of byte per line of each bitplane
  MOVE.b   10(a0), d5    ; Get compression mode

  ; Just check if the Bitmap can support this picture
  ;
  CMP.w     (a2), d4     ; Check BitPerRow
  BGT     _Fault2        ;
  CMP.w    2(a2), d2     ; Check Row (ie: Height)
  BGT     _Fault2        ;
  CMP.b    5(a2), d3     ; Check Depth
  BGT     _Fault2        ;

  MOVE.l   a3, d0
  MOVE.l   #BODY, d1
  JSR      GetIFFChunk(a5)   ; Flush d0/d1-a0/a1
  TST.l    d0            ;
  BEQ     _Fault1        ;

  MOVE.l   d0, a0        ;

  SUBQ.l   #1, d2        ; Right setup numbers for fast loops...
  SUBQ.l   #1, d4        ;

  TST.b    d5
  BEQ     _NotCompressed

  CMP.b    #1, d5
  BEQ     _ByteRunCompressed

_Fault1:            ; BMHD chunk or BODY chunk not found
  MOVEQ    #-1, d0  ;
  MOVEM.l  (a7)+,d2-d7/a2-a3  ; Restore registers
  RTS

_Fault2:
  MOVEQ    #-2, d0  ; Picture is too big for this bitmap

_End:
  MOVEM.l  (a7)+,d2-d7/a2-a3  ; Restore registers
  RTS


_ByteRunCompressed:

  MOVEQ    #0,d5         ;

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

  ; a =  ReadByte        ;

  MOVE.b  (a0)+, d6      ;

  ; If a >= 0

  CMP.b    #0, d6
  BGE     _Case1         ; Read the n next byte without change

  CMP.b    #-128, d6
  BEQ     _Next2         ; Ignore this byte

  ; g = -a
  ; a =  ReadByte
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
  ;   a =  ReadByte
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

  MOVE.w   (a2), d0
  EXT.l    d0
  ADD.l    d0, d5         ; Add the plane offset for next bitplane write

  DBF      d2, _LLoop3    ; Process it for all the picture Height  

  MOVEQ    #0,d0
  MOVEM.l  (a7)+,d2-d7/a2-a3  ; Restore registers
  RTS

; ************************************************************
;
; Not Compressed IFF/BODY decompression routine for interleaved
; or normal bitmaps !
;
;


_NotCompressed:
  MOVEQ    #0,d5

_Loop3:
  MOVEQ    #0,d1         ; Our bitplane counter

_Loop2:
  MOVE.l   a2, a1        ; Get 1st plane addr

  MOVE.w   d1, d0        ; Get right plane addr
  LSL.w    #2, d0        ;

  MOVE.l   8(a1,d0), a1  ;
  ADD.l    d5, a1

  MOVE.w   d4, d0        ; Get Number of pixel per line and
_Loop1:                  ; fill the bitmap
  MOVE.b  (a0)+, (a1)+   ;
  DBF      d0, _Loop1    ;

  ADDQ.l   #1, d1        ; Add the plane counter..
  CMP.w    d1, d3        ;
  BNE     _Loop2         ;

  MOVE.w   (a2), d0      ;
  EXT.l    d0
  ADD.l    d0, d5

  DBF      d2, _Loop3    ; Process it for all the picture Height  

  MOVEQ    #0,d0
  MOVEM.l  (a7)+,d2-d7/a2-a3  ; Restore registers
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

 endfunc   9

;------------------------------------------------------------------------------------------------------
;
 name      "PictureID", "()"
 flags      LongResult | InLine
 amigalibs
 params
 debugger   10, _CurrentCheck

  MOVE.l  _PicturePtr(a5), d0
  I_RTS

 endfunc    10

;------------------------------------------------------------------------------------------------------

 name      "GrabPicture","(#Picture,BitMapID,PaletteID)"
 flags      LongResult
 amigalibs _ExecBase, a6
 params     d0_l, d1_l, d2_l
 debugger   11, _GrabPicture_Check

  MOVEM.l  d2-d7/a2-a3,-(a7)  ; Save registers
  JSR      GetPosition(a5) ; A3 hold #Picture

  MOVE.l   d1,a2           ; use BitMapID

  CLR.l    d0              ; ...
  MOVE.b   5(a2),d0        ; get \Depth
  CLR.l    d1              ; ...
  MOVE.w   0(a2),d1        ; get \BytesPerRow
  MOVE.l   d1,d4           ; ...
  CLR.l    d7              ; regulare bitmap

  CMPI.w   #1,d0           ; only one bitmap
  BEQ      GP_l0           ; yep

  DIVU.w   d0,d1           ; \BytesPerRow / \Depth
  ADD.l    8(a2),d1        ; + first bitmap ptr
  CMP.l    12(a2),d1       ; same as second bitmap ptr
  BNE      GP_l0           ; nope

  DIVU.w   d0,d4           ; fix real bytes per row
  MOVEQ    #1,d7           ; interleavled bitmap

GP_l0
  MOVEQ    #1,d3           ; ...
  LSL.l    d0,d3           ; ...
  MULU.w   #3,d3           ; ...
  MOVE.l   d4,d6           ; ...
  MULU.w   2(a2),d4        ; \BytesPerRow * \Rows
  MULU.w   d0,d4           ; * \Depth

  MOVEQ    #48,d5          ; ilbm, bmhd, cmap and body id size
  ADD.l    d3,d5           ; add cmapdata size
  ADD.l    d4,d5           ; add bodydata size

  MOVE.l   d5,d0           ; arg1.
  ADDQ.l   #8,d0           ; add form id size
  MOVEQ    #1,d1           ; ...
  SWAP     d1              ; arg2.
  JSR     _AllocVec(a6)    ; (size,req) - d0/d1

  MOVE.l   d0,(a3)         ; set \Picture
  BEQ      GP_End          ; ...

  MOVE.l   d0,a1           ; ...

  MOVE.l   #FORM,(a1)+     ; set FORM ID
  MOVE.l   d5,(a1)+        ; set ckSize

  MOVE.l   #ILBM,(a1)+     ; set ILBM ID

  MOVE.l   #BMHD,(a1)+     ; set BMHD ID
  MOVE.l   #20,(a1)+       ; set ckSize

  MULU.w   #8,d6           ; calc width in pixels
  MOVE.w   d6,(a1)+        ; set w
  MOVE.w   2(a2),(a1)+     ; set h
  MOVE.l   #0,(a1)+        ; set x & y
  MOVE.b   5(a2),(a1)+     ; set nPlanes
  MOVE.b   #0,(a1)+        ; set masking
  MOVE.b   #0,(a1)+        ; set compression
  MOVE.b   #0,(a1)+        ; set pad1
  MOVE.w   #0,(a1)+        ; set transparentColor
  MOVE.b   #0,(a1)+        ; set xAspect
  MOVE.b   #0,(a1)+        ; set yAspect
  MOVE.w   #320,(a1)+      ; set pageWidth
  MOVE.w   #256,(a1)+      ; set pageHeight

  MOVE.l   #CMAP,(a1)+     ; set CMAP ID
  MOVE.l   d3,(a1)+        ; set ckSize

  MOVE.l   d2,a0           ; use PaletteID
  MOVE.l   (a0)+,d6        ; get num of colors
  SWAP     d6              ; put it right
  SUBQ.w   #1,d6           ; loop counter

GP_loop0
  MOVE.b   0(a0),(a1)+     ; move red
  MOVE.b   4(a0),(a1)+     ; move green
  MOVE.b   8(a0),(a1)+     ; move blue

  ADDA.w   #12,a0          ; next palette reg
  DBRA     d6,GP_loop0     ; loop until out of colors

  MOVE.l   #BODY,(a1)+     ; set BODY ID
  MOVE.l   d4,(a1)+        ; set ckSize

  CLR.l    d0              ; ...
  MOVE.b   5(a2),d0        ; get \Depth
  TST.l    d7              ; interleavled bitmap
  BEQ      GP_l1           ; nope

  CLR.l    d1              ; ...
  MOVE.w   0(a2),d1        ; get \BytesPerRow
  MOVE.l   d1,d2           ; ...
  DIVU.w   d0,d1           ; \BytesPerRow / \Depth
  SUB.l    d1,d2           ; bytes to next row, bitmap
  MOVE.l   d2,d3           ; bytes to next row, body
  BRA      GP_l2           ; ...

GP_l1
  CLR.l    d1              ; ...
  MOVE.w   0(a2),d1        ; get \BytesPerRow
  CLR.l    d2              ; bytes to next row, bitmap
  MOVE.l   d1,d3           ; ...
  MULU.w   d0,d3           ; \Depth * \BytesPerRow
  SUB.l    d1,d3           ; bytes to next row, body

GP_l2
  CLR.l    d4              ; offset
  MOVE.w   d0,d7           ; use \Depth
  SUBQ.l   #1,d7           ; fix loop counter
  MOVE.l   a1,d0           ; save first body row

GP_loop1
  MOVE.w   2(a2),d6        ; get \Rows
  SUBQ.w   #1,d6           ; fix loop counter
  MOVE.l   8(a2,d4),a0     ; next bitmap ptr

GP_loop2
  MOVE.w   d1,d5           ; use bytes per row
  SUBQ.w   #1,d5           ; fix loop counter

GP_loop3
  MOVE.b   (a0)+,(a1)+     ; bitmap -> body
  DBRA     d5,GP_loop3     ; loop until end of row

  ADD.l    d2,a0           ; inc to next row, bitmap
  ADD.l    d3,a1           ; inc to next row, body
  DBRA     d6,GP_loop2     ; loop until out of rows

  ADDQ.l   #4,d4           ; inc offset
  ADD.l    d1,d0           ; inc to next row, body
  MOVE.l   d0,a1           ; use next row, body
  DBRA     d7,GP_loop1     ; ...

  MOVE.l   (a3),d0         ; return \Picture

GP_End
  MOVEM.l  (a7)+,d2-d7/a2-a3  ; Restore registers
  RTS

 endfunc 11

;------------------------------------------------------------------------------------------------------

 name      "SavePicture","(#Picture,FileName$)"
 flags      LongResult
 amigalibs _DosBase, a6
 params     d0_l, d1_l
 debugger   12, _ExistCheck

  MOVEM.l  d2-d5/a3,-(a7)  ; Save registers
  JSR      GetPosition(a5) ; A3 hold #Picture

  MOVE.l   a1,a3           ; ...

  MOVE.l   #1006,d2        ; arg2.
  JSR     _Open(a6)        ; (name,mode) - d1/d2

  MOVE.l   d0,d5           ; ...
  BEQ      SP_End          ; ...

  MOVE.l   d0,d1           ; arg1.
  MOVE.l   a3,d2           ; arg2.
  MOVE.l   4(a3),d3        ; arg3.
  ADDQ.l   #8,d3           ; ...
  JSR     _Write(a6)       ; (file,buf,len) - d1/d2/d3

  MOVE.l   d0,d4           ; use later

  MOVE.l   d5,d1           ; arg1.
  JSR     _Close(a6)       ; (file) - d1

  MOVE.l   d4,d0           ; any error
  BGE      SP_End          ; nope

  MOVEQ    #0,d0           ; ...

SP_End
  MOVEM.l (a7)+,d2-d5/a3  ; Restore registers
  RTS

 endfunc 12

;------------------------------------------------------------------------------------------------------

 base
LibBase:


 Dc.l 0      ; PicturePtr - Active Picture Ptr
 Dc.l 0      ; ObjNum
 Dc.l 0      ; MemPtr


; GetPosition **********************************************
;
;
l_GetPosition:
  MOVEA.l _MemPtr(a5), a3
  LSL.l    #2, d0
  ADD.l    d0, a3
  MOVE.l   (a3), a1
  RTS


; FreePicture **********************************************
; A6 must be ExecBase on entry:
;
l_FreePicture:
  MOVE.l   a3,-(a7)
  JSR      GetPosition(a5)    ; Input d0, Result a1 - a3 store the current pos.
  MOVE.l   a1,d0
  BEQ     _EndFreePicture
  CLR.l (a3)
  JSR     _FreeVec(a6)        ; Free it   - a1/d0
_EndFreePicture:
  MOVE.l   (a7)+,a3
  RTS


; GetIFFChunk **********************************************
;
; d0 = *Picture
; d1 = ChunkID
;
l_GetIFFChunk:
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

  Even

 endlib

;------------------------------------------------------------------------------------------------------

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
  TST.l   _PicturePtr(a5)
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


_GrabPicture_Check

  MOVEM.l  d3-d5,-(a7) ; Save registers
  TST.l   _MemPtr(a5)
  BEQ      Error0
  CMP.l   _ObjNum(a5), d0
  BGE      Error1
  MOVEA.l _MemPtr(a5), a0
  MOVE.l   d0, d3
  LSL.l    #2, d3
  ADD.l    d3, a0
  MOVE.l   (a0), d3
  BNE      Error4
  MOVE.l   d1,a0
  MOVE.l   d2,a1
  MOVE.b   5(a0),d3
  MOVEQ    #1,d4
  LSL.l    d3,d4
  MOVE.l   (a1),d5
  SWAP     d5
  CMP.l    d4,d5
  BNE      _Do_Error5   ; need to restore regs first
  MOVEM.l  (a7)+,d3-d5  ;
  RTS

_Do_Error5
  MOVEM.l (a7)+,d3-d5
  BRA Error5


Error0:  debugerror "InitPicture() doesn't have been called before"
Error1:  debugerror "Maximum 'Picture' objects reached"
Error2:  debugerror "There is no current used 'Picture'"
Error3:  debugerror "Specified #Picture object number isn't initialized"
Error4:  debugerror "Specified #Picture object number is initialized"
Error5:  debugerror "BitMap and Palette have color number Mismatch"

 enddebugger

