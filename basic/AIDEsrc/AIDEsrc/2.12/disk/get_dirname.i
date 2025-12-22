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
* get_dirname
*
* >= d1.l = BCPLPtr auf LockStruktur
*
* => d0.l = Zeiger auf Dirname, negativ dann Fehler
*--------------------------------------
get_dirname

	movem.l d1-d5/a0,-(a7)

	bsr     alloc_fiblock   	;Speicher für FIBlock besorgen
	move.l  d2,d5   		;merken, geklappt?
	beq.s   .fehler 		;nein

	bsr     examine 		;Daten besorgen
	tst.l   d0      		;alles ok?
	beq.s   .fehler 		;nein

	moveq.l #0,d0   		;-1 in d0 von Examine() löschen
	move.l  d2,a0   		;zeige auf FIBlock

.fehler
	moveq.l #-1,d0  		;melde "Fehler"
.ende
	move.l  d5,d2   		;FIBlock angelegt?
	beq.s   .exit   		;nein

	bsr     free_fiblock    	;FIBlock wieder freigeben

	movem.l (a7)+,d1-d5/a0
	rts
*--------------------------------------
