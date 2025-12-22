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
* Funktionen der mrt.library
*--------------------------------------
* create_msg_port
*
* >= d0.l = Priorit‰t
* >= a0.l = Zeiger auf Namen des Ports,
*           oder 0, wenn kein globaler Port gew¸nscht wird
*
* => d0.l = Zeiger auf Port, oder 0, wenn nicht geklappt
*--------------------------------------

create_msg_port

        movem.l d1-d3/a0-a1/a6,-(a7)

        CALLMRT CreatePort              ;Port anlegen
        tst.l   d0                      ;angelegt ?
        bne.s   .ende                   ;ja

        move.l  #IDtext_no_port,d3      ;nein, Meldung ausgeben
        bsr     alert_requester
.ende
        movem.l (a7)+,d1-d3/a0-a1/a6
        rts

*-------------------------------------
* delete_msg_port
*
* >= a0.l = Zeiger auf MsgPort
*
* kein R¸ckgaberegister
*
* Anmerkung:
* Funktion pr¸ft auf vorhandenen Zeiger
*--------------------------------------

delete_msg_port

        cmp.l   #0,a0
        beq.s   .abbruch

        movem.l d0-d1/a0-a1/a6,-(a7)

        CALLMRT DeletePort

        movem.l (a7)+,d0-d1/a0-a1/a6
.abbruch
        rts

*-------------------------------------
* hex_to_dez_ascii

* Funktion zum Wandeln einer Hex-Zahl in dezimalen ASCIICode

* => a0.l = Zeiger auf den String, oder den Puffer,
*           in den die dezimale ASCII-Zahl eingetragen werden soll.

* => d0.l = Hex-Zahl, die gewandelt werden soll.

* => d1.w = Offset auf die Stelle im String, oder Puffer,
*           wo die ASCII-Zahl eingetragen werden soll.

* => d2.l = OptionsFlag

*         = 0 = f¸hrende Nullen nicht unterdr¸cken

*         = 1 = f¸hrende Nullen unterdr¸cken aber "Space" daf¸r ausgeben

*         = 2 = f¸hrende Nullen unterdr¸cken, nichts daf¸r eintragen,
*               Offset erst dann erhˆhen, wenn keine f¸hrenden Nullen
*               mehr vorhanden sind.
*               (Diese Option gibt nur so viele Stellen aus,
*               wie die Dezimalzahl Stellen hat.)

*         = 3 = f¸hrende Nullen unterdr¸cken, nichts eintragen,
*               Offset aber von Anfang an erhˆhen.
*               (Diese Option tr‰gt die Dezimalzahl so ein,
*               als ob f¸hrende Nullen auszugeben w‰ren)

*         = 4 = f¸hrende Nullen teilweise unterdr¸cken,
*               die Anzahl der auszugebenden Stellen ber¸cksichtigen,
*               die im oberen Wort des Langwortes angegeben sind.
*               z.B.: d2 = 0003 0004 => z.B. 008, oder 015

*         = 5 = wie Option 4,
*               aber das ASCII-Zeichen daf¸r eintragen,
*               das im obersten Byte angegeben ist.
*               z.B.: d2 = 2A03 0005 => z.B. **8, oder *15

* Anmerkung zu Option 4 und 5:
* Ist die Zahl grˆﬂer als an Stellen angegeben wurde, wird die
* Zahl komplett ausgegeben, aber ohne f¸hrende Nullen oder Zeichen.

* kein R¸ckgaberegister
*--------------------------------------

hex_to_dez_ascii

        movem.l d1-d2/a0/a6,-(a7)

        CALLMRT HexToDezASCII           ;wandeln und eintragen

        movem.l (a7)+,d1-d2/a0/a6
        rts

*--------------------------------------
* ascii_dez_hex
*
* Diese Funktion wandelt eine dezimale ASCII-Zahl in
* einen realen Hex-Wert um. ( grˆﬂter erlaubter Wert ist 255 ! )
*
* >= d0.l = ASCII-Zahl (z.B. 00313537 = 157)
*
* => d0.l = Hex-Zahl = alles ok, -1 = grˆﬂer 255
*--------------------------------------

ascii_dez_hex

        move.l  a6,-(a7)

        CALLMRT DezASCIIToHex

        move.l  (a7)+,a6
        rts

*--------------------------------------
* install_menu_complete
*
* >= a0.l = WindowPtr
* >= a1.l = NewMenuPtr
* >= a2.l = VisualInfoPtr
* >= a3.l = TextAttrPtr
*
* >= d0.l = FrontPen
*
* => d0.l = Men¸Ptr, = 0 = Fehler
*--------------------------------------

install_menu_complete

        move.l  a6,-(a7)

        CALLMRT InstallMenuComplete

        move.l  (a7)+,a6
        rts

*--------------------------------------
* IDCMP Event Funktionen
*--------------------------------------
* gt_win_event
*
* >= d1.l = Flag (0 = ohne Wait/ 1 = mit Wait)
*
* zur¸ckgegeben wird:
*
* => d0.l = im_Class
* => d1.l = im_Code
* => d2.l = im_Qualifier
* => d3.l = im_IAddress
* => d4.l = im_MouseX
* => d5.l = im_MouseY
*--------------------------------------

gt_win_event

        move.l  a6,-(a7)

        CALLMRT GTWinEvent

        move.l  (a7)+,a6
        rts

*--------------------------------------
* close_window_safely
*
* >= a0.l = WindowPtr
*
* kein R¸ckgaberegister
*
* Anmerkung:
* Funktion pr¸ft auf vorhandenen Zeiger
*--------------------------------------

close_window_safely

        cmpa.l  #0,a0                   ;Zeiger vorhanden
        beq.s   .abbruch                ;nein

        movem.l d0-d1/a0-a4/a6,-(a7)

        move.l  a0,a2                   ;WindowPtr in a2 merken
        tst.l   wd_UserPort(a0)         ;Zeiger auf MsgPort in WindowStruktur
                                        ;vorhanden ?
        beq.s   .close                  ;nein, Window schlieﬂen !

        bsr     forbid                  ;keine Stˆrungen jetzt
        move.l  wd_UserPort(a0),a0      ;Zeiger auf Port => a0
.loop
        bsr     gt_get_i_msg            ;hole Msg
        tst.l   d0                      ;liegt eine vor ?
        beq.s   .deaktivieren           ;nein

        move.l  d0,a1                   ;Zeiger auf Msg ¸bergeben
        bsr     remove                  ;entfernen
        bsr     gt_reply_i_msg          ;quittieren
        bra.s   .loop                   ;noch eine ?

* Window-Port deaktivieren
*-------------------------
.deaktivieren
        moveq.l #0,d0                   ;Flags => d0 = 0 = kein Ereignis
        move.l  a2,a0                   ;WindowPtr => a0
        move.l  d0,a1                   ;0 eintragen => MsgPort entfernen
        bsr     modify_idcmp            ;Port abmelden

        bsr     permit                  ;alles erledigt, Multitasking
                                        ;wieder erlauben
.close
        bsr     close_window            ;Fenster schlieﬂen

        movem.l (a7)+,d0-d1/a0-a4/a6
.abbruch
        rts

*--------------------------------------
* quick_sort ©
*
* >= a0.l = Anfangsadresse des zu sortierenden Arrays
*
* >= d0.l = Anzahl der zu sortierenden Eintr‰ge im Array
* >= d1.l = L‰nge eines Dateneintrages im Array
* >= d2.l = Flag =  0 = Groﬂ/Kleinschreibung nicht beachten;
*                <> 0 = beachten
*
* >= d3.l = Offset auf das Datenfeld  nach dem sortiert werden soll
* >= d4.l = L‰nge des Datenfeldes nach dem sortiert werden soll
* >= d5.l = Flag =  0 = aufsteigend sortieren (1,2,3);
*                <> 0 = absteigend  sortieren (3,2,1)
*
* Anmerkung:
* Sind d3 und d4 = 0 wird die L‰nge in d1 als zu pr¸fende L‰nge gew‰hlt.
* d3 und d4 m¸ssen = 0 sein, wenn nicht erforderlich !
*
* kein R¸ckgaberegister
*--------------------------------------

quick_sort

        move.l  a6,-(a7)

        CALLMRT QuickSort

        move.l  (a7)+,a6
        rts

*--------------------------------------
* string_compare ©
*
* >= a0.l = Zeiger auf 1. String (muﬂ mit NullByte abgeschlossen sein !)
* >= a1.l = Zeiger auf 2. String (dto.)
*
* >= d1.l =  0 = Groﬂ/Kleinschreibung nicht beachten; <> 0 = beachten
*
* => d0.l =  0 = beide gleich
* => d0.l =  1 = 1. String ist "grˆﬂer"
* => d0.l = -1 = 1. String ist "kleiner"
*
* Anmerkung:
* Die Strings brauchen nicht die gleiche L‰nge zu besitzen.
* Die L‰nge ist mit 32767 Bytes/String begrenzt.
*--------------------------------------

string_compare

        move.l  a6,-(a7)

        CALLMRT StringCompare

        move.l  (a7)+,a6
        rts

*--------------------------------------
* string_n_compare
*
* >= a0.l = Zeiger auf 1. String oder Datenfeld
* >= a1.l = Zeiger auf 2. String oder Datenfeld
*
* >= d0.l = Anzahl der Bytes die verglichen werden sollen
* >= d1.l =  0 = Groﬂ/Kleinschreibung nicht beachten; <> 0 = beachten
*
* => d0.l =  0 = beide gleich
* => d0.l =  1 = 1. String ist "grˆﬂer"
* => d0.l = -1 = 1. String ist "kleiner"
*
* Anmerkung:
* Die Strings brauchen nicht mit einem NullByte abgeschlossen zu sein!
* Diese Funktion eignet sich auch zum Vergleich zweier Speicherbereiche!
*--------------------------------------

string_n_compare

        move.l  a6,-(a7)

        CALLMRT StringNCompare

        move.l  (a7)+,a6
        rts

*--------------------------------------
* build_requester
*
* Gibt einen Requester mittels der SystemFunktion BuildSysRequest aus.
* Es kˆnnen maximal 4 Textzeilen ausgegeben werden.
*
* >= a0.l = WindowPtr auf Fenster, in dem Requester erschienen soll
*           = 0 = default PublicScreen
*
* >= a1.l = Zeiger auf TextAttributStruktur
*           muﬂ 0 sein, wenn nicht erforderlich.
*
* >= d0.l = IDCMPFlags
*
* >= d1.l = Zeiger auf Text f¸r linkes Gadget  = positive Antwort,
*           muﬂ 0 sein, wenn nicht gew¸nscht.
*
* >= d2.l = Zeiger auf Text f¸r rechtes Gadget = negative Antwort,
*           muﬂ angegeben sein !!
*
* >= d3.l = Zeiger auf Text der 1. Textzeile,
*           muﬂ angegeben sein !!
*
* >= d4.l = Zeiger auf Text der 2. Textzeile,
*           muﬂ 0 sein, wenn nicht gew¸nscht.
*
* >= d5.l = Zeiger auf Text der 3. Textzeile,
*           muﬂ 0 sein, wenn nicht gew¸nscht.
*
* >= d6.l = Zeiger auf Text der 4. Textzeile,
*           muﬂ 0 sein, wenn nicht gew¸nscht.
*
* >= d7.l = Zeiger auf RequesterWindowTitel,
*           muﬂ 0 sein, wenn nicht gew¸nscht !
*
* => d0.l = 0 = Cancel, 1 = Retry, -1 = Fehler
*--------------------------------------

build_requester

        movem.l a0-a1/a6,-(a7)

        Locale  d1,d1
        Locale  d2,d2
        Locale  d3,d3
        Locale  d4,d4
        Locale  d5,d5
        Locale  d6,d6
        Locale  d7,d7
        CALLMRT BuildRequester

        movem.l (a7)+,a0-a1/a6
        rts

*-------------------------------------
