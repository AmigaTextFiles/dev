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
* pruefe_datei
*
* >= d1.l = Zeiger auf Dateinamen
*
* => d0.l = -1 = kein AIDE_config File
* => d0.l =  0 = alles ok
*--------------------------------------

pruefe_datei

	movem.l d2-d4/a0-a1,-(a7)

	move.l  _BufferPtr,d2   	;als Puffer benutzen
	move.l  #LaengeIDString,d3      ;Anzahl der zu lesenden Bytes => d3
	bsr     read_datei      	;lesen
	tst.l   d0      		;alles ok?
	bmi.s   .ende   		;nein, Fehler

	move.l  d2,a0   		;Zeiger auf Speicher => a0
	lea     IDString,a1     	;Zeiger auf CompareString => a1
	moveq.l #1,d0   		;muss genau stimmen, also Groß/Kleinschreibung beachten

	bsr     string_compare  	;vergleiche
	tst.l   d0      		;welches Ergebnis?
	beq.s   .ende   		;identisch, dann alles ok

	bsr     file_is_not_a_config_file
					;Meldung ausgeben
	moveq.l #-1,d0  		;melde Fehler, Laden abbrechen
	move.b  #0,ConfigFileFlag       ;und Flag löschen
.ende
	movem.l (a7)+,d2-d4/a0-a1
	rts

*--------------------------------------
