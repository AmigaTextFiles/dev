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
* MenueStruktur Hauptmenue
*--------------------------------------

* 1. Menue "Projekt"

NewMenue NEWMENU        NM_TITLE,m1t,0,0,0

        NEWMENU         NM_ITEM,m1p1t,m1p1c,0,0
        NEWMENU         NM_ITEM,m1p2t,m1p2c,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,m1p3t,m1p3c,0,0
        NEWMENU         NM_ITEM,m1p4t,m1p4c,0,0
        NEWMENU         NM_ITEM,m1p5t,m1p5c,0,0
        NEWMENU         NM_ITEM,m1p6t,m1p6c,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,m1p7t,m1p7c,0,0
        NEWMENU         NM_ITEM,m1p8t,0,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,m1p9t,m1p9c,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,m1p10t,0,0,0
        NEWMENU         NM_SUB,default_text,0,0,0
        NEWMENU         NM_SUB,other_text,0,0,0

        NEWMENU         NM_ITEM,m1p11t,0,0,0
        NEWMENU         NM_SUB,default_text,0,0,0
        NEWMENU         NM_SUB,other_text,0,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,m1p12t,0,0,0
        NEWMENU         NM_ITEM,m1p13t,m1p13c,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,m1p14t,m1p14c,0,0

*---------------------------------------------------

* 2. Menue "Utilities"

        NEWMENU         NM_TITLE,m2t,0,0,0

        NEWMENU         NM_ITEM,m2p1t,0,0,0
        NEWMENU         NM_ITEM,m2p2t,0,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,m2p3t,0,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,m2p4t,0,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,m2p5t,0,0,0

        NEWMENU         NM_ITEM,NM_BARLABEL,0,0,0

        NEWMENU         NM_ITEM,m2p6t,0,0,0
        NEWMENU         NM_ITEM,m2p7t,0,0,0
        NEWMENU         NM_ITEM,m2p8t,0,0,0
        NEWMENU         NM_ITEM,m2p9t,0,0,0
*---------------------------------------------------

* 3. Menue "Help"

        NEWMENU         NM_TITLE,m3t,0,0,0

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

m1t     dc.b "Projekt",0
        even

m1p1t   dc.b "Open ...",0
        even
m1p1c   dc.b "O",0
        even

m1p2t   dc.b "View ...",0
        even
m1p2c   dc.b "V",0
        even

m1p3t   dc.b "Rename ...",0
        even
m1p3c   dc.b "R",0
        even

m1p4t   dc.b "Copy ...",0
        even
m1p4c   dc.b "C",0
        even

m1p5t   dc.b "Delete ...",0
        even
m1p5c   dc.b "D",0
        even

m1p6t   dc.b "Print ...",0
        even
m1p6c   dc.b "P",0
        even

m1p7t   dc.b "Execute ...",0
        even
m1p7c   dc.b "X",0
        even

m1p8t   dc.b "Spawn Shell",0
        even

m1p9t   dc.b "AIDE setup ...",0
        even
m1p9c   dc.b "S",0
        even

m1p10t  dc.b "Load Config File",0
        even
default_text
        dc.b "default",0
        even
other_text
        dc.b "other ...",0
        even

m1p11t  dc.b "Save Config File",0
        even

m1p12t  dc.b "About ...",0
        even

m1p13t  dc.b "Iconify",0
        even
m1p13c  dc.b "I",0
        even

m1p14t  dc.b "Quit AIDE",0
        even
m1p14c  dc.b "Q",0
        even


*---------------------------------------------------

m2t     dc.b "Utilities",0
        even
m2p1t   dc.b "Calculator",0
        even
m2p2t   dc.b "ReqEd",0
        even
m2p3t   dc.b "Create BMAP file(s)",0
        even
m2p4t   dc.b "AmigaBASIC -> ASCII",0
        even
m2p5t   dc.b "UppercACEr",0
        even
m2p6t   dc.b "Utility 0",0
        even
m2p7t   dc.b "Utility 1",0
        even
m2p8t   dc.b "Utility 2",0
        even
m2p9t   dc.b "Utility 3",0
        even
*---------------------------------------------------

m3t     dc.b "Help",0
        even
m3p1t   dc.b "AIDE",0
        even
m3p2t   dc.b "ACE",0
        even
m3p3t   dc.b "SuperOptimizer",0
        even
m3p4t   dc.b "A68K",0
        even
m3p5t   dc.b "PhxAss",0
        even
m3p6t   dc.b "BLink",0
        even
m3p7t   dc.b "PhxLnk",0
        even
m3p8t   dc.b "ACE Reference",0
        even
m3p9t   dc.b "ACE Reserved Words",0
        even
m3p10t  dc.b "ACE Examples",0
        even
m3p11t  dc.b "ACE History",0
        even
m3p12t  dc.b "ACEcalc",0
        even
m3p13t  dc.b "ReqEd",0
        even
*---------------------------------------------------
