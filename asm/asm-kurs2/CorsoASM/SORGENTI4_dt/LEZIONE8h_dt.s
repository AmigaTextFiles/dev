
; Lezione8h.s - Verwendung der UniM Impressed-Routine zum Erstellen eines Panels
			; Steuerung mit Gadgets

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist Etc.
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
	bsr.w	PuntaFig1		; Zeiger auf Fig.1
	bsr.w	PuntaFigBase	; Zeiger auf Fig.base

	move.l	#BufferVuoto,d0	; freien Platz, an dem es sein wird
	LEA	BPLPOINTER2,A1		; gedruckter Text
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Deaktivieren Sie die AGA
	move.w	#$c00,$106(a5)		; Deaktivieren Sie die AGA
	move.w	#$11,$10c(a5)		; Deaktivieren Sie die AGA

	move.b	$dff00a,mouse_y		; Wir geben der Variablen das mouse_y-x 
	move.b	$dff00b,mouse_x		; aktueller Lesewert der Maus

;*****************************************************************************
; 				HAUPTSCHLEIFE
;*****************************************************************************

Clear:
	clr.b	Azione			; Setzen Sie die Variablen zurück
	clr.b	TastoAzionato
	clr.b	EsciVar

Programma:
	****1
	btst	#6,$bfe001	; Linke Maustaste gedrückt? Wenn nicht
	bne.s	Contprog	; setze das Programm fort, ansonsten:
	bsr.w	CheckAzione	; Kontrolle welche Taste wir gedrückt haben
	cmpi.b	#1,TastoAzionato; Wenn wir dort eine der "Tasten" gedrückt haben
	beq.s	Comando		; Variante "Switched Key" und = 1; gehen wir
				; um zu überprüfen, auf welche Taste wir geklickt haben!
Contprog:
	bsr.w	MuoviFreccia	; Routine, die die Maus liest / bewegt
	bra.s	Programma		; Ende des Programms: Kehren wir zum Anfang zurück!

;*****************************************************************************
;	Routine "Comando" zur Interpretation der gedrückten Taste
;*****************************************************************************

; In der Variable "ACTION" finden wir einen eingegebenen Wert
; zuvor aus der Routine "CheckAzione". Überprüfen Sie den Wert
; wir können wissen, auf welche Taste wir "geklickt" haben und gehen, 
; sein entsprechendes kleines Programm um die auszuführen.

Comando:
	cmpi.b	#$f,Azione	; Wenn die Aktion' "f", ist, haben wir auf die Schaltfläche geklickt
	beq.s	Verde		; GRÜN	
	cmpi.b	#$e,Azione	; Wenn die Aktion' "e", ist, haben wir auf die Schaltfläche geklickt
	beq.w	Rosso		; Rot
	cmpi.b	#$d,Azione	; Wenn die Aktion' "d", ist, haben wir auf die Schaltfläche geklickt
	beq.w	Giallo		; GELB
	cmpi.b	#7,Azione	; Wenn die Aktion' "7", ist, haben wir auf die Schaltfläche geklickt
	beq.w	Music_On	; Music_On
	cmpi.b	#6,Azione	; Wenn die Aktion' "6", ist, haben wir auf die Schaltfläche geklickt
	beq.w	Music_Off	; Music_Off
	cmpi.b	#5,Azione	; Wenn die Aktion' "5", ist, haben wir auf die Schaltfläche geklickt
	beq.w	Esci		; Quit
	cmpi.b	#4,Azione	; Wenn die Aktion' "4", ist, haben wir auf die Schaltfläche geklickt
	beq.w	PalNtsc		; PalNtsc
	cmpi.b	#3,Azione	; Wenn die Aktion' "3", ist, haben wir auf die Schaltfläche geklickt
	beq.w	Piu			; mehr
	cmpi.b	#$2,Azione	; Wenn die Aktion' "2", ist, haben wir auf die Schaltfläche geklickt
	beq.w	Meno		; Meno
;	cmpi.b	#1,Azione	; Wenn die Aktion' "1", ist, haben wir auf die Schaltfläche geklickt
	bra.w	GiuSu		; GiuSu (In Wahrheit ist nur noch dieser übrig)
						; Möglichkeit, also springen wir direkt

;*****************************************************************************

Verde:
	bsr.w	MuoviFreccia	; Routine, die die Maus liest / bewegt
	lea	Barra+6,a6			; Die Multiplikation zurückbringen
	move.b	#$1,ColorB		; Wir speichern, welche Farbe wir anzeigen
	move.w	#$0030,(a6)		; Lassen Sie uns die FARBEN der Leiste (die Entfernung) ändern
	move.w	#$0060,8(a6)	; zwischen einer Wartezeit und der anderen ist 8 Bytes)
	move.w	#$0090,8*2(a6)
	move.w	#$00c0,8*3(a6)
	move.w	#$00f0,8*4(a6)
	move.w	#$00c0,8*5(a6)
	move.w	#$0090,8*6(a6)
	move.w	#$0060,8*7(a6)
	move.w	#$0030,8*8(a6)
	bra.w	Clear			; Gehen wir zurück an die Spitze!

;*****************************************************************************

