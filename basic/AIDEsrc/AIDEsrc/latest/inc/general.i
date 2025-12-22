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

screen_oeffnen

        bsr     alloc_signal            ;Signal besorgen
        move.l  d0,ScreenSignal         ;merken, alles okay?
        bmi     .ende                   ;nein

        move.l  d0,SigNummer            ;ja, für den Screen verwenden

        lea     _ScreenTags,a1          ;zeige auf TagItems
        move.l  4(a1),d0
        bsr     GetString
        move.l  a0,4(a1)                ;translate ScreenTitle

        bsr     open_screen_tag_list    ;Screen öffnen
        move.l  d0,_ScrnPtr             ;merken, geklappt?
        bne.s   .rastport               ;ja

        bsr     screen_open_error       ;Fehlermeldung auswerten

        bra.s   .fehler                 ;nein, melde Fehler!
.rastport
        move.l  d0,a0                   ;zeige auf ScreenStruktur
        lea     sc_RastPort(a0),a1      ;Adresse RastPort besorgen
        move.l  a1,_ScrnRastPort        ;und merken

        lea     sc_ViewPort(a0),a0      ;Adresse ViewPort besorgen
        move.l  a0,_ScrnViewPort        ;und merken

        lea     _NewWindow,a0           ;zeige auf NewWindowStruktur
        move.l  d0,nw_Screen(a0)        ;trage den Zeiger auf den Screen ein
        move.w  #2,nw_Type(a0)          ;Type = PublicScreen

* Farben einstellen
*------------------
        move.l  _ScrnViewPort,a0        ;zeige auf ViewPort
        move.l  ColorMapPtr,a1          ;zeige auf ColorMap
        moveq.l #FarbenAnzahl,d0        ;Anzahl der Farben => d0
        bsr     load_rgb4               ;einstellen

* VisualInfo_Screen besorgen
*---------------------------
        move.l  _ScrnPtr,a0             ;zeige auf ScreenStruktur
        lea     _ScreenTags,a1          ;zeige auf TagItemListe
        bsr     get_visual_info_a       ;VisualInfo besorgen
        move.l  d0,_VInfo               ;merken, geklappt?
        bne.s   .ende                   ;ja
.fehler
        moveq   #-1,d0                  ;melde Fehler
.ende
        rts
*--------------------------------------

set_pubscreen_mode

        movem.l d0-d1/a0-a1/a6,-(a7)

        move.l  _ScrnPtr,a0             ;ScreenPtr => a0
        moveq.l #0,d0                   ;d0 = NULL = public
        CALLINT PubScreenStatus         ;setzen

        lea     _ScreenTitle,a0         ;Titelstring
        CALLSYS SetDefaultPubScreen     ;als default Screen setzen

        move.l  #SHANGHAI!POPPUBSCREEN,d0
                                        ;aktiviere Shanghai und PopPupScreen
        CALLSYS SetPubScreenModes

        movem.l (a7)+,d0-d1/a0-a1/a6
        rts

*--------------------------------------

get_workbench_data

        lea     WBString,a0             ;zeige auf Name "Workbench"
        bsr     lock_pub_screen         ;besorge den Pointer
        move.l  d0,_WBScreen            ;Zeiger merken
        beq.s   .fehler                 ;nicht geklappt

        move.l  d0,a0                   ;zeige auf ScreenStruktur
        sub.l   a1,a1                   ;keine TagItemListe
        bsr     get_visual_info_a       ;VisualInfo besorgen
        move.l  d0,_VInfo               ;merken, geklappt?
        beq     .fehler                 ;nein

        move.w  MainWinHeight,d2        ;Default-Fenstergröße => d2

        bsr     get_font_prefs          ;welcher Font wird benutzt?
        tst.w   d0                      ;alles geklappt?
        bmi.s   .std                    ;nein

        move.w  #8,d1                   ;Standardfonthöhe => d1
        sub.w   d1,d0                   ;Differenz bilden
        ble     .std                    ;kleiner als, oder gleich 8

        add.w   d0,d2                   ;Differenz addieren
        move.w  d2,MainWinHeight        ;und merken
