
; Lezione11h3.s	- coppereffekt VORBERECHNET !!! 50 vorberechnete copperlisten
			; werden nacheinander mit COP2LC ($dff084) angezeigt.

	SECTION	BarrexPrecalc,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s" ; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001010000000	; nur copper DMA

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:
	bsr.w	precalcop	; Routine welche 50 copperlisten kalkuliert
		; das macht eine vollständige "Schleife" des Effekts

	lea	$dff000,a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren copper
	move.l	#OURCOPPER,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$12000,d2	; warte auf Zeile $120
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; warte auf Zeile $120
	BNE.S	Waity1

	btst	#2,$dff016	; richtige Taste gedrückt?
	beq.w	Mouse2		; wenn ja SwappaCoppero nicht ausführen

	bsr.w	SwappaCoppero	; Zeigen Sie auf die nächste copperliste für
						; die korrekte "Animation" des Effekts.

mouse2:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$12000,d2	; warte auf Zeile $120
Aspetta:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; warte auf Zeile $120
	BEQ.S	Aspetta

	btst	#6,$bfe001	; Maus gedrückt?
	bne.s	mouse
	rts


******************************************************************************
; Routine SWAP der vorberechneten copperliste .. (eine Animation !!!)
******************************************************************************

;	      \||||/
;	      (·)(·)
;	   ___\ \/ /___
;	  (_   \__/   _)
;	  /   .        \
;	 /    |Stz!\_   \
;	(_____| ___(_____)
;	 (___)      (___)
;	   ¡   \_    ¡
;	   |_   |   _|
;	   |    ;    |
;	   |    |    |
;	 __(____|____)__
;	(_______:_______)
 

SwappaCoppero:
	MOVE.L	copbufpunt(PC),D0
	lea	coppajumpa,a0	; Adresszeiger auf cop2 in coplist
	MOVE.W	D0,6(A0)	; Zeiger auf den aktuellen Frame
	SWAP	D0
	MOVE.W	D0,2(A0)
	ADD.L	#(linee*8)+AGGIUNTE,COPBUFPUNT	; zeigt auf WEITER COP
	MOVE.L	copbufpunt(PC),D0
	cmp.l	#finebuffoni,d0		; sind wir am letzten copper?
	bne.w	NonRibuffona		; Wenn noch nicht, ok
	move.l	#copbuf1,copbufpunt	; sonst geh ab dem ersten!
NonRibuffona:
	rts

******************************************************************************
; 		Routine vorberrechneter copper-Effekt
******************************************************************************

;	/\____/\
;	\(O..O)/
;	 (----)
;	  TTTT Mo!

LINEE		equ	211
AGGIUNTE	equ	20		; LÄNGE DER HINZUGEFÜGTEN TEILE UNTEN...
NUMBUFCOPPERI	equ	50	; Anzahl frame/copperlist!!!

PrecalCop:

; Jetzt erstellen wir die copperlist.

	lea	copbuf1,a0		; Adresse Puffer wo wir die cops bearbeiten
	move.w	#NUMBUFCOPPERI-1,d7	; Anzahl der vorzuberechnenden copperlisten
FaiBuf:
	bsr.w	FaiCopp1		; Mach eine copperlist
	add.w	#(linee*8)+AGGIUNTE,a0	; zeige auf die nächste
	dbra	d7,FaiBuf		; mache alle Frames

; Jetzt "füllen" wir sie, als würden wir den Effekt in Echtzeit ausführen.
	
	lea	copbuf1,a0		; Adresse der ersten vorberechneten copperliste
	move.w	#NUMBUFCOPPERI-1,d7	; Anzahl cops zu "füllen" 
ribuf:
 	BSR.s	changecop	; Rufen Sie die Routine auf, die den copper ändert 
	add.w	#(linee*8)+AGGIUNTE,a0 ; springe zum nächsten, um ihn zu füllen
	dbra	d7,riBuf	; Füllen Sie alle copperlists


; Schließlich richten wir die copperlisten in den Zeigern in copperlist!!!

	MOVE.L	#copbuf1,D0	; erstes "frame" copper2
	lea	coppajumpa,a0	; Zeiger auf das Ende copper1
	MOVE.W	D0,6(A0)	; ...
	SWAP	D0
	MOVE.W	D0,2(A0)

	MOVE.L	#ourcopper,D0	; copper1 Anfang
	lea	coppajumpa2,a0	; Zeiger auf das Ende des "Pezzofinale"
	MOVE.W	D0,6(A0)	; zu dem der copper2 springt
	SWAP	D0
	MOVE.W	D0,2(A0)
	rts

******************************************************************************
; Routine die eine copperlist erstellt
******************************************************************************

FaiCopp1:
	move.l	a0,-(SP)	
	MOVE.L	#$2c07fffe,d1	; copper wait Anweisung, beginnt mit
							; warten auf Zeile $2c
	MOVE.L	#$1800000,d2	; $dff180 = color 0 für copper
	MOVE.w	#LINEE-1,d0		; Anzahl der Zeilen der Schleife
	MOVEQ	#$000,d3		; Farbe setzen = schwarz
coploop:
	MOVE.L	d1,(a0)+		; setzen des WAIT
	MOVE.L	d2,(a0)+		; setzen des $180 (color0) auf SCHWARZ gelöscht
	ADD.L	#$01000000,d1	; eine Zeile tiefer mit WAIT 1 warten
	DBRA	d0,coploop		; Wiederholen Sie diesen Vorgang bis zum Ende der Zeilen
	move.l	finPunt(PC),d0	; pezzofinale, zu dem alles copper2 springt
							; als frame verwendet.
	MOVE.w	#$82,(A0)+		; TEILFINALE Zeiger - COP1LC
	move.w	d0,(a0)+
	swap	d0
	MOVE.w	#$80,(A0)+
	move.w	d0,(a0)+
	move.l	#$880000,(a0)+	; COPJMP1 - springe zum letzten Stück, welches
		; dann copper1 wird als erster copper wieder hergestellt!
	move.l	(SP)+,a0
	rts

CopBufPunt:
	dc.l	copbuf1
FinPunt:
	dc.l	pezzofinale

******************************************************************************
; Routine ändert die Farben in einer copperlist
******************************************************************************

changecop:
	move.l	a0,-(SP)	; a0 auf dem stack speichern
	MOVE.w	#LINEE-1,d0	; Anzahl der Zeilen der Schleife
	MOVE.L	PuntatoreTABCol(PC),a1	; Beginn der Farbtabelle in a1
	move.l	a1,PuntatTemporaneo	; gespeichert in PuntatoreTemporaneo
	moveq	#0,d1			; d1 löschen
LineeLoop:
	move.w	(a1)+,6(a0)	; Kopieren Sie die Farbe aus der Tabelle in die copperlist
	addq.w	#8,a0		; nächste color0 in copperlist
	addq.b	#1,d1		; Ich notiere die Länge des Unterstrichs in d1
 	cmp.b	#9,d1		; Ende der Unterleiste?
	bne.s	AspettaSottoBarra

	MOVE.L	PuntatTemporaneo(PC),a1
	addq.w	#2,a1			; Punkt nach färben
	cmp.l	#FINETABColBarra,PuntatTemporaneo	; sind wir am Ende der Tabelle?
	bne.s	NonRipartire		; wenn noch nicht, gehe zu NonRipartire
	lea	TABColoriBarra(pc),a1	; ansonsten ab dem ersten col!
NonRipartire:
	move.l	a1,PuntatTemporaneo	; und speichern Sie den Wert vorübergehend in Pun. temporaneo
	moveq	#0,d1			; d1 löschen
AspettaSottoBarra:
	dbra d0,LineeLoop		; Mach alle Zeilen

	addq.l	#2,PuntatoreTABCol		 ; nächste colore
	cmp.l	#FINETABColBarra+2,PuntatoreTABCol ; wir sind am ende der Farbtabelle?						 
	bne.s FineRoutine			 ; wenn nicht, raus, sonst...
	move.l #TABColoriBarra,PuntatoreTABCol	 ; ab dem ersten Wert von
						 ; TABColoriBarra
FineRoutine:
	move.l	(SP)+,a0	; setze a0 vom Stapel fort
	rts

; Tabelle mit RGB-Farbwerten. In diesem Fall handelt es sich um Blautöne

TABColoriBarra:
	dc.w	$000,$001,$002,$003,$004,$005,$006,$007
	dc.w	$008,$009,$00A,$00B,$00C,$00D,$00D,$00E
	dc.w	$00E,$00F,$00F,$00F,$00E,$00E,$00D,$00D
	dc.w	$00C,$00B,$00A,$009,$008,$007,$006,$005
	dc.w	$004,$003,$002,$001,$000,$000,$000,$000
	dcb.w	10,$000
FINETABColBarra:
	dc.w	$000,$001,$002,$003,$004,$005,$006,$007	; Diese Werte werden benötigt
	dc.w	$008,$009,$00A,$00B,$00C,$00D,$00D,$00E ; für die Nebenstangen
	dc.w	$00E,$00F,$00F,$00F,$00E,$00E,$00D,$00D
	dc.w	$00C,$00B,$00A,$009,$008,$007,$006,$005
	dc.w	$004,$003,$002,$001,$000,$000,$000,$000


PuntatTemporaneo:
 	dc.l	TABColoriBarra

PuntatoreTABCol:
 	DC.L	TABColoriBarra

***************************************************************************

	SECTION	GRAPH,DATA_C

ourcopper:
Copper2:
	dc.w	$180,$000	; Color0 - schwarz
	dc.w	$100,$200	; BplCon0 - keine bitplanes

; Hier können Sie Spritepointers, Colors, Bplpointers und so weiter setzen...


coppajumpa:
	dc.w	$84		; COP2LCh
	DC.W	0
	dc.w	$86		; COP2LCl
	DC.W	0
	DC.W	$8a,0	; COPJMP2 - starte den cop2 (frame)

* * * * * * 

pezzofinale:			; zu diesem Stück springt das copper2 zu seinem
	dc.w	$ffdf,$fffe	; Ende, jedes Bild der Animation...
	dc.w	$0107,$fffe
	dc.w	$180,$010
	dc.w	$0207,$fffe
	dc.w	$180,$020
	dc.w	$0307,$fffe
	dc.w	$180,$030
	dc.w	$0507,$fffe
	dc.w	$180,$040
	dc.w	$0707,$fffe
	dc.w	$180,$050
	dc.w	$0907,$fffe
	dc.w	$180,$060
	dc.w	$0c07,$fffe
	dc.w	$180,$070
	dc.w	$0f07,$fffe
	dc.w	$180,$080
	dc.w	$1207,$fffe
	dc.w	$180,$090
	dc.w	$1607,$fffe
	dc.w	$180,$0a0
	dc.w	$1a07,$fffe
	dc.w	$180,$0b0
	dc.w	$1f07,$fffe
	dc.w	$180,$0c0
	dc.w	$2607,$fffe
	dc.w	$180,$0d0
	dc.w	$2c07,$fffe
	dc.w	$180,$0e0

coppajumpa2:
	dc.w	$80	; COP1lc für Neustart der copperlist von ourcopper
	DC.W	0
	dc.w	$82	; COP2Lcl
	DC.W	0
	;DC.W	$88,0	; COPJMP1
	dc.w	$FFFF,$FFFE	; Ende copperlist
finepezzofinale:


	section	bufcopperi,bss_C

copcols:
copbuf1:
	ds.b	((linee*8)+AGGIUNTE)*NUMBUFCOPPERI	; 50 copperlist!
finebuffoni:

	end

Wenn Sie den Coppereffekt vorberechnen, werden die Multiplikationen, die Koordinaten
der 3D-Vektoren, Musik ... Sie können eine Demo erstellen, die den Prozessor frei 
lässt um einen nicht vorberechneten Effekt zu machen !!!! HAHAHAHA!

Beachten Sie, wenn Sie von copper1 zu copper2 springen, das Sie an dessen Ende 
zum "pezzofinale" copper springen, das es copper1 als Ausgangscopper nimmt!
Lasst uns also das copper zweimal aufbauen und nicht einmal wie in Lektion 11h.s