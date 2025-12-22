
; Listing13d1b.s - Tabellen 
; Tabelle wird im Programm berechnet
; Zeile 1001

start:
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;
	bsr.w	PrecalcoTabba		; Tabbelle mit Vorberechneten Koeffizienten
;-------------------------------
	move.w	#15,d0 
;-------------------------------
	lea	Table,a0				; Adresse der Tabelle
	add.w	d0,d0				; d0 * 2, um den Offset der Tabelle zu finden,
								; da jeder Wert ein Wort lang ist
	move.w	(a0,d0.w),d0		; Kopieren des richtigen Werts aus der Tabelle nach d0
;-------------------------------
	move.w	#15,d0 
;-------------------------------
	add.w	d0,d0				; d0*2, jeder Wert 1 Wort, d.h. 2 Bytes
	;move.w	Table(pc,d0.w),d0	; Kopie von der Tabelle, der richtige Wert bis 256 Bytes
								; realtive mode error	
;-------------------------------
	; move.w	#15,d0
	; move.w	Table(pc,d0.w*2),d0	; Anweisung von 68020 oder höher

		rts


PrecalcoTabba
	lea	Table,a0				; Adressraum von 100 zu schreibenden Wörtern
								; Vielfache von c ...
	moveq	#0,d0				; Start mit 0...
	move.w	#100-1,d7			; 100 Werte
PreCalcLoop
	move.w	d0,(a0)+			; wir speichern das aktuelle Vielfache
	add.w	#1,d0				; c hinzufügen, nächstes Vielfaches
	dbra	d7,PreCalcLoop		; Wir erstellen die gesamte MulTab
	
	rts


	SECTION	Precalc,bss

Table:
	ds.w	100		; Beachten Sie, dass der aus Nullen bestehende BSS-Abschnitt
					; nicht die tatsächliche Länge der ausführbaren Datei verlängert.
		end


>m 21370
00021370 0000 0001 0002 0003 0004 0005 0006 0007  ................
00021380 0008 0009 000A 000B 000C 000D 000E 000F  ................
00021390 0010 0011 0012 0013 0014 0015 0016 0017  ................
000213A0 0018 0019 001A 001B 001C 001D 001E 001F  ................
000213B0 0020 0021 0022 0023 0024 0025 0026 0027  . .!.".#.$.%.&.'
000213C0 0028 0029 002A 002B 002C 002D 002E 002F  .(.).*.+.,.-.../
000213D0 0030 0031 0032 0033 0034 0035 0036 0037  .0.1.2.3.4.5.6.7
000213E0 0038 0039 003A 003B 003C 003D 003E 003F  .8.9.:.;.<.=.>.?
000213F0 0040 0041 0042 0043 0044 0045 0046 0047  .@.A.B.C.D.E.F.G
00021400 0048 0049 004A 004B 004C 004D 004E 004F  .H.I.J.K.L.M.N.O
00021410 0050 0051 0052 0053 0054 0055 0056 0057  .P.Q.R.S.T.U.V.W
00021420 0058 0059 005A 005B 005C 005D 005E 005F  .X.Y.Z.[.\.].^._
00021430 0060 0061 0062 0063 1234 5678 0102 0000  .`.a.b.c.4Vx....
00021440 000A 0102 0000 0018 0000 0000 0000 0000  ................
00021450 0000 0000 0000 0000 0000 0000 0000 0000  ................
>

table:
	dc.w $0000, $0001, $0002, $0003, $0004, $0005, $0006, $0007
	dc.w $0008, $0009, $000A, $000B, $000C, $000D, $000E, $000F
	dc.w $0010, $0011, $0012, $0013, $0014, $0015, $0016, $0017
	dc.w $0018, $0019, $001A, $001B, $001C, $001D, $001E, $001F
	dc.w $0020, $0021, $0022, $0023, $0024, $0025, $0026, $0027
	dc.w $0028, $0029, $002A, $002B, $002C, $002D, $002E, $002F
	dc.w $0030, $0031, $0032, $0033, $0034, $0035, $0036, $0037
	dc.w $0038, $0039, $003A, $003B, $003C, $003D, $003E, $003F
	dc.w $0040, $0041, $0042, $0043, $0044, $0045, $0046, $0047
	dc.w $0048, $0049, $004A, $004B, $004C, $004D, $004E, $004F
	dc.w $0050, $0051, $0052, $0053, $0054, $0055, $0056, $0057
	dc.w $0058, $0059, $005A, $005B, $005C, $005D, $005E, $005F
	dc.w $0060, $0061, $0062, $0063

;------------------------------------------------------------------------------
r
Filename: Listing13d1b.s
>a
Pass1
Pass2
No Errors
>j					


;------------------------------------------------------------------------------
r
Filename: Listing13d1b.s
>a
Pass1
Pass2
No Errors
>wo
FILENAME>Listings13da1
Sorting relo-area
Writing hunk length..
Writing hunk data..
File length = 149 (=$00008C)