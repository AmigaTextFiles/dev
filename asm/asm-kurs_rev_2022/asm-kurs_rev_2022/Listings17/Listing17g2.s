
; Listing17g2.s	Copper-Positionen
; ANZEIGEN EINES BILDES IN 320*256 mit 1 Plane (2 Farben)
; als 16x16-Raster und Copper-Move an Pixel-Position setzen

 SECTION CIPundCOP,CODE

Anfang:
	move.l	4.w,a6				; Execbase in a6
	jsr	-$78(a6) 				; Disable - stoppt das Multitasking
	lea	GfxName(PC),a1			; Adresse des Namen der zu öffnenden Lib in a1
	jsr	-$198(a6)				; OpenLibrary, Routine der EXEC
	move.l	d0,GfxBase			; speichere diese Adresse in GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop		; hier speichern wir die Adresse der Copperlist
								; des Betriebssystemes (immer auf $26 nach GfxBase)

;******************************************************************************
;HIER LASSEN WIR UNSERE BPLPOINTERS IN DER COPPELIST UNSERE BITPLANES ANPOINTEN
;******************************************************************************

	MOVE.L	#PIC,d0				; in d0 kommt die Adresse von unserer PIC
	LEA	BPLPOINTERS,A1			; in a1 kommt die Adresse der Bitplane-Pointer der Copperlist
	MOVEQ	#1-1,D1				; Anzahl der Bitplanes 0 (hier ist es 1)
POINTBP:
	move.w	d0,6(a1)			; niederwertige Word der Plane-Adresse
	swap	d0					; vertauscht die 2 Word in d0 (Z.B.: 1234 > 3412)			     
	move.w	d0,2(a1)			; hochwertige Word der Adresse des 			      
	swap	d0					; orginale Adresse wieder hergestellt
	ADD.L	#40*256,d0			; Zählen 10240 zu D0 dazu, nächste Bitplane
	addq.w	#8,a1				; Adresse der nächsten bplpointers in der Copperlist
	dbra	d1,POINTBP			; Wiederhole D1 mal POINTBP (D1=num of bitplanes)


	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP					
	move.w	d0,$dff088			; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc			; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106		; BPLCON3 - Deaktiviert das AGA
	
	bsr cop_pix					; Umwandlung Pixelposition in Copper-Move-Position
								; auskommentieren um die einfache Berechnung zu sehen
mouse:	
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse				; wenn nicht, zurück zu mouse:

	move.l	OldCop(PC),$dff080 	; COP1LC - "Zeiger" auf die Orginal-COP
	move.w	d0,$dff088			; COPJMP1 - und starten sie

	move.l	4.w,a6
	jsr	-$7e(a6)				; Enable - stellt Multitasking wieder her
	move.l	GfxBase(PC),a1		; Basis der Library, die es zu schließen gilt
								; (Libraries werden geöffnet UND geschlossen!)
	jsr	-$19e(a6)				; Closelibrary - schließt die Graphics lib
	rts


cop_pix:
;******************************************************************************
; hier die gewünschte Pixelposition des Copper-Move eintragen 
	move.w	#80,d5				; x=160 (320x256)
	move.w	#81,d6				; y=266		; 266max (310=266+44)
;******************************************************************************

coppixelpos:
	moveq	#0,d7				; Testbit zurücksetzen
	move.l #$0000fffe,d4		; HP=$00, VP=$00
; x-Position	
	moveq	#0,d0				; d0 säubern
	move.w	#$81,d0				; Zielposition Copper-Farbänderung	129	(DIWSTRT x-Pos)
	add.w	d5,d0				; x-Pixelpos. im Screen
	move.w  #$5c,d1				; linke Position des Screens - Pixelposition 92
								; Abstand in Pixeln/4
	sub.w	d1,d0				; ($81-$5c)/2
	lsr		#1,d0				; Ergebnis dividiert durch zwei	
;---------------------------------	
	btst	#0,d0				; Bit 0 = 0?
	beq 	ok
	add.b	#1,d0				; gerade machen
;--------------------------------	
ok									
	lsl #8,d0					; Ergebnis an die richtige Position verschieben
	lsl.l #8,d0					; weiter verschieben

	add.l	#$002F0000,d0		; $2F -horizontale Basis-Copperpos. entspricht Pixelpos. $51	
	add.l	d4,d0				; Ergebnis horizontale Pos.
; y-Position
	moveq	#0,d1
	move.w	#$2c,d1				; Zielposition Copper-Farbänderung	44	(DIWSTRT y-Pos)
	add.w	d6,d1				; y-Pixelpos. im Screen
	cmp.w	#$FF,d1				; VP > 255?
	blo weiter					; wenn nicht, gehe zu weiter
	move.b	#$01,d7				; Testflag setzen
weiter:
	swap	d1					; Ergebnis an die richtige Position verschieben	
	lsl.l	#8,d1				; Ergebnis an die richtige Position verschieben
	add.l	d1,d0				; Wait-Anweisung fertig	
	
