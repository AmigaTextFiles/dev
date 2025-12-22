
; Listing17g.s	113 horizontale Copper-Positionen
; ANZEIGEN EINES BILDES IN 320*256 mit 1 Plane (2 Farben)
; als 16x16-Raster 

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

initcopper:
	move.l	#$192ffffe,d0		; $192f oben links anfangen (tauschen mit $1901) oder andere			
	move.l	#$01800ff0,d1		
	move.l	#$01800444,d2

	lea	copperpos,a0			; Adresse copperlist
	moveq	#90-1,d3			; 113 Positionen sind möglich Schleife für jede Zeile			
Initloop1:						; mit 90 ; 114	; 117 odere andere ändern
	move.l	d0,(a0)+			; lädt die erste wait-Anweisung in D0							
    move.l	d1,(a0)+			; gelb
	move.l	d2,(a0)+			; grau
	add.l	#$02020000,d0		; Wait ändern, um in der übernächsten Zeile zu warten
	add.l	#$00000100,d1		; wer will kann die Farbe ändern
	dbra	d3,Initloop1
	move.l	#$fffffffe,a0		; Ende der Copperlist

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
	dc.w	$94,$00d0	; DdfStope1
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

	; das BPLCON0 ($dff100) für einen Bildschirm mit 2 Bitplanes: (4 Farben)
				; 5432109876543210
	dc.w	$100,%0001001000000000	; bit 12 an!!		  (1 = %001)	1 Bitplanes: (2 Farben)
	;dc.w	$100,%0010001000000000	; bit 13 an!!		  (2 = %010)	2 Bitplanes: (4 Farben)
	;dc.w	$100,%0011001000000000	; bits 13 und 12 an!! (3 = %011)	3 Bitplanes: (8 Farben)

;	Wir lassen die Bitplanes direkt anpointen, indem wir die Register
;	$dff0e0 und folgende hier in der Copperlist einfügen. Die
;	Adressen der Bitplanes werden dann von der Routine POINTBP
;	automatisch eingetragen

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste	Bitplane - BPL0PT
	;dc.w $e4,$0000,$e6,$0000	; zweite Bitplane - BPL1PT
	;dc.w $e8,$0000,$ea,$0000	; dritte Bitplane - BPL2PT

;	Die 8 Farben des Bildes werden hier definiert:

	dc.w	$0180,$000	; color0
	dc.w	$0182,$fff	; color1
	;dc.w	$0184,$fff	; color2
	;dc.w	$0186,$ccc	; color3
	;dc.w	$0188,$999	; color4
	;dc.w	$018a,$232	; color5
	;dc.w	$018c,$777	; color6
	;dc.w	$018e,$444	; color7
	
copperpos:
	blk.l	500,$fffffffe 

	end


Ein Copper-Wait kann an allen geraden Positionen aufgrund des fehlenden HP0
platziert werden. Dadurch sind 113 horizontale Copper-Wait-Positionen möglich.
d.h von $0 bis $E0 (0 bis 224)

Dieses Listing zeigt eine Copper-Treppe. Man erkennt die 2-Pixelgenauigkeit.
Innerhalb von 16 Pixeln sind vier verschiedene x-Positionen möglich, was einer
4 Pixelgenauigkeit entspricht.

Die Treppe zeigt ca. 90 Stufen. Copper-Waits-Copper-Move-Folge. 

Bei Eingabe von einer horizontalen Wait-Position zwischen HP=$00 bis HP=$28
beginnt die Treppe jeweils eine Zeile tiefer. (Angaben ungefähr)

von move.l	#$1901fffe,d0  bis move.l	#$1929fffe,d0

Erst ab move.l	#$1902bffe,d0 beginnt die Treppe wie gewünscht oben links.

Der sichtbare Bereich beginnt somit im Bereich um HP=$2e.
$2e*2=$5c (92) ist auch der Beginn des sichtbaren Bereichs der durch diwstrt
eingestellt werden kann. d.h. dc.w $2c5c.

Der sichtbare Bereich endet bei HP=$E0.

