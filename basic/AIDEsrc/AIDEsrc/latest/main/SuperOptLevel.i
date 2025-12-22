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

*-----------------
* SuperOptLevel.i
*-----------------

; This file allows to enter the codes for the new superoptimizer.
; Furthermore it contains routines to transform the superopt settings
; into CLI parameters.

set_superopt_level

        cmp.l   #0,SOptVersion          ; welche Version benutzen wir?
        bgt.s   .neueversion

        bra     set_level               ; aha, die 1.x
        bra.s   .ende

.neueversion
        bsr     open_sopt_win           ; Window öffnen
        tst.l   d0                      ; offen?
        beq.s   .ende                   ; nein ;-(

        bsr     SOpt_beschriften        ; Beschriftung ausgeben
        bsr     superopt_events         ; behandle events
        bsr     CloseSOptWin            ; und fertig

.ende
        rts

*******************


CloseSOptWin

        move.l  a0,-(a7)

        move.l  _SOptWinPtr,a0          ;WindowPtr => a0
        bsr     close_window_safely     ;schließen

        move.l  _SOptGadList,a0         ;GadgetListPtr => a0
        bsr     free_gt_gadgets         ;freigeben
        clr.l   _SOptGadList            ;Zeiger löschen

        move.l  (a7)+,a0
        rts

*-------------------------

open_sopt_win

* GadgetStrukturen anlegen
*-------------------------
        tst.l   _SOptGadList            ;Gadgets schon vorhanden?
        bne.s   .window                 ;ja

        bsr     create_gadgets_superopt
        tst.l   d0                      ;alles ok?
        beq     .ende                   ;nein

.window
        lea     _NewWindow,a0           ;zeige auf WindowStruktur

        move.w  MainWinLeftEdge,nw_LeftEdge(a0)
        move.w  MainWinTopEdge,nw_TopEdge(a0)
        move.w  MainWinWidth,nw_Width(a0)
        move.w  MainWinHeight,nw_Height(a0)
        move.l  SOptWinFlags,nw_Flags(a0)
        move.l  _SOptGadList,nw_FirstGadget(a0)

        tst.l   _ScrnPtr                ;eigener Screen?
        beq.s   .wb_win                 ;nein

        move.w  #2,nw_Type(a0)          ;PublicScreen eintragen
        bra.s   .oeffnen                ;und öffnen

.wb_win
        move.w  #1,nw_Type(a0)          ;WbScreen eintragen

.oeffnen
        bsr     open_window             ;öffne Window
        move.l  d0,_SOptWinPtr          ;Adresse sichern
        beq     .ende                   ;nicht geöffnet

        move.l  d0,a0                   ;WindowPtr => a0
        move.l  wd_RPort(a0),_SOptWinRastPort
                                        ;merken
* Font setzen
*------------
        move.l  wd_RPort(a0),a1         ;RastPortPtr => a1
        move.l  _FontPtr,a0             ;FontPtr     => a0
        bsr     set_font                ;Font setzen

        move.l  _SOptWinPtr,a0          ;WindowPtr   => a0
        bsr     gt_refresh_window       ;Fenster auffrischen

* Fenster Titel ausgeben
*-----------------------
        Locale  #ID_SOptWinTitle,a1     ;Zeiger auf Titel eintragen
        move.l  #-1,a2                  ;keine Änderung im ScreenTitel
        bsr     set_win_titles          ;und ausführen

        move.l  SOptWinIDCMP,d0         ;Flags      => d0
        move.l  _WinMsgPort,a1          ;MsgPortPtr => a1
        bsr     modify_idcmp            ;aktivieren

* Bevelboxen ausgeben
*--------------------

        lea     BorderTags,a1
        move.l  _VInfo,4(a1)
        move.l  #GTBB_Recessed,8(a1)

        move.l  _SOptWinRastPort,a0
        move.l  #13,d0
        move.l  #20,d1
        move.l  #550,d2
        move.l  #117,d3
        bsr     draw_bevel_box_a

        moveq   #1,d0                   ;melde "alles OK"

.ende
        rts

**************************

superopt_events

        moveq.l #0,d0                   ;nur auf Userport reagieren
        moveq.l #1,d1                   ;mit Wait()
        move.l  _WinMsgPort,a0          ;Zeiger auf MsgPort => a0

        bsr     gt_win_event            ;Ereignis besorgen

        bsr     sopt_sperren            ;keine weiteren Ereignisse zugelassen

        btst    #2,d0                   ;RefreshWindow?
        beq.s   .buttons                ;nein

        move.l  _SOptWinPtr,a0          ;ja, auffrischen
        bsr     gt_begin_refresh
        bsr     gt_end_refresh
        bra.s   .loop

.buttons
        btst    #9,d0                   ;WindowClose?
        bne.s   .ende                   ;ja

.gadgetup
        btst    #6,d0                   ;GadgetUp?
        beq.s   .gadgetdown             ;nein

        bsr     react_on_sopt_gadget  ;ja, auswerten
        bra.s   .loop                   ;auf neues Ereignis warten

.gadgetdown
        btst    #5,d0                   ;GadgetDown?
        beq.s   .loop                   ;nein

        bsr     react_on_sopt_gadget    ;ja, auswerten

.loop
        bsr     sopt_freigeben          ;Ereignisse wieder zulassen
        bra.s   superopt_events
.ende
        rts

*--------------------------------------

react_on_sopt_gadget

        move.l  d3,a0                   ;Zeiger auf GadgetStruktur => a0
        move.w  gg_GadgetID(a0),d0      ;GadgetID => d0
        move.w  gg_Flags(a0),d2         ;Flags => d2
        move.w  gg_SpecialInfo(a0),d3   ;Zeiger auf SpecialInfo => d3

.checkboxes
        cmp.w   #16,d0
        bgt.s   .buttons

        move.w  #16,d1
        sub.w   d0,d1
        lea     SOptLevel,a0

        bsr     bit_aendern

        move.l  _MemPtr,a0
        move.l  SOptLevel,superopt_level(a0)
        move.w  #1,Config_geaendert

        bra.s   .end

.buttons

        sub.l   #17,d0                  ; Buttonnummer berechnen
        lsl.l   #2,d0                   ; Offset berechnen
        move.l  SOptLevel,d1            ; jetzige Werte
        andi.l  #$FF000000,d1           ; löschen
        lea     SOptAbbr,a3             ; gewünschte Werte holen
        move.l  0(a3,d0),d2             ; Wert holen
        or.l    d2,d1                   ; verknüpfen
        move.l  d1,SOptLevel
        move.l  _MemPtr,a0
        move.l  d1,superopt_level(a0)   ; eintragen

        bsr     update_SOpt

.end
        rts

*--------------------------------------

set_level

        movem.l d0-d7/a0-a1,-(a7)

        lea     Eingabe,a0              ;zeige auf EingabePuffer
        clr.l   (a0)                    ;Inhalt löschen
        clr.l   d0                      ;Register löschen
        move.l  SOptLevel,d0            ;Wert => d0
        andi.l  #$ff000000,d0           ;Bitmaske auflegen
        swap    d0                      ;swap words
        divu.w  #$100,d0                ;move 3rd byte to 4th byte
        moveq.l #0,d1                   ;kein weiterer Offset
        moveq.l #2,d2                   ;keine führende Nullen
        bsr     hex_to_dez_ascii        ;wandeln und eintragen

        lea     StrGadInfo,a0           ;Zeige auf StringInfoStruktur
        move.w  #3,$A(a0)               ;nur 3 Zeichen zulassen

        lea     StrGad,a0               ;GadgetPtr => a0
        move.l  #000,gg_NextGadget(a0)  ;kein weiteres Gadget
        move.w  #010,gg_LeftEdge(a0)    ;Position eintragen
        move.w  #010,gg_TopEdge(a0)
        move.w  #104,gg_Width(a0)
        move.w  #008,gg_Height(a0)
        move.w  #$600,gg_Flags(a0)
        move.w  #$803,gg_Activation(a0) ;ActivationFlags eintragen
        move.l  a0,d0                   ;GadgePtr in d0 übergeben

        move.l  _MainWinPtr,a0          ;hole dir die Fensterposition
        move.w  wd_LeftEdge(a0),d1      ;aktuellen Wert => d0
        addi.w  #120,d1                 ;berechne die neue Fensterposition
        move.w  wd_TopEdge(a0),d2
        addi.w  #148,d2
        move.w  #132,d3
        move.w  #041,d4
        move.l  MsgWinFlags,d5          ;weitere Daten übergeben
        move.l  MsgWinIDCMP,d6
        move.l  #ID_InputWinTitle,d7

        bsr     open_msg_win            ;Fenster öffnen
        tst.l   d0                      ;alles klar?
        beq     .ende                   ;nein

        move.l  _MsgWinRPort,a0         ;RastPortPtr => a0
        lea     BorderTags,a1           ;TagItems    => a1
        move.l  _VInfo,4(a1)            ;VisualInfo eintragen
        move.l  #0,8(a1)                ;normalen Border ausgeben

        move    #006,d0                 ;LeftEdge
        move    #006,d1                 ;TopEdge
        move    #112,d2                 ;Width
        move    #016,d3                 ;Height
        bsr     draw_bevel_box_a        ;ausgeben

        move.l  #GTBB_Recessed,8(a1)    ;recessed Border ausgeben
        addq    #1,d0
        addq    #1,d1
        subq    #2,d2
        subq    #2,d3
        bsr     draw_bevel_box_a        ;ausgeben

        lea     StrGad,a0               ;GadgetPtr => a0
        move.l  _MsgWinPtr,a1           ;zeige auf Window
        bsr     activate_gadget         ;und aktivieren
.message
        moveq   #1,d1                   ;mit Wait()
        bsr     msg_win_msg             ;warte auf Message

        btst    #9,d0                   ;WindowClose gewaehlt ?
        bne.s   .close                  ;ja

        lea     StrGadInfo,a0           ;zeige auf StrGadInfoStruktur
        move.l  $1C(a0),d0              ;Wert => d0
        tst.l   d0                      ;= NULL?
        beq.s   .warnung                ;ja

        cmpi.b  #12,d0                  ;wie groß?
        ble.s   .eintragen              ;kleiner gleich 12, dann in Ordnung

.warnung
        tst.l   _ScrnPtr                ;Screen offen?
        beq.s   .workbench              ;nein, Workbench

        move.l  _ScrnPtr,a0             ;zeige auf Screen
        bra.s   .beep

.workbench
        move.l  _WBScreen,a0            ;zeige auf WBScreen

.beep
        bsr     display_beep            ;Fehleingabe kenntlich machen
        bra.s   .message                ;auf die richtige Eingabe warten

.eintragen
        mulu.w  #$100,d0
        swap    d0                      ;3th byte to 1st byte
        andi.l  #$00FFFFFF,SOptLevel    ;erase old value
        or.l    d0,SOptLevel            ;Wert verknüpfen und eintragen

        move.l  _MemPtr,a0              ;zeige auf Konfiguration
        move.l  SOptLevel,superopt_level(a0)   ;eintragen

        move.w  #1,Config_geaendert     ;merke, Konfiguration wurde geändert
.close
        lea     StrGad,a1               ;GadgetPtr übergeben
        bsr     close_msg_win           ;schließen
.ende
        movem.l (a7)+,d0-d7/a0-a1
        rts

*--------

update_SOpt

        movem.l d0-d1/a0-a4,-(a7)

        lea     CheckBoxTags,a2         ;TagItems  => a2
        move.l  a2,a3                   ;zur Bearbeitung => a3

        moveq   #0,d0                   ;Offset auf GadgetZeiger => d0
        moveq   #16,d2                  ;Bittestregister initialisieren

        move.l  _SOptWinPtr,a1          ;WindowPtr => a1
        lea     _Gadget_Ptr_SOptWin,a4  ;zeige auf Zeigerablage

        bsr     sopt_gadgets_freigeben

.loop
        bsr     get_sopt_options        ;einstellen

        move.l  0(a4,d0),a0             ;GadgetPtr => a0

        bsr     gt_set_gadget_attrs_a

        addq    #4,d0                   ;Zeigeroffest erhöhen
        dbra    d2,.loop                ;Bittestregister erniedrigen

        bsr     sopt_gadgets_sperren
        move.w  #1,Config_geaendert

        movem.l (a7)+,d0-d1/a0-a4
        rts
