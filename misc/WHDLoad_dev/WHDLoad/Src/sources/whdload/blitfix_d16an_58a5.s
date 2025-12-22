;*---------------------------------------------------------------------------
;  :Modul.	blitfix_d16an_58a5.s
;  :Contents.	routine to fix program that does not correctly wait for
;		blitter finish
;		the instruction which writes the "bltsize" register will be
;		patched with a routine which will wait for blitter finish
;		after writing "bltsize"
;  :Version.	$Id: blitfix_d16an_58a5.s 1.5 2000/04/16 16:46:17 jah Exp wepl $
;  :History.	13.09.98 created
;		19.03.99 checked area fixed, a2 now returns pointer
;		09.04.00 interrupt blit check added
;  :Requires.	-
;  :Copyright.	Public Domain
;  :Language.	68000 Assembler
;  :Translator.	Barfly V1.131
;  :To Do.
;---------------------------------------------------------------------------*
;
; this will patch the following instructions:
;		move.w	(d16,a0),($58,a5)
;		move.w	(d16,a1),($58,a5)
;		move.w	(d16,a2),($58,a5)
;
; IN:	A0 = APTR start of memory to patch
;	A1 = APTR end of memory to patch
;	A2 = APTR space for patch routine MUST be < $8000 !!!
;		  required are 18 bytes
; OUT:	D0-D1/A0-A1 unchanged
;	A2 = APTR points to the end of patch routine

_blitfix_d16an_58a5
		movem.l	d0-d2/a0-a1,-(a7)

		move.w	a2,d0			;D0 = address for A0
		move.w	#$4ef9,(a2)+		;JMP $xxxxxxxx.l
		pea	.waita0
		move.l	(a7)+,(a2)+
		move.w	a2,d1			;D1 = address for A1
		move.w	#$4ef9,(a2)+		;JMP $xxxxxxxx.l
		pea	.waita1
		move.l	(a7)+,(a2)+
		move.w	a2,d2			;D2 = address for A2
		move.w	#$4ef9,(a2)+		;JMP $xxxxxxxx.l
		pea	.waita2
		move.l	(a7)+,(a2)+

		subq.l	#4,a1
.loop		cmp.w	#$0058,(4,a0)
		bne	.next
		cmp.w	#$3b68,(a0)		;move.w ($xxxx,a0),($xxxx,a5)
		beq	.a0
		cmp.w	#$3b69,(a0)		;move.w ($xxxx,a1),($xxxx,a5)
		beq	.a1
		cmp.w	#$3b6a,(a0)		;move.w ($xxxx,a2),($xxxx,a5)
		bne	.next
.a2		move.w	#$4eb8,(a0)+		;JSR $xxxx.w
		move.w	(a0),(2,a0)		;save d16
		move.w	d2,(a0)+		;routine
		bra	.next
.a1		move.w	#$4eb8,(a0)+		;JSR $xxxx.w
		move.w	(a0),(2,a0)		;save d16
		move.w	d1,(a0)+		;routine
		bra	.next
.a0		move.w	#$4eb8,(a0)+		;JSR $xxxx.w
		move.w	(a0),(2,a0)		;save d16
		move.w	d0,(a0)+		;routine
.next		addq.l	#2,a0
		cmp.l	a0,a1
		bhs	.loop

		movem.l	(a7)+,d0-d2/a0-a1
		rts

.waita0		move.l	a1,-(a7)
		move.l	(4,a7),a1
		add.w	(a1),a0
		move.w	(a0),($58,a5)
		sub.w	(a1)+,a0
		move.l	a1,(4,a7)
		move.l	(a7)+,a1
		BLITWAIT a5
	IFD INTBLITCHECK
		move.l	d0,-(a7)
		move	sr,d0
		and.w	#$0700,d0
		beq	.intok
		illegal
.intok		move.l	(a7)+,d0
	ENDC
		rts

.waita1		move.l	a0,-(a7)
		move.l	(4,a7),a0
		add.w	(a0),a1
		move.w	(a1),($58,a5)
		sub.w	(a0)+,a1
		move.l	a0,(4,a7)
		move.l	(a7)+,a0
		BLITWAIT a5
	IFD INTBLITCHECK
		move.l	d0,-(a7)
		move	sr,d0
		and.w	#$0700,d0
		beq	.intok
		illegal
.intok		move.l	(a7)+,d0
	ENDC
		rts

.waita2		move.l	a0,-(a7)
		move.l	(4,a7),a0
		add.w	(a0),a2
		move.w	(a2),($58,a5)
		sub.w	(a0)+,a2
		move.l	a0,(4,a7)
		move.l	(a7)+,a0
		BLITWAIT a5
	IFD INTBLITCHECK
		move.l	d0,-(a7)
		move	sr,d0
		and.w	#$0700,d0
		beq	.intok
		illegal
.intok		move.l	(a7)+,d0
	ENDC
		rts
