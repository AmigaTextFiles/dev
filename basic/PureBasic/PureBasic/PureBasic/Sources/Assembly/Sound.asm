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
;   -Doobrey- Commands and debugger checks now preserve regs.

; --------------------------------------------------------------------------------------
; Version 1.05

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"


 initlib "Sound", "Sound", "FreeSounds", 0, 1, 0

; --------------------------------------------------------------------------------------

 name      "FreeSounds","()"
 flags      ; (-)
 amigalibs _ExecBase,a6
 params
 debugger   0

 MOVEM.l d2/d7/a2/a5,-(a7)    ; Save registers
 MOVE.l  (a5)+,d7          ; get objbase
 BEQ.w   FSs_End           ; no Sounds to free

 MOVE.l  (a5)+,d0          ; get global
 BEQ.w   FSs_l1            ; ...

 MOVE.l  d0,a0             ; use global
 MOVE.w  -4(a0),d0         ; get soundmask
 MOVE.l  26(a5),a0         ; get custom

 MOVE.w  d0,$96(a0)        ; clear audio dma bits
 LSL.w   #7,d0             ; ...
 MOVE.w  d0,$9a(a0)        ; clear audio intena bits

 MOVE.w  (a5)+,d2          ; get nr_obj
 MOVE.l  d7,a2             ; use objbase

FSs_loop0
 MOVE.l  (a2),d0           ; get \Sample
 BLE.w   FSs_l0            ; no sample

 MOVE.l  d0,a1             ; arg1.
 JSR    _FreeVec(a6)       ; (memblock) - a1

FSs_l0
 LEA     16(a2),a2         ; inc objptr
 DBRA    d2,FSs_loop0      ; ...

 MOVEQ   #5,d0             ; arg1.
 MOVE.l  a5,a1             ; arg2.
 JSR    _RemIntServer(a6)  ; (intnum,interrupt) - d0/a1

FSs_l1
 MOVE.l  d7,a1             ; arg1.
 JSR    _FreeVec(a6)       ; (memblock) - a1

FSs_End
 MOVEM.l (a7)+,d2/d7/a2/a5    ; Restore registers
 RTS

 endfunc 0

;-------------------------------------------------------------------------------

 name      "InitSound","(Sounds.l)"
 flags      ; (True/False)
 amigalibs _ExecBase,a6
 params     d0_w
 debugger   1,Error1

 MOVEM.l d7/a5,-(a7)        ; Save registers
 MOVE.w  d0,d7              ; save param1

 ADDQ.w  #1,d0              ; atleast one #Sound
 LSL.w   #4,d0              ; arg1.
 MOVEQ   #1,d1              ; }
 SWAP    d1                 ; } arg2.
 JSR    _AllocVec(a6)       ; (size,req) - d0/d1
 MOVE.l  d0,(a5)+           ; set objbase
 BEQ.w   IS_End             ; no mem

 MOVE.l  24(a4),(a5)+       ; set global
 MOVE.w  d7,(a5)+           ; set nr_obj

 LEA     44(a5),a0          ; ...
 MOVE.l  a0,d0              ; ...
 LEA     22(a5),a0          ; ...
 LEA     ServerCode(pc),a1  ; ...
 MOVEM.l d0/a0-1,10(a5)     ; set ln_Node, Is_Data & is_Code

 MOVEQ   #5,d0              ; arg1.
 MOVE.l  a5,a1              ; arg2.
 JSR    _AddIntServer(a6)   ; (intnum,interrupt) - d0/a1

 MOVEQ   #1,d0              ; set returnvalue

IS_End
 MOVEM.l (a7)+,d7/a5	    ; Restore registers
 RTS

ServerCode
 MOVE.w  (a1),d0          ; get vbdata
 BEQ.w   q0               ; quit if nothing to do

 CLR.w   (a1)+            ; zero to vbdata
 MOVE.l  (a1),a0          ; get custombase

 MOVE.w  d0,$96(a0)       ; start audio dma

 LSL.w   #7,d0            ; make dma bits to int bits
 MOVE.w  d0,$9c(a0)       ; clear bits in intreq

 BSET    #15,d0           ; set set/clear bit
 MOVE.w  d0,$9a(a0)       ; set bits in intena

 MOVEQ   #0,d0            ; not last server

q0
 RTS

 endfunc 1

;-------------------------------------------------------------------------------

 name      "LoadSound","(#Sound.w,FileName$)"
 flags      ByteResult ; (True/False)
 amigalibs _DosBase,a6, _ExecBase,d7
 params     d0_w,d1_l
 debugger   2,Error3

