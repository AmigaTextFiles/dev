
; Listing11h4.s	BAR WELCHE UNTER VERWENDUNG DES WAIT MASKING RAUF UND RUNTER GEHT

; Dieses Listing ist mit einer Ausnahme mit Listing3d.s identisch
; Ein Trick, mit dem wir den gesamten Balken bewegen können
; mit nur einer Anweisung !!!! Der Trick ist in der COPPERLISTE!

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s" ; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001010000000	; nur copper DMA

WaitDisk	EQU	30				; 50-150 zur Rettung (je nach Fall)

START:
	lea	$dff000,a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; warte auf Zeile $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $130 (304)
	BNE.S	Waity1

	btst	#2,$dff016			; richtige Taste gedrückt?
	beq.s	Mouse2				; wenn ja MuoviCopper nicht ausführen 

	bsr.s	MuoviCopper			; Routine die die WAIT-Maskierung nutzt

mouse2:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; warte auf Zeile $130 (304)
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse
	rts

*****************************************************************************

MuoviCopper:
	TST.B	SuGiu				; Sollen wir rauf oder runter gehen?
								; (TST prüft auf BEQ) wenn SuGiu 0 ist
								; dann springen wir zu VAIGIU, wenn es stattdessen $FF ist
								; (falls diese TST nicht verifiziert ist)
								; steigen wir weiter auf (machen subqs)
	beq.w	VAIGIU
	cmpi.b	#$34,BARRA			; sind wir an der Zeile $34?
	beq.s	MettiGiu			; wenn ja, sind wir oben und müssen runter
	subq.b	#1,BARRA
	rts

MettiGiu:
	clr.b	SuGiu				; Zurücksetzen von SuGiu für das TST.B SuGiu
	rts							; es bedeutet, das wir runter müssen

VAIGIU:
	cmpi.b	#$77,BARRA			; sind wir an der Zeile $77?
	beq.s	MettiSu				; Wenn ja, sind wir ganz unten und müssen zurück
	addq.b	#1,BARRA
	rts

MettiSu:
	move.b	#$ff,SuGiu			; Wenn das SuGiu-Label nicht Null ist,
	rts							; bedeutet es, das wir wieder aufsteigen müssen.

Finito:
	rts


; Dieses Byte, angegeben durch das SuGiu-Label, ist ein Richtungs-FLAG 
SuGiu:
	dc.b	0,0


*****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$100,$200
	dc.w	$180,$000			; Starten Sie den Cop mit der Farbe SCHWARZ

	dc.w	$2c07,$FFFE			; ein kleiner grüner fester Balken
	dc.w	$180,$010
	dc.w	$2d07,$FFFE
	dc.w	$180,$020
	dc.w	$2e07,$FFFE
	dc.w	$180,$030
	dc.w	$2f07,$FFFE
	dc.w	$180,$040
	dc.w	$3007,$FFFE
	dc.w	$180,$030
	dc.w	$3107,$FFFE
	dc.w	$180,$020
	dc.w	$3207,$FFFE
	dc.w	$180,$010
	dc.w	$3307,$FFFE
	dc.w	$180,$000

