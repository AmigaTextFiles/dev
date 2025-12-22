
; Listing2g.s

Anfang:
	lea	THEEND,a0		; gib in a0 die Start-Adresse
	lea	START,a1		; gib in a1 die End-Adresse
CLELOOP:
	clr.l	-(a0)		; zähle 4 zu a0 dazu (long!), dann lösche das Long
	cmp.l	a0,a1		; ist a0 gleich a1? Sind wir also an der Adresse START?
	bne.s	CLELOOP		; wenn nicht, kehre zu CLELOOP zurück...
	rts					; ENDE, zurück zum ASMONE

START:
	dcb.b	40,$fe		; GIB HIER 40 BYTES vom Typ $fe in den Speicher
THEEND:					; Dieses Label markiert das Ende der 40 Bytes

	dcb.b	10,0		; Hier geben wir - grade mal aus Jux - 10 Nuller
						; in den Speicher

	end


Dieses  kleine Programm macht den Speicher ab der Adresse in a0 sauber bis
hin zur Adresse in a1: der Unterschied zu Listing2f.s besteht  darin,  daß
hier  "rückwärts"  gegangen wird, im Gegensatz zum CLR (a0)+, hier wird am
Ende gestartet und man kommt Schritt für Schritt zum Anfang. Macht ein AD,
dann  könnt  ihr  es  überprüfen:  ihr  werdet  feststellen, daß bei jedem
Durchgang  des   CLR   -(a0)   das   Register   a0   dekrementiert,   d.h.
heruntergezählt,  wird,  bis es mit dem Wert in a1 gleich ist, also START.
Überprüft dann auch mit M  START,  daß  der  "Putzvorgang"  auch  wirklich
stattgefunden  hat.  Wenn  es  euch  interessiert, probiert auch das CLR.L
-(a0) durch ein CLR.W -(a0) oder ein CLR.B -(a0) zu  ersetzen.  In  diesen
Fällen werden jeweils Schritte zu 2 bzw. zu 1 Byte gemacht. Es werden also
20 bzw. 40 Durchgänge nötig sein, den Bereich zu löschen.