.PB_LoadSound
 
 MOVEM.l  d2-d6/a2/a5,-(a7) ; Save registers.
 
 LSL.w   #4,d0         ; ...
 MOVE.l  (a5),a2       ; ...
 ADD.w   d0,a2         ; - A2 hold #Sound

 MOVE.l  #1005,d2      ; arg2.
 JSR    _Open(a6)      ; (filename,accesmode) - d1/d2
 MOVE.l  d0,d6         ; - D6 hold filehandle
 BEQ.w   LS_End        ; couldn't open file

 MOVEQ   #12,d3        ; first seek pos
 LEA     64(a5),a0     ; ptr to buffer
 MOVE.l  a0,d4         ; - D4 hold ptr to buffer
 MOVEQ   #1,d5         ; - D5 counter
 LEA     46(a5),a5     ; ptr to chunk id (VHDR)

LS_loop0
 MOVE.l  d6,d1         ; arg1.
 MOVE.l  d3,d2         ; arg2.
 CLR.l   d3            ; arg3.
 JSR    _Seek(a6)      ; (file,pos,mode) - d1/d2/d3

LS_loop1
 MOVE.l  d6,d1         ; arg1.
 MOVE.l  d4,d2         ; arg2.
 MOVEQ   #8,d3         ; arg3.
 JSR    _Read(a6)      ; (file,buffer,length) - d1/d2/d3

 MOVE.l  d4,a0         ; use ptr to buffer
 MOVE.l  (a0)+,d0      ; get chunkid from file

 MOVE.l  (a0),d3       ; arg3. Get size of this chunk..
 ADDQ.l  #1,d3         ; add one and..
 ANDI.b  #$fe,d3       ; make it even

 CMP.l   (a5),d0       ; see if chunkid is right
 BNE.w   LS_loop0      ; not right chunk

 TST.b   d5            ; if counter = 0 then it's BODY chunk
 BNE.w   LS_l0         ; ...

 EXG.l   d7,a6         ; use execbase
 MOVE.l  d3,d0         ; arg1.
 MOVEQ   #2,d1         ; arg2.
 JSR    _AllocVec(a6)  ; (size,req) - d0/d1
 EXG.l   d7,a6         ; use dosbase
 MOVE.l  d0,(a2)+      ; set \Sample
 BEQ.w   LS_l2         ; quit if no mem

 MOVE.l  d3,d1         ; ...
 LSR.l   #1,d1         ; byte to word
 MOVE.w  d1,(a2)       ; set \Length
 MOVE.l  d0,d2         ; arg2. (Read)

LS_l0
 MOVE.l  d6,d1         ; arg1.
 JSR    _Read(a6)      ; (file,buffer,length) - d1/d2/d3

 TST.b   d5            ; if counter = 1 then it's VHDR chunk
 BEQ.w   LS_l1         ; ...

 MOVE.l  d4,a0         ; use ptr to buffer

 ; repeat start & end could be fixed here

 MOVE.l  #3546895,d0   ; ????
 MOVE.w  12(a0),d1     ; get period
 DIVU.w  d1,d0         ; calc period
 MOVE.w  d0,6(a2)      ; set \Period
 MOVE.w  #64,8(a2)     ; set \Volume
 MOVE.w  #15,10(a2)    ; set \Channels

LS_l1
 ADDQ.w  #4,a5         ; inc ptr to chunk id
 DBRA    d5,LS_loop1   ; dec counter

LS_l2
 MOVE.l  d6,d1         ; arg1.
 JSR    _Close(a6)     ; (file) - d1

 TST.b   d5            ; see if all was done
 SLT     d0            ; return True/False

LS_End
 MOVEM.l  (a7)+,d2-d6/a2/a5 ; Restore registers.
 RTS

 endfunc 2

