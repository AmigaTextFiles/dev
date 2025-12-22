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
* create_gadgets
*
* Legt die GadToolsGadgetStrukturen für das Hauptwindow an.
*
* kein Übergaberegister
*
* => d0.l = 0 = Fehler, <> 0 = alles ok
*--------------------------------------

create_gadgets

	movem.l d1-d3/a0-a4,-(a7)

	lea     _MainGadList,a0 	;zeige auf Zeigerablage
	bsr     create_context  	;anlegen
	move.l  d0,d1   		;merken, geklappt?
	beq     .fehler 		;nein

	lea     NewGad,a1       	;zeige auf NewGadgetStruktur

* Source Button Gadgets
*----------------------
	lea     EnableTags,a2   	;zeige auf TagItems
	lea     _GadgetTexte,a3 	;zeige auf TextZeigerTabelle
	lea     _Gadget_Ptr_MainWin,a4  ;zeige auf GadgetPtrAblage

	moveq.l #0,d3   		;Offsetzählregister initialisieren

	move    #004,gng_TopEdge(a1)    ;Positionsdaten eintragen
	move    #110,gng_Width(a1)
	move    #010,gng_Height(a1)
	move    #000,gng_GadgetID(a1)

	move.l  #PLACETEXT_IN!NG_HIGHLABEL,gng_Flags(a1)
	moveq.l #2,d2   		;Gadgetzählregister initialisieren
	move    #05,gng_LeftEdge(a1)    ;bei 9 links anfangen
.loop1
	add     #11,gng_TopEdge(a1)     ;TopEdge +11
	bsr     button_kind     	;anlegen
	move.l  d0,d1   		;in d1 merken, geklappt?
	beq     .fehler 		;nein

	tst.l   source_fullname 	;schon ein Eintrag vorhanden (Start über ProjectIcon)?
	bne.s   .skip1  		;ja, Source Gadgets nicht disablen

	lea     DisableTags,a2  	;zeige auf TagItems
.skip1
	cmpi.w  #1,d2   		;EditSource Gadget erreicht?
	bne.s   .next   		;nein

	tst.l   editor  		;Editor angegeben?
	beq.s   .disable_edit   	;nein

	move.l  d1,-(a7)		;d1 retten
	move.l  editor,d1       	;zeige auf den Namen
	bsr     pruefe_den_filenamen    ;gibt es den?
	move.l  (a7)+,d1		;d1 wieder herstellen
	tst.l   d0      		;alles ok?
	bpl.s   .next   		;ja, Gadget nicht deaktivieren

.disable_edit
	lea     DisableTags,a2  	;zeige auf TagItems
.next
	dbra    d2,.loop1

* Program Button Gadgets
*-----------------------
	add     #15,gng_TopEdge(a1)     ;TopEdge +15
	moveq.l #5,d2   		;5 Gadgets
.loop2
	tst.l   source_fullname 	;schon ein Eintrag vorhanden (Start über ProjectIcon)?
	bne.s   .enable 		;ja, 1. Program Gadgets nicht disablen

.disable
	lea     DisableTags,a2  	;zeige auf TagItems
	bra.s   .make_gadgets

.enable
	lea     EnableTags,a2

	cmpi    #1,d2   		;Run und Run in Shell nicht disablen
	ble     .make_gadgets

	cmpi    #4,d2   		;schon bearbeitet?
	ble     .disable		;ja

.make_gadgets
	add     #11,gng_TopEdge(a1)
	bsr     button_kind
	move.l  d0,d1
	beq     .fehler
	dbra    d2,.loop2

* Make Button Gadgets
*--------------------
	lea     EnableTags,a2

	tst.l   source_fullname 	;schon ein Eintrag vorhanden (Start über ProjectIcon)?
	bne.s   .skip3  		;ja, Make Gadgets nicht disablen

	lea     DisableTags,a2  	;zeige auf TagItems
.skip3
	add     #15,gng_TopEdge(a1)
	moveq.l #2,d2
.loop3
	add     #11,gng_TopEdge(a1)
	bsr     button_kind
	move.l  d0,d1
	beq     .fehler
	dbra    d2,.loop3

* Precompiler Mx Gadget
*----------------------
	move    #125,gng_LeftEdge(a1)   ;bei 129 links weitermachen
	move    #015,gng_TopEdge(a1)    ;wieder auf Zeile 26 setzen
	move.l  #PLACETEXT_RIGHT!NG_HIGHLABEL,gng_Flags(a1)
	lea     MxTags,a2       	;zeige auf TagitemStruktur

	bsr     get_preco_from_tooltypes
	bsr     get_preco       	;welcher Precompiler

	move.l  #_MxGadTexte_pre,4(a2)  ;Zeiger auf TextPtrTabelle eintragen
	move.l  #2,20(a2)       	;2 Zeilen Abstand zwischen den Gadgets
	bsr     mx_kind 		;anlegen
	move.l  d0,d1   		;merken, geklappt?
	beq     .fehler 		;nein

* ACE Options CheckBox Gadgets
*-----------------------------
	lea     CheckBoxTags,a2
	add     #36,gng_TopEdge(a1)
	sub     #4,gng_LeftEdge(a1)
	moveq.l #4,d2
.loop4
	bsr     get_ace_options
	add     #12,gng_TopEdge(a1)
	bsr     checkbox_kind
	move.l  d0,d1
	beq     .fehler
	dbra    d2,.loop4

* ACE Options "other" button
*---------------------------
	lea     EnableTags,a2
	move.l  #PLACETEXT_IN!NG_HIGHLABEL,gng_Flags(a1)
	add     #12,gng_TopEdge(a1)
	move    #012,gng_Height(a1)
	move    #124,gng_Width(a1)
	bsr     button_kind
	move.l  d0,d1
	beq     .fehler

* SuperOptimizer CheckBox Gadget
*-------------------------------
	lea     CheckBoxTags,a2

	bsr     get_superopt_status

	move.l  #PLACETEXT_RIGHT!NG_HIGHLABEL,gng_Flags(a1)
	add     #29,gng_TopEdge(a1)
	bsr     checkbox_kind
	move.l  d0,d1
	beq     .fehler

* SuperOptimizer Button Gadget
*-----------------------------
	move.l  #PLACETEXT_IN!NG_HIGHLABEL,gng_Flags(a1)
	add     #12,gng_TopEdge(a1)
	bsr     button_kind
	move.l  d0,d1
	beq     .fehler

* View Button Gadgets
*--------------------
	lea     DisableTags,a2
	move    #004,gng_TopEdge(a1)
	move    #126,gng_Width(a1)
	move    #010,gng_Height(a1)
	move    #251,gng_LeftEdge(a1)
	moveq.l #2,d2
.loop5
	add     #11,gng_TopEdge(a1)
	bsr     button_kind
	move.l  d0,d1
	beq     .fehler
	dbra    d2,.loop5

* Assembler Mx Gadget
*--------------------
	add     #26,gng_TopEdge(a1)
	move.l  #PLACETEXT_RIGHT!NG_HIGHLABEL,gng_Flags(a1)
	add     #4,gng_LeftEdge(a1)
	lea     MxTags,a2

	bsr     get_assembler

	move.l  #_MxGadTexte_ass,4(a2)
	move.l  #2,20(a2)
	bsr     mx_kind
	move.l  d0,d1
	beq     .fehler

* Assembler CheckBox Gadgets
*---------------------------
	lea     CheckBoxTags,a2
	add     #21,gng_TopEdge(a1)
	sub     #4,gng_LeftEdge(a1)
	moveq.l #2,d2
.loop6
	bsr     get_assembler_options

	add     #12,gng_TopEdge(a1)
	bsr     checkbox_kind
	move.l  d0,d1
	beq     .fehler
	dbra    d2,.loop6

* Assembler "Set Options" Button
*-------------------------------
	lea     EnableTags,a2
	move.l  #PLACETEXT_IN!NG_HIGHLABEL,gng_Flags(a1)
	add     #12,gng_TopEdge(a1)
	move    #12,gng_Height(a1)
	bsr     button_kind
	move.l  d0,d1
	beq     .fehler

* Linker Lib Cycle Gadget
*------------------------
	add     #28,gng_TopEdge(a1)
	move    #16,gng_Height(a1)
	lea     CycleTags,a2

	bsr     get_linkerlibs

	move.l  #_MxGadTexte_lnklib,4(a2)
	bsr     cycle_kind
	move.l  d0,d1
	beq     .fehler

* Linker Mx Gadget
*-----------------
	move    #015,gng_TopEdge(a1)
	move    #110,gng_Width(a1)
	move    #010,gng_Height(a1)
	move    #387,gng_LeftEdge(a1)
	move.l  #PLACETEXT_RIGHT!NG_HIGHLABEL,gng_Flags(a1)
	lea     MxTags,a2

	bsr     get_linker

	move.l  #_MxGadTexte_lnk,4(a2)
	move.l  #3,20(a2)
	bsr     mx_kind
	move.l  d0,d1
	beq     .fehler

* Linker CheckBox Gadgets
*------------------------
	lea     CheckBoxTags,a2
	add     #69,gng_LeftEdge(a1)
	sub     #12,gng_TopEdge(a1)
	moveq.l #2,d2
.loop7
	bsr     get_linker_options

	add     #12,gng_TopEdge(a1)
	bsr     checkbox_kind
	move.l  d0,d1
	beq     .fehler
	dbra    d2,.loop7

* Linker "Set Options" Button
*----------------------------
	lea     EnableTags,a2
	move.l  #PLACETEXT_IN!NG_HIGHLABEL,gng_Flags(a1)
	sub     #072,gng_LeftEdge(a1)
	add     #012,gng_TopEdge(a1)
	move    #010,gng_Height(a1)
	move    #184,gng_Width(a1)
	bsr     button_kind
	move.l  d0,d1
	beq     .fehler

* Linker Module "Remove all Modules" Button
*------------------------------------------
	add     #003,gng_LeftEdge(a1)
	add     #114,gng_TopEdge(a1)
	move    #178,gng_Width(a1)
	move.l  #PLACETEXT_IN!NG_HIGHLABEL,gng_Flags(a1)
	move    #10,gng_Height(a1)
	bsr     button_kind
	tst.l   d0
	bne.s   .ende
.fehler
	move.l  _MainGadList,a0 		;GadgetListPtr => a0
	bsr     free_gt_gadgets 		;freigeben
	clr.l   _MainGadList    		;Ptr löschen
	bsr     no_gadtools_gadgets     	;Fehlermeldung ausgeben
	moveq   #0,d0   			;Fehler melden
.ende
	movem.l (a7)+,d1-d3/a0-a4
	rts
*--------------------------------------
