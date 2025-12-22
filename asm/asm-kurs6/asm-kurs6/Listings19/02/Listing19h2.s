
; Listing19h2.s
; Heatmap

; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

; vh [<ratio> <lines>]  "Heat map"


start:
	move.l	$4.w,a6				; Execbase in a6
	jsr	-$78(a6)				; Disable - stoppt das multitasking
;------------------------------------------------------------------------------
mouse1:
	btst	#6,$bfe001			; left mousebutton?
	bne.s	mouse1				
;------------------------------------------------------------------------------
mouse2:
	bsr routine1
	btst	#2,$dff016			; right mousebutton?
	bne.s	mouse2		
;------------------------------------------------------------------------------
	bsr routine2				; Start Copperlist
mouse3:
	btst	#6,$bfe001			; left mousebutton?
	bne.s	mouse3
	bsr routine3				; start old copperlist
;------------------------------------------------------------------------------
exit:
	move.l	4.w,a6				; Execbase in a6
	jsr	-$7e(a6)				; Enable - stellt Multitasking wieder her
	rts


;------------------------------------------------------------------------------
routine1:						; lesson13 - line 1450
	lea	Table,a0				; Zeiger auf Tabelle									- 12 Zyklen
	move.w	#(1200/16)-1,d7		; Anzahl der Bytes geteilt durch 16 für das clr.l !		- 8 Zyklen
Clr:
	clr.l	(a0)+				; zurücksetzen 4 bytes									- 20 Zyklen
	clr.l	(a0)+				; zurücksetzen 4 bytes									- 20 Zyklen
	clr.l	(a0)+				; zurücksetzen 4 bytes									- 20 Zyklen
	clr.l	(a0)+				; zurücksetzen 4 bytes									- 20 Zyklen
	dbra	d7,Clr				; und wir machen 1/16 der Schleifen						- 10 Zyklen	/ (1*14 Zyklen)

	rts
;------------------------------------------------------------------------------
routine2:
	move.l	4.w,a6				; Execbase in a6
	;jsr	-$78(a6)				; Disable - stoppt das Multitasking
	lea	GfxName,a1				; Adresse des Namen der zu öffnenden Library in a1
	jsr	-$198(a6)				; OpenLibrary, Routine der EXEC, die Libraris
								; öffnet, und als Resultat in d0 die Basisadresse
								; derselben Bibliothek liefert, ab welcher
								; die Offsets (Distanzen) zu machen sind
	move.l	d0,GfxBase			; speichere diese Adresse in GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop		; hier speichern wir die Adresse der Copperlist
								; des Betriebssystemes (immer auf $26 nach
								; GfxBase)
	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP
								; (deren Adresse)
	move.w	d0,$dff088			; COPJMP1 - Starten unsere COP
	rts
;------------------------------------------------------------------------------
routine3:
	move.l	OldCop(PC),$dff080	; COP1LC - "Zeiger" auf die Orginal-COP
	move.w	d0,$dff088			; COPJMP1 - und starten sie

	;move.l	4.w,a6
	;jsr	-$7e(a6)			; Enable - stellt Multitasking wieder her
	move.l	GfxBase(PC),a1		; Basis der Library, die es zu schließen gilt
								; (Libraries werden geöffnet UND geschlossen!!)
	jsr	-$19e(a6)				; Closelibrary - schließt die Graphics lib
	rts
;------------------------------------------------------------------------------


GfxName:
	dc.b	"graphics.library",0,0	; Bemerkung: um Charakter in den
								; Speicher zu geben, verwenden wir
								; immer das dc.b und setzen sie
								; unter "" oder ´´, Abschluß mit ,0
								
GfxBase:						; Hier hinein kommt die Basisadresse der graphics.library,
	dc.l	0					; ab hier werden die Offsets gemacht
	
OldCop:							; Hier hinein kommt die Adresse der Orginal-Copperlist
	dc.l	0					; des Betriebssystems

