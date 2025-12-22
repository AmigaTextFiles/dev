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
* Funktionen der gadtools.library ©
*--------------------------------------
* GadgetFunktionen
*--------------------------------------
* >= d1.l = Zeiger auf vorheriges Gadget
* >= d3.l = Offsetzaehlregister
*
* >= a1.l = Zeiger auf NewGadgetStruktur
* >= a2.l = Zeiger auf TagItemStruktur
* >= a3.l = Zeiger auf TextPtrTabelle
* >= a4.l = Zeiger auf GadgetPtrAblage
*
* => d0.l = Zeiger auf neues Gadget oder 0 bei Fehler
* => d3.l = neuer Offset
*--------------------------------------

button_kind
        moveq.l #BUTTON_KIND,d0         ;Art => d0
        bra.s   gadget_anlegen          ;und ausfuehren

list_view_kind
        moveq.l #LISTVIEW_KIND,d0
        bra.s   gadget_anlegen

string_kind
        moveq.l #STRING_KIND,d0
        bra.s   gadget_anlegen

integer_kind
        moveq.l #INTEGER_KIND,d0
        bra.s   gadget_anlegen

mx_kind
        moveq.l #MX_KIND,d0
        move.l  a1,-(a7)
        move.l  4(a2),a1
        bsr     translate_array
        move.l  (a7)+,a1
        bra.s   gadget_anlegen

checkbox_kind
        moveq.l #CHECKBOX_KIND,d0
        bra.s   gadget_anlegen

cycle_kind
        moveq.l #CYCLE_KIND,d0
        move.l  a1,-(a7)
        move.l  4(a2),a1
        bsr     translate_array
        move.l  (a7)+,a1
        bra.s   gadget_anlegen

scroller_kind
        moveq.l #SCROLLER_KIND,d0

gadget_anlegen

        movem.l a0/d0,-(a7)
        move.l  0(a3,d3),d0
        move.l  #0,a0
        tst.l   d0
        beq.s   .no_string
        jsr     GetString

.no_string

        move.l  a0,gng_GadgetText(a1)
        movem.l (a7)+,a0/d0

        move.l  d1,a0                   ;Adresse vorheriges Gadget => a0
        bsr     create_gadget_a         ;anlegen
        move.l  d0,0(a4,d3)             ;Ptr in Tabelle merken
        addq    #4,d3                   ;Offset auf naechsten Ptr addieren
        add     #1,gng_GadgetID(a1)     ;ID erhoehen
        rts

*--------------------------------------
* create_context
*
* >= a0.l = Zeiger auf GadgetStruktur (komplett mit Nullen gefuellt!)
*
* => d0.l = Zeiger auf ContextGadget oder 0 bei Fehler
*--------------------------------------

create_context

        movem.l d1/a0-a1/a6,-(a7)

        CALLGADTOOLS CreateContext

        movem.l (a7)+,d1/a0-a1/a6
        rts

*--------------------------------------
* create_gadget_a
*
* >= d0.l = GadgetKind
* >= a0.l = Zeiger auf vorheriges Gadget
* >= a1.l = Zeiger auf NewGadgetStruktur
* >= a2.l = Zeiger auf TagItemListe
*
* => d0.l = Zeiger auf Gadget oder 0 bei Fehler
*--------------------------------------

create_gadget_a

        movem.l d1/a0-a1/a6,-(a7)

        CALLGADTOOLS CreateGadgetA

        movem.l (a7)+,d1/a0-a1/a6
        rts

*--------------------------------------
* free_gt_gadgets
*
* >= a0.l = Zeiger auf GadgetListe
*
* kein Rückgaberegister
*
* Anmerkung:
* Funktion prüft auf vorhandenen Zeiger
*--------------------------------------

free_gt_gadgets

        cmp.l   #0,a0
        beq.s   .abbruch

        movem.l d0-d1/a0-a1/a6,-(a7)

        CALLGADTOOLS FreeGadgets

        movem.l (a7)+,d0-d1/a0-a1/a6
.abbruch
        rts

*--------------------------------------
* gt_set_gadget_attrs_a
*
* >= a0.l = Zeiger auf Gadget
* >= a1.l = Zeiger auf Window
* >= a3.l = Zeiger auf TagItemListe
*
* kein Rueckgaberegister
*--------------------------------------

gt_set_gadget_attrs_a

        movem.l d0-d1/a0-a3/a6,-(a7)

        sub.l   a2,a2                   ;Zeiger auf Requester muss 0 sein !!!
        CALLGADTOOLS GT_SetGadgetAttrsA

        movem.l (a7)+,d0-d1/a0-a3/a6
        rts

