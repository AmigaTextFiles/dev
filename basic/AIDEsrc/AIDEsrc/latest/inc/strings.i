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

* embed_quotes
*
* Diese Routine setzt einen in a0 übergebenen String in Anführungs-
* striche.
*


embed_quotes

       move.l  a0,a1

.loop

       tst.b   (a1)+
       bne.s   .loop

       move.l  a1,a2

.shift

       cmpa.l  a0,a1
       beq.s   .quote

       move.b  -1(a1),(a1)
       suba.l  #1,a1
       bra.s   .shift

.quote

       move.b  #34,(a0)
       move.b  #34,(a2)+
       move.b  #00,(a2)

       rts

***
eos

*
* -> in a1 Zeiger auf String
* <- in a1 Zeiger auf Nullbyte des Strings

.next
       cmp.b   #0,(a1)+
       bne.s   .next

       sub.l   #1,a1
       rts
