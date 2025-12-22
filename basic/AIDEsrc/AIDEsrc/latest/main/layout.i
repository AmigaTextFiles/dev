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
* border_ausgeben
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

border_ausgeben

        movem.l d0-d3/a0-a1,-(a7)

        move.l  _MainWinRastPort,a0     ;RastPortPtr => a0
        lea     BorderTags,a1           ;TagItems    => a1
        move.l  _VInfo,4(a1)            ;VisualInfo eintragen
        move.l  #GTBB_Recessed,8(a1)    ;recessed Border ausgeben

* Source
        move    #002,d0                 ;LeftEdge
        move    #002,d1                 ;TopEdge
        move    #116,d2                 ;Width
        move    #048,d3                 ;Height
        bsr     draw_bevel_box_a        ;ausgeben

* Program
        add     #048,d1                 ;TopEdge
        move    #081,d3                 ;Height
        bsr     draw_bevel_box_a        ;ausgeben

* Make
        add     #081,d1                 ;TopEdge
        move    #048,d3                 ;Height
        bsr     draw_bevel_box_a        ;ausgeben

* Precompiler
        move    #118,d0                 ;LeftEdge
        move    #002,d1                 ;TopEdge
        move    #130,d2                 ;Width
        bsr     draw_bevel_box_a        ;ausgeben

* ACE Options
        add     #048,d1                 ;TopEdge
        move    #088,d3                 ;Height
        bsr     draw_bevel_box_a        ;ausgeben

* SuperOptimizer
        add     #088,d1                 ;TopEdge
        move    #041,d3                 ;Height
        bsr     draw_bevel_box_a        ;ausgeben

* View
        move    #248,d0                 ;LeftEdge
        move    #002,d1                 ;TopEdge
        move    #132,d2                 ;Width
        move    #048,d3                 ;Height
        bsr     draw_bevel_box_a        ;ausgeben

* Assembler
        add     #048,d1                 ;TopEdge
        move    #097,d3                 ;Height
        bsr     draw_bevel_box_a        ;ausgeben

* Linker Lib
        add     #097,d1                 ;TopEdge
        move    #032,d3                 ;Height
        bsr     draw_bevel_box_a        ;ausgeben

* Linker
        move    #380,d0                 ;LeftEdge
        move    #002,d1                 ;TopEdge
        move    #192,d2                 ;Width
        move    #177,d3                 ;Height
        bsr     draw_bevel_box_a        ;ausgeben

* Module
        add     #004,d0                 ;LeftEdge
        add     #061,d1                 ;TopEdge
        move    #184,d2                 ;Width
        move    #113,d3                 ;Height
        bsr     draw_bevel_box_a        ;ausgeben

        move.l  #0,8(a1)                ;normalen Border ausgeben

* available
        add     #3,d0
        add     #12,d1
        sub     #18,d2
        sub     #23,d3
        bsr     draw_bevel_box_a

* ProportionalGadget

        move    #553,d0
        move    #012,d2
        bsr     draw_bevel_box_a

        movem.l (a7)+,d0-d3/a0-a1
        rts

*--------------------------------------
* beschriftung_ausgeben
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

beschriftung_ausgeben

        movem.l a0-a1,-(a7)

        move.l  _MainWinRastPort,a0     ;RastPortPtr     => a0
        lea     Ausgabe_Ts,a1           ;IntuiTextStrPtr => a1

        move.b  #001,(a1)               ;foreground color
        move.b  #002,1(a1)              ;background color
        move.b  #1,d0                   ;print text centered

        move.w  #060,4(a1)              ;left edge
        move.w  #005,6(a1)              ;top edge
        move.l  #IDSource_Titel_Text,12(a1)
        bsr     print_locale            ;ausgeben

        move.w  #060,4(a1)              ;left edge
        move.w  #053,6(a1)              ;top edge
        move.l  #IDProgram_Titel_Text,12(a1)
        bsr     print_locale            ;ausgeben

        move.w  #060,4(a1)              ;left edge
        move.w  #134,6(a1)              ;top edge
        move.l  #IDMake_Titel_Text,12(a1)
        bsr     print_locale            ;ausgeben

        move.w  #183,4(a1)              ;left edge
        move.w  #005,6(a1)              ;top edge
        move.l  #IDPreco_Titel_Text,12(a1)
        bsr     print_locale            ;ausgeben

        move.w  #53,6(a1)              ;top edge
        move.l  #IDAceOpt_Titel_Text,12(a1)
        bsr     print_locale            ;ausgeben

        move.w  #183,4(a1)              ;left edge
        move.w  #141,6(a1)              ;top edge
        move.l  #IDSuperOpt_Titel_Text,12(a1)
        bsr     print_locale            ;ausgeben

        move.w  #314,4(a1)              ;left edge
        move.w  #005,6(a1)              ;top edge
        move.l  #IDView_Titel_Text,12(a1)
        bsr     print_locale            ;ausgeben

        move.w  #314,4(a1)              ;left edge
        move.w  #053,6(a1)              ;top edge
        move.l  #IDAss_Titel_Text,12(a1)
        bsr     print_locale            ;ausgeben

        move.w  #314,4(a1)              ;left edge
        move.w  #150,6(a1)              ;top edge
        move.l  #IDLinkLib_Titel_Text,12(a1)
        bsr     print_locale            ;ausgeben

        move.w  #469,4(a1)              ;left edge
        move.w  #005,6(a1)              ;top edge
        move.l  #IDLinker_Titel_Text,12(a1)
        bsr     print_locale            ;ausgeben

        move.w  #66,6(a1)               ;top edge
        move.l  #IDModule_Titel_Text,12(a1)
        bsr     print_locale            ;ausgeben

        movem.l (a7)+,a0-a1
        rts

