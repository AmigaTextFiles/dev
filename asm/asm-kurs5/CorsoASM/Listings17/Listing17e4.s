; Listing17e4.s = CodFiscale.s
; CODICE FISCALE (C)1993 Daniele Paccaloni (DDT / HALF-BRAINS TEAM) !
; Dies ist die schnellste Routine zur Berechnung des Steuerkennzeichens von
; einer Person. Die Gemeindetabelle kann nach Wunsch erweitert werden.
; Offensichtlich ist die Geschwindigkeit nicht wesentlich, um die Steuerkennzeichen
; einer einzelnen Person (wie es jetzt im Eingabeaufforderungsmodus geschieht) zu berechnen
; Wenn Sie dies jedoch für einen Stapeljob beheben, ist dies sehr nützlich.
; einige Staatsämter angesichts der beschämenden Langsamkeit, mit der sie kommen
; viele Übungen durchgeführt :) Wenn alle Programme 
; in Assembler geschrieben wurden wären keine Pentiums mehr nötig
; ... außer zum Spielen von DOOM!!!
; Viel Spaß beim Finden der Steuerkennziffer Ihrer Freunde, Sie werden sie in Erstaunen versetzen
; errate alle Zahlen .. und auch die letzten, die schwierigsten !!! :)
; Dieses Programm kann süchtig machen .. !@#?! Außerhalb der 
; Reichweite jüngerer Kinder halten.
;					Daniele

S:

Input:	move.l	$4.w,a6			; Take the execbase address,
	lea	DosName,a1				; open the GFXlibrary {
	jsr	-408(a6)				; }.
	tst.l	d0
	beq.w	Error
	move.l	d0,DosBase			; Save the GFXbase pointer,
	move.l	d0,a6


; NACHNAME

	bsr.w	ClrBuf

InputSurn:
	jsr	-60(a6)					; _LVOOutput
	tst.l	d0
	beq.w	Error
	move.l	d0,OutHandler
	move.l	d0,d1
	move.l	#OutText1,d2
	move.l	#EndOutText1-OutText1,d3
	jsr	-48(a6)					; _LVOWrite

	jsr	-54(a6)					; _LVOInput
	tst.l	d0
	beq.w	Error
	move.l	d0,InHandler		; d0=string lenght
	move.l	d0,d1
	move.l	#InputBuffer,d2
	moveq	#80,d3
	jsr	-42(a6)					; _LVORead
	tst.l	d0
	beq.s	InputSurn
	move.l	d0,d1				; Copy string lenght

	bsr.w	Maiuscolo
	bsr.w	EliminaSpazii

	move.w	d1,d0				; Suchen Sie nach den ersten 3 Konsonanten
	subq.w	#1,d0
	moveq	#3,d4
	lea	InputBuffer(pc),a0
	lea	CODICE(pc),a4
ChkNxtC:
	move.b	(a0)+,d3
	lea	VocalsTab(pc),a2
	moveq	#4,d2
ChkVocC:
	cmp.b	(a2)+,d3
	beq.s	IsVoc
	dbra	d2,ChkVocC
	cmp.b	#10,d3				; Check if EOL
	beq.s	GetVocs
	move.b	d3,(a4)+
	subq.w	#1,d4
	beq.s	NOME
IsVoc:
	dbra	d0,ChkNxtC

GetVocs:	
	move.w	d1,d0				; Komplett mit Vokalen
	subq.w	#1,d0
	lea	InputBuffer(pc),a0
ChkNxtV:
	move.b	(a0)+,d3
	lea	VocalsTab(pc),a2
	moveq	#4,d2
ChkVocV:
	cmp.b	(a2)+,d3
	beq.s	YeVoc
	dbra	d2,ChkVocV
	dbra	d0,ChkNxtV
	bra.s	VDone

YeVoc:
	move.b	d3,(a4)+
	subq.w	#1,d4
	beq.s	NOME
	dbra	d0,ChkNxtV
VDone:
PatchX:
	move.b	#"X",(a4)+			; Fügen Sie bei Bedarf Xs ein
	subq.w	#1,d4
	bne.s	PatchX

;--------------------------------NAME

NOME:
	bsr.w	ClrBuf
InputName:
	jsr	-60(a6)					; _LVOOutput
	tst.l	d0
	beq.w	Error
	move.l	d0,OutHandler
	move.l	d0,d1
	move.l	#OutText2,d2
	move.l	#EndOutText2-OutText2,d3
	jsr	-48(a6)					; _LVOWrite

	jsr	-54(a6)					; _LVOInput
	tst.l	d0
	beq.w	Error
	move.l	d0,InHandler
	move.l	d0,d1
	move.l	#InputBuffer,d2
	moveq	#80,d3
	jsr	-42(a6)					; _LVORead
	tst.l	d0					; d0 = Länge string
	beq.s	InputName
	move.l	d0,d1				; Kopie Länge string

	bsr.w	Maiuscolo
	bsr.w	EliminaSpazii

; Kopieren Sie die ersten 4 Konsonanten des Namens in ConsNome:

	move.l	d1,d0
	subq.w	#1,d0
	moveq	#4,d4				; Überprüfen Sie 4 Konsonanten
	lea	InputBuffer(pc),a0
	lea	ConsNome(pc),a5			; Kopieren Sie hier die ersten 4 Konsonanten
NxtLet:
	move.b	(a0)+,d3
	lea	VocalsTab(pc),a2
	moveq	#4,d2
ChkCons:
	cmp.b	(a2)+,d3
	beq.s	NoCon
	dbra	d2,ChkCons
	cmp.b	#10,d3				; Check if EOL
	beq.s	NoCon
	move.b	d3,(a5)+
	subq.w	#1,d4
	beq.s	FourCon
NoCon:
	dbra	d0,NxtLet
	lea	ConsNome(pc),a5			; Adresse ersten 4 Konsonanten
	moveq	#3,d0
	sub.w	d4,d0				; d0=Anzahl der Konsonanten Name
	bpl.s	CpyCon
	subq.w	#1,d4
	bra.s	NoCons
CpyCon:
	move.b	(a5)+,(a4)+
	dbra	d0,CpyCon
	subq.w	#1,d4				; Testen Sie, ob 3 Konsonanten vorhanden sind,
	beq.s	DATA				; Wenn ja, gehen Sie, um das Datum zu verschlüsseln...
NoCons:
	move.w	d1,d0				; Ansonsten komplett mit Vokalen:
	subq.w	#1,d0
	lea	InputBuffer(pc),a0
ChkNxtN:
	move.b	(a0)+,d3
	lea	VocalsTab(pc),a2
	moveq	#4,d2
ChkVocN:
	cmp.b	(a2)+,d3
	beq.s	YeVoc2
	dbra	d2,ChkVocN
	dbra	d0,ChkNxtN
	bra.s	VDoneN

YeVoc2:
	move.b	d3,(a4)+
	subq.w	#1,d4
	beq.w	DATA
	dbra	d0,ChkNxtN
VDoneN:
PatchXN:
	move.b	#"X",(a4)+			; Fügen Sie bei Bedarf Xs ein
	subq.w	#1,d4
	bne.s	PatchXN
	bra.s	SkipHere

; Kopieren Sie den 1 ', 3', 4 'Konsonanten in den CODE

FourCon:
	lea	ConsNome(pc),a5			; Adresse der ersten 4 Konsonanten
	move.b	(a5),(a4)+			; Kopieren Sie den ersten in den Code
	move.b	2(a5),(a4)+			; Kopieren Sie den dritten in den Code
	move.b	3(a5),(a4)+			; Kopieren Sie den vierten in den Code
SkipHere:
;------------------------------------DATA DI NASCITA
DATA:
	bsr.w	ClrBuf
