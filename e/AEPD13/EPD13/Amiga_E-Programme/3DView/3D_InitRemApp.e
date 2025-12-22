PROC start_from_cli() /*"start_from_cli()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : ER_NONE if ok,else the error.
 * Description  : Parse cli arguments.
 *******************************************************************************/
    DEF pro:PTR TO process,myargs:PTR TO LONG,rdargs,tyscr,str[8]:STRING
    pro:=task
    myargs:=[0,0,0]
    base_lock:=CurrentDir(pro.currentdir)
    IF rdargs:=ReadArgs('FICHIER/A,DID/K,BLACK/S',myargs,NIL)
        StrCopy(fichier_source,myargs[0],ALL)
        StrCopy(str,myargs[1],StrLen(myargs[1]))
        UpperStr(str)
        StrAdd(str,'  ',2)
        tyscr:=Long(str)
        SELECT tyscr
            CASE ID_BR
                type_scr:=LORES_KEY
                tattr:=['topaz.font',8,0,0]:textattr
            CASE ID_BRE
                type_scr:=LORESLACE_KEY
                tattr:=['topaz.font',8,0,0]:textattr
            CASE ID_HR
                type_scr:=HIRES_KEY
                tattr:=['topaz.font',8,0,0]:textattr
            CASE ID_HRE
                type_scr:=HIRESLACE_KEY
            CASE ID_SHR
                type_scr:=SUPER_KEY
                tattr:=['topaz.font',9,0,0]:textattr
            CASE ID_SHRE
                type_scr:=SUPERLACE_KEY
                tattr:=['topaz.font',9,0,0]:textattr
            DEFAULT
                type_scr:=SUPERLACE_KEY
                tattr:=['topaz.font',9,0,0]:textattr
        ENDSELECT
        type_scr:=type_scr+PAL_MONITOR_ID
        FreeArgs(rdargs)
        IF myargs[2] THEN palette:=[$000,$BBB,$787,$068]:INT ELSE palette:=[$787,$000,$ABB,$068]:INT
    ELSE
        WriteF('Usage :\n')
        WriteF('         >3DView [fichier] DID [displayid]\n')
        WriteF('Avec displayid :\n')
        WriteF('BR   320*256 DRE   320*512.\n')
        WriteF('HR   640*256 HRE   640*512.\n')
        WriteF('SHR 1280*256 SHRE 1280*512.\n')
        WriteF('(SHRE par défault).\n')
        RETURN ER_BADARGS
    ENDIF
    RETURN ER_NONE
ENDPROC
PROC start_from_wb() /*"start_from_wb()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : ER_NONE ig ok,else the error.
 * Description  : Parse WB arguments.
 *******************************************************************************/
    DEF wb:PTR TO wbstartup /*wb_args:PTR TO wbarg */
    DEF args:PTR TO wbarg
    DEF s_d_o:PTR TO diskobject
    DEF pivstr,str[8]:STRING,tyscr
    DEF nom_prg[256]:STRING,piv_lock
    wb:=wbmessage
    args:=wb.arglist
    StrCopy(nom_prg,args[0].name,ALL)
    piv_lock:=CurrentDir(args[0].lock)
    IF s_d_o:=GetDiskObject(nom_prg)
        pivstr:=FindToolType(s_d_o.tooltypes,'DID')
        StrCopy(str,pivstr,StrLen(pivstr))
        UpperStr(str)
        StrAdd(str,'  ',2)
        tyscr:=Long(str)
        SELECT tyscr
            CASE ID_BR
                type_scr:=LORES_KEY
                tattr:=['topaz.font',8,0,0]:textattr
            CASE ID_BRE
                type_scr:=LORESLACE_KEY
                tattr:=['topaz.font',8,0,0]:textattr
            CASE ID_HR
                type_scr:=HIRES_KEY
                tattr:=['topaz.font',8,0,0]:textattr
            CASE ID_HRE
                type_scr:=HIRESLACE_KEY
                tattr:=['topaz.font',8,0,0]:textattr
            CASE ID_SHR
                type_scr:=SUPER_KEY
                tattr:=['topaz.font',9,0,0]:textattr
            CASE ID_SHRE
                type_scr:=SUPERLACE_KEY
                tattr:=['topaz.font',9,0,0]:textattr
            DEFAULT
                type_scr:=SUPERLACE_KEY
                tattr:=['topaz.font',9,0,0]:textattr
        ENDSELECT
        type_scr:=type_scr+PAL_MONITOR_ID
        pivstr:=FindToolType(s_d_o.tooltypes,'PALETTE')
        IF StrCmp('BLACK',pivstr,5) THEN palette:=[$000,$BBB,$787,$068]:INT ELSE palette:=[$787,$000,$ABB,$068]:INT
        FreeDiskObject(s_d_o)
    ENDIF
    CurrentDir(piv_lock)
    StrCopy(fichier_source,args[1].name,ALL)
    base_lock:=CurrentDir(args[1].lock)
    RETURN ER_NONE
ENDPROC
PROC open_lib() HANDLE /*"open_lib()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : ER_NONE if ok,else the error.
 * Description  : Open libraries.
 *******************************************************************************/
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GFXLIB)
    IF (reqtoolsbase:=OpenLibrary('reqtools.library',38))=NIL THEN Raise(ER_REQTOOLSLIB)
    IF (iconbase:=OpenLibrary('icon.library',37))=NIL THEN Raise(ER_ICONLIB)
    IF (mathtransbase:=OpenLibrary('mathtrans.library',37))=NIL THEN Raise(ER_MATHTRANSLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC close_lib() /*"close_lib()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Close Libraries.
 *******************************************************************************/
    IF mathtransbase THEN CloseLibrary(mathtransbase)
    IF iconbase THEN CloseLibrary(iconbase)
    IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
PROC open_interface() HANDLE /*"open_interface()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : ER_NONE if ok,else the error.
 * Description  : Init 3DVeiwScreen,Open 3DViewScreen,Init ViewWindow,Open ViewWindow,
 *                Init InfoWindow.
 *******************************************************************************/
    DEF windowport:PTR TO mp
    IF (view_screen:=OpenScreenTagList(NIL,          /* get ourselves a public screen */
                                     [SA_TOP,0,
                                      SA_DEPTH,2,
                                      SA_FONT,tattr,
                                      SA_DISPLAYID,type_scr,
                                      SA_PUBNAME,'ViewScreen',
                                      SA_TITLE,title_req,
                                      SA_PUBSIG,IF (sig:=AllocSignal(-1))=NIL THEN Raise(ER_SIG) ELSE sig,
                                      SA_PUBTASK,task,
                                      SA_AUTOSCROLL,TRUE,
                                      SA_OVERSCAN,OSCAN_TEXT,
                                      SA_PENS,[0,1,1,2,1,3,1,0,2,1,2,1]:INT,
                                      0,0]))=NIL THEN Raise(ER_SCREEN)
    PubScreenStatus(view_screen,0)                 /* make it available */
    /* Centre et Ratio de l'écran */
    centre_x:=Div(view_screen.width,2)
    centre_y:=Div(view_screen.height,2)
    format:=SpDiv(SpFlt(view_screen.height),SpFlt(view_screen.width))
    IF (view_window:=OpenW(0,0,view_screen.width,view_screen.height,$400700,$190E,'ViewWindow',view_screen,15,NIL))=NIL THEN Raise(ER_WINDOW)
    LoadRGB4(ViewPortAddress(view_window),palette,4)
    Gt_RefreshWindow(view_window,NIL)
    windowport:=view_window.userport
    viewwindow_sig:=windowport.sigbit
    viewwindow_sig:=Shl(1,viewwindow_sig)
    IF (wininfo_visual:=GetVisualInfoA(view_screen,NIL))=NIL THEN Raise(ER_VISUAL)
    IF (g:=CreateContext({wininfo_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (g_num:=CreateGadgetA(TEXT_KIND,g,[24,19,126,14,'Numéro',wintattr,0,2,wininfo_visual,0]:newgadget,[GTTX_TEXT,'0',GTTX_BORDER,TRUE,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_nbrspts:=CreateGadgetA(TEXT_KIND,g_num,[24,34,126,14,'NbrsPts',wintattr,1,2,wininfo_visual,0]:newgadget,[GTTX_TEXT,texte,GTTX_BORDER,TRUE,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_nbrsfaces:=CreateGadgetA(TEXT_KIND,g_nbrspts,[24,49,126,14,'NbrsFaces',wintattr,2,2,wininfo_visual,0]:newgadget,[GTTX_TEXT,texte,GTTX_BORDER,TRUE,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_datafaces:=CreateGadgetA(TEXT_KIND,g_nbrsfaces,[24,79,126,14,'DataFaces',wintattr,3,2,wininfo_visual,0]:newgadget,[GTTX_TEXT,texte,GTTX_BORDER,TRUE,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_datapts:=CreateGadgetA(TEXT_KIND,g_datafaces,[24,64,126,14,'DataPts',wintattr,4,2,wininfo_visual,0]:newgadget,[GTTX_TEXT,texte,GTTX_BORDER,TRUE,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_objcx:=CreateGadgetA(TEXT_KIND,g_datapts,[266,20,126,14,'Objet Centre X',wintattr,5,2,wininfo_visual,0]:newgadget,[GTTX_TEXT,texte,GTTX_BORDER,TRUE,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_objcy:=CreateGadgetA(TEXT_KIND,g_objcx,[266,35,126,14,'Objet Centre Y',wintattr,6,2,wininfo_visual,0]:newgadget,[GTTX_TEXT,texte,GTTX_BORDER,TRUE,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_objcz:=CreateGadgetA(TEXT_KIND,g_objcy,[266,50,126,14,'Objet Centre Z',wintattr,7,2,wininfo_visual,0]:newgadget,[GTTX_TEXT,texte,GTTX_BORDER,TRUE,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_objminx:=CreateGadgetA(TEXT_KIND,g_objcz,[20,101,126,14,'Objet MinX',wintattr,8,2,wininfo_visual,0]:newgadget,[GTTX_TEXT,texte,GTTX_BORDER,TRUE,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_objmaxx:=CreateGadgetA(TEXT_KIND,g_objminx,[20,116,126,14,'Objet MaxX',wintattr,9,2,wininfo_visual,0]:newgadget,[GTTX_TEXT,texte,GTTX_BORDER,TRUE,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_objminy:=CreateGadgetA(TEXT_KIND,g_objmaxx,[20,131,126,14,'Objet MinY',wintattr,10,2,wininfo_visual,0]:newgadget,[GTTX_TEXT,texte,GTTX_BORDER,TRUE,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_objmaxy:=CreateGadgetA(TEXT_KIND,g_objminy,[20,146,126,14,'Objet MaxY',wintattr,11,2,wininfo_visual,0]:newgadget,[GTTX_TEXT,texte,GTTX_BORDER,TRUE,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_objminz:=CreateGadgetA(TEXT_KIND,g_objmaxy,[20,161,126,14,'Objet MinZ',wintattr,12,2,wininfo_visual,0]:newgadget,[GTTX_TEXT,texte,GTTX_BORDER,TRUE,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_objmaxz:=CreateGadgetA(TEXT_KIND,g_objminz,[20,175,126,14,'Objet MaxZ',wintattr,13,2,wininfo_visual,0]:newgadget,[GTTX_TEXT,texte,GTTX_BORDER,TRUE,GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_listobj:=CreateGadgetA(LISTVIEW_KIND,g_objmaxz,[258,71,275,73,'Object(s)',wintattr,14,8,wininfo_visual,0]:newgadget,[GTLV_SHOWSELECTED,NIL,GTLV_LABELS,-1,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_objselected:=CreateGadgetA(CHECKBOX_KIND,g_listobj,[263,149,26,11,'Object Selected',wintattr,15,2,wininfo_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTCB_CHECKED,FALSE,GT_UNDERSCORE,"_", TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_objbounded:=CreateGadgetA(CHECKBOX_KIND,g_objselected,[263,162,26,11,'Object Bounded',wintattr,17,2,wininfo_visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTCB_CHECKED,FALSE,GT_UNDERSCORE,"_", TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_objtype:=CreateGadgetA(TEXT_KIND,g_objbounded,[263,174,160,14,'Object Type',wintattr,16,2,wininfo_visual,0]:newgadget,[GTTX_TEXT,texte,GTTX_BORDER,TRUE,GT_UNDERSCORE,"_", TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC close_interface() /*"close_interface()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Free All (InfoWindow,ViewWindow,Signal and 3DViewScreen).
 *******************************************************************************/
    IF wininfo_visual THEN FreeVisualInfo(wininfo_visual)
    IF wininfo_glist THEN FreeGadgets(wininfo_glist)
    IF sig THEN FreeSignal(sig)
    IF view_window THEN CloseWindow(view_window)
    /*IF view_screen THEN UnlockPubScreen(view_screen,NIL)*/
    IF view_screen THEN CloseScreen(view_screen)
ENDPROC