Rosso:
	bsr.w	MuoviFreccia	; Routine, die die Maus liest / bewegt
	lea	Barra+6,a6			; Die Multiplikation zurückbringen
	move.b	#$2,ColorB		; Wir speichern, welche Farbe wir anzeigen
	move.w	#$0300,(a6)		; Wir ändern die Wartezeit der Bar (die Entfernung)
	move.w	#$0600,8(a6)	; zwischen einer Wartezeit und der anderen ist 8 Bytes)
	move.w	#$0900,8*2(a6)
	move.w	#$0c00,8*3(a6)
	move.w	#$0f00,8*4(a6)
	move.w	#$0c00,8*5(a6)
	move.w	#$0900,8*6(a6)
	move.w	#$0600,8*7(a6)
	move.w	#$0300,8*8(a6)
	bra.w	Clear			; Gehen wir zurück an die Spitze!

;*****************************************************************************

Giallo:
	bsr.w	MuoviFreccia	; Routine, die die Maus liest / bewegt
	lea	Barra+6,a6			; Die Multiplikation zurückbringen
	clr.b	ColorB			; Wir speichern, welche Farbe wir anzeigen
	move.w	#$0310,(a6)		; Wir ändern die Wartezeit der Bar (die Entfernung)
	move.w	#$0640,8(a6)	; zwischen einer Wartezeit und der anderen ist 8 Bytes)
	move.w	#$0970,8*2(a6)
	move.w	#$0ca0,8*3(a6)
	move.w	#$0fd0,8*4(a6)
	move.w	#$0ca0,8*5(a6)
	move.w	#$0970,8*6(a6)
	move.w	#$0640,8*7(a6)
	move.w	#$0310,8*8(a6)
	bra.w	Clear			; Gehen wir zurück an die Spitze!

;*****************************************************************************

PaNtFlag:
	dc.w	0

PalNtsc:
	bchg.b	#1,PaNtflag
	btst.b	#1,PaNtflag
	beq.s	VaiPal
	move.w	#0,$1dc(a5)		; BEAMCON0 (ECS+) Videoauflösung NTSC
	bra.w	Clear			; Gehen wir zurück an die Spitze!
VaiPal
	move.w	#$20,$1dc(a5)	; BEAMCON0 (ECS+) Videoauflösung PAL
	bra.w	Clear


;*****************************************************************************

; Erinnern wir uns, IMMER die "MuoviFreccia" -Routine in die Punkte zu setzen, zum
; Beispiel wie das folgende, das nicht zurückkehrt, um das Hauptprogramm auszuführen
; bis die linke Maustaste gedrückt wird. Wenn es weggelassen wurde,
; Die Maus würde sich nicht bewegen, bis wir die Maustaste loslassen!

Piu:
	bsr.w	MuoviFreccia	; Routine, die die Maus liest / bewegt
	lea	barra,a6			; Lassen Sie uns in a5, die Adresse von "BARRA", so setzen
							; Vermeiden, es jedes Mal neu zu schreiben, hrsg
							; Darüber hinaus ist die Ausführung schneller!
	cmpi.b	#$84,8*9(a6)	; Wir kamen an der Zeile an $84?
	beq.s	FinePiu			; Wenn ja, sind wir oben und hören auf.
	addq.b	#1,(a6)			; Wir verschieben die Position des Balkens um ein Pixel
	addq.b	#1,8(a6)		; zu einer Zeit
	addq.b	#1,8*2(a6)
	addq.b	#1,8*3(a6)
	addq.b	#1,8*4(a6)
	addq.b	#1,8*5(a6)
	addq.b	#1,8*6(a6)
	addq.b	#1,8*7(a6)
	addq.b	#1,8*8(a6)
	addq.b	#1,8*9(a6)

**2
	btst.b	#6,$bfe001		; Bis der linke Knopf losgelassen wird
	beq.s	Piu				; der Balken bewegt sich trotz der
							; Maus ist nicht mehr über der "+" Taste:
							; Versuchen Sie, unter der ersten Zeile einzufügen
							; "bsr.w Muovifreccia" die Bezeichnung "PIU2", e
							; Ändern Sie auch die Zeile unter *** 2 in
							; "beq.s Piu2". Trotzdem bewegen Sie die
							; Maus bewegt sich der Pfeil nicht!

	bra.w	Clear			; Kehren wir zum Anfang zurück !!

; sind wir auf den Grund gegangen? Dann die BLAUE Leiste

FinePiu:
	bsr.w	MuoviFreccia	; Routine, die die Maus liest / bewegt
	lea	Barra+6,a6			; Barra in coplist
	move.w	#$0003,(a6)		; Cambiamo i COLORI della barra in BLU
	move.w	#$0006,8(a6)
	move.w	#$0009,8*2(a6)
	move.w	#$000c,8*3(a6)
	move.w	#$000f,8*4(a6)
	move.w	#$000c,8*5(a6)
	move.w	#$0009,8*6(a6)
	move.w	#$0006,8*7(a6)
	move.w	#$0003,8*8(a6)
	btst.b	#6,$bfe001		; Bis der linke Knopf losgelassen wird
	beq.s	FinePiu			; der Balken bewegt sich trotz der
							; Maus ist nicht mehr über der "+" Taste
	cmp.b	#1,ColorB		; Lassen Sie uns überprüfen, welche Farbe es vorher war
							; der Balken durch die Variable ColorB:
							; Wenn der Wert "1" ist, ist der Balken
							; grüne Farbe:
	beq.w	Verde			; Gehen wir zum GRÜNEN Etikett und geben das zurück
							; Balken in seiner ursprünglichen Farbe
	cmp.b	#2,ColorB		; Auch hier, wenn die Variable von Wert ist
	beq.w	Rosso			; "2", lass uns zum ROTEN Etikett gehen
	bra.w	Giallo			; Wenn keine Bedingung aufgetreten ist
							; Zuvor war die Bar unvermeidlich
							; GELB, denn die möglichen Farben ja
							; sie sind drei: rot, grün oder gelb!

