
; Lezione11n1.s - Timing-Routine, mit der Sie eine bestimmte Anzahl 
; von Mikrosekunden unter Verwendung eines CIAA / B-Timers B warten können

; Mit dieser Testroutine können Sie überprüfen, wie viele Videozeilen vorhanden sind
; Sie entsprechen einer bestimmten Anzahl von Mikrosekunden.
; (Der ROTE Teil des Bildschirms ist derjenige, in dem die Routine ausgeführt wird.)


MICS:	equ	2000	; ~2000 Microsekunden = ~2 Millisekunden
					; Wert = Micros/1,4096837
					; 1 Microsekunde = 1 sec/1 Million
					; HINWEIS: Zum Vergleichen dieser Routine mit
					; derjenigen, die auf die Rasterlinien wartet, zählen sie
					; ca 200 Millisekunden stimmen mit ca. 5 Rasterzeilen überein,
					; 400 Millisekunden mit 9,5 Zeilen,
					; 600 Millisekunden mit 14 Zeilen etc.

Start:
	move.l	4.w,a6		; Execbase in a6
	jsr	-$84(a6)		; forbid
	jsr	-$78(a6)		; disable
	LEA	$DFF000,A5

WBLANNY:
	MOVE.L	4(A5),D0	; $dff004 - VPOSR/VHPOSR
	ANDI.L	#$1FF00,D0	; wirkt sich nur auf die Bits der vertikalen Zeile aus
	CMPI.L	#$08000,D0	; warte auf Zeile  $80
	BNE.S	WBLANNY

	move.w	#$f00,$180(a5)	; Color 0 ROT

	bsr.s	CIAMIC

	move.w	#$0f0,$180(a5)	; Color 0 GRÜN

	btst	#6,$bfe001
	bne.s	WBLANNY


	move.l	4.w,a6		; Execbase in a6
	jsr	-$7e(a6)		; enable
	jsr	-$8a(a6)		; permit
	rts

;	Hier ist die Routine, die eine bestimmte Anzahl von MICROSEKUNDEN 
;   mit dem A-Timer des CIAB wartet. Zur Verwendung des CIAA-Timers reicht A aus
;   Ersetzen Sie "lea $bfd000,a4" durch "lea $bfe001,a4". Im Listing ist es
;   bereits vorhanden. Entfernen Sie einfach das Semikolon und setzen Sie 
;   stattdessen die grundlegende CIAB ein. Es ist jedoch besser, die CIAB zu verwenden, 
;   da der CIAA-Timer wird vom Betriebssystem für verschiedene Aufgaben verwendet wird.

CIAMIC:
	movem.l	d0/a4,-(sp)	; speichern der verwendeten Register
	lea	$bfd000,a4		; CIAB base

; 	lea	$bfe001,a4		; CIAA base
						; WIRD VOM BETRIEBSSYSTEM GENUTZT! 
						; BENUTZEN SIE NICHT DEN TIMER B!
						; DEN CIAA, BITTE!

	move.b  $f00(a4),d0			; $bfde00 - CRB, CIAB control reg. B
	andi.b   #%11000000,d0		; bit 0-5 zurücksetzen
	ori.b    #%00001000,d0		; One-Shot mode (runmode single)
	move.b  d0,$f00(a4)			; CRB - Steuerregister setzen
	move.b  #%01111101,$d00(a4)	; ICR - löscht die interrupts CIA
	move.b  #(MICS&$FF),$600(a4)	; TBLO - setzen Sie das Low-Byte der Zeit
	move.b  #(MICS>>8),$700(a4)	; TBHI - setzen Sie das High-Byte der Zeit
	bset.b  #0,$f00(a4)			; CRB - Start timer!!
wait:
	btst.b  #1,$d00(a4)	; ICR - Wir warten darauf, dass die Zeit abläuft.
						; Beachten Sie, dass Bit 1 getestet wird und nicht
						; Bit 0, um auf Timer B zu warten.
	beq.s   wait
	movem.l	(sp)+,d0/a4		; Register wieder herstellen
	rts

	end

; Nur eine letzte Sache. Wenn Sie Zeit hätten, auf einem Label zu warten, könnten Sie
; "chop" in low byte und high byte mit einem lsr legen:

	lea	$bfd000,a4				; cia_b base
	move.w	TimerValue(PC),d0	; countdown
	move.b	d0,$600(a4)			; timer B - set lo byte
	lsr.w	#8,d0
	move.b	d0,$700(a4)			; timer B - set hi byte
			; 76543210
	move.b  #%01111101,$d00(a4)	; ICR - löscht die interrupts CIA
	move.b	#%00011001,$f00(a4)	; CRB - start
					; 7 - Alarm -> 0
					; 6,5 - Inmode bits -> 00
					; 4 - Load bit -> 1 (lädt es bei
					;		Timer den Wert, und es beginnt
					;		der Countdown).
					; 3 - RunMode -> 1 (One shot, 1 Zeit)
					; 2 - OutMode -> 0 (per ricev. pulse)
					; 1 - PBON -> 0
					; 0 - Start -> zählt
					; nach unten; runter auf 0-> Interrupt
	MOVE.B	#%10000010,$d00(a4)	; ICR - aktivieren interr. timer B ciaB
loop:
	btst	#1,$d00(a4)		; ICR - test tb-bit ->clear ICR
	beq.s	loop			; not set->wait
	rts


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


