
; Listing6l.s	BLINKENDE FARBEN, HERGESTELLT MIT EINER TABELLE
;				VERWENDET WIRD EINE ROUTINE, DIE AM ENDE RÜCKWÄRTS GEHT

	SECTION	CIPundCOP,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Namen der Lib
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase		;
	move.l	d0,a6
	move.l	$26(a6),OldCop	; speichern die alte COP

	move.l	#COPPERLIST,$dff080	; COP1LC - unsere COP
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse			; Wenn nicht, geh nicht weiter

	btst	#2,$dff016		; wenn die rechte Maustaste gedrückt ist,
	beq.s	Warte			; gehe zu Warte
 
	bsr.w	BLINKEN			; ansonsten gehe zu BLINKEN

Warte:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	beq.s	Warte			; Wenn nicht, geh nicht weiter

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse			; wenn nicht, zurück zu mouse:

	move.l	OldCop(PC),$dff080 ; COP1LC - "Zeiger" auf die Orginal-COP
	move.w	d0,$dff088	    ; COPJMP1 - und starten sie

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

;	Blinkroutine, die eine vorgefertigte Farbverlauf-TABELLE verwendet.
;	Diese Tabelle ist nicht anderes als eine Reihe von Words mit den
;	verschiedenen RGB-Werten, die COLOR1 annehmen wird.
;	Diese Routine nimmt bei jedem Durchgang den nächsten Wert in der 
;	Tabelle, und wenn sie beim letzten Word der in ihr angekommen ist,
;	also beim Label ENDECOLORTAB, dann wechselt sie die Richtung mit dem
;	BCHG.G  #1,DIRFLAG. Nun wird solange "rückwärts" gegangen, bis wir
;	beim ersten Word angekommen sind, dann wechseln wir erneut DIRFLAG
;	und wir fahren fort, indem wir wieder "vorwärts" lesen.
;	Bemerkung: Diese Routine ist dann nützlich, wenn die Werte so gestaltet
;	sein sollen, daß sie einen Maximalwert erreicht und dann wieder
;	abfallen. In diesem Fall hätten wir so eine Tabelle schreiben müssen:
;
;	dc.w	0,1,2,3,4,5,6,7,8,9,10 ; rauf bis zum Maximum
;	dc.w	10,9,8,7,6,5,4,3,2,1,0 ; und dann wieder runter
;
;	Bei unserer Routine ist das aber nicht notwendig, es reicht die halbe
;	Tabelle, bis 10, dann ist die Routine selbst damit beschäftigt, den
;	"Abstieg" zu machen. Wir sparen Platz und Zeit, wenn die Werte alle
;	"von Hand" eingegeben werden müssen.
;	Wenn die Tabelle aber nicht spiegelbildlich wäre, etwa so:
;
;	dc.b	0,2,3,5,6,7,8,9,10
;	dc.b	9,8,7,6,4,3,2,1,0
;
;	dann hätten wir eine Routine verwendet, die bis zum Ende liest und
;	dann von vorne beginnt.


BLINKEN:
	BTST	#1,DIRFLAG		; müssen wir die Word in der Tabelle vorwärts
	BEQ.S	RUNTERT2		; oder rückwärts lesen?
RAUFT2:
	SUBQ.L	#2,COLTABPOINT			; Pointe auf das vorherige Word
	MOVE.L	COLTABPOINT(PC),A0		; Adresse, die in COLTABPOINT steht,
									; kommt in a0
	CMP.L	#COLORTAB,A0	; Sind wir beim ersten Wert in der Tabelle 
							; angekommen?
	BNE.S	NOBSTART2
	BCHG.B	#1,DIRFLAG		; ändere Richtung, geh nach vorne!

NOBSTART2:
	MOVE.W	(A0),Farbeo		; kopiere das Word der Tabelle in die COP
	MOVE.W	(A0),Farbeu		; kopiere das Word der Tabelle in die COP
	rts

RUNTERT2:
	ADDQ.L	#2,COLTABPOINT			; Pointe auf das nächste Word
	MOVE.L	COLTABPOINT(PC),A0		; Adresse aus COLTABPOINT kommt in a0
	CMP.L	#ENDECOLORTAB-2,A0		; Sind wir beim letzten Word der TAB?
	BNE.S	KEINRICHTUNGSWECHSEL	; wenn nicht, ändere nix
	BCHG.B	#1,DIRFLAG				; wechsle Richtung, geh rückwärts!
KEINRICHTUNGSWECHSEL:
	MOVE.W	(A0),Farbeo		; kopiere das Word aus der Tabelle in die
	MOVE.W	(A0),Farbeu		; kopiere das Word aus der Tabelle in die
	rts						; Farbe0 in der COP

DIRFLAG:					; Label FLAG, wird verwendet, um die
	DC.W	0				; Leserichtung anzugeben.


