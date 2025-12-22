; ResizingExample 1.4 (30-09-94)
; 
; SAS/C V6.51
;
; Copyright c 1994 , Carsten Ziegeler
;		     Augustin-Wibbelt-Str.8 , 33106 Paderborn, Deutschland
;
; Preassembler 1.24 / ASMONE 1.2 (1-12-94)
;
; Copyright c 1994 , Marius Schwarz
;		     Gesemannstr. 4 , 38226 Salzgitter , Deutschland
;
; BeispielSource fuer ListViewGadgets und Progressindicatorgadgets
;
; Anmerkungen :
;
; Der Sourcecode wurde korregiert,die Listviewlisten waren verkehrt.
; Anmerkung Includes: siehe GuideExample.p
;
	IncDir 	"sys:coder/"
	Include "preass/startrek.inc"
	Include "Preass/intuition.inc"	
	Include "LVO3.0/GuiEnv_lib.i"
	Include "include/guienv.i"
	Include "Include/Libraries/gadtools.i"

;---------------------------------------------------------------------------

	{* Start:START *}
	{* AutoLiban *}
	{* Delayaus *}

	{* IncVar: Guierror,Prg*}
	{* InitMinList: Alist,Clist*}
	{* IncSysBlock: Nodespeicher,280*}
	

dc.b 0,`$VER: Resizing Example 1.4 (1-12-94) V1.24`,$0a
dc.b   ` Preass v1.24`,0

even
start:

; Nodes Initaliesieren 
	
	lea ListviewAlabs,a4
	lea Listviewclabs,a3
	lea Nodespeicher,a5
.node1:	IF (a4)=#0 --> windowoeffnen
	move.l (a4)+,10(a5)
	Addtail(#Alist,a5)
	lea 14(a5),a5
	move.l (a3)+,10(a5)
	Addtail(#Clist,a5)
	lea 14(a5),a5
	bra .node1

windowoeffnen:
	window=openguiwindowA(50,50,300,150,"Test-Window",
	#IDCMP_gadgetUP!IDCMP_Closewindow!IDCMP_newsize!
	 IDCMP_REfreshwindow!IDCMP_VanillaKey!IDCMP_GadgetDown,
	#WFlg_Activate!WFlg_Sizegadget!WFlg_DepthGadget!
	 WFLG_Closegadget!WFLG_Dragbar,#0,
	 >Windowtags:WA_Minwidth,250|WA_MinHeight,120|WA_MAxwidth,500|
		     WA_MaxHeight,200|Tag_done,0)
	checkf window,.ende

; GuiInfoStruktur erstellen.

	gui=createguiinfoA(window,
	>GuiTaglist:Gui_creationfont,dosFalse|Gui_createerror,Guierror|
		    Tag_Done,0)

; Gadgets fuers erste Gui erstellen:

	CreateGUIgadgetA(gui,10,20,-10,-35,#GEG_ProgressIndicatorKind,
	>Gadget1tags:GEG_text,progress="Progress"|GEG_Flags,PlaceText_above|
		     GEG_Description,$21210101|Tag_Done,0)
	CreateGUIgadgetA(gui,10,10,70,18,#Button_Kind,
	>Gadget2tags:GEG_text,plus="_Plus"|GEG_Flags,PlaceText_in|
		     GEG_Description,$21050000|Tag_Done,0)
	CreateGUIgadgetA(gui,-80,10,70,18,#Button_Kind,
	>Gadget3tags:GEG_text,minus="_Minus"|GEG_Flags,PlaceText_in|
	 	     GEG_Description,$01050000|GEG_Objects,0|Tag_Done,0)

; Gui Darstellen

	report=drawguia(gui,#0)
	if report=#Ge_done --> .weiter
.fehler:GuiRequesta(gui,"Fehler!",#Ger_OKKind,#0)
	bra .free	
.weiter:WaitGuiMsg(gui)
	MsgClass=.l36(gui)
	MsgGadNbr=.w52(gui)
	if MsgClass=#IDcmp_CloseWindow --> .newgui
	if MsgClass=#IDCMP_GadgetUp    --> .next
	if MsgClass=#IDCMP_GadgetDown  --> .next Else .weiter
.next:		if MsgGadNbr=#1 --> .plus   ; Gadget = Plus dann Prg=Prg+1
		if MsgGadNbr=#2 --> .minus  ; Gedget nicht Minus dann Fehler
		bra .fehler
.minus:	if Prg>#0  --> .minus1 Else .weiter
.plus:	If prg<#10 --> .plus1 Else .weiter
.minus1:prg==prg--
	bra .aufbau
.Plus1:	prg==prg++
.aufbau:lea SetGadgettags,a0
	4(a0)==prg*10	; <<--- Man beachte den Adressmodus!!! :-)
	SetGuiGadgetA(gui,0,>SetGadgettags:GEG_PicurrentValue,0|
					   Tag_Done,0)
	bra .weiter

; Neues Gui aufbauen,dazu muss das Alte entfernt werden.

.newgui:
	Changegui(gui,>Changetags:Gui_removeGadgets,1|Tag_done,0)
	changegui(gui,
		>Changetags2:Gui_creationwidth,300|
			     Gui_CreationHeight,150|
			     Gui_PreserveWindow,Gui_PWFull|
			     Tag_Done,0)
	CreateGuiGadgeta(gui,20,-45,-20,13,#String_kind,
	>Gadget4tags:GEG_Description,$21010100|
		     Tag_Done,0)

	GuiGadgetinfo1=GetGuiGadgetA(gui,0,#GEG_Address)
	lea Gadget5tags,a0
	4(a0)==GuiGadgetInfo1
	CreateGuiGadgeta(gui,20,30,-20,-45,#Listview_kind,
	>Gadget5tags:GTLV_Showselected,0|
		     GEG_text,List="_List"|
		     GEG_Flags,Placetext_Above|
		     GEG_Description,$21210101|
		     GTLV_Labels,Alist|
		     Tag_Done,0)

	CreateGuiGadgeta(gui,20,10,70,18,#Button_kind,
	>Gadget6tags:GEG_text,Amigas="_Amigas"|
		     GEG_Flags,Placetext_in|
		     GEG_Description,$21050000|
		     Tag_Done,0)

	CreateGuiGadgeta(gui,-90,0,70,18,#Button_kind,
	>Gadget7tags:GEG_text,Cpus="_Cpus"|
		     GEG_Flags,Placetext_in|
		     GEG_Description,$01250000|
		     Tag_Done,0)
	
	CreateGuiGadgeta(gui,10,10,-10,-10,#GEG_Borderkind,
	>Gadget8tags:GEG_text,Bordertext="Choose something"|
		     GEG_Flags,PlaceText_above!NG_Highlabel|
		     GEG_Description,$21210101|
		     Tag_Done,0)
	

	report=drawguia(gui,#0)
	if report=#Ge_done --> .weiter2 Else .fehler 
.weiter2:
	WaitGuiMsg(gui)
	MsgClass=.l36(gui)
	MsgGadNbr=.w52(gui)
	if MsgClass=#IDCmp_CloseWindow --> .free
	if MSGClass=#IDCMP_Newsize --> .free
	if MsgClass=#IDCMP_GadgetUp    --> .next2
	if MsgClass=#IDCMP_GadgetDown  --> .next2 Else .weiter2
.next2:
	if MsgGadNbr=#2 --> .setAmiga
	if MsgGadNbr=#3 --> .setCpu Else .weiter2
.setamiga:
	SetGuiGadgetA(gui,1,
	>SetamigaGadgettags:GTLV_Labels,alist|
			    Tag_done,0)
	bra .weiter2
.setcpu:
	SetGuiGadgetA(gui,1,
	>SetcpuGadgettags:GTLV_Labels,clist|
			  Tag_done,0)
	bra .weiter2
.free:	freeguiinfo(gui)
	closeguiwindow(window)
.ende:	lea Alist,a5
RemoveAlist:
	RemTail(#Alist)
	cmpa.l 8(a5),a5
	bne removeAlist
	lea Clist,a5
RemoveClist:
	RemTail(#Clist)
	cmpa.l 8(a5),a5
	bne removeClist
	RTS
	
ListViewAlabs:	dc.l Amiga500,Amiga500p,Amiga600,Amiga1000,Amiga1200
		dc.l Amiga2000,Amiga3000,Amiga400030,Amiga400040
		dc.l AmigaXXXXyyy,0
ListViewClabs:  dc.l C8086,C80286,C80386,C80486,Pentium
		dc.l M68000,M68020,M68030,M68040,M68060,0

even
Amiga500:	dc.b `Amiga 500`,0
even
Amiga500p:	dc.b `Amiga 500+`,0
even
Amiga600:	dc.b `Amiga 600`,0
even
Amiga1000:	dc.b `Amiga 1000`,0
even
Amiga1200:	dc.b `Amiga 1200`,0
even
Amiga2000:	dc.b `Amiga 2000`,0
even
Amiga3000:	dc.b `Amiga 3000`,0
even
Amiga400030:	dc.b `Amiga 4000/30`,0
even
Amiga400040:	dc.b `Amiga 4000/40`,0
even
Amigaxxxxyyy:	dc.b `Amiga XXXX/YYY`,0
even
C8086:		dc.b `8086`,0
even
C80286:		dc.b `80286`,0
even
C80386:		dc.b `80386`,0
even
C80486:		dc.b `80486`,0
even
Pentium:	dc.b `Pentium`,0
even
M68000:		dc.b `68000`,0
even
M68020:		dc.b `68020`,0
even
M68030:		dc.b `68030`,0
even
M68040:		dc.b `68040`,0
even
M68060:		dc.b `68060`,0
even