;	  /\  __ __ ______ __ __  /\ Mo!
;	_// \/  ____ _  _ ____  \/ \\_
;	\(_  \  \(O/      \O)/  /  _)/
;	 \/     _)/  _/\   \(_     \/
;	 /_ __        ··\    ______ \
;	(    (_____/\  _____/ | | |\ \
;	 \__________ \/   \_|_|_|_|_) )
;	            \ _______________/
;	             \/

BARRA:
	dc.w	$3407,$FFFE			; wir warten auf Zeile $34 (WAIT NORMAL!)
								; Dieses Warten ist der "CHEF" des Wartens
								; Nach Maskierungen folgen sie ihm
								; wie die Schergen: wenn das wait
								; um 1 sinkt , werden alle wait maskiert
								; Basiswert fällt um 1 usw.

	dc.w	$180,$300			; starte den roten Balken: rot mit 3

	dc.w	$00E1,$80FE			; Dieses Paar copperanweisungen, anstatt
	dc.w	$0007,$80FE			; mit $FFFE zu enden, enden sie mit $80FE
								; in der Praxis können sie übersetzt werden mit:
								; "WAIT FOR THE NEXT LINE", in diesem Fall
								; Bei der Zeile nach dem BARRA warten:.
								; Tatsächlich wartet der $00E180fE auf das Ende der
								; Zeile (zum rechten Rand des Bildschirms), die
								; was das copper zur nächsten Zeile auslöst
								; in die waagerechte Position 0001 (der
								; linke Bildschirmrand). Dazu zeigen Sie
								; auf "ausrichten", wir warten auf die Position
								; 0007 wie die anderen waits.

	dc.w	$180,$600			; rot mit 6

	dc.w	$00E1,$80FE			; AUF DIE NÄCHSTE ZEILE WARTEN
	dc.w	$0007,$80FE			; MIT dem "maskierten" Y-Wait

	dc.w	$180,$900			; rot mit 9

	dc.w	$00E1,$80FE			; AUF DIE NÄCHSTE ZEILE WARTEN
	dc.w	$0007,$80FE			; MIT dem "maskierten" Y-Wait

	dc.w	$180,$c00			; rot mit 12

	dc.w	$00E1,$80FE			; AUF DIE NÄCHSTE ZEILE WARTEN
	dc.w	$0007,$80FE			; MIT dem "maskierten" Y-Wait

	dc.w	$180,$f00			; rot mit 15 (maximal)

	dc.w	$00E1,$80FE			; AUF DIE NÄCHSTE ZEILE WARTEN
	dc.w	$0007,$80FE			; MIT dem "maskierten" Y-Wait

	dc.w	$180,$c00			; rot mit 12

	dc.w	$00E1,$80FE			; AUF DIE NÄCHSTE ZEILE WARTEN
	dc.w	$0007,$80FE			; MIT dem "maskierten" Y-Wait

	dc.w	$180,$900			; rot mit 9

	dc.w	$00E1,$80FE			; AUF DIE NÄCHSTE ZEILE WARTEN
	dc.w	$0007,$80FE			; MIT dem "maskierten" Y-Wait

	dc.w	$180,$600			; rot mit 6

	dc.w	$00E1,$80FE			; AUF DIE NÄCHSTE ZEILE WARTEN
	dc.w	$0007,$80FE			; MIT dem "maskierten" Y-Wait

	dc.w	$180,$300			; rot mit 3

	dc.w	$00E1,$80FE			; AUF DIE NÄCHSTE ZEILE WARTEN
	dc.w	$0007,$80FE			; MIT dem "maskierten" Y-Wait

	dc.w	$180,$000			; color schwarz


	dc.w	$fd07,$FFFE			; warten auf Zeile $FD
	dc.w	$180,$00a			; blau Intensität 10
	dc.w	$fe07,$FFFE			; nächste Zeile
	dc.w	$180,$00f			; blau Intensität maximal (15)
	dc.w	$FFFF,$FFFE			; Ende COPPERLIST


	end

In diesem Beispiel haben wir einige MOVEs gespart: Wir ändern nur 1 BYTE
pro Frame und scrollen eine ganze Bar! Dies dank der "Wait und Maske".
In der Praxis liegt der Grund in der Tatsache, das wir diese 2 Wait-Masken
eingesetzt haben:

	dc.w	$00E1,$80FE			; AUF DIE NÄCHSTE ZEILE WARTEN
	dc.w	$0007,$80FE			; MIT dem "maskierten" Y-Wait

Gehen wir zu der Zeile, die dem zuletzt definierten Wartezeit von $FFFE folgt,
und fügen die anderen Paare von $80fe hinzu dann können wir bei der ersten
Wartezeit viele Zeilen "erhalten". Trotz allem ist es ein wenig
gewöhnungsbedürftig, weil es einige Einschränkungen gibt, zum Beispiel
funktioniert es nicht für Zeilen nach 127 ($7f). Versuchen sie die maximal
erreichbare Zeile zu ändern:

VAIGIU:
	cmpi.b	#$77,BARRA			; sind wir an der Zeile $77?

Wenn Sie ein nettes $f0 setzen, werden Sie bemerken, das wenn der Balken die 
$80-Grenze überschritten hat flacht es ab und wird zu einer Linie.
Die Y-Koordinate muss von $00 bis $7f reichen, da wir nur 6 Bit maskieren
können. Besser als nichts !!!

Man kann also sagen, dass die Maskierung im oberen Teil des Bildschirms
von etwa $00 bis $7f und unterhalb der NTSC-Zone, dh nach dem $FFDF,$FFFE
arbeitet.