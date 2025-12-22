
; Listing8h.s - Verwendung der UniMuoviSprite-Routine zum Erstellen eines Panels
			; Steuerung mit Schaltflächen

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110100000	; nur copper,bitplane,sprite DMA
;			 -----a-bcdefghij

;	a: Blitter Nasty
;	b: Bitplane DMA
;	c: Copper DMA
;	d: Blitter DMA
;	e: Sprite DMA
;	f: Disk DMA
;	g-j: Audio 3-0 DMA

START:
	bsr.w	PuntaFig1			; Zeiger auf Fig.1
	bsr.w	PuntaFigBase		; Zeiger auf Fig.base

	move.l	#BufferVuoto,d0		; freien Platz, an dem es sein wird
	LEA	BPLPOINTER2,A1			; gedruckter Text
	move.w	d0,6(a1)	
	swap	d0
	move.w	d0,2(a1)

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	move.b	$dff00a,mouse_y		; JOY0DAT - Wir geben den Variablen mouse_y -_x 
	move.b	$dff00b,mouse_x		; JOY1DAT - den aktuellen Lesewert der Maus

;*****************************************************************************
; 				HAUPTSCHLEIFE
;*****************************************************************************

Clear:
	clr.b	Azione				; die Variablen zurücksetzen
	clr.b	TastoAzionato
	clr.b	EsciVar

Programma:
	****1
	btst	#6,$bfe001			; linke Maustaste gedrückt? Wenn nicht
	bne.s	Contprog			; setze das Programm fort, ansonsten:
	bsr.w	CheckAzione			; Kontrolle welche Taste wir gedrückt haben
	cmpi.b	#1,TastoAzionato	; Wenn wir eine der "Tasten" gedrückt haben
	beq.s	Comando				; Variante "Switched Key" und = 1; gehen wir
								; um zu überprüfen, auf welche Taste wir geklickt haben!
Contprog:
	bsr.w	MuoviFreccia		; Routine, die die Maus liest / bewegt
	bra.s	Programma			; Ende des Programms: wir kehren zum Anfang zurück!

;*****************************************************************************
;	Routine "Comando" zur Interpretation der gedrückten Taste
;*****************************************************************************

; In der Variable "Azione" (Aktion) finden wir einen eingegebenen Wert den wir
; zuvor aus der Routine "CheckAzione" erhalten haben. Wir überprüfen den Wert
; und wissen damit, auf welche Taste wir "geklickt" haben und gehen in sein
; entsprechendes kleines Programm um es auszuführen.

Comando:
	cmpi.b	#$f,Azione			; Wenn Aktion "f", ist, haben wir auf die Schaltfläche geklickt
	beq.s	Verde				; grün	
	cmpi.b	#$e,Azione			; Wenn Aktion "e", ist, haben wir auf die Schaltfläche geklickt
	beq.w	Rosso				; rot
	cmpi.b	#$d,Azione			; Wenn Aktion "d", ist, haben wir auf die Schaltfläche geklickt
	beq.w	Giallo				; gelb
	cmpi.b	#7,Azione			; Wenn Aktion "7", ist, haben wir auf die Schaltfläche geklickt
	beq.w	Music_On			; Music_On
	cmpi.b	#6,Azione			; Wenn Aktion "6", ist, haben wir auf die Schaltfläche geklickt
	beq.w	Music_Off			; Music_Off
	cmpi.b	#5,Azione			; Wenn Aktion "5", ist, haben wir auf die Schaltfläche geklickt
	beq.w	Esci				; Quit
	cmpi.b	#4,Azione			; Wenn Aktion "4", ist, haben wir auf die Schaltfläche geklickt
	beq.w	PalNtsc				; PalNtsc
	cmpi.b	#3,Azione			; Wenn Aktion "3", ist, haben wir auf die Schaltfläche geklickt
	beq.w	Piu					; mehr
	cmpi.b	#$2,Azione			; Wenn Aktion "2", ist, haben wir auf die Schaltfläche geklickt
	beq.w	Meno				; weniger
;	cmpi.b	#1,Azione			; Wenn Aktion "1", ist, haben wir auf die Schaltfläche geklickt
	bra.w	GiuSu				; GiuSu (In Wahrheit ist nur noch diese übrig)
								; Möglichkeit, also springen wir direkt

;*****************************************************************************

Verde:
	bsr.w	MuoviFreccia		; Routine, die die Maus liest / bewegt
	lea	Barra+6,a6				; Zur Rückgabe der Multiplikation
	move.b	#$1,ColorB			; speichern, welche Farbe wir anzeigen
	move.w	#$0030,(a6)			; wir ändern die FARBEN des Balkens (den Abstand)
	move.w	#$0060,8(a6)		; zwischen einem wait und dem anderen sind 8 Bytes
	move.w	#$0090,8*2(a6)
	move.w	#$00c0,8*3(a6)
	move.w	#$00f0,8*4(a6)
	move.w	#$00c0,8*5(a6)
	move.w	#$0090,8*6(a6)
	move.w	#$0060,8*7(a6)
	move.w	#$0030,8*8(a6)
	bra.w	Clear				; wir kehren zum Anfang zurück!

;*****************************************************************************

Rosso:
	bsr.w	MuoviFreccia		; Routine, die die Maus liest / bewegt
	lea	Barra+6,a6				; Zur Rückgabe der Multiplikation
	move.b	#$2,ColorB			; speichern, welche Farbe wir anzeigen
	move.w	#$0300,(a6)			; wir ändern die FARBEN des Balkens (den Abstand)
	move.w	#$0600,8(a6)		; zwischen einem wait und dem anderen sind 8 Bytes
	move.w	#$0900,8*2(a6)
	move.w	#$0c00,8*3(a6)
	move.w	#$0f00,8*4(a6)
	move.w	#$0c00,8*5(a6)
	move.w	#$0900,8*6(a6)
	move.w	#$0600,8*7(a6)
	move.w	#$0300,8*8(a6)
	bra.w	Clear				; wir kehren zum Anfang zurück!
		
;*****************************************************************************

Giallo:
	bsr.w	MuoviFreccia		; Routine, die die Maus liest / bewegt
	lea	Barra+6,a6				; Zur Rückgabe der Multiplikation
	clr.b	ColorB				; speichern, welche Farbe wir anzeigen
	move.w	#$0310,(a6)			; wir ändern die FARBEN des Balkens (den Abstand)
	move.w	#$0640,8(a6)		; zwischen einem wait und dem anderen sind 8 Bytes
	move.w	#$0970,8*2(a6)
	move.w	#$0ca0,8*3(a6)
	move.w	#$0fd0,8*4(a6)
	move.w	#$0ca0,8*5(a6)
	move.w	#$0970,8*6(a6)
	move.w	#$0640,8*7(a6)
	move.w	#$0310,8*8(a6)
	bra.w	Clear				; wir kehren zum Anfang zurück!

