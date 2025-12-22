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
* create_gadgets_SuperOpt
*
* Legt die GadToolsGadgetStrukturen für das SuperOptimizer Window an.
*
* kein Übergaberegister
*
* => d0.l = 0 = Fehler, <> 0 = alles ok
*--------------------------------------

create_gadgets_superopt

        movem.l d1-d3/a0-a4,-(a7)

        lea     _SOptGadList,a0         ;zeige auf Zeigerablage
        bsr     create_context          ;anlegen
        move.l  d0,d1                   ;merken, geklappt?
        beq     .fehler                 ;nein

        lea     NewGad,a1               ;zeige auf NewGadgetStruktur
        lea     CheckBoxTags,a2
        lea     _SOptButtons,a3
        lea     _Gadget_Ptr_SOptWin,a4

        moveq.l #0,d3

* SuperOptimizers Options CheckBox Gadgets
*-----------------------------

        move.w  #21,gng_LeftEdge(a1)
        move.w  #12,gng_TopEdge(a1)
        move.w  #0,gng_GadgetID(a1)
        moveq.l #16,d2

.loop1
        bsr     get_sopt_options
        add.w   #12,gng_TopEdge(a1)
        bsr     checkbox_kind
        move.l  d0,d1
        beq     .fehler

        cmp.l   #8,d2
        bne.s   .repeat

        move.w  #280,gng_LeftEdge(a1)
        move.w  #12,gng_TopEdge(a1)

.repeat
        dbra    d2,.loop1

.buttons

        lea     EnableTags,a2
        move.w  #21,gng_LeftEdge(a1)
        move.w  #152,gng_TopEdge(a1)
        move.w  #014,gng_Height(a1)
        move.w  #100,gng_Width(a1)
        move.l  #PLACETEXT_IN!NG_HIGHLABEL,gng_Flags(a1)
        moveq.l #3,d2

.loop2
        bsr     button_kind
        move.l  d0,d1
        beq     .fehler
        add.w   #140,gng_LeftEdge(a1)

        dbra    d2,.loop2


        bra.s   .ende

.fehler
        move.l  _SOptGadList,a0                 ;GadgetListPtr => a0
        bsr     free_gt_gadgets                 ;freigeben
        clr.l   _SOptGadList                    ;Ptr löschen
        bsr     no_gadtools_gadgets             ;Fehlermeldung ausgeben
        moveq   #0,d0                           ;Fehler melden

.ende
        movem.l (a7)+,d1-d3/a0-a4
        rts

***********************
* Beschriftung ausgeben
***********************

SOpt_beschriften

        move.l  _SOptWinRastPort,a0     ;RastPortPtr     => a0
        lea     Ausgabe_Ts,a1           ;IntuiTextStrPtr => a1
        lea     _SOptGadgetsText,a2

        move.b  #002,(a1)               ;foreground color
        move.b  #000,1(a1)              ;background color
        move.b  #1,d0                   ;centered

        move.w  #291,4(a1)
        move.w  #005,6(a1)
        move.l  #IDSOptTitle,12(a1)
        bsr     print_locale

        moveq   #0,d0                   ;left align

        move.b  #001,(a1)               ;foreground color
        move.w  #059,4(a1)              ;left edge
        move.w  #014,6(a1)              ;top edge
        move.l  #16,d2

.loop2

        add.w   #12,6(a1)
        move.l  (a2)+,12(a1)
        bsr     print_locale            ;ausgeben

        cmp.l   #8,d2
        bne.s   .repeat2

        move.w  #315,4(a1)
        move.w  #14,6(a1)

.repeat2

        dbra    d2,.loop2
        rts
