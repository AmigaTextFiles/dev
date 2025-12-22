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

react_on_gadget

        movem.l d0-d7/a0-a6,-(a7)

        move.l  d3,a0                   ;Zeiger auf GadgetStruktur => a0
        move.w  gg_GadgetID(a0),d0      ;GadgetID => d0
        move.w  gg_Flags(a0),d2         ;Flags => d2
        move.l  gg_SpecialInfo(a0),d3   ;Zeiger auf SpecialInfo => d3

        lsl     #2,d0                   ; * 4 da long
        lea     tabelle_uprge,a1        ;zeige auf Tabelle
        move.l  0(a1,d0),a1             ;addiere Offset

        jsr     (a1)                    ;Unterprogramm ausführen

        movem.l (a7)+,d0-d7/a0-a6
        rts

*--------------------------------------

tabelle_uprge

* Source
*-------
        dc.l    set_source,reset_source,edit_source

* Program
*--------
        dc.l    precompile_prg,compile_prg,assemble_prg,link_prg,run_prg,run_in_shell

* Make
*-----
        dc.l    make_exe,make_application,make_submod

* Precompiler
*------------
        dc.l    set_precomp

* ACE Options
*------------
        dc.l    set_break_trap,set_asm_comment,set_create_icon,set_optimize,set_win_trap,set_other

* SuperOptimizer
*---------------
        dc.l    toggle_active,set_superopt_level

* View
*-----
        dc.l    view_precom_source,view_asm_source,view_ace_errors

* Assembler
*----------
        dc.l    set_assembler,set_ass_sc,set_ass_sd,set_debug_info,set_ass_options

* LinkerLib
*----------
        dc.l    set_linker_lib

* Linker
*-------
        dc.l    set_linker,set_lnk_sc,set_lnk_sd,set_lnk_nodebug,set_lnk_options

* Module
*-------
        dc.l    rem_all_modules,scroller

        dc.l    avail,avail,avail,avail,avail,avail,avail,avail,avail,avail,avail
*--------------------------------------
* Make
*--------------------------------------

make_exe

        bsr     clear_buffer            ;alten Inhalt löschen
        move.l  #1,KomplettFlag         ;kompletten CompilerRun durchführen

        tst.w   precompiled             ;schon ausgeführt?
        bne.s   .compile                ;ja

        bsr     precompile_prg          ;zuerst den Precompiler eintragen
        tst.l   d0                      ;Fehler aufgetreten?
        bmi.s   .ende                   ;ja

.compile
        tst.w   compiled                ;schon ausgeführt?
        bne.s   .assemble               ;ja

        bsr     compile_prg             ;dann ACE
        tst.l   d0                      ;Fehler aufgetreten?
        bmi.s   .ende                   ;ja

.assemble
        tst.w   assembled               ;schon ausgeführt?
        bne.s   .link                   ;ja

        bsr     assemble_prg            ;dann den Assembler
        tst.l   d0                      ;Fehler aufgetreten?
        bmi.s   .ende                   ;ja
.link
        tst.w   linked                  ;schon ausgeführt?
        bne.s   .ende                   ;ja

        tst.l   AceObjectFlag           ;SUBMod erzeugen?
        bne.s   .execute                ;ja

        bsr     link_prg                ;zum Schluß den Linker
        tst.l   d0                      ;Fehler aufgetreten?
        bmi.s   .ende                   ;ja

.execute
        bsr     compile                 ;und ausführen
        bsr     make_exe_auswerten      ;Okay Werte setzen

.ende
        clr.l   CommandoSetup           ;KommandoBits löschen
        clr.l   KomplettFlag            ;Flag wieder löschen
        clr.l   StringEndeAddress       ;Adresse löschen
        rts

*--------------------------------------

make_exe_auswerten

        move.l  CompileErrorFlag,d0     ;Flag zur Prüfung => d0
        beq.s   .ok                     ;kein Fehler aufgetreten

        btst    #nap,d0
        bne.s   .precompiler

        btst    #acpp,d0
        bne.s   .precompiler

        btst    #preco_other,d0
        bne.s   .precompiler

        btst    #removeline,d0
        bne.s   .precompiler

        btst    #ace,d0
        bne.s   .ace

        btst    #superopt,d0
        bne.s   .ace

        btst    #a68k,d0
        bne.s   .assembler

        btst    #phxass,d0
        bne.s   .assembler

        btst    #ass_other,d0
        bne.s   .assembler

        btst    #blink,d0
        bne.s   .linker

        btst    #phxlnk,d0
        bne.s   .linker

        btst    #lnk_other,d0
        bne.s   .linker
.ok
        bsr     set_okay
        moveq.l #0,d0
        bra.s   .ende

.precompiler
        bsr     reset_source
        bra.s   .fehler
.ace
        bsr     reset_compile
        bra.s   .fehler

.assembler
        bsr     reset_assembler
        bra.s   .fehler
.linker
        bsr     reset_linker

.fehler
        moveq.l #-1,d0

.ende
        rts

*--------------------------------------

make_application

        tst.w   built                   ;schon ausgeführt?
        bne.s   .ende                   ;ja

        clr.w   built                   ;Flag löschen
        bsr     make_exe                ;Source compilieren
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        bsr     copy_exe                ;File => bltdir kopieren
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        move.w  #1,built                ;setze Flag, ausgeführt

        move.l  OptionsSetup,d0         ;Flag => d0
        btst    #create_icon,d0         ;Icon gewünscht?
        beq.s   .meldung                ;nein, Meldung ausgeben

        bsr     copy_exe_info           ;ebenfalls ein Icon, falls vorhanden

