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
* open_msg_win
*
* >= d0.l = GadgetListPtr
* >= d1.w = LeftEdge
* >= d2.w = TopEdge
* >= d3.w = Width
* >= d4.w = Height
* >= d5.l = WindowFlags
* >= d6.l = IDCMPFlags
* >= d7.l = WindowTitel
*
* => d0.l <> 0 = alles ok = 0 dann Fenster nicht geöffnet
*--------------------------------------

open_msg_win

        movem.l d1-d2/a0-a2,-(a7)

        lea     _NewWindow,a0           ;zeige auf NewWindowStruktur
        move.l  d0,nw_FirstGadget(a0)   ;Daten eintragen
        move.w  d1,nw_LeftEdge(a0)
        move.w  d2,nw_TopEdge(a0)
        move.w  d3,nw_Width(a0)
        move.w  d4,nw_Height(a0)
        move.l  d5,nw_Flags(a0)

        tst.l   ScreenFlag              ;eigener Screen?
        beq.s   .wb_win                 ;nein

        move.w  #2,nw_Type(a0)          ;PublicScreen eintragen
        bra.s   .oeffnen                ;und öffnen
.wb_win
        move.w  #1,nw_Type(a0)          ;WbScreen eintragen

.oeffnen
        bsr     open_window             ;öffne Window
        move.l  d0,_MsgWinPtr           ;merken, geklappt?
        beq     .ende                   ;nein

        move.l  d0,a0                   ;zum RastPort holen => a0
        move.l  wd_RPort(a0),_MsgWinRPort ;merken

        move.l  wd_RPort(a0),a1         ;RastPortPtr => a1
        move.l  _FontPtr,a0             ;FontPtr     => a0
        bsr     set_font                ;Thinpaz.font setzen

        move.l  _MsgWinPtr,a0           ;WindowPtr => a0
        Locale  d7,a1                   ;Zeiger auf Titel => a1
        move.l  #-1,a2                  ;keine Änderung im ScreenTitel
        bsr     set_win_titles          ;und ausführen

        move.l  d6,d0                   ;IDCMPFlags => d0
        move.l  _WinMsgPort,a1          ;MsgPortPtr => a1
        bsr     modify_idcmp            ;aktivieren

        move.l  _MsgWinRPort,a0         ;RastPortPtr => a0
        lea     BorderTags,a1           ;TagItems    => a1
        move.l  _VInfo,4(a1)            ;VisualInfo eintragen
        move.l  #GTBB_Recessed,8(a1)    ;recessed Border ausgeben

        move    #002,d0                 ;LeftEdge
        move    #002,d1                 ;TopEdge
        move    d3,d2
        subi.w  #12,d2                  ;berechne die Breite
        move    d4,d3
        subi.w  #17,d3                  ;berechne die Höhe
        bsr     draw_bevel_box_a        ;ausgeben

.ende
        movem.l (a7)+,d1-d2/a0-a2
        rts

*--------------------------------------
* msg_win_msg
*
* >= d1.l = Flag (0 = ohne Wait/ 1 = mit Wait)
*
* zurückgegeben wird:
*
* => d0.l = im_Class
* => d1.l = im_Code
* => d2.l = im_Qualifier
* => d3.l = im_IAddress
* => d4.l = im_MouseX
* => d5.l = im_MouseY
*--------------------------------------

msg_win_msg

        movem.l d6/a0,-(a7)

        move.l  d1,d6                   ;Flag merken
.msg
        move.l  d6,d1                   ;Flag übergeben
        move.l  _WinMsgPort,a0          ;MsgPortPtr ins Übergaberegister
        bsr     gt_win_event            ;Ereignis besorgen

        btst    #2,d0                   ;RefreshWindow?
        beq.s   .ende                   ;nein, beenden, Msg zurückgeben

        move.l  _MsgWinPtr,a0           ;ja, auffrischen
        bsr     gt_begin_refresh
        bsr     gt_end_refresh
        bra.s   .msg                    ;und auf nächstes Ereignis warten
.ende
        movem.l (a7)+,d6/a0
        rts

*--------------------------------------
* close_msg_win
*
* >= a1.l = GadgetListPtr
*
* kein Rückgaberegister
*--------------------------------------

close_msg_win

        movem.l d0-d1/a0,-(a7)

        move.l  _MsgWinPtr,a0           ;WindowPtr => a0

        cmp.l   #0,a1                   ;Zeiger angegeben?
        beq.s   .close                  ;nein

        moveq.l #-1,d0                  ;alle Gadgets
        bsr     remove_g_list           ;entfernen