*--------------------------------------
* module_neu_ausgeben
*
* >= d0.l = neue Startzeile
*
* kein Rückgaberegister
*--------------------------------------

module_neu_ausgeben

        movem.l d0-d2/a0-a3,-(a7)

        tst.l   ModuleAnzahl            ;Array vorhanden?
        beq     .ende                   ;nein

        move.w  d0,StartZeile           ;merken

        move.l  _MainWinRastPort,a0     ;RastPortPtr     => a0
        lea     Ausgabe_Ts,a1           ;IntuiTextStrPtr => a1
        move.l  #ModuleTextPuffer,12(a1) ;Zeiger auf Text eintragen

        move.b  #001,(a1)               ;foreground color
        move.w  #389,4(a1)              ;left edge
        move.w  #076,6(a1)              ;top edge

        move.l  ModuleAnzahl,d1         ;Anzahl => d1
        bsr     prop_einstellen         ;Knob auf richtige Größe stellen

        cmpi.w  #11,d1                  ;kleiner = 11 ?
        ble     .array                  ;ja

        moveq   #11,d1                  ;größer, nur maximal 11 darstellbar
.array
        subq    #1,d1                   ;-1, da dbra bis -1 zählt
        move.l  _AvailableModule,a2     ;Zeige auf ModuleArray

        mulu    #FileSize,d0            ;aktuelle Zeile berechnen
        add.w   d0,a2                   ;und addieren

        lea     AvailGad01,a3           ;zeige auf GadgetStrukturen
.loop
        move.w  gg_Flags(a3),d2         ;Flags => d2

        tst.b   31(a2)                  ;wie steht das Flag?
        beq.s   .skip                   ;nicht aktiv

        move.b  #2,1(a1)                ;background color hell
        bset    #7,d2                   ;als selected markieren
        bra.s   .ausgeben
.skip
        move.b  #0,1(a1)                ;background color normal
        bclr    #7,d2                   ;als nicht selected markieren

.ausgeben
        move.w  d2,gg_Flags(a3)         ;Flags wieder eintragen
        bsr     module_text_eintragen   ;Text eintragen
        moveq   #0,d0                   ;left align
        bsr     print_i_text            ;ausgeben

        lea     FileSize(a2),a2         ;Ptr auf nächsten Namen eintragen
        addi.w  #8,6(a1)                ;TopEdge aufaddieren

        move.l  (a3),a3                 ;Zeiger auf nächste Gadgetstruktur => a3
        dbra    d1,.loop

        moveq   #11,d1                  ;maximal darstellbare Anzahl => d1
        move.l  ModuleAnzahl,d0         ;Anzahl => d0
        sub     d0,d1                   ;größer oder gleich?
        ble     .ende                   ;ja

        move.w  #0,(a1)                 ;color = background
        lea     ModuleTextPuffer,a2     ;Zeiger auf Text eintragen
        moveq   #ZeilenLaenge-1,d2
.loop2
        move.b  #" ",(a2)+              ;Text löschen
        dbra    d2,.loop2

        subq    #1,d1
        moveq   #0,d0                   ;left align
.loop3
        bsr     print_i_text            ;evtl. Text löschen
        addi.w  #8,6(a1)                ;TopEdge aufaddieren
        dbra    d1,.loop3
.ende
        movem.l (a7)+,d0-d2/a0-a3
        rts

