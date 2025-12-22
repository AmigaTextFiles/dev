
; Listing3e.s	Scrolleffekt eines farbververlaufenen Hintergrundes
	
;	Routine wird einmal alle drei Frames ausgeführt

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
	move.l	#MeinCopper,$dff080  ; COP1LC - "Zeiger" auf unsere COP
							; (deren Adresse)
	move.w	d0,$dff088	    ; COPJMP1 - Starten unsere COP
mouse:
	cmpi.b	#$ff,$dff006	; VHPOSR - sind wir bei Zeile 255 angekommen?
	bne.s	mouse			; Wenn nicht, geh nicht weiter

frame:
	cmpi.b	#$fe,$dff006	; Sind wir auf Zeile 254? (muß die Runde nochmal
	bne.s	frame			; drehen!) Wenn nicht, geh nicht weiter
	
frame2:
	cmpi.b	#$fd,$dff006	; Sind wir auf Zeile 253? (muß die Runde nochmal
	bne.s	frame2			; drehen!) Wenn nicht, geh nicht weiter


	bsr.s	ScrollColors	; Eine sogenannte RASTERBAR!


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

;	Diese Routine läßt die 14 Farben unserer grünen Copperlist "fließen",
;	das einem dauernden nach-oben-Fließen gleicht, so, als ob wir aus
;	einem Fenster schauen würden und dauernd farbverschwommene Balken
;	rauffliegen sehen würden. Praktisch gesehen tue ich nichts anderes
;	als die Farben zu verschieben, indem ich die zweite in die erste
;	kopiere, die dritte in die zweite etc, so als hätte ich eine Reihe
;	von farbigen Murmeln: stellt euch vor, ihr nehmt die erste und steckt
;	sie in einen Sack, dann gebt ihr die zweite in das "Loch", das durch
;	das Verschwinden der ersten entstanden ist. Ihr fahrt fort, bis ihr
;	bei der letzten angekommen seid, und die vierzehnte Kugel in das
;	"Loch" der dreizehnten gebt. Nun hängt ihr hinten wieder die erste
;	Kugel an, die ihr ja in den Sack gesteckt hattet. Zu Bemerken ist
;	die letzte Anweisung, die ein "move.w col1,col14 ist", also das
;	Loch stopft, nachdem es von der ersten Position in die letzte geschoben
;	worden ist. Es bildet sich ein Endlos-zyklus, ähnlich einer
;	Fahrradkette:
;
;	>>>>>>>>>>>>>>>>>>>>>
;	^		    v
;	<<<<<<<<<<<<<<<<<<<<
;
;	aber ohne dem unteren Teil der Kette: einfach dann, wenn ein Glied
;	der Kette am Ende (v)angekommen ist, wird es in die erste Position
;	kopiert (^), und ermöglicht somit die Endlosschleife:
;
;	>>>>>>>>>>>>>>>>>>>>>  
;	^		    v
;
;	Um die Routine zu unterbrechen, reicht es, einen x-bliebigen Befehl
;	zu streichen, der mit dem Kopieren zu tun hat, indem ihr z.B. einen
;	Strichpunkt vorne hingebt, in etwa vor dem (move.w col2,col1), und
;	ihr werdet bemerken, daß nur ein Durchgang gemacht wird, und dann
;	alles stehen bleibt, danach enden die Farben, da die "Kette
;	unterbrochen" wurde, und sie keine Vorgängerfarbe mehr liefert.


Scrollcolors:
	move.w	col2,col1		; col2 kommt in col1
	move.w	col3,col2		; col3 kommt in col2
	move.w	col4,col3		; col4 kommt in col3
	move.w	col5,col4		; col5 kommt in col4
	move.w	col6,col5		; col6 kommt in col5
	move.w	col7,col6		; col7 kommt in col6
	move.w	col8,col7		; col8 kommt in col7
	move.w	col9,col8		; col9 kommt in col8
	move.w	col10,col9		; col10 kommt in col9
	move.w	col11,col10		; col11 kommt in col10
	move.w	col12,col11		; col12 kommt in col11
	move.w	col13,col12		; col13 kommt in col12
	move.w	col14,col13		; col14 kommt in col13
	move.w	col1,col14		; col1 kommt in col14
	rts

