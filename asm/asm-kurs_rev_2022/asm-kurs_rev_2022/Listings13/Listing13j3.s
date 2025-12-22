
; Listing13j3.s	; cnop 0,4	; Optimierungen auf 68020+
; Zeile 1983
; nur Programmfragment

Schließlich mag der 68020+ wirklich Routinen und Label, die an Adressen mit
Vielfachen von 32 ausgerichtet sind, d.h. Langwort ausgerichtet.
Um 32-Bit auszurichten, nur ein:

	CNOP	0,4

Vor der Routine oder dem Label. Auf 68000 gibt es aber keine Verbesserungen,
aber auf 68020+ gibt es sie, insbesondere wenn der ausgerichtete Code in
Fast RAM oder in Cache geht. Hier ist ein Beispiel:

Routine1:
	bsr.s	rotazione
	bsr.s	proiezione
	bsr.s	disegno
	rts

	cnop	0,4
rotazione:
	...
	rts

	cnop	0,4
proiezione:
	...
	rts

	cnop	0,4
disegno:
	...
	rts

Stellen Sie bei Labeln sicher, dass Sie nicht auf ungerade Adressen zugreifen,
wodurch es sich verlangsamt. Richten Sie diese stattdessen auch auf long aus:

Originalfassung:

Label1:
	dc.b	0
Label2:
	dc.b	0	; Adresse seltsam! "move.b xx, label1" wird langsam sein!
Label3:
	dc.w	0
Label4:
	dc.w	0
Label5:
	dc.l	0
Label6:
	dc.l	0
Label7:
	dc.l	0

ausgerichtete Version:

	cnop	0,4
Label1:
	dc.b	0
	cnop	0,4
Label2:
	dc.b	0
	cnop	0,4
Label3:
	dc.w	0
	cnop	0,4
Label4:
	dc.w	0
	cnop	0,4
Label5:
	dc.l	0
Label6:
	dc.l	0 ; diese 2 sind definitiv ausgerichtet, 
Label7:		  ;	es besteht keine Notwendigkeit für cnop
	dc.l	0