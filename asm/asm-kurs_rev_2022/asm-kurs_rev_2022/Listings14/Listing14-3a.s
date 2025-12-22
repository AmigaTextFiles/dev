
; Listing14-3a.s	** PRÄZISIONSTÖNE UND HALBTÖNE **

	SECTION	Toni,CODE

Start:
	move.l	4.w,a6
	jsr	-$78(A6)				; _LVODisable
	bset	#1,$bfe001			; Schaltet den Tiefpassfilter aus
	lea	$dff000,a6
	move.w	$2(a6),d7			; dmaconr - speichern DMA für OS

	move.l	#armonica,$a0(a6)	; AUD0LCH.w+AUD0LCL.w=AUD0LC.l
	move.w	#16/2,$a4(a6)		; 16 bytes/2=8 word der Daten (AUD0LEN)

	move.l	#12*2+2,d0			; RE3
	moveq	#16,d1
	bsr.s	halftone2per
	move.w	d0,$a6(a6)			; AUD0PER

	move.w	#64,$a8(a6)			; AUD0VOL maximal (0 dB)
	move.w	#$8001,$96(a6)		; einschalten AUD0 DMA in DMACONW

WLMB:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	WLMB

	or.w	#$8000,d7			; Bit 15 schaltet ein (SET/CLR)
	move.w	#$0001,$96(a6)		; dmacon - ausschalten aud0
	move.w	d7,$96(a6)			; dmacon - reset DMA von OS
	move.l	4.w,a6
	jsr	-$7e(a6)				; _LVOEnable
	rts

******************************************************************************
;			«  Periode der Halbtöne »
;
; Berechnen Sie die Periode, die in AUDxPER eingefügt werden soll, wenn der 
; Halbton von DO1 ausgeht
; d0.w   = Halbton (ab DO1 = 0)
; d1.w   = Länge Harmonische (in byte)
******************************************************************************

Clock	equ	3546895
DO1	equ	131				; Frequenz [Hz] für DO1  ; C3 = 130,81HZ

HalfTone2Per:
	divu.w	#12,d0
	move.w	#do1,d2
	lsl.w	d0,d2
	swap	d0
	add.w	d0,d0
	add.w	d0,d0
	mulu.w	halftones(pc,d0.w),d2
	divu.w	halftones+2(pc,d0.w),d2
	move.l	#clock,d0
	mulu.w	d2,d1
	divu.w	d1,d0
	rts					; [d0.w=Periode für Sampling]

HalfTones:									; deutsche Notennamen
	dc.w	10000,10000	; DO=1.0			; C
	dc.w	10595,10000	; DO#=1.0595		; CIS/DES
	dc.w	11225,10000	; RE=1.1225			; D
	dc.w	11892,10000	; RE#=1.1892		; DIS/ES
	dc.w	12599,10000	; MI=1.2599			; E
	dc.w	13348,10000	; FA=1.3348			; F
	dc.w	14142,10000	; FA#=1.4142		; FIS/GES	
	dc.w	14983,10000	; SOL=1.4983		; G
	dc.w	15874,10000	; SOL#=1.5874		; GIS/AS
	dc.w	16818,10000	; LA=1.6818			; A
	dc.w	17818,10000	; LA#=1.7818		; AIS/B
	dc.w	18877,10000	; SI=1.8877			; H

******************************************************************************

	SECTION	Sample,DATA_C	; Wird es von der DMA gelesen, muss es sich in CHIP befinden

	; Harmonische von 16 Werten, die mit dem IS von trash'm-one erzeugt wurden

Armonica:
	DC.B	$19,$46,$69,$7C,$7D,$6A,$47,$1A,$E8,$BB,$97,$84,$83,$95,$B8,$E5

	END

******************************************************************************