;*****************************************************************************

Meno:
	bsr.w	Muovifreccia	; Die übliche Rede oben ist nur das wert 
	lea	barra,a6			; addiere den Wert "1" zu "bar",
	cmpi.b	#$36,8*9(a6)	; Haben wir den Boden erreicht?
	beq.s	FineMeno		; wenn es alles stoppt und die BLAUE Leiste färbt
	subq.b	#1,(a6)			; subtrahieren, so dass es sich in die Richtung bewegt
	subq.b	#1,8(a6)		; Gegenteil (aufwärts)
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
	bra.w	Clear			; Kehren wir zum Anfang zurück !!

; sind wir an die Spitze gekommen? Dann blaue Leiste!

FineMeno:
	bsr.w	MuoviFreccia	; Routine, die die Maus liest / bewegt
	lea	Barra+6,a6
	move.w	#$0003,(a6)		; color blau
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
	cmpi.b	#$1,ColorB		; Überprüfen Sie, welche Farbe der Balken hatte
	beq.w	Verde
	cmpi.b	#$2,ColorB
	beq.w	Rosso
	bra.w	Giallo

;*****************************************************************************

Music_On:
	move.b	#1,MusicFlag	; Indem Sie der MusicFlag-Variablen den Wert "1" zuweisen,
							; Wann immer wir es testen, werden wir es wissen
							; wenn die Musik aktiviert wurde.
	move.l	a5,-(SP)		; Speichern Sie a5 im Stapel
	bsr.w	mt_init			; Lassen Sie uns zu der Routine springen, die Musik spielt
	move.l	(SP)+,a5		; setze a5 vom Stapel fort

	**4
;	bsr.w	MuoviFreccia	; Routine, die die Maus liest / bewegt
	bra.w	Clear			; Gehen wir zurück an die Spitze!

;*****************************************************************************

Music_Off:
	clr.b	MusicFlag		; Indem Sie der MusicFlag-Variablen den Wert "0" geben,
							; Wann immer wir es testen, werden wir es wissen
							; wenn die Musik ausgeschaltet wurde.
	move.l	a5,-(SP)		; Speichern Sie a5 im Stapel
	bsr.w	mt_end			; Lassen Sie uns zu der Routine springen, die die Musik stoppt
	move.l	(SP)+,a5		; setze a5 vom Stapel fort
	**5
;	bsr.w	MuoviFreccia	; Routine, die die Maus liest / bewegt
	bra.w	Clear			; Gehen wir zurück an die Spitze!

;*****************************************************************************
;			Rirtono bei OldCop
;*****************************************************************************

Esci:						; Verlassen wir das Programm!!!
	move.l	a5,-(SP)		; Speichern Sie a5 im Stapel
	bsr.w	mt_end			; Lass uns die Musik ausschalten !!!: Wenn wir gedrückt haben
							; die "EXIT" Taste, während die Musik war
							; beim spielen passiert es im casino
	move.l	(SP)+,a5		; setze a5 vom Stapel fort
	rts


*******************************************************************************
*				Vari BSR				      *
*******************************************************************************

PuntaFig1:
	MOVE.L	#picture1,d0
	moveq	#4-1,d1			; 4 bitplane!
	LEA	BPLPOINTERS,A1
POINTBPa:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*84,d0		; Die Zahl ist 84 Zeilen hoch, nicht 256!!
	addq.w	#8,a1
	dbra	d1,POINTBPa

; Wir zielen alle Sprites auf das Sprite null ab, um das sicher zu stellen
; es gibt keine probleme

	MOVE.L	#SpriteNullo,d0	; Adresse der sprite in d0
	LEA	SpritePointers,a1	; Zeiger in copperlist
	MOVEQ	#8-1,d1			; alle 8 sprite
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
	rts						; Rückkehr zum BSR

PuntaFigBase:	
	MOVE.L	#picturebase,d0
	LEA	BPLPOINTERSbase,A1
	moveq	#0,d1			; 1 bitplane!
POINTBPbasenew:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*105,d0		; Die Zahl ist 105 Zeilen hoch, nicht 256!!
	addq.w	#8,a1
	dbra	d1,POINTBPbasenew
	rts						; Rückkehr

******************************************************************************
; Diese Routine prüft, ob wir einen "Button" / "Gadget" oder gedrückt haben
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
								; Geben Sie die Variable "Switched Key"
								; der Wert "1"
	cmpi.w	#$00fc,Sprite_y		; Der Pfeil befindet sich unter der Position von
								; Schlüssel?
								; Sprite_y ist> von 00fc, wenn ja:
	bhi.s	rtnCheck			; Wir sind raus!
	cmpi.w	#$00f1,Sprite_y		; Der Pfeil ist an der Linie ausgerichtet
								; der "GRÜNE Farbe ändern"?
;
	bhi.w	Effetto_Verde		; Wenn ja: Gehen Sie zu Grün Action
;
	cmpi.w	#$00fe,Sprite_y		; Sind wir zwischen 00f1 und 00fe? Wenn ja:
	bhi.s	rtnCheck			; Wir sind raus!
	cmpi.w	#$00e4,Sprite_y		; Der Pfeil ist an der Linie ausgerichtet
								; der "Farbe ändern ROT"?
;
	bhi.w	Effetto_Rosso		; Wenn ja, gehen Sie zu Aktion rot
