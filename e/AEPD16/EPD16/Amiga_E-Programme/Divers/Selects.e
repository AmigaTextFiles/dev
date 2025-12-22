/***************************************************/
/* SelectScreen v0.0a (c) 1993 NasGûl              */
/***************************************************/
/*
C_DATE=05 Feb 1994
C_TIME=00:06:52
*/
ENUM NONE,ER_OPENLIB,ER_WB,ER_VISUAL,ER_CONTEXT,ER_GADGET,ER_WINDOW,ER_MENUS,
     ER_MEM,ER_SIG

ENUM JOB_DONE,JOB_CONST,JOB_OBJ,JOB_LIB=6

MODULE 'intuition/intuition','gadtools', 'libraries/gadtools',
       'intuition/gadgetclass', 'exec/nodes', 'intuition/screens',
       'exec/lists','exec/tasks','intuition/intuitionbase'
MODULE 'exec/libraries','exec/execbase'
MODULE 'dos/dosasl', 'dos/dos', 'utility','utility/tagitem'
MODULE 'reqtools','libraries/reqtools','graphics/text'

CONST L_SCREEN=0, /* Type of the list (screens or windows )*/
      L_WINDOW=1

RAISE ER_MEM IF New()=NIL
RAISE ER_MEM IF String()=NIL

DEF scr=NIL:PTR TO screen,	   /* Ptr to screen */
    visual=NIL, 		   /* Ptr to visual */
    wnd=NIL:PTR TO window,	   /* Ptr to Window */
    glist=NIL,offy,g,g1,gwb,	   /* Gadgetlist and listview (g1) WB (gwb)*/
    type,infos			   /* type and infos for IDCMP */
DEF new_liste:PTR TO lh 	   /* My list */
DEF add_node[1000]:ARRAY OF LONG   /* Address of node */
DEF add_texte[1000]:ARRAY OF LONG  /* Texte of node   */
DEF add_scr[1000]:ARRAY OF LONG    /* Address of screen */
DEF type_liste=L_SCREEN 	   /* initialise list to screen */
DEF max_node=1			   /* initialise the number of node */
DEF ac_win,wb_add,check=FALSE	   /* Address of the first windowAnd WB */
				   /* check for CloseScreen when selected in */
				   /* the listview			     */
DEF tattr
PROC main() HANDLE /*"main()"*/
  /* Initialise my list */
  DEF sig
  new_liste:=[0,0,0,0]
  IF (sig:=AllocSignal(-1))=NIL THEN checkerror(ER_SIG)
  checkerror(initinterface())
  checkerror(openinterface())
  REPEAT
    wait4message()
  UNTIL type=IDCMP_CLOSEWINDOW
  OpenWorkBench()
  Raise(NONE)
EXCEPT
    IF sig THEN FreeSignal(sig)
    closeinterface()
    SELECT exception
	CASE NONE;   NOP
	CASE ER_MEM; WriteF('Mémoire insufisante.\n')
	DEFAULT;     NOP
    ENDSELECT
ENDPROC
PROC initinterface() /*"initinterface()"*/
  /* Open library - Remember the address of firstwindow and wb */
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN RETURN ER_OPENLIB
  IF (reqtoolsbase:=OpenLibrary('reqtools.library',37))=NIL THEN RETURN ER_OPENLIB
  IF (scr:=LockPubScreen('Workbench'))=NIL THEN RETURN ER_WB
  wb_add:=scr
  /*IF scr THEN UnlockPubScreen(NIL,scr)*/
  ac_win:=wnd
