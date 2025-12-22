
;---;  configfile.r  ;---------------------------------------------------------
*
*	****	CONFIGURATION FILE MANAGEMENT    ***
*
*	Author		Stefan Walter
*	Version		1.01
*	Last Revision	19.03.94
*	Identifier	rwc_defined
*       Prefix		rwc_	(Read and Write Configuration)
*				 ¯        ¯     ¯
*	Functions	ReadConfigFile, WriteConfigFile
*
*	Requirements	dosfile.r, numbers.mac, stringmacros.r
*
;------------------------------------------------------------------------------

	IFND	rwc_defined
rwc_defined	SET	1

;------------------
rwc_oldbase	EQU __BASE
	base	rwc_base
rwc_base:

;------------------
	include	numbers.r
	include	configfile.i


;------------------

;------------------------------------------------------------------------------
*
* ReadConfigFile	Read a configuration file.
*
* INPUT:	a0:	File name.
*		a1:	Configuration structure.
*
* RESULT:	d0:	-1 if successful, 0 if error.
*		d1:	if d0=0: Line number or 0 if file not found.
*
;------------------------------------------------------------------------------
	IFD	xxx_ReadConfigFile
ReadConfigFile:
	movem.l	d2-a6,-(sp)
	lea	rwc_base(pc),a4
	move.l	a1,a5
	clr.l	\linenum(a4)
	moveq	#0,d6
	moveq	#0,d7

\load:	move.l	a0,d0
	moveq	#0,d1
	moveq	#1,d2
	CALL_	LoadFile
	move.l	d0,\text
	move.l	d0,\block
	beq	\done
	move.l	d2,\textlen
	move.l	d0,a0
	tst.b	(a0)			:file starts with 0? -> error
	beq	\free
	clr.b	-1(a0,d2)
	addq.l	#1,\linenum(a4)

\loop:	move.l	\text(pc),a0
	lea	\buffer(pc),a1
	move.l	\linenum(a4),d7
	move.l	d7,d1
	CALL_	CopyLine
	move.l	a0,\text(a4)
	clr.b	-(a1)			;remove CR
	move.l	d1,\linenum(a4)
	tst.w	d0
	beq	\fine
	
\search:
	move.l	a5,a2
	lea	\buffer(pc),a3
\slsk:	cmp.b	#" ",(a3)+
	beq.s	\slsk
	subq.l	#1,a3
	tst.b	(a3)
	beq.s	\loop

\sloop:	move.l	a3,a0
	tst.b	(a2)
	beq	\free			;not found
	cmp.b	#rwc_BITS0,(a2)
	bhs.s	\od
	cmp.b	#rwc_FLAGOFF,(a2)
	bhi.s	\slnext
\od:	move.w	rwc_offset1(a2),d0
	lea	(a4,d0),a1
	bsr	\compare
	bne.s	\found
\slnext:
	lea	rwc_SIZEOF(a2),a2
	bra.s	\sloop
	
\found:	move.l	a2,a3
	move.l	a0,d4
	move.w	rwc_readcall(a3),d0
	beq.s	\norc
	jsr	(a4,d0)
	tst.w	d0
	beq	\free
\norc:	move.w	rwc_offset2(a3),d1
	cmp.b	#rwc_FLAGON,(a3)
	beq	\flagon
	cmp.b	#rwc_FLAGOFF,(a3)
	beq	\flagoff
	cmp.b	#rwc_BITC0,(a3)
	bhs	\rbitc
	cmp.b	#rwc_BITS0,(a3)
	bhs	\rbits

\doall:	lea	rwc_SIZEOF(a3),a3
	cmp.b	#rwc_ENDLOOP,(a3)
	beq.s	\last	
	bls.s	\alldone
	cmp.b	#rwc_IF,(a3)
	beq.s	\alldone
	move.l	d4,a0
	CALL_	RemoveSpaces

	moveq	#0,d0
	move.b	(a3),d0
	add.w	d0,d0
	lea	\jumps(pc),a1
	move.w	-2*rwc_DECBYTE(a1,d0),d1
	move.w	rwc_offset1(a3),d2
	lea	(a4,d2),a1
	move.w	rwc_offset2(a3),d2
	lea	(a4,d2),a2
	jsr	(a4,d1)

	move.l	a0,d4
	tst.w	d0
	beq.s	\free
	move.w	rwc_readcall(a3),d0
	beq.s	\norc2
	jsr	(a4,d0)
	tst.w	d0
	beq.s	\free
