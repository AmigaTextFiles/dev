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
* new_buffer
*
* Diese Funktion besorgt neuen Speicherplatz, wenn beim Laden
* festgestellt wird, daß die Daten nicht in den vorher reservierten
* Speicher passen. Gibt ebenfalls den alten Speicher frei.
*
* >= d2.l = Zeiger auf alten Speicherbereich, oder NULL wenn keiner vorhanden
* >= d3.l = aktuelle Filegröße = Größe des zu reservierenden Speichers
*
* => d2.l = Zeiger auf neuen Speicherbereich
* Ebenfalls kann auf den Zeiger über "_NewBufferPtr" zugegriffen werden!
*
* Anmerkung:
* Reservierter Speicher muß mit der Funktion FreeVec()
* wieder freigegeben werden!
*--------------------------------------
new_buffer

	movem.l d0/a1,-(a7)

	move.l  d2,a1   		;Zeiger auf alten Speicher => a1
	bsr     free_vec		;freigeben

	move.l  d3,d0   		;Größe => d0
	move.l  #MEMF_ANY!MEMF_CLEAR!MEMF_LARGEST,d1
					;Anforderungen => d1
	bsr     alloc_vec       	;reservieren
	move.l  d0,d2   		;in d2 zurückgeben

	movem.l (a7)+,d0/a1
	rts
*--------------------------------------

