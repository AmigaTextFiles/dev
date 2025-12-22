; fast copy memory, source and dest must not overlap
; origins from gfx3d.library source on Aminet
; http://aminet.net/package/util/libs/gfx3dlib_31_src

	MACHINE	68020

	XDEF       __C2P_CopyMem





	; copy 4 bytes per time
C2P_CopyMem4	MACRO	(src,dest,size)(a0,a1,d0)
	dbra	d0,.\@loop
	bra.s	.\@exit
	CNOP	0,4
.\@loop:
	move.l	(a0)+,(a1)+
	dbra	d0,.\@loop
.\@exit:
	ENDM



C2P_CopyMem16	MACRO	(src,dest,size)(a0,a1,d0)
;	tst.l	d0
;	beq.s	.\@exit
.\@start:
	ror.l	#1,d0
	dbra	d0,.\@32bytes
	bra.s	.\@16bytes
	CNOP	0,4
.\@32bytes:
	movem.l	d2-d7/a2,-(sp)
.\@loop:
	movem.l	(a0)+,d1-d7/a2
	movem.l	d1-d7/a2,(a1)
	moveq	#32,d1
	add.l	d1,a1
	dbra	d0,.\@loop
	movem.l	(sp)+,d2-d7/a2
;	tst.l	d0
;	bpl.s	.\@exit
.\@16bytes:
	tst.l	d0
	bpl.s	.\@exit
	movem.l	d2-d3,-(sp)
	movem.l	(a0),d0-d3
	movem.l	d0-d3,(a1)
	movem.l	(sp)+,d2-d3
.\@exit:
	ENDM

pop   MACRO reg
	move.\0 (sp)+,\1
	ENDM

push  MACRO reg
	move.\0 \1,-(sp)
	ENDM




	section    code





; C2P_CopyMem
; Copy a block of memory from source to dest.
; Source and dest memory area must not to overlap.
; a0 = address of source memory block to copy from
; a1 = address of dest memory area to copy to
; d0 = number of bytes to copy
	public	__C2P_CopyMem
	cnop	0,4
__C2P_CopyMem:
	tst.l	d0
	ble.s	.exit

	move.l	d0,d1
	asr.l	#3,d0

	tst.l	d0
	ble.l	.loop_end
.loop:
	REPT	2
	move.l	(a0)+,(a1)+		; copy quadwords
	ENDR
	subq	#1,d0
	bgt.s	.loop

.loop_end:
	ror.l	#3,d1
	bcc.s	.odd_longword_done
	move.l	(a0)+,(a1)+		; copy odd longword

.odd_longword_done:
	rol.l	#1,d1
	bpl.s	.odd_word_done
	move.w	(a0)+,(a1)+		; copy odd word

.odd_word_done:
	rol.l	#1,d1
	bpl.s	.exit
	move.b	(a0)+,(a1)+		; copy odd byte

.exit:
	rts



	end

