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
**  Noch zu erledigen:
**     Falls es nicht möglich war, den MessagePort oder das App-
**     Icon zu erstellen, wird momentan noch keine Fehlermeldung
**     ausgegeben und einfach weitergemacht.
**
**
** Autor : Daniel Seifert <dseifert@hell1og.be.schule.de>
** Datum : 17/18. April 1997
**         27. April 1997 (Ergänzung der Kommentare)
**         26. Mai 1997   (ab jetzt zuerst Window schließen, dann
**                         AppIcon starten!)
**         13. Juni 1997  Absturzursache entfernt



iconify:

        movem.l d0-d4/a0-a4/a6,-(a7)            ; rette Register

        bsr     CreateRexxHost
        move.l  d0,_AppIcon_MsgPort             ; sichern
        beq     .ende                           ; beenden, falls fehlgeschlagen

        bsr     freigeben                       ; Gadgets freigeben
        bsr     close_main_win                  ; Fenster schließen

        moveq.l #0,d0                           ; AppIcon-ID = 0
        moveq.l #0,d1                           ; keine Userdata
        move.l  #default_aide_name,a0           ; Text unter dem AppIcon
        move.l  _AppIcon_MsgPort,a1             ; MsgPort
        move.l  #0,a2                           ; lock (currently unused)
        move.l  _icondat,a3                     ; Icon

        cmp.l   #0,a3                           ; wurde ein Icon geladen?
        beq     .fertig                         ; nein -> Abbruch

        move.l  #0,a4                           ; taglist (none)

        move.l  _WBBase,a6                      ; use workbench.library
        jsr     _LVOAddAppIconA(a6)             ; AppIcon starten

        move.l  d0,_AppIcon                     ; sichern
        beq.s   .fertig                         ; Fehler -> Abbruch


;        move.l  ($4).w,a6
;        lea     rexxsyslibname,a1
;        moveq.l #0,d0
;        jsr     _LVOOpenLibrary(a6)
;        move.l  d0,_RexxSysBase

.loop1
        move.l  _AppIcon_MsgPort,a0             ; auf diesen Port warten
        CALLEXEC    WaitPort                    ; und los
        move.l  _AppIcon_MsgPort,a0             ;
        CALLEXEC    GetMsg
        move.l  d0,a0
;        bsr     CheckMsg                        ; welcher MsgTyp?
;        tst.l   d0
;        bne.s   .rexx                           ; a Rexx msg

.loop2:
        CALLEXEC GetMsg                         ; get message
        move.l  d0,a1                           ; until port
        tst.l   d0
        beq.s   .fertig                         ; is empty

        jsr     _LVOReplyMsg(a6)                ; reply message
        bra.s   .loop2

.rexx
        bsr     RexxHandle                      ; parse the RexxMsg
        bra.s   .loop1                          ; wait for next msg

.fertig:

        move.l  _AppIcon,a0                     ; appIcon-Adresse nach a0
        move.l  _WBBase,a6                      ; Workbench.library benutzen
        jsr     _LVORemoveAppIcon(a6)           ; appIcon wieder entfernen

        bsr     open_main_win                   ; Hauptfenster wieder öffnen
        bsr     sperren                         ; Gadgets erstmal sperren

        move.l  _AppIcon_MsgPort,a0             ; MsgPort nach a0
        CALLMRT DeletePort                      ; MsgPort vom System entfernen

        move.l  _RexxSysBase,a1
        cmp.l   #0,a1
        beq.s   .ende

        CALLEXEC CloseLibrary

.ende:
        movem.l (a7)+,d0-d4/a0-a4/a6            ; Register wiederherstellen
        rts                                     ; und zurück

CheckMsg
        movem.l a0,-(a7)
        moveq.l #0,d0
        move.l  _RexxSysBase,a6
        cmp.l   #0,a6
        beq.s   .fehler
        jsr     _LVOIsRexxMsg(a6)
.fehler movem.l (a7)+,a0
        rts