;
	cmpi.w	#$00e1,Sprite_y		; Sind wir zwischen 00e1 und 00d7? Wenn ja:
	bhi.s	rtnCheck			; Wir sind raus!
	cmpi.w	#$00d7,Sprite_y		; Der Pfeil ist an der Linie ausgerichtet
								; der "Farbe ändern GELB"?
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
	clr.b	TastoAzionato		; Keine Tasten gedrückt haben,
	rts							; Lassen Sie uns das verlorene Programm vermeiden
								; Mal gleich nochmal nachlesen
								; die Position der Maus über die
								; Variable "Switched Key"

;*****************************************************************************
; Jetzt, da wir wissen, dass das Y das eines "Knopfes" ist, lassen Sie uns das 
; überprüfen auch wenn das X das richtige ist!
;*****************************************************************************

Azione_Tasti:
	cmpi.w	#$0111,Sprite_x		; Der Pfeil befindet sich jenseits der Tasten
								; "Musica Off"? wenn ja:
	bhi.s	rtnCheck			; Wir sind raus!
	cmpi.w	#$00ea,Sprite_x		; Der Pfeil befindet sich zwischen il tasto
								; "Musica Off"? wenn ja:
	bhi.w	Effetto_Off_Music	; Gehe zuEffetto_Off_Music

	cmpi.w	#$00dc,Sprite_x		; Der Pfeil befindet sich zwischen 00ea e 00dc? wenn ja:
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
								; "+" e "-"?
	bhi.s	Quale_Due1			; Mal sehen, welche der "+" oder "-"
	cmpi.w	#$004f,Sprite_x		; Der Pfeil befindet sich zwischen 77 und 6c?
	bhi.s	rtnCheck			; Wir sind raus!
	cmpi.w	#$003e,Sprite_x		; Der Pfeil ist auf dem Scheißknopf: -> <- !!
	bhi.s	Effetto_GiuSu		; Gehen wir zu Effetto_GiuSu
	bra.s	rtnCheck			; Wenn keine Aktion aufgetreten ist
								; dann lass uns zu rtnCheck gehen

Quale_Due2:
	cmpi.w	#$00c3,Sprite_y		; Der Pfeil befindet sich über der Taste
	bhi.w	Effetto_Quit		; "Quit"? Wenn ja, gehe zu Effekt_Quit
	cmpi.w	#$00bc,Sprite_y		; Der Pfeil befindet sich zwischen 00c3 und 00bc?
	bhi.w	rtnCheck			; Wir sind in der Mitte der beiden Taste!
	cmpi.w	#$00b0,Sprite_y		; Der Pfeil befindet sich zwischen 00bc und 00b0?
	bhi.w	Effetto_Pal			; Andiamo a Effetto_Pal
	
Quale_Due1:
	cmpi.w	#$00c3,Sprite_y		; Der Pfeil befindet sich über der Taste
	bhi.s	Effetto_Piu			; "Piu"? Wenn ja, gehe zu Effekt_Piu
	cmpi.w	#$00bc,Sprite_y 	; Der Pfeil befindet sich zwischen 00bc und 00c3?
	bhi.w	rtnCheck			; Wir sind in der Mitte der beiden Taste!
	cmpi.w	#$00b0,Sprite_y		; Der Pfeil befindet sich zwischen 00b0 und 00bc?
	bhi.w	Effetto_Meno		; Andiamo a Effetto_Meno


;*****************************************************************************
; Geben wir nun der Aktionsvariablen den Wert der gedrückten Taste
;*****************************************************************************

Effetto_Verde:				; Wenn ja, wird dieser Zustand überprüft
	move.b	#$d,Azione		; es bedeutet, dass wir über dem sind
	rts						; bar GRÜN! Dann informieren wir die
							; Programm, das gedrückt wurde
							; dieser "Schlüssel" durch die Variable
							; Aktion mit dem Wert "d".
Effetto_Rosso:
	move.b	#$e,Azione		; Wie oben, bis auf die Schaltfläche
	rts						; -Rosso- Wir geben den Wert von  "e".

Effetto_Giallo:
	move.b	#$f,Azione		; Wie oben, bis auf die Schaltfläche
	rts						; -Giallo- Wir geben den Wert von   "f".

Effetto_GiuSu:
	move.b	#$1,Azione		; Wie oben, bis auf die Schaltfläche
	rts						; -GiuSu- Wir geben den Wert von "1".

Effetto_Piu:
	move.b	#$2,Azione		; Wie oben, bis auf die Schaltfläche
	rts						; -Piu- Wir geben den Wert von "2".

Effetto_Meno:
	move.b	#$3,Azione		; Wie oben, bis auf die Schaltfläche
	rts						; -Meno- Wir geben den Wert von "3".

Effetto_Pal:
	move.b	#$4,Azione		; Wie oben, bis auf die Schaltfläche
	rts						; -Pal- Wir geben den Wert von "4".

Effetto_Quit:
	move.b	#$5,Azione		; Wie oben, bis auf die Schaltfläche
	rts						; -Quit- Wir geben den Wert von "5".

Effetto_Off_Music
	move.b	#$6,Azione		; Wie oben, bis auf die Schaltfläche
	rts						; -Off_Music- Wir geben den Wert von "6".

Effetto_On_Music
	move.b	#$7,Azione		; Wie oben, bis auf die Schaltfläche
	rts						; -On_Music- Wir geben den Wert von "7".
	
*************************************************************************
* Routine, die die Position der Maus lieste				*
* Betreten der Koordinaten in Mouse_x/Mouse_y - Sprite_x/Sprite_Y	*
*************************************************************************

LeggiMouse:
	move.b	$a(a5),d1		; $dff00a - JOY0DAT byte hoch
	move.b	d1,d0
	sub.b	mouse_y(PC),d0
	beq.s	no_vert
	ext.w	d0
	add.w	d0,sprite_y
