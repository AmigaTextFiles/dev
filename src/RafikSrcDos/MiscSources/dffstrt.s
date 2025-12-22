;TOSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
;
;dffstrt pisane 2 raz dysk zaginoî :(((( (przynajmniej chwilowo!:((

StartX:	equ	129-16
Szerokosc:	equ	640+16
		move.w	#StartX,d0
;ddfstrt(hstart/2-8.5)&$fff8
		lsr.w	#1,d0
		move.w	#Szerokosc,d1
		tst.b	Hi
		bmi.s	.hi
		sub.w	#8,d0
		and.w	#$fff8,d0	;ddfSTRT
		lsr.w	#1,d1
		bra.s	.low
.hi
		sub.w	#4,d0
		and.w	#$fffc,d0	;for hires
		lsr.w	#2,d1
.low
;ddfstop(ddfstrt+(size in pixels/4 -8)
		sub.w	#8,d1
		add.w	d0,d1		;dffstop
		rts

Hi:		dc.b	-1

