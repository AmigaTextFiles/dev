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
* asl_req_sichern
*
*
* kein Übergaberegister, aber die Zeiger _fr_Dirname und _fr_Filename initialisiert
* wenn gewünscht, sonst NULL
*
* => d0.l = <> 0 = OK, = 0 = Cancel gewählt
*
* der Directoryname steht in TempDir
* der Filename steht in TempFile
*--------------------------------------
asl_req_sichern

        movem.l d1-d3/a0-a1,-(a7)

        bsr.s   asl_req_sichern_anlegen ;Struktur anlegen
        move.l  a0,d2                   ;Zeiger auf FileRequestStruktur merken
        move.l  a1,d3                   ;Zeiger auf TagItemListe merken
        tst.l   d0                      ;geklappt?
        beq.s   .ende                   ;nein

        bsr     asl_request             ;Requester ausgeben
        tst.l   d0                      ;welche Antwort ?
        beq.s   .ende                   ;"Cancel" gewählt!

* aktuellen Dir- und Filenamen merken
*------------------------------------
        bsr     dir_filename_kopieren
.ende
        bsr     asl_req_freigeben       ;Strukturen wieder freigeben

        movem.l (a7)+,d1-d3/a0-a1
        rts
*--------------------------------------
* asl_req_sichern_anlegen
*
* kein Übergaberegister, aber die Zeiger _fr_Dirname und _fr_Filename initialisiert
*
* => d0.l = Zeiger auf FileRequestStruktur, = 0 dann Fehler
* => a0.l = Zeiger auf FileRequestStruktur
* => a1.l = Zeiger auf TagItemListe
*--------------------------------------
asl_req_sichern_anlegen

        movem.l d1-d2/a2,-(a7)

* TagItemStruktur anlegen
*------------------------
        moveq.l #10,d0                  ;Anzahl der Strukturen im Array
        bsr     allocate_tag_items      ;anlegen
        move.l  d0,d2                   ;Zeiger merken, geklappt ?
        beq     .ende                   ;nein

* TagsItems fuer FileRequester eintragen
*---------------------------------------
        move.l  d0,a0                   ;Zeiger auf TagArray zum Eintragen => a0
        move.l  d0,a1                   ;in a1 zurückgeben

* Zeiger auf Titel Text eintragen
*--------------------------------
        move.l  #ASL_FileRequest!ASLFR_TitleText,ti_Tag(a0)

        move.l  d0,-(a7)
        move.l  a0,-(a7)
        move.l  ASLReqTitel,d0
        bsr     GetString
        move.l  a0,d0
        move.l  (a7)+,a0
        move.l  d0,ti_Data(a0)
        move.l  (a7)+,d0

        add.l   #ti_SIZEOF,a0

* "SaveMode" eintragen
*---------------------
        move.l  #ASL_FileRequest!ASLFR_DoSaveMode,ti_Tag(a0)
        move.l  #True,ti_Data(a0)
        add.l   #ti_SIZEOF,a0

* WindowPtr eintragen
*--------------------
        move.l  #ASL_FileRequest!ASL_Window,ti_Tag(a0)
        move.l  _MainWinPtr,ti_Data(a0)
        add.l   #ti_SIZEOF,a0

* an der aktuellen Fensterposition ausgeben
*------------------------------------------
        moveq.l #0,d0                   ;Register löschen
        move.l  _MainWinPtr,a2          ;zeige auf WindowStruktur
        move.w  wd_LeftEdge(a2),d0      ;aktuellen Wert => d0

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

* Datenende kennzeichnen
*-----------------------
        move.l  #TAG_DONE,ti_Tag(a0)

* FileRequesterStruktur anlegen
*------------------------------
        moveq.l #0,d0                   ;Filerequester wanted
        bsr     alloc_asl_request       ;RequesterStruktur anlegen
        move.l  d0,a0                   ;auch in a0 zurückgeben
.ende
        movem.l (a7)+,d1-d2/a2
        rts
*--------------------------------------
