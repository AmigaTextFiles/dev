; Listing17g3.s	Copper-Positionen
; ANZEIGEN EINES BILDES IN 320*256 mit 1 Plane (2 Farben)
; als 16x16-Raster 


 SECTION CIPundCOP,CODE

Anfang:
	;btst	#2,$dff016			; right mousebutton?	(zum Debuggen Shift+F12)
	;bne.s	anfang		

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

	move.l	#cop2,$dff084		; Zeiger COP2
	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP					
	move.w	d0,$dff088			; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc			; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106		; BPLCON3 - Deaktiviert das AGA
	
mainloop: 
;	move.l $dff004,d1
;	and.l #$000fff00,d1
;	cmp.l #$00013700,d1			; auf Ende des-Rasterdurchlaufs warten
;	bne.s	mainloop

mouse:	
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mainloop			; wenn nicht, zurück zu mouse:

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
	incbin	"320x256x1_raster.raw"	; Bild im RAW 1 Bitplane

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

	; das BPLCON0 ($dff100) für einen Bildschirm mit 1 Bitplane: (2 Farben)
				; 5432109876543210
	dc.w	$100,%0001001000000000	; bit 12 an!!		  (1 = %001)	1 Bitplanes: (2 Farben)
	;dc.w	$100,%0010001000000000	; bit 13 an!!		  (2 = %010)	2 Bitplanes: (4 Farben)
	;dc.w	$100,%0011001000000000	; bits 13 und 12 an!! (3 = %011)	3 Bitplanes: (8 Farben)
	;dc.w	$100,%0100001000000000	; bit 14 an!!		  (4 = %100)	4 Bitplanes: (16 Farben)
	;dc.w	$100,%0101001000000000	; bits 14 und 12 an!! (5 = %101)	5 Bitplanes: (32 Farben)
	;dc.w	$100,%0110001000000000	; bits 14 und 13 an!! (6 = %110)	6 Bitplanes: (64 Farben)


;	Wir lassen die Bitplanes direkt anpointen, indem wir die Register
;	$dff0e0 und folgende hier in der Copperlist einfügen. Die
;	Adressen der Bitplanes werden dann von der Routine POINTBP
;	automatisch eingetragen

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste	Bitplane - BPL0PT
	;dc.w $e4,$0000,$e6,$0000	; zweite Bitplane - BPL1PT
	;dc.w $e8,$0000,$ea,$0000	; dritte Bitplane - BPL2PT
	;dc.w $ec,$0000,$ee,$0000	; vierte Bitplane - BPL3PT
	;dc.w $f0,$0000,$f2,$0000	; fünfte Bitplane - BPL4PT
	;dc.w $f4,$0000,$f6,$0000	; sechste Bitplane - BPL5PT


; Die 8 Farben des Bildes werden hier definiert:
	dc.w	$0180,$000	; color0
	dc.w	$0182,$fff	; color1
	;dc.w	$0184,$fff	; color2
	;dc.w	$0186,$ccc	; color3
	;dc.w	$0188,$999	; color4
	;dc.w	$018a,$232	; color5
	;dc.w	$018c,$777	; color6
	;dc.w	$018e,$444	; color7

; die weiteren Farben
	;dc.w	$0190,$444	; color08
	;dc.w	$0192,$444	; color09
	;dc.w	$0194,$444	; color10
	;dc.w	$0196,$444	; color11
	;dc.w	$0198,$444	; color12
	;dc.w	$019a,$444	; color13
	;dc.w	$019c,$444	; color14
	;dc.w	$019e,$444	; color15
	;dc.w	$01a0,$444	; color16
	;dc.w	$01a2,$444	; color17
	;dc.w	$01a4,$444	; color18
	;dc.w	$01a6,$444	; color19
	;dc.w	$01a8,$444	; color20
	;dc.w	$01aa,$444	; color21
	;dc.w	$01ac,$444	; color22
	;dc.w	$01ae,$444	; color23
	;dc.w	$01b0,$444	; color24
	;dc.w	$01b2,$444	; color25
	;dc.w	$01b4,$444	; color26
	;dc.w	$01b6,$444	; color27
	;dc.w	$01b8,$444	; color28
	;dc.w	$01ba,$444	; color29
	;dc.w	$01bc,$444	; color30
	;dc.w	$01be,$444	; color31

	
copperpos:	
	dc.w	$0101,$fffe
	dc.w	$180,$003	; color0 - blau
;------------------------------------------------------------------------------
; 1. Welche Zeile kann als erstes angesprochen werden?
; Ergebnis:	yy=20
;------------------------------------------------------------------------------
	;dc.w	$1921fffe	; 19 geht nicht
	;dc.w	$180,$f00	; rot
	;dc.w	$193ffffe	
	;dc.w	$180,$444	; grau	
; ----------------
	dc.w	$2021,$fffe	; $20 ist die erste Zeile die angesprochen werden kann
	dc.w	$180,$f00	; rot
	dc.w	$203f,$fffe	; $3e - Ende der ersten Linie 
	dc.w	$180,$444	; grau
