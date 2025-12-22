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
* check_environment
*
* kein Übergaberegister
*
* => d0.l = positiv = alles ok, negativ = Fehler
*--------------------------------------

check_environment

        movem.l d1-d3/a0,-(a7)

        move.w  #1,pruef_Flag           ;Flag setzen, nur den Namen überprüfen

        moveq.l #0,d2                   ;OffsetZählregister initialisieren
        moveq.l #EnvDirAnzahl-1,d3      ;Schleifenzählregister initialisieren
        lea     env_dir_tab,a0          ;zeige auf Tabelle
.loop
        move.l  0(a0,d2),d1             ;zeige auf Directorynamen
        bsr     fileinfo_besorgen       ;prüfe auf die Existenz
        tst.l   d0                      ;vorhanden?
        bpl.s   .next                   ;ja

        bsr     error_environment_message
                                        ;Meldung ausgeben
        bra.s   .ende                   ;und beenden
.next
        addq    #4,d2                   ;OffsetZählregister aufaddieren
        dbra    d3,.loop                ;auf nächstes Dir prüfen
.ende
        move.w  #0,pruef_Flag           ;Flag wieder löschen

        movem.l (a7)+,d1-d3/a0
        rts

*--------------------------------------

load_start_config

        movem.l d0-d1/a0-a1,-(a7)

        lea     Dateiname,a1            ;zeige auf Namenspuffer
        move.l  a1,d1                   ;in d1 übergeben

        tst.l   tp_configfile           ;Name in den Icon ToolTypes angegeben?
        beq.s   .skip                   ;nein, default Dateiname verwenden

        move.l  #tp_configfile,a0       ;zeige auf diesen Namen
        bra.s   .dateiname              ;als Dateiname verwenden
.skip
        lea     ConfigDirname,a0        ;zeige auf den Directorynamen
        bsr     string_kopieren         ;und kopieren

        lea     ConfigFilename,a0       ;dto.

.dateiname
        bsr     string_kopieren

        bsr     load_config_file        ;laden und setzen

        movem.l (a7)+,d0-d1/a0-a1
        rts

*--------------------------------------

load_default_config

        movem.l d1/a0-a1,-(a7)

        lea     ConfigDirname,a0        ;zeige auf den Directorynamen
        lea     Dateiname,a1            ;zeige auf Namenspuffer
        move.l  a1,d1                   ;in d1 übergeben
        bsr     string_kopieren         ;und kopieren

        lea     ConfigFilename,a0       ;dto.
        bsr     string_kopieren

        bsr     load_config_file        ;laden und setzen

        movem.l (a7)+,d1/a0-a1
        rts

*--------------------------------------

load_other_config

        movem.l d1/a0-a3,-(a7)

        tst.b   OtherConfigDir          ;DirectoryEintrag vorhanden?
        beq.s   .default_dir            ;nein

        move.l  #OtherConfigDir,_fr_Dirname
                                        ;zeige auf den Directorynamen
        bra.s   .filename               ;jetzt den Filenamen

.default_dir
        move.l  #ConfigDirname,_fr_Dirname
                                        ;zeige auf den Directorynamen
.filename
        move.l  #OtherConfigName,_fr_Filename
                                        ;zeige auf Filenamen

        move.l  #IDconfig_laden_Text,ASLReqTitel
                                        ;setze Titel für ASLFileRequester
        moveq.l #0,d1                   ;kein Dateiname, damit der ASLFilerequester
                                        ;ausgegeben wird
        bsr     load_config_file        ;laden und setzen
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        lea     Dateiname,a3            ;zeige auf den kompletten Namen
        bsr     split_filename          ;wieder trennen

        lea     TempDir,a0              ;die aktuellen Namen merken
        lea     OtherConfigDir,a1
        bsr     string_kopieren

        lea     TempFile,a0
        lea     OtherConfigName,a1
        bsr     string_kopieren
.ende
        movem.l (a7)+,d1/a0-a3
        rts

*--------------------------------------
* load_config_file
*
* >= d1.l = Zeiger auf kompletten Dateinamen oder 0
*           wenn der ASL-FileRequester ausgegeben werden soll.
*
* => d0.l = positiv = alles ok, negativ = Fehler
*--------------------------------------

