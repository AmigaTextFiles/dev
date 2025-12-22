/*******************************************************************************************/
/* Source code generate by Gui2E v0.1 © 1994 NasGûl                                        */
/*******************************************************************************************/
/********************************************************************************
 * << EUTILS HEADER >>
 ********************************************************************************
 ED               "EDG"
 EC               "EC"
 PREPRO           "EPP"
 SOURCE           "Gui2E.e"
 EPPDEST          "G_EPP.e"
 EXEC             "Gui2E"
 ISOURCE          " "
 HSOURCE          " "
 ERROREC          " "
 ERROREPP         " "
 VERSION          "0"
 REVISION         "1"
 NAMEPRG          "Gui2E"
 NAMEAUTHOR       "NasGûl"
 ********************************************************************************
 * HISTORY :
 *******************************************************************************/

OPT OSVERSION=37

MODULE 'intuition/intuition','gadtools','libraries/gadtools','intuition/gadgetclass','intuition/screens',
       'graphics/text','exec/lists','exec/nodes','exec/ports','eropenlib','utility/tagitem',
       'asl','libraries/asl'
MODULE 'gadtoolsbox/forms','readguifile'

ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW
CONST F_LOAD=0,F_SAVE=1
PMODULE 'ReadGUI'
DEF screen:PTR TO screen,
    visual=NIL,
    tattr:PTR TO textattr,
    reelquit=FALSE
/****************************************
 * gui Definitions
 ****************************************/
DEF gui_window=NIL:PTR TO window
DEF gui_glist=NIL
/* Gadgets */
CONST GA_GLCONV=0
CONST GA_G_GENPROCLIB=1
CONST GA_G_GENMES=2
CONST GA_G_INFO=3
/* Gadgets labels of gui */
DEF glconv
DEF g_genproclib
DEF g_genmes
DEF g_info
/* var def */
DEF genlib=FALSE
DEF genmes=FALSE
DEF source[256]:STRING
DEF destin[256]:STRING
DEF f_out
DEF reelstdout
PROC p_OpenLibraries() HANDLE /*"p_OpenLibraries()"*/
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GRAPHICSLIB)
    IF (aslbase:=OpenLibrary('asl.library',37))=NIL THEN Raise(ER_ASLLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_CloseLibraries()  /*"p_CloseLibraries()"*/
    IF aslbase THEN CloseLibrary(aslbase)
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
PROC p_SetUpScreen() HANDLE /*"p_SetUpScreen()"*/
    IF (screen:=LockPubScreen('Workbench'))=NIL THEN Raise(ER_LOCKSCREEN)
    IF (visual:=GetVisualInfoA(screen,NIL))=NIL THEN Raise(ER_VISUAL)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_SetDownScreen() /*"p_SetDownScreen()"*/
    IF visual THEN FreeVisualInfo(visual)
    IF screen THEN UnlockPubScreen(NIL,screen)
ENDPROC
PROC p_InitguiWindow() HANDLE /*"p_InitguiWindow()"*/
    IF (gui_glist:=CreateContext({gui_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (glconv:=CreateGadgetA(BUTTON_KIND,gui_glist,[21,17,245,13,'Convert Gui File',tattr,0,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_genproclib:=CreateGadgetA(CHECKBOX_KIND,glconv,[21,34,26,11,'Generate OpenCLoseLib',tattr,1,2,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTCB_CHECKED,FALSE,GT_UNDERSCORE,"_", TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_genmes:=CreateGadgetA(CHECKBOX_KIND,g_genproclib,[21,48,26,11,'Generate Message Proc',tattr,2,2,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTCB_CHECKED,FALSE,GT_UNDERSCORE,"_", TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_info:=CreateGadgetA(TEXT_KIND,g_genmes,[21,70,245,13,'',tattr,3,0,visual,0]:newgadget,[GTTX_BORDER,TRUE,GTTX_TEXT,'None.',GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RenderguiWindow() /*"p_RenderguiWindow()"*/
    DrawBevelBoxA(gui_window.rport,9,14,270,74,[GT_VISUALINFO,visual,TAG_DONE,0])
    RefreshGList(glconv,gui_window,NIL,-1)
    Gt_RefreshWindow(gui_window,NIL)
ENDPROC
PROC p_OpenguiWindow() HANDLE /*"p_OpenguiWindow()"*/
    IF (gui_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,10,
                       WA_TOP,10,
                       WA_WIDTH,287,
                       WA_HEIGHT,91,
                       WA_IDCMP,$244,
                       WA_FLAGS,$102E+WFLG_HASZOOM,
                       WA_GADGETS,gui_glist,
                       WA_ZOOM,[10,10,287,11]:INT,
                       WA_TITLE,'Gui2E © 1994 NasGûl',
                       WA_SCREENTITLE,'Made With GadToolsBox v2.0 © 1991-1993',
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    p_RenderguiWindow()
    Gt_RefreshWindow(gui_window,NIL)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RemguiWindow() /*"p_RemguiWindow()"*/
    IF gui_window THEN CloseWindow(gui_window)
    IF gui_glist THEN FreeGadgets(gui_glist)
ENDPROC
PROC p_LookAllMessage() /*"p_LookAllMessage()"*/
    DEF sigreturn
    DEF guiport:PTR TO mp
    IF gui_window THEN guiport:=gui_window.userport ELSE guiport:=NIL
    sigreturn:=Wait(Shl(1,guiport.sigbit) OR
                    $F000)
    IF (sigreturn AND Shl(1,guiport.sigbit))
        p_LookguiMessage()
    ENDIF
    IF (sigreturn AND $F000)
        reelquit:=TRUE
    ENDIF
ENDPROC
PROC p_LookguiMessage() /*"p_LookguiMessage()"*/
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF type=0,infos=NIL
   IF mes:=Gt_GetIMsg(gui_window.userport)
       type:=mes.class
       SELECT type
           CASE IDCMP_MENUPICK
              infos:=mes.code
              SELECT infos
              ENDSELECT
           CASE IDCMP_CLOSEWINDOW
              reelquit:=TRUE
           CASE IDCMP_GADGETDOWN
              type:=IDCMP_GADGETUP
           CASE IDCMP_REFRESHWINDOW
              p_RenderguiWindow()
           CASE IDCMP_GADGETUP
           /*CASE gad*/
              g:=mes.iaddress
              infos:=g.gadgetid
              SELECT infos
                  CASE GA_GLCONV
                      IF p_FileRequester(F_LOAD)
                          IF g_ReadGUIFile(source)
                              p_Alert('Read Source Ok.')
                              IF p_FileRequester(F_SAVE)
                                  IF f_out:=Open(destin,1006)
                                      stdout:=f_out
                                      g_WriteFHeader()
                                      g_WriteFDef(myguibase.adrlistwindow)
                                      IF genlib THEN g_WriteFOpenCloseLib()
                                      g_WriteFScreen()
                                      g_WriteFWindowList(myguibase.adrlistwindow)
                                      IF genmes
                                          g_WriteFLookMessage(myguibase.adrlistwindow)
                                          g_WriteFWinMessage(myguibase.adrlistwindow)
                                      ENDIF
                                      IF (genmes OR genlib) THEN g_WriteFMain(myguibase.adrlistwindow)
                                  ELSE
                                      p_Alert('Error Output.')
                                  ENDIF
                                  g_RemGUIBase()
                                  g_InitGUIBase()
                                  IF f_out THEN Close(f_out)
                                  stdout:=reelstdout
                                  p_Alert('Save File ok.')
                              ELSE
                                  p_Alert('Save Aborded.')
                                  g_RemGUIBase()
                                  g_InitGUIBase()
                              ENDIF
                          ELSE
                              p_Alert('Not a GUI FIle.')
                          ENDIF
                      ENDIF
                  CASE GA_G_GENPROCLIB
                      infos:=mes.code
                      IF infos THEN genlib:=TRUE ELSE genlib:=FALSE
                  CASE GA_G_GENMES
                      infos:=mes.code
                      IF infos THEN genmes:=TRUE ELSE genmes:=FALSE
                  CASE GA_G_INFO
              ENDSELECT
       ENDSELECT
       Gt_ReplyIMsg(mes)
   ENDIF
ENDPROC
PROC p_FileRequester(t) /*"p_FileRequester(t)"*/
    DEF req:PTR TO filerequestr
    DEF ret=FALSE
    DEF f=FALSE
    DEF tag
    IF t=F_LOAD
        tag:=[ASL_HAIL,'Gui2E : Load',0]
    ELSE
        tag:=[ASL_FUNCFLAGS,FILF_SAVE,ASL_HAIL,'Gui2E : Save',0]
        f:=TRUE
    ENDIF
    IF req:=AllocAslRequest(ASL_FILEREQUEST,tag)
        IF RequestFile(req)
            AddPart(req.dir,'',256)
            IF f=FALSE THEN StringF(source,'\s\s',req.dir,req.file) ELSE StringF(destin,'\s\s',req.dir,req.file)
            ret:=TRUE
        ENDIF
        FreeAslRequest(req)
    ENDIF
    RETURN ret
ENDPROC
PROC p_Alert(texte) /*"p_Alert(texte)"*/
    Gt_SetGadgetAttrsA(g_info,gui_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,texte,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0])
ENDPROC
PROC main() HANDLE /*"main()"*/
    DEF testmain
    tattr:=['topaz.font',8,0,0]:textattr
    reelstdout:=stdout
    string_kind:=['GENERIC_KIND',
                  'BUTTON_KIND',
                  'CHECKBOX_KIND',
                  'INTEGER_KIND',
                  'LISTVIEW_KIND',
                  'MX_KIND',
                  'NUMBER_KIND',
                  'CYCLE_KIND',
                  'PALETTE_KIND',
                  '',
                  'SCROLLER_KIND',
                  'SLIDER_KIND',
                  'STRING_KIND',
                  'TEXT_KIND']
    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_SetUpScreen())<>ER_NONE THEN Raise(testmain)
    g_InitGUIBase()
    IF (testmain:=p_InitguiWindow())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_OpenguiWindow())<>ER_NONE THEN Raise(testmain)
    REPEAT
        p_LookAllMessage()
    UNTIL reelquit=TRUE
    Raise(ER_NONE)
EXCEPT
    g_RemGUIBase()
    p_RemguiWindow()
    p_SetDownScreen()
    p_CloseLibraries()
    SELECT exception
        CASE ER_LOCKSCREEN; WriteF('Lock Screen Failed.')
        CASE ER_VISUAL;     WriteF('Error Visual.')
        CASE ER_CONTEXT;    WriteF('Error Context.')
        CASE ER_MENUS;      WriteF('Error Menus.')
        CASE ER_GADGET;     WriteF('Error Gadget.')
        CASE ER_WINDOW;     WriteF('Error Window.')
    ENDSELECT
ENDPROC
