
; soc04d.s
; Programm zeigt die Zeitschleife (Wartemodus) und das holen des nächsten
; BLTCON0-Wertes aus der Tabelle

BLTCON0=$040
;MINTERMS_SPEED=100		; In Frames ausgedrückt (1/50 Sekunden)
MINTERMS_SPEED=4		; zu Testzwecken (debuggen)		

; Konfigurieren Sie die Intervalle (alle außer abc für D = A | B | C)

start:	
	; Timer und Offset, um die Werte von BLTCON0 zu durchlaufen und die 256 Kombinationen von Intervallen zu testen

	move.w #(256-1)<<1,d7				; Offset in bltcon0		255*2=510 ($1fe) ; zeigt also auf $0fff
	swap d7								; $0000.01FE --> 01FE.0000
	move.w #1,d7						; Timer		 --> 01FE.0001
	
_loop:

	;WAITBLIT
	subq.w #1,d7						; 01FE.0000 (erste Runde) 
	bge _mintermsNoChange				; wenn d7>=0 werden die folgenden Anweisungen übersprungen
	move.w #MINTERMS_SPEED,d7			; 01FE.0064, d7=$64 (100)
	swap d7								; $0064.01FE 
	lea bltcon_0,a1						; Anfangsadresse des Feldes der verschiedenen BLTCON0-Werte
	;move.w (a1,d7.w),BLTCON0(a5)		; BLTCON0 laden Wert: 0FFF
	move.w (a1,d7.w),d2					; zu Testzwecken 
	subq.w #2,d7						; d7=$0064.01FC 
	bne _mintermsNoUnderflow			;  
	move.w #(256-1)<<1,d7				; 255*2=510
_mintermsNoUnderflow:					; 
	swap d7								; $01FC.0064 
_mintermsNoChange:

	bra _loop

	rts

bltcon_0:
	dc.w $0F00, $0F01, $0F02, $0F03, $0F04, $0F05, $0F06, $0F07
	dc.w $0F08, $0F09, $0F0A, $0F0B, $0F0C, $0F0D, $0F0E, $0F0F
	dc.w $0F10, $0F11, $0F12, $0F13, $0F14, $0F15, $0F16, $0F17
	dc.w $0F18, $0F19, $0F1A, $0F1B, $0F1C, $0F1D, $0F1E, $0F1F
	dc.w $0F20, $0F21, $0F22, $0F23, $0F24, $0F25, $0F26, $0F27
	dc.w $0F28, $0F29, $0F2A, $0F2B, $0F2C, $0F2D, $0F2E, $0F2F
	dc.w $0F30, $0F31, $0F32, $0F33, $0F34, $0F35, $0F36, $0F37
	dc.w $0F38, $0F39, $0F3A, $0F3B, $0F3C, $0F3D, $0F3E, $0F3F
	dc.w $0F40, $0F41, $0F42, $0F43, $0F44, $0F45, $0F46, $0F47
	dc.w $0F48, $0F49, $0F4A, $0F4B, $0F4C, $0F4D, $0F4E, $0F4F ; 10
	dc.w $0F50, $0F51, $0F52, $0F53, $0F54, $0F55, $0F56, $0F57
	dc.w $0F58, $0F59, $0F5A, $0F5B, $0F5C, $0F5D, $0F5E, $0F5F
	dc.w $0F60, $0F61, $0F62, $0F63, $0F64, $0F65, $0F66, $0F67
	dc.w $0F68, $0F69, $0F6A, $0F6B, $0F6C, $0F6D, $0F6E, $0F6F
	dc.w $0F70, $0F71, $0F72, $0F73, $0F74, $0F75, $0F76, $0F77
	dc.w $0F78, $0F79, $0F7A, $0F7B, $0F7C, $0F7D, $0F7E, $0F7F
	dc.w $0F80, $0F81, $0F82, $0F83, $0F84, $0F85, $0F86, $0F87
	dc.w $0F88, $0F89, $0F8A, $0F8B, $0F8C, $0F8D, $0F8E, $0F8F
	dc.w $0F90, $0F91, $0F92, $0F93, $0F94, $0F95, $0F96, $0F97
	dc.w $0F98, $0F99, $0F9A, $0F9B, $0F9C, $0F9D, $0F9E, $0F9F ; 20
	dc.w $0FA0, $0FA1, $0FA2, $0FA3, $0FA4, $0FA5, $0FA6, $0FA7
	dc.w $0FA8, $0FA9, $0FAA, $0FAB, $0FAC, $0FAD, $0FAE, $0FAF
	dc.w $0FB0, $0FB1, $0FB2, $0FB3, $0FB4, $0FB5, $0FB6, $0FB7
	dc.w $0FB8, $0FB9, $0FBA, $0FBB, $0FBC, $0FBD, $0FBE, $0FBF
	dc.w $0FC0, $0FC1, $0FC2, $0FC3, $0FC4, $0FC5, $0FC6, $0FC7
	dc.w $0FC8, $0FC9, $0FCA, $0FCB, $0FCC, $0FCD, $0FCE, $0FCF
	dc.w $0FD0, $0FD1, $0FD2, $0FD3, $0FD4, $0FD5, $0FD6, $0FD7
	dc.w $0FD8, $0FD9, $0FDA, $0FDB, $0FDC, $0FDD, $0FDE, $0FDF
	dc.w $0FE0, $0FE1, $0FE2, $0FE3, $0FE4, $0FE5, $0FE6, $0FE7
	dc.w $0FE8, $0FE9, $0FEA, $0FEB, $0FEC, $0FED, $0FEE, $0FEF ; 30
	dc.w $0FF0, $0FF1, $0FF2, $0FF3, $0FF4, $0FF5, $0FF6, $0FF7 
	dc.w $0FF8, $0FF9, $0FFA, $0FFB, $0FFC, $0FFD, $0FFE, $0FFF	; 32x8=256

ende:

	end


