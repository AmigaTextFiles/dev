
;---;  qsort.r  ;--------------------------------------------------------------
*
*	****	QuickSort    ****
*
*	Author		Daniel Weber
*	Version		0.86
*	Last Revision	14.07.93
*	Identifier	qst_defined
*       Prefix		qst_	(quicksort)
*				 ¯    ¯  ¯
*	Functions	qsort		- sorts a given array of longwords
*
;------------------------------------------------------------------------------

	IFND	qst_defined
qst_defined	SET	1

;------------------
qst_oldbase	equ __BASE
	base	qst_base
qst_base:

;------------------
	opt	sto,o+,ow-,q+,qw-


;------------------------------------------------------------------------------
*
* qst_randomentry
*
* this macro may be used to fill an array with random values
* (it might be very useful to test the quicksort algorithm below):
*
* .fillarray:	REPT	100		;fills longword array with 100 entries
*		qst_randomentry
*		ENDR
*
* note that the use of this macro takes its time to be assembled...
*
;------------------------------------------------------------------------------

qst_randomentry	MACRO
		IFND	.seed
		IFC	'','\1'
.seed		SET	1993+_mcount		;random value + macro number
		ELSE
.seed		SET	\1			;user defined start value
		ENDC
		ENDC

.a		SET	16807			;a:=16807
.m		SET	2147483647		;m:=2147483647
.q		SET	.m/.a			;q:=m DIV a
.r		SET	.m\.a			;r:=m MOD a
.seed		SET	.a*(.seed\.q)-.r*(.seed/.q) ;seed:=a*(seed MOD q)-r*(seed DIV q)
		IFLE	.seed			;IF seed<= 0 THEN
.seed		SET	.seed+.m		;   seed:=seed+m
		ENDC				;END
		dc.l	.seed&$7fffffff		;only positive #
		ENDM


;------------------------------------------------------------------------------
*
* qsort		- QuickSort
*
* INPUT:	D0	#of elements to be sorted
*		A0	start address of array
*
* NOTE:		all register will be unaffected
*
* Memeory use:	O(log2 N)
*
;------------------------------------------------------------------------------

qsort:	apushm
	subq.l	#1,d0
	ble	qst_quickend

	move.l	a0,a2
	lsl.l	#2,d0
	lea	-4+4(a2,d0.l),a3

	pea	qst_quickend(pc)	;a 'bsr.s' will be shorter, but the
					;apushm/apopm would then be sensless...
;
; a2: first element
; a3: last element
;
qst_quick:
	movem.l	a0/a1,-(a7)
qst_quick2:
;*	cmp.l	$110,a7			;just for tests
;*	bge.s	..			;just for tests
;*	move.l	a7,$110			;just for tests
;*..:
	cmp.l	a2,a3			;don't sort if there are no, one, or
	bls.s	.out			;a negative #of elements

;*	addq.l	#1,$120			;just for tests

	move.l	a3,d0			;x:= a[(l+r) DIV 2];
	sub.l	a2,d0
	lsr.l	#1,d0
	and.b	#$fc,d0
	move.l	(a2,d0.l),d1		;the middle element

	move.l	a2,a0			;i:=l
	lea	4(a3),a1		;j:=r (+1 for the predecrement ea below)
					;REPEAT
0$:	cmp.l	(a0)+,d1		;WHILE a[i]<x DO INC(i) END
	bgt.s	0$			;
	subq.l	#4,a0			;

1$:	cmp.l	-(a1),d1		;WHILE a[j]>x DO DEC(j) END
	blt.s	1$			;

2$:	cmp.l	a0,a1			;IF i<=j THEN
	blt.s	3$			;
.swap:	move.l	(a0),d0			;swap a[i],a[j]
	move.l	(a1),(a0)+		;INC(i)
	move.l	d0,(a1)			;DEC(j) END  (DEC will be done above

	cmp.l	a0,a1			;('-(a1)') or some lines below...)
	bgt.s	0$			;UNTIL i>j
	subq.l	#4,a1			;(DEC(j))

3$:	move.l	a1,d0
	sub.l	a2,d0			;#of elements *4 in the left side
	move.l	a3,d1
	sub.l	a0,d1			;#of elements *4 in the right side
	cmp.l	d0,d1
	bge.s	.bigright
;
; this is the recursive part of this quicksort.
; to keep the stack usage as small as possible only the smaller
; part will be called recursively and the larger non-recursively.
;
.bigleft:				;left side is bigger
	move.l	a2,-(a7)
	move.l	a0,a2
	bsr	qst_quick		;QuickSort(j,r)
	move.l	(a7)+,a2
	move.l	a1,a3
	bra	qst_quick2		;QuickSort(l,j)


.bigright:				;right side is bigger
	move.l	a3,-(a7)
	move.l	a1,a3
	bsr	qst_quick		;QuickSort(l,j)
	move.l	(a7)+,a3
	move.l	a0,a2
	bra	qst_quick2		;QuickSort(j,r)

.out:	movem.l	(a7)+,a0/a1
	rts


;--------------------------------------
qst_quickend:				;end quicksort
	apopm	a7			;
	rts

;--------------------------------------------------------------------

	base	qst_oldbase
	opt	rcl

;------------------
	ENDIF

 end

