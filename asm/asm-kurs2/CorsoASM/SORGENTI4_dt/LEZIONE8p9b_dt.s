
; Lezione8p9b.s		Fragen und Ratschläge zu CC-Anwendungen

	SECTION	CondC,CODE

AspettaMouse:
	move.b	$BFE001,d2
	and.b	#$40,D2		; $40 = %01000000, d.h. Bit 6
	bne.s	AspettaMouse
	RTS

	end

Wie kommt es, dass diese Routine richtig darauf wartet, dass die Maus gedrückt
wird, ohne irgendwelche BTST? Ich hoffe der Kommentar auf der Seite und Ihre 
Kenntnis der CCs dort lässt uns die Antwort annehmen.
Wir kommen zu einigen Anwendungen von "cc". Geh und hol die Lektion 7s
ein Sprite hüpfen. Hier ist diese Routine ohne das "Btst"
sie testeten (unnötigerweise) das hohe Bit, um festzustellen, ob die Zahl 
negativ geworden war:

; Diese Routine ändert die Koordinaten des Sprites durch Hinzufügen einer 
; konstant Geschwindigkeit sowohl vertikal als auch horizontal. Auch wenn das 
; Sprite eine der Kanten berührt sieht die Routine vor, die Richtung umzukehren.

; Um diese Routine zu verstehen, muss bekannt sein, dass der Befehl "NEG" 
; benötigt wird um eine positive Zahl in eine negative Zahl umzuwandeln und 
; umgekehrt. Sie werden es auch bemerken auch eine BPL nach einem ADD und 
; nicht nach einem TST oder einem CMP. Jetzt wissen Sie warum:

MuoviSprite:
	move.w	sprite_y(PC),d0	; Lies die alte Position
	add.w	speed_y(PC),d0	; addiere die Geschwindigkeit
	bpl.s	no_tocca_sopra	; wenn> 0 ist in Ordnung
	neg.w	speed_y			; Wenn <0, haben wir die obere Kante berührt
							; dann umgekehrte Richtung
	bra.s	Muovisprite		; berechnet die neue Position neu

no_tocca_sopra:
	cmp.w	#243,d0	; Wenn die Position 256-13 = 243 ist, wird das Sprite
					; Berühren Sie die untere Kante
	blo.s	no_tocca_sotto
	neg.w	speed_y		; Wenn das Sprite die untere Kante berührt,
						; Geschwindigkeit umkehren
	bra.s	Muovisprite	; erobere die neue Position wieder

no_tocca_sotto:
	move	d0,sprite_y	; Aktualisieren Sie die Position
posiz_x:
	move.w	sprite_x(PC),d1	; Lies die alte Position
	add.w	speed_x(PC),d1	; addiere die Geschwindigkeit
	bpl.s	no_tocca_sinistra
	neg.w	speed_x		; Wenn <0 nach links tippen: umgekehrte Richtung
	bra.s	posiz_x		; Neuberechnung der neuen Position oriz.

no_tocca_sinistra:
	cmp.w	#304,d1	; Wenn die Position 320-16 = 304 ist, ist das Sprite
					; Berühre den rechten Rand
	blo.s	no_tocca_destra
	neg.w	speed_x		; Wenn es sich nach rechts berührt, kehren Sie die Richtung um
	bra.s	posiz_x		; Neuberechnung der neuen Position oriz.

no_tocca_destra:
	move.w	d1,sprite_x	; Aktualisieren Sie die Position

	lea	miosprite,a1	; Adresse sprite
	moveq	#13,d2		; Höhe sprite
        bsr.s	UniMuoviSprite  ; führt die universelle Routine aus, die 
              			 ; das Sprite positioniert
	rts

-	-	-	-	-	-	-	-	-	-

Jetzt sehen wir eine andere mögliche Verwendung von CCs. Angenommen, wir möchten einen 
vertikalen Bildlauf zu einer Bitebene machen mit einer anderen als der angegebenen 
Routine. Es "nimmt" die Adresse von den bplpointers, adda 40 und gewinnt sie wieder.
Angenommen, diese Routine muss nur 40 zu bpl0ptl hinzufügen, d.H. Zu
niedriges Wort der Adresse. Das Problem entsteht, wenn wir uns zum Beispiel 
bei der $2ffE2-Adresse befinden, würde also Adda 40 zu $​​3000a gehen, und sogar das 
hohe Wort ändern.:

Copperlist:
	...
	dc.w	$e0	; bpl0pth
PlaneH:
	dc.w	$0002
	dc.w	$e2	; bpl0ptl
PlaneL:
	dc.w	$ffe2

Wie Sie sehen können, erhalten wir $000A, wenn wir PlaneL um 40 erhöhen, aber 
PlaneH bleibt $0002! Aus diesem Grund nehmen wir die Adresse jedes Mal, fügen
sie hinzu und geben sie wieder als 2 Wörter zurück! Andernfalls, wenn das hohe 
Wort "schnappt", was würden wir tun?
Mit CC kann jedoch etwas getan werden. Wir sagten, dass uns $ffe2 + 40 gibt
die genaue Lösung, $000a, aber der Carry ist auch festgelegt, für den Übertrag,
gegeben dass wir $ffff überschritten haben. Allo könnten wir schreiben:

Scroll:
	add.w	#40,PlaneL	; Steigen Sie aus einer Linie aus, indem Sie 40  
				; zum unteren Wort der Adresse hinzufügen, auf die der
				; bpl1pt zeigt
	bcc.s	NonScattato	; Wir haben den umschließbaren Wert überschritten
						; aus dem Wort und wir müssen auch ändern
						; das hohe Wort? Wenn nicht, spring ...
	addq.w	#1,PlaneH	; Ansonsten ist das hohe Wort adda 1, das heißt
						; Add-On-Report auf dem PlaneL "ausführen"!
NonScattato:
	rts

Dies sind einige Beispiele dafür, wie Sie bereits bekannte Routinen "überprüfen" können.

