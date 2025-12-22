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
* Funktionen der asl.library
*--------------------------------------
* alloc_asl_request
*
* >= d0.l = ASL_FileRequest = 0, ASL_FontRequest = 1, ASL_ScreenModeRequest = 2
* >= a0.l = Zeiger auf TagItemListe
*
* => d0.l = Zeiger auf RequestStruktur, = 0 dann Fehler
*--------------------------------------

alloc_asl_request

	movem.l d1/a0-a1/a6,-(a7)

	CALLASL AllocAslRequest

	movem.l (a7)+,d1/a0-a1/a6
	rts

*--------------------------------------
* asl_request
*
* >= a0.l = Zeiger auf RequestStruktur
* >= a1.l = Zeiger auf TagItemListe
*
* => d0.l = 0 = "Cancel"; <> = "OK" gewählt
*--------------------------------------

asl_request

	movem.l d1/a0-a1/a6,-(a7)

	CALLASL AslRequest

	movem.l (a7)+,d1/a0-a1/a6
	rts

*--------------------------------------
* free_asl_request
*
* >= a0.l = Zeiger auf RequestStruktur
*
* kein Rückgaberegister
*--------------------------------------

free_asl_request

	movem.l d0-d1/a0-a1/a6,-(a7)

	CALLASL FreeAslRequest

	movem.l (a7)+,d0-d1/a0-a1/a6
	rts
*--------------------------------------