.meldung
        bsr     application_has_been_built
                                        ;Meldung ausgeben
.ende
        rts

*--------------------------------------

copy_exe

        lea     Dateiname,a1            ;zeige auf Namenspuffer
        move.l  a1,d1                   ;in d1 übergeben
        bsr     tmp_file_eintragen      ;kompletten Namen eintragen
        adda.l  #1,a1
        addq.l  #1,d1                   ;Anführungszeichen überspringen
.loop
        cmpi.b  #".",-(a1)              ;finde den Punkt
        bne.s   .loop

        move.b  #0,(a1)                 ;NullByte eintragen

        moveq   #0,d2                   ;Speicher und Größe sind unbekannt
        moveq   #0,d3
        bsr     datei_laden             ;und in den Speicher damit
        tst.l   d0                      ;alles okay?
        bmi.s   .ende                   ;nein

        move.l  d1,a1                   ;Zeiger auf den NamensPuffer wieder => a1
        bsr     built_file_eintragen    ;den neuen Namen eintragen

        bsr     datei_sichern           ;und dorthin kopieren

        move.l  d2,a1                   ;Zeiger auf Speicher => a1
        bsr     free_vec                ;und wieder freigeben
.ende
        rts

*--------------------------------------

copy_exe_info

        lea     Dateiname,a1            ;zeige auf Namenspuffer
        move.l  a1,d1                   ;in d1 übergeben
        bsr     exe_info_eintragen      ;trage "ace:icon/exe.info" ein
        tst.l   d0                      ;vorhanden?
        bmi.s   .ende                   ;nein

        moveq   #0,d2                   ;Speicher und Größe sind unbekannt
        moveq   #0,d3
        bsr     datei_laden             ;und in den Speicher damit
        tst.l   d0                      ;alles okay?
        bmi.s   .ende                   ;nein

        move.l  d1,a1                   ;Zeiger auf den NamensPuffer wieder => a1
        bsr     built_info_eintragen    ;den neuen Namen eintragen

        bsr     datei_sichern           ;und dorthin kopieren

        move.l  d2,a1                   ;Zeiger auf Speicher => a1
        bsr     free_vec                ;und wieder freigeben
.ende
        rts

*--------------------------------------

built_file_eintragen

        movem.l d0-d1/a0,-(a7)

        move.l  a1,d1                   ;Zeiger in d1 übergeben
        move.l  blt_dir,a0              ;zeige auf den BuiltDirString
        bsr     string_kopieren         ;und eintragen
        move.w  #1,pruef_Flag           ;nur den FileNamen überprüfen
        bsr     pruefe_den_dirnamen     ;ROOT oder Unterdirectory?
                                        ;evtl. : oder / anfügen
        clr.w   pruef_Flag              ;Flag wieder löschen

        lea     source_filename,a0      ;zeige auf den FileNamen
        bsr     string_kopieren         ;und eintragen
.loop
        cmpi.b  #".",-(a1)              ;finde den Punkt
        bne.s   .loop

        move.b  #0,(a1)                 ;NullByte eintragen

        movem.l (a7)+,d0-d1/a0
        rts

*--------------------------------------

exe_info_eintragen

        movem.l d1/a0-a1,-(a7)

        move.l  a1,d1                   ;Zeiger in d1 übergeben
        lea     default_icon_dir,a0     ;zeige auf den IconDirString
        bsr     string_kopieren         ;und eintragen
        move.w  #1,pruef_Flag           ;nur den FileNamen überprüfen
        bsr     pruefe_den_dirnamen     ;ROOT oder Unterdirectory?
                                        ;evtl. : oder / anfügen
        clr.w   pruef_Flag              ;Flag wieder löschen

        lea     exe_icon_name,a0        ;zeige auf den FileNamen
        bsr     string_kopieren         ;und eintragen

        move.w  #1,pruef_Flag           ;nur den FileNamen überprüfen
        bsr     fileinfo_besorgen       ;prüfe ob eins vorhanden
        clr.w   pruef_Flag              ;Flag wieder löschen

        movem.l (a7)+,d1/a0-a1
        rts

*--------------------------------------

built_info_eintragen

        bsr     built_file_eintragen    ;zuerst den kompletten Namen eintragen

        move.b  #".",(a1)+              ;nun den Punkt
        move.b  #"i",(a1)+              ;und jetzt "info"
        move.b  #"n",(a1)+
        move.b  #"f",(a1)+
        move.b  #"o",(a1)+
        move.b  #0,(a1)+
        rts

*--------------------------------------

make_submod

        move.w  precompiled,d0          ;Flag retten, falls schon durchgeführt
        bsr     clear_compiler_status   ;muss neu kompiliert werden,
                                        ;da andere ACEOption!!!
        move.w  d0,precompiled          ;Flag wieder eintragen
        move.l  #1,AceObjectFlag        ;Flag setzen, => SUBMod erzeugen

        bsr     make_exe                ;kompilieren
        tst.l   d0                      ;erfolgreich?
        bmi.s   .ende                   ;nein

        bsr     copy_submod             ;kopieren und Liste aktualisieren
