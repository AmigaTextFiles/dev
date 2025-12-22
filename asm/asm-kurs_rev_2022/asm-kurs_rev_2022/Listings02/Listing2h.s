
; Listing2h.s

Anfang:
	lea	$dff006,a0			; VHPOSR  - gib $dff006 in a0
	lea	$dff180,a1			; COLOR00 - gib $dff180 in a1
	lea	$bfe001,a2			; CIAAPRA - gib $bfe001 in a2
Waitmouse:
	move.w	(a0),(a1)+		; gib den Wert von $dff006 in COLOR0,
							; also $dff180 (Inhalt von a1)
							; dann inkrementiere um 2 a1, so bringst
							; du es auf $dff182,also color 1
	move.w	(a0),-(a1)		; dekrementiere um 2 a1, so wird daraus 
							; wieder $dff180, dann gib $dff006 in COLOR0
	btst	#6,(a2)			; linke Maustaste gedrückt?
	bne.s	Waitmouse		; wenn nicht, zurück zu waitmouse 
	rts						; Ende

	END


Mit  dieser  Schleife erkennt man sehr gut die Unterschiede zwischen (a1)+
und -(a1), denn sie sind so angelegt, daß sie sich  gegenseitig  aufheben:
während  das  erste  (a0)+  a1  um ein Word inkrementiert und es somit auf
$dff182 bringt, dekrementiert -(a1) diesen gleich wieder  und  stellt  den
Ausgangszustand  wieder  her:  $dff180.  Danach  wird  in COLOR0 ($dff180)
hineingeschrieben. Diese zwei Befehle kann man einfacher so schreiben:

	move.w	(a0),(a1)
	move.w	(a0),(a1)

Verifiziert den Tausch der Adressen im Register a1 durch ein AD.  Erinnert
euch  GUT DARAN, daß wenn ihr ein + NACH einer Klammer seht, dann wird der
Befehl ausgeführt und DANACH das Register  hinaufgezählt,  umgekehrt,  mit
einem - VOR der Klammer wird ZUERST heruntergezählt und dann die Operation
durchgeführt. Bemerkung: Ihr könnt den  Zyklus  während  dem  AD  beenden,
indem  ihr  die linke Maustaste gedrückt haltet, während ihr über dem btst
seid. Einmal beim RTS angekommen, drückt ESC.
