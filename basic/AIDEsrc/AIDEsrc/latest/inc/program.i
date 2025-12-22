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
* Program
*--------------------------------------

precompile_prg

        movem.l d1-d2/a0-a1,-(a7)

        tst.l   KomplettFlag            ;kompletten CompilerRun durchführen?
        bne.s   .start                  ;ja

        bsr     clear_buffer            ;nein, zuerst Puffer löschen
.start
        move.l  MakeSetup,d2            ;hole die Flags
        moveq.l #nap,d0                 ;Bittestregister initialisieren
        moveq.l #0,d1                   ;Bitmerkregister initialisieren
.loop
        btst    d0,d2                   ;welcher Precompiler?
        bne.s   .preco                  ;gefunden

        addq    #1,d0                   ;Register aufaddieren
        bra.s   .loop
.preco
        cmpi.b  #preco_other,d0         ;other Precompiler gewählt?
        bne.s   .buffer                 ;nein

        move.l  _MemPtr,a0              ;zeige auf Configuration
        tst.b   other_precomp_name(a0)  ;Eintrag vorhanden?
        bne.s   .other                  ;ja, gesondert behandeln

        bsr     no_other_preco_eingetragen
                                        ;Meldung ausgeben
        bra.s   .fehler                 ;und beenden
.other
        bsr     other_preco_cmd_eintragen       ;eintragen
        bra.s   .ausfuehren             ;und ausführen

.buffer
        bsr     preco_cmd_eintragen     ;Kommando eintragen

.ausfuehren
        tst.l   KomplettFlag            ;kompletten CompilerRun durchführen?
        beq.s   .compile                ;nein

        move.l  a1,StringEndeAddress    ;Adresse in "StringEndeAddress" zurückgeben
        bra.s   .ende                   ;und beenden

.compile
        bsr     compile                 ;und ausführen

        tst.l   CompileErrorFlag        ;alles ok?
        bne.s   .fehler                 ;nein

        bsr     activate_compile_gad    ;Gadget aktivieren
        move.w  #1,precompiled          ;Flag setzen
        clr.l   CommandoSetup           ;KommandoBits löschen
        moveq.l #0,d0                   ;melde alles okay
        bra.s   .ende
.fehler
        bsr     reset_source            ;Fehler, noch mal von vorne anfangen
        moveq.l #-1,d0                  ;melde Fehler
.ende
        movem.l (a7)+,d1-d2/a0-a1
        rts

*--------------------------------------
* >= a0.l = _MemPtr

other_preco_cmd_eintragen

        movem.l d0-d1,-(a7)             ;Register retten

        lea     other_precomp_name(a0),a0 ;zeige auf den Namen
        lea     dcpp_name,a1            ;zeige auf Vergleichstring
        moveq.l #0,d1                   ;Schreibweise egal
        bsr     string_compare          ;vergleiche
        tst.l   d0                      ;welches Ergebnis?
        bne.s   .other                  ;nicht DCPP

        movem.l (a7)+,d0-d1             ;Register wieder herstellen
        bsr     dcpp_eintragen          ;Kommando eintragen
        bra.s   .ende                   ;und beenden
.other
        movem.l (a7)+,d0-d1             ;Register wieder herstellen
        bsr     preco_cmd_eintragen     ;Kommando eintragen
.ende
        rts
*--------------------------------------

preco_cmd_eintragen

        bsr     source_preco_eintragen  ;kompletten String eintragen
        bsr     tmp_file_eintragen      ;Destinationname eintragen

        cmpi.b  #acpp,d0                ;ACPP = Precompiler?
        bne.s   .ende                   ;nein

        bsr     beta_eintragen          ;trage ".beta" ein
        bsr     removeline_eintragen    ;RemoveLine ebenfalls ausführen
.ende
        rts
*---------------------------------------

dcpp_eintragen

        bsr     source_preco_eintragen  ;kompletten String eintragen

        move.b  #"-",(a1)+              ;"-o" anfügen
        move.b  #"o",(a1)+

        bsr     tmp_file_eintragen      ;Name eintragen
        bsr     beta_eintragen          ;trage "beta" ein

        move.b  #" ",(a1)+              ;Space anfügen
        move.b  #"-",(a1)+              ;"-U" anfügen
        move.b  #"U",(a1)+

        bsr     removeline_eintragen    ;RemoveLine ebenfalls ausführen
.ende
        rts
*---------------------------------------

source_preco_eintragen

        move.l  _BufferPtr,a1           ;zeige auf Kommandofeld
        bsr     cmd_eintragen           ;Kommando eintragen

        lea     source_fullname,a0      ;zeige auf den kompletten Namen
        move.b  #34,(a1)+
        bsr     string_kopieren         ;und eintragen
        move.b  #34,(a1)+
        move.b  #" ",(a1)+              ;Space anfügen
        rts

*--------------------------------------

removeline_eintragen

        moveq.l #removeline,d0          ;KommandoBitNr eintragen
        bsr     adresse_einstellen      ;Adresse auf das nächste Langwort stellen
        bsr     cmd_eintragen           ;Kommando eintragen

        bsr     tmp_file_eintragen      ;Name eintragen
        bsr     beta_eintragen          ;trage "beta" ein
        move.b  #" ",(a1)+              ;NullByte mit Space überschreiben
        bsr     tmp_file_eintragen      ;Name eintragen

        rts
*---------------------------------------

compile_prg

        movem.l d1-d5/a0-a2,-(a7)

        tst.l   KomplettFlag            ;kompletten CompilerRun durchführen?
        bne.s   .start                  ;ja

        bsr     clear_buffer            ;nein, zuerst Puffer löschen
.start
        bsr     deactivate_ace_error_gad

        move.l  CommandoSetup,d1        ;KommandoBits  => d1 eintragen
        moveq.l #ace,d0                 ;KommandoBitNr => d0

        tst.l   KomplettFlag            ;kompletten CompilerRun durchführen?
        beq.s   .skip1                  ;nein

        tst.l   StringEndeAddress       ;Adresse vorhanden?
        beq.s   .skip1                  ;nein

        move.l  StringEndeAddress,a1    ;"StringEndeAddress" => a1
        bsr     adresse_einstellen      ;Adresse auf das nächste Langwort stellen
        bra.s   .skip2
.skip1
        move.l  _BufferPtr,a1           ;zeige auf Kommandofeld
.skip2
        bsr     cmd_eintragen           ;Kommando eintragen

        move.l  OptionsSetup,d2         ;gewählte Options => d2
        lea     ace_option_table,a0     ;zeige auf OptionsZeigerTabelle
        moveq.l #0,d3                   ;Bittestregister initialisieren
        moveq.l #4,d4                   ;Zählregister initialisieren
        moveq.l #0,d5                   ;Offsetzählregister initialisieren
        tst.b   -(a1)                   ;Adresse korrigieren
.loop1
        btst    d3,d2                   ;prüfe auf Option
        beq.s   .next                   ;nicht gesetzt, auf nächste prüfen

        move.l  0(a0,d5),a2             ;Zeiger auf Option eintragen
        move.b  (a2),(a1)+              ;Option eintragen
.next
        addq    #1,d3                   ;Bittestregister aufaddieren
        addq    #4,d5                   ;Offsetzählregister aufaddieren
        dbra    d4,.loop1               ;bis alle geprüft

        tst.l   AceObjectFlag           ;SUBMod erzeugen?
        beq.s   .other                  ;nein

        move.b  #"m",(a1)+              ;ja, Flag eintragen

.other
        move.l  _MemPtr,a0              ;zeige auf Configuration
        tst.b   other_ace_options(a0)   ;Eintrag vorhanden?
        beq.s   .space                  ;nein, Space anfügen

        lea     other_ace_options(a0),a0 ;zeige auf Eintrag
        bsr     string_kopieren         ;und alle eintragen
.space
        move.b  #" ",(a1)+              ;Space anfügen

        bsr     tmp_file_eintragen      ;Name eintragen

        bsr     process_superoptimizer  ;Superoptimizer ebenfalls eintragen

        tst.l   KomplettFlag            ;kompletten CompilerRun durchführen?
        beq.s   .compile                ;nein

        move.l  a1,StringEndeAddress    ;Adresse in "StringEndeAddress" zurückgeben
        bra.s   .ende                   ;und beenden

.compile
        bsr     compile                 ;und ausführen

        tst.l   CompileErrorFlag        ;alles ok?
        bne.s   .fehler                 ;nein

        bsr     activate_assembler_gad  ;Gadget aktivieren
        move.w  #1,compiled             ;Flag setzen
        clr.l   CommandoSetup           ;KommandoBits löschen
        bsr     deactivate_ace_error_gad
        moveq.l #0,d0                   ;melde alles okay
        bra.s   .ende
.fehler
        bsr     reset_compile           ;Fehler
        moveq.l #-1,d0                  ;melde Fehler
.ende
        movem.l (a7)+,d1-d5/a0-a2
        rts

*--------------------------------------

process_superoptimizer

        movem.l d0-d5/a3,-(a7)

        move.l  MakeSetup,d0            ;Setup => d0
        btst    #superopt,d0            ;aktiv ?
        beq     .ende                   ;nein

        move.l  CommandoSetup,d1        ;KommandoBits  => d1 eintragen
        moveq.l #superopt,d0            ;KommandoBitNr => d0
        bsr     adresse_einstellen      ;Adresse auf das nächste Langwort stellen
        bsr     cmd_eintragen           ;Kommando eintragen

        move.l  _MemPtr,a0              ;zeige auf Konfiguration
        move.l  superopt_level(a0),d0   ;besorge den Wert

        move.l  a1,a0                   ;zeige auf KommandoStringEnde

        move.l  a0,-(a7)                ;Register retten
        moveq   #18,d1                  ;Zählregister einstellen
.loesch
        clr.b   (a0)+                   ;evtl. vorherigen Text löschen
        dbra    d1,.loesch              ;bis 18 Bytes gelöscht sind

        move.l  (a7)+,a0                ;Register wieder herstellen

        cmp.l   #0,SOptVersion          ;which version to use?
        beq.s   .old_SOPT               ;the old one

.new_SOPT                               ;the new one

        move.l  #16,d5
        move.l  SOptLevel,d3
        move.l  #OptionChars,a3

.checkbit

        btst.l  d5,d3
        beq.s   .nextbit

        move.b  0(a3,d5),(a0)+

.nextbit

        sub.l   #1,d5
        tst.l   d5
        bge.s   .checkbit

        bra.s   .loop1

.old_SOPT

        move.l  a0,-(a7)                ;Register retten
        moveq   #3,d1                   ;Zählregister einstellen
.loesch2
        clr.b   (a0)+                   ;evtl. vorherigen Text löschen
        dbra    d1,.loesch2             ;bis 4 Bytes gelöscht sind

        move.l  (a7)+,a0                ;Register wieder herstellen

        move.l  SOptLevel,d0
        andi.l  #$FF000000,d0
        swap    d0
        divu.w  #$100,d0
        moveq   #0,d1                   ;kein weiterer Offset erforderlich
        moveq   #2,d2                   ;keine führenden Nullen erwünscht

        bsr     hex_to_dez_ascii        ;wandeln und eintragen

.loop1
        tst.b   (a1)+                   ;finde das Ende des Strings
        bne.s   .loop1

        move.b  #" ",-1(a1)             ;NullByte mit Space überschreiben
        bsr     tmp_file_eintragen      ;Name eintragen
        bsr     s_eintragen             ;trage "s" ein
        move.b  #" ",(a1)+              ;NullByte mit Space überschreiben
        bsr     tmp_file_eintragen      ;Name eintragen
        bsr     opt_eintragen           ;trage "_opt.s" ein
.ende
        movem.l (a7)+,d0-d5/a3
        rts

*--------------------------------------

assemble_prg

        movem.l d1-d2/a0-a1,-(a7)

        tst.l   KomplettFlag            ;kompletten CompilerRun durchführen?
        bne.s   .start                  ;ja

        bsr     clear_buffer            ;nein, zuerst Puffer löschen
.start
        move.l  MakeSetup,d2            ;hole die Flags
        moveq.l #a68k,d0                ;Bittestregister initialisieren
        move.l  CommandoSetup,d1        ;KommandoBits  => d1
.loop
        btst    d0,d2                   ;welcher Assembler?
        bne.s   .ass                    ;gefunden

        addq    #1,d0                   ;Register aufaddieren
        bra.s   .loop                   ;auf nächsten prüfen
.ass
        cmpi.b  #ass_other,d0           ;other Assembler gewählt?
        bne.s   .skip0                  ;nein

        move.l  _MemPtr,a0              ;zeige auf Configuration
        tst.b   other_ass_name(a0)      ;Eintrag vorhanden?
        bne.s   .skip0                  ;ja, vielleicht alles ok

        bsr     no_other_assembler_eingetragen
                                        ;Meldung ausgeben
        bra.s   .fehler                 ;und beenden
.skip0
        tst.l   KomplettFlag            ;kompletten CompilerRun durchführen?
        beq.s   .skip1                  ;nein

        tst.l   StringEndeAddress       ;Adresse vorhanden?
        beq.s   .skip1                  ;nein

        move.l  StringEndeAddress,a1    ;"StringEndeAddress" => a1
        bsr     adresse_einstellen      ;Adresse auf das nächste Langwort stellen
        bra.s   .skip2
.skip1
        move.l  _BufferPtr,a1           ;zeige auf Kommandofeld
.skip2
        bsr     cmd_eintragen           ;Kommando eintragen

        cmpi.b  #phxass,d0              ;PhxAss gewählt?
        bne.s   .skip3                  ;nein

        bsr     phxass_einstellen       ;ja, entsprechend eintragen
        bra.s   .skip4                  ;die anderen Assembler übersringen
.skip3
        cmpi.b  #a68k,d0                ;A68K gewählt?
        beq.s   .a68k                   ;die anderen Assembler übersringen

        bsr     other_ass_einstellen    ;ja, entsprechend eintragen
        bra.s   .skip4                  ;die anderen Assembler übersringen
.a68k
        bsr     a68k_einstellen         ;ja, entsprechend eintragen
.skip4
        tst.l   KomplettFlag            ;kompletten CompilerRun durchführen?
        beq.s   .compile                ;nein

        move.l  a1,StringEndeAddress    ;Adresse in "StringEndeAddress" zurückgeben
        bra.s   .ende                   ;und beenden

.compile
        bsr     compile                 ;und ausführen

        tst.l   CompileErrorFlag        ;alles ok?
        bne.s   .fehler                 ;nein

        bsr     activate_linker_gad     ;Gadget aktivieren
        move.w  #1,assembled            ;Flag setzen
        clr.l   CommandoSetup           ;KommandoBits löschen
        moveq.l #0,d0                   ;melde alles okay
        bra.s   .ende
.fehler
        clr.w   assembled               ;Flags löschen
        clr.l   CommandoSetup
        moveq.l #-1,d0                  ;melde Fehler
.ende
        movem.l (a7)+,d1-d2/a0-a1
        rts

*--------------------------------------

a68k_einstellen

        move.l  OptionsSetup,d0         ;prüfe auf Options

        btst    #ass_debug_info,d0      ;DebugInfo gewählt?
        beq.s   .filename               ;nein

        move.b  #"-",(a1)+              ;"-d" vor den Namen setzen
        move.b  #"d",(a1)+
        move.b  #" ",(a1)+              ;Space eintragen

.filename
        bsr     sourcefile_ass_eintragen ;Name eintragen
        move.b  #" ",(a1)+              ;Space eintragen

* Anmerkung:
* SmallCode/Data Modell nicht mit A68K!!!

.other
        bsr     assembler_options_eintragen
                                        ;evtl. "other Options" eintragen
        move.b  #" ",(a1)+              ;Space eintragen
        move.b  #34,(a1)+               ;Anführungszeichen
        move.b  #"-",(a1)+              ;anderen Namen für Objectfile verwenden
        move.l  a2,-(a7)
        move.l  a1,-(a7)
        bsr     objfile_eintragen       ;Name eintragen
        move.l  (a7)+,a2
        move.b  #"o",(a2)
        move.l  (a7)+,a2

        rts

*--------------------------------------

phxass_einstellen

        bsr     sourcefile_ass_eintragen
                                        ;Name eintragen

        move.b  #"T",(a1)+              ;"TO " eintragen
        move.b  #"O",(a1)+
        move.b  #" ",(a1)+

        bsr     objfile_eintragen       ;Name eintragen

        move.b  #"A",(a1)+              ;"A " eintragen = ALIGN (default)
        move.b  #" ",(a1)+

        move.l  OptionsSetup,d0         ;prüfe auf Options

        btst    #ass_debug_info,d0      ;DebugInfo gewählt?
        beq.s   .small_code             ;nein

        move.b  #"D",(a1)+              ;"DS " eintragen
        move.b  #"S",(a1)+
        move.b  #" ",(a1)+

.small_code
        btst    #ass_small_code,d0      ;SmallCodeModell gewählt?
        beq.s   .small_data             ;nein

        move.b  #"S",(a1)+              ;"SC " eintragen
        move.b  #"C",(a1)+
        move.b  #" ",(a1)+

.small_data
        btst    #ass_small_data,d0      ;SmallDataModell gewählt?
        beq.s   .std                    ;nein

        move.b  #"S",(a1)+              ;"SD " eintragen
        move.b  #"D",(a1)+
        move.b  #" ",(a1)+
.std
        move.b  #"N",(a1)+              ;"NOEXE " eintragen (default)
        move.b  #"O",(a1)+
        move.b  #"E",(a1)+
        move.b  #"X",(a1)+
        move.b  #"E",(a1)+
        move.b  #" ",(a1)+

        move.b  #"O",(a1)+              ;"OPT 0" eintragen (default)
        move.b  #"P",(a1)+
        move.b  #"T",(a1)+
        move.b  #" ",(a1)+
        move.b  #"0",(a1)+

        bsr     assembler_options_eintragen
                                        ;evtl. "other Options" eintragen
.ende
        move.b  #0,(a1)                 ;NullByte anfügen und fertig
        rts

*--------------------------------------

other_ass_einstellen

        bsr     sourcefile_ass_eintragen ;Name eintragen

        move.b  #0,(a1)+                ;NullByte anfügen
        bsr     assembler_options_eintragen
                                        ;evtl. Options einfügen
        tst.b   -(a1)                   ;Adresse korrigieren
        bsr     objfile_eintragen       ;Name eintragen

.ende
        move.b  #0,(a1)                 ;NullByte anfügen und fertig
        rts

*--------------------------------------

link_prg

        movem.l d1-d2/a0-a1,-(a7)

        tst.l   KomplettFlag            ;kompletten CompilerRun durchführen?
        bne.s   .start                  ;ja

        bsr     clear_buffer            ;nein, zuerst Puffer löschen
.start
        move.l  MakeSetup,d2            ;hole die Flags
        moveq.l #blink,d0               ;Bittestregister initialisieren
        move.l  CommandoSetup,d1        ;KommandoBits  => d1 eintragen
.loop
        btst    d0,d2                   ;welcher Linker?
        bne.s   .lnk                    ;gefunden

        addq    #1,d0                   ;Register aufaddieren
        bra.s   .loop
.lnk
        cmpi.b  #lnk_other,d0           ;other Linker gewählt?
        bne.s   .skip0                  ;nein

        move.l  _MemPtr,a0              ;zeige auf Configuration
        tst.b   other_linker_name(a0)   ;Eintrag vorhanden?
        bne.s   .skip0                  ;ja

        bsr     no_other_linker_eingetragen
                                        ;Meldung ausgeben
        bra.s   .fehler                 ;und beenden
.skip0
        tst.l   KomplettFlag            ;kompletten CompilerRun durchführen?
        beq.s   .skip1                  ;nein

        tst.l   StringEndeAddress       ;Adresse vorhanden?
        beq.s   .skip1                  ;nein

        move.l  StringEndeAddress,a1    ;"StringEndeAddress" => a1
        bsr     adresse_einstellen      ;Adresse auf das nächste Langwort stellen
        bra.s   .skip2
.skip1
        move.l  _BufferPtr,a1           ;zeige auf Kommandofeld
.skip2
        bsr     cmd_eintragen           ;Kommando eintragen

        cmpi.b  #phxlnk,d0              ;PhxLnk gewählt?
        bne.s   .skip3                  ;nein

        bsr     phxlnk_einstellen       ;ja, entsprechend eintragen
        bra.s   .skip4                  ;die anderen Linker überspringen
.skip3
        cmpi.b  #blink,d0               ;BLink gewählt?
        beq.s   .blink                  ;ja, die anderen Linker übersringen

        bsr     other_lnk_einstellen    ;ja, entsprechend eintragen
        bra.s   .skip4                  ;die anderen Linker übersringen
.blink
        bsr     blink_einstellen        ;entsprechend eintragen
.skip4
        tst.l   d0                      ;alles ok?
        bmi.s   .fehler                 ;nein

        tst.l   KomplettFlag            ;kompletten CompilerRun durchführen?
        bne.s   .ende                   ;ja

.compile
        bsr     compile                 ;und ausführen

        tst.l   CompileErrorFlag        ;alles ok?
        bne.s   .fehler                 ;nein

        move.w  #1,linked               ;Flag setzen
        clr.l   CommandoSetup           ;KommandoBits löschen
        moveq.l #0,d0                   ;melde alles okay
        bra.s   .ende
.fehler
        clr.w   linked                  ;Flags löschen
        clr.l   CommandoSetup
        moveq.l #-1,d0                  ;melde Fehler
.ende
        movem.l (a7)+,d1-d2/a0-a1
        rts

*--------------------------------------

blink_einstellen

        move.l  a1,-(a7)
        bsr     objfile_eintragen       ;Name eintragen
        move.l  a1,-(a7)

        move.l  4(a7),a1
        move.b  #32,(a1)

        move.l  (a7)+,a1
        move.b  #32,-2(a1)              ;Anführungszeichen löschen

        adda.l  #4,a7

        move.b  #"L",(a1)+              ;"LIB " anfügen
        move.b  #"I",(a1)+
        move.b  #"B",(a1)+
        move.b  #" ",(a1)+

        move.l  d0,d1                   ;d0 in d1 merken
        bsr     libs_eintragen          ;die Namen der Libraries anfügen
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        bsr     module_eintragen        ;die Namen der Module anfügen
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        bsr     linker_options_auswerten
                                        ;die Kennung für die Options eintragen
.ende
        move.b  #0,-(a1)                ;NullByte anfügen
        rts

*--------------------------------------

phxlnk_einstellen

        bsr     tmp_file_eintragen      ;Filename eintragen
        bsr     o_eintragen             ;".o" anfügen
        move.b  #" ",(a1)+              ;NullByte mit Space überschreiben

        move.l  d0,d1                   ;d0 in d1 merken

        bsr     module_eintragen        ;die Namen der Module anfügen
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        bsr     libs_eintragen          ;die Namen der Libraries anfügen
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        move.b  #"K",(a1)+              ;als Default Kickstart 1.x kompatibel
        move.b  #"1",(a1)+
        move.b  #" ",(a1)+

        bsr     linker_options_auswerten
                                        ;die Kennung für die Options eintragen
.ende
        move.b  #0,-(a1)
        rts

*--------------------------------------
* dlink dlib:c.o dlib:c.lib dlib:amiga.lib dlib:auto.lib dlib:x.o -o ram:foo

other_lnk_einstellen

        bsr     objfile_eintragen       ;Name eintragen

        move.l  d0,d1                   ;d0 in d1 merken
        bsr     libs_eintragen          ;die Namen der Libraries anfügen
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        bsr     module_eintragen        ;die Namen der Module anfügen
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        bsr     linker_options_auswerten
                                        ;die Kennung für die Options eintragen
.ende
        move.b  #0,-(a1)                ;NullByte anfügen
        rts

*--------------------------------------

libs_eintragen

        movem.l d1/a0,-(a7)

        bsr     lib_dir_eintragen

        lea     startup_lib_name,a0
        bsr     string_kopieren
        move.b  #" ",(a1)+

        bsr     lib_dir_eintragen

        lea     db_lib_name,a0
        bsr     string_kopieren
        move.b  #" ",(a1)+

        move.l  OptionsSetup,d1         ;hole die Flags
        moveq.l #other_lib,d0           ;Bittestregister initialisieren
.loop
        btst    d0,d1                   ;welche LinkerLib außer dem Standard?
        bne.s   .lib                    ;gefunden

        addq    #1,d0                   ;Register aufaddieren
        bra.s   .loop
.lib
        move.b  #34,(a1)+
        bsr     lib_dir_eintragen

        cmpi.b  #other_lib,d0           ;other LinkerLib gewählt?
        bne.s   .amiga                  ;nein

        move.l  _MemPtr,a0              ;zeige auf Configuration
        tst.b   other_lib_name(a0)      ;Eintrag vorhanden?
        bne.s   .other                  ;ja, vielleicht alles ok

        bsr     no_other_linkerlib_eingetragen
                                        ;Meldung ausgeben
        bra.s   .fehler                 ;und beenden
.other
        lea     other_lib_name(a0),a0   ;zeige auf Lib Namen
        bsr     string_kopieren         ;kopieren
        bra.s   .ok                     ;und beenden
.amiga
        cmpi.b  #amiga_lib,d0           ;amiga.lib gewählt?
        bne.s   .ami                    ;nein

        lea     amiga_lib_name,a0
        bsr     string_kopieren
        bra.s   .ok
.ami
        lea     ami_lib_name,a0
        bsr     string_kopieren
.ok
        move.b  #34,(a1)+
        move.b  #32,(a1)+
        moveq.l #0,d0
        bra.s   .ende
.fehler
        moveq.l #-1,d0                  ;melde "Fehler"
.ende
        movem.l (a7)+,d1/a0
        rts

*--------------------------------------

lib_dir_eintragen

        lea     default_lib_dir,a0
        bsr     string_kopieren
        rts

*--------------------------------------

module_eintragen

        tst.l   ModuleAnzahl            ;Array vorhanden?
        beq     .abort                  ;nein

        movem.l a0/a2,-(a7)

        move.l  _BufferPtr,a2           ;zur Berechnung der Größe => a2
        add.l   #BufferSize-80,a2       ;die Größe minus 1 Filenamen addieren

        move.l  ModuleAnzahl,d0         ;Anzahl => d0
        subq.l  #1,d0                   ;-1 da dbra bis -1 zählt
        move.l  _AvailableModule,a0     ;Zeige auf ModuleArray
.loop
        cmp.l   a1,a2                   ;Puffer schon voll?
        bpl.s   .bearbeiten             ;nein

        bsr     zu_viele_module         ;Meldung ausgeben
        moveq   #-1,d0                  ;melde Fehler
        bra.s   .ende                   ;und beenden

.bearbeiten
        tst.b   31(a0)                  ;wie steht das Flag?
        beq.s   .next                   ;nicht gewählt

        move.b  #34,(a1)+
        bsr     mod_dir_eintragen       ;zuerst den Dirnamen eintragen
        move.l  a0,-(a7)                ;Register retten
        bsr     string_kopieren         ;jetzt den Modulenamen
        move.b  #34,(a1)+
        move.l  (a7)+,a0                ;Register wieder herstellen
        move.b  #" ",(a1)+              ;Space anfügen
.next
        lea     FileSize(a0),a0         ;Ptr auf nächsten Namen eintragen
        dbra    d0,.loop

        moveq   #0,d0                   ;melde ok
.ende
        movem.l (a7)+,a0/a2
.abort
        rts

*--------------------------------------

mod_dir_eintragen

        movem.l d0-d1/a0,-(a7)

        move.w  #1,pruef_Flag
        move.l  a1,d1
        move.l  mod_dir,a0
        bsr     string_kopieren
        bsr     pruefe_den_dirnamen
        clr.w   pruef_Flag

        movem.l (a7)+,d0-d1/a0
        rts

*--------------------------------------

linker_options_auswerten

        cmpi.b  #lnk_other,d1           ;other Linker gewählt?
        beq.s   .other                  ;ja, nur die eingetragenen Options auswerten

        move.l  OptionsSetup,d0         ;OptionsSetup => d0
        btst    #linker_small_code,d0   ;gewählt?
        beq.s   .sd                     ;nein

        cmpi.b  #phxlnk,d1              ;PhxLnk gewählt?
        bne.s   .sc                     ;nein

        move.b  #"B",(a1)+              ;BLink kompatibel = Default
        move.b  #" ",(a1)+
.sc
        lea     small_code_string,a0    ;zeige auf String
        bsr     string_kopieren
        move.b  #" ",(a1)+              ;NullByte mit Space überschreiben
.sd
        btst    #linker_small_data,d0   ;gewählt?
        beq.s   .nodebug                ;nein

        lea     small_data_string,a0    ;zeige auf String
        bsr     string_kopieren
        move.b  #" ",(a1)+              ;NullByte mit Space überschreiben

.nodebug
        btst    #linker_no_debug,d0     ;gewählt?
        beq.s   .other                  ;nein

        lea     no_debug_string,a0      ;zeige auf String
        bsr     string_kopieren
        move.b  #" ",(a1)+              ;NullByte mit Space überschreiben

.other
        move.l  _MemPtr,a0              ;zeige auf die Konfiguration
        tst.b   linker_options(a0)      ;Eintrag vorhanden?
        beq.s   .ende                   ;nein

        lea     linker_options(a0),a0   ;zeige auf Eintrag
        bsr     string_kopieren         ;und alle eintragen
        move.b  #" ",(a1)+              ;NullByte mit Space überschreiben
.ende
        rts

*--------------------------------------

run_prg

        movem.l d0-d6/a0-a2,-(a7)

        bsr     make_program            ;kompilieren
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        move.l  #1,AsynchFlag           ;läuft asynchron
        bsr     program_ausfuehren      ;und ausführen
.ende
        movem.l (a7)+,d0-d6/a0-a2
        rts

*--------------------------------------

run_in_shell

        movem.l d0-d6/a0-a2,-(a7)

        bsr     make_program            ;kompilieren
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein

        move.l  a1,a2                   ;Zeiger auf Stringende übergeben
        bsr     cmd_string_eingabe_win  ;evtl. CmdString besorgen
        tst.l   d0                      ;geklappt?
        beq     .ende                   ;nein

        move.b  #0,(a1)
        move.l  #1,AsynchFlag           ;läuft asynchron
        bsr     program_ausfuehren      ;und ausführen
.ende
        movem.l (a7)+,d0-d6/a0-a2
        rts

*--------------------------------------

* => a1.l = Zeiger auf Stringende
* => d6.l = Zeiger auf Stringanfang

make_program

        bsr     make_exe                ;kompilieren
        tst.l   d0                      ;alles ok?
        bmi.s   .ende                   ;nein
.name
        lea     Dateiname,a1            ;zeige auf Namenspuffer
        move.l  a1,d6                   ;in d6 merken
        bsr     tmp_file_eintragen      ;kompletten Namen eintragen
.loop
        cmpi.b  #".",-(a1)              ;finde den Punkt
        bne.s   .loop

        move.b  #34,(a1)+
        move.b  #0,(a1)                 ;NullByte eintragen
.ende
        rts

*--------------------------------------

* >= d6.l = Zeiger auf CmdString
* => d0.l = Ergebnis von SystemTagList()

program_ausfuehren

        bsr     shell_win_oeffnen       ;Fenster öffnen
        move.l  d0,d3                   ;Handle merken
        bmi.s   .ende                   ;fehlgeschlagen

        tst.l   AsynchFlag              ;asynchron?
        bne.s   .asynch                 ;ja

        lea     run_tags,a1             ;nein
        bra.s   .handle                 ;und die Handles eintragen
.asynch
        lea     run_asynch_tags,a1      ;zeige auf Tagitems
.handle
        move.l  d3,12(a1)               ;Input Handle eintragen
        move.l  d6,d1                   ;CmdString in d1 übergeben
        move.l  a1,d2                   ;TagItems in d2 übergeben
        bsr     dos_system_taglist      ;ausführen

        tst.l   AsynchFlag              ;asynchron?
        bne.s   .ende                   ;ja, Window nicht schliessen

        move.l  d3,d1                   ;Handle => d1
        bsr     close_datei             ;CON:Window schliessen
.ende
        rts

*--------------------------------------
* cmd_eintragen
*
* >= d0.l = BitNr des Kommandos
* >= d1.l = BitAblageRegister für gesetzte Bits
*
* >= a1.l = Zeiger auf Stelle im Kommandofeld
*           wo der KommandoString eingetragen
*           werden soll.
*--------------------------------------

cmd_eintragen

        movem.l d0/a0/a2,-(a7)

        bset    d0,d1                   ;Bit setzen
        move.l  d1,CommandoSetup        ;KommandoBits eintragen
        lea     dos_cmd_txt_table,a0    ;zeige auf KommandoStringTabelle
        lsl.l   #2,d0                   ;* 4 da LangwortOffset
        move.l  0(a0,d0),a0             ;zeige auf KommandoString
        lea     dos_cmd_table,a2        ;zeige auf KommandoTabelle
        move.l  a1,0(a2,d0)             ;Zeiger auf Kommando eintragen

        bsr     string_kopieren         ;Kommando eintragen
        move.b  #" ",(a1)+              ;Space anfügen

        movem.l (a7)+,d0/a0/a2
        rts

*--------------------------------------
* adresse_einstellen
*
* >= a1.l = Adresse die auf das nächsten Langwort eingestellt werden soll
*
* => a1.l = Adresse auf das nächsten Langwort eingestellt
*--------------------------------------

adresse_einstellen

        move.l  d0,-(a7)

        move.l  a1,d0                   ;zum Bearbeiten => d0
        lsr.l   #1,d0                   ;dividiere durch 2, vergiss den Übertrag
        lsl.l   #1,d0                   ;multipliziere mal 2
        addq.l  #4,d0                   ;auf das nächste Langwort justieren
        move.l  d0,a1                   ;in a1 zurückgeben

        move.l  (a7)+,d0
        rts

*--------------------------------------

tmp_file_eintragen

        movem.l d0-d1/a0,-(a7)

        move.l  a1,d1                   ;Zeiger in d1 übergeben
        move.b  #34,(a1)+
        move.l  tmp_dir,a0              ;zeige auf den TempDirString
        bsr     string_kopieren         ;und eintragen
        move.w  #1,pruef_Flag           ;nur den FileNamen überprüfen
        bsr     pruefe_den_dirnamen     ;ROOT oder Unterdirectory?
                                        ;evtl. : oder / anfügen
        clr.w   pruef_Flag              ;Flag wieder löschen

        lea     source_filename,a0      ;zeige auf den FileNamen
        bsr     string_kopieren         ;und eintragen
        move.b  #34,(a1)+
        move.b  #0,(a1)

        movem.l (a7)+,d0-d1/a0
        rts

*--------------------------------------

beta_eintragen

        cmpi.b  #".",-(a1)              ;finde den Punkt
        bne.s   beta_eintragen

        tst.b   (a1)+                   ;stelle den Zeiger hinter den Punkt

        move.b  #"b",(a1)+              ;trage "beta" ein
        move.b  #"e",(a1)+              ;trage "beta" ein
        move.b  #"t",(a1)+              ;trage "beta" ein
        move.b  #"a",(a1)+              ;trage "beta" ein
        move.b  #34,(a1)+
        move.b  #0,(a1)                 ;NullByte anfügen

        rts

*--------------------------------------

b_eintragen

        cmpi.b  #".",-(a1)              ;finde den Punkt
        bne.s   b_eintragen

        tst.b   (a1)+                   ;stelle den Zeiger hinter den Punkt

        move.b  #"b",(a1)+              ;trage "b" ein
        move.b  #34,(a1)+
        move.b  #0,(a1)                 ;NullByte anfügen

        rts

*--------------------------------------

s_eintragen

        cmpi.b  #".",-(a1)              ;finde den Punkt
        bne.s   s_eintragen

        tst.b   (a1)+                   ;stelle den Zeiger hinter den Punkt

        move.b  #"s",(a1)+              ;trage "s" ein
        move.b  #34,(a1)+
        move.b  #0,(a1)                 ;NullByte anfügen

        rts

*--------------------------------------

opt_eintragen

        cmpi.b  #".",-(a1)              ;finde den Punkt
        bne.s   opt_eintragen

        move.b  #"_",(a1)+              ;trage "_opt" ein
        move.b  #"o",(a1)+
        move.b  #"p",(a1)+
        move.b  #"t",(a1)+
        move.b  #".",(a1)+              ;trage ".s" ein
        move.b  #"s",(a1)+
        move.b  #34,(a1)+               ;trage `"' ein
        move.b  #0,(a1)                 ;NullByte anfügen

        rts

*--------------------------------------

o_eintragen

        cmpi.b  #".",-(a1)              ;finde den Punkt
        bne.s   o_eintragen

        tst.b   (a1)+                   ;stelle den Zeiger hinter den Punkt

        move.b  #"o",(a1)+              ;trage "o" ein
        move.b  #34,(a1)+               ;trage `"' ein
        move.b  #0,(a1)                 ;NullByte anfügen

        rts

*--------------------------------------

sourcefile_ass_eintragen

        bsr     tmp_file_eintragen      ;Name eintragen

        move.l  MakeSetup,d0            ;Setup => d0
        btst    #superopt,d0            ;aktiv ?
        beq     .s                      ;nein

        bsr     opt_eintragen           ;ja, _opt.s versuchen
        bra.s   .space                  ;nun Space einfügen
.s
        bsr     s_eintragen             ;nein, SuperOptimizer nicht aktiv
.space
        move.b  #" ",(a1)+              ;NullByte mit Space überschreiben
        rts

*--------------------------------------

objfile_eintragen

        bsr     tmp_file_eintragen      ;Name eintragen
        bsr     o_eintragen             ;".o" anfügen
        move.b  #" ",(a1)+              ;NullByte mit Space überschreiben
        rts

*--------------------------------------

assembler_options_eintragen

        move.l  _MemPtr,a0              ;zeige auf Configuration
        tst.b   ass_options(a0)         ;Eintrag vorhanden?
        beq.s   .ende                   ;nein

        lea     ass_options(a0),a0      ;zeige auf Eintrag
        tst.b   -(a1)                   ;Zeiger korrigieren,
                                        ;die Null von "OPT 0" von PhxAss überschreiben
        bsr     string_kopieren         ;und eintragen
        move.b  #" ",(a1)+              ;NullByte mit Space überschreiben
.ende
        rts

*--------------------------------------

