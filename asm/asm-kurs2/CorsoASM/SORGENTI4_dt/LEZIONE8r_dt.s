
; Lezione8r.s		Prozessorerkennung und -routinen
				; Chipsatz (aga oder normal).
				; (Aber für uns macht das die Sysinfo !!)

	SECTION	SysInfo,CODE

*****************************************************************************
	include	"startup1.s"	; Copperlist Etc.
*****************************************************************************

		;5432109876543210
DMASET	EQU	%1000001110000000	; nur copper und bitplane DMA

START:

;	Zeiger auf bitplanes in copperlist

	MOVE.L	#BITPLANE,d0	; in d0 setzen wir die adresse der 
	LEA	BPLPOINTERS,A1		; Zeiger in der COPPERLIST
	move.w	d0,6(a1)		; Kopieren Sie das LOW Wort der bitplaneadresse
	swap	d0				; Vertausche die 2 Wörter von d0 (zB: 1234> 3412)
	move.w	d0,2(a1)		; Kopieren Sie das HIGH Wort der bitplaneadresse

; Beachten Sie die -80 !!!! (um den "Tiefen" - Effekt zu verursachen

	MOVE.L	#BITPLANE-80,d0	; in d0 setzen wir die Adresse der bitplane -80
							; das ist eine SUB-Zeile! *******
	LEA	BPLPOINTERS2,A1		; Zeiger in der COPPERLIST
	move.w	d0,6(a1)		; Kopieren Sie das LOW Wort der bitplaneadresse
	swap	d0				; Vertausche die 2 Wörter von d0 (zB: 1234> 3412)
	move.w	d0,2(a1)		; Kopieren Sie das HIGH Wort der bitplaneadresse

	bsr.s	CpuDetect	; Prüfen Sie, welche CPU vorhanden ist und wechseln Sie
						; den Text richtig wenn es kein 68000 ist
						; grundlegend.
	bsr.w	FpuDetect	; Überprüfen Sie, ob ein Coprozessor vorhanden ist
						; mathematische Gleitkommazahl (Floating Point Unit)
	bsr.w	AgaDetect	; Überprüfen Sie, ob der AGA-Chipsatz vorhanden ist.

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
						; und sprites.

	move.l	#COPPERLIST,$80(a5)	; Wir zielen auf unsere COP
	move.w	d0,$88(a5)			; Beginnen wir mit der COP
	move.w	#0,$1fc(a5)			; Deaktivieren Sie die AGA
	move.w	#$c00,$106(a5)		; Deaktivieren Sie die AGA
	move.w	#$11,$10c(a5)		; Deaktivieren Sie die AGA


mouse:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$10800,d2	; Warte auf Zeile = $108
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos. 
	CMPI.L	D2,D0		; Warte auf Zeile = $108
	BNE.S	Waity1
Waity2:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos. 
	CMPI.L	D2,D0		; Warte auf Zeile = $108
	Beq.S	Waity2

	bsr.w	PrintCarattere	; Drucken Sie jeweils ein Zeichen

	btst	#6,$bfe001	; Maus gedrückt?
	bne.s	mouse

	rts

;*****************************************************************************
;			ROUTINE ZUM ERKENNEN DES PROCESSORS
;
; Sowohl diese Routine als auch die, die das Vorhandensein der FPU feststellt, 
; verwenden ein Spezialbyte des Betriebssystems, das $129 Bytes nach dem
; Wert in $4 gefunden, dh execBase + $129.
;
;	AttnFlags (dh Byte $129 (a6), in a6 gibt es execBase)
;
;      bit	CPU o FPU
;
;	0	68010 (o 68020/30/40)
;	1	68020 (o 68030/40)
;	2	68030 (o 68040)			[V37+]
;	3	68040 					[V37+]
;	4	68881 FPU fitted (o 68882)
;	5	68882 FPU fitted		[V37+]
;	6	68040 FPU fitted		[V37+]
;
;*****************************************************************************

;	      /\                     ___.               /\
;	     /  \   ______  __      /   |_________     /  \NoS!
;	    /    \  \_    \/  \    /    |        /    /    \_ ___ _/\__
;	   //     \  /         \  /_____|   ____/___./     \ _ _ _ ø¶ /
;	  //       \/    \  /   \/      |   \__     |       \\   /_)(_\
;	 /          \     \/     \      |     7     |         \    \/
;	/____________\____/_____/\______j___________j__________\

CpuDetect:
	LEA	CpuType(PC),A1
	move.l	4.w,a6		; ExecBase in a6

; Hinweis: Der 68030/40 wird von Kickstart 1.3 oder niedriger nicht erkannt, aber
; Es wird davon ausgegangen, dass wer einen 68020+ hat, auch Kickstart 2.0 oder 
; höher hat!

	btst.b	#3,$129(a6)		; Attnflags - ein 68040?
	BNE.S	M68040
	btst.b	#2,$129(a6)	;d0	; Attnflags - ein 68030?
	BNE.S	M68030
	btst.b	#1,$129(a6)	;d0	; Attnflags - ein 68020?
	BNE.S	M68020
	btst.b	#0,$129(a6)	;d0	; Attnflags - ein 68010?
	BNE.S	M68010
M68000:
	BRA.S	PROCDONE	; ein 68000! lass den Text '68000'

M68010:
	MOVE.W	#'10',(a1)	; ändert '68000' in '68010'
	BRA.S	PROCDONE

M68020:
	MOVE.W	#'20',(a1)	; ändert '68000' in '68020'
	BRA.S	PROCDONE

M68030:
	MOVE.W	#'30',(a1)	; ändert '68000' in '68030'
	BRA.S	PROCDONE

M68040:
	MOVE.W	#'40',(a1)	; ändert '68000' in '68040'


PROCDONE:
	rts

;*****************************************************************************
;			ROUTINE WELCHE DEN KOPROZESSOR ERKENNT
;*****************************************************************************

; Überprüfen Sie nun, ob ein mathematischer Coprozessor (FPU) vorhanden ist.

FPUDetect:
	LEA	FpuType(PC),a1		; Coprozessor-Textzeichenfolge (FPU)
	move.l	4.w,a6			; Execbase (Zugang zum byte AttnFlags)
	btst.b	#3,$129(a6)		; Wenn es sich um einen 68040 handelt, 
							; ist der Coprozessor im Lieferumfang enthalten!
	BNE.S	FpuPresente
	btst.b	#4,$129(a6);d0	; 68881? -> FPU detected!
	BNE.S	FpuPresente
	btst.b	#5,$129(a6);d0	; 68882? -> FPU detected!
	BNE.S	FpuPresente
	BRA.S	FpuNonPresente	; NO FPU! ....

FpuPresente:
	MOVE.L	#'FOUN',(A1)+	; Wenn es vorhanden ist, schreiben wir GEFUNDEN!
	MOVE.B	#'D',(A1)+
FpuNonPresente:
	rts

;*****************************************************************************
;	      ROUTINE DIE CHIPSET AGA ERKENNT (Mach NIEMALS einen Fehler!)
;*****************************************************************************

AgaDetect:
	LEA	$DFF000,A5
	MOVE.W	$7C(A5),D0		; DeniseID (die LisaID AGA)
	MOVEQ	#100,D7			; 100 mal kontrollieren (aus Sicherheitsgründen gegeben)
							; dass die alte denise aus zufälligen werten)
