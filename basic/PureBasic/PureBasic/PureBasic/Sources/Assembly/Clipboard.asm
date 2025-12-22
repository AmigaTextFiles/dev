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
; PureBasic 'ClipBoard' library
;
; ToDo:
;	Move closedevice/deleteiorequest/deletemsgport to base ..make a smaller lib.
;     ..possible for the opens/creates too ??
; 18/03/2005
;	 - SetClipboardText() is NoResult , added save d2-d6.
;	 - GetClipboardText() added save d5-d6.
;

; 30/05/2001
;   PhxAss convertion
;
; 10/07/1999
;  FirstVersion
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16

CMD_READ   = 2
CMD_WRITE  = 3
CMD_UPDATE = 4

FTXT = $46545854
CHRS = $43485253
FORM = $464F524D

;-- Base offsets--

_ClipBoardName   = 0



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

 initlib "Clipboard", "Clipboard", "", 0, 1, 0

;
; Now do the functions...
;
;----------------------------------------------------------------------------------
 name      "SetClipboardText", "(Text$)"
 flags	NoResult
 amigalibs _ExecBase, a6
 params    a0_l
 debugger  1

.SetClipboardText_TEST:

  MOVEM.l   d2-d6/a3,-(a7)	;save regs

  MOVE.l   a0, d2

  BSR      GetStringLength
  MOVE.l   d0, d3
  BEQ     _NPCT_End   ; If NULL string, don't change the clipboard.

  JSR     _CreateMsgPort(a6)
  BEQ     _NPCT_End
  MOVE.l   d0, a2

  MOVE.l   d0, a0
  MOVEQ    #52, d0                ; IOClipReq size
  JSR     _CreateIORequest(a6)    ; - a0,d0
  BEQ     _NPCT_DeleteMsgPort

  MOVE.l   d0, a3

  LEA.l   _ClipBoardName(a5), a0
  CLR.l    d0
  MOVE.l   a3, a1
  CLR.l    d1
  JSR     _OpenDevice(a6)           ; - a0,d0,a1,d1
  BNE     _NPCT_DeleteIORequest     ; If d0 <> 0 then quit

  MOVE.l   d3, d5   ; Size of the data transfered
  ADD.w    #20, d5  ; to the clipboard (need IFF Header)

  MOVE.l   d5, d0
  AND.l    #1, d0
  TST.l    d0
  BEQ     _SkipEVEN
  ADDQ     #1, d5     ; Make the size EVEN
_SkipEVEN:

  MOVE.l   d5, d0
  MOVE.l   #MEMF_CLEAR, d1
  JSR     _AllocVec(a6)    ; - d0,d1
  MOVE.l   d0, d6

  MOVE.l   d0, a0
  MOVE.l   #FORM, (a0)+      ; Build The Header of our
  MOVE.l   d5,    (a0)       ; files.
  SUB.l    #8,    (a0)+      ;
  MOVE.l   #FTXT, (a0)+      ;
  MOVE.l   #CHRS, (a0)+      ;
  MOVE.l   d3,    (a0)+      ; Size of the String

  SUBQ     #1, d3
  MOVE.l   d2, a1             ; String Addr
_NPCT_CopyLoop:               ; Copy the string
  MOVE.b   (a1)+, (a0)+       ;
  DBF      d3, _NPCT_CopyLoop ;

  MOVE.w   #CMD_WRITE, 28(a3) ;
  MOVE.l   d5, 36(a3)         ; Len of the String + IFF Header
  MOVE.l   d6, 40(a3)         ; Pointer to String to send
  MOVE.l   a3, a1
  JSR     _DoIO(a6)           ; (IORequest) - a1

  MOVE.w   #CMD_UPDATE, 28(a3)
  MOVE.l   a3, a1
  JSR     _DoIO(a6)           ; (IORequest) - a1

  MOVE.l   d6, a1
  JSR     _FreeVec(a6) ; - a1

  MOVE.l   a3, a1
  JSR     _CloseDevice(a6)          ; (IORequest) - a1