Diese Listing unterscheidet sich nicht wesentlich vom Vorherigen.
Es beinhaltet eine kleine Routine, die die Abtastperiode einer Note berechnet.
Der einzige unterschied ist, dass man jetzt nicht nur 7 Noten einer Skala von
verschiedenen Oktaven erzeugen kann, sondern auch die Noten der "schwarzen
Tasten" eines Klaviers oder die DIESIS (#) / BEMOLLE (b): 
Kurz gesagt, Sie haben auch die Möglichkeit die HALBTÖNE zu spielen.
Zunächst fällt ein Unterschied auf: Die Werte der Tabelle "HalfTones" sind viel
größer als die in der Tabelle "Notes" im vorherigen Beispiel und dies, um eine
größere Präzision zu gewährleisten: In der Tat die zwei Wörter bezeichnen
jeweils Zähler und Nenner des Bruchs, der die Beziehung zwischen einer Note und
dem C auf einer Skala angibt und in der Tat ändert sich die Beziehung nicht.
Nehmen Sie zum Beispiel das SOL: In "Notes" ist der Wert 3/2 = 1.5, in
"HalfTones" ist es gleich 14983/10000 = 1.4983. Wie Sie am Wert sehen ist es
fast das gleiche (der Unterschied ist vernachlässigbar). In "Notes" habe ich
über die "klassischen" Brüche berichtet, die in vielen Bücher über akustische
Physik gefunden werden können, die den Vorteil haben, kleine und leicht zu
merkende Zähler und Nenner zu haben.
Die Werte der "Halbtöne" haben stattdessen zusätzlich zu den Verhältnissen
aller Noten auf der Halbtonskala eine Genauigkeit von 4 Nachkommastellen. Es
wird erreicht, indem mit sehr großen Zahlen multipliziert und dann durch 
10^ Anzahl der Nachkommastellen dividiert wird oder bis zum Zehntausendstel.
Das Unterprogramm "HalfTone2Per" funktioniert ungefähr wie das Unterprogramm 
"Note2Per". Der einzige Unterschied besteht in der Angabe des Eingabeparameters:
Einmal muss der gewünschte Halbton ab DO1 angegeben werden. Wenn wir also ein
FA1 spielen wollen, müssen wir in d0.w = 5 setzen. Zwischen dem DO1 und dem FA1
gibt es 5 Halbtöne Unterschied. In der Musik ist 1 Ton = 2 Halbtöne, und jede
Tonleiter hat 6 Töne = 12 Halbtöne. Zwischen einer Note und der anderen liegt
1 Ton, ohne die Frequenzintervalle zwischen MI und FA und zwischen SI und DO
der Oktave, danach sind sie nur noch gleich 1 Halbton.
Da es bei jeder Oktave notwendig ist, die Frequenz zu verdoppeln, erhöht sich
die Frequenz der Noten - innerhalb einer Skala und darüber hinaus - ist es
nicht konstant, aber EXPONENTIEL mit Basis 2. Also die Berechnung der
Verhältnisse der Noten innerhalb einer Skala ist dann so einfach wie es
scheint: 
Es gilt zu wissen, dass das Intervall von Verhältnissen in einer Skala von 
12 Halbtönen gleich 1 ist (von 1 des ersten DO bis 2 des DO der nächsten
Oktave). Jeder Halbton ist 1/12 in der Abszissen-Achse eines kartesischen
Graphen (x, y) zum Nächsten, der die Funktion darstellt. exponentiell: Y = 2^X.
Betrachten Sie das Intervall 0 <= X <= 1, in dem wir uns befinden. Ordne einen
Kurvenzweig 2^0<=Y<=2^1 = 1<=Y<=2 zu. Jetzt werden alle 12 relativen Werte von
Y beginnend von X = 0 berechnet. 
12 mal: Y=2^(1/12), Y=2^(2/12), Y=2^(3/12) und so weiter bis zu Y=2^(12/12) = 2,
was dem Verhältnis des 12. Halbtons oder des DO der nächsten Oktave entspricht.
Jeder erhaltene Dezimalwert entspricht dem Wert mit dem multipliziert werden 
muss, um die die Frequenz der gewünschten Note in der Oktave zu erhalten.
Dieser Dezimalwert muss in einen Bruch umgewandelt werden. In der Tat MUSS es
zu einem Bruch mit Zahlen zurückverfolgt werden  (nicht dezimal), da der 68000
nur ganze Zahlen "simulieren" kann (d.h. ohne Komma). Um zum Beispiel die
Beziehung zwischen einem LA# und DO (= 1/1) zu kennen:
Y = 2^(10/12) = 2^0.8333 (...periodisch...) = 1.7818 (Runden).
Diese Dezimalstellen der Zahl lassen sich leicht auf den Bruch 17818/10000 
zurückführen. (Es ist eigentlich 17818 zehntausendstel.)
Nun, wenn wir zum Beispiel eine LA3# wollen: DO3 = 131 * 2^(3-1) = 
131*2*2=131*4=524 Hz. LA3# =(524*17818)/10000 = 933 Hz.