DENLOOP:
	MOVE.W	$7C(A5),D1		; Denise ID (die LisaID AGA)
	CMP.B	d0,d1			; Gleicher Wert?
	BNE.S	NOTAGA			; Nicht der gleiche Wert: Denise OCS!
	DBRA	D7,DENLOOP
	BTST.L	#2,d0			; BIT 2 reset = AGA. Ist die Aga da?
	BNE.S	NOTAGA			; nein?
	LEA	Chipset(PC),A1		JA!
	MOVE.L	#'AGA ',(A1)+	; Setzen Sie AGA anstelle von NORMAL ein...
	MOVE.W	#'  ',(A1)+
	LEA	Messaggio(PC),A1	; Und gratuliere der AGA
	MOVE.L	#'Gran',(A1)+
	MOVE.L	#'de! ',(A1)+
	MOVE.L	#'Una ',(A1)+
	MOVE.L	#'macc',(A1)+
	MOVE.L	#'hina',(A1)+
	MOVE.L	#' AGA',(A1)+
	MOVE.L	#'!!! ',(A1)+
	MOVE.L	#'    ',(A1)+
	MOVE.L	#'    ',(A1)+
	MOVE.L	#'    ',(A1)
NOTAGA:						; nicht AGA... OCS/ECS... mah..
	rts						; Dann hinterlassen Sie die Nachricht, um es zu kaufen!