ENDPROC
PROC openinterface() /*"openinterface()"*/
  /* Open interface */
  tattr:=['topaz.font',8,0,0]:textattr
  IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN RETURN ER_VISUAL
  offy:=scr.wbortop+Int(scr.rastport+58)+1
  IF (g:=CreateContext({glist}))=NIL THEN RETURN ER_CONTEXT
  new_liste:=[0,0,0,0]
  displayscreens()
  /* Gadget for CLose And open WB */
  IF (gwb:=CreateGadgetA(CYCLE_KIND,g,[scr.wborleft+92,12,80,12,'',tattr,1,0,visual,0]:newgadget,[GTCY_LABELS,['CloseWB','OpenWB',0],0]))=NIL THEN RETURN ER_GADGET
  /* Gadget For Screens and Windows */
  IF (g:=CreateGadgetA(CYCLE_KIND,gwb,[scr.wborleft+2,12,80,12,'',tattr,2,0,visual,0]:newgadget,[GTCY_LABELS,['Screens','Windows',0],0]))=NIL THEN RETURN ER_GADGET
  /* Checkbox For CloseScreen */
  IF (g:=CreateGadgetA(CHECKBOX_KIND,g,[scr.wborleft+176,13,80,12,'CloseScreen',tattr,4,PLACETEXT_RIGHT,visual,0]:newgadget,NIL))=NIL THEN RETURN ER_GADGET
  /* Gadget of ViewList */
  IF (g1:=CreateGadgetA(LISTVIEW_KIND,g,[scr.wborleft+2,25,315,50,NIL,NIL,3,0,visual,new_liste]:newgadget,
					[GTLV_TOP,0,GTLV_SCROLLWIDTH,15,
					 GTLV_LABELS,new_liste,0]))=NIL THEN RETURN ER_GADGET
  /* Open the Window */
  IF (wnd:=OpenW(0,0,325,76,$304 OR LISTVIEWIDCMP,2+4+8+WFLG_HASZOOM,'SelectS v0.0a (c) 1993 NasGûl',scr,15,glist))=NIL THEN RETURN ER_WINDOW
  /* Refresh */
  Gt_RefreshWindow(wnd,NIL)
  Gt_SetGadgetAttrsA(g1,wnd,NIL,[GTLV_TOP,0,GTLV_LABELS,new_liste,0])
  /* Activate the firstwindow */
  ActivateWindow(ac_win)
ENDPROC
PROC close_win() /*"close_win()"*/
  IF visual THEN FreeVisualInfo(visual)
  IF wnd THEN CloseWindow(wnd)
  IF glist THEN FreeGadgets(glist)
ENDPROC
PROC closeinterface() /*"closeinterface()"*/
  IF wnd THEN ClearMenuStrip(wnd)
  IF visual THEN FreeVisualInfo(visual)
  IF wnd THEN CloseWindow(wnd)
  IF glist THEN FreeGadgets(glist)
  IF scr THEN UnlockPubScreen(NIL,scr)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
  IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
PROC checkerror(er) /*"checkerror(er)"*/
  DEF errors:PTR TO LONG
  IF er>0
    closeinterface()
    errors:=['','open "gadtools.library" v37','lock workbench','get visual infos','create context','create gadget','open window','allocate menus','Erreur mémoire','Erreur signal']
    RtEZRequestA('could not \s\n','Ok',0,[errors[er]],[RTEZ_REQTITLE,'SelectS v0.0a',TAG_DONE]:tagitem)
    CleanUp(10)
  ENDIF
ENDPROC
PROC wait4message() /*"wait4message()"*/
  DEF mes:PTR TO intuimessage,g:PTR TO gadget
  DEF change_scr=FALSE,test_wb
  REPEAT
    type:=0
    IF mes:=Gt_GetIMsg(wnd.userport)
      type:=mes.class
      IF (type=IDCMP_GADGETDOWN) OR (type=IDCMP_GADGETUP)
	g:=mes.iaddress
	infos:=g.gadgetid
	SELECT infos
	    CASE 1			 /* CloseWB or OpenWB Gadget */
		IF mes.code=1
		    test_wb:=CloseWorkBench()
		    IF test_wb=0 THEN DisplayBeep(0)
		ELSEIF mes.code=0
		    test_wb:=OpenWorkBench()
		    IF test_wb=0 THEN DisplayBeep(0)
		ENDIF
	    CASE 2			 /* Screens or Windows Gadget */
		IF type_liste=L_SCREEN
		    type_liste:=L_WINDOW
		    displaywindows()
		ELSE
		   type_liste:=L_SCREEN
		   displayscreens()
		ENDIF
	    CASE 3			 /* ListView */
		infos:=mes.code+1
		IF type_liste=L_SCREEN	 /* For Screens */
		    IF check=FALSE	 /* CheckBox not Checked */
			ScreenToFront(add_scr[infos])
			scr:=add_scr[infos]
			ac_win:=scr.firstwindow
			change_scr:=TRUE
		    ELSE		 /* CheckBox Checked */
			test_wb:=CloseScreen(add_scr[infos])
			IF test_wb=0 THEN DisplayBeep(0)
		    ENDIF
		ELSE			 /* For Windows */
		    WindowToFront(add_scr[infos])
		ENDIF
	    CASE 4			 /* The CheckBox for CloseScreen */
		IF mes.code THEN check:=TRUE ELSE check:=FALSE
	    DEFAULT; NOP
	ENDSELECT
	/* Refresh the ViewList */
	Gt_SetGadgetAttrsA(g1,wnd,NIL,[GTLV_LABELS,new_liste,0])
      ELSEIF type=IDCMP_REFRESHWINDOW	 /* For the Zip Gadget */
	Gt_BeginRefresh(wnd)
	Gt_RefreshWindow(wnd,NIL)
	Gt_EndRefresh(wnd,TRUE)
      ELSEIF type<>IDCMP_CLOSEWINDOW
	type:=0
      ENDIF
      Gt_ReplyIMsg(mes)
    ELSE
	Wait(-1)
	/* Refresh the ListView */
	IF type_liste=L_SCREEN THEN displayscreens() ELSE displaywindows()
	Gt_SetGadgetAttrsA(g1,wnd,NIL,[GTLV_LABELS,new_liste,0])
    ENDIF
  UNTIL type
  /* Change the screen */
  IF change_scr=TRUE
      close_win()
      checkerror(openinterface())
  ENDIF
ENDPROC
PROC displayscreens() /*"displayscreens()"*/
  /* Make the list of ALL screens (public or not) */
  DEF slist:PTR TO screen
  DEF intui:PTR TO intuitionbase
  DEF str_piv[256]:STRING,mynode:PTR TO ln,b
  max_node:=1
  add_node[0]:=0
  new_liste:=[0,0,0,0]
  Forbid()
  intui:=intuitionbase
  slist:=intui.firstscreen
  WHILE slist
    add_node[max_node]:=New(SIZEOF ln)
    StringF(str_piv,'\l\s[35]*',
	  slist.title)
    add_texte[max_node]:=String(EstrLen(str_piv))
    StrCopy(add_texte[max_node],str_piv,ALL)
    mynode:=add_node[max_node]
    mynode.pri:=0
    mynode.name:=add_texte[max_node]
    add_scr[max_node]:=slist
    INC max_node
    slist:=slist.nextscreen
  ENDWHILE
  Permit()
  FOR b:=1 TO max_node-1
      mynode:=add_node[b]
      mynode.succ:=add_node[b+1]
      mynode.pred:=add_node[b-1]
      mynode.name:=add_texte[b]
      AddTail(new_liste,mynode)
  ENDFOR
  new_liste.head:=add_node[1]
  new_liste.tailpred:=add_node[max_node-1]
ENDPROC
PROC displaywindows() /*"displaywindows()"*/
  /* Make the list of the windows */
  DEF slist:PTR TO screen,wlist:PTR TO window,
      intui:PTR TO intuitionbase
  DEF str_piv[256]:STRING,mynode:PTR TO ln,b
  max_node:=1
  add_node[0]:=0
  new_liste:=[0,0,0,0]
  Forbid()
  intui:=intuitionbase
  slist:=intui.firstscreen
  wlist:=slist.firstwindow
  WHILE wlist
    add_node[max_node]:=New(SIZEOF ln)
    add_scr[max_node]:=wlist
    StringF(str_piv,'\l\s[80]',wlist.title)
    add_texte[max_node]:=String(EstrLen(str_piv))
    StrCopy(add_texte[max_node],str_piv,ALL)
    mynode:=add_node[max_node]
    mynode.pri:=0
    mynode.name:=add_texte[max_node]
    INC max_node
    wlist:=wlist.nextwindow
  ENDWHILE
  slist:=slist.nextscreen
  Permit()
  FOR b:=1 TO max_node-1
      mynode:=add_node[b]
      mynode.succ:=add_node[b+1]
      mynode.pred:=add_node[b-1]
      mynode.name:=add_texte[b]
      AddTail(new_liste,mynode)
  ENDFOR
  new_liste.head:=add_node[1]
  new_liste.tailpred:=add_node[max_node-1]
ENDPROC