.std
        lea     _NewWindow,a0           ;zeige auf WindowStruktur
        move.w  #1,nw_Type(a0)          ;Type = WBScreen
        move.w  d2,nw_Height(a0)        ;Fensterhöhe eintragen

        moveq   #0,d0                   :melde alles ok!
        bra.s   .ende

.fehler
        moveq   #-1,d0                  ;melde Fehler
.ende
        rts

*--------------------------------------

open_main_win

        movem.l d1/a0-a2,-(a7)

* GadgetStrukturen anlegen
*-------------------------
        tst.l   _MainGadList            ;Gadgets schon vorhanden?
        bne.s   .window                 ;ja

        bsr     create_gadgets
        tst.l   d0                      ;alles ok?
        beq     .ende                   ;nein

.window
        lea     _NewWindow,a0           ;zeige auf WindowStruktur

        move.w  MainWinLeftEdge,nw_LeftEdge(a0)
        move.w  MainWinTopEdge,nw_TopEdge(a0)
        move.w  MainWinWidth,nw_Width(a0)
        move.w  MainWinHeight,nw_Height(a0)
        move.l  MainWinFlags,nw_Flags(a0)
        move.l  _MainGadList,nw_FirstGadget(a0)

        tst.l   _ScrnPtr                ;eigener Screen?
        beq.s   .wb_win                 ;nein

        move.w  #2,nw_Type(a0)          ;PublicScreen eintragen
        bra.s   .oeffnen                ;und öffnen

.wb_win
        move.w  #1,nw_Type(a0)          ;WbScreen eintragen

.oeffnen
        bsr     open_window             ;öffne Window
        move.l  d0,_MainWinPtr          ;Adresse sichern
        beq     .ende                   ;nicht geöffnet

        move.l  d0,a0                   ;WindowPtr => a0
        move.l  wd_RPort(a0),_MainWinRastPort
                                        ;merken
* Font setzen
*------------
        move.l  wd_RPort(a0),a1         ;RastPortPtr => a1
        move.l  _FontPtr,a0             ;FontPtr     => a0
        bsr     set_font                ;Font setzen

        move.l  _MainWinPtr,a0          ;WindowPtr   => a0
        bsr     gt_refresh_window       ;Fenster auffrischen

* Fenster Titel ausgeben
*-----------------------
        Locale  #ID_MainWinTitle,a1     ;Zeiger auf Titel eintragen
        move.l  #-1,a2                  ;keine Änderung im ScreenTitel
        bsr     set_win_titles          ;und ausführen

* Intuition Gadgets ausgeben
*----------------------------
        moveq.l #-1,d0                  ;ans Ende anfügen
        moveq.l #-1,d1                  ;alle
        lea     Scroller,a1             ;zeige auf den Anfang der GadgetListe
        bsr     add_g_list              ;ans Fenster binden

        exg     a0,a1                   ;Zeiger umtauschen
        moveq   #-1,d0                  ;alle bis zum Ende der Liste
        bsr     refresh_g_list          ;und auffrischen

* Aussehen darstellen
*--------------------
        moveq   #0,d0                   ;Offset = 0
        bsr     module_neu_ausgeben     ;ModuleDir ausgeben

        bsr     border_ausgeben         ;Border
        bsr     beschriftung_ausgeben   ;und Texte ebenfalls
        moveq   #1,d0                   ;melde "alles OK"

        bsr     menue_installieren      ;MenÜ anfügen
.ende
        movem.l (a7)+,d1/a0-a2
        rts
*--------------------------------------

* Menü installieren
*------------------

