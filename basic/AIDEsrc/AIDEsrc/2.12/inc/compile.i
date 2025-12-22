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
* compile ©
*
* !Nur InputHandle benutzen! OutputHandle wird vom System gesetzt!
*
* Führt die entsprechenden Aktionen aus, um einen
* SourceCode zu kompilieren.
*
* Kein Übergaberegister, aber gesetzte Bits für auszuführende
* Kommandosequenz in CommandoSetup.
*
* Kein Rückgaberegister, aber Fehler in CompileErrorFlag gesetzt.
*--------------------------------------

compile

	movem.l d0-d7/a0-a3,-(a7)

	clr.l   CompileErrorFlag	;Flag löschen

	bsr     open_compile_win	;Fenster öffnen und Text ausgeben
	tst.l   d0      		;geklappt?
	beq     .ende   		;nein

	moveq.l #0,d7   		;Flag setzen = 1. Durchlauf

	bsr     con_win_oeffnen 	;Fenster öffnen
	move.l  d0,d6   		;Handle merken
	bmi     .close  		;fehlgeschlagen

	move.l  _MsgWinPtr,a0   	;Zeige auf MsgWin
	bsr     activate_window 	;wieder aktivieren

	move.l  #dos_tags,d2    	;Zeiger auf TagItems eintragen
	move.l  d2,a3   		;zum Eintragen der Handle => a3
	move.l  d6,12(a3)       	;Input Handle eintragen

.cmd_table
	lea     dos_cmd_table,a2	;zeige auf Cmd-Tabelle
	move.l  CommandoSetup,d3	;Setup => d3
	moveq.l #0,d4   		;Offsetzählregister initialisieren
	moveq.l #0,d5   		;Bittestregister initialisieren

.cmd_loop
	btst    d5,d3   		;Bit gesetzt = Kommando gewählt?
	beq.s   .next_cmd       	;nein

	move.l  d3,CompileErrorFlag     ;merken

	bclr    d5,d3   		;Bit löschen, Kommando angelaufen

	tst.l   d7      		;1. Durchlauf?
	beq.s   .cmd    		;ja

	bsr     compile_win_ausgabe     ;nächsten Text ausgeben und auf Msg prüfen
	tst.l   d0      		;Stop oder WindowClose gewählt?
	bne.s   .close  		;ja
.cmd
	addq    #1,d7   		;markiere nächsten Loop
	move.l  0(a2,d4),d1     	;Zeiger auf Kommando eintragen

	bsr     dos_system_taglist      ;Kommando ausführen

	tst.l   d0      		;alles ok?
	beq.s   .next_cmd       	;nein

.fehler
	bsr     compiler_error_msg      ;Meldung ausgeben
	bra.s   .close  		;und beenden

.next_cmd
	move.l  d3,CompileErrorFlag     ;merken
	tst.l   d3      		;alles erledigt?
	beq.s   .close  		;ja

	addq    #1,d5   		;Bittestregister aufaddieren
	addq    #4,d4   		;Offsetregister aufaddieren
	bra.s   .cmd_loop       	;nächstes Kommando ausführen
.close
	bsr     close_compile_win       ;Fenster schliessen

	move.l  d6,d1   		;Handle zum Schliessen => d1
	bmi.s   .ende   		;CON:Window nicht geöffnet

	bsr     close_datei     	;CON:Window schliessen

	tst.l   CompileErrorFlag	;Fehler?
	bne.s   .ende   		;ja, Requester nicht ausgeben

	bsr     compiler_run_ok 	;Okay-Meldung ausgeben
.ende
	movem.l (a7)+,d0-d7/a0-a3
	rts

*--------------------------------------
* open_compile_win ©
*
* kein Übergaberegister
*
* => d0.l <> 0 = alles ok = 0 dann Fenster nicht geöffnet
*--------------------------------------

open_compile_win

	movem.l d1-d7/a0-a2,-(a7)

	bsr     create_compilewin_gadget ;Stop-Gadget anlegen
	tst.l   d0      		;geklappt?
	beq.s   .ende   		;nein

	move.l  _CompileWinGadList,d0   ;Zeige auf GadgetListe in d0 übergeben

	move.l  _MainWinPtr,a0  	;hole dir die aktuelle Fensterposition
	move.w  wd_LeftEdge(a0),d1      ;Position des neuen Fensters entsprechend eintragen
	addi.w  #151,d1
	move.w  wd_TopEdge(a0),d2
	move.w  #280,d3
	move.w  #100,d4
	move.l  MsgWinFlags,d5  	;Flags eintragen
	move.l  MsgWinIDCMP,d6
	move.l  #_MsgWinTitle,d7

	bsr     open_msg_win    	;Fenster öffnen
	tst.l   d0      		;geklappt?
	beq.s   .ende   		;nein

	move.l  _MsgWinPtr,a0   	;WindowPtr => a0
	bsr     gt_refresh_window       ;auffrischen

	bsr.s   compile_win_image       ;Image ausgeben
.ende
	movem.l (a7)+,d1-d7/a0-a2
	rts

*--------------------------------------
* compile_win_image ©
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

compile_win_image

	movem.l d0-d7/a0-a3,-(a7)

	sub.l   a3,a3   		;Register löschen

	move.l  CommandoSetup,d3	;Setup => d3
	moveq.l #0,d4   		;Offsetzählregister initialisieren
	moveq.l #0,d5   		;Bittestregister initialisieren

	move.l  _MsgWinRPort,a0 	;RastPortPtr     => a0
	lea     Ausgabe_Ts,a1   	;IntuiTextStrPtr => a1
	lea     cmd_txt_table,a2	;zeige auf TextzeigerTabelle
	move.b  #01,0(a1)       	;Vordergrundfarbe eintragen
	move.b  #02,1(a1)       	;Hintergrundfarbe eintragen
	move.w  #11,4(a1)       	;LeftEdge
	move.w  #06,6(a1)       	;TopEdge
.loop
	btst    d5,d3   		;Bit gesetzt = Kommando gewählt?
	beq.s   .next   		;nein

	cmp.l   #0,a3   		;Adresse schon eingetragen?
	bne.s   .clear  		;ja

	move.l  0(a2,d4),a3     	;Zeiger auf 1. Text merken
.clear
	bclr    d5,d3   		;Bit löschen, Kommando angelaufen
	move.l  0(a2,d4),12(a1) 	;Zeiger auf Text eintragen
	bsr     print_i_text    	;ausgeben
	move.b  #00,1(a1)       	;Hintergrundfarbe eintragen
	add.w   #15,4(a1)       	;LeftEdge +15
	add.w   #11,6(a1)       	;TopEdge  +11
.next
	tst.l   d3      		;alles erledigt?
	beq.s   .ende   		;ja

	addq    #4,d4   		;Offsetregister aufaddieren
	addq    #1,d5   		;Bittestregister aufaddieren
	bra.s   .loop   		;nächsten Text ausgeben
.ende

* Anfangswerte wieder eintragen
*------------------------------
	move.w  #11,4(a1)       	;LeftEdge
	move.w  #06,6(a1)       	;TopEdge
	move.l  a3,12(a1)       	;Zeiger auf Text eintragen

	movem.l (a7)+,d0-d7/a0-a3
	rts

*--------------------------------------
* compile_win_ausgabe ©
*
* >= d5.l = aktuelle BitNr. des auszuführenden Kommandos
* und durch "compile_win_image" initialisierte IntuiTextStruktur.
*
* kein Rückgaberegister
*--------------------------------------

compile_win_ausgabe

	movem.l d1-d6/a0-a2,-(a7)

	move.l  d5,d6   		;aktuelle BitNr. merken

	moveq.l #0,d1   		;Flag setzen = ohne Wait
	bsr     msg_win_msg     	;evtl. Message abholen
	tst.l   d0      		;Stop oder WindowClose gewählt?
	bne.s   .ende   		;ja, beenden

	move.l  _MsgWinRPort,a0 	;RastPortPtr     => a0
	lea     Ausgabe_Ts,a1   	;IntuiTextStrPtr => a1
	lea     cmd_txt_table,a2	;zeige auf TextzeigerTabelle
	move.b  #3,1(a1)		;Hintergrundfarbe eintragen
	bsr     print_i_text    	;erledigten Text mit anderem Hintergrund ausgeben

	move.b  #02,1(a1)       	;Hintergrundfarbe eintragen
	add.w   #15,4(a1)       	;LeftEdge +15
	add.w   #11,6(a1)       	;TopEdge  +11
.textptr
	lsl.l   #2,d6   		;BitNr. * 4 = Offset auf Textadresse
	move.l  0(a2,d6.l),12(a1)       ;Zeiger auf Text eintragen

	bsr     print_i_text    	;ausgeben
.ende
	movem.l (a7)+,d1-d6/a0-a2
	rts

*--------------------------------------
* create_compilewin_gadget ©
*
* kein Übergaberegister
*
* => d0.l <> 0 = alles ok, = 0 dann Fehler
*--------------------------------------

create_compilewin_gadget

	movem.l d1-d4/a0-a4,-(a7)

	lea     _CompileWinGadList,a0   ;zeige auf Zeigerablage
	bsr     create_context  	;Gadget anlegen
	move.l  d0,d1   		;in d1 merken, geklappt?
	beq.s   .ende   		;nein

	lea     NewGad,a1       	;zeige auf NewGadgetStruktur
	move    #071,gng_TopEdge(a1)    ;Daten eintragen
	move    #005,gng_LeftEdge(a1)
	move    #262,gng_Width(a1)
	move    #012,gng_Height(a1)
	move    #000,gng_GadgetID(a1)
	move.l  #PLACETEXT_IN!NG_HIGHLABEL,gng_Flags(a1)

	lea     EnableTags,a2   	  ;zeige auf TagItems
	lea     _CompileWinGadgetTexte,a3 ;zeige auf TextZeigerTabelle
	lea     _CompileWinGadgetPtr,a4   ;zeige auf Zeigerablage
	moveq.l #0,d3   		;Offsetzählregister löschen, nur 1 Gadget
	bsr     button_kind     	;anlegen
	tst.l   d0      		;geklappt
	bne.s   .ende   		;ja

	bsr     no_gadtools_gadgets     ;nein, Fehlermeldung ausgeben
.ende
	movem.l (a7)+,d1-d4/a0-a4
	rts

*--------------------------------------
* close_compile_win ©
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

close_compile_win

	movem.l a0-a1,-(a7)

	move.l  _CompileWinGadList,a1   ;GadgetListPtr => a1
	bsr     close_msg_win   	;Fenster schließen

	exg     a0,a1   		;GadgetListPtr => a0
	bsr     free_gt_gadgets 	;und freigeben

	movem.l (a7)+,a0-a1
	rts

*--------------------------------------