GfxName:
	dc.b	"graphics.library",0,0	; Bemerkung: um Charakter in den
							; Speicher zu geben, verwenden wir
							; immer das dc.b und setzen sie
							; unter "" oder ´´, Abschluß mit ,0

GfxBase:	    ; Hier hinein kommt die Basisadresse der graphics.library,
	dc.l	0   ; ab hier werden die Offsets gemacht



OldCop:			; Hier hinein kommt die Adresse der Orginal-Copperlist des
	dc.l	0	; Betriebssystemes



;=========== Copperlist ==========================


	section cop,data_C

MEINCOPPER:
	dc.w	$100,$200		; BPLCON0 - Screen ohne Bitplanes, nur die
							; Hintergrundfarbe $180 ist sichtbar

	DC.W	$180,$000		; COLOR0 - wir beginnen mit SCHWARZ

	dc.w	$9a07,$fffe		; warten auf Zeile 154 ($9a in Hexadezimal)
	dc.w	$180			; REGISTER COLOR0
col1:
	dc.w	$0f0			; Wert von COLOR 0 (das verändert wird)
	dc.w	$9b07,$fffe		; warten auf Zeile 155 (wird nicht verändert)
	dc.w	$180			; REGISTER COLOR0 (wird nicht verändert)
col2:
	dc.w	$0d0			; Wert von COLOR 0 (wird verändert)
	dc.w	$9c07,$fffe		; warten auf Zeile 156 (wird nicht verändert.)
	dc.w	$180			; REGISTER COLOR0
col3:
	dc.w	$0b0			; Wert von COLOR 0
	dc.w	$9d07,$fffe		; warten auf Zeile 157
	dc.w	$180			; REGISTER COLOR0
col4:
	dc.w	$090			; Wert von COLOR 0
	dc.w	$9e07,$fffe		; warten auf Zeile 158
	dc.w	$180			; REGISTER COLOR0
col5:
	dc.w	$070			; Wert von COLOR 0
	dc.w	$9f07,$fffe		; warten auf Zeile 159
	dc.w	$180			; REGISTER COLOR0
col6:
	dc.w	$050			; Wert von COLOR 0
	dc.w	$a007,$fffe		; warten auf Zeile 160
	dc.w	$180			; REGISTER COLOR0
col7:
	dc.w	$030			; Wert von COLOR 0
	dc.w	$a107,$fffe		; warten auf Zeile 161
	dc.w	$180			; color0... (nun habt ihr schon verstanden,
col8:						; ab hier gebe ich keinen Kommentar mehr!)
	dc.w	$030
	dc.w	$a207,$fffe		; Zeile 162
	dc.w	$180
col9:
	dc.w	$050
	dc.w	$a307,$fffe		; Zeile 163
	dc.w	$180
col10:
	dc.w	$070
	dc.w	$a407,$fffe		; Zeile 164
	dc.w	$180
col11:
	dc.w	$090
	dc.w	$a507,$fffe		; Zeile 165
	dc.w	$180
col12:
	dc.w	$0b0
	dc.w	$a607,$fffe		; Zeile 166
	dc.w	$180
col13:
	dc.w	$0d0
	dc.w	$a707,$fffe		; Zeile 167
	dc.w	$180
col14:
	dc.w	$0f0
	dc.w	$a807,$fffe		; Zeile 168

	dc.w	$180,$0000		; Wählen Schwarz für den letzten Teil
							; des Bildschirms unter dem Effekt

	DC.W	$FFFF,$FFFE		; Ende der Copperlist

	END



Änderungen: Probiert folgende Anweisung am Ende der Routine "Scrollcolors"
anzuhängen,  und ihr werdet eine Farbveränderung feststellen ( indem ihr 1
zur RED-Komponente dazuaddiert, also zum Rot).

	add.w	#$100,col13

Probiert,  den  Wert  zu  variiern,   um   andere   Farbkombinationen   zu
produzieren.  Klar, es ist eine recht wage Art, Farbverläufe herzustellen,
aber es ist recht gut, um zu sehen, ob man die Routinen verstanden hat.


