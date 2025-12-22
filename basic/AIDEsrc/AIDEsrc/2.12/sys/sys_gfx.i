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
* Funktionen der graphics.library
*--------------------------------------
* load_font
*
* >= a0.l = Zeiger auf TextAttrStruktur
* >= d3.l = Zeiger auf Fontname
*
* => d0.l = <> 0 = alles ok, = 0 = Fehler
*--------------------------------------

load_font

	movem.l d1-d3/a0-a1/a6,-(a7)

	CALLDISKFONT OpenDiskFont       ;öffnen
	tst.l   d0      		;geklappt ?
	bne.s   .ende   		;ja

	move.l  d3,a0   		;zeige auf den Namen des Fonts
	move.l  #text_font_not_loaded1,d3
					;zeige auf Fehlermeldungstext
	bsr.s   .vervollstaendigen      ;restlichen Text eintragen

	bsr     alert_requester 	;Requester ausgeben
.ende
	movem.l (a7)+,d1-d3/a0-a1/a6
	rts

*-----------------
.vervollstaendigen

	movem.l a0-a1,-(a7)

	move.l  d3,a1   			;zum Kopieren => a1
	bsr     string_kopieren 	;und kopieren

	lea     text_font_not_loaded2,a0	;zum Kopieren => a0
	bsr     string_kopieren 	;und kopieren

	movem.l (a7)+,a0-a1
	rts

*--------------------------------------
* set_font
*
* Setzt den angegebenen Font im angegebenen RastPort
*
* >= a0.l = Zeiger auf Font
* >= a1.l = Zeiger auf Rastport
*
* kein Rückgaberegister
*--------------------------------------

set_font

	movem.l d0-d1/a0-a1/a6,-(a7)

	CALLGRAPH SetFont

	movem.l (a7)+,d0-d1/a0-a1/a6
	rts

*--------------------------------------
* close_font
*
* >= a1.l = FontPtr.
*
* kein Rückgaberegister
*
* Anmerkung:
* Funktion prüft auf vorhandenen Zeiger
*--------------------------------------

close_font

	cmp.l   #0,a1
	beq.s   .abbruch

	movem.l d0-d1/a0-a1/a6,-(a7)

	CALLGRAPH CloseFont

	movem.l (a7)+,d0-d1/a0-a1/a6
.abbruch
	rts

*--------------------------------------
* load_rgb4
*
* >= d0.l = Anzahl der Farben
*
* >= a0.l = Zeiger auf ViewPort
* >= a1.l = Zeiger auf ColorMap
*
* kein Rückgaberegister
*--------------------------------------
load_rgb4

	movem.l d0-d1/a0-a1/a6,-(a7)

	CALLGRAPH LoadRGB4

	movem.l (a7)+,d0-d1/a0-a1/a6
	rts
*--------------------------------------
