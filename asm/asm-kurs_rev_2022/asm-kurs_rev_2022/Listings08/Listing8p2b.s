
; Listing8p2b.s		Erweiterung des Vorzeichens in den Adressregistern

	SECTION	CondC,CODE

Inizio:
	move.l	#$ffffffff,a0		; dass ist "move.l #-1,a0"
	move.w	#$51a7,a0
stop:
	rts

	end

;            \|/
;           (©_©)
;--------ooO-(_)-Ooo--------

In diesem Listing werden wir uns mit einer anderen Besonderheit der direkten
Adressierung zum Adressregister befassen.
Wir führen eine Anweisung zu einem Zeitpunkt des oben gezeigten Programms aus.
Der erste MOVE lädt einen 32-Bit-Wert in A0.

D0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
A0: FFFFFFFF 00000000 00000000 00000000 00000000 00000000 00000000 07C9F584
SSP=07CA06B7 USP=07C9F584 SR=8000 T1 -- PL=0 ----- PC=07CA1F8E
PC=07CA1F8E 307C0100		 MOVE.W  #$51A7,A0
>

Das Register A0 hat wie erwartet den Wert $FFFFFFFF angenommen. Jetzt lassen
sie uns den zweiten Move machen. Beachten Sie, dass ein 16-Bit-Wert in A0
geladen wird.
Wir würden erwarten, dass nur das niedrige Wort von A0 geändert wird.
Stattdessen können wir überprüfen, dass das High Word ebenfalls geändert wurde:

D0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
A0: 000051A7 00000000 00000000 00000000 00000000 00000000 00000000 07C9F584
SSP=07CA06B7 USP=07C9F584 SR=8000 T1 -- PL=0 ----- PC=07CA1F92
PC=07CA1F92 4E75		 RTS
>

Dies geschieht, weil beim Schreiben in ein Adressregister ein WORT 
(Denken Sie daran, dass es NICHT möglich ist, ein einzelnes BYTE zu
schreiben, d.h. die Anweisung MOVE.B xxxx,Ax ist NICHT erlaubt.) in ein
LANGWORT durch eine Operation namens "Vorzeichenerweiterung", die darin
besteht, das beim Kopieren das höchstwertige Bit des WORTES (dh Bit 15)
in das hohe Wort erweitert wird.
Wie Sie wissen, wird das Vorzeichen eines WORD-Formatwerts im hohen
Bit des WORD angegeben. Damit das gleiche Vorzeichen beim Übergang vom
WORD-Wert zum LONGWORD-Wert erhalten bleibt wird das Vorzeichen erweitert. 
In der Praxis haben wir in unserem Fall:

Startwert = $51A7 = %0101000110100111
					 ^
			         |
			         höchstwertiges Bit ist 0

erweiterter Wert = $000051A7  = %00000000000000000101000110100111

Alle Bits 16 bis 31 haben den Wert 0 angenommen.

Nehmen wir ein weiteres Beispiel und ändern Sie die von MOVE kopierten Werte:

	move.l	#$22222222,a0
	move.w	#$c1a7,a0

Wenn wir den ersten MOVE ausführen, erhalten wir:

D0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
A0: 22222222 00000000 00000000 00000000 00000000 00000000 00000000 07C9F584
SSP=07CA06B7 USP=07C9F584 SR=8000 T1 -- PL=0 ----- PC=07CA2642
PC=07CA2642 307CC1A7		 MOVE.W  #$C1A7,A0
>

den zweiten MOVE durchführen:

D0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
A0: FFFFC1A7 00000000 00000000 00000000 00000000 00000000 00000000 07C9F584 
SSP=07CA06B7 USP=07C9F584 SR=8000 T1 -- PL=0 ----- PC=07CA2646
PC=07CA2646 4E75                 RTS

In diesem Fall hat die Vorzeichenerweiterung den LONGWORD-Wert negativ gemacht:

Startwert = $C1A7 = %1100000110100111
			         ^
			         |
			         Das höchstwertige Bit ist 1
Erweiterter Wert = $FFFFC1A7  = %11111111111111111100000110100111

Alle Bits 16 bis 31 haben den Wert 1 angenommen.

Hinweis: Die Anweisung EXT.L wird verwendet, um das Vorzeichen wie in diesen 
Beispielen zu erweitern.
