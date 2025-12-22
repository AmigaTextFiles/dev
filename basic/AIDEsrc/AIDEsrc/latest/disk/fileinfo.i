*   AIDE 2.13, an environment for ACE
*   Copyright (C) 1995/97 by Herbert Breuer
*		  1997/99 by Daniel Seifert
*
*                 contact me at: dseifert@gmx.net
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
* fileinfo_besorgen
*
* >= d1.l = Zeiger auf den Dateinamen
*
* => d0.l = positiv = alles ok, negativ dann Fehler
* => d3.l = Filegröße
*--------------------------------------
fileinfo_besorgen

	movem.l d1-d2/d4-d6/a0,-(a7)

	move.l  d1,d6   		;Zeiger in d6 merken

	bsr     alloc_fiblock   	;Speicher für FIBlock besorgen
	move.l  d2,d5   		;merken, geklappt?
	beq     .fehler 		;nein

.wiederholen
	move.l  d6,d1   		;Zeiger auf Dateinamen => d1
	moveq.l #-2,d2  		;Modus = "lesen"
	bsr     lock    		;Lock ermitteln
	move.l  d0,d4   		;Lock merken

	tst.w   pruef_Flag      	;soll nur der Dateiname überprueft werden?
	beq.s   .sichern		;nein, weitermachen

	move.l  d4,d1   		;ja, Lock übergeben
	beq     .fehler 		;keinen Lock, dann melde "Fehler"

	bsr     unlock  		;Lock wieder freigeben
	bra     .ende   		;und beenden

.sichern
	tst.l   d4      		;alles ok ?
	bne.s   .skip   		;<> 0 = Lock ermittelt, alles ok

	tst.b   sichern_Flag    	;soll die Datei gesichert werden?
	bne.s   .ende   		;ja, dann alles ok, Datei existiert noch nicht!

	bsr     io_error		;nein, Fehlermeldung ausgeben
	tst.l   d0      		;welche Antwort?
	bmi.s   .fehler 		;mit 'Cancel' beantwortet
	bpl.s   .wiederholen    	;mit 'Retry' beantwortet

.skip
	tst.b   sichern_Flag    	;soll die Datei gesichert werden?
	beq.s   .examine		;nein, dann Meldung überspringen

	move.l  d4,d1   		;Lock übergeben
	bsr     unlock  		;freigeben

	bsr     datei_existiert 	;Meldung ausgeben
	tst.l   d0      		;welche Antwort?
	bmi.s   .ende   		;Requester wurde nicht ausgegeben!
	bne.s   .ende   		;"Überschreiben" gewählt, normal weitermachen

	bsr     neuer_name      	;"nein" gewählt, frage ob ein neuer Name vergeben werden soll
	tst.l   d0      		;welche Antwort?
	bmi.s   .ende   		;"Cancel" gewählt
	bpl.s   .wiederholen    	;"neuen Namen" gewählt, noch einmal versuchen

.examine
	move.l  d4,d1   		;Lock übergeben
	move.l  d5,d2   		;Zeiger auf FIBlock übergeben
	bsr     examine 		;Daten zum File besorgen
	tst.l   d0      		;alles ok?
	bne.s   .unlock 		;ja

	bsr     io_error		;nein, Fehlermeldung ausgeben

	move.l  d4,d1   		;Lock übergeben
	bsr     unlock  		;freigeben

	tst.l   d0      		;welche Antwort?
	bmi.s   .fehler 		;mit 'Cancel' beantwortet
	bpl     .wiederholen    	;mit 'Retry' beantwortet

.unlock
	move.l  d4,d1   		;Lock übergeben
	bsr     unlock  		;freigeben

	moveq.l #0,d0   		;-1 in d0 von Examine() löschen
	move.l  d2,a0   		;zeige auf FIBlock
	move.l  $7C(a0),d3      	;Filelänge => d3
	bne.s   .ende   		; > 0, dann lesbare Datei

	bsr     dateilaenge_null	;Meldung ausgeben
.fehler
	moveq.l #-1,d0  		;melde "Fehler"
.ende
	move.l  d5,d2   		;FIBlock angelegt?
	beq.s   .exit   		;nein

	bsr     free_fiblock    	;FIBlock wieder freigeben
.exit
	movem.l (a7)+,d1-d2/d4-d6/a0
	rts
*--------------------------------------
