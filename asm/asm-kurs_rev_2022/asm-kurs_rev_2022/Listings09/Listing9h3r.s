
; Listing9h3r.s		Wir lassen ein Bild erscheinen
		; immer eine Pixelspalte gleichzeitig 
		; Rechte Taste um den Blitt zu starten, links um zu beenden.	
		; Hinweis: Bild in RAWBLIT (oder interleaved, wenn Sie es bevorzugen).

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA ; $83C0


START:
	MOVE.L	#BITPLANE,d0		; Zeiger auf das Bild
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	MOVEQ	#3-1,D1				; Anzahl Bitplanes (hier sind es 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0				
								; HIER IST DER ERSTE UNTERSCHIED
								; ZU DEN NORMALEN BILDERN !!!!!!
	ADD.L	#40,d0				; + Länge einer Zeile !!!!!
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper, blitter
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse1:
	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse1				; Wenn nicht, gehe zurück zu mouse1:

	bsr.s	Mostra				; Routine ausführen

mouse2:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse2				; Wenn nicht, gehe zurück zu mouse2:

	rts


; ************************ DIE ROUTINE, DIE DIE FIGUR ZEIGT *******************

;	     .øØØØØØø.
;	     |¤¯_ _¬¤|
;	    _|___ ___|_
;	   (_| (·T.) l_)
;	    /  ¯(_)¯  \
;	   /____ _ ____\
;	  //    Y Y    \\
;	 //__/\_____/\__\\ xCz
;	(_________________)

Mostra:

; Anfangswerte von Zeigern

	lea	picture,a0				; zeigt auf den Anfang der Figur
	lea	bitplane,a1				; zeigt auf den Anfang der ersten Bitebene

	moveq	#20-1,d7			; alle Wort- "Spalten" ausführen
								; Der Bildschirm ist 20 Wörter breit
								; Es gibt 20 Spalten.

FaiTutteLeWord:
	moveq	#16-1,d6			; 16 Pixel für jedes Wort.
	move.w	#%1000000000000000,d0	; Wert der Maske am Anfang der
								; internen Schleife. Wir übergeben nur das
								; Pixel ganz links vom Wort.
FaiUnaWord:

; warte auf Vblank, um jeweils eine Pixelspalte pro Frame zu zeichnen

WaitWblank:
	CMP.b	#$ff,$dff006		; vhposr - warte auf die Zeile 255
	bne.s	WaitWblank
Aspetta:
	CMP.b	#$ff,$dff006		; vhposr - noch Zeile 255 ?
	beq.s	Aspetta

	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
waitblit:
	btst	#6,2(a5)
	bne.s	waitblit

	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 - Kopie von A nach D
	move.w	#$ffff,$44(a5)		; BLTAFWM - alle Bits übergeben
	move.w	d0,$46(a5)			; Wert der Maske in das BLTALWM Register laden

								; Lade die Zeiger
	move.l	a0,$50(a5)			; bltapt
	move.l	a1,$54(a5)			; bltdpt

; Sowohl für die Quelle als auch für das Ziel blitten wir ein Wort auf einen 
; 20 Wörter breiten Bildschirm. Also hat das Modulo den Wert 2 * (20-1) = 38 = $26.
; Da die 2 Register aufeinanderfolgende Adressen haben, braucht man nur eine
; Anweisung anstatt 2 zu verwenden:

	move.l #$00260026,$64(a5)	; bltamod und bltdmod 

; wir blitten ein 256 Zeilen hohes Wort "Spalte" (den ganzen Bildschirm)

	move.w	#(3*256*64)+1,$58(a5)	; bltsize
								; Höhe 256 Zeilen von 3 Ebenen
								; 1 Wortbreite
						
	asr.w	#1,d0				; die Maske für den nächsten Blitt vorbereiten

	dbra	d6,FaiUnaWord		; für alle Pixel wiederholen
	
	addq.w	#2,a0				; auf das nächste Wort zeigen
	addq.w	#2,a1				; auf das nächste Wort zeigen

	dbra	d7,FaiTutteLeWord	; für alle Wörter wiederholen 

	btst	#6,$02(a5)			; dmaconr - warte auf das Ende des Blitters
waitblit2:
	btst	#6,$02(a5)
	bne.s	waitblit2

	rts

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$38				; DdfStart
	dc.w	$94,$d0				; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2

								; HIER IST DER ZWEITE UNTERSCHIED
								; ZU DEN NORMALEN BILDERN !!!!!!
	dc.w	$108,80				; WERT MODULO = 2*20*(3-1)= 80
	dc.w	$10a,80				; BEIDE MODULO MIT GLEICHEN WERT.

	dc.w	$100,$3200			; bplcon0 - 3 bitplanes lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane
	dc.w	$e4,$0000,$e6,$0000
	dc.w	$e8,$0000,$ea,$0000

	dc.w	$0180,$000			; color0
	dc.w	$0182,$475			; color1
	dc.w	$0184,$fff			; color2
	dc.w	$0186,$ccc			; color3
	dc.w	$0188,$999			; color4
	dc.w	$018a,$232			; color5
	dc.w	$018c,$777			; color6
	dc.w	$018e,$444			; color7

	dc.w	$FFFF,$FFFE			; Ende copperlist

;****************************************************************************

PICTURE:
	incbin	"/Sources/amiga.rawblit"			
								; Hier laden wir die Figur ein
								; RAWBLIT-Format (oder interleaved),
								; mit KEFCON konvertiert.

;****************************************************************************

	section	gnippi,bss_C

bitplane:
		ds.b	40*256			; 3 bitplanes
		ds.b	40*256
		ds.b	40*256
	end

;****************************************************************************

Dieses Beispiel ist die RawBlit-version von Listing9h3.s. Vergleichen Sie 
die Unterschiede in den Formeln zur Berechnung der zu schreibenden Werte
in die Blitter-Register.

