
;---;  parse.r  ;--------------------------------------------------------------
*
*	****	TEXT PARSE ROUTINES    ****
*
*	Author		Stefan Walter
*	Add. Code	Daniel Weber
*	Version		1.01
*	Last Revision	02.03.92
*	Identifier	pre_defined
*       Prefix		pre_	(parse)
*				 ¯ ¯ ¯
*	Functions	RemoveSpaces, CopyLine, CopyZeroText, NextLine
*
;------------------------------------------------------------------------------

;------------------
	ifnd	pre_defined
pre_defined	=1

;------------------
pre_oldbase	equ __base
	base	pre_base
pre_base:

;------------------

;------------------------------------------------------------------------------

;------------------
; REMOVESPACES
;	Jumps to next char that is not a space or tab
;
;	a0=text position	=>	next text position
;
	IFD	xxx_RemoveSpaces
RemoveSpaces:
	cmp.b	#$20,(a0)+
	beq.s	RemoveSpaces
	subq.w	#1,a0
	cmp.b	#$9,(a0)+
	beq.s	RemoveSpaces
	subq.w	#1,a0
	rts

	ENDC

;------------------
; COPYLINE
; 	Copies text from the current position to the end of line or begin
;	of comments. Jumps directly after next <CR> and leaves all kinds of
;	comments out. Maximum chars that are copied are 256, endchar is zero.
;	spaces before text end are removed. tabs are converted to spaces.
;	stuff in ' or " will be left intact and copied unchanged.
;	Source text must end with zero byte!
;
;	a0=text position	=>	next text position
;	a1=buffer		=>	points after <CR>
;	d0			=>	number of bytes or 0 if EOF
;	d1=number of this line	=>	number of next line
;	ccr			=>	set on test d0
;
	IFD	xxx_CopyLine
CopyLine:
	move.l	d2,-(sp)
	move.l	d1,d2
	moveq	#0,d0
	tst.b	(a0)		;end char reached?
	beq.s	\done

\copychar:
	addq.w	#1,d0
	move.b	(a0)+,d1
	cmp.b	#";",d1
	beq.s	\remcomment
	cmp.b	#"*",d1
	beq.s	\remcomment
	cmp.b	#"\",d1
	bne.s	\nocomment
	cmp.b	#"*",(a0)
	beq.s	\remmulticomment

\nocomment:
	cmp.b	#$a,d1
	beq.s	\crend
	cmp.b	#$9,d1
	bne.s	\notab
	moveq	#" ",d1
\notab:
	move.b	d1,(a1)+
	cmp.b	#'"',d1
	beq.s	\forcetext
	cmp.b	#"'",d1
	beq.s	\forcetext
	cmp.w	#256,d0
	blt.s	\nomax
	subq.w	#1,a1
	subq.w	#1,d0
\nomax:
	bra.s	\copychar

;------------------
\crend:
	addq.l	#1,d2
\ending:
	subq.w	#1,d0
	beq.s	\setend
	cmp.b	#$20,-(a1)
	beq.s	\ending
	addq.w	#1,a1

\setend:
	clr.b	(a1)+
	addq.w	#1,d0

\done:
	move.l	d2,d1
	move.l	(sp)+,d2
	tst.w	d0
	rts

;------------------
; remove comment with ';' or '*'
;
\remcomment:
	tst.b	(a0)
	beq.s	\ending
	cmp.b	#$a,(a0)+
	bne.s	\remcomment
	bra.s	\crend

;------------------
; remove comment in \* *\, stuff right after *\ will be declared
; as new line, even if it's only a <CR>
;
\remmulticomment:
	move.b	(a0),d1
	beq.s	\ending
	addq.w	#1,a0
	cmp.b	#$a,d1
	bne.s	\nocomcr
	addq.l	#1,d2
\nocomcr:
	cmp.b	#"*",d1
	bne.s	\remmulticomment
	cmp.b	#"\",(a0)
	bne.s	\remmulticomment
	addq.w	#1,a0
	bra.s	\ending
	
;------------------
; copy text in ' or "
;
\forcetext:
	tst.b	(a0)
	beq.s	\ending
	addq.w	#1,d0
	cmp.b	#$a,(a0)+
	beq.s	\crend
	move.b	-(a0),(a1)+
	cmp.w	#256,d0
	blt.s	\noover
	subq.w	#1,d0
	subq.w	#1,a1
\noover:	
	cmp.b	(a0)+,d1
	bne.s	\forcetext
	bra.s	\nomax
	

	ENDC

;------------------
; COPYZEROTEXT
;	Copies a zeroterminated text
;
;	a0=destination		=>	next text position
;	a1=text to be copied
;
	IFD	xxx_CopyZeroText
CopyZeroText:
	move.b	(a1)+,(a0)+
	bne.s	CopyZeroText
	subq.w	#1,a0
	rts
	ENDC

;------------------
; NEXTLINE
;	move current position to next line
;	LF and null-byte accepted as eol characters.
;
;	a0: text
;
	IFD	xxx_NextLine
NextLine:
	cmp.b	#$a,(a0)
	beq.s	.out
	tst.b	(a0)+
	bne.s	NextLine
	subq.l	#1,a0
.out:	addq.l	#1,a0
	rts
	ENDC
	


;------------------

;--------------------------------------------------------------------

;------------------
	base	pre_oldbase

;------------------
	endif

 end