*--------------------------------------
* toggle_module_gadget
*
* >= d0 = Offset im Array
* >= d2 = Aktivitätszustand des Gadgets
*
* kein Rückgaberegister
*--------------------------------------

toggle_module_gadget

        movem.l d0-d1/a0-a2,-(a7)

        tst.l   ModuleAnzahl            ;Array vorhanden?
        beq     .ende                   ;nein

        move.l  _MainWinRastPort,a0     ;RastPortPtr     => a0
        lea     Ausgabe_Ts,a1           ;IntuiTextStrPtr => a1
        move.l  #ModuleTextPuffer,12(a1) ;Zeiger auf Text eintragen
        move.l  _AvailableModule,a2     ;zeige auf ModuleArray

        move.w  StartZeile,d1           ;AnzeigeAnfang => d1
        add.w   d0,d1                   ;angewählte Zeile addieren
        mulu    #FileSize,d1            ;aktuelle ArrayOffset berechnen
        add.w   d1,a2                   ;und addieren

        bsr     module_text_eintragen   ;Text eintragen

        btst    #7,d2                   ;welcher Zustand?
        beq.s   .deaktiviert            ;Gadget deaktiviert

        move.b  #002,1(a1)              ;background color
        move.b  #1,31(a2)               ;Markierung setzen
        bra.s   .foreground             ;nun die anderen Werte

.deaktiviert
        move.b  #000,1(a1)              ;background color
        move.b  #0,31(a2)               ;Markierung löschen

.foreground
        move.b  #001,(a1)               ;foreground color
        move.w  #389,4(a1)              ;LeftEdge
        move.w  #076,6(a1)              ;TopEdge

        mulu    #8,d0                   ;aktuelle Zeile berechnen
        add.w   d0,it_TopEdge(a1)       ;und addieren
        moveq   #0,d0                   ;left-align
        bsr     print_i_text            ;ausgeben
.ende
        movem.l (a7)+,d0-d1/a0-a2
        rts

*--------------------------------------
* module_text_eintragen
*
* >= a2.l = Zeiger auf Text
*
* kein Rückgaberegister
*--------------------------------------

module_text_eintragen

        movem.l d0/a0-a2,-(a7)

        tst.l   ModuleAnzahl            ;Array vorhanden?
        beq     .ende                   ;nein

        lea     ModuleTextPuffer,a1
        moveq.l #ZeilenLaenge,d0
.loop
        move.b  (a2)+,(a1)+
        bne.s   .next
        beq.s   .space1
.next
        subq.l  #1,d0
        bne.s   .loop
.space1
        tst.l   d0
        beq.s   .ende

        move.b  #" ",-(a1)
.space
        move.b  #" ",(a1)+
        subq.l  #1,d0
        bne.s   .space
.ende
        movem.l (a7)+,d0/a0-a2
        rts
*--------------------------------------
* prop_einstellen
*
* >= d0.w = Startzeile
* >= d1.l = ModuleAnzahl
*
* kein Rückgaberegister
*--------------------------------------

prop_einstellen

        movem.l d0-d6/a0-a1,-(a7)

        cmpi.w  #11,d1                  ;kleiner = 11 ?
        ble     .nicht_berechnen        ;ja

        move.l  #$FFFF,d6               ;Maximalwert => d6
        mulu    #11,d6                  ;11 können angezeigt werden
        divu    d1,d6                   ;durch die tatsächliche Anzahl dividieren
        moveq.l #0,d4                   ;Register löschen
        move.w  d6,d4                   ;VertBodyGröße => d4
        bra.s   .pos

.nicht_berechnen

        move.l  #$FFFF,d4               ;Maximalwert => d4
.pos
        tst     d0                      ;an Pos 0 ausgeben?
        bne.s   .same_pos               ;nein

        moveq   #0,d2                   ;ja
        bra.s   .einstellen             ;und einstellen

.same_pos
        lea     ScrollerInfo,a0         ;Zeiger auf PropInfoStruktur => a0
        move.w  4(a0),d2                ;aktuelle Pos => d2

.einstellen
        lea     Scroller,a0             ;GadgetPtr => a0
        move.l  _MainWinPtr,a1          ;WindowPtr => a1
        moveq.l #13,d0                  ;Flags => d0
        moveq.l #0,d1                   ;nicht horizontal
        moveq.l #0,d3                   ;nicht horizontal
        moveq.l #1,d5                   ;nur 1 Gadget auffrischen

        bsr     new_modify_prop         ;einstellen
.ende
        movem.l (a7)+,d0-d6/a0-a1
        rts

*-------------------------------------
