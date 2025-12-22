        opt o+,ow-
;*************************************************
;** FPSPSnoop                                   **
;**                                             **
;** the handler part: Detects to be emulated    **
;** instructions                                **
;**                                             **
;** Version 40.3 © Thomas Richter               **
;** THOR Software, 30.8.2001                    **
;*************************************************

        opt c+

        include inc:macros.asm

RawIOPutChar=         -516          ;this one is undocumented, but there.
Supervisor=             -30

;FOLD Register-Setup
;*************************************************
;** Register-Setup                              **
;** describes the register state at the         **
;** exception time. Will be filled in here      **
;** on the stack                                **
;*************************************************
        rsreset
rs_DataRegs:            rs.l 8          ;d0-d7
rs_AddrRegs:            rs.l 8          ;a0-a7 (USP is a7)
rs_SSP:                 rs.l 1          ;SSP
rs_PC:                  rs.l 1          ;PC of the faulting instruction
rs_SR:                  rs.w 1          ;Status register
rs_Vector:              rs.w 1          ;Vector offset
rs_EA:                  rs.l 1          ;EA of faulting instruction, if available
rs_FPURegs:             rs.b 12*8       ;fp0-fp7
rs_FPCR:                rs.l 1          ;FPCR
rs_FPIAR:               rs.l 1          ;FPIAR
rs_FPSR:                rs.l 1          ;FPSR
rs_len:                 rs.b 0
rs_FPUState:            rs.l 1          ;FPU status indicator here
rs_FPUFrame:            rs.b 0          ;FPU stack frame here
;ENDFOLD


        machine mc68040

        xref _Exception_Handler
        xref _OldVectors
        xref _SysBase


;FOLD GetVBR
        xdef _GetVBR
_GetVBR:
        saveregs a5-a6
        move.l _SysBase(a4),a6
        lea _ReadVBR(pc),a5
        jsr Supervisor(a6)
        loadregs
        rts
_ReadVBR:
        movec.l vbr,d0
        rte

        
;FOLD Exception_Callin
;*************************************************
;** Exception-Callin                            **
;*************************************************
        xdef _Exception_Callin
_Exception_Callin:
        move.l a6,-(a7)
        move.l a7,a6                            ;keep stack base here

        fsave -(a7)                             ;keep FPU state frame here
        clr.l -(a7)                             ;restore FPU state flag indicator
        reserve rs_len                          ;reserve registers

        movem.l d0-d7/a0-a5,rs_DataRegs(a7)     ;keep data regs

        fmovem.l fpcr,rs_FPCR(a7)
        fmovem.l fpiar,rs_FPIAR(a7)
        fmovem.l fpsr,rs_FPSR(a7)
        fmovem.x fp0-fp7,rs_FPURegs(a7)

        movec.l usp,a0
        move.l (a6),4*6+rs_AddrRegs(a7)         ;keep a6
        move.l a0,4*7+rs_AddrRegs(a7)           ;keep USP
        move.l a6,a1                            ;keep SSP
        move.w 4(a6),rs_SR(a7)                  ;keep status register
        move.w 4+6(a6),d0                       ;get vector offset
        clr.l rs_EA(a7)                         ;clear EA
        move.w d0,d1
        and.w #$f000,d0                         ;extract stack frame type
        and.w #$0fff,d1                         ;extract vector offset from here
        move.w d1,rs_Vector(a7)                 ;store here
        rol.w #4,d0                             ;get offset

        cmp.w #$f4,d1                           ;is it unimp integer?
        beq.s .isinteger
;
; ok, and now for the hacky stuff. Problem is as follows: if the FPU status
; is null, and we run into the frestore below, the fpiar will be null-ed as
; well such that the real exception handler will be unable to fetch the
; instruction. Therefore, we have to modify a NULL stackframe to an IDLE
; stackframe.
;
        move.l _SysBase,a0                      ;check whether this is a 040 or a 060
        btst #7,$129(a0)                        ;060?
        bne.s .is060

        tst.b rs_FPUFrame(a7)                   ;NULL-State?
        bra.s .check
