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
* Funktionen der exec.library
*--------------------------------------
* open_library
*
* OpenLibrary() Aufruf ab V36
*
* >= d0.l = Zeiger auf Requester Text bei Open-Fehler
* >= a1.l = Zeiger auf LibraryName
*
* => d0 = Zeiger auf LibraryBase, oder 0 bei Fehler
*
* Anmerkung:
* Funktion prüft auf vorhandenen Zeiger
*--------------------------------------

open_library

	cmp.l   #0,a1   		;Zeiger vorhanden?
	beq.s   .abbruch		;nein

	movem.l d1/d3/a0-a1/a6,-(a7)

	move.l  d0,d3   		;Zeiger auf Text ins Übergaberegister

	moveq.l #36,d0  		;VersionsNr. => d0 mindestens V36 erforderlich
	CALLEXEC OpenLibrary    	;öffnen
	tst.l   d0      		;alles ok ?
	bne.s   .ende   		;ja

	tst.l   d3      		;Zeiger angegeben?
	beq.s   .ende   		;nein

	bsr     alert_requester 	;nein Meldung ausgeben
.ende
	movem.l (a7)+,d1/d3/a0-a1/a6
.abbruch
	rts

*--------------------------------------
* close_library
*
* >= a1.l = Zeiger auf LibraryBase
*
* kein Rückgaberegister
*
* Anmerkung:
* Funktion prüft auf vorhandenen Zeiger
*--------------------------------------

close_library

	cmp.l   #0,a1
	beq.s   .abbruch

	movem.l d0-d1/a0-a1/a6,-(a7)

	CALLEXEC CloseLibrary

	movem.l (a7)+,d0-d1/a0-a1/a6
.abbruch
	rts

*-------------------------------------
* alloc_signal
*
* kein Übergaberegister
*
* => d0.l = Signal, oder -1 bei Fehler
*--------------------------------------

alloc_signal

	movem.l d1/a0-a1/a6,-(a7)

	moveq.l #-1,d0  		;beliebiges Signal
	CALLEXEC AllocSignal

	movem.l (a7)+,d1/a0-a1/a6
	rts

*-------------------------------------
* free_signal
*
* >= d0.l = Signal
*
* kein Rückgaberegister
*--------------------------------------

free_signal

	movem.l d0-d1/a0-a1/a6,-(a7)

	CALLEXEC FreeSignal

	movem.l (a7)+,d0-d1/a0-a1/a6
	rts

*-------------------------------------
* remove
*
* >= a1 = Zeiger auf NodeStruktur
*
* kein Rückgaberegister
*
* Anmerkung:
* Funktion prüft auf vorhandenen Zeiger
*--------------------------------------

remove
	cmp.l   #0,a1
	beq.s   .abbruch

	movem.l d0-d1/a0-a1/a6,-(a7)

	CALLEXEC Remove

	movem.l (a7)+,d0-d1/a0-a1/a6
.abbruch
	rts

*--------------------------------------
* forbid
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

forbid
	movem.l d0-d1/a0-a1/a6,-(a7)

	CALLEXEC Forbid

	movem.l (a7)+,d0-d1/a0-a1/a6
	rts

*--------------------------------------
* permit
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

permit
	movem.l d0-d1/a0-a1/a6,-(a7)

	CALLEXEC Permit

	movem.l (a7)+,d0-d1/a0-a1/a6
	rts

*--------------------------------------
* alloc_vec ©
*
* >= d0.l = Größe, oder 0, wenn nur nach der Größe des noch freien
*           Speichers, gemäß der Klassifikation in d1, gefragt wird.
*
* >= d1.l = Art des benötigten Speichers
*
* => d0.l = Zeiger auf reservierten Speicher, oder Größe, wenn nur nachgefragt wurde!
*         = 0 = nicht geklappt, bzw. nicht genug frei.
*--------------------------------------

alloc_vec

	movem.l d1-d3/a0-a1/a6,-(a7)

	move.l  d0,d2   		;Größe in d2 merken

	CALLEXEC AvailMem       	;wieviel Speicher ist noch frei ?
	tst.l   d2      		;nur den noch freien Speicher zurückgeben?
	beq.s   .ende   		;ja, nichts zu reservieren

	cmp.l   d2,d0   		;ist das genug ?
	bpl.s   .reservieren    	;ja

	moveq.l #0,d0   		;nein, melde "not enough memory"
	bra.s   .ende   		;und beenden

.reservieren
	move.l  d2,d0   		;Größe => d0
	move.l  (a7),d1 		;Anforderungen => d1
	CALLEXEC AllocVec       	;reservieren
.ende
	movem.l (a7)+,d1-d3/a0-a1/a6
	rts

*--------------------------------------
* free_vec
*
* >= a1.l = Zeiger auf Speicher [ reserviert durch AllocVec() ]
*
* kein Rückgaberegister
*
* Anmerkung:
* Funktion prüft auf vorhandenen Zeiger
*--------------------------------------

free_vec

	cmp.l   #0,a1
	beq.s   .abbruch

	movem.l d0-d1/a0-a1/a6,-(a7)

	CALLEXEC FreeVec		;freigeben

	movem.l (a7)+,d0-d1/a0-a1/a6

.abbruch
	rts

*-------------------------------------
* copy_mem_quick
*
* >= d0.l = Größe in Bytes (longword aligned !)
* >= a0.l = SourcePtr      (longword aligned !)
* >= a1.l = DestPtr        (longword aligned !)
*
* kein Rückgaberegister
*--------------------------------------

copy_mem_quick

	movem.l d0-d1/a0-a1/a6,-(a7)

	CALLEXEC CopyMemQuick

	movem.l (a7)+,d0-d1/a0-a1/a6
	rts

*--------------------------------------
* copy_mem
*
* >= d0.l = Größe in Bytes
* >= a0.l = SourcePtr
* >= a1.l = DestPtr
*
* kein Rückgaberegister
*--------------------------------------

copy_mem

	movem.l d0-d1/a0-a1/a6,-(a7)

	CALLEXEC CopyMem

	movem.l (a7)+,d0-d1/a0-a1/a6
	rts

*--------------------------------------
* wait
*
* >= d0.l = SignalBits auf die gewartet werden soll
*
* => d0.l =  SignalBits auf die reagiert wurde
*--------------------------------------

wait
	movem.l d1/a0-a1/a6,-(a7)

	CALLEXEC Wait

	movem.l (a7)+,d1/a0-a1/a6
	rts

*--------------------------------------
