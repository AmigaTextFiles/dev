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

open_setup_win

        movem.l d0-d1/a0-a2,-(a7)

* NewWindowStruktur initialisieren
*---------------------------------
        lea     _NewWindow,a0           ;zeige auf WindowStruktur
        move.l  _MainWinPtr,a1          ;zeige auf WindowStruktur
                                        ;an Position des MainWin ausgeben

        move.w  wd_LeftEdge(a1),nw_LeftEdge(a0)
        move.w  wd_TopEdge(a1),nw_TopEdge(a0)

        bsr     close_main_win          ;jetzt das Hauptfenster schließen

        move.w  MainWinWidth,nw_Width(a0) ;gleiche Höhe und Breite
        move.w  MainWinHeight,nw_Height(a0)

        move.l  SetupWinFlags,nw_Flags(a0)

* Gadgets anlegen
*----------------
        bsr     create_setup_gadgets    ;GadgetStrukturen anlegen
        tst.l   d0                      ;alles klar?
        beq     .ende                   ;nein

        move.l  _SetupGadList,nw_FirstGadget(a0)

* Daten in SpecialInfoStruktur eintragen
*---------------------------------------
        bsr     setup_stringgads_einstellen

* Fenster öffnen
*---------------
        bsr     open_window             ;öffne Window
        move.l  d0,_SetupWinPtr         ;Adresse sichern
        beq     .ende                   ;nicht geöffnet

        move.l  d0,a0                   ;WindowPtr => a0
        move.l  wd_RPort(a0),_SetupWinRastPort
                                        ;merken
* Font setzen
*------------
        move.l  wd_RPort(a0),a1         ;RastPortPtr => a1
        move.l  _FontPtr,a0             ;FontPtr     => a0
        bsr     set_font                ;Font setzen

        move.l  _SetupWinPtr,a0         ;WindowPtr   => a0
        bsr     gt_refresh_window       ;Fenster auffrischen

* Fenster Titel ausgeben
*-----------------------
        lea     _SetupWinTitle,a1       ;Zeiger auf Titel eintragen
        move.l  #-1,a2                  ;keine Änderung im ScreenTitel
        bsr     set_win_titles          ;und ausführen

        move.l  SetupWinIDCMP,d0        ;Flags      => d0
        move.l  _WinMsgPort,a1          ;MsgPortPtr => a1
        bsr     modify_idcmp            ;aktivieren

        bsr     setup_border_ausgeben

        bsr     setup_beschriftung_ausgeben

* Intuition StringGadgets ausgeben
*---------------------------------
        moveq.l #-1,d0                  ;ans Ende anfügen
        moveq.l #-1,d1                  ;alle
        move.l  _SetupWinPtr,a0         ;WindowPtr   => a0
        lea     SetupStrGad01,a1        ;zeige auf den Anfang der GadgetListe
        bsr     add_g_list              ;ans Fenster binden

        exg     a0,a1                   ;Zeiger umtauschen
        moveq   #-1,d0                  ;alle bis zum Ende der Liste
        bsr     refresh_g_list          ;und auffrischen

        bsr     setup_events            ;auf Events warten

        move.l  _SetupWinPtr,a1         ;zeige auf WindowStruktur
                                        ;Position merken

        move.w  wd_LeftEdge(a1),MainWinLeftEdge
        move.w  wd_TopEdge(a1),MainWinTopEdge

        bsr     close_setup_win         ;jetzt Fenster schließen
.ende
        movem.l (a7)+,d0-d1/a0-a2
        rts

*--------------------------------------

close_setup_win

        move.l  a0,-(a7)

        move.l  _SetupWinPtr,a0         ;WindowPtr => a0
        bsr     close_window_safely     ;schließen

        move.l  _SetupGadList,a0        ;GadgetListPtr => a0
        bsr     free_gt_gadgets         ;freigeben
        clr.l   _SetupGadList           ;Zeiger löschen

        move.l  (a7)+,a0
        rts

*--------------------------------------

setup_events

        moveq.l #0,d0                   ;nur auf Userport reagieren
        moveq.l #1,d1                   ;mit Wait()
        move.l  _WinMsgPort,a0          ;Zeiger auf MsgPort => a0

        bsr     gt_win_event            ;Ereignis besorgen

        bsr     setup_sperren           ;keine weiteren Ereignisse zugelassen

        btst    #2,d0                   ;RefreshWindow?
        beq.s   .buttons                ;nein

        move.l  _SetupWinPtr,a0          ;ja, auffrischen
        bsr     gt_begin_refresh
        bsr     gt_end_refresh
        bra.s   .loop

.buttons
        btst    #3,d0                   ;MouseButtons ?
        beq.s   .window_close           ;nein

        bsr     pruefe_auf_strgad_aktiv ;prüfe, ob ein StringGadget aktiviert
                                        ;gewesen ist
        bra.s   .loop                   ;und nächstes Ereignis besorgen

.window_close
        btst    #9,d0                   ;WindowClose?
        bne.s   .ende                   ;ja

.gadgetup
        btst    #6,d0                   ;GadgetUp?
        beq.s   .gadgetdown             ;nein

        bsr     react_on_setup_gadget   ;ja, auswerten
        bra.s   .loop                   ;auf neues Ereignis warten

.gadgetdown
        btst    #5,d0                   ;GadgetDown?
        beq.s   .loop                   ;nein

        bsr     react_on_setup_gadget   ;ja, auswerten
.loop
        bsr     setup_freigeben         ;Ereignisse wieder zulassen
        bra.s   setup_events            ;und auf ein Neues
.ende
        rts
*--------------------------------------
* create_setup_gadgets
*
* Legt die GadToolsGadgetStrukturen für das Setupwindow an.
*
* kein Übergaberegister
*
* => d0.l = 0 = Fehler, <> 0 = alles ok
*--------------------------------------

