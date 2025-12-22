
; Listing8p2a.s		Flags und Adressregister

	SECTION	CondC,CODE

Inizio:
	move.w	#$0000,d0
	move.l	#$80000000,a0
stop:
	rts

	end


;	   . · · .
;	  .       .
;	  .       .
;	   .     .
;	     · ·

In diesem Listing werden wir uns mit einer Besonderheit der direkten
Adressierung zum Adressregister befassen. Wir werden diese Besonderheit anhand
eines MOVE-Befehls sehen, bei dem die Adressierung für das Ziel direkt zum 
Adressregister verwendet wird, aber es kommt mit allen Anweisungen die die
direkte Adressierung in das Adressregister für das Ziel zulassen.

Assemblieren Sie zuerst das Programm und führen Sie die erste Anweisung aus.
Sie erhalten folgende Ausgabe:

D0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
A0: 80000000 00000000 00000000 00000000 00000000 00000000 00000000 07C9EDC4
SSP=07C9FEF7 USP=07C9EDC4 SR=8004 T1 -- PL=0 --Z-- PC=07CA18DC
PC=07CA18DC 207C80000000	 MOVE.L  #$80000000,A0
>

Das Flag Z" nahm erwartungsgemäß den Wert 1 an.
Wir führen auch die zweite Anweisung aus:

D0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 80000000 00000000 00000000 00000000 00000000 00000000 00000000 07C9EDC4 
SSP=07C9FEF7 USP=07C9EDC4 SR=8004 T1 -- PL=0 --Z-- PC=07CA18E2
PC=07CA18E2 4E75		 RTS
>

Wir stellen fest, dass wenn der Befehl ausgeführt wurde, das Flag "Z" immer 
noch 1 enthält und das Flag "N" stattdessen 0 ist. Dennoch haben wir den Wert 
von $80000000 geladen. Im Register A0 ist es negativ! Unser treuer 680x0 hat
sich also geirrt? Natürlich nicht! (Es ist kein Pentium 60! :).

Der Punkt ist der, wie wir ihn schon in Lektion 8 erklärt haben. Eigentlich
befasst sich die Anweisung ja mit dem Kopieren von Daten in ein Adressregister
und MOVEA, ist eine Variante vom normalen MOVE. Der Bequemlichkeit halber
erlaubt uns der ASMONE mit MOVE in die Adressregister zu kopieren, und er
kümmert sich darum den MOVE durch MOVEA zu ersetzen. Normalerweise merken wir
den Ersatz gar nicht.

In diesem Fall muss man jedoch sehr vorsichtig sein, weil MOVEA sich anders als 
MOVE in Bezug auf die Änderung des CC verhält. MOVEA, wie Sie in 68000-2.TXT 
lesen können, lässt die CCs unverändert. In unserem Fall war das Flag "Z" vor
der Ausführung von MOVE #$80000000,A0 auf Z=1 und aus diesem Grund blieb es
beim Wert 1. Lassen Sie es uns überprüfen, indem wir den ersten MOVE ändern.

	move.w	#$8000,d0

Bei der Ausführung STEP BY STEP stellen wir fest, dass der erste MOVE den
Wert 1 im Flag "N" hat.

D0: 00008000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CC685C 
SSP=07CC798F USP=07CC685C SR=8008 T1 -- PL=0 -N--- PC=07CC9A60
PC=07CC9A60 207C80000000	 MOVE.L  #$80000000,A0
>

Und das MOVE.L #80000000,A0, wie gesagt, lässt die CCs unverändert:

D0: 00008000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
A0: 80000000 00000000 00000000 00000000 00000000 00000000 00000000 07CC685C 
SSP=07CC798F USP=07CC685C SR=8008 T1 -- PL=0 -N--- PC=07CC9A66
PC=07CC9A66 4E75		 RTS     
>

Besonderes Augenmerk muss auf die Tatsache gelegt werden, dass die CCs nicht
bei der Adressierung von Registern beeinflusst werden. Hier kann also der Fall 
für einem BUG liegen. Angenommen, Sie haben ein Datenelement gespeichert und
sie wollen es auf zwei verschiedene Arten modifizieren, abhängig davon, ob es
positiv oder negativ ist.
Wenn wir die Daten in ein Datenregister kopieren, zum Beispiel nach D0,
können wir den folgenden Codeausschnitt schreiben.:

	move.w	dato(pc),d0			; ändert die CCs basierend auf den Daten
	bmi.s	dato_negativo
dato_positivo:
	; Operationen, die ausgeführt werden sollen, wenn die Daten positiv sind
	bra.s	fine

dato_negativo:
	; auszuführende Operationen, wenn die Daten negativ sind
fine:
	; Rest des Programms

In diesem Fall setzt MOVE, wie wir bereits wissen, die CCs entsprechend des
Vorzeichens der Daten.
Wenn wir stattdessen unsere Daten in ein Adressregister eintragen müssten
(zB A0) Wenn wir eine ähnliche Prozedur schreiben würden, würde sie nicht
funktionieren, weil MOVEA die CCs nicht korrekt aktualisiert.

	move.w	dato(pc),a0			; KEINE Änderung der CCs basierend auf Daten !!
	bmi.s	dato_negativo		; Der Sprung erfolgt auf der Basis des
								; Status der CCs vor MOVE
dato_positivo:
	; Operationen, die ausgeführt werden sollen, wenn die Daten positiv sind
	bra.s	fine

dato_negativo:
	; auszuführende Operationen, wenn die Daten negativ sind

fine:
	; Rest des Programms

Eine mögliche Lösung für das Problem könnte darin bestehen, die Daten zuerst in
ein Datenregister zu kopieren und dann in A0, oder Sie verwenden den
TST-Befehl.
