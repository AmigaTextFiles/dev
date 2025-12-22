	incdir	includes:

	include	libraries/vmemory_lib.i
	include	libraries/vmemorybase.i

; Offsets Exec.library
_LVOOpenLibrary		EQU	-$198
_LVOCloseLibrary	EQU	-$19e

; Offsets Dos.library
_LVOOpen		EQU	-$1e
_LVOClose		EQU	-$24
_LVORead		EQU	-$2a
_LVOWrite		EQU	-$30
_LVOOutput		EQU	-$3c

	include	startup.i		; Startup-Modul
; Oeffnen der Libary

	lea	VMemname,a1			
	moveq	#0,d0				
	move.l	4.w,a6				
	jsr	_LVOOpenLibrary(a6)			

; alles Ok ? Nein --> NoLib

	tst.l	d0
	beq	NoLib

	move.l	d0,VMemBase			; Base speichern
	move.l	d0,a6

; dies ist zwar nicht die feine englische Art, um an die Dosbase zu ge-
; langen, aber der Zweck heigigt die Mittel und dieses Demoprogramm
; soll ja nur die Moeglichkeiten der VMemory.library etwas eroeffnen.

	move.l	sb_DosLib(a6),DosBase

	move.l	DosBase,a6
	jsr	_LVOOutput(a6)			; Stdout holen

	move.l	d0,Handle			; und speichern

	lea	Test1Txt,a0			
	bsr	WriteText

	lea	TestMem,a0			; Speicherblock nach a0
	bsr	WriteText			; und ausgeben

	bsr	ReadText			; auf Eingabe warten

; ersten Text ausgeben

	lea	Test0Txt,a0			; Text nach a0
	bsr	WriteText			; und ausgeben

	bsr	ReadText

; Test Speicher in virtuellen Speicher verlegen

	lea	TestMem,a0			; Speicherblock nach a0
	move.l	#250,d0				; 250 Bytes groesse
	move.l	VMemBase,a6
	jsr	_LVOAllocVMem(a6)		; belegen

	tst.l	d0				; alles Ok ?
	bmi	NoVMem				; nein --> NoVMem

	move.l	d0,Page				; sonst Page merken

	lea	Test7Txt,a0			; Test7Txt ausgeben
	bsr	WriteText

	bsr	ReadText

	move.l	#249,d0				; 250 Byte groesse
	lea	TestMem,a0			; ab TestMem
loop1
	move.b	#'x',(a0)+			; und mit x-en fuellen
	dbra	d0,loop1			; alle ? nein --> loop1

	
	lea	Test2Txt,a0
	bsr	WriteText

	lea	TestMem,a0
	bsr	WriteText

	bsr	ReadText

	lea	Test3Txt,a0
	bsr	WriteText

	bsr	ReadText

	move.l	Page,d0				; Page nach d0
	move.l	VMemBase,a6
	jsr	_LVOReadVMem(a6)		; und Speicher wieder holen

	lea	Test4Txt,a0
	bsr	WriteText

	lea	TestMem,a0
	bsr	WriteText

	bsr	ReadText

	lea	Test5Txt,a0
	bsr	WriteText

	bsr	ReadText

	move.l	Page,d0				; Page nach d0
	move.l	VMemBase,a6
	jsr	_LVOFreeVMem(a6)		; und Speicher freigeben


NoVMem
	move.l	4.w,a6
	move.l	VMemBase,a1
	jsr	_LVOCloseLibrary(a6)

	moveq	#0,d0
	rts

NoLib
	moveq	#20,d0
	rts
		
; Routine zur Textausgabe

WriteText
	move.l	DosBase,a6
	move.l	Handle,d1
	move.l	a0,d2			; Text nach d2

Txtloop
	tst.b	(a0)+
	bne	Txtloop

	move.l	a0,d3			; Textende nach d3
	sub.l	d2,d3			; und Textlaenge ermitteln
	jsr	_LVOWrite(a6)		; Text schreiben

	rts

; Routine zur Texteingabe (1 Zeichen)

ReadText
	lea	Test6Txt,a0
	bsr	WriteText

	move.l	Dosbase,a6
	move.l	Handle,d1
	move.l	#Eingabe,d2		; Eingabepuffer nach d2
	moveq	#1,d3			; nur 1 Zeichen holen
	jsr	_LVORead(a6)		; und Eingabe holen

	rts
	
Page
	dc.l	0

VMemBase
	dc.l	0

DosBase
	dc.l	0

Handle
	dc.l	0

VMemname
	dc.b	'vmemory.library',0
	even

Test0Txt
	dc.b	$0a,'Belege nun virtuellen Speicher ...',$0a,0
	even

Test1Txt
	dc.b	$0a,'So sieht der Speicher aus, welcher ausgelagert wird:',$0a,0
	even

Test2Txt
	dc.b	$0a,'So sieht nun der veraenderte Speicher aus :',$0a,0
	even

Test3Txt
	dc.b	$0a,'Hole wieder den alten Speicher zurueck ...',$0a,0
	even

Test4Txt
	dc.b	$0a,'So sieht jetzt wieder der Speicher aus :',$0a,0
	even

Test5Txt
	dc.b	$0a,'Gebe nun den Speicher wieder frei ...',$0a,0
	even

Test6Txt
	dc.b	$0a,'Bitte Enter druecken ...',$0a,0
	even

Test7Txt
	dc.b	$0a,'Veraendere nun den Speicher ...',$0a,0
	even

TestMem
	ds.b	250,'a'
	dc.b	0
	even

Eingabe
	dc.b	0
	even

