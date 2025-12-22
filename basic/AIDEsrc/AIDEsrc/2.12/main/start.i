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
* Programmstart ©
*--------------------------------------

hauptprogramm

* Libraries öffnen
*-----------------

        movem.l d0-d7/a0-a6,-(a7)       ;alle Register retten

        move.l  a1,_eigenerTask         ;Adresse merken

        lea     intname,a1              ;zeige auf Library-Namen
        moveq.l #0,d0                   ;keinen TextPtr, muss gesondert
                                        ;behandelt werden
        bsr     open_library            ;öffnen
        move.l  d0,_IntuitionBase       ;Zeiger merken, geklappt ?
        bne.s   open_mrt_library        ;ja

        bsr     wrong_system_version    ;Meldung ausgeben
        bra     exit_aide               ;und beenden

open_mrt_library
        lea     mrtname,a1              ;zeige auf Library-Namen
        moveq   #0,d0                   ;keinen TextPtr, muss gesondert
                                        ;behandelt werden
        bsr     open_library            ;öffnen
        move.l  d0,_MRTBase             ;merken, geklappt?
        bne     open_gfx                ;ja

        bsr     mrt_library_not_opened  ;Meldung ausgeben
        bra     exit_aide               ;und beenden

open_gfx
        lea     graphname,a1            ;jetzt V36 Requester ausgeben
        move.l  #text_gfxlib,d0
        bsr     open_library
        move.l  d0,_GfxBase
        beq     beenden

        lea     wbname,a1
        move.l  #text_wblib,d0
        bsr     open_library
        move.l  d0,_WBBase
        beq     beenden

        lea     dosname,a1              ;dto.
        move.l  #text_doslib,d0
        bsr     open_library
        move.l  d0,_DOSBase
        beq     beenden

        lea     aslname,a1              ;dto.
        move.l  #text_asllib,d0
        bsr     open_library
        move.l  d0,_AslBase
        beq     beenden

        lea     utilityname,a1          ;dto.
        move.l  #text_utillib,d0
        bsr     open_library
        move.l  d0,_UtilityBase
        beq     beenden

        lea     gadtoolsname,a1         ;dto.
        move.l  #text_gadtoolslib,d0
        bsr     open_library
        move.l  d0,_GadToolsBase
        beq     beenden

        lea     diskfontname,a1         ;dto.
        move.l  #text_diskfontlib,d0
        bsr     open_library
        move.l  d0,_DiskfontBase
        beq     beenden

        lea     iconname,a1             ;dto.
        move.l  #text_iconlib,d0
        bsr     open_library
        move.l  d0,_IconBase
        beq     beenden

* System DOS-Fehlermeldungen abschalten
*--------------------------------------
        move.l  _eigenerTask,a1         ;Zeiger auf Task => a1
        move.l  #-1,pr_WindowPtr(a1)    ;trage -1 ein
                                        ;= keine Meldungen gewünscht

* prüfe, ob ACE und AIDE richtig installiert sind
*------------------------------------------------
env_check
        bsr     check_environment
        tst.l   d0                      ;alles ok?
        bmi     beenden                 ;nein

* Speicher für ConfigFile reservieren
*------------------------------------
        move.l  #MemSize,d0             ;Größe => d0
        move.l  #MEMF_ANY!MEMF_CLEAR!MEMF_LARGEST,d1
        bsr     alloc_vec               ;reservieren
        move.l  d0,_MemPtr              ;merken, geklappt?
        bne.s   puffer_markieren        ;ja

        bsr     not_enough_start_mem    ;nein, Meldung ausgeben
        bra     beenden                 ;und beenden

* Kommando Puffer markieren
*--------------------------
puffer_markieren
        add.l   #BufferSize,d0          ;die Hälfte davon
        move.l  d0,_BufferPtr           ;als KommandoPuffer benutzen

* evtl. WbArgs auslesen
*----------------------

        tst.l   _WbenchMsg              ;Zeiger vorhanden, WBStart?
        beq.s   config_laden            ;nein

        bsr     get_start_wb_args       ;evtl. WbArgs vom Start auslesen
        bsr     set_start_source_tooltypes
                                        ;und setzen
* ConfigFile laden
*-----------------
        tst.w   Config_loaded           ;ConfigFile von WbArgs schon geladen?
        bne.s   font_laden              ;ja

