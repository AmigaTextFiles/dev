
; Listing3h.s	LINKS-RECHTS-SCROLL MIT MOVE & WAIT DES COPPER

	SECTION CIPundCOP,CODE	; auch Fast ist	OK

Anfang:
	move.l	4.w,a6			; Execbase in a6
	jsr	-$78(a6)			; Disable - stoppt das Multitasking
	lea	GfxName,a1			; Adresse des Namen der zu öffnenden Library in a1
	jsr	-$198(a6)			; OpenLibrary, Routine der EXEC, die Libraris
							; öffnet, und als Resultat in d0 die Basisadresse
							; derselben Bibliothek liefert, ab welcher
							; die Offsets (Distanzen) zu machen sind
	move.l	d0,GfxBase		; speichere diese Adresse in GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; hier speichern wir die Adresse der Copperlist
							; des Betriebssystemes (immer auf $26 nach
							; GfxBase)
	move.l	#COPPERLIST,$dff080 ; COP1LC - "Zeiger" auf unsere COP
							; (deren Adresse)
	move.w	d0,$dff088	    ; COPJMP1 - Starten unsere COP
mouse:	
	cmpi.b	#$ff,$dff006	; VHPOSR - sind wir bei Zeile 255 angekommen?
	bne.s	mouse			; Wenn nicht, geh nicht weiter


	bsr.w	CopperLinkRech	; Routine für Links/Rechts Scroll

Warte:
	cmpi.b	#$ff,$dff006	; VHPOSR:
							; Sind wir noch auf $FF? Wenn ja, warte auf die
	beq.s	Warte			; nächste Zeile (00). Ansonsten wird CopperLinkRech


	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse			; wenn nicht, zurück zu mouse:

	move.l	OldCop(PC),$dff080	; COP1LC - "Zeiger" auf die Orginal-COP
	move.w	d0,$dff088		; COPJMP1 - und starten sie

	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable - stellt Multitasking wieder her
	move.l	GfxBase(PC),a1	; Basis der Library, die es zu schließen gilt
							; (Libraries werden geöffnet UND geschlossen!)
	jsr	-$19e(a6)			; Closelibrary - schließt die Graphics lib
	rts

; Die Routine ist die gleiche wie in Listing3g.s, mit dem einzigen Unterschied,
; daß 29 Wait statt einem mit einem DBRA-Loop verändert werden, das zu einem
; Wait springt, es ändert, zum Nächsten, es ändert usw.
	
CopperLinkRech:
	CMPI.W	#85,FlagRechts	; GehRechts 85 Mal ausgeführt?
	BNE.S	GehRechts		; wenn nicht, wiederhole nochmal
							; wenn es aber 85 Mal ausgeführt wurde,
							; dann geh weiter

	CMPI.W	#85,FlagLinks	; GehLinks 85 Mal ausgeführt?
	BNE.S	GehLinks		; wenn nicht, wiederhole nochmal

	CLR.W	FlagRechts		; Die Routine GehLinks wurde 85 Mal ausge-
	CLR.W	FlagLinks		; führt, also ist zu diesem Zeitpunkt der
						    ; graue Balken zurückgekommen und der Rechts-
						    ; Links-Zyklus ist fertig. Wir löschen die
						    ; zwei Flags und steigen aus: beim nächsten FRAME
						    ; wird GehRechts ausgeführt, nach 85 Frame
						    ; GehLinks 85 Mal, etcetera.
	RTS						; ZURÜCK ZUM MOUSE-LOOP
	
GehRechts:					; Diese Routine bewegt den Balken nach RECHTS
	lea	CopBar+1,A0			; Wir geben in A0 die Adresse des ersten XX-
							; Wertes des ersten Wait, das sich genau 1 Byte
							; nach CopBar befindet

	move.w	#29-1,D2		; wir müßen 29 Wait verändern (verwenden ein DBRA)