COLTABPOINT:				; Dieses Longword "POINTET" auf COLORTAB, also
	dc.l	COLORTAB-2		; enthält es die Adresse von COLORTAB. Es wird
						    ; die Adresse des zuletzt gelesenen Word innerhalb
						    ; der Tabelle beinhalten. (hier beginne es bei 
						    ; COLORTAB-2, weil das Blinken ja mit ADDQ.L #2,C...
						    ; beginnt. Es dient zum "ausgleich" dieser ersten
						    ; Anweisung.

;	Die Tabelle mit den vordefinierten Werten, die das Blinken ergeben:

COLORTAB:
	dc.w	$000,$000,$001,$011,$011,$011,$012,$012 ; Beginn DUNKEL
	dc.w	$022,$022,$022,$023,$023
	dc.w	$033,$033,$034
	dc.w	$044,$044
	dc.w	$045,$055,$055
	dc.w	$056,$056,$066,$066,$066
	dc.w	$167,$167,$177,$177,$177,$177,$177
	dc.w	$278,$278,$278,$288,$288,$288,$288,$288
	dc.w	$389,$389,$399,$399,$399,$399
	dc.w	$39a,$39a,$3aa,$3aa,$3aa
	dc.w	$3ab,$3bb,$3bb,$3bb
	dc.w	$4bc,$4cc,$4cc,$4cc
	dc.w	$4cd,$4cd,$4dd,$4dd,$4dd
	dc.w	$5de,$5de,$5ee,$5ee,$5ee,$5ee
	dc.w	$6ef,$6ff,$6ff,$7ff,$7ff,$8ff,$8ff,$9ff ; Maximum HELL
ENDECOLORTAB:



	SECTION GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000 ; SPRITE
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000

	dc.w	$8E,$2c81		; DiwStrt (Register mit Normalwerten)
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$0038		; DdfStart
	dc.w	$94,$00d0		; DdfStop
	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

				; 5432109876543210
	dc.w	$100,%0000001000000000  ; 0 BITPLANES LOWRES

	dc.w	$0180			; Color0 - HINTERGRUND
Farbeo:	
	dc.w	$000

	dc.w	$a027,$fffe		; Wait Zeile $a0
	dc.w	$180			; Color0
FARBE0:
	dc.w	$000

	dc.w	$c027,$fffe		; Wait Zeile $c0
	dc.w	$0180			; Color0
Farbeu:	
	dc.w	$000

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

	end

Dies  ist  eine  der  vielen  Varienten der Routine, die aus einer Tabelle
Werte ausliest. Diese Routine kann nur bei  "spielgelbildlichen"  Tabellen
verwendet werden, also mit gleich ansteigenden Werten, die einen Höhepunkt
erreichen,  und  dann  symetrisch  abfallen  sollen.  Der  Effekt  ist
symetrischer als der in Listing6i.s präsentierte.

Versucht, die Tabelle mit dieser zu ersetzen: (Amiga+b+c+i)

COLORTAB:
	dc.w $000,$100,$200,$300,$400,$500,$600,$700
	dc.w $800,$900,$a00,$b00,$c00,$d00,$e00
	dc.w $f00,$f10,$f20,$f30,$f40,$f50,$f60,$f70
	dc.w $f80,$f90,$fa0,$fb0,$fc0,$fd0,$fe0
	dc.w $ff0,$ef0,$df0,$cf0,$bf0,$af0,$9f0,$8f0
	dc.w $7f0,$6f0,$5f0,$4f0,$3f0,$2f0,$1f0
	dc.w $0f0,$0f1,$0f2,$0f3,$0f4,$0f5,$0f6,$0f7
	dc.w $0f8,$0f9,$0fa,$0fb,$0fc,$0fd,$0fe
	dc.w $0ff,$0ef,$0df,$0cf,$0bf,$0af,$09f,$08f
	dc.w $07f,$06f,$05f,$04f,$03f,$02f,$01f
	dc.w $00f,$10f,$20f,$30f,$40f,$50f,$60f,$70f
	dc.w $80f,$90f,$a0f,$b0f,$c0f,$d0f,$e0f
	dc.w $f0f,$e0e,$d0d,$c0c,$b0b,$a0a,$909,$808
	dc.w $707,$606,$505,$404,$303,$202,$101,$000
ENDECOLORTAB:

Probiert auch diese:

COLORTAB:
	dc.w 0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
	dc.w $10f,$20f,$30f,$40f,$50f,$60f,$70f,$80f
	dc.w $90f,$a0f,$b0f,$c0f,$d0f,$e0f,$f0f
	dc.w $f1e,$f2d,$f3c,$f4b,$f5a,$f69,$f78,$f87
	dc.w $f96,$fa5,$fb4,$fc3,$fd2,$fe1,$ff0
	dc.w $ff0,$ff0,$fe0,$fd0,$fc0,$fb0,$fa0,$f90
	dc.w $f80,$f70,$f60,$f50,$f40,$f30,$f20,$f10
	dc.w $f00,$f00,$e01,$d02,$c03,$b04,$a05,$906
	dc.w $807,$708,$609,$50a,$40b,$30c,$20d,$10e,15
	dc.w $0f,$1f,$2f,$3f,$4f,$5f,$6f,$7f,$8f,$9f,$af
	dc.w $bf,$cf,$df,$ef,$ff,$ff,$fe,$fd,$fc,$fb,$fa
	dc.w $f9,$f8,$f7,$f6,$f5,$f4,$f3,$f2,$f1,$f0
	dc.w $1f1,$2f2,$3f3,$4f4,$5f5,$6f6,$7f7,$8f8,$9f9
	dc.w $afa,$bfb,$cfc,$dfd,$efe,$fff,$ffe,$ffd,$ffc,$ffb
	dc.w $ffa,$ff9,$ff8,$ff7,$ff6,$ff5,$ff4,$ff3,$ff2,$ff1,$ff0
	dc.w $fe0,$fd0,$fc0,$fb0,$fa0,$f90,$f80,$f70,$f60,$f50,$f40
	dc.w $f30,$f20,$f10,$f00,$f00,$e00,$d00,$c00,$b00,$a00,$900
	dc.w $800,$700,$600,$500,$400,$300,$200,$100,$0,0
ENDECOLORTAB:


