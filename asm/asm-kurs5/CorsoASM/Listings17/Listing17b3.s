		************************************
		*       /\/\                       *
		*      /    \                      *
		*     / /\/\ \ O R B_I D           *
		*    / /    \ \   / /              *
		*   / /    __\ \ / /               *
		*   ¯¯     \ \¯¯/ / I S I O N S    *
		*           \ \/ /                 *
		*            \  /                  *
		*             \/                   *
		*     Feel the DEATH inside!       *
		************************************
		* Coded by:                        *
		* The Dark Coder / Morbid Visions  *
		************************************

; Listing17b3.s = skip3.s

; Kommentare am Ende der Quelle

	SECTION	DK,code

	incdir	"Include/"
	include	MVstartup.s			; Startup Code: Nimmt
								; Systemprüfung vor und Aufruf
								; durch Platzieren der START-Routine: 
								; A5=$DFF000

			;5432109876543210
DMASET	EQU	%1000001010000000	; copper DMA


Start:

	move	#DMASET,dmacon(a5)
	move.l	#COPPERLIST,cop1lc(a5)
	move	d0,copjmp1(a5)

	move.l	#copperloop,cop2lc(a5)	; Laden der Schleifenadresse
								; in COP2LC

mouse:

	bsr	CambiaCopper

	moveq	#3-1,d7
WaitFrame
; Beachten Sie die doppelte Überprüfung der Synchronität
; notwendig, da Muovicopper-Bewegungen auf 68030 WENIGER als EINE Rasterlinie erfordern
	move.l	#$1ff00,d1			; Bits durch UND auswählen
	move.l	#$13000,d2			; warte auf Zeile $130 (304)
.waity1
	move.l	vposr(a5),d0		; vposr und vhposr
	and.l	d1,d0				; wählen Sie nur die Bits der vertikalen Pos.
	cmp.l	d2,d0				; warte auf Zeile $130 (304)
	bne.s	.waity1

.waity2
	move.l	vposr(a5),d0
	and.l	d1,d0
	cmp.l	d2,d0
	beq.s	.waity2

	dbra	d7,WaitFrame

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse				; wenn nicht, gehe zurück zu mouse:

	rts

****************************************************
* Diese Routine bewegt die Flagge und ändert die Farben

CambiaCopper:

	move.b	PosBandiera(pc),d0

	tst.b	PosFlag
	beq.s	Basso

	subq.b	#1,d0			
	cmp.b	#$81,d0
	bra.s	Muovi				; Die Bcc-Anweisungen ändern die CCs nicht

Basso:	
	addq.b	#1,d0
	cmp.b	#$bf,d0

Muovi:
	shs	PosFlag					; Testgrenzen (beide!;)
	move.b	d0,PosBandiera
	lsl	#8,d0
	move.b	#$07,d0
	move	d0,Inizio
	add	#$4000,d0
	move	d0,Fine

	tst.b	FadeFlag
	beq.s	FadeIn

FadeOut:
	sub	#$010,verde+2			; erhöht die Helligkeit
	cmp	#$080,verde+2
	sne	FadeFlag				; wenn wir mindestens sind, wechseln Sie zu FadeIn

	sub	#$111,bianco+2			; erhöht die Helligkeit
	sub	#$100,rosso+2			; erhöht die Helligkeit
	rts

FadeIn:
	add	#$010,verde+2			; erhöht die Helligkeit
	cmp	#$0f0,verde+2			; wenn wir maximal sind, geht es zu FadeOut
	seq	FadeFlag

	add	#$111,bianco+2			; erhöht die Helligkeit
	add	#$100,rosso+2			; erhöht die Helligkeit

	rts

* Positionieren der ersten Zeile der Flagge
; Die Flagge muss zwischen den Zeilen $80 und $ff bleiben und 
; daher $40 hoch sein,
; die Position muss zwischen den Zeilen $80 und $bf variieren
PosBandiera	dc.b	$a0
PosFlag		dc.b	0
FadeFlag	dc.b	0

	SECTION	MY_COPPER,CODE_C

*************************************************************************
* Copper Macros by The Dark Coder / Morbid Visions
* vers. 3 SE / 16-07-96 / für ASM One 1.29
* Dies ist eine kleinere Version der Coppermakros, die von den Morbid Visions verwendet werden
* speziell erstellt für veröffentlichte Quellen auf Infamia.
* Vollversion (integriert in andere MV-Standardmakros) hat
* zusätzliche Fehlerprüfungen und die Verwendung des Blitters
* Finished Disable bit. Interessenten können sich an The Dark Coder wenden.

* Format
* CMOVE unmittelbarer Wert, Register Hardware Ziel
* WAIT  Hpos,Vpos[,Hena,Vena]
* SKIP  Hpos,Vpos[,Hena,Vena]
* CSTOP