;-------------------------------------------------------------------------------

 name      "SaveSound","(#Sound.w,FileName$)"
 flags      ByteResult ; (True/False)
 amigalibs _DosBase,a6, _ExecBase,d7
 params     d0_w,d1_l
 debugger   3,Error2

 MOVEM.l d2-d6/a2/a5,-(a7)  ; Save registers

 LSL.w   #4,d0         ; calc adress..
 MOVE.l  (a5),a2       ; to #Sound
 ADD.w   d0,a2         ; ...

 MOVE.l  #1006,d2      ; arg2.
 JSR    _Open(a6)      ; (filename,accesmode) - d1/d2
 MOVE.l  d0,d6         ; - D6 hold filehandler
 BEQ.w   SS_End1       ; couldn't open file

 EXG.l   d7,a6         ; use execbase

 MOVEQ   #48,d0        ; arg1.
 MOVEQ   #1,d1         ; }
 SWAP    d1            ; } arg2.
 JSR    _AllocVec(a6)  ; (size,req) - d0/d1
 MOVE.l  d0,d5         ; - D5 hold memptr
 BEQ.w   SS_End0       ; no mem

 MOVE.l  d5,a0         ; - A0 hold ptr to buffer
 ADD.w   #38,a5        ; ptr to chunk id (FORM)

 MOVE.l  (a5)+,(a0)+   ; set FORM id
 MOVE.w  4(a2),d4      ; get \Length
 EXT.l   d4            ; ...
 LSL.l   #1,d4         ; convert to byte
 MOVEQ   #40,d0        ; size of chunks id & VHDR chunk
 ADD.l   d0,d4         ; calc total size
 MOVE.l  d4,(a0)+      ; set FORM size
 SUB.l   d0,d4         ; ...
 MOVE.l  (a5)+,(a0)+   ; set 8SVX id
 MOVE.l  (a5)+,(a0)+   ; set VHDR id
 MOVEQ   #20,d0        ; VHDR size is 20
 MOVE.l  d0,(a0)+      ; set VHDR size

 ; repeat start & end could be fixed here

 LEA     12(a0),a0     ; skip to samplesPerSec

 MOVE.l  #3546895,d0   ; ????
 MOVE.w  6(a2),d1      ; get \Period
 DIVU.w  d1,d0         ; calc samplesPerSec
 MOVE.w  d0,(a0)+      ; set samplePerSec
 MOVE.b  #1,(a0)       ; set ctOctave

 ADDQ.w  #6,a0         ; skip to BODY chunk

 MOVE.l  (a5),(a0)+    ; set BODY id
 MOVE.l  d4,(a0)       ; set BODY size

 EXG.l   d7,a6         ; use dosbase

 MOVE.l  d6,d1         ; arg1.
 MOVE.l  d5,d2         ; arg2.
 MOVEQ   #48,d3        ; total chunk sizes
 JSR    _Write(a6)     ; (file,buffer,length) - d1/d2/d3

 TST.l   d0            ; see if Write success
 BLE.w   SS_End0       ; false

 MOVE.l  d6,d1         ; arg1.
 MOVE.l  (a2),d2       ; arg2.
 MOVE.l  d4,d3         ; arg3.
 JSR    _Write(a6)     ; (file,buffer,length) - d1/d2/d3

SS_End0
 MOVE.l  d0,d2         ; save error

 TST.l   d5            ; see if any mem
 BEQ.w   SS_l0         ; nop

 EXG.l   d7,a6         ; use execbase

 MOVE.l  d5,a1         ; arg1.
 JSR    _FreeVec(a6)   ; (memblock) - a1

SS_l0
 MOVE.l  d7,a6         ; use dosbase

 MOVE.l  d6,d1         ; arg1.
 JSR    _Close(a6)     ; (file) - d1

 TST.l   d2            ; see if any error
 SGT     d0            ; return True/False

SS_End1
 MOVEM.l (a7)+,d2-d6/a2/a5  ; Restore registers
 RTS

 endfunc 3

;-------------------------------------------------------------------------------

 name      "DecodeSound","(#Sound.w,Pointer.l)"
 flags      ; (Length)
 amigalibs _ExecBase,a6
 params     d0_w,d1_l
 debugger   4,Error3

 MOVEM.l d2-d6/a2/a5 ,-(a7) ; Save registers

 LSL.w   #4,d0         ; calc adress..
 MOVE.l  (a5),a2       ; to #Sound
 ADD.w   d0,a2         ; ...

 MOVE.l  d1,a0         ; use ptr to IFF Sound
 LEA     46(a5),a5     ; ptr to chunk id (VHDR)

DS_loop0
 MOVE.l  (a0)+,d0      ; get a longword

 CMP.l   (a5),d0       ; see if it's the VHDR chunk
 BNE.w   DS_l0         ; false

 ; repeat start & end could be fixed here

 MOVE.l  #3546895,d2   ; ????
 MOVE.w  16(a0),d3     ; get samplesPerSec
 DIVU.w  d3,d2         ; calc period
 MOVE.w  d2,6(a2)      ; set \Period
 MOVE.w  #64,8(a2)     ; set \Volume
 MOVE.w  #15,10(a2)    ; set \Channels

