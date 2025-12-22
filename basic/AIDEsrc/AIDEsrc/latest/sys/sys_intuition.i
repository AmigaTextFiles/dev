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
* Funktionen der intuition.library
*--------------------------------------
* open_screen_tag_list
*
* => a1.l = Zeiger auf TagItemListe
*
* => d0.l = 0 bei Fehler, _ScreenPtr = alles ok
*--------------------------------------

open_screen_tag_list

        movem.l d1/a0-a1/a6,-(a7)

        sub.l   a0,a0                   ;keine NewScreenStruktur!!
        CALLINT OpenScreenTagList       ;öffne Screen

        movem.l (a7)+,d1/a0-a1/a6
        rts

*-------------------------------------
* close_screen
*
* >= a0.l = _ScreenPtr
*
* => d0.l = True falls geschlossen, sonst False
*
* Anmerkung:
* Diese Funktion bewirkt nichts, wenn der Pointer NULL ist.
*--------------------------------------

close_screen

        cmp.l   #0,a0
        beq.s   .abbruch

        movem.l d1/a0-a1/a6,-(a7)

        CALLINT CloseScreen

        movem.l (a7)+,d1/a0-a1/a6
.abbruch
        rts

*-------------------------------------
* get_screen_data
*
* >= a0.l = PufferPtr zur Ablage der ScreenStruktur
* >= a1.l = Zeiger auf CustomScreen oder NULL
* >= d0.l = Größe der Screenstruktur
* >= d1.l = Type (WBENCHSCREEN oder CUSTOMSCREEN)
*
* => d0.l = NULL dann nicht geklappt, sonst <> NULL
*--------------------------------------

get_screen_data

        movem.l d1/a0-a1/a6,-(a7)

        CALLINT GetScreenData

        movem.l (a7)+,d1/a0-a1/a6
        rts

*-------------------------------------
* screen_to_front
*
* >= a0.l = ScreenPtr
*
* kein Rückgaberegister
*--------------------------------------

screen_to_front

        movem.l d0-d1/a0-a1/a6,-(a7)

        CALLINT ScreenToFront           ;nach vorne bringen

        movem.l (a7)+,d0-d1/a0-a1/a6
        rts

*-------------------------------------
* screen_to_back
*
* >= a0.l = ScreenPtr
*
* kein Rückgaberegister
*--------------------------------------

screen_to_back

        movem.l d0-d1/a0-a1/a6,-(a7)

        CALLINT ScreenToBack            ;nach hinten bringen

        movem.l (a7)+,d0-d1/a0-a1/a6
        rts

*-------------------------------------
* display_beep
*
* >= a0.l = ScreenPtr
*
* kein Rückgaberegister
*--------------------------------------

display_beep

        movem.l d0-d1/a0-a1/a6,-(a7)

        CALLINT DisplayBeep

        movem.l (a7)+,d0-d1/a0-a1/a6
        rts

*-------------------------------------
* lock_pub_screen
*
* >= a0.l = Zeiger auf den Namen des Screens
*
* => d0.l = 0 bei Fehler, ScreenPtr = alles ok
*
* Anmerkung:
* Diese Funktion bewirkt nichts, wenn einer der Pointer NULL ist.
*--------------------------------------

lock_pub_screen

        cmp.l   #0,a0
        beq.s   .abbruch

        movem.l d1/a0-a1/a6,-(a7)

        CALLINT LockPubScreen

        movem.l (a7)+,d1/a0-a1/a6
.abbruch
        rts

*-------------------------------------
* unlock_pub_screen
*
* >= a1.l = _ScreenPtr (durch LockPubScreen ermittelt)
*
* kein Rückgaberegister
*
* Anmerkung:
* Diese Funktion bewirkt nichts, wenn der ScreenPointer NULL ist.
*--------------------------------------

unlock_pub_screen

        cmp.l   #0,a1
        beq.s   .abbruch

        movem.l d0-d1/a0-a1/a6,-(a7)

        sub.l   a0,a0                   ;keinen Namen
        CALLINT UnlockPubScreen

        movem.l (a7)+,d0-d1/a0-a1/a6
.abbruch
        rts

*-------------------------------------
* open_window
*
* >= a0.l = Zeiger auf NewWindowStruktur
*
* => d0.l = 0 = Fehler, _WindowPtr = alles ok
*--------------------------------------

open_window

        movem.l d1/a0-a1/a6,-(a7)

        CALLINT OpenWindow              ;öffne Window

        movem.l (a7)+,d1/a0-a1/a6
        rts

*--------------------------------------
* activate_window
*
* >= a0.l = Zeiger auf NewWindowStruktur
*
* kein Rückgaberegister
*--------------------------------------

activate_window

        movem.l d0-d1/a0-a1/a6,-(a7)

        CALLINT ActivateWindow

        movem.l (a7)+,d0-d1/a0-a1/a6
        rts

*--------------------------------------
* close_window
*
* >= a0.l = Zeiger auf NewWindowStruktur
*
* kein Rückgaberegister
*--------------------------------------

close_window

        movem.l d0-d1/a0-a1/a6,-(a7)

        CALLINT CloseWindow             ;Window schließen

        movem.l (a7)+,d0-d1/a0-a1/a6
        rts

*--------------------------------------
* set_menu_strip
*
* >= a0.l = WindowPtr
* >= a1.l = Zeiger auf Menuestruktur
*
* kein Rückgaberegister
*--------------------------------------

set_menu_strip

        movem.l d0-d1/a0-a1/a6,-(a7)

        CALLINT SetMenuStrip            ;Menue installieren

        movem.l (a7)+,d0-d1/a0-a1/a6
        rts

*-------------------------------------
* clear_menu_strip
*
* >= a0.l = WindowPtr
*
* kein Rückgaberegister
*--------------------------------------

clear_menu_strip

        movem.l d0-d1/a0-a1/a6,-(a7)

        CALLINT ClearMenuStrip          ;Menue entfernen

        movem.l (a7)+,d0-d1/a0-a1/a6
        rts

*-------------------------------------
* print_i_text
*
* >= a0.l = Zeiger auf RastPort
* >= a1.l = Zeiger auf IntuiTextStruktur
*
* kein Rückgaberegister
*--------------------------------------

print_locale

        movem.l a0/d0,-(a7)
        move.l  12(a1),d0
        jsr     GetString
        move.l  a0,12(a1)
        movem.l (a7)+,a0/d0

print_i_text

        movem.l d0-d1/a0-a1/a6,-(a7)

        tst.l   d0
        beq.s   .leftalign

        movem.l a0-a1,-(a7)             ;rette Register
        move.l  a1,a0                   ;IntuiStruct nach a0
        CALLINT IntuiTextLength         ;Länge in Pixel ermitteln
        divu.w  #2,d0                   ;hälfte
        andi.l  #$00FF,d0               ;Restwert löschen
        neg.l   d0                      ;negieren
        movem.l (a7)+,a0-a1             ;Register wiederherstellen
        bra.s   .go_on

.leftalign
        moveq.l #0,d0

.go_on
        moveq.l #0,d1                   ;y-Pos = 0
        CALLINT PrintIText              ;Text ausgeben

        movem.l (a7)+,d0-d1/a0-a1/a6
        rts

*--------------------------------------
* modify_idcmp
*
* >= d0.l = IDCMPFlags oder 0 zum Sperren
* >= a0.l = Zeiger auf WindowStruktur
* >= a1.l = Zeiger auf MsgPort oder 0 zum Entfernen
*
* kein Rückgaberegister
*--------------------------------------

modify_idcmp

        movem.l d0-d1/a0-a1/a6,-(a7)

        move.l  a1,wd_UserPort(a0)      ;MsgPort eintragen
        CALLINT ModifyIDCMP             ;aktivieren

        movem.l (a7)+,d0-d1/a0-a1/a6
        rts

*--------------------------------------
* set_win_titles
*
* >= a0.l = WindowPtr
* >= a1.l = Zeiger auf Text fuer WindowTitle
* >= a2.l = Zeiger auf Text fuer ScreenTitle
*
* Anmerkung:
* a1 und/oder a2 =  0 = Blank-Leiste
* a1 und/oder a2 = -1 = keine Aenderung
*
* kein Rückgaberegister
*--------------------------------------

set_win_titles

        movem.l d0-d1/a0-a1/a6,-(a7)

        CALLINT SetWindowTitles

        movem.l (a7)+,d0-d1/a0-a1/a6
        rts

*-------------------------------------
* refresh_g_list
*
* >= d0.l = Anzahl der aufzufrischenden Gadgets
*         = -1 = alle Gadgets der Liste
*
* >= a0.l = Zeiger auf den Anfang der aufzufrischenden GadgetStrukturen
* >= a1.l = WindowPtr
*
* kein Rückgaberegister
*--------------------------------------

refresh_g_list

        movem.l d0-d1/a0-a2/a6,-(a7)

        sub.l   a2,a2                   ;kein Requester
        CALLINT RefreshGList            ;auffrischen

        movem.l (a7)+,d0-d1/a0-a2/a6
        rts

*-------------------------------------
* add_g_list ©
*
* >= d0.l = Listen-Position an der die Gadgets eingefügt werden sollen
*         = -1 = ans Ende anfügen
* >= d1.l = Anzahl der einzufügenden Gadgets = -1 = alle
*
* >= a0.l = WindowPtr
* >= a1.l = Zeiger auf den Anfang der einzufügenden GadgetStrukturen
*
* kein Rückgaberegister
*--------------------------------------

add_g_list

        movem.l d0-d1/a0-a2/a6,-(a7)

        sub.l   a2,a2                   ;kein Requester
        CALLINT AddGList                ;installieren

        movem.l (a7)+,d0-d1/a0-a2/a6
        rts

*-------------------------------------
* remove_g_list ©
*
* >= d0.l = Anzahl der zu entfernenden Gadgets = -1 = bis Listenende
*
* >= a0.l = WindowPtr
* >= a1.l = Zeiger auf den Anfang der zu entfernenden GadgetStrukturen
*
* kein Rückgaberegister
*
* Anmerkung:
* Diese Funktion bewirkt nichts, wenn einer der Pointer NULL ist.
*--------------------------------------

remove_g_list

        cmp.l   #0,a0
        beq.s   .abbruch

        cmp.l   #0,a1
        beq.s   .abbruch

        movem.l d0-d1/a0-a1/a6,-(a7)

        CALLINT RemoveGList

        movem.l (a7)+,d0-d1/a0-a1/a6
.abbruch
        rts

*-------------------------------------
* activate_gadget
*
* >= a0.l = Zeiger auf GadgetStruktur
* >= a1.l = Zeiger auf Window
*
* kein Rückgaberegister
*--------------------------------------

activate_gadget

        movem.l d0-d1/a0-a2/a6,-(a7)

        sub.l   a2,a2
        CALLINT ActivateGadget

        movem.l (a7)+,d0-d1/a0-a2/a6
        rts

*--------------------------------------
* new_modify_prop
*
* >= a0.l = Zeiger auf Gadget
* >= a1.l = Zeiger auf Window
*
* >= d0.l = Flags
* >= d1.l = HorizPot
* >= d2.l = VertPot
* >= d3.l = HorizBody
* >= d4.l = VertBody
* >= d5.l = NumGad
*
* kein Rückgaberegister
*--------------------------------------

new_modify_prop

        movem.l d0-d1/a0-a2/a6,-(a7)

        sub.l   a2,a2
        CALLINT NewModifyProp

        movem.l (a7)+,d0-d1/a0-a2/a6
        rts

*--------------------------------------
