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
* datei_laden
*
* >= d1.l = Zeiger auf Dateinamen
* >= d2.l = Zeiger auf Speicher
* >= d3.l = Speichergröße in Bytes
*
* d1/d2/d3 dürfen Null sein, es wird dann der ASLFileRequester
* ausgegeben und ebenfalls neuer Speicher für das zu ladende File besorgt.
*
* => d0.l = positiv = alles ok, negativ = Fehler
*
* Achtung:
*--------
* => d0.l = 1 wenn Fehler bei der Prüfung auf ConfigFile aufgetreten
*
* Falls vor dem Laden d2 und d3 = NULL
* waren steht dann in:
*
* => d2.l = Zeiger auf Speicher
* => d3.l = Speichergröße in Bytes
*
* Der Speicherbereich muss mit FreeVec() freigegeben werden!!!!
*--------------------------------------
datei_laden

	movem.l d1/d4,-(a7)

	tst.l   d1      		;Zeiger angegeben?
	bne.s   .fileinfo       	;ja, ASLFilerequester nicht ausgeben

	bsr     asl_req_laden   	;File-Requester ausgeben
	tst.l   d0      		;welches Ergebnis?
	beq     .fehler 		;"Cancel" gewählt

	clr.w	pruef_Flag		;Flag löschen
	bsr     dateiname_besorgen      ;Dateiname besorgen und prüfen
	tst.l   d0      		;in Ordnung?
	bmi     .ende   		;nein, Fehler

.fileinfo
	bsr     fileinfo_besorgen       ;prüfe ob alles zum Lesen bereit
	tst.l   d0      		;alles ok ?
	bmi     .ende   		;nein, "Fehler"

	tst.b   ConfigFileFlag  	;ConfigFile?
	beq.s   .read   		;nein, keine Prüfung durchführen

	bsr     pruefe_datei    	;prüfe ob wirklich ConfigFile
	tst.l   d0      		;alles ok?
	bmi.s   .ende   		;nein
.read
					;Zeiger auf Dateinamen steht in d1
					;Zeiger auf Speicher steht in d2
					;Dateigröße steht d3
	bsr     read_datei      	;lesen
	bra.s   .ende   		;und beenden
.fehler
	moveq.l #-1,d0  		;melde "Fehler"
.ende
	movem.l (a7)+,d1/d4
	rts
*--------------------------------------
