
; soc30b.s = copperScreen.s
; Copperlist-Anaylse

											Adressen: Copperpointer/Copperlist-Label/Copperjump	
;Start-------------------------------------------------------------------------
CL:																		; 1fd38
Wait 0			; restart		
	Display
	COP1PT	Cla													; 1fd84
Wait $6401 fffe	; Wait for vpos >= 0x64 and hpos >= 0x00
	COP2PT	Clb													; 1fe3c
;Abschnitt 1a-------------------------------------------------------------------
Cla:																	; 1fd84			
Skip $8001 8001	; Skip if vpos & 0x00 >= 0x80, , ignore horizontal
	COPJMP2																		; 1fe3c
;Abschnitt 2a-------------------------------------------------------------------
Wait $803f 80fe	; Wait for vpos & 0x00 >= 0x80 and hpos >= 0x3e
	COLOR 40
	COP2PT														; 1fee0
	COPJMP2
;Abschnitt 1b-------------------------------------------------------------------
Clb:																	; 1fe3c
Wait $003f 80fe	; Wait for  hpos >= 0x3e							
	COLOR 40
;Abschnitt 2b-------------------------------------------------------------------
Clc:																	; 1fee0																
Skip $ff01 ff01	; Skip if vpos >= 0xff, , ignore horizontal			 	
	COPJMP1																		; 1fd84
;Abschnitt 3a-------------------------------------------------------------------
CLd:																	; 1fee8																
Wait $ff3f fffe ;  Wait for vpos >= 0xff and hpos >= 0x3e
	COLOR 40
	COP1PT Cle													; 1ff94
;Abschnitt 3b-------------------------------------------------------------------
Cle:																	; 1ff94
Wait $003f 80fe ;  Wait for  hpos >= 0x3e
	COLOR 40
Skip $1901 ff01 ;  Skip if vpos >= 0x19, , ignore horizontal
	COPJMP1																		; 1ff94
	COP1PT CL1													; 1fd38
Wait $ffff fffe	; Ende
;------------------------------------------------------------------------------

Beschreibung:

Den Programmcode versteht wahrscheinlich niemand? Aus diesem Grund habe ich die
Copperliste analysiert.

Copperpointer-Sprungadressen habe ich mit Label: CL, Cla, Clb, ..., Cle 
bezeichet.

Die Copperliste startet bei 0 mit der Einrichtung des Displays.
Der Copperpointer1 wird auf CLa gesetzt:
Nachdem Wait auf Zeile $64 wird der Copperpointer2 auf Clb gesetzt.

Abschnitt 1a:
Der Copper trifft zuerst auf den Skip und weil der Rasterstrahl zunächst <$80
ist wird der nächste Befehl nicht übersprungen. D.h. Der Copper führt den 
COPJMP2 aus und springt zunächst zu Clb.
Abschnitt 1b:
Hier trifft er auf ein maskiertes Wait für alle Zeilen zwischen $00 und $79.
Er setzt 40 Farben und trifft auf das skip $ff01.
Da die Bedingung zunächst nicht erfüllt ist, führt der Copper den COPJMP1 aus
und springt zurück nach Cla. Dies erfolgt solange bis Zeile $80 erreicht wird.
Dann wird der skip $8001 "gültig" und er überspringt den COPJMP2.

Abschnitt 2a:
Der Copper trifft nun auf das Wait $803f 80fe und setzt 40 Farben ab der
horizontalen Position $3f. Nun trifft er auf ein Skip ff01. 
Da die Zeile $ff (255) noch nicht erreicht ist, führt er den COPJMP1 aus
und springt zurück nach Abschnitt 1a: 
(Es könnte optimiert werden zu Abschnitt 2a)
Er wiederholt jetzt den Abschnitt2 solange bis Zeile 255 $ff erreicht ist.
und setzt in allen Zeilen die 40 Farben.

Abschnitt 3:
Irgendwann ist der Rasterstrahl hinter $ff und der COPJMP1 wird übersprungen.
Der Copper trifft auf das Wait $ff3f fffe und setzt 40 Farben. Der COP1PT wird
neu geladen mit der Adresse von Label Cle.
Er trifft nun auf ein maskiertes Wait $003f 80fe welches in jeder Zeile von
Zeile 256 bis 313 (bis zum Ende) gültig ist und setzt 40 Farben.
Der Copper triftt nun auf ein skip $1901 ff01 und führt den Befehl COPJMP1 
solange der Rasterstrahl noch nicht die Zeile 255+$19 erreicht hat aus.
Er springt solange zurück zu Cle.
Wenn Zeile $1901 erreicht ist wird der COPJMP1 übersprungen und der 
Copperpointer wird mit der Anfangsadresse der Copperliste CL geladen.
Das Ende wird erreicht und mit Beginn des neuen frames wird die Copperliste
wieder bei Cl neu gestartet.