* Hinweis: Hpos,Vpos Koordinate copper, Hena, Vena sind die Maskenwerte
* der copperposition, optional (falls nicht angegeben, wird davon ausgegangen
* Hena=$fe und Vena=$7f) (Hena - Horizontal enable,...)

cmove:	macro
	dc.w	 (\2&$1fe)
	dc.w	\1
	endm

wait:	macro
	dc.w	(\2<<8)+(\1&$fe)+1
	ifeq	NARG-2
		dc.w	$fffe
	endc	
	ifeq	NARG-4
		dc.w	$8000+((\4&$7f)<<8)+(\3&$fe)
	endc
	endm

skip:	macro
	dc.w	(\2<<8)+(\1&$fe)+1
	ifeq	NARG-2
		dc.w	$fffe
	endc	
	ifeq	NARG-4
		dc.w	$8000+((\4&$7f)<<8)+(\3&$fe)+1
	endc
	endm


cstop:	macro
	dc.w	$ffff
	dc.w	$fffe
	endm
 

* Beginn der copperlist
COPPERLIST:

; Bar 1
	cmove	$111,color00
	wait	$7,$29
	cmove	$a0a,color00
	wait	$7,$2a
	cmove	$11f,color00
	wait	$7,$2b
	cmove	$000,color00

Inizio:
	wait	$7,$80

copperloop:						; Ab hier beginnt die Schleife

verde:	
	cmove	$080,color00		; grüne Farbe. Der RGB-Wert, der in das Register 
								; geladen werden soll ist bei "grün + 2"
								; weil es das zweite Wort der copper-Anweisung ist							

	wait	$6b,$80,$fe,0		; Warten im ersten Drittel des Bildschirms
								; (y ist maskiert)

bianco:	
	cmove	$888,color00		; Weiß. Wechseln zu "Weiß + 2"
	wait	$a5,$80,$fe,0		; Warten auf das zweite Drittel des Bildschirms

rosso:	
	cmove	$800,color00		; rot. Wechseln zu "rot + 2"
	wait	$e0,$80,$fe,0		; auf das Ende der Zeile warten

Fine:
	skip	0,$c0,0,$7f			; SKIP zur Zeile $c0
								; (x ist maskiert)

	cmove	0,copjmp2			; schreiben in COPJMP2 - zum Anfang der Schleife springen

	cmove	$000,color00
	wait	220,255

; Bar 2
	wait	$7,$14
	cmove	$11f,color00
	wait	$7,$15
	cmove	$a0a,color00
	wait	$7,$16
	cmove	$111,color00

	cstop						; Ende der copperlist

	end

Dieses Beispiel zeigt eine beträchtliche Optimierung, die durch die Verwendung
von Copperschleifen erreicht wird.
Wir haben ein Flag, das seine Farbe ändert und sich auf und ab bewegt.
Um die Flagge zu zeichnen, muss COLOR00 innerhalb einer Rasterzeile dreimal
geändert werden und wiederholt werden mit den gleichen Farben in jeder Zeile. 
Es ist sehr praktisch, eine copperschleife zu verwenden.
Die Waits innerhalb der Schleife haben maskierte vertikale Positionen,
so dass es in jeder Rasterzeile funktioniert, ohne geändert zu werden.
Um die Farben zu ändern, müssen nur 3 copperanweisungen geändert werden.
Um die Flagge vertikal zu bewegen, ändern Sie jedes Mal	die	Warteposition des
WAIT vor der Schleife und das SKIP, das die Schleife beendet.
Insgesamt müssen also nur 5 Änderungen im Speicher vorgenommen werden.
Wenn wir keine copperschleife oder maskierte WAITs verwenden würden, müssten
wir folgende Änderungen vornehmen: In jeder Rasterzeile warten die 3 CMOVE
(copper move) und die 3 WAITs auf die verschiedenen Positionen. Da die Flagge
64 Zeilen hoch ist, hätten wir insgesamt 64 * 6 = 384 zu ändernde
Speicherplätze.
Wie Sie auch feststellen können und wie im Artikel über Infamy erwartet,
werden in dieser Quelle Makros definiert und verwendet, um die Copper-
Anweisungen zu definieren. Auf diese Weise erhalten wir (meiner Meinung nach)
einige Quellen sauberer und es verringert die Wahrscheinlichkeit von Fehlern
beim Schreiben der copperlisten. Vergleichen Sie beispielsweise den Teil der
copperliste, der den farbige Balken oben in dieser Quelle mit dem identischen
generierten Stück mit den DC.W generiert mit dem in den Beispielen skip1.s
und skip2.s. Die Version in dieser Quelle ist sofort verständlich auch auf
einen Blick und es ist viel eleganter und ordentlicher.
