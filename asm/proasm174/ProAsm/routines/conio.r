
;---;  conio.r  ;----------------------------------------------------------
*
*	****	CONSOLE WINDOW INPUT/OUTPUT    ****
*
*	Author		Stefan Walter
*	Version		1.02
*	Last Revision	06.05.93
*	Identifier	cio_defined
*	Prefix		cio_	(Console IO)
*				 ¯       ¯¯
*	Functions	ConPrint, ConPrintRaw, (ConRead), SetConHandles
*			(GetCLIHandles), (GetPageDim), (ConPagePrint)
*			(NewCIOPage), (SetCIOConMode), (TestCTRLC)
*
*	Flags		cio_OUTPUTONLY set 1 if ConRead not needed
*			cio_CLI set 1 if GetCLIHandles also needed
*			cio_NORAW set 1 if no RAW output
*			cio_PAGETOO set 1 if page print routines also needed 
*			cio_CONMODE set 1 if CON/RAW switching too
*			cio_CTRLTOO set 1 if CTRL-? test too
*
;------------------------------------------------------------------------------
*
* All functions in here are basically for console output. I/O to files
* is also possible, if a read/write error occurs, the cio_error flag
* is set. This can be checked afterwards.
*
;------------------------------------------------------------------------------

;------------------
	ifnd	cio_defined
cio_defined	=1

	ifd	cio_PAGETOO
cio_CONMODE	set	1
cio_CTRL	set	1
	endif

;------------------
cio_oldbase	equ __base
	base	cio_base
cio_base:

;------------------

;------------------------------------------------------------------------------
*
* ConPrint	Smart print routine. Prints zeroterminated text by
*		sending it line by line, replacing certain special
*		chars by ANSI control sequences. Text is sent to handler
*		that had to be set by SetConHandle.
*
*		Supportet control chars:
*
*		$01		set FG color to 1
*		$02		set FG color to 2
*		$03		set FG color to 3
*		$04		fat text		
*		$05		underline
*		$06		italics
*		$07		normal
*		$0800		set BG color to 0
*		$0801		set BG color to 1
*		$0802		set BG color to 2
*		$0803		set BG color to 3
*		$08f8		set FG color to 0
*		$09		TAB (fill up with spaces for 2.0)
*
* Tabs only work right if ConPrint begins a new line!
*
* INPUT:	a0	Text
*
;------------------------------------------------------------------------------

;------------------
ConPrint:

;------------------
; Start:
;
\start:
	movem.l	d0-a6,-(sp)
	moveq	#0,d7
	tst.b	(a0)		
	beq.s	\done
	move.l	a0,a4
	bsr	\setlinestart

;------------------
; Char loop.
;
\charloop:
	moveq	#0,d0
	move.b	(a4)+,d0
	beq.s	\printanddone
	cmp.b	#$a,d0
	beq.s	\printline
	cmp.b	#$9,d0
	beq.s	\tab
	cmp.b	#8,d0
	bhi.s	\copy
	bne.s	\copya
	add.b	(a4)+,d0

;------------------
; Copy controll sequence
;
\copya:
	move.b	cio_ansimode(pc),d1
	beq.s	\charloop
	lsl.w	#2,d0
	lea	cio_ansitexts(pc),a1
	add.w	d0,a1
	move.b	#$9b,(a3)+
	bra.s	\nextansi

\ansiloop:
	move.b	(a1)+,(a3)+
\nextansi:
	dbra	d6,\noprint
	bsr	\print

\noprint:
	tst.b	(a1)
	bne.s	\ansiloop
	bra.s	\charloop

;------------------
; Tab.
;
\tab:
	move.w	d7,d1
	addq.w	#8,d7
	and.w	#$fff8,d7
	move.w	d7,d0
	sub.w	d1,d0

\loopa:
	move.b	#" ",(a3)+
	dbra	d6,\notab
	bsr	\print

\notab:
	subq.w	#1,d0
	bne.s	\loopa
	bra.s	\charloop
	
;------------------
; Copy a char.
;
\copy:
	addq.w	#1,d7
	move.b	d0,(a3)+
	dbra	d6,\charloop	

\sub:
	bsr	\print
	bra.s	\charloop

;------------------
; Prints.
;
\printline:
	move.b	d0,(a3)+
	bra.s	\sub

\printanddone:
	bsr	\print
	
;------------------
; Done
;
\done:
	movem.l	(sp)+,d0-a6
	rts

;------------------
; Print line terminated by a3.
;
\print:
	moveq	#0,d7
	move.l	cio_conout(pc),d1
	bsr	OpenDosLib
	move.l	a3,d3
	pea	cio_printbuffer(pc)
	move.l	(sp)+,d2
	sub.l	d2,d3
	move.l	d3,-(sp)
	jsr	-48(a6)			;Write()
	cmp.l	(sp)+,d0
	lea	cio_error(pc),a0
	sne	(a0)
	bsr	CloseDosLib

\setlinestart:
	lea	cio_printbuffer(pc),a3
	move.w	#199,d6
	rts

;------------------

;------------------------------------------------------------------------------
*
* ConPrintRaw	Smart print routine. First runs text through RawDoFmt.
*		Then text goes to ConPrint.
*
* INPUT:	a0	Buffer
*		a1	Data
*
;------------------------------------------------------------------------------

;------------------
ConPrintRaw:

;------------------
; Start:
;
\start:
	movem.l	d0-a6,-(sp)
	lea	cio_error(pc),a2
	clr.b	(a2)
	lea	cio_rawbuffer(pc),a3
	lea	\setin(pc),a2
	move.l	4.w,a6
	jsr	-522(a6)		;RawDoFmt()
	movem.l	(sp)+,d0-a6
	rts

;------------------
; Fill-in routine.
;
\setin:
	movem.l	d0/a0/a1,-(sp)
	lea	cio_rawbuffer+200(pc),a1
	move.b	d0,(a3)+
	beq.s	\print
	cmp.l	a3,a1
	bhi.s	\okay

\print:
	clr.b	(a3)
	lea	cio_rawbuffer(pc),a3
	lea	cio_error(pc),a0
	tst.b	(a0)		;error...
	bne.s	\okay
	move.l	a3,a0

	ifd	cio_PAGETOO
	move.b	cio_rawpages(pc),d0
	beq.s	\np
	bsr	ConPagePrint
	bra.s	\okay
	endif

\np:	bsr	ConPrint
	
\okay:	movem.l	(sp)+,a0/a1/d0
	rts

;------------------
	ifnd	cio_OUTPUTONLY

;------------------
	
;------------------------------------------------------------------------------
*
* ConRead	Smart read routine. Will read zeroterminated text to a
*		200 bytes text buffer (zero byte not included in 200 bytes
*		=> 202 bytes buffer allocation neccessary).
*
* RESULT:	a0	Buffer
*		d0	Length (excluding zero byte)
*
;------------------------------------------------------------------------------

;------------------
ConRead:

;------------------
; Start.
;
\start:
	movem.l	d1-d7/a1-a6,-(sp)
	lea	cio_readbuffer(pc),a4

\loop:
	move.l	cio_conin(pc),d1
	move.l	a4,d2		
	moveq	#1,d3
	bsr	OpenDosLib
	jsr	-42(a6)			;Read()
	bsr	CloseDosLib
	lea	cio_error(pc),a1
	tst.l	d0			;error or length 0
	smi	(a1)			;error => set flag
	ble.s	\end
	cmp.b	#$a,(a4)		;CR
	beq.s	\end
	pea	cio_readbuffer+200(pc)
	cmp.l	(sp)+,a4
	bge.s	\loop			;a4=200?
	addq.l	#1,a4
	bra.s	\loop

\end:
	clr.b	(a4)
	lea	cio_readbuffer(pc),a0
	sub.l	a0,a4
	move.l	a4,d0
	tst.l	d0
	movem.l	(sp)+,d1-d7/a1-a6
	rts

;------------------
	endif

;------------------

;------------------------------------------------------------------------------
*
* SetConHandles	Sets both cio_conin and cio_conout.
*
* INPUT:	d0	Input HD
*		d1	Output HD
*
;------------------------------------------------------------------------------

;------------------
SetConHandles:

;------------------
; Set and go.
;
\set:
	pea	(a0)
	lea	cio_conin(pc),a0
	move.l	d0,(a0)+
	move.l	d1,(a0)
	move.l	(sp)+,a0
	rts

;------------------
	ifd	cio_CLI

;------------------

;------------------------------------------------------------------------------
*
* GetCLIHandles	Get CLI window handles.
*
* RESULT	d0	Output handle or 0 if error
*		ccr	On d0
*
;------------------------------------------------------------------------------

;------------------
GetCLIHandles:

;------------------
; Do.
;
\do:
	movem.l	d1-a6,-(sp)
	moveq	#0,d7
	bsr	OpenDosLib
	beq.s	\done
	jsr	-54(a6)
	lea	cio_conin(pc),a3
	move.l	d0,(a3)+
	beq.s	\close
	jsr	-60(a6)
	move.l	d0,(a3)+
	beq.s	\close
	move.l	d0,d7

\close:
	bsr	CloseDosLib

\done:
	move.l	d7,d0
	movem.l	(sp)+,d1-a6
	rts

;------------------
	endif
	ifd	cio_PAGETOO

;------------------

;------------------------------------------------------------------------------
*
* GetPageDim	Get window dimension and remember it. The filehandle must be
*		stored in cio_conin, the file must be interactive! The window
*		Pointer is storet in cio_window.
*		
* RESULT	d0	0 if error, window if okay
*		cio_window etc. get set to right values.
*
;------------------------------------------------------------------------------

;------------------
GetPageDim:

;------------------
; Start:
;
\start:	movem.l	d1-a6,-(sp)
	moveq	#0,d7
	bsr	OpenDosLib
	beq	\end

;------------------
; Allocate infoblock and packet.
;
\alloc:	bsr	AllocPacket
	beq.s	\closedos
	move.l	d0,d6

	move.l	a7,a5
	move.l	a7,d4
	sub.w	#9*4,d4
	and.b	#$fc,d4
	move.l	d4,a7

;------------------
; Get process and test if it goes.
;
\getproc:
	move.l	4.w,a6
	move.l	$114(a6),a4

;------------------
; If it is interactive, send packet.
;
\inter:	bsr	GetDosBase
	move.l	cio_conin(pc),d1
	jsr	-216(a6)		;IsInteractive
	tst.l	d0
	beq.s	\freeinfo
	move.l	d6,a0
	moveq	#25,d0
	move.l	d0,8(a0)		;ACTION_DISK_INFO
	move.l	d4,d0
	lsr.l	#2,d0
	move.l	d0,20(a0)		;BPTR InfoData

	move.l	d6,d1
	move.l	cio_conin(pc),d2
	lsl.l	#2,d2
	move.l	d2,a0
	move.l	8(a0),d2
	mea	$5c(a4),d3
	bsr	SendPacket
	move.l	d3,d0
	bsr	WaitForPacket

	move.l	d4,a0
	move.l	28(a0),d7

	move.l	d7,a0
	move.l	50(a0),a0
	lea	cio_fonty(pc),a1
	move.l	$3a(a0),(a1)

;------------------
; Clean up.
;
\freeinfo:
	move.l	a5,a7
	
\freepacket:
	move.l	d6,d0
	bsr	FreePacket

\closedos:
	bsr	CloseDosLib

\end:	move.l	d7,d0
	lea	cio_window(pc),a1
	move.l	d7,(a1)
	movem.l	(sp)+,d1-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* NewCIOPage	Start a new page. This calculates the values for the current
*		window size.
*
;------------------------------------------------------------------------------

;------------------
NewCIOPage:

;------------------
; Clear counter and calculate values.
;
\start:	movem.l	d0-a6,-(sp)
	lea	cio_base(pc),a4
	move.l	cio_window(a4),a0
	moveq	#0,d0
	add.b	$37(a0),d0		;border top
	add.b	$39(a0),d0		;border bottom
	neg.w	d0
	add.w	10(a0),d0		;=> number of lines in window
	moveq	#0,d1
	add.b	$36(a0),d1		;border right
	add.b	$38(a0),d1		;border left
	neg.w	d1
	add.w	8(a0),d1		;=> number of raws in window

	divu	cio_fonty(pc),d0
1$:	move.w	d0,cio_count(a4)
	bne.s	2$
	moveq	#1,d0
	bra.s	1$

2$:	divu	cio_fontx(pc),d1
3$:	move.w	d1,cio_length(a4)
	bne.s	4$
	moveq	#1,d1
	bra.s	3$

4$:	movem.l	(sp)+,d0-a6
	rts
	
;------------------

;------------------------------------------------------------------------------
*
* PrintPageLine	Print one line to the window, cut it if neccessary. The text
*		must be only one line, otherwise a good output is not guaranteed.
*		If a page is full, the window goes to RAW mode, requests <SPACE>
*		and goes back to the old mode after calling NewCIOPage
*
* INPUT		a0	text, zeroterminated.
*
;------------------------------------------------------------------------------

;------------------
ConPagePrint:

;------------------
; Test if counter goes zero, print the 'press any key to continue', clear
; it and go to CON mode:
;
\test:	movem.l	d0-a6,-(sp)
	move.l	a0,a3
	lea	cio_base(pc),a4

	subq.w	#1,cio_count(a4)
	bhi.s	\count

	moveq	#-1,d0
	bsr	SetCIOConMode
	beq	\count

	lea	\request(pc),a0
	bsr	ConPrint
	bsr	OpenDosLib
	beq.s	1$
	move.l	cio_conin(pc),d1
	mea	cio_printbuffer(pc),d2
	moveq	#1,d3
	jsr	-42(a6)			;Read()
	bsr	CloseDosLib

1$:	lea	\request2(pc),a0
	bsr	ConPrint
	moveq	#0,d0
	bsr	SetCIOConMode
	bsr	NewCIOPage

	lea	cio_count(pc),a0
	subq.w	#1,(a0)


;------------------
; Test if line longer than allowed.
;
\count:	bsr	TestCTRLC
	lea	cio_break(pc),a0
	sne	(a0)
	bne.s	\dono
	move.l	a3,a0
	moveq	#0,d7
	move.w	cio_length(pc),d0

\loop:	cmp.b	#$a,(a0)+
	beq.s	\fine
	subq.w	#1,d0
	bne.s	\loop

	moveq	#1,d7
	move.b	(a0),d6
	move.b	-(a0),d5
	move.l	a0,a2
	move.b	#$a,(a0)+
	clr.b	(a0)

\fine:	move.l	a3,a0
	bsr	ConPrint
	
	tst.b	d7
	beq.s	\dono
	move.b	d5,(a2)+
	move.b	d6,(a2)

\dono:	movem.l	(sp)+,d0-a6
	rts



\request:	dc.b	8,1,8,$f8,"<Press any key to continue>",8,0,1
		dc.b	$9b,$30,$20,$70,0

\request2:	dc.b	$d,$9b,$20,$70,$9b,$4b,0
	even

;------------------
	endif
	ifd	cio_CONMODE

;------------------

;------------------------------------------------------------------------------
*
* SetCIOConMode	Set mode of window.
*
* INPUT		d0	0:CON  -1:RAW
*
* RESULT	d0	0 if error, else -1
*
;------------------------------------------------------------------------------

;------------------
SetCIOConMode:

;------------------
; Do it.
;
\start:	movem.l	d1-a6,-(sp)
	move.l	d0,d7
	bsr	AllocPacket
	beq.s	\error
	move.l	d0,d6

	move.l	4.w,a6
	move.l	$114(a6),a4
	lea	$5c(a4),a4

	move.l	d6,a0
	pea	994.w			;ACTION_SETRAWMODE
	move.l	(sp)+,8(a0)
	move.l	d7,20(a0)		;BPTR InfoData

	move.l	d6,d1
	move.l	cio_conin(pc),d2
	lsl.l	#2,d2
	move.l	d2,a0
	move.l	8(a0),d2
	move.l	a4,d3
	bsr	SendPacket
	move.l	a4,d0
	bsr	WaitForPacket
	move.l	d6,d0
	bsr	FreePacket
	moveq	#-1,d0

\exit:	movem.l	(sp)+,d1-a6
	rts

\error:	moveq	#0,d0
	bra.s	\exit

;------------------
	endif
	ifd	cio_CTRL

;------------------

;------------------------------------------------------------------------------
*
* TestCTRLC	Test if CTRL-C pressed
*
* RESULT	d0	-1 if pressed, else 0
*		ccr	on d0
*
;------------------------------------------------------------------------------

;------------------
TestCTRLC:

;------------------
; Do it.
;
\start:	movem.l	d1-a6,-(sp)
	move.l	4.w,a6
	moveq	#0,d0
	move.l	#$1000,d1		;CTRL-C
	move.l	d1,d7
	jsr	-306(a6)		;SetSignal()
	and.l	d7,d0
	sne	d0
	movem.l	(sp)+,d1-a6
	rts

;------------------
	endif

;------------------

;--------------------------------------------------------------------

;------------------
	include	doslib.r

	ifd	cio_CONMODE
	include	packets.r
	endif

;------------------
; Read.
;
	ifnd	cio_OUTPUTONLY
	ifd	crp_buffer
cio_readbuffer	equ	crp_buffer
	else
cio_readbuffer:		ds.b	202,0
	endif
	endif

;------------------
; Write.
;
cio_printbuffer:	ds.b	200,0
	ifnd	CIO_NORAW
cio_rawbuffer:		ds.b	202,0
	endif

;------------------
; Handles.
;
cio_conin:		dc.l	0
cio_conout:		dc.l	0

;------------------
; Page mode stuff:
;
	ifd	cio_PAGETOO
cio_window:		dc.l	0
cio_fonty:		dc.w	0
cio_fontx:		dc.w	0
cio_count:		dc.w	0
cio_length:		dc.w	0
cio_rawpages:		dc.b	0	;set if ConPrintRaw uses PagePrint
cio_break:		dc.b	0	;set if CTRL-C while paused
	endif

;------------------
; Flags:
;
cio_ansimode:	dc.b	-1		;-1:ansi, 0: no
cio_error:	dc.b	0		;set if error while ConPrint

;------------------
; ANSI control texts.
;
cio_ansitexts:
	dc.b	"30m",0
	dc.b	"31m",0
	dc.b	"32m",0
	dc.b	"33m",0
	dc.b	"1m",0,0
	dc.b	"4m",0,0
	dc.b	"7m",0,0
	dc.b	"0m",0,0
	dc.b	"40m",0
	dc.b	"41m",0
	dc.b	"42m",0
	dc.b	"43m",0

;------------------

;--------------------------------------------------------------------

;------------------
	base	cio_oldbase

;------------------
	endif

	end