menue_installieren

        moveq.l #0,d0                   ;Pen         => d0
        move.l  _MainWinPtr,a0          ;WindowPtr   => a0
        lea     NewMenue,a1             ;NewMenuePtr => a1
        move.l  _VInfo,a2               ;VInfoPtr    => a2

        tst.b   Wahl_Font_Name          ;Name eingetragen?
        beq.s   .thinpaz                ;nein, Thinpaz.font verwenden

        lea     _WahlFontAttr,a3        ;ja, zeige auf TextAttributStruktur
        bra.s   .install                ;und installieren

.thinpaz
        move.l  _FontAttrPtr,a3         ;TextAttrPtr => a3

.install
        bsr     localize_menu           ;localize menu texts
        bsr     install_menu_complete   ;installieren
        move.l  d0,_MenuePtr            ;merken, geklappt?
        beq.s   .ende                   ;nein

        move.l  d1,_MenueTagList        ;ebenfalls merken
.ende
        rts
*--------------------------------------

close_main_win

        move.l  a0,-(a7)

* Menüs freigeben
*----------------
        move.l  _MenuePtr,a0            ;zeige auf MenüStruktur
        bsr     free_menus              ;freigeben
        clr.l   _MenuePtr               ;Zeiger löschen

        move.l  _MenueTagList,a0        ;zeige auf TagItemStruktur
        bsr     free_tag_items          ;freigeben
        clr.l   _MenueTagList           ;Zeiger löschen

* Fenster schließen
*------------------
        move.l  _MainWinPtr,a0          ;WindowPtr => a0
        bsr     close_window_safely     ;schließen
        clr.l   _MainWinPtr             ;Zeiger löschen

* GadgetStrukturen freigeben
*---------------------------
        move.l  _MainGadList,a0         ;GadgetListPtr => a0
        bsr     free_gt_gadgets         ;freigeben
        clr.l   _MainGadList            ;Zeiger löschen

        move.l  (a7)+,a0
        rts

*--------------------------------------

get_font_prefs

        movem.l d1/a0-a1,-(a7)

        move.l  _BufferPtr,a0           ;zeige auf Puffer
        sub.l   a1,a1                   ;keinen ScreenPtr
        move.l  #sc_SIZEOF,d0           ;Größe => d0
        move.l  #WBENCHSCREEN,d1        ;Type  => d1
        bsr     get_screen_data         ;Daten besorgen
        tst.l   d0                      ;geklappt?
        beq.s   .ende                   ;nein

        lea     sc_Font(a0),a0          ;zeige auf TextAttributPtr des Screens
        move.l  (a0),a0                 ;den Ptr => a0
        lea     _WahlFontAttr,a1        ;zeige auf TextAttributStruktur
        move.l  4(a0),4(a1)             ;Fontdaten eintragen
        move.w  4(a0),d0                ;in d0 zurückgeben

        move.l  (a0),a0                 ;zeige auf den Namen des Fonts
        lea     Wahl_Font_Name,a1       ;zeige auf Fontnamenablage
        bsr     string_kopieren         ;eintragen
.ende
        movem.l (a7)+,d1/a0-a1
        rts
*--------------------------------------
* string_kopieren
*
* Kopiert einen NULL terminierten String
* in die angegebene Zieladresse, und stellt
* die Zeiger auf das NULLByte!
*
* >= a0.l = Zeiger auf String der kopiert werden soll
* >= a1.l = Zeiger auf Ziel, wo der String hinkopiert werden soll
*
* => a0.l = Zeiger auf Ende des Strings     (NULLByte)
* => a1.l = Zeiger auf Ende des ZielStrings (NULLByte)
*--------------------------------------

string_kopieren

        move.b (a0)+,(a1)+              ;inclusive NullByte alles kopieren
        bne.s   string_kopieren

        tst.b   -(a1)                   ;setze den Zeiger auf das NullByte
        tst.b   -(a0)
        rts

*--------------------------------------
* name_ram_disk_korrigieren
*
* Trägt den Directory-Namen mit evtl. "Ram Disk" Korrektur
* in "source_dirname" ein.
*
* >= a0.l = Zeiger auf den zu kopierenden DirectoryNamen
*
* kein Rückgaberegister
*--------------------------------------

