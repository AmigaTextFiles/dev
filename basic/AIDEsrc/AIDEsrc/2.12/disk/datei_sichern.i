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
* datei_sichern
*
* >= d1.l = Zeiger auf Dateinamen
* >= d2.l = Zeiger auf Speicher
* >= d3.l = Größe in Bytes
*
* => d0.l = positiv = alles ok, negativ = Fehler
*--------------------------------------
datei_sichern

	tst.l   d1      		;Zeiger angegeben?
	bne.s   .fileinfo       	;ja, ASLFilerequester nicht ausgeben

	bsr     asl_req_sichern 	;File-Requester ausgeben
	tst.l   d0      		;welches Ergebnis?
	beq     .fehler 		;"Cancel" gewählt

	bsr     dateiname_besorgen      ;Dateiname besorgen und prüfen
	tst.l   d0      		;in Ordnung?
	bmi     .ende   		;nein, Fehler

.fileinfo
	move.b  #1,sichern_Flag 	;Flag setzen
	bsr     fileinfo_besorgen       ;prüfe, ob alles zum Schreiben bereit
	tst.l   d0      		;alles ok ?
	bmi.s   .ende   		;nein

					;Zeiger auf Dateinamen steht in d1
					;Zeiger auf Puffer steht in d2
					;Größe steht in d3
	bsr     write_datei     	;schreiben
	bra.s   .ende   		;und beenden
.fehler
	moveq.l #-1,d0  		;melde "Fehler"
.ende
	move.b  #0,sichern_Flag 	;Flag loeschen
	rts
*--------------------------------------