load_config_file

        movem.l d1-d3/a0,-(a7)

        move.b  #1,ConfigFileFlag       ;Flag setzen
        move.w  #1,pruef_Flag           ;Flag setzen, nur den Namen überprüfen

        move.l  _MemPtr,a0              ;zeige auf Speicher
        move.l  a0,d2                   ;Zeiger auf Speicherbereich in d2 übergeben
        move.l  #ConfigFileSize,d3      ;Dateigröße in d3 übergeben

        bsr     datei_laden             ;und laden
        tst.l   d0                      ;alles ok?
        bmi.s   .fehler                 ;nein

        tst.b   ConfigFileFlag          ;wirklich ConfigFile?
        beq.s   .ende                   ;nein, Prüfung nicht bestanden

        bsr     set_config              ;auf die neuen Werte reagieren

        move.w  #0,Config_geaendert     ;Flag löschen
        bra.s   .ende                   ;und beenden

.fehler
        tst.l   (a0)                    ;Configuration schon vorhanden?
        bne.s   .message                ;ja

        bsr     create_new_config_file  ;nein, neues ConfigFile anlegen
        bsr     set_config              ;die default Konfiguration setzen
        bra.s   .ende                   ;und beenden

.message
        bsr     no_config_file_loaded   ;Meldung ausgeben, nichts geladen
.ende
        move.b  #0,ConfigFileFlag       ;Flags wieder löschen
        move.w  #0,pruef_Flag

        movem.l (a7)+,d1-d3/a0
        rts

*--------------------------------------

save_default_config

        movem.l d0-d1,-(a7)

        lea     ConfigDirname,a0        ;zeige auf String
        lea     Dateiname,a1            ;zeige auf Puffer
        move.l  a1,d1                   ;in d1 an "datei_sichern" übergeben
        bsr     string_kopieren         ;und kopieren

        lea     ConfigFilename,a0       ;dto.
        bsr     string_kopieren

        bsr     save_config_file        ;und sichern

        movem.l (a7)+,d0-d1
        rts

*--------------------------------------

save_other_config

        movem.l d0-d1,-(a7)

        tst.b   OtherConfigDir          ;DirectoryEintrag vorhanden?
        beq.s   .default_dir            ;nein

        move.l  #OtherConfigDir,_fr_Dirname
                                        ;zeige auf den Directorynamen
        bra.s   .filename               ;jetzt den Filenamen

.default_dir
        move.l  #ConfigDirname,_fr_Dirname
                                        ;zeige auf den Directorynamen
.filename
        move.l  #OtherConfigName,_fr_Filename
                                        ;zeige auf Filenamen

        move.l  #IDconfig_sichern_Text,ASLReqTitel
                                        ;setze Titel für ASLFileRequester

        moveq.l #0,d1                   ;kein Dateiname, damit der ASLFilerequester
                                        ;ausgegeben wird

        move.b  #1,sichern_Flag         ;Flag setzen
        bsr     save_config_file        ;und sichern
        clr.b   sichern_Flag            ;Flag wieder löschen

        movem.l (a7)+,d0-d1
        rts

*--------------------------------------
* save_config_file
*
* >= d1.l = Zeiger auf kompletten Dateinamen oder 0 wenn der ASLFilerequester
*           ausgegeben werden soll.
*
* => d0.l = positiv = alles ok, negativ = Fehler
*--------------------------------------

save_config_file

        movem.l d1-d3/a0-a1,-(a7)

        move.b  #1,ConfigFileFlag       ;Flag setzen
        move.w  #0,pruef_Flag           ;evtl. Prüf-Flag hier löschen

        move.l  _MemPtr,d2              ;Zeiger auf Speicherbereich übergeben
        move.l  #ConfigFileSize,d3      ;Dateigröße in d3 übergeben
        bsr     datei_sichern           ;und sichern
        tst.l   d0                      ;alles ok?
        bpl.s   .ok                     ;ja

        tst.l   _MainWinPtr             ;Fenster schon offen?
        bne.s   .skip                   ;ja, nicht mehr in der StartPhase

        bsr     new_config_file_not_saved
                                        ;Meldung ausgeben
        bra.s   .ende                   ;und beenden
