
; Listing17f6.s
; Screengröße dem Bild anpassen 
; mit Änderung der DIWSTRT-DIWSTOP und DDFSTRT-DDFSTOP Werte
; sowie Bitplanepointer-Wiederverwendung

	SECTION CiriCop,CODE

Anfang:
	move.l	4.w,a6				; Execbase
	jsr	-$78(a6)				; Disable
	lea	GfxName(PC),a1			; Libname
	jsr	-$198(a6)				; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop		; speichern die alte COP

;-------------------------------------------------
	;	POINTEN AUF UNSERE BITPLANES
	lea	Bplpointers,A1
	bsr bplpointer
	lea	Bplpointers2,A1
	bsr bplpointer
	lea	Bplpointers3,A1
	bsr bplpointer
;-------------------------------------------------

	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088			; START COP
	move.w	#0,$dff1fc			; NO AGA!
	move.w	#$c00,$dff106

mainloop: 
	move.l $dff004,d1
	and.l #$000fff00,d1
	cmp.l #$00013700,d1			; auf Ende des-Rasterdurchlaufs warten
	bne.s	mainloop
		
;-----frame loop start---
	; bsr prg
	
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mainloop

	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088			; Starten die alte SystemCOP

	move.l	4.w,a6
	jsr	-$7e(a6)				; Enable
	move.l	GfxBase(PC),a1
	jsr	-$19e(a6)				; Closelibrary
	rts
	
;--- Bitplane-Pointer---
bplpointer:
	MOVE.L	#PIC,d0				; Adresse unserer Bildes
	;LEA	BPLPOINTERS,A1		; Bitplanepointer der Copperlist
	MOVEQ	#2,D1				; Anzahl der Bitplanes -1 (hier sind es 3)									
POINTBP:
	move.w	d0,6(a1)							
	swap	d0	
	move.w	d0,2(a1)
	swap	d0			
	ADD.L	#1608,d0			; Zählen 1608 zu D0 dazu, -> nächstes Plane	24Bytes * 67 Zeilen
	addq.w	#8,a1				; zu den nächsten Bplpointers in der Cop
	dbra	d1,POINTBP			; Wiederhole D1 mal POINTBP (D1=n. bitplanes)
	rts


;	Daten
GfxName:
	dc.b	"graphics.library",0,0

GfxBase:
	dc.l	0

OldCop:
	dc.l	0


	SECTION GRAPHIC,DATA_C

COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

		    ; 5432109876543210
	;dc.w	$100,%0001001000000000  ; Bit 12 an!! 1 Bitplane Lowres
	;dc.w	$100,%0010001000000000  ; Bit 13 an!! 2 Bitplane Lowres
	dc.w	$100,%0011001000000000  ; Bits 13 und 12 an!! (3 = %011)
									; 3 Bitplanes Lowres, nicht Lace
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod
	
	;dc.w	$180,$000	; Color0	; Hintergrund Schwarz
	;dc.w	$182,$00F	; Color1	; Farbe 1 der Bitplane
	;dc.w	$184,$f00	; Color2
	;dc.w	$186,$00f	; Color3

LogoPal:
	dc.w $0180,$0667,$0182,$0ddd,$0184,$0833,$0186,$0334
	dc.w $0188,$0a88,$018a,$099a,$018c,$0556,$018e,$0633

;----------------------------------------------------------
	dc.w	$2021,$fffe,$180,$aaa,$203f,$fffe,$180,$000
Bplpointers:
	dc.w	$e0,$0000,$e2,$0000		; erste  Bitplane - BPL0PT
	dc.w	$e4,$0000,$e6,$0000		; zweite Bitplane - BPL1PT
	dc.w	$e8,$0000,$ea,$0000		; dritte Bitplane - BPL2PT
	
	dc.w	$8e,$3d81	; DiwStrt	
	dc.w	$90,$8041	; DiwStop
	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$0090	; DdfStop
;----------------------------------------------------------
	dc.w	$8b21,$fffe,$180,$aaa,$8b3f,$fffe,$180,$000	
