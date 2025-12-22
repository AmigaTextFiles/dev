
; Listing13k2b.s 
; Zeile 2181

start:
mouse2:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse2				; Wenn nicht, gehe zurück zu mouse2:

	movea.l #$40000,a0
	Move.b #"1",(a0)
	Move.w #"12",(a0)
	Move.l #"1234",(a0)

	rts

	end

; Ich werde die folgende Sache bekommen:
			;           (a)	(b)	(c)
			; $40000	"1"	"1"	"1"
			; $40001	"0"	"2"	"2"
			; $40002	"0"	"0"	"3"
			; $40003	"0"	"0"	"4"

>d pc
000212b8 66f6                     bne.b #$f6 == $000212b0 (T)
000212ba 207c 0004 0000           movea.l #$00040000,a0
000212c0 10bc 0031                move.b #$31,(a0) [31]
000212c4 30bc 3132                move.w #$3132,(a0) [3100]
000212c8 20bc 3132 3334           move.l #$31323334,(a0) [31000000]
000212ce 4e75                     rts  == $00c4f7b8

>f 212ba
Breakpoint added.
>g

>m ra0
00040000 3100 0000 0000 0000 0000 0000 0000 0000  1...............

>m ra0
00040000 3132 0000 0000 0000 0000 0000 0000 0000  12..............

>m ra0
00040000 3132 3334 0000 0000 0000 0000 0000 0000  1234............