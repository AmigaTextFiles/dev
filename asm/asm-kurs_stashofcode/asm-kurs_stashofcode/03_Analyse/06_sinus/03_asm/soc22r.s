
; soc22r.s

; Blitter erase
; Erase the hidden bitplane

DMACONR=$002
DMACON=$096

BLTAFWM=$044
BLTALWM=$046
BLTAPTL=$052
BLTCPTH=$048
BLTDPTH=$054
BLTAMOD=$064
BLTBMOD=$062
BLTCMOD=$060
BLTDMOD=$066
BLTADAT=$074
BLTBDAT=$072
BLTCON0=$040
BLTCON1=$042
BLTSIZE=$058

DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C

WAITBLIT:	MACRO
_waitBlitter0\@
	btst #14,DMACONR(a5)
	bne _waitBlitter0\@
_waitBlitter1\@
	btst #14,DMACONR(a5)
	bne _waitBlitter1\@
	ENDM

;waitmouse
;	btst	#2,$dff016			; right mousebutton?
;	bne.s	waitmouse	
	
start:
	lea $dff000,a5
	move.w #$83C0,DMACON(a5)	;DMAEN=1, COPEN=1, BPLEN=1, COPEN=1, BLTEN=1
		
	WAITBLIT
	move.w #0,BLTDMOD(a5)									; Modulo D = 0	
	move.w #$0000,BLTCON1(a5)								; keine Sondermodi
	move.w #%0000000100000000,BLTCON0(a5)					; BLTCON0, $0100, only USED
	;move.l bitplaneC,BLTDPTH(a5)							; Ziel
	move.l #bitplaneC,BLTDPTH(a5)							; Ziel (damit das Beispiel funktioniert)
	move.w #(DISPLAY_DX>>4)!(DISPLAY_DY<<6),BLTSIZE(a5)		; 320/16=20 Wörter, 256 Zeilen
										
	nop
	rts

	Section bitplane,DATA_C

bitplaneA:				blk.b 10240,$11		; für 320x256						$FF für Vollbild
bitplaneB:				blk.b 10240,$80		; für 320x256						$FF für Vollbild
bitplaneC:				blk.b 10240,$AA		; für 320x256						$FF für Vollbild
	
	end

Programmerklärung:

	lea bitplaneC,a0
	move.w #(DISPLAY_DX),d0						; MOVE.W #$0140,D0
	move.w #(DISPLAY_DX>>4),d0					; MOVE.W #$0014,D0
	move.w #(DISPLAY_DX>>4)!(DISPLAY_DY),d0		; MOVE.W #$0114,D0
	move.w #(DISPLAY_DX>>4)!(DISPLAY_DY<<6),d0	; MOVE.W #$4014,D0
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),d0	; MOVE.W #$4014,D0	- besser links Zeilen, rechts Breite Wörter

>?320
$00000140 = %00000000`00000000`00000001`01000000 = 320 = 320
>?320>>4
$00000014 = %00000000`00000000`00000000`00010100 = 20 = 20
>

DISPLAY_DY<<6	= 256 Zeilen nach links verschoben * 64 (Bits 6-15)
DISPLAY_DX>>4	= 320/16 = $14 = 00010100