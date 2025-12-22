		IFND	PYPERMACRO
PYPERMACRO	SET	1
Call	MACRO
	JSR	_LVO\1(a6)
	ENDM

Exec	MACRO
	movea.l	4.w,a6
	ENDM
	
mousewait	MACRO
mwa\@		move.w	$dff106,d0
		and.w	#\1,d0
		move.w	d0,$dff180
		btst	#6,$bfe001
		beq.b	mwa\@
mwb\@		move.w	$dff106,d0
		or.w	#\1,d0
		move.w	d0,$dff180
		btst	#6,$bfe001
		bne.b	mwb\@
		ENDM

GetTagData	MACRO	; tag,default,taglist	[A6 must be uty base]
		movea.l	\3,a0
		move.l	#\1,d0
		move.l	#\2,d1
		Call	GetTagData
		ENDM

FindGetData	MACRO	; tag,taglist,faillabel
		movea.l	\2,a0
		move.l	#\1,d0
		Call	FindTagItem
		tst.l	d0
		beq	\3
		movea.l	d0,a0
		movea.l	4(a0),d0
		ENDM
		
FindTag		MACRO	; tag,taglist
		movea.l	\2,a0
		move.l	#\1,d0
		Call	FindTagItem
		ENDM

SetTagData	MACRO	; tag,value,taglist
		FindTag	\1,\3
		tst.l	d0
		beq.b	.no\@
		movea.l	d0,a0
		move.l	\2,4(a0)
.no\@
		ENDM
		
bxxxm	MACRO	; \1(bit),\2offset,\3=Ax,\4=xxx
	IFLT	\1-8
	b\4	#\1,\2+3(\3)
	ELSE
	IFLT	\1-16
	b\4	#\1-8,\2+2(\3)
	ELSE
	IFLT	\1-24
	b\4	#\1-16,\2+1(\3)
	ELSE
	IFLT	\1-32
	b\4	#\1-24,\2(\3)
	ELSE
	illegal
	ENDC
	ENDC
	ENDC
	ENDC
	ENDM

bclrm	MACRO	
	bxxxm	\1,\2,\3,clr
	ENDM
	
bsetm	MACRO	
	bxxxm	\1,\2,\3,set
	ENDM

btstm	MACRO	
	bxxxm	\1,\2,\3,tst
	ENDM

bchgm	MACRO	
	bxxxm	\1,\2,\3,chg
	ENDM
	
TRUE	EQU	-1
FALSE	EQU	0	

mulu64	MACRO
	mulu.l	\1,\2:\3
	ENDM

divu64	MACRO
	divu.l	\1,\2:\3
	ENDM
	
muls64	MACRO
	muls.l	\1,\2:\3
	ENDM

divs64	MACRO
	divs.l	\1,\2:\3
	ENDM	
	
mulsn		MACRO	; 32*32=32 HiPrecision.		\1,\2,\3(skr)
		muls64	\1,\3,\2
		move.w	\3,\2
		swap	\2
		ENDM

mulun		MACRO	; 32*32=32 HiPrecision.		\1,\2,\3(skr)
		mulu64	\1,\3,\2
		move.w	\3,\2
		swap	\2
		ENDM


; Obsolete: use PyTree instead, wich is faster for big numbers because of a table.
; If you know your number to be little, you can use this. Or if you need a small
; routine to stay in cache. Try them, then select.

PyRadix		MACRO	; \1=dx(a^2) \2=dy=a 	IF \1<0, returns 0 !!!
		moveq.l	#-1,\2
.subloop\@	addq.l	#2,\2
		sub.l	\2,\1
		bpl.b	.subloop\@
		lsr.l	#1,\2
		ENDM

; PyTree macro: calcs the sqr of a number, using a scalable table.
; WARNING: NEGATIVE NUMBERS GIVE ABSURDE RESULTS! NO INTERNAL CHECK!
; Optimization 1. Eliminate cmps, use only a unique sub at start.

; OLD !! Use Graham's one instead !! FFFAST and NO TABLE !

PyTree	MACRO	;\1=x \2=Ax pointing to table \3=x^.5(result) \4=skratch
	bra.b	.cyc\@
.jump\@	move.l	(\2),\3
	ble.b	.fnd\@
	lea.l	(\2,\3.l),\2
