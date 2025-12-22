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
* Funktionen der dos.library
*--------------------------------------
* open_datei
*
* >= d1.l = Zeiger auf Dateinamen
* >= d2.l = Modus ( #1005 = alt, #1006 = neu, #1004 = read/write )
*
* => d0.l = FileHandle = alles ok, = negativ = Fehler
*--------------------------------------

open_datei

	movem.l d1-d3/a0-a1/a6,-(a7)

	move.l  d1,d3   		;Zeiger auf Dateinamen sichern
.open
	move.l  d3,d1   		;Zeiger auf Dateinamen uebergeben
	CALLDOS Open    		;Datei oeffnen
	tst.l   d0      		;alles ok ?
	bne.s   .ende   		;ja, beenden

	bsr     io_error		;nein, IO_Error
	tst.l   d0      		;welche Antwort ?
	bpl.s   .open   		;mit 'Retry' beantwortet, nochmal versuchen
.fehler
	moveq.l #-1,d0  		;melde Fehler
.ende
	movem.l (a7)+,d1-d3/a0-a1/a6
	rts

*--------------------------------------
* read_datei
*
* Besorgt neuen Speicher, wenn kein PufferPtr angegeben ist.
* öffnet, liest und schliesst die Datei.
*
* >= d1.l = Zeiger auf Dateinamen
* >= d2.l = Zeiger auf Puffer
* >= d3.l = Dateigröße  in Bytes
*
* => d0.l = positiv = alles ok, = negativ = Fehler
* => d2.l = Zeiger auf Puffer, falls keiner angegeben war!!
*--------------------------------------

read_datei

	movem.l d1/d3-d5/a0-a1/a6,-(a7)

	move.l  d2,d4   		;Zeiger auf Puffer merken
					;Zeiger auf Dateinamen steht in d1
	move.l  #1005,d2		;Modus "alt" = lesen
	bsr     open_datei      	;öffnen
	move.l  d0,d5   		;FileHandle => d5 merken
	bmi.s   .ende   		;negativ, dann "Fehler"

	move.l  d4,d2   		;Zeiger => d2, angegeben?
	bne.s   .read   		;ja, lesen

	bsr     new_buffer      	;Puffer besorgen
	tst.l   d2      		;geklappt?
	beq.s   .fehler 		;nein, melde "Fehler"
.read
	move.l  d5,d1   		;FileHandle => d1
					;in d2 steht der Zeiger auf den Puffer
					;in d3 steht die Dateigröße in Bytes
	CALLDOS Read    		;und lesen
	tst.l   d0      		;alles ok ?
	bpl.s   .ok     		;ja

	bsr     io_error		;nein, IOError
	tst.l   d0      		;welche Antwort ?
	bpl.s   .read   		;mit 'Retry' beantwortet
	bra.s   .fehler 		;mit 'Cancel' beantwortet
					;melde "Fehler"
.ok
	cmp.l   d0,d3   		;alles gelesen ?
	bpl.s   .ende   		;ja, schließen

	bsr     datei_nicht_vollstaendig_geladen
					;Meldung ausgeben
.fehler
	moveq.l #-1,d0  		;melde "Fehler"
.ende
	move.l  d5,d1   		;FileHandle übergeben
	bsr     close_datei     	;Datei schließen

	movem.l (a7)+,d1/d3-d5/a0-a1/a6
	rts

*--------------------------------------
* write_datei
*
* öffnet, schreibt und schließt die Datei.
*
* >= d1.l = Zeiger auf Dateinamen
* >= d2.l = Zeiger auf Puffer
* >= d3.l = Dateigröße in Bytes
*
* => d0.l = positiv = alles ok, = negativ = Fehler
*--------------------------------------

write_datei

	movem.l d1-d4/a0-a1/a6,-(a7)

	move.l  #1006,d2		;Modus = "neu" => d2
	bsr     open_datei      	;öffnen
	move.l  d0,d4   		;FileHandle => d4 merken
	bmi.s   .ende   		;negativ, dann "Fehler", beenden
.write
	move.l  d4,d1   		;FileHandle wieder => d1
	move.l  4(a7),d2		;Zeiger auf Speicher => d2
	CALLDOS Write   		;schreiben
	tst.l   d0      		;alles ok ?
	bpl.s   .pruefe 		;vielleicht

	bsr     io_error		;nein, IO_Error
	tst.l   d0      		;welche Antwort ?
	bpl.s   .write  		;mit 'Retry' beantwortet

	move.l  d4,d1   		;FileHandle übergeben
	bsr     close_datei     	;Datei vorher schließen, kann sonst nicht gelöscht werden

.loeschen
	bsr     muell_datei_loeschen    ;Meldung ausgeben, fehlerhafte Datei löschen?
	tst.l   d0      		;welche Antwort?
	bmi.s   .ende   		;Requester wurde nicht ausgegeben
	beq.s   .fehler 		;mit 'nein' beantwortet

	move.l  (a7),d1 		;zeige auf Dateinamen
	bsr     dos_delete_file 	;fehlerhaftes File löschen
	bra.s   .fehler 		;melde "Fehler"

.pruefe
	move.l  d4,d1   		;FileHandle übergeben
	bsr.s   close_datei     	;Datei schließen

	cmp.l   d0,d3   		;alles geschrieben ?
	bne.s   .loeschen       	;nein, Datei wieder löschen
	beq.s   .ende   		;ja, beenden
.fehler
	moveq.l #-1,d0  		;melde "Fehler"
.ende
	movem.l (a7)+,d1-d4/a0-a1/a6
	rts
*--------------------------------------
* close_datei
*
* >= d1.l = FileHandle
*
* kein Rueckgaberegister
*--------------------------------------

close_datei

	movem.l d0-d1/a0-a1/a6,-(a7)

	CALLDOS Close   		;Datei schliessen

	movem.l (a7)+,d0-d1/a0-a1/a6
	rts
*--------------------------------------
* lock ©
*
* >= d1.l = Zeiger auf Name
* >= d2.l = Mode = -2 = SharedLock, = -1 = ExclusiveLock
*
* => d0.l = BPtr auf LockStruktur = alles ok, = 0 = Fehler
*--------------------------------------

lock

	movem.l d1/a0-a1/a6,-(a7)

	CALLDOS Lock

	movem.l (a7)+,d1/a0-a1/a6
	rts
*---------------------------------------
* dos_current_dir
*
* >= d1.l = BCPLPointer auf Lock
*
* => d0.l = BCPLPtr auf oldLockStruktur
*--------------------------------------

dos_current_dir

	movem.l d1/a0-a1/a6,-(a7)

	CALLDOS CurrentDir

	movem.l (a7)+,d1/a0-a1/a6
	rts

*---------------------------------------
* unlock ©
*
* => d1.l = BPtr auf LockStruktur
*
* kein Rückgaberegister
*--------------------------------------

unlock
	tst.l   d1      		;Zeiger vorhanden
	beq.s   .abbruch		;nein

	movem.l d0-d1/a0-a1/a6,-(a7)

	CALLDOS UnLock

	movem.l (a7)+,d0-d1/a0-a1/a6

.abbruch
	rts

*---------------------------------------
* examine ©
*
* => d1.l = BPtr auf LockStruktur
* => d2.l = APtr auf FIBlockPuffer (long-aligned)
*
* => d0.l = -1 = alles ok, = 0 = Fehler
*--------------------------------------

examine

	movem.l d1/a0-a1/a6,-(a7)

	CALLDOS Examine

	movem.l (a7)+,d1/a0-a1/a6
	rts

*---------------------------------------
* ex_next ©
*
* => d1.l = BPtr auf LockStruktur
* => d2.l = APtr auf FIBlockPuffer (long-aligned)
*
* => d0.l = -1 = alles ok, = 0 = Fehler
*--------------------------------------

ex_next

	movem.l d1/a0-a1/a6,-(a7)

	CALLDOS ExNext

	movem.l (a7)+,d1/a0-a1/a6
	rts

*---------------------------------------
* dos_delete_file
*
* => d1.l = Ptr auf File- oder Directorynamen
* Directory muß! leer sein.
*
* => d0.l = -1 = alles ok, = 0 = Fehler
*--------------------------------------

dos_delete_file

	movem.l d1/a0-a1/a6,-(a7)

	CALLDOS DeleteFile

	movem.l (a7)+,d1/a0-a1/a6
	rts

*---------------------------------------
* rename
*
* => d1.l = CPtr auf alten Namen
* => d2.l = CPtr auf neuen Namen
*
* => d0.l = -1 = alles ok, = 0 = Fehler
*--------------------------------------

rename

	movem.l d1/a0-a1/a6,-(a7)

	CALLDOS Rename

	movem.l (a7)+,d1/a0-a1/a6
	rts

*---------------------------------------
* exall_dir
*
* >= d1.l = Zeiger auf den Pfadnamen
*
* => d0.l = Anzahl der ermittelten Einträge = alles ok, = negativ = Fehler
* => d1.l = Zeiger auf Datenablagepuffer, = 0 bei Fehler
*
* Anmerkung:
*
* Da die Funktion ExAll() auch unter V37 fehlerhaft arbeitet,
* ( die RamDisk wird nicht erkannt ) werden zur
* Ermittlung der Directoryeinträge die Funktionen Examine() und ExNext()
* verwendet !
*
* Die Rückgabe der Daten erfolgt in Anlehnung an die Funktion ExAll()
* in der gleichen Weise. Die Struktur ExAllData ist gültig.
* Es werden grundsätzlich immer alle Daten zu einem Directory oder
* File zurückgegeben. PatternMatching ist nicht vorgesehen.
*
* Der Puffer für die Daten wird von exall_dir mit der Funktion AllocVec()
* reserviert. Der Puffer ist genau den Directorydaten angepaßt!
* Der Puffer muß mit der Funktion FreeVec() freigegeben werden!

DirPufferEintrag	equ     156
* 40 Bytes/Struktur + 32 Bytes/Name + 84 Bytes/Kommentar = 156/Datenfeld

DirPufferSize   	equ     156*100 ;falls es nicht reicht wird neuer Puffer allokiert!
*--------------------------------------

exall_dir

	movem.l d2-d7/a0-a6,-(a7)

	move.l  d1,d5   		;Zeiger auf den Dirnamen => d5 merken

	move.l  #DirPufferSize,d3       ;AnfangsGröße => d3
	bsr     alloc_dirpuffer 	;Speicher reservieren
	move.l  d0,a2   		;Zeiger auf Puffer => a2
	move.l  d0,a4   		;und => a4
	tst.l   d0      		;geklappt ?
	beq.s   .fehler1		;nein

.lock
	move.l  d5,d1   		;Zeiger auf den Namen wieder => d1
	moveq.l #-2,d2  		;Modus = SharedLock
	bsr     lock    		;Lock ermitteln
	move.l  d0,d1   		;merken, erfolgreich ?
	bne.s   .fiblock		;ja

	bsr     io_error		;nein, Fehlermeldung ausgeben
	tst.l   d0      		;wie beantwortet ?
	bpl.s   .lock   		;"Retry"  gewählt
	bmi.s   .fehler2		;"Cancel" gewählt

.fiblock
	bsr     alloc_fiblock   	;Speicher für FIBlock reservieren
	tst.l   d2      		;geklappt ?
	beq.s   .fehler3		;nein, Lock und Puffer freigeben

.examine
	moveq.l #0,d4   		;Zählregister initialisieren
	bsr     examine 		;1. Eintrag ermitteln
	tst.l   d0      		;alles ok ?
	bmi.s   .ex_next		;ja

	bsr     io_error		;nein, Fehlermeldung ausgeben
	tst.l   d0      		;wie beantwortet
	bpl.s   .examine		;"Retry"  gewählt
	bmi.s   .fehler4		;"Cancel" gewählt

.ex_next
	bsr     ex_next 		;nächsten Eintrag ermitteln
	tst.l   d0      		;Fehler ?
	bpl.s   .io_error       	;vielleicht

	addq    #1,d4   		;nein, Zählregister aufaddieren
	bsr     daten_eintragen 	;Daten in Puffer eintragen
	tst.l   d0      		;alles ok ?
	bpl.s   .ex_next		;ja
	bmi.s   .fehler4		;nein, Fehler, alles wieder freigeben

.io_error
	bsr     io_error		;IoError besorgen
	cmpi.l  #232,d0 		;Error_No_More_Entries ?
	beq.s   .unlock 		;ja, alles ok

	tst.l   d0      		;nein, Fehler, wie beantwortet ?
	bpl.s   .ex_next		;"Retry"  gewählt
	bmi.s   .fehler4		;"Cancel" gewählt

.unlock
	bsr     free_fiblock    	;FiBlock freigeben
	bsr     unlock  		;Lock wieder freigeben
	bsr     puffer_bearbeiten       ;Puffer den Daten anpassen

	move.l  d4,d0   		;Anzahl der ermittelten Einträge zurückgeben
	move.l  a2,d1   		;Zeiger auf Puffer zurückgeben
	bra.s   .ende   		;und beenden

.fehler4
	bsr     free_fiblock    	;FiBlock freigeben

.fehler3
	bsr     unlock  		;Lock wieder freigeben

.fehler2
	move.l  a2,a1   		;zeige auf Puffer
	bsr     free_vec		;freigeben

.fehler1
	moveq.l #-1,d0  		;melde Fehler
	moveq.l #0,d1   		;Register löschen
.ende
	movem.l (a7)+,d2-d7/a0-a6
	rts

*--------------------------------------
* daten_eintragen
*
* >= d2.l = Zeiger auf FIBlock
* >= d3.l = Größe des Puffers
* >= d4.l = aktuelle Anzahl der ermittelten Directoryeinträge
*
* >= a2.l = Zeiger auf den Anfang des Puffers
* >= a3.l = Zeiger auf den aktuellen freien Eintrag
*
*
* => d0.l = positiv = alles ok, negativ = Fehler
*
* => a2.l = Zeiger auf den Anfang des Puffers
* => a3.l = Zeiger auf den vorherigen Eintrag
* => a4.l = Zeiger auf den nächsten Eintrag
*--------------------------------------

daten_eintragen

	movem.l d1-d2/a0-a1/a5-a6,-(a7)

	move.l  a2,a5   		;zur Berechnung des Pufferendes => a5
	add.l   d3,a5   		;Größe addieren = Ende

	move.l  a4,a6   		;zum Prüfen => a6
	add.l   #DirPufferEintrag,a6    ;max. Größe eines Eintrags addieren
	cmp.l   a6,a5   		;Ende des Puffers erreicht ?
	beq.s   .neuer_puffer   	;ja
	bpl.s   .ok     		;nein

.neuer_puffer
	bsr     neuer_puffer    	;neuen Puffer reservieren
	tst.l   d0      		;alles ok ?
	bmi.s   .ende   		;nein
.ok
	move.l  a4,a3   		;Zeiger auf nächsten Eintrag => a3

	lea     ed_Strings(a3),a0       ;Zeiger auf den Namen => a0
	move.l  a0,ed_Name(a3)  	;eintragen

	move.l  d2,a0   		;Zeiger auf FIBlock => a0

					;die weiteren Daten eintragen

	move.l  fib_EntryType(a0),ed_Type(a3)
	move.l  fib_Size(a0),ed_Size(a3)
	move.l  fib_Protection(a0),ed_Prot(a3)

	lea     fib_DateStamp(a0),a1
	move.l  (a1),ed_Days(a3)
	move.l  ds_Minute(a1),ed_Mins(a3)
	move.l  ds_Tick(a1),ed_Ticks(a3)

	move.l  ed_Name(a3),a4  	;Zeiger auf den Namen eintragen
	lea     fib_FileName(a0),a1     ;zeige auf den Namen

	bsr     .kopieren       	;Name kopieren und Adresse
					;auf Langwort justieren

	tst.b   fib_Comment(a0) 	;Kommentar vorhanden ?
	beq.s   .skip   		;nein

	lea     fib_Comment(a0),a1      ;zeige auf den Kommentar
	move.l  a4,ed_Comment(a3)       ;als Zeiger auf den Kommentar eintragen

	bsr     .kopieren       	;Name kopieren und Adresse
					;auf Langwort justieren
.skip
	move.l  a4,(a3) 		;als Anfang der nächsten
					;Struktur eintragen
	moveq.l #0,d0   		;melde "alles ok"
.ende
	movem.l (a7)+,d1-d2/a0-a1/a5-a6
	rts

*------------------

.kopieren
	move.b  (a1)+,(a4)+     	;kopiere den Namen
	bne.s   .kopieren

	move.l  a4,d0   		;zum Langwortjustieren => d0
	lsr.l   #2,d0   		;dividiere durch 4
	lsl.l   #2,d0   		;wieder mal 4
	cmp.l   d0,a4   		;identisch ?
	beq.s   .copy_ende      	;ja

	addq    #4,d0   		;4 Bytes addieren
	move.l  d0,a4   		;zur weiteren Bearbeitung => a4

.copy_ende
	rts

*--------------------------------------
* >= a2.l = Zeiger auf den alten Puffer
* >= d3.l = Größe des alten Puffers
*
* => d0.l = Zeiger auf den neuen Puffer, = 0 = Fehler
* => d3.l = Größe des neuen Puffers
*
* => a2.l = Zeiger auf den neuen Puffer
* => a3.l = Zeiger auf den vorherigen Eintrag
* => a4.l = Zeiger auf den nächsten Eintrag
*
* Anmerkung:
* d3/a2-a5 enthalten die alten Werte bei Fehler !
*--------------------------------------

neuer_puffer

	movem.l d1-d2/a0-a1,-(a7)

	move.l  a2,a0   		;alten Anfang => a0 merken

	move.l  d3,d0   		;alte Größe => d0
	add.l   d0,d0   		;die doppelte Größe reservieren
	bsr     neu_reservieren_kopieren;DatenPuffer neu reservieren
					;und die Daten in den neuen Puffer
					;kopieren
	tst.l   d0      		;alles ok ?
	bne.s   .anpassen       	;ja

	moveq.l #-1,d0  		;nein, melde "Fehler"
	bra.s   .ende   		;und beenden

.anpassen
	bsr     zeiger_anpassen 	;die Zeiger an die neuen Adressen anpassen

.ende
	movem.l (a7)+,d1-d2/a0-a1
	rts

*--------------------------------------
* neu_reservieren_kopieren
*
* >= a2.l = Zeiger auf den alten Puffer
* >= d3.l = Größe des alten Puffers
* >= d0.l = Größe des neuen Puffers
*
* => d0.l = <> 0 = alles ok, = 0 = Fehler
* => a2.l = Zeiger auf den neuen Puffer, = alter Puffer bei Fehler !
* => d3.l = Größe des neuen Puffers
*--------------------------------------

neu_reservieren_kopieren

	movem.l d1-d2/a0-a1/a3,-(a7)

	move.l  d3,d2   		;alte Größe => d2 merken
	move.l  d0,d3   		;neue Größe => d3 übergeben
	bsr     alloc_dirpuffer 	;reservieren
	tst.l   d0      		;geklappt ?
	beq.s   .ende   		;nein

	move.l  d0,a1   		;neuen Anfang => a1
	move.l  d0,a3   		;=> a3 merken
	move.l  a2,a0   		;alten Anfang => a0
	move.l  d2,d0   		;alte Größe   => d0
	bsr     copy_mem_quick  	;kopieren

	move.l  a2,a1   		;alten Zeiger => a1
	bsr     free_vec		;freigeben

	move.l  a3,a2   		;neuen Zeiger => a2 zurückgeben
.ende
	movem.l (a7)+,d1-d2/a0-a1/a3
	rts

*--------------------------------------
* puffer_bearbeiten
*
* >= d4.l = Anzahl der ermittelten Einträge
*
* >= a2.l = Zeiger auf den Anfang des Puffers
* >= a3.l = Zeiger auf den vorherigen Eintrag
* >= a4.l = Zeiger auf den nächsten Eintrag ( = Ende des Puffers )
*
* => a2.l = Zeiger auf den Anfang des neuen Puffers
*--------------------------------------

puffer_bearbeiten

	tst.l   d4      		;Einträge ermittelt ?
	beq.s   .abbruch		;nein

	movem.l d0-d1,-(a7)

	move.l  a2,a0   		;alten Anfang => a0 merken

	move.l  a4,d0   		;Ende des Puffers => d0
	sub.l   a2,d0   		;den Anfang subtrahieren
					;= benötigte Größe
	move.l  d0,d1   		;zum Rechnen => d1
	move.l  d0,d3   		;zum Kopieren => d3
	divu    d4,d1   		;durch die Anzahl dividieren
	add.w   d1,d0   		;1 Eintrag mehr reservieren

	bsr     neu_reservieren_kopieren ;Puffer anpassen und kopieren
	tst.l   d0      		;geklappt ?
	beq.s   .zeiger_loeschen	;nein, mit dem alten Puffer weitermachen

	bsr     zeiger_anpassen 	;die Zeiger den neuen Adressen anpassen

.zeiger_loeschen
	clr.l   (a3)    		;Zeiger auf das Ende löschen

	movem.l (a7)+,d0-d1
.abbruch
	rts

*--------------------------------------

zeiger_anpassen

	move.l  a2,a4   		;zum Bearbeiten => a4
	move.l  a2,d0   		;und => d0
	sub.l   a0,d0   		;die Adresse des alten Puffers
					;von der neuen Adresse subtrahieren
.loop
	add.l   d0,(a4) 		;den Zeiger auf den nächsten Eintrag
					;korrigieren
	add.l   d0,ed_Name(a4)  	;Zeiger auf den Namen korrigieren

	tst.l   ed_Comment(a4)  	;Zeiger auf Kommentar vorhanden ?
	beq.s   .next   		;nein

	add.l   d0,ed_Comment(a4)       ;Zeiger auf den Kommentat korrigieren
.next
	move.l  a4,a3   		;als vorherigen Eintrag merken
	move.l  (a4),a4 		;zeige auf den nächsten Eintrag
	tst.l   (a4)    		;letzten erreicht ?
	bne.s   .loop   		;nein

	rts

*--------------------------------------
* alloc_dirpuffer
*
* >= d3.l = Größe des zu reservierenden Speichers
*
* => d0.l = Zeiger auf reservierten Speicher = alles ok, = 0 = Fehler
*--------------------------------------

alloc_dirpuffer

	move.l  d1,-(a7)

	move.l  d3,d0   		;Größe => d0
	move.l  #MEMF_ANY!MEMF_CLEAR!MEMF_LARGEST,d1
	bsr     alloc_vec       	;reservieren

	move.l  (a7)+,d1
	rts

*--------------------------------------
* alloc_fiblock
*
* kein Übergaberegister
*
* => d2.l = APtr auf FIBlock, = 0 = Fehler
*--------------------------------------

alloc_fiblock

	movem.l d0-d1/a0-a1/a6,-(a7)

	moveq.l #0,d0   		;keine TagItems
	moveq.l #DOS_FIB,d1     	;FIBlockID => d1
	CALLDOS AllocDosObject  	;anlegen
	move.l  d0,d2   		;in d2 zurückgeben

	movem.l (a7)+,d0-d1/a0-a1/a6
	rts

*--------------------------------------
* free_fiblock
*
* >= d2.l = APtr auf FIBlock
*
* kein Rückgaberegister
*
* Function prüft auf vorhandenen Zeiger
*--------------------------------------

free_fiblock

	tst.l   d2      		;Zeiger vorhanden
	beq.s   .abbruch		;nein

	movem.l d0-d1/a0-a1/a6,-(a7)

	moveq.l #DOS_FIB,d1     	;FIBlockID => d1
	CALLDOS FreeDosObject   	;freigeben

	movem.l (a7)+,d0-d1/a0-a1/a6

.abbruch
	rts

*--------------------------------------
* get_dirname
*
* >= d1.l = BCPLPtr auf LockStruktur
* >= a1.l = Zeiger auf Ablagepuffer des Namens
*
* => d0.l = Zeiger auf Dirname, negativ dann Fehler
*--------------------------------------

get_dirname

	movem.l d1-d3/a0-a2/a6,-(a7)

	move.l  a1,a2   		;Zeiger merken

	bsr     alloc_fiblock   	;Speicher besorgen
	tst.l   d2      		;geklappt?
	beq.s   .fehler 		;nein

	move.l  #fib_SIZEOF,d3  	;Größe => d3, d1 und d2 sind schon initialisiert
	CALLDOS NameFromLock
	tst.l   d0      		;alles ok?
	beq.s   .fehler 		;nein

	move.l  d2,a0   		;zeige auf Zwischenpuffer
	move.l  a2,a1   		;zeige auf Ablagepuffer
	bsr     string_kopieren 	;dort eintragen
	moveq.l #0,d0   		;melde alles ok
	bra.s   .ende   		;und beenden
.fehler
	moveq.l #-1,d0  		;melde "Fehler"
.ende
	bsr     free_fiblock    	;FIBlock wieder freigeben
					;Funktion prüft auf vorhandenen Zeiger!!
	movem.l (a7)+,d1-d3/a0-a2/a6
	rts

*--------------------------------------
* dos_system_taglist
*
* >= d1.l = Zeiger auf Komandostring
* >= d2.l = Zeiger auf TagItemListe
*
* => d0.l = 0 = alles ok, <> 0 = Fehler
*--------------------------------------

dos_system_taglist

	movem.l d1/a0-a1/a6,-(a7)

	CALLDOS SystemTagList

	movem.l (a7)+,d1/a0-a1/a6
	rts

*--------------------------------------
