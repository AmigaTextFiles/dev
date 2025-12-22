;*---------------------------------------------------------------------------
;  :Modul.	blitfix_dn_58a6.s
;  :Contents.	routine to fix program that does not correctly wait for
;		blitter finish
;		the instruction which writes the "bltsize" register will be
;		patched with a routine which will wait for blitter finish
;		after writing "bltsize"
;  :Version.	$Id: blitfix_dn_58a6.s 1.5 2000/04/16 16:46:17 jah Exp wepl $
;  :History.	30.08.97 extracted from Turrican slave
;		19.03.99 checked area fixed, a2 now returns pointer
;		05.04.00 bug in patchcount fixed
;		09.04.00 interrupt blit check added
;  :Requires.	-
;  :Copyright.	Public Domain
;  :Language.	68000 Assembler
;  :Translator.	Barfly V1.131
;  :To Do.
;---------------------------------------------------------------------------*
;
; this will patch the following instructions:
;		move.w	d0,($58,a6)
;		move.w	d1,($58,a6)
;		move.w	d2,($58,a6)
;		move.w	d3,($58,a6)
;		move.w	d4,($58,a6)
;		move.w	d5,($58,a6)
;		move.w	d6,($58,a6)
;		move.w	d7,($58,a6)
;
; IN:	A0 = APTR start of memory to patch
;	A1 = APTR end of memory to patch
;	A2 = APTR space for patch routine MUST be < $8000 !!!
; OUT:	D0-D1/A0-A1 unchanged
;	A2 = APTR points to the end of patch routine

_blitfix_dn_58a6
		movem.l	d0/a0-a1,-(a7)

	IFD PATCHCOUNT
		clr.l	(a2)+
		clr.l	(a2)+
	ENDC

		subq.l	#2,a1
.loop		move.w	(a0)+,d0
		and.w	#$fff8,d0
		cmp.w	#$3d40,d0		;move.w dx,($58,a6)
		bne	.next
		cmp.w	#$0058,(a0)
		bne	.next
		move.w	-(a0),d0		;old opcode
		move.w	#$4eb8,(a0)+		;JSR $XXXX.w
		move.w	a2,(a0)
		and.w	#7,d0			;register number

	IFD PATCHCOUNT
		addq.b	#1,(-8,a2,d0.w)
	ENDC

		mulu	#6,d0
		add.w	d0,(a0)+		;jmp address
.next		cmp.l	a0,a1
		bhs	.loop

		lea	(.wait_d0),a0
		lea	(.wait_end),a1
.cpy		move.w	(a0)+,(a2)+
		cmp.l	a0,a1
		bne	.cpy

		movem.l	(a7)+,d0/a0-a1
		rts

.wait_d0	move.w	d0,($58,a6)
		bra.b	.wait
.wait_d1	move.w	d1,($58,a6)
		bra.b	.wait
.wait_d2	move.w	d2,($58,a6)
		bra.b	.wait
.wait_d3	move.w	d3,($58,a6)
		bra.b	.wait
.wait_d4	move.w	d4,($58,a6)
		bra.b	.wait
.wait_d5	move.w	d5,($58,a6)
		bra.b	.wait
.wait_d6	move.w	d6,($58,a6)
		bra.b	.wait
.wait_d7	move.w	d7,($58,a6)
.wait		BLITWAIT a6
	IFD INTBLITCHECK
		move.l	d0,-(a7)
		move	sr,d0
		and.w	#$0700,d0
		beq	.intok
		illegal
.intok		move.l	(a7)+,d0
	ENDC
		rts
.wait_end
