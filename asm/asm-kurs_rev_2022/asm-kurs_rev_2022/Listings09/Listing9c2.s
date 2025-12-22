
; Listing9c2.s	  In diesem Listing wird eine Kachel von 16 * 15 Pixeln,
				; in nur einer Bitebene wiederholt geblittet
				; fülle den Bildschirm aus (320*256 lowres 1 bitplane).

	section	bau,code

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"		; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA ; $83C0


START:
	MOVE.L	#BitPlane1,d0		; Zeiger auf die "leere" Bitplane
	LEA	BPLPOINTER1,A1			; Bitplanepointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper, blitter
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; COP starten
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	bsr.s	fillmem				; fülle den "Kachel" -Bildschirm
								; mit dem Blitter
mouse:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse

	rts						


;*****************************************************************************
; Diese Routine füllt den Kachelbildschirm.
;*****************************************************************************

;	   .-----------.
;	   |         ¬ |
;	   |           |
;	   |  ___      |
;	  _j / __\     l_
;	 /,_  /  \ __  _,\
;	.\¬| /    \__¬ |¬/....
;	  ¯l_\_o__/° )_|¯    :
;	   /   ¯._.¯¯  \     :
;	.--\_ -^---^- _/--.  :
;	|   `---------'   |  :
;	|   T    °    T   |  :
;	|   `-.--.--.-'   | .:
;	l_____|  |  l_____j
;	   T  `--^--'  T
;	   l___________|
;	   /     _    T
;	  /      T    | xCz
;	 _\______|____l_
;	(________X______)

fillmem:
	lea	Bitplane1,a0			; Adresse Ziel Bitplane
	lea	gfxdata1,a3				; Figur Kachel 16*15

	btst	#6,2(a5)			; dmaconr
WBlit1:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

	move.l	#$ffffffff,$44(a5)	; BLTAFWM/LWM - wir werden es später erklären
	move.w	#0,$64(a5)			; BLTAMOD = 0, in der Tat das Bild der				
								; Kachel ist NICHT im Inneren eines größeren 
								; Bildes enthalten und
								; die Zeilen, die es bilden folgen
								; im Speicher aufeinander.
	move.w	#38,$66(a5)			; BLTDMOD (40-2=38), tatsächlich eine
								; "Kachel" ist 16 Pixel breit,
								; das sind 2 Bytes, die wir entfernen müssen
								; auf die gesamte Breite einer Zeile,
								; welche 40 ist, und das Ergebnis ist 40-2=38!
	move.w	#$0000,$42(a5)		; BLTCON1 - keine besonderen Modi
	move.w	#$09f0,$40(a5)		; BLTCON0 (Kanal A und D)

	moveq	#16-1,d2			; 16 Kacheln übereinander um 
								; am Ende anzukommen, tatsächlich
								; die Kacheln sind 15 Pixel hoch,
								; und 1 Pixel "Abstand" zwischen einer und
								; der anderen, macht eine
								; Größe von 16 Pixeln pro Kachel,
								; deshalb 256/16 = 16 Kacheln.
FaiTutteLeRighe:
	moveq	#20-1,d0			; 20 Kacheln pro Zeile,
								; in der Tat, die Kacheln sind
								; 16 Pixel breit, das sind 2 Bytes,
								; daraus ergibt sich, dass pro horizontale
								; Zeile 320/16 = 20 sind.
FaiUnaRigaLoop:
	move.l	a0,$54(a5)			; BLTDPT - Ziel (bitplane 1)
	move.l	a3,$50(a5)			; BLTAPT - Quelle (fig1)
	move.w	#(15*64)+1,$58(a5)	; BLTSIZE - Höhe 15 Zeilen,
								; Breite 1 word (16 Pixel)
	btst	#6,2(a5)			; dmaconr
WBlit2:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

	addq.w	#2,a0				; überspringt 1 Word (16 Pixel) in der Bitebene 1, 
								; in Richtung "vorwärts" für die nächste Kachel

	dbra	d0,FaiUnaRigaLoop	; Schleife
								; Blitt über alle 20 Kacheln einer Zeile.
 
	lea	15*40(a0),a0			; überspringt 15 Zeilen in der Bitebene 1. 
								; Wir haben a0 bereits durch addq #2,a0 erhöht und somit
								; haben wir bereits eine Zeile übersprungen,
								; bevor wir hier angekommen sind. Für jede Schleife
								; werden daher 16 Zeilen übersprungen und hinterlassen
								; zwischen einer Kachel und der anderen ein "Streifen"
								; Hintergrund, weil die Kacheln
								; nur 15 Pixel hoch sind.
	dbra	d2,FaiTutteLeRighe	; mache alle 16 Zeilen
 	rts	

;*****************************************************************************

		section	cop,data_C

copperlist
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$38				; DdfStart
	dc.w	$94,$d0				; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod

	dc.w	$100,$1200			; BPLCON0 - 1 bitplane lowres

	dc.w	$180,$126			; Color0
	dc.w	$182,$0a0			; Color1

BPLPOINTER1:
	dc.w	$e0,0,$e2,0			; erste bitplane

	dc.l	$ffff,$fffe			; Ende copperlist

;*****************************************************************************

; Figur, bestehend aus 1 Bitebene. Breite = 1 Wort, Höhe = 15 Zeilen

gfxdata1:
	dc.w	%1111111111111100	; 1
	dc.w	%1111111111111100	; 2
	dc.w	%1100000000001100	; 3
	dc.w	%1100000000001100
	dc.w	%1100011110001100
	dc.w	%1100111111001100
	dc.w	%1100110011001100
	dc.w	%1100110011001100
	dc.w	%1100111111001100
	dc.w	%1100011110001100
	dc.w	%1100000000001100
	dc.w	%1100000000001100
	dc.w	%1111111111111100
	dc.w	%1111111111111100
	dc.w	%0000000000000000	; 15

	section	gnippi,bss_C

bitplane1:
		ds.b	40*256

	end

;*****************************************************************************


In diesem Beispiel verwenden wir eine kleine Figur (16 Pixel breit und 15
Zeilen hoch) wie eine "Kachel", um den Bildschirm zu "kacheln". In der Praxis
kopieren wir die Quellfigur so oft, so dass wir den gesamten Bildschirm
abdecken. Der Bildschirm ist 320 und die Kachel 16 Pixel breit, in einer Reihe
zeichnen wir 320/16 = 20 Kacheln. 
In der Höhe misst der Bildschirm jedoch 256 und die Kachel 15 Pixel. Da wir 
eine leere Reihe von Pixeln zwischen 2 Kacheln zeichnen erhalten wir 
256 / (15 + 1) = 16 Kacheln für jede Spalte.

Jede Kachel wird mit einem Blitt kopiert. Die Dimensionen des Blitts ist
1 Wort (16 Pixel) in der Breite und 15 Zeilen in der Höhe. Das Quellmodulo
ist 0, da die Quelle NICHT ein Bildschirm groß ist und die Zeilen, die die
Figur der Kachel bilden nacheinander im Speicher angeordnet sind.
Das Ziel ist stattdessen in einem 20 Wörter breiten Bild und daher wird das 
Modulo nach der Formel wie wir es in der Lektion gesehen haben berechnet.

Die Anweisungen, die den Blitt ausführen, befinden sich in zwei ineinander 
platzierten Schleifen. Die innere Schleife wiederholt den Blitt 20 Mal, um eine
horizontale Reihe von Kacheln zu zeichnen. Die äussere Schleife wiederholt die
innere Schleife 16 mal um insgesamt 16 Reihen von Kacheln zu zeichnen. Zwischen
einem Blitt und dem anderen variiert natürlich die Adresse des Ziels, um die
Kachel jedes Mal an einem anderen Ort auf dem Bildschirm zu zeichnen. Aus
diesem Grund werden wir den Zeiger auf das Ziel in einem Register setzen, das
wir während der Routine ändern werden.

In der inneren Schleife zeichnen wir nacheinander die Kacheln, die eine 
horizontale Reihe bilden. Nachdem wir eine Kachel gezeichnet haben, müssen 
wir den Zeiger auf das Ziel um ein Wort nach rechts verschieben, d.h. wir
müssen den Zeiger auf das nächste Wort im Speicher setzen.
Dies entspricht dem Hinzufügen von 2 an der Adresse (ein Wort = 2 Bytes).

Auf diese Weise, wenn wir zur letzten Iteration des inneren Zyklus kommen
zeigt der Ziel-Zeiger auf das letzte Wort der Zeile. Nach dem Drucken der
Kachel (die letzte in der horizontalen Reihe) wird erneut 2 zum Zeiger
hinzugefügt, so dass es zum ersten Wort der folgenden Zeile zeigt. Jetzt
möchten wir mit dem Drucken einer weiteren Reihe von Kacheln beginnen. Da eine
Reihe von Kacheln 16 Zeilen hoch ist, müssen wir die nächste Reihe 16 Zeilen
niedriger als die eine mit der wir gerade fertig sind zeichnen. Unser Zeiger
bekommt stattdessen wie gesagt Trinkgeld ist also bereits eine Zeile niedriger
als die aktuelle. 

Also müssen wir darauf hinweisen nun weitere 15 Zeilen weiter unten zu drucken.
Dies entspricht dem Hinzufügen von 15 * 40 zur Adresse, weil jede Zeile
40 Bytes (20 Wörter) belegt, was bei jeder Iteration des externen Zyklus
geschieht.


		vor dem Start der ersten Iteration des internen Zyklus
		Der Zeiger zeigt hier.
		
		   |
		   V

Reihe Y		|      |      |      |
Reihe Y+1	|      |      |      |
.
.		   ^
		   |
		   
		nach der letzten Iteration des internen Zyklus
		Der Zeiger zeigt auf dieses Wort.

		Um stattdessen die neue Zeile zu drucken, muss es auf dieses Wort zeigen.
		Um das zu erreichen, müssen wir es um 15 Zeilen nach unten verschieben
		Hinzufügen von 40 für jede Zeile.

		   |
		   V

Reihe Y+16	|      |      |      |



