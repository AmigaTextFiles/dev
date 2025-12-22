        opt o+,ow-
;*************************************************
;** PatchConsole                                **
;** Patches a stupid bug in the console device  **
;*************************************************

        section main_code,code

        include inc:macros.asm
        include inc:exec_lib.asm

PatchConsole:
        move.l ExecBase,a6

        jsr Forbid(a6)

        lea $15e(a6),a0                 ;device list
        lea ConsoleName(pc),a1
        jsr FindName(a6)                ;don't try this stunt yourself
        tst.l d0
        beq .notpatched

        move.l d0,a0
        move.w $14(a0),d1               ;get version
        cmp.w #39,d1                    ;must be V39 or V40
        beq.s .foundV39
        cmp.w #40,d1                    ;or V40 ?
        bne .notpatched

.foundV39:
        lea ConsoleName(pc),a1
        jsr FindTask(a6)                ;don't try this yourself
        tst.l d0
        beq .notpatched

        move.l d0,a4
        move.w $e(a4),d0                ;get the state of the task
        subq.w #$4,d0                   ;must be waiting
        bne .notpatched

        move.l $36(a4),a1               ;get the stack pointer
        move.l $3e(a4),a3               ;check up to this address
        do
         cmp.l a3,a1
         bhs .notpatched
         move.l (a1),a0                 ;read the return address
         cmp.l #$f80004,a0              ;must be above this one
         blo.s .next
         cmp.l #$ffffff,a0              ;and below this one
         bhi.s .next
         move.l -4(a0),d0               ;read the instruction at this address
         cmp.l #$4eaefec2,d0            ;must be Wait(a6)
         bne.s .next

         move.w $3c(a0),d0              ;read first bsr.s
         cmp.w #$6100,d0                ;long branch is not allowed
         beq.s .next
         and.w #$ff01,d0                ;mask out the jump distance
         cmp.w #$6100,d0                ;must be bsr
         bne.s .next

         move.w $5c(a0),d0              ;read first bsr.w
         cmp.w #$6100,d0                ;must be bsr
         bne.s .next

         move.w $82(a0),d0              ;read again instruction
         cmp.w #$6100,d0                ;must be bsr.w again
         beq.s .found                   ;if this matches, too, we got it.
.next:
         addq.l #2,a1                   ;next word
        loop.s
.found:
        move.l a1,a4                    ;the return address is kept here

        lea $84(a0),a1                  ;get first extension word
        move.w (a1),d0                  ;read jump distance
        adda.w d0,a1                    ;the destination of the third jump
        move.l a1,2+RomJump3            ;stunt! Patch in the code

        lea $5e(a0),a2
        move.w (a2),d0
        adda.w d0,a2
        cmp.l a1,a2                     ;these two must go to the same address. Argh.
        bne.s .notpatched
        move.l a1,2+RomJump2

        lea $3c(a0),a1                  ;read first jump
        move.w (a1)+,d0                 ;this is a short jump
        and.w #$00ff,d0                 ;get the jump distance
        beq.s .notpatched               ;if this is long, don't.
        adda.w d0,a1                    ;calculate destination
        move.l a1,2+RomJump1            ;destination

        move.l #WaitBack,(a4)           ;patch return address. Huh!
                                        ;we're done now
        jsr CacheClearU(a6)             ;done

        lea PatchConsole(pc),a0
        clr.l -4(a0)                    ;release segment: Urghl.
        moveq #0,d0                     ;Yes, I know this is ugly.
        bra.s .exit
.notpatched:
        moveq #32,d0
.exit:
        jsr Permit(a6)                  ;does not alter the registers
        rts

ConsoleName:
        dc.b "console.device",0

;*************************************************
;** The following is the replacement            **
;** code of the console.device                  **
;*************************************************

        section patched_code,code

PatchStart:

_loop:
        move.b  $152(a6),d0
        move.b  d0,d1
        and.b   #$1C,d1
        beq.s _release
        btst    #7,d0
        beq.s _release
        bset    #5,d0
        bne.s _release
        move.b  d0,$152(a6)
        move.l  $125A(a6),d0
        beq.s _release
        lea     $1246(a6),a1
        move.w  #9,$1C(a1)
        clr.b   $1E(a1)
        moveq   #0,d1
        move.l  d1,$20(a1)
        move.l  #$186A0,$24(a1)
        move.l  a6,-(a7)
        movea.l d0,a6
        jsr     -$1E(a6)
        movea.l (a7)+,a6
_release:
        lea     $54(a6),a0
        move.l  a6,-(a7)
        movea.l $30(a6),a6
        jsr     -$23A(a6)
        movea.l (a7)+,a6
        move.l  #$F0000000,d0
        move.l  a6,-(a7)
        movea.l $30(a6),a6
        jsr     -$13E(a6)
WaitBack:
        movea.l (a7)+,a6
        move.l  d0,d7
        lea     $54(a6),a0
        move.l  a6,-(a7)
        movea.l $30(a6),a6
        jsr     -$2A6(a6)
        movea.l (a7)+,a6
        tst.l   $50(a6)
        beq _loop
        move.l  d7,d0
        andi.l  #$C0000000,d0
        beq.s _test

        move.l  d7,-(a7)
        lea     $126E(a6),a0
        move.l  a6,-(a7)
        movea.l $30(a6),a6
        jsr     -$234(a6)
        movea.l (a7)+,a6
        lea     $82(a6),a2             ;this is the bug
        bra.s _enterloop
_windowloop:

RomJump1:
        jsr $55555554                   
_enterloop:
        movea.l (a2),a2
        tst.l   (a2)
        bne.s _windowloop
        lea     $126E(a6),a0
        move.l  a6,-(a7)
        movea.l $30(a6),a6
        jsr     -$23A(a6)
        movea.l (a7)+,a6
        move.l  (a7)+,d7
_test:
        btst    #$1D,d7
        beq.s _no1d
RomJump2:
        jsr $aaaaaaaa                   ;ditto
_no1d:
        btst    #$1C,d7
        beq _loop
        lea     $1224(a6),a0
        move.l  a6,-(a7)
        movea.l $30(a6),a6
        jsr     -$174(a6)
        movea.l (a7)+,a6
        bclr    #5,$152(a6)
        beq _loop
RomJump3:
        jsr $aaaaaaaa
        beq _loop