Bplpointers2:
	dc.w	$e0,$0000,$e2,$0000		; erste  Bitplane - BPL0PT
	dc.w	$e4,$0000,$e6,$0000		; zweite Bitplane - BPL1PT
	dc.w	$e8,$0000,$ea,$0000		; dritte Bitplane - BPL2PT
						; DiwStrt kann $FF nicht überschreiten!!!
	dc.w	$8e,$8cF0	; DiwStrt	; Bildanfang auf Vielfaches von 16! 15*16=240=$F0
	dc.w	$90,$cfb1	; DiwStop	; 240+192=432=$1b0 oder +1Pixel $1b1
	dc.w	$92,$0070	; DdfStart	; eigentlich $70
	dc.w	$94,$00c8	; DdfStop
;----------------------------------------------------------
	dc.w	$f321,$fffe,$180,$aaa,$f33f,$fffe,$180,$000		; F3 Zeile 243
Bplpointers3:
	dc.w	$e0,$0000,$e2,$0000		; erste  Bitplane - BPL0PT
	dc.w	$e4,$0000,$e6,$0000		; zweite Bitplane - BPL1PT
	dc.w	$e8,$0000,$ea,$0000		; dritte Bitplane - BPL2PT

	dc.w	$8e,$f481	; DiwStrt	
	dc.w	$90,$3741	; DiwStop	; Diwstop VV $80 - höchste mögliche Position
	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$0090	; DdfStop
;----------------------------------------------------------	
				
	dc.w	$FFFF,$FFFE	; Ende der Copperlist
		
PIC:
	;blk.b 10240,$FF
	incbin "/Sources/sky.192x67x3.raw"			; 192/8=24Bytes pro Zeile
	end

Hallo Photon,

ich hatte gerade nur dein "Sky-Logo" zur Hand. Ich habe die Größe in
ein ganzzahliges Byteformat geändert und in das normale raw-Format konvertiert.
Auf diesem Weg möchte ich mich auch bei dir bedanken. Durch deine Serie habe
ich im Januar 2016 mit 41 Jahren überhaupt erst mit der Assemblerprogrammierung
auf dem Amiga angefangen und nun schaue was dabei herausgekommen ist...


Hi photon,

I just had your "Sky logo" on hand. I have the size changed
in an integer byte format and converted it to a normal raw format.
I would also like to thank you on this way. Through your series
I started Amiga assembler programming in January 2016 at the age of 41
and now see what came out of it ...


aus Buch Amiga intern zitiert:
Der DMA-Controller geht bei der Darstellung der Bit-Planes folgendermaßen
vor: Der Bit-Plane-DMA bleibt inaktiv, bis die erste Zeile des
Bildschirmfensters erreicht wird (DIWSTRT). Jetzt holt er ab der in DFFSTRT
festgelegten Spalte die Datenworte der verschiedenen Bit-Planes. Dabei hält
er sich an das Timing in Abbildung xxx.
Als Zeiger auf die Daten im Chip-RAM verwendet er die BPLxPT. Nach jedem
gelesenen Datenwort wird BPLxPT um ein Wort erhöht. Die gelesenen Worte
gelangen in die BPLxDAT-Register. Diese Register werden nur vom DMA-Kanal
benutzt. Sind alle sechs BPLxDAT-Register mit zusammengehörigen Datenworten aus
den Bit-Planes versorgt worden, gelangen die Daten Bit für Bit zu der
Videologik in Denise, die je nach gewähltem Modus eine der 4096 Farben auswählt
und diese dann auf dem Bildschirm ausgibt.
Beim Erreichen von DFFSTOP pausiert der Bit-Plane-DMA bis zum DFFSTRT der
nächsten Zeile, dann wiederholt sich der Vorgang bis zum Ende der letzten Zeile
des Bildschirmfensters (DIWSTOP).

Der BPLxPT zeigt jetzt auf das erste Wort nach der Bit-Plane. Da aber im
nächsten Bild der BPLxPT wieder auf das erste Wort der zugehörigen Bit-Plane
zeigen soll, muss er wieder zurückgesetzt werden.
Dies erledigt der Copper schnell und problemlos.

Noch ein Hinweis: Das Programm bei der Ausführung mal mit dem DMA-Debugger
ansehen. Shift+F12 öffnet den Debugger, >v-4 aktiviert den DMA-Debuger,
>vd beendet den DMA-Debugger. Mehr zum WinUAE Debugger in Lektion19