.skip
        bsr     config_file_not_saved   ;Meldung ausgeben
        bra.s   .ende                   ;und beenden
.ok
        move.w  #0,Config_geaendert     ;Flag löschen
.ende
        move.b  #0,ConfigFileFlag       ;Flag wieder löschen

        movem.l (a7)+,d1-d3/a0-a1
        rts

*--------------------------------------
* create_new_config_file
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

create_new_config_file

        movem.l d0-d3/a0-a3,-(a7)

        lea     IDString,a0             ;zeige auf String
        move.l  _MemPtr,a1              ;zeige auf SpeicherBereich
        move.l  a1,a3                   ;in a3 merken
        move.l  #LaengeIDString,d0      ;Größe => d0
        bsr     copy_mem                ;und kopieren

        lea     ConfigDirname,a0        ;zeige auf String
        lea     Dateiname,a1            ;zeige auf Puffer
        move.l  a1,d1                   ;in d1 übergeben
        bsr     string_kopieren         ;und kopieren

        move.l  a1,a2                   ;Adresse merken

        lea     oldOptionsFilename,a0   ;zeige auf den alten Namen
        bsr     string_kopieren         ;eintragen
        bsr     fileinfo_besorgen       ;prüfe ob das File existiert
        tst.l   d0                      ;gefunden?
        bpl.s   .old_options            ;ja, eintragen


        bsr     set_default_options     ;kein Optionsfile gefunden,
                                        ;default Werte dafür eintragen
        bra.s   .old_config             ;prüfe auf old ConfigFile

.old_options
        bsr     old_options_eintragen   ;übernimm die alten Werte

.old_config
        move.l  a2,a1                   ;zeige wieder auf den Filenamen
        lea     oldConfigFilename,a0    ;zeige auf den alten Namen
        bsr     string_kopieren         ;eintragen
        bsr     fileinfo_besorgen       ;prüfe ob das File existiert
        tst.l   d0                      ;gefunden?
        bmi.s   .default_config         ;nein, DefaultConfig eintragen

        bsr     old_config_eintragen    ;übernimm die alten Werte

.default_config
        bsr     set_default_config      ;Dirs auf jeden Fall ergänzen
.save
        bsr     save_default_config     ;das neue File abspeichern

        movem.l (a7)+,d0-d3/a0-a3
        rts

*--------------------------------------
* old_options_eintragen
*
* >= d1.l = Zeiger auf alten Filenamen
* >= a3.l = Zeiger auf Speicher
*
* => d0.l = positiv = alles ok, negativ = Fehler
*--------------------------------------

old_options_eintragen

        movem.l a0-a3,-(a7)

        move.l  a3,a0                   ;zeige auf Speicher für die Options

        bsr     load_old_files          ;altes OptionsFile laden
        tst.l   d0                      ;alles ok?
        bmi     .fehler                 ;nein, Ladefehler

        move.l  d2,a1                   ;zeige auf alte ConfigDaten

        moveq.l #0,d0                   ;Register löschen zur Aufnahme der Optionbits

        cmpi.b  #"T",(a1)               ;TRUE oder FALSE gesetzt?
        bne.s   .skip0                  ;FALSE, dann nichts setzen

        bset    #nap,d0                 ;Bit setzen
.skip0
        cmpi.b  #"T",1(a1)              ;TRUE oder FALSE gesetzt?
        bne.s   .skip1                  ;FALSE, dann nichts setzen

        bset    #acpp,d0                ;Bits setzen
        bset    #removeline,d0
.skip1
        cmpi.b  #"T",10(a1)
        bne.s   .skip2

        bset    #superopt,d0
