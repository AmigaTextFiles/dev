
; Listing8p9b.s		Fragen und Ratschläge zu CC-Anwendungen

	SECTION	CondC,CODE

AspettaMouse:
	move.b	$BFE001,d2
	and.b	#$40,D2				; $40 = %01000000, d.h. Bit 6
	bne.s	AspettaMouse
	RTS

	end

Wie kommt es, dass diese Routine richtig darauf wartet, dass die Maustaste
gedrückt wird, ohne irgendwelche BTST? Ich hoffe der Kommentar auf der Seite
und Ihre Kenntnis der CCs lässt Sie die Antwort vermuten.
Kommen wir nun zu einigen Anwendungen von "CC". Gehen Sie zurück zu Listing7.s,
das ein Sprite abprallen ließ. Hier ist diese Routine ohne das "btst", das
(unnötigerweise) das hohe Bit getestet hat, um festzustellen, ob die Zahl 
negativ geworden war:

; Diese Routine ändert die Koordinaten des Sprites durch Hinzufügen einer 
; konstanten Geschwindigkeit sowohl vertikal als auch horizontal. Auch wenn das 
; Sprite eine der Ränder berührt sieht die Routine vor, die Richtung umzukehren.

; Um diese Routine zu verstehen, muss bekannt sein, dass der Befehl "NEG" 
; benötigt wird um eine positive Zahl in eine negative Zahl umzuwandeln und 
; umgekehrt. Sie werden auch das das BPL nach einem ADD und nicht nach einem
; TST oder einem CMP bemerken. Jetzt wissen Sie warum:

MuoviSprite:
	move.w	sprite_y(PC),d0		; alte Position lesen
	add.w	speed_y(PC),d0		; Geschwindigkeit addieren
	bpl.s	no_tocca_sopra		; wenn > 0 ist es in Ordnung
	neg.w	speed_y				; Wenn < 0, haben wir den oberen Rand berührt
								; dann umgekehrte Richtung
	bra.s	Muovisprite			; berechnet die neue Position neu

no_tocca_sopra:
	cmp.w	#243,d0				; wenn die Position 256-13 = 243 ist,
								; berühret das Sprite den unteren Rand
	blo.s	no_tocca_sotto
	neg.w	speed_y				; Wenn das Sprite den unteren Rand berührt,
								; Geschwindigkeit umkehren
	bra.s	Muovisprite			; berechnet die neue Position neu

no_tocca_sotto:
	move	d0,sprite_y			; aktualisieren der Position
posiz_x:
	move.w	sprite_x(PC),d1		; alte Position lesen
	add.w	speed_x(PC),d1		; Geschwindigkeit addieren
	bpl.s	no_tocca_sinistra
	neg.w	speed_x				; Wenn < 0 links berührt: Richtung umkehren
	bra.s	posiz_x				; Neuberechnung der neuen Position horizontal

no_tocca_sinistra:
	cmp.w	#304,d1				; Wenn die Position 320-16 = 304 ist,
								; berühret das Sprite den rechten Rand
	blo.s	no_tocca_destra
	neg.w	speed_x				; Wenn es rechts berührt, Richtung umkehren
	bra.s	posiz_x				; Neuberechnung der neuen Position horizonzal

no_tocca_destra:
	move.w	d1,sprite_x			; aktualisieren der Position

	lea	miosprite,a1			; Adresse Sprite
	moveq	#13,d2				; Höhe Sprite
    bsr.s	UniMuoviSprite		; führt die universelle Routine aus, die 
              					; das Sprite positioniert
	rts

-	-	-	-	-	-	-	-	-	-

Jetzt sehen wir eine weitere mögliche Verwendung der CCs. Angenommen, wir
möchten einen vertikalen Bildlauf zu einer Biebene, unter Verwendung einer
anderen Routine, die die Adresse aus den bplpointers "holt" und 40 addiert
und sie wieder einsetzt.
Angenommen, diese Routine muss nur 40 zu bpl0ptl hinzufügen, d.h. zum
niedrigen Wort der Adresse. Das Problem entsteht, wenn wir uns zum Beispiel 
an der Adresse $2ffE2 befinden, so dass die Addition von 40 $??3000a ergeben
würde und auch das hohe Wort ändern würde.:

Copperlist:
	...
	dc.w	$e0					; bpl0pth
PlaneH:
	dc.w	$0002
	dc.w	$e2					; bpl0ptl
PlaneL:
	dc.w	$ffe2

Wie Sie sehen können, erhalten wir $000A, wenn wir 40 zu PlaneL addieren, aber 
PlaneH bleibt $0002! Aus diesem Grund nehmen wir jedes Mal die Adresse, addieren
sie hinzu und fügen sie wieder in die 2 Wörter zurück! 
Andernfalls, wenn das hohe Wort "zu schnappt", was würden wir tun?
Mit CC kann jedoch etwas getan werden. Wir sagten, dass $ffe2 + 40 uns die
genaue Lösung $000a gibt, aber es wird auch der Carry gesetzt, für den
Übertrag, da wir $ffff überschritten haben. Allo könnten wir schreiben:

Scroll:
	add.w	#40,PlaneL			; eine Zeile nach unten gehen, indem wir 40
								; zum unteren Wort der Adresse hinzufügen, auf
								; die der bpl1pt zeigt 
	bcc.s	NonScattato			; haben wir den enthaltenen Wert im Wort
								; überschritten? dann müssen wir auch das hohe
								; Wort ändern. Wenn nicht, spring ...
	addq.w	#1,PlaneH			; Ansonsten, addiere 1 in das hohe Wort, dh
								; den Übertrag der Addition auf die PlaneL
								; "ausführen"!
NonScattato:
	rts

Dies sind einige Beispiele dafür, wie Sie bereits bekannte Routinen
"überprüfen" können.