RechtsLoop:
	addq.b	#2,(a0)			; zählen 2 zu der X-Koordinate des Wait dazu
	ADD.W	#16,a0			; gehen zum nächsten Wait, das zu ändern ist
	dbra	D2,RechtsLoop   ; Zyklus wird d2-Mal durchlaufen
	addq.w	#1,FlagRechts   ; vermerken,daß wir ein weiteres Mal GehRechts 
			 				; ausgeführt haben
							; GehRechts: in FlagRechts steht die Anzahl,
							; wie oft wir GehRechts ausgeführt haben
	RTS						; Zurück zum Mouse-Loop


GehLinks:					; diese Routine bewegt den Balken nach LINKS
	lea	CopBar+1,A0
	move.w	#29-1,D2		; wir müßen 29 Wait verändern
LinksLoop:
	subq.b	#2,(a0)			; ziehen der X-Koordinate des Wait 2 ab
	ADD.W	#16,a0			; gehen zum nächsten Wait über, das zu verändern ist
	dbra	D2,LinksLoop	; Zyklus wird d2-Mal durchgeführt
	addq.w	#1,FlagLinks	; Zählen 1 zur Anzahl dazu, wie oft diese Routine
							; GehLinks ausgeführt wurde
	RTS						; Zurück zum Mouse-Loop

; Achtet auf etwas: wir ändern nur jedes zweite Wait, nicht alle Wait.
; Wir ändern hier nur die Hälfte, im Gegensatz zum Balken, der steigt und
; sinkt, wo ein Wait pro Zeile reicht:
;
;	dc.w	$YY07,$FFFE		; Wait Zeile YY, Anfang der Zeile (07)
;	dc.w	$180,$0RGB		; Farbe...
;	dc.w	$YY07,$FFFE		; Wait Zeile YY, Anfang der Zeile (07)
;	...
;
; In diesem Fall müßen wir zwei Wait pro Zeile schreiben,also eins für den
; Anfang der Zeile, und eins, das in dieser Zeile nach links-rechts läuft:
;
;	dc.w	$YY07,$FFFE		; Wait Zeile YY, Anfang der Zeile (07)
;	dc.w	$180,$0RGB		; Farbe GRAU
;	dc.w	$YYXX,$FFFE		; Wait Zeile YY, auf horizontaler Position,
;							; die wir entscheiden, lassen das GRAU
;							; gegenüber dem ROT vorrücken.
;	dc.w	$180,$0RGB		; ROT


FlagRechts:					; In diesem Word wird die Anzahl festgehalten,
	dc.w	0				; wie oft GehRechts ausgeführt wurde

FlagLinks:					; In diesem Word wird die Anzahl festgehalten,
	dc.w	0				; wie oft GehLinks ausgeführt wurde



GfxName:
	dc.b	"graphics.library",0,0  ; Bemerkung: um Charakter in den
							; Speicher zu geben, verwenden wir
							; immer das dc.b und setzen sie
							; unter "" oder '', Abschluß mit ,0


GfxBase:	    ; Hier hinein kommt die Basisadresse der graphics.library,
	dc.l	0   ; ab hier werden die Offsets gemacht



OldCop:			; Hier hinein kommt die Adresse der Orginal-Copperlist des
	dc.l	0	; Betriebssystemes


	SECTION GRAPHIC,DATA_C  ; Dieser Befehl veranlaßt das Betriebssystem,
							; das folgende Datensegment in die CHIP-RAM
							; zu laden, obligatorisch.
							; Die Cpperlist MÜSSEN in die CHIP RAM!