.skip2
        bset    #ace,d0                 ;natürlich ACE :)
        bset    #superopt,d0            ;SuperOptimizer nicht zu vergessen.
        bset    #a68k,d0                ;A68K  vorgeben,   war Std.
        bset    #blink,d0               ;BLink vorgeben,   war Std.

        move.l  d0,new_MakeSetup(a0)    ;und eintragen

        moveq.l #0,d0                   ;Register löschen
        cmpi.b  #$A,12(a1)              ;einstellige oder zweistellige Zahl?
        bne.s   .zweistellig            ;zweistellig

        move.b  11(a1),d0               ;zuerst => d0
        bra.s   .eintragen              ;auf Wortlänge eintragen

.zweistellig
        move.w  11(a1),d0               ;zuerst => d0

.eintragen
        bsr     ascii_dez_hex           ;ASCIICode in Hex wandeln
        move.l  d0,superopt_level(a0)   ;SuperoptLevel eintragen
        moveq.l #0,d0                   ;Register wieder löschen

* jetzt kommen die Compiler Options dran
*---------------------------------------

        cmpi.b  #"T",2(a1)
        bne.s   .skip3

        bset    #break_trapping,d0
.skip3
        cmpi.b  #"T",3(a1)
        bne.s   .skip4

        bset    #asm_comment,d0
.skip4
        cmpi.b  #"T",4(a1)
        bne.s   .skip5

        bset    #create_icon,d0
.skip5
        cmpi.b  #"T",6(a1)
        bne.s   .skip6

        bset    #optimize_assembly,d0
.skip6
        cmpi.b  #"T",7(a1)
        bne.s   .skip7

        bset    #window_trapping,d0
.skip7
        cmpi.b  #"T",8(a1)
        bne.s   .skip8

        bset    #ass_debug_info,d0
.skip8
        cmpi.b  #"T",9(a1)
        bne.s   .skip9

        bset    #linker_small_code,d0
        bset    #linker_small_data,d0
.skip9
        bset    #ami_lib,d0             ;Ami.lib vorgeben, war Std.
        move.l  d0,new_OptionsSetup(a0) ;eintragen

        cmpi.b  #"T",5(a1)              ;ListLines als Vorgabe gewählt?
        bne.s   .skip10                 ;nein

        move.b  #"l",other_ace_options(a0)
                                        ;ja, eintragen
.skip10
        bsr     free_vec                ;Speicher wieder freigeben
        bra.s   .ende
.fehler
        move.l  _MemPtr,a3              ;zeige auf Speicher

        bsr     set_default_options     ;Fehler beim Laden,
                                        ;Defaultwerte verwenden
        bra.s   .exit
.ende
        bsr     set_new_default_options ;die neuen Werte ebenfalls
                                        ;eintragen
.exit
        movem.l (a7)+,a0-a3
        rts

*--------------------------------------

* >= a3 = Zeiger auf Speicher für Konfiguration

set_default_options

        move.l  #default_OptionsSetup,new_OptionsSetup(a3)
        move.l  #default_SOptLevel,superopt_level(a3)

set_new_default_options

        move.l  #default_MakeSetup,new_MakeSetup(a3)
        move.l  ScreenFlag,screen_flag(a3)
        move.l  CleanUpFlag,clean_up_flag(a3)

        rts

*--------------------------------------
* old_config_eintragen
*
* >= d1.l = Zeiger auf alten Filenamen
*
* => d0.l = positiv = alles ok, negativ = Fehler
*--------------------------------------

old_config_eintragen

        movem.l d1-d5/a0-a4,-(a7)

        bsr     load_old_files          ;altes ConfigFile laden
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein, keins vorhanden

        move.l  d2,a2                   ;zeige auf altes Config File
        move.l  d2,d5                   ;=> d5 zur Berechnung der End-Adresse des Speichers
        add.l   d0,d5                   ;Filelänge aufaddieren

        cmpi.b  #"#",(a2)               ;fängt der Text im File mit einer Kommentareinleitung an?
        ble     .loop1                  ;ja, Zeilenende suchen.
        bra.s   .kopieren               ;nein, regulärer Eintrag

.loop1
        cmp.l   d5,a2                   ;Fileende erreicht?
        beq.s   .free_mem               ;ja

        cmpi.b  #$A,(a2)+               ;suche das Zeilenende (RETURN)
        bne.s   .loop1                  ;noch nicht gefunden

        cmpi.b  #"#",(a2)               ;ist das nächste Zeichen < = "#" = Kommentareinleitung?
        ble     .loop1                  ;ja, weitersuchen

