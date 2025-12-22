
; Listing5i.s	DURCHLAUFEN DER GESAMTEN CHIP-MEMORY MITTELS DER BITPLANEPTR
;				IN DER COPPERLIST.
;				LINKE TASTE UM SICH VORWÄRTS ZU BEWEGEN, RECHTE FÜR RÜCKWÄRTS,
;				BEIDE ZUM AUSSTEIGEN.

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

;	BEMERKUNG: hier lassen wir die Bitplanes alle auf $000000 pointen,
;	also auf den Anfang der CHIP-RAM

	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse			; Wenn nicht, geh nicht weiter

Warte:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	beq.s	Warte			; Wenn nicht, geh nicht weiter

	btst	#2,$dff016		; wenn die rechte Maustaste gedrückt ist,
	bne.s	NichtRunter		; gehe zu NichtRunter

	bsr.s	GehRunter		; ansonsten auf GehRunter

NichtRunter:
	btst	#6,$bfe001		; linke Taste gedrückt?
	beq.s	ScrollRauf		; wenn ja, scrolle rauf
	bra.s	mouse			; nein? Dann wiederhole den Zyklus noch ein
							; FRAME lang

ScrollRauf:
	bsr.w	GehRauf			; läßt das Bild nach oben scrollen

	btst	#2,$dff016		; If both buttons are pressed, exit, or MOUSE
	bne.s	mouse

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


;	Diese Routine bewegt das Bild nach oben und unten, indem es auf die
;	Bitplanepointers zugreift (mittels Label BPLPOINTERSin der Copperlist).

GehRunter:
	LEA	BPLPOINTERS,A1		; Mit diesen 4 Anweisungen holen wir aus der
	move.w	2(a1),d0		; Copperlist die Adresse, wohin das $dff0e0
	swap	d0				; gerade pointet und geben diesen Wert
	move.w	6(a1),d0		; in d0
	
	sub.l	#80*3,d0		; subtrahieren 80*3, also 3 Zeilen, somit
							; scrollt das Bild nach unten
	bra.s	ENDE


GehRauf:
	LEA	BPLPOINTERS,A1		; Mit diesen 4 Anweisungen holen wir aus der
	move.w	2(a1),d0		; Copperlist die Adresse, wohin das $dff0e0
	swap	d0				; gerade pointet und geben diesen Wert
	move.w	6(a1),d0		; in d0
	
	add.l	#80*3,d0		; addieren 80*3, also 3 Zeilen, somit
							; scrollt das Bild nach oben
	;bra.s	ENDE

ENDE:						; WIR POINTEN AUF UNSERE BITPLANES
	move.w	d0,6(a1)		; kopiert das niederw. Word der Adresse des Pl
	swap	d0				; vertauscht die 2 Word in d0 (1234 > 3412)
	move.w	d0,2(a1)		; kopiert ds hochw. Word der Adresse des Plane
	rts


	SECTION GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000 ; SPRITE
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000

	dc.w	$8e,$2c81		; DiwStrt	(Register mit Standartwerten)
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$003c		; DdfStart HIRES Normal
	dc.w	$94,$00d5		; DdfStop HIRES Normal
	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

			    ; 5432109876543210  ; BPLCON0:
	dc.w	$100,%1001001000000000  ; Bits 12 und 15 an!! 1 Bitplane
									; Hires 640x256, nicht Interlace
BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste Bitplane - BPL0PT

	dc.w	$0180,$000		; color0
	dc.w	$0182,$2ae		; color1

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

	end

Mit diesem simplen Programm könnt ihr den Inhalt eurer Chip-Ram sehen,  es
wird ein Bitplane in HIRES angezeigt,das anfänglich auf $00000 zeigt, also
dem Anfang der Chip-Ram des Amiga.  Durch  drücken  der  linken  Maustaste
könnt  ihr  die  Adresse  inkrementieren  (erhöhen), mit der rechten Taste
dekrementieren (in der Adresse rückwärts fahren). Damit könnt  ihr  sehen,
was  sich  in  diesem  Bereich alles tummelt: Die Workbench wird erkennbar
sein, der Asmone, und wenn ihr ein Spiel gespielt habt, bevor  ihr  dieses
Listing testet, werdet ihr vielleicht auch noch dessen Hintergrund und die
Figuren darin sehen. Ja, denn mit einem  Reset  wird  der  Speicher  nicht
gelöscht, das geschiegt nur bei einem totalen Abschalten.
Mit beiden Tasten könnt ihr aussteigen. Probiert,  einige  Videospiele  zu
laden,  einen  Reset zu machen und zu sehen, was übrig geblieben ist. Wenn
ihr den Scroll verschnellern wollt, dann müßt ihr den Wert verändern,  der
zu den Bitplane dazugezählt wird. Hauptsache, es ist ein Vielfaches von 80
(Ihr wißt ja, die Geschichte mit den 640 Punkten, die 80 Byte ergeben,  im
Gegensatz zu den 320 horizontalen Punkten des LowRes, bei dem grade mal 40
Byte pro Zeile zustande kommen).
Im Listing werden 3 Zeilen pro Durchgang genommen:

	sub.l	#80*3,d0		; subtrahieren 80*3, also 3 Zeilen

Um  den  Scroll  mit TURBO zu machen, testet ein 80*10 oder mehr. Wenn ihr
aus purer Neugierde wissen  möchtet,  auf  welcher  Adresse  ein  Bitplane
steht, dann steigt aus und tippt "M BPLPOINTERS":


XXXXXX 00 E0 00 02 00 E2 10 C0 ... (00 e0 = bplpointerH, 00 e2 das andere BPLP)

oder $00E0,$0002,$00E2,$10C0 ......

In diesem Beispiel ist die Adresse $0002 10c0, oder $210c0.