;------------------------------------------------------------------------------
; 2. Welcher horizontale Startpunkt kann als erstes angesprochen werden?	
; Ergebnis: von xx=01 bis xx=27 ist alles gleich
;------------------------------------------------------------------------------
	;dc.w	$2201,$fffe	; wie 21
	;dc.w	$2207,$fffe	; wie 21
	dc.w	$2221,$fffe
	;dc.w	$2223,$fffe	; wie 21
	;dc.w	$2225,$fffe	; wie 21
	;dc.w	$2227,$fffe	; wie 21
	;dc.w	$2229,$fffe	; anders 
	dc.w	$180,$0f0	; grün
	dc.w	$2233,$fffe	; $33 ist der Punkt der angesprochen werden muss
						; damit eine Linie sichtbar wird, d.h.$33-$27=$6)
	dc.w	$180,$444	; grau 
;------------------------------------------------------------------------------
; 3. Welcher horizontale Punkt kann als letztes angesprochen werden?
; Ergebnis: xx=e0, d.h. von e2 bis 30
;------------------------------------------------------------------------------
	dc.w	$22e1,$fffe	; $22 noch Zeile $22
	dc.w	$180,$00f	; blau
	dc.w	$2331,$fffe	; $23 eine Zeile tiefer
	dc.w	$180,$444	; grau
; ----------------	
	dc.w	$24e1,$fffe	; $24 eine Zeile tiefer 
	dc.w	$180,$ff0	; gelb
	dc.w	$2533,$fffe	; endet in der nächsten Zeile
	dc.w	$180,$444	; grau
;------------------------------------------------------------------------------
; 4. Welcher Welche Werte liegen ausserhalb des sichtbaren Bereichs?
; Ergebnis: von e2 bis 30
;------------------------------------------------------------------------------
	dc.w	$27e3,$fffe	; $27 noch Zeile $27
	dc.w	$180,$00f	; blau
	dc.w	$2831,$fffe	; $28 eine Zeile tiefer
	dc.w	$180,$444	; grau
;------------------------------------------------------------------------------
; 5. Untersuchung copper execution time - move - wait
;------------------------------------------------------------------------------
	dc.w	$3031,$fffe								; bei bis zu 4 bitplanes
	;dc.w	$3031,$fffe		; gleich				; + 4 CCK
	;dc.w	$3007,$fffe		; schon überschritten	; + 4 CCK
	dc.w	$180,$444								; + 4 CCK 
	;dc.w	$180,$555								; + 2 CCK
	;dc.w	$180,$666								; + 2 CCK
	;dc.w	$180,$777								; + 2 CCK
	dc.w	$3033,$fffe								; + 4 CCK
	dc.w	$3035,$fffe								; + 4 CCK
	dc.w	$3037,$fffe								; + 4 CCK	
;------------------------------------------------------------------------------
; 6. Untersuchung copper execution time - move - skip
;------------------------------------------------------------------------------
	dc.w	$3121,$fffe		; ohne diese wait-Anweisung ist Sprungbedingung 
							; immer erfüllt
	dc.w	$0180,$00F		
	dc.w	$0180,$0F0
	dc.w	$3131,$ff01		; skip if VP >=31 & HP>=30
	dc.w	$8a,0			; copjmp2 start
	dc.w	$0180,$666			
	dc.w	$0180,$444
;------------------------------------------------------------------------------
; 7. längste Strecke mit Anfangs- und Endpunkt 
; Ergebnis: längste Strecke von xx=32 bis xx=e0
;------------------------------------------------------------------------------
	dc.w	$3833,$fffe	; 
	dc.w	$180,$f0f	; lila
	dc.w	$38e1,$fffe	;
	dc.w	$180,$444	; grau
;------------------------------------------------------------------------------
; 8. längste volle Strecke
; Ergebnis: längste Strecke von xx=30 bis xx=e2
;------------------------------------------------------------------------------
	dc.w	$4031,$fffe	; 
	dc.w	$180,$f0f	; lila
	dc.w	$40e3,$fffe	;
	dc.w	$180,$444	; grau