name_ram_disk_korrigieren

        movem.l d0-d1/a0-a1,-(a7)

        lea     ram_disk_string,a1      ;zeige auf "Ram Disk:"
        moveq.l #9,d0                   ;9 Bytes sind zu vergleichen
        moveq.l #0,d1                   ;Groß/Kleinschreibung ist egal
        bsr     string_n_compare        ;vergleiche

        lea     source_dirname,a1       ;zeige auf Ablage für den DirectoryNamen

        tst.l   d0                      ;welches Ergebnis vom Vergleich?
        bne.s   .eintragen              ;ungleich, normal weitermachen

        move.l  #"RAM:",(a1)            ;trage "RAM:"ein
        add.l   #9,a0                   ;Offset um 9 erhöhen
        add.l   #4,a1                   ;Offset um 4 erhöhen

.eintragen
        bsr     string_kopieren         ;eintragen

        movem.l (a7)+,d0-d1/a0-a1
        rts

*---------------------------------------

set_current_program_dir

        movem.l d0-d2,-(a7)

        move.l  tmp_dir,d1              ;zeige auf default String
        moveq.l #-2,d2                  ;SharedLock
        bsr     lock                    ;Lock besorgen
        move.l  d0,CurrentDirLock       ;geklappt?
        beq.s   .fehler                 ;nein

        move.l  d0,d1                   ;Lock => d1
        bsr     dos_current_dir         ;als CurrentDir setzen
        move.l  d0,OldCurrentDirLock    ;alten Lock merken
        bra.s   .ende                   ;und beenden
.fehler
        bsr     temp_dir_error          ;Warnung ausgeben
        move.w  #1,CurrentDirError      ;Flag setzen
.ende
        movem.l (a7)+,d0-d2
        rts

*--------------------------------------

set_old_current_dir

        tst.l   OldCurrentDirLock       ;Lock angegeben?
        beq.s   .abort                  ;nein

        tst.w   CurrentDirError         ;Fehler aufgetreten?
        bne.s   .abort                  ;ja, abbrechen

        move.l  d1,-(a7)

        move.l  OldCurrentDirLock,d1    ;zeige auf alten Lock
        bsr     dos_current_dir         ;setze als CurrentDir

        move.l  CurrentDirLock,d1       ;unseren Lock => d1
        bsr     unlock                  ;und freigeben

        move.l  (a7)+,d1
.abort
        rts

*--------------------------------------
* clean_up_files
*
* Löscht alle Files in "tmp_dir"
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

clean_up_files

        movem.l d0-d3/a0-a4,-(a7)

        move.l  tmp_dir,a0              ;zeige auf Directory (TempDir = CurrentDir)
        lea     Dateiname,a1            ;zeige auf Arbeitspuffer
        move.l  a1,d1                   ;in d1 übergeben
        move.l  a1,a2                   ;in a2 merken
        bsr     string_kopieren         ;eintragen

        move.w  #1,pruef_Flag           ;nur die Namen überprüfen

        bsr     pruefe_den_dirnamen     ;nun prüfen

        move.w  #0,pruef_Flag           ;Flag wieder löschen

        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        move.l  a1,a3                   ;Dirname-Ende in a3 merken
        bsr     exall_dir               ;ermittle alle Files im Directory
        tst.l   d0                      ;Files ermittelt?
        beq.s   .ende                   ;nein, keine Files vorhanden
        bmi.s   .ende                   ,nein, Fehler aufgetreten

        move.l  d1,d3                   ;Zeiger merken

        subq    #1,d0                   ;Anzahl -1, wegen dbra
        move.l  d0,d2                   ;zum Bearbeiten => d2
        move.l  d1,a4                   ;zeige auf ExAllStrukturen
        move.l  a2,d1                   ;zeige auf den kompletten Namen
