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
* asl_req_laden
*
* kein Übergaberegister, aber die Zeiger _fr_Dirname und _fr_Filename initialisiert
* wenn gewünscht, sonst NULL
*
* => d0.l = <> 0 = OK, = 0 = Cancel gewählt
*
* der Directoryname steht in TempDir
* der Filename steht in TempFile
*--------------------------------------
asl_req_laden

	movem.l d1-d3/a0-a2,-(a7)

	tst.l   _MainWinPtr     	;Fenster geöffnet?
	beq.s   .skip   		;nein

	move.l  _MainWinPtr,a2  	;Ptr übergeben
	bra.s   .req    		;und Requester ausgeben
.skip
	move.l  _SetupWinPtr,a2 	;Ptr übergeben
.req
	bsr     asl_req_laden_anlegen   ;Struktur anlegen
	move.l  a0,d2   		;Zeiger auf FileRequestStruktur merken
	move.l  a1,d3   		;Zeiger auf TagItemListe merken
	tst.l   d0      		;geklappt?
	beq.s   .ende   		;nein

	bsr     asl_request     	;Requester ausgeben
	tst.l   d0      		;welche Antwort ?
	beq.s   .ende   		;"Cancel" gewählt!

* aktuellen Dir- und Filenamen merken
*------------------------------------
	bsr     dir_filename_kopieren
.ende
	bsr     asl_req_freigeben       ;Strukturen wieder freigeben

	movem.l (a7)+,d1-d3/a0-a2
	rts
*--------------------------------------
* asl_req_laden_anlegen
*
* kein Übergaberegister, aber die Zeiger _fr_Dirname und _fr_Filename initialisiert
*
* => d0.l = Zeiger auf FileRequestStruktur, = 0 dann Fehler
* => a0.l = Zeiger auf FileRequestStruktur
* => a1.l = Zeiger auf TagItemListe
* => a2.l = WindowPtr
*--------------------------------------
asl_req_laden_anlegen

	movem.l d1-d2,-(a7)

* TagItemStruktur anlegen
*------------------------
	moveq.l #11,d0  		;Anzahl der Strukturen im Array
	bsr     allocate_tag_items      ;anlegen
	move.l  d0,d2   		;Zeiger merken, geklappt ?
	beq     .ende   		;nein

* TagItems fuer FileRequester eintragen
*--------------------------------------
	move.l  d0,a0   		;Zeiger auf TagArray zum Eintragen => a0
	move.l  d0,a1   		;in a1 zurückgeben

* Zeiger auf Titel eintragen
*---------------------------
	move.l  #ASL_FileRequest!ASLFR_TitleText,ti_Tag(a0)
	move.l  ASLReqTitel,ti_Data(a0)
	add.l   #ti_SIZEOF,a0

* WindowPtr eintragen
*--------------------
	move.l  #ASL_FileRequest!ASL_Window,ti_Tag(a0)
	move.l  _MainWinPtr,ti_Data(a0)
	add.l   #ti_SIZEOF,a0

* an der aktuellen Fensterposition ausgeben
*------------------------------------------
	moveq.l #0,d0
	move.w  wd_LeftEdge(a2),d0

	move.l  #ASL_FileRequest!ASL_LeftEdge,ti_Tag(a0)
	move.l  d0,ti_Data(a0)
	add.l   #ti_SIZEOF,a0

	move.w  wd_TopEdge(a2),d0

	move.l  #ASL_FileRequest!ASL_TopEdge,ti_Tag(a0)
	move.l  d0,ti_Data(a0)
	add.l   #ti_SIZEOF,a0

* IDCMPFlag eintragen
*--------------------
	move.l  #ASL_FileRequest!ASL_FuncFlags,ti_Tag(a0)
	move.l  #FILF_NEWIDCMP,ti_Data(a0)
	add.l   #ti_SIZEOF,a0

* Dirname eintragen
*------------------
	move.l  #ASL_FileRequest!ASLFR_InitialDrawer,ti_Tag(a0)
	move.l  _fr_Dirname,ti_Data(a0)
	add.l   #ti_SIZEOF,a0

* Filename eintragen
*-------------------
	move.l  #ASL_FileRequest!ASLFR_InitialFile,ti_Tag(a0)
	move.l  _fr_Filename,ti_Data(a0)
	add.l   #ti_SIZEOF,a0

	tst.w   MultiSelectFlag 	;MultiSelect erlaubt?
	beq.s   .skip   		;nein

* Do Multiselect?
*----------------
	move.l  #ASL_FileRequest!ASLFR_DoMultiSelect,ti_Tag(a0)
	move.l  #1,ti_Data(a0)
	add.l   #ti_SIZEOF,a0

* Datenende kennzeichnen
*-----------------------
.skip
	move.l  #TAG_DONE,ti_Tag(a0)

* FileRequesterStruktur anlegen
*------------------------------
	moveq.l #0,d0   		;Filerequester wanted
	bsr     alloc_asl_request       ;RequesterStruktur anlegen
	move.l  d0,a0   		;auch in a0 zurückgeben
.ende
	movem.l (a7)+,d1-d2
	rts
*--------------------------------------
* asl_req_freigeben
*
* >= d2.l = Zeiger auf FileRequestStruktur
* >= d3.l = Zeiger auf TagItemListe
*
* kein Rückgaberegister
*--------------------------------------
asl_req_freigeben

	tst.l   d2      		;FileRequestStruktur vorhanden?
	beq.s   .tags   		;nein

	move.l  d2,a0   		;Zeiger übergeben
	bsr     free_asl_request	;wieder freigeben
.tags
	tst.l   d3      		;TagItemListe vorhanden?
	beq.s   .ende   		;nein

	move.l  d3,a0   		;Zeiger übergeben
	bsr     free_tag_items  	;TagItemStr wieder freigeben
.ende
	rts
*--------------------------------------
* dir_filename_kopieren
*
* >= a0.l = Zeiger auf FileRequestStruktur
*
* kein Rückgaberegister, aber:
*
* der Directoryname steht in TempDir
* der Filename steht in TempFile

* bei Multiselect wird, wenn mehrere Files angewaehlt
* werden, neuer Puffer allokiert und der Zeiger im
* Label _FileListPuffer abgelegt.
* Wenn nur 1 File gewaehlt wird, steht der Filename
* wie gehabt in TempFile.
*--------------------------------------
dir_filename_kopieren

	movem.l a0-a1,-(a7)

	move.l  rf_Dir(a0),a0   	;zeige auf Dirnamen
	lea     TempDir,a1      	;zeige auf Puffer
	bsr     string_kopieren 	;eintragen

	move.l  (a7),a0 		;Zeiger auf FileRequestStruktur => a0
	tst.l   fr_NumArgs(a0)  	;MultiSelect ?
	beq.s   .skip   		;nein

	bsr     file_liste_kopieren     ;ja, Namen kopieren
	bra.s   .ende   		;und beenden
.skip
	move.l  (a7),a0 		;Zeiger auf FileRequestStruktur => a0
	move.l  rf_File(a0),a0  	;zeige auf Filenamen
	lea     TempFile,a1     	;zeige auf Puffer
	bsr     string_kopieren 	;eintragen
.ende
	movem.l (a7)+,a0-a1
	rts
*--------------------------------------

* >= a0 = Zeiger auf FilerequestStruktur

file_liste_kopieren

	movem.l d0-d2/a0-a3,-(a7)

	move.l  fr_NumArgs(a0),d2       ;Anzahl    => d2
	move.l  fr_ArgList(a0),a2       ;ListenPtr => a2

	cmpi.w  #1,d2   		;nur 1 File gewaehlt?
	beq     .ein_file       	;ja

	move.l  d2,FileListAnzahl       ;merken
	move.l  d2,d0   		;zum Rechnen => d0
	mulu    #32,d0  		;mit der maximalen Filenamenlaenge
					;multiplizieren

	move.l  #MEMF_ANY!MEMF_CLEAR!MEMF_LARGEST,d1
	bsr     alloc_vec       	;reservieren
	move.l  d0,_FileListPuffer      ;merken, geklappt?
	beq     .ende   		;nein

	move.l  d0,a3   		;in a3 merken
	moveq   #4,d1   		;Offset-Zählregister initialisieren
	subq    #1,d2   		;Schleifen-Zählregister -1
.loop
	move.l  0(a2,d1),a0     	;zeige auf Filenamen
	move.l  a3,a1   		;Zeiger auf Puffer => a1
	bsr     string_kopieren 	;eintragen

	addq    #8,d1   		;Offset-Zählregister aufaddieren
	add.l   #32,a3  		;PufferAdresse aufaddieren
	dbra    d2,.loop

	clr.l   TempFile		;evtl. alten Eintrag löschen
	bra.s   .ende   		;und beenden

.ein_file
	move.l  4(a2),a0		;zeige auf Filenamen
	lea     TempFile,a1     	;zeige auf Puffer
	bsr     string_kopieren 	;eintragen
.ende
	movem.l (a7)+,d0-d2/a0-a3
	rts

*--------------------------------------
