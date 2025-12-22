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
* MenueStruktur Hauptmenue
*--------------------------------------

* 1. Menue "Projekt"

NewMenue NEWMENU        NM_TITLE,IDm1t,0,0,0

        NEWMENU         NM_ITEM,IDm1p1t,m1p1c,0,0
        NEWMENU         NM_ITEM,IDm1p2t,m1p2c,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,IDm1p3t,m1p3c,0,0
        NEWMENU         NM_ITEM,IDm1p4t,m1p4c,0,0
        NEWMENU         NM_ITEM,IDm1p5t,m1p5c,0,0
        NEWMENU         NM_ITEM,IDm1p6t,m1p6c,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,IDm1p7t,m1p7c,0,0
        NEWMENU         NM_ITEM,IDm1p8t,0,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,IDm1p9t,m1p9c,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,IDm1p10t,0,0,0
        NEWMENU         NM_SUB,IDdefault_text,0,0,0
        NEWMENU         NM_SUB,IDother_text,0,0,0

        NEWMENU         NM_ITEM,IDm1p11t,0,0,0
        NEWMENU         NM_SUB,IDdefault_text,0,0,0
        NEWMENU         NM_SUB,IDother_text,0,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,IDm1p12t,0,0,0
        NEWMENU         NM_ITEM,IDm1p13t,m1p13c,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,IDm1p14t,m1p14c,0,0

*---------------------------------------------------

* 2. Menue "Utilities"

        NEWMENU         NM_TITLE,IDm2t,0,0,0

        NEWMENU         NM_ITEM,IDm2p1t,0,0,0
        NEWMENU         NM_ITEM,IDm2p2t,0,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,IDm2p3t,0,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,IDm2p4t,0,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,IDm2p5t,0,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,IDm2p6t,0,0,0
        NEWMENU         NM_ITEM,IDm2p7t,0,0,0
        NEWMENU         NM_ITEM,IDm2p8t,0,0,0
        NEWMENU         NM_ITEM,IDm2p9t,0,0,0
*---------------------------------------------------

* 3. Menue "Help"

        NEWMENU         NM_TITLE,IDm3t,0,0,0

        NEWMENU         NM_ITEM,m3p1t,0,0,0
        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,m3p2t,0,0,0
        NEWMENU         NM_ITEM,m3p3t,0,0,0
        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,m3p4t,0,0,0
        NEWMENU         NM_ITEM,m3p5t,0,0,0
        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,m3p6t,0,0,0
        NEWMENU         NM_ITEM,m3p7t,0,0,0
        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,m3p8t,0,0,0
        NEWMENU         NM_ITEM,m3p9t,0,0,0
        NEWMENU         NM_ITEM,m3p10t,0,0,0
        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,m3p11t,0,0,0
        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,m3p12t,0,0,0
        NEWMENU         NM_ITEM,m3p13t,0,0,0

*---------------------------------------------------
        NEWMENU         NM_END,0,0,0,0
*---------------------------------------------------

m1p1c   dc.b "O",0
        even

m1p2c   dc.b "V",0
        even

m1p3c   dc.b "R",0
        even

m1p4c   dc.b "C",0
        even

m1p5c   dc.b "D",0
        even

m1p6c   dc.b "P",0
        even

m1p7c   dc.b "X",0
        even

m1p9c   dc.b "S",0
        even

m1p13c  dc.b "I",0
        even

m1p14c  dc.b "Q",0
        even

