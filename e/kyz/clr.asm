; mem := clr(mem, sze)
; clears sze bytes of memory starting at mem, returns mem

; mem := memset(mem, chr, sze)
; puts char chr into sze bytes of memory starting at mem. returns mem

; PROC memset(mem:PTR TO CHAR, chr, sze)
;   DEF end; end := mem + sze
;   WHILE mem < end DO mem[]++ := chr
; ENDPROC mem - sze

; PROC clr(mem, sze) IS memset(mem, 0, sze)

	xdef	clr__ii
clr__ii	move.l	4(sp),a1	; get sze
	moveq	#0,d0		; chr = 0
	bsr.s	_bla		; jump into memset with 4 more bytes on stack:
	rts			; mem=8(sp) -> mem=12(sp). sze/chr already set

	xdef	memset__iii
memset__iii
	move.l	8(sp),d0	; get chr
	move.l	4(sp),a1	; get sze
_bla	move.l	12(sp),a0	; get mem
	adda.l	a0,a1
.loop	cmp.l	a0,a1
	bls.s	.exit		; exit when a0 >= end
	move.b	d0,(a0)+	; a0[]++:=d0
	bra.s	.loop		; repeat
.exit	move.l	12(sp),d0
	rts
