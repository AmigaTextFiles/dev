;-------------------------------------------------------------------------------
;                                Timer
;
; Codé par Yragael / Denis Duplan (stashofcode@gmail.com) en mai 2018.
;
; Code & documentation on www.stashofcode.com (EN) and www.stashofcode.fr (FR)
;-------------------------------------------------------------------------------

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

;---------- Warten auf vertikales blank (funktioniert nur, wenn der VERTB-Interrupt aktiviert ist!) ----------

_waitVERTB:
	movem.w d0,-(sp)
_waitVERTBLoop:
	move.w INTREQR(a5),d0
	btst #5,d0
	beq _waitVERTBLoop
	movem.w (sp)+,d0
	rts

;---------- Warten auf das einzeilige Raster ----------

; Eingang(s) :
;	D0 = Zeile, in der das Raster erwartet wird
; Verwendung von Registern :
;	=D0 *D1 =D2 =D3 =D4 =D5 =D6 =D7 =A0 =A1 =A2 =A3 =A4 =A5 =A6
; Bemerkung :
;	Vorsicht, wenn die Schleife, aus der der Aufruf stammt, weniger als eine Zeile
;   zur Ausführung benötigt, denn dann sind zwei Aufrufe erforderlich :
;
;	move.w #Y+1,d0
;	jsr _waitRaster
;	move.w #Y,d0
;	jsr _waitRaster

_waitRaster:
	movem.l d1,-(sp)
_waitRasterLoop:
	move.l VPOSR(a5),d1
	lsr.l #8,d1
	and.w #$01FF,d1
	cmp.w d0,d1
	bne _waitRasterLoop
	movem.l (sp)+,d1
	rts

;---------- Warten auf N Frames ----------

; Eingang(s) :
;	D0 = Anzahl der zu wartenden Frames
; Verwendung von Registern :
;	*D0 =D1 *D2 =D3 =D4 =D5 =D6 =D7 =A0 =A1 =A2 =A3 =A4 =A5 =A6

_wait:
	movem.l d0-d2,-(sp)
	move.w d0,d2
_waitLoop:
	IFNE DEBUG							; Funktioniert nur, wenn D0 = 1
	move.w #$0000,BPLCON3(a5)			; AGA-Kompatibilität: Palette 0 auswählen
	move.w #$00F0,COLOR00(a5)
	ENDC
	move.w #DISPLAY_Y+DISPLAY_DY,d0
	jsr _waitRaster
	IFNE DEBUG							; Funktioniert nur, wenn D0 = 1
	move.w #$0000,BPLCON3(a5)			; AGA-Kompatibilität: Palette 0 auswählen
	move.w #$0F00,COLOR00(a5)
	ENDC
	move.w #DISPLAY_Y+DISPLAY_DY+1,d0	; Achten Sie darauf, dass es nicht über 312 hinausgeht  !
	jsr _waitRaster
	subq.w #1,d2
	bne _waitLoop
	movem.l (sp)+,d0-d2
	rts
