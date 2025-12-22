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
* set_source
*
* Besorgt den Namen eines neuen Source-Files
* und veranlasst alle Einstellungen.
* Legt ein neues File an, wenn nicht vorhanden.
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

set_source

	move.l  #set_source_Text,ASLReqTitel
					;Titel für ASLRequester eintragen
	tst.l   source_dirname  	;Name eingetragen?
	bne.s   .eintragen      	;ja

	move.l  src_dir,_fr_Dirname	;nein, default Directory eintragen
	bra.s   .asl_requester  	;Requester ausgeben

.eintragen
	move.l  #source_dirname,_fr_Dirname
					;alten DirectoryNamen eintragen
.asl_requester
	move.l  #source_filename,_fr_Filename
					;evtl. FileNamen eintragen

	bsr     asl_req_laden   	;FileRequester ausgeben
	tst.l   d0      		;welche Antwort?
	beq.s   .deactivate     	;Cancel gewählt, alles löschen

	tst.b   TempFile		;Name gewählt?
	beq.s   .message		;nein

	move.w  #1,new_source_file_Flag ;evtl. neues SourceFile gewünscht?

	bsr     dateiname_besorgen      ;prüfe die Eingabe
	tst.l   d0      		;alles ok?
	bpl.s   .activate       	;ja

	tst.w   new_source_file_Flag    ;evtl. neues SourceFile gewünscht?
	bne.s   .deactivate     	;nein, Fehler im Directorynamen!

	bsr     create_new_source_file  ;neues File anlegen
	bra.s   .ende   		;und beenden, alles Notwendige wird von
					;"create_new_source_file" erledigt!!
.activate
	clr.w   new_source_file_Flag    ;Flag löschen, wird nicht mehr gebraucht
	bsr     activate_source 	;SourceFile aktivieren
	bra.s   .ende   		;und beenden

.message
	bsr     no_source_file_selected ;Requester ausgeben
	tst.l   d0      		;welche Antwort?
	bmi.s   .deactivate     	;Requester wurde nicht ausgegeben
	bne.s   .asl_requester  	;Retry gewählt, nochmal ausgeben

.deactivate
	tst.l   source_filename 	;schon ein SourceFile gesetzt gewesen?
	beq.s   .ende   		;nein

	bsr     really_kill_source      ;Meldung ausgeben?
	tst.l   d0      		;welche Antwort?
	beq.s   .ende   		;Nein gewählt

	bsr     clean_up_settings       ;Settings zurücksetzen
	bsr     clean_up_files  	;alle Files im temporären Directory löschen
.ende
	rts
*--------------------------------------
* reset_source
*
* Aktiviert ein altes Source-File für einen neuen
* kompletten Compilerdurchlauf.
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

reset_source

	bsr     clear_compiler_status   ;Compiler Ergebnis löschen
	bsr     clean_up_files  	;alle temporären Files löschen
	bsr     activate_gads_new_source
					;Gadgets einstellen
	move.w  #1,source_set_Flag      ;Flag wieder setzen, Source neu gesetzt
	rts
*--------------------------------------
* create_new_source_file
*
* Legt ein neues Source-File an und aktiviert die Settings für einen neuen
* kompletten Compilerdurchlauf. Aktiviert ebenfalls den Editor.
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

create_new_source_file

	movem.l d0-d5/a0-a1,-(a7)

	bsr     set_source_vorbereitung ;Einstellungen zurücksetzen usw...

	bsr     pruefe_auf_filetype     ;als ACE SourceFile markiert?
	tst.l   d0      		;alles klar?
	bmi.s   .ende   		;nein

	move.l  #source_fullname,d1     ;zeige auf den Namen
	move.l  #Dateiname,d2   	;zeige auf Dummy Puffer
	clr.l   Dateiname       	;NullBytes eintragen
	moveq.l #0,d3   		;NullBytes schreiben
	bsr     datei_sichern   	;und File anlegen

	bsr     edit_source     	;Editor aufrufen
	bsr     activate_source 	;und aktivieren
.ende
	movem.l (a7)+,d0-d5/a0-a1
	rts
*--------------------------------------
* edit_source
*
* Aktiviert den Editor für ein aktuelles Source-File.
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

edit_source

	movem.l d0-d6/a0-a1,-(a7)

	moveq.l #0,d4   		;Register löschen, wichtig!!!
	moveq.l #0,d5

	move.l  editor,a0       	;zeige auf den Editornamen
	lea     Dateiname,a1    	;als Commandoablage benutzen
	move.l  a1,d3   		;in d3 merken
	bsr     string_kopieren 	;Editorname incl. Directory eintragen

	lea     source_fullname,a0      ;auf den kompletten Sourcenamen zeigen
	move.l  a0,d1   		;in d1 übergeben
	move.b  #" ",(a1)+      	;Space eintragen
	bsr     string_kopieren 	;ebenfalls eintragen

	bsr     file_info_block 	;besorge die Daten zum File
	tst.l   d0      		;alles klar?
	bmi.s   .ende   		;nein

	move.l  d1,d4   		;Zeiger auf 1. FIBlock in d4 merken

	movem.l d1-d3/a0-a2,-(a7)

	move.l  d3,d6   		;Zeiger auf Kommandostring übergeben
	clr.l   AsynchFlag      	;läuft synchron
	bsr     program_ausfuehren      ;und ausführen

	movem.l (a7)+,d1-d3/a0-a2

	tst.l   d0      		;alles ok?
	bne.s   .ende   		;nein

	move.l  #source_fullname,d1     ;auf den kompletten Sourcenamen zeigen
	bsr     file_info_block 	;besorge die Daten zum File
	tst.l   d0      		;alles klar?
	bmi.s   .ende   		;nein

	move.l  d1,d5   		;Zeiger auf 2. FIBlock in d5 merken

	move.l  d4,a0   		;Zeiger auf 1. FIBlock in a0 übergeben
	move.l  d5,a1   		;Zeiger auf 2. FIBlock in a1 übergeben
	bsr     get_datestamp_differences
					;unterschiedlich?
	tst.l   d0      		;welches Ergebnis?
	beq.s   .ende   		;keine Änderung

	bsr     reset_source    	;Änderung, neuer Compilerlauf erforderlich
.ende
	move.l  d4,d2   		;zeige auf 1. FIBlock
	bsr     free_fiblock    	;freigeben

	move.l  d5,d2   		;zeige auf 2. FIBlock
	bsr     free_fiblock    	;freigeben

	movem.l (a7)+,d0-d6/a0-a1
	rts
*--------------------------------------
* activate_source
*
* Aktiviert ein neues Source-File für einen kompletten Compilerdurchlauf.
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

activate_source

	movem.l d0-d2/a0-a1,-(a7)

	bsr     set_source_vorbereitung ;Einstellungen zurücksetzen usw...

	bsr     pruefe_auf_filetype     ;ACE SourceFile gewählt?
	tst.l   d0      		;alles klar?
	bmi.s   .ende   		;nein

* Überprüfe ob ein .info File existiert
*--------------------------------------
	lea     source_fullname,a0      ;zeige auf den kompletten Namen
	lea     Dateiname,a1    	;zeige auf Arbeitspuffer
	move.l  a1,d1   		;in d1 übergeben
	bsr     string_kopieren 	;eintragen

	move.b  #".",(a1)+      	;".info" anfügen
	move.b  #"i",(a1)+
	move.b  #"n",(a1)+
	move.b  #"f",(a1)+
	move.b  #"o",(a1)+

	move.b  #0,(a1) 		;NullByte anfügen
	move.w  #1,pruef_Flag   	;nur den FileNamen überprüfen
	bsr     fileinfo_besorgen       ;gibt es ein .info File?
	clr.w   pruef_Flag      	;Flag wieder löschen
	tst.l   d0      		;ja?
	bmi.s   .activate       	;nein

	move.l  #source_dirname,d1      ;zeige aufs Directory
	moveq.l #-2,d2  		;SharedLock
	bsr     lock    		;Lock besorgen
	move.l  d0,d1   		;in d1 übergeben

	lea     source_filename,a0      ;zeige auf den Filenamen
	bsr     tooltypes_ermitteln     ;besorge die ToolTypes
	tst.l   d0      		;alles klar?
	bmi.s   .unlock 		;nein

	bsr     set_source_tooltypes    ;ToolTypes eintragen und prüfen
.unlock
	bsr     unlock  		;Lock wieder freigeben

.activate
	bsr     activate_gads_new_source
					;Gadgets einstellen
	move.w  #1,source_set_Flag      ;Flag wieder setzen, Source neu gesetzt
	bsr     source_file_aktiv       ;Meldung ausgeben
.ende
	movem.l (a7)+,d0-d2/a0-a1
	rts
*--------------------------------------
* set_source_tooltypes
*
* Stellt auf Grund der ToolTypes die CompilerOptions ein
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

set_source_tooltypes

	movem.l d0-d2/a0-a1,-(a7)

	tst.l   tp_configfile   	;Eintrag vorhanden?
	beq.s   .preco  		;nein

	bsr     load_tp_configfile      ;evtl. File laden
.preco
	tst.l   tp_preco		;Eintrag vorhanden?
	beq.s   .ende   		;nein

	move.l  MakeSetup,d2    	;Flag => d2

	lea     tp_preco,a0     	;zeige auf ermittelten Eintrag für Precompiler

	lea     GadText_12,a1   	;zeige auf String "APP"
	moveq.l #0,d1   		;Groß/Kleinschreibung nicht beachten
	bsr     string_compare  	;vergleiche
	tst.l   d0      		;identisch?
	bne.s   .acpp   		;nein

	moveq.l #app,d0 		;setze Flag => APP
	bclr    #acpp,d2		;die anderen löschen
	bclr    #preco_other,d2
	bra.s   .ausgeben       	;und setzen
.acpp
	lea     GadText_13,a1   	;zeige auf String "ACPP"
	moveq.l #0,d1   		;Groß/Kleinschreibung nicht beachten
	bsr     string_compare  	;vergleiche
	tst.l   d0      		;identisch?
	bne.s   .other  		;nein

	moveq.l #acpp,d0		;setze Flag => ACPP
	bclr    #app,d2 		;die anderen löschen
	bclr    #preco_other,d2
	bra.s   .ausgeben       	;und setzen
.other
	moveq.l #preco_other,d0 	;setze Flag => other Preco
	bclr    #app,d2 		;die anderen löschen
	bclr    #acpp,d2

	bsr     other_preco_eintragen

	move.l  _MemPtr,a1      	;zeige auf Konfigurationsdaten
	lea     other_precomp_name(a1),a1
					;zeige auf den Eintrag
	bsr     string_kopieren 	;aktuellen Preco-Namen eintragen

.ausgeben
	bset    d0,d2   		;Precompiler Bit setzen
	move.l  d2,MakeSetup    	;Einstellung merken
	bsr     preco_gad_einstellen    ;MX Gadget einstellen
.ende
	movem.l (a7)+,d0-d2/a0-a1
	rts
*--------------------------------------
* set_source_vorbereitung
*
* Löscht alle vorherigen Einstellungen und Gadgets und veranlasst das
* Kopieren der Namen aus "TempDir" und "TempFile" in
* "source_dirname", "source_filename" und "source_fullname"
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

set_source_vorbereitung

	bsr     clear_compiler_status   ;Compiler Ergebnis löschen
	bsr     clean_up_files  	;alle temporären Files löschen
	clr.w   source_set_Flag 	;Flag löschen, damit die Gadgets z.Zt. nicht
					;beinflußt werden
	bsr     clean_up_settings       ;Einstellungen zurücksetzen

	move.w  #1,source_set_Flag      ;Flag wieder setzen, damit bei einem Fehler
					;auch die Gadgets disabled werden.
	bsr     source_name_eintragen   ;trage die Namen in die MerkArrays ein

	rts
*--------------------------------------
* source_name_eintragen
*
* Kopiert die Namen aus "TempDir" und "TempFile" in
* "source_dirname", "source_filename" und "source_fullname"
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

source_name_eintragen

	movem.l a0-a3,-(a7)

	lea     TempDir,a0      	;trage die Namen in die MerkArrays ein

	bsr     name_ram_disk_korrigieren
					;mit evtl. "Ram Disk" Namenskorrekur eintragen

	lea     source_dirname,a0       ;zeige auf den korrigierten DirNamen
	lea     source_fullname,a1      ;ebenfalls hier eintragen
	move.l  a1,d1   		;in d1 übergeben
	bsr     string_kopieren 	;eintragen

	move.w  #1,pruef_Flag   	;nur den FileNamen überprüfen
	bsr     pruefe_den_dirnamen     ;ROOT oder Unterdirectory?
	clr.w   pruef_Flag      	;Flag wieder löschen
	move.l  a1,a3   		;Ende des Namens in a3 merken

	lea     TempFile,a0     	;jetzt kommt der Filename dran
	move.l  a0,a2   		;in a2 merken
	lea     source_filename,a1      ;zeige auf FilenamenPuffer
	bsr     string_kopieren 	;eintragen

	move.l  a2,a0   		;zeige wieder auf den FileNamen
	move.l  a3,a1   		;zeige wieder auf die Fortsetzung im "source_fullname" Puffer
	bsr     string_kopieren 	;eintragen

	movem.l (a7)+,a0-a3
	rts
*--------------------------------------
