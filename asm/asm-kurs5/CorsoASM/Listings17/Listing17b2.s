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

; Listing17b2.s = skip2.s

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

	move.l	#copperloop,d0
	move	d0,cpptr1+6
	swap	d0
	move	d0,cpptr1+2

	move.l	#copperloop2,d0
	move	d0,cpptr2+6
	swap	d0
	move	d0,cpptr2+2

mouse:

	bsr	MuoviCopper

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

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse

	rts

************************************************
* Diese Routine wiederholt die Farben in der copperliste

MuoviCopper:
	lea	copperloop,a0
	move.w	6(a0),d0
	moveq	#7-1,d1
.loop
	move.w	14(a0),6(a0)
	addq.l	#8,a0
	dbra	d1,.loop
	move.w	d0,6(a0)

	lea	copperloop2,a0
	move.w	6(a0),d0
	moveq	#7-1,d1
muoviloop2
	move.w	14(a0),6(a0)
	addq.l	#8,a0
	dbra	d1,muoviloop2
	move.w	d0,6(a0)
	rts

	SECTION	MY_COPPER,CODE_C

COPPERLIST:

; Bar 1
	dc.l $01800111
	dc.l $2907fffe
	dc.l $01800080
	dc.l $01800a0a
	dc.l $2a07fffe
	dc.l $0180011f
	dc.l $2b07fffe
	dc.l $01800000

	dc.w	$3007,$FFFE			; warte auf Zeile $30

cpptr1
	dc.w	$084,0
	dc.w	$086,0

copperloop						; Diese Schleife wird oberhalb der Zeile $80
	dc.w	$0007,$87fe			; ausgeführt. Alle WAITs haben das höchstwertige Bit
	dc.w	$180,$080			; der vertikalen Position bei 0
	dc.w	$0107,$87fe	 
	dc.w	$180,$0a0
	dc.w	$0207,$87fe			; WAIT in Zeile 2 mit einem signifikanten + Bit bei 0
	dc.w	$180,$0c0
	dc.w	$0307,$87fe
	dc.w	$180,$0e0
	dc.w	$0407,$87FE
	dc.w	$180,$0c0
	dc.w	$0507,$87FE
	dc.w	$180,$0a0
	dc.w	$0607,$87FE
	dc.w	$180,$080
	dc.w	$0707,$87FE
	dc.w	$180,$088
	dc.w	$00e1,$80FE
	dc.w	$8007,$ffff
	dc.w	$8a,0

cpptr2
	dc.w	$084,0
	dc.w	$086,0

copperloop2						; Diese Schleife wird unterhalb der Zeile $80-Linie 
	dc.w	$8007,$87fe			; ausgeführt. Alle WAITs haben das höchstwertige Bit
	dc.w	$180,$080			; der vertikalen Position bei 1
	dc.w	$8107,$87fe	
	dc.w	$180,$0a0
	dc.w	$8207,$87fe			; WAIT in Zeile 2 mit einem signifikanten + Bit bei 1
	dc.w	$180,$0c0
	dc.w	$8307,$87fe
	dc.w	$180,$0e0
	dc.w	$8407,$87FE
	dc.w	$180,$0c0
	dc.w	$8507,$87FE
	dc.w	$180,$0a0
	dc.w	$8607,$87FE
	dc.w	$180,$080
	dc.w	$8707,$87FE
	dc.w	$180,$088
	dc.w	$80e1,$80FE			; hier ist der Unterschied
	dc.w	$b007,$ffff
	dc.w	$8a,0

	dc.w	$180,$000
	dc.w	$FFDF,$FFFE			; warte auf Zeile 255

; Bar 2
	dc.l $01800000
	dc.l $1407fffe
	dc.l $0180011f
	dc.l $1507fffe
	dc.l $01800a0a
	dc.l $1607fffe
	dc.l $01800111

	dc.w	$FFFF,$FFFE			; Ende der copperlist

	END

Dieses Beispiel zeigt die Notwendigkeit, 2 Copperschleifen zu verwenden,
wegen der Unmöglichkeit, das most signifikant Bit der vertikalen Position zu
maskieren. Wir verwenden 2 Schleifen, die bis auf den Wert des höchsten Bits
von WAIT absolut identisch sind, welcher für die oben ausgeführte Schleife 0
ist und (in der anderen) ab der Zeile $80 stattdessen 1 ist. 
Die Notwendigkeit, 2 Schleifen zu verwenden, zwingt uns natürlich dazu, die
Adresse die in COP2LC enthalten ist zu variieren, d.h. jedes Mal muss die
Schleifenadresse richtig sein. Da COP2LC synchron mit dem Video geladen werden
muss, machen wir es durch den copper. Wir laden COP2LC genau im gleichen
Modus wie die anderen Zeigerregister (BPLxPT, SPRxPT usw.) durch die
copperliste. Vor dem Eintritt in eine Schleife wird die Adresse der Schleife
in COP2LC geschrieben.
Beachten Sie, da wir 2 Schleifen verwenden, muss die Prozessorroutine die 
Farben in beiden Schleifen drehen. Trotzdem stellt sich diese Technik immer 
als vorteilhaft gegenüber der Technik heraus, bei der keine Schleifen verwendet
werden. In diesem Beispiel, führen wir den Effekt von Zeile $30 bis $b0 für
insgesamt 128 Zeilen aus, was mit der "traditionellen" Technik 128 Iterationen
der Routine (zum wiederholen der Farben) erfordern würde.
Dank der Schleifen schaffen wir es mit 16 Iterationen (jeweils 8 pro
Schleife), also 8-mal schneller.
