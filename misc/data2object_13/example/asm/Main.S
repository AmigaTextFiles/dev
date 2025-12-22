;
; make a text-object with d2o:
;
;      d2o Main.s SYMBOL Text OBJECT Text.o
;
; compile your assembly-source to an object-file:
;
;      asm Main.S
;
;
; Now you've got the two object files:
;
;      Text.o    containing the text you want to use
;      Main.o    containing the main code
;
;
; Make an executable file with for example SAS/C slink:
;
;      slink from Main.o Text.o to Test
;

	xref	_lTextLen	; 'Text' could be anything, it's just what
	xref	_pText		; you specified in d2o, option SYMBOL

	xdef	Main
	
	section	"TEXT",code
	
Main	move.l	$4.w,a6
	moveq.l	#36,d0
	lea	dosname(PC),a1
	jsr	-552(a6)	OpenLibrary(a6)
	tst.l	d0
	bne.s	GotDos
	moveq.l	#20,d0		error, could not open dos.library
	rts
	
GotDos	move.l	d0,a6
	jsr	-60(a6)		Output(a6)
	move.l	d0,d1
	lea	_pText,a0
	move.l	a0,d2
	move.l	_lTextLen,d3
	jsr	-48(a6)		Write(a6)
	
	move.l	a6,a1
	move.l	$4.w,a6
	jsr	-414(a6)	CloseLibrary(a6)
	moveq.l	#0,d0
	rts
	
dosname	dc.b	'dos.library',0
	
	end