\norc2:	bra.s	\doall

\last	move.w	rwc_readcall(a3),d0
	beq.s	\norc3
	jsr	(a4,d0)
	tst.w	d0
	beq.s	\free
\norc3:	bra.s	\doall

\alldone:
	bra	\loop

\fine:	moveq	#-1,d6

\free:	move.l	4.w,a6
	move.l	\block(pc),a1
	move.l	\textlen(pc),d0
	jsr	-210(a6)		;FreeMem
	
\done:	move.l	d7,d1
	move.l	d6,d0
	movem.l	(sp)+,d2-a6
	rts

\flagon:
	st.b	(a4,d1)
\flagdone:
	bra	\loop
\flagoff:
	sf.b	(a4,d1)
	bra.s	\flagdone

\rbits:	move.b	(a3),d0
	sub.b	#rwc_BITS0,d0
	bset	d0,(a4,d1)
	bra.s	\flagdone

\rbitc:	move.b	(a3),d0
	sub.b	#rwc_BITC0,d0
	bclr	d0,(a4,d1)
	bra.s	\flagdone


\jumps:	dc.w	\rnumber%
	dc.w	\rnumber%
	dc.w	\rnumber%
	dc.w	\rnumber%
	dc.w	\rnumber%
	dc.w	\rnumber%
	dc.w	\rkeywords%
	dc.w	\rstrptr%
	dc.w	\rstring%

;------------------
\compare:			;a0: pointer in text, a1: pointer on KW
	movem.l	d1/d2,-(sp)	;d0:1= exact match, 0: not matched 
\cmploop:
	move.b	(a1)+,d0
	bsr.s	\makeupper
	move.b	d0,d1
	move.b	(a0)+,d0
	bsr.s	\makeupper
	cmp.b	d0,d1
	bne.s	\cmpdone
	tst.b	d0
	bne.s	\cmploop

\cmpdone:
	subq.l	#1,a0
	subq.l	#1,a1
	cmp.b	#" ",(a0)
	beq.s	\cmpok1
	tst.b	(a0)
	bne.s	\cmpbad
\cmpok1:tst.b	(a1)
	bne.s	\cmpbad
	moveq	#1,d0
	bra.s	\cmprts
\cmpbad:moveq	#0,d0
\cmprts:movem.l	(sp)+,d1/d2
	rts

\makeupper:
	cmp.b	#"a",d0
	blt.s	\isupper
	cmp.b	#"z",d0
	bgt.s	\isupper
	sub.b	#32,d0
\isupper:
	rts

;------------------
\rnumber:	
	cmp.b	#"$",(a0)
	beq.s	\rhex
\rdec:	GetDecNumber_
	beq	\rerr
	bra	\rstore
\rhex:	GetHexNumber_
	beq	\rerr
\rstore:moveq	#0,d1
	move.b	(a3),d1
	subq.b	#rwc_DECBYTE,d1
	divu	#3,d1
	swap	d1
	subq.b	#1,d1	
	bmi.s	\rbyte
	beq.s	\rword
\rlong:	move.l	d0,(a1)
	bra.s	\rokay
\rword:	move.w	d0,(a1)
	bra.s	\rokay
\rbyte:	move.b	d0,(a1)
\rokay:	moveq	#-1,d0
	rts
\rerr:	moveq	#0,d0
	rts

\rkeywords:
	move.l	a1,d3
	move.l	a0,d2
\rkeyl:	move.w	2(a2),d0
	beq.s	\rerr		;key not found!
	lea	(a4,d0),a1
	move.l	d2,a0
	bsr	\compare
	bne.s	\rkf
	addq.l	#4,a2
	bra.s	\rkeyl
\rkf:	move.l	d3,a1
	move.w	(a2),(a1)
	bra.s	\rokay

\rstrptr:
	move.l	(a1),a1
\rstring:
	move.w	rwc_offset2(a3),d0
	CALL_	ParseName
	tst.w	d0
	beq.s	\rokay
	bra.s	\rerr

\buffer:	ds.b	256,0
\linenum:	dc.l	0
\text:		dc.l	0
\block:		dc.l	0
\textlen:	dc.l	0

	ENDIF



;------------------------------------------------------------------------------
*
* WriteConfigFile	Write a configuration file.
*
* INPUT:	a0:	File name.
*		a1:	Configuration structure.
*
* RESULT:	d0:	-1 if write successful, 0 if error.
*
;------------------------------------------------------------------------------
	IFD	xxx_WriteConfigFile
WriteConfigFile:
	movem.l	d1-a6,-(sp)
	lea	rwc_base(pc),a4
	moveq	#-1,d6
	move.l	a1,a5

	move.l	a0,d1
	move.l	#1006,d2
	move.l	DosBase(pc),a6
	jsr	-30(a6)			;Open()
	tst.l	d0
	beq	\done2
	lea	cio_conout(pc),a0
	move.l	(a0),d7
	move.l	d0,(a0)

\loop:	moveq	#0,d5
	move.b	(a5),d5
	move.w	rwc_writecall(a5),d0
	beq.s	\nwc
	jsr	(a4,d0)
\nwc:	add.w	d5,d5
	lea	\wjumps(pc),a0
	move.w	(a0,d5),d5
	move.w	rwc_offset1(a5),d0
	lea	(a4,d0),a0
	move.w	rwc_offset2(a5),d0
	lea	(a4,d0),a1
	jsr	(a4,d5)
	tst.b	(a5)
	beq.s	\end
	lea	rwc_SIZEOF(a5),a5
	tst.w	d6
	bne.s	\loop

\end:	lea	cio_conout(pc),a0
	move.l	(a0),d1
	move.l	d7,(a0)
	move.l	DosBase(pc),a6
	jsr	-36(a6)			;Close

\done:	move.l	d6,d0
\done2:	movem.l	(sp)+,d1-a6
	rts

\wjumps:
	dc.w	\wnop%
	dc.w	\wkey%
	dc.w	\wdolist%
	dc.w	\wdoloop%
	dc.w	\wflagon%
	dc.w	\wflagoff%
	dc.w	\wendloop%
	dc.w	\wifset%
	dc.w	\wdecbyte%
	dc.w	\wdecword%
	dc.w	\wdeclong%
	dc.w	\whexbyte%
	dc.w	\whexword%
	dc.w	\whexlong%
	dc.w	\wkeywords%
	dc.w	\wstrptr%
	dc.w	\wstring%
	dc.w	\wbits%
	dc.w	\wbits%
	dc.w	\wbits%
	dc.w	\wbits%
	dc.w	\wbits%
	dc.w	\wbits%
	dc.w	\wbits%
	dc.w	\wbits%
	dc.w	\wbitc%
	dc.w	\wbitc%
	dc.w	\wbitc%
	dc.w	\wbitc%
	dc.w	\wbitc%
	dc.w	\wbitc%
	dc.w	\wbitc%
	dc.w	\wbitc%


;--------------------------------------

\wbits:	move.b	(a5),d0
	sub.b	#rwc_BITS0,d0
	btst	d0,(a1)
	bne	\wkey
	rts
	
\wbitc:	move.b	(a5),d0
	sub.b	#rwc_BITC0,d0
	btst	d0,(a1)
	beq	\wkey
	rts

\wifset:
	move.l	a5,\lpos(a4)
	tst.b	(a0)
	beq	\wsend
	rts
	
\wstring:
	move.l	a0,\buffer(a4)
	bra.s	\wanystr
\wstrptr:
	move.l	(a0),\buffer(a4)
\wanystr:	lea	\wstrstring(pc),a0
	bra	\wnum

\wkey:	CALL_	ConPrint

\all:	move.b	cio_error(pc),d0
	beq.s	\nowe
	moveq	#0,d6
	rts
\nowe:	cmp.b	#rwc_IF,rwc_SIZEOF(a5)		;new keyword or end?
	lea	\cr(pc),a0
	bls.s	\write
	cmp.b	#rwc_BITS0,rwc_SIZEOF(a5)
	bhs.s	\write
	lea	\space(pc),a0
\write:	CALL_	ConPrint
	move.b	cio_error(pc),d0
	beq.s	\nowe2
	moveq	#0,d6
\nowe2:	rts

\wflagon:
	tst.b	(a1)
	bne.s	\wkey
\wnop:	rts

\wflagoff:
	tst.b	(a1)
	beq.s	\wkey
	rts

\wdecbyte:
	move.b	(a0),\buffer+1(a4)
	clr.b	\buffer(a4)
	lea	\dwstring(pc),a0
	bra.s	\wnum

\wdecword:
	move.w	(a0),\buffer(a4)
	lea	\dwstring(pc),a0
	bra.s	\wnum

\wdeclong:
	move.l	(a0),\buffer(a4)
	lea	\dlstring(pc),a0
	bra.s	\wnum

\whexbyte:
	move.b	(a0),\buffer+1(a4)
	clr.b	\buffer(a4)
	lea	\hbstring(pc),a0
	bra.s	\wnum

\whexword:
	move.w	(a0),\buffer(a4)
	lea	\hwstring(pc),a0
	bra.s	\wnum

\whexlong:
	move.l	(a0),\buffer(a4)
	lea	\hlstring(pc),a0

\wnum:	lea	\buffer(pc),a1
	CALL_	ConPrintRaw
	bra	\all

\wdoloop:
	move.w	(a1),\lcounter(a4)
	beq.s	\wsend
	move.l	a5,\lpos(a4)
	bra	\wkey

\wdolist:
	move.l	a5,\lpos(a4)
	move.l	a1,\llist(a4)

\wlist:	move.l	\lpos(a4),a5
	move.l	\llist(pc),a1
	move.l	(a1),a1
	move.l	a1,\llist(a4)
	tst.l	(a1)
	bne	\wkey
\wsend:	cmp.b	#rwc_ENDLOOP,(a5)
	beq.s	\wgend
	lea	rwc_SIZEOF(a5),a5
	bra.s	\wsend
\wgend:	rts
	
\wendloop:
	move.l	\lpos(pc),a1
	move.w	rwc_offset1(a1),d0
	lea	(a4,d0),a0
	cmp.b	#rwc_IF,(a1)
	beq.s	\wgend
	cmp.b	#rwc_DOLOOP,(a1)
	bne.s	\wlist
	subq.w	#1,\lcounter(a4)
	beq.s	\wgend
	move.l	a1,a5
	bra	\wkey
	
\wkeywords:
	move.w	(a0),d0
\wkloop:move.w	2(a1),d1
	beq.s	\wnokey
	lea	(a4,d1),a0
	cmp.w	(a1),d0
	beq	\wkey
	addq.w	#4,a1
	bra.s	\wkloop
\wnokey:	rts


\lpos:		dc.l	0
\lcounter:	dc.w	0
\llist:		dc.l	0
\buffer:	dc.l	0

\cr:		dc.b	$a,0
\space:		dc.b	$20,0
\dwstring:	dc.b	"%d",0	
\dlstring:	dc.b	"%ld",0	
\hbstring:	dc.b	"$%02x",0	
\hwstring:	dc.b	"$%04x",0	
\hlstring:	dc.b	"$%08lx",0	
\wstrstring:	dc.b	'"%s"',0
	even

	ENDC



;--------------------------------------------------------------------

;------------------
	include	conio.r
	include	dosfile.r
	include	parse.r


;------------------

;--------------------------------------------------------------------

	base	rwc_oldbase

;------------------

	ENDIF

	end