.is060:
        tst.b 2+rs_FPUFrame(a7)                 ;NULL-State?
.check:
        bne.s .isinteger
        move.l a6,rs_FPUState(a7)               ;leave FPU frame untouched
.isinteger:

        addq.l #4,a1                            ;compensate for the a6-push
        move.l 4+2(a6),rs_PC(a7)                ;store the PC here, as first approximation
        addq.l #8,a1                            ;compensate for short stack frame type
        tst.b d0                                ;frame #0: PC is correct and points to the FPU instruction
        beq.s .int2
        cmp.b #2,d0                             ;Post-Instruction, or UnimpFPU?
        beq.s .longframe
        cmp.b #3,d0
        bne.s .pcisfine
.longframe:
        addq.l #4,a1                            ;enlarge the stack frame
        move.l 4+8(a6),rs_EA(a7)                ;fill in EA
.pcisfine:

        cmp.w #$f4,d1                           ;is it unimp integer?
        beq.s .int2
        move.l rs_FPIAR(a7),rs_PC(a7)           ;use this as PC
.int2:

        move.l a7,a0                            ;return data here
        move.l a1,rs_SSP(a7)                    ;keep SSP
        bsr _Exception_Handler

        ;** Now perform state restauration

        lea _OldVectors,a0                      ;get me
        move.w rs_Vector(a7),d0                 ;read offset
        move.l (a0,d0.w),a0                     ;read old jump-in

        move.l (a6),a1                          ;restore a6->a1
        move.l a0,(a6)                          ;push as jump-in
        move.l a1,a6                            ;restore a6

        movem.l rs_DataRegs(a7),d0-d1           ;restore d0,d1
        movem.l rs_AddrRegs(a7),a0-a1           ;restore a0,a1
                                                ;FPU frame is not touched here!
        fmovem.l rs_FPSR(a7),fpsr
        fmovem.l rs_FPIAR(a7),fpiar
        fmovem.l rs_FPCR(a7),fpcr

        restore
        tst.l (a7)                              ;restore FPU state?
        beq.s .restore
        move.l (a7),a7                          ;otherwise, pop SP
        rts

.restore:
        addq.l #4,a7                            ;pop the status indicator
        frestore (a7)+                          ;restore FPU state frame

        rts                                     ;run into the destination setup by the old vector
;ENDFOLD
;FOLD PrintFmt
;*************************************************
;** PrintFmt                                    **
;** Print a formatted string *a0 with stream    **
;** in *a1 to the serial port. Output can be    **
;** captured with Sushi or Sashimi.             **
;** *a6 = SysBase                               **
;**                                             **
;** all entries in the stream are longs, but    **
;** they are used as follows:                   **
;**             %d      signed decimal          **
;**             %x      unsigned hex            **
;**             %s      string                  **
;**             %c      one character           **
;**             %%      the % sign itself       **
;*************************************************
        xdef _VPrintFmt
_VPrintFmt:
        saveregs a2-a3

        move.l a0,a2                    ;get format string
        move.l a1,a3                    ;keep stream

        do
         move.b (a2)+,d0                ;next character
         break.s eq                     ;abort if done
         cmp.b #'%',d0                  ;the format character?
         bne.s .putchar

         move.b (a2)+,d0                ;get the format type
         break.s eq                     ;abort if done
         cmp.b #'%',d0                  ;is it % itself?
         beq.s .putchar
         cmp.b #'d',d0                  ;decimal?
         bne.s .nodecimal
         move.l (a3)+,d0                ;get the number
         bsr _PutDecimal
         reloop.s
.nodecimal:
         cmp.b #'x',d0                  ;hex?
         bne.s .nohex
         move.l (a3)+,d0                ;get hex number
         bsr _PutHex
         reloop.s
.nohex:
         cmp.b #'b',d0                  ;hex byte?
         bne.s .nobyte
         move.l (a3)+,d0
         bsr _PutByte
         reloop.s
