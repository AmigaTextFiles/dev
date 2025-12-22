
; Listing11n1.s - Timing Routine, mit der Sie eine bestimmte Anzahl von 
; Mikrosekunden unter Verwendung eines Timers A von CIAA/B warten können

; Mit dieser Testroutine können Sie überprüfen, wie viele Videozeilen vorhanden sind
; Sie entsprechen einer bestimmten Anzahl von Mikrosekunden.
; (Der ROTE Teil des Bildschirms ist derjenige, in dem die Routine ausgeführt wird.)


MICS:	equ	2000				; ~2000 Microsekunden = ~2 Millisekunden
								; Wert = Micros/1,4096837
								; 1 Microsekunde = 1 sec/1 Million
								; HINWEIS: Zum Vergleichen dieser Routine mit
								; derjenigen, die auf die Rasterlinien wartet, zählen sie
								; ca 200 Millisekunden stimmen mit ca. 5 Rasterzeilen überein,
								; 400 Millisekunden mit 9,5 Zeilen,
								; 600 Millisekunden mit 14 Zeilen etc.

Start:
	move.l	4.w,a6				; Execbase in a6
	jsr	-$84(a6)				; forbid
	jsr	-$78(a6)				; disable
	LEA	$DFF000,A5

WBLANNY:
	MOVE.L	4(A5),D0			; $dff004 - VPOSR/VHPOSR
	ANDI.L	#$1FF00,D0			; wirkt sich nur auf die Bits der vertikalen Zeile aus
	CMPI.L	#$08000,D0			; warte auf Zeile $080
	BNE.S	WBLANNY

	move.w	#$f00,$180(a5)		; Color 0 ROT

	bsr.s	CIAMIC

	move.w	#$0f0,$180(a5)		; Color 0 GRÜN

	btst	#6,$bfe001
	bne.s	WBLANNY


	move.l	4.w,a6				; Execbase in a6
	jsr	-$7e(a6)				; enable
	jsr	-$8a(a6)				; permit
	rts

;	Hier ist die Routine, die eine bestimmte Anzahl von MICROSEKUNDEN mit dem,
;   Timer A des CIAB wartet. Zur Verwendung des Timer A des CIAA reicht es aus
;   "lea $bfd000,a4" durch "lea $bfe001,a4" zu ersetzen. Im Listing ist es
;   bereits vorhanden. Entfernen Sie einfach das Semikolon und setzen Sie 
;   stattdessen den CIAB ein. Es ist jedoch besser, die CIAB zu verwenden, 
;   da der CIAA-Timer vom Betriebssystem für verschiedene Aufgaben verwendet wird.

CIAMIC:
	movem.l	d0/a4,-(sp)			; speichern der verwendeten Register
 	lea	$bfd000,a4				; CIAB base
 ;	lea	$bfe001,a4				; CIAA base (wenn Sie die B verwenden möchten)
	move.b  $e00(a4),d0			; $bfde00 - CRA, CIAB control reg. A
	andi.b   #%11000000,d0		; setzt i zurück Bit 0-5
	;andi.b   #%00000000,d0		; alles zurücksetzen - AdÜ
	ori.b    #%00001000,d0		; One-Shot mode (runmode single)
	move.b  d0,$e00(a4)			; CRA - Steuerregister festlegen
	move.b  #%01111110,$d00(a4)	; ICR - löscht die interrupts CIA
	;move.b  #%01111111,$d00(a4)	; ICR - löscht die interrupts CIA - AdÜ
	move.b  #(MICS&$FF),$400(a4)	; TALO - Setzen Sie das Low-Byte der Zeit
	move.b  #(MICS>>8),$500(a4)	; TAHI - Setzen Sie das High-Byte der Zeit
	bset.b  #0,$e00(a4)			; CRA - Start timer!!
wait:
	btst.b  #0,$d00(a4)			; ICR - Wir warten darauf, dass die Zeit abläuft
	beq.s   wait
	movem.l	(sp)+,d0/a4			; Register wieder herstellen
	rts

	end

; CIA:	ICR  (Interrupt Control Register)				[d]
;
; 0	TA			underflow
; 1	TB			underflow
; 2	ALARM		TOD alarm
; 3	SP			serial port full/empty
; 4	FLAG		flag
; 5-6			unused
; 7  R			IR
; 7  W			set/clear
;
; CIA:  CRA, CRB  (Control Register)					[e-f]
;
; 0	START			0 = stop / 1 = start TA; {0}=0 when TA underflow
; 1	PBON			1 = TA output on PB / 0 = normal mode
; 2	OUTMODE			1 = toggle / 0 = pulse
; 3	RUNMODE			1 = one-shot / 0 = continous mode
; 4  S	LOAD		1 = force load (strobe, always 0)
; 5   A	INMODE		1 = TA counts positive CNT transition
;					0 = TA counts 02 pulses
; 6   A	SPMODE		serial port....
; 7   A	unused
; 6-5 B	INMODE		00 = TB counts 02 pulses
;					01 = TB counts positive CNT transition
;					10 = TB counts TA underflow pulses
;					11 = TB counts TA underflow pulses while CNT is high
; 7   B	ALARM		1 = writing TOD sets alarm
;					0 = writing TOD sets clock
;					Reading TOD always reads TOD clock

