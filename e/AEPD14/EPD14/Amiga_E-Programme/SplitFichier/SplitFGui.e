/*******************************************************************************************/
/* Source code generate by Gui2E v0.1 © 1994 NasGûl                                        */
/*******************************************************************************************/
/********************************************************************************
 * << EUTILS HEADER >>
 ********************************************************************************
 ED        "EDG"
 EC        "EC -e"
 PREPRO    "EPP -t -c"
 SOURCE    "SplitFGui.e"
 EPPDEST   "SP_EPP.e"
 EXEC      "SplitFGui"
 ISOURCE   ""
 HSOURCE   ""
 ERROREC   ""
 ERROREPP  ""
 VERSION   "0"
 REVISION  "1"
 NAMEPRG   "SpliFGui"
 NAMEAUTHOR "NasGûl"
 ********************************************************************************
 * HISTORY :
 *******************************************************************************/

OPT OSVERSION=37

CONST F_LOAD=0,
      F_SAVE=1

MODULE 'intuition/intuition','gadtools','libraries/gadtools','intuition/gadgetclass','intuition/screens',
       'graphics/text','exec/lists','exec/nodes','exec/ports','eropenlib','utility/tagitem'
MODULE 'asl','libraries/asl','mathtrans'
ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW,ER_MEM

RAISE ER_MEM IF New()=NIL,
      ER_MEM IF String()=NIL

DEF screen:PTR TO screen,
    visual=NIL,
    tattr:PTR TO textattr,
    reelquit=FALSE,
    offy
/****************************************
 * sp Definitions
 ****************************************/
DEF sp_window=NIL:PTR TO window
DEF sp_glist=NIL
/* Gadgets */
ENUM GA_GSOURCE,GA_GDESTIN,GA_GCAP,GA_GBUF,GA_GLOAD,GA_GSPLIT,GA_GINFO
/* Gadgets labels of sp */
DEF gsource,gdestin,gcap,gbuf,gload,gsplit,ginfo
/* Application def */
DEF dosfich_source[256]:STRING
DEF dos_destin[256]:STRING
DEF fich_destin[256]:STRING
DEF infotexte[80]:STRING
DEF nbrsfichier,reellong,
    capacite=12,startcap=12,restelastfichier,
    reel_buff=65535,valbuf=1,conv=FALSE
/*********************************/
/* OpenCloseLibraries            */
/*********************************/
PROC p_OpenLibraries() HANDLE /*"p_OpenLibraries()"*/
/********************************************************************************
 * Para     : NONE
 * Return   : ER_NONE if ok,else the error.
 * Description  : Open libraires.
 *******************************************************************************/
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GRAPHICSLIB)
    IF (aslbase:=OpenLibrary('asl.library',37))=NIL THEN Raise(ER_ASLLIB)
    IF (mathtransbase:=OpenLibrary('mathtrans.library',37))=NIL THEN Raise(ER_MATHTRANSLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_CloseLibraries()  /*"p_CloseLibraries()"*/
/********************************************************************************
 * Para     : NONE
 * Return   : NONE
 * Description  : CLose Libraries.
 *******************************************************************************/
    IF mathtransbase THEN CloseLibrary(mathtransbase)
    IF aslbase THEN CloseLibrary(aslbase)
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
/*********************************/
/* ScreenWindow Proc             */
/*********************************/
PROC p_SetUpScreen() HANDLE /*"p_SetUpScreen()"*/
/********************************************************************************
 * Para     : NONE
 * Return   : ER_NONE if ok,else the error.
 * Description  : Lock Pubscreen workbench.
 *******************************************************************************/
    IF (screen:=LockPubScreen('Workbench'))=NIL THEN Raise(ER_LOCKSCREEN)
    IF (visual:=GetVisualInfoA(screen,NIL))=NIL THEN Raise(ER_VISUAL)
    offy:=screen.wbortop+Int(screen.rastport+58)+1
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_SetDownScreen() /*"p_SetDownScreen()"*/
/********************************************************************************
 * Para     : NONE
 * Return   : NONE
 * Description  : Unlock pubscreen workbench.
 *******************************************************************************/
    IF visual THEN FreeVisualInfo(visual)
    IF screen THEN UnlockPubScreen(NIL,screen)
ENDPROC
PROC p_InitspWindow() HANDLE /*"p_InitspWindow()"*/
/********************************************************************************
 * Para     : NONE
 * Return   : ER_NONE if ok,else the error.
 * Description  : Init Window.
 *******************************************************************************/
    IF (sp_glist:=CreateContext({sp_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (gsource:=CreateGadgetA(TEXT_KIND,sp_glist,[177,17,201,12,'Fichier Source',tattr,0,1,visual,0]:newgadget,[GTTX_BORDER,TRUE,GTTX_TEXT,'None.',GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (gdestin:=CreateGadgetA(TEXT_KIND,gsource,[177,31,201,12,'Dossier Destination',tattr,1,1,visual,0]:newgadget,[GTTX_BORDER,TRUE,GTTX_TEXT,'None.',GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (gcap:=CreateGadgetA(MX_KIND,gdestin,[28,47,17,9,'',tattr,2,2,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTMX_LABELS,['880 Ko.','1600 Ko.',0],GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (gbuf:=CreateGadgetA(MX_KIND,gcap,[269,47,17,9,'',tattr,3,2,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTMX_LABELS,['65535 Ko.','131070 Ko.','262140 Ko.',0],GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (gload:=CreateGadgetA(BUTTON_KIND,gbuf,[138,48,101,12,'Load',tattr,4,16,visual,0]:newgadget,[GA_IMMEDIATE,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (gsplit:=CreateGadgetA(BUTTON_KIND,gload,[138,61,101,12,'Split',tattr,5,16,visual,0]:newgadget,[GA_IMMEDIATE,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (ginfo:=CreateGadgetA(TEXT_KIND,gsplit,[9,76,373,12,'',tattr,6,0,visual,0]:newgadget,[GTTX_BORDER,TRUE,GTTX_TEXT,'None.',GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RenderspWindow(texte) /*"p_RenderspWindow(texte)"*/
/********************************************************************************
 * Para     : texte (STRING).
 * Return   : NONE
 * Description  : Rebuild graphical interface.
 *******************************************************************************/
   StrCopy(infotexte,texte,ALL)
   IF conv=FALSE
       Gt_SetGadgetAttrsA(gsource,sp_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,'None.',GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0])
       Gt_SetGadgetAttrsA(gdestin,sp_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,'None.',GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0])
       Gt_SetGadgetAttrsA(ginfo,sp_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,texte,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0])
       Gt_SetGadgetAttrsA(gsplit,sp_window,NIL,[GA_DISABLED,TRUE,GT_UNDERSCORE,"_",TAG_DONE,0])
   ELSE
       Gt_SetGadgetAttrsA(gsource,sp_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,dosfich_source,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0])
       Gt_SetGadgetAttrsA(gdestin,sp_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,dos_destin,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0])
       Gt_SetGadgetAttrsA(ginfo,sp_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,texte,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0])
       Gt_SetGadgetAttrsA(gsplit,sp_window,NIL,[GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0])
   ENDIF
   DrawBevelBoxA(sp_window.rport,9,46,111,29,[GA_BORDER,TRUE,GT_VISUALINFO,visual,TAG_DONE,0])
   DrawBevelBoxA(sp_window.rport,125,46,126,29,[GTBB_RECESSED,1,GT_VISUALINFO,visual,TAG_DONE,0])
   DrawBevelBoxA(sp_window.rport,257,46,127,29,[GT_VISUALINFO,visual,TAG_DONE,0])
   DrawBevelBoxA(sp_window.rport,9,13,376,32,[GA_BORDER,TRUE,GT_VISUALINFO,visual,TAG_DONE,0])
   RefreshGList(gsource,sp_window,NIL,-1)
   Gt_RefreshWindow(sp_window,NIL)
ENDPROC
PROC p_OpenspWindow() HANDLE /*"p_OpenspWindow()"*/
/********************************************************************************
 * Para     : NONE
 * Return   : ER_NONE if ok,else the error.
 * Description  : Open the window.
 *******************************************************************************/
    IF (sp_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,10,
                       WA_TOP,10,
                       WA_WIDTH,388,
                       WA_HEIGHT,90,
                       WA_IDCMP,IDCMP_CLOSEWINDOW+IDCMP_REFRESHWINDOW+IDCMP_GADGETDOWN,
                       WA_FLAGS,$102E+WFLG_HASZOOM,
                       WA_GADGETS,sp_glist,
                       WA_TITLE,'SplitF v0.1 © 1994 NasGûl',
                       WA_ZOOM,[10,10,388,11]:INT,
                       WA_SCREENTITLE,'Made With GadToolsBox v2.0 © 1991-1993',
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    p_RenderspWindow('None.')
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RemspWindow() /*"p_RemspWindow()"*/
/********************************************************************************
 * Para     : NONE
 * Return   : NONE
 * Description  : Remove the window.
 *******************************************************************************/
    IF sp_window THEN CloseWindow(sp_window)
    IF sp_glist THEN FreeGadgets(sp_glist)
ENDPROC
/*********************************/
/* Message proc                  */
/*********************************/
PROC p_LookAllMessage() /*"p_LookAllMessage()"*/
/********************************************************************************
 * Para     : NONE
 * Return   : NONE
 * Description  : Look All Message (window and CtrlC()).
 *******************************************************************************/
    DEF sigreturn
    DEF spport:PTR TO mp
    IF sp_window THEN spport:=sp_window.userport ELSE spport:=NIL
    sigreturn:=Wait(Shl(1,spport.sigbit) OR
                    $F000)
    IF (sigreturn AND Shl(1,spport.sigbit))
        p_LookspMessage()
    ENDIF
    IF (sigreturn AND $F000)
        reelquit:=TRUE
    ENDIF
ENDPROC
PROC p_LookspMessage() /*"p_LookspMessage()"*/
/********************************************************************************
 * Para     : NONE
 * Return   : NONE
 * Description  : Look window mesaage.
 *******************************************************************************/
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF selec
   DEF type=0,infos=NIL
   DEF long=NIL
   IF mes:=Gt_GetIMsg(sp_window.userport)
      type:=mes.class
      SELECT type
         CASE IDCMP_MENUPICK
            infos:=mes.code
            SELECT infos
            ENDSELECT
         CASE IDCMP_REFRESHWINDOW
            p_RenderspWindow(infotexte)
         CASE IDCMP_GADGETDOWN
            g:=mes.iaddress
            infos:=g.gadgetid
            SELECT infos
               CASE GA_GSOURCE
               CASE GA_GDESTIN
               CASE GA_GCAP
                  selec:=mes.code
                  SELECT selec
                     CASE 0;  startcap:=12
                     CASE 1;  startcap:=24
                  ENDSELECT
               CASE GA_GBUF
                  selec:=mes.code
                  SELECT selec
                     CASE 0;   valbuf:=1
                     CASE 1;   valbuf:=2
                     CASE 2;   valbuf:=4
                  ENDSELECT
               CASE GA_GLOAD
                  IF p_FileRequester(F_LOAD,'charger un fichier')
                     IF (long:=FileLength(dosfich_source))>800000
                        IF p_FileRequester(F_SAVE,'Choississez un dossier')
                           conv:=TRUE
                           reellong:=long
                           StringF(infotexte,'Longueur :\d Octets.',long)
                           p_RenderspWindow(infotexte)
                        ELSE
                           conv:=FALSE
                           StrCopy(dosfich_source,'',ALL)
                           p_RenderspWindow('None.')
                        ENDIF
                     ELSE
                        conv:=FALSE
                        StrCopy(dosfich_source,'',ALL)
                        p_RenderspWindow('Ce fichier tient sur 1 disk.')
                     ENDIF
                  ELSE
                     conv:=FALSE
                     StrCopy(dosfich_source,'',ALL)
                     p_RenderspWindow('None.')
                  ENDIF
               CASE GA_GSPLIT
                  IF p_DoSplitFichier(dosfich_source,fich_destin,dos_destin,reellong)=ER_NONE THEN p_RenderspWindow('Split Ok.')
               CASE GA_GINFO
            ENDSELECT
         CASE IDCMP_CLOSEWINDOW
            reelquit:=TRUE
      ENDSELECT
      Gt_ReplyIMsg(mes)
   ENDIF
   reel_buff:=Mul(65535,valbuf)
   capacite:=Div(startcap,valbuf)
ENDPROC
/*********************************/
/* Application Proc              */
/*********************************/
PROC p_FileRequester(func,titre) /*"p_FileRequester(func,titre)"*/
/********************************************************************************
 * Para     : function (F_LOAD ou F_SAVE),titre (STRING).
 * Return   : TRURE if ok,else FASLE.
 * Description  : PopUp a AslFileRequester.
 *******************************************************************************/
    DEF req:PTR TO filerequestr
    DEF ret=FALSE
    DEF tag
    DEF doit
    IF func=F_LOAD
        tag:=[ASL_FUNCFLAGS,FILF_PATGAD,ASL_HAIL,titre,0]
    ELSE
        tag:=[ASL_FUNCFLAGS,FILF_SAVE,ASL_EXTFLAGS1,FIL1F_NOFILES,ASL_HAIL,titre,0]
    ENDIF
    IF req:=AllocAslRequest(ASL_FILEREQUEST,tag)
        IF doit:=RequestFile(req)
            SELECT func
               CASE F_LOAD
                    StringF(fich_destin,'\s',req.file)
                    AddPart(req.dir,'',256)
                    StringF(dosfich_source,'\s\s',req.dir,req.file)
               CASE F_SAVE
                    StringF(dos_destin,'\s',req.dir)
            ENDSELECT
        ENDIF
        FreeAslRequest(req)
    ENDIF
    IF doit
      RETURN TRUE
    ENDIF
    RETURN ret
ENDPROC
PROC p_DoSplitFichier(dfs,fichier_source,dossier_destin,longueur) HANDLE /*"p_DoSplitFichier(dfs,fichier_source,dossier_destin,longueur)"*/
/********************************************************************************
 * Para     : dossier/fichier source,fichier destination,dossier destination,longueur.
 * Return   : ER_NONE if ok,else the error.
 * Description  : Split the file.
 *******************************************************************************/
    DEF h_s=NIL,h_d=NIL
    DEF b,j
    DEF fichier_destin[256]:STRING
    DEF data=NIL,resteboucle=NIL,reste=NIL
    AddPart(dossier_destin,'',256)
    nbrsfichier:=SpFix(SpDiv(SpMul(SpFlt(capacite),SpFlt(reel_buff)),SpFlt(longueur)))
    restelastfichier:=longueur-Mul(nbrsfichier,Mul(capacite,reel_buff))
    StringF(infotexte,'Nbrs de fichiers:\d (\d Octets.)',nbrsfichier,Mul(capacite,reel_buff))
    p_RenderspWindow(infotexte)
    Delay(50)
    StringF(infotexte,'Longueur du dernier fichier:\d Octets.',restelastfichier)
    p_RenderspWindow(infotexte)
    Delay(50)
    IF h_s:=Open(dfs,1005)
        FOR b:=1 TO nbrsfichier
            StringF(fichier_destin,'\s\s.Part\d',dossier_destin,fichier_source,b)
            StringF(infotexte,'\s',fichier_destin)
            p_RenderspWindow(infotexte)
            Delay(10)
            IF h_d:=Open(fichier_destin,1006)
                FOR j:=1 TO capacite
                    data:=New(reel_buff)
                    Read(h_s,data,reel_buff)
                    Write(h_d,data,reel_buff)
                    Dispose(data)
                    CtrlC()
                ENDFOR
                IF h_d THEN Close(h_d)
            ENDIF
            CtrlC()
        ENDFOR
        StringF(fichier_destin,'\s\s.Part\d',dossier_destin,fichier_source,b)
        StringF(infotexte,'Dernier Fichier :\s',fichier_destin)
        p_RenderspWindow(infotexte)
        Delay(10)
        IF h_d:=Open(fichier_destin,1006)
            resteboucle:=SpFix(SpDiv(SpFlt(reel_buff),SpFlt(restelastfichier)))
            FOR b:=1 TO resteboucle
                data:=New(reel_buff)
                Read(h_s,data,reel_buff)
                Write(h_d,data,reel_buff)
                Dispose(data)
                CtrlC()
            ENDFOR
            reste:=restelastfichier-Mul(resteboucle,reel_buff)
            data:=New(reste)
            Read(h_s,data,reste)
            Write(h_d,data,reste)
            Dispose(data)
        ENDIF
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF h_d THEN Close(h_d)
    IF h_s THEN Close(h_s)
    IF data THEN Dispose(data)
    RETURN exception
ENDPROC
/*********************************/
/* Main Proc                     */
/*********************************/
PROC main() HANDLE /*"main()"*/
/********************************************************************************
 * Para     : NONE
 * Return   : ER_NONE if ok,else the error.
 * Description  : Main Procedure.
 *******************************************************************************/
    DEF testmain
    tattr:=['topaz.font',8,0,0]:textattr
    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_SetUpScreen())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_InitspWindow())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_OpenspWindow())<>ER_NONE THEN Raise(testmain)
    REPEAT
        p_LookAllMessage()
    UNTIL reelquit=TRUE
    Raise(ER_NONE)
EXCEPT
    p_RemspWindow()
    p_SetDownScreen()
    p_CloseLibraries()
    SELECT exception
        CASE ER_LOCKSCREEN; WriteF('Lock Screen Failed.\n')
        CASE ER_VISUAL;     WriteF('Error Visual.\n')
        CASE ER_CONTEXT;    WriteF('Error Context.\n')
        CASE ER_MENUS;      WriteF('Error Menus.\n')
        CASE ER_GADGET;     WriteF('Error Gadget.\n')
        CASE ER_WINDOW;     WriteF('Error Window.\n')
    ENDSELECT
ENDPROC