InputData:
	jsr	-60(a6)					; _LVOOutput
	tst.l	d0
	beq.w	Error
	move.l	d0,OutHandler
	move.l	d0,d1
	move.l	#OutText3,d2
	move.l	#EndOutText3-OutText3,d3
	jsr	-48(a6)					; _LVOWrite

	jsr	-54(a6)					; _LVOInput
	tst.l	d0
	beq.w	Error
	move.l	d0,InHandler
	move.l	d0,d1
	move.l	#InputBuffer,d2
	moveq	#80,d3
	jsr	-42(a6)					; _LVORead
	tst.l	d0					; d0 = Länge string
	beq.s	InputData
	cmp.l	#9,d0
	bne.s	InputData
	lea	InputBuffer(pc),a0
	cmp.b	#"/",2(a0)
	bne.s	InputData
	cmp.b	#"/",5(a0)
	bne.s	InputData
	move.b	(a0),d7
	bsr.w	VerifNum
	bne.s	InputData
	move.b	1(a0),d7
	bsr.w	VerifNum
	bne.s	InputData
	move.b	3(a0),d7
	bsr.w	VerifNum
	bne.s	InputData
	move.b	4(a0),d7
	bsr.w	VerifNum
	bne.w	InputData
	move.b	6(a0),d7
	bsr.w	VerifNum
	bne.w	InputData
	move.b	7(a0),d7
	bsr.w	VerifNum
	bne.w	InputData
	move.l	d0,d1				; Kopie String-Länge

	cmp.b	#"2",(a0)			; Testen Sie, ob der Tag  > 29 ist
	bls.s	OkGg
	cmp.b	#"1",1(a0)			; Wenn Tag> 31 dann
	bhi.w	InputData			;   reinput...

OkGg:
	move.b	3(a0),d0
	sub.b	#$30,d0
	mulu.w	#10,d0				; Multiplikation nicht optimiert
	add.b	4(a0),d0
	sub.b	#$30,d0
	cmp.b	#12,d0
	bhi.w	InputData

	move.b	6(a0),(a4)+			; Kopieren Sie die letzten beiden Ziffern des
	move.b	7(a0),(a4)+			; Jahr im Code.

	subq.w	#1,d0				; Subtrahiert 1 für die Abweichung in der tab
	and.w	#$00ff,d0			; Reinigt die Oberseite von d0
	lea	MonthTab(pc),a2			; zeigt auf den Tabelle
	move.b	(a2,d0.w),d0		; nimmt den Buchstaben des Monats in d0

	move.b	d0,(a4)+			; setzt Buchstaben des Monats in cod

	move.b	(a0),d6				; d6.b = Zehnerzahl des Tages
	move.b	1(a0),d7			; d7.b = Einheitszahl des Tages
;------------------------------------Geschlecht
	bsr.w	ClrBuf
InputSesso:
	jsr	-60(a6)					; _LVOOutput
	tst.l	d0
	beq.w	Error
	move.l	d0,OutHandler
	move.l	d0,d1
	move.l	#OutText4,d2
	move.l	#EndOutText4-OutText4,d3
	jsr	-48(a6)					; _LVOWrite

	jsr	-54(a6)					; _LVOInput
	tst.l	d0
	beq.w	Error
	move.l	d0,InHandler
	move.l	d0,d1
	move.l	#InputBuffer,d2
	moveq	#80,d3
	jsr	-42(a6)					; _LVORead
	tst.l	d0					; d0 = String-Länge
	beq.s	InputSesso	
	move.l	d0,d1				; Kopie String-Länge

	bsr.w	Maiuscolo

	lea	InputBuffer(pc),a2
	cmp.b	#"M",(a2)
	beq.s	Maschio
	cmp.b	#"F",(a2)
	bne.s	InputSesso

	addq.b	#4,d6				; Wenn es eine Frau ist, addiere 4
								; auf die Zehnerstelle!

Maschio:move.b	d6,(a4)+		; Es setzt die Zehnerstelle des Tages
								; im Code,
	move.b	d7,(a4)+			; Legt die Anzahl der Einheiten des Tages fest
								; im Code.

;------------------------------------COMUNE
	bsr.w	ClrBuf
InputComune:
	jsr	-60(a6)					; _LVOOutput
	tst.l	d0
	beq.w	Error
	move.l	d0,OutHandler
	move.l	d0,d1
	move.l	#OutText5,d2
	move.l	#EndOutText5-OutText5,d3
	jsr	-48(a6)					; _LVOWrite

	jsr	-54(a6)					; _LVOInput
	tst.l	d0
	beq.w	Error
	move.l	d0,InHandler
	move.l	d0,d1
	move.l	#InputBuffer,d2
	moveq	#80,d3
	jsr	-42(a6)					; _LVORead
	tst.l	d0					; d0 = String-Länge
	beq.s	InputComune
	move.l	d0,d1				; Stringlänge kopieren

	bsr.w	Maiuscolo

	lea	ComuniTab(pc),a3
