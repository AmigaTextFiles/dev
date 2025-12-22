
; BoopsiExample 1.4 (28-11-94)
; 
; SAS/C V6.51
;
; Copyright c 1994 , Carsten Ziegeler
;		     Augustin-Wibbelt-Str.8 , 33106 Paderborn, Deutschland
;
; Preassembler 1.24 / ASMONE 1.2 
;
; Copyright c 1994 , Marius Schwarz
;		     Gesemannstr. 4 , 38226 Salzgitter , Deutschland
;
; Beispielsource für BoopsiGadgets
;  

	IncDir 	"sys:coder/"
	Include "preass/startrek.inc"	 ; Sammelinclude (EXEC/DOS/INTUI)
        					 ; SammelLVO3.0  (EXEC/DOS/INTUI)
	Include "preass/intuition.inc"       ; Intuition include
	Include "LVO3.0/GuiEnv_lib.i"	 ; Offsets für GUIenv
	Include "include/guienv.i"  	 ; abgeändertes GUIenv.h Include
		        			 ; fuer ASMOne 1.2 (keine Structs)
	Include "Include/Libraries/gadtools.i"
					                 ; ASMone fähiges Include
	Include "include/intuition/icclass.i"
        					 ; siehe Gadtools.i
	
;---------------------------------------------------------------------------

	{* Start:START *}		        ; Ansprunglabel setzen
	{* AutoLiban *}			; Automatisches erstellen von
					                ; Openlibs,Closelibs & Startup.i
	{* Delayaus *}			; Beim Compilieren nicht warten

	{* IncVar: Guierror*}		; Erzeugte Variable GUIerror

dc.b 0,`$VER: BOOPSIEXample 1.4 (29.09.94) Preass version`,0

even
start:
; öffne Gui-Window
	window=openguiwindowA(50,50,150,150,"GUIENVIRONMENT - BOOPSIExample",
	#IDCMP_Closewindow!IDCMP_newsize!IDCMP_REfreshwindow,
	#WFlg_Activate!WFlg_Sizegadget!WFlg_DepthGadget!
	 WFLG_Closegadget!WFLG_Dragbar,0,
	 >Windowtags:WA_Minwidth,250|WA_MinHeight,120|WA_MAxwidth,500|
		         WA_MaxHeight,200|Tag_done,0)

	checkf window,.ende		        ; wenn Window = Dosfalse,ende
	Wbenchtofront()			; WorkBench nach vorn holen
	gui=createguiinfoA(window,>GuiTaglist:Gui_createerror,Guierror|Tag_Done,0)

; GuiInfoStuct erstellen
; Änderung zum Original:
; GUI_Creationfont nicht dabei!

; Proportional BoopsiGadget erstellen.
; Carsten hat auf jedweden Kommentar verzichtet,also nicht
; wundern ,wenns auch hier nichts gibt.
; GEG_Class ist ein Tag das einen Zeiger auf einen String
; haben möchte.Dieser String gibt die Klasse des Boopsis an.
; Nach zulesen in den Autodocs unter MAKECLASS().
; Neue Klassen müßen bei Commodore angemeldet werden.Ich frag
; mich nur wie ? Commodore gibts doch nicht mehr.
	
	CreateGUIgadgetA(gui,10,20,-10,-10,#GEG_BoopsipublicKind,
	>Gadget1tags:GEG_class,propgclass="propgclass"|
		     GEG_Description,$21210101|
		     ICA_Map,prop2intmap|
		     PGA_total,100|
		     PGA_Top,25|
		     PGA_Visible,10|
		     PGA_newlook,Dostrue|
		     Tag_Done,0)

; Die Tagliste des zweiten gadget will wissen wo das erste
; Gadget untergebracht ist.

	GuiGadgetinfo0=GETGuiGadgeta(gui,0,#geg_Address)

; Das Boopsigadget das hier erstellt wird,enthält später
; die Zahl,die das Propgadget hat.Anfangswert ist (s.o.)
; 25 (PGA_TOP).Maximal passen in das Stringgadget 3 Zeichen
; rein,StringA_Maxchars!,das Stringgadget ist laut
; GEG_Description ,jaja,leicht unüblich das Hexzahl anzugeben,
; aber das liegt daran,dass der Editor von ASMone nicht nach
; rechts scrollt und so die Zeile leicht eingeschraenkt ist,
; kann man nicht ändern,es sei den man nimmt nen Texteditor.
; Preass ist das übrigens egal,wie lang die Zeile ist.
; Na jedenfalls ist das Stringgadget immer 10 Pixel rechts vom
; Propgadget ,10 Pixel von der oberen Windowgrenze , 10 Pixel 
; von der rechten Windowrand und garantierte 18 Pixel Hoch.

	CreateGUIgadgetA(gui,10,10,-10,18,#GEG_BoopsipublicKind,
	>Gadget2tags:ICA_target,guigadgetinfo0|
		     GEG_class,strgclass="strgclass"|
		     GEG_Description,$05210100|
		     ICA_Map,int2propmap|
		     StringA_longval,25|
		     StringA_Maxchars,3|
		     Tag_Done,0)

; erstellen der Adresse des zweiten Gadgets.

	GuiGadgetinfo1=GETGuiGadgeta(gui,1,#geg_Address)

; Einfuegen der GuiGadgetinfo1 in die Tag-Liste von SETGUIGADGET()

	lea getgadget2tags,a0
	4(a0)==GuiGadgetinfo1

; Set.. erweitert die Angaben zum ersten Gadget,das muss auch
; wissen wo das Partner Gadget untergebracht ist.
; Was mich wundert ist,dass ICA_Target beim ersten die 
; Variable GUIGADGETinfo0 in der Tagliste akzeptiert ,
; aber bei der zweiten klappt das nicht!

	SetGuigadgeta(gui,0,>Getgadget2tags:ICA_target,1|
		  			    Tag_Done,0)
; Gui erstellen
	report=drawguia(gui,#0)
	if report=#Ge_done --> .weiter
; Vergleiche ob DrawGui erfolgreich war.
.fehler:GuiRequesta(gui,"Fehler!",#Ger_OKKind,#0) ; wars nicht!
	bra .free	
.weiter:WaitGuiMsg(gui)		; Handling des Gui und warten auf CLOSEW.
	MsgClass=.l36(gui)
	if MsgClass=#IDcmp_CloseWindow --> .free
	if MsgClass=#IDCMP_newsize     --> .fehler Else .weiter
.free:	freeguiinfo(gui)
	closeguiwindow(window)
.ende:	RTS

; Interne Umrechnungstabelle, fragt mich nicht wofür.

int2propmap:	dc.l Stringa_longVal,Pga_top,0
prop2intmap:	dc.l PGA_top,Stringa_longval,0

