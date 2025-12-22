
; Lezione9g1.s	Anzeigen eines INTERLEAVED-Bildes
				; Linke Taste zum Beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:

	MOVE.L	#BITPLANE,d0	; 
	LEA	BPLPOINTERS,A1		; Bitplanepointer
	MOVEQ	#3-1,D1			; Anzahl der Bitebenen (hier sind 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0			; HIER IST DER ERSTE UNTERSCHIED ZU
						; DEN NORMALEN BILDERN !!!!!!
	ADD.L	#40,d0		; + LÄNGE einer ZEILE !!!!!
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

mouse:
	btst	#6,$bfe001	; linke Maustaste gedrückt?
	bne.s	mouse		; Wenn nicht, gehe zurück zu mouse:
	rts					; Ausgang

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
				
			; HIER IST DER ZWEITE UNTERSCHIED 
			; ZU NORMALEN BILDERN !!!!!!
	dc.w	$108,80		; Wert MODULO = 2*20*(3-1)= 80
	dc.w	$10a,80		; BEIDE MODULO MIT GLEICHEN WERT.

	dc.w	$100,$3200	; bplcon0 - 3 bitplanes lowres

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane
	dc.w $e4,$0000,$e6,$0000
	dc.w $e8,$0000,$ea,$0000

	dc.w	$0180,$000	; color0
	dc.w	$0182,$475	; color1
	dc.w	$0184,$fff	; color2
	dc.w	$0186,$ccc	; color3
	dc.w	$0188,$999	; color4
	dc.w	$018a,$232	; color5
	dc.w	$018c,$777	; color6
	dc.w	$018e,$444	; color7

	dc.w	$FFFF,$FFFE	; Ende copperlist


BITPLANE:
	incbin	"assembler2:sorgenti6/amiga.rawblit"
	
			; Hier laden wir die Figur ein
			; RAWBLIT-Format (oder interleaved),
			; mit KEFCON konvertiert.
	end

In diesem Beispiel zeigen wir ein Bild im Interleaved-Format an
(oder Rawblit, wie KEFCON es nennt). Das ist das übliche Bild, aber
wir mussten es in das interleaved-Format konvertieren, also verwenden
wir eine andere Datei.
Wie wir es bereits in der Lektion gesagt haben, um Bilder in diesem Format
anzuzeigen müssen Sie 2 Dinge im Vergleich zu normalen Bildern ändern:

1) Beim Zeiger der Bitebene ist es notwendig, die Adressen der 
verschiedenen Bitplanes zu berechnen, die zwischen den 
einzelnen Linie "liegen" und nicht durch alle Linien der Bitebene

2) die Bitebenen Modulo sind nicht gleich 0, sondern dienen dazu, die 
Zeilen der andere Bitplanes zu überspringen. Sie werden mit der Formel 
berechnet, die wir in der Lektion gesehen haben:

 MODULO=2*L*(N-1) 	Wobei L die Breite der Bitebene ist, ausgedrückt in 
					Worten und N ist die Anzahl der Bitebenen

In unserem Fall sind die Bitebenen 20 Wörter breit (320/16) oder 40 Bytes,
und die Anzahl der Bitebenen ist 3. Sie können den
Unterschied 1) in den ersten Zeilen des Programms finden, in der Schleife, 
wo die Zeiger auf die Bitebenen in die Copperliste geladen werden, und der
Unterschied 2) in der Copperliste die Anweisungen, die den Wert der Modulo
in die Register BPL1MOD und BPL2MOD laden.

