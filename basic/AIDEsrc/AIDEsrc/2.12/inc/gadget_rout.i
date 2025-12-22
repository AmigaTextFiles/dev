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
* gadgets_freigeben
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

gadgets_freigeben

	movem.l	d0-d1/a0-a1,-(a7)

* zuerst die GadToolsGadgets
*---------------------------
	moveq.l	#-1,d0			;-1 = am Ende anfügen
	moveq.l	#-1,d1			;-1 = alle
	move.l	_MainWinPtr,a0		;WindowPtr => a0
	move.l	_MainGadList,a1		;GadgetlistPtr übergeben
	bsr	add_g_list		;und ans Fenster binden

* dann die Intuition Gadgets
*---------------------------
	moveq.l	#-1,d0
	moveq.l	#-1,d1
	lea	Scroller,a1
	bsr	add_g_list

	movem.l	(a7)+,d0-d1/a0-a1
	rts
*--------------------------------------
* gadgets_sperren
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

gadgets_sperren

	movem.l	d0-d1/a0-a1,-(a7)

* zuerst die Intuition Gadgets
*-----------------------------
	moveq.l	#-1,d0			;-1 = alle
	move.l	_MainWinPtr,a0		;WindowPtr     => a0
	lea	Scroller,a1		;GadgetListPtr => a1
	bsr	remove_g_list		;entfernen

* dann die GadToolsGadgets
*-------------------------
	moveq.l	#-1,d0
	move.l	_MainGadList,a1
	bsr	remove_g_list

	movem.l	(a7)+,d0-d1/a0-a1
	rts
*--------------------------------------
* setup_gadgets_freigeben
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

setup_gadgets_freigeben

	movem.l	d0-d1/a0-a1,-(a7)

* zuerst die GadToolsGadgets
*---------------------------
	moveq.l	#-1,d0			;-1 = am Ende anfügen
	moveq.l	#-1,d1			;-1 = alle
	move.l	_SetupWinPtr,a0		;WindowPtr => a0
	move.l	_SetupGadList,a1	;GadgetlistPtr übergeben
	bsr	add_g_list		;und ans Fenster binden

* dann die Intuition Gadgets
*---------------------------
	moveq.l	#-1,d0
	moveq.l	#-1,d1
	lea	SetupStrGad01,a1
	bsr	add_g_list

	movem.l	(a7)+,d0-d1/a0-a1
	rts
*--------------------------------------
* setup_gadgets_sperren
*
* kein Übergaberegister
*
* kein Rückgaberegister
*--------------------------------------

setup_gadgets_sperren

	movem.l	d0-d1/a0-a1,-(a7)

* zuerst die Intuition Gadgets
*-----------------------------
	moveq.l	#-1,d0
	move.l	_SetupWinPtr,a0
	lea	SetupStrGad01,a1
	bsr	remove_g_list

* dann die GadToolsGadgets
*-------------------------
	moveq.l	#-1,d0
	move.l	_SetupGadList,a1
	bsr	remove_g_list

	movem.l	(a7)+,d0-d1/a0-a1
	rts
*--------------------------------------
* deactivate_gadgets
*
* >= d0.l = Startpositon
* >= d1.l = Anzahl der Gadgets
*
* kein Rückgaberegister
*--------------------------------------

deactivate_gadgets

	movem.l	d0-d1/a0-a4,-(a7)

	bsr	gadgets_freigeben	;müssen ans Fenster gebunden sein,
					;sonst Absturz

	lea	_Gadget_Ptr_MainWin,a4	;zeige auf Zeigerablage
	lsl.l	#2,d0			;* 4 da long
	subq	#1,d1			;-1, da dbra bis -1 zählt

	move.l	_MainWinPtr,a1		;WindowPtr => a1
	lea	DisableTags,a3		;TagItems  => a3
.loop1
	move.l	0(a4,d0),a0		;GadgetPtr => a0
	bsr	gt_set_gadget_attrs_a	;ändern

	addq	#4,d0			;Offset erhöhen
	dbra	d1,.loop1		;nächstes Gadget

	bsr	gadgets_sperren		;jetzt wieder entfernen,
					;wir sind noch nicht fertig

	movem.l	(a7)+,d0-d1/a0-a4
	rts
*--------------------------------------
* activate_gadgets
*
* >= d0.l = Startpositon
* >= d1.l = Anzahl der Gadgets
*
* kein Rückgaberegister
*--------------------------------------

activate_gadgets

	movem.l	d0-d1/a0-a4,-(a7)

	bsr	gadgets_freigeben	;müssen ans Fenster gebunden sein,
					;sonst Absturz

	lea	_Gadget_Ptr_MainWin,a4	;zeige auf Zeigerablage
	lsl.l	#2,d0			;* 4 da long
	subq	#1,d1			;-1, da dbra bis -1 zählt

	move.l	_MainWinPtr,a1		;WindowPtr => a1
	lea	EnableTags,a3		;TagItems  => a3
.loop1
	move.l	0(a4,d0),a0		;GadgetPtr => a0
	bsr	gt_set_gadget_attrs_a	;ändern

	addq	#4,d0			;Offset erhöhen
	dbra	d1,.loop1		;nächstes Gadget

	bsr	gadgets_sperren		;jetzt wieder entfernen, wir sind
					;noch nicht fertig

	movem.l	(a7)+,d0-d1/a0-a4
	rts
*--------------------------------------
* preco_gad_einstellen
*
* >= d0.l = ID Precompiler
*
* kein Rückgaberegister
*--------------------------------------

preco_gad_einstellen

	movem.l	d0-d1/a0-a4,-(a7)

	tst.l	_MainWinPtr		;Fenster schon offen?
	beq.s	.ende			;nein

	lea	MxTags,a3		;TagItems  => a3
	move.l	d0,12(a3)		;ID Precompiler eintragen

	move.l	_MainWinPtr,a1		;WindowPtr => a1
	lea	_Gadget_Ptr_MainWin,a4	;zeige auf Zeigerablage
	moveq.l	#48,d0			;Offset auf Zeiger => d0
	move.l	0(a4,d0),a0		;GadgetPtr => a0

	bsr	gadgets_freigeben

	bsr	gt_set_gadget_attrs_a

	bsr	gadgets_sperren
.ende
	movem.l	(a7)+,d0-d1/a0-a4
	rts
*--------------------------------------
* ass_gad_einstellen
*
* >= d0.l = ID Assembler
*
* kein Rückgaberegister
*--------------------------------------

ass_gad_einstellen

	movem.l	d0-d1/a0-a4,-(a7)

	tst.l	_MainWinPtr		;Fenster schon offen?
	beq.s	.ende			;nein

	lea	MxTags,a3		;TagItems  => a3
	move.l	d0,12(a3)		;ID Assembler eintragen

	move.l	_MainWinPtr,a1		;WindowPtr => a1
	lea	_Gadget_Ptr_MainWin,a4	;zeige auf Zeigerablage
	moveq	#96,d0			;Offset auf Zeiger => d0
	move.l	0(a4,d0),a0		;GadgetPtr => a0

	bsr	gadgets_freigeben

	bsr	gt_set_gadget_attrs_a

	bsr	gadgets_sperren
.ende
	movem.l	(a7)+,d0-d1/a0-a4
	rts
*--------------------------------------
* sopt_gad_einstellen
*
* kein Rückgaberegister
*--------------------------------------

sopt_gad_einstellen

	movem.l	d0-d1/a0-a4,-(a7)

	tst.l	_MainWinPtr		;Fenster schon offen?
	beq.s	.ende			;nein

	lea	CheckBoxTags,a3		;TagItems  => a3
	move.l	a3,a2			;zur Bearbeitung => a2
	bsr	get_superopt_status	;einstellen

	move.l	_MainWinPtr,a1		;WindowPtr => a1
	lea	_Gadget_Ptr_MainWin,a4	;zeige auf Zeigerablage
	moveq	#76,d0			;Offset auf Zeiger => d0
	move.l	0(a4,d0),a0		;GadgetPtr => a0

	bsr	gadgets_freigeben

	bsr	gt_set_gadget_attrs_a

	bsr	gadgets_sperren
.ende
	movem.l	(a7)+,d0-d1/a0-a4
	rts
*--------------------------------------
* aceopt_gads_einstellen
*
* kein Rückgaberegister
*--------------------------------------

aceopt_gads_einstellen

	movem.l	d0-d1/a0-a4,-(a7)

	tst.l	_MainWinPtr		;Fenster schon offen?
	beq.s	.ende			;nein

	lea	CheckBoxTags,a3		;TagItems  => a3
	move.l	a3,a2			;zur Bearbeitung => a2

	moveq	#52,d0			;Offset auf GadgetZeiger => d0
	moveq	#4,d2			;Bittestregister initialisieren
.loop
	bsr	get_ace_options		;einstellen

	move.l	_MainWinPtr,a1		;WindowPtr => a1
	lea	_Gadget_Ptr_MainWin,a4	;zeige auf Zeigerablage
	move.l	0(a4,d0),a0		;GadgetPtr => a0

	bsr	gadgets_freigeben

	bsr	gt_set_gadget_attrs_a

	bsr	gadgets_sperren

	addq	#4,d0			;Zeigeroffest erhöhen
	dbra	d2,.loop		;Bittestregister erniedrigen
.ende
	movem.l	(a7)+,d0-d1/a0-a4
	rts
*--------------------------------------
* assopt_gads_einstellen
*
* kein Rückgaberegister
*--------------------------------------

assopt_gads_einstellen

	movem.l	d0-d1/a0-a4,-(a7)

	tst.l	_MainWinPtr		;Fenster schon offen?
	beq.s	.ende			;nein

	lea	CheckBoxTags,a3		;TagItems  => a3
	move.l	a3,a2			;zur Bearbeitung => a2

	moveq	#100,d0			;Offset auf GadgetZeiger => d0
	moveq	#2,d2			;Bittestregister initialisieren
.loop
	bsr	get_assembler_options	;einstellen

	move.l	_MainWinPtr,a1		;WindowPtr => a1
	lea	_Gadget_Ptr_MainWin,a4	;zeige auf Zeigerablage
	move.l	0(a4,d0),a0		;GadgetPtr => a0

	bsr	gadgets_freigeben

	bsr	gt_set_gadget_attrs_a

	bsr	gadgets_sperren

	addq	#4,d0			;Zeigeroffest erhöhen
	dbra	d2,.loop		;Bittestregister erniedrigen
.ende
	movem.l	(a7)+,d0-d1/a0-a4
	rts
*--------------------------------------

lnklib_gad_einstellen

	movem.l	d0-d1/a0-a4,-(a7)

	tst.l	_MainWinPtr		;Fenster schon offen?
	beq.s	.ende			;nein

	lea	CycleTags,a3		;TagItems  => a3
	move.l	a3,a2			;zur Bearbeitung => a2
	bsr	get_linkerlibs		;einstellen

	move.l	_MainWinPtr,a1		;WindowPtr => a1
	lea	_Gadget_Ptr_MainWin,a4	;zeige auf Zeigerablage
	moveq	#116,d0			;Offset auf Zeiger => d0
	move.l	0(a4,d0),a0		;GadgetPtr => a0

	bsr	gadgets_freigeben

	bsr	gt_set_gadget_attrs_a

	bsr	gadgets_sperren
.ende
	movem.l	(a7)+,d0-d1/a0-a4
	rts
*--------------------------------------
* lnk_gad_einstellen
*
* >= d0.l = ID Linker
*
* kein Rückgaberegister
*--------------------------------------

lnk_gad_einstellen

	movem.l	d0-d1/a0-a4,-(a7)

	tst.l	_MainWinPtr		;Fenster schon offen?
	beq.s	.ende			;nein

	lea	MxTags,a3		;TagItems  => a3
	move.l	d0,12(a3)		;ID Assembler eintragen

	move.l	_MainWinPtr,a1		;WindowPtr => a1
	lea	_Gadget_Ptr_MainWin,a4	;zeige auf Zeigerablage
	moveq	#120,d0			;Offset auf Zeiger => d0
	move.l	0(a4,d0),a0		;GadgetPtr => a0

	bsr	gadgets_freigeben

	bsr	gt_set_gadget_attrs_a

	bsr	gadgets_sperren
.ende
	movem.l	(a7)+,d0-d1/a0-a4
	rts
*--------------------------------------
* lnkopt_gads_einstellen
*
* kein Rückgaberegister
*--------------------------------------

lnkopt_gads_einstellen

	movem.l	d0-d1/a0-a4,-(a7)

	tst.l	_MainWinPtr		;Fenster schon offen?
	beq.s	.ende			;nein

	lea	CheckBoxTags,a3		;TagItems  => a3
	move.l	a3,a2			;zur Bearbeitung => a2

	moveq	#124,d0			;Offset auf GadgetZeiger => d0
	moveq	#2,d2			;Bittestregister initialisieren
.loop
	bsr	get_linker_options	;einstellen

	move.l	_MainWinPtr,a1		;WindowPtr => a1
	lea	_Gadget_Ptr_MainWin,a4	;zeige auf Zeigerablage
	move.l	0(a4,d0),a0		;GadgetPtr => a0

	bsr	gadgets_freigeben

	bsr	gt_set_gadget_attrs_a

	bsr	gadgets_sperren

	addq	#4,d0			;Zeigeroffest erhöhen
	dbra	d2,.loop		;Bittestregister erniedrigen
.ende
	movem.l	(a7)+,d0-d1/a0-a4
	rts
*--------------------------------------
* >= a2.l = Zeiger auf TagItemListe
*--------------------------------------

get_preco

	movem.l	d0-d1,-(a7)

	bsr	get_preco_from_tooltypes
					;ToolTypeseintrag vorhanden?
	move.l	MakeSetup,d0		;Flag => d0
	moveq.l	#preco_other,d1		;Bittestregister initialisieren
.loop
	btst	d1,d0			;Bit gesetzt?
	bne.s	.setzen			;ja, es kann nur 1 Precompiler
					;gewählt werden

	dbra	d1,.loop		;auf nächstes Bit prüfen
.setzen
	move.l	d1,12(a2)		;Flag in TagItemListe eintragen

	movem.l	(a7)+,d0-d1
	rts
*--------------------------------------
* >= d2.l = Schleifenzähler (4 bis 0)
* >= a2.l = Zeiger auf TagItemListe
*--------------------------------------

get_ace_options

	movem.l	d0-d1,-(a7)

	move.l	OptionsSetup,d0		;Flag => d0
	btst	d2,d0			;teste Bit
	beq.s	.nicht_gesetzt		;nicht gesetzt

	move.l	#1,4(a2)		;gesetzt => Haken ausgeben
	bra.s	.ende			;und beenden

.nicht_gesetzt

	move.l	#0,4(a2)		;nicht gesetzt => Haken nicht ausgeben
.ende
	movem.l	(a7)+,d0-d1
	rts
*--------------------------------------
* >= a2.l = Zeiger auf TagItemListe
*--------------------------------------

get_superopt_status

	move.l	d0,-(a7)

	move.l	MakeSetup,d0		;Setup => d0
	btst	#superopt,d0		;aktiv ?
	beq.s	.nicht_gesetzt		;nein

	move.l	#1,4(a2)		;ja => Haken ausgeben
	bra.s	.ende			;und beenden

.nicht_gesetzt

	move.l	#0,4(a2)		;nein => Haken nicht ausgeben
.ende
	move.l	(a7)+,d0
	rts
*--------------------------------------
* >= a2.l = Zeiger auf TagItemListe
*--------------------------------------

get_assembler

	movem.l	d0-d1,-(a7)

	move.l	MakeSetup,d0		;Flag => d0
	moveq.l	#ass_other,d1		;Bittestregister initialisieren
.loop
	btst	d1,d0			;Bit gesetzt?
	bne.s	.setzen			;ja, es kann nur 1 Assembler gewählt werden

	dbra	d1,.loop		;auf nächstes Bit prüfen
.setzen
	subq	#a68k,d1		;für das Flag das A68K Bit subtrahieren
	move.l	d1,12(a2)		;Flag in TagItemListe eintragen

	movem.l	(a7)+,d0-d1
	rts
*--------------------------------------
* >= d2.l = Schleifenzähler (2 bis 0)
* >= a2.l = Zeiger auf TagItemListe
*--------------------------------------

get_assembler_options

	movem.l	d0-d1,-(a7)

	move.l	OptionsSetup,d0		;Flag => d0
	move.l	d2,d1			;zum Addieren => d1
	addq	#ass_debug_info,d1	;Bitoffset addieren
	btst	d1,d0			;teste Bit
	beq.s	.nicht_gesetzt		;nicht gesetzt

	move.l	#1,4(a2)		;gesetzt => Haken ausgeben
	bra.s	.ende			;und beenden

.nicht_gesetzt

	move.l	#0,4(a2)		;nicht gesetzt => Haken nicht ausgeben
.ende
	movem.l	(a7)+,d0-d1
	rts
*--------------------------------------
* >= a2.l = Zeiger auf TagItemListe
*--------------------------------------

get_linkerlibs

	movem.l	d0-d1,-(a7)

	move.l	OptionsSetup,d0		;Flag => d0
	moveq.l	#ami_lib,d1		;Bittestregister initialisieren
.loop
	btst	d1,d0			;Bit gesetzt?
	bne.s	.setzen			;ja, es kann nur 1 Linker Lib gewählt werden

	dbra	d1,.loop		;auf nächstes Bit prüfen
.setzen
	subi.w	#other_lib,d1		;für das Flag das other.lib Bit subtrahieren
	move.l	d1,12(a2)		;Flag in TagItemListe eintragen

	movem.l	(a7)+,d0-d1
	rts
*--------------------------------------
* >= a2.l = Zeiger auf TagItemListe
*--------------------------------------

get_linker

	movem.l	d0-d1,-(a7)

	move.l	MakeSetup,d0		;Flag => d0
	moveq.l	#lnk_other,d1		;Bittestregister initialisieren
.loop
	btst	d1,d0			;Bit gesetzt?
	bne.s	.setzen			;ja, es kann nur 1 Linker gewählt werden

	subq	#1,d1			;um 1 Bit erniedrigen
	cmpi.b	#blink-1,d1		;letztes LinkerBit geprüft?
	bne.s	.loop			;nein, auf nächstes Bit prüfen

.setzen
	cmpi.w	#blink-1,d1		;kein Bit gesetzt?
	bne.s	.eintragen		;nein

	bset	#blink,d0		;Bit für BLink setzen
	moveq.l	#blink,d1		;Flag für BLink setzen
	move.l	d0,MakeSetup		;Setup merken

.eintragen
	subi.w	#blink,d1		;für das Flag das BLink Bit subtrahieren
	move.l	d1,12(a2)		;Flag in TagItemListe eintragen

	movem.l	(a7)+,d0-d1
	rts
*--------------------------------------
* >= d2.l = Schleifenzähler (2 bis 0)
* >= a2.l = Zeiger auf TagItemListe
*--------------------------------------

get_linker_options

	movem.l	d0-d1,-(a7)

	move.l	OptionsSetup,d0		;Flag => d0
	move.l	d2,d1			;zum Addieren => d1
	addq	#linker_no_debug,d1	;Bitoffset addieren
	btst	d1,d0			;teste Bit
	beq.s	.nicht_gesetzt		;nicht gesetzt

	move.l	#1,4(a2)		;gesetzt => Haken ausgeben
	bra.s	.ende			;und beenden

.nicht_gesetzt

	move.l	#0,4(a2)		;nicht gesetzt => Haken nicht ausgeben
.ende
	movem.l	(a7)+,d0-d1
	rts
*--------------------------------------
activate_gads_new_source

	movem.l	d0-d1,-(a7)

	moveq.l	#1,d0			;Anfangsposition eintragen
	moveq.l	#3,d1			;3 Gadgets
	bsr	activate_gadgets	;und aktivieren

	bsr	pruefe_auf_editor	;Editor okay?
	tst.l	d0			;welches Ergebnis
	bpl.s	.next			;ja, Gadget nicht deaktivieren

	moveq.l	#2,d0			;Anfangsposition eintragen
	moveq.l	#1,d1			;das EditSource Gadget
	bsr	deactivate_gadgets	;und deaktivieren
.next
	moveq.l	#7,d0			;Anfangsposition eintragen
	moveq.l	#5,d1			;3 Gadgets
	bsr	activate_gadgets	;und aktivieren

	bsr	deactivate_compile_gad
	bsr	deactivate_assembler_gad
	bsr	deactivate_linker_gad
	bsr	deactivate_ace_error_gad

	movem.l	(a7)+,d0-d1
	rts
*--------------------------------------
deactivate_gads_no_source

	movem.l	d0-d1,-(a7)

	tst.w	source_set_Flag		;vorher Source gesetzt gewesen?
	beq.s	.view			;nein

	moveq.l	#1,d0			;Anfangsposition eintragen
	moveq.l	#11,d1			;11 Gadgets
	bsr	deactivate_gadgets	;und deaktivieren
.view
	moveq.l	#21,d0			;Anfangsposition eintragen (View Gadgets)
	moveq.l	#3,d1			;3 Gadgets
	bsr	deactivate_gadgets	;und deaktivieren

	movem.l	(a7)+,d0-d1
	rts
*--------------------------------------
activate_compile_gad

	movem.l	d0-d1,-(a7)

	moveq.l	#4,d0			;Anfangsposition eintragen
	moveq.l	#1,d1			;1 Gadget
	bsr	activate_gadgets	;und aktivieren

	bsr	pruefe_auf_viewer	;Viewer okay?
	tst.l	d0			;alles ok?
	bpl.s	.activate		;ja, Gadget aktivieren

	moveq.l	#21,d0			;Anfangsposition eintragen
	moveq.l	#1,d1			;das ViewPrecompiledSource Gadget
	bsr	deactivate_gadgets	;deaktivieren
	bra.s	.ende			;und beenden

.activate
	moveq.l	#21,d0			;Anfangsposition eintragen
	moveq.l	#1,d1			;1 Gadget
	bsr	activate_gadgets	;und aktivieren
.ende
	movem.l	(a7)+,d0-d1
	rts
*--------------------------------------
deactivate_compile_gad

	movem.l	d0-d1,-(a7)

	moveq.l	#4,d0			;Anfangsposition eintragen
	moveq.l	#1,d1			;1 Gadget
	bsr	deactivate_gadgets	;und aktivieren

	moveq.l	#21,d0			;Anfangsposition eintragen
	moveq.l	#1,d1			;1 Gadget
	bsr	deactivate_gadgets	;und aktivieren

	movem.l	(a7)+,d0-d1
	rts
*--------------------------------------
activate_assembler_gad

	movem.l	d0-d1,-(a7)

	moveq.l	#5,d0			;Anfangsposition eintragen
	moveq.l	#1,d1			;1 Gadget
	bsr	activate_gadgets	;und aktivieren

	bsr	pruefe_auf_viewer	;Viewer okay?
	tst.l	d0			;alles ok?
	bpl.s	.activate		;ja, Gadget aktivieren

	moveq.l	#22,d0			;Anfangsposition eintragen
	moveq.l	#1,d1			;das ViewAssemblerSource Gadget
	bsr	deactivate_gadgets	;deaktivieren
	bra.s	.ende			;und beenden

.activate
	moveq.l	#22,d0			;Anfangsposition eintragen
	moveq.l	#1,d1			;1 Gadget
	bsr	activate_gadgets	;und aktivieren
.ende
	movem.l	(a7)+,d0-d1
	rts
*--------------------------------------
deactivate_assembler_gad

	movem.l	d0-d1,-(a7)

	moveq.l	#5,d0			;Anfangsposition eintragen
	moveq.l	#1,d1			;1 Gadget
	bsr	deactivate_gadgets	;und aktivieren

	moveq.l	#22,d0			;Anfangsposition eintragen
	moveq.l	#1,d1			;1 Gadget
	bsr	deactivate_gadgets	;und aktivieren

	movem.l	(a7)+,d0-d1
	rts
*--------------------------------------
activate_ace_error_gad

	movem.l	d0-d1,-(a7)

	bsr	pruefe_auf_viewer	;Viewer okay?
	tst.l	d0			;alles ok?
	bmi.s	.ende			;nein, Gadget nicht aktivieren

	moveq.l	#23,d0			;Anfangsposition eintragen
	moveq.l	#1,d1			;1 Gadget
	bsr	activate_gadgets	;und aktivieren
.ende
	movem.l	(a7)+,d0-d1
	rts
*--------------------------------------
deactivate_ace_error_gad

	movem.l	d0-d1,-(a7)

	moveq.l	#23,d0			;Anfangsposition eintragen
	moveq.l	#1,d1			;1 Gadget
	bsr	deactivate_gadgets	;und deaktivieren

	movem.l	(a7)+,d0-d1
	rts
*--------------------------------------
activate_linker_gad

	movem.l	d0-d1,-(a7)

	moveq.l	#6,d0			;Anfangsposition eintragen
	moveq.l	#1,d1			;1 Gadget
	bsr	activate_gadgets	;und aktivieren

	movem.l	(a7)+,d0-d1
	rts
*--------------------------------------
deactivate_linker_gad

	movem.l	d0-d1,-(a7)

	moveq.l	#6,d0			;Anfangsposition eintragen
	moveq.l	#1,d1			;1 Gadget
	bsr	deactivate_gadgets	;und aktivieren

	movem.l	(a7)+,d0-d1
	rts
*--------------------------------------
activate_all_okay_gads

	bsr	activate_compile_gad
	bsr	activate_assembler_gad
	bsr	deactivate_ace_error_gad
	bsr	activate_linker_gad
	rts
*--------------------------------------
