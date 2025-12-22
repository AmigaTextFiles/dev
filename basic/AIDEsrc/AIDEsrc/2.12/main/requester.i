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
* wrong_system_version
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

wrong_system_version

        movem.l d0-d3/a0-a6,-(a7)

        lea     intname,a1              ;zeige auf Library-Namen
        moveq.l #0,d0                   ;Version egal
        CALLEXEC OpenLibrary            ;öffnen
        tst.l   d0                      ;geklappt ?
        beq.s   .ende                   ;nein

        move.l  d0,a5                   ;Zeiger auf IntuitonBase => a5
        exg     a5,a6                   ;LibraryPtr wechseln

        sub.l   a0,a0                   ;auf Workbench ausgeben
        lea     sys_ts,a1               ;zeige auf MessageTextStruktur
        sub.l   a2,a2                   ;kein RetryGadget
        lea     sys_gad_ts,a3           ;zeige auf GadgetTextStruktur
        moveq.l #0,d0                   ;keine positive Antwort
        moveq.l #$40,d1                 ;nur reagieren auf GadgetUp
        move.l  #350,d2                 ;Breite des Fensters
        move.l  #060,d3                 ;Höhe des Fensters
        CALLSYS AutoRequest             ;ausgeben

        move.l  a6,a1                   ;LibraryPtr => a1
        exg     a5,a6                   ;LibraryPtr wechseln
        CALLSYS CloseLibrary            ;und wieder schließen
.ende
        movem.l (a7)+,d0-d3/a0-a6
        rts
*--------------------------------------
* AutoRequest() Textstrukturen
*--------------------------------------
sys_gad_ts      INTUITEXT 0,0,0,6,3,0,text_i_see,0
sys_ts          INTUITEXT 0,0,0,15,10,0,text_wrong_system,0
*--------------------------------------
* mrt_library_not_opened
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

mrt_library_not_opened

        movem.l d0-d3/a0-a6,-(a7)

        sub.l   a0,a0                   ;auf Workbench ausgeben
        lea     mrt_ts,a1               ;zeige auf MessageTextStruktur
        sub.l   a2,a2                   ;kein RetryGadget
        lea     sys_gad_ts,a3           ;zeige auf GadgetTextStruktur
        moveq   #0,d0                   ;keine positive Antwort
        moveq   #$40,d1                 ;nur reagieren auf GadgetUp
        move.l  #350,d2                 ;Breite des Fensters
        move.l  #060,d3                 ;Höhe des Fensters
        CALLINT AutoRequest             ;ausgeben

        move.l  a6,a1                   ;LibraryPtr => a1
        CALLEXEC CloseLibrary           ;und schließen

        movem.l (a7)+,d0-d3/a0-a6
        rts
*--------------------------------------
* AutoRequest() Textstrukturen
*--------------------------------------
mrt_ts          INTUITEXT 0,0,0,15,10,0,text_mrtlib,0
*--------------------------------------
* Unterroutinen zur Ausgabe von Melde-Requestern
*--------------------------------------
* "build_requester" erwartet folgende Werte:
*
* >= d0.l = IDCMP-Flags auf die reagiert werden soll
* >= d1.l = Zeiger auf Gadget-Text für positive Antwort (links)
* >= d2.l = Zeiger auf Gadget-Text für negative Antwort (rechts)
* >= d3.l = Zeiger auf 1. Meldetext
* >= d4.l = Zeiger auf 2. Meldetext
* >= d5.l = Zeiger auf 3. Meldetext
* >= d6.l = Zeiger auf 4. Meldetext
* >= d7.l = Zeiger auf Requestertitel
*
* >= a0.l = WindowPtr oder 0 wenn Workbench
* >= a1.l = Zeiger auf TextAttributStruktur
*
* => d0.l = -1 = Fehler, Requester wurde nicht ausgegeben
* => d0.l =  0 = negative Antwort gewählt
* => d0.l =  1 = positive Antwort gewählt
*--------------------------------------
* alert_requester (wird immer ausgegeben)
*
* >= d3.l = Zeiger auf Ausgabe-Text
*
* kein Rückgaberegister
*--------------------------------------

alert_requester

        movem.l d0-d7/a0-a1,-(a7)

        move.l  #IDCMP_GADGETUP,d0      ;IDCMPFlag => d0
        bsr     i_see_eintragen         ;GadgetTexte eintragen
        bsr     nur_einen_text          ;kein weiteren Texte
        tst.l   _MainWinPtr             ;Fenster schon offen?
        beq.s   .wb                     ;nein

        move.l  #error_req_title,d7     ;RequesterTitel übergeben
        move.l  _MainWinPtr,a0          ;Window übergeben
        move.l  _FontAttrPtr,a1         ;TextAttributStrukturPtr übergeben
        bra.s   .requester              ;und ausgeben
.wb
        move.l  #alert_req_title,d7     ;zeige auf RequesterTitel
        sub.l   a0,a0                   ;kein eigenes Fenster
        sub.l   a1,a1                   ;SystemFont

.requester
        bsr     build_requester         ;Requester ausgeben

        movem.l (a7)+,d0-d7/a0-a1
        rts

*--------------------------------------
*
* error_requester (wird nur ausgegeben wenn RequesterFlag <> 2,
*                  oder wenn in der StartupPhase aufgerufen)
*
*--------------------------------------

error_requester

        movem.l d7/a0-a1,-(a7)

        tst.l   _MainWinPtr             ;Fenster schon offen?
        beq.s   .wb                     ;nein, dann ausgeben,
                                        ;Fehler in StartupPhase!

        cmpi.l  #2,RequesterFlag        ;minimal Requester ausgeben?
        beq.s   .ende                   ;ja

        move.l  _MainWinPtr,a0          ;zeige auf Window
        move.l  _FontAttrPtr,a1         ;zeige auf TextAttributStruktur
        move.l  #error_req_title,d7     ;zeige auf Titel
        bra.s   .requester              ;und ausgeben
.wb
        sub.l   a0,a0                   ;kein eigenes Fenster
        sub.l   a1,a1                   ;SystemFont verwenden
        move.l  #alert_req_title,d7     ;zeige auf Titel

.requester
        bsr     build_requester         ;Requester ausgeben
.ende
        movem.l (a7)+,d7/a0-a1
        rts

*--------------------------------------
*
* requester (wird nur ausgegeben wenn RequesterFlag = NULL)
*
*--------------------------------------

requester

        movem.l d7/a0-a1,-(a7)

        tst.l   RequesterFlag           ;prüfe, ob auszugeben
        bne.s   .ende                   ;nein

        move.l  _MainWinPtr,a0          ;zeige auf Window
        move.l  _FontAttrPtr,a1         ;zeige auf TextAttributStruktur
        move.l  #req_title,d7           ;zeige auf Titel
        bsr     build_requester         ;Requester ausgeben
.ende
        movem.l (a7)+,d7/a0-a1
        rts

*--------------------------------------

yes_no_eintragen

        move.l  #text_yes,d1            ;zeige auf Gadget-Text für
                                        ;positive Antwort
        move.l  #text_no,d2             ;zeige auf Gadget-Text für
                                        ;negative Antwort
        rts

*--------------------------------------

i_see_eintragen

        moveq.l #0,d1                   ;kein 2. Gadget
        move.l  #text_i_see,d2          ;zeige auf Gadget-Text
        rts

*--------------------------------------

okay_eintragen

        moveq.l #0,d1                   ;kein 2. Gadget
        move.l  #text_okay,d2           ;zeige auf Gadget-Text
        rts

*--------------------------------------

cancel_eintragen

        moveq.l #0,d1
        move.l  #text_cancel,d2
        rts

*--------------------------------------

nur_einen_text

        moveq.l #0,d4
        moveq.l #0,d5
        moveq.l #0,d6
        rts

*--------------------------------------

nur_zwei_texte

        moveq.l #0,d5
        moveq.l #0,d6
        rts

*--------------------------------------

* Startup Alert Messages
*-----------------------

error_environment_message

        movem.l d0-d6/a0-a1,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text_error_env1,d3
        move.l  #text_error_env2,d4
        move.l  #text_error_env3,d5
        moveq.l #0,d6
        bsr     error_requester

        movem.l (a7)+,d0-d6/a0-a1
        rts

*--------------------------------------

not_enough_start_mem

        movem.l d0-d7,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text_not_enough_start_mem1,d3
        move.l  #text_not_enough_start_mem2,d4
        bsr     nur_zwei_texte
        bsr     error_requester

        movem.l (a7)+,d0-d7
        rts

*--------------------------------------

new_config_file_not_saved

        movem.l d0-d7,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text_new_config_not_saved1,d3
        move.l  #text_new_config_not_saved2,d4
        bsr     nur_zwei_texte
        bsr     error_requester

        movem.l (a7)+,d0-d7
        rts

*--------------------------------------

no_gadtools_gadgets

        move.l  d3,-(a7)

        move.l  #text_gt_gadgets_not_created,d3
        bsr     alert_requester

        move.l  (a7)+,d3
        rts

*--------------------------------------

screen_open_error

        move.l  ScreenOpenError,d0      ;ErrorCode => d0
        lsl.l   #2,d0                   ; * 4, da LangwortOffset
        lea     ScreenOpenErrorTable,a0 ;zeige auf die Tabelle
        move.l  0(a0,d0),d3             ;Zeiger auf Text => d3
        bsr     alert_requester         ;Meldung ausgeben

        rts
*--------------------------------------

ScreenOpenErrorTable
                dc.l    0
                dc.l    no_monitor_text
                dc.l    newer_custom_chips_text
                dc.l    not_enough_mem_text
                dc.l    not_enough_chip_mem_text
                dc.l    aide_already_active_text
                dc.l    unknown_display_mode_text
                dc.l    screen_to_deep_text
                dc.l    failed_to_attach_screen_text
                dc.l    mode_not_available_text


no_monitor_text
                dc.b    "Named monitor spec not available.",0
                even

newer_custom_chips_text
                dc.b    "You need newer custom chips for this screen mode.",0
                even

not_enough_mem_text
                dc.b    "Not enough memory to open the screen.",0
                even

not_enough_chip_mem_text
                dc.b    "Not enough chip memory to open the screen.",0
                even

aide_already_active_text
                dc.b    "PublicScreen AIDE is already in use.",0
                even

unknown_display_mode_text
                dc.b    "Don't recognize mode asked for.",0
                even

screen_to_deep_text
                dc.b    "Screen deeper than HW supports.",0
                even

failed_to_attach_screen_text
                dc.b    "Failed to attach screen.",0
                even

mode_not_available_text
                dc.b    "Screen mode not available.",0
                even

*--------------------------------------
* Error Messages
*---------------

* mit Rückgabewert
*-----------------

printer_error

        movem.l d1-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     yes_no_eintragen
        move.l  #text_printer_error1,d3
        move.l  #text_printer_error2,d4
        move.l  #text_printer_error3,d5
        moveq.l #0,d6

        bsr     error_requester

        cmpi.l  #IDCMP_GADGETUP,d0      ;Requester ausgegeben worden?
        bne.s   .ende                   ;ja

        moveq.l #0,d0                   ;nein, negative Antwort zurückgeben
.ende
        movem.l (a7)+,d1-d6
        rts

*--------------------------------------

no_source_file_selected

        movem.l d1-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     yes_no_eintragen
        move.l  #text_no_source_file_selected1,d3
        move.l  #text_no_source_file_selected2,d4
        bsr     nur_zwei_texte
        bsr     error_requester

        cmpi.l  #IDCMP_GADGETUP,d0      ;Requester ausgegeben worden?
        bne.s   .ende                   ;ja

        moveq.l #0,d0                   ;nein, negative Antwort zurückgeben
.ende
        movem.l (a7)+,d1-d6
        rts

*--------------------------------------

dirname_falsch

        movem.l d1-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     yes_no_eintragen
        move.l  #text_dirname_wrong,d3
        move.l  #text_correct_it,d4
        bsr     nur_zwei_texte
        bsr     error_requester

        cmpi.l  #IDCMP_GADGETUP,d0
        bne.s   .auswerten

        moveq.l #-1,d0
        bra.s   .ende

.auswerten
        bsr     datei_req_antwort_auswerten
.ende
        movem.l (a7)+,d1-d6
        rts
*--------------------------------------

dateiname_falsch

        movem.l d1-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     yes_no_eintragen
        move.l  #text_filename_wrong,d3
        move.l  #text_correct_it,d4
        bsr     nur_zwei_texte
        bsr     error_requester

        cmpi.l  #IDCMP_GADGETUP,d0
        bne.s   .auswerten

        moveq.l #-1,d0
        bra.s   .ende

.auswerten
        bsr     datei_req_antwort_auswerten
.ende
        movem.l (a7)+,d1-d6
        rts

*--------------------------------------

config_changed

        movem.l d1-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     yes_no_eintragen
        move.l  #text_config_changed,d3
        move.l  #text_want_to_save,d4
        bsr     nur_zwei_texte
        bsr     error_requester

        cmpi.l  #IDCMP_GADGETUP,d0
        bne.s   .ende

        moveq.l #0,d0                   ;negative Antwort zurückgeben
.ende
        movem.l (a7)+,d1-d6
        rts

*--------------------------------------
* ohne Rückgabewert
*--------------------------------------

printer_open_error

        movem.l d1-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text_printer_openerror1,d3
        move.l  #text_printer_openerror2,d4
        bsr     nur_zwei_texte

        bsr     error_requester

        cmpi.l  #IDCMP_GADGETUP,d0      ;Requester ausgegeben worden?
        bne.s   .ende                   ;ja

        moveq.l #0,d0                   ;nein, negative Antwort zurückgeben
.ende
        movem.l (a7)+,d1-d6
        rts

*--------------------------------------

no_other_preco_eingetragen

        movem.l d0-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text_no_other_preco_eingetragen,d3
        move.l  #text_compiler_run_abort,d4
        bsr     nur_zwei_texte
        bsr     error_requester

        movem.l (a7)+,d0-d6
        rts

*--------------------------------------

no_other_assembler_eingetragen

        movem.l d0-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text_no_other_assembler_eingetragen,d3
        move.l  #text_compiler_run_abort,d4
        bsr     nur_zwei_texte
        bsr     error_requester

        movem.l (a7)+,d0-d6
        rts

*--------------------------------------

no_other_linker_eingetragen

        movem.l d0-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text_no_other_linker_eingetragen,d3
        move.l  #text_compiler_run_abort,d4
        bsr     nur_zwei_texte
        bsr     error_requester

        movem.l (a7)+,d0-d6
        rts

*--------------------------------------

no_other_linkerlib_eingetragen

        movem.l d0-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text_no_other_linkerlib_eingetragen,d3
        move.l  #text_compiler_run_abort,d4
        bsr     nur_zwei_texte
        bsr     error_requester

        movem.l (a7)+,d0-d6
        rts

*--------------------------------------

not_marked_as_source

        movem.l d0-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text_file_not_marked,d3
        bsr     nur_einen_text
        bsr     error_requester

        movem.l (a7)+,d0-d6
        rts

*--------------------------------------

no_module_dir

        movem.l d0-d7,-(a7)

        move.l  RequesterFlag,d7        ;Flag retten
        clr.l   RequesterFlag           ;Flag löschen => Requester
                                        ;wird immer ausgegeben

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text_no_module_dir,d3
        move.l  #text3_module_dir_error,d4
        bsr     nur_zwei_texte
        bsr     error_requester

        move.l  d7,RequesterFlag        ;Flag wieder herstellen

        movem.l (a7)+,d0-d7
        rts

*--------------------------------------

no_config_file_loaded

        movem.l d0-d7,-(a7)

        move.l  RequesterFlag,d7
        clr.l   RequesterFlag

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text_no_config_loaded,d3
        move.l  #text_default_settings,d4
        bsr     nur_zwei_texte
        bsr     error_requester

        move.l  d7,RequesterFlag

        movem.l (a7)+,d0-d7
        rts

*--------------------------------------

config_file_not_saved

        movem.l d0-d7,-(a7)

        move.l  RequesterFlag,d7
        clr.l   RequesterFlag

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text_config_not_saved,d3
        bsr     nur_einen_text
        bsr     error_requester

        move.l  d7,RequesterFlag

        movem.l (a7)+,d0-d7
        rts

*--------------------------------------

file_is_not_a_config_file

        movem.l d0-d7,-(a7)

        move.l  RequesterFlag,d7
        clr.l   RequesterFlag

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text_no_data_file,d3

        tst.l   _MainWinPtr
        bne.s   .current

        move.l  #text_default_settings,d4
        bra.s   .ausgeben

.current
        move.l  #text_current_settings,d4

.ausgeben
        bsr     nur_zwei_texte
        bsr     error_requester

        move.l  d7,RequesterFlag

        movem.l (a7)+,d0-d7
        rts

*--------------------------------------

dateilaenge_null

        movem.l d0-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text_filelength_null,d3
        bsr     nur_einen_text
        bsr     error_requester

        movem.l (a7)+,d0-d6
        rts

*--------------------------------------

datei_nicht_vollstaendig_geladen

        movem.l d0-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        bsr     nur_einen_text
        move.l  #text_not_loaded_complete,d3
        bsr     error_requester

        movem.l (a7)+,d0-d6
        rts

*--------------------------------------

temp_dir_error

        movem.l d0-d7,-(a7)

        move.l  RequesterFlag,d7
        clr.l   RequesterFlag

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text1_temp_dir_error,d3
        bsr.s   .vervollstaendigen      ;trage das Directory ein
        move.l  #text3_module_dir_error,d4
        bsr     nur_zwei_texte
        bsr     error_requester

        move.l  d7,RequesterFlag

        movem.l (a7)+,d0-d7
        rts

*-----------------

.vervollstaendigen

        movem.l a0-a1,-(a7)

        move.l  tmp_dir,a0              ;zum Kopieren => a0
        move.l  d3,a1                   ;zeige auf Text
        adda.l  #16,a1                  ;Offset addieren
        bsr     string_kopieren         ;und kopieren

        lea     text2_module_dir_error,a0
                                        ;zum Kopieren => a0
        bsr     string_kopieren         ;und kopieren

        movem.l (a7)+,a0-a1
        rts

*--------------------------------------

module_dir_error

        movem.l d0-d7,-(a7)

        move.l  RequesterFlag,d7
        clr.l   RequesterFlag

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text1_module_dir_error,d3
        bsr.s   .vervollstaendigen
        move.l  #text3_module_dir_error,d4
        bsr     nur_zwei_texte
        bsr     error_requester

        move.l  d7,RequesterFlag

        movem.l (a7)+,d0-d7
        rts

*-----------------

.vervollstaendigen

        movem.l a0-a1,-(a7)

        move.l  mod_dir,a0              ;zum Kopieren => a0
        move.l  d3,a1                   ;zeige auf Text
        adda.l  #18,a1                  ;Offset addieren
        bsr     string_kopieren         ;und kopieren

        lea     text2_module_dir_error,a0
                                        ;zum Kopieren => a0
        bsr     string_kopieren         ;und kopieren

        movem.l (a7)+,a0-a1
        rts

*--------------------------------------

zu_viele_module

        movem.l d0-d7,-(a7)

        move.l  RequesterFlag,d7        ;Flag retten
        clr.l   RequesterFlag           ;Flag löschen => Requester
                                        ;wird immer ausgegeben

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text_too_many_modules,d3
        bsr     nur_einen_text
        bsr     error_requester

        move.l  d7,RequesterFlag        ;Flag wieder herstellen

        movem.l (a7)+,d0-d7
        rts

*--------------------------------------

no_doc_dir

        movem.l d0-d7,-(a7)

        move.l  RequesterFlag,d7        ;Flag retten
        clr.l   RequesterFlag           ;Flag löschen => Requester
                                        ;wird immer ausgegeben

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text_no_doc_dir1,d3
        move.l  #text_no_doc_dir2,d4
        bsr     nur_zwei_texte
        bsr     error_requester

        move.l  d7,RequesterFlag        ;Flag wieder herstellen

        movem.l (a7)+,d0-d7
        rts

*------------------

text_no_doc_dir1        dc.b    "No doc dir specified!",0
        even

text_no_doc_dir2        dc.b    "Please correct your AIDE setup.",0
        even

*--------------------------------------
* >= a3 = Zeiger auf den Namen des .guide -Files = NULL wenn nicht gewuenscht
* >= a4 = Zeiger auf den Namen des .doc   -Files = NULL wenn nicht gewuenscht

doc_file_nicht_gefunden

        movem.l d0-d7,-(a7)

        move.l  RequesterFlag,d7
        clr.l   RequesterFlag

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #text_doc_file,d3
        move.l  #doc_buffer1,d4
        move.l  #doc_buffer2,d5
        move.l  #text_not_found,d6

        bsr     .doc_file_names_eintragen
        bsr     error_requester

        move.l  d7,RequesterFlag

        movem.l (a7)+,d0-d7
        rts

*-----------------

.doc_file_names_eintragen

        movem.l d0-d1/a0-a2,-(a7)

        move.w  #1,pruef_Flag           ;Flag setzen

        move.l  _MemPtr,a2              ;zeige auf Konfiguration
        lea     new_doc_dir(a2),a0      ;zeige auf den Namen des DocDirs
        tst.b   (a0)                    ;Eintrag vorhanden
        beq.s   .ende                   ;nein

        tst.b   (a3)                    ;Name angegeben?
        bne.s   .text1                  ;ja

        moveq   #0,d4                   ;Zeiger löschen
        bra.s   .skip                   ;auf doc-file prüfen
.text1
        move.l  d4,a1                   ;zeige auf den Puffer
        bsr     string_kopieren         ;eintragen

        move.l  d4,d1                   ;zum Prüfen => d1
        bsr     pruefe_den_dirnamen     ;: oder / anfügen

        move.l  a3,a0                   ;zeige auf den Namen des Files
        bsr     string_kopieren         ;und kopieren

        lea     new_doc_dir(a2),a0      ;zeige auf den Namen des DocDirs

.skip
        tst.b   (a4)                    ;Name angegeben?
        bne.s   .text2                  ;ja

        move.l  d6,d5                   ;Zeiger auf Text => d5
        moveq   #0,d6                   ;Zeiger löschen
        bra.s   .ende                   ;und beenden
.text2
        move.l  d5,a1                   ;zeige auf den Puffer
        bsr     string_kopieren         ;eintragen

        move.l  d5,d1                   ;zum Prüfen => d1
        bsr     pruefe_den_dirnamen     ;: oder / anfügen

        move.l  a4,a0                   ;zeige auf den Namen des Files
        bsr     string_kopieren         ;und kopieren

        tst.l   d4                      ;Name angegeben?
        bne.s   .ende                   ;ja

        move.l  d5,d4                   ;nein, Zeiger richtig eintragen
        move.l  d6,d5
        moveq   #0,d6

.ende
        move.w  #0,pruef_Flag           ;Flag löschen

        movem.l (a7)+,d0-d1/a0-a2
        rts

*-----------------
text_doc_file   dc.b    "Doc file(s):",0
        even
text_not_found  dc.b    "not found!",0
        even

doc_buffer1     ds.b    256
        even
doc_buffer2     ds.b    256
        even

*--------------------------------------
* compiler_error_msg (wird immer ausgegeben !!!)
*
* >= d5.l = aktuelles Kommandobit
*
* kein Rückgaberegister
*--------------------------------------

compiler_error_msg

        movem.l d0-d7,-(a7)

        move.l  RequesterFlag,d7
        clr.l   RequesterFlag

        lea     cmd_error_table,a0      ;zeige auf Textzeigerablage
        lsl.l   #2,d5                   ;Bit * 4 = Offset auf Textadresse
        move.l  0(a0,d5.l),d3           ;Zeiger auf Text => d3

        move.l  #IDCMP_GADGETUP,d0
        bsr     cancel_eintragen
        move.l  #comp_error_text2,d4
        bsr     nur_zwei_texte
        bsr     error_requester
.ende
        move.l  d7,RequesterFlag

        movem.l (a7)+,d0-d7
        rts

*--------------------------------------

* normal Messages
*----------------

* mit Rückgabewert
*-----------------

really_kill_source

        movem.l d1-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     yes_no_eintragen
        move.l  #text_no_source_file_selected1,d3
        move.l  #text_kill_source,d4
        bsr     nur_zwei_texte
        bsr     requester

        cmpi.l  #IDCMP_GADGETUP,d0
        bne.s   .ende

        moveq.l #0,d0                   ;negative Antwort zurückgeben
.ende
        movem.l (a7)+,d1-d6
        rts

*--------------------------------------

beenden_requester

        movem.l d1-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     yes_no_eintragen
        move.l  #text_prg_title,d3
        move.l  #text_prg_end,d4
        bsr     nur_zwei_texte
        bsr     requester

        cmpi.l  #IDCMP_GADGETUP,d0
        bne.s   .ende

        moveq.l #1,d0                   ;positive Antwort zurückgeben
.ende
        movem.l (a7)+,d1-d6
        rts

*--------------------------------------
* wird nur ausgegeben, wenn "datei_existiert" negativ beantwortet wurde

neuer_name

        movem.l d1-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     yes_no_eintragen
        move.l  #text_file_exists,d3
        move.l  #text_rename_it,d4
        bsr     nur_zwei_texte
        bsr     requester
        bsr     datei_req_antwort_auswerten

        movem.l (a7)+,d1-d6
        rts

*--------------------------------------

datei_existiert

        movem.l d1-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     yes_no_eintragen
        bsr     nur_zwei_texte
        move.l  #text_overwrite_it,d4

        tst.b   ConfigFileFlag          ;ConfigFile?
        bne.s   .config                 ;ja

        move.l  #text_file_exists,d3
        bra.s   .requester

.config
        tst.l   _MainWinPtr
        beq.s   .antwort

        move.l  #text_configfile_exists,d3

.requester
        bsr     requester

        cmpi.l  #IDCMP_GADGETUP,d0
        bne.s   .ende

.antwort
        moveq.l #1,d0                   ;positive Antwort zurückgeben
.ende
        movem.l (a7)+,d1-d6
        rts

*--------------------------------------

muell_datei_loeschen

        movem.l d1-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     yes_no_eintragen
        move.l  #text_file_error,d3
        move.l  #text_delete_it,d4
        bsr     nur_zwei_texte
        bsr     requester

        cmpi.l  #IDCMP_GADGETUP,d0
        bne.s   .ende

        moveq.l #1,d0                   ;positive Antwort zurückgeben
.ende
        movem.l (a7)+,d1-d6
        rts

*--------------------------------------

* ohne Rückgabewert
*------------------

source_file_aktiv

        movem.l d0-d6/a0-a1,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     okay_eintragen
        move.l  #text_souce_file_aktiv1,d3

        move.l  d3,a1
        adda.l  #13,a1
        lea     source_fullname,a0
        bsr     string_kopieren

        lea     text_souce_file_aktiv2,a0
        bsr     string_kopieren

        bsr     nur_einen_text
        bsr     requester

        movem.l (a7)+,d0-d6/a0-a1
        rts

*--------------------------------------

compiler_run_ok

        movem.l d0-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #compile_erfolgreich_txt,d3
        bsr     nur_einen_text
        bsr     requester

        movem.l (a7)+,d0-d6
        rts

*--------------------------------------

application_has_been_built

        movem.l d0-d6,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        bsr     i_see_eintragen
        move.l  #application_built_txt,d3
        bsr     nur_einen_text
        bsr     requester

        movem.l (a7)+,d0-d6
        rts

*--------------------------------------

about_box

        movem.l d0-d7/a0-a1,-(a7)

        move.l  #IDCMP_GADGETUP,d0
        moveq.l #0,d1
        move.l  #about_gad_txt,d2
        move.l  #text_about1,d3
        move.l  #text_about2,d4
        move.l  #text_about3,d5
        move.l  #text_about4,d6
        move.l  #req_title,d7
        move.l  _MainWinPtr,a0
        move.l  _FontAttrPtr,a1
        bsr     build_requester

        movem.l (a7)+,d0-d7/a0-a1
        rts

*--------------------------------------
* datei_req_antwort_auswerten
*
* >= d0.l = Antwort auf den Requester
*
* => d0.l = negativ = abbrechen, 0 = weitermachen
* => d1.l = Zeiger auf den Dateinamen
*--------------------------------------

datei_req_antwort_auswerten

        tst.l   d0                      ;welche Antwort ?
        bmi.s   .ende                   ;Requester wurde nicht ausgegeben
        beq.s   .fehler                 ;nein gewählt, "abbrechen" melden

        tst.b   sichern_Flag            ;Sichern- oder Laden-Schleife?
        beq.s   .laden                  ;laden

        bsr     asl_req_sichern         ;File-Requester ausgeben
        bra.s   .auswerten
.laden
        bsr     asl_req_laden           ;File-Requester ausgeben

.auswerten
        tst.l   d0                      ;"Cancel" gewählt ?
        beq.s   .fehler                 ;ja, "abbrechen" melden

        tst.w   pruef_Flag              ;von "dateiname_besorgen" aufgerufen worden ?
        bne.s   .ok                     ;ja, nicht mehr anlaufen

        bsr     dateiname_besorgen      ;prüfe den Namen
        tst.l   d0                      ;alles ok?
        bpl.s   .ok                     ;ja
.fehler
        moveq.l #-1,d0                  ;nein, melde "Fehler"
        bra.s   .ende                   ;und beenden
.ok
        moveq.l #0,d0                   ;melde "alles ok"
.ende
        rts
*--------------------------------------