_NPCT_DeleteIORequest:              ;
  MOVE.l   a3, a0                   ;
  JSR     _DeleteIORequest(a6)      ; (IORequest) - a0
_NPCT_DeleteMsgPort:                ;
  MOVE.l   a2, a0                   ;
  JSR     _DeleteMsgPort(a6)        ; (MsgPort) - a0
_NPCT_End:                          ;
  MOVEM.l   (a7)+,d2-d6/a3		; Restore registers
  RTS


GetStringLength:
;
; Input : a0 - Address of the string
; Output: d0 - Length of the string

  MOVEQ    #-1,d0
_GSL_Loop:
  ADDQ.l   #1,d0
  TST.b    (a0)+
  BNE     _GSL_Loop
  RTS

  endfunc  1

;----------------------------------------------------------------------------------

 name      "GetClipboardText", "()"
 flags     StringResult
 amigalibs _ExecBase, a6
 params
 debugger  2

.GetClipboardText_TEST:
  MOVEM.l  d5-d6/a2,-(a7)

  MOVE.l   a3, d6                 ; String Buffer
  CLR.l    d5

  JSR     _CreateMsgPort(a6)
  BEQ     _NGCT_End
  MOVE.l   d0, a2

  MOVE.l   d0, a0
  MOVEQ    #52, d0                ; IOClipReq size
  JSR     _CreateIORequest(a6)    ; - a0,d0
  BEQ     _NGCT_DeleteMsgPort

  MOVE.l   d0, a3

  LEA.l   _ClipBoardName(a5), a0
  CLR.l    d0
  MOVE.l   a3, a1
  CLR.l    d1
  JSR     _OpenDevice(a6)           ; - a0,d0,a1,d1
  BNE     _NGCT_DeleteIORequest     ; If d0 <> 0 then quit

  MOVE.w   #CMD_READ, 28(a3)   ;
  MOVE.l   #4096, 36(a3)       ; Len of the String + IFF Header
  MOVE.l   d6, 40(a3)          ; Pointer to String to send
  MOVE.l   a3, a1
  JSR     _SendIO(a6)          ; (IORequest) - a1

  MOVE.l   #10000, 44(a3)      ; Fill the IOClipReq\Offset
  MOVE.l   a3, a1
  JSR     _SendIO(a6)          ; (IORequest) - a1

  MOVE.l   d6, a0
  CMP.l    #FORM, (a0)+
  BNE     _NGCT_CloseDevice
  ADD.w    #4, a0
  CMP.l    #FTXT, (a0)+
  BNE     _NGCT_CloseDevice
  CMP.l    #CHRS, (a0)+
  BNE     _NGCT_CloseDevice
  MOVE.l   (a0)+, d0          ; Get String Size...

  TST.l    d0                 ; Test if NULL
  BEQ     _NGCT_CloseDevice   ;

  MOVE.l   d0, d5

  MOVE.l   d6, a1             ; String Addr
_NGCT_CopyLoop:               ; Copy the string
  MOVE.b   (a0)+, (a1)+       ;
  DBF      d0, _NGCT_CopyLoop ;

_NGCT_CloseDevice
  MOVE.l   a3, a1
  JSR     _CloseDevice(a6)          ; (IORequest) - a1
_NGCT_DeleteIORequest:              ;
  MOVE.l   a3, a0                   ;
  JSR     _DeleteIORequest(a6)      ; (IORequest) - a0
_NGCT_DeleteMsgPort:                ;
  MOVE.l   a2, a0                   ;
  JSR     _DeleteMsgPort(a6)        ; (MsgPort) - a0
_NGCT_End:                          ;
  MOVE.l   d5, d0 ; String length
  MOVE.l   d6, a3 ; Restore A3 pointer
  ADD.l    d5, a3 ;
  MOVEM.l   (a7)+,d5-d6/a2
  RTS

  endfunc  2

;----------------------------------------------------------------------------------
 base

 Dc.b "clipboard.device",0,0

 Even

 endlib
;----------------------------------------------------------------------------------
 startdebugger

 enddebugger