no_vert:
  	move.b	d1,mouse_y
	move.b	$b(a5),d1		; $dff00a - JOY0DAT - byte niedrig
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
*		Routine die das sprite0	bewegt	*
*********************************************************
;	a1 = Adresse des sprite
;	d0 = vertikale Y-Position des Sprites auf dem Bildschirm (0-255)
;	d1 = X horizontale Position des Sprites auf dem Bildschirm (0-320)
;	d2 = Höhe von sprite

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
*		Timing und Update von Sprite-LOOPs	      *
*******************************************************************************

MuoviFreccia:

; Dies ist eine Timing-Routine, da sie als Referenz verwendet wird
; den Elektronenstrahl mit 50 Hz (es sei denn, Sie verwenden das System
; NTSC! (60Hz!)). Genau, der Pinsel in allen Computern hat das gleiche
; Geschwindigkeit, sowohl im alten A500 als auch im A4000.

	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$0fe00,d2	; Warte auf Zeile $fe (254)
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Warte auf Zeile $fe (254)
	BNE.S	Waity1


	tst.b	MusicFlag	; Wenn MusicFlag "0" ist, ist Musik nicht
	beq.w	NoMusic2	; eingeschaltet worden, so überspringen wir die 
						; folgende Zeile
	move.l	a5,-(SP)	; Speichern Sie a5 im Stapel
	bsr.w	mt_music	; Die Musik wird abgespielt, wenn die Taste gedrückt wurde
						; "On_Music"
	move.l	(SP)+,a5	; setze a5 vom Stapel fort

NoMusic2:
	bsr.w	LeggiMouse	; Wechseln Sie zu der Routine, die die Position 
						; der Maus liest
	move.w	sprite_y(pc),d0	; Bereiten Sie die Koordinaten von vor y
	move.w	sprite_x(pc),d1	; Bereiten Sie die Koordinaten von vor x
	lea	miosprite0,a1	; wähle das zu bewegende Sprite aus
	moveq	#13,d2		; Bereiten Sie die Länge des Sprites vor
	bsr.w	UniMuoviSprite	; Springen wir zu der Routine, die das Sprite bewegt
	bsr.w	PrintCarattere	; Schreiben Sie den Text

	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$0fe00,d2	; Warte auf Zeile $0fe (254)
Aspetta:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Warte auf Zeile $0fe (254)
	BEQ.S	Aspetta

	rts

;***************************************************************************
; "Spezialeffekt" des Schließens und Öffnens der Spalte DIWSTART/STOP
;***************************************************************************

	
GiuSu:
	bsr.w	SchermoChiudi	; Lassen Sie uns zu der Routine springen, die den Bildschirm schließt
	bsr.w	SchermoApri		; Lassen Sie uns zu der Routine springen, die den Bildschirm öffnet
	bra.w	Clear			; Gehen wir zurück an die Spitze!

;*****************************************************************************

SchermoChiudi:
	bsr.w	MuoviFreccia	; warte bis 1 FRAME-Zyklus abgelaufen ist !!
	ADDQ.B	#1,DiwYStart	; Senken Sie den oberen Bildschirm um ein Pixel
	SUBQ.B	#1,DIWySTOP		; Wir vergrößern den unteren Bildschirm um ein Pixel
	CMPI.b	#$ad,DiwYStart	; Wenn wir die gewünschte Position erreicht haben,
	beq.s	Finito3			; dann gehen wir raus, sonst setzen wir das zurück
	bra.s	SchermoChiudi	; pixel
Finito3:
	rts

SchermoApri:
	bsr.w	MuoviFreccia	; Lass es stattdessen zunehmen, wir machen es
							; abnehmen, das heißt wir kehren um:
							; addq # 1, DiwyStart
	SUBQ.B	#5,DiwYStart	; subq #1,DiwyStop
	ADDQ.B	#5,DIWySTOP		; jeweils mit
	CMPI.B	#$2c,DiwYStop	; subq #5,DiwyStart
	beq.w	Finito4			; addq #5,DiwyStop
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
		
SPRITE_Y:	dc.w	$a0	; hier wird das Y des Sprites gespeichert
						; Durch Ändern dieses Wertes können wir Y ändern
						; die Ausgangsposition der Maus
SPRITE_X:	dc.w	0	; hier wird das X des Sprites gespeichert
						; Durch Ändern dieses Wertes können wir X ändern
						; die Ausgangsposition der Maus
MOUSE_Y:	dc.b	0	; hier ist die Maus Y gespeichert
MOUSE_X:	dc.b	0	; hier ist die Maus X gespeichert

*****************************************************************************
;			Routine DRUCK
*****************************************************************************

PRINTcarattere:
	MOVE.L	PuntaTESTO(PC),A0 ; Adresse des zu druckenden Textes in a0
	MOVEQ	#0,D2			; löschen d2
	MOVE.B	(A0)+,D2		; Nächstes Zeichen in d2
	CMP.B	#$ff,d2			; Ende des Textsignals? ($FF)
	beq.s	FineTesto		; wenn ja, esci senza stampare
	TST.B	d2				; Zeilenende-Signal? ($00)
	bne.s	NonFineRiga		; Wenn nicht, nicht einpacken

	ADD.L	#40*7,PuntaBITPLANE	; Gehen wir zum Kopf
	ADDQ.L	#1,PuntaTesto		; erste Zeichenzeile nach
								; (überspringe die NULL)
	move.b	(a0)+,d2			; erstes Zeichen der Zeile nach
								; (überspringe die NULL)

