
; Listing6m.s	"RÜCKPRALLEFFEKT", HERGESTELLT MIT EINER TABELLE

	SECTION	CIPundCOP,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Namen der Lib
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase		;
	move.l	d0,a6
	move.l	$26(a6),OldCop	; speichern die alte COP

;	POINTEN AUF UNSERE BITPLANES

	MOVE.L	#PIC,d0			; wohin pointen
	LEA	BPLPOINTERS,A1		; COP - Pointers
	MOVEQ	#2,D1			; Anzahl der Bitplanes -1 (hier sind es 3)
							; für den DBRA - Zyklus
POINTBP:
	move.w	d0,6(a1)
	swap	d0		
	move.w	d0,2(a1)	
	swap	d0				
	ADD.L	#40*256,d0		; + Länge Bitplane

	addq.w	#8,a1
	dbra	d1,POINTBP

	move.l	#COPPERLIST,$dff080	; COP1LC - unsere COP
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse
	
	bsr.w	BOING			; Läßt das Bild "springen". wir verwenden dazu
							; eine Tabelle

Warte:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	beq.s	Warte		

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse

	move.l	OldCop(PC),$dff080	; COP1LC - "Zeiger" auf die Orginal-COP
	move.w	d0,$dff088		; COPJMP1 - und starten sie

	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable
	move.l	GfxBase(PC),a1
	jsr	-$19e(a6)			; Closelibrary 
	rts


; DATEN

GfxName:
	dc.b	"graphics.library",0,0

GfxBase:
	dc.l	0

OldCop:
	dc.l	0

; Diesmal verwenden wir eine Tabelle, die die Werte enthält, die von den
; Bitplanepointers abgezogen werden sollen. Somit simulieren wird das Springen,
; das "Federn" eines Bildes, und erhalten nicht eine banale
; Rauf-Runter-Bewegung mit einer Serie von add.l #40 und sub.l #40.
; Dafür brauchen wir eben eine Tabelle, die diese Werte enthält. Diese sind
; klarerweise Vielfache von 40, wobei 2*40 ein Sprung von 2 Zeilen bedeutet,
; 3*40 3 Zeilen...:
;
;	dc.l	40,40,2*40,2*40 ; Beispiel...
;
; Um in die Anfangsposition zurückzukommen, wenn wir einmal am Ende des
; Bildschirmes angekommen sind, müssen wir soviel dazuzählen, wieviel von
; den Bitplane-Pointern abgezogen wurde. Da in der Routine aber eine
; Subtraktion vorhanden ist:
;
;	sub.l	d1,d0	; subtrahiere den Wert aus der Tabelle (d1) von der
;			; Adresse, auf die die BplPointer gerade zeigen
;
; wie zum Geier können wir dann mit dieser Subtraktion etwas dazuzählen?
; Ganz simpel!! Einfach negative Zahlen wegzählen!!! Wieviel ist 10-(-1))
; Ganz klar, 11! Also stehen in der Tabelle negative Zahlen, nachdem wir
; das "Ende" erreicht haben:
;
;	dc.l	-8*40,-6*40,-5*40		; gehen wieder rauf
;
; ein sub.l #-8*40 ist wie ein add.l #8*40.
; Erinnert ihr euch aber auch, daß die negativen Zahlen das Vorzeichen mit dem
; höchstwertigsten Bit speichern? Ein -40 ist also ein $FFFFFFd8, deswegen
; sind die Werte in der Tabelle auch LongWord und nicht WORD, eben um auch
; negative Zahlen beinhalten zu können, Word sind nur positiv.
; Ein
;
; dc.w -40
;
; wird nicht assembliert, es gibt einen Fehler, ihr müßt ein Long verwenden
; wenn ihr negative Zahlen braucht.
;
; Da wir .L-Werte verwendet haben, müssen wir das auch in der Routine
; berücksichtigen:
;
; ADDQ.L #4,BOINGTABPOINT
; ENDEBOINGTAB-4
; dc.l BOINGTAB-4
;
; und nicht
;
; ADDQ.L #2,BOINGTABPOINT
; ENDEBOINGTAB-2
; dc.l BOINGTAB-2
;
; Was das Verschieben des Bildes angeht, gibts keine Neuigkeiten: wir holen
; die Adresse aus den BPLPOINTERS, machen unsere SUB mit dem aus der Tabelle
; geholten Wert und schreiben die neu errechnete Adresse zurück.


