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
* Menue auswerten
*
* >= d1 = Menue-Flags des Events
*--------------------------------------

menue
        cmpi    #$FFFF,d1               ;Menüpunkt gewählt?
        beq.s   .ende                   ;nein, beenden

* berechne die Untermenü-Nr.
*---------------------------
        move.l  d1,d2                   ;zum Bearbeiten => d2

        lsr.l   #7,d2
        lsr.l   #4,d2                   ;um 11 Bits nach rechts schieben
                                        ;= Menue und Menüpunkt eliminieren
        lsl.l   #2,d2                   ;mit 4 multiplizieren,
                                        ;da Langwort-Offset

* berechne den Menüpunkt
*-----------------------
        move.l  d1,d0                   ;in d0 für Menü-Auswertung merken
        andi.l  #$7E0,d1                ;#%11111100000 =>lösche die unteren
                                        ;5 Bits
        lsr.l   #3,d1                   ;dann dividiere durch 8 =>
                                        ;Menuepunkt * 4 in d1

* berechne das Menü
*------------------
        andi.l  #$1F,d0                 ;#%00000011111 => lösche die
                                        ;oberen Bits => Menü-Nr.
        lsl.l   #2,d0                   ;* 4 da Langwort-Offset

* berechne die Adresse des auszuführenden Unterprogrammes
*--------------------------------------------------------
        lea     menu,a0                 ;Zeiger auf MenueTabelle => a0
        move.l  0(a0,d0),a0             ;Zeiger auf MenuePunktTabelle => a0
        move.l  0(a0,d1),a0             ;Zeiger auf Unterprogramm => a0
        jsr     (a0)                    ;und ausführen
.ende
        rts

*--------------------------------------

menue1  dc.l    open_file,view_file,0
        dc.l    rename_file,copy_file,delete_file,print_file,0
        dc.l    execute_prg,spawnshell,0
        dc.l    aide_setup,0
        dc.l    load_conf,save_conf,0
        dc.l    about,iconify,0
        dc.l    prg_beenden

menue2  dc.l    calculator,reqed.exe,0
        dc.l    bmapfiles,0
        dc.l    ab_to_ascii,0
        dc.l    uppercacer.exe,0
        dc.l    util0.exe,util1.exe,util2.exe,util3.exe

menue3  dc.l    aide.doc,0
        dc.l    ace.doc,superopt.doc,0
        dc.l    a68k.doc,phxass.doc,0
        dc.l    blink.doc,phxlnk.doc,0
        dc.l    aceref.doc,acewords.doc,aceexamples.doc,0
        dc.l    acehistory.doc,0
        dc.l    acecalc.doc,reqed.doc

menu    dc.l    menue1,menue2,menue3

*--------------------------------------
* open_file
*
* Aktiviert den Editor für ein zu selectierendes File
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

open_file

        tst.l   editor                  ;Editor definiert?
        beq     .abort                  ;nein

        movem.l d0/d6/a0-a1,-(a7)

        tst.b   curr_open_dir           ;Directoryname angegeben?
        bne.s   .skip                   ;ja

        lea     default_ace_dir,a0      ;nein, DefaultDirName eintragen
        lea     curr_open_dir,a1
        bsr     string_kopieren
.skip
        move.l  #curr_open_dir,_fr_Dirname
        move.l  #curr_open_file,_fr_Filename
        move.l  #IDladen_Text,ASLReqTitel

        bsr     asl_req_laden           ;ASL-Filerequester ausgeben
        tst.l   d0                      ;alles ok?
        beq     .ende                   ;nein

        tst.b   TempFile                ;File gewählt?
        beq.s   .ende                   ;nein

        bsr     dateiname_besorgen      ;Name zusammensetzen
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        lea     curr_open_dir,a1        ;aktuellen Dirnamen merken
        lea     TempDir,a0
        bsr     string_kopieren

        lea     curr_open_file,a1       ;aktuellen Filenamen merken
        lea     TempFile,a0
        bsr     string_kopieren

        move.l  editor,a0               ;zeige auf den Editornamen
        move.l  _BufferPtr,a1           ;als Commandoablage benutzen
        move.l  a1,d6                   ;in d6 übergeben
        bsr     string_kopieren         ;Editorname incl. Directory eintragen

        move.l  d1,a0                   ;zeige auf den kompletten Namen
        move.b  #" ",(a1)+              ;Space anfügen
        move.b  #34,(a1)+               ;Anführungszeichen
        bsr     string_kopieren         ;eintragen
        move.b  #34,(a1)+               ;Anführungszeichen eintragen
        move.b  #00,(a1)                ;Nullbyte

        move.l  #1,AsynchFlag           ;läuft asynchron
        bsr     program_ausfuehren      ;und ausführen
.ende
        movem.l (a7)+,d0/d6/a0-a1
.abort
        rts

*--------------------------------------
* view_file
*
* Aktiviert den Viewer für ein zu selectierendes File
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

view_file

        tst.l   viewer                  ;Viewer definiert?
        bne.s   .start                  ;ja

        tst.l   agdtool                 ;Amigaguide definiert?
        beq     .abort                  ;nein
.start
        movem.l d0-d6/a0-a1,-(a7)

        tst.b   curr_view_dir           ;Directoryname angegeben?
        bne.s   .skip                   ;ja

        lea     default_ace_dir,a0      ;nein, DefaultDirname eintragen
        lea     curr_view_dir,a1
        bsr     string_kopieren
.skip
        move.l  #curr_view_dir,_fr_Dirname
        move.l  #curr_view_file,_fr_Filename
        move.l  #IDview_Text,ASLReqTitel

        bsr     asl_req_laden           ;ASL-Filerequester ausgeben
        tst.l   d0                      ;alles ok?
        beq     .ende                   ;nein

        tst.b   TempFile                ;File gewählt?
        beq.s   .ende                   ;nein

        bsr     dateiname_besorgen      ;Name zusammensetzen
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        lea     curr_view_dir,a1        ;aktuellen Dirnamen merken
        lea     TempDir,a0
        bsr     string_kopieren

        lea     curr_view_file,a1       ;aktuellen Filenamen merken
        lea     TempFile,a0
        bsr     string_kopieren

        move.l  viewer,a0               ;zeige auf den Viewernamen
        move.l  _BufferPtr,a1           ;als Commandoablage benutzen
        move.l  a1,d6                   ;in d6 übergeben
        bsr     string_kopieren         ;Editorname incl. Directory eintragen

        move.l  d1,a0                   ;zeige auf den kompletten Namen
        move.b  #" ",(a1)+              ;Space anfügen
        move.b  #34,(a1)+               ;Anführungszeichen
        bsr     string_kopieren         ;eintragen
        move.b  #34,(a1)+
        move.b  #00,(a1)

        move.l  #1,AsynchFlag           ;läuft asynchron
        bsr     program_ausfuehren      ;und ausführen
.ende
        movem.l (a7)+,d0-d6/a0-a1
.abort
        rts

*--------------------------------------

rename_file

        movem.l d0-d6/a0-a1,-(a7)

        tst.b   curr_rename_dir         ;Directoryname angegeben?
        bne.s   .skip                   ;ja

        lea     default_ace_dir,a0      ;nein, Default-Dirname eintragen
        lea     curr_rename_dir,a1
        bsr     string_kopieren
.skip
        move.l  #curr_rename_dir,_fr_Dirname
        move.l  #curr_rename_file,_fr_Filename
        move.l  #IDrename_Text1,ASLReqTitel

        bsr     asl_req_laden           ;ASL-Filerequester ausgeben
        tst.l   d0                      ;alles ok?
        beq     .ende                   ;nein

        tst.b   TempFile                ;File gewählt?
        beq     .ende                   ;nein

        bsr     dateiname_besorgen      ;Name zusammensetzen
        tst.l   d0                      ;alles ok?
        bmi     .ende                   ;nein

        lea     Dateiname,a0            ;zeige auf den kompletten Namen
        lea     curr_rename_fullname1,a1 ;zeige auf die Ablage
        bsr     string_kopieren         ;und eintragen

        lea     curr_rename_dir,a1      ;aktuellen Dirnamen merken
        lea     TempDir,a0
        bsr     string_kopieren

        lea     curr_rename_file,a1     ;aktuellen Filenamen merken
        lea     TempFile,a0
        bsr     string_kopieren

        move.l  #IDrename_Text2,ASLReqTitel

        bsr     asl_req_laden           ;ASL-Filerequester ausgeben
        tst.l   d0                      ;alles ok?
        beq     .ende                   ;nein

        tst.b   TempFile                ;File gewählt?
        beq.s   .ende                   ;nein

        move.b  #1,sichern_Flag         ;Flag setzen
        bsr     dateiname_besorgen      ;Name zusammensetzen
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        lea     Dateiname,a0            ;zeige auf den kompletten Namen
        lea     curr_rename_fullname2,a1 ;zeige auf die Ablage
        bsr     string_kopieren         ;und eintragen


        move.l  #curr_rename_fullname1,d1 ;zeige auf den alten Namen
        move.l  #curr_rename_fullname2,d2 ;zeige auf den neuen Namen
        bsr     rename                  ;und ausführen

        bsr     submods_aktualisieren   ;Liste aktualisieren, evtl. geändert
.ende
        move.b  #0,sichern_Flag         ;Flag löschen

        movem.l (a7)+,d0-d6/a0-a1
        rts

*--------------------------------------

copy_file

        movem.l d0-d6/a0-a1,-(a7)

        tst.b   curr_copy_dir           ;Directoryname angegeben?
        bne.s   .skip                   ;ja

        lea     default_ace_dir,a0      ;nein, Default-Dirname eintragen
        lea     curr_copy_dir,a1
        bsr     string_kopieren
.skip
        move.l  #curr_copy_dir,_fr_Dirname
        move.l  #curr_copy_file,_fr_Filename
        move.l  #IDcopy_Text1,ASLReqTitel

        bsr     asl_req_laden           ;ASL-Filerequester ausgeben
        tst.l   d0                      ;alles ok?
        beq     .ende                   ;nein

        tst.b   TempFile                ;File gewählt?
        beq     .ende                   ;nein

        bsr     dateiname_besorgen      ;Name zusammensetzen
        tst.l   d0                      ;alles ok?
        bmi     .ende                   ;nein

        lea     Dateiname,a0            ;zeige auf den kompletten Namen
        lea     curr_copy_fullname1,a1  ;zeige auf die Ablage
        bsr     string_kopieren         ;und eintragen

        lea     curr_copy_dir,a1        ;aktuellen Dirnamen merken
        lea     TempDir,a0
        bsr     string_kopieren

        lea     curr_copy_file,a1       ;aktuellen Filenamen merken
        lea     TempFile,a0
        bsr     string_kopieren

        move.l  #IDcopy_Text2,ASLReqTitel

        bsr     asl_req_laden           ;ASL-Filerequester ausgeben
        tst.l   d0                      ;alles ok?
        beq     .ende                   ;nein

        tst.b   TempFile                ;File gewählt?
        beq.s   .ende                   ;nein

        move.b  #1,sichern_Flag         ;Flag setzen
        bsr     dateiname_besorgen      ;Name zusammensetzen
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein
        move.b  #0,sichern_Flag         ;Flag löschen

        lea     Dateiname,a0            ;zeige auf den kompletten Namen
        lea     curr_copy_fullname2,a1  ;zeige auf die Ablage
        bsr     string_kopieren         ;und eintragen

        move.l  #curr_copy_fullname1,d1 ;zeige auf den Namen
        moveq   #0,d2
        moveq   #0,d3
        bsr     datei_laden             ;Datei laden
        tst.l   d0                      ;alles okay?
        bmi.s   .ende                   ;nein

        move.l  #curr_copy_fullname2,d1 ;zeige auf den neuen Namen
        bsr     datei_sichern           ;und zurückschreiben

        move.l  d2,a1                   ;Zeiger auf Speicher => a1
        bsr     free_vec                ;und wieder freigeben

        bsr     submods_aktualisieren   ;Liste aktualisieren, evtl. geändert
.ende
        movem.l (a7)+,d0-d6/a0-a1
        rts


*--------------------------------------

delete_file


        movem.l d0-d6/a0-a1,-(a7)

        tst.b   curr_delete_dir         ;Directoryname angegeben?
        bne.s   .skip                   ;ja

        lea     default_ace_dir,a0      ;nein, Default-Dirname eintragen
        lea     curr_delete_dir,a1
        bsr     string_kopieren
.skip
        move.l  #curr_delete_dir,_fr_Dirname
        move.l  #DummyBuffer,_fr_Filename
        move.l  #IDdelete_Text,ASLReqTitel

        bsr     asl_req_sichern         ;ASL-Filerequester ausgeben
        tst.l   d0                      ;alles ok?
        beq     .ende                   ;nein

        tst.b   TempFile                ;File gewählt?
        beq     .ende                   ;nein

        bsr     dateiname_besorgen      ;Name zusammensetzen
        tst.l   d0                      ;alles ok?
        bmi     .ende                   ;nein

        lea     curr_delete_dir,a1      ;aktuellen Dirnamen merken
        lea     TempDir,a0
        bsr     string_kopieren

        move.l  #Dateiname,d1           ;zeige auf den Namen
        bsr     dos_delete_file         ;und ausführen

        bsr     submods_aktualisieren   ;Liste aktualisieren, evtl. geändert
.ende
        movem.l (a7)+,d0-d6/a0-a1
        rts


*--------------------------------------

print_file

        movem.l d0-d6/a0-a1,-(a7)

        tst.b   curr_print_dir          ;Directoryname angegeben?
        bne.s   .skip                   ;ja

        lea     default_ace_dir,a0      ;nein, Default-Dirname eintragen
        lea     curr_print_dir,a1
        bsr     string_kopieren
.skip
        move.l  #curr_print_dir,_fr_Dirname
        move.l  #curr_print_file,_fr_Filename
        move.l  #IDprint_Text,ASLReqTitel

        bsr     asl_req_laden           ;ASL-Filerequester ausgeben
        tst.l   d0                      ;alles ok?
        beq     .ende                   ;nein

        tst.b   TempFile                ;File gewählt?
        beq.s   .ende                   ;nein

        bsr     dateiname_besorgen      ;Name zusammensetzen
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        lea     curr_print_dir,a1       ;aktuellen Dirnamen merken
        lea     TempDir,a0
        bsr     string_kopieren

        lea     curr_print_file,a1      ;aktuellen Filenamen merken
        lea     TempFile,a0
        bsr     string_kopieren

        move.l  #Dateiname,d1           ;zeige auf den Namen
        bsr     print_datei
.ende
        movem.l (a7)+,d0-d6/a0-a1
        rts

*--------------------------------------

* >= d1.l = Zeiger auf den Dateinamen des zu druckenden Files

print_datei

        movem.l d0-d7/a0-a6,-(a7)

        moveq   #0,d2                   ;kein Puffer vorhanden
        moveq   #0,d3                   ;Größe unbekannt
        bsr     datei_laden             ;Datei laden
        move.l  d2,d7                   ;PufferPtr in d7 merken
        tst.l   d0                      ;alles okay?
        bmi.s   .ende                   ;nein
.open
        move.l  #printer_name,d1        ;zeige auf den Namen PRT:
        move.l  #1006,d2                ;Modus = "neu" => d2
        CALLDOS Open                    ;Datei oeffnen
        move.l  d0,d6                   ;FileHandle => d6 merken
        bne.s   .write                  ;alles ok, weitermachen

        bsr     printer_open_error      ;Fehlermeldung ausgeben
        bra.s   .ende                   ;und beenden
.write
        move.l  d6,d1                   ;FileHandle wieder => d1
        move.l  d7,d2                   ;Zeiger auf Speicher => d2
                                        ;Filegröße steht in d3
        CALLDOS Write                   ;schreiben
        tst.l   d0                      ;alles ok ?
        bpl.s   .close                  ;ja

        bsr     printer_error           ;Fehlermeldung ausgeben
        tst.l   d0                      ;welche Antwort ?
        bne.s   .write                  ;mit 'Retry' beantwortet
        bra.s   .ende                   ;mit 'Cancel' beantwortet
.close
        move.l  d6,d1                   ;FileHandle übergeben
        bsr     close_datei             ;Drucker wieder schließen
.ende
        move.l  d7,a1                   ;Zeiger auf Speicher => a1
        bsr     free_vec                ;und wieder freigeben

        movem.l (a7)+,d0-d7/a0-a6
        rts

*--------------------------------------

execute_prg

        movem.l d0/a0,-(a7)

        bsr     execute_prg_win         ;StringEingabeFenster öffnen
        tst.l   d0                      ;geklappt ?
        beq     .ende                   ;nein

        move.l  _BufferPtr,a0           ;zeige auf KommandoPuffer
        tst.b   (a0)                    ;String angegeben?
        beq.s   .ende                   ;nein

        bsr     execute_utility         ;und ausführen
.ende
        movem.l (a7)+,d0/a0
        rts

*--------------------------------------

spawnshell

        lea     spawn_shell_string,a0   ;Cmd-String übergeben
        bsr     execute_utility         ;und ausführen

        rts

*--------------------------------------

aide_setup

        bsr     open_setup_win          ;Setup durchführen

        bsr     set_config              ;auf die geänderten Einstellungen reagieren
        bsr     set_old_current_dir     ;auf evtl. geändertes TMP-Dir reagieren
        bsr     set_current_program_dir

        bsr     open_main_win           ;jetzt MainWin wieder öffnen
        tst.l   d0                      ;geklappt?
        beq.s   .fehler                 ;nein

        bsr     gadgets_sperren         ;Gadgets sperren, wir sind noch nicht fertig
        bra.s   .ok

.fehler
        moveq.l #-1,d0                  ;Programm beenden, MainWin nicht offen
        bra.s   .ende
.ok
        tst     ModDirChanged           ;geändert?
        beq.s   .skip                   ;nein

        bsr     submods_aktualisieren   ;ja, Liste aktualisieren
        move.w  #0,ModDirChanged        ;Flag löschen
.skip
        moveq.l #0,d0
.ende
        rts

*--------------------------------------

load_conf

        tst.w   Config_geaendert        ;Configuration geändert?
        beq.s   .continue               ;nein

        bsr     config_changed          ;ja, Meldung ausgeben
        tst.l   d0                      ;welche Antwort?
        beq.s   .continue               ;Nein gewählt

        bsr     save_other_config       ;"sichern als" aufrufen

.continue

        lea     load_conf_table,a0      ;zeige auf Tabelle
        move.l  0(a0,d2),a0             ;Zeiger auf Unterprogramm => a0
        jsr     (a0)                    ;ausführen
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        bsr     test                    ;gadgets_mainwin_aktualisieren

        bsr     submods_aktualisieren   ;Liste aktualisieren

        move.l  _MainWinPtr,a0          ;Fenster auffrischen
        bsr     gt_begin_refresh
        bsr     gt_end_refresh

        bsr     clean_up_settings
.ende
        rts

*--------------------------------------

*gadgets_mainwin_aktualisieren

test

        movem.l d0-d7/a0-a6,-(a7)

        move.l  MakeSetup,d1            ;Flags => d1
.nap
        moveq   #nap,d0
        btst    d0,d1                   ;Flag gesetzt?
        beq.s   .acpp                   ;nein

        bra.s   .preco_einstellen       ;ja, einstellen
.acpp
        moveq   #acpp,d0
        btst    d0,d1
        beq.s   .preco_other

        bra.s   .preco_einstellen

.preco_other
        moveq   #preco_other,d0

.preco_einstellen
        bsr     preco_gad_einstellen

        bsr     aceopt_gads_einstellen

        bsr     sopt_gad_einstellen

.a68k
        moveq   #a68k,d0
        btst    d0,d1
        beq.s   .phxass

        bra.s   .ass_einstellen
.phxass
        moveq   #phxass,d0
        btst    d0,d1
        beq.s   .ass_other

        bra.s   .ass_einstellen

.ass_other
        moveq   #ass_other,d0

.ass_einstellen
        subq    #a68k,d0
        bsr     ass_gad_einstellen

        bsr     assopt_gads_einstellen

        bsr     lnklib_gad_einstellen

.blink
        moveq   #blink,d0
        btst    d0,d1
        beq.s   .phxlnk

        bra.s   .lnk_einstellen
.phxlnk
        moveq   #phxlnk,d0
        btst    d0,d1
        beq.s   .lnk_other

        bra.s   .lnk_einstellen

.lnk_other
        moveq   #lnk_other,d0

.lnk_einstellen
        subi.w  #blink,d0
        bsr     lnk_gad_einstellen

        bsr     lnkopt_gads_einstellen

.ende
        movem.l (a7)+,d0-d7/a0-a6
        rts

*--------------------------------------

load_conf_table
        dc.l    load_default_config,load_other_config

*--------------------------------------

save_conf

        lea     save_conf_table,a0
        move.l  0(a0,d2),a0
        jsr     (a0)

        rts

*--------------------------------------

save_conf_table
        dc.l    save_default_config,save_other_config

*--------------------------------------

about
        bsr     about_box
        rts

*--------------------------------------

prg_beenden

        bsr     beenden_requester       ;Requester ausgeben
        tst.l   d0                      ;welche Antwort ?
        beq.s   .ende                   ;"nein" gewählt

        tst.w   Config_geaendert        ;Configuration geändert?
        beq.s   .clean_up               ;nein

        bsr     config_changed          ;ja, Meldung ausgeben
        tst.l   d0                      ;welche Antwort?
        beq.s   .clean_up               ;Nein gewählt

        bsr     save_other_config       ;"sichern als" aufrufen

.clean_up
        tst.l   CleanUpFlag             ;temporäre Files löschen?
        beq.s   .flag                   ;nein

        bsr     clean_up_files          ;alle temporären Files löschen
.flag
        moveq.l #-1,d0                  ;Antwort -1 = beenden zurückgeben
.ende
        rts

*--------------------------------------

calculator

        move.l  _MemPtr,a0              ;zeige auf Konfiguration
        lea     new_calc(a0),a0         ;zeige auf den Eintrag
        tst.b   (a0)                    ;angegeben?
        beq.s   .ende                   ;nein

        bsr     execute_utility         ;und ausführen
.ende
        rts

*--------------------------------------

reqed.exe

        move.l  _MemPtr,a0
        lea     new_reqed(a0),a0
        tst.b   (a0)
        beq.s   .ende

        bsr     execute_utility
.ende
        rts

*--------------------------------------

bmapfiles

        movem.l d0-d7/a0-a6,-(a7)

        moveq   #0,d3                   ;Register löschen!!!!!

        move.l  _MemPtr,a0              ;zeige auf Konfiguration
        lea     new_fd_dir(a0),a2       ;zeige auf FD-Dir
        tst.b   (a2)                    ;Eintrag vorhanden?
        beq     .ende                   ;nein

        lea     new_fdtobmap(a0),a3     ;zeige auf FD-Tool
        tst.b   (a3)                    ;Eintrag vorhanden?
        beq     .ende                   ;nein

        move.l  a2,_fr_Dirname          ;zeige auf Dirname
        move.l  #DummyBuffer,_fr_Filename
                                        ;keine Vorgabe für den Filenamen
        move.l  #IDbmaps_Text,ASLReqTitel ;Zeiger auf Titel eintragen
        move.w  #1,MultiSelectFlag      ;MultiSelect erlaubt
        bsr     asl_req_laden           ;ASL-Filerequester ausgeben
        tst.l   d0                      ;alles ok?
        beq     .ende                   ;nein

        move.w  #0,MultiSelectFlag      ;alles erledigt, Flag löschen

        tst.b   TempFile                ;Eintrag vorhanden?
        beq.s   .skip                   ;nein

        bsr     execute_fd2bmap         ;ja, ausführen
        bra.s   .ende                   ;und beenden

.skip
        tst.l   _FileListPuffer         ;Puffer angelegt?
        beq.s   .ende                   ;nein

        move.l  _FileListPuffer,a2      ;Zeiger auf Puffer => a2
        lea     TempFile,a4             ;zeige auf Filenamenablage

        move.l  FileListAnzahl,d4       ;Anzahl => d4
        subq    #1,d4                   ;Schleifen-Zählregister -1
.loop
        move.l  a2,a0                   ;zeige auf Filenamen
        move.l  a4,a1                   ;Zeiger auf Puffer => a1
        bsr     string_kopieren         ;eintragen

        bsr     execute_fd2bmap         ;und ausführen
        tst.l   d0                      ;alles ok?
        bmi     .ende                   ;nein

        add.l   #32,a2                  ;StringOffset addieren
        dbra    d4,.loop

        move.l  _FileListPuffer,a1      ;Zeiger auf Puffer => a1
        bsr     free_vec                ;und freigeben
        move.l  #0,_FileListPuffer      ;Zeiger löschen
        move.l  #0,TempFile             ;Eintrag löschen
.ende
        move.l  d3,d1                   ;Handle => d1
        beq.s   .exit                   ;kein Handle vorhanden

        bsr     close_datei             ;Fenster wieder schließen
.exit
        movem.l (a7)+,d0-d7/a0-a6
        rts

*--------------------------------------

execute_fd2bmap

        bsr     dateiname_besorgen      ;Name zusammensetzen
        tst.l   d0                      ;alles ok?
        bmi     .ende                   ;nein

        move.l  a3,a0                   ;zeige auf den Namen des Tools
        move.l  _BufferPtr,a1           ;als Cmd-Puffer benutzen
        move.l  a1,d6                   ;in d6 übergeben

        bsr     string_kopieren         ;und eintragen
        move.b  #" ",(a1)+              ;NullByte mit Space überschreiben

        lea     Dateiname,a0            ;zeige auf den Filenamen
        bsr     string_kopieren         ;und eintragen
.loop
        cmpi.b  #"_",-(a1)              ;suche den Unterstrich
        bne.s   .loop                   ;bis gefunden
        move.b  #" ",(a1)+              ;Unterstrich mit Space überschreiben

        lea     default_bmap_dir,a0     ;zeige auf Zieldirectory
        bsr     string_kopieren         ;und eintragen

        tst.l   d3                      ;Handle schon vorhanden?
        bne.s   .skip                   ;ja

        bsr     shell_win_oeffnen       ;Fenster öffnen
        move.l  d0,d3                   ;Handle merken
        bmi.s   .ende                   ;fehlgeschlagen
.skip
        lea     run_tags,a1             ;zeige auf Tagitems
        move.l  d3,12(a1)               ;Input Handle eintragen
        move.l  d6,d1                   ;CmdString in d1 übergeben
        move.l  a1,d2                   ;TagItems in d2 übergeben
        bsr     dos_system_taglist      ;ausführen
        tst.l   d0                      ;alles ok?
        beq.s   .ende                   ;ja

        moveq   #-1,d0                  :melde Fehler
.ende
        rts

*--------------------------------------

ab_to_ascii

        movem.l d0-d7/a0-a6,-(a7)

        moveq   #0,d3                   ;Register löschen
        clr.l   curr_basic_file         ;Eintrag löschen

        move.l  _MemPtr,a0              ;zeige auf Konfiguration
        lea     new_abtoascii(a0),a3    ;zeige auf Tool
        tst.b   (a3)                    ;Eintrag vorhanden?
        beq     .ende                   ;nein

        tst.b   curr_basic_dir          ;Directoryname angegeben?
        bne.s   .skip1                  ;ja

        lea     default_ace_dir,a0      ;nein, Default-Dirname eintragen
        lea     curr_basic_dir,a1
        bsr     string_kopieren
.skip1
        move.l  #curr_basic_dir,_fr_Dirname
        move.l  #DummyBuffer,_fr_Filename
        move.l  #IDab2ascii_Text1,ASLReqTitel
        move.w  #1,MultiSelectFlag      ;MultiSelect erlaubt

        bsr     asl_req_laden           ;ASL-Filerequester ausgeben
        tst.l   d0                      ;alles ok?
        beq     .ende                   ;nein

        move.w  #0,MultiSelectFlag      ;alles erledigt, Flag löschen

        lea     TempDir,a0              ;Sourcedirectory merken
        lea     curr_basic_dir,a1
        bsr     string_kopieren

        tst.b   TempFile                ;Eintrag vorhanden?
        beq     .skip2                  ;nein

        lea     TempFile,a0             ;ja, Name merken
        lea     curr_basic_file,a1
        bsr     string_kopieren
.skip2
        tst.b   curr_basic_dest_dir     ;Eintrag vorhanden ?
        beq.s   .skip3                  ;nein

        move.l  #curr_basic_dest_dir,_fr_Dirname
.skip3
        move.l  #DummyBuffer,_fr_Filename
        move.l  #IDab2ascii_Text2,ASLReqTitel

        bsr     asl_req_laden           ;ASL-Filerequester ausgeben
        tst.l   d0                      ;alles ok?
        beq     .ende                   ;nein

        lea     TempDir,a0              ;Zieldirectory merken
        lea     curr_basic_dest_dir,a1
        bsr     string_kopieren

        lea     TempDir,a1              ;Sourcedirectory zurückschreiben
        lea     curr_basic_dir,a0
        bsr     string_kopieren

        tst.b   curr_basic_file         ;Eintrag vorhanden?
        beq     .skip4                  ;nein

        lea     TempFile,a1             ;ja, Name zurückschreiben
        lea     curr_basic_file,a0
        bsr     string_kopieren

        bsr     execute_ab2ascii        ;ja, ausführen
        bra.s   .ende                   ;und beenden

.skip4
        tst.l   _FileListPuffer         ;Puffer angelegt?
        beq.s   .ende                   ;nein

        move.l  _FileListPuffer,a2      ;Zeiger auf Puffer => a2
        lea     TempFile,a4             ;zeige auf Filenamenablage

        move.l  FileListAnzahl,d4       ;Anzahl => d4
        subq    #1,d4                   ;Schleifen-Zählregister -1
.loop
        move.l  a2,a0                   ;zeige auf Filenamen
        move.l  a4,a1                   ;Zeiger auf Puffer => a1
        bsr     string_kopieren         ;eintragen

        bsr     execute_ab2ascii        ;und ausführen
        tst.l   d0                      ;alles ok?
        bmi     .ende                   ;nein

        add.l   #32,a2                  ;StringOffset addieren
        dbra    d4,.loop

        move.l  _FileListPuffer,a1      ;Zeiger auf Puffer => a1
        bsr     free_vec                ;und freigeben
        move.l  #0,_FileListPuffer      ;Zeiger löschen
        move.l  #0,TempFile             ;Eintrag löschen
.ende
        move.l  d3,d1                   ;Handle => d1
        beq.s   .exit                   ;kein Handle vorhanden

        bsr     close_datei             ;Fenster wieder schließen
.exit
        movem.l (a7)+,d0-d7/a0-a6
        rts

*--------------------------------------

execute_ab2ascii

        bsr     dateiname_besorgen      ;Name zusammensetzen
        tst.l   d0                      ;alles ok?
        bmi     .ende                   ;nein

        move.l  a3,a0                   ;zeige auf den Namen des Tools
        move.l  _BufferPtr,a1           ;als Cmd-Puffer benutzen
        move.l  a1,d6                   ;in d6 übergeben
        bsr     string_kopieren         ;und eintragen
        move.b  #" ",(a1)+              ;NullByte mit Space überschreiben
        move.b  #"<",(a1)+              ;< anfügen

        lea     Dateiname,a0            ;zeige auf den Filenamen
        bsr     string_kopieren         ;und eintragen
        move.b  #" ",(a1)+              ;NullByte mit Space überschreiben
        move.b  #">",(a1)+              ;> anfügen

        move.l  a1,d1                   ;in d1 zur Prüfung merken
        lea     curr_basic_dest_dir,a0  ;zeige auf Zieldirectory
        bsr     string_kopieren         ;und eintragen

        move.w  #1,pruef_Flag           ;Flag setzen

        bsr     pruefe_den_dirnamen     ;Namen überprüfen
        tst.l   d0                      ;alles ok?
        bmi     .ende                   ;nein

        clr.w   pruef_Flag              ;Flag löschen

        lea     TempFile,a0             ;zeige auf den Filenamen
        bsr     string_kopieren         ;und eintragen
        move.b  #".",(a1)+              ;. anfügen
        move.b  #"b",(a1)+              ;b anfügen
        move.b  #0,(a1)+                ;NULLByte anfügen

        tst.l   d3                      ;Handle schon vorhanden?
        bne.s   .skip                   ;ja

        bsr     shell_win_oeffnen       ;Fenster öffnen
        move.l  d0,d3                   ;Handle merken
        bmi.s   .ende                   ;fehlgeschlagen
.skip
        lea     run_tags,a1             ;zeige auf Tagitems
        move.l  d3,12(a1)               ;Input Handle eintragen
        move.l  d6,d1                   ;CmdString in d1 übergeben
        move.l  a1,d2                   ;TagItems in d2 übergeben
        bsr     dos_system_taglist      ;ausführen
        tst.l   d0                      ;alles ok?
        beq.s   .ende                   ;ja

        moveq   #-1,d0                  ;melde Fehler
.ende
        rts

*--------------------------------------

uppercacer.exe


        movem.l d0-d7/a0-a6,-(a7)

        moveq   #0,d3                   ;Register löschen!!!!!

        move.l  _MemPtr,a0              ;zeige auf Konfiguration
        lea     new_src_dir(a0),a2      ;zeige auf Dir
        tst.b   (a2)                    ;Eintrag vorhanden?
        beq     .ende                   ;nein

        move.l  _MemPtr,a0              ;zeige auf Konfiguration
        lea     new_uppercacer(a0),a3   ;zeige auf ToolEintrag
        tst.b   (a3)                    ;Eintrag vorhanden?
        beq     .ende                   ;nein

        move.l  a2,_fr_Dirname          ;zeige auf Dirname
        move.l  #DummyBuffer,_fr_Filename
        move.l  #IDset_source_Text,ASLReqTitel ;Zeiger auf Titel eintragen
        move.w  #1,MultiSelectFlag      ;MultiSelect erlaubt
        bsr     asl_req_laden           ;ASL-Filerequester ausgeben
        tst.l   d0                      ;alles ok?
        beq     .ende                   ;nein

        move.w  #0,MultiSelectFlag      ;alles erledigt, Flag löschen

        tst.b   TempFile                ;Eintrag vorhanden?
        beq.s   .skip                   ;nein

        bsr     execute_uppercacer      ;ja, ausführen
        bra.s   .ende                   ;und beenden

.skip
        tst.l   _FileListPuffer         ;Puffer angelegt?
        beq.s   .ende                   ;nein

        move.l  _FileListPuffer,a2      ;Zeiger auf Puffer => a2
        lea     TempFile,a4             ;zeige auf Filenamenablage

        move.l  FileListAnzahl,d4       ;Anzahl => d4
        subq    #1,d4                   ;Schleifen-Zählregister -1
.loop
        move.l  a2,a0                   ;zeige auf Filenamen
        move.l  a4,a1                   ;Zeiger auf Puffer => a1
        bsr     string_kopieren         ;eintragen

        bsr     execute_uppercacer      ;und ausführen
        tst.l   d0                      ;alles ok?
        bmi     .ende                   ;nein

        add.l   #32,a2                  ;StringOffset addieren
        dbra    d4,.loop

        move.l  _FileListPuffer,a1      ;Zeiger auf Puffer => a1
        bsr     free_vec                ;und freigeben
        move.l  #0,_FileListPuffer      ;Zeiger löschen
        move.l  #0,TempFile             ;Eintrag löschen
.ende
        move.l  d3,d1                   ;Handle => d1
        beq.s   .exit                   ;kein Handle vorhanden

        bsr     close_datei             ;Fenster wieder schließen
.exit
        movem.l (a7)+,d0-d7/a0-a6
        rts

*--------------------------------------

execute_uppercacer

        bsr     dateiname_besorgen      ;Name zusammensetzen
        tst.l   d0                      ;alles ok?
        bmi     .ende                   ;nein

        move.l  a3,a0                   ;zeige auf den Namen des Tools
        move.l  _BufferPtr,a1           ;als Cmd-Puffer benutzen
        move.l  a1,d6                   ;in d6 übergeben

        bsr     string_kopieren         ;und eintragen
        move.b  #" ",(a1)+              ;NullByte mit Space überschreiben

        lea     Dateiname,a0            ;zeige auf den Filenamen
        bsr     string_kopieren         ;und eintragen
        move.b  #" ",(a1)+              ;NullByte mit Space überschreiben

        lea     Dateiname,a0            ;zeige auf den Filenamen
        bsr     string_kopieren         ;und eintragen
.loop
        cmp.l   d6,a1                   ;Anfang der Puffers erreicht?
        beq.s   .fehler                 ;ja, keine Extension im Namen

        cmpi.b  #".",-(a1)              ;suche den Punkt
        bne.s   .loop                   ;bis gefunden

        move.b  #"_",(a1)+              ;trage "_u.b" ein
        move.b  #"u",(a1)+
        move.b  #".",(a1)+
        move.b  #"b",(a1)+
        move.b  #0,(a1)                 ;NullByte anfügen

        tst.l   d3                      ;Handle schon vorhanden?
        bne.s   .skip                   ;ja

        bsr     shell_win_oeffnen       ;Fenster öffnen
        move.l  d0,d3                   ;Handle merken
        bmi.s   .ende                   ;fehlgeschlagen
.skip
        lea     run_tags,a1             ;zeige auf Tagitems
        move.l  d3,12(a1)               ;Input Handle eintragen
        move.l  d6,d1                   ;CmdString in d1 übergeben
        move.l  a1,d2                   ;TagItems in d2 übergeben
        bsr     dos_system_taglist      ;ausführen
        tst.l   d0                      ;alles ok?
        beq.s   .ende                   ;ja
.fehler
        moveq   #-1,d0                  :melde Fehler
.ende
        rts

*--------------------------------------

util0.exe

        move.l  _MemPtr,a0
        lea     new_util_a(a0),a0
        tst.b   (a0)
        beq.s   .ende

        bsr     execute_utility
.ende
        rts

*--------------------------------------

util1.exe

        move.l  _MemPtr,a0
        lea     new_util_b(a0),a0
        tst.b   (a0)
        beq.s   .ende

        bsr     execute_utility
.ende
        rts

*--------------------------------------

util2.exe

        move.l  _MemPtr,a0
        lea     new_util_c(a0),a0
        tst.b   (a0)
        beq.s   .ende

        bsr     execute_utility
.ende
        rts


*--------------------------------------

util3.exe

        move.l  _MemPtr,a0
        lea     new_util_d(a0),a0
        tst.b   (a0)
        beq.s   .ende

        bsr     execute_utility
.ende
        rts


*--------------------------------------

aide.doc

        lea     aide_guide_name,a0
        lea     aide_doc_name,a1

        bsr     doc_file_pruefen

        moveq.l #0,d0
        rts

*--------------------------------------

ace.doc

        lea     ace_guide_name,a0
        lea     ace_doc_name,a1

        bsr     doc_file_pruefen

        moveq.l #0,d0
        rts

*--------------------------------------

superopt.doc

        lea     superopt_guide_name,a0
        sub.l   a1,a1

        bsr     doc_file_pruefen

        moveq.l #0,d0
        rts

*--------------------------------------

a68k.doc

        sub.l   a0,a0
        lea     a68k_doc_name,a1

        bsr     doc_file_pruefen

        moveq.l #0,d0
        rts

