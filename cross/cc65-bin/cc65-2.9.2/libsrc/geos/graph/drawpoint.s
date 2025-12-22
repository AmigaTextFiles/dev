
;
; Maciej 'YTM/Elysium' Witkowiak
;
; 29.10.99

; void DrawPoint	(struct pixel *mypixel);


	    .import PointRegs
	    .export _DrawPoint

	    .include "../inc/jumptab.inc"

_DrawPoint:
	    jsr PointRegs
	    sec
	    lda #0
	    jmp DrawPoint
