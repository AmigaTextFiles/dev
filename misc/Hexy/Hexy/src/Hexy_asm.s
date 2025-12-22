
;*
 * [!BGN - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 * Program   : Hexy (Binary file viewer/editor for the Amiga.)
 * Version   : 1.6
 * File      : Work:Source/!WIP/HisoftProjects/Hexy/Hexy_asm.s
 * Author    : Andrew Bell
 * Copyright : Copyright © 1998-1999 Andrew Bell (See GNU GPL)
 * Created   : Saturday 28-Feb-98 16:00:00
 * Modified  : Sunday 22-Aug-99 23:31:45
 * Comment   : 
 *
 * (Generated with StampSource 1.2 by Andrew Bell)
 *
 * [!END - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
;*


;*
 * -------------------------------------------------------------
 * Amiga MC680x0 assembly support routines for Hexy v1.x
 *
 * Copyright © 1998-1999 Andrew Bell, <andrew.ab2000@bigfoot.com>
 * --------------------------------------------------------------
 *
 * Hexy, binary file viewer and editor for the Amiga.
 * Copyright (C) 1999 Andrew Bell
 *
 * Author's email address: andrew.ab2000@bigfoot.com
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * --------------------------------------------------------------
 *
 * This file created on Fri/27/Feb/1998
 *
 * This code makes Hexy that *little bit* faster than other hex viewers :-)
 * 
 * TODO: Optimize and more loop unrolling.
 *
 * NOTES: Use an assembler that can do full branch optimizations when
 *        compiling this code.
 *
 *        060 users: There could be some 020 instructions in here that
 *        have since been removed from the 060. I haven't had the chance
 *        to check. If this is the case, then they'll have to be emulated
 *        in software which will mean a drop in performance.
 *
;*

                incdir  AInc:
                include mymacros.i
                include exec/types.i
                include lvo/exec_lib.i
                include lvo/graphics_lib.i
                include lvo/utility_lib.i

                SECTION text,code
                MC68020

                IFD     _PHXASS_

                TTL     Hexy_asm.s
                SYMDEBUG
                LINEDEBUG
                OPT     !

                ENDC

                rsreset
VC_FileAddress  rs.l    1
VC_FileLength   rs.l    1
VC_CurrentPoint rs.l    1
VC_RPort        rs.l    1
VC_InitialYPos  rs.w    1
VC_YAmount      rs.w    1
VC_XPos         rs.w    1
VC_Mode         rs.w    1
VC_SIZEOF       rs.l    0

                xdef    HEX.MainLoop    ; temp
                xdef    HEX.FilterLoop
                xdef    HEX.Insert
                xdef    HEX.TestClip
                xdef    HEX.InitClip
                xdef    HEX.InitCHEXPart
                xdef    HEX.ClipHEXPart
                xdef    HEX.Loop001
                xdef    HEX.ClipSPInit
                xdef    HEX.ClipStrPart
                xdef    HEX.Render

*---------------------------------------------------------------------------*

                xdef    _AdjustView

_AdjustView:    PUSH    ALL             ; A0=VC, D0=Offset (Signed)

                move.l  VC_CurrentPoint(a0),d1
                add.l   d0,d1
                bmi.b   .SetToZero

                move.l  VC_FileLength(a0),d2
                beq.w   .Exit

                subq.l  #1,d2           ; -1 so we can see last byte
                cmp.l   d2,d1
                ble.b   .SizeOK

                move.l  d2,d1
                bra.b   .SizeOK

.SetToZero      moveq   #0,d1
.SizeOK         move.l  d1,VC_CurrentPoint(a0)
                bsr.b   _UpdateView

.Exit           PULL    ALL
                rts

*---------------------------------------------------------------------------*

; D7.w = lines left
; D6.w = current Y pixel
; A4.l = memory address

                xref    _GfxBase
                xref    _SysBase
                xdef    _UpdateView

                xref    _EditFlag               ; BOOL (16 bit)

                xref    _Edit_WipeCursor        ; C code
                xref    _Edit_ShiftCursor

R_UPDATEVIEW    reg     d0-d1/d5-d7/a0-a1/a4-a6

_UpdateView:    PUSH    R_UPDATEVIEW            ; A0=VC, D0=MODE

                move.l  a0,a5                   ; A4=VC

                tst.w   _EditFlag
                beq.w   .NotActive

                jsr     _Edit_WipeCursor        ; Call C code

.NotActive      moveq   #1,d0                   ; Black
                move.l  VC_RPort(a5),a1         ; RP
                SETLIB  _GfxBase,SetAPen

                move.w  VC_YAmount(a5),d7       ; Amount of Y lines
                subq.w  #1,d7
                move.w  VC_InitialYPos(a5),d6   ; Current Y pixel
                move.l  VC_CurrentPoint(a5),d5  ; Current offset

                move.l  VC_FileAddress(a5),d0
                beq.w   .Exit
                move.l  d0,a4
                add.l   d5,a4                   ; File Adr + Cur pnt

                tst.w   VC_Mode(a5)
                beq.b   .HEX
.ASCII          bsr.w   ASCII.Mode
                bra.b   .Exit
.HEX            bsr.w   HEX.Mode

.Exit           tst.w   _EditFlag
                beq.b   .NotActive2

                moveq   #0,d0
                jsr     _Edit_ShiftCursor       ; Call C code

.NotActive2     PULL    R_UPDATEVIEW
                rts

                *-----------------------------------------------------------*

                xdef    HEX.Mode

HEX.Mode        PUSH    ALL

HEX.MainLoop    cmp.l   VC_FileLength(a5),d5
                blt.b   HEX.DoPaste
                lea     EmptyLine(pc),a2
                bra     HEX.Render

HEX.DoPaste     lea     DumpLine(pc),a0         ; A0=Write
                move.l  a0,a2
                move.l  a4,a1                   ; A1=LONG read
                move.l  d5,d0                   ; Do Offset
                bsr.w   LongToHex
                move.b  #':',(a0)+

                moveq   #' ',d2

                ; Loop rolled out 5 times for speed

                move.l  (a1)+,d0
                bsr.w   LongToHex
                move.b  d2,(a0)+

                move.l  (a1)+,d0
                bsr.w   LongToHex
                move.b  d2,(a0)+

                move.l  (a1)+,d0
                bsr.w   LongToHex
                move.b  d2,(a0)+

                move.l  (a1)+,d0
                bsr.w   LongToHex
                move.b  d2,(a0)+

                move.l  (a1)+,d0
                bsr.w   LongToHex
                move.b  d2,(a0)+

                moveq   #19,d1                  ; Filter 20-1 bytes
HEX.FilterLoop  move.b  (a4)+,d0
                bne.b   HEX.Insert

                moveq   #1,d0
HEX.Insert      move.b  d0,(a0)+
                dbf.w   d1,HEX.FilterLoop
                clr.b   (a0)+                   ; Terminate string

                *-----------------------------------------------------------*

                ; if (offset < len-20) then goto HEX.Render

HEX.TestClip    move.l  VC_FileLength(a5),d0    ; Use an An
                sub.l   #(4*5),d0
                cmp.l   d5,d0
                bge.b   HEX.Render
HEX.InitClip    move.l  VC_FileLength(a5),d0
                sub.l   VC_CurrentPoint(a5),d0  ; (or d5)

                ;moveq #(4*5),d1
                ;divul.l d1,d1:d0

                xref    _UtilityBase

                move.l  a6,-(sp)
                moveq   #(4*5),d1
                SETLIB  _UtilityBase,UDivMod32
                move.l  (sp)+,a6

                moveq   #20,d0
                sub.l   d1,d0
                move.l  d0,d3
                move.l  d1,d4
                beq.b   HEX.Render
HEX.InitCHEXPart
                move.l  d1,d0                   ; Get Dump Remainder

                ;moveq #4,d1
                ;divul.l d1,d1:d0

                move.l  a6,-(sp)
                moveq   #4,d1
                SETLIB  _UtilityBase,UDivMod32
                move.l  (sp)+,a6

                move.l  d1,-(sp)                ; Store lrem
                moveq   #9,d1
                mulu.l d1,d0                    ; x9 ('00000000 ')
                move.l  (sp)+,d1                ; Restore remainder
                lsl.l   #1,d1                   ; x2
                add.l   d1,d0                   ; Add result to lrem
HEX.ClipHEXPart lea     DumpLine(pc),a0         ;   to get wipe index
                lea     9(a0,d0.w),a0
                moveq   #(5*9),d1               ; -1 aswell
                sub.l   d0,d1
                beq.b   HEX.ClipSPInit
                bmi.b   HEX.ClipSPInit
                moveq   #' ',d0
HEX.Loop001     move.b  d0,(a0)+
                subq.l  #1,d1
                bne.b   HEX.Loop001

HEX.ClipSPInit  lea     DumpLine(pc),a0
                lea     (6*9)(a0,d4.w),a0
                tst.l   d3
                beq.b   HEX.Invalid01
                bmi.b   HEX.Invalid01

                moveq   #' ',d0
HEX.ClipStrPart move.b  d0,(a0)+
                subq.l  #1,d3
                bne.b   HEX.ClipStrPart

HEX.Invalid01   *-----------------------------------------------------------*

HEX.Render      move.w  VC_XPos(a5),d0          ; Set X pix
                move.w  d6,d1                   ; Get Y pix
                move.l  VC_RPort(a5),a1         ; RP
                SETLIB  _GfxBase,Move

                moveq   #HLENGTH,d0
                movea.l a2,a0                   ; String
                move.l  VC_RPort(a5),a1         ; RP
                DOLIB   Text

                add.l   #20,d5
                addq.w  #8,d6
                dbf.w   d7,HEX.MainLoop

.Exit           PULL    ALL
                rts

*---------------------------------------------------------------------------*

ASCIIXAMOUNT    =       64

                xdef    ASCII.Mode

ASCII.Mode      PUSH    ALL

ASCII.MainLoop  cmp.l   VC_FileLength(a5),d5
                blt.b   ASCII.DoPaste

                lea     EmptyLine(pc),a2
                bra.b   ASCII.Render

ASCII.DoPaste   lea     DumpLine(pc),a0
                move.l  d5,d0
                bsr.w   LongToHex
                move.w  #': ',(a0)+
                moveq   #(ASCIIXAMOUNT-1),d1    ; Filter
ASCII.FltLoop   move.b  (a4)+,d0
                bne.b   ASCII.Insert
                moveq   #1,d0
ASCII.Insert    move.b  d0,(a0)+
                dbf.w   d1,ASCII.FltLoop
                lea     DumpLine(pc),a2

                *-----------------------------------------------------------*

                ; if (offset < len - ASCIIXAMOUNT) then goto ASCII.Render

ASCII.TestClip  move.l  VC_FileLength(a5),d0    ; Use an An
                sub.l   #ASCIIXAMOUNT,d0
                cmp.l   d5,d0
                bge.b   ASCII.Render

ASCII.InitClip  move.l  VC_FileLength(a5),d0
                sub.l   VC_CurrentPoint(a5),d0  ; (or d5)
                moveq   #ASCIIXAMOUNT,d1
                divul.l d1,d1:d0                ; Change this
                moveq   #ASCIIXAMOUNT,d0
                sub.l   d1,d0
                move.l  d0,d3
                move.l  d1,d4
                beq.b   ASCII.Render

ASCII.InitCHEXPart
                move.l  d1,d0                   ; Get Dump Remainder
                move.l  #ASCIIXAMOUNT,d2
                sub.l   d0,d2                   ; into index
                beq.b   ASCII.Render
                bmi.b   ASCII.Render

ASCII.Clip      lea     DumpLine(pc),a0
                lea     10(a0,d1.w),a0
                moveq   #' ',d0
ASCII.Loop001   move.b  d0,(a0)+
                subq.l  #1,d2
                bne.b   ASCII.Loop001

                *-----------------------------------------------------------*

ASCII.Render    move.w  VC_XPos(a5),d0          ; Set X pix
                move.w  d6,d1                   ; Get Y pix
                move.l  VC_RPort(a5),a1         ; RP
                SETLIB  _GfxBase,Move

                moveq   #HLENGTH,d0
                movea.l a2,a0                   ; String
                move.l  VC_RPort(a5),a1         ; RP
                DOLIB   Text

                add.l   #ASCIIXAMOUNT,d5
                addq.w  #8,d6
                dbf.w   d7,ASCII.MainLoop

                PULL    ALL
                rts

*---------------------------------------------------------------------------*

                xdef    LongToHex

; void LongToHex( register __d0 ULONG, register __a1 UBYTE *Dest );

LongToHex:      PUSH    d0-d5

                moveq   #7,d2                   ; 8 Digits
                moveq   #'0',d3
                moveq   #'9',d4
                moveq   #$f,d5

LTH.Loop        rol.l   #4,d0
                move.b  d0,d1
                and.b   d5,d1
                add.b   d3,d1
                cmp.b   d4,d1
                ble.b   LTH.NoLetter

                addq.b  #7,d1
LTH.NoLetter    move.b  d1,(a0)+
                dbra.w  d2,LTH.Loop

                PULL    d0-d5                   ; A0 = End of string
                rts

*---------------------------------------------------------------------------*

HLENGTH         =       (9+9+9+9+9+9+20)

EmptyLine       dcb.b   HLENGTH,$20
                dc.b    0,0
DumpLine        ds.b    128
                even

*---------------------------------------------------------------------------*


; NOTE: The following two routines have been taken from my own private
;       link library of routines.


******* AB.LIB/SearchMem ****************************************************
*
*   NAME   
*       SearchMem - Search memory for a binary string.
*
*   SYNOPSIS
*       Offset =  SearchMem( Mem, MemLen, CmpStr, CmpStrLen)
*       D0                   A0   D0      A1      D1
*
*       __asm ULONG SearchMem( __A0 void *Mem,
*                              __D0 ULONG MemLen,
*                              __A1 UBYTE *CmpStr,
*                              __D1 ULONG CmpStrLen );
*
*   FUNCTION
*       Look for a binary string in memory.
*
*   INPUTS
*       Mem       - Pointer to memory that will be searched.
*       MemLen    - Length of memory to be searched.
*       CmpStr    - Pointer to binary string to find.
*       CmpStrLen - Length of binary string to find
*
*   RESULT
*       ULONG Offset - Offset the binary string was found at (relative)
*                      to the Mem parameter. If string was not found then
*                      ~NULL is returned.
*
*   SEE ALSO
*       AB.LIB/SearchMemRev()
*
*****************************************************************************
* AB.LIB code module, created: 4/8/1997
*
* This file is copyright © 1997 Andrew Bell.
*
* __asm ULONG SearchMem(__A0 void *Mem, __D0 ULONG MemLen, __A1 UBYTE *CmpStr, __D1 ULONG CmpStrLen);
*

                xdef    SearchMem
                xdef    _SearchMem

SearchMem:
_SearchMem:     PUSH    d1-d4/a0-a3

                move.l  a0,-(sp)
                tst.l   d0              ; Check params
                beq.b   SM.Fail
                tst.l   d1
                beq.b   SM.Fail
                subq.l  #1,d1
                move.b  (a1)+,d2        ; Get first byte from match string
SM.Loop         cmp.b   (a0)+,d2        ; Compare next byte
                bne.b   SM.NextByte
                move.l  a0,a2
                subq.l  #1,d4
                move.l  a1,a3
                move.l  d1,d3
                beq.b   SM.Matched
                move.l  d0,d4           ; << BEQ.B here >>
SM.Loop2        cmpm.b  (a0)+,(a1)+     ; Match rest of string
                bne.b   SM.NoMatch
                subq.l  #1,d3
                beq.b   SM.Matched
                subq.l  #1,d4
                bne.b   SM.Loop2
                bra.b   SM.Fail
SM.Matched      subq.l  #1,a2
                move.l  a2,d0
                sub.l   (sp),d0
                bra.b   SM.Fin
SM.NoMatch      move.l  a3,a1
                move.l  a2,a0
SM.NextByte     subq.l  #1,d0
                bne.b   SM.Loop
SM.Fail         moveq.l #-1,d0

SM.Fin          addq.l  #4,sp
                PULL    d1-d4/a0-a3
                tst.l   d0              ; Handy when using asm
                rts




******* AB.LIB/SearchMemRev *************************************************
*
*   NAME   
*       SearchMemRev - Search memory for a binary string, backwards.
*
*   SYNOPSIS
*       Offset =  SearchMemRev( Mem, MemLen, CmpStr, CmpStrLen)
*       D0                      A0   D0      A1      D1
*
*       __asm ULONG SearchMemRev( __A0 void *Mem,
*                                 __D0 ULONG MemLen,
*                                 __A1 UBYTE *CmpStr,
*                                 __D1 ULONG CmpStrLen );
*
*   FUNCTION
*       Look for a binary string in memory, backwards.
*
*   INPUTS
*       Mem       - Pointer to memory that will be searched.
*       MemLen    - Length of memory to be searched.
*       CmpStr    - Pointer to binary string to find.
*       CmpStrLen - Length of binary string to find
*
*   RESULT
*       ULONG Offset - Offset the binary string was found at (relative)
*                      to the Mem parameter. If string was not found then
*                      ~NULL is returned.
*
*   SEE ALSO
*       AB.LIB/SearchMem()
*
*****************************************************************************
* AB.LIB code module, created: 4/8/1997
*
* This file is copyright © 1997 Andrew Bell.
*
* __asm ULONG SearchMemRev(__A0 void *Mem, __D0 ULONG MemLen, __A1 UBYTE *CmpStr, __D1 ULONG CmpStrLen);
*

                xdef    SearchMemRev
                xdef    _SearchMemRev

_SearchMemRev:
SearchMemRev:   PUSH    d1-d4/a0-a3

                move.l  a0,-(sp)
                tst.l   d0
                beq.b   SMR.Fail
                tst.l   d1
                beq.b   SMR.Fail
                sub.l   d1,d0
                bmi.b   SMR.Fail
                lea.l   (a0,d0.l),a0
                addq.l  #1,a0
                subq.l  #1,d1
                move.b  (a1)+,d2
SMR.Loop        cmp.b   -(a0),d2
                bne.b   SMR.NextByte
                move.l  a0,a2
                addq.l  #1,a0
                move.l  a1,a3
                move.l  d1,d3
                beq.b   SMR.Matched
                move.l  d0,d4
SMR.Loop2       cmp.b   (a0)+,(a1)+
                bne.b   SMR.NoMatch
                subq.l  #1,d3
                beq.b   SMR.Matched
                subq.l  #1,d4
                bne.b   SMR.Loop2
                bra.b   SMR.Fail
SMR.Matched     move.l  a2,d0
                sub.l   (sp),d0
                bra.b   SMR.Fin
SMR.NoMatch     move.l  a3,a1
                move.l  a2,a0
SMR.NextByte    subq.l  #1,d0
                bpl.b   SMR.Loop

SMR.Fail        moveq.l #-1,d0
SMR.Fin         addq.l  #4,sp
                PULL    d1-d4/a0-a3
                rts

*---------------------------------------------------------------------------*

                end     ; For brain-dead assemblers :)
