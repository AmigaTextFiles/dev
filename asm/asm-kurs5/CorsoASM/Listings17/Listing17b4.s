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

; Listing17b4.s = skip4.s

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

Basso	addq.b	#1,d0
	cmp.b	#$bf,d0

Muovi
	shs	PosFlag					; Testgrenzen (beide!;)
	move.b	d0,PosBandiera
	lsl	#8,d0
	move.b	#$07,d0
	move	d0,Inizio
	add	#$4000,d0
	move	d0,Fine

	tst.b	FadeFlag
	beq.s	FadeIn

FadeOut
	sub	#$010,verde+2			; erhöht die Helligkeit
	cmp	#$080,verde+2
	sne	FadeFlag				; wenn wir mindestens sind, wechseln Sie zu FadeIn

	sub	#$0100,rosso+2			; erhöht die Helligkeit
	rts

FadeIn
	add	#$010,verde+2			; erhöht die Helligkeit
	cmp	#$0f0,verde+2			; Wenn wir maximal sind, geht es zu FadeOut
	seq	FadeFlag

	add	#$100,rosso+2			; erhöht die Helligkeit

	rts

* Positionieren Sie die erste Zeile der Flagge
; Die Flagge muss zwischen den Zeilen $80 und $ff bleiben und 
; daher $40 hoch sein,
; die Position muss zwischen den Zeilen $80 und $bf variieren
PosBandiera	dc.b	$a0
PosFlag		dc.b	0
FadeFlag	dc.b	0

	SECTION	MY_COPPER,CODE_C

*************************************************************************
* Copper Macros by The Dark Coder / Morbid Visions
* vers. 3 SE / 16-07-96 / per ASM One 1.29
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

	wait	$1e-4,$80,$3e,0		; warte den ersten Teil
								; Die ys sind vollständig maskiert
								; Die 2 höchstwertigen Bits werden maskiert
								; des x. Auf diese Weise wird die Schleife
								; 4 mal pro Zeile wiederholt.

rosso:	
	cmove	$0800,color00		; rot. Wechseln Sie zu "rot + 2"
	wait	$3e-20,$80,$3e,0	; auf das Ende der Zeile warten


Fine:
	skip	$0,$c0,$0,$7f		; SKIP zur Zeile $c0
								; (Die x sind maskiert)

	cmove	0,copjmp2			; schreiben in COPJMP2 - springen zum Anfang der Schleife

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

Dieses Beispiel zeigt eine Copperschleife, die sich während einer gleichen 
Zeile mehrmals wiederholt, dank der Verwendung von WAIT mit Masken (teilweise)
auch die X-Koordinaten.
Dies ist eine Variation des Beispiels von skip3.s, in dem wir eine "Flagge"
aus 2 Farben haben, die sich horizontal wiederholt.
Der Körper der Schleife besteht nur aus 2 CMOVE, verwendet für die zwei Farben.
Maskieren der beiden most signifikanten Bits der horizontalen Position von WAIT
bedeutet, dass der Zyklus jeweils viermal pro Zeile wiederholt wird, ähnlich
wie wir es für die vertikale Positionen gesehen haben.
Um eine Schleife zu haben, die jede Zeile zweimal wiederholt, maskieren Sie
einfach nur das höchstwertige Bit der horizontalen Positionen der WAITs.
Beachten Sie, dass es sehr schwierig ist, Schleifen zu erhalten, die sich öfter 
als 4 Mal wiederholen, da WAITs die auf horizontale Positionen warten sollen
so nah beieinander sind, dass das copper nicht einmal Zeit hat eine Anweisung
auszuführen.
Beachten Sie, damit die Farbbänder gleich groß sind die horizontalen
Wartepositionen der WAIT's zu kompensieren, dass wenn das Copper aus dem Warten
"herauskommt"

Im ersten WAIT der Schleife wird sofort der folgende CMOVE $xx,COLOR00
ausgeführt, während wenn er das Warten im zweiten WAIT "verlässt", muss er das
SKIP und das CMOVE $0,COPJMP2, bevor Sie die Schleife zu Beginn wieder
CMOVE $yy, COLOR00 ausführen.
Beachten Sie, dass diese Art der copper Verwendung der Erzeugung von 
Plasmen ähnelt. Bei Plasmen werden WAIT und CMOVE nicht verwendet, sie
werden kontinuierlich durchgeführt. Bei Plasmen ändert sich jede Farbe
durch einen anderen korrospondierenden CMOVE. In diesem Fall ändern sich jedoch
viele Farben die durch eine einzelne CMOVE durchgeführt werden. Der Nachteil
ist natürlich, dass die von CMOVE selbst erzeugten "Bänder" keine
unterschiedlichen Farben haben können.
Es gibt jedoch den zusätzlichen Vorteil, dass nur eins CMOVE benötigt wird,
um die Farbe zu ändern in die Speicher zu schreiben.
In diesem Beispiel kommen bei jedem Framen nur 2 modifizierte
Copperanweisungen. Wenn wir WAITs nicht mit maskierten horizontalen Positionen
verwendet hätten sollten wir 8 CMOVE verwenden, um alle Farben in einer Zeile
zu ändern und folglich sollten wir alle 8 in jedem Frame ändern.