Table:
	blk.b 1200,$FF
	

	SECTION GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$100,$200			; BPLCON0 - Kein Bild, nur Hintergrund
	dc.w	$180,$000			; COLOR0 SCHWARZ
	dc.w	$7f07,$FFFE			; WAIT - Warte auf Zeile $7f (127)
	dc.w	$180,$00F			; COLOR0 BLAU
	dc.w	$FFFF,$FFFE			; ENDE DER COPPERLIST

	end

;------------------------------------------------------------------------------
>r
Filename:Listing19h2.s
>a
Pass1
Pass2
No Errors
>j																				
;------------------------------------------------------------------------------
																				; Shift+F12
>vh																				; mouse 1
001: 00023210 - 00023227 00000017 (23) 37.70663%
002: 000232c0 - 000232d7 00000017 (23) 19.70699%
003: 00023218 - 0002322f 00000017 (23) 18.85336%
004: 000232c8 - 000232df 00000017 (23) 9.85347%
005: 00c4b4c0 - 00c4b4d7 00000017 (23) 1.77182%
006: 00c001e8 - 00c001ff 00000017 (23) 0.89175%
007: 00c496b8 - 00c496cf 00000017 (23) 0.87213%
008: 00c00240 - 00c00257 00000017 (23) 0.69314%
009: 00c023a8 - 00c023bf 00000017 (23) 0.62038%
010: 00c000f0 - 00c00107 00000017 (23) 0.55899%
011: 00c001f0 - 00c00207 00000017 (23) 0.44587%
012: 00c4b4c8 - 00c4b4df 00000017 (23) 0.44434%
013: 00c4d7d8 - 00c4d7ef 00000017 (23) 0.43885%
014: 00c001d8 - 00c001ef 00000017 (23) 0.41372%
024: 00c00120 - 00c0013f 0000001f (31) 0.38844%
015: 00c00030 - 00c00047 00000017 (23) 0.37510%
016: 00c00248 - 00c0025f 00000017 (23) 0.34761%
017: 00c02db8 - 00c02dcf 00000017 (23) 0.29418%
018: 00c496c0 - 00c496d7 00000017 (23) 0.28809%
019: 00c42570 - 00c42587 00000017 (23) 0.27755%
020: 00c00230 - 00c00247 00000017 (23) 0.25184%
021: 00c00238 - 00c0024f 00000017 (23) 0.22614%
022: 00c001e0 - 00c001f7 00000017 (23) 0.22178%
023: 00c4d7e0 - 00c4d7f7 00000017 (23) 0.21951%
025: 00c00128 - 00c0013f 00000017 (23) 0.19205%
026: 00c00028 - 00c0003f 00000017 (23) 0.18763%
027: 00c42568 - 00c4257f 00000017 (23) 0.13239%
028: 00c000e8 - 00c000ff 00000017 (23) 0.10744%
029: 00c00088 - 00c0009f 00000017 (23) 0.08854%
030: 00c066f0 - 00c06707 00000017 (23) 0.06271%
>vh cop
Mask 00000200 Name COP
000: 00000420 - 00000477 00000057 (87) COP
001: 00010508 - 0001051f 00000017 (23) COP
002: 0001ed50 - 0001edef 0000009f (159) COP
003: 00dff088 - 00dff097 0000000f (15) COP
004: 00dff0e0 - 00dff0e7 00000007 (7) COP
005: 00dff100 - 00dff10f 0000000f (15) COP
006: 00dff120 - 00dff13f 0000001f (31) COP
007: 00dff180 - 00dff187 00000007 (7) COP
008: 00dff1a0 - 00dff1bf 0000001f (31) COP
>vhc
heatmap data cleared
>x
;------------------------------------------------------------------------------
>vh																				; check it double!
001: 000232c0 - 000232d7 00000017 (23) 66.66667%								
002: 000232c8 - 000232df 00000017 (23) 33.33333%
>vh cop
Mask 00000200 Name COP
000: 00000420 - 00000477 00000057 (87) COP
001: 0001ed50 - 0001edef 0000009f (159) COP
002: 00dff088 - 00dff097 0000000f (15) COP
003: 00dff0e0 - 00dff0e7 00000007 (7) COP
004: 00dff100 - 00dff10f 0000000f (15) COP
005: 00dff120 - 00dff13f 0000001f (31) COP
006: 00dff180 - 00dff187 00000007 (7) COP
007: 00dff1a0 - 00dff1bf 0000001f (31) COP
>vhc
heatmap data cleared
>x
;------------------------------------------------------------------------------
>vh																				; check it double!
001: 000232c0 - 000232d7 00000017 (23) 66.66667%								; result is the same
002: 000232c8 - 000232df 00000017 (23) 33.33333%
>vh cop
Mask 00000200 Name COP
000: 00000420 - 00000477 00000057 (87) COP
001: 0001ed50 - 0001edef 0000009f (159) COP
002: 00dff088 - 00dff097 0000000f (15) COP
003: 00dff0e0 - 00dff0e7 00000007 (7) COP
004: 00dff100 - 00dff10f 0000000f (15) COP
005: 00dff120 - 00dff13f 0000001f (31) COP
006: 00dff180 - 00dff187 00000007 (7) COP
007: 00dff1a0 - 00dff1bf 0000001f (31) COP
>
;------------------------------------------------------------------------------
;																				; left mousebutton
>vh
001: 000232c0 - 000232d7 00000017 (23) 44.97116%								; bsr routine1			
002: 000232c8 - 000232df 00000017 (23) 22.69508%
003: 00023300 - 00023317 00000017 (23) 20.95065%
004: 000232f8 - 0002330f 00000017 (23) 5.51704%
005: 00023308 - 0002331f 00000017 (23) 5.37727%
006: 000232d0 - 000232e7 00000017 (23) 0.27928%
007: 000232f0 - 00023307 00000017 (23) 0.13971%
008: 000232d8 - 000232ef 00000017 (23) 0.06982%
>vh cop
Mask 00000200 Name COP
000: 00000420 - 00000477 00000057 (87) COP
001: 0001ed50 - 0001edef 0000009f (159) COP
002: 00dff088 - 00dff097 0000000f (15) COP
003: 00dff0e0 - 00dff0e7 00000007 (7) COP
004: 00dff100 - 00dff10f 0000000f (15) COP
005: 00dff120 - 00dff13f 0000001f (31) COP
006: 00dff180 - 00dff187 00000007 (7) COP
007: 00dff1a0 - 00dff1bf 0000001f (31) COP
>vhc
heatmap data cleared
>x
;------------------------------------------------------------------------------
>vh																				; check it double!
001: 00023300 - 00023317 00000017 (23) 64.37773%								; bsr routine1
002: 000232f8 - 0002330f 00000017 (23) 16.95279%
003: 00023308 - 0002331f 00000017 (23) 16.52361%
004: 000232d0 - 000232e7 00000017 (23) 0.85835%
005: 000232c8 - 000232df 00000017 (23) 0.64376%
006: 000232f0 - 00023307 00000017 (23) 0.42917%
007: 000232d8 - 000232ef 00000017 (23) 0.21459%
>vh cop
Mask 00000200 Name COP
000: 00000420 - 00000477 00000057 (87) COP
001: 0001ed50 - 0001edef 0000009f (159) COP
002: 00dff088 - 00dff097 0000000f (15) COP
003: 00dff0e0 - 00dff0e7 00000007 (7) COP
004: 00dff100 - 00dff10f 0000000f (15) COP
005: 00dff120 - 00dff13f 0000001f (31) COP
006: 00dff180 - 00dff187 00000007 (7) COP
007: 00dff1a0 - 00dff1bf 0000001f (31) COP
>vhc
heatmap data cleared
>x
;------------------------------------------------------------------------------
>vh																				; check it double!
001: 00023300 - 00023317 00000017 (23) 64.37762%								; result is the same
002: 000232f8 - 0002330f 00000017 (23) 16.95279%								; bsr routine1
003: 00023308 - 0002331f 00000017 (23) 16.52359%
004: 000232d0 - 000232e7 00000017 (23) 0.85840%
005: 000232c8 - 000232df 00000017 (23) 0.64380%
006: 000232f0 - 00023307 00000017 (23) 0.42920%
007: 000232d8 - 000232ef 00000017 (23) 0.21460%
>vh cop
Mask 00000200 Name COP
000: 00000420 - 00000477 00000057 (87) COP
001: 0001ed50 - 0001edef 0000009f (159) COP
002: 00dff088 - 00dff097 0000000f (15) COP
003: 00dff0e0 - 00dff0e7 00000007 (7) COP
004: 00dff100 - 00dff10f 0000000f (15) COP
005: 00dff120 - 00dff13f 0000001f (31) COP
006: 00dff180 - 00dff187 00000007 (7) COP
007: 00dff1a0 - 00dff1bf 0000001f (31) COP
>vhc
heatmap data cleared
>x
;------------------------------------------------------------------------------
>vh																				; right mousebutton / Shift+F12
001: 00023300 - 00023317 00000017 (23) 35.64396%								; mouse3:
002: 000232e0 - 000232f7 00000017 (23) 29.75436%
003: 000232d8 - 000232ef 00000017 (23) 14.99603%
004: 000232f8 - 0002330f 00000017 (23) 9.38622%
005: 00023308 - 0002331f 00000017 (23) 9.14871%
006: 000232d0 - 000232e7 00000017 (23) 0.47530%
007: 000232c8 - 000232df 00000017 (23) 0.35643%
008: 000232f0 - 00023307 00000017 (23) 0.23760%
010: 00023310 - 0002334f 0000003f (63) 0.00057%
009: 00c066e0 - 00c06707 00000027 (39) 0.00032%
011: 00023338 - 0002334f 00000017 (23) 0.00007%
012: 00c00038 - 00c00057 0000001f (31) 0.00007%
013: 00c00038 - 00c0004f 00000017 (23) 0.00002%
>vh cop
Mask 00000200 Name COP
000: 00000420 - 00000477 00000057 (87) COP
001: 00010508 - 0001051f 00000017 (23) COP
002: 0001ed50 - 0001edef 0000009f (159) COP
003: 00dff088 - 00dff097 0000000f (15) COP
004: 00dff0e0 - 00dff0e7 00000007 (7) COP
005: 00dff100 - 00dff10f 0000000f (15) COP
006: 00dff120 - 00dff13f 0000001f (31) COP
007: 00dff180 - 00dff187 00000007 (7) COP
008: 00dff1a0 - 00dff1bf 0000001f (31) COP
>vhc
heatmap data cleared
>x
;------------------------------------------------------------------------------
>vh																				; Shift+F12
001: 000232e0 - 000232f7 00000017 (23) 66.66667%								; mouse3:
002: 000232d8 - 000232ef 00000017 (23) 33.33333%
>vh cop
Mask 00000200 Name COP
000: 00010508 - 0001051f 00000017 (23) COP
001: 00dff100 - 00dff107 00000007 (7) COP
002: 00dff180 - 00dff187 00000007 (7) COP
>vhc
heatmap data cleared
>x
;------------------------------------------------------------------------------
>vh																				; Shift+F12
001: 000232e0 - 000232f7 00000017 (23) 66.66662%								; mouse3:
002: 000232d8 - 000232ef 00000017 (23) 33.33338%
>vh cop
Mask 00000200 Name COP
000: 00010508 - 0001051f 00000017 (23) COP
001: 00dff100 - 00dff107 00000007 (7) COP
002: 00dff180 - 00dff187 00000007 (7) COP
>
																				; note: check the result double!
