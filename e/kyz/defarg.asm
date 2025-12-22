; a shorter (code and execution-wise) replacement for 'IF x THEN x ELSE y'.
; instead of 'IF x THEN x ELSE y', write 'defarg(x, y)'

	xdef	defarg__ii
defarg__ii
	move.l	8(sp),d0
	bne.s	.done
	move.l	4(sp),d0
.done	rts