.loop
        move.l  ed_Name(a4),a0          ;Zeiger auf FileNamen   => a0
        move.l  a3,a1                   ;Zeiger auf DirnameEnde => a1
        bsr     string_kopieren         ;eintragen

        bsr     dos_delete_file         ;File löschen

        move.l  (a4),a4                 ;Ptr auf nächste ExAllDataStruktur eintragen
        dbra    d2,.loop                ;nächstes File bearbeiten

        move.l  d3,a1                   ;zeige auf reservierten Speicher
        bsr     free_vec                ;wieder freigeben
.ende
        movem.l (a7)+,d0-d3/a0-a4
        rts

*--------------------------------------
* clean_up_settings
*
* Löscht alle Flags und Daten, um einen Zustand
* zu signalisieren, der "no Source File set" entspricht.
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

clean_up_settings

        clr.l   tp_program_dir          ;evtl. Einträge hier löschen
        clr.l   tp_program_name
        clr.l   tp_filetype
        clr.l   tp_configfile
        clr.l   tp_preco
        clr.l   source_filename
        clr.l   source_dirname
        clr.l   source_fullname

        tst.l   _MainWinPtr             ;Fenster schon offen?
        beq.s   .ende                   ;nein, keine weitere Anpassung erforderlich

        bsr     clear_compiler_status   ;Compiler Ergebnis löschen

        bsr     deactivate_gads_no_source
                                        ;Gadgets einstellen

        clr.w   source_set_Flag         ;Flag löschen, kein SourceFile gesetzt
.ende
        rts
*--------------------------------------
* clear_compiler_status
*
* Löscht alle Flags und Daten, um einen Zustand
* zu signalisieren, der "not compiled" entspricht.
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

clear_compiler_status

        clr.w   precompiled             ;Compiler-Ergebnis löschen
        clr.w   compiled
        clr.w   assembled
        clr.w   linked
        clr.w   built
        clr.l   CompileErrorFlag
        clr.l   CommandoSetup
        clr.l   StringEndeAddress
        rts

*--------------------------------------

reset_compile

        bsr     activate_compile_gad
        bsr     activate_ace_error_gad

        bsr     clear_compiler_status
        move.w  #1,precompiled
        rts

*--------------------------------------

reset_assembler

        bsr     activate_compile_gad
        bsr     activate_assembler_gad

        bsr     deactivate_ace_error_gad
        bsr     deactivate_linker_gad

        bsr     clear_compiler_status
        move.w  #1,precompiled
        move.w  #1,compiled
        rts

*--------------------------------------

reset_linker

        bsr     deactivate_ace_error_gad
        bsr     activate_all_okay_gads
        clr.w   linked
        clr.w   built
        rts

*--------------------------------------

set_okay

        bsr     activate_all_okay_gads

        move.w  #1,precompiled
        move.w  #1,compiled
        move.w  #1,assembled
        move.w  #1,linked
        clr.w   built
        rts

*--------------------------------------
* pruefe_auf_filetype
*
* Überprüft, ob es sich bei dem Eintrag in FILETYPE
* um ACESource handelt, oder ob .b/.bas als Extension
* vorhanden ist.
*
* kein Übergaberegister
*
* => d0.l = positiv = alles ok, negativ, dann Fehler
*--------------------------------------

pruefe_auf_filetype

        movem.l d1/a0-a1,-(a7)

        tst.l   tp_filetype             ;FileType angegeben?
        beq.s   .ext                    ;nein, prüfe auf Extension

        lea     tp_filetype,a0          ;ja, zeige auf Eintrag
        lea     tp_filetype_name,a1     ;zeige auf Definition
        moveq.l #0,d1                   ;Groß/Kleinschreibung nicht beachten
        bsr     string_compare          ;vergleiche
        tst.l   d0                      ;identisch?
        beq.s   .ende                   ;ja, keine Meldung
        bne.s   .message                ;neine, Meldung ausgeben
.ext
        lea     source_filename,a0      ;zeige auf den Filenamen

