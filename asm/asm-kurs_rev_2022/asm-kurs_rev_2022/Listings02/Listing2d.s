
; Listing2d.s

Anfang:
	lea	NILPFERD,a0			; gib in A0 die Adresse von NILPFERD
	move.l	(a0),d0			; gib in d0 den .L-Wert, den wir
							; an der Adresse in a0 finden, also
							; das erste Longword, das bei NILPFERD steht
	move.l	NILPFERD,d1		; in d1 geben wir den Inhalt des ersten
							; longword (4 bytes=4 Adressen) von NILPFERD
	move.l	a0,d2			; in d2 geben wir die in a0 enthaltene Zahl,
							; also die Adresse von NILPFERD, das zuerst
							; mit dem LEA NILPFERD,a0 geladen wurde
	move.l	#NILPFERD,d3	; in d3 geben wir die Adresse von NILPFERD
	rts

NILPFERD:
	dc.l	$123

	END


Bei  diesem  Beispiel  erkennt  man  den  Unterschied  zwischen  direkter,
indirekter und absoluter Adressierung: einmal  assembliert,  macht  ein  D
Anfang,  um  die  Ausgangssituation anzusehen, und nach einem J werdet ihr
den Unterschied in  den  Registern  bemerken:  in  d0  und  d1  wird  $123
enthalten sein, also der Inhalt
von NILPFERD:

	lea	NILPFERD,a0			; gib in A0 die Adresse von NILPFERD
	move.l	(a0),d0			; gib in d0 den .L-Wert, den wir
							; an der Adresse in a0 finden, also
							; das erste longword, das nach NILPFERD steht
							; (Mit dem MOVE.L kopiert man das Byte an
							; der Adresse in a0 selbst und die drei
							; folgenden, denn ein Long ist ja 4 Byte lang).


Das ist identisch mit:

	move.l	NILPFERD,d1		; in d1 geben wir den .L-Inhalt von NILPFERD

In beiden Fällen wird der .L-Inhalt (d.h. 4 Bytes ab der angegebenen Adresse)
von NILPFERD ins Datenregister kopiert.

In d2, d3 und a0 hingegen werdet ihr die Adresse von NILPFERD bemerken, denn:


	lea	NILPFERD,a0			; in A0 geben wir die Adresse von NILPFERD
	move.l	a0,d2			; in d2 geben wir den Wert, der in a0 enthalten
							; ist, also der Adresse von NILPFERD, die mit dem
							; LEA geladen wurde

ist identisch mit:

	move.l	#NILPFERD,d3	; in d3 geben wir die Adresse von NILPFERD
	


Diese Differenzen in der Adressierung müßen klar  sein,  denn  wenn  diese
einmal  sitzen, dann reicht es, sich an die Befehle und deren Bedeutung zu
erinnern, denn sie verwenden alle die gleichen Adressierungsarten.

Beispiele von bisher gelernten Adressierungen:

DIREKT:
	move.l	a0,a1

INDIREKT:
	clr.l	 (a0)
	move.l	(a3),(a4)

ABSOLUT:
	move.l	#LABEL,d0
	MOVE.L	#10,d4

