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

*
* GetString
*
* => d0 : Kennummer
* =< a0 : Zeiger auf Text
*

GetString

       movem.l a1-a2/a6/d1,-(a7)

       move.l  _LocaleBase,a6
       move.l  catalog_ptr,a0
       move.l  #0,a1

       move.l  #textptr,a2
       move.l  d0,d1
       beq.s   .nolocale

       cmp.l   #count_txt,d1
       bgt.s   .already

       lsl.l   #2,d1
       move.l  0(a2,d1),a1

       cmp.l   #0,a6
       beq.s   .nolocale

       jsr     _LVOGetCatalogStr(a6)
       move.l  d0,a0
       bra.s   .fertig

.already

       move.l  d0,a0
       bra.s   .fertig

.nolocale

       move.l  a1,a0

.fertig

       movem.l (a7)+,a1-a2/a6/d1
       rts

***********
OpenCatalog

       movem.l d0/a0-a2/a6,-(a7)

       move.l  _LocaleBase,a6
       cmp.l   #0,a6
       beq.s   .fehler

       move.l  #0,a0
       move.l  #catalogname,a1
       move.l  #localetags,a2
       jsr     _LVOOpenCatalogA(a6)

       move.l  d0,catalog_ptr
       bra.s   .fertig

.fehler

       move.l  #0,catalog_ptr

.fertig

       movem.l (a7)+,d0/a0-a2/a6
       rts

************
CloseCatalog

       movem.l a0/a6,-(a7)

       move.l  _LocaleBase,a6
       cmp.l   #0,a0
       beq.s   .fertig

       move.l  catalog_ptr,a0
       jsr     _LVOCloseCatalog(a6)

.fertig
       movem.l  (a7)+,a0/a6
       rts

*************
localize_menu

       movem.l  a0-a1/d0,-(a7)

.next

       cmp.b    #$FF,2(a1)
       beq.s    .skip
       move.l   2(a1),d0
       bsr      GetString
       move.l   a0,2(a1)

.skip
       adda.l   #20,a1
       cmp.b    #0,(a1)
       bne.s    .next

       movem.l  (a7)+,a0-a1/d0
       rts

***************
translate_array

       movem.l  a0-a1/d0,-(a7)

.next
       cmp.l    #0,(a1)
       beq.s    .ende

       move.l   (a1),d0
       bsr      GetString
       move.l   a0,(a1)+
       bra.s    .next

.ende

       movem.l  (a7)+,a0-a1/d0
       rts

*****************
translate_minimum

       movem.l  d0-d1/a0-a5,-(a7)

       lea      appendTxt,a2
       lea      append2Txt,a3
       lea      appendOffset,a4

.next
       move.l   (a2)+,d0
       bsr      GetString
       move.l   (a3)+,a1

       move.l   a1,d1
       neg.l    d1

       bsr      string_kopieren

       add.l    a1,d1
       move.l   (a4)+,a5
       move.l   d1,(a5)

       cmp.l    #0,(a2)
       bne.s    .next

       movem.l  (a7)+,d0-d1/a0-a5
       rts