;*****************************************************************************

PaNtFlag:
	dc.w	0

PalNtsc:
	bchg.b	#1,PaNtflag
	btst.b	#1,PaNtflag
	beq.s	VaiPal
	move.w	#0,$1dc(a5)			; BEAMCON0 (ECS+) Videoauflösung NTSC
	bra.w	Clear				; wir kehren zum Anfang zurück!
VaiPal
	move.w	#$20,$1dc(a5)		; BEAMCON0 (ECS+) Videoauflösung PAL
	bra.w	Clear				; wir kehren zum Anfang zurück!


;*****************************************************************************

; Denken Sie daran, die 'MoveArrow'-Routine IMMER in den Punkten zu platzieren,
; zum Beispiel wie das folgende, das nicht zur Ausführung des Hauptprogramms 
; zurückkehrt, bis die linke Maustaste gedrückt wird. Wenn sie weggelassen würde,
; würde die Maus sich nicht bewegen, bis die Maustaste losgelassen wird!

Piu:
	bsr.w	MuoviFreccia		; Routine, die die Maus liest / bewegt
	lea	barra,a6				; in a6, die Adresse von "BARRA" einsetzen, um zu
								; vermeiden, das es jedes Mal neu geschrieben werden
								; muss, und darüber hinaus ist die Ausführung schneller!
	cmpi.b	#$84,8*9(a6)		; sind wir an der Zeile an $84 angekommen?
	beq.s	FinePiu				; Wenn ja, sind wir oben und hören auf.
	addq.b	#1,(a6)				; Wir verschieben die Position des Balkens um ein
	addq.b	#1,8(a6)			; Pixel zu einem Zeitpunkt
	addq.b	#1,8*2(a6)
	addq.b	#1,8*3(a6)
	addq.b	#1,8*4(a6)
	addq.b	#1,8*5(a6)
	addq.b	#1,8*6(a6)
	addq.b	#1,8*7(a6)
	addq.b	#1,8*8(a6)
	addq.b	#1,8*9(a6)

**2
	btst.b	#6,$bfe001			; bis die linke Maustaste losgelassen wird
	beq.s	Piu					; bewegt sich der Balken weiter, auch wenn 	
								; sich die Maus nicht mehr über der "+"-Taste befindet:
								; Versuchen Sie, unter der ersten Zeile hinzuzufügen
								; "bsr.w Muovifreccia" die Bezeichnung "PIU2" und	
								; ändern Sie auch die Zeile unter *** 2 in
								; "beq.s Piu2". Trotz der Tatsache, dass sich die
								; Maus bewegt, bewegt sich der Pfeil nicht!

	bra.w	Clear				; wir kehren zum Anfang zurück!

; sind wir bis zum Boden gegangen? Dann der BLAUE Balken

FinePiu:
	bsr.w	MuoviFreccia		; Routine, die die Maus liest / bewegt
	lea	Barra+6,a6				; Bar in coplist
	move.w	#$0003,(a6)			; wir ändern die Farben des Balkens auf BLAU
	move.w	#$0006,8(a6)
	move.w	#$0009,8*2(a6)
	move.w	#$000c,8*3(a6)
	move.w	#$000f,8*4(a6)
	move.w	#$000c,8*5(a6)
	move.w	#$0009,8*6(a6)
	move.w	#$0006,8*7(a6)
	move.w	#$0003,8*8(a6)
	btst.b	#6,$bfe001			; solange die linke Maustaste nicht losgelassen wird
	beq.s	FinePiu				; bewegt sich der Balken weiter, auch wenn
								; sich die Maus nicht mehr über der "+" Taste befindet:
	cmp.b	#1,ColorB			; wir überprüfen, welche Farbe es vorher hatte
								; der Balken durch die Variable ColorB:
								; Wenn der Wert "1" war, ist der Balken grün
	beq.w	Verde				; wir gehen zum Label GRÜN und geben dem 
								; Balken seine ursprüngliche Farbe zurück
	cmp.b	#2,ColorB			; Auch hier, wenn die Variable den Wert
	beq.w	Rosso				; "2" hat, gehen wir zum Label ROT
	bra.w	Giallo				; Wenn keine Bedingung aufgetreten ist
								; war die Bar unvermeidlich
								; GELB, denn die möglichen Farben
								; sind drei: rot, grün oder gelb!

;*****************************************************************************

Meno:
	bsr.w	Muovifreccia		; Es gilt das Gleiche wie oben, nur dass wir
	lea	barra,a6				; addiere den Wert "1" zu "bar",
	cmpi.b	#$36,8*9(a6)		; Haben wir den Boden erreicht?
	beq.s	FineMeno			; anhalten und den Balken blau färben
	subq.b	#1,(a6)				; wir subtrahieren, so dass es sich in die
	subq.b	#1,8(a6)			; entgegengesetzte Richtung (nach oben) bewegt
	subq.b	#1,8*2(a6)
	subq.b	#1,8*3(a6)
	subq.b	#1,8*4(a6)
	subq.b	#1,8*5(a6)
	subq.b	#1,8*6(a6)
	subq.b	#1,8*7(a6)
	subq.b	#1,8*8(a6)
	subq.b	#1,8*9(a6)
	**3
	btst.b	#6,$bfe001
	beq.s	Meno
	bra.w	Clear				; Kehren wir zum Anfang zurück !!

; sind wir oben angekommen? Dann blauer Balken!

FineMeno:
	bsr.w	MuoviFreccia		; Routine, die die Maus liest / bewegt
	lea	Barra+6,a6
	move.w	#$0003,(a6)			; color blau
	move.w	#$0006,8(a6)
	move.w	#$0009,8*2(a6)
	move.w	#$000c,8*3(a6)
	move.w	#$000f,8*4(a6)
	move.w	#$000c,8*5(a6)
	move.w	#$0009,8*6(a6)
	move.w	#$0006,8*7(a6)
	move.w	#$0003,8*8(a6)
	btst.b	#6,$bfe001
	beq.s	FineMeno
	cmpi.b	#$1,ColorB			; Überprüfen, welche Farbe der Balken hatte
	beq.w	Verde
	cmpi.b	#$2,ColorB
	beq.w	Rosso
	bra.w	Giallo