initcopper:
	;move.l	#$1901fffe,d0		; $192f  oben links anfangen
	move.l	#$01800ff0,d1
	move.l	#$01800444,d2

	lea	copperpos,a0			; Adresse copperlist
	cmp	#1,d7					; VP >255
	bne wait
	move.l	#$ffdffffe,(a0)+	; um unterhalb von Zeile 255 zu kommen
wait:
	move.l	d0,(a0)+			; lädt die erste wait-Anweisung in D0							
    move.l	d1,(a0)+			; gelb
	move.l	d2,(a0)+			; grau
	move.l	#$fffffffe,a0		; Ende der Copperlist
	rts
	


GfxName:
	dc.b	"graphics.library",0,0	

GfxBase:	     ; Hier hinein kommt die Basisadresse der graphics.library,
	dc.l	0    ; ab hier werden die Offsets gemacht

OldCop:			; Hier hinein kommt die Adresse der Orginal-Copperlist
	dc.l	0	; des Betriebssystemes


	SECTION GRAPHIC,DATA_C

PIC:
	incbin	"/Sources/320x256x1_raster.raw"	; Bild im RAW 1 Bitplane

COPPERLIST:

	; Die Sprites lassen wir auf NULL zeigen, also pointen, um sie zu 
	; eliminieren ansonsten geistern sie umher uns stören uns nur!!!

	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000
	
	dc.w	$8e,$2c81	; DiwStrt	Register mit Standartwerten
	dc.w	$90,$2cc1	; DiwStop	
	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$00d0	; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

				; 5432109876543210
	dc.w	$100,%0001001000000000	; bit 12 an!!	(1 = %001)	1 Bitplane: (2 Farben)

;	Wir lassen die Bitplanes direkt anpointen, indem wir die Register
;	$dff0e0 und folgende hier in der Copperlist einfügen. Die
;	Adressen der Bitplanes werden dann von der Routine POINTBP
;	automatisch eingetragen

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste	Bitplane - BPL0PT
	dc.w	$0180,$000			; color0
	dc.w	$0182,$fff			; color1

	dc.w	$1001,$fffe			; 
	dc.w	$0180,$0444			; grau
	
copperpos:						; diese Zeilen werden durch bsr cop_pix geändert
	dc.w	$2791,$fffe			; 129+(320/2)=289 = $81+$A0=$121 dividiert durch 2 = $90	
	dc.w	$180,$f0f			; lila
	dc.w	$27e1,$fffe			; bis Ende der Zeile
	dc.w	$180,$444			; grau
	dc.l	$fffffffe

	end

In diesem Listing wird die Ermittlung der Copper-Wait-Position in Bezug zu 
einer Pixelposition in einem LowRes-Screen mit 320x256 Pixeln gezeigt.
Der Lowres-Screen hat dabei die obere linke Ecke an der Position DIWSTRT mit
x=$81 (129) und y=$2c (44). Wie kann die Wait-Position berechnet werden?
Die linke Bildschirmposition kann mit $5c gefunden werden. (DIWSTRT: $2c5c)
Die durch Tests dazugehörende horizontale Copper-Wait-Position wurde mit $2e
ermittelt. Es ist die erste wait-Position die nicht in einer neuen Zeile
beginnt.

Die Berechnung erfolgt auf folgende Weise:

A = Pixel_Position_Ziel	z.B. $81
B = linke Bildschirmposition $5c
C = Pixelverschiebung um 4 Pixel, um die x-Position x+16 Pixel zu bekommen
    werden 4 Verschiebungen benötigt, 4*4 Pixel=16 Pixel
D = 2_Pixelgenauigkeit = 2

wait_HP= ((A-B)/C)*D

Bsp.:
wait_HP= (($81-$5c)/4)*2	kann gekürzt werden
wait_HP= ($81-$5c)/2			= $12 (18 Pixel)

	dc.w	$yy2d,$fffe		($2d+$12=$3F) --> auf ungerades Bit 0 achten!
	dc.w	$yy3f,$fffe					  --> 3e entspricht der x-Position $81

Achtung: Wenn der Copper-Move auf ein Vielfaches von 16, also dem dargestellten
Raster fällt, wird er durch die Vordergrundfarbe Color01 überschrieben.

bezogen auf (320x256)
Test 1:
	move.w	#0,d5				; x=0	  (129+0=129)
	move.w	#18,d6				; y=18	  (44+18=62)

Test 2:
	move.w	#160,d5				; x=160	  (129+160=289)	
	move.w	#130,d6				; y=130	  (44+130=174)

Test 3:
	move.w	#80,d5				; x=80	  (129+80=209)
	move.w	#80,d6				; y=80	  (44+80=124)

Test 4:
	move.w	#320,d5				; x=320   (129+320=449)
	move.w	#266,d6				; y=266	  (44+266=310)

