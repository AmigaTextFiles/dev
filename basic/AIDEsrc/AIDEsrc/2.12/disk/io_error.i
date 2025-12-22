*   AIDE 2.12, an environment for ACE
*   Copyright (C) 1995/97 by Herbert Breuer
*		  1997/99 by Daniel Seifert
*
*                 contact me at: dseifert@berlin.sireco.net
*
*                                Daniel Seifert
*                                Elsenborner Weg 25
*                                12621 Berlin
*                                GERMANY
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation; either version 2 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program; if not, write to the
*          Free Software Foundation, Inc., 59 Temple Place, 
*          Suite 330, Boston, MA  02111-1307  USA

*--------------------------------------
* io_error
*
* Gibt die entsprechende DOS-Fehlermeldung aus.
*
* kein Übergaberegister
*
* => d0.l =   1  = Requester mit "Retry"  beantwortet
* => d0.l =  -1  = Requester mit "Cancel" beantwortet, oder Fehler
*
* => d0.l =   0  = kein Fehler oder 232 wenn DirEnde erreicht
*--------------------------------------
io_error

	movem.l d1-d7/a0-a2/a6,-(a7)

	CALLDOS IoErr   		;hole die FehlerNr
	tst.l   d0      		; = 0 ?
	beq     .ende   		;dann kein Fehler

	cmp.l   #232,d0 		;ErrorNoMoreEntries ?
	beq     .ende   		;ja

	tst.w   pruef_Flag      	;Fehlermeldung ausgeben?
	beq.s   .fehler_meldung 	;ja

	moveq   #-1,d0  		;nein, melde Fehler aufgetreten
	bra     .ende   		,und beenden

.fehler_meldung
	lea     io_error_nr,a0  	;zeige auf Tabelle
	move.l  #err_count,d1   	;Anzahl auf die zu reagierenden
					;Fehler => d1
.search
	cmp.b   (a0)+,d0		;FehlerNr gefunden?
	dbeq    d1,.search      	;wenn nicht

	tst     d1      		;welches Ergebnis ?
	bpl.s   .text_adresse   	;ja, gefunden !

					;nein, FehlerNr. ausgeben,
					;in d0 steht die Hex-Zahl

	lea     err_text,a0     	;zeige auf Textstring
	moveq.l #14,d1  		;Offset, ab dem die ASCII-Zahl
					;eingetragen werden soll
	moveq.l #2,d2   		;Flag = führende Nullen unterdücken
	bsr     hex_to_dez_ascii	;eigene Library-Routine aufrufen
	move.l  a0,d3   		;Textadresse übergeben
	bra.s   .nur_cancel     	;und ausgeben

.text_adresse
	neg.l   d1      		;da sub d1,#err_count nicht möglich
	add.l   #err_count,d1   	;berechne PlatzNr von FehlerNr
	lsl.l   #2,d1   		;* 4
	lea     io_error_table,a0       ;zeige auf Tabelle
	move.l  0(a0,d1),d3     	;TextAdresse nach d3

.ausgeben
	lea     nr_tab2,a2      	;zeige auf Tabelle
	move.l  #err_count2,d1  	;Anzahl nach d1

.search2
	cmp.b   (a2)+,d0		;FehlerNr gefunden?
	dbeq    d1,.search2     	;nein, weiter prüfen
	tst     d1      		;welches Ergebnis ?
	bmi.s   .nur_cancel     	;nein, nicht gefunden

	move.l  #err_retry,d1   	;zeige auf Retry-GadgetText
	move.l  #err_cancel,d2  	;zeige auf Cancel-GadgetText
	move.l  #err_2text,d4   	;zeige auf Text
	bra.s   .aufrufen       	;Requester ausgeben

.nur_cancel
	moveq.l #0,d1   		;kein 2. Gadget
	move.l  #err_cancel,d2  	;zeige auf Cancel-GadgetText
	move.l  #err_3text,d4   	;zeige auf Error_Text

.aufrufen
	move.l  #IDCMP_GADGETUP,d0      ;IDCMPFlag => d0
	move.l  _MainWinPtr,a0  	;zeige auf Window
	move.l  _FontAttrPtr,a1 	;zeige auf TextAttributStruktur
	moveq.l #0,d5
	moveq.l #0,d6
	move.l  #io_error_titel,d7      ;zeige auf Window-Titel
	bsr     build_requester 	;Requester ausgeben
	tst.l   d0      		;welches Ergebnis
	bne.s   .ende   		;Retry gewählt oder Fehler => beenden

	moveq.l #-1,d0  		;Meldung: abbrechen zurückgeben
.ende
	movem.l (a7)+,d1-d7/a0-a2/a6
	rts
*--------------------------------------
io_error_table
	dc.l    errCA,errCC,errCD,errD2,errD5,errD6,errDA,errDD,errDE
	dc.l    errDF,errE0,errE1,errE2
*--------------------------------------
io_error_nr
	dc.b    $ca,$cc,$cd,$d2,$d5,$d6,$da,$dd,$de,$df,$e0,$e1,$e2
err_count       equ     *-io_error_nr
	even
*--------------------------------------
nr_tab2
	dc.b    $d5,$d6,$e1,$e2
err_count2      equ     *-nr_tab2
	even
*--------------------------------------
errCA   dc.b    "Object in use.",0
	even
errCC   dc.b    "Directory not found.",0
	even
errCD   dc.b    "Directory name is wrong.",0
	even
errD2   dc.b    "File name is invalid.",0
	even
errD5   dc.b    "Disk is not validated.",0
	even
errD6   dc.b    "Disk is write protected.",0
	even
errDA   dc.b    "Device not mounted.",0
	even
errDD   dc.b    "Disk is full.",0
	even
errDE   dc.b    "File is protected from deletion.",0
	even
errDF   dc.b    "File is write protected.",0
	even
errE0   dc.b    "File is read protected.",0
	even
errE1   dc.b    "No AmigaDOS disk.",0
	even
errE2   dc.b    "No disk in drive.",0
	even
err_text
	dc.b    "DOS error no.     ",0
	even
err_retry
	dc.b    " Retry ",0
	even
err_cancel
	dc.b    " Cancel ",0
	even
err_2text
	dc.b    "Try again?",0
	even
err_3text
	dc.b    "Oh no!",0
	even
io_error_titel
	dc.b    " AIDE IO Error Request",0
	even
*--------------------------------------
