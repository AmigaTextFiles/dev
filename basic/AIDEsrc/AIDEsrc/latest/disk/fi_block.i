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
* file_info_block
*
* >= d1.l = Zeiger auf den Dateinamen
*
* => d0.l = positiv = alles ok, negativ dann Fehler
* => d1.l = Zeiger auf FIBlock, = 0 dann Fehler
*
* Anmerkung:
*
* Muß mit "free_fiblock" wieder freigegeben werden.
* "free_fiblock" verlangt den Zeiger in d2!!!
* Wird bei Fehler von der Funktion freigegeben!!
*--------------------------------------

file_info_block

	movem.l d2-d4,-(a7)

	bsr     alloc_fiblock   	;Speicher für FIBlock besorgen
	move.l  d2,d3   		;merken, geklappt?
	beq.s   .fehler 		;nein

	moveq.l #-2,d2  		;Modus = "lesen"
	bsr     lock    		;Lock ermitteln
	move.l  d0,d4   		;Lock merken
	beq     .free_fiblock   	;keinen Lock, dann melde "Fehler"

	move.l  d4,d1   		;Lock übergeben
	move.l  d3,d2   		;Zeiger auf FIBlock übergeben
	bsr     examine 		;Daten zum File besorgen
	tst.l   d0      		;alles ok?
	beq.s   .unlock 		;nein

	move.l  d4,d1   		;Lock übergeben
	bsr     unlock  		;freigeben

	moveq.l #0,d0   		;melde "alles okay"
	move.l  d3,d1   		;Zeiger auf FIBlock in d1 zurückgeben
	bra.s   .ende   		;und beenden
.unlock
	move.l  d4,d1   		;Lock => d1
	beq.s   .free_fiblock   	;es gibt keinen

	bsr     unlock  		;Lock wieder freigeben

.free_fiblock
	move.l  d3,d2   		;zeige auf FIBlock
	bsr     free_fiblock    	;freigeben
.fehler
	moveq.l #-1,d0  		;melde "Fehler"
	moveq.l #0,d1
.ende
	movem.l (a7)+,d2-d4
	rts
*--------------------------------------
* get_datestamp_differences
*
* >= a0.l = Zeiger auf 1. FIBlock
* >= a1.l = Zeiger auf 2. FIBlock
*
* => d0.l = 0 = DateStamps gleich, <> 0 = DateStamps unterschiedlich
*--------------------------------------

get_datestamp_differences

	movem.l d1/a0-a1,-(a7)

	lea     fib_DateStamp(a0),a0    ;zeige auf 1. Datestampstruktur
	lea     fib_DateStamp(a1),a1    ;zeige auf 2. Datestampstruktur
	moveq.l #ds_SIZEOF,d0   	;Größe der Struktur => d0
	moveq.l #1,d1   		;muss genau stimmen
	bsr     string_n_compare	;vergleiche

	movem.l (a7)+,d1/a0-a1
	rts
*--------------------------------------