;------------------------------------------------------------------------------
; 9. Linie auf Rahmen (Punkte vom Rahmen 320x256)
; Ergebnis: yy=4c   (x1 liegt zwischen xx=3f und xx=41 (2Pixel Genauigkeit)
;					(x2 liegt zwischen xx=df und xx=e1 (2Pixel Genauigkeit) 
;------------------------------------------------------------------------------
	dc.w	$4c3f,$fffe	; 
	dc.w	$182,$f00	; rot, diesmal auf $182 (Zeichenfarbe)
	dc.w	$4cdf,$fffe	;
	dc.w	$182,$fff	; weiß
;------------------------------------------------------------------------------
; 10. Welcher Wert ist die Mitte?
; (($e0-$3e)/2)+$3e  (Endpunkt-Anfangspunkt)/2 + Rand links
; jeder wait und move - benötigt selbst 24 Pixel
;------------------------------------------------------------------------------
	dc.w	$5091,$fffe	; 
	dc.w	$180,$f00	; rot
	dc.w	$5091,$fffe	; x+24 Pixel
	dc.w	$180,$444	; grau
	
	dc.w	$5091,$fffe	; 
	dc.w	$180,$f00	; rot, x+24 Pixel
	dc.w	$5091,$fffe	;
	dc.w	$180,$444	; grau, x+24 Pixel (3x8)
;------------------------------------------------------------------------------
; 11. 2 Pixel Genauigkeit - Punkt am 320x256 Bildschirm
;------------------------------------------------------------------------------
	dc.w	$a021,$fffe
	dc.w	$180,$0f0	; grün
	dc.w	$a03f,$fffe	; 1.Punkt
	dc.w	$180,$444	; grau
; ----------------	
	dc.w	$a421,$fffe
	dc.w	$180,$00f	; blau	
	dc.w	$a441,$fffe	; 2.Punkt
	dc.w	$180,$444	; grau
; ----------------		
	dc.w	$a821,$fffe
	dc.w	$180,$ff0	; gelb
	dc.w	$a843,$fffe	; 3.Punkt
	dc.w	$180,$444	; grau
; ----------------	
	dc.w	$ac21,$fffe
	dc.w	$180,$f0f	; lila
	dc.w	$ac45,$fffe	; 4.Punkt
	dc.w	$180,$444	; grau
; ----------------		
	dc.w	$b021,$fffe
	dc.w	$180,$0ff	; cyan
	dc.w	$b047,$fffe	; 5.Punkt
	dc.w	$180,$444	; grau
;------------------------------------------------------------------------------
; 12.  Copper benötigt Zeit für Ausführung
;------------------------------------------------------------------------------	
	dc.w	$b441,$fffe	; Linie vom ersten Punkt
	dc.w	$180,$f00	; rot (von $40, $42, $44, $46, $50)
	dc.w	$b451,$fffe	; alle Längen gleich, ab $52 anders)
	dc.w	$180,$444	; grau
;------------------------------------------------------------------------------
; 13. jeder move benötigt 8 Pixel
;------------------------------------------------------------------------------
	dc.w	$bb37,$fffe	; 
	dc.w	$180,$0f0	; grün
	dc.w	$bb41,$fffe	;
	dc.w	$180,$00f	; blau	
	dc.w	$180,$ff0	; gelb
	dc.w	$180,$f0f	; lila
	dc.w	$180,$0ff	; cyan
	dc.w	$180,$444
;------------------------------------------------------------------------------	
; 14. Zeile 255
;------------------------------------------------------------------------------		
	dc.w	$ff37,$fffe	; Zeile: $ff
	dc.w	$180,$f00	; rot
	dc.w	$ff41,$fffe	;
	dc.w	$180,$444	; grau
;------------------------------------------------------------------------------		
; 15. Thema - nach Zeile 255
;------------------------------------------------------------------------------	
	dc.w	$ffdf,$fffe	; > nach Zeile 255
	dc.w	$0531,$fffe	; Zeile 260
	dc.w	$180,$0f0	; grün
	dc.w	$0541,$fffe	;
	dc.w	$180,$444	; grau
;------------------------------------------------------------------------------	
; 16. Zeile 256 vom 320x256 bildschirm (255+$28)
;------------------------------------------------------------------------------	
	dc.w	$2c3f,$fffe	; 
	dc.w	$180,$00f	; blau
	dc.w	$2cdf,$fffe	;			; das erklärt auch warum wir dc.w	$ffdf,$fffe wählen	
	dc.w	$180,$444	; grau		; wir sind am Ende des Screens
;------------------------------------------------------------------------------		
; 17. tiefster Punkt
;------------------------------------------------------------------------------	
	dc.w	$3763,$fffe	; 
	dc.w	$180,$ff0	; gelb
	dc.w	$37df,$fffe	;			
	dc.w	$180,$444	; grau		
;------------------------------------------------------------------------------	
	dc.w	$ffff,$fffe	; ende der copperlist
	

Cop2:					; copperlist 2
	dc.w	$8007,$fffe	 
	dc.w	$180,$000	; schwarz
	dc.w	$A007,$fffe	 
	dc.w	$180,$FFF	; weiß
	dc.w	$C007,$fffe	 
	dc.w	$180,$FF0	; gelb	
	dc.w	$ffff,$fffe

	end


Das ganze dient eher so einer Art Copper-Grundlagenforschung.

WinUAE Debugger:	
- öffnen mit Shift+F12
- v startet den DMA_Debugger
- v $30 $20		- Rasterzeile $30, ab horizontaler Position $20 anzeigen

Warum horizontale Wait-Position $de? 

	dc.w	$2cdf,$fffe	; letzte horizontale Position des Screens

Es ist die letzte horizontale Position eines 320x256 Screens mit DiwStrt bei
$81. ($81+$140=$1C1) (129+320=449) 449/2=224	bzw. $e0

Um auf die Zeile $2d zu warten kann man in der vorhergehenden Zeile warten wo
der Raster aus dem Screen geht. Nun hat man mehr Rasterzeit um z.B. die Palette
zu ändern. 

Oder allgemein sollten Copperanweisungen ausserhalb von DDFSTOP und vor Beginn
DDFSTRT platziert werden.