DS_l0
 CMP.l   4(a5),d0      ; see if it's the BODY chunk
 BNE.w   DS_loop0      ; false

 MOVE.l  (a0)+,d6      ; save length of chunkdata
 MOVE.l  a0,d5         ; save ptr to sampledata

 CMP.l   #$200000,d1   ; see if it's chipmem
 BLT.w   DS_l1         ; true

 MOVE.l  d5,d4         ; ...

 MOVE.l  d6,d0         ; arg1.
 MOVEQ   #2,d1         ; arg2.
 JSR    _AllocVec(a6)  ; (size,req) - d0/d1
 MOVE.l  d0,d5         ; save ptr to mem
 BEQ.w   DS_End        ; quit if no mem

 MOVE.l  d4,a0         ; arg1.
 MOVE.l  d5,a1         ; arg2.
 MOVE.l  d6,d0         ; arg3.
 JSR    _CopyMem(a6)   ; (src,dest,size) - a0/a1/d0
 BRA     DS_l2         ; ...

DS_l1
 BSET    #31,d5        ; flag say sample is in programs chipmem

DS_l2
 MOVE.l  d5,(a2)+      ; set \Sample
 LSR.l   #1,d6         ; byte to word
 MOVE.w  d6,(a2)       ; set \Length

 MOVE.w  d6,d0         ; return true

DS_End
 MOVEM.l (a7)+,d2-d6/a2/a5  ; Restore registers
 RTS

 endfunc 4

;-------------------------------------------------------------------------------

 name      "CopySound","(#Sound.w,#Sound.w)"
 flags      LongResult ; (Length)
 amigalibs _ExecBase,a6
 params     d0_w,d1_w
 debugger   5,Error5

 MOVEM.l d6-d7/a2-a3,-(a7)   ; save A2 A3 to stack

 LSL.w   #4,d0         ; }
 LSL.w   #4,d1         ; } calc adress..
 MOVE.l  (a5),a2       ; } to #Sound
 MOVE.l  a2,a3         ; }
 ADD.w   d0,a2         ; ...
 ADD.w   d1,a3         ; ...

 MOVE.l  (a2)+,d7      ; get \Sample
 MOVE.w  (a2),d6       ; get \Length
 EXT.l   d6            ; ...
 LSL.l   #1,d6         ; word to byte

 MOVE.l  d6,d0         ; arg1.
 MOVEQ   #2,d1         ; arg2.
 JSR    _AllocVec(a6)  ; (size,req) - d0/d1
 MOVE.l  d0,(a3)+      ; set \Sample
 BEQ.w   CS_End        ; quit if no mem

 MOVE.l  d7,a0         ; arg1.
 MOVE.l  d0,a1         ; arg2.
 MOVE.l  d6,d0         ; arg3.
 JSR    _CopyMem(a6)   ; (src,dest,size) - a0/a1/d0

 MOVE.l  (a2)+,(a3)+   ; copy \Length & \Period
 MOVE.l  (a2),(a3)     ; copy \Volume & \Channels

 MOVE.l  d6,d0         ; set returnvalue

CS_End
 MOVEM.l (a7)+,d6-d7/a2-a3   ; restore A2 A3
 RTS

 endfunc 5

;-------------------------------------------------------------------------------

 name      "FreeSound","(#Sound.w)"
 flags      ; (-)
 amigalibs _ExecBase,a6
 params     d0_w
 debugger   6,Error2

 LSL.w   #4,d0         ; calc adress..
 MOVE.l  (a5),a0       ; to #Sound
 ADD.w   d0,a0         ; ...

 MOVE.l  (a0),d0       ; get \Sample
 BLE.w   FS_End        ; minus = sample in programs chipmem

 CLR.l   (a0)          ; zero to \Sample
 CLR.w   10(a0)        ; zero to \Channels
 MOVE.l  d0,a1         ; arg1.
 JMP    _FreeVec(a6)   ; (memblock) - a1

FS_End
 RTS

 endfunc 6