;*****************************************************************************

Music_On:
	move.b	#1,MusicFlag		; der MusicFlag-Variablen den Wert "1" geben,
								; Wann immer wir es testen, werden wir wissen
								; wenn die Musik aktiviert wurde.
	move.l	a5,-(SP)			; speichern a5 im stack
	bsr.w	mt_init				; zur Routine springen, die die Musik spielt
	move.l	(SP)+,a5			; a5 vom Stack wiederherstellen

	**4
;	bsr.w	MuoviFreccia		; Routine, die die Maus liest / bewegt
	bra.w	Clear				; wir kehren zum Anfang zurück!

;*****************************************************************************

Music_Off:
	clr.b	MusicFlag			; der MusicFlag-Variablen den Wert "0" geben,
								; Wann immer wir es testen, werden wir wissen
								; wenn die Musik ausgeschaltet wurde.
	move.l	a5,-(SP)			; speichern a5 im stack
	bsr.w	mt_end				; zur Routine springen, die die Musik stoppt
	move.l	(SP)+,a5			; a5 vom Stack wiederherstellen
	**5
;	bsr.w	MuoviFreccia		; Routine, die die Maus liest / bewegt
	bra.w	Clear				; wir kehren zum Anfang zurück!

;*****************************************************************************
;			Rirtono bei OldCop
;*****************************************************************************

Esci:							; wir verlassen das Programm!!!
	move.l	a5,-(SP)			; speichern a5 im stack
	bsr.w	mt_end				; die Musik ausschalten !!!: Wenn wir auf die
								; "EXIT" Taste drücken, während die Musik
								; spielt, passiert ein durcheinander
	move.l	(SP)+,a5			; a5 vom Stack wiederherstellen
	rts	


*******************************************************************************
*				Vari BSR													  *
*******************************************************************************

PuntaFig1:
	MOVE.L	#picture1,d0
	moveq	#4-1,d1				; 4 bitplane!
	LEA	BPLPOINTERS,A1
POINTBPa:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*84,d0			; die bitplane ist 84 Zeilen hoch, nicht 256!!
	addq.w	#8,a1
	dbra	d1,POINTBPa

; alle Sprites zeigen auf das Null-Sprite, um sicherzustellen
; das es keine Probleme gibt

	MOVE.L	#SpriteNullo,d0		; Adresse des sprite in d0
	LEA	SpritePointers,a1		; Spritezeiger in copperlist
	MOVEQ	#8-1,d1				; alle 8 sprite
NulLoop:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	addq.w	#8,a1
	dbra	d1,NulLoop

; Zeiger erste sprite

	MOVE.L	#MIOSPRITE0,d0
	LEA	SpritePointers,a1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	rts							; Rückkehr zum BSR

PuntaFigBase:	
	MOVE.L	#picturebase,d0
	LEA	BPLPOINTERSbase,A1
	moveq	#0,d1				; 1 bitplane!
POINTBPbasenew:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*105,d0			; die bitplane ist 105 Zeilen hoch, nicht 256!!
	addq.w	#8,a1
	dbra	d1,POINTBPbasenew
	rts							; Rückkehr

******************************************************************************
; Diese Routine prüft, ob wir einen "Button" / "Gadget" gedrückt haben
; Wo gibt es keine Befehle. Wenn eine "Taste" gedrückt wird, weisen Sie zu
; der Wert, der der "Taste" entspricht, die auf die Variable "Aktion" gedrückt wurde.
******************************************************************************


