/* MemFree inspriré de gadtoolsdemo.e et avail.e */
/*************************************************/
/* V0.0a - Version initiale			 */
/* V0.0b - Ajout de Delay et Pubscreen		 */
/* v0.0c - Ajout de Front			 */
/* v0.0d - Ajout d'un port Arexx                 */
/*	   Commandes Arexx:			 */
/*	   - QUIT/BACK/FRONT/NOFRONT/YESFRONT/	 */
/*	     FAST/CHIP/CHANGEPS <nompubscreen>/  */
/*	     NEWDELAY <delay>/FASTCHIP/ZIP	 */
/* v0.0e - Ajout de menus et utilisation de la	 */
/*	   reqtools.library.			 */
/*************************************************/

ENUM NONE,ER_OPENLIB,ER_WB,ER_VISUAL,ER_CONTEXT,ER_GADGET,ER_WINDOW,ER_MENUS,
     ER_BADARGS,ER_REXXPORT,ER_SIG
ENUM ARG_DELAY,ARG_PS,ARG_FRONT,NUMARGS

MODULE 'intuition/intuition', 'gadtools', 'libraries/gadtools',
       'intuition/gadgetclass', 'exec/nodes', 'intuition/screens'
MODULE 'exec/execbase','exec/lists','workbench/startup',
       'exec/libraries','exec/tasks', 'exec/ports',
       'intuition/intuitionbase'
MODULE 'icon','wb','workbench/workbench'
MODULE 'rexxsyslib','rexx/storage'
MODULE 'reqtools','libraries/reqtools','utility/tagitem'

MODULE 'exec/execbase'
MODULE 'graphics/text'


ENUM CHIP,FAST

CONST GFXOFFSET=40, BUFSIZE=GADGETSIZE*5

DEF scr=NIL:PTR TO screen,
    visual=NIL,
    wnd=NIL:PTR TO window,
    wndmp:PTR TO mp,
    glist=NIL,offy,g,
    type,infos,menu,gad,def_gad

DEF base:PTR TO execbase,x:PTR TO LONG

DEF rdargs=NIL
DEF wb:PTR TO wbstartup,wb_args:PTR TO wbarg
DEF pubscreen[256]:STRING,delay,screen[256]:STRING
DEF struc_diskobj:PTR TO diskobject,nom_prg[50]:STRING
DEF version[50]:STRING,front
DEF myport:PTR TO mp,data_port:PTR TO ln,test_port
DEF zipped=FALSE,zip_piv
DEF tattr
PROC main()
  DEF cli_args[NUMARGS]:LIST,templ,x,r_quit
  DEF sig
  StrCopy(version,'$VER:\e[;32mMemFree\e[;0m v0.0e \e[;32m(\e[;33mc\e[;32m) Na\e[;33msG\e[;0mûl (10-Nov-93).',ALL)
  base:=execbase  /* For Virus D */
  IF (sig:=AllocSignal(-1))=NIL THEN checkerror(ER_SIG)
  IF wbmessage=NIL
      FOR x:=0 TO NUMARGS-1 DO cli_args[x]:=0
      templ:='D=DELAY,PS/K,FRONT/S'
      rdargs:=ReadArgs(templ,cli_args,NIL)
      IF rdargs=NIL THEN checkerror(ER_BADARGS)
      delay:=Val(cli_args[ARG_DELAY],NIL)
      IF delay=0 THEN delay:=10
      front:=cli_args[ARG_FRONT]
      IF cli_args[ARG_PS]
	  StrCopy(pubscreen,cli_args[ARG_PS],ALL)
      ELSE
	  StrCopy(pubscreen,'Workbench',ALL)
      ENDIF
  ELSE
      IF (iconbase:=OpenLibrary('icon.library',37))=NIL THEN RETURN ER_OPENLIB
      wb:=wbmessage
      wb_args:=wb.arglist
      CurrentDir(wb_args[0].lock)
      StrCopy(nom_prg,wb_args[0].name,ALL)
      struc_diskobj:=GetDiskObject(wb_args[0].name)
      delay:=Val(FindToolType(struc_diskobj.tooltypes,'DELAY'),NIL)
      IF delay=0 THEN delay:=10
      screen:=FindToolType(struc_diskobj.tooltypes,'PS')
      IF screen=0
	  StrCopy(pubscreen,'Workbench',ALL)
      ELSE
	  StrCopy(pubscreen,screen,ALL)
      ENDIF
      front:=FindToolType(struc_diskobj.tooltypes,'FRONT')
      IF StrCmp(front,'TRUE',ALL)
	  front:=TRUE
      ELSE
	  front:=FALSE
      ENDIF
  ENDIF
  checkerror(initinterface())
  checkerror(openinterface())
  REPEAT
    wait4message()
    IF type=IDCMP_CLOSEWINDOW
	r_quit:=RtEZRequestA('      (c) 1993 By NasGûl\n      ~~~~~~~~~~~~~~~~~~\nVoulez-vous vraiment Quitter ?','Oui|Non',0,0,[RT_PUBSCRNAME,pubscreen,RTEZ_REQTITLE,'MemFree v0.0e',TAG_DONE]:tagitem)
	IF r_quit=1 THEN type:=IDCMP_CLOSEWINDOW ELSE type:=0
    ENDIF
  UNTIL type=IDCMP_CLOSEWINDOW
  closeinterface()
ENDPROC
PROC initinterface()
  DEF menu_toggle
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN RETURN ER_OPENLIB
  IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN RETURN ER_OPENLIB
  IF (reqtoolsbase:=OpenLibrary('reqtools.library',37))=NIL THEN RETURN ER_OPENLIB
  IF (test_port:=FindPort('MemFreePort'))<>0 THEN RETURN ER_REXXPORT
  IF myport:=CreateMsgPort()
	data_port:=myport.ln
	data_port.name:='MemFreePort'
	AddPort(myport)
  ENDIF
  IF front=TRUE
      menu_toggle:=$109
  ELSE
      menu_toggle:=$9
  ENDIF
  IF (menu:=CreateMenusA([1,0,' Options ',0,0,0,0,
			  2,0,'  NewDelay','N',0,0,0,
			  2,0,'  ChangePs','P',0,0,0,
			  2,0,'  Quitter ','Q',0,0,0,
			  1,0,' Mémoire  ',0,0,0,0,
			  2,0,'  Fast    ','F',0,0,0,
			  2,0,'  Chip    ','C',0,0,0,
			  2,0,' Fast/Chip','V',0,0,0,
			  2,0,' Virus D  ','D',0,0,0,
			  1,0,'  Fenêtre ',0,0,0,0,
			  2,0,'  YesFront','T',menu_toggle,0,0,
			  0,0,0,0,0,0,0]:newmenu,NIL))=NIL THEN RETURN ER_MENUS
ENDPROC
PROC openinterface()
  DEF rast
  tattr:=['topaz.font',8,0,0]:textattr
  gad:='CHIP'
  def_gad:=gad
  IF (scr:=LockPubScreen(pubscreen))=NIL
      RtEZRequestA('Ecran public introuvable.','Ok',0,0,[RT_PUBSCRNAME,pubscreen,RTEZ_REQTITLE,'MemFree v0.0e',TAG_DONE]:tagitem)
      IF (scr:=LockPubScreen('Workbench'))=NIL THEN RETURN ER_WB
  ENDIF
  ScreenToFront(scr)
  IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN RETURN ER_VISUAL
  offy:=scr.wbortop+Int(scr.rastport+58)+1
  IF (g:=CreateContext({glist}))=NIL THEN RETURN ER_CONTEXT
  IF LayoutMenusA(menu,visual,NIL)=FALSE THEN RETURN ER_MENUS
  IF (g:=CreateGadgetA(BUTTON_KIND,g,[scr.wborleft+6,offy+31,80,
				     11,'   Chip   ',tattr,1,PLACETEXT_IN,visual,'CHIP']:newgadget,
				    [GTSC_TOP,2,GTSC_VISIBLE,3,
				     GTSC_TOTAL,10,GTSC_ARROWS,22,
				     PGA_FREEDOM,LORIENT_HORIZ,GA_RELVERIFY,
				     GTLV_SELECTED,
				     TRUE,GA_IMMEDIATE,TRUE,0]))=NIL THEN RETURN ER_GADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,[scr.wborleft+87,offy+31,80,
				     11,'   Fast   ',tattr,1,PLACETEXT_IN,visual,'FAST']:newgadget,
				     [GTSC_TOP,2,GTSC_VISIBLE,3,
				     GTSC_TOTAL,10,GTSC_ARROWS,22,
				     PGA_FREEDOM,LORIENT_HORIZ,GA_RELVERIFY,
				     GTLV_SELECTED,
				     TRUE,GA_IMMEDIATE,TRUE,0]))=NIL THEN RETURN ER_GADGET
  /*IF (wnd:=OpenW(scr.width-182,scr.height-46-offy,182,offy+46,$30C OR SCROOLERIDCMP,8+2+$1000,'MemFree v0.0e',scr,2,glist))=NIL THEN RETURN ER_WINDOW*/
  IF (wnd:=OpenW(scr.width-182,scr.height-46-offy,182,offy+46,$40032C+BUTTONIDCMP,$100A,'MemFree v0.0e',scr,2,glist))=NIL THEN RETURN ER_WINDOW
  wnd.screentitle:='MemFree v0.0e (c) 1993 NasGûl'
  wndmp:=wnd.userport
  rast:=wnd.rport
  SetTopaz(8)
  IF SetMenuStrip(wnd,menu)=FALSE THEN RETURN ER_MENUS
  Gt_RefreshWindow(wnd,NIL)
  display(gad)
ENDPROC

PROC closeinterface()
  IF wnd THEN ClearMenuStrip(wnd)
  IF menu THEN FreeMenus(menu)
  IF visual THEN FreeVisualInfo(visual)
  IF wnd THEN CloseWindow(wnd)
  IF glist THEN FreeGadgets(glist)
  IF scr THEN UnlockPubScreen(NIL,scr)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  IF intuitionbase THEN CloseLibrary(intuitionbase)
  IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
  IF rdargs THEN FreeArgs(rdargs)
  IF iconbase THEN CloseLibrary(iconbase)
  IF struc_diskobj THEN FreeDiskObject(struc_diskobj)
  IF myport THEN RemPort(myport)
  IF myport THEN DeleteMsgPort(myport)
ENDPROC

PROC close_win()
  IF wnd THEN ClearMenuStrip(wnd)
  IF visual THEN FreeVisualInfo(visual)
  IF wnd THEN CloseWindow(wnd)
  IF glist THEN FreeGadgets(glist)
  IF scr THEN UnlockPubScreen(NIL,scr)
ENDPROC

PROC checkerror(er)
  DEF errors:PTR TO LONG
  IF er>0
    closeinterface()
    errors:=['','Impossible d\aouvrir la\n "gadtools.library" v37',
		'Ecran public introuvable',
		'Erreur: visual infos',
		'Erreur: creation context',
		'Erreur: creation gadget',
		'Erreur : Ouverture fenêtre',
		'Erreur: allocation menus',
		'Erreur : Bad Args !',
		'Port Arexx existant',
		'Erreur : Allocation Signal']
    RtEZRequestA(errors[er],'Ok',0,0,[RT_PUBSCRNAME,pubscreen,RTEZ_REQTITLE,'MemFree v0.0e',TAG_DONE]:tagitem)
    CleanUp(10)
  ENDIF
ENDPROC

PROC wait4message()
  DEF mes:PTR TO intuimessage,g:PTR TO gadget
  DEF appmsg:PTR TO rexxmsg,com_rexx[50]:STRING
  DEF rexx_args:PTR TO LONG,change_aff,change_id
  DEF retour,val,str[80]:STRING
  DEF req:PTR TO rtfilerequester,ch_pubsc=FALSE
  DEF virus_action=0,item_adr:PTR TO menuitem
  REPEAT
    type:=0
    IF mes:=Gt_GetIMsg(wnd.userport)
	type:=mes.class
	IF type=IDCMP_MENUPICK
	  infos:=mes.code
	  SELECT infos
	      CASE $F800		     /* GET NEW DELAY */
		  IF req:=RtAllocRequestA(RT_REQINFO,NIL)
		      val:=delay
		      retour:=RtGetLongA({val},'MemFree v0.0e',NIL,
					 [RT_PUBSCRNAME,pubscreen,
					  RTGL_MIN,10,
					  RTGL_MAX,3000,
					  RTGL_TEXTFMT,'Nouveau Delay',
					  RTGL_GADFMT,'New|Cancel',
					  TAG_DONE]:tagitem)
		      IF retour=1 THEN delay:=val
		      RtFreeRequest(req)
		  ENDIF
	      CASE $F820		     /* GET NEW PUBSCREEN */
		  IF req:=RtAllocRequestA(RT_REQINFO,NIL)
			  retour:=RtGetStringA(str, 200,'MemFree v0.0e',NIL,
					       [RT_PUBSCRNAME,pubscreen,
						RTGS_GADFMT,'Ok|Cancel',
						RTGS_TEXTFMT, 'Choix d\aun nouveau Public screen.',
						TAG_DONE]:tagitem)
		      IF retour=1
			  ch_pubsc:=TRUE
			  StrCopy(pubscreen,str,ALL)
		      ENDIF
		      RtFreeRequest(req)
		  ENDIF
	      CASE $F840		     /* QUITTER */
		  type:=IDCMP_CLOSEWINDOW
	      /******************************/
	      CASE $F801		     /* MEM FAST */
		  def_gad:='FAST'
		  change_aff:=FALSE
	      CASE $F821		     /* MEM CHIP */
		  def_gad:='CHIP'
		  change_aff:=FALSE
	      CASE $F841		     /* FASTCHIP */
		  change_aff:=TRUE
	      CASE $F861		     /* Virus D  */
		 IF check_exec() THEN virus_action:=RtEZRequestA('Virus Détected.','ColdReboot|Gasp !!',0,0,[RT_PUBSCRNAME,pubscreen,RTEZ_REQTITLE,'MemFree v0.0e',TAG_DONE]:tagitem)
		 IF virus_action=1 THEN ColdReboot()
	      /******************************/
	      CASE $F802		     /* Always Front */
		  IF front=TRUE
		      front:=FALSE
		  ELSE
		      front:=TRUE
		  ENDIF
	      DEFAULT;	  NOP
	  ENDSELECT
	ELSEIF (type=IDCMP_GADGETDOWN) OR (type=IDCMP_GADGETUP)
	    g:=mes.iaddress
	    infos:=g.gadgetid
	    gad:=g.userdata
	    def_gad:=gad
	    display(gad)
	    change_aff:=FALSE
	ELSEIF type=IDCMP_REFRESHWINDOW
	  Gt_BeginRefresh(wnd)
	  Gt_EndRefresh(wnd,TRUE)
	  type:=0
	ELSEIF type<>IDCMP_CLOSEWINDOW
	    type:=0
	ENDIF
	Gt_ReplyIMsg(mes)
	IF ch_pubsc=TRUE
	    ch_pubsc:=FALSE
	    zipped:=FALSE
	    close_win()
	    checkerror(openinterface())
	ENDIF
    ELSE
      IF appmsg:=GetMsg(myport)
	  rexx_args:=appmsg.args
	  StrCopy(com_rexx,rexx_args[0],ALL)
	  IF StrCmp(com_rexx,'QUIT',ALL)
	      type:=IDCMP_CLOSEWINDOW
	  ELSEIF StrCmp(com_rexx,'FRONT',ALL)
	      WindowToFront(wnd)
	  ELSEIF StrCmp(com_rexx,'BACK',ALL)
	      WindowToBack(wnd)
	  ELSEIF StrCmp(com_rexx,'CHIP',ALL)
	      change_aff:=FALSE
	      def_gad:='CHIP'
	      display(def_gad)
	  ELSEIF StrCmp(com_rexx,'FASTCHIP',ALL)
	      change_aff:=TRUE
	      change_id:=0
	  ELSEIF StrCmp(com_rexx,'FAST',ALL)
	      change_aff:=FALSE
	      def_gad:='FAST'
	      display(def_gad)
	  ELSEIF StrCmp(com_rexx,'NOFRONT',ALL)
	      item_adr:=ItemAddress(menu,$F802)
	      front:=FALSE
	      item_adr.flags:=$605F
	  ELSEIF StrCmp(com_rexx,'YESFRONT',ALL)
	      item_adr:=ItemAddress(menu,$F802)
	      front:=TRUE
	      item_adr.flags:=$615F
	  ELSEIF StrCmp(com_rexx,'CHANGEPS',8)
	      IF StrLen(com_rexx)=8
		  StrCopy(pubscreen,'Workbench',ALL)
	      ELSE
		  MidStr(pubscreen,com_rexx,9,ALL)
	      ENDIF
	      zipped:=FALSE
	      close_win()
	      checkerror(openinterface())
	  ELSEIF StrCmp(com_rexx,'NEWDELAY',8)
	      MidStr(delay,com_rexx,9,ALL)
	      delay:=Val(delay,NIL)
	      IF delay<10 THEN delay:=10
	  ELSEIF StrCmp(com_rexx,'ZIP',ALL)
	      IF zipped=FALSE
		  SizeWindow(wnd,0,-46)
		  MoveWindow(wnd,0,46)
		  zip_piv:=TRUE
	      ELSEIF zipped=TRUE
		  MoveWindow(wnd,0,-46)
		  SizeWindow(wnd,0,46)
		  zip_piv:=FALSE
	      ENDIF
	      zipped:=zip_piv
	  ELSEIF StrCmp(com_rexx,'VD',2)
	     IF check_exec() THEN RtEZRequestA('Virus Détected.','ColdReboot|Gasp !!',0,0,[RT_PUBSCRNAME,pubscreen,RTEZ_REQTITLE,'MemFree v0.0e',TAG_DONE]:tagitem)
	     IF virus_action=1 THEN ColdReboot()
	  ENDIF
	  ReplyMsg(appmsg)
      ENDIF
      WHILE appmsg:=GetMsg(myport) DO ReplyMsg(appmsg)
      IF (change_aff=TRUE) AND (change_id=0)
	  def_gad:='FAST'
	  change_id:=-1
      ELSEIF change_aff=TRUE
	  def_gad:='CHIP'
	  change_id:=0
      ENDIF
      IF front=TRUE
	  Forbid()
	  Gt_BeginRefresh(wnd)
	  WindowToFront(wnd)
	  Gt_EndRefresh(wnd,TRUE)
	  Permit()
      ENDIF
      display(def_gad)
      /*Delay(delay)*/
      Wait(Shl(1,wndmp.sigbit))
    ENDIF
  UNTIL type
ENDPROC
PROC display(gad)
    DEF chip,fast,largest_chip,largest_fast
    DEF total_chip,total_fast
    chip:=AvailMem($2)
    fast:=AvailMem($4)
    largest_chip:=AvailMem($20002)
    largest_fast:=AvailMem($20004)
    total_chip:=AvailMem($80002)
    total_fast:=AvailMem($80004)
    IF StrCmp(gad,'CHIP',ALL)
	TextF(10,10+offy,'  Chip  :\d[9]',chip)
	TextF(10,10+offy+8,'  L Chip:\d[9]',largest_chip)
	TextF(10,10+offy+16,'  T Chip:\d[9]',total_chip)
    ELSEIF StrCmp(gad,'FAST',ALL)
	TextF(10,10+offy,'  Fast  :\d[9]',fast)
	TextF(10,10+offy+8,'  L Fast:\d[9]',largest_fast)
	TextF(10,10+offy+16,'  T Fast:\d[9]',total_fast)
    ENDIF
ENDPROC
/*******************************/
/* Routines par EA van breemen */
/*******************************/
/* A small virus detector      */
/* By EA van Breemen	       */
/*******************************/
/* Check procedure of execbase */
PROC check_exec()
    DEF test
    RtEZRequestA('  By EA van Breemen\n  ~~~~~~~~~~~~~~~~~\nColdCapture :\z\h[8]\nCoolCapture :\z\h[8]\nKickMemPtr  :\z\h[8]\nKickTagPtr  :\z\h[8]',
		'Ok',
		   0,
		[base.coldcapture,base.coolcapture,
		 base.kickmemptr,base.kicktagptr],
		[RT_PUBSCRNAME,pubscreen,RTEZ_REQTITLE,'MemFree v0.0e',TAG_DONE]:tagitem)
test:=Exists({x},[[base.coldcapture,'ColdCapture'],[base.coolcapture,'CoolCapture'],
		  [base.kickmemptr,'KickMemPtr'],[base.kicktagptr,'KickTagPtr']],
		  `x[0])

ENDPROC test
