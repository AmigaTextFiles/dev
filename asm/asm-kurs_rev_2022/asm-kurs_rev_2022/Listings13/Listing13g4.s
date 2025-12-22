
; Listing13g4.s		(es erscheint klar...)
; Zeile 1338

Ich rate Ihnen auch, die Bccs entsprechend ihrer Wahrscheinlichkeit der
Ausführung zuerst zu platzieren, das sind praktisch diejenigen, die mit
größerer Wahrscheinlichkeit die Kontrolle übertragen. Ein weiterer
interessanter Fall ist dieser: Wir haben eine Reihe von Werten, wir wissen
nicht wie viele, aber wir wissen, dass sie mit einer Null enden ... 
Angenommen, wir müssen sie von einem Speicherbereich in einen anderen kopieren.
Wir könnten so etwas tun:

	Lea	Source,a0
	Lea	Dest,a1
CpLoop:
	Move.b	(a0)+,d0	; Quelle -> d0
	Move.b	d0,(a1)+	; d0 -> Ziel
	Tst.b	d0			; d0=0?
	Bne.s	CpLoop		; Wenn noch nicht, weiter

Aber wir können es auf folgende Weise besser machen:

	Lea	Source,a0
	Lea	Dest,a1
CpLoop:
	Move.b	(a0)+,(a1)+	; Quelle -> Ziel
	Bne.s	CpLoop		; flag 0 gesetzt? Wenn noch nicht, weiter!

Wie Sie sehen können, erledigt der 68000 in diesem Fall alles von selbst.

Sprechen wir jetzt über die Aufrufe der Subroutinen und damit über die Movem.
Die Verwendung von Subroutinen ist offensichtlich sehr nützlich bei der
Erstellung der Programme, aber bei der Optimierung Ihres Codes sollte beachtet
werden, dass anstatt des BSR-Label / RTS-Anweisungspaars zu verwenden, können
Sie auch das BRA-Label gefolgt von einem BRA am Ende der Subroutine das Sie
an den Ausgangspunkt zurückführt, das unmittelbar auf das JMP-Label folgt
verwenden, aber diese Optimierung liegt in Ihrem Ermessen.
Verwenden Sie jedoch, immer BSR anstelle von JSR und auch BRA anstelle von
JMP, wenn möglich. Wenn Sie jedoch zur Verwendung von Routinen zurückkehren,
müssen Sie häufig den Inhalt der Register löschen, bevor Sie mit der Arbeit
beginnen. Wir können uns jedoch jedes Mal eine Menge "Moveq #0,Dx" und
"Sub.l Ax,Ax" sparen, tatsächlich machen wir das zu Beginn des Hauptprogramms
und sehen was passiert, wenn wir unsere Subroutinen aufrufen.
Beispiel:

	Moveq	#0,d0	;
	Moveq	#0,d1
	...
	Moveq	#0,d7
	Move.l	d0,a0
		..
   	Move.l	d0,a6
Main:
	Bsr.s	Pippo
	Bsr.s	Pluto
	Bsr.s	Paperino
	...
	Bra.s	Main

Nun, wenn wir den Inhalt der verwendeten Register bei jedem Aufruf speichern
werden wir jedes Mal, wenn eine Routine endet und zur nächsten geht "saubere"
Register haben. Es ist offensichtlich, dass dies für den eigenen Code gut ist.
Andernfalls könnten Sie mit einer Anweisung alle Register reinigen, nämlich:

	movem.l	TantiZeri(PC),d0-d7/a0-a6

TantiZeri:
	dcb.b	15,0