*--------------------------------------
* RefreshFunktionen
*--------------------------------------
* gt_begin_refresh
*
* >= a0.l = Zeiger auf WindowStruktur
*
* kein Rueckgaberegister
*--------------------------------------

gt_begin_refresh

        movem.l d0-d1/a0-a1/a6,-(a7)

        CALLGADTOOLS GT_BeginRefresh

        movem.l (a7)+,d0-d1/a0-a1/a6
        rts

*--------------------------------------
* gt_end_refresh
*
* >= a0.l = Zeiger auf WindowStruktur
*
* kein Rueckgaberegister
*--------------------------------------

gt_end_refresh

        movem.l d0-d1/a0-a1/a6,-(a7)

        moveq.l #True,d0                ;setze Flag => beenden
        CALLGADTOOLS GT_EndRefresh

        movem.l (a7)+,d0-d1/a0-a1/a6
        rts

*--------------------------------------
* gt_refresh_window
*
* >= a0.l = Zeiger auf WindowStruktur
*
* kein Rueckgaberegister
*--------------------------------------

gt_refresh_window

        movem.l d0-d1/a0-a1/a6,-(a7)

        sub.l   a1,a1
        CALLGADTOOLS GT_RefreshWindow

        movem.l (a7)+,d0-d1/a0-a1/a6
        rts

*--------------------------------------
* RenderingFunktion
*--------------------------------------
* draw_bevel_box_a
*
* >= a0.l = Zeiger auf RastPort
* >= a1.l = Zeiger auf TagItemListe
* >= d0.l = LeftEdge
* >= d1.l = TopEdge
* >= d2.l = Width
* >= d3.l = Height
*
* kein Rueckgaberegister
*--------------------------------------

draw_bevel_box_a

        movem.l d0-d1/a0-a1/a6,-(a7)

        CALLGADTOOLS DrawBevelBoxA

        movem.l (a7)+,d0-d1/a0-a1/a6
        rts

*--------------------------------------
* VisualInfo Funktionen
*--------------------------------------
* get_visual_info_a
*
* >= a0.l = Zeiger auf Screen
* >= a1.l = Zeiger auf TagItemListe
*
* => d0.l = Zeiger auf VisualInfo
*--------------------------------------

get_visual_info_a

        movem.l d1/a0-a1/a6,-(a7)

        CALLGADTOOLS GetVisualInfoA

        movem.l (a7)+,d1/a0-a1/a6
        rts

*--------------------------------------
* free_visual_info
*
* >= a0.l = Zeiger auf VisualInfo
*
* kein Rückgaberegister
*
* Anmerkung:
* Funktion prüft auf vorhandenen Zeiger
*--------------------------------------

free_visual_info

        cmp.l   #0,a0
        beq.s   .abbruch

        movem.l d0-d1/a0-a1/a6,-(a7)

        CALLGADTOOLS FreeVisualInfo

        movem.l (a7)+,d0-d1/a0-a1/a6
.abbruch
        rts

*--------------------------------------
* Menue Funktionen
*--------------------------------------
* free_menus
*
* >= a0.l = Zeiger auf MenuStruktur
*
* kein Rückgaberegister
*
* Anmerkung:
* Funktion prüft auf vorhandenen Zeiger
*--------------------------------------

free_menus

        cmp.l   #0,a0
        beq.s   .abbruch

        movem.l d0-d1/a0-a1/a6,-(a7)

        CALLGADTOOLS FreeMenus

        movem.l (a7)+,d0-d1/a0-a1/a6
.abbruch
        rts

*--------------------------------------
* gt_get_i_msg
*
* >= a0.l = Zeiger auf IntuiMsgPort
*
* => d0.l = Zeiger auf IntuiMsgStruktur oder 0
*--------------------------------------

gt_get_i_msg

        movem.l d1/a0-a1/a6,-(a7)

        CALLGADTOOLS GT_GetIMsg

        movem.l (a7)+,d1/a0-a1/a6
        rts

*--------------------------------------
* gt_reply_i_msg
*
* >= a1.l = Zeiger auf IntuiMsgStruktur
*
* kein Rueckgaberegister
*--------------------------------------

gt_reply_i_msg

        movem.l d0-d1/a0-a1/a6,-(a7)

        CALLGADTOOLS GT_ReplyIMsg

        movem.l (a7)+,d0-d1/a0-a1/a6
        rts

*--------------------------------------
