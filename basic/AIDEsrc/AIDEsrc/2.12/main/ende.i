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
* Unterprogramm Hauptprogrammende
*--------------------------------------

hprg_ende


* DiskObject wieder freigeben
*----------------------------

        move.l  _IconBase,a6
        move.l  _icondat,a0

        cmp.l   #0,_icondat
        beq.s   .screen

        jsr     _LVOFreeDiskObject(a6)

* zuerst den Screen nach hinten bringen
*--------------------------------------

.screen
        tst.l   _ScrnPtr                ;Screen geöffnet?
        beq.s   .window                 ;nein

        move.l  _ScrnPtr,a0             ;zeige auf ScreenStruktur
        bsr     screen_to_back          ;zuerst den Screen nach hinten bringen

.window
        bsr     close_main_win          ;Window schließen, Gadgets und Menü freigeben

* VisualInfo wieder freigeben
* [nach CloseWindow() aber vor CloseScreen() oder UnlockPubScreen()]
* (siehe RKRM Includes and Autodocs v37)
*-------------------------------------------------------------------

        move.l  _VInfo,a0               ;zeige auf VisualInfoStruktur
        bsr     free_visual_info        ;freigeben
        clr.l   _VInfo                  ;Zeiger löschen

* Screen schließen
*-----------------

.close_screen

        tst.l   _ScrnPtr                ;Screen geöffnet?
        beq.s   .wb                     ;nein

        move.l  _ScrnPtr,a0             ;zeige auf ScreenStruktur
        bsr     close_screen            ;jetzt schließen
        tst.l   d0                      ;geklappt?
        bne.s   .signal                 ;ja

        move.l  _ScrnPtr,a0             ;zeige auf ScreenStruktur
        bsr     screen_to_front         ;wieder nach vorne bringen

        move.l  ScreenSignal,d1         ;Signal => d1
        moveq   #0,d0                   ;Register löschen
        bset    d1,d0                   ;in d0 setzen
        bsr     wait                    ;warte

        bra.s   .close_screen           ;alle Visitors geschlossen, Screen jetzt auch schließen

* Signal freigeben
*-----------------

.signal
        move.l  ScreenSignal,d0         ;Signal => d0
        bsr     free_signal             ;freigeben
        bra.s   .font                   ;WB überspringen

* WBScreen wieder freigeben
*--------------------------

.wb
        move.l  _WBScreen,a1            ;zeige auf WBScreen
        bsr     unlock_pub_screen       ;freigeben

* Font wieder freigeben
*-----------------------

.font
        move.l  _FontPtr,a1             ;zeige auf Font
        bsr     close_font              ;freigeben

* MsgPort entfernen
*------------------

        move.l  _WinMsgPort,a0          ;zeige auf MsgPort
        bsr     delete_msg_port         ;entfernen

* reservierte Speicherbereiche freigeben
*---------------------------------------

        move.l  _MemPtr,a1              ;Zeiger  => a1
        bsr     free_vec                ;freigeben

        move.l  _AvailableModule,a1     ;die Module ebenfalls
        bsr     free_vec

* OriginalDir wieder als CurrentDir setzen
*-----------------------------------------

        bsr     set_old_current_dir

* Libraries schließen
*--------------------

        moveq   #Anzahl_Lib-1,d0        ;Anzahl der Libs => d0
        moveq   #0,d1                   ;Offsetzählregister initialisieren
        lea     _AslBase,a0             ;zeige auf ZeigerAblage 1. Eintrag
.loop
        move.l  0(a0,d1),a1             ;LibraryPtr => a1
        bsr     close_library           ;schließen

        addq    #4,d1                   ;Offset erhöhen
        dbra    d0,.loop                ;nächste Lib schließen
.ende
        rts

*--------------------------------------