config_laden
        moveq.l #0,d1                   ;default Name verwenden
        bsr     load_start_config       ;Konfiguration laden und Werte setzen

* Font laden
*-----------
font_laden
        move.l  _FontAttrPtr,a0         ;zeige auf TextAttrStruktur
        move.l  (a0),d3                 ;Zeiger auf den Namen => d3
        bsr     load_font               ;Font laden
        move.l  d0,_FontPtr             ;merken, geklappt?
        beq     beenden                 ;nein

        move.l  d0,ExStrGadStr          ;FontPtr eintragen

* Array aller vorhandenen SUBModule anlegen
*------------------------------------------
        move.l  _MemPtr,a0              ;zeige auf Konfiguration
        lea     new_mod_dir(a0),a0      ;zeige auf Directoryeintrag
        tst.b   (a0)                    ;Eintrag vorhanden?
        beq.s   msg_port                ;nein

        move.l  a0,d1                   ;in d1 übergeben
        bsr     available_module_array  ;Array anlegen

* MsgPort anlegen
*----------------
msg_port
        moveq.l #0,d0                   ;Pri = 0
        sub.l   a0,a0                   ;kein Name erforderlich
        bsr     create_msg_port         ;anfordern
        move.l  d0,_WinMsgPort          ;merken, geklappt?
        beq     beenden                 ;nein

* Screen öffnen
*--------------
        tst.l   ScreenFlag              ;Screen gewählt?
        beq.s   workbench               ;nein Workbench

        bsr     screen_oeffnen          ;Screen öffnen
        tst.l   d0                      ;alles klar?
        bmi     beenden                 ;nein

        bra.s   visual_info_eintragen   ;ja, Daten eintragen

* VisualInfo_WB besorgen
*-----------------------
workbench

        bsr     get_workbench_data      ;Daten besorgen
        tst.l   d0                      ;alles klar?
        bmi     beenden                 ;nein

* Font und Visual Info eintragen
*-------------------------------
visual_info_eintragen

        lea     NewGad,a1               ;zeige auf NewGadgetStruktur
        move.l  _VInfo,gng_VisualInfo(a1)
                                        ;Zeiger auf VisualInfoStruktur eintragen
        move.l  _FontAttrPtr,gng_TextAttr(a1)
                                        ;Zeiger auf Font eintragen

        lea     Ausgabe_Ts,a1           ;IntuiTextStrPtr => a1
        move.l  _FontAttrPtr,it_ITextFont(a1)
                                        ;FontPtr eintragen
* Hauptwindow öffnen
*-------------------
        bsr     open_main_win           ;öffnen und Image darstellen
        tst.l   d0                      ;alles klar?
        beq     beenden                 ;nein

* Icon laden
*-----------

        move.l  #default_aide_path,a0
        move.l  _IconBase,a6
        jsr     _LVOGetDiskObjectNew(a6)
        move.l  d0,_icondat

* Window-Port beim Start aktivieren
*----------------------------------
        move.l  _MainWinPtr,a0          ;zeige auf Window
        move.l  MainWinIDCMP,d0         ;Flags      => d0
        move.l  _WinMsgPort,a1          ;MsgPortPtr => a1
        bsr     modify_idcmp            ;aktivieren

* TempDir als CurrentDir setzen
*------------------------------
        bsr     set_current_program_dir ;temporäres ACE-Dir als
                                        ;"current" anmelden

* Daten in SpecialInfoStruktur eintragen
*---------------------------------------
*       bsr     setup_stringgads_einstellen

* Screen nach vorne bringen
*--------------------------
        tst.l   _ScrnPtr                ;Screen geöffnet?
        beq.s   events                  ;nein, Events abwarten

        bsr     set_pubscreen_mode      ;PubScreen einstellen

        move.l  _ScrnPtr,a0             ;ja
        bsr     screen_to_front         ;Screen nach vorne bringen

* Unterprogramm Steuerung ausführen
*----------------------------------
events
        bsr     steuerung               ;was macht der Anwender?

* Unterprogramm hprg_ende ausführen
*----------------------------------
beenden
        bsr     hprg_ende               ;alles wieder schließen und entfernen

exit_aide
        movem.l (a7)+,d0-d7/a0-a6       ;alle Register wieder herstellen

        moveq.l #0,d0                   ;ReturnCode = 0
        rts                             ;Rücksprung
*--------------------------------------