create_setup_gadgets

        movem.l d1-d4/a0-a6,-(a7)

        lea     _SetupGadList,a0        ;zeige auf Zeigerablage
        bsr     create_context          ;anlegen
        move.l  d0,d1                   ;merken, geklappt?
        beq     .fehler                 ;nein

        lea     NewGad,a1               ;zeige auf NewGadgetStruktur

* die Filerequester Buttons
*--------------------------

        move    #153,gng_LeftEdge(a1)   ;Position eintragen
        move    #025,gng_TopEdge(a1)
        move    #014,gng_Height(a1)
        move    #014,gng_Width(a1)
        move    #000,gng_GadgetID(a1)
        move.l  #R_Text,gng_GadgetText(a1)
        move.l  #PLACETEXT_IN!NG_HIGHLABEL,gng_Flags(a1)

        lea     EnableTags,a2           ;zeige auf TagItems

        moveq.l #5,d2                   ;Gadgetzählregister initialisieren
.loop1
        bsr     create_button_gad
        move.l  d0,d1                   ;merken, geklappt?
        beq     .fehler                 ;nein

        add     #027,gng_TopEdge(a1)    ;TopEdge aufaddieren
        dbra    d2,.loop1               ;bis alle bearbeitet

        add     #164,gng_LeftEdge(a1)   ;Position eintragen
        move    #025,gng_TopEdge(a1)

        moveq.l #5,d2                   ;Gadgetzählregister initialisieren
.loop2
        bsr     create_button_gad
        move.l  d0,d1                   ;merken, geklappt?
        beq     .fehler                 ;nein

        add     #027,gng_TopEdge(a1)    ;TopEdge aufaddieren
        dbra    d2,.loop2               ;bis alle bearbeitet

        add     #164,gng_LeftEdge(a1)   ;Position eintragen
        move    #025,gng_TopEdge(a1)

        moveq.l #5,d2                   ;Gadgetzählregister initialisieren
.loop3
        bsr     create_button_gad
        move.l  d0,d1                   ;merken, geklappt?
        beq     .fehler                 ;nein

        add     #027,gng_TopEdge(a1)    ;TopEdge aufaddieren
        dbra    d2,.loop3               ;bis alle bearbeitet

* PublicScreen Setting
*---------------------
        move    #33,gng_TopEdge(a1)     ;Position eintragen
        add     #29,gng_LeftEdge(a1)

        lea     MxTags,a2               ;zeige auf Tagitems
        move.l  #PLACETEXT_RIGHT!NG_HIGHLABEL,gng_Flags(a1)
        move.l  #2,20(a2)               ;2 Zeilen Abstand zwischen den Gadgets
        move.l  #_Yes_No_Texte,4(a2)    ;Zeiger auf TextPtrTabelle eintragen

        tst.l   ScreenFlag              ;PublicScreen schon gewählt?
        beq.s   .no_screen              ;nein

        move.l  #1,12(a2)               ;aktiv einstellen
        bra.s   .screen_gad             ;und anlegen

.no_screen
        move.l  #0,12(a2)               ;nicht aktiv einstellen

.screen_gad
        bsr     create_mx_gad           ;anlegen
        move.l  d0,d1                   ;merken, geklappt
        beq     .fehler                 ;nein

* RequesterFlag Setting
*----------------------

        add     #033,gng_TopEdge(a1)    ;TopEdge aufaddieren
        move.l  #_ReqGadTexte,4(a2)     ;Zeiger auf TextPtrTabelle eintragen
        move.l  RequesterFlag,12(a2)    ;aktuellen Zustand einstellen

        bsr     create_mx_gad           ;anlegen
        move.l  d0,d1                   ;merken, geklappt?
        beq     .fehler                 ;nein

* CleanUpFlag Setting
*--------------------

        add     #044,gng_TopEdge(a1)    ;TopEdge aufaddieren
        move.l  #_Yes_No_Texte,4(a2)    ;Zeiger auf TextPtrTabelle eintragen
        move.l  CleanUpFlag,12(a2)      ;aktuellen Zustand einstellen
        bsr     create_mx_gad           ;anlegen
        move.l  d0,d1                   ;merken, geklappt?
        beq     .fehler                 ;nein

* MenuPen Setting
*----------------

        add     #033,gng_TopEdge(a1)    ;TopEdge aufaddieren
        move.l  #_MenuPenGadTexte,4(a2) ;Zeiger auf TextPtrTabelle eintragen
        move.l  MenuPen,12(a2)          ;aktuellen Zustand einstellen
        bsr     create_mx_gad           ;anlegen
        tst.l   d0                      ;welches Ergebnis?
        bne.s   .ende                   ;alles ok

.fehler
        move.l  _SetupGadList,a0        ;GadgetListPtr => a0
        bsr     free_gt_gadgets         ;freigeben
        clr.l   _SetupGadList           ;Ptr löschen
        moveq   #0,d0                   ;melde Fehler
.ende
        movem.l (a7)+,d1-d4/a0-a6
        rts

*--------------------------------------

create_button_gad

        moveq.l #BUTTON_KIND,d0         ;Art => d0
        move.l  d1,a0                   ;Adresse vorheriges Gadget => a0
        bsr     create_gadget_a         ;anlegen
        add     #1,gng_GadgetID(a1)     ;ID erhoehen
        rts

*--------------------------------------

create_mx_gad

        moveq.l #MX_KIND,d0
        move.l  d1,a0                   ;Adresse vorheriges Gadget => a0
        bsr     create_gadget_a         ;anlegen
        add     #1,gng_GadgetID(a1)     ;ID erhoehen
        rts

*--------------------------------------
* setup_stringgads_einstellen
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