.cyc\@	move.l	(\2)+,\4
	sub.l	\1,\4
	beq.b	.exact\@
	blt.b	.jump\@
	tst.l	(\2)
	bmi.b	.fnd\@
	addq.l	#8,\2
	bra.b	.cyc\@
.exact\@
	move.l	4(\2),\3
	bra.b	.had\@
.fnd\@	addq.l	#4,\2
	move.l	(\2)+,\3
	beq.b	.had\@
	blt.b	.low\@
.high\@	subq.l	#2,\3
	sub.l	\3,\4
	bgt.b	.high\@
	bra.b	.had\@
.low\@	add.l	\3,\4
	addq.l	#2,\3
	ble.b	.low\@
	subq.l	#2,\3
.had\@	lsr.l	#1,\3
	ENDM

*	move.l	#896*896,d0
*	lea.l	Table,a0
*	PyTree	d0,a0,d1,d2
*	rts
*Table	incbin	"ram:pytree.table"
	
; Tested with 900*900: ok,exact (goes into high cycle)
; Tested with 900*900+1: ok,same
; Tested with 895*895: ok,exact (goes into low cycle)
; Tested with 895*895+1: BAD, gives 896. correct !
; ReTested with 895*895+1: ok,gives 895
; ReTested with 895*895: ok,gives 895
; Tested with 896*896: ok,gives 896, BUT DOES THE low CYCLE! 896 is in the table! must do directly!
; ReTested with 896*896: ok,does directly.
; Post-Opt1:
; ReTested with 896*896: ok,gives 896 (no more directly,table changed.)

; Profiler info: PyTree is faster than PyRadix, MUCH faster, with quite big values 
; (from 200 and more,...)

PySqrt	MACRO	; \1=a^2 \2=a \3 skr \4 skr
	moveq	#1,\2		;thank goes to  
	ror.l	#2,\2		;Graham for this 
        moveq   #32,\3		;fast and short sqrter 
.l2n 
        move.l  \2,\4 
        rol.l   \3,\4 
        add.w   \2,\2 
        cmp.l   \4,\1 
        bcs.b   .no 
        addq.w  #1,\2 
        sub.l   \4,\1 
.no 
        subq.w  #2,\3 
        bgt.b   .l2n 
        andi.l	#$0000ffff,\2
	ENDM 

BrowseList	MACRO	; \1=Label,\2=Ax \3=ListHeader (loaded by lea.l \3,\2)
		IFNC	'','\3'
		lea.l	\3,\2
		ENDC
		bra	\1_END
\1
		ENDM

BrowseListEnd	MACRO	; \1=Label,\2=Ax
\1_END		TSTNODE	\2,\2
		bne	\1
		ENDM

BrowseArray	MACRO	; \1=Label
		bra	\1_END
\1
		ENDM

BrowseArrayEnd	MACRO	; \1=Label,\2=Ax array,\3=Ax Item, d0 skr !!!
\1_END		movea.l	(\2)+,\3
		move.l	\3,d0
		bne	\1
		ENDM
		
;----------------- DEBUG MACROS -------------------------------------------------------

BeNasty		MACRO
NastyCode	SET	1
		ENDM

NoNasty		MACRO
NastyCode	SET	0
		ENDM		
NastyBK		MACRO
		IFD	NastyCode
		IFNE	NastyCode
		illegal
		ENDC
		ENDC
		ENDM
		
;----------------- stack taglists -------------------------------

TagStkGet	MACRO	
STAKKEDTAGS	SET	0
		clr.l	-(a7)
		ENDM

TagStk		MACRO	; \1=tagvalue (without #),\2=tag data (<ea>)
STAKKEDTAGS	SET	STAKKEDTAGS+1
		move.l	\2,-(a7)
		move.l	#\1,-(a7)
		ENDM

TagStkAx	MACRO	;\1=ax
		IFC	'','\1'
		movea.l	a7,a1
		ELSE
		movea.l	a7,\1
		ENDC
		ENDM
		
TagStkPop	MACRO
		IFNE	STAKKEDTAGS
		lea.l	STAKKEDTAGS*8+4(a7),a7
		ENDC
		ENDM

		ENDC