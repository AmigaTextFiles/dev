*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Test code for debugging purpose
*

;fs "ConfirmQuit"
ConfirmQuit:
	 lea       cqtitle(pc),a0
	 lea       cqbody(pc),a1
	 lea       cqbut(pc),a2
	 lea       cqhook,a3
	 sub.l     a4,a4
	 bra       _Request
cqhook:
	 tst.b     d0
	 bne       _Quit
	 rts

cqtitle:
	 dc.b      "COUIN's request",0
cqbody:
	 dc.b      "Are you sure you want to quit ?",0
cqbut:
	 dc.b      "OK|Cancel",0
	 even
;fe

;fs "_About"
_About:
	 lea       abtitle(pc),a0
	 lea       abbody(pc),a1
	 lea       abbut(pc),a2
	 lea       abhook,a3
	 sub.l     a4,a4
	 bra       _Request
abhook:
	 subq.l    #1,d0
	 beq.s     _AboutCouin
	 subq.l    #1,d0
	 beq.s     _AboutCdBS
	 subq.l    #1,d0
	 beq.s     _Greetings
	 rts
abtitle:
	 dc.b      "About Kaliosis Quantrum",0
abbody:
	 dc.b      $9b,"=","Kaliosis Quantrum v",VERSION+"0",".",REVISION+"0"," ("
	 DATE
	 dc.b      ")",$a
	 dc.b      "©1997-1998, CdBS Software",$a
	 dc.b      "http://www.cdbssoftware.net",$a
	 dc.b      "e-mail : Kalio@CdBSSoftware.net",$a
	 dc.b      "IRC : #CdBS",$a,$a
	 dc.b      $9b,"-","Scenario & Design",$a
	 dc.b      "Sylve",$a
	 dc.b      "Toxico Nimbus",$a
	 dc.b      "Troll",$a
	 dc.b      "MORB",$a,$a
	 dc.b      $9b,"-","COUIN engine Code & Design",$a
	 dc.b      "MORB",$a,$a
	 dc.b      $9b,"-","Graphics",$a
	 dc.b      "Sylve",$a
	 dc.b      "Toxico Nimbus",$a,$a
	 dc.b      $9b,"-","Musics",$a
	 dc.b      "TiDeAF",$a
	 dc.b      "Rafo",$a,$a
	 dc.b      $9b,"-","Press relation",$a
	 dc.b      "OneVision",$a,0
abbut:
	 dc.b      "About COUIN|About CdBS|Greetings|Resume",0
	 even
;fe
;fs "_AboutCouin"
_AboutCouin:
	 lea       abctitle(pc),a0
	 lea       abcbody(pc),a1
	 lea       abcbut(pc),a2
	 sub.l     a3,a3
	 sub.l     a4,a4
	 bra       _Request

abctitle:
	 dc.b      "About COUIN",0
abcbody:
	 dc.b      "CdBSian Obviously Universal & Interactive Nonsense (COUIN)",$a
	 dc.b      "(Absurdité CdBSienne Manifestement Universelle et Interactive)",$a
	 dc.b      $9b,"-",$a
	 dc.b      "©1997-1998, CdBS Software",$a
	 dc.b      $9b,"-",$a
	 dc.b      "Prepre beta developpement version",0
abcbut:
	 dc.b      "OK",0
	 even
;fe
;fs "_AboutCdBS"
_AboutCdBS:
	 lea       abcstitle(pc),a0
	 lea       abcsbody(pc),a1
	 lea       abcsbut(pc),a2
	 lea       abcsh1(pc),a3
	 sub.l     a4,a4
	 bra       _Request

abcsh1:
	 tst.l     d0
	 beq.s     .Done

	 lea       abcstitle(pc),a0
	 lea       abcsbody2(pc),a1
	 lea       abcbut(pc),a2
	 sub.l     a3,a3
	 sub.l     a4,a4
	 bra       _Request
	 tst.l     d0
	 beq.s     .Done

.Done:
	 rts

abcstitle:
	 dc.b      "About CdBS",0
abcsbut:
	 dc.b      "More...|Resume",0
abcsbody:
	 dc.b      $9b,"=","CdBS Software",$a
	 dc.b      "http://www.cdbssoftware.net",$a
	 dc.b      "email: CdBS@CdBSSoftware.net, IRC: #CdBS",$a
	 dc.b      $9b,"=",$a
	 dc.b      "Members of CdBS Software are :",$a
	 dc.b      $9b,"-",$a
	 dc.b      "Toxico Nimbus (ToxN@CdBSSoftware.net) -- Project Manager",$a
	 dc.b      "http://www.cdbssoftware.net/toxn/",$a
	 dc.b      $9b,"-",$a
	 dc.b      "MORB (MORB@CdBSSoftware.net) -- Main coder",$a
	 dc.b      "http://www.cdbssoftware.net/morb/",$a
	 dc.b      $9b,"-",$a
	 dc.b      "Troll (Troll@CdBSSoftware.net) -- Coder",$a
	 dc.b      "http://www.cdbssoftware.net/troll/",$a
	 dc.b      $9b,"-",$a
	 dc.b      "Sylve -- Graphic artist",$a
	 dc.b      $9b,"-",$a
	 dc.b      "iO (iO@CdBSSoftware.net) -- Moral support ;)",$a
	 dc.b      $9b,"-",$a
	 dc.b      "El Phara (ElPhara@CdBSSoftware.net) -- Coder",$a
	 dc.b      $9b,"-",$a
	 dc.b      "Rafo (Rafo@CdBSSoftware.net) -- Musical artist",0


abcsbody2:
	 dc.b      "Members of CdBS Software (continued) :",$a

	 dc.b      $9b,"-",$a
	 dc.b      "TiDeAF (TiDeAF@CdBSSoftware.net) -- Musical and graphic artist",$a
	 dc.b      "http://www.mygale.org/~tideaf/",$a

	 dc.b      $9b,"-",$a
	 dc.b      "OneVision (OneVision@CdBSSoftware.net) -- Law manager",$a
	 dc.b      "and external relations",$a

	 dc.b      $9b,"-",$a
	 dc.b      "Mohic (Mohic@CdBSSoftware.net) -- Coder",$a
	 dc.b      $9b,"-",$a
	 dc.b      "Stc (Stc@CdBSSoftware.net) -- Coder",$a
	 dc.b      $9b,"-",$a
	 dc.b      "Exxos -- Graphic artist and PC Coder",$a
	 dc.b      $9b,"-",$a
	 dc.b      "Shiva (Shiva@CdBSSotware.net) -- Moral support & HP48 coder",$a
	 dc.b      $9b,"-",$a
	 dc.b      "Sarts -- Designer & Moral supporter",$a
	 dc.b      $9b,"-",$a
	 dc.b      "BestONE -- Pognon manager",$a
	 dc.b      $9b,"-",$a
	 dc.b      "Kaneda -- CMS chip burner",0
	 even
;fe
;fs "_Greetings"
_Greetings:
	 lea       gretitle(pc),a0
	 lea       grebody(pc),a1
	 lea       abcbut(pc),a2
	 sub.l     a3,a3
	 sub.l     a4,a4
	 bra       _Request

gretitle:
	 dc.b      "Greetings",0

grebody:
	 dc.b      $9b,"=","Greetings to all CdBS' gods",$a
	 dc.b      "iO, Mohic, El Phara, Exxos, Shiva,",$a
	 dc.b      "BestONE, Sarts, Kaneda, Stc",$a,$a
	 dc.b      $9b,"-","Greetings to all  those people",$a
	 dc.b      "Everybody at JANAL",$a
	 dc.b      "Everybody on surle.net",$a
	 dc.b      "Louis Garden, Christian, Daniel Tartavel,",$a
	 dc.b      "Pascal Marcelin, Samyl, Eric, Sanky, Markus, Bins",$a
	 dc.b      "and the others",$a
	 dc.b      $9b,"-",$a
	 dc.b      "Everybody on #artbas",$a
	 dc.b      "Kakace, Achille, Stan, Tcherno, Nico, Sammy, TH2A,",$a
	 dc.b      "OFS, Eric, Brice, Moonbeam, Shaman, FLYx, DeadX, Zapek",$a
	 dc.b      "and the others...",$a
	 dc.b      $9b,"-",$a
	 dc.b      "JF Fabre, MaxieZeus, Jan Vieten",$a
	 dc.b      "And all the others we forgot",$a,0
	 even
;fe

;fs "_NYI"
_NYI:
	 lea       NYITitle,a0
	 lea       NYIBody,a1
	 lea       NYIBut,a2
	 sub.l     a3,a3
	 sub.l     a4,a4
	 bra       _Request

NYITitle:
	 dc.b      "You just clicked on the bad button",0
NYIBody:
	 dc.b      "Sorry, this function is not yet implemented.",$a,$a
	 dc.b      "I remember you that it is a work in progress",$a
	 dc.b      "thing, as written in the 'About' section.",$a,$a
	 dc.b      "Don't cry anymore, COUIN will be completed one day.",$a,$a
	 dc.b      "So stop making me shit for a small useless function that doesn't",$a
	 dc.b      "work for now. It's incredible, you are never happy. Grûnt.",0
NYIBut:
	 dc.b      "Yes, I understand, please forgive me, you Great Coder.",0
	 even
;fe

;fs "Editor test"
_IConTest:
	 move.l    tgred,a0
	 lea       testcon,a2
	 DOMTDJI   CNM_PutS,a0

_EdVIncrTest:
	 move.l    tgred,a0
	 DOMTDJI   SAM_VIncr,a0

_CLeftTest:
	 move.l    tgred,a0
	 DOMTDJI   REM_MoveCursorLeft,a0

_CRightTest:
	 move.l    tgred,a0
	 DOMTDJI   REM_MoveCursorRight,a0

_CUpTest:
	 move.l    tgred,a0
	 DOMTDJI   REM_MoveCursorUp,a0

_CDownTest:
	 move.l    tgred,a0
	 DOMTDJI   REM_MoveCursorDown,a0

_ICharTest:
	 moveq     #$7f,d2
	 move.l    tgred,a0
	 DOMTDJI   REM_InsertChar,a0

	 moveq     #"A",d2
	 move.l    tgred,a2
	 DOMTDI    REM_InsertChar,a2
	 DOMTDI    REM_InsertChar,a2
	 DOMTDI    REM_InsertChar,a2
	 DOMTDI    REM_InsertChar,a2

	 moveq     #$a,d2
	 DOMTDI    REM_InsertChar,a2

	 moveq     #"B",d2
	 DOMTDI    REM_InsertChar,a2

	 moveq     #$a,d2
	 DOMTDJI   REM_InsertChar,a2

_DigBufTst:
	 move.l    tgred,a2
	 ;lea       abbody,a1
	 lea       testbuffer,a1
	 SDATALI   a1,REDT_Buffer,a2
	 DOMTDJI   REM_DigestBuffer,a2

testcon:
	 dc.b      "Grunt",$a,"> ",0

testbuffer:
	 dc.b      0
	 dc.b      $a
	 dc.b      "Kaliosis Quantrum v",VERSION+"0",".",REVISION+"0"," ("
	 DATE
	 dc.b      ")",$a
	 dc.b      "©1997-1998, CdBS Software",$a
	 dc.b      "http://www.asi.fr/~tartavel/CdBS/Home.html",$a
	 dc.b      "e-mail : morb@nef.surle.net or toxn@toxiczone.surle.net",$a,$a
	 dc.b      "Scenario & Design : Sylve & Toxico Nimbus",$a,$a
	 dc.b      "Graphics : Sylve",$a,$a
	 dc.b      "COUIN engine Code & Design : MORB",$a
	 dc.b      "Additional code : Troll",$a,$a
	 dc.b      "Scenaric Code & Map Design : Toxico Nimbus",$a,$a
	 dc.b      "Greetings to (in no particular order) :",$a,$a
	 dc.b      "Trollix (Menhirs rulez *87), "
	 dc.b      "Exxos, Kaneda, BestONE, Sarts, "
	 dc.b      "Les gens de chez JANAL (international), "
	 dc.b      "Les lobotomisés de chez Uto-Pic (FLYx, Samyl, & Marcel), "
	 dc.b      "ßouß/Popsy Team, ZIG, The Coca Cola Company, "
	 dc.b      "#AmyCoders, #Artbas, #AmigaRulezFr, "
	 dc.b      "Georges (Avec un S, il est plusieurs là-dedans), "
	 dc.b      "Pascal Marcelin, Christian, Daniel, L0ki, TH2A, Mohic, "
	 dc.b      "Io, Gogo, DJThunder, Maui, Bins, MoonBeam, Gérard 'Shaman' Cornu, "
	 dc.b      "Rafo, Raphael Guénot, et tout le monde surle.net...",0


	 ;rept      8
	 ;dc.b      "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF",$a,$a
	 ;endr
	 ;dc.b      "ENDENDENDENDENDENDENDENDENDENDENDENDENDENDENDEND",0

	 ;dc.b      "Buffer de test a la con",$a
	 ;dc.b      "pour editeur",$a
	 ;dc.b      "de texte",$a
	 ;dc.b      "Grunt paf",$a
	 ;dc.b      "Zlonka",$a
	 ;dc.b      "klonk couin",0
	 even
;fe
;fs "_GlubluTest"
_GlubluTest2
	 bra       _GlubluTest2
	 nop
_GlubluTest:
	 move.l    _CurrentGui,tgog

	 lea       _ggggTest(pc),a0
	 bra       _ChangeGui

tgog:
	 ds.l      1
tgouste:
	 move.l    tgog,a0
	 bra       _ChangeGui

_ggggTest:
	 GENTRY    _VGroup,0,0

	 GENTRY    _HGroup,0,0
	 GENTRY    _SmallButton,"X",tgouste
	 GENTRY    _SmallButton,"I",_Iconify
	 GENTRY    _DragBar,tb1,0
	 GEND

	 GENTRY    _HGroup,0,0
	 GENTRY    _ListView,tstlst,0,0,0,tl2
	 GENTRY    _ListView,tstlst,0,0,0,tl8
	 GENTRY    _ListView,tstlst,0,0,0,tlA
	 GEND

	 GENTRY    _HGroup,0,0
	 GENTRY    _Button,tb2,0
	 GENTRY    _Button,tb3,0
	 GENTRY    _Button,tb4,0
	 GENTRY    _Button,tb5,0
	 GENTRY    _Button,tb6,0
	 GENTRY    _Button,tb7,0
	 GEND

	 ;GENTRY    _Text,grotext,0,0,gagu

	 GENTRY    _HGroup,0,0
	 GENTRY    _HScroller,0,0,0,20,5
	 GENTRY    _Button,tb8,0
	 GENTRY    _Button,oomtxt,_OutOfMemory
	 GEND

	 GENTRY    _HProp,0,0,0,16,1

	 ;GENTRY    _Empty,0,0

	 GENTRY    _HGroup,0,0
	 GENTRY    _Button,tb2,0
	 GENTRY    _Button,tb3,0
	 GENTRY    _Button,tb5,0
	 GENTRY    _Button,tb7,0
	 GEND

	 GEND

tstlst:
	 dc.l      tl1
tltruc:
	 dc.l      0
	 dc.l      tlB

tl1:
	 dc.l      tl2,tstlst,tb1,1
tl2:
	 dc.l      tl3,tl1,tb2,1
tl3:
	 dc.l      tl4,tl2,tb3,2
tl4:
	 dc.l      tl5,tl3,tb4,2
tl5:
	 dc.l      tl6,tl4,tb5,1
tl6:
	 dc.l      tl7,tl5,tb6,1
tl7:
	 dc.l      tl8,tl6,tb7,2
tl8:
	 dc.l      tl9,tl7,tb8,2
tl9:
	 dc.l      tlA,tl8,tb9,2
tlA:
	 dc.l      tlB,tl9,tbA,1
tlB:
	 dc.l      tltruc,tlA,tbB,1

grotext:
	 dc.b      "Ceci n'est pas un texte monoligne  :^)",$a
	 dc.b      "La preuve",$a,$a
	 dc.b      "Il y en a plusieurs",$a
	 dc.b      "Et il y a même des %lx caractères %ld",$a
	 dc.b      "de formatage %ld.",0
	 even
gagu:
	 dc.l      $deadbeef,123,45
tb1:
	 dc.b      "COUIN's Gui de néssai. Klang.",0
tb2:
	 dc.b      "Couin",0
tb3:
	 dc.b      "Glonk glou",0
tb4:
	 dc.b      "Paf",0
tb5:
	 dc.b      "Schglubulu",0
tb6:
	 dc.b      "Ga",0
tb7:
	 dc.b      "Poupouf",0
tb8:
	 dc.b      "Beuark.",0
oomtxt:
	 dc.b      "OOM Test",0

tb9:
	 dc.b      "Shnorfl.",0
tbA:
	 dc.b      "Sgronk gnlionglub",0
tbB:
	 dc.b      "Gluibnlionglsgonkrank. Si.",0
	 even
;fe
;fs "_NewGuiTest"
ngtobj:
	 ds.l      1

_NewGuiTest:
	 lea       ntgui,a0
	 bsr       _OpenGui
	 ;rts
	 bsr       _DigBufTst
	 move.l    tgred,a2
	 DOMTDI    GCM_Layout,a2
	 DOMTDI    GCM_Clear,a2
	 DOMTDJI   GCM_Render,a2
;ngtExit:
tgred:
	 ds.l      1

ntgui:
	 dc.l      0

	 GUI
	   VGROUP

	     HGROUP
	       SMALLBTN  "X",_CloseGui,0
	       SMALLBTN  "I",_Iconify,0
	       DRAGBAR   ngtt
	     ENDOBJ

	     HGROUP

	       VGROUP
		 HGROUP
		   LISTVIEW  tstlst,tl3,0,0,0,1000
		   VKNOB
		   LISTVIEW  tstlst,0,0,0,0,1000
		 ENDOBJ

		 HKNOB
		 dc.l OBJ_Begin,_EditorClass
		 STOOBJ         tgred

		 BUTTON        edA,_IConTest,0

	       ENDOBJ

	       VKNOB

	       VGROUP
		 BUTTON   tb2,0,0
		 BUTTON   tb3,0,0
		 BUTTON   tb4,0,0
		 LISTVIEW tstlst,0,0,0,0,1000
		 ;HKNOB
		 ;dc.l  OBJ_Begin,_ScrollAreaClass
		 ;dc.l  SADT_HTotalNVS,640
		 ;dc.l  SADT_HTotalVS,640
		 ;dc.l  SADT_HVisibleNVS,1000
		 ;dc.l  SADT_HVisibleVS,500
		 ;dc.l  SADT_VTotalNVS,1512
		 ;dc.l  SADT_VTotalVS,1512
		 ;dc.l  SADT_VVisibleNHS,512
		 ;dc.l  SADT_VVisibleHS,500
		 ;ENDOBJ
		 BUTTON   tb5,0,0
		 BUTTON   tb6,0,0
		 BUTTON   tb7,0,0
	       ENDOBJ

	     VKNOB

	     VGROUP
	       FLOATTEXT grotext,gagu
	       HKNOB
	       LISTVIEW  tstlst,0,0,0,0,1000
	     ENDOBJ
	   ENDOBJ

	   HGROUP
	     HSCROLLR  1,17,1,0,0
	     VKNOB
	     HPROP     1,17,1,0,0
	   ENDOBJ

	   HGROUP
	     HSCROLLR  0,20,5,0,0
	     VKNOB
	     BUTTON    tb8,_GlubluTest,0
	     VKNOB
	     BUTTON    oomtxt,_OutOfMemory,0
	   ENDOBJ
	 ENDOBJ

ngtt:
	 dc.b      "New horrible gui test",0
reddb:
	 dc.b      "Digest buffer test",0
edleft:
	 dc.b      142,0
edright:
	 dc.b      141,0
edup:
	 dc.b      144,0
eddown:
	 dc.b      143,0
edA:
	 dc.b      "Insert test",0
edvit:
	 dc.b      "Increment VPos",0
	 even
;fe

;fs "_ReqTest"
_ReqTest:
	 lea       rttitle,a0
	 lea       rtbody,a1
	 lea       rtbut,a2
	 sub.l     a3,a3
	 sub.l     a4,a4
	 bra.s     _Request

rttitle:
	 dc.b      "COUIN's Requester de essai (sans vouloir me montrer pesant)",0
rtbody:
	 dc.b      "Ceci est un requester COUIN.",$a
	 dc.b      "Un requester d'essai.",$a
	 dc.b      "Avec un texte complètement inepte.",$a
	 dc.b      "Et un saut de ligne,",$a
	 dc.b      "pour faire style.",$a,$a
	 dc.b      "Je pourrais encore raconter des",$a
	 dc.b      "conneries longtemps, comme ça.",$a,$a
	 dc.b      "Et puis il y a une rangée de boutons",$a
	 dc.b      "en bas. Voilà. Paf.",0

rtbut:
	 dc.b      "Oui|Non|Probablement|Sans opinion|Peut-être|Je sais pas|Quoique",0
	 even
;fe
;fs "_FReqTest"
_FReqTest:
	 lea       TstFReq,a2
	 sub.l     a1,a1
	 lea       FRTHook,a1
	 bra.s     _FileRequest

FRTHook:
	 tst.l     d0
	 beq.s     .OuinX

	 lea       FRRTitle,a0
	 lea       FRRViviBody,a1
	 lea       FRRBut,a2
	 sub.l     a3,a3
	 move.l    #TFRPath,-(a7)
	 move.l    a7,a4
	 bsr       _Request
	 addq.l    #4,a7
	 rts

.OuinX:
	 lea       FRRTitle,a0
	 lea       FRROuinxBody,a1
	 lea       FRRBut,a2
	 sub.l     a3,a3
	 sub.l     a4,a4
	 bra       _Request


TstFReq:
	 dc.l      freqt
TFRPath:
	 dc.b      "sys:",0
	 ds.b      1024

freqt:
	 dc.b      "COUIN's File requester",0

FRRTitle:
	 dc.b      "It was the file requester of COUIN",0
FRRBut:
	 dc.b      "Gluuub.",0
FRROuinxBody:
	 dc.b      "You didn't select anything.",0
FRRViviBody:
	 dc.b      "There is the complete path of file that you selected :",$a
	 dc.b      "%s",0
	 even
;fe

;fs "_EditMonsters"
EdmLastGui:
	 ds.l      1
EdmState:
	 dc.b      0
	 even

_EditMonsters:
	 lea       Plf1,a5

	 move.l    _CurrentGui,EdmLastGui

	 lea       EdmHandler(pc),a0
	 move.l    a0,_PlayfieldClickHandler

	 lea       EdMGui(pc),a0
	 bra       _ChangeGui

ExitEdm:
	 clr.l     _PlayfieldClickHandler

	 move.l    EdmLastGui(pc),a0
	 bra       _ChangeGui

EdmHandler:
	 lsr.l     #1,d0

	 lea       Plf1(pc),a5
	 move.l    pf_X(a5),d2
	 lsr.l     #2,d2

	 add.l     d2,d0
	 add.l     pf_Y(a5),d1

	 movem.l   d0-1,TestSpr+12
	 movem.l   d0-1,sprpostruc

	 lea       Plf1SprH(pc),a4
	 lea       TestSpr(pc),a3

	 bsr       _DrawSprite

	 lea       Plf1(pc),a5
	 move.l    pf_WorkOfst(a5),d0
	 move.l    pf_RefreshPtrs(a5,d0.l),a0
	 moveq     #-1,d0
	 move.l    d0,2(a0)

	 tst.b     EdmState
	 bne.s     .WaitRelease

	 btst      #6,$bfe001
	 bne.s     .Done

	 st        EdmState
	 move.l    (AbsExecBase).w,a6
	 move.l    _ObjMemPool,a0
	 moveq     #sp_Size,d0
	 CALL      AllocPooled
	 lea       CustomBase,a6

.glou:
	 ;move.w    $dff006,d0
	 ;and.w     #$ff,d0
	 ;move.w    d0,$dff180
	 ;btst      #2,$dff016
	 ;bne.s     .glou

	 tst.l     d0
	 beq.s     .Done

	 move.l    d0,a0
	 lea       sp_Pos(a0),a1
	 lea       TestSpr+12(pc),a2
	 move.l    (a2)+,(a1)+
	 move.l    (a2)+,(a1)+
	 move.l    (a2),(a1)+
	 clr.l     (a1)+
	 lea       TestSpr(pc),a2
	 move.l    (a2)+,(a1)+
	 move.l    (a2)+,(a1)+
	 move.l    (a2),(a1)+
	 clr.l     (a1)

	 lea       Plf1(pc),a5
	 move.l    pf_Sprites(a5),a4
	 move.l    sh_First(a4),a1
	 move.l    a1,(a0)
	 move.l    a0,sh_First(a4)
	 move.l    a1,d0
	 beq.s     .Done
	 move.l    a0,sp_Prev(a1)

.Done:
	 rts

.WaitRelease:
	 btst      #6,$bfe001
	 beq.s     .Done
	 sf        EdmState
	 rts

EdMGui:
	 GENTRY    _VGroup,0,0

	 GENTRY    _HGroup,0,0
	 GENTRY    _SmallButton,"X",ExitEdm
	 GENTRY    _SmallButton,"I",_Iconify
	 GENTRY    _DragBar,EdmTitle,0
	 GEND

	 ;GENTRY    _Button,clrspr,_GuiClrSpr

	 ;GEND

	 GENTRY    _Selector,0,0
	 GENTRY    _Sprite,TestSprD,0
	 GENTRY    _Sprite,TestSprD,0
	 GENTRY    _Sprite,TestSprD,0
	 GENTRY    _Sprite,TestSprD,0
	 GENTRY    _Sprite,TestSprD,0
	 GENTRY    _Sprite,TestSprD,0
	 GENTRY    _Sprite,TestSprD,0
	 GENTRY    _Sprite,TestSprD,0
	 GEND

	 GEND

EdmTitle:
	 dc.b      "COUIN's Monsters editor",0
clrspr:
	 dc.b      "RefreshBuffer()",0
	 even
;fe

;fs "_ToggleWrap"
_ToggleWrap:
	 move.l    #$960000,Wcol1
	 move.l    #$960000,Wcol2

	 bchg      #0,_GameBplCon0+1
	 beq.s     .Done

	 move.l    #$1800500,Wcol1
	 move.l    #$1800005,Wcol2

.Done
	 rts
;fe

;fs "_ACTest"
BrusselSprout:
	 incbin    "BrusselSprout.bin"
	 even
_ACTest:
	 lea       BrusselSprout,a0
	 move.l    #$4c,d0
	 move.l    #$37,d1
	 bsr       _ACScanBitmap
	 lea       TestSprBm,a0
	 bsr       _ACCut
	 rts
;fe

;fs "Speed control"
_SetXSpeed:
	 move.l    d1,XSpeed
	 bra.s     SpdRefr

_SetYSpeed:
	 move.l    d1,YSpeed

SpdRefr:
	 move.l    a2,-(a7)
	 move.l    SpdTxtObj,a2
	 DOMTDI    GCM_Clear,a2
	 DOMTDI    GCM_Layout,a2
	 DOMTDI    GCM_Render,a2
	 move.l    (a7)+,a2
	 rts
spddats:
XSpeed:
	 dc.l      16
YSpeed:
	 dc.l      4
;fe

;fs "Test sprite structure"
TestSpr:
	 dc.l      0,0,0
	 dc.l      50,160
	 dc.l      TestSprD
sprpostruc:
	 dc.l      50,160
	 dc.l      TestSprD

TestSpr2:
	 dc.l      0,0,0
	 dc.l      50,100
	 dc.l      TestSprD
	 dc.l      50,100
	 dc.l      TestSprD

TestSprD:
	 dc.l      TestSprBm
	 dc.l      TestSprMsk
	 dc.l      2,22,33
	 dc.l      11,17

TestSprD2:
	 dc.l      TestSpr2Bm
	 dc.l      TestSpr2Msk
	 dc.l      3,46,38
	 dc.l      23,19
;fe

;fs "Test class"
	 CLASS     TestClass,RootClass
	 METHOD    TM_Gna
	 METHOD    TM_Gni

TestClass:
	 dc.l      0
	 dc.l      _RootClass
	 dc.l      0,0,0,0,0
	 dc.l      0
	 dc.l      TCFuncs
	 dc.l      0
	 dc.l      0
	 dc.l      0

TCFuncs:
	 dc.l      TCGni,TCGna,0

TCGni:
	 lea       TCTitle,a0
	 lea       TCGniBody,a1
	 lea       TCButs,a2
	 sub.l     a3,a3
	 bra.s     _Request
TCGna:
	 lea       TCTitle,a0
	 lea       TCGnaBody,a1
	 lea       TCButs,a2
	 sub.l     a3,a3
	 bra.s     _Request

TCTitle:
	 dc.b      "Test class message",0
TCButs:
	 dc.b      "I see",0
TCGnaBody:
	 dc.b      "Method 'Gna' invoked",0
TCGniBody:
	 dc.b      "Method 'Gni' invoked",0
	 even
;fe
;fs "_OOTest"
ootitle:
	 dc.b      "Object oriented routines test",0
newob:
	 dc.b      "New object",0
dispob:
	 dc.b      "Dispose object",0
gnamtd:
	 dc.b      "Do method Gna",0
gnimtd:
	 dc.b      "Do method Gni",0
addm:
	 dc.b      "Add new member",0
	 even

tstobj:
	 ds.l      1

_NewObj:
	 lea       TestClass,a0
	 sub.l     a1,a1
	 bsr.s     _NewObject
	 move.l    d0,tstobj
	 rts
_DispObj:
	 move.l    tstobj,a0
	 bra.s     _DisposeObject
_GnaMethod:
	 move.l    tstobj,a0
	 DOMTDJI   TM_Gna,a0
	 rts
_GniMethod:
	 move.l    tstobj,a0
	 DOMTDJI   TM_Gni,a0
_AddNew:
	 lea       TestClass,a0
	 sub.l     a1,a1
	 bsr.s     _NewObject
	 move.l    d0,a0
	 move.l    tstobj,a2
	 DOMTDJI   MTD_Add,a0

_OOTest:
	 lea       .OOGui(pc),a0
	 bra       _OpenGui

.OOGui:
	 dc.l      0

	 GUI

	 VGROUP

	 HGROUP
	 SMALLBTN  "X",_CloseGui,0
	 SMALLBTN  "I",_Iconify,0
	 DRAGBAR   ootitle
	 ENDOBJ

	 HGROUP
	 BUTTON    newob,_NewObj,0
	 BUTTON    dispob,_DispObj,0
	 BUTTON    gnamtd,_GnaMethod,0
	 BUTTON    gnimtd,_GniMethod,0
	 BUTTON    addm,_AddNew,0
	 ENDOBJ

	 ENDOBJ

	 ENDOBJ


;fe
;fs "_KBTest"
_KBTest:
	 lea       KBTBuf(pc),a2
.Loop:
	 bsr       _GetAsciiKey
	 tst.l     d0
	 bmi.s     .Ok
	 move.b    d0,(a2)+
	 bra.s     .Loop
.Ok:
	 clr.b     (a2)+

	 lea       kbttitle(pc),a0
	 lea       kbtbody(pc),a1
	 lea       kbtbut(pc),a2
	 sub.l     a3,a3
	 lea       kbtstream(pc),a4
	 bra.s     _Request
kbtstream:
	 dc.l      KBTBuf

kbttitle:
	 dc.b      "Keyboard routines test",0
kbtbody:
	 dc.b      "Contenu du buffer clavier :",$a
	 dc.b      "%s",0
kbtbut:
	 dc.b      "OK",0
	 even

KBTBuf:
	 ds.b      1024
;fe

;fs "_DebugMenu"
SpdTxtObj:
	 dc.l      0

_DebugMenu:
	 lea       .DBGui(pc),a0
	 jmp       _OpenGui

.DBGui:
	 dc.l      0
	 dc.l      OBJ_Begin,_GuiClass
	 dc.l      GDTA_ShownFlag,0

	 VGROUP

	 HGROUP
	 SMALLBTN  "X",ConfirmQuit,0
	 SMALLBTN  "I",_Iconify,0
	 DRAGBAR   tg1
	 ENDOBJ

	 HGROUP
	 BUTTON    testgui,_NewGuiTest,0
	 BUTTON    tstreq,_FReqTest,0
	 BUTTON    tstwrap,_ToggleWrap,0
	 ENDOBJ

	 HGROUP
	 ;BUTTON    guigrunt,_NewGuiTest,0
	 ;BUTTON    kbtst,_KBTest,0
	 BUTTON    tstac,_ACTest,0
	 BUTTON    maped,_MapEditor,0
	 BUTTON    testenmy,_EditMonsters,0
	 ENDOBJ

	 HGROUP
	 VGROUP
	 EMPTY
	 FIXEDTXT  xstxt,0
	 EMPTY
	 ENDOBJ
	 HPROP     16,65,1,_SetXSpeed,0
	 ENDOBJ

	 HGROUP
	 VGROUP
	 EMPTY
	 FIXEDTXT  ystxt,0
	 EMPTY
	 ENDOBJ
	 HPROP     4,17,1,_SetYSpeed,0
	 ENDOBJ

	 dc.l      OBJ_Begin,_TextClass
	 dc.l      TDTA_Text,spdtxt
	 dc.l      TDTA_FData,spddats
	 STOOBJ    SpdTxtObj

	 BUTTON    about,_About,0

	 ENDOBJ

	 ENDOBJ

tg1:
	 dc.b      "COUIN's Debug menu",0
testgui:
	 dc.b      "GUI test",0
testft:
	 dc.b      "Float text test",0
tstreq:
	 dc.b      "File requester test",0
tstwrap:
	 dc.b      "Show/hide wrap",0
tstac:
	 dc.b      "Autocrop test",0
maped:
	 dc.b      "Map editor",0
testenmy:
	 dc.b      "Edit monsters",0
xstxt:
	 dc.b      "X Speed :",0
ystxt:
	 dc.b      "Y Speed :",0
spdtxt:
	 dc.b      "Horizontal speed (X) : %ld/4 pixels/Vbl",$a
	 dc.b      "Vertical speed (Y) : %ld pixels/Vbl",0
about:
	 dc.b      "About",0
ootst:
	 dc.b      "OO Test",0
kbtst:
	 dc.b      "Keyboard Test",0
guigrunt:
	 dc.b      "New GUI Test",0
	 even
;fe

;fs "Shiva's stuff"
*It's green, super green.
*I say GREEN!!!!!!
;fe
