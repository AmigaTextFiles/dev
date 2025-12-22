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

sperren

        movem.l d0-d1/a0-a1,-(a7)

        moveq.l #0,d0                   ;keine Flags
        move.l  _MainWinPtr,a0          ;WindowPtr  => a0
        move.l  d0,a1                   ;MsgPortPtr = NULL
        bsr     modify_idcmp            ;MsgPort entfernen

        bsr     clear_menu_strip        ;Menü entfernen
        bsr     gadgets_sperren         ;Gadgets entfernen

        movem.l (a7)+,d0-d1/a0-a1
        rts

*--------------------------------------

freigeben

        movem.l d0-d1/a0-a1,-(a7)

        move.l  MainWinIDCMP,d0         ;Flags => d0
        move.l  _MainWinPtr,a0          ;zeige auf Window-Struktur
        move.l  _WinMsgPort,a1          ;zeige auf MsgPort
        bsr     modify_idcmp            ;MsgPort wieder aktivieren

        move.l  _MenuePtr,a1            ;zeige auf Menü-Struktur
        bsr     set_menu_strip          ;wieder installieren

        bsr     gadgets_freigeben       ;dto.

        movem.l (a7)+,d0-d1/a0-a1
        rts

*--------------------------------------

setup_sperren

        movem.l d0-d1/a0-a1,-(a7)

        moveq.l #0,d0                   ;keine Flags
        move.l  _SetupWinPtr,a0         ;WindowPtr  => a0
        move.l  d0,a1                   ;MsgPortPtr = NULL
        bsr     modify_idcmp            ;MsgPort entfernen

        bsr     setup_gadgets_sperren   ;Gadgets sperren

        movem.l (a7)+,d0-d1/a0-a1
        rts

*--------------------------------------

setup_freigeben

        movem.l d0-d1/a0-a1,-(a7)

        move.l  SetupWinIDCMP,d0        ;Flags => d0
        move.l  _SetupWinPtr,a0         ;zeige auf Window-Struktur
        move.l  _WinMsgPort,a1          ;zeige auf MsgPort
        bsr     modify_idcmp            ;MsgPort wieder aktivieren

        bsr     setup_gadgets_freigeben ;dto.

        movem.l (a7)+,d0-d1/a0-a1
        rts
*--------------------------------------

sopt_sperren

        movem.l d0-d1/a0-a1,-(a7)

        moveq.l #0,d0                   ;keine Flags
        move.l  _SOptWinPtr,a0          ;WindowPtr  => a0
        move.l  d0,a1                   ;MsgPortPtr = NULL
        bsr     modify_idcmp            ;MsgPort entfernen

        jsr     sopt_gadgets_sperren    ;Gadgets sperren

        movem.l (a7)+,d0-d1/a0-a1
        rts

*--------------------------------------

sopt_freigeben

        movem.l d0-d1/a0-a1,-(a7)

        move.l  SOptWinIDCMP,d0         ;Flags => d0
        move.l  _SOptWinPtr,a0          ;zeige auf Window-Struktur
        move.l  _WinMsgPort,a1          ;zeige auf MsgPort
        bsr     modify_idcmp            ;MsgPort wieder aktivieren

        jsr     sopt_gadgets_freigeben  ;dto.

        movem.l (a7)+,d0-d1/a0-a1
        rts
*--------------------------------------