.nobyte:
         cmp.b #'c',d0                  ;char?
         bne.s .nochar
         move.l (a3)+,d0
         bra.s .putchar
.nochar:
         cmp.b #'s',d0                  ;string?
         reloop.s ne                    ;if not, ignore

         move.l (a3)+,a0                ;get string
         bsr _PutString
         reloop.s

.putchar:
         jsr RawIOPutChar(a6)        ;if not, just use the serial port
        loop.s

        loadregs
        rts

;**
;** _PutHex:    Dump the hex number d0
;**
_PutHex:
        saveregs d2-d3
        move.l d0,d3                    ;keep it

        for.l #8,d2
         rol.l #4,d3                    ;next digit
         move.b d3,d0                   ;to d0
         and.b #$0f,d0                  ;mask nibble
         or.b #'0',d0                   ;to ASCII
         cmp.b #'9',d0                  ;a number 'a' to 'f' ?
         bls.s .putme
         add.b #'a'-'9'-1,d0            ;offset
.putme:
         jsr RawIOPutChar(a6)        ;if not, just use the serial port
        next d2

        loadregs
        rts
;**
;** _PutByte:    Dump the hex byte d0
;**
_PutByte:
        saveregs d2-d3
        move.l d0,d3                    ;keep it

        for.l #2,d2
         rol.b #4,d3                    ;next digit
         move.b d3,d0                   ;to d0
         and.b #$0f,d0                  ;mask nibble
         or.b #'0',d0                   ;to ASCII
         cmp.b #'9',d0                  ;a number 'a' to 'f' ?
         bls.s .putme
         add.b #'a'-'9'-1,d0            ;offset
.putme:
         jsr RawIOPutChar(a6)        ;if not, just use the serial port
        next d2

        loadregs
        rts
;**
;** _PutDecimal
;**
_PutDecimal:
        saveregs d2-d3/a2

        move.l d0,d3                    ;negative ?
        beq.s .isnull                   ;or null ?
        bpl.s .positive
        moveq #'-',d0
        neg.l d3
        jsr RawIOPutChar(a6)            ;if not, just use the serial port
        bra.s .positive
.isnull:
        moveq #'0',d0
        jsr RawIOPutChar(a6)        ;if not, just use the serial port
        bra.s .exit

.positive:
        lea Powers(pc),a2               ;Powers of ten, lookup table
        moveq #0,d2                     ;character used for the '0'.
                                        ;Leading 0s are not printed
        do
         moveq #-1,d0                   ;divide d3 by d1, result -> d0
         move.l (a2)+,d1                ;next smaller power
         break.s eq                     ;we're done if we're done...
         do
          addq.l #1,d0                  ;this can loop at most 9 times
          sub.l d1,d3                   ;childs stupid division algorithm
         while.s cc                     ;until no more subtraction possible
         add.l d1,d3                    ;undo the last operation
                                        ;result in d0, remainder in d3
         tst.b d0                       ;'0' or not ?
         bne.s .nozero
         tst.b d2                       ;a leading 0 ?
         reloop.s eq                    ;if so, next digit
         moveq #'0',d0                  ;if not, put a zero
         bra.s .putit
.nozero:
         moveq #'0',d2                  ;next nuls are true nuls
         or.b d2,d0                     ;to ASCII
.putit:
         jsr RawIOPutChar(a6)        ;if not, just use the serial port
        loop.s
.exit:
        loadregs
        rts

;**
;** _PutString
;**
_PutString:
        saveregs a2

        move.l a0,a2
        do
         move.b (a2)+,d0
         break.s eq
         jsr RawIOPutChar(a6)        ;if not, just use the serial port
        loop.s

        loadregs
        rts

Powers:         ;** powers of ten for simple binary -> decimal conversion
        dc.l 1000000000
        dc.l 100000000
        dc.l 10000000
        dc.l 1000000
        dc.l 100000
        dc.l 10000
        dc.l 1000
        dc.l 100
        dc.l 10
        dc.l 1
        dc.l 0          ;done.

;ENDFOLD

