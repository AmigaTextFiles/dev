
; Lezione11n2.s - Timing-Routine, mit der Sie auf eine
;		bestimmte Anzahl Hertz warten können

Start:
	move.l	4.w,a6		; Execbase in a6
	jsr	-$84(a6)		; forbid
	jsr	-$78(a6)		; disable
	LEA	$DFF000,A5

	;bsr.s	CIAHZ		; Warten Sie ein paar Sekunden
	bsr.s   CIAHZ2		

	move.l	4.w,a6		; Execbase in a6
	jsr	-$7e(a6)		; enable
	jsr	-$8a(a6)		; permit
	rts


; bfe801 todlo	-	1=~0,02 secs oder 1/50 sec (PAL) oder 1/60 sec (NTSC)
; bfe901 todmid	-	1=~3 secs
; bfea01 todhi	-	1=~21 mins
;
; In der Praxis handelt es sich um einen Timer, der eine 23-Bit-Zahl 
; enthalten kann.
; geteilt: 0-7 Bits in TODLO, Bits 8-15 in TODMID und Bits 16-23 in TODHI.


CIAHZ2:
	MOVE.L	A2,-(SP)
	LEA	$BFE001,A2	; CIAA base -> verwendet
;	LEA	$BFD000,A2	; CIAB base

	MOVE.B	#0,$800(A2)	; TODLO - Bit 7-0 für Timer zu 50-60Hz
						; reset timer!
WCIA:
	CMPI.B	#50*2,$800(A2)	; TODLO - Wait time = 2 Sekunden...
	BGE.S	DONE
	BRA.S	WCIA
DONE:
	MOVE.L	(SP)+,A2
	RTS

	end

Beachten Sie, dass, wenn Sie CIAB verwenden möchten, zu einem Sync-Timer wechseln.
horizontal und nicht vertikal, so ist es sehr schnell. Um
ungefähr 2 Sekunden zu warten müssen die TODMID bemühen:

CIAHZ:
	MOVE.L	A2,-(SP)
;	LEA	$BFE001,A2	; CIAA base
	LEA	$BFD000,A2	; CIAB base -> verwendet

	MOVE.B	#0,$800(A2)	; TODLO - Bit 7-0 für Timer zu 50-60Hz
						; reset timer!
WCIA:
	CMPI.B	#120,$900(A2)	; TODMID - Wait time = 2 Sekunden...
	BGE.S	DONE
	BRA.S	WCIA
DONE:
	MOVE.L	(SP)+,A2
	RTS

Beachten Sie, dass der CIAA TOD von timer.device verwendet wird,
TOD des CIAB wird von graphics.library verwendet!

Wenn Sie können, warten Sie für eine kurze Zeit mit der klassischen Routine:

	lea	$dff006,a0		; VHPOSR
	moveq	#XXX-1,d0	; Anzahl der zu wartenden Zeilen
waitlines:
	move.b	(a0),d1		; $dff006 - aktuelle vertikale Linie in d1
stepline:
	cmp.b	(a0),d1		; sind wir immer noch auf der gleichen Zeile?
	beq.s	stepline	; wenn ja warten
	dbra	d0,waitlines	; Zeile "warten", warten d0-1 Zeilen