.loop
        tst.b   (a0)                    ;NullByte erreicht?
        beq.s   .message                ;ja, "." nicht gefunden, keine Extension

        cmpi.b  #".",(a0)+              ;suche den "."
        bne.s   .loop                   ;bis gefunden oder NullByte

        lea     text_b_ext,a1           ;zeige auf Vergleichsstring
        moveq.l #1,d0                   ;nur 1 Byte
        moveq.l #0,d1                   ;Groß/Kleinschreibung nicht beachten
        bsr     string_n_compare        ;vergleiche
        tst.l   d0                      ;identisch?
        beq.s   .ende                   ,ja

        lea     text_bas_ext,a1         ;zeige auf Vergleichsstring
        moveq.l #3,d0                   ;3 Bytes
        bsr     string_n_compare        ;vergleiche
        tst.l   d0                      ;identisch?
        beq.s   .ende                   ,ja

.message
        bsr     not_marked_as_source    ;Warnung ausgeben
        bsr     clean_up_settings       ;alles wieder zurückstellen
        bsr     clean_up_files
        moveq.l #-1,d0                  :melde Fehler
.ende
        movem.l (a7)+,d1/a0-a1
        rts

*--------------------------------------

clear_buffer

        movem.l d0/a0,-(a7)

        move.l  _BufferPtr,a0           ;zeige auf Puffer
        move.l  #ConfigFileSize,d0      ;Größe => d0

        lsr.l   #2,d0                   ;/4 da Langwörter gelöscht werden
        subq.l  #1,d0                   ;-1 da dbra bis -1 läuft
.loop
        clr.l   (a0)+
        dbra    d0,.loop

        movem.l (a7)+,d0/a0
        rts

*--------------------------------------
* shell_win_oeffnen
*
* überträgt die aktuelle MainWinPosition auf das Shell-Fenster
* und öffnet dieses
*
* >= d0.w = TopEdge Offset
* >= d1.w = Height
*
* => d0.l = FileHandle oder -1 bei Fehler
*--------------------------------------

shell_win_oeffnen

        movem.l d1-d2/a0-a1,-(a7)

        lea     shell_def_buffer,a0     ;zeige auf Datenfeld für Shell-Fenster

        moveq.l #98,d0                  ;Zählregister initialisieren
.loop0
        clr.b   (a0)+                   ;alten Pufferinhalt löschen
        dbra    d0,.loop0

        lea     shell_def_buffer,a0     ;Zeiger wieder => a0
        move.l  _MainWinPtr,a1          ;hole dir ein paar Daten hiervon

        moveq.l #0,d0                   ;Register löschen
        move.w  wd_LeftEdge(a1),d0      ;Fensterdaten eintragen

        moveq.l #0,d1                   ;Offset => d1 = 0
        moveq.l #0,d2                   ;Flag = führende Nullen ausgeben

        bsr     hex_to_dez_ascii        ;wandeln und eintragen

        bsr.s   .test_loop              ;Ende der Zahl ermitteln

        move.b  #"/",(a0)+              ;/ eintragen

        move.w  wd_TopEdge(a1),d0       ;aktuelles TopEdge eintragen

        CALLMRT HexToDezASCII           ;wandeln und eintragen

        bsr.s   .test_loop              ;Ende der Zahl ermitteln

        lea     shell_fortsetzung,a1    ;zeige auf den Rest der Definition
.loop1
        move.b  (a1)+,(a0)+             ;eintragen
        bne.s   .loop1                  ;alles

        move.l  #shell_def,d1           ;zeige auf Definition
        move.l  #MODE_OLDFILE,d2        ;Modus übergeben
        bsr     open_datei              ;und öffnen

        movem.l (a7)+,d1-d2/a0-a1
        rts

*--------------------------------------

.test_loop
        tst.b   (a0)+                   ;finde das Ende der eingetragenen Zahl
        bne.s   .test_loop

        tst.b   -(a0)                   ;Adresse korrigieren
        rts