COPPERLIST:
	dc.w	$100,$200		; BPLCON0
	dc.w	$180,$000		; COLOR0 - Beginne die Cop mit SCHWARZ

	dc.w	$2c07,$FFFE		; WAIT - ein kleiner, fixer Balken in Grün
	dc.w	$180,$010		; COLOR0
	dc.w	$2d07,$FFFE		; WAIT
	dc.w	$180,$020		; COLOR0
	dc.w	$2e07,$FFFE		; WAIT
	dc.w	$180,$030		; COLOR0
	dc.w	$2f07,$FFFE		; WAIT
	dc.w	$180,$040		; COLOR0
	dc.w	$3007,$FFFE
	dc.w	$180,$030
	dc.w	$3107,$FFFE
	dc.w	$180,$020
	dc.w	$3207,$FFFE
	dc.w	$180,$010
	dc.w	$3307,$FFFE
	dc.w	$180,$000


	dc.w	$9007,$fffe		; Warten auf den Beginn der Zeile
	dc.w	$180,$000		; Grau auf Minimum, also SCHWARZ!
CopBar:
	dc.w	$9031,$fffe		; Wait, das geändert wird ($9033,$9035,$9037...)
	dc.w	$180,$100		; Farbe Rot, die immer weiter rechts beginnen
							; wird, vorangegangen vom Grau, das dementsprechend
							; fortschreiten wird
	dc.w	$9107,$fffe		; Wait, das nicht geändert wird (Beginn der Zeile)
	dc.w	$180,$111		; Farbe GRAU (startet beim Beginn der Zeile bis
	dc.w	$9131,$fffe		; zu diesem WAIT, das wir nicht ändern werden...
	dc.w	$180,$200		; danach beginnt das ROT

;	wir fahren fort, aber platzsparend. Beachtet das Schema:

; Bemerke: mit einem "dc.w $1234" geben wir 1 Word in den Speicher, mit
; "dc.w $1234,$1234"
; hingegen zwei Word hintereinander, also ein Longword "dc.l $12341234"
; das auch folgends in den Speicher kommen konnte:
; "dc.b $12,$34,$12,$34", folglich können wir auch 8 oder mehr Words mit
; nur einem dc.w in den Speicher geben!
; Z.B. die Zeile 3 könnte mit einem dc.l so umgeschrieben werden:
;	dc.l	$9207fffe,$1800222,$9231fffe,$1800300   also:
;	dc.l	$9207fffe,$01800222,$9231fffe,$01800300 mit den
;		*anfänglichen* Nullen
; Paßt auf diese Anfangsnullen auf! Ein  dc.w $0180 schreibe ich als
; dc.w $180, weil es so einfach bequemer ist, aber die NULL existiert,
; das muß beachtet werden!
; Um alles noch klarer zu gestalten, die Zeile 3 würde mitsamt ihren Nullen
; so aussehen:
;	dc.w	$9207,$fffe,$0180,$0222,$9231,$fffe,$0180,$0300 (1 Word =$xxxx)
; Praktisch gesehen, kann man die "unnützen" Nullen des .b, .w, .l als
; Optional hinschreiben
;
;		FIXE WAIT (dann Grau)-VERÄNDERB. WAIT (gefolgt vom Rot)

	dc.w	$9207,$fffe,$180,$222,$9231,$fffe,$180,$300 ; Zeile 3
	dc.w	$9307,$fffe,$180,$333,$9331,$fffe,$180,$400 ; Zeile 4
	dc.w	$9407,$fffe,$180,$444,$9431,$fffe,$180,$500 ; Zeile 5
	dc.w	$9507,$fffe,$180,$555,$9531,$fffe,$180,$600 ; ....
	dc.w	$9607,$fffe,$180,$666,$9631,$fffe,$180,$700
	dc.w	$9707,$fffe,$180,$777,$9731,$fffe,$180,$800
	dc.w	$9807,$fffe,$180,$888,$9831,$fffe,$180,$900
	dc.w	$9907,$fffe,$180,$999,$9931,$fffe,$180,$a00
	dc.w	$9a07,$fffe,$180,$aaa,$9a31,$fffe,$180,$b00
	dc.w	$9b07,$fffe,$180,$bbb,$9b31,$fffe,$180,$c00
	dc.w	$9c07,$fffe,$180,$ccc,$9c31,$fffe,$180,$d00
	dc.w	$9d07,$fffe,$180,$ddd,$9d31,$fffe,$180,$e00
	dc.w	$9e07,$fffe,$180,$eee,$9e31,$fffe,$180,$f00
	dc.w	$9f07,$fffe,$180,$fff,$9f31,$fffe,$180,$e00
	dc.w	$a007,$fffe,$180,$eee,$a031,$fffe,$180,$d00
	dc.w	$a107,$fffe,$180,$ddd,$a131,$fffe,$180,$c00
	dc.w	$a207,$fffe,$180,$ccc,$a231,$fffe,$180,$b00
	dc.w	$a307,$fffe,$180,$bbb,$a331,$fffe,$180,$a00
	dc.w	$a407,$fffe,$180,$aaa,$a431,$fffe,$180,$900
	dc.w	$a507,$fffe,$180,$999,$a531,$fffe,$180,$800
	dc.w	$a607,$fffe,$180,$888,$a631,$fffe,$180,$700
	dc.w	$a707,$fffe,$180,$777,$a731,$fffe,$180,$600
	dc.w	$a807,$fffe,$180,$666,$a831,$fffe,$180,$500
	dc.w	$a907,$fffe,$180,$555,$a931,$fffe,$180,$400
	dc.w	$aa07,$fffe,$180,$444,$aa31,$fffe,$180,$300
	dc.w	$ab07,$fffe,$180,$333,$ab31,$fffe,$180,$200
	dc.w	$ac07,$fffe,$180,$222,$ac31,$fffe,$180,$100
	dc.w	$ad07,$fffe,$180,$111,$ad31,$fffe,$180,$000
	dc.w	$ae07,$fffe,$180,$000

;		FIXE WAIT (dann Grau)-VERÄNDERB. WAIT (gefolgt vom Rot)

;	Wie ihr seht, braucht es für jede Zeile zwei Wait, eines, das den
;	Anfang der Zeile abwartet, und eines, das, das wir dauernd verändern,
;	um den Punkt zu definieren, bei dem der Farbwechsel Grau/Rot
;	stattfinden soll, also zwischen dem Grau, das ab Position 07
;	besteht, und dem Rot, das nach diesem Wait startet.

	dc.w	$fd07,$FFFE		; warte Zeile $FD ab
	dc.w	$180,$00a		; BLAU Helligkeit 10
	dc.w	$fe07,$FFFE		; nächste Zeile
	dc.w	$180,$00f		; Blau maximale Helligkeit (15)
	dc.w	$FFFF,$FFFE		; ENDE DER COPPERLIST


	end


Letzte  Kleinigkeit:  wenn ihr die Sache mit den Anfangs-Nullen noch nicht
ganz  klar  habt,  dann  hier  einige  "richtige"  und  einige   "falsche"
Umrechnungen:


	dc.b 1,2	= dc.w	$0102   oder   dc.w	$102

	dc.b 42,$2	= dc.w	$2a02   (42 dezimal = $2a Hex)

	dc.b 12,$2,$12,41 = dc.w $c02,$1229 = dc.l $c021229

	dc.b 12,$22,0	= dc.w	$000c,$2200 = dc.w $c,$2200 = dc.l $c2200

	dc.w 1,2,3,432	= dc.l	$00010002,$000301b0 = dc.l $10002,$301b0

	dc.l $1234567	= dc.b	1,$23,$45,$67

	dc.l $2342	= dc.b	0,0,$23,$42

	dc.l 4		= dc.b	0,0,0,4

	Achtung letztes Beispiel:

	ein dc.l 4 wird im Speicher zu $00000004, ein dc.b 4 zu $04,
	wenn ich also 04 in das dc.l gebe, wird es von vier Bytes $00
	vorangegangen, im Falle des dc.b 4 positioniert sich die 4
	an erste Stelle, was in ASSEMBLER etwas komplett anderes ist,
	obwohl man immer von 4 spricht!!!!