BOING:
	LEA	BPLPOINTERS,A1		; Mit diesen 4 Anweisungen holen wir aus der
	move.w	2(a1),d0		; Copperlist die Adresse, wohin das $dff0e0
	swap	d0				; gerade pointet und geben diesen Wert
	move.w	6(a1),d0		; in d0

	ADDQ.L	#4,BOINGTABPOINT		; Pointe auf das nächste Longword
	MOVE.L	BOINGTABPOINT(PC),A0	; Adresse, die im Long BOINGTABPOINT
								; steht wird in a0 kopiert
	CMP.L	#ENDEBOINGTAB-4,A0	; Sind wir beim letzten .L in der TAB?
	BNE.S	NOBSTART2			; noch nicht? dann fahr´ fort
	MOVE.L	#BOINGTAB-4,BOINGTABPOINT ; Starte wieder beim ersten Long
NOBSTART2:
	MOVE.l	(A0),d1			; kopiere das Long aus der Tabelle in d1

	sub.l	d1,d0			; subtrahieren den Wert aud der Tabelle, somit
							; scrollt das Bild rauf oder runter

	LEA	BPLPOINTERS,A1		; Pointer in der COPPERLIST
	MOVEQ	#2,D1			; Anzahl der Bitplanes -1 (hier sind es 3)
POINTBP2:
	move.w	d0,6(a1)		; kopiert das niederw. Word der Adress des Plane
	swap	d0				; vertauscht die 2 Word von d0 (z.B.: 1234 > 3412)
	move.w	d0,2(a1)		; kopiert das höherw. Word der Adresse des Plane
	swap	d0				; vertauscht die 2 Word von d0 (3412 > 1234)
	ADD.L	#40*256,d0		; + Länge Bitplane -> nächstes Bitplane
	addq.w	#8,a1			; zu den nächsten bplpointers in der Cop
	dbra	d1,POINTBP2		; Wiederhole D1 Mal POINTBP (D1=num of bitplanes)
	rts


