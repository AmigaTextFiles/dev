
; Lezione14-4b.s	** SPIELT KOMPLEXERE WELLENFORMEN **

	section	samplestereo,code

Start:
	move.l	4.w,a6
	jsr	-$78(A6)			; _LVODisable
	bset	#1,$bfe001		; schaltet den Tiefpassfilter aus
	lea	$dff000,a6
	move.w	$2(a6),d7		; dmaconr - speichern DMA von OS

	move.l	#sample1,$a0(a6)	; AUD0LCH.w+AUD0LCL.w=AUD0LC.l
	move.l	#sample2,$b0(a6)	; AUD1LCH.w+AUD1LCL.w=AUD1LC.l
	move.w	#(sample1_end-sample1)/2,$a4(a6) ; Länge in word (AUD0LEN)
	move.w	#(sample2_end-sample2)/2,$b4(a6) ; Länge in word (AUD1LEN)

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

Sample1:
	incbin	"assembler3:sorgenti8/carrasco.21056"
Sample1_end:

Sample2:
	incbin	"assembler3:sorgenti8/lee3.21056"
Sample2_end:

	END

******************************************************************************

Wir haben gerade zwei verschiedene Samples in Stereo gespielt, zwei Samples
mit gleicher idealer Abtastrate und die gleiche Länge (was sehr wichtig ist,
da sie mit derselben Frequenz gelesen werden, sie haben dieselbe Frequenz
Dauer und Schleife sind synchronisiert).