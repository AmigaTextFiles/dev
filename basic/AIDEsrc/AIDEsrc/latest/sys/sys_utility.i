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
* Funktionen der utility.library
*-------------------------------------
* allocate_tag_items
*
* => d0.l = Anzahl der anzulegenden Strukturen
*
* >= d0.l = Zeiger auf TagArrayStruktur
*--------------------------------------

allocate_tag_items

	movem.l d1/a0-a1/a6,-(a7)

	CALLUTILITY AllocateTagItems

	movem.l (a7)+,d1/a0-a1/a6
	rts

*--------------------------------------
* free_tag_items
*
* >= a0.l = Zeiger auf TagArray oder -Liste
*
* kein Rückgaberegister
*
* Anmerkung:
* Funktion prüft auf vorhandenen Zeiger
*--------------------------------------

free_tag_items

	cmpa.l  #0,a0
	beq.s   .abbruch

	movem.l d0-d1/a0-a1/a6,-(a7)

	CALLUTILITY FreeTagItems

	movem.l (a7)+,d0-d1/a0-a1/a6

.abbruch
	rts

*--------------------------------------