BOINGTABPOINT:				; Dieses Longword "POINTET" auf BOINGTAB, also
	dc.l	BOINGTAB-4		; enthält es die Adresse von BOINGTAB. Es wird
							; die Adresse des letzten gelesenen Long innerhalb
							; der Tabella beinhalten. (hier beginnt es bei
							; BOINGTAB-4, weil BOING mit einem  ADDQ.L #4,C..
							; beginnt es gleicht somit diese Anweisung aus.

;	Die Tabelle mit den "vorgerechneten" Rückprallwerten:

BOINGTAB:
	dc.l	0,0,0,0,0,0,40,40,40,40,40,40,40,40,40				; sinken
	dc.l	40,40,2*40,2*40
	dc.l	2*40,2*40,2*40,2*40,2*40
	dc.l	3*40,3*40,3*40,3*40,3*40,4*40,4*40,4*40,5*40,5*40
	dc.l	6*40,8*40											; ganz unten
	dc.l	-8*40,-6*40,-5*40									; steigen
	dc.l	-5*40,-4*40,-4*40,-4*40,-3*40,-3*40,-3*40,-3*40,-3*40
	dc.l	-2*40,-2*40,-2*40,-2*40,-2*40
	dc.l	-2*40,-2*40,-40,-40
	dc.l	-40,-40,-40,-40,-40,-40,-40,-40,-40,0,0,0,0,0		; sind ganz
ENDEBOINGTAB:													; oben



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
	dc.w	$100,%0011001000000000  ; Bits 12 +13 an! (3 = %011)

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste  Bitplane
	dc.w $e4,$0000,$e6,$0000	; zweite Bitplane
	dc.w $e8,$0000,$ea,$0000	; dritte Bitplane

	dc.w	$0180,$000		; Color0
	dc.w	$0182,$475		; Color1
	dc.w	$0184,$fff		; Color2
	dc.w	$0186,$ccc		; Color3
	dc.w	$0188,$999		; Color4
	dc.w	$018a,$232		; Color5
	dc.w	$018c,$777		; Color6
	dc.w	$018e,$444		; Color7

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

	dcb.b	80*40,0			; auf NULL gesetzter Speicher vor dem Bitplane

PIC:
	incbin	"/Sources/Amiga_320_256_3.raw"	; hier laden wir das Bild in RAW
	

	end

Ein  Spiel  oder  ein  Demo  programmieren  bedeutet auch, eine Unzahl von
Tabllen zu erstellen. Die Tabelle in diesem Listing könnte geeignet  sein,
ein  Männchen  in  einem  Platform-Spiel  springen zu lassen. Die schlecht
programmierten Spiele, bzw. mit einer nicht geeigneten  Programmiersprache
auscodierten	Spiele,	unterscheiden	sich  oft  in  den  unnatürlichen
Bewegungen der Figuren, in ihrer Langsamkeit  oder  anderem.  Stellt  euch
vor, euer Held springt nach oben: zuerst geht´s linear mit einer Reihe von
Sub rauf,  dann  mit  einigen  Add  wieder  herunter.  Graußig.  Auch  die
Wellenbewegungen von Außerirdischen in einem Shoot-em-Up sind das Ergebnis
von Tabellen. Die etwas besseren  Programmierer  komplizieren  dann  alles
noch  mal:  sie  machen  eigene Tabellen für den Sprung, abhängig davon wo
sich das Männchen gerade befindet, je nachdem  wie  lange  der  Feuerknopf
gedrückt  wird,  kommt  eine  andere  Sprungtabelle  zum Einsatz und somit
springt es weiter oder weniger weit. Dann zählen sie noch errechnete Werte
(z.B. Geschwindigkeit des Männchens) dazu und die Bewegungen sind perfekt.
In extremen Beispielen wie  Flipperspielen  muß  der  Rückprall  berechnet
werden,  abhängig von Winkel, Geschwindigkeit und Schwerkraft. Es schließt
aber nicht aus, daß auch sie Tabellen verwenden. In Flipperspielen  bewegt
sich	nur  die  Kugel,  das  Spielfeld  kann  einfach  durch  Ändern  der
BitplanePointers verschoben werden, deswegen kann  man  es  sich  leisten,
Zeit  mit  Berechnungen zu verlieren. Studiert euch also gut die Routinen,
die mit Tabellen arbeiten und modifiziert  vorherige  Beispiele,  um  z.B.
einen  Farbverlaufbalken  mit  dem  Copper  auf  komische Art und Weise zu
bewegen.


Tauscht die Tabelle mit dieser aus:  sie  produziert  eine  "oszillierende
Fluktuation"  (A.d.Ü.:  "Hört sich ziemlich nach Raumschiff Enterprise an,
was gemeint ist, seht ihr beim Testen!") anstatt dem Rückprall. (verwendet
Amiga+b+c+i)


BOINGTAB:
	dc.l	0,0,40,40,40,40,40,40,40,40,40					; oben
	dc.l	40,40,2*40,2*40
	dc.l	2*40,2*40,2*40,2*40,2*40						; beschleunigen
	dc.l	3*40,3*40,3*40,3*40,3*40
	dc.l	3*40,3*40,3*40,3*40,3*40
	dc.l	2*40,2*40,2*40,2*40,2*40						; bremsen
	dc.l	2*40,2*40,40,40
	dc.l	40,40,40,40,40,40,40,40,40,0,0,0,0,0,0,0		; unten
	dc.l	-40,-40,-40,-40,-40,-40,-40,-40,-40
	dc.l	-40,-40,-2*40,-2*40
	dc.l	-2*40,-2*40,-2*40,-2*40,-2*40
	dc.l	-3*40,-3*40,-3*40,-3*40,-3*40					; beschleunigen
	dc.l	-3*40,-3*40,-3*40,-3*40,-3*40
	dc.l	-2*40,-2*40,-2*40,-2*40,-2*40					; bremsen
	dc.l	-2*40,-2*40,-40,-40
	dc.l	-40,-40,-40,-40,-40,-40,-40,-40,-40,0,0,0,0,0	; wieder ganz
ENDEBOINGTAB:												; oben