*****************************************************************************
;			Druckroutine
*****************************************************************************

PRINTcarattere:
	MOVE.L	PuntaTESTO(PC),A0	; Adresse des zu druckenden Textes in a0
	MOVEQ	#0,D2				; lösche d2
	MOVE.B	(A0)+,D2			; Nächstes Zeichen in d2
	CMP.B	#$ff,d2				; Ende des Textsignals? ($FF)
	beq.s	FineTesto			; Wenn ja, beenden Sie ohne zu drucken
	TST.B	d2					; Zeilenende-Signal? ($00)
	bne.s	NonFineRiga			; Wenn nicht, nicht einpacken

	ADD.L	#80*7,PuntaBITPLANE	; Gehen wir zum Kopf
	ADDQ.L	#1,PuntaTesto		; erste Zeichenzeile nach
								; (überspringe die NULL)
	move.b	(a0)+,d2			; erstes Zeichen der Zeile nach
								; (überspringe die NULL)

NonFineRiga:
	SUB.B	#$20,D2		; ZÄHLE 32 VOM ASCII-WERT DES BUCHSTABEN WEG,
						; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
						; (Das $20 entspricht), IN $00, DAS
						; MALZEICHEN ($21) IN $01....
	LSL.W	#3,D2		; MULTIPLIZIERE DIE ERHALTENE ZAHL MIT 8,
						; da die Charakter ja 8 Pixel hoch sind
	MOVE.L	D2,A2
	ADD.L	#FONT,A2	; FINDEN SIE DAS GEWÜNSCHTE ZEICHEN IM FONT...

	MOVE.L	PuntaBITPLANE(PC),A3 ; Adr. der Zielbitebene in a3

						; WIR DRUCKEN DAS ZEILENZEICHEN ZEILENWEISE
	MOVE.B	(A2)+,(A3)	; Drucke Zeile 1 des Zeichens
	MOVE.B	(A2)+,80(A3)	; Drucken Sie die Zeile 2  " "
	MOVE.B	(A2)+,80*2(A3)	; Drucken Sie die Zeile 3  " "
	MOVE.B	(A2)+,80*3(A3)	; Drucken Sie die Zeile 4  " "
	MOVE.B	(A2)+,80*4(A3)	; Drucken Sie die Zeile 5  " "
	MOVE.B	(A2)+,80*5(A3)	; Drucken Sie die Zeile 6  " "
	MOVE.B	(A2)+,80*6(A3)	; Drucken Sie die Zeile 7  " "
	MOVE.B	(A2)+,80*7(A3)	; Drucken Sie die Zeile 8  " "

	ADDQ.L	#1,PuntaBitplane ; wir bewegen uns 8 Bits vorwärts (NÄCHSTER ZEICHEN)
	ADDQ.L	#1,PuntaTesto	 ; nächstes zu druckendes Zeichen

FineTesto:
	RTS


PuntaTesto:
	dc.l	TESTO

PuntaBitplane:
	dc.l	BITPLANE