.ende
        clr.l   AceObjectFlag           ;Flag löschen
        rts

*--------------------------------------

copy_submod

        lea     Dateiname,a1            ;zeige auf Namenspuffer
        move.l  a1,d1                   ;in d1 übergeben
        bsr     tmp_file_eintragen      ;kompletten Namen eintragen

        bsr     o_eintragen             ;Extension anfügen

        add.l   #1,d1
        move.b  #0,-(a1)                ;Anführungszeichen löschen

        moveq   #0,d2                   ;Speicher und Größe sind unbekannt
        moveq   #0,d3
        bsr     datei_laden             ;und in den Speicher damit
        tst.l   d0                      ;alles okay?
        bmi.s   .ende                   ;nein

        move.l  d1,a1                   ;Zeiger auf den NamensPuffer wieder => a1

        move.l  _MemPtr,a0              ;zeige auf Konfiguration
        lea     new_mod_dir(a0),a0      ;zeige auf Directoryeintrag
        bsr     string_kopieren         ;eintragen

        move.w  #1,pruef_Flag           ;nur den FileNamen überprüfen
        bsr     pruefe_den_dirnamen     ;ROOT oder Unterdirectory?
                                        ;evtl. : oder / anfügen
        clr.w   pruef_Flag              ;Flag wieder löschen

        lea     source_filename,a0      ;zeige auf den FileNamen
        bsr     string_kopieren         ;und eintragen
        bsr     o_eintragen             ;Extension anfügen
        move.b  #0,-(a1)                ;Anführungszeichen löschen
        bsr     datei_sichern           ;und dorthin kopieren

        move.l  d2,a1                   ;Zeiger auf Speicher => a1
        bsr     free_vec                ;und wieder freigeben

        bsr     submods_aktualisieren   ;Liste neu ausgeben
.ende
        rts

*--------------------------------------

submods_aktualisieren

        move.l  _MemPtr,a0              ;zeige auf Konfiguration
        lea     new_mod_dir(a0),a0      ;zeige auf Directoryeintrag
        move.l  a0,d1                   ;in d1 übergeben
        bsr     available_module_array  ;Array anlegen

        moveq   #0,d0                   ;Offset = 0
        bsr     module_neu_ausgeben     ;ModuleDir ausgeben

        rts

*--------------------------------------

* Precompiler
*--------------------------------------

set_precomp

        lea     MakeSetup,a0            ;zeige auf FlagBits
        move.l  #nap,d3                 ;BitOffsetregister initialisieren
        bsr     toggle_bits             ;Bits entsprechend der GadgetID setzen und löschen

        move.l  _MemPtr,a0              ;zeige auf Konfiguration
        move.l  d0,new_MakeSetup(a0)    ;Änderung eintragen

        move.w  #1,Config_geaendert     ;Flag setzen

        btst    #preco_other,d0         ;other Preco gewählt?
        beq     .ende                   ;nein

        lea     StrGadInfo,a0           ;Zeige auf StringInfoStruktur
        move.w  #31,$A(a0)              ;max. 30 Zeichen zulassen

        move.l  _MemPtr,a0              ;trage die alten Daten in den Puffer
        lea     other_precomp_name(a0),a0
        lea     Eingabe,a1
        bsr     string_kopieren

        bsr     input_window            ;öffne Input Window
        tst.l   d0                      ;geklappt?
        beq     .ende                   ;nein

        move.l  _MsgWinRPort,a0         ;RastPortPtr     => a0
        lea     Ausgabe_Ts,a1           ;IntuiTextStrPtr => a1

        move.b  #01,(a1)                ;foreground color
        move.b  #00,1(a1)               ;background color
        move.w  #7,4(a1)              ;left edge
        move.w  #08,6(a1)               ;top edge
        move.l  #IDPreco_Other_Text,12(a1)
        move.b  #0,d0
        bsr     print_locale            ;ausgeben

        moveq   #1,d1                   ;mit Wait()
        bsr     msg_win_msg             ;warte auf Message

        move.l  _MemPtr,a2              ;zeige auf Konfiguration
        lea     other_precomp_name(a2),a1
                                        ;zeige auf Namensfeld
        lea     Eingabe,a0              ;zeige auf EingabePuffer
        tst.b   (a0)                    ;Eintrag vorhanden?
        bne.s   .eintragen              ;ja

        move.l  #0,(a1)                 ;Eintrag löschen
        move.l  OldSetup,MakeSetup      ;Flags wieder eintragen
        move.l  OldSetup,new_MakeSetup(a2)

        move.l  #nap,d3                 ;BitOffsetregister initialisieren
        move.l  #12,d4                  ;GadgetId => d4
        move.l  OldSetup,d0             ;Flags => d0
        lea     MxTags,a3               ;zeige auf TagItems

        bsr     gad_zurueckstellen      ;auf vorherigen Wert zurückstellen

        bra.s   .close                  ;und Fenster wieder schließen

.eintragen
        move.l  a0,a2                   ;in a2 merken
        bsr     string_kopieren         ;ja, eintragen

        move.l  a2,a0                   ;dto.
        bsr     other_preco_eintragen
.close
        lea     StrGad,a1               ;GadgetPtr übergeben
        bsr     close_msg_win           ;schließen
.ende
        rts

*--------------------------------------
* ACE Options
*--------------------------------------

set_break_trap

        lea     OptionsSetup,a0         ;Options => d0
        move.l  #break_trapping,d1      ;BitNr. in d1 übergeben
        bsr     bit_aendern             ;Bitzustand ändern

        move.l  _MemPtr,a0              ;zeige auf Konfiguration
        move.l  d0,new_OptionsSetup(a0) ;Änderung eintragen

        move.w  #1,Config_geaendert     ;Flag setzen
        rts

*--------------------------------------

set_asm_comment

        lea     OptionsSetup,a0
        move.l  #asm_comment,d1
        bsr     bit_aendern

        move.l  _MemPtr,a0
        move.l  d0,new_OptionsSetup(a0)

        move.w  #1,Config_geaendert
        rts

*--------------------------------------

set_create_icon

        lea     OptionsSetup,a0
        move.l  #create_icon,d1
        bsr     bit_aendern

        move.l  _MemPtr,a0
        move.l  d0,new_OptionsSetup(a0)

        move.w  #1,Config_geaendert
        rts

*--------------------------------------

set_optimize

        lea     OptionsSetup,a0
        move.l  #optimize_assembly,d1
        bsr     bit_aendern

        move.l  _MemPtr,a0
        move.l  d0,new_OptionsSetup(a0)

        move.w  #1,Config_geaendert
        rts

*--------------------------------------

set_win_trap

        lea     OptionsSetup,a0
        move.l  #window_trapping,d1
        bsr     bit_aendern

        move.l  _MemPtr,a0
        move.l  d0,new_OptionsSetup(a0)

        move.w  #1,Config_geaendert
        rts

*--------------------------------------

set_other

        lea     StrGadInfo,a0           ;Zeige auf StringInfoStruktur
        move.w  #81,$A(a0)              ;max. 80 Zeichen zulassen

        move.l  _MemPtr,a0              ;trage die alten Daten in den Puffer
        lea     other_ace_options(a0),a0
        lea     Eingabe,a1
        bsr     string_kopieren

        bsr     input_window            ;öffne Input Window
        tst.l   d0                      ;geklappt?
        beq.s   .ende                   ;nein

        move.l  _MsgWinRPort,a0         ;RastPortPtr     => a0
        lea     Ausgabe_Ts,a1           ;IntuiTextStrPtr => a1

        move.b  #01,(a1)                ;foreground color
        move.b  #00,1(a1)               ;background color
        move.w  #7,4(a1)              ;left edge
        move.w  #08,6(a1)               ;top edge
        move.b  #0,d0
        move.l  #IDAce_Options_Text,12(a1)
        bsr     print_locale            ;ausgeben

        moveq   #1,d1                   ;mit Wait()
        bsr     msg_win_msg             ;warte auf Message

        btst    #9,d0                   ;WindowClose gewählt ?
        bne.s   .close                  ;ja, nichts ändern

        move.l  _MemPtr,a1              ;trage die neuen Daten in die Konfiguration ein
        lea     other_ace_options(a1),a1
        lea     Eingabe,a0
        bsr     string_kopieren
        move.w  #1,Config_geaendert     ;Flag setzen
.close
        lea     StrGad,a1               ;GadgetPtr übergeben
        bsr     close_msg_win           ;schließen
.ende
        rts

*--------------------------------------
* SuperOptimizer
*--------------------------------------

toggle_active

        lea     MakeSetup,a0
        move.l  #superopt,d1
        bsr     bit_aendern

        move.l  _MemPtr,a0
        move.l  d0,new_MakeSetup(a0)

        move.w  #1,Config_geaendert
        rts

*--------------------------------------
* View
*--------------------------------------

view_precom_source


        bsr     pruefe_auf_viewer       ;Viewer definiert?
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        lea     Dateiname,a1            ;zeige auf Puffer
        move.l  a1,d2                   ;in d2 merken
        bsr     string_kopieren         ;Viewerdefinition eintragen
        move.b  #" ",(a1)+              ;Space anfügen
        move.l  a1,d1                   ;in d1 merken

        bsr     tmp_file_eintragen      ;Filename eintragen
        bsr     b_eintragen             ;Extension anfügen
        move.w  #1,pruef_Flag           ;Flag setzen
;        bsr     fileinfo_besorgen       ;prüfe den Namen
;        tst.l   d0                      ;alles ok?
;        bmi.s   .ende                   ;nein

        bsr     viewer_aktivieren       ;ja, ausgeben
.ende
        clr.w   pruef_Flag              ;Flag wieder löschen
        rts

*--------------------------------------

view_asm_source

        bsr     pruefe_auf_viewer       ;dto.
        tst.l   d0
        bmi.s   .ende

        lea     Dateiname,a1
        move.l  a1,d2
        bsr     string_kopieren
        move.b  #" ",(a1)+
        move.l  a1,d1

        bsr     tmp_file_eintragen
        bsr     s_eintragen
        move.w  #1,pruef_Flag
;        bsr     fileinfo_besorgen
;        tst.l   d0
;        bmi.s   .ende

        bsr     viewer_aktivieren
.ende
        clr.w   pruef_Flag
        rts

*--------------------------------------

view_ace_errors

        bsr     pruefe_auf_viewer       ;dto.
        tst.l   d0
        bmi.s   .ende

        lea     Dateiname,a1
        move.l  a1,d2
        bsr     string_kopieren
        move.b  #" ",(a1)+
        move.l  a1,d1

        move.l  tmp_dir,a0
        bsr     string_kopieren

        move.w  #1,pruef_Flag
        bsr     pruefe_den_dirnamen

        lea     ace_error_string,a0
        bsr     string_kopieren

        bsr     fileinfo_besorgen
        tst.l   d0
        bmi.s   .ende

        bsr     viewer_aktivieren
.ende
        clr.w   pruef_Flag
        rts

*--------------------------------------

viewer_aktivieren

        move.l  d2,d6                   ;Zeiger auf CmdString übergeben
        move.l  #1,AsynchFlag           ;läuft asynchron
        bsr     program_ausfuehren      ;und ausführen

        rts

*--------------------------------------

* Assembler
*--------------------------------------

set_assembler

        lea     MakeSetup,a0
        move.l  #a68k,d3
        bsr     toggle_bits

        move.l  _MemPtr,a0
        move.l  d0,new_MakeSetup(a0)

        move.w  #1,Config_geaendert

        btst    #ass_other,d0           ;other Assembler gewählt?
        beq     .ende                   ;nein

        lea     StrGadInfo,a0           ;Zeige auf StringInfoStruktur
        move.w  #31,$A(a0)              ;max. 30 Zeichen zulassen

        move.l  _MemPtr,a0              ;trage die alten Daten in den Puffer
        lea     other_ass_name(a0),a0
        lea     Eingabe,a1
        bsr     string_kopieren

        bsr     input_window            ;öffne Input Window
        tst.l   d0                      ;geklappt?
        beq     .ende                   ;nein

        move.l  _MsgWinRPort,a0         ;RastPortPtr     => a0
        lea     Ausgabe_Ts,a1           ;IntuiTextStrPtr => a1

        move.b  #01,(a1)                ;foreground color
        move.b  #00,1(a1)               ;background color
        move.w  #7,4(a1)               ;left edge
        move.w  #08,6(a1)               ;top edge
        move.l  #IDAsm_Other_Text,12(a1)
        moveq.l #0,d0
        bsr     print_locale            ;ausgeben

        moveq   #1,d1                   ;mit Wait()
        bsr     msg_win_msg             ;warte auf Message

        move.l  _MemPtr,a2              ;zeige auf Konfiguration
        lea     other_ass_name(a2),a1   ;zeige auf Namensfeld
        lea     Eingabe,a0              ;zeige auf EingabePuffer
        tst.b   (a0)                    ;Eintrag vorhanden?
        bne.s   .eintragen              ;ja

        move.l  #0,(a1)                 ;Eintrag löschen
        move.l  OldSetup,MakeSetup      ;Flags wieder eintragen
        move.l  OldSetup,new_MakeSetup(a2)

        move.l  #a68k,d3                ;BitOffsetregister initialisieren
        move.l  #24,d4                  ;GadgetId => d4
        move.l  OldSetup,d0             ;Flags => d0
        lea     MxTags,a3               ;zeige auf TagItems

        bsr     gad_zurueckstellen      ;auf vorherigen Wert zurückstellen

        move.l  OldSetup,MakeSetup      ;Flags wieder eintragen
        bra.s   .close                  ;und Fenster wieder schließen

.eintragen
        move.l  a0,a2                   ;in a2 merken
        bsr     string_kopieren         ;ja, eintragen

        move.l  a2,a0                   ;dto.
        bsr     other_ass_eintragen
.close
        lea     StrGad,a1               ;GadgetPtr übergeben
        bsr     close_msg_win           ;schließen
.ende
        rts

*--------------------------------------

set_ass_sc

        lea     OptionsSetup,a0
        move.l  #ass_small_code,d1
        bsr     bit_aendern

        move.l  _MemPtr,a0
        move.l  d0,new_OptionsSetup(a0)

        move.w  #1,Config_geaendert
        rts

*--------------------------------------

set_ass_sd

        lea     OptionsSetup,a0
        move.l  #ass_small_data,d1
        bsr     bit_aendern

        move.l  _MemPtr,a0
        move.l  d0,new_OptionsSetup(a0)

        move.w  #1,Config_geaendert
        rts

*--------------------------------------

set_debug_info

        lea     OptionsSetup,a0
        move.l  #ass_debug_info,d1
        bsr     bit_aendern

        move.l  _MemPtr,a0
        move.l  d0,new_OptionsSetup(a0)

        move.w  #1,Config_geaendert
        rts

*--------------------------------------

set_ass_options

        lea     StrGadInfo,a0           ;Zeige auf StringInfoStruktur
        move.w  #256,$A(a0)             ;max. 255 Zeichen zulassen

        move.l  _MemPtr,a0              ;trage die alten Daten in den Puffer
        lea     ass_options(a0),a0
        lea     Eingabe,a1
        bsr     string_kopieren

        bsr     input_window            ;öffne Input Window
        tst.l   d0                      ;geklappt?
        beq.s   .ende                   ;nein

        move.l  _MsgWinRPort,a0         ;RastPortPtr     => a0
        lea     Ausgabe_Ts,a1           ;IntuiTextStrPtr => a1

        move.b  #01,(a1)                ;foreground color
        move.b  #00,1(a1)               ;background color
        move.w  #7,4(a1)              ;left edge
        move.w  #08,6(a1)               ;top edge
        move.l  #IDAsm_Options_Text,12(a1)
        moveq.l #0,d0
        bsr     print_locale            ;ausgeben

        moveq   #1,d1                   ;mit Wait()
        bsr     msg_win_msg             ;warte auf Message

        btst    #9,d0                   ;WindowClose gewählt ?
        bne.s   .close                  ;ja, nichts ändern

        move.l  _MemPtr,a1              ;trage die neuen Daten in die Konfiguration ein
        lea     ass_options(a1),a1
        lea     Eingabe,a0
        bsr     string_kopieren
        move.w  #1,Config_geaendert     ;Flag setzen
.close
        lea     StrGad,a1               ;GadgetPtr übergeben
        bsr     close_msg_win           ;schließen
.ende
        rts

*--------------------------------------
* LinkerLib
*--------------------------------------

set_linker_lib

        lea     OptionsSetup,a0         ;zeige auf Setup
        move.l  (a0),OldSetup           ;merken

        move.l  #other_lib,d3           ;Bitoffset initialisieren
        bsr     toggle_bits             ;einstellen

        move.l  _MemPtr,a0              ;zeige auf Konfiguration
        move.l  d0,new_OptionsSetup(a0) ;merken

        move.w  #1,Config_geaendert     ;melde geändert!

        btst    #other_lib,d0           ;other Linker Library gewählt?
        beq     .ende                   ;nein

        lea     StrGadInfo,a0           ;Zeige auf StringInfoStruktur
        move.w  #31,$A(a0)              ;max. 30 Zeichen zulassen

        move.l  _MemPtr,a0              ;trage die alten Daten in den Puffer
        lea     other_lib_name(a0),a0
        lea     Eingabe,a1
        bsr     string_kopieren

        bsr     input_window            ;öffne Input Window
        tst.l   d0                      ;geklappt?
        beq     .ende                   ;nein

        move.l  _MsgWinRPort,a0         ;RastPortPtr     => a0
        lea     Ausgabe_Ts,a1           ;IntuiTextStrPtr => a1

        move.b  #01,(a1)                ;foreground color
        move.b  #00,1(a1)               ;background color
        move.w  #7,4(a1)               ;left edge
        move.w  #08,6(a1)               ;top edge
        move.l  #IDLib_Other_Text,12(a1)
        moveq.l #0,d0
        bsr     print_locale            ;ausgeben

        moveq   #1,d1                   ;mit Wait()
        bsr     msg_win_msg             ;warte auf Message

        move.l  _MemPtr,a2              ;zeige auf Konfiguration
        lea     other_lib_name(a2),a1   ;zeige auf Namensfeld
        lea     Eingabe,a0              ;zeige auf Eingabepuffer
        tst.b   (a0)                    ;Eintrag vorhanden?
        bne.s   .eintragen              ;ja

        move.l  #0,(a1)                 ;Eintrag löschen
        move.l  OldSetup,OptionsSetup   ;Flags wieder eintragen
        move.l  OldSetup,new_OptionsSetup(a2)

        lea     CycleTags,a3            ;zeige auf TagItems
        move.l  #1,12(a3)               ;ID für amiga.lib eintragen
                                        ;in die TagItems eintragen
        lea     _Gadget_Ptr_MainWin,a0  ;zeige auf GadgetPtrAblage
        move.l  #29,d4                  ;GadgetId => d4
        lsl.l   #2,d4                   ;* 4 da long
        move.l  0(a0,d4),a0             ;GadgetPtr => a0
        move.l  _MainWinPtr,a1          ;WindowPtr => a1

        bsr     gadgets_freigeben       ;müssen ans Fenster gebunden sein,
                                        ;sonst Absturz

        bsr     gt_set_gadget_attrs_a   ;ändern

        bsr     gadgets_sperren         ;jetzt wieder entfernen, wir sind
                                        ;noch nicht fertig
        bra.s   .close                  ;und Fenster wieder schließen

.eintragen
        bsr     string_kopieren
.close
        lea     StrGad,a1               ;GadgetPtr übergeben
        bsr     close_msg_win           ;schließen
.ende
        rts

*--------------------------------------
* Linker
*--------------------------------------

set_linker

        lea     MakeSetup,a0
        move.l  #blink,d3
        bsr     toggle_bits

        move.l  _MemPtr,a0
        move.l  d0,new_MakeSetup(a0)

        move.w  #1,Config_geaendert

        btst    #lnk_other,d0           ;other Linker gewählt?
        beq     .ende                   ;nein

        lea     StrGadInfo,a0           ;Zeige auf StringInfoStruktur
        move.w  #31,$A(a0)              ;max. 30 Zeichen zulassen

        move.l  _MemPtr,a0              ;trage die alten Daten in den Puffer
        lea     other_linker_name(a0),a0
        lea     Eingabe,a1
        bsr     string_kopieren

        bsr     input_window            ;öffne Input Window
        tst.l   d0                      ;geklappt?
        beq     .ende                   ;nein

        move.l  _MsgWinRPort,a0         ;RastPortPtr     => a0
        lea     Ausgabe_Ts,a1           ;IntuiTextStrPtr => a1

        move.b  #01,(a1)                ;foreground color
        move.b  #00,1(a1)               ;background color
        move.w  #7,4(a1)               ;left edge
        move.w  #08,6(a1)               ;top edge
        move.l  #IDLnk_Other_Text,12(a1)
        moveq.l #0,d0
        bsr     print_locale            ;ausgeben

        moveq   #1,d1                   ;mit Wait()
        bsr     msg_win_msg             ;warte auf Message

        move.l  _MemPtr,a2              ;zeige auf Konfiguration
        lea     other_linker_name(a2),a1 ;zeige auf Namensfeld
        lea     Eingabe,a0              ;zeige auf EingabePuffer
        tst.b   (a0)                    ;Eintrag vorhanden?
        bne.s   .eintragen              ;ja

        move.l  #0,(a1)                 ;Eintrag löschen
        move.l  OldSetup,MakeSetup      ;Flags wieder eintragen
        move.l  OldSetup,new_MakeSetup(a2)

        move.l  #blink,d3               ;BitOffsetregister initialisieren
        move.l  #30,d4                  ;GadgetId => d4
        move.l  OldSetup,d0             ;Flags => d0
        lea     MxTags,a3               ;zeige auf TagItems

        bsr     gad_zurueckstellen      ;auf vorherigen Wert zurückstellen
        bra.s   .close                  ;und Fenster wieder schließen

.eintragen
        move.l  a0,a2                   ;in a2 merken
        bsr     string_kopieren         ;ja, eintragen

        move.l  a2,a0                   ;dto.
        bsr     other_linker_eintragen
.close
        lea     StrGad,a1               ;GadgetPtr übergeben
        bsr     close_msg_win           ;schließen
.ende
        rts

*--------------------------------------

set_lnk_sc

        lea     OptionsSetup,a0
        move.l  #linker_small_code,d1
        bsr     bit_aendern

        move.l  _MemPtr,a0
        move.l  d0,new_OptionsSetup(a0)

        move.w  #1,Config_geaendert
        rts

*--------------------------------------

set_lnk_sd

        lea     OptionsSetup,a0
        move.l  #linker_small_data,d1
        bsr     bit_aendern

        move.l  _MemPtr,a0
        move.l  d0,new_OptionsSetup(a0)

        move.w  #1,Config_geaendert
        rts

*--------------------------------------

set_lnk_nodebug

        lea     OptionsSetup,a0
        move.l  #linker_no_debug,d1
        bsr     bit_aendern

        move.l  _MemPtr,a0
        move.l  d0,new_OptionsSetup(a0)

        move.w  #1,Config_geaendert
        rts

*--------------------------------------

set_lnk_options


        lea     StrGadInfo,a0           ;Zeige auf StringInfoStruktur
        move.w  #256,$A(a0)             ;max. 255 Zeichen zulassen

        move.l  _MemPtr,a0              ;trage die alten Daten in den Puffer
        lea     linker_options(a0),a0
        lea     Eingabe,a1
        bsr     string_kopieren

        bsr     input_window            ;öffne Input Window
        tst.l   d0                      ;geklappt?
        beq.s   .ende                   ;nein

        move.l  _MsgWinRPort,a0         ;RastPortPtr     => a0
        lea     Ausgabe_Ts,a1           ;IntuiTextStrPtr => a1

        move.b  #01,(a1)                ;foreground color
        move.b  #00,1(a1)               ;background color
        move.w  #7,4(a1)                ;left edge
        move.w  #08,6(a1)               ;top edge
        move.l  #IDLnk_Options_Text,12(a1)
        moveq.l #0,d0
        bsr     print_locale            ;ausgeben

        moveq   #1,d1                   ;mit Wait()
        bsr     msg_win_msg             ;warte auf Message

        btst    #9,d0                   ;WindowClose gewählt ?
        bne.s   .close                  ;ja, nichts ändern

        move.l  _MemPtr,a1              ;trage die neuen Daten in die Konfiguration ein
        lea     linker_options(a1),a1
        lea     Eingabe,a0
        bsr     string_kopieren
        move.w  #1,Config_geaendert     ;Flag setzen
.close
        lea     StrGad,a1               ;GadgetPtr übergeben
        bsr     close_msg_win           ;schließen
.ende
        rts

*--------------------------------------
* Module
*--------------------------------------

rem_all_modules

        tst.l   _AvailableModule        ;Array vorhanden?
        beq     .ende                   ;nein

        lea     AvailGad01,a1           ;zeige auf GadgetListe
        move.l  _AvailableModule,a0     ;zeige auf ModuleArray
        move.l  ModuleAnzahl,d0         ;Anzahl => d0
        subq.l  #1,d0                   ;-1 da dbra bis -1 zählt

        moveq.l #0,d1                   ;ZählRegister initialisieren
        moveq.l #0,d2                   ;Flags = 0
.loop
        move.b  #0,31(a0)               ;Markierung löschen

        cmpi.b  #11,d1                  ;die gesamte Anzeige schon bearbeitet?
        bge     .skip                   ;ja

        move.l  d0,-(a7)                ;Register merken

        move.l  d1,d0                   ;Offset => d0
        bsr     toggle_module_gadget    ;Toggle das Gadget

        move.w  gg_Flags(a1),d0         ;GadgetFlags => d0
        bclr    #7,d0                   ;SelectedBit löschen
        move.w  d0,gg_Flags(a1)         ;Flags wieder eintragen
        move.l  (a1),a1                 ;zeige auf nächste GadgetStruktur

        move.l  (a7)+,d0                ;Register wieder herstellen
.skip
        lea     FileSize(a0),a0         ;Ptr auf nächsten Namen eintragen
        addq.l  #1,d1                   ;Zählregister aufaddieren
        dbra    d0,.loop                ;nächsten Eintrag bearbeiten
.ende
        rts

*--------------------------------------

scroller
        tst.l   _AvailableModule        ;Array vorhanden?
        beq.s   .ende                   ;nein

        lea     ScrollerInfo,a0         ;Zeiger auf PropInfoStruktur => a0
        move.w  4(a0),d0                ;aktuelle Pos => d0
        move.l  ModuleAnzahl,d1         ;Anzahl => d1
        subi.w  #11,d1                  ;Größe der Anzeige subtrahieren
        ble     .ende                   ;kleiner oder gleich?
                                        ;dann nichts neu auszugeben
        mulu    d1,d0                   ;mit der Anzahl multiplizieren
        divu    #$FFFF,d0               ;durch den max. Wert dividieren
        andi.l  #$FFFF,d0               ;Divisionsrest löschen
                                        ;das ergibt die neue Startzeile des
                                        ;Displays
        bsr     module_neu_ausgeben     ;und aktualisieren
.ende
        rts

*--------------------------------------
avail
        tst.l   _AvailableModule        ;Array vorhanden?
        beq.s   .ende                   ;nein

        move.w  gg_GadgetID(a0),d0      ;GadgetID => d0
        subi.w  #37,d0                  ;IDOffset subtrahieren = PlatzNr. gewähltes Modul

        move.l  ModuleAnzahl,d1         ;Anzahl => d1
        sub.l   d0,d1                   ;ID größer als tatsächliche Anzahl?
        ble     .ende                   ;ja

        bsr     toggle_module_gadget    ;Toggle das Gadget
.ende
        rts
*--------------------------------------
* toggle_bits
*
* Setzt oder löscht die entsprechenden Bits im angegebenen Flag
* für Mx- und CycleGadgets.
*
* >= d1.l = aktuelle GadgetID
* >= d3.l = BitNr zum Setzen oder Löschen
*
* >= d0.l = neu eingestellte Flags
* >= a0.l = Zeiger auf Flag
*
* kein Rückgaberegister
*--------------------------------------

toggle_bits

        move.l  (a0),d0                 ;Flags zum Bearbeiten => d0
        move.l  d0,OldSetup             ;merken
        add.l   d3,d1                   ;evtl. BitOffset addieren
        moveq.l #2,d2                   ;Schleifenzählregister initialisieren
.loop
        cmp.l   d3,d1                   ;welcher?
        beq.s   .set                    ;gefunden

        bclr    d3,d0                   ;Bit löschen
        bra.s   .next                   ;nächstes Bit bearbeiten
.set
        bset    d3,d0                   ;Bit setzen
.next
        addq.l  #1,d3                   ;Register aufaddieren
        dbra    d2,.loop                ;bis alle geprüft

        move.l  d0,(a0)                 ;Flag wieder eintragen
        rts

*--------------------------------------
* bit_aendern
*
* Setzt oder löscht das angegebene Bit im Flag
* nach Aktivitätszustand des Gadgets
*
* >= d1.l = BitNr zum Setzen oder Löschen
* >= d2.l = GadgetActivationFlag
*
* >= d0.l = neu eingestellte Flags
* >= a0.l = Zeiger auf Flag
*
* kein Rückgaberegister
*--------------------------------------

bit_aendern

        move.l  (a0),d0                 ;Flags zum Bearbeiten => d0
        btst    #7,d2                   ;welcher Zustand?
        beq.s   .deactiviert            ;Gadget deaktiviert

        bset    d1,d0                   ;Bit setzen
        bra.s   .merken                 ;wieder eintragen

.deactiviert
        bclr    d1,d0                   ;Bit löschen

.merken
        move.l  d0,(a0)                 ;Flags wieder eintragen
        rts

*--------------------------------------

* >= d0.l = SetupFlag
* >= d3.l = BitNr
* >= d4.l = GadgetId
* >= a3.l = Zeiger auf TagItems

*--------------------------------------
gad_zurueckstellen

        move.l  d3,d1                   ;in d1 bearbeiten
        moveq.l #2,d2                   ;Schleifenzählregister initialisieren
.loop
        btst    d1,d0                   ;welcher?
        bne.s   .gefunden               ;gefunden

.next
        addq.l  #1,d1                   ;Register aufaddieren
        dbra    d2,.loop                ;bis alle geprüft

        bra.s   .ende                   ;zur Sicherheit, falls keiner
                                        ;gefunden wurde

.gefunden

        sub.l   d3,d1                   ;ermittle die GadgetNr.
        move.l  d1,12(a3)               ;in die TagItems eintragen

        lea     _Gadget_Ptr_MainWin,a0  ;zeige auf GadgetPtrAblage
        lsl.l   #2,d4                   ;* 4 da long
        move.l  0(a0,d4),a0             ;GadgetPtr => a0


        move.l  _MainWinPtr,a1          ;WindowPtr => a1

        bsr     gadgets_freigeben       ;müssen ans Fenster gebunden sein,
                                        ;sonst Absturz

        bsr     gt_set_gadget_attrs_a   ;ändern

        bsr     gadgets_sperren         ;jetzt wieder entfernen, wir sind
                                        ;noch nicht fertig
.ende
        rts
*--------------------------------------
