;*---------------------------------------------------------------------------
;  :Program.	blitfix_imm_58a6.s
;  :Contents.	routine to fix program that does not correctly wait for
;		blitter finish
;		the instruction which writes the "bltsize" register will be
;		patched with a routine which will wait for blitter finish
;		after writing "bltsize"
;  :Version.	$Id: blitfix_imm_58a6.s 1.4 2000/04/16 16:46:17 jah Exp wepl $
;  :History.	30.08.97 extracted from Turrican slave
;		19.03.99 checked area fixed, a2 now returns pointer
;		09.04.00 interrupt blit check added
;  :Requires.	-
;  :Copyright.	Public Domain
;  :Language.	68000 Assembler
;  :Translator.	Barfly V1.131
;  :To Do.
;---------------------------------------------------------------------------*
;
; this will patch the following instruction:
;		move.w	#XXXX,($58,a6)
;
; IN:	A0 = APTR start of memory to patch
;	A1 = APTR end of memory to patch
;	A2 = APTR space for patch routine MUST be < $8000 !!!
;		  required are 6 bytes (8 bytes with PATCHCOUNT)
; OUT:	D0-D1/A0-A1 unchanged
;	A2 = APTR points to the end of patch routine

_blitfix_imm_58a6
		movem.l	a0-a1,-(a7)

	IFD PATCHCOUNT
		clr.w	(6,a2)			;counter = 0
	ENDC

		subq.l	#4,a1
.loop		cmp.w	#$3d7c,(a0)+		;move.w #xxxx,($xxxx,a6)
		bne	.next
		cmp.w	#$0058,(2,a0)
		bne	.next
		move.w	(a0),(2,a0)		;save blitsize
		subq.w	#2,a0
		move.w	#$4eb8,(a0)+		;JSR $xxxx.w
		move.w	a2,(a0)+

	IFD PATCHCOUNT
		addq.w	#1,(6,a2)
	ENDC

.next		cmp.l	a0,a1
		bhs	.loop

		move.w	#$4ef9,(a2)+		;JMP $xxxxxxxx.l
		lea	(.movewait),a0
		move.l	a0,(a2)+

	IFD PATCHCOUNT
		addq.l	#2,a2
	ENDC

		movem.l	(a7)+,a0-a1
		rts

.movewait	move.l	a0,-(a7)
		move.l	(4,a7),a0
		move.w	(a0)+,($58,a6)
		move.l	a0,(4,a7)
		move.l	(a7)+,a0
		BLITWAIT a6
	IFD INTBLITCHECK
		move.l	d0,-(a7)
		move	sr,d0
		and.w	#$0700,d0
		beq	.intok
		illegal
.intok		move.l	(a7)+,d0
	ENDC
		rts
