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

get_start_wb_args

	movem.l d0-d1/a0-a1,-(a7)

	move.l  _WbenchMsg,a0   	;zeige auf WbMessageStruktur
	move.l  sm_NumArgs(a0),d0       ;Anzahl der Argumente => d0
	move.l  sm_ArgList(a0),a0       ;Zeiger auf ArgList => a0

	cmpi.l  #2,d0   		;weniger als 2 Argumente?
	bmi.s   .skip   		;ja

* Anmerkung:
* Es wird nur das 2. Argument = 1. Project Icon ausgewertet!!!
* Das 1. Argument enthält immer die Daten zum zu startenden Programm.
* Wenn das 2. Argument nicht vorhanden ist, wird das Argument
* des Programms ausgewertet.

	move.l  8(a0),d1		;Lock  2. Argument => d1
	move.l  12(a0),a0       	;Namen 2. Argument => a0
	bra.s   .dir
.skip
	move.l  (a0),d1 		;Lock  1. Argument => d1
	move.l  4(a0),a0		;Namen 1. Argument => a0
.dir
	lea     tp_program_name,a1      ;merke dir den ProgrammNamen hier
	move.l  a0,-(a7)		;a0 retten
	bsr     string_kopieren 	;Namen eintragen
	move.l  (a7)+,a0		;a0 wieder herstellen

	bsr     tooltypes_ermitteln     ;die Tooltypes auslesen
	tst.l   d0      		;alles ok?
	bmi.s   .ende   		;nein

	lea     tp_program_dir,a1       ;zeige auf Namenspuffer
	bsr     get_dirname     	;welches Directory?
	tst.l   d0      		;alles ok?
	bpl.s   .ende   		;ja, beenden

	move.l  #0,(a1) 		;nein, evtl. alten Eintrag löschen
.ende
	movem.l (a7)+,d0-d1/a0-a1
	rts

*--------------------------------------
* tooltypes_ermitteln
*
* >= d1.l = BCPLPtr auf LockStruktur
* >= a0.l = Zeiger auf den Filenamen
*
* => d0.l = positiv = alles ok, negativ dann keine Tooltypes
*--------------------------------------

tooltypes_ermitteln

	movem.l d1-d5/a0-a6,-(a7)

	bsr     dos_current_dir 	;vorübergehend setzen
	move.l  d0,d2   		;alten Lock merken

	CALLICON GetDiskObject  	;hole die DiskObjectStruktur
	move.l  d0,d3   		;merken, geklappt?
	bne.s   .tool_types     	;ja

	move.l  d2,d1   		;oldLock => d1
	bsr     dos_current_dir 	;wieder auf altes Dir zurücksetzen
	moveq.l #-1,d0  		;melde Fehler
	bra.s   .ende   		;und beenden

.tool_types
	move.l  d0,a0   		;zeige auf DiskObjectStruktur
	move.l  do_ToolTypes(a0),a2     ;Zeiger auf die ToolTypes merken
	lea     ToolTypesTable,a3       ;zeige auf ZeigerTabelle
	lea     ToolTypesAblage,a4      ;zeige auf Ablage
	moveq.l #0,d4   		;Offsetzählregister initialisieren
.loop
	move.l  a2,a0   		;Zeiger auf ToolTypes => a0
	tst.l   0(a3,d4)		;= NULL, EndeMarkierung?
	beq.s   .auswerten      	;ja, Ergebnis auswerten

	move.l  0(a3,d4),a1     	;zeige auf Suchstring
	CALLSYS FindToolType    	;suche den Eintrag
	move.l  d0,0(a4,d4)     	;Ergebnis ablegen
	addq    #4,d4   		;Offsetzählregister aufaddieren
	bra.s   .loop   		;und nächsten Eintrag suchen

.auswerten
	moveq.l #0,d4   		;Offsetzählregister zurücksetzen
	moveq.l #AnzahlToolTypes-1,d5   ;Schleifenzählregister initialisieren

	lea     ToolTypesEinstellungen,a3
					;zeige auf ToolTypesAblageTabelle
.loop2
	move.l  0(a4,d4),a0     	;zeige auf gefundenen Eintrag
	move.l  0(a3,d4),a1     	;zeige auf Ablage
	cmp.l   #0,a0   		;Zeiger vorhanden?
	beq.s   .next   		;nein

	bsr     string_kopieren 	;eintragen
.next
	addq    #4,d4   		;Offsetzählregister aufaddieren
	dbra    d5,.loop2       	;und nächsten Eintrag bearbeiten

	move.l  d3,a0   		;zeige auf DiskObjectStruktur
	CALLSYS FreeDiskObject  	;wieder freigeben

	move.l  d2,d1   		;oldLock => d1
	bsr     dos_current_dir 	;wieder auf altes Dir zurücksetzen
.ende
	movem.l (a7)+,d1-d5/a0-a6
	rts

*--------------------------------------

set_start_source_tooltypes

	tst.l   tp_program_name 	;Name eingetragen?
	beq     .abort  		;nein

	movem.l d0-d1/a0-a2,-(a7)

	move.w  #1,pruef_Flag   	;nur den Filenamen überprüfen

	lea     tp_program_name,a0      ;zeige auf den Namen
	lea     default_aide_name,a1    ;zeige auf "AIDE"
	moveq.l #0,d1   		;Groß/Kleinschreibung nicht beachten
	bsr     string_compare  	;vergleiche
	tst.l   d0      		;identisch?
	bne.s   .bearbeiten     	;nein

	clr.l   source_filename 	;evtl. Einträge löschen
	clr.l   source_dirname
	clr.l   source_fullname
	bra.s   .ende   		;und beenden

.bearbeiten
	lea     source_filename,a1      ;zeige auf Ablage
	move.l  a0,a2   		;Zeiger auf Filenamen merken
	bsr     string_kopieren 	;eintragen

	lea     tp_program_dir,a0       ;zeige auf den Namen des Directories

	bsr     name_ram_disk_korrigieren
					;mit evtl. "Ram Disk" Namenskorrekur eintragen

	lea     source_dirname,a0       ;korrigierten Directory-Namen
	lea     source_fullname,a1      ;auch hier eintragen
	move.l  a1,d1   		;in d1 übergeben
	bsr     string_kopieren 	;kopieren

	bsr     pruefe_den_dirnamen     ;ROOT oder Unterdirectory?

	move.l  a2,a0   		;zeige wieder auf den Filenamen
	bsr     string_kopieren 	;ebenfalls eintragen

	bsr     pruefe_auf_filetype     ;ACE Source File gewählt?
	tst.l   d0
	bmi.s   .ende   		;nein

	move.w  #1,source_set_Flag      ;ja, Flag setzen

	tst.l   tp_configfile   	;ConfigFile angegeben?
	beq.s   .ende   		;nein

	bsr     load_tp_configfile      ;File laden
.ende
	clr.w   pruef_Flag      	;Flag wieder löschen

	movem.l (a7)+,d0-d1/a0-a2
.abort
	rts

*--------------------------------------

get_preco_from_tooltypes

	movem.l d0-d2/a0-a2,-(a7)

	tst.l   tp_preco		;Eintrag vorhanden?
	beq.s   .ende   		;nein

	move.l  MakeSetup,d2    	;Flag => d2

	lea     tp_preco,a0     	;zeige auf ermittelten Eintrag für Precompiler
	lea     GadText_12,a1   	;zeige auf String "APP"
	moveq.l #0,d1   		;Groß/Kleinschreibung nicht beachten
	bsr     string_compare  	;vergleiche
	tst.l   d0      		;identisch?
	bne.s   .acpp   		;nein

	moveq.l #0,d0   		;setze Flag => APP
	bset    #0,d2   		;APP Bit setzen
	bclr    #1,d2   		;die anderen löschen
	bclr    #2,d2
	bra.s   .merken
.acpp
	lea     GadText_13,a1   	;zeige auf String "ACPP"
	moveq.l #0,d1   		;Groß/Kleinschreibung nicht beachten
	bsr     string_compare  	;vergleiche
	tst.l   d0      		;identisch?
	bne.s   .other  		;nein

	moveq.l #1,d0   		;setze Flag => ACPP
	bset    #1,d2   		;ACPP Bit setzen
	bclr    #0,d2   		;die anderen löschen
	bclr    #2,d2
	bra.s   .merken
.other
	moveq.l #2,d0   		;setze Flag => other Preco
	bset    #2,d2   		;other Bit setzen
	bclr    #0,d2   		;die anderen löschen
	bclr    #1,d2

	bsr     other_preco_eintragen   ;in AusgabeTexte eintragen

	move.l  _MemPtr,a1      	;zeige auf Konfigurationsdaten
	lea     other_precomp_name(a1),a1
					;zeige auf den Eintrag
	bsr     string_kopieren 	;aktuellen Preco-Namen eintragen
.merken
	move.l  d2,MakeSetup    	;merken
.ende
	movem.l (a7)+,d0-d2/a0-a2
	rts

*--------------------------------------