;                 _,'|             _.-''``-...___..--';)
;                /_ \'.      __..-' ,      ,--...--'''
;               ¶     .`--'''       `     /'
;                `-';'               ;   ; ;
;          __...--''     ___...--_..'  .;.'
;         (,__....----'''       (,..--''
;||||||||///|||||||||||||||||||||||||||||||||||||||||||||||||||||

CheckAzione:

; Überprüfen Sie zuerst die Positionen Y

	move.b	#$1,TastoAzionato	; Wir nehmen das im Voraus an
								; Wir drückten eine der Tasten
								; und geben der Variable "Switched Key"
								; der Wert "1"
	cmpi.w	#$00fc,Sprite_y		; Der Pfeil befindet sich unter der Position
								; der Schaltflächen?
								; Sprite_y ist > 00fc, wenn ja:
	bhi.s	rtnCheck			; Wir sind raus!
	cmpi.w	#$00f1,Sprite_y		; Der Pfeil ist an der Linie ausgerichtet
								; die "Farbe ändern in GRÜN"?
;
	bhi.w	Effetto_Verde		; Wenn ja: Gehen Sie zu Aktion Grün 
;
	cmpi.w	#$00fe,Sprite_y		; Sind wir zwischen 00f1 und 00fe? Wenn ja:
	bhi.s	rtnCheck			; Wir sind raus!
	cmpi.w	#$00e4,Sprite_y		; Der Pfeil ist an der Linie ausgerichtet
								; die "Farbe ändern in ROT"?
;
	bhi.w	Effetto_Rosso		; Wenn ja, gehen Sie zu Aktion rot
;
	cmpi.w	#$00e1,Sprite_y		; Sind wir zwischen 00e1 und 00d7? Wenn ja:
	bhi.s	rtnCheck			; Wir sind raus!
	cmpi.w	#$00d7,Sprite_y		; Der Pfeil ist an der Linie ausgerichtet
								; der "Farbe ändern in GELB"?
;
	bhi.w	Effetto_Giallo		; Wenn ja, gehen Sie zu Aktion gelb
;
	cmpi.w	#$00d0,Sprite_y		; Sind wir zwischen 00d7 und 00d0? Wenn ja:
	bhi.s	rtnCheck			; Wir sind raus!

	cmpi.w	#$00b0,Sprite_y		; Der Pfeil befindet sich zwischen "+", "-",
;								; "Pal-Ntsc","Exit"...
	bhi.s	Azione_Tasti		; Wenn ja, gehen Sie zu Aktion _Tasti
;
rtnCheck:
	clr.b	TastoAzionato		; es wurden keine Tasten gedrückt,
	rts							; wir verhindern, dass das Programm 
								; Zeit durch sofortiges erneutes Lesen 
								; der Mausposition verschwendet, über die
								; Variable "KeyActivated".

;*****************************************************************************
; Jetzt, da wir wissen, dass das Y das einer "Schaltfläche" ist, lassen Sie  
; uns auch überprüfen, ob das X das richtige ist!
;*****************************************************************************

Azione_Tasti:
	cmpi.w	#$0111,Sprite_x		; Der Pfeil befindet sich jenseits der Tasten
								; "Musica Off"? wenn ja:
	bhi.s	rtnCheck			; Wir sind raus!
	cmpi.w	#$00ea,Sprite_x		; Der Pfeil befindet sich zwischen den Tasten
								; "Musica Off"? wenn ja:
	bhi.w	Effetto_Off_Music	; Gehe zuEffetto_Off_Music

	cmpi.w	#$00dc,Sprite_x		; Der Pfeil befindet sich zwischen 00ea und 00dc? wenn ja:
	bhi.s	rtnCheck			; Wir sind raus!
	cmpi.w	#$00b3,Sprite_x		; Der Pfeil befindet sich über der Taste
								; "Musica_On"? wenn ja:
	bhi.w	Effetto_On_Music	; Gehe zuEffetto_On_Music
	cmpi.w	#$00ab,Sprite_x		; Der Pfeil befindet sich jenseits der Tasten
								; "Pal/Ntsc" und "Quit"
	bhi.s	rtnCheck			; Wir sind raus!
	cmpi.w	#$0077,Sprite_x		; Der Pfeil befindet sich zwischen den Tasten
								; "Pal/Ntsc,Quit"?
	bhi.s	Quale_Due2			; Mal sehen, welche der "Pal / Ntsc" oder "Quit"
	cmpi.w	#$006c,Sprite_x		; Der Pfeil befindet sich zwischen 77 und 6c?
	bhi.s	rtnCheck			; Wir sind raus!
	cmpi.w	#$005d,Sprite_x		; Der Pfeil befindet sich zwischen den Tasten
								; "+" und "-"?
	bhi.s	Quale_Due1			; Mal sehen, welche der "+" oder "-"
	cmpi.w	#$004f,Sprite_x		; Der Pfeil befindet sich zwischen 77 und 6c?
	bhi.s	rtnCheck			; Wir sind raus!
	cmpi.w	#$003e,Sprite_x		; Der Pfeil ist auf dem Schaltfläche: -> <- !!
	bhi.s	Effetto_GiuSu		; Gehen wir zu Effetto_GiuSu
	bra.s	rtnCheck			; Wenn keine Aktion aufgetreten ist
								; dann lass uns zu rtnCheck gehen

Quale_Due2:
	cmpi.w	#$00c3,Sprite_y		; Der Pfeil befindet sich über der Taste
	bhi.w	Effetto_Quit		; "Quit"? Wenn ja, gehe zu Effekt_Quit
	cmpi.w	#$00bc,Sprite_y		; Der Pfeil befindet sich zwischen 00c3 und 00bc?
	bhi.w	rtnCheck			; Wir sind in der Mitte der beiden Taste!
	cmpi.w	#$00b0,Sprite_y		; Der Pfeil befindet sich zwischen 00bc und 00b0?
	bhi.w	Effetto_Pal			; wir gehen zu  Effetto_Pal
	
Quale_Due1:
	cmpi.w	#$00c3,Sprite_y		; Der Pfeil befindet sich über der Taste
	bhi.s	Effetto_Piu			; "Piu"? Wenn ja, gehe zu Effekt_Piu
	cmpi.w	#$00bc,Sprite_y 	; Der Pfeil befindet sich zwischen 00bc und 00c3?
	bhi.w	rtnCheck			; Wir sind in der Mitte der beiden Taste!
	cmpi.w	#$00b0,Sprite_y		; Der Pfeil befindet sich zwischen 00b0 und 00bc?
	bhi.w	Effetto_Meno		; wir gehen zu Effetto_Meno


;*****************************************************************************
; Geben wir nun der Aktionsvariablen den Wert der gedrückten Taste
;*****************************************************************************

Effetto_Verde:					; Wenn ja, wird dieser Zustand überprüft
	move.b	#$d,Azione			; es bedeutet, dass wir über der grünen Bar
	rts							; sind! Dann informieren wir das
								; Programm, das diese "Schaltfläche" gedrückt
								; wurde durch die Variable Azione
								; (Aktion) mit dem Wert "d".
Effetto_Rosso:
	move.b	#$e,Azione			; Wie oben, bis auf die Schaltfläche
	rts							; -rot- Wir geben den Wert von  "e".

Effetto_Giallo:
	move.b	#$f,Azione			; Wie oben, bis auf die Schaltfläche
	rts							; -gelb- Wir geben den Wert von   "f".

Effetto_GiuSu:
	move.b	#$1,Azione			; Wie oben, bis auf die Schaltfläche
	rts							; -GiuSu- Wir geben den Wert von "1".

Effetto_Piu:
	move.b	#$2,Azione			; Wie oben, bis auf die Schaltfläche
	rts							; -plus- Wir geben den Wert von "2".

Effetto_Meno:
	move.b	#$3,Azione			; Wie oben, bis auf die Schaltfläche
	rts							; -minus- Wir geben den Wert von "3".

Effetto_Pal:
	move.b	#$4,Azione			; Wie oben, bis auf die Schaltfläche
	rts							; -Pal- Wir geben den Wert von "4".

Effetto_Quit:
	move.b	#$5,Azione			; Wie oben, bis auf die Schaltfläche
	rts							; -Quit- Wir geben den Wert von "5".

Effetto_Off_Music
	move.b	#$6,Azione			; Wie oben, bis auf die Schaltfläche
	rts							; -Off_Music- Wir geben den Wert von "6".

Effetto_On_Music
	move.b	#$7,Azione			; Wie oben, bis auf die Schaltfläche
	rts							; -On_Music- Wir geben den Wert von "7".
	
*************************************************************************
* Routine, die die Position der Maus lieste				*
* Betreten der Koordinaten in Mouse_x/Mouse_y - Sprite_x/Sprite_Y	*
*************************************************************************

LeggiMouse:
	move.b	$a(a5),d1			; $dff00a - JOY0DAT byte hoch
	move.b	d1,d0
	sub.b	mouse_y(PC),d0
	beq.s	no_vert
	ext.w	d0
	add.w	d0,sprite_y
no_vert:
  	move.b	d1,mouse_y
	move.b	$b(a5),d1			; $dff00a - JOY0DAT byte niedrig
	move.b	d1,d0
	sub.b	mouse_x(PC),d0
	beq.s	no_oriz
	ext.w	d0
	add.w	d0,sprite_x
no_oriz:
	move.b	d1,mouse_x
	cmpi.w	#$0021,sprite_x		; Minimale x-Position? (linker Rand)
	bpl.b	s1					; wenn noch nicht, ist es nicht notwendig zu blockieren.
	move.w	#$0021,sprite_x		; Ansonsten lassen Sie es uns aufhören
								; Lage $21  .. NICHT ÜBER !!
s1:
	cmpi.w	#$0004,sprite_y		; Minimale y-Position? (Anfang des Bildschirms)
	bpl.b	s2					; wenn noch nicht, nicht blockieren
	move.w	#$0004,sprite_y		; ansonsten nagelt das sprite an
								; oberer linker Rand
s2:
	cmpi.w	#$011d,sprite_x		; Maximale x-Position? (rechter Rand)
	ble.b	s3					; wenn noch nicht, ist es nicht notwendig zu blockieren
	move.w	#$011d,sprite_x		; Ansonsten lasst es uns für $11d blockieren
s3:
	cmpi.w	#$00ff,sprite_y		; Position und Masse? (Bildschirm unten)
	ble.b	s4					; wenn noch nicht, nicht blockieren
	move.w	#$00ff,sprite_y		; Ansonsten blockiere a $ff
s4:
	rts

*********************************************************
*		Routine die das sprite0	bewegt					*
*********************************************************
;	a1 = Adresse des Sprites
;	d0 = vertikale Y-Position des Sprites auf dem Bildschirm (0-255)
;	d1 = horizontale X-Position des Sprites auf dem Bildschirm (0-320)
;	d2 = Höhe des Ssprites

UniMuoviSprite:
	ADD.W	#$2c,d0
	MOVE.b	d0,(a1)
	btst.l	#8,d0
	beq.s	NonVSTARTSET
	bset.b	#2,3(a1)
	bra.s	ToVSTOP
NonVSTARTSET:
	bclr.b	#2,3(a1)
ToVSTOP:
	ADD.w	D2,D0
	move.b	d0,2(a1)
	btst.l	#8,d0
	beq.s	NonVSTOPSET
	bset.b	#1,3(a1)
	bra.b	VstopFIN
NonVSTOPSET:
	bclr.b	#1,3(a1)
VstopFIN:
	add.w	#128,D1
	btst	#0,D1
	beq.s	BitBassoZERO
	bset	#0,3(a1)
	bra.s	PlaceCoords
BitBassoZERO:
	bclr	#0,3(a1)
PlaceCoords:
	lsr.w	#1,D1
	move.b	D1,1(a1)
	rts

*******************************************************************************
*		Timing und Update von Sprite-LOOPs									  *
*******************************************************************************

MuoviFreccia:

; Dies ist eine Timing-Routine, da der Vergleich mit den Elektronenstrahl 
; mit 50 Hz (es sei denn, Sie verwenden das NTSC-System! (60Hz!)) verwendet
; wird. Genau, der Elektronenstrahl hat in allen Computern die gleiche
; Geschwindigkeit, sowohl im alten A500 als auch im A4000.

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$0fe00,d2			; Warte auf Zeile $fe (254)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile $fe (254)
	BNE.S	Waity1


	tst.b	MusicFlag			; Wenn MusicFlag "0" ist, ist Musik nicht
	beq.w	NoMusic2			; eingeschaltet worden, so überspringen wir die 
								; folgende Zeile
	move.l	a5,-(SP)			; speichern a5 im stack
	bsr.w	mt_music			; Die Musik wird abgespielt, wenn die Taste
								; gedrückt wurde "On_Music"
	move.l	(SP)+,a5			; a5 vom stack wiederherstellen

NoMusic2:
	bsr.w	LeggiMouse			; Wechseln zur Routine, die die 
								; Mausposition liest
	move.w	sprite_y(pc),d0		; y-Koordinate vorbereiten
	move.w	sprite_x(pc),d1		; x-Koordinate vorbereiten
	lea	miosprite0,a1			; wähle das zu bewegende Sprite aus
	moveq	#13,d2				; die Länge des Sprites vorbereiten
	bsr.w	UniMuoviSprite		; wir gehen zu der Routine, die das Sprite bewegt
	bsr.w	PrintCarattere		; und schreiben den Text

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$0fe00,d2			; Warte auf Zeile $0fe (254)
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile $0fe (254)
	BEQ.S	Aspetta

	rts

;***************************************************************************
; "Spezialeffekt" Schließen und Öffnen mit DIWSTART/STOP
;***************************************************************************

	
GiuSu:
	bsr.w	SchermoChiudi		; zur Routine springen, die den Bildschirm schließt
	bsr.w	SchermoApri			; zur Routine springen, die den Bildschirm öffnet
	bra.w	Clear				; wir kehren zum Anfang zurück!

;*****************************************************************************

SchermoChiudi:
	bsr.w	MuoviFreccia		; warte bis 1 FRAME-Zyklus abgelaufen ist !!
	ADDQ.B	#1,DiwYStart		; wir senken den oberen Bildschirm um ein Pixel
	SUBQ.B	#1,DIWySTOP			; wir heben den unteren Bildschirm um ein Pixel
	CMPI.b	#$ad,DiwYStart		; Wenn wir die gewünschte Position erreicht haben,
	beq.s	Finito3				; dann gehen wir raus, sonst setzen wir das
	bra.s	SchermoChiudi		; pixel
Finito3:
	rts

SchermoApri:
	bsr.w	MuoviFreccia		; anstatt es zu erhöhen, verringern wir es,
								; das heißt wir kehren um:
								; addq #1,DiwyStart
	SUBQ.B	#5,DiwYStart		; subq #1,DiwyStop
	ADDQ.B	#5,DIWySTOP			; jeweils mit
	CMPI.B	#$2c,DiwYStop		; subq #5,DiwyStart
	beq.w	Finito4				; addq #5,DiwyStop
	bra.s	SchermoApri
Finito4:
	rts


*******************************************************************************
*				Dati					      *
*******************************************************************************
Azione:
	dc.l	0
TastoAzionato:
	dc.l	0
EsciVar
	dc.l	0
ColorB:
	dc.b	2
	even

MusicFlag:
	dc.w	0
		
SPRITE_Y:	dc.w	$a0			; hier wird das Y des Sprites gespeichert
								; Durch Ändern dieses Wertes können wir Y ändern
								; die Ausgangsposition der Maus
SPRITE_X:	dc.w	0			; hier wird das X des Sprites gespeichert
								; Durch Ändern dieses Wertes können wir X ändern
								; die Ausgangsposition der Maus
MOUSE_Y:	dc.b	0			; hier ist das Y der Maus gespeichert
MOUSE_X:	dc.b	0			; hier ist das X der Maus gespeichert

*****************************************************************************
;			Druckroutine
*****************************************************************************

PRINTcarattere:
	MOVE.L	PuntaTESTO(PC),A0	; Adresse des zu druckenden Textes in a0
	MOVEQ	#0,D2				; leer d2
	MOVE.B	(A0)+,D2			; Nächstes Zeichen in d2
	CMP.B	#$ff,d2				; Ende des Textsignals? ($FF)
	beq.s	FineTesto			; wenn ja, beenden ohne zu drucken
	TST.B	d2					; Zeilenende-Signal? ($00)
	bne.s	NonFineRiga			; Wenn nicht, nicht einpacken

	ADD.L	#40*7,PuntaBITPLANE	; Gehen wir zum Kopf
	ADDQ.L	#1,PuntaTesto		; erste Zeichenzeile nach
								; (überspringe die NULL)
	move.b	(a0)+,d2			; erstes Zeichen der Zeile nach
								; (überspringe die NULL)

NonFineRiga:
	SUB.B	#$20,D2				; ZÄHLE 32 VOM ASCII-WERT DES BUCHSTABEN WEG,
								; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
								; (Das $20 entspricht), IN $00, DAS
								; AUSRUFUNGSZEICHEN ($21) IN $01....
	LSL.W	#3,D2				; MULTIPLIZIERE DIE ERHALTENE ZAHL MIT 8,
								; da die Charakter ja 8 Pixel hoch sind
	MOVE.L	D2,A2
	ADD.L	#FONT,A2			; FINDEN SIE DAS GEWÜNSCHTE ZEICHEN IM FONT...

	MOVE.L	PuntaBITPLANE(PC),A3 ; Adresse der Zielbitebene in a3

								; DRUCKE DEN BUCHSTABEN ZEILE FÜR ZEILE
	MOVE.B	(A2)+,(A3)			; Drucke Zeile 1 vom Charakter
	MOVE.B	(A2)+,40(A3)		; Drucke Zeile 2  " "
	MOVE.B	(A2)+,40*2(A3)		; Drucke Zeile 3  " "
	MOVE.B	(A2)+,40*3(A3)		; Drucke Zeile 4  " "
	MOVE.B	(A2)+,40*4(A3)		; Drucke Zeile 5  " "
	MOVE.B	(A2)+,40*5(A3)		; Drucke Zeile 6  " "
	MOVE.B	(A2)+,40*6(A3)		; Drucke Zeile 7  " "
	MOVE.B	(A2)+,40*7(A3)		; Drucke Zeile 8  " "

	ADDQ.L	#1,PuntaBitplane	; wir bewegen uns 8 Bits vorwärts (NÄCHSTES ZEICHEN)
	ADDQ.L	#1,PuntaTesto		; nächstes zu druckendes Zeichen

FineTesto:
	RTS


PuntaTesto:
	dc.l	TESTO

PuntaBitplane:
	dc.l	BufferVuoto+40*3

;	$00 für "Zeilenende" - $FF für "Textende"

			 ; Anzahl Zeichen pro Zeile: 40
TESTO:	     ;		  1111111111222222222233333333334
             ;   1234567890123456789012345678901234567890
	dc.b	'                                        ',0 ; 1
	dc.b	'    Usa il mouse per spostare la        ',0 ; 2
	dc.b	'                                        ',0 ; 3
	dc.b	'    barra, cambiarla di colore,         ',0 ; 4
	dc.b	'                                        ',0 ; 5
	dc.b	'    suonare la musica o "chiudere"      ',0 ; 6
	dc.b	'                                        ',0 ; 7
	dc.b	'    lo schermo con il DIWSTART/STOP     ',$FF ; 12

	EVEN

; Die FONT 8x8-Zeichen, werden im CHIP von der CPU und nicht vom Blitter kopiert,
; so kann es auch im FAST RAM sein. In der Tat wäre es besser!

FONT:
	 incbin	"/Sources/nice.fnt"

*******************************************************************************
*			ROUTINE MUSICALE
*******************************************************************************

	include	"/Sources/music.s"

*******************************************************************************
;			MEGACOPPERLISTE GALAKTISCH (fast...)
*******************************************************************************


	SECTION	GRAPHIC,DATA_C


COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$8E					; DiwStrt
DiwYStart:
	dc.b	$30
DIWXSTART:
	dc.b	$81
	dc.w	$90					; DiwStop
DIWYSTOP:
	dc.b	$2c
DIWXSTOP:
	dc.b	$c1
	dc.w	$92,$38				; DdfStart
	dc.w	$94,$d0				; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,$24			; BplCon2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod

				; 5432109876543210
	dc.w	$100,%0100001000000000	; BPLCON0 - 4 planes lowres (16 color)

; Bitplane pointers

BPLPOINTERS:
	dc.w	$e0,0,$e2,0			; erste bitplane
	dc.w	$e4,0,$e6,0			; zweite bitplane
	dc.w	$e8,0,$ea,0			; dritte bitplane
	dc.w	$ec,0,$ee,0			; vierte bitplane

; Die ersten 16 Farben sind für das LOGO

	dc.w	$180,$000,$182,$fff,$184,$200,$186,$310
	dc.w	$188,$410,$18a,$620,$18c,$841,$18e,$a73
	dc.w	$190,$b95,$192,$db6,$194,$dc7,$196,$111
	dc.w	$198,$222,$19a,$334,$19c,$99b,$19e,$446


	dc.w	$1A2,$fff			; color17   Color
	dc.w	$1A4,$fa6			; color18   der
	dc.w	$1A6,$000			; color19   Maus

BARRA:
	dc.w	$5c07,$FFFE			; warte auf die Zeile $50
	dc.w	$180,$300			; starte den roten Balken: rot mit 3
	dc.w	$5d07,$FFFE			; nächste Zeile
	dc.w	$180,$600			; rot mit 6
	dc.w	$5e07,$FFFE
	dc.w	$180,$900			; rot mit 9
	dc.w	$5f07,$FFFE
	dc.w	$180,$c00			; rot mit 12
	dc.w	$6007,$FFFE
	dc.w	$180,$f00			; rot mit 15 (al massimo)
	dc.w	$6107,$FFFE
	dc.w	$180,$c00			; rot mit 12
	dc.w	$6207,$FFFE
	dc.w	$180,$900			; rot mit 9
	dc.w	$6307,$FFFE
	dc.w	$180,$600			; rot mit 6
	dc.w	$6407,$FFFE
	dc.w	$180,$300			; rot mit 3
	dc.w	$6507,$FFFE
	dc.w	$180,$000			; color schwarz


; roter Balken unter dem Logo

	dc.w	$8407,$fffe			; Ende des logo

BPLPOINTER2:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$100,$1200			; 1 bitplane (zurücksetzen)

	dc.w	$8507,$FFFE			; folgende Zeile
	dc.w	$180,$606			; violet
	dc.w	$8607,$FFFE
	dc.w	$180,$909			; violet
	dc.w	$8707,$FFFE
	dc.w	$180,$c0c			; violet
	dc.w	$8807,$FFFE
	dc.w	$180,$f0f			; violet (maximal)
	dc.w	$8907,$FFFE
	dc.w	$180,$c0c			; violet
	dc.w	$8a07,$FFFE
	dc.w	$180,$909			; violet
	dc.w	$8b07,$FFFE
	dc.w	$180,$606			; violet
	dc.w	$8c07,$FFFE	
	dc.w	$180,$303			; violet
	dc.w	$8d07,$FFFE		
	dc.w	$180,$000			; color schwarz

	dc.w	$182,$fe3			; Color Text

; zentrale Bar

	dc.w	$9007,$FFFE			; folgende Zeile

	dc.w	$180,$011			; dunkelgrün mit 11
	dc.w	$9507,$FFFE
	dc.w	$180,$022			; dunkelgrün mit 22
	dc.w	$9a07,$FFFE
	dc.w	$180,$033			; dunkelgrün mit 33
	dc.w	$9f07,$FFFE
	dc.w	$180,$055			; dunkelgrün mit 55
	dc.w	$a407,$FFFE
	dc.w	$180,$077			; dunkelgrün mit 77
	dc.w	$a907,$FFFE
	dc.w	$180,$099			; dunkelgrün mit 99
	dc.w	$ae07,$FFFE
	dc.w	$180,$077			; dunkelgrün mit 77
	dc.w	$b307,$FFFE
	dc.w	$180,$055			; dunkelgrün mit 55
	dc.w	$b807,$FFFE
	dc.w	$180,$033			; dunkelgrün mit 33
	dc.w	$bd07,$FFFE
	dc.w	$180,$022			; dunkelgrün mit 22
	dc.w	$c207,$FFFE
	dc.w	$180,$011			; dunkelgrün mit 11

*****Bild am Boden:

	dc.w	$c607,$FFFE			; auf Zeile $c6 warten
	dc.w	$180,$000			; color SCHWARZ

				; 5432109876543210
	dc.w	$100,%0001001000000000	; 1 bitplane LoRes

BPLPOINTERSbase:
	dc.w	$e0,$0000,$e2,$0000
CopBase:	
	dc.w	$0180,$0000,$0182,$0877

; violetter Balken über dem Panel

	dc.w	$ca07,$FFFE			; nächste Zeile
	dc.w	$180,$606			; violet
	dc.w	$cb07,$FFFE
	dc.w	$180,$909			; violet
	dc.w	$cc07,$FFFE	
	dc.w	$180,$c0c			; violet
	dc.w	$cd07,$FFFE
	dc.w	$180,$f0f			; violet (maximal)
	dc.w	$ce07,$FFFE
	dc.w	$180,$c0c			; violet
	dc.w	$cf07,$FFFE
	dc.w	$180,$909			; violet
	dc.w	$d007,$FFFE
	dc.w	$180,$606			; violet
	dc.w	$d107,$FFFE
	dc.w	$180,$303			; violet
	dc.w	$d207,$FFFE
	dc.w	$180,$000			; colore schwarz

	dc.w	$ca07,$FFFE			; WAIT - warte auf Zeile $ca
	dc.w	$180,$001			; COLOR0 - sehr dunkelblau
	dc.w	$cc07,$FFFE			; WAIT - warte auf Zeile $cc
	dc.w	$180,$002			; etwas intensiver blau
	dc.w	$ce07,$FFFE			; nächstes wait 2 Zeilen tiefer
	dc.w	$180,$003			; blau mit 3
	dc.w	$d007,$FFFE			; 
	dc.w	$180,$004			; blau mit 4
	dc.w	$d207,$FFFE			; 
	dc.w	$180,$005			; blau mit 5
	dc.w	$d407,$FFFE			; 
	dc.w	$180,$006			; blau mit 6
	dc.w	$d607,$FFFE			; 
	dc.w	$180,$007			; blau mit 7
	dc.w	$d807,$FFFE			; 
	dc.w	$180,$008			; blau mit 8
	dc.w	$da07,$FFFE			; 
	dc.w	$180,$009			; blau mit 9
	dc.w	$e007,$FFFE			; 
	dc.w	$180,$00a			; blau mit 10
	dc.w	$e507,$FFFE			; 
	dc.w	$180,$00b			; blau mit 11
	dc.w	$ea07,$FFFE			; 
	dc.w	$180,$00c			; blau mit 12
	dc.w	$f007,$FFFE			; 
	dc.w	$180,$00d			; blau mit 13
	dc.w	$f507,$FFFE			; 
	dc.w	$180,$00e			; blau mit 14
	dc.w	$fa07,$FFFE			; 
	dc.w	$180,$00f			; blau mit 15

	dc.w	$ffdf,$FFFE			; Warte auf Zeile $ff

	dc.w	$0207,$FFFE			; warten
	dc.w	$182,$0f0			; color1 grün

	dc.w	$0f07,$FFFE			; warten
	dc.w	$182,$f22			; color1 rot

	dc.w	$1c07,$FFFE			; warten
	dc.w	$182,$ff0			; color1 gelb

	dc.w	$2907,$FFFE			; warten
	dc.w	$182,$877			; color1 grau

	dc.w	$FFFF,$FFFE			; Ende copperlist

*******************************************************************************
*				Sprite														  *
*******************************************************************************
; Wie immer sollte die Grafik wie die copperliste NUR in CHIP geladen werden!!

MIOSPRITE0:
VSTART0:
	dc.b $50
HSTART0:
	dc.b $45
VSTOP0:
	dc.b $5d
VHBITS0:
	dc.b $00
 dc.w	%0110000000000000,%1000000000000000
 dc.w	%0001100000000000,%1110000000000000
 dc.w	%1000011000000000,%1111100000000000
 dc.w	%1000000110000000,%1111111000000000
 dc.w	%0100000000000000,%0111111110000000
 dc.w	%0100000000000000,%0111111000000000
 dc.w	%0010000100000000,%0011111000000000
 dc.w	%0010010010000000,%0011111100000000
 dc.w	%0001001001000000,%0001101110000000
 dc.w	%0001000100100000,%0001100111000000
 dc.w	%0000000010000000,%0000000011100000
 dc.w	%0000000000000000,%0000000000000000
 dc.w	%0000000000000000,%0000000000000000
 dc.w	0,0


SpriteNullo:					; Null-Sprite, auf das in der Copperlist gezeiget wird
	dc.l	0,0,0,0				; für alle nicht verwendete Zeiger

PICTUREbase:
	incbin	"/Sources/base320x105x1.raw"	; 1 Bitplanes 
				
; Das ist das Bild 320 Pixel breit und 84 hoch, 4 Bitebenen (16 Farben).


PICTURE1:
	incbin	"/Sources/logo320x84x16c.raw"	; 4 Bitplanes 
				
			
; Musik. Achtung: Die "music.s"-Routine von Diskette 2 ist nicht dieselbe wie
; die von Diskette 1. Die beiden Änderungen betreffen die Entfernung eines BUGs
;

mt_data:
	dc.l	mt_data1

mt_data1:
	incbin	"/Sources/mod.JamInExcess"

	Section	MiniBitplane,bss_c

;	Der Text wird in diesem Puffer gedruckt

BufferVuoto:
	ds.b	40*68

	end			
								; Der Computer liest nicht über das END hinaus!
								; Jetzt können wir alles ohne 
								; PUNKT und Komma oder Semikolon schreiben


Wenn wir mit jedem Tastendruck einen anderen Videoeffekt erzielen möchten, 
müssen wir wissen ob die linke Maustaste gedrückt wird und, wenn ja, die
Position des Sprite Mauszeigers. Kurz gesagt, wir müssen wissen, welche Taste
gedrückt wurde um einen anderen Videoeffekt auszuführen:

Sobald wir das Programm beginnen, finden wir eine Überprüfung: "Linke Taste
gedrückt?", Wenn die Taste nicht gedrückt wurde, wird das Programm fortgesetzt,
indem es aktualisiert wird, wobei der Pfeil auf dem Bildschirm bewegt wird und
wenn wir die Maustaste drücken, springen wir zu einer Routine, die die Position
von 
 - Sprite_x
 - Sprite_y
mit den Koordinaten, an denen sich unsere Schaltflächen befinden, vergleicht!

**************************** Tricks *****************************

Aber woher kennen wir die X- und Y-Koordinaten unserer "Button"? keine Sorge,
Sie müssen nicht Milliarden von Tests oder Berechnungen nach Augenmaß
durchführen! Da der ASMONE einen eingebauten Monitor hat, können wir es so
machen: Entwerfen Sie das Bedienfeld mit seinen Schaltflächen, das Sie möchten. 
Wenn wir das ganze anzeigen, müssen wir nur noch wissen, welchen Koordinaten
die Tasten entsprechen und das erfolgt mit der Mausroutine. 

Wenn Sie die Position jeder Schaltfläche überprüfen möchten, setzen Sie einfach
an den Anfang des Programm (anstelle von **** 1), diese einfache Schleife:

Aspetta:
	bsr.w	LeggiMouse
	move.w	sprite_y(pc),d0
	move.w	sprite_x(pc),d1
	lea	miosprite0,a1
	moveq	#13,d2
	bsr.w	UniMuoviSprite
	btst	#2,$dff016
	bne.w	Aspetta
	bra.w	esci	

Dadurch wird die Mausposition aktualisiert und beim Drücken der linken
Maustaste, beenden wir einfach das Programm !!
Positionieren Sie sich an der gewünschten Koordinate, die Sie wissen möchten,
zum Beispiel an einer Ecke einer Schaltfläche und beenden Sie das Programm mit
der linken Maustaste an dieser Stelle.
Jetzt müssen Sie nur noch die letzten Positionen sehen, die die Maus 
eingenommen hat mit dem mythischen "M"-Befehl (nach Drücken der ESC-Taste):

	m Sprite_x   (RETURN drücken)
	m Sprite_y   (RETURN drücken)

Der Befehl "M" ist sehr nützlich. Er wird häufig verwendet, um zu überprüfen,
an welchem "Punkt" oder bei welchem "Wert" es angekommen ist. Wenn Sie zum
Beispiel, ein Sprite oder einen Balken an einem bestimmten Punkt anhalten
wollen, machen Sie einfach eine Schleife, die es vorwärts bewegt bis die Maus
drücken. Starten Sie das Programm, drücken Sie die Maus, wenn es den
gewünschten Punkt erreicht haben, und machen Sie "M variable". Einfach !!!

***************************************************************************

Versuchen Sie testweise, das Sprite an verschiedenen Stellen auf dem
Bildschirm anzuzeigen. Versuchen Sie beim Starten des Programms auch, den
Mauszeiger in das Rechteck in der unteren Abbildung.

Sicherlich haben Sie schon bemerkt, dass, wenn Sie die Taste "+" oder "-"
drücken und die linke Maustaste nicht loslassen, wird der Balken weiter
angezeigt. Die Leiste wird unerschrocken fortgesetzt zu bewegen, auch wenn wir
den Pfeil aus der Schaltfläche bewegen:
Dies liegt daran, dass wir, wie in **2 erläutert, bis zur Freigabe die
Maustaste drücken, prüft das Programm die Mausposition nicht erneut!

Um dies zu ändern, fügen Sie einfach ** 2 hinzu:

	bsr.s	MuoviFreccia

natürlich das weglassen

	btst.b	#6,$bfe001
	beq.s	Piu

Versuchen Sie auch, Punkt ** 3 zu ändern 

jetzt einfach nur noch hinzufügen:

	brs.s	MuoviFreccia 

An den Punkten ** 4, ** 5 sehen Sie, was passiert:
Einfach die Taste eingeben oder verlassen und der Effekt startet!

Im Gegensatz zu den anderen Tasten reicht das für die Tasten "Balkenfarbe
ändern" nur fahren Sie mit dem Mauszeiger darüber, um den gewünschten Effekt
zu erzielen! Jetzt sollten sie wissen warum!

Schließlich "blockieren" die Tasten, die die Musik ein- und ausschalten, auch
die Pfeil ... für Sie das schwierige Problem zu verstehen, warum.