;-------------------------------------------------------------------------------

 name      "PlaySound","(#Sound.w,Repeat.w)"
 flags      ; (Channels)
 amigalibs
 params     d0_w,d1_w
 debugger   7,Error2

 MOVEM.l d2-d7/a6,-(a7)  ; Save registers

 LSL.w   #4,d0           ; calc adress..
 MOVEM.l (a5),a0-a1      ; to #Sound  (get global too)
 ADD.w   d0,a0           ; ...

 MOVE.w  10(a0),d0       ; get \Channels
 AND.w   -4(a1),d0       ; filter out channels to use
 BEQ.w   PS_End          ; ...

 MOVE.l  34(a5),a6       ; - A6 hold custom
 ADDQ.w  #1,d1           ; inc param2  ????
 MOVEQ   #3,d2           ; loop counter

 MOVE.w  d0,$96(a6)      ; clear audio dma bits
 MOVE.w  d0,d3           ; - D3 hold channelmask
 LSL.w   #7,d0           ; make dma bits to intena bits
 MOVE.w  d0,$9a(a6)      ; clear audio intena bits

 MOVE.l  (a0)+,d4        ; get \Sample
 MOVEM.w (a0),d5-d7      ; get \Length, \Period & \Volume

 MOVEQ   #12,d0          ; sound data displacement
 LEA     346(a1),a1      ; ptr into last sound data
 LEA     208(a6),a6      ; ptr to last audio channel

PS_loop0
 BTST    d2,d3           ; test bit to see if..
 BEQ.w   PS_l0           ; channel should be used

 MOVE.w  d1,(a1)         ; set repeat time for handlercode
 MOVE.l  d4,(a6)         ; set sample
 MOVEM.w d5-d7,4(a6)     ; set length, period & volume

PS_l0
 SUB.l   d0,a1           ; dec sound data ptr
 SUB.w   #16,a6          ; dec audio data ptr
 DBRA    d2,PS_loop0     ; loop until all 4 channels is done

 MOVE.w  d3,d0           ; return played channels

 BSET    #15,d3          ; set set/clear bit
 OR.w    d3,32(a5)       ; pass chan to servercode

PS_End
 MOVEM.l (a7)+,d2-d7/a6  ; Restore registers
 RTS

 endfunc 7

;-------------------------------------------------------------------------------

 name      "StopSound","(#Sound.w)"
 flags      ; (-)
 amigalibs
 params     d0_w
 debugger   8,Error2

 LSL.w   #4,d0         ; calc adress..
 MOVEM.l (a5),a0-a1    ; to #Sound (get global too)
 ADD.w   d0,a0         ; ...

 MOVEQ   #3,d0         ; loop counter
 MOVE.w  10(a0),d1     ; get \Channels
 AND.w   -4(a1),d1     ; filter out channels
 MOVE.l  34(a5),a0     ; - A0 hold custombase

SS_loop01
 BTST    d0,d1         ; is channel in use
 BEQ.w   SS_l01        ; nop

 CLR.w   $d8(a0)       ; zero to volume

SS_l01
 SUB.w   #16,a0        ; dec ptr to audio channels
 DBRA    d0,SS_loop01  ; dec loop counter

 MOVE.w  d1,$d6(a0)    ; clear audio dma bits
 LSL.w   #7,d1         ; make dma bits to intena bits
 MOVE.w  d1,$da(a0)    ; clear audio intena bits

 RTS

 endfunc 8

;-------------------------------------------------------------------------------


 name      "SetSoundPeriod","(#Sound.w,Period.w)"
 flags      ; (-)
 amigalibs
 params     d0_w,d1_w
 debugger   9,Error2

 LSL.w   #4,d0         ; calc adress..
 MOVE.l  (a5),a0       ; to #Sound
 ADD.w   d0,a0         ; ...

 MOVE.l  #3546895,d0   ; ????
 DIVU.w  d1,d0         ; calc period
 MOVE.w  d0,6(a0)      ; set \Period
 RTS

 endfunc 9

;-------------------------------------------------------------------------------

 name      "SetSoundVolume","(#Sound.w,Volume.w)"
 flags      ; (-)
 amigalibs
 params     d0_w,d1_w
 debugger   10,Error2

 LSL.w   #4,d0         ; calc adress..
 MOVE.l  (a5),a0       ; to #Sound
 ADD.w   d0,a0         ; ...

 MOVE.w  d1,8(a0)      ; set \Volume
 RTS

 endfunc 10

;-------------------------------------------------------------------------------

 name      "SetSoundChannels","(#Sound.w,Channels.w)"
 flags      ; (-)
 amigalibs
 params     d0_w,d1_w
 debugger   11,Error2

 LSL.w   #4,d0         ; calc adress..
 MOVE.l  (a5),a0       ; to #Sound
 ADD.w   d0,a0         ; ...

 MOVE.w  d1,10(a0)     ; set \Channels
 RTS

 endfunc 11

;-------------------------------------------------------------------------------

 name      "ChangeSoundPeriod","(#Sound.w,Period.w)"
 flags      ; (Channels)
 amigalibs
 params     d0_w,d1_w
 debugger   12,Error2

 MOVE.l d2,-(a7)       ; Save registers

 LSL.w   #4,d0         ; calc adress..
 MOVEM.l (a5),a0-a1    ; to #Sound  (get global too)
 ADD.w   d0,a0         ; ...

 MOVE.w  10(a0),d0     ; get \Channels
 AND.w   -4(a1),d0     ; filter out channels

 MOVE.l  #3546895,d2   ; ????
 DIVU.w  d1,d2         ; calc period

 MOVEQ   #3,d1         ; counter
 MOVE.l  #$dff0d6,a1   ; get adress to fourth period reg

CSP_loop0
 BTST    d1,d0         ; see if channels is on
 BEQ.w   CSP_l0        ; false

 MOVE.w  d2,(a1)       ; set new period

CSP_l0
 SUB.w   #16,a1        ; dec to prev period reg
 DBRA    d1,CSP_loop0  ; dec counter

 MOVE.l (a7)+,d2       ; Restore registers
 RTS

 endfunc 12

;-------------------------------------------------------------------------------

 name      "ChangeSoundVolume","(#Sound.w,Volume.w)"
 flags      ; (Channels)
 amigalibs
 params     d0_w,d1_w
 debugger   13,Error2

 MOVE.L d2,-(a7)       ; Save registers
 LSL.w   #4,d0         ; calc adress..
 MOVEM.l (a5),a0-a1    ; to #Sound  (get global too)
 ADD.w   d0,a0         ; ...

 MOVE.w  10(a0),d0     ; get \Channels
 AND.w   -4(a1),d0     ; filter out channels

 MOVEQ   #3,d2         ; counter
 MOVE.l  #$dff0d8,a1   ; get adress to fourth volume reg

CSV_loop0
 BTST    d2,d0         ; see if channel is on
 BEQ.w   CSV_l0        ; false

 MOVE.w  d1,(a1)       ; set new volume

CSV_l0
 SUB.w   #16,a1        ; dec to prev volume reg
 DBRA    d2,CSV_loop0  ; dec counter

 MOVE.l (a7)+,d2       ; Restore registers
 RTS

 endfunc 13

;-------------------------------------------------------------------------------

 name      "CreateSound","(#Sound.w,Length.l)"
 flags      LongResult ; (MemPtr)
 amigalibs _ExecBase,a6
 params     d0_w,d1_l
 debugger   14,Error3

 MOVE.l a2,-(a7)           ; Save registers

 LSL.w   #4,d0         ; calc adress..
 MOVE.l  (a5),a2       ; to #Sound
 ADD.w   d0,a2         ; ...

 MOVE.l  d1,d0         ; arg1.

 LSR.l   #1,d1         ; byte to word
 MOVE.w  d1,4(a2)      ; set \Length

 MOVEQ   #2,d1         ; arg2.
 JSR    _AllocVec(a6)  ; (size,req) - d0/d1
 MOVE.l  d0,(a2)       ; set \Sample

 MOVEA.l (a7)+,a2          ; Restore registers
 RTS

 endfunc 14

;-------------------------------------------------------------------------------


 name      "PokeSoundData","(#Sound.w,Position.l,Data.b)"
 flags      ; (-)
 amigalibs
 params     d0_w,d1_l,d2_b
 debugger   15,Error4

 LSL.w   #4,d0         ; calc adress..
 MOVE.l  (a5),a0       ; to #Sound
 ADD.w   d0,a0         ; ...

 MOVE.l  (a0),a0       ; get \Sample
 ADD.l   d1,a0         ; add wanted position to ptr
 MOVE.b  d2,(a0)       ; poke data to samplemem
 RTS

 endfunc 15

;-------------------------------------------------------------------------------


 name      "PeekSoundData","(#Sound.w,Position.l)"
 flags      ByteResult ; (Sound Data)
 amigalibs
 params     d0_w,d1_l
 debugger   16,Error4

 LSL.w   #4,d0         ; calc adress..
 MOVE.l  (a5),a0       ; to #Sound
 ADD.w   d0,a0         ; ...

 MOVE.l  (a0),a0       ; get \Sample
 ADD.l   d1,a0         ; add wanted position to ptr
 MOVE.b  (a0),d0       ; peek data from samplemem
 RTS

 endfunc 16

;-------------------------------------------------------------------------------

 name      "GetSoundLength","(#Sound.w)"
 flags      LongResult ; (Sound Length)
 amigalibs
 params     d0_w
 debugger   17,Error2

 LSL.w   #4,d0         ; calc adress..
 MOVE.l  (a5),a0       ; to #Sound
 ADD.w   d0,a0         ; ...

 CLR.l   d0            ; ...
 MOVE.w  4(a0),d0      ; get \Length
 LSL.l   #1,d0         ; word to byte
 RTS

 endfunc 17

;-------------------------------------------------------------------------------

 name      "SoundFilter","(ON/OFF)"
 flags      ; (-)
 amigalibs
 params     d0_b
 debugger   18

 TST.b  d0
 BEQ.w  lj10

 MOVEQ   #2,d0
 OR.b    d0,$bfe001
 RTS

lj10
 MOVEQ   #-3,d0
 AND.b   d0,$bfe001
 RTS

 endfunc 18

;-------------------------------------------------------------------------------

 name      "ChangeChannelPeriod","(Channel.w,Period.w)"
 flags      ; (Channels)
 amigalibs
 params     d0_w,d1_w
 debugger   19 ;,Error2

 MOVE.l d2,-(a7)       ; Save registers
 MOVE.l  4(a5),a0      ; get global
 AND.w   -4(a0),d0     ; filter out channels

 MOVE.l  #3546895,d2   ; ????
 DIVU.w  d1,d2         ; calc period

 MOVEQ   #3,d1         ; counter
 MOVE.l  #$dff0d6,a0   ; get adress to fourth period reg

CCP_loop0
 BTST    d1,d0         ; see if channels is on
 BEQ.w   CCP_l0        ; false

 MOVE.w  d2,(a0)       ; set new period

CCP_l0
 SUB.w   #16,a0        ; dec to prev period reg
 DBRA    d1,CCP_loop0  ; dec counter

 MOVE.l (a7)+,d2       ; Restore registers
 RTS

 endfunc 19

;-------------------------------------------------------------------------------

 name      "ChangeChannelVolume","(Channel.w,Volume.w)"
 flags      ; (Channels)
 amigalibs
 params     d0_w,d1_w
 debugger   20 ;,Error2

 MOVE.l d2,-(a7)       ; Save registers
 MOVE.l  4(a5),a0      ; get global
 AND.w   -4(a0),d0     ; filter out channels

 MOVEQ   #3,d2         ; counter
 MOVE.l  #$dff0d8,a0   ; get adress to fourth volume reg

CCV_loop0
 BTST    d2,d0         ; see if channel is on
 BEQ.w   CCV_l0        ; false

 MOVE.w  d1,(a0)       ; set new volume

CCV_l0
 SUB.w   #16,a0        ; dec to prev volume reg
 DBRA    d2,CCV_loop0  ; dec counter
 
 MOVE.l (a7)+,d2       ; Restore registers
 RTS

 endfunc 20

;-------------------------------------------------------------------------------

 base

objbase:  Dc.l 0                ; 4
global:   Dc.l 0                ; 4
nr_obj:   Dc.w 0                ; 2

VBlank:
          Dc.l 0,0
          Dc.b 2,0
          Dc.l 0
          Dc.l 0,0              ; 22

vbdata:   Dc.w 0                ; 2
custom:   Dc.l $dff000          ; 4

form:     Dc.b "F","O","R","M"  ; 4
svx8:     Dc.b "8","S","V","X"  ; 4
vhdr:     Dc.b "V","H","D","R"  ; 4
body:     Dc.b "B","O","D","Y"  ; 4

name:     Dc.b "PureBasic",0    ; 10
buff:     Ds.l  5               ; 20

; SoundData
;
; Mask.w : Counter.w : Offset.w
; RepeatStart.l : RepeatLen.w

; soundmask    = 0      2
; ptmodulemask = 2      2
; sampleptrs   = 4    124
; maindata     = 128   24
; chandata1    = 152   40
; chandata2    = 192   40
; chandata3    = 232   40
; chandata4    = 272   40
; sounddata1   = 312   12
; sounddata2   = 324   12
; sounddata3   = 336   12
; sounddata4   = 348   12
; audioint1    = 360   26
; audioint2    = 386   26
; audioint3    = 412   26
; audioint4    = 438   26
; audioreq     = 464   68
; .........    = 532 byte

 endlib

;-------------------------------------------------------------------------------

 startdebugger

Error1
 TST.l   24(a4)
 BEQ     Err_00
 TST.l   d0
 BMI     Err_01
 CMPI.l  #2046,d0
 BGT     Err_01
 RTS