Werte von HP=$e2 bis HP=$fe und HP=$00 bis HP=$2a fallen in den "nicht
sichtbaren" Bereich. Werte von HP=$e2 bis HP=$fe werden nicht mitgezählt.

	move.l	#$19e3fffe,d0		; Startwert
	moveq	#38-1,d3			; 38 Schleifen von HP=$e3 bis HP=$2c
	
>m copperpos	
		 19E3 FFFE 0180 0FF0 0180 0444	; 1. $E2	dc.w $19e3,$fffe
		 1BE5 FFFE 0180 10F0 0180 0444
		 1DE7 FFFE 0180 11F0 0180 0444
		 1FE9 FFFE 0180 12F0 0180 0444
		 21EB FFFE 0180 13F0 0180 0444
		 23ED FFFE 0180 14F0 0180 0444
		 25EF FFFE 0180 15F0 0180 0444
		 27F1 FFFE 0180 16F0 0180 0444
		 29F3 FFFE 0180 17F0 0180 0444
		 2BF5 FFFE 0180 18F0 0180 0444
		 2DF7 FFFE 0180 19F0 0180 0444
		 2FF9 FFFE 0180 1AF0 0180 0444
		 31FB FFFE 0180 1BF0 0180 0444
		 33FD FFFE 0180 1CF0 0180 0444
		 35FF FFFE 0180 1DF0 0180 0444	; 15. $FE	 dc.w $19ff,$fffe
		 3801 FFFE 0180 1EF0 0180 0444	; 16. $00	 dc.w $1901,$fffe
		 3A03 FFFE 0180 1FF0 0180 0444
		 3C05 FFFE 0180 20F0 0180 0444
		 3E07 FFFE 0180 21F0 0180 0444
		 4009 FFFE 0180 22F0 0180 0444
		 420B FFFE 0180 23F0 0180 0444
		 440D FFFE 0180 24F0 0180 0444
		 460F FFFE 0180 25F0 0180 0444
		 4811 FFFE 0180 26F0 0180 0444
		 4A13 FFFE 0180 27F0 0180 0444
		 4C15 FFFE 0180 28F0 0180 0444
		 4E17 FFFE 0180 29F0 0180 0444
		 5019 FFFE 0180 2AF0 0180 0444
		 521B FFFE 0180 2BF0 0180 0444
		 541D FFFE 0180 2CF0 0180 0444
		 561F FFFE 0180 2DF0 0180 0444
		 5821 FFFE 0180 2EF0 0180 0444
		 5A23 FFFE 0180 2FF0 0180 0444
		 5C25 FFFE 0180 30F0 0180 0444
		 5E27 FFFE 0180 31F0 0180 0444
		 6029 FFFE 0180 32F0 0180 0444
		 622B FFFE 0180 33F0 0180 0444
		 642D FFFE 0180 34F0 0180 0444	; 38. $2c	dc.w $192d,$fffe
		 FFFF FFFE 
		 

Von $0 bis $FE (0 bis 254) wären insgesamt 128 Positionen möglich. Positionen
ab $E2 werden jedoch nicht mitgezählt, also 15 Positionen. Von den 128 möglichen
Copperpositionen liegen 38 ausserhalb des sichtbaren Bereichs. Von diesen
wiederum werden 15 nicht mitgezählt. Somit bleiben 113 Copperpositionen übrig
von denen 23 Positionen im nicht sichbaren Bereich liegen. 

23+90=113 bzw. (113+15=128)
	
Der Startwert und Schleifenzähler kann für Untersuchungen weiter verändert
werden.

	move.l	#$192ffffe,d0		; Startwert	
	moveq	#113-1,d3			; 113 Positionen sind möglich Schleife für jede Zeile			
								; 90 ; 113 ; 117 verschiedene Werte einsetzen

Zusammenfassung:
	move.l	#$192ffffe,d0		; Startwert	
	moveq	#128-1,d3			; nicht sinnvoll, aber was solls...

