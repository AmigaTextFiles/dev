
; Lezione14-4a.s	** SPIELT KOMPLEXE WELLENFORMEN **


	section	samplemono,code

Start:
	move.l	4.w,a6
	jsr	-$78(A6)			; _LVODisable
	bset	#1,$bfe001		; Schaltet den Tiefpassfilter aus
	lea	$dff000,a6
	move.w	$2(a6),d7		; dmaconr - speichern DMA von OS

	move.l	#sample,$a0(a6)	; AUD0LCH.w+AUD0LCL.w=AUD0LC.l
	move.l	#sample,$b0(a6)	; AUD1LCH.w+AUD1LCL.w=AUD1LC.l
	move.w	#(sample_end-sample)/2,$a4(a6)	; Länge in word (AUD0LEN)
	move.w	#(sample_end-sample)/2,$b4(a6)	; Länge in word (AUD1LEN)

Clock	equ	3546895

	move.w	#clock/21056,$a6(a6)	; AUD0PER mit 168
	move.w	#clock/21056,$b6(a6)	; AUD1PER mit 168

	move.w	#64,$a8(a6)		; AUD0VOL maximal (0 dB)
	move.w	#64,$b8(a6)		; AUD1VOL maximal (0 dB)
	move.w	#$8003,$96(a6)	; einschalten AUD0-AUD1 DMA in DMACONW


WLMB:
	btst	#6,$bfe001		; warte auf die linke Maustaste
	bne.s	WLMB

	or.w	#$8000,d7		; einschalten mit Bit 15 (SET/CLR)
	move.w	#$0003,$96(a6)	; ausschalten DMA
	move.w	d7,$96(a6)		; rücksetzen DMA von OS
	move.l	4.w,a6
	jsr	-$7e(a6)			; _LVOEnable
	rts

******************************************************************************

	SECTION	Sample,DATA_C

; Bemerkung: das Sample wird von "NASP" by Pyratronik/IBB entnommen

Sample:	incbin	"assembler3:sorgenti8/carrasco.21056"
Sample_end:

	END

******************************************************************************

Für dieses Beispiel gibt es nicht viele Erklärungen:
Es gibt keine Neuigkeiten, in der Tat ist es Beispiel 1 sehr ähnlich und wir
sind viel anspruchsvollere Listings gewöhnt.
Nur eines: Die Abtastrate der Samples beträgt 21056Hz es ist gleich der
ursprünglichen Aufnahmefrequenz: es ist notwendig ein SAMPLING SPEED
einzustellen, das der Digitalisierungsgeschwindigkeit entspricht. Wenn Sie
den Ton mit der richtigen Geschwindigkeit hören möchten, versuchen Sie es
mit einer Änderung die Abtastperiode in AUDxPER ...

*** Ich möchte darauf hinweisen, dass 21056 NICHT die Häufigkeit angibt, mit
der das gesamte Sample gelesen wird, aber die Lesefrequenz byteweise:
21056 Bytes pro Sekunde werden in einem Sample beliebiger Länge gelesen.
Der Hardware muss der relative Abtastzeitraum mit der Lesegeschwindigkeit
mitgeteilt werden.
Wie bei der Harmonischen: Zuerst haben wir festgestellt, wie oft
die GANZE Welle gelesen wurde, dann haben wir die Abtastperiode berechnet:
Multiplizieren der Frequenz der Note mit der Länge des Samples in Bytes, so
holen Sie sich die Lesegeschwindigkeit ***.


Anmerkung vom Übersetzer: 
(Quelle: http://www.winnicki.net/amiga/memmap/AUDxPER.html)

		How you determine the period depends on how you get
        your waveform data.  If you use a digitizer and the
        frequency is in Samples-per-second, use this
        equation:                   3579546
                    AUDxPER = --------------------
                               Samples-per-second
							   

Hinweis zu Clock	equ	3546895		

(Quelle: https://www.amigawiki.org/) 
bzw. https://www.amigawiki.org/doku.php?id=de:signals:pal
Das Amiga-Chipset wird bei einem PAL-Computer mit 28,37516 MHz getaktet.
Die Motivation hierfür war, möglichst nahe an die Basisfrequenz der NTSC-Version
von 28,63636 MHz zu kommen. Nach Teilung durch 8 entsteht ein Takt von 3,546895MHz,
welcher recht nahe an der „colour clock“ (CCK) des NTSC-Amiga liegt. Der
PAL-Farbträger wird erzeugt, indem dieser Takt mit dem Faktor 1,25 multipliziert
wird. Das Ergebnis von 4,43361875 MHz ist exakt der Takt, der in der PAL-Fernsehnorm
genutzt wird.

d.h. NTSC: 28,63636 MHz/8 = 3,579546 MHz

Amiga500: Taktfrequenz PAL: 7,09MHz bzw. NTSC: 7,16MHz
PAL:  2*3,546895 MHz = 7,09379MHz
NTSC: 2*3,579546 MHz = 7,15909MHz