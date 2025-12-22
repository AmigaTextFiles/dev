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
* dateiname_besorgen
*
* Liest die Namen aus TempDir und TemFile aus, setzt diese zusammen,
* trägt ":" und "/" ein, falls erforderlich, und legt den kompletten
* Dateinamen in "Dateiname" ab.
*
* Gibt bei einer Fehleingabe eine Fehlermeldung aus und ermöglicht
* die Korrektur des Namens, falls gewünscht.
*
* => d0.l = negativ bei Fehleingabe, = positiv = alles ok
* => d1.l = Zeiger auf den Dateinamen
*--------------------------------------

dateiname_besorgen

        movem.l d2-d3/a0-a2,-(a7)

        move.w  pruef_Flag,d3           ;alten Zustand merken
        move.w  #1,pruef_Flag           ;Flag setzen

.wiederholen

        lea     TempDir,a0              ;zeige auf Dirnamen
        lea     Dateiname,a1            ;zeige auf Ablage für den Dateinamen
        move.l  a1,d1                   ;in d1 zurückgeben
        tst.b   (a0)                    ;keinen Directorynamen angegeben?
        beq.s   .file                   ;ja, nur den Filenamen kopieren

        bsr     string_kopieren         ;kopieren, der Zeiger steht dann auf dem NullByte

        bsr     pruefe_den_dirnamen
        tst.l   d0                      ;welches Ergebnis ?
        bpl.s   .ram                    ;positiv, dann alles ok

.dirname_falsch
        bsr     dirname_falsch          ;Meldung ausgeben
        tst.l   d0                      ;welche Antwort ?
        bmi     .ende                   ;"Cancel" gewählt
        bpl.s   .wiederholen            ;"Ja" gewählt,  noch einmal probieren

.ram
        move.l  a1,a2                   ;aktuelle Zeigerpos. retten
        lea     ram_disk_string,a0      ;zeige auf "Ram Disk:"
        move.l  d1,a1                   ;zeige wieder auf den Anfang des Dateinamens
        moveq   #0,d1                   ;Groß/Kleinschreibung ist egal
        moveq   #8,d0                   ;8 Bytes sind zu vergleichen
        bsr     string_n_compare        ;vergleiche
        move.l  a1,d1                   ;Zeiger wieder => d1
        tst.l   d0                      ;identisch?
        beq.s   .ram_eintragen          ;ja

        move.l  a2,a1                   ;nein, aktuelle Zeigerpos wieder => a1
        bra.s   .file                   ;und den Filenamen eintragen

.ram_eintragen

        move.b  #"R",(a1)+              ;trage "RAM:" für "Ram Disk:" ein
        move.b  #"A",(a1)+
        move.b  #"M",(a1)+
        move.b  #":",(a1)+
        move.b  #0,(a1)

        tst.b   5(a1)                   ;kommt noch ein Dirname?
        beq.s   .file                   ;nein

        lea     5(a1),a0                ;zeige auf den Rest des Namens
.loop
        move.b  (a0)+,(a1)+             ;nach vorne schieben
        bne.s   .loop                   ;incl. NullByte

        tst.b   -(a1)                   ;Zeiger korrigieren
.file
        tst.w   Setup_Flag              ;nur das Directory auswerten?
        bne.s   .ende                   ;ja, beenden

        lea     TempFile,a0             ;zeige auf Filenamen
        tst.b   (a0)                    ;keinen Filenamen angegeben?
        beq.s   .dateiname_falsch       ;ja, Meldung ausgeben

        bsr     string_kopieren         ;kopieren, der Zeiger steht dann auf dem NullByte

        bsr     fileinfo_besorgen       ;prüfe den kompletten Namen
        tst.l   d0                      ;welches Ergebnis?
        bpl.s   .ende                   ;positiv, dann alles ok

        tst.w   new_source_file_Flag    ;evtl. neues SourceFile gewünscht?
        beq.s   .sichern                ;nein

        clr.w   new_source_file_Flag    ;Flag löschen, melde neues File anlegen!
        bra.s   .ende                   ;und beenden

.sichern
        tst.b   sichern_Flag            ;soll die Datei gesichert werden?
        beq.s   .dateiname_falsch       ;nein, Meldung ausgeben

        moveq.l #0,d0                   ;ja, melde "alles ok", Datei existiert noch nicht
        bra.s   .ende                   ;beenden

.dateiname_falsch

        moveq   #-1,d0                  ;Fehlermeldung setzen
        tst     d3                      ;nur den Namen überprüfen?
        bne.s   .ende                   ;ja

        bsr     dateiname_falsch        ;Meldung ausgeben
        tst.l   d0                      ;welche Antwort ?
        bmi.s   .ende                   ;"Cancel" gewählt
        bpl     .wiederholen            ;"ja" gewählt, noch einmal probieren
.ende
        clr.w   pruef_Flag              ;Flag löschen
        move.w  d3,pruef_Flag           ;alten Zustand wieder herstellen

        movem.l (a7)+,d2-d3/a0-a2
        rts
*--------------------------------------
* pruefe_den_dirnamen
*
* >= d1.l = Zeiger auf den Anfang des Dateinamens
* >= a1.l = Zeiger auf das Ende des Dateinamens
*
* => a1.l = Zeiger auf das neue Ende des Dateinamens
*--------------------------------------

pruefe_den_dirnamen

        movem.l a0/d1,-(a7)
        move.l  d1,a0

        cmp.b   #34,(a0)                ;fängt String mit '"' an?
        bne.s   .cont                   ;nö

        add.l   #1,d1                   ;überspringe "

.cont
        moveq   #0,d0                   ;Register löschen

        cmpi.b  #":",-1(a1)             ;ist das letzte Zeichen ein :
        beq.s   .ende                   ;ja

        cmpi.b  #"/",-1(a1)             ;ist das letzte Zeichen ein /
        beq.s   .ende                   ;ja

        move.b  #":",(a1)+              ;: anfügen
        move.b  #0,(a1)                 ;NullByte anfügen

        bsr     fileinfo_besorgen       ;prüfe den Namen
        tst.l   d0                      ;welches Ergebnis ?
        bpl.s   .ende                   ;positiv, dann alles ok

        move.b  #"/",-1(a1)             ;anstatt ":" "/" einfügen
        bsr     fileinfo_besorgen       ;prüfe den Namen
.ende
        movem.l (a7)+,a0/d1
        rts
*--------------------------------------
* pruefe_den_filenamen
*
* >= d1.l = Zeiger auf den Anfang des Dateinamens
*
* => d0.l = positiv = okay, negativ dann Fehler
*--------------------------------------

pruefe_den_filenamen

        movem.l a0/d1,-(a7)
        move.l  d1,a0

        cmp.b   #34,(a0)
        bne.s   .cont
        add.l   #1,d1

.cont
        move.w  #1,pruef_Flag           ;Flag setzen
        bsr     fileinfo_besorgen       ;prüfe den kompletten Namen
        clr.w   pruef_Flag              ;Flag löschen
        movem.l (a7)+,a0/d1
        rts

*--------------------------------------
* split_filename
*
* Trennt den Filenamen vom Dirnamen
*
* >= a3 = Zeiger auf den Filenamen
*
* die getrennten Namen stehen dann in TempDir und TempFile
*
*--------------------------------------

split_filename

        movem.l a0-a3,-(a7)

        tst.b   (a3)                    ;Eintrag vorhanden?
        beq.s   .clear                  ;nein

        move.l  a3,a0                   ;zum Bearbeiten => a0
.loop1
        tst.b   (a0)+                   ;finde das Ende des Namens
        bne.s   .loop1
.loop2
        cmp.l   a3,a0                   ;Anfang des Filenamens erreicht?
        beq.s   .loop3                  ;ja

        cmpi.b  #"/",-(a0)              ;suche den letzten /
        bne.s   .loop2

        move.l  a0,a2                   ;Zeiger merken
        tst.b   (a0)+                   ;stelle den Zeiger auf den Filenamen
        bra.s   .kopieren               ;alles klar, Zeiger merken

.loop3
        cmpi.b  #":",(a0)+              ;finde den Doppelpunkt
        bne.s   .loop3

        move.l  a0,a2                   ;Zeiger merken

.kopieren
        lea     TempFile,a1             ;zeige auf Ablagepuffer
        bsr     string_kopieren         ;und eintragen

        lea     TempDir,a1              ;zeige auf Ablagepuffer
.loop4
        move.b  (a3)+,(a1)+             ;kopiere
        cmp.l   a3,a2                   ;Ende des Pfadnamens erreicht?
        bne.s   .loop4                  ;nein

        clr.b   (a1)+                   ;NullByte anfügen

        bra.s   .ende                   ;ja, beenden

.clear
        clr.l   TempDir                 ;evtl. Einträge löschen
        clr.l   TempFile

.ende
        movem.l (a7)+,a0-a3
        rts

*--------------------------------------
