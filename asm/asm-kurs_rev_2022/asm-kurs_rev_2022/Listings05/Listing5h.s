
; Listing5h.s	HORIZONTALE WELLENBEWEGUNG EINES BILDES MIT DEM $dff102

	SECTION	CIPundCOP,CODE

Anfang:
	move.l	4.w,a6			; Execbase in a6
	jsr	-$78(a6)			; Disable - stoppt das Multitasking
	lea	GfxName(PC),a1		; Adresse des Namen der zu öffnenden Lib in a1
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase		; speichere diese Adresse in GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; hier speichern wir die Adresse der Copperlist
							; des Betriebssystemes

;	POINTEN AUF UNSERE BITPLANES

	MOVE.L	#PIC,d0			; in d0 kommt die Adresse unserer PIC
	LEA	BPLPOINTERS,A1		; in a1 kommt die Adresse der Bitplane-
							; Pointer der Copperlist
	MOVEQ	#2,D1			; Anzahl der Bitplanes -1 (hier sind es 3)
							; für den DBRA - Zyklus
POINTBP:
	move.w	d0,6(a1)		; kopiert das niederwertige Word der Plane-
							; Adresse ins richtige Word der Copperlist
	swap	d0				; vertauscht die 2 Word in d0 (1234 > 3412)

	move.w	d0,2(a1)		; kopiert das hochwertige Word der Adresse des 
							; Plane in das richtige Word in der Copperlist
	swap	d0				; vertauscht erneut die 2 Word von d0
	ADD.L	#40*256,d0		; Zählen 10240 zu D0 dazu, -> nächstes Plane

	addq.w	#8,a1			; zu den nächsten Bplpointers in der Cop
	dbra	d1,POINTBP		; Wiederhole D1 mal POINTBP (d1=n. bitplanes)

	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse			; Wenn nicht, geh nicht weiter

	btst	#2,$dff016		; wenn die rechte Maustaste gedrückt ist,
	beq.s	Warte			; überspringe die Routine

	bsr.s	Wellen			; Bringt das Bild in Wellenbewegung

Warte:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	beq.s	Warte			; Wenn nicht, geh nicht weiter

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse			; wenn nicht, zurück zu mouse:

	move.l	OldCop(PC),$dff080	; COP1LC - "Zeiger" auf die Orginal-COP
	move.w	d0,$dff088		; COPJMP1 - und starten sie

	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable - stellt Multitasking wieder her
	move.l	GfxBase(PC),a1	; Basis der Library, die es zu schließen gilt
							; (Libraries werden geöffnet UND geschlossen!)
	jsr	-$19e(a6)			; Closelibrary - schließt die Graphics lib
	rts

; DATEN


GfxName:
	dc.b	"graphics.library",0,0	

GfxBase:		; Hier hinein kommt die Basisadresse der graphics.lib,
	dc.l	0	; ab hier werden die Offsets gemacht

OldCop:			; Hier hinein kommt die Adresse der Orginal-Copperlist des
	dc.l	0	; Betriebssystemes


; Diese Routine ist ähnlich mit der in Listing3e.s, die Werte werden wie in
; einer Kette vertauscht. Ich erinnere euch das System:
;
;	move.w	col2,col1		; col2 kommt in col1
;	move.w	col3,col2		; col3 kommt in col2
;	move.w	col4,col3		; col4 kommt in col3
;	move.w	col5,col4		; col5 kommt in col4
;
; In dieser Routine werden aber anstatt der Farben die Werte des $dff102
; kopiert, aber die grundsätzliche funktionsweise der Routine ist die gleiche.
; Um LABEL und Zeit zu sparen wurde diese Routine mit einem DBRA-Zyklus
; ausgestattet, der die Rotation sovieler Word vornimmt, wie wir wollen: da
; die zu ändernden Word alle 8 Byte entfernt sind, brauchen wir nur eines
; in a0 zu geben, das andere in a1 und dann mit einem MOVE.W (a0),(a1) zu
; kopieren. Dann schreiten wir zum nächsten Paar über, indem wir zu a0 und a1
; 8 dazuzählen, sie werden dann auf die nächsten Word pointen.
; Achtung: um einen unendlichen Zyklus zu machen, muß der letzte Wert immer
; in den errsten geschrieben werden:
;
;	>>>>>>>>>>>>>>>>>>>>>
;	^		    v
; In diesem Fall wir am Ende des Zyklus immer der erste Wert in den letzten
; geschrieben, der Zufluß ist also konstant. Die alte Routine endete so:
;	move.w	col1,col14		; col1 kommt in col14

Wellen:
	LEA	Con1Effekt+8,A0		; Adresse Quellword in a0
	LEA	Con1Effekt,A1		; Adresse Zielword in a1
	MOVEQ	#44,D2			; 45 BPLCON1 sind in COPLIST zu ändern
Vertausche:
	MOVE.W	(A0),(A1)		; kopiert zwei Word - scroll!
	ADDQ.W	#8,A0			; nächstes Word-Paar
	ADDQ.W	#8,A1			; nächstes Word-Paar
	DBRA	D2,Vertausche	; wiederhole "Vertausche" die richtige
							; Anzahl mal
	MOVE.W	Con1Effekt,LetzterWert	; um den Zyklus unendlich fortlaufen zu
	RTS						; lassen kopieren wir den ersten Wert
							; jedesmal in den Letzten.


	SECTION GRAPHIC,DATA_C