NonFineRiga:
	SUB.B	#$20,D2		; ADDIERE 32 ZUM ASCII - WERT DES ZEICHENS
						; WIE MAN ZB DAS TRANSFORMIERT
			; DAS LEERZEICHEN (das sind $20), in $00 das
			; VON ASTERISC($21), in $01 ...
	LSL.W	#3,D2		; MULTIPLIZIERE FMIT 8 DIE VORHERIGE NUMMER,
						; Die Zeichen sind 8 Pixel hoch
	MOVE.L	D2,A2
	ADD.L	#FONT,A2	; FINDEN SIE DAS GEWÜNSCHTE ZEICHEN IN DER SCHRIFTART...

	MOVE.L	PuntaBITPLANE(PC),A3 ; Adr. der Zielbitebene in a3

				; WIR DRUCKEN DAS ZEILENZEICHEN ZEILENWEISE
	MOVE.B	(A2)+,(A3)		; Drucken Sie die Zeile 1 von Charakter
	MOVE.B	(A2)+,40(A3)	; Drucken Sie die Zeile 2  " "
	MOVE.B	(A2)+,40*2(A3)	; Drucken Sie die Zeile 3  " "
	MOVE.B	(A2)+,40*3(A3)	; Drucken Sie die Zeile 4  " "
	MOVE.B	(A2)+,40*4(A3)	; Drucken Sie die Zeile 5  " "
	MOVE.B	(A2)+,40*5(A3)	; Drucken Sie die Zeile 6  " "
	MOVE.B	(A2)+,40*6(A3)	; Drucken Sie die Zeile 7  " "
	MOVE.B	(A2)+,40*7(A3)	; Drucken Sie die Zeile 8  " "

	ADDQ.L	#1,PuntaBitplane ; wir bewegen uns 8 Bits vorwärts (NÄCHSTER ZEICHEN)
	ADDQ.L	#1,PuntaTesto	; nächstes zu druckendes Zeichen

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

; Die FONT 8x8-Zeichen, die in CHIP von der CPU und nicht vom Blitter kopiert wurden,
; so kann es auch im schnellen ram sein. In der Tat wäre es besser!

FONT:
	;incbin	"assembler2:sorgenti4/nice.fnt"
	 incbin	"nice.fnt"

*******************************************************************************
*			ROUTINE MUSICALE
*******************************************************************************

	include	"music.s"

*******************************************************************************
;			MEGACOPPERLISTONA GALATTICA (quasi...)
*******************************************************************************


	SECTION	GRAPHIC,DATA_C


COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$8E	; DiwStrt
DiwYStart:
	dc.b	$30
DIWXSTART:
	dc.b	$81
	dc.w	$90	; DiwStop
DIWYSTOP:
	dc.b	$2c
DIWXSTOP:
	dc.b	$c1
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,$24	; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

		    ; 5432109876543210
	dc.w	$100,%0100001000000000	; BPLCON0 - 4 planes lowres (16 color)

; Bitplane pointers

BPLPOINTERS:
	dc.w $e0,0,$e2,0	; erste bitplane
	dc.w $e4,0,$e6,0	; zweite bitplane
	dc.w $e8,0,$ea,0	; dritte bitplane
	dc.w $ec,0,$ee,0	; vierte bitplane

; Die ersten 16 Farben sind für das LOGO

	dc.w $180,$000,$182,$fff,$184,$200,$186,$310
	dc.w $188,$410,$18a,$620,$18c,$841,$18e,$a73
	dc.w $190,$b95,$192,$db6,$194,$dc7,$196,$111
	dc.w $198,$222,$19a,$334,$19c,$99b,$19e,$446


	dc.w	$1A2,$fff	; color17   Color
	dc.w	$1A4,$fa6	; color18   der
	dc.w	$1A6,$000	; color19   Maus

BARRA:
	dc.w	$5c07,$FFFE	; warte auf die Zeile $50
	dc.w	$180,$300	; starte den roten Balken: rot mit 3
	dc.w	$5d07,$FFFE	; nächste Zeile
	dc.w	$180,$600	; rot mit 6
	dc.w	$5e07,$FFFE
	dc.w	$180,$900	; rot mit 9
	dc.w	$5f07,$FFFE
	dc.w	$180,$c00	; rot mit 12
	dc.w	$6007,$FFFE
	dc.w	$180,$f00	; rot mit 15 (al massimo)
	dc.w	$6107,$FFFE
	dc.w	$180,$c00	; rot mit 12
	dc.w	$6207,$FFFE
	dc.w	$180,$900	; rot mit 9
	dc.w	$6307,$FFFE
	dc.w	$180,$600	; rot mit 6
	dc.w	$6407,$FFFE
	dc.w	$180,$300	; rot mit 3
	dc.w	$6507,$FFFE
	dc.w	$180,$000	; color schwarz


; roter Balken unter dem Logo

	dc.w	$8407,$fffe	; Ende des logo

BPLPOINTER2:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$100,$1200	; 1 bitplane (rücksetzen)

	dc.w	$8507,$FFFE	; folgende Zeile 
	dc.w	$180,$606	; viola
	dc.w	$8607,$FFFE
	dc.w	$180,$909	; viola
	dc.w	$8707,$FFFE
	dc.w	$180,$c0c	; viola
	dc.w	$8807,$FFFE
	dc.w	$180,$f0f	; viola (höchstens)
	dc.w	$8907,$FFFE
	dc.w	$180,$c0c	; viola
	dc.w	$8a07,$FFFE
	dc.w	$180,$909	; viola
	dc.w	$8b07,$FFFE
	dc.w	$180,$606	; viola
	dc.w	$8c07,$FFFE
	dc.w	$180,$303	; viola
	dc.w	$8d07,$FFFE
	dc.w	$180,$000	; color schwarz

	dc.w	$182,$fe3	; Color Text

