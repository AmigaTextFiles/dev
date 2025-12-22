; hex.asm - convert ascii hex digits to a real hex number
; by Kyzer/CSG
; $VER: hex.asm 1.1 (21.02.00)

; IN:
;  A0=string containing ASCII hex digits

; OUT:
;  D0=value of hex string (32 bit)
;  D1=validity: -1 = valid number, 0 = invalid number

; ALSO TRASHED
;  A0/A1/D2/D3

	cmp.b	#'$',(a0)+		; skip leading '$'
	beq.s	.start
	subq.l	#1,a0

	cmp.b	#'0',(a0)		; skip leading '0x'
	bne.s	.start
	cmp.b	#'x',1(a0)
	bne.s	.start
	addq.l	#2,a0

.start	moveq	#0,d0
	moveq	#8-1,d1
.nxtlet	moveq	#0,d2
	move.b	(a0),d2

	; d2 = asciichar = c; convert c -> x, where
	; c = "0":"9" = 48:57	-> x = 0:9
	; c = "A":"F" = 65:69	-> x = 10:15
	; c = "a":"f" = 97:102	-> x = 10:15

	sub.b	#48,d2		; x = c-"0"        [if c="0":"9" then x=0:9  ]
	bmi.s	.nothex		; if x < 0 then goto FAIL
	cmp.b	#9,d2
	bls.s	.hexok		; if x <= 9 then goto OK
	subq.b	#7,d2		; x-=("A"-"0")+10  [if c="A":"F" then x=10:15]
	cmp.b	#15,d2
	bls.s	1$		; if x > 15 then
	sub.b	#32,d2		; x -= "a"-"A"     [if c="a":"f" then x=10:15]
1$	cmp.b	#15,d2		; if x > 15 then goto FAIL
	bhi.s	.nothex
	tst.b	d2
	bmi.s	.nothex		; if x >= 0 then goto OK

.hexok	asl.l	#4,d0
	add.b	d2,d0

	addq.l	#1,a0
	tst.b	(a0)
	beq.s	.done

	dbra	d1,.nxtlet

.done	moveq	#-1,d1	; OK
	rts
.nothex	moveq	#0,d1	; FAIL
	rts