*--------------------------------------

phxass.doc

        lea     phxass_guide_name,a0
        sub.l   a1,a1

        bsr     doc_file_pruefen

        moveq.l #0,d0
        rts

*--------------------------------------

blink.doc

        sub.l   a0,a0
        lea     blink_doc_name,a1

        bsr     doc_file_pruefen

        moveq.l #0,d0
        rts

*--------------------------------------

phxlnk.doc

        lea     phxlnk_guide_name,a0
        sub.l   a1,a1

        bsr     doc_file_pruefen

        moveq.l #0,d0
        rts

*--------------------------------------

aceref.doc

        lea     ace_ref_name,a0
        sub.l   a1,a1

        bsr     doc_file_pruefen

        moveq.l #0,d0
        rts

*--------------------------------------

acewords.doc

        sub.l   a0,a0
        lea     ace_words_name,a1

        bsr     doc_file_pruefen

        moveq.l #0,d0
        rts

*--------------------------------------

aceexamples.doc

        lea     example_guide_name,a0
        sub.l   a1,a1

        bsr     doc_file_pruefen

        moveq.l #0,d0
        rts

*--------------------------------------

acehistory.doc

        sub.l   a0,a0
        lea     ace_history_name,a1

        bsr     doc_file_pruefen

        moveq.l #0,d0
        rts

*--------------------------------------

acecalc.doc

        lea     acecalc_guide_name,a0
        lea     acecalc_doc_name,a1

        bsr     doc_file_pruefen

        moveq.l #0,d0
        rts

*--------------------------------------

reqed.doc

        lea     reqed_guide_name,a0
        lea     reqed_doc_name,a1

        bsr     doc_file_pruefen

        moveq.l #0,d0
        rts

*--------------------------------------

* >= a0 = Zeiger auf den Namen des .guide -Files = NULL wenn nicht gewuenscht
* >= a1 = Zeiger auf den Namen des .doc   -Files = NULL wenn nicht gewuenscht

doc_file_pruefen

        movem.l d0-d6/a0-a4,-(a7)

        move.w  #1,pruef_Flag           ;Flag setzen
        moveq   #0,d0                   ;Register löschen

        move.l  a0,a3                   ;Zeiger merken
        move.l  a1,a4

        move.l  _MemPtr,a2              ;zeige auf Konfiguration
        lea     new_doc_dir(a2),a0      ;zeige auf den Namen des DocDirs
        tst.b   (a0)                    ;Eintrag vorhanden
        bne.s   .bearbeiten             ;ja

        bsr     no_doc_dir              ;Meldung ausgeben
        bra.s   .ende                   ;und beenden

.bearbeiten
        lea     TempDir,a1              ;zeige auf den Zwischenpuffer
        bsr     string_kopieren         ;eintragen

        tst.l   agdtool                 ;Amigaguide definiert?
        beq.s   .viewer                 ;nein, den Viewer benutzen

        cmp.l   #0,a3                   ;Name angegeben?
        beq.s   .viewer                 ;nein

        move.l  a3,a0                   ;zeige auf den Namen des GuideFiles
        lea     TempFile,a1             ;zeige auf den Zwischenpuffer
        bsr     string_kopieren         ;eintragen

        bsr     dateiname_besorgen      ;Name zusammensetzen und prüfen
        tst.l   d0                      ;alles ok?
        bmi.s   .viewer                 ;nein, mit dem Viewer probieren

        lea     new_agdtool(a2),a0      ;zeige auf den Namen des Tools
        tst.b   (a0)                    ;Eintrag vorhanden
        beq.s   .ende                   ;nein

        bsr     doc_ausgeben            ;ja, ausgeben
        bra.s   .ende                   ;und beenden

.viewer
        cmp.l   #0,a4                   ;Name angegeben?
        beq.s   .fehler                 ;nein

        move.l  a4,a0                   ;zeige auf den Namen des DocFiles
        lea     TempFile,a1             ;zeige auf den Zwischenpuffer
        bsr     string_kopieren         ;eintragen

        bsr     dateiname_besorgen      ;Name zusammensetzen und prüfen
        tst.l   d0                      ;alles ok?
        bmi.s   .fehler                 ;nein, kein DocFile vorhanden

        lea     new_viewer(a2),a0       ;zeige auf den Namen des Tools
        tst.b   (a0)                    ;Eintrag vorhanden
        beq.s   .ende                   ;nein

        bsr     doc_ausgeben            ;ja, ausgeben
        bra.s   .ende                   ;und beenden

.fehler
        tst.l   d0                      ;Fehler aufgetreten?
        beq.s   .ende                   ;nein

        bsr     doc_file_nicht_gefunden ;Meldung ausgeben

.ende
        move.w  #0,pruef_Flag

        movem.l (a7)+,d0-d6/a0-a4
        rts

*--------------------------------------

* >= a0 = Zeiger auf den Namen des Tools
* >= Dateiname enthaelt den kompletten Namen des DocFiles

doc_ausgeben

        move.l  _BufferPtr,a1           ;als Commandoablage benutzen
        bsr     string_kopieren         ;eintragen
        move.b  #" ",(a1)+              ;Space anfügen

        lea     Dateiname,a0            ;zeige auf den kompletten Namen
        bsr     string_kopieren         ;eintragen

        move.l  _BufferPtr,a0           ;in a0 übergeben
        bsr     execute_utility         ;und ausführen

        rts

*--------------------------------------

* >= a0 = Zeiger auf CmdString

execute_utility

        movem.l d0/d6,-(a7)

        move.l  a0,d6                   ;Cmd-String übergeben
        move.l  #1,AsynchFlag           ;läuft asynchron
        bsr     program_ausfuehren      ;und ausführen

        movem.l (a7)+,d0/d6
        rts
*--------------------------------------