; zentrale bar

	dc.w	$9007,$FFFE	; folgende Zeile

	dc.w	$180,$011	; celestino a 11
	dc.w	$9507,$FFFE
	dc.w	$180,$022	; celestino a 22
	dc.w	$9a07,$FFFE
	dc.w	$180,$033	; celestino a 33
	dc.w	$9f07,$FFFE
	dc.w	$180,$055	; celestino a 55
	dc.w	$a407,$FFFE
	dc.w	$180,$077	; celestino a 77
	dc.w	$a907,$FFFE
	dc.w	$180,$099	; celestino a 99
	dc.w	$ae07,$FFFE
	dc.w	$180,$077	; celestino a 77
	dc.w	$b307,$FFFE
	dc.w	$180,$055	; celestino a 55
	dc.w	$b807,$FFFE
	dc.w	$180,$033	; celestino a 33
	dc.w	$bd07,$FFFE
	dc.w	$180,$022	; celestino a 22
	dc.w	$c207,$FFFE
	dc.w	$180,$011	; celestino a 11

*****Figura di base:

	dc.w	$c607,$FFFE	; Wir warten auf die Schlange c6
	dc.w	$180,$000	; color SCHWARZ

		    ; 5432109876543210
	dc.w	$100,%0001001000000000	; 1 bitplane je LoRes

BPLPOINTERSbase:
	dc.w $e0,$0000,$e2,$0000
CopBase:	
	dc.w $0180,$0000,$0182,$0877

; roter Balken über dem Panel

	dc.w	$ca07,$FFFE	; nächste Zeile
	dc.w	$180,$606	; rot
	dc.w	$cb07,$FFFE
	dc.w	$180,$909	; rot
	dc.w	$cc07,$FFFE
	dc.w	$180,$c0c	; rot
	dc.w	$cd07,$FFFE
	dc.w	$180,$f0f	; rot (höchstens)
	dc.w	$ce07,$FFFE
	dc.w	$180,$c0c	; rot
	dc.w	$cf07,$FFFE
	dc.w	$180,$909	; rot
	dc.w	$d007,$FFFE
	dc.w	$180,$606	; rot
	dc.w	$d107,$FFFE
	dc.w	$180,$303	; rot
	dc.w	$d207,$FFFE
	dc.w	$180,$000	; colore schwarz

	dc.w	$ca07,$FFFE	; WAIT - Ich warte auf die Zeile $ca
	dc.w	$180,$001	; COLOR0 - sehr dunkelblau
	dc.w	$cc07,$FFFE	; WAIT - Zeile 74 ($4a)
	dc.w	$180,$002	; etwas intensiver blau
	dc.w	$ce07,$FFFE	; Zeile 75 ($4b)
	dc.w	$180,$003	; blau mit 3
	dc.w	$d007,$FFFE	; nächste Zeile
	dc.w	$180,$004	; blau mit 4
	dc.w	$d207,$FFFE	; nächste Zeile
	dc.w	$180,$005	; blau mit 5
	dc.w	$d407,$FFFE	; nächste Zeile
	dc.w	$180,$006	; blau mit 6
	dc.w	$d607,$FFFE	; Sprung 2 Zeile: von $4e a $50, d.h. von 78 a 80
	dc.w	$180,$007	; blau mit 7
	dc.w	$d807,$FFFE	; sato 2 Zeile
	dc.w	$180,$008	; blau mit 8
	dc.w	$da07,$FFFE	; Sprung 3 Zeile
	dc.w	$180,$009	; blau mit 9
	dc.w	$e007,$FFFE	; Sprung 3 Zeile
	dc.w	$180,$00a	; blau mit 10
	dc.w	$e507,$FFFE	; Sprung 3 Zeile
	dc.w	$180,$00b	; blau mit 11
	dc.w	$ea07,$FFFE	; Sprung 3 Zeile
	dc.w	$180,$00c	; blau mit 12
	dc.w	$f007,$FFFE	; Sprung 4 Zeile
	dc.w	$180,$00d	; blau mit 13
	dc.w	$f507,$FFFE	; Sprung 5 Zeile
	dc.w	$180,$00e	; blau mit 14
	dc.w	$fa07,$FFFE	; Sprung 6 Zeile
	dc.w	$180,$00f	; blau mit 15

	dc.w	$ffdf,$FFFE	; Warte Zeile $ff

	dc.w	$0207,$FFFE	; warten
	dc.w	$182,$0f0	; colore 1 grün

	dc.w	$0f07,$FFFE	; warten
	dc.w	$182,$f22	; colore 1 rot

	dc.w	$1c07,$FFFE	; warten
	dc.w	$182,$ff0	; colore 1 gelb

	dc.w	$2907,$FFFE	; warten
	dc.w	$182,$877	; colore 1 grau

	dc.w	$FFFF,$FFFE	; Ende copperlist

*******************************************************************************
*				Sprite					      *
*******************************************************************************
; Wie immer sollte die Grafik NUR wie die copperliste in CHIP geladen werden!!

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


SpriteNullo:			; Sprite Nullzeiger in copperlist
	dc.l	0,0,0,0		; in nicht verwendeten Zeigern

PICTUREbase:
	;incbin	"base320*105*1.raw"
	blk.b 4200,$FF		; 1 Bitplanes 
; DIch wähle eine Breite von 320 Pixel, hoch 84, 4 Bitebenen (16 Farben).

PICTURE1:
	;incbin	"logo320*84*16c.raw"
	blk.b 13440,$FF		; 4 Bitplanes 

; Musik. Achtung: Die "music.s" -Routine von Disc 2 ist nicht dieselbe wie
; Die beiden Änderungen betreffen die Entfernung eines BUG als alle
; manchmal hat es einen Guru dazu gebracht, das Programm zu verlassen, und 
; die Tatsache, dass in mt_data Es ist ein Hinweis auf Musik, nicht auf
; Musik. Dies ermöglicht es Ihnen, zu ändern
; die Musik leichter.

mt_data:
	dc.l	mt_data1

mt_data1:
	incbin	"mod.JamInExcess"

	Section	MiniBitplane,bss_c

;	Der Text wird in diesem Puffer gedruckt

BufferVuoto:
	ds.b	40*68

	end			
				; Der Computer liest nicht über das ENDE hinaus!
				; Jetzt können wir alles ohne es schreiben
				; die PUNKTE und VIRGOLA oder ASTERISCHI


Wenn Sie mit jedem Tastendruck einen anderen Videoeffekt erzielen möchten, 
müssen Sie dies wissen
wenn der linke Knopf gedrückt wird und, wenn ja, die Position des
Sprite der Maus. Kurz gesagt, wir müssen wissen, welche Taste gedrückt wurde
So führen Sie einen anderen Videoeffekt aus:

Sobald wir mit dem Programm beginnen, finden wir ein Steuerelement: "Linke 
Taste gedrückt?", Wenn die Taste nicht gedrückt wurde, fahren wir mit der 
Programmaktualisierung fort
Bewegen Sie den Pfeil auf den Bildschirm, wenn dies der Fall war
gedrückt, springen wir zu einer Routine, die die Position von vergleicht:
 - Sprite_x
 - Sprite_y
mit den Koordinaten, wo unsere Schlüssel sind!

**************************** Basteltrick *************************

Aber woher kennst du die X- und Y-Koordinaten unserer "Buttons"? ruhig,
Sie müssen nicht Milliarden von Tests oder Berechnungen mit dem Auge machen! 
Da hat ASMONE ein L.M. eingebauten können wir dies tun: zeichnen Sie die
Bedienfeld, das Sie möchten, mit Ihren Tasten; einmal gezeigt
und das ganze visualisiert, mit der mausroutine ist es gerade die zeit dazu
wissen, welchen Koordinaten die Tasten entsprechen.

Wenn Sie die Position jedes Schlüssels überprüfen möchten, setzen Sie ihn 
einfach an den Anfang des
Programm (anstelle von **** 1), diese einfache Schleife:

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

Dadurch wird die Mausposition aktualisiert, verschoben und beim Drücken der Taste
linke Maustaste, wir beenden einfach das Programm !!
Positionieren Sie sich an der Koordinate, die Sie wissen möchten, zum Beispiel an 
einer Ecke von und verlassen Sie das Menü mit der linken Maustaste.
Jetzt müssen Sie nur noch die letzten Positionen sehen, die Sie mit der Maus 
eingenommen haben mythischer "M" -Befehl (nach Drücken der ESC-Taste):

	m Sprite_x   (premere RETURN)
	m Sprite_y   (premere RETURN)

Der Befehl "M" ist sehr nützlich. Es wird häufig verwendet, um zu überprüfen, an
welchem ?? "Punkt" oder womit "Wert" angekommen ist. Zum Beispiel, wenn Sie einen
stoppen wollten Sprite oder ein Balken an einem bestimmten Punkt, machen Sie einfach 
eine Schleife, die es vorwärts bewegt
bis die Maus gedrückt wird. Starten Sie das Programm, drücken Sie die Maus
wenn es zu dem Punkt kam, den Sie wollen, und machen Sie "M variable". Einfach !!!

***************************************************************************

Versuchen Sie als Test, das Sprite an verschiedenen Stellen auf dem Bildschirm 
anzuzeigen. Versuchen Sie beim Starten des Programms auch, die
Mauszeiger im Rechteck der unteren Abbildung.

Eine Sache, die Sie sicherlich bemerkt haben, ist die Tatsache, dass, wenn wir die 
Taste "+" drücken oder "-", und wir lassen die linke Maustaste nicht los, die Leiste
wird fortgesetzt Unerschrocken zu bewegen, auch wenn wir den Pfeil aus der Schaltfläche
bewegen:
Dies liegt daran, wie in Punkt ** 2 erläutert, bis wir freigegeben haben
Bei gedrückter Maustaste überprüft das Programm die Position der Maus nicht erneut!
Um dies zu ändern, fügen Sie einfach ** 2 hinzu:

	bsr.s	MuoviFreccia

offensichtlich das weglassen

	btst.b	#6,$bfe001
	beq.s	Piu

Versuchen Sie auch, Punkt zu ändern ** 3

Füge jetzt nur noch hinzu:

	brs.s	MuoviFreccia 

An den Punkten ** 4, ** 5 sehen Sie, was passiert:
Geben Sie einfach den Schlüssel ein oder aus, der den Effekt startet!

Im Gegensatz zu den anderen Tasten reicht das für die "Balkenfarbe ändern"
Bewegen Sie den Mauszeiger darüber, um den gewünschten Effekt zu erzielen!
Jetzt solltest du wissen warum!

Schließlich "blockieren" die Tasten, die die Musik aktivieren und deaktivieren, auch 
die Pfeil ... für Sie das schwierige Problem zu verstehen, warum.