Error2
 TST.l   (a5)
 BEQ     Err2
 TST.l   4(a5)
 BEQ     Err2

 TST.w   d0
 BMI     Err3
 CMP.w   8(a5),d0
 BGT     Err3

 ; Doobrey: Changed to preserve regs
 ;MOVE.w  d0,d5
 ;LSL.w   #4,d5
 ;MOVE.l  (a5),a0
 ;ADD.w   d5,a0

 MOVE.l d0,-(a7)
 LSL.w  #4,d0
 MOVE.l (a5),a0
 ADD.w  d0,a0
 MOVE.l (a7)+,d0

 TST.l   (a0)
 BEQ     Err4
 RTS

Error3
 TST.l   (a5)
 BEQ     Err2
 TST.l   4(a5)
 BEQ     Err2

 TST.w   d0
 BMI     Err3
 CMP.w   8(a5),d0
 BGT     Err3

 ; Doobrey: Changed to preserve regs.
 ;MOVE.w  d0,d5
 ;LSL.w   #4,d5
 ;MOVE.l  (a5),a0
 ;ADD.w   d5,a0

 MOVE.l d0,-(a7)
 LSL.w  #4,d0
 MOVE.l (a5),a0
 ADD.w  d0,a0
 MOVE.l (a7)+,d0

 TST.l   (a0)
 BNE     Err5
 RTS

Error4
 TST.l   (a5)
 BEQ     Err2
 TST.l   4(a5)
 BEQ     Err2

 TST.w   d0
 BMI     Err3
 CMP.w   8(a5),d0
 BGT     Err3

 ; Doobrey: Changed to preserve regs.
 ;MOVE.w  d0,d7
 ;LSL.w   #4,d7
 ;MOVE.l  (a5),a0
 ;ADD.w   d7,a0

 MOVE.l d0,-(a7)
 LSL.w  #4,d0
 MOVE.l (a5),d0
 ADD.w  d0,a0
 MOVE.l (a7)+,d0

 TST.l   (a0)
 BEQ     Err4

 TST.l   d1
 BMI     Err6

 MOVEM.l d5-d7,-(a7) ; Save registers
 MOVE.w  d0,d5
 LSL.w   #4,d5
 MOVE.l  (a5),a0
 ADD.w   d5,a0
 MOVE.l  (a0)+,d5
 MOVE.l  d5,d6
 MOVE.w  (a0),d7
 EXT.l   d7
 LSL.l   #1,d7
 ADD.l   d7,d5
 ADD.l   d1,d6
 CMP.l   d5,d6
 BGE     _Do_Err6     ; needs to restore then branch!
 MOVEM.l (a7)+, d5-d7 ; Restore registers
 RTS

_Do_Err6
 MOVEM.l (a7)+,d5-d7
 BRA Err6


Error5
 TST.l   (a5)
 BEQ     Err2
 TST.l   4(a5)
 BEQ     Err2

 TST.w   d0
 BMI     Err3
 CMP.w   8(a5),d0
 BGT     Err3

 ; Doobrey: Changed to preserve regs.
 ;MOVE.w  d0,d5
 ;LSL.w   #4,d5
 ;MOVE.l  (a5),a0
 ;ADD.w   d5,a0

 MOVE.l d0,-(a7)
 LSL.w  #4,d0
 MOVE.l (a5),a0
 ADD.w  d0,a0
 MOVE.l (a7)+,d0

 TST.l   (a0)
 BEQ     Err4

 TST.w   d1
 BMI     Err3
 CMP.w   8(a5),d1
 BGT     Err3

 ; Doobrey: Changed to preserve regs.
 ;MOVE.w  d1,d5
 ;LSL.w   #4,d5
 ;MOVE.l  (a5),a0
 ;ADD.w   d5,a0
 
 MOVE.l d1,-(a7)
 LSL.w  #4,d1
 MOVE.l (a5),a0
 ADD.w  d1,a0
 MOVE.l (a7)+,d1

 TST.l   (a0)
 BNE     Err5

 CMP.w   d1,d0
 BEQ     Err7

 RTS

Err_00: DebugError "Must Call InitAudio() First"
Err_01: DebugError "Sounds out of Range"
Err2:   DebugError "Call InitSound() First or No Error Check Done"
Err3:   DebugError "#Sound out of Range"
Err4:   DebugError "#Sound are not Initialized"
Err5:   DebugError "#Sound is already Initialized"
Err6:   DebugError "Position out of sounds Range"
Err7:   DebugError "Param1 and Param2 are the same"

 enddebugger

