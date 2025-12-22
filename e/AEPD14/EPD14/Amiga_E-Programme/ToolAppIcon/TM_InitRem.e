PROC tm_OpenLibraries() HANDLE /*"tm_OpenLibraries()"*/
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GRAPHICSLIB)
    IF (reqtoolsbase:=OpenLibrary('reqtools.library',38))=NIL THEN Raise(ER_REQTOOLSLIB)
    IF FindTask('ToolManager Handler')=0
        tm_Request('ToolManager n\aest pas actif','_Merci',NIL)
        Raise(ER_NOTM)
    ENDIF
    IF (toolmanagerbase:=OpenLibrary('toolmanager.library',3))=NIL THEN Raise(ER_TOOLMANAGERLIB)
    IF (workbenchbase:=OpenLibrary('workbench.library',37))=NIL THEN Raise(ER_WORKBENCHLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC tm_InitAPP() HANDLE /*"tm_InitAPP()"*/
    DEF tt
    IF (prgsig:=AllocSignal(prgsig))=NIL THEN Raise(ER_SIG)
    IF (tm_h:=AllocTMHandle())=NIL THEN Raise(ER_TMHANDLE)
    IF (tt:=tm_InitMainWindow())<>ER_NONE THEN Raise(tt)
    IF (list_appicon:=p_InitList())=NIL THEN Raise(ER_LIST)
    list_empty:=[0,0,0,0]; list_empty[0]:=list_empty+4; list_empty[2]:=list_empty
    AddTail(list_empty,[0,0,0,0,' ']:ln)
    IF (prgport:=CreateMsgPort())=NIL THEN Raise(ER_PORT)
    IF (appitem:=AddAppMenuItemA(0,0,'TMAppIc',prgport,[MTYPE_APPMENUITEM,TAG_DONE]))=NIL THEN Raise(ER_APPITEM)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC tm_InitMainWindow() HANDLE /*"tm_InitMainWindow()"*/
    IF (execw_screen:=LockPubScreen('Workbench'))=NIL THEN Raise(ER_WB)
    IF (execw_visual:=GetVisualInfoA(execw_screen,NIL))=NIL THEN Raise(ER_VISUAL)
    IF (execw_glist:=CreateContext({execw_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (g_name:=CreateGadgetA(STRING_KIND,execw_glist,[156,17,181,13,'Nom de L\aobjet',tattr,0,1,execw_visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_exectype:=CreateGadgetA(CYCLE_KIND,g_name,[156,30,181,12,'Mode Exec',tattr,1,1,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTCY_LABELS,['CLI','WB','Arexx',0],GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_getcommand:=CreateGadgetA(BUTTON_KIND,g_exectype,[309,42,28,13,'?',tattr,2,16,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_command:=CreateGadgetA(STRING_KIND,g_getcommand,[159,42,148,13,'Commande',tattr,3,1,execw_visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_hotkey:=CreateGadgetA(STRING_KIND,g_command,[158,55,181,13,'Raccourci-clavier',tattr,4,1,execw_visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_stack:=CreateGadgetA(STRING_KIND,g_hotkey,[157,68,181,13,'Pile',tattr,5,1,execw_visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_priority:=CreateGadgetA(STRING_KIND,g_stack,[157,81,181,13,'Priorité',tattr,6,1,execw_visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_delay:=CreateGadgetA(STRING_KIND,g_priority,[157,94,181,13,'Délai',tattr,7,1,execw_visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_currentdir:=CreateGadgetA(STRING_KIND,g_delay,[159,107,148,13,'Tiroir courant',tattr,8,1,execw_visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_getpath:=CreateGadgetA(BUTTON_KIND,g_currentdir,[309,120,28,13,'?',tattr,9,16,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_path:=CreateGadgetA(STRING_KIND,g_getpath,[159,120,148,13,'Chemin',tattr,10,1,execw_visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_getoutput:=CreateGadgetA(BUTTON_KIND,g_path,[309,133,28,13,'?',tattr,11,16,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_output:=CreateGadgetA(STRING_KIND,g_getoutput,[159,133,148,13,'Fichier sortie',tattr,12,1,execw_visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_getpubscreen:=CreateGadgetA(BUTTON_KIND,g_output,[309,146,28,13,'?',tattr,13,16,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_pubscreen:=CreateGadgetA(STRING_KIND,g_getpubscreen,[159,146,148,13,'Ecran public',tattr,14,1,execw_visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_arguments:=CreateGadgetA(CHECKBOX_KIND,g_pubscreen,[37,165,26,11,'Arguments',tattr,15,2,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTCB_CHECKED,FALSE,GT_UNDERSCORE,"_", TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_tofront:=CreateGadgetA(CHECKBOX_KIND,g_arguments,[160,165,26,11,'Au premier plan',tattr,16,2,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTCB_CHECKED,FALSE,GT_UNDERSCORE,"_", TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_add:=CreateGadgetA(BUTTON_KIND,g_tofront,[383,114,101,12,'Add',tattr,17,16,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_rem:=CreateGadgetA(BUTTON_KIND,g_add,[488,114,101,12,'Rem',tattr,18,16,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_file:=CreateGadgetA(STRING_KIND,g_rem,[159,187,148,13,'Fichier Image',tattr,19,1,execw_visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_getfile:=CreateGadgetA(BUTTON_KIND,g_file,[309,187,30,13,'?',tattr,20,16,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_position:=CreateGadgetA(CYCLE_KIND,g_getfile,[366,17,234,12,'',tattr,21,0,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTCY_LABELS,['Positionnement','Terminer positionnement',0],GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_posx:=CreateGadgetA(STRING_KIND,g_position,[419,29,181,13,'PosX',tattr,22,1,execw_visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_posy:=CreateGadgetA(STRING_KIND,g_posx,[419,42,181,13,'PosY',tattr,23,1,execw_visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_showname:=CreateGadgetA(CHECKBOX_KIND,g_posy,[419,62,26,11,'Monter le nom',tattr,24,2,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTCB_CHECKED,FALSE,GT_UNDERSCORE,"_", TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_save:=CreateGadgetA(BUTTON_KIND,g_showname,[357,80,101,12,'Sauver',tattr,25,16,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_saveas:=CreateGadgetA(BUTTON_KIND,g_save,[462,80,101,12,'Sauver S.',tattr,26,16,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_use:=CreateGadgetA(BUTTON_KIND,g_saveas,[358,93,101,12,'Charger',tattr,27,16,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_test:=CreateGadgetA(BUTTON_KIND,g_use,[463,93,101,12,'Tester',tattr,28,16,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_quit:=CreateGadgetA(BUTTON_KIND,g_test,[572,80,51,25,'QUIT',tattr,29,16,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_getcurrentdir:=CreateGadgetA(BUTTON_KIND,g_quit,[309,107,28,13,'?',tattr,30,16,execw_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_list:=CreateGadgetA(LISTVIEW_KIND,g_getcurrentdir,[369,130,231,73,'',tattr,31,0,execw_visual,0]:newgadget,[GTLV_SHOWSELECTED,NIL,GTLV_LABELS,-1,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC tm_CloseLibraries() /*"tm_CloseLibraries()"*/
    IF workbenchbase THEN CloseLibrary(workbenchbase)
    IF tm_Request('       Avec l\aaimable participation de      \n'+
                  '    <<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>   \n'+
                  '   Nico François         ReqTools.library.   \n'+
                  '   Stefan Becker         ToolManager.library.\n'+
                  '   Jaba Development      GadToolsBox.        \n'+
                  '   Dietmar Eilert        GoldED.             \n'+
                  '   Barry Wills           Epp.                \n'+
                  '   Wouter Van Oortmersen Ec.                 \n'+
                  '    <<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>   \n'+
                  '       Voulez-vous Quitter ToolManager ?     \n'+
                  '    <<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>   ','_Oui|_Non',NIL)
        VOID QuitToolManager()
    ENDIF
    IF toolmanagerbase THEN CloseLibrary(toolmanagerbase)
    IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
PROC tm_RemAPP() /*"tm_RemAPP()"*/
    IF appitem THEN RemoveAppMenuItem(appitem)
    IF prgport THEN DeleteMsgPort(prgport)
    IF list_appicon THEN tm_CleanAppIconList(list_appicon,LIST_REMOVE)
    tm_RemMainWindow()
    IF tm_h THEN FreeTMHandle(tm_h)
    IF prgsig THEN FreeSignal(prgsig)
ENDPROC