;	$00 für "Zeilenende" - $FF für "Textende"

			; Anzahl der Zeichen pro Zeile: 40
TESTO:	    ;		  1111111111222222222233333333334
            ;   1234567890123456789012345678901234567890
	dc.b	'    Loading Randy Operating System 1.02,'   ; 1
	dc.b	' please wait...                         ',0 ; 1b
;
	dc.b	'                                        '   ; 2
	dc.b	'                                        ',0 ; 2b
;
	dc.b	'    Testing HARWARE...                  '   ; 3
	dc.b	'                                        ',0 ; 3b
;
	dc.b	'    Testing KickStart...                '   ; 4
	dc.b	'                                        ',0 ; 4b
;
	dc.b	'    Done.                               '   ; 5
	dc.b	'                                        ',0 ; 5b
;
	dc.b	'                                        '   ; 6
	dc.b	'                                        ',0 ; 6b
;
	dc.b	'    PROCESSOR (CPU):  680'
CpuType:
	dc.b	'00             '  ; 7
	dc.b	'                                        ',0 ; 7b
;
	dc.b	'    MATH COPROCESSOR: '
FpuType:
	dc.b	'NONE              '   ; 8
	dc.b	'                                        ',0 ; 8b
;
	dc.b	'    GRAPHIC CHIPSET:  '
Chipset:
	dc.b	'NORMAL           '   ; 9
	dc.b	'                                        ',0 ; 9b
;
	dc.b	'                                        '   ; 10
	dc.b	'                                        ',0 ; 10b
;
	dc.b	'     '
Messaggio:
	dc.b	'Comprati una macchina AGA!         '   ; 11
	dc.b	'                                        ',$FF ; 11b
;

	EVEN


;	Die FONT 8x8-Zeichen werden in CHIP von der CPU und nicht vom Blitter kopiert,
;	so kann es auch im schnellen ram sein. In der Tat wäre es besser!

FONT:
	;incbin	"assembler2:sorgenti4/nice.fnt"
	incbin	"nice.fnt"
******************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8e,$2c81	; DiwStrt	(Register mit normalen Werten)
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$003c	; DdfStart HIRES
	dc.w	$94,$00d4	; DdfStop HIRES
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

			    ; 5432109876543210
	dc.w	$100,%1010001000000000	; bit 13 - 2 bitplanes, 4 color HIRES

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane
BPLPOINTERS2:
	dc.w $e4,$0000,$e6,$0000	; zweites bitplane

	dc.w	$180,$103	; color0 - HINTERGRUND
	dc.w	$182,$fff	; color1 - plane 1 normale Position, es ist
						; der Teil, der oben "hervorsteht".
	dc.w	$184,$345	; color2 - plane 2 (Versatz unten)
	dc.w	$186,$abc	; color3 - beide Ebenen - überlappen

	dc.w	$FFFF,$FFFE	; Ende copperlist

******************************************************************************

	SECTION	MIOPLANE,BSS_C	; ABSCHNITT BSS muss aus bestehen
			; nur ZERI !!! Wir verwenden DS.b, um zu definieren
			; Wie viele Nullen enthält der Abschnitt.

; Deshalb brauchen wir die "ds.b 80":
; Move.l #bitplane-80,d0; in d0 setzen wir die Adresse der bitplane -80
; das ist eine SUB-Zeile! *******

	ds.b	80		; die Zeile, die "überprüfen"
BITPLANE:
	ds.b	80*256	; eine bitplane HIres 640x256

	end

Wenn Sie bemerken, ändern wir den Text, bevor er gedruckt wird, nichts Wunderbares.
Um herauszufinden, welcher Prozessor und welcher Chipsatz sich in Ihrem Computer 
befindet, wenden Sie sich einfach an die relativen Bits des Betriebssystems und 
des $ dff07c. Es reicht jedoch aus Szene zeigt eine Erkennung zu Beginn der 
Produktion !!!