>m copperpos
0006CFE4 192F FFFE 0180 0FF0 0180 0444		; 24.	1 ($2e=>46*2=92 = $5c)
		 1B31 FFFE 0180 10F0 0180 0444		; 25.	2 ($30=>48*2=96 = $60)
		 1D33 FFFE 0180 11F0 0180 0444		; 26.	3 ($32=>50*2=100 = $64)
		 ......
		 C9DF FFFE 0180 67F0 0180 0444		; 112.	89 ($de=>222*2=444 = $1bc)
		 CBE1 FFFE 0180 68F0 0180 0444		; 113.	90 ($e0=>224*2=448 = $1C0)
		 ; folgende sind nicht mehr sichtbar und werden nicht mitgezählt
		 CDE3 FFFE 0180 69F0 0180 0444		; 114.  1.	; fällt in den Beginn der nächsten Zeile
		 CFE5 FFFE 0180 6AF0 0180 0444
		 D1E7 FFFE 0180 6BF0 0180 0444
		 D3E9 FFFE 0180 6CF0 0180 0444
		 D5EB FFFE 0180 6DF0 0180 0444
		 D7ED FFFE 0180 6EF0 0180 0444
		 D9EF FFFE 0180 6FF0 0180 0444
		 DBF1 FFFE 0180 70F0 0180 0444
		 DDF3 FFFE 0180 71F0 0180 0444
		 DFF5 FFFE 0180 72F0 0180 0444
		 E1F7 FFFE 0180 73F0 0180 0444
		 E3F9 FFFE 0180 74F0 0180 0444
		 E5FB FFFE 0180 75F0 0180 0444
		 E7FD FFFE 0180 76F0 0180 0444
		 E9FF FFFE 0180 77F0 0180 0444		; 128.	15.	; fällt in den Beginn der nächsten Zeile
		 ; folgende sind nicht sichtbar und werden mitgezählt
		 EC01 FFFE 0180 78F0 0180 0444		; 1. 
		 EE03 FFFE 0180 79F0 0180 0444
		 F005 FFFE 0180 7AF0 0180 0444
		 F207 FFFE 0180 7BF0 0180 0444
		 F409 FFFE 0180 7CF0 0180 0444
		 F60B FFFE 0180 7DF0 0180 0444
		 F80D FFFE 0180 7EF0 0180 0444
		 FA0F FFFE 0180 7FF0 0180 0444
		 FC11 FFFE 0180 80F0 0180 0444
		 FE13 FFFE 0180 81F0 0180 0444		; 10.
		 0015 FFFE 0180 82F0 0180 0444
		 0217 FFFE 0180 83F0 0180 0444
		 0419 FFFE 0180 84F0 0180 0444
		 061B FFFE 0180 85F0 0180 0444
		 081D FFFE 0180 86F0 0180 0444 
		 0A1F FFFE 0180 87F0 0180 0444
		 0C21 FFFE 0180 88F0 0180 0444
		 0E23 FFFE 0180 89F0 0180 0444
		 1025 FFFE 0180 8AF0 0180 0444  
		 1227 FFFE 0180 8BF0 0180 0444		; 20.
		 1429 FFFE 0180 8CF0 0180 0444
		 162B FFFE 0180 8DF0 0180 0444
		 182D FFFE 0180 8EF0 0180 0444		; 23.		 
		 FFFF FFFE 


Also, ab CCK $e3 --> ($1c6) 'virtual lowres pixels' sind wir bereits in der
nächsten Zeile.

HRM:
The horizontal position has a maximum value of $E2. This means that the largest
number that will ever appear in the comparison is $FFE2. When waiting for
$FFE2, the line $FF will be reached, but the horizontal position $FE will never
happen. Thus, the position will never reach $FFFE.

You may be tempted to wait for horizontal position $FE (since it will never
happen), and put a smaller number into the vertical position field. This will
not lead to the desired result. The comparison operation is waiting for the
beam position to become greater than or equal to the entered position. If the
vertical position is not $FF, then as soon as the line number becomes higher
than he entered number, the comparison will evaluate to true and the wait will
end.



