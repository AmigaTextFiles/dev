
;---;  numbers.r  ;------------------------------------------------------------
*
*	****	NUMBER IN & OUTPUT ROUTINES    ****
*
*	Author		Daniel Weber
*	Version		1.00
*	Last Revision	16.11.94
*	Identifier	nbr_defined
*	Prefix		nbr_	(number)
*				 ¯  ¯ ¯
*	Routines	GetHexNumber, GetDecNumber, GetBinNumber, GetOctNumber,
*			ItoA
*
;------------------------------------------------------------------------------

;------------------
	ifnd	nbr_defined
nbr_defined	=1

;------------------
nbr_oldbase	equ __base
	base	nbr_base
nbr_base:

;------------------

nbr_reglist	REG	d2-d4		; standard register list


;------------------------------------------------------------------------------
*
* GetHexNumber	- Try to get a hexadecimal number. "$" and C-style "0x"
*		  introducers supported
*
* INPUT:	a0	String to interprete.
*
* RESULT:	d0	Result.
*		d1	0 if error, -1 if okay.
*		a0	updated pointer (after number)
*		ccr	On d1.
*
;------------------------------------------------------------------------------
	IFD	xxx_GetHexNumber
	NEED_	nbr_getchar
	NEED_	nbr_prefix

GetHexNumber:
	movem.l	nbr_reglist,-(a7)
	moveq	#0,d0			;number...
	moveq	#0,d3			;mark
	moveq	#8,d6			;max #of digits to read
	bsr	nbr_prefix
	cmp.b	#"$",(a0)+		;$...
	beq.s	..hex
	cmp.b	#"0",-(a0)		;0x...
	bne.s	..err
	cmp.b	#"x",1(a0)
	bne.s	..err
	addq.l	#2,a0

	moveq	#8,d1
.hexloop:
	bsr	nbr_getchar
	sub.b	#"A",d0
	bcc.s	1$
	addq.b	#7,d0
	bpl.s	2$
1$:	add.b	#10,d0
	cmp.b	#15,d0
	bhi.s	2$
	lsl.l	#4,d2
	or.b	d0,d2
	moveq	#1,d3
	dbra	d1,.hexloop
	bra	nbr_failed		;overflow
2$:	move.l	d2,d0
	bra	nbr_exit
	ENDC



;------------------------------------------------------------------------------
*
* GetDecNumber	- Try to get a decimal number.
*
* INPUT:	a0	String to interprete.
*
* RESULT:	d0	Result.
*		d1	0 if error, -1 if okay.
*		a0	points after decimal number
*		ccr	On d1.
*
;------------------------------------------------------------------------------
	IFD	xxx_GetDecNumber
	NEED_	nbr_prefix
GetDecNumber:
	movem.l	nbr_reglist,-(a7)
	bsr	nbr_prefix
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d3
0$:	move.b	(a0)+,d1
	sub.b	#"0",d1
	cmp.b	#9,d1
	bhi.s	1$
	moveq	#1,d3
	move.l	d0,d4
	lsl.l	#3,d0
	add.l	d4,d4
	add.l	d4,d0
	add.l	d1,d0
	bra.s	0$
1$:	tst.w	d3
	sne	d1
	tst.b	d1
	movem.l	(a7)+,_movemlist
	rts
	ENDC




;------------------------------------------------------------------------------
*
* GetBinNumber	- Try to get a binary number (%...).
*
* INPUT:	a0	String to interprete.
*
* RESULT:	d0	Result.
*		d1	0 if error, -1 if okay.
*		a0	points after decimal number
*		ccr	On d1.
*
;------------------------------------------------------------------------------
	IFD	xxx_GetBinNumber
	NEED_	nbr_prefix
	NEED_	nbr_failed
	NEED_	nbr_exit
GetBinNumber:
	movem.l	nbr_reglist,-(a7)
	bsr	nbr_prefix
	moveq	#32,d4			;max # of bits
	moveq	#0,d0
	moveq	#0,d3

1$:	move.b	(a0)+,d1
	sub.b	#"0",d1
	cmp.b	#1,d1
	bhi	nbr_exit
	add.l	d0,d0
	or.b	d1,d0
	moveq	#1,d3
	dbra	d4,1$
	bra	nbr_failed
	ENDC



;------------------------------------------------------------------------------
*
* GetOctNumber	- Try to get a octal number (0...).
*
* INPUT:	a0	String to interprete.
*
* RESULT:	d0	Result.
*		d1	0 if error, -1 if okay.
*		a0	points after decimal number
*		ccr	On d1.
*
;------------------------------------------------------------------------------
	IFD	xxx_GetOctNumber
	NEED_	nbr_prefix
GetOctNumber:
	movem.l	d2-d7/a1-a6,-(a7)
	bsr	nbr_prefix
	moveq	#11,d4
	moveq	#0,d0
.oct:	move.b	(a0)+,d1
	sub.b	#"0",d1
	cmp.b	#7,d1
	bhi	nbr_exit
	lsl.l	#3,d0
	or.b	d1,d0
	moveq	#1,d3
	dbra	d4,.oct
	bra	nbr_failed
	ENDC



;------------------------------------------------------------------------------
*
* ItoA	- Integer (32 bit) to ASCII
*
* INPUT		d0:	integer value
*		d1:	length of buffer
*		a0:	buffer for integer string
*
* RESULT	d0:	pointer to buffer
*		a0:	pointer to buffer after integer string
*
;------------------------------------------------------------------------------
	IFD	xxx_ItoA
ItoA:	movem.l	d2-d5/a0-a1,-(a7)
	lea	nbr_10(pc),a1

nbr_Ito	moveq	#0,d4
.ito:	move.l	(a1)+,d2
	beq.s	.zero
	moveq	#-1,d3

0$:	sub.l	d2,d5
	dbcs	d3,0$
	add.l	d2,d5
	addq.w	#1,d3
	bne.s	1$
	tst.w	d4
	beq.s	.ito

1$:	moveq	#-1,d4
	subq.w	#1,d1
	bmi.s	.err
	neg.b	d3
	add.b	#"0",d3
	move.b	d3,(a0)+
	bra.s	.ito

.zero:	subq.w	#1,d1
	bmi.s	.err
	add.b	#"0",d5
	move.b	d5,(a0)+

.err:	
.exit:	exg	a0,d0
	moven.l	(a7)+,_movemlist
	exg	a0,d0
	rts




;------------------
nbr_10:	dc.l 1000000000
	dc.l 100000000
	dc.l 10000000
	dc.l 1000000
	dc.l 100000
	dc.l 10000			;word from here
	dc.l 1000
	dc.l 100
	dc.l 10
	dc.l 0

	ENDC




;------------------------------------------------------------------------------
*
* used subroutines
*
;------------------------------------------------------------------------------

;
; nbr_exit	- standard exit routine
;
	IFD	xxx_nbr_exit
	NEED_	nbr_failed
nbr_exit:
	tst.b	d3
	beq.s	nbr_failed
	tst.b	d7
	beq.s	1$
	neg.l	d0
1$:	subq.l	#1,a0
	moveq	#-1,d1
	movem.l	(a7)+,nbr_reglist
	rts
	ENDC


;
; nbr_failed	- standard exit routtine if failed
;
	IFD	xxx_nb_failed
nbr_failed:
	movem.l	(a7)+,nbr_reglist
	moveq	#0,d1
	rts
	ENDC



;
; nbr_getchar	- get an uppercased character
;
; a0: pointer
; => d0: (uppercase) char
;    a0: a0+1
;
	IFD	xxx_nbr_getchar
nbr_getchar:
	move.b	(a0)+,d0
	cmp.b	#"a",d0
	blt.s	.out
	cmp.b	#"z",d0
	bhi.s	.out
	and.b	#$df,d0			; convert to uppercase
.out:	rts
	ENDC



;
; nbr_prefix	- get prefix
;
; a0: pointer
; => d7: prefix (0: positive -1: negative)
;    a0: updated
;
	IFD	xxx_nbr_prefix
nbr_prefix:
	moveq	#-1,d7			;sign
..sign:	not.b	d7
	cmp.b	#"-",(a0)+
	beq.s	..sign
	subq.l	#1,a0
	rts
	ENDC




;--------------------------------------------------------------------

	base	nbr_oldbase

	ENDC

	end