SrchNxt:
	lea	InputBuffer(pc),a2
	move.l	d0,d1
	subq.w	#1,d1
CmpCom:
	move.b	(a2)+,d2
	cmp.b	(a3)+,d2
	bne.s	NoThiz
	dbra	d1,CmpCom
	bra.s	ComFound

NoThiz:
	cmp.b	#10,(a3)+
	bne.s	NoThiz
	addq.w	#4,a3
	cmp.l	#ComuniTabEnd,a3
	bne.s	SrchNxt

; Nicht gefunden; Geben Sie die Steuernummer ein

InputCodiceCom:
	jsr	-60(a6)					; _LVOOutput
	tst.l	d0
	beq.w	Error
	move.l	d0,OutHandler
	move.l	d0,d1
	move.l	#OutText6,d2
	move.l	#EndOutText6-OutText6,d3
	jsr	-48(a6)					; _LVOWrite
	jsr	-54(a6)					; _LVOInput
	tst.l	d0
	beq.w	Error
	move.l	d0,InHandler
	move.l	d0,d1
	move.l	#InputBuffer,d2
	moveq	#80,d3
	jsr	-42(a6)					; d0 = String-Länge
	tst.l	d0
	beq.s	InputCodiceCom
	cmp.b	#5,d0				; Codelänge = 4 Stellen
	bne.s	InputCodiceCom
	lea	InputBuffer(pc),a3
	bclr.b	#5,(a3)				; Großbuchstabe
ComFound:
	move.b	(a3)+,(a4)+			; Gemeinsamen Code kopieren
	move.b	(a3)+,(a4)+			; in der Abgabenordnung
	move.b	(a3)+,(a4)+
	move.b	(a3)+,(a4)+

;------------------------------BERECHNE CHARAKTER DER STEUERUNG

	lea	CODICE+1(pc),a0
	moveq	#6,d5
	moveq	#0,d7
ParLop:
	move.b	(a0),d6
	cmp.b	#"9",d6
	bls.s	PNum
	sub.b	#"A"-"0",d6
PNum:
	sub.b	#"0",d6
	ext.w	d6
	add.w	d6,d7
	addq.w	#2,a0
	dbra	d5,ParLop

	lea	CODICE(pc),a0
	lea	CtrlTab(pc),a2
	moveq	#7,d5
DisLop:
	moveq	#0,d6
	move.b	(a0),d6
	cmp.b	#"9",d6
	bls.s	DNum
	sub.b	#"A"-"0",d6
DNum:
	sub.b	#"0",d6
	lsl.w	#1,d6
	add.w	(a2,d6.w),d7
	addq	#2,a0
	dbra	d5,DisLop

	divu.w	#26,d7
	swap	d7
	add.b	#"A",d7
	move.b	d7,(a4)

;------------------------------CODE DRUCKEN

	move.l	DosBase(pc),a6
	jsr	-60(a6)					; _LVOOutput - Steuercode ausdrucken
	tst.l	d0
	beq.s	Error
	move.l	d0,OutHandler
	move.l	d0,d1
	move.l	#CODICE,d2
	moveq	#17,d3
	jsr	-48(a6)					; _LVOWrite

Error:
	move.l	$4.w,a6				; Adresse Execbase,
	move.l	DosBase(pc),a1
	jsr	-414(a6)				; Schließt die Bibliothek DOS
	rts



;---- SOUBROUTINE GROSSBUCHSTABEN --------
; Parameter:	d0.w = Anzahl von Characters

Maiuscolo:
	movem.l	d0/a0,-(sp)
	subq.w	#1,d0
	lea	InputBuffer(pc),a0
Caps:
	cmp.b	#" ",(a0)
	bne.s	OkM
	addq.w	#1,a0
	bra.s	After

OkM:
	bclr.b	#5,(a0)+
After:
	dbra	d0,Caps
	movem.l	(sp)+,d0/a0
	rts


;---- SOUBROUTINE FREIE RÄUME --------
; Parameter:	keine

EliminaSpazii:
	movem.l	d0/a0/a1/a2,-(sp)
	lea	InputBuffer(pc),a0
