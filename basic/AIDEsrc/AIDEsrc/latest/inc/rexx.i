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


*****
* CreateRexxHost
*
* Legt einen ARexx-Port an, der ARexx-Messages empfangen kann.
*
* => a0 : Zeiger auf den Namen des Portes
*
* <= d0 : Zeiger auf den ARexx-Port oder 0 (Fehler)

CreateRexxHost

        movem.l a1,-(a7)

        lea     ARexxPortName,a1

.existent
        CALLEXEC Forbid
        CALLEXEC FindPort             ; existiert Port schon?
        CALLEXEC Permit

        lea     ARexxPortName,a0
        move.l  a0,a1
        tst.l   d0
        beq.s   .anlegen

.suchepunkt
        cmpi.b  #".",(a0)+
        beq.s   .nächster
        tst.b   (a0)
        beq.s   .erster
        bra.s   .suchepunkt

.erster
        move.l  #$2E310000,(a0)        ; schreibe ".1"
        move.l  a1,a0
        bra.s   .existent

.nächster
        move.b  (a0),d0                ; aktuelle Nummer (1-9, A-Z, a-z)
        add.b   #1,d0

        cmpi.b  #122,d0
        bgt.s   .fehler                ; schon über "z" hinaus -> Abbruch

        cmpi.b  #97,d0
        bge.s   .eintragen

        cmpi.b  #90,d0
        bgt.s   .jmp1

        cmpi.b  #65,d0
        bge.s   .eintragen

        cmpi.b  #57,d0
        blt.s   .eintragen

        add.b   #7,d0
        bra.s   .eintragen

.jmp1   add.b   #6,d0

.eintragen
        move.b  d0,(a0)
        move.l  a1,a0
        bra.s   .existent



.anlegen
        move.l  #1,d0                  ; Priorität 1
        bsr     create_msg_port        ; Port anlegen
        bra.s   .ende                  ; Ende

.fehler
        move.l  #0,d0                  ; Fehler

.ende   movem.l (a7)+,a1
        rts


*****
* DeleteRexxHost
*
* Löscht den Host wieder.
*
* => a0 : Zeiger auf den Host

DeleteRexxHost

        bsr     delete_msg_port
        rts

*****
* ReplyRexxCommand
*
* Bestätigt den Erhalt einer Rexxmessage und tut alles erfor-
* derliche, um den Speicher wieder freizugeben.
*
* => a0.l : Zeiger auf Message
* => d0.l : primary result
* => d1.l : secondary result
* => a1.l : Zeiger auf "Result"

ReplyRexxCommand

        movem.l  a0-a1/d0-d2,-(a7)

        tst.l    d0                    ; Fehler?
        beq.s    .argstring            ; nein, Result formatieren

        move.l   #5,d1
        bra.s    .send

.argstring

        movem.l  a0/d0,-(a7)
        move.l   d1,a0
        moveq.l  #-1,d0

.len    addq.l   #1,d0
        tst.b    (a0)+
        bne.s    .len

        move.l   d1,a0
        bsr      CreateArgstring

        move.l   d0,d1
        movem.l  (a7)+,a0/d0

.send

        move.l   d0,rm_Result1(a0)
        move.l   d1,rm_Result2(a0)
        move.l   a0,a1

        CALLEXEC ReplyMsg

        movem.l  (a7)+,a0-a1/d0-d2
        rts

*****
* GetRexxCommand
*
* Liefert einen Zeiger auf den Kommandostring zurück.
*
* => a0.l : Zeiger auf die Rexxmsg
* <= d0.l : Zeiger auf den Commandostring

GetRexxCommand

        move.l   rm_Args(a0),d0
        rts

*****
* RexxHandle
*
* Wertet einen ARexx-Befehl aus und führt die erforderlichen
* Operationen durch.
*
* => a0.l : Zeiger auf die Rexxmsg

RexxHandle

        movem.l  a0-a3/a6/d0-d2,-(a7)

        bsr      GetRexxCommand              ; get cmd-ptr in d0
        move.l   a0,PendingRexxMsg

        lea      RexxCmdTable,a2
        move.l   d0,a0
        move.l   CountRexxCmd,d2
        subq.w   #1,d2

.checkcmd
        move.l   (a2)+,a1
        move.l   (a2)+,a3
        moveq.l  #0,d1
        bsr      string_compare
        tst.l    d0
        dbeq     d2,.checkcmd

        tst.w    d2
        blt.s    .fehler
;        jsr      (a3)

.fehler move.l   PendingRexxMsg,a0
        bsr      ReplyRexxCommand
        move.l   #0,PendingRexxMsg

        movem.l  (a7)+,a0-a3/a6/d0-d2
        rts


RexxCmdTable     dc.l  RexxSet,set_source
                 dc.l  RexxReset,reset_source
                 dc.l  RexxPrecompile,precompile_prg
                 dc.l  RexxCompile,compile_prg
                 dc.l  RexxAssemble,assemble_prg
                 dc.l  RexxLink,link_prg
                 dc.l  RexxRun,run_prg
                 dc.l  RexxRunShell,run_in_shell
                 dc.l  RexxMakeExe,make_exe
                 dc.l  RexxMakeApp,make_application
                 dc.l  RexxMakeMod,make_submod

CountRexxCmd     dc.l  11
PendingRexxMsg   dc.l  0

RexxSet          dc.b  "SET",0
                 even
RexxReset        dc.b  "RESET",0
                 even
RexxPrecompile   dc.b  "PRECOMPILE",0
                 even
RexxCompile      dc.b  "COMPILE",0
                 even
RexxAssemble     dc.b  "ASSEMBLE",0
                 even
RexxLink         dc.b  "LINK",0
                 even
RexxRun          dc.b  "RUN",0
                 even
RexxRunShell     dc.b  "RUNSHELL",0
                 even
RexxMakeExe      dc.b  "MAKEEXE",0
                 even
RexxMakeApp      dc.b  "MAKEAPP",0
                 even
RexxMakeMod      dc.b  "MAKEMOD",0
                 even