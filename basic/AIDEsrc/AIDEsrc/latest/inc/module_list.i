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
* available_module_array
*
* Liest die vorhandenen Module aus dem angegebenen
* Directory aus und setzt diese in einem Array zusammen.
*
* >= d1.l = Zeiger auf Directorynamen
*
* => d0.l = 0 = Fehler, <> 0 = alles ok
*--------------------------------------

available_module_array

	movem.l d1,-(a7)

	tst.l   d1      		;Zeiger angegeben?
	beq.s   .fehler 		;nein

	move.w  #1,pruef_Flag   	;Flag setzen

	bsr     exall_dir       	;alle Einträge besorgen
	tst.l   d0      		;alles ok?
	beq.s   .ende   		;nein, keine Files vorhanden
	bpl.s   .array  		;ja

	bsr     module_dir_error	;Meldung ausgeben
	moveq.l #1,d0   		;melde weitermachen
	bra.s   .ende   		;und beenden
.fehler
	bsr     no_module_dir   	;Meldung ausgeben
.array
	bsr.s   module_array_anlegen    ;in einen kleineren Array kopieren
.ende
	clr.w   pruef_Flag      	;Flag wieder löschen

	movem.l (a7)+,d1
	rts

*--------------------------------------
* module_array_anlegen
*
* >= d0.l = Anzahl der Arrayeinträge
* >= d1.l = Zeiger auf ExAllArray
*
* => d0.l = 0 = Fehler, <> 0 = alles ok
*--------------------------------------

module_array_anlegen

	movem.l d1-d7/a0-a3,-(a7)

	move.l  d1,a2   		;ExAllArray zum Bearbeiten => a2
	move.l  d1,d6   		;in d6 zum Freigeben merken

	move.l  d0,d7   		;Anzahl der ermittelten Einträge merken

	move.l  _AvailableModule,a1     ;zeige auf alten Array
	bsr     free_vec		;freigeben
	mulu    #32,d0  		;zum Speicher reservieren mit
					;der FileNamenLänge von 32
					;multiplizieren

	move.l  #MEMF_ANY!MEMF_CLEAR!MEMF_LARGEST,d1
	bsr     alloc_vec       	;reservieren
	move.l  d0,_AvailableModule     ;merken, geklappt?
	beq.s   .ende   		;nein

	move.l  d0,a3   		;zum Bearbeiten => a3
	subq    #1,d7   		;-1, da dbra bis -1 zählt
	moveq   #0,d2   		;Zählregister initialisieren
.loop
	tst.l   ed_Type(a2)     	;File oder Dir?
	bpl.s   .next_entry     	;Directory

	addq    #1,d2   		;Zählregister aufaddieren
	move.l  ed_Name(a2),a0  	;Zeiger auf den Namen eintragen
	move.l  a3,a1   		;zum Kopieren => a1

.kopieren
	move.b  (a0)+,(a1)+     	;kopiere den Namen
	bne.s   .kopieren

	lea     FileSize(a3),a3 	;Ptr auf nächstes Feld eintragen

.next_entry
	move.l  (a2),a2 		;Ptr auf nächste ExAllDataStruktur eintragen
	dbra    d7,.loop

	move.l  d2,ModuleAnzahl 	;als tatsächliche Anzahl merken

	move.l  _AvailableModule,a0     ;Adresse auf Array => a0
	move.l  d2,d0   		;Anzahl eintragen
	moveq.l #FileSize,d1    	;Länge eintragen
	moveq.l #0,d2   		;Groß/Kleinschreibung nicht beachten
	moveq.l #0,d3   		;keine weiteren Flags
	moveq.l #0,d4
	moveq.l #0,d5   		;aufsteigend sortieren (1,2,3)
	bsr     quick_sort      	;und sortieren
.ende
	move.l  d6,a1   		;Zeiger auf ExAllArray => a1
	bsr     free_vec		;Speicher wieder freigeben

	movem.l (a7)+,d1-d7/a0-a3
	rts

*--------------------------------------