.kopieren
        lea     PruefBuffer,a1          ;Zeiger auf Zwischenpuffer => a1

        move.l  a1,-(a7)                ;Register retten
.loop2
        move.b  (a2)+,(a1)+             ;kopiere den String
        cmpi.b  #"=",(a2)               ;"=" Zeichen erreicht?
        bne.s   .loop2                  ;nein

        move.b  #0,(a1)                 ;NullByte anfügen

        move.l  (a7)+,a1                ;Register wieder herstellen

        lea     old_def_table,a3        ;zeige auf Suchstringtabelle

        moveq.l #1,d1                   ;Groß/Kleinschreibung beachten
                                        ;Schlüsselworte sind nur in Grossbuchstaben!!
        moveq.l #0,d3                   ;Offsetzählregister initialisieren
        moveq.l #8,d4                   ;Schleifenzählregister initialisieren

.compare
        move.l  0(a3,d3),a0             ;Zeiger auf 1. Prüfstring  => a0
        bsr     string_compare          ;vergleiche
        tst.l   d0                      ;identisch?
        beq.s   .eintrag                ;ja

        addq    #4,d3                   ;Offset aufaddieren
        dbra    d4,.compare             ;weitersuchen

        bra.s   .loop1                  ;nicht gefunden => Fehler im File

.eintrag
        tst.b   (a2)+                   ;stelle den Zeiger hinter das "=" Zeichen

        move.l  _MemPtr,a4              ;Anfang auf neues ConfigFile => a4
        add.l   #new_editor,a4          ;Offset auf die DirectoryEinträge addieren
        mulu    #20,d3                  ;* 20 (strSize/4) ergibt Offset auf Direintrag
        add.l   d3,a4                   ;Offset auf a4 aufaddieren

.eintragen
        move.b  (a2)+,(a4)+             ;Directoryangabe eintragen
        cmpi.b  #$A,(a2)                ;Ende des Strings erreicht?
        bne.s   .eintragen              ;nein

        bra.s   .loop1                  ;nächsten Eintrag suchen

.free_mem
        move.l  d2,a1                   ;zeige auf reservierten Speicher
        bsr     free_vec                ;wieder freigeben
.ende
        movem.l (a7)+,d1-d5/a0-a4
        rts

*--------------------------------------
* load_old_files
*
* >= d1.l = Zeiger auf alten Filenamen
*
* => d0.l = positiv = alles ok, negativ = Fehler
* => d2.l = Zeiger auf geladenes File im Speicher
* => d3.l = Filelänge des alten Files
*--------------------------------------

load_old_files

        move.b  #0,ConfigFileFlag       ;Flags löschen
        move.w  #0,pruef_Flag

        moveq.l #0,d2                   ;d2 löschen = neuen Speicher anfordern
        moveq.l #0,d3                   ;d3 löschen = unbekannte Filelänge
        bsr     datei_laden             ;nun laden

        move.b  #1,ConfigFileFlag       ;Flags wieder setzen
        move.w  #1,pruef_Flag

        rts

*--------------------------------------
* set_default_config
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

set_default_config

        movem.l d0-d3/a0-a4,-(a7)

        lea     ConfigDirs,a2           ;zeige auf DirnamenTabelle
        move.l  _MemPtr,a3              ;zeige auf Speicher für Konfiguration
        lea     ConfigDirOffsetTab,a4   ;zeige auf die Offsetwerte

        moveq   #0,d2                   ;Offset-Zählregister initialisieren
        moveq   #AnzahlConfigDirs-1,d3  ;Schleifen-Zählregister initialisieren

        move.w  #1,pruef_Flag           ;nur die Namen überprüfen
.loop
        move.l  0(a2,d2),d1             ;zeige auf den Namen
        bsr     fileinfo_besorgen       ;prüfe ob existent
        tst.l   d0                      ;alles klar?
        bmi.s   .next                   ;nein, nicht vorhanden

        move.l  d1,a0                   ;zum Kopieren Zeiger => a0
        move.l  0(a4,d2),d0             ;Offsetwert in d0 eintragen
        lea     0(a3,d0),a1             ;zeige auf Stelle in der Konfiguration
        tst.b   (a1)                    ;schon ein Eintrag vorhanden?
        bne.s   .next                   ;ja

        bsr     string_kopieren         ;nein, default Angabe eintragen
.next
        cmpi    #10,d3                  ;agdtool erreicht?
        bne.s   .weiter                 ;nein

        tst.l   d0                      ;alles ok?
        bpl.s   .weiter                 ;ja

        move.l  mltvtool,0(a2,d2)       ;nein, Zeiger auf Multiview eintragen
        bra.s   .loop
.weiter
        addq    #4,d2                   ;Offset aufaddieren
        dbra    d3,.loop                ;und nächsten Eintrag prüfen

        move.w  #0,pruef_Flag           ;Flag wieder löschen

        movem.l (a7)+,d0-d3/a0-a4
        rts

*--------------------------------------
* set_config
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

set_config

        movem.l d0-d2/a0-a2,-(a7)


        move.l  _MemPtr,a0              ;zeige auf Konfiguration
        move.l  screen_flag(a0),ScreenFlag
        move.l  requester_flag(a0),RequesterFlag
        move.l  clean_up_flag(a0),CleanUpFlag
        move.l  new_MakeSetup(a0),MakeSetup
        move.l  new_OptionsSetup(a0),OptionsSetup
        move.l  superopt_level(a0),SOptLevel
        move.l  superopt_version(a0),SOptVersion

        moveq.l #ChangeableConfigDirs-1,d0
                                        ;Schleifenzählregister initialisieren
        moveq.l #80,d1                  ;Offset für ConfigFile initialisieren
        moveq.l #0,d2                   ;Offsetzählregister Zeigertabelle initialisieren
        lea     new_editor(a0),a1       ;zeige auf den 1. Eintrag in a1
        lea     ConfigDirs,a2           ;zeige auf ZeigerTabelle
.loop
        tst.b   (a1)                    ;Directoryangabe vorhanden?
        beq.s   .next                   ;nein

        move.l  a1,0(a2,d2)             ;ja, Zeiger darauf eintragen, default Wert überschreiben
.next
        addq    #4,d2                   ;Offset aufaddieren
        add.l   d1,a1                   ;Offset aufaddieren
        dbra    d0,.loop                ;bis alle bearbeitet

        move.l  a0,a2                   ;_MemPtr in a2 merken
        lea     other_precomp_name(a2),a0
        bsr     other_preco_eintragen

        lea     other_ass_name(a2),a0
        bsr     other_ass_eintragen

        lea     other_linker_name(a2),a0
        bsr     other_linker_eintragen

        movem.l (a7)+,d0-d2/a0-a2
        rts

*--------------------------------------

other_preco_eintragen

        tst.b   (a0)                    ;Eintrag vorhanden?
        beq.s   .ende                   ;nein

        movem.l a0-a2,-(a7)

        move.l  a0,a2                   ;in a2 merken

        lea     preco_other_txt,a1
        add.l   preco_other_txt_offset,a1
        move.b  #" ",(a1)+
        bsr     string_kopieren

        move.b  #".",(a1)+              ;3 Punkte und NullByte anfügen
        move.b  #".",(a1)+
        move.b  #".",(a1)+
        move.b  #0,(a1)

        move.l  a2,a0
        lea     dos_cmd_preco_other,a1
        add.l   #dos_cmd_preco_other_offset,a1
        bsr     string_kopieren

        move.l  a2,a0
        lea     error_preco_other_txt,a1
        add.l   error_preco_other_txt_offset,a1
        move.b  #" ",(a1)+
        bsr     string_kopieren

        movem.l (a7)+,a0-a2
.ende
        rts

*--------------------------------------

other_ass_eintragen

        tst.b   (a0)                    ;Eintrag vorhanden?
        beq.s   .ende                   ;nein

        movem.l a0-a2,-(a7)

        move.l  a0,a2                   ;in a2 merken

        lea     ass_other_txt,a1
        add.l   ass_other_txt_offset,a1
        move.b  #" ",(a1)+
        bsr     string_kopieren

        move.b  #".",(a1)+              ;3 Punkte und NullByte anfügen
        move.b  #".",(a1)+
        move.b  #".",(a1)+
        move.b  #0,(a1)

        move.l  a2,a0                   ;dto.
        lea     dos_cmd_ass_other,a1
        add.l   #dos_cmd_ass_other_offset,a1
        bsr     string_kopieren

        move.l  a2,a0                   ;dto.
        lea     error_ass_other_txt,a1
        add.l   error_ass_other_txt_offset,a1
        move.b  #" ",(a1)+
        bsr     string_kopieren

        movem.l (a7)+,a0-a2
.ende
        rts

*--------------------------------------

other_linker_eintragen

        tst.b   (a0)                    ;Eintrag vorhanden?
        beq.s   .ende                   ;nein

        movem.l a0-a2,-(a7)

        move.l  a0,a2                   ;in a2 merken

        lea     lnk_other_txt,a1
        add.l   lnk_other_txt_offset,a1
        move.b  #" ",(a1)+
        bsr     string_kopieren

        move.b  #".",(a1)+              ;3 Punkte und NullByte anfügen
        move.b  #".",(a1)+
        move.b  #".",(a1)+
        move.b  #0,(a1)

        move.l  a2,a0                   ;dto.
        lea     dos_cmd_lnk_other,a1
        add.l   #dos_cmd_lnk_other_offset,a1
        bsr     string_kopieren

        move.l  a2,a0                   ;dto.
        lea     error_lnk_other_txt,a1
        add.l   error_lnk_other_txt_offset,a1
        move.b  #" ",(a1)+
        bsr     string_kopieren

        movem.l (a7)+,a0-a2
.ende
        rts

*--------------------------------------

load_tp_configfile

        movem.l d0-d1/a0-a2,-(a7)

        lea     tp_configfile,a0        ;zeige auf ermittelten Filenamen
        move.l  a0,a1                   ;zum Testen => a1
.loop1
        tst.b   (a1)+                   ;setze den Zeiger auf das Ende des Namens
        bne.s   .loop1

        move.l  a1,a2                   ;Ende in a2 merken
.loop2
        cmp.l   a0,a1                   ;den Anfang wieder erreicht?
        beq.s   .doppelpunkt            ;ja, prüfe auf Doppelpunkt

        cmpi.b  #"/",-(a1)              ;finde den letzten /
        bne.s   .loop2                  ;noch nicht
        beq.s   .vergleichen            ;ja, vergleichen

.doppelpunkt
        move.l  a2,a1                   ;Zeiger aufs Ende => a1
.loop3
        cmp.l   a0,a1                   ;den Anfang wieder erreicht?
        beq.s   .ende                   ;ja, keine DirAngabe vorhanden

        cmpi.b  #":",-(a1)              ;finde den :
        bne.s   .loop3                  ;noch nicht

.vergleichen
        tst.b   (a1)+                   ;/ oder : eliminieren

        lea     ConfigFilename,a0       ;zeige auf originalen Filenamen
        moveq.l #0,d1                   ;Groß/Kleinschreibung nicht beachten
        moveq.l #ConfigFilenameLength-1,d0
                                        ;Länge ohne NullByte übergeben
        bsr     string_n_compare        ;vergleiche
        tst.l   d0                      ;identisch?
        beq.s   .ende                   ;ja

        move.l  #tp_configfile,d1       ;zeige auf ermittelten Filenamen

        move.w  #1,pruef_Flag           ;nur den Namen überprüfen
        bsr     fileinfo_besorgen       ;prüfe den Dateinamen
        move.w  #0,pruef_Flag           ;Flag wieder löschen
        tst.l   d0                      ;okay?
        bmi.s   .ende                   ;nein

        move.l  #tp_configfile,d1       ;zeige auf den Filenamen
        bsr     load_config_file        ;ja, laden und setzen
        move.w  #1,Config_loaded        ;Flag setzen, damit nicht doppelt geladen wird
.ende
        movem.l (a7)+,d0-d1/a0-a2
        rts

*--------------------------------------
