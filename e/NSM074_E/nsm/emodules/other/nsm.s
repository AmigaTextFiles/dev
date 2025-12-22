; octacontrol.s
; adapted to Amiga E by Claude Heiland-Allen 1999.05.16

;----------------------------------------------------------------------------
; Changes:
; -  names changed: _#?        -> _nsm_#?__iii etc, except
;                   _isranged  -> _nsm_ranged__i
;                   _isplaying -> _nsm_playing__i
;                   _istrackon -> _nsm_trackon__ii
; -  stack args (same order left to right as C includes)
; -  strange string things not converted (E has built in string functions)
; -  setmed / getmed not converted, implemented in E instead (nasty stack)
; -  some bsr changed to CALL
; -  some return codes fixed
;
; NB: these changes pushed some bsr.s out of range, so all .s removed
;     (PhxAss optimiser puts them back)
;----------------------------------------------------------------------------

;	Octacontrol.a - Assembler functions that
;	lets you control the variable-space of
;	octamed.
;
;	Version: 0.74
;	Made by Kjetil S. Matheussen 19.2.98

;----------------------------------------------------------------------------
; Amiga E support
; Functions named #?__iii, number of "i" = number of LONG arguments, pushed
; onto stack from left to right (so last arg is 4(sp) at start of code).
; E requires d2-d7/a4/a5 to be preserved.  Return is in D0.
;
;	ZAVE	MACRO	; (reglist)                                save regs
;	UNZAVE	MACRO	; (reglist)                                restore
;	PUSH	MACRO	; (reg)                                    push long
;	POPA	MACRO	; (saveds, argcount, arg#, dest)           pop arg
;	POPN	MACRO	; (count)                                  fix stack
;	CALL0	MACRO	; (name)                                   call func
;	CALL1	MACRO	; (name, arg1)                                ''
;	CALL2	MACRO	; (name, arg1, arg2)                          ''
;	CALL3	MACRO	; (name, arg1, arg2, arg3)                    ''
;	CALL4	MACRO	; (name, arg1, arg2, arg3, arg4)              ''
;	CALL5	MACRO	; (name, arg1, arg2, arg3, arg4, arg5)        ''
;	CALL6	MACRO	; (name, arg1, arg2, arg3, arg4, arg5, arg6)  ''

ZAVE	MACRO	; (reglist)
		movem.l	\1,-(sp)
		ENDM

UNZAVE	MACRO	; (reglist)
		movem.l	(sp)+,\1
		ENDM

PUSH	MACRO	; (reg)
		move.l	\1,-(sp)
		ENDM

POPA	MACRO	; (saved, count, arg, dest)
		move.l	4*(1+\1+\2-\3)(sp),\4
		ENDM

POPN	MACRO	; (count)
		add.l	#(4*\1),sp
		ENDM

CALL0	MACRO	; (name)
		bsr		\1
		ENDM

CALL1	MACRO	; (name, arg1)
		PUSH	\2
		bsr		\1
		POPN	1
		ENDM

CALL2	MACRO	; (name, arg1, arg2)
		PUSH	\2
		PUSH	\3
		bsr		\1
		POPN	2
		ENDM

CALL3	MACRO	; (name, arg1, arg2, arg3)
		PUSH	\2
		PUSH	\3
		PUSH	\4
		bsr		\1
		POPN	3
		ENDM

CALL4	MACRO	; (name, arg1, arg2, arg3, arg4)
		PUSH	\2
		PUSH	\3
		PUSH	\4
		PUSH	\5
		bsr		\1
		POPN	4
		ENDM

CALL5	MACRO	; (name, arg1, arg2, arg3, arg4, arg5)
		PUSH	\2
		PUSH	\3
		PUSH	\4
		PUSH	\5
		PUSH	\6
		bsr		\1
		POPN	5
		ENDM

CALL6	MACRO	; (name, arg1, arg2, arg3, arg4, arg5, arg6)
		PUSH	\2
		PUSH	\3
		PUSH	\4
		PUSH	\5
		PUSH	\6
		PUSH	\7
		bsr		\1
		POPN	6
		ENDM

UBYTE	MACRO	; (reg)
		and.l	#$000000FF,\1
		ENDM

UWORD	MACRO	; (reg)
		and.l	#$0000FFFF,\1
		ENDM

SBYTE	MACRO	; (reg)
		ext.w	\1
		ext.l	\1
		ENDM

SWORD	MACRO	; (reg)
		ext.l	\1
		ENDM

;----------------------------------------------------------------------------


	xdef	_nsm_getblockbase__ii

	xdef	_nsm_getblockname__i
	xdef	_nsm_getnumlines__i
	xdef	_nsm_getnumtracks__i
	xdef	_nsm_getnumpages__i
	xdef	_nsm_getlinehighlight__ii
	xdef	_nsm_setlinehighlight__ii
	xdef	_nsm_unsetlinehighlight__ii

;	xdef	_nsm_getmed__iiiii
;	xdef	_nsm_setmed__iiiiii
	xdef	_nsm_getcmdlvl__iiii
	xdef	_nsm_setcmdlvl__iiiii
	xdef	_nsm_getcmdnum__iiii
	xdef	_nsm_setcmdnum__iiiii
	xdef	_nsm_getinum__iii
	xdef	_nsm_setinum__iiii
	xdef	_nsm_setnote__iiii
	xdef	_nsm_getnote__iii

	xdef	_nsm_ranged__i
	xdef	_nsm_getrangeendline__i
	xdef	_nsm_getrangeendtrack__i
	xdef	_nsm_getrangestartline__i
	xdef	_nsm_getrangestarttrack__i

	xdef	_nsm_getcurrtrack__i
	xdef	_nsm_getcurrline__i
	xdef	_nsm_getcurrblock__i
	xdef	_nsm_getcurrpage__i
	xdef	_nsm_getsubpos__i
	xdef	_nsm_getnumblocks__i
	xdef	_nsm_trackon__ii
	xdef	_nsm_playing__i
	xdef	_nsm_getcurroctave__i

	xdef	_nsm_getsamplebase__ii
	xdef	_nsm_getcurrsamplebase__i
	xdef	_nsm_getsamplelength__i
	xdef	_nsm_getsample__ii
	xdef	_nsm_setsample__iii

	xdef	_nsm_getfinetune__ii
	xdef	_nsm_gethold__ii
	xdef	_nsm_getdecay__ii
	xdef	_nsm_getdefaultpitch__ii
	xdef	_nsm_getextendedpreset__ii
	xdef	_nsm_getmidichannel__ii
	xdef	_nsm_getmidipreset__ii
	xdef	_nsm_getcurrinstrument__i
	xdef	_nsm_getsuppressnoteonoff__ii
	xdef	_nsm_getinname__ii
	xdef	_nsm_gettranspose__ii
	xdef	_nsm_getvolume__ii
	xdef	_nsm_getloopstart__ii
	xdef	_nsm_getlooplength__ii
	xdef	_nsm_getloopstate__ii
	xdef	_nsm_getlooppingpong__ii
	xdef	_nsm_getdisable__ii

	xdef	_nsm_freeresult
	xdef	_nsm_sendrexx__i

	xdef	_nsm_getoctabase

;	xdef	_nsm_wordintostring_noconst
;	xdef	_nsm_stringtoint

	section	text,code

_nsm_getblockbase__ii:
	move.l	d6,-(sp)
		POPA	1,2,1,a0
		POPA	1,2,2,d6
;	move.l	octabase(PC),a0
	sub.l		#$ae86,a0
	move.l	(a0),a0
	rol.l		#2,d6
	add.l		d6,a0
	move.l	(a0),d0
	add.l		#$3e,d0
	move.l	(sp)+,d6
	rts


_nsm_getblockname__i:
		POPA	0,1,1,a0
	move.l		-$3a(a0),d0
	rts

_nsm_getnumlines__i:
		POPA	0,1,1,a0
	move.w		-$3c(a0),d0
	addq.w		#1,d0											;This is quite stupid, but its the
																	;way the OCTAMED_REXX port does it.
		UWORD	d0
	rts

_nsm_getnumtracks__i:
		POPA	0,1,1,a0
	move.w		-$3e(a0),d0
		UWORD	d0
	rts

_nsm_getnumpages__i:
		POPA	0,1,1,a0
	move.w		-$4(a0),d0
		UWORD	d0
	rts

_nsm_getlinehighlight__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	moveq			#0,d0

	cmp.w			-$3c(a0),d1									;Checks if at legal line
	bgt			failed_linehighlight
	btst			#15,d1										;Check if line is negative
	bne			failed_linehighlight

	move.l		-$10(a0),a0
	cmp.l			#0,a0											;This address does only exist if there are any
	beq			failed_linehighlight						;highlightened lines
	add.l			d1,a0
	move.b		(a0),d0

failed_linehighlight:
	rts

_nsm_setlinehighlight__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d0
	cmp.w			-$3c(a0),d0									;Checks if at legal line
	bgt			failed_linehighlight
	btst			#15,d0										;Check if line is negative
	bne			failed_linehighlight

	move.l		-$10(a0),a0
	cmp.l			#0,a0											;This address does only exist if there are any
	beq			setfirsthighlight							;highlightened lines. If not, the
																	;line has to be highligthened via the
																	;OCTAMED_REXX arexx-port.
	add.l			d0,a0
	move.b		#1,(a0)										;Highlight the line directly. Use the
																	;"updateeditor"-command to view the result.
	rts


setfirsthighlight:											;Highlight the line via the arexx-port.
	move.l		d6,-(SP)
	lea			manualset(PC),a0
	moveq			#23,d1
	moveq			#0,d6
	move.l		d0,d6
	bsr			_wordintostring_noconst
	lea			manualset(PC),a0
	move.l		a0,d6
;	bsr			_sendrexx
	CALL1	_nsm_sendrexx__i,d6
	move.l		(sp)+,d6
	rts

manualset:
	dc.b			"ED_HIGHLIGHTLINE LINE  00000 ON",0



_nsm_unsetlinehighlight__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d0
	moveq			#0,d1
	btst			#15,d0										;Check if line is negative
	bne			failed_linehighlight
	move.w		-$3c(a0),d1									;Number of lines.
	cmp.w			d1,d0											;Checks if at legal line
	bgt			failed_linehighlight

	move.l		-$10(a0),a0
	cmp.l			#0,a0
	beq			failed_linehighlight						;All lines are unhighlightened allready.

	move.l		a0,a1

findfirsthighlight:
	cmp.b			#1,(a1)
	beq			findsecondhighlight
	addq.l		#1,a1
	dbra			d1,findfirsthighlight
	bra			unsetlasthighlight						;This should be impossible, but you never know.

findsecondhighlight:
	subq			#1,d1

findsecondhighlightloop:
	addq.l		#1,a1
	cmp.b			#1,(a1)
	beq			unsetdirectly
	dbra			d1,findsecondhighlightloop

	bra			unsetlasthighlight


unsetdirectly:
	add.l			d0,a0
	move.b		#0,(a0)										;Unhighlight the line directly. Use the
																	;"updateeditor"-command to view the result.
	rts


unsetlasthighlight:											;Unhighlight the line via the arexx-port.
	move.l		d6,-(SP)
	lea			manualunset(PC),a0
	moveq			#23,d1
	moveq			#0,d6
	move.l		d0,d6
	bsr			_wordintostring_noconst
	lea			manualunset(PC),a0
	move.l		a0,d6
;	bsr			_sendrexx
	CALL1	_nsm_sendrexx__i,d6
	move.l		(sp)+,d6
	rts

manualunset:
	dc.b			"ED_HIGHLIGHTLINE LINE  00000 OFF",0

;even
	dc.b			0

;_nsm_getmed__iiiii:
;	cmp.b			#0,d4
;	beq			_getnote
;
;	cmp.b			#1,d4
;	beq			_getinum
;
;	cmp.b			#2,d4
;	beq			_getcmdnum
;
;	cmp.b			#3,d4
;	beq			_getcmdlvl
;
;	rts											;Failed
;
;_nsm_setmed__iiiiii:
;	cmp.b			#0,d4
;	beq			_setnote
;
;	cmp.b			#1,d4
;	beq			_setinum
;
;	cmp.b			#2,d4
;	beq			_setcmdnum
;
;	cmp.b			#3,d4
;	beq			_setcmdlvl
;
;	moveq			#0,d0							;Failed
;	rts

_nsm_setcmdlvl__iiiii:
		ZAVE	d2/d3
		POPA	2,5,1,a0
		POPA	2,5,2,d1
		POPA	2,5,3,d2
		POPA	2,5,4,d3
		POPA	2,5,5,d0
	tst.l			d3								;If page is zero
	beq			setcmdlvl_exit2

	cmp.w			#1,d3
	bne			setcmdlvl_lpage			;If it's not at page 1.

	movem.l		d2/d3,-(sp)
	bsr			getnoteinumpos
	tst.l			d3
	beq			setcmdlvl_exit
	move.b		d0,3(a0)
setcmdlvl_exit:
	movem.l		(sp)+,d2/d3
setcmdlvl_exit2:
		UNZAVE	d2/d3
	rts

setcmdlvl_lpage:
	movem.l		d2/d3-d5,-(sp)
	bsr			getcmd_lpage
	tst.l			d4
	beq			setcmdlvl_lpage_exit
	move.b		d0,1(a0)
setcmdlvl_lpage_exit:
	movem.l		(sp)+,d2/d3-d5
	rts



_nsm_getcmdlvl__iiii:
		ZAVE	d2/d3
		POPA	2,4,1,a0
		POPA	2,4,2,d1
		POPA	2,4,3,d2
		POPA	2,4,4,d3
	moveq			#0,d0
	tst.l			d3								;If page is zero
	beq			getcmdlvl_exit2

	cmp.w			#1,d3
	bne			getcmdlvl_lpage			;If it's not at page 1.

	movem.l		d2/d3,-(sp)
	bsr			getnoteinumpos
	tst.l			d3
	beq			getcmdlvl_exit
	move.b		3(a0),d0
getcmdlvl_exit:
	movem.l		(sp)+,d2/d3
getcmdlvl_exit2:
		UNZAVE	d2/d3
		UBYTE	d0
	rts

getcmdlvl_lpage:
	movem.l		d2/d3-d5,-(sp)
	bsr			getcmd_lpage
	tst.l			d4
	beq			getcmdlvl_lpage_exit
	move.b		1(a0),d0
getcmdlvl_lpage_exit:
	movem.l		(sp)+,d2/d3-d5
		UNZAVE	d2/d3
		UBYTE	d0
	rts




_nsm_setcmdnum__iiiii:
		ZAVE	d2/d3
		POPA	2,5,1,a0
		POPA	2,5,2,d1
		POPA	2,5,3,d2
		POPA	2,5,4,d3
		POPA	2,5,5,d0
	tst.l			d3								;If page is zero
	beq			setcmdnum_exit2

	cmp.w			#1,d3
	bne			setcmdnum_lpage			;If it's not at page 1.

	movem.l		d2/d3,-(sp)
	bsr			getnoteinumpos
	tst.l			d3
	beq			setcmdnum_exit
	move.b		d0,2(a0)
setcmdnum_exit:
	movem.l		(sp)+,d2/d3
setcmdnum_exit2:
		UNZAVE	d2/d3
	rts

setcmdnum_lpage:
	movem.l		d2/d3-d5,-(sp)
	bsr			getcmd_lpage
	tst.l			d4
	beq			setcmdnum_lpage_exit
	move.b		d0,(a0)
setcmdnum_lpage_exit:
	movem.l		(sp)+,d2/d3-d5
		UNZAVE	d2/d3
	rts




_nsm_getcmdnum__iiii:
		ZAVE	d2/d3
		POPA	2,4,1,a0
		POPA	2,4,2,d1
		POPA	2,4,3,d2
		POPA	2,4,4,d3
	moveq			#0,d0
	tst.l			d3								;If page is zero (illegal)
	beq			getcmdnum_exit2

	cmp.w			#1,d3
	bne			getcmdnum_lpage			;If it's not at page 1.

	movem.l		d2/d3,-(sp)
	bsr			getnoteinumpos
	tst.l			d3
	beq			getcmdnum_exit
	move.b		2(a0),d0
getcmdnum_exit:
	movem.l		(sp)+,d2/d3
getcmdnum_exit2:
		UNZAVE	d2/d3
		UBYTE	d0
	rts

getcmdnum_lpage:
	movem.l		d2/d3-d5,-(sp)
	bsr			getcmd_lpage
	tst.l			d4
	beq			getcmdnum_lpage_exit
	move.b		(a0),d0
getcmdnum_lpage_exit:
	movem.l		(sp)+,d2/d3-d5
		UNZAVE	d2/d3
		UBYTE	d0
	rts


getcmd_lpage:
	move.w		-$3e(a0),d4					;Number of tracks in block

	cmp.w			d4,d1							;Checks if at legal track
	bge			getcmd_lpage_exit
	cmp.w			-$3c(a0),d2					;Checks if at legal line
	bgt			getcmd_lpage_exit
	btst			#15,d1						;Check if track is negative
	bne			getcmd_lpage_exit
	btst			#15,d2						;Check if line is negative
	bne			getcmd_lpage_exit

	btst			#15,d3						;Check if page is negative
	bne			getcmd_lpage_exit

	subq.w		#2,d3							;Have to do this
	move.w		-$4(a0),d5					;Number of pages in the block
	cmp.w			d5,d3							;Checks if page is legal
	bge			getcmd_lpage_exit
	btst			#15,d3						;Check if page is negative
	bne			getcmd_lpage_exit

	move.l		-8(a0),a0
	lsl.l			#2,d3
	add.l			d3,a0
	move.l		(a0),a0

	mulu			d4,d2
	add.l			d2,d1
	lsl.l			#1,d1							;Two bytes between each cmdnum or cmdlvl
	add.l			d1,a0

	rts

getcmd_lpage_exit:
	moveq			#0,d4
	rts




getnoteinumpos:

	move.w		-$3e(a0),d3					;Number of tracks in block

	cmp.w			d3,d1							;Checks if at legal track
	bge			getnoteinumpos_exit
	cmp.w			-$3c(a0),d2					;Checks if at legal line
	bgt			getnoteinumpos_exit
	btst			#15,d1						;Check if track is negative
	bne			getnoteinumpos_exit
	btst			#15,d2						;Check if line is negative
	bne			getnoteinumpos_exit

	mulu			d3,d2

	add.l			d2,d1
	lsl.l			#2,d1							;4 bytes between each note or inum
	add.l			d1,a0

	rts

getnoteinumpos_exit:
	moveq			#0,d3
	rts




_nsm_setinum__iiii:
	movem.l		d2/d3,-(sp)
		POPA	2,4,1,a0
		POPA	2,4,2,d1
		POPA	2,4,3,d2
		POPA	2,4,4,d0
	bsr			getnoteinumpos
	tst.l			d3
	beq			setinum_exit
	move.b		d0,1(a0)
setinum_exit:
	movem.l		(sp)+,d2/d3
	rts


_nsm_getinum__iii:
	movem.l		d2/d3,-(sp)
		POPA	2,3,1,a0
		POPA	2,3,2,d1
		POPA	2,3,3,d2
	moveq			#0,d0
	bsr			getnoteinumpos
	tst.l			d3
	beq			getinum_exit
	move.b		1(a0),d0
getinum_exit:
	movem.l		(sp)+,d2/d3
		UBYTE	d0
	rts


_nsm_setnote__iiii:
	movem.l		d2/d3,-(sp)
		POPA	2,4,1,a0
		POPA	2,4,2,d1
		POPA	2,4,3,d2
		POPA	2,4,4,d0
	bsr			getnoteinumpos
	tst.l			d3
	beq			setnote_exit
	move.b		d0,(a0)
setnote_exit:
	movem.l		(sp)+,d2/d3
	rts


_nsm_getnote__iii:
	movem.l		d2/d3,-(sp)
		POPA	2,3,1,a0
		POPA	2,3,2,d1
		POPA	2,3,3,d2
	moveq			#0,d0
	bsr			getnoteinumpos
	tst.l			d3
	beq			getnote_exit
	move.b		(a0),d0
getnote_exit:
	movem.l		(sp)+,d2/d3
		UBYTE	d0
	rts

;a0=octabase,d1=sample
_nsm_getsamplebase__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$af86,a0
	rol.w			#2,d1
	add.l			d1,a0
	move.l		(a0),d0
	tst.l			d0
	beq			getsamplebase_failed
	addq.l		#6,d0
getsamplebase_failed:
	rts

_nsm_getcurrsamplebase__i:
		POPA	0,1,1,a0
	add.l			#$160e,a0
	move.l		(a0),a0
	move.l		(a0),d0
	beq			getsamplebase_failed
	addq.l		#6,d0
	rts

_nsm_getsamplelength__i:
		POPA	0,1,1,a0
	move.l		-6(a0),d0
	rts

_nsm_getsample__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	lsl.l			#1,d1
	add.l			d1,a0
	moveq			#0,d0
	move.w		(a0),d0
		SWORD	d0
	rts

;a0=samplebase,d0=value,d6=offset
_nsm_setsample__iii:
		ZAVE	d6
		POPA	1,3,1,a0
		POPA	1,3,2,d6
		POPA	1,3,3,d0
	cmp.l			#0,a0
	beq			setsample_failed
	lsl.l			#1,d6
	move.l		-6(a0),d1
	cmp.l			d1,d6
	bge			setsample_failed
	add.l			d6,a0
	move.w		d0,(a0)
	rts
setsample_failed:
	moveq			#0,d0
		UNZAVE	d6
	rts

;a0=octabase,d1=sample
_nsm_getfinetune__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$af86,a0
	move.l		(a0),a0
	subq.w		#1,d1
	lsl.w			#6,d1
	add.l			d1,a0
	moveq			#0,d0
	move.b		51(a0),d0
		SBYTE	d0
	rts

_nsm_gethold__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$af86,a0
	move.l		(a0),a0
	subq.w		#1,d1
	lsl.w			#6,d1
	add.l			d1,a0
	moveq			#0,d0
	move.b		48(a0),d0
		UBYTE	d0
	rts

_nsm_getdecay__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$af86,a0
	move.l		(a0),a0
	subq.w		#1,d1
	lsl.w			#6,d1
	add.l			d1,a0
	moveq			#0,d0
	move.b		49(a0),d0
		UBYTE	d0
	rts

_nsm_getdefaultpitch__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$af86,a0
	move.l		(a0),a0
	subq.w		#1,d1
	lsl.w			#6,d1
	add.l			d1,a0
	moveq			#0,d0
	move.b		54(a0),d0
		UBYTE	d0
	rts

_nsm_getextendedpreset__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$af86,a0
	move.l		(a0),a0
	subq.w		#1,d1
	lsl.w			#6,d1
	add.l			d1,a0
	move.b		44(a0),d1
	btst			#6,d1
	bne			set
	moveq			#0,d0
		UBYTE	d0
	rts

_nsm_getmidichannel__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$af86,a0
	move.l		(a0),a0
	subq.w		#1,d1
	lsl.w			#6,d1
	add.l			d1,a0
	moveq			#0,d0
	move.b		44(a0),d0
	bclr.l		#6,d0
	bclr.l		#7,d0
		UBYTE	d0
	rts

_nsm_getmidipreset__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$af86,a0
	move.l		(a0),a0
	subq.w		#1,d1
	lsl.w			#6,d1
	add.l			d1,a0
	moveq			#0,d0
	move.w		52(a0),d0
		UWORD	d0
	rts

_nsm_getinname__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$af86,a0
	move.l		(a0),a0
	subq.w		#1,d1
	lsl.w			#6,d1
	add.l			d1,a0
	move.l		a0,d0
	rts

_nsm_getcurrinstrument__i:
		POPA	0,1,1,a0
	add.l			#$160e,a0
	move.l		(a0),d0
	sub.l			#$c594,a0
	move.l		a0,d1
	sub.l			d1,d0
	lsr.l			#2,d0
	rts

_nsm_getsuppressnoteonoff__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$af86,a0
	move.l		(a0),a0
	subq.w		#1,d1
	lsl.w			#6,d1
	add.l			d1,a0
	move.b		44(a0),d1
	btst			#7,d1
	bne			set
	moveq			#0,d0
		UBYTE	d0
	rts

_nsm_gettranspose__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$af86,a0
	move.l		(a0),a0
	subq.w		#1,d1
	lsl.w			#6,d1
	add.l			d1,a0
	moveq			#0,d0
	move.b		50(a0),d0
		SBYTE	d0
	rts

_nsm_getvolume__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$af86,a0
	move.l		(a0),a0
	subq.w		#1,d1
	lsl.w			#6,d1
	add.l			d1,a0
	moveq			#0,d0
	move.b		46(a0),d0
		UBYTE	d0
	rts

_nsm_getloopstart__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$af86,a0
	move.l		(a0),a0
	subq.w		#1,d1
	lsl.w			#6,d1
	add.l			d1,a0
	moveq			#0,d0
	move.l		40(a0),d0
	rts

_nsm_getlooplength__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$af86,a0
	move.l		(a0),a0
	subq.w		#1,d1
	lsl.w			#6,d1
	add.l			d1,a0
	moveq			#0,d0
	move.l		56(a0),d0
	rts

_nsm_getloopstate__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$af86,a0
	move.l		(a0),a0
	subq.w		#1,d1
	lsl.w			#6,d1
	add.l			d1,a0
	move.b		45(a0),d1
	btst			#0,d1
	bne			set
	moveq			#0,d0
	rts
set:                        ; exit point for many...
	moveq			#1,d0
	rts

_nsm_getlooppingpong__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$af86,a0
	move.l		(a0),a0
	subq.w		#1,d1
	lsl.w			#6,d1
	add.l			d1,a0
	move.b		45(a0),d1
	btst			#3,d1
	bne			set
	moveq			#0,d0
	rts

_nsm_getdisable__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$af86,a0
	move.l		(a0),a0
	subq.w		#1,d1
	lsl.w			#6,d1
	add.l			d1,a0
	move.b		45(a0),d1
	btst			#2,d1
	bne			set
	moveq			#0,d0
	rts

_nsm_freeresult												;Releases the memory occopied when making the result-string.
	move.l	result2(pc),a1
	cmp		#0,a1
	beq		notastring
	subq.l	#8,a1
	move.l	(a1),d0
	move.l	a6,-(sp)
	move.l	4.w,a6
	jsr		-210(a6)
	lea		result2(pc),a1
	move.l	#0,8(a1)									;take away address from arexx-message.
															;(probably not necesarry)
	move.l	(sp)+,a6
notastring:
	rts



;	Used registers for _sendrexx:
;	A6 - exec.library
;	A5 - My message-port
;	A3 - Arexx-message
;	A1 - Octa-port name
;	D4 - Return-message

_nsm_sendrexx__i:
;	bsr			_freeresult							;Frees the last resultstring, if any
	CALL0	_nsm_freeresult

		ZAVE	d6

	movem.l		d4/a3/a5-a6,-(sp)

		POPA	5,1,1,d6

	moveq			#0,d4									;If something goes wrong.

	move.l		4.w,a6

	jsr			-$29a(a6)							;Creates a message-port
	tst.l			d0
	beq			exit
	move.l		d0,a5

	lea			arexxMsg_end(pc),a3				;The end of the message
	moveq			#31,d0								;Reset arexxMsg to nulls. Don't know if this is necesarry, but...
loop:
	clr.l			-(a3)									;A3 will eventullly be 'ArexxMsg'
	dbra			d0,loop

	move.l		a5,$e(a3)							;Set replyport
	move.w		#$80,$12(a3)						;Rexx-msg length
;	move.l		#0,$6c(a3)							;Extension. (f.ex .rexx, .omed, etc.)
;	move.l		#0,$70(a3)							;Host
	move.l		#$01020000,$1c(a3)				;Set the action-type. (message | return)
	move.l		d6,$28(a3)							;Put the argument into the message

	jsr			-120(a6)								;Disable interrupts

	lea			octaportname(pc),a1				;Finds the octarexx-port
	jsr			-390(a6)
	tst.l			d0
	beq			could_not_find_port

	move.l		d0,a0									;Port to send to
	move.l		a3,a1									;Message to send
	jsr			-366(a6)								;Sends the message

	jsr			-126(a6)								;Enable interrupts

	move.l		a5,a0									;Waits for reply
	jsr			-$180(a6)

	move.l		36(a3),d4							;Gets the result2


close_port:
	move.l		a5,a0
	jsr			-$2a0(a6)


exit:
	move.l		d4,d0
	movem.l		(sp)+,d4/a3/a5-a6

		UNZAVE	d6

	rts													;Finished!

could_not_find_port:
	jsr			-126(a6)								;Enable interrupts
	bra			close_port

octaportname:
	dc.b			"OCTAMED_REXX",0

	dc.b			0										;Simulated seka-function: 'Even'



;	Used registers in getoctabase:
;	A6 - exec.library
;	A5 - My message-port
;	A3 - NSM-message
;	A1 - NSM-port

_nsm_getoctabase:

		ZAVE	d6      ; hmmm, exits via end of sendrexx...

	movem.l		d4/a3/a5-a6,-(sp)

	moveq			#0,d4

	move.l		$4.w,a6

	jsr			-$29a(a6)							;Creates a message-port
	tst.l			d0
	beq			exit
	move.l		d0,a5

	lea			NSMMessage(pc),a3

	move.l		d0,14(a3)							;Set the replyport for the message

	jsr			-120(a6)								;Disable interrupts


	lea			nsmportname(pc),a1				;Finds the NSM-port
	jsr			-390(a6)
	tst			d0
	beq			could_not_find_port


	move.l		d0,a0									;Sends the message
	move.l		a3,a1
	jsr			-366(a6)


	jsr			-126(a6)								;Enable interrupts


	move.l		a5,a0									;Waits for reply
	jsr			-$180(a6)

	move.l		20(a3),d4
	add.l			#$b00e,d4
;	lea			octabase(pc),a1
;	move.l		d4,(a1)

	bra			close_port



;octabase:
;	dc.l			0

nsmportname:
	dc.b			"nsmport",0


_nsm_ranged__i:
		POPA	0,1,1,a0
	moveq			#0,d0
;	move.l		octabase(pc),a0
	move.b		$f76(a0),d0
		UBYTE	d0
	rts

_nsm_getrangeendline__i:
		POPA	0,1,1,a0
;	move.l		octabase(pc),a0
	move.w		$f6c(a0),d0
		UWORD	d0
	rts

_nsm_getrangeendtrack__i:
		POPA	0,1,1,a0
;	move.l		octabase(pc),a0
	move.w		$f66(a0),d0
		UWORD	d0
	rts

_nsm_getrangestartline__i:
		POPA	0,1,1,a0
;	move.l		octabase(pc),a0
	move.w		$f6a(a0),d0
		UWORD	d0
	rts

_nsm_getrangestarttrack__i:
		POPA	0,1,1,a0
;	move.l		octabase(pc),a0
	move.w		$f64(a0),d0
		UWORD	d0
	rts

_nsm_getcurrtrack__i:
		POPA	0,1,1,a0
;	move.l		octabase(pc),a0
	move.w		$bf6(a0),d0
		UWORD	d0
	rts

_nsm_getcurrline__i:
		POPA	0,1,1,a0
;	move.l		octabase(pc),a0
	move.w		-$2d6(a0),d0
		UWORD	d0
	rts

_nsm_getcurrblock__i:
		POPA	0,1,1,a0
;	move.l		octabase(pc),a0
	move.w		-$2dc(a0),d0
		UWORD	d0
	rts

_nsm_getcurrpage__i:
		POPA	0,1,1,a0
	move.w		-$2de(a0),d0
	addq.w		#1,d0
		UWORD	d0
	rts

_nsm_getsubpos__i:
		POPA	0,1,1,a0
;	move.l		octabase(pc),a0
	move.w		$bf8(a0),d0
		UWORD	d0
	rts

_nsm_getnumblocks__i:
		POPA	0,1,1,a0
;	move.l		octabase(pc),a0
	move.w		-$6996(a0),d0
		UWORD	d0
	rts

;a0=octabase,d1=track
_nsm_trackon__ii:
		POPA	0,2,1,a0
		POPA	0,2,2,d1
	sub.l			#$ae74,a0
	add.l			d1,a0
	moveq			#0,d0
	move.b		(a0),d0
		UBYTE	d0
	rts

;a0=octabase
_nsm_playing__i:
		POPA	0,1,1,a0
	moveq			#0,d0
	move.b		-$94(a0),d0
		UBYTE	d0
	rts

;a0=octabase
_nsm_getcurroctave__i:
		POPA	0,1,1,a0
	sub.l		#$6b7c,a0
	move.l	(a0),a0
	move.w	$10a6(a0),d0
		UWORD	d0
	rts


arexxMsg:													;An ArexxMsg-structure
NSMMessage:													;An NSMMessage-structure.
	;Structure message
	 ;Structure Node
	  dc.l		  0			;struct node *ln_succ
	  dc.l		  0			;struct node *ln_pred
	  dc.b		  5			;UBYTE ln_type=NT_MESSAGE
	  dc.b		  0			;UBYTE priority
	  dc.l		  0			;char *ln_Name
	 dc.l			 0			;struct MsgPort *mn_replyport
	 dc.w			24			;UWORD mn_Length


	dc.l			0			;In the NSMMessage-structure: UWORD *Octa_addr
;End of NSM-message structure. Length: 24 bytes

	dc.l			0
rm_Action:
	dc.l			0
	dc.l			0				;Result1 (error-messages and such)
result2:
	dc.l			0				;Result2 (result-string)
rm_Args:
	dc.l			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.l			0
	dc.l			0
	dc.l			0
	dc.l			0
	dc.l			0
rm_avail:
	dc.l			0
arexxMsg_end:

;End of ArexxMsg, Length: 128 bytes



_wordintostring_noconst:
	move.l	d6,-(sp)
	move.l	a0,a1

	addq.w	#5,d1
	add.l		d1,a0

	btst		#15,d6
	beq		notneg
	move.b	#$2d,-6(a0)								;Its a negative number
	neg.w		d6
notneg:

	moveq		#3,d1										;Accomumlate 4 digits first
prevdigit:
	andi.l	#$0000ffff,d6							;Clears the reminder
	divu		#10,d6
	move.l	d6,d0
	swap		d0											;D0 will now be the reminder of the d6/10 division
	add.b		#$30,d0
	move.b	d0,-(a0)									;Sets the 4 last digits
	dbra		d1,prevdigit

	add.b		#$30,d6
	move.b	d6,-(a0)									;Sets the first digit

	move.l	(sp)+,d6
	move.l	a1,d0
	rts




_stringtoint:								;This is probably not the fastest string-to-int
	tst.l		d6								;converter available, but that doesn't matter much.
	bne		notnullstring
	moveq		#0,d0
	rts
notnullstring:

	move.l	d6,d0
	move.l	d0,a0
	move.l	#0,a1
findfirstdigit:
	move.b	(a0)+,d1
	cmp.b		#$30,d1
	blt		findfirstdigit
	cmp.b		#$39,d1
	bgt		findfirstdigit
	subq.l	#1,a0

	cmp.l		a0,d0
	beq		notneg2
	move.l	a0,a1

notneg2:
	moveq		#0,d1
	moveq		#0,d0
findlastdigit:
	addq		#1,d1
	move.b	(a0)+,d0
	cmp.b		#$30,d0
	blt		foundit
	cmp.b		#$39,d0
	ble		findlastdigit
foundit:

	subq.l	#1,a0

	move.b	-(a0),d0
	sub.b		#$30,d0						;ASCII to number

	cmp.l		#2,d1
	beq		justonedigit

	movem.l	d2/d3/d4/d5,-(sp)
	subq		#3,d1
	moveq		#0,d3

prevdigit2:
	moveq		#0,d2
	move.b	-(a0),d2
	sub.b		#$30,d2						;ASCII to number

	move.l	d3,d4
multiplybyten:
	lsl.l		#1,d2
	move.l	d2,d5
	lsl.l		#2,d2
	add.l		d5,d2
	dbra		d4,multiplybyten

	add.l		d2,d0
	addq		#1,d3

	dbra		d1,prevdigit2

	movem.l	(sp)+,d2/d3/d4/d5
justonedigit:
	cmp.l		#0,a1
	beq		notneg3
	cmp.b		#$2d,-1(a1)
	bne		notneg3
	neg.l		d0
notneg3:
sendrexxRI_failed:
	rts



	END