COPPERLIST:
	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000 ; SPRITE
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000

	dc.w	$8e,$2c81		; DiwStrt	(Register mit Standartwerten)
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$0038		; DdfStart
	dc.w	$94,$00d0		; DdfStop
	
	dc.w	$102			; BplCon1 - DAS REGISTER
	dc.b	$00				; BplCon1 - DAS NICHT VERWENDETE BYTE!!!
MEINCON1:
	dc.b	$00				; BplCon1 - DAS VERWENDETE BYTE!!!

	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

				; 5432109876543210  ; BPLCON0:
	dc.w	$100,%0011001000000000  ; Bits 13 und 12 an!! (3 = %011)
									; 3 Bitplanes Lowres, nicht Lace
BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste  Bitplane - BPL0PT
	dc.w	$e4,$0000,$e6,$0000	; zweite Bitplane - BPL1PT
	dc.w	$e8,$0000,$ea,$0000	; dritte Bitplane - BPL2PT

	dc.w	$0180,$000		; Color0
	dc.w	$0182,$475		; Color1
	dc.w	$0184,$fff		; Color2
	dc.w	$0186,$ccc		; Color3
	dc.w	$0188,$999		; Color4
	dc.w	$018a,$232		; Color5
	dc.w	$018c,$777		; Color6
	dc.w	$018e,$444		; Color7

; Der Effekt in der Copperlist: er besteht aus einem Wait und einem
; BPLCON1, die Wait stehen alle 4 Zeilen: $34, $38, $3c...
; In den $dff102 sind schon die "Wellenwerte" enthalten: 1,2,3,4,...3,2,1.

	DC.W	$3007,$FFFE,$102
Con1Effekt:
	DC.W	$00
	DC.W	$3407,$FFFE,$102,$00
	DC.W	$3807,$FFFE,$102,$00
	DC.W	$3C07,$FFFE,$102,$11
	DC.W	$4007,$FFFE,$102,$11
	DC.W	$4407,$FFFE,$102,$11
	DC.W	$4807,$FFFE,$102,$11
	DC.W	$4C07,$FFFE,$102,$22
	DC.W	$5007,$FFFE,$102,$22
	DC.W	$5407,$FFFE,$102,$22
	DC.W	$5807,$FFFE,$102,$33
	DC.W	$5C07,$FFFE,$102,$33
	DC.W	$6007,$FFFE,$102,$44
	DC.W	$6407,$FFFE,$102,$44
	DC.W	$6807,$FFFE,$102,$55
	DC.W	$6C07,$FFFE,$102,$66
	DC.W	$7007,$FFFE,$102,$77
	DC.W	$7407,$FFFE,$102,$88
	DC.W	$7807,$FFFE,$102,$88
	DC.W	$7C07,$FFFE,$102,$99
	DC.W	$8007,$FFFE,$102,$99
	DC.W	$8407,$FFFE,$102,$aa
	DC.W	$8807,$FFFE,$102,$aa
	DC.W	$8C07,$FFFE,$102,$aa
	DC.W	$9007,$FFFE,$102,$99
	DC.W	$9407,$FFFE,$102,$99
	DC.W	$9807,$FFFE,$102,$88
	DC.W	$9C07,$FFFE,$102,$88
	DC.W	$A007,$FFFE,$102,$77
	DC.W	$A407,$FFFE,$102,$66
	DC.W	$A807,$FFFE,$102,$55
	DC.W	$AC07,$FFFE,$102,$44
	DC.W	$B007,$FFFE,$102,$44
	DC.W	$B407,$FFFE,$102,$33
	DC.W	$B807,$FFFE,$102,$33
	DC.W	$BC07,$FFFE,$102,$22
	DC.W	$C007,$FFFE,$102,$22
	DC.W	$C407,$FFFE,$102,$22
	DC.W	$C807,$FFFE,$102,$11
	DC.W	$CC07,$FFFE,$102,$11
	DC.W	$D007,$FFFE,$102,$11
	DC.W	$D407,$FFFE,$102,$11
	DC.W	$D807,$FFFE,$102,$00
	DC.W	$DC07,$FFFE,$102,$00
	DC.W	$E007,$FFFE,$102,$00
	DC.W	$E407,$FFFE,$102

LetzterWert:
	DC.W	$00

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	BILD


PIC:
	incbin	"/Sources/Amiga_320_256_3.raw"
							; hier laden wir das Bild im RAW-Format

	end

Dieser  Welleneffekt  ist  ein Klassiker der Amiga. Um zu Sparen wird hier
nicht bei jeder Zeile eine Welle erzeugt, sondern nur alle 4 Zeilen,  aber
mindestens  ist  die  Routine  schnell,  die die $dff102 in der Copperlist
durchläuft.

Die Routine in diesem Listing kann überall dort verwendet werden  wo  Word
"rotiert"  werden  müßen,  also  könnte  sie  euch  bei  Farbeffekten  und
ähnlichem dienen.