setup_stringgads_einstellen

        movem.l a0-a4,-(a7)

        move.l  _MemPtr,a4              ;zeige auf Konfiguration

        lea     SetupStrGadInfo01,a2    ;zeige auf GadgetSpecialInfoStruktur
        move.l  (a2),a1                 ;Zeiger auf Puffer => a1
        lea     new_src_dir(a4),a0      ;Adresse auf den Eintrag => a0
        bsr     string_kopieren         ;in den Puffer eintragen

        lea     SetupStrGadInfo02,a2    ;dto.
        move.l  (a2),a1
        lea     new_tmp_dir(a4),a0
        bsr     string_kopieren

        lea     SetupStrGadInfo03,a2
        move.l  (a2),a1
        lea     new_blt_dir(a4),a0
        bsr     string_kopieren

        lea     SetupStrGadInfo04,a2
        move.l  (a2),a1
        lea     new_doc_dir(a4),a0
        bsr     string_kopieren

        lea     SetupStrGadInfo05,a2
        move.l  (a2),a1
        lea     new_mod_dir(a4),a0
        bsr     string_kopieren

        lea     SetupStrGadInfo06,a2
        move.l  (a2),a1
        lea     new_fd_dir(a4),a0
        bsr     string_kopieren

        lea     SetupStrGadInfo07,a2
        move.l  (a2),a1
        lea     new_editor(a4),a0
        bsr     string_kopieren

        lea     SetupStrGadInfo08,a2
        move.l  (a2),a1
        lea     new_viewer(a4),a0
        bsr     string_kopieren

        lea     SetupStrGadInfo09,a2
        move.l  (a2),a1
        lea     new_agdtool(a4),a0
        bsr     string_kopieren

        lea     SetupStrGadInfo10,a2
        move.l  (a2),a1
        lea     new_fdtobmap(a4),a0
        bsr     string_kopieren

        lea     SetupStrGadInfo11,a2
        move.l  (a2),a1
        lea     new_abtoascii(a4),a0
        bsr     string_kopieren

        lea     SetupStrGadInfo12,a2
        move.l  (a2),a1
        lea     new_uppercacer(a4),a0
        bsr     string_kopieren

        lea     SetupStrGadInfo13,a2
        move.l  (a2),a1
        lea     new_calc(a4),a0
        bsr     string_kopieren

        lea     SetupStrGadInfo14,a2
        move.l  (a2),a1
        lea     new_reqed(a4),a0
        bsr     string_kopieren

        lea     SetupStrGadInfo15,a2
        move.l  (a2),a1
        lea     new_util_a(a4),a0
        bsr     string_kopieren

        lea     SetupStrGadInfo16,a2
        move.l  (a2),a1
        lea     new_util_b(a4),a0
        bsr     string_kopieren

        lea     SetupStrGadInfo17,a2
        move.l  (a2),a1
        lea     new_util_c(a4),a0
        bsr     string_kopieren

        lea     SetupStrGadInfo18,a2
        move.l  (a2),a1
        lea     new_util_d(a4),a0
        bsr     string_kopieren

        movem.l (a7)+,a0-a4
        rts

*--------------------------------------
* setup_border_ausgeben
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

setup_border_ausgeben

        movem.l d0-d4/a0-a1,-(a7)

        move.l  _SetupWinRastPort,a0    ;RastPortPtr => a0
        lea     BorderTags,a1           ;TagItems    => a1
        move.l  _VInfo,4(a1)            ;VisualInfo eintragen
        move.l  #GTBB_Recessed,8(a1)    ;recessed Border ausgeben

        move    #002,d0                 ;LeftEdge
        move    #002,d1                 ;TopEdge
        move    #500,d2                 ;Width
        move    #177,d3                 ;Height
        bsr     draw_bevel_box_a        ;ausgeben

        move    #006,d0                 ;LeftEdge
        move    #014,d1                 ;TopEdge
        move    #164,d2                 ;Width
        move    #027,d3                 ;Height

        moveq.l #5,d4                   ;Schleifenzählregister initialisieren
        bsr     .loop                   ;ausgeben

        add     #164,d0                 ;LeftEdge
        move    #014,d1                 ;TopEdge

        moveq.l #5,d4                   ;Schleifenzählregister initialisieren
        bsr     .loop                   ;ausgeben

        add     #164,d0                 ;LeftEdge
        move    #014,d1                 ;TopEdge

        moveq.l #5,d4                   ;Schleifenzählregister initialisieren
        bsr     .loop                   ;ausgeben

        add     #168,d0                 ;LeftEdge
        move    #002,d1                 ;TopEdge
        move    #070,d2                 ;Width
        move    #177,d3                 ;Height
        bsr     draw_bevel_box_a        ;ausgeben

        add     #004,d0                 ;LeftEdge
        add     #012,d1                 ;TopEdge
        move    #062,d2                 ;Width
        move    #041,d3                 ;Height
        bsr     draw_bevel_box_a        ;ausgeben

        add     #041,d1                 ;TopEdge
        move    #044,d3                 ;Height
        bsr     draw_bevel_box_a        ;ausgeben

        add     #044,d1                 ;TopEdge
        move    #033,d3                 ;Height
        bsr     draw_bevel_box_a        ;ausgeben

        add     #033,d1                 ;TopEdge
        move    #044,d3                 ;Height
        bsr     draw_bevel_box_a        ;ausgeben

        move.l  #0,8(a1)                ;normalen Border ausgeben

        move    #008,d0                 ;LeftEdge
        move    #025,d1                 ;TopEdge
        move    #144,d2                 ;Width
        move    #014,d3                 ;Height

        moveq.l #5,d4                   ;Schleifenzählregister initialisieren
        bsr     .loop                   ;ausgeben

        add     #164,d0                 ;LeftEdge aufaddieren
        move    #025,d1                 ;TopEdge einstellen

        moveq.l #5,d4                   ;Schleifenzählregister initialisieren
        bsr     .loop                   ;ausgeben

        add     #164,d0                 ;LeftEdge aufaddieren
        move    #025,d1                 ;TopEdge einstellen

        moveq.l #5,d4                   ;Schleifenzählregister initialisieren
        bsr     .loop                   ;ausgeben

        move.l  #GTBB_Recessed,8(a1)    ;recessed Border ausgeben

        move    #010,d0                 ;LeftEdge
        move    #026,d1                 ;TopEdge
        move    #140,d2                 ;Width
        move    #012,d3                 ;Height

        moveq.l #5,d4                   ;Schleifenzählregister initialisieren
        bsr     .loop                   ;ausgeben

        add     #164,d0                 ;LeftEdge aufaddieren
        move    #026,d1                 ;TopEdge einstellen

        moveq.l #5,d4                   ;Schleifenzählregister initialisieren
        bsr     .loop                   ;ausgeben

        add     #164,d0                 ;LeftEdge aufaddieren
        move    #026,d1                 ;TopEdge einstellen

        moveq.l #5,d4                   ;Schleifenzählregister initialisieren
        bsr     .loop                   ;ausgeben

        movem.l (a7)+,d0-d4/a0-a1
        rts

.loop
        bsr     draw_bevel_box_a        ;ausgeben
        add     #27,d1                  ;TopEdge aufaddieren
        dbra    d4,.loop
        rts
*--------------------------------------
* setup_beschriftung_ausgeben
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

setup_beschriftung_ausgeben

        movem.l d0-d1/a0-a2,-(a7)

        move.l  _SetupWinRastPort,a0    ;RastPortPtr     => a0
        lea     Ausgabe_Ts,a1           ;IntuiTextStrPtr => a1
        lea     SetupTextTable,a2       ;zeige auf Textzeiger
        moveq.l #0,d0

        move.b  #002,(a1)               ;Vordergrund
        move.b  #001,1(a1)              ;Hintergrund

        move.w  #200,4(a1)              ;LeftEdge
        move.w  #004,6(a1)              ;TopEdge
        move.l  0(a2,d0),12(a1)         ;Zeiger auf Text eintragen
        bsr     print_i_text            ;ausgeben

        move.b  #001,(a1)               ;Vordergrund
        move.b  #002,1(a1)              ;Hintergrund
        move.w  #012,4(a1)              ;LeftEdge
        move.w  #016,6(a1)              ;TopEdge

        moveq.l #5,d1
.loop1
        addq    #4,d0                   ;Offset aufaddieren
        move.l  0(a2,d0),12(a1)         ;Zeiger auf Text eintragen
        bsr     print_i_text            ;ausgeben

        add.w   #27,6(a1)               ;TopEdge aufaddieren
        dbra    d1,.loop1               ;nächsten bearbeiten

        move.w  #012+164,4(a1)          ;LeftEdge
        move.w  #016,6(a1)              ;TopEdge

        moveq.l #5,d1
.loop2
        addq    #4,d0                   ;Offset aufaddieren
        move.l  0(a2,d0),12(a1)         ;Zeiger auf Text eintragen
        bsr     print_i_text            ;ausgeben

        add.w   #27,6(a1)               ;TopEdge aufaddieren
        dbra    d1,.loop2               ;nächsten bearbeiten

        move.w  #012+164*2,4(a1)        ;LeftEdge
        move.w  #016,6(a1)              ;TopEdge

        moveq.l #5,d1
.loop3
        addq    #4,d0                   ;Offset aufaddieren
        move.l  0(a2,d0),12(a1)         ;Zeiger auf Text eintragen
        bsr     print_i_text            ;ausgeben

        add.w   #27,6(a1)               ;TopEdge aufaddieren
        dbra    d1,.loop3               ;nächsten bearbeiten

        move.w  #024+164*3,4(a1)        ;LeftEdge
        move.w  #004,6(a1)              ;TopEdge

        move.b  #002,(a1)               ;Vordergrund
        move.b  #001,1(a1)              ;Hintergrund

        addq    #4,d0                   ;Offset aufaddieren
        move.l  0(a2,d0),12(a1)         ;Zeiger auf Text eintragen
        bsr     print_i_text            ;ausgeben

        move.b  #001,(a1)               ;Vordergrund
        move.b  #002,1(a1)              ;Hintergrund

        sub.w   #3,4(a1)                ;LeftEdge
        add.w   #12,6(a1)               ;TopEdge aufaddieren
        addq    #4,d0                   ;Offset aufaddieren
        move.l  0(a2,d0),12(a1)         ;Zeiger auf Text eintragen
        bsr     print_i_text            ;ausgeben

        add.w   #8,6(a1)                ;TopEdge aufaddieren
        addq    #4,d0                   ;Offset aufaddieren
        move.l  0(a2,d0),12(a1)         ;Zeiger auf Text eintragen
        bsr     print_i_text            ;ausgeben

        sub.w   #3,4(a1)                ;LeftEdge
        add.w   #33,6(a1)               ;TopEdge aufaddieren
        addq    #4,d0                   ;Offset aufaddieren
        move.l  0(a2,d0),12(a1)         ;Zeiger auf Text eintragen
        bsr     print_i_text            ;ausgeben

        add.w   #3,4(a1)                ;LeftEdge
        add.w   #44,6(a1)               ;TopEdge aufaddieren
        addq    #4,d0                   ;Offset aufaddieren
        move.l  0(a2,d0),12(a1)         ;Zeiger auf Text eintragen
        bsr     print_i_text            ;ausgeben

        add.w   #33,6(a1)               ;TopEdge aufaddieren
        addq    #4,d0                   ;Offset aufaddieren
        move.l  0(a2,d0),12(a1)         ;Zeiger auf Text eintragen
        bsr     print_i_text            ;ausgeben

        movem.l (a7)+,d0-d1/a0-a2
        rts

*--------------------------------------

react_on_setup_gadget

        bsr     pruefe_auf_strgad_aktiv ;StringGadget schon aktiv gewesen?

        movem.l d0-d7/a0-a6,-(a7)

        move.l  d0,d4                   ;IDCMPFlag merken
        move.l  d3,a0                   ;Zeiger auf GadgetStruktur => a0
        move.w  gg_GadgetID(a0),d0      ;GadgetID => d0
        move.w  gg_Flags(a0),d2         ;Flags => d2
        move.l  gg_SpecialInfo(a0),d3   ;Zeiger auf SpecialInfo => d3

        bsr     teste_auf_string_gadget ;StringGadget das 1. Mal angeklickt?
        tst.l   d0                      ;welches Ergebnis?
        bmi.s   .ende                   ;ja

        move.l  _MemPtr,a2              ;zeige auf Konfigurationsdaten

        lsl     #2,d0                   ; * 4 da long
        lea     tabelle_setup_uprge,a1  ;zeige auf Tabelle
        move.l  0(a1,d0),a1             ;addiere Offset

        jsr     (a1)                    ;Unterprogramm ausführen

        move.w  #1,Config_geaendert     ;Flag setzen
.ende
        movem.l (a7)+,d0-d7/a0-a6
        rts

*--------------------------------------

tabelle_setup_uprge

        dc.l    asl_src_dir,asl_tmp_dir,asl_blt_dir,asl_doc_dir,asl_mod_dir,asl_fd_dir

        dc.l    asl_editor,asl_viewer,asl_agdtool,asl_fd2bmap,asl_ab2ascii,asl_uppercacer

        dc.l    asl_calc,asl_reqed,asl_util0,asl_util1,asl_util2,asl_util3

        dc.l    set_pubscreen,set_requester,set_cleanup,set_menupen

        dc.l    set_src_dir,set_tmp_dir,set_blt_dir,set_doc_dir,set_mod_dir,set_fd_dir

        dc.l    set_editor,set_viewer,set_agdtool,set_fd2bmap,set_ab2ascii,set_uppercacer

        dc.l    set_calc,set_reqed,set_util0,set_util1,set_util2,set_util3

*--------------------------------------

set_src_dir

        lea     new_src_dir(a2),a1      ;zeige auf Dirname-Ablage
        bsr     new_dir_eintragen       ;eintragen
        rts

*--------------------------------------

set_tmp_dir

        lea     new_tmp_dir(a2),a1
        bsr     new_dir_eintragen
        rts

*--------------------------------------

set_blt_dir

        lea     new_blt_dir(a2),a1
        bsr     new_dir_eintragen
        rts

*--------------------------------------

set_doc_dir

        lea     new_doc_dir(a2),a1
        bsr     new_dir_eintragen
        rts

*--------------------------------------

set_mod_dir

        lea     new_mod_dir(a2),a0      ;zeige auf aktuellen DirEintrag
        lea     Dateiname,a1            ;als Ablagepuffer benutzen
        bsr     string_kopieren         ;merken

        lea     new_mod_dir(a2),a1      ;jetzt => a1
        bsr     new_dir_eintragen       ;Änderung eintragen

        lea     new_mod_dir(a2),a0      ;zeige auf neuen DirEintrag
        lea     Dateiname,a1            ;zeige auf den alten
        bsr     string_compare          ;vergleiche
        tst.l   d0                      ;identisch?
        beq.s   .ende                   ;ja

        move.w  #1,ModDirChanged        ;nein, geändert, Flag setzen
.ende
        rts

*--------------------------------------

set_fd_dir

        lea     new_fd_dir(a2),a1
        bsr     new_dir_eintragen
        rts

*--------------------------------------

set_editor

        lea     new_editor(a2),a1
        bsr     new_dir_eintragen
        rts

*--------------------------------------

set_viewer

        lea     new_viewer(a2),a1
        bsr     new_dir_eintragen
        rts

*--------------------------------------

set_agdtool

        lea     new_agdtool(a2),a1
        bsr     new_dir_eintragen
        rts

*--------------------------------------

set_fd2bmap

        lea     new_fdtobmap(a2),a1
        bsr     new_dir_eintragen
        rts

*--------------------------------------

set_ab2ascii

        lea     new_abtoascii(a2),a1
        bsr     new_dir_eintragen
        rts

*--------------------------------------

set_uppercacer

        lea     new_uppercacer(a2),a1
        bsr     new_dir_eintragen
        rts

*--------------------------------------

set_calc

        lea     new_calc(a2),a1
        bsr     new_dir_eintragen
        rts

*--------------------------------------

set_reqed

        lea     new_reqed(a2),a1
        bsr     new_dir_eintragen
        rts

*--------------------------------------

set_util0

        lea     new_util_a(a2),a1
        bsr     new_dir_eintragen
        rts

*--------------------------------------

set_util1

        lea     new_util_b(a2),a1
        bsr     new_dir_eintragen
        rts

*--------------------------------------

set_util2

        lea     new_util_c(a2),a1
        bsr     new_dir_eintragen
        rts

*--------------------------------------

set_util3

        lea     new_util_d(a2),a1
        bsr     new_dir_eintragen
        rts

*--------------------------------------

new_dir_eintragen

        move.l  a0,a3                   ;GadgetPtr merken
        move.l  d3,a0                   ;zeige auf SpecialInfoStruktur
        move.l  4(a0),a2                ;Zeiger auf UndoPuffer merken
        move.l  (a0),a0                 ;zeige auf EingabeString

        move.l  a0,d1                   ;in d1 zur Prüfung übergeben
        bsr     pruefe_den_filenamen    ;prüfe den Namen
        tst.l   d0                      ;alles ok?
        bpl.s   .kopieren               ;ja

.set_orig
        bsr     set_orig_dir            ;nein, auf Originalwert zurückstellen
        bra.s   .ende                   ,und beenden

.kopieren
        bsr     string_kopieren         ;die neue Angabe eintragen
.ende
        rts

*--------------------------------------

set_orig_dir

        move.l  a0,a1                   ;zeige auf EingabePuffer
        move.l  a2,a0                   ;zeige auf UndoPuffer
        bsr     string_kopieren         ;vorherigen String eintragen

        move.l  a3,a0                   ;GadgetPtr => a0
        move.l  _SetupWinPtr,a1         ;WindowPtr => a1
        moveq   #1,d0                   ;1 Gadget
        bsr     refresh_g_list          ;auffrischen
.ende
        rts

*--------------------------------------

asl_src_dir

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_src_dir(a0),a2      ;KonfigPtr => a2
        lea     SetupStrGadPuffer01,a3  ;PufferPtr => a3
        lea     SetupStrGad01,a4        ;GadgetPtr => a4
        bsr     asl_dir_setup           ;Setup ausführen

        rts

*--------------------------------------

asl_tmp_dir

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_tmp_dir(a0),a2      ;KonfigPtr => a2
        lea     SetupStrGadPuffer02,a3  ;PufferPtr => a3
        lea     SetupStrGad02,a4        ;GadgetPtr => a4
        bsr     asl_dir_setup           ;Setup ausführen

        rts

*--------------------------------------

asl_blt_dir

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_blt_dir(a0),a2      ;KonfigPtr => a2
        lea     SetupStrGadPuffer03,a3  ;PufferPtr => a3
        lea     SetupStrGad03,a4        ;GadgetPtr => a4
        bsr     asl_dir_setup           ;Setup ausführen

        rts

*--------------------------------------

asl_doc_dir

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_doc_dir(a0),a2      ;KonfigPtr => a2
        lea     SetupStrGadPuffer04,a3  ;PufferPtr => a3
        lea     SetupStrGad04,a4        ;GadgetPtr => a4
        bsr     asl_dir_setup           ;Setup ausführen

        rts

*--------------------------------------

asl_mod_dir

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_mod_dir(a0),a2      ;KonfigPtr => a2

        movem.l a0-a1,-(a7)

        move.l  a2,a0                   ;zeige auf aktuellen DirEintrag
        move.l  _BufferPtr,a1           ;als Ablagepuffer benutzen
        bsr     string_kopieren         ;merken

        movem.l (a7)+,a0-a1

        lea     SetupStrGadPuffer05,a3  ;PufferPtr => a3
        lea     SetupStrGad05,a4        ;GadgetPtr => a4
        bsr     asl_dir_setup           ;Setup ausführen

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_mod_dir(a0),a0      ;zeige auf neuen DirEintrag
        move.l  _BufferPtr,a1           ;zeige auf den alten
        bsr     string_compare          ;vergleiche
        tst.l   d0                      ;identisch?
        beq.s   .ende                   ;ja

        move.w  #1,ModDirChanged        ;nein, geändert, Flag setzen
.ende
        rts

*--------------------------------------

asl_fd_dir

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_fd_dir(a0),a2       ;KonfigPtr => a2
        lea     SetupStrGadPuffer06,a3  ;PufferPtr => a3
        lea     SetupStrGad06,a4        ;GadgetPtr => a4
        bsr     asl_dir_setup           ;Setup ausführen

        rts

*--------------------------------------

asl_dir_setup

        move.w  #1,Setup_Flag

        move.l  a3,_fr_Dirname          ;Zeiger auf Directorynamen eintragen
        move.l  _BufferPtr,a0           ;zeige auf Puffer
        move.l  a0,_fr_Filename         ;keinen Filenamen, DummyPuffer angeben
        clr.l   (a0)                    ;evtl. Eintrag löschen
        move.l  #dirname_Text,ASLReqTitel ;setze Titel für ASLFileRequester
        bsr     asl_req_laden           ;FileRequester ausgeben
        tst.l   d0                      ;"Cancel" gewählt, oder DirectoryError!
        beq.s   .ende                   ;ja

        bsr     setup_aktualisieren
.ende
        clr.w   Setup_Flag
        rts

*--------------------------------------

asl_editor

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_editor(a0),a2       ;KonfigPtr => a2
        lea     SetupStrGadPuffer07,a3  ;PufferPtr => a3
        lea     SetupStrGad07,a4        ;GadgetPtr => a4
        bsr     asl_file_setup          ;Setup ausführen

        rts

*--------------------------------------

asl_viewer

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_viewer(a0),a2       ;KonfigPtr => a2
        lea     SetupStrGadPuffer08,a3  ;PufferPtr => a3
        lea     SetupStrGad08,a4        ;GadgetPtr => a4
        bsr     asl_file_setup          ;Setup ausführen

        rts

*--------------------------------------

asl_agdtool

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_agdtool(a0),a2      ;KonfigPtr => a2
        lea     SetupStrGadPuffer09,a3  ;PufferPtr => a3
        lea     SetupStrGad09,a4        ;GadgetPtr => a4
        bsr     asl_file_setup          ;Setup ausführen

        rts

*--------------------------------------

asl_fd2bmap

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_fdtobmap(a0),a2     ;KonfigPtr => a2
        lea     SetupStrGadPuffer10,a3  ;PufferPtr => a3
        lea     SetupStrGad10,a4        ;GadgetPtr => a4
        bsr     asl_file_setup          ;Setup ausführen

        rts

*--------------------------------------

asl_ab2ascii

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_abtoascii(a0),a2    ;KonfigPtr => a2
        lea     SetupStrGadPuffer11,a3  ;PufferPtr => a3
        lea     SetupStrGad11,a4        ;GadgetPtr => a4
        bsr     asl_file_setup          ;Setup ausführen

        rts

*--------------------------------------

asl_uppercacer

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_uppercacer(a0),a2   ;KonfigPtr => a2
        lea     SetupStrGadPuffer12,a3  ;PufferPtr => a3
        lea     SetupStrGad12,a4        ;GadgetPtr => a4
        bsr     asl_file_setup          ;Setup ausführen

        rts

*--------------------------------------

asl_calc

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_calc(a0),a2 ;KonfigPtr => a2
        lea     SetupStrGadPuffer13,a3  ;PufferPtr => a3
        lea     SetupStrGad13,a4        ;GadgetPtr => a4
        bsr     asl_file_setup          ;Setup ausführen

        rts

*--------------------------------------

asl_reqed

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_reqed(a0),a2        ;KonfigPtr => a2
        lea     SetupStrGadPuffer14,a3  ;PufferPtr => a3
        lea     SetupStrGad14,a4        ;GadgetPtr => a4
        bsr     asl_file_setup          ;Setup ausführen

        rts

*--------------------------------------

asl_util0

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_util_a(a0),a2       ;KonfigPtr => a2
        lea     SetupStrGadPuffer15,a3  ;PufferPtr => a3
        lea     SetupStrGad15,a4        ;GadgetPtr => a4
        bsr     asl_file_setup          ;Setup ausführen

        rts

*--------------------------------------

asl_util1

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_util_b(a0),a2       ;KonfigPtr => a2
        lea     SetupStrGadPuffer16,a3  ;PufferPtr => a3
        lea     SetupStrGad16,a4        ;GadgetPtr => a4
        bsr     asl_file_setup          ;Setup ausführen

        rts

*--------------------------------------

asl_util2

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_util_c(a0),a2       ;KonfigPtr => a2
        lea     SetupStrGadPuffer17,a3  ;PufferPtr => a3
        lea     SetupStrGad17,a4        ;GadgetPtr => a4
        bsr     asl_file_setup          ;Setup ausführen

        rts

*--------------------------------------

asl_util3

        move.l  _MemPtr,a0              ;zeige auf Speicher
        lea     new_util_d(a0),a2       ;KonfigPtr => a2
        lea     SetupStrGadPuffer18,a3  ;PufferPtr => a3
        lea     SetupStrGad18,a4        ;GadgetPtr => a4
        bsr     asl_file_setup          ;Setup ausführen

        rts

*--------------------------------------

asl_file_setup

        bsr     split_filename          ;in Dir- und Filenamen aufteilen

        move.l  #TempDir,_fr_Dirname    ;Zeiger auf Directorynamen eintragen
        move.l  #TempFile,_fr_Filename  ;Zeiger auf Filenamen eintragen
        move.l  #filename_Text,ASLReqTitel ;setze Titel für ASLFileRequester
        bsr     asl_req_laden           ;FileRequester ausgeben
        tst.l   d0                      ;"Cancel" gewählt, oder DirectoryError!
        beq.s   .ende                   ;ja

        tst.b   TempFile                ;Filename angegeben?
        beq.s   .ende                   ;nein, beenden

        bsr     setup_aktualisieren
.ende
        rts

*--------------------------------------

laengen_test

        movem.l d1/a0,-(a7)

        moveq   #80,d1                  ;nicht mehr als 80 Zeichen sind erlaubt!
        moveq   #0,d0                   ;Zählregister initialisieren

.loop
        addq    #1,d0                   ;Zählregister aufaddieren
        cmp.b   d1,d0                   ;80 Zeichen erreicht?
        beq.s   .fehler                 ;ja

        tst.b   (a0)+                   ;finde das NullByte
        bne.s   .loop                   ;noch nicht gefunden
.ok
        moveq   #0,d0                   ;melde ok
        bra.s   .ende                   ;und beenden
.fehler
        moveq   #-1,d0                  ;melde "zu lang"
.ende
        movem.l (a7)+,d1/a0
        rts

*--------------------------------------

setup_aktualisieren

        bsr     dateiname_besorgen      ;neuen Namen zusammensetzen

        lea     Dateiname,a0            ;zeige auf neuen Namen
        bsr     laengen_test            ;prüfe die Länge
        tst.l   d0                      ;welches Ergebnis?
        bmi.s   .ende                   ;zu lang!!
.loop
        tst.b   (a0)+
        bne.s   .loop

        cmpi.b  #"/",-2(a0)
        bne.s   .eintragen

        clr.b   -2(a0)

.eintragen

        lea     Dateiname,a0
        move.l  a2,a1                   ;zeige auf Konfiguration
        bsr     string_kopieren         ;und eintragen

        lea     Dateiname,a0            ;dto. für GadgetPuffer
        move.l  a3,a1
        bsr     string_kopieren

        move.l  a4,a0                   ;GadgetPtr => a0
        move.l  _SetupWinPtr,a1         ;WindowPtr => a1
        moveq   #1,d0                   ;1 Gadget
        bsr     refresh_g_list          ;auffrischen
.ende
        rts

*--------------------------------------

set_pubscreen

        move.l  d1,ScreenFlag           ;Flag setzen und merken
        move.l  d1,screen_flag(a2)

        rts

*--------------------------------------

set_requester

        move.l  d1,RequesterFlag        ;dto.
        move.l  d1,requester_flag(a2)

        rts

*--------------------------------------

set_cleanup

        move.l  d1,CleanUpFlag          ;dto.
        move.l  d1,clean_up_flag(a2)

        rts

*--------------------------------------

set_menupen

        move.l  d1,MenuPen              ;dto.
        move.l  d1,menu_pen(a2)

        rts

*--------------------------------------

teste_auf_string_gadget

        cmpi.l  #$20,d4                 ;GadgetDown Event?
        bne.s   .abbruch                ;nein

        cmpi.l  #21,d0                  ;ID kleiner als 22?
        ble     .abbruch                ;ja, kein StringGadget gewesen

        move.l  a0,_StrGadAktiv         ;GadgetPtr merken
        bsr     activate_gadget         ;und aktivieren
        moveq   #-1,d0                  ;melde "Abbrechen"

.abbruch
        rts

*--------------------------------------
* pruefe_auf_strgad_aktiv
*
* kein Übergaberegister
*
* => Label.l = StrGad_aktiv_gewesen = 0 = nein, <> 0 = ja
*--------------------------------------

pruefe_auf_strgad_aktiv

        tst.l   _StrGadAktiv            ;StringGadgetEingabe aktiviert gewesen ?
        beq.s   .abbruch                ;nein

.bearbeiten

        movem.l d0-d7/a0-a6,-(a7)

        move.l  _StrGadAktiv,a0         ;Zeiger auf GadgetStruktur => a0
        clr.l   _StrGadAktiv            ;und löschen, als bearbeitet markieren
        move.w  gg_GadgetID(a0),d0      ;GadgetID => d0
        move.w  gg_Flags(a0),d2         ;Flags => d2
        move.l  gg_SpecialInfo(a0),d3   ;Zeiger auf SpecialInfo => d3

        move.l  _MemPtr,a2              ;zeige auf Konfigurationsdaten

        lsl     #2,d0                   ; * 4 da long
        lea     tabelle_setup_uprge,a1  ;zeige auf Tabelle
        move.l  0(a1,d0),a1             ;addiere Offset

        jsr     (a1)                    ;Unterprogramm ausführen

        move.w  #1,Config_geaendert     ;Flag setzen
        movem.l (a7)+,d0-d7/a0-a6
.abbruch
        rts
*--------------------------------------

ModDirChanged   dc.w    0
Setup_Flag      dc.w    0
_StrGadAktiv    dc.l    0

*--------------------------------------
DirSetup_Titel_Text
                dc.b    " Directory Setup ",0
                even
*--------------------------------------
NewSrcDir_Titel_Text
                dc.b    " Source Dir",0
                even
*--------------------------------------
NewTmpDir_Titel_Text
                dc.b    " Temp Dir ",0
                even
*--------------------------------------
NewBltDir_Titel_Text
                dc.b    " Built Dir ",0
                even
*--------------------------------------
NewDocDir_Titel_Text
                dc.b    " Doc Dir ",0
                even
*--------------------------------------
NewModDir_Titel_Text
                dc.b    " SUBMod Dir ",0
                even
*--------------------------------------
NewFDDir_Titel_Text
                dc.b    " FD Dir ",0
                even
*--------------------------------------
NewEditor_Titel_Text
                dc.b    " Editor ",0
                even
*--------------------------------------
NewViewer_Titel_Text
                dc.b    " Viewer ",0
                even
*--------------------------------------
NewAGD_Titel_Text
                dc.b    " Amigaguide ",0
                even
*--------------------------------------
NewFD2BMAP_Titel_Text
                dc.b    " FD -> BMAP ",0
                even
*--------------------------------------
NewAB2ASCII_Titel_Text
                dc.b    " AmigaBASIC -> ASCII ",0
                even
*--------------------------------------
NewUppercACEr_Titel_Text
                dc.b    " UppercACEr ",0
                even
*--------------------------------------
NewCalc_Titel_Text
                dc.b    " Calculator ",0
                even
*--------------------------------------
NewReqEd_Titel_Text
                dc.b    " ReqEd ",0
                even
*--------------------------------------
NewUtil0_Titel_Text
                dc.b    " Utility 0 ",0
                even
*--------------------------------------
NewUtil1_Titel_Text
                dc.b    " Utility 1 ",0
                even
*--------------------------------------
NewUtil2_Titel_Text
                dc.b    " Utility 2 ",0
                even
*--------------------------------------
NewUtil3_Titel_Text
                dc.b    " Utility 3 ",0
                even
*--------------------------------------
R_Text          dc.b    "R",0
                even
*--------------------------------------
Other_Text      dc.b    " Other ",0
                even

PubScreen_Text1 dc.b    " Public ",0
                even
PubScreen_Text2
                dc.b    " Screen ",0
                even
*--------------------------------------
ReqSet_Text     dc.b    "Requester",0
                even

All_Text        dc.b    "All",0
                even
Error_Text      dc.b    "Error",0
                even
Min_Text        dc.b    "Min",0
                even

Cleanup_Text    dc.b    "Clean up",0
                even
Menupen_Text
                dc.b    "Menu Pen",0
                even

Null_Text       dc.b    "0",0
                even
Eins_Text       dc.b    "1",0
                even
Zwei_Text       dc.b    "2",0
                even
*--------------------------------------
SetupTextTable

                dc.l    DirSetup_Titel_Text

                dc.l    NewSrcDir_Titel_Text
                dc.l    NewTmpDir_Titel_Text
                dc.l    NewBltDir_Titel_Text
                dc.l    NewDocDir_Titel_Text
                dc.l    NewModDir_Titel_Text
                dc.l    NewFDDir_Titel_Text

                dc.l    NewEditor_Titel_Text
                dc.l    NewViewer_Titel_Text
                dc.l    NewAGD_Titel_Text
                dc.l    NewFD2BMAP_Titel_Text
                dc.l    NewAB2ASCII_Titel_Text
                dc.l    NewUppercACEr_Titel_Text

                dc.l    NewCalc_Titel_Text
                dc.l    NewReqEd_Titel_Text
                dc.l    NewUtil0_Titel_Text
                dc.l    NewUtil1_Titel_Text
                dc.l    NewUtil2_Titel_Text
                dc.l    NewUtil3_Titel_Text

                dc.l    Other_Text

                dc.l    PubScreen_Text1
                dc.l    PubScreen_Text2
                dc.l    ReqSet_Text
                dc.l    Cleanup_Text
                dc.l    Menupen_Text

*--------------------------------------
_Yes_No_Texte   dc.l    text_no
                dc.l    text_yes
                dc.l    0
*--------------------------------------
_ReqGadTexte    dc.l    All_Text
                dc.l    Error_Text
                dc.l    Min_Text
                dc.l    0
*--------------------------------------
_MenuPenGadTexte
                dc.l    Null_Text
                dc.l    Eins_Text
                dc.l    Zwei_Text
                dc.l    0
*--------------------------------------