HuntS:
	move.b	(a0),d6
	cmp.b	#10,d6
	beq.s	EDone
	cmp.b	#" ",d6
	beq.s	Argh
	addq.w	#1,a0
	bra.s	HuntS

Argh:
	move.l	a0,a1
	move.l	a0,a2
Yop:
	addq.w	#1,a2
	move.b	(a2),(a1)+
	cmp.b	#10,(a2)
	beq.s	SEOL
	bra.s	Yop

SEOL:
	addq.w	#1,a0
	bra.s	HuntS
EDone:
	movem.l	(sp)+,d0/a0/a1/a2
	rts


;---- SOUBROUTINE CLEAR BUFFER --------
; Parameter:	keine

ClrBuf:
	lea	InputBuffer(pc),a0
	moveq	#(80/4)-1,d0
ClrB:
	clr.l	(a0)+
	dbra	d0,ClrB
	rts

;---- SOUBROUTINE ÜBERPRÜFE NUMMER --------
; Parameter:	d7.b = Zeichen zu überprüfen
; Ergebnis:	Zflag setzen wenn gleich

VerifNum:
	cmp.b	#$30,d7
	bhi.s	OkBnd1
	rts

OkBnd1:
	cmp.b	#$39,d7
	bhi.s	ExitVM
	moveq	#0,d7
ExitVM:
	rts

;---------------------------------------------------
DosName:	dc.b	"dos.library",0
DosBase:	dc.l	0

OutHandler:	dc.l	0
InHandler:	dc.l	0

OutText1:	dc.b	10,$9b,'33',$6d,"  CODICE FISCALE ",$9b,'31',$6d,"di D.Paccaloni & T.Labruzzo"
		dc.b	10,10,"COGNOME > "
EndOutText1:
OutText2:	dc.b	10,"NOME > "
EndOutText2:
OutText3:	dc.b	10,"DATA DI NASCITA (gg/mm/aa) > "
EndOutText3:
OutText4:	dc.b	10,"SESSO > "
EndOutText4:
OutText5:	dc.b	10,"COMUNE DI NASCITA > "
EndOutText5:
OutText6:	dc.b	10,"Codice comune non trovato, inserirlo (4 cifre) > "
EndOutText6:

	even

InputBuffer:	dcb.b	80,0

VocalsTab:	dc.b	"AEIOU"

MonthTab:	dc.b	"ABCDEHLMPRST"

		; Gemeindetabelle, bei Bedarf zu erweitern!
ComuniTab:	dc.b	"AREZZO",10,"A390"
		dc.b	"ASCOLI PICENO",10,"A462"
		dc.b	"ASTI",10,"A479"
		dc.b	"BARI",10,"A662"
		dc.b	"BERGAMO",10,"A794"
		dc.b	"BOLOGNA",10,"A944"
		dc.b	"BRESCIA",10,"B157"
		dc.b	"CATANIA",10,"C351"
		dc.b	"CATANZARO",10,"C352"
		dc.b	"COMO",10,"C933"
		dc.b	"FERRARA",10,"D548"
		dc.b	"IMPERIA",10,"E290"
		dc.b	"LA SPEZIA",10,"E463"
		dc.b	"LECCE",10,"E506"
		dc.b	"MILANO",10,"F205"
		dc.b	"NAPOLI",10,"F839"
		dc.b	"PALERMO",10,"G273"
		dc.b	"PISA",10,"G702"
		dc.b	"ROMA",10,"H501"
		dc.b	"SIRACUSA",10,"I754"
		dc.b	"TORINO",10,"L219"
		dc.b	"TRIESTE",10,"L424"
		dc.b	"TRENTO",10,"L378"
		dc.b	"UDINE",10,"L483"
		dc.b	"VENEZIA",10,"L736"
		dc.b	"VERONA",10,"L781"
ComuniTabEnd:

		even
CtrlTab:	dc.w	1,0,5,7,9,13,15,17,19,21,2,4,18,20,11,3,6,8
		dc.w	12,14,16,10,22,25,24,23

		even
ConsNome:	dcb.b	4,0

CODICE:		dcb.b	16,0	; 16 Zeichen
		dc.b	10			; EOL


	end