.close
        bsr     close_window_safely     ;Window schließen
        clr.l   _MsgWinPtr              ;Zeiger löschen

        movem.l (a7)+,d0-d1/a0
        rts

*--------------------------------------
* input_window
*
* kein Übergabegaberegister
*
* => d0.l <> 0 = alles ok = 0 dann Fenster nicht geöffnet
*--------------------------------------

input_window

        movem.l d1-d7/a0-a1,-(a7)

        lea     StrGad,a0               ;GadgetPtr => a0
        move.l  #000,gg_NextGadget(a0)  ;kein weiteres Gadget
        move.w  #010,gg_LeftEdge(a0)    ;Position eintragen
        move.w  #023,gg_TopEdge(a0)
        move.w  #200,gg_Width(a0)
        move.w  #008,gg_Height(a0)
        move.w  #$600,gg_Flags(a0)
        move.w  #$003,gg_Activation(a0)  ;ActivationFlags eintragen
        move.l  a0,d0                   ;GadgePtr in d0 übergeben

        move.l  _MainWinPtr,a0          ;hole dir die Fensterposition

        move.w  wd_LeftEdge(a0),d1      ;aktuellen Wert => d0
        addi.w  #174,d1                 ;berechne die neue Fensterposition

        move.w  wd_TopEdge(a0),d2
        addi.w  #078,d2
        move.w  #229,d3
        move.w  #054,d4
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
        move    #019,d1                 ;TopEdge
        move    #209,d2                 ;Width
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
.ende
        movem.l (a7)+,d1-d7/a0-a1
        rts

*--------------------------------------

cmd_string_eingabe_win

        lea     StrGadInfo,a0           ;Zeige auf StringInfoStruktur
        move.w  #255,$A(a0)             ;max. 254 Zeichen zulassen

        clr.l   Eingabe                 ;alten Inhalt löschen

        bsr     input_window            ;öffne Input Window
        tst.l   d0                      ;geklappt?
        beq     .ende                   ;nein

        move.l  _MsgWinRPort,a0         ;RastPortPtr     => a0
        lea     Ausgabe_Ts,a1           ;IntuiTextStrPtr => a1

        move.b  #01,(a1)                ;foreground color
        move.b  #00,1(a1)               ;background color
        moveq   #0,d0                   ;left aligned
        move.w  #7,4(a1)              ;left edge
        move.w  #08,6(a1)               ;top edge
        move.l  #IDCmd_Line_Text,12(a1)
        bsr     print_locale            ;ausgeben

        moveq   #1,d1                   ;mit Wait()
        bsr     msg_win_msg             ;warte auf Message

        btst    #9,d0                   ;WindowClose gewählt ?
        bne.s   .close                  ;ja, keine Argumente

        move.l  a2,a1                   ;Stringende wieder => a1
        move.b  #" ",(a1)+              ;NullByte mit Space überschreiben
        lea     Eingabe,a0              ;zeige auf die Argumente
        bsr     string_kopieren         ;und eintragen
.close
        lea     StrGad,a1               ;GadgetPtr übergeben
        bsr     close_msg_win           ;schließen
.ende
        rts

*--------------------------------------

execute_prg_win

        lea     StrGadInfo,a0           ;Zeige auf StringInfoStruktur
        move.w  #255,$A(a0)             ;max. 254 Zeichen zulassen

        clr.l   Eingabe                 ;alten Inhalt löschen

        bsr     input_window            ;öffne Input Window
        tst.l   d0                      ;geklappt?
        beq     .ende                   ;nein

        move.l  _MsgWinRPort,a0         ;RastPortPtr     => a0
        lea     Ausgabe_Ts,a1           ;IntuiTextStrPtr => a1

        move.b  #01,(a1)                ;foreground color
        move.b  #00,1(a1)               ;background color
        moveq   #0,d0
        move.w  #7,4(a1)               ;left edge
        move.w  #08,6(a1)               ;top edge
        move.l  #IDExec_Prg_Text,12(a1)
        bsr     print_locale            ;ausgeben

        moveq   #1,d1                   ;mit Wait()
        bsr     msg_win_msg             ;warte auf Message

        btst    #9,d0                   ;WindowClose gewählt ?
        bne.s   .close                  ;ja, keine Argumente

        move.l  _BufferPtr,a1           ;zeige auf KommandoPuffer
        lea     Eingabe,a0              ;zeige auf die KommandoString
        bsr     string_kopieren         ;und eintragen
.close
        lea     StrGad,a1               ;GadgetPtr übergeben
        bsr     close_msg_win           ;schließen
.ende
        rts

*--------------------------------------
