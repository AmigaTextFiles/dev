
; Lezione14-1.s			** HARMONISCHE SPIELEN **


	SECTION	armonica,CODE

Start:
	move.l	4.w,a6
	jsr	-$78(A6)			; _LVODisable

	bset	#1,$bfe001		; Schaltet den Tiefpassfilter aus

	lea	$dff000,a6
	move.w	$2(a6),d7		; dmaconr - speichern DMA von OS

Clock	equ	3546895

	move.l	#armonica,$a0(a6)	; AUD0LCH.w+AUD0LCL.w=AUD0LC.l
	move.w	#16/2,$a4(a6)		; 16 bytes/2=8 word der Daten (AUD0LEN)
	move.w	#clock/(16*880),$a6(a6)	; AUD0PER zu 251
	move.w	#64,$a8(a6)			; AUD0VOL maximal (0 dB)
	move.w	#$8201,$96(a6)		; einschalten AUD0 DMA in DMACONW

WLMB:
	btst	#6,$bfe001		; warten mit der linken Maustaste
	bne.s	WLMB

	or.w	#$8000,d7		; Bit 15 schaltet ein (SET/CLR)
	move.w	#$0001,$96(a6)	; dmacon - ausschalten aud0
	move.w	d7,$96(a6)		; dmacon - Reset DMA von OS
	move.l	4.w,a6
	jsr	-$7e(a6)			; _LVOEnable
	rts

******************************************************************************

	SECTION	Sample,DATA_C	; Wird es von der DMA gelesen, muss es sich in CHIP befinden

	; Harmonische von 16 Werten, die mit dem IS von trash'm-one erzeugt wurden 

Armonica:
	DC.B	$19,$46,$69,$7C,$7D,$6A,$47,$1A,$E8,$BB,$97,$84,$83,$95,$B8,$E5

	END

******************************************************************************

Die Harmonische ist ein 16-Byte-Sample, das auf Kanal 0 mit Samplingrate 251
gespielt wird.
Um 16 Bytes in 1 Sekunde (1 Hz) abzuspielen, sollte der AUDPER-Wert 1/16 des
Wertes der Taktkonstante sein, da der DMA 1/16 der Zeit für 16 = die ganze 
Zeit = 1 Sekunde warten soll.
Um beispielsweise einen LA3 (= 440 Hz) zu erzeugen, müsste man mit 880 Hz 
abtasten (Nyquist Theorem), wobei die Harmonische mit einer Frequenz von 1 
gelesen werden soll 880 Hz Messwert und die Abtastperiode (= einzugebender
Wert) AUDxPER wäre 1/880 der 1/16 der Taktkonstante:
3546895/16 = 221680 = 1 Hz, Außerdem kann es nicht in das Register eingetragen 
werden da es über dem 16-Bit-Bereich liegt (AUDxPER = 1 word ohne Zeichen);
(3546895/16)/880 = 3546895/(16*880) = 251 = 880 Hz.

N.B.:	Die beiden jsr auf die Funktionen "deaktivieren" und "aktivieren" des 
    exec könnten weggelassen werden, aber für die elegante Codierung, wären 
    sie obligatorisch:
	Unter dem Betriebssystem wäre es nicht möglich, die DMA-Kanäle direkt zu
	berühren (nicht einmal die Audio-Kanäle), nicht so sehr wegen der Gefahr, 
	dass es dazu kommt, dass der Computer abgestürzt ist
    (Exec kann nicht alle Eventualitäten überprüfen)
	Zugriffe auf Hardwareregister, da die Hardware keine Schaltkreise hat
	Schutz und Systembibliotheken wirken keine Wunder
    die Gewissheit, dass Ihre Aufgabe / Ihr Prozess mit anderen in Konflikt steht
    Aufgaben / Prozesse, die Audioressourcen verwenden: Der Amiga hat nur
    einen Soundchip und jeder muss darauf zugreifen, um zu spielen. 
	Der Kernel im ROM stellt AUDIO.DEVICE zur Verfügung
	jede Aufgabe, den Chip zu nutzen und per Software zu vermitteln
	Zugriff und Nutzung zwischen den verschiedenen Prozessen.
	Da dieser Kurs die Verwendung der Hardware durch Zugriff 
	auf die Register beinhaltet, werden wir die devices nicht verwenden und 
	deshalb werden wir immer verpflichtet sein (auch wenn sich niemand anmeldet).
	Zu der Soundhardware wäre es eigentlich nicht nötig) 
	"legal" (mit einer exec-Funktion) das Betriebssystem auszuschalten.

