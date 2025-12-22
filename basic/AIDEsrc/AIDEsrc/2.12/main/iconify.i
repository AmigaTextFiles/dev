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

**
** Funktion iconify
**
**   Schließt das Hauptfenster von AIDE und legt ein AppIcon an.
**   Bei Betätigung desselben wird das Fenster wieder geöffnet.
**
**   Voraussetzungen:
**     In <_icondat> steht ein Zeiger auf eine DiskObject-Struk-
**     tur. Diese muß beim Programmstart initialisiert und beim
**     Programmende wieder freigegeben werden.
**
** Autor : Daniel Seifert <dseifert@hell1og.be.schule.de>
** Datum : 17/18. April 1997



iconify:

        movem.l d0-d4/a0-a4/a6,-(a7)            ; rette Register

        move.l  #0,a0                           ; noname
        move.b  #0,d0                           ; no priority
        CALLMRT CreatePort                      ; Port erstellen

        move.l  d0,_AppIcon_MsgPort             ; sichern
        beq     .ende                           ; beenden, falls fehlgeschlagen

        moveq.l #0,d0                           ; AppIcon-ID = 0
        moveq.l #0,d1                           ; keine Userdata
        move.l  #default_aide_name,a0           ; Text unter dem AppIcon
        move.l  _AppIcon_MsgPort,a1             ; MsgPort
        move.l  #0,a2                           ; lock (currently unused)
        move.l  _icondat,a3                     ; Icon

        cmp.l   #0,a3                           ; wurde ein Icon geladen?
        beq     .fehler                         ; nein -> Abbruch
        move.l  #0,a4                           ; taglist (none)

        move.l  _WBBase,a6                      ; use workbench.library
        jsr     _LVOAddAppIconA(a6)             ; AppIcon starten

        move.l  d0,_AppIcon                     ; sichern
        beq.s   .fehler                         ; Fehler -> Abbruch

        bsr     freigeben                       ; Gadgets freigeben
        bsr     close_main_win                  ; Fenster schließen

        move.l  _AppIcon_MsgPort,a0             ; Port to clear
        move.l  ($4).w,a6                       ; hole ExecBase

.loop:

        jsr     _LVOGetMsg(a6)                  ; get message
        tst.l   d0                              ; until port
        beq.s   .endloop                        ; is empty

        move.l  d0,a1                           ; messageptr to a1
        jsr     _LVOReplyMsg(a6)                ; reply message
        bra.s   .loop                           ; get next message

.endloop:

        move.l  _AppIcon_MsgPort,a0             ; auf diesen Port warten
        jsr     _LVOWaitPort(a6)                ; und los

.loop2:
        jsr     _LVOGetMsg(a6)                  ; get message
        move.l  d0,a1                           ; until port
        tst.l   d0
        beq.s   .fertig                         ; is empty

        jsr     _LVOReplyMsg(a6)                ; reply message
        bra.s   .loop2

.fertig:

        move.l  _AppIcon,a0                     ; appIcon-Adresse nach a0
        move.l  _WBBase,a6                      ; Workbench.library benutzen
        jsr     _LVORemoveAppIcon(a6)		; appIcon wieder entfernen

        bsr     open_main_win			; Hauptfenster wieder öffnen
        bsr     sperren				; Gadgets erstmal sperren

.fehler:
        move.l  _AppIcon_MsgPort,a0		; MsgPort nach a0
        CALLMRT DeletePort			; MsgPort vom System entfernen

.ende:
        movem.l (a7)+,d0-d4/a0-a4/a6            ; Register wiederherstellen
        rts                                     ; und zurück