*--------------------------------------
* con_win_oeffnen
*
* überträgt die aktuelle MainWinPosition auf das CON:Window
* und öffnet dieses
*
* >= d0.w = TopEdge Offset
* >= d1.w = Height
*
* => d0.l = FileHandle oder -1 bei Fehler
*--------------------------------------

con_win_oeffnen

        movem.l d1-d2/a0-a1/a6,-(a7)

        lea     con_def_buffer,a0       ;zeige auf Datenfeld für CON: Fenster

        moveq.l #98,d0                  ;Zählregister initialisieren
.loop0
        clr.b   (a0)+                   ;alten Pufferinhalt löschen
        dbra    d0,.loop0

        lea     con_def_buffer,a0       ;Zeiger wieder => a0
        move.l  _MainWinPtr,a1          ;hole dir ein paar Daten hiervon

        moveq.l #0,d0                   ;Register löschen
        move.w  wd_LeftEdge(a1),d0      ;Fensterdaten eintragen

        moveq.l #0,d1                   ;Offset => d1 = 0
        moveq.l #0,d2                   ;Flag = führende Nullen ausgeben

        CALLMRT HexToDezASCII           ;wandeln und eintragen

        bsr.s   .test_loop              ;Ende der Zahl ermitteln

        move.b  #"/",(a0)+              ;/ eintragen

        move.w  wd_TopEdge(a1),d0       ;aktuelles TopEdge eintragen
        addi.w  #100,d0                 ;100 Pixel addieren

        CALLMRT HexToDezASCII           ;wandeln und eintragen

        bsr.s   .test_loop              ;Ende der Zahl ermitteln

        lea     con_fortsetzung,a1      ;zeige auf den Rest der Definition
.loop1
        move.b  (a1)+,(a0)+             ;eintragen
        bne.s   .loop1                  ;alles

        move.l  #con_def,d1             ;zeige auf Definition
        move.l  #MODE_OLDFILE,d2        ;Modus übergeben
        bsr     open_datei              ;und öffnen

        movem.l (a7)+,d1-d2/a0-a1/a6
        rts

*--------------------------------------

.test_loop
        tst.b   (a0)+                   ;finde das Ende der eingetragenen Zahl
        bne.s   .test_loop

        tst.b   -(a0)                   ;Adresse korrigieren
        rts
*--------------------------------------

pruefe_auf_editor

        move.l  d1,-(a7)

        tst.l   editor                  ;Editor angegeben?
        beq.s   .fehler                 ;nein

        move.w  #1,pruef_Flag           ;nur die Namen überprüfen
        move.l  editor,d1               ;zeige auf den Namen
        bsr     fileinfo_besorgen       ;prüfe
        clr.w   pruef_Flag              ;Flag wieder löschen
        bra.s   .ende                   ;und beenden
.fehler
        moveq   #-1,d0                  ;melde Fehler
.ende
        move.l  (a7)+,d1
        rts

*--------------------------------------

* => d0 = negativ, dann Viewer nicht definiert
* => a0 = Zeiger auf Viewerdefinition

pruefe_auf_viewer

        move.l  d1,-(a7)

        move.l  viewer,a0               ;zeige auf Viewerdefinition
        tst.b   (a0)                    ;Viewer definiert?
        bne.s   .start                  ;ja

        move.l  agdtool,a0              ;zeige auf Amigaguidedefinition
        tst.b   (a0)                    ;Amigaguide definiert?
        beq.s   .fehler                 ;nein
.start
        move.w  #1,pruef_Flag           ;nur die Namen überprüfen
        move.l  a0,d1                   ;zeige auf den Namen
        bsr     fileinfo_besorgen       ;prüfe
        clr.w   pruef_Flag              ;Flag wieder löschen
        bra.s   .ende                   ;und beenden
.fehler
        moveq   #-1,d0                  ;melde Fehler
.ende
        move.l  (a7)+,d1
        rts

*--------------------------------------
