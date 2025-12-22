/*==================================================*/
/* Source code generate by Gui2E v0.1 © 1994 NasGûl */
/*==================================================*/

/*======<<< Peps Header >>>======
 PRGVERSION '0'
 ================================
 PRGREVISION '13'
 ================================
 AUTHOR      'NasGûl'
 ===============================*/
/*==============================
 20-09-94 - mise au format (font ecran).
 05-10-94 - ajout des subtypes.
 15-02-95 - s'ouvre sur l'écran public par défaut.
 12-03-95 - Edition des icônes par défaut.
 02-04-95 - Localisation.
 ===============================*/
OPT OSVERSION=37

MODULE 'intuition/intuition','gadtools','libraries/gadtools','intuition/gadgetclass','intuition/screens',
       'graphics/text','exec/lists','exec/nodes','exec/ports','eropenlib','utility/tagitem',
       'intuition/intuitionbase'
MODULE 'whatis','wvprefs'
MODULE 'asl','libraries/asl','utility'
MODULE 'wb','exec/execbase','exec/libraries','dos/var'
MODULE 'mheader'

ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW,
     ER_MEM
RAISE ER_MEM IF New()=NIL,
      ER_MEM IF String()=NIL

CONST LOAD_PREFS=0,
      SAVE_PREFS=1

CONST DEBUG=FALSE

DEF screen:PTR TO screen,
    visual=NIL,
    tattr:PTR TO textattr,
    reelquit=FALSE,
    offy,offx
/*======================================
 = wp Definitions
 ======================================*/
DEF wp_window=NIL:PTR TO window
DEF wp_menu
DEF wp_glist
/* Gadgets */
ENUM GA_G_COMMAND,GA_G_GETCOMMAND,GA_G_EXECTYPE,
     GA_G_STACK,GA_G_PRI,GA_G_LOAD,GA_G_SAVE,
     GA_G_SAVEAS,GA_G_ADD,GA_G_REM,GA_G_IDLIST,
     GA_G_ACTIONLIST,GA_GA_G_PARENTTYPE,GA_G_USEPARENTTYPE

/* Gadgets labels of wp */
DEF g_command,g_getcommand,g_exectype,
    g_stack,g_pri,g_load,g_save,g_saveas,
    g_add,g_rem,g_idlist,g_actionlist,g_parenttype,g_useparenttype
/* Application def       */
DEF mywvbase:PTR TO wvbase
DEF curidnode=0
DEF curactionnode=0
DEF defdir[256]:STRING
DEF icdir[256]:STRING
DEF defact=-1

PMODULE 'Pmodules:Plist/p_DoUpNode'
PMODULE 'WVPrefsData'
PMODULE 'WhatView_Cat'
PMODULE 'PModules:PMHeader'
/********************************************************************************
 * Fichier      : DWriteF.e
 * Procédures   : dWriteF(PTR TO LONG,PTR TO LONG)
 * Informations : WriteF() if DEBUG=TRUE
 *******************************************************************************/
/*"Window Proc"*/
/*"p_SetUpScreen()"*/
PROC p_SetUpScreen() HANDLE 
    DEF pt:PTR TO textattr
    dWriteF(['p_SetUpScreen()\n'],[0])
    IF (screen:=LockPubScreen(p_LockActivePubScreen()))=NIL THEN Raise(ER_LOCKSCREEN)
    IF (visual:=GetVisualInfoA(screen,NIL))=NIL THEN Raise(ER_VISUAL)
    offy:=screen.wbortop+Int(screen.rastport+58)-10
    pt:=screen.font
    IF pt.ysize<=8
        tattr:=[pt.name,pt.ysize,0,0]:textattr
    ELSE
        tattr:=['topaz.font',8,0,0]:textattr
    ENDIF
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_SetDownScreen()"*/
PROC p_SetDownScreen() 
    dWriteF(['p_SetDownScreen()\n'],[0])
    IF visual THEN FreeVisualInfo(visual)
    IF screen THEN UnlockPubScreen(NIL,screen)
ENDPROC
/**/
/*"p_LockActivePubScreen()"*/
PROC p_LockActivePubScreen()
    DEF ps:PTR TO pubscreennode
    DEF s:PTR TO screen
    DEF sn:PTR TO ln
    DEF psl:PTR TO lh
    DEF ret=NIL
    DEF myintui:PTR TO intuitionbase
    ret:=NIL
    myintui:=intuitionbase
    s:=myintui.activescreen
    IF psl:=LockPubScreenList()
        sn:=psl.head
        WHILE sn
            ps:=sn
            IF sn.succ<>0
                IF ps.screen=s THEN ret:=sn.name
            ENDIF
            sn:=sn.succ
        ENDWHILE
        UnlockPubScreenList()
    ENDIF
    RETURN ret
ENDPROC
/**/
/*"p_InitwpWindow()"*/
PROC p_InitwpWindow() HANDLE 
    DEF g:PTR TO gadget
    dWriteF(['p_InitwpWindow()\n'],[0])
    IF (g:=CreateContext({wp_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (wp_menu:=CreateMenusA([1,0,get_WhatView_string(MSGWVPREFS_MENU_DEFACT),0,0,0,0,
                               2,0,get_WhatView_string(MSGWVPREFS_MENU_OPENWIN),'O',257,30,0,
                               2,0,get_WhatView_string(MSGWVPREFS_MENU_WHATVIEW),'W',$1,29,0,
                               2,0,get_WhatView_string(MSGWVPREFS_MENU_INFO),'I',$1,27,0,
                               2,0,get_WhatView_string(MSGWVPREFS_MENU_ADDICON),'A',$1,23,0,
                               2,0,get_WhatView_string(MSGWVPREFS_MENU_EXECUTE),'E',$1,15,0,
                               2,0,get_WhatView_string(MSGWVPREFS_MENU_QUIT),'Q',$0,0,0,
                               1,0,get_WhatView_string(MSGWVPREFS_MENU_UTILS),0,0,0,0,
                               2,0,get_WhatView_string(MSGWVPREFS_MENU_EDITICON),'C',0,0,0,
                                   0,0,0,0,0,0,0]:newmenu,NIL))=NIL THEN Raise(ER_MENUS)
    IF LayoutMenusA(wp_menu,visual,NIL)=FALSE THEN Raise(ER_MENUS)
    IF (g_command:=CreateGadgetA(TEXT_KIND,g,[offx+88,offy+19,181,12,get_WhatView_string(MSGWVPREFS_GAD_COMMANDE),tattr,0,1,visual,0]:newgadget,[GTTX_BORDER,TRUE,GTTX_TEXT,'',GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    dWriteF(['g_command\n'],[0])
    IF (g_getcommand:=CreateGadgetA(BUTTON_KIND,g_command,[offx+269,offy+19,41,12,'?',tattr,1,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    dWriteF(['g_getcommand\n'],[0])
    IF (g_exectype:=CreateGadgetA(CYCLE_KIND,g_getcommand,[offx+88,offy+32,221,12,get_WhatView_string(MSGWVPREFS_GAD_EXECTYPE),tattr,2,1,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTCY_LABELS,['Mode WB','Mode CLI',0],GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    dWriteF(['g_exectype\n'],[0])
    IF (g_stack:=CreateGadgetA(INTEGER_KIND,g_exectype,[offx+218,offy+45,91,12,get_WhatView_string(MSGWVPREFS_GAD_STACK),tattr,3,1,visual,0]:newgadget,[GTIN_NUMBER,NIL,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    dWriteF(['g_stack\n'],[0])
    IF (g_pri:=CreateGadgetA(INTEGER_KIND,g_stack,[offx+88,offy+45,77,12,get_WhatView_string(MSGWVPREFS_GAD_PRI),tattr,4,1,visual,0]:newgadget,[GTIN_NUMBER,NIL,GA_RELVERIFY,TRUE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    dWriteF(['g_pri\n'],[0])
    IF (g_load:=CreateGadgetA(BUTTON_KIND,g_pri,[offx+16,offy+63,81,12,get_WhatView_string(MSGWVPREFS_GAD_LOAD),tattr,5,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    dWriteF(['g_load\n'],[0])
    IF (g_save:=CreateGadgetA(BUTTON_KIND,g_load,[offx+122,offy+63,81,12,get_WhatView_string(MSGWVPREFS_GAD_SAVE),tattr,6,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    dWriteF(['g_save\n'],[0])
    IF (g_saveas:=CreateGadgetA(BUTTON_KIND,g_save,[offx+229,offy+63,81,12,get_WhatView_string(MSGWVPREFS_GAD_SAVEAS),tattr,7,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    dWriteF(['g_saveas\n'],[0])
    IF (g_add:=CreateGadgetA(BUTTON_KIND,g_saveas,[offx+56,offy+81,81,12,get_WhatView_string(MSGWVPREFS_GAD_ADD),tattr,8,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    dWriteF(['g_add\n'],[0])
    IF (g_rem:=CreateGadgetA(BUTTON_KIND,g_add,[offx+188,offy+81,81,12,get_WhatView_string(MSGWVPREFS_GAD_REM),tattr,9,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    dWriteF(['g_rem\n'],[0])
    IF (g_idlist:=CreateGadgetA(LISTVIEW_KIND,g_rem,[offx+28,offy+106,110,41,get_WhatView_string(MSGWVPREFS_GAD_ID),tattr,10,4,visual,0]:newgadget,[GA_IMMEDIATE,TRUE,GTLV_SHOWSELECTED,NIL,GTLV_LABELS,NIL,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    dWriteF(['g_idlist\n'],[0])
    IF (g_actionlist:=CreateGadgetA(LISTVIEW_KIND,g_idlist,[offx+176,offy+106,110,41,get_WhatView_string(MSGWVPREFS_GAD_ACTION),tattr,11,4,visual,0]:newgadget,[GA_IMMEDIATE,TRUE,GTLV_SHOWSELECTED,NIL,GTLV_LABELS,NIL,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    dWriteF(['g_actionlist\n'],[0])
    IF (g_parenttype:=CreateGadgetA(TEXT_KIND,g_actionlist,[offx+119,offy+152,181,12,get_WhatView_string(MSGWVPREFS_GAD_PARENTTYPE),tattr,12,1,visual,0]:newgadget,[GTTX_BORDER,1,GTTX_TEXT,'',GTTX_COPYTEXT,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_useparenttype:=CreateGadgetA(CHECKBOX_KIND,g_parenttype,[offx+274,offy+167,26,11,get_WhatView_string(MSGWVPREFS_GAD_USEPT),tattr,13,1,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GTCB_CHECKED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RenderwpWindow()"*/
PROC p_RenderwpWindow() 
    DEF infonode:PTR TO actionnode
    DEF n:PTR TO ln
    DEF ty,pty,pidstr[9]:STRING
    dWriteF(['p_RenderwpWindow()\n'],[0])
    p_CheckGoodItem(defact)
    IF (p_EmptyList(mywvbase.adractionlist))<>-1
        infonode:=p_GetAdrNode(mywvbase.adractionlist,curactionnode)
        n:=infonode
        ty:=GetIDType(n.name)
        pty:=ParentFileType(ty)
        Gt_SetGadgetAttrsA(g_command,wp_window,NIL,[GA_DISABLED,FALSE,GTTX_BORDER,TRUE,GTTX_TEXT,infonode.command,TAG_DONE])
        Gt_SetGadgetAttrsA(g_getcommand,wp_window,NIL,[GA_DISABLED,FALSE,TAG_DONE])
        Gt_SetGadgetAttrsA(g_exectype,wp_window,NIL,[GA_DISABLED,FALSE,GTCY_ACTIVE,infonode.exectype,TAG_DONE])
        Gt_SetGadgetAttrsA(g_stack,wp_window,NIL,[GA_DISABLED,FALSE,GTIN_NUMBER,infonode.stack,TAG_DONE])
        Gt_SetGadgetAttrsA(g_pri,wp_window,NIL,[GA_DISABLED,FALSE,GTIN_NUMBER,infonode.priority,TAG_DONE])
        Gt_SetGadgetAttrsA(g_actionlist,wp_window,NIL,[GA_DISABLED,FALSE,GTLV_SHOWSELECTED,TRUE,GTLV_SELECTED,curactionnode,GTLV_LABELS,mywvbase.adractionlist,TAG_DONE])
        Gt_SetGadgetAttrsA(g_rem,wp_window,NIL,[GA_DISABLED,FALSE,TAG_DONE])
        IF pty
            pidstr:=GetIDString(pty)
            Gt_SetGadgetAttrsA(g_parenttype,wp_window,NIL,[GA_DISABLED,FALSE,GTTX_TEXT,pidstr,TAG_DONE])
            Gt_SetGadgetAttrsA(g_useparenttype,wp_window,NIL,[GA_DISABLED,FALSE,GTCB_CHECKED,infonode.usesubtype,TAG_DONE])
        ELSE
            Gt_SetGadgetAttrsA(g_parenttype,wp_window,NIL,[GA_DISABLED,FALSE,GTTX_TEXT,'Aucun.',TAG_DONE])
            Gt_SetGadgetAttrsA(g_useparenttype,wp_window,NIL,[GA_DISABLED,TRUE,GTCB_CHECKED,FALSE,TAG_DONE])
        ENDIF
    ELSE
        Gt_SetGadgetAttrsA(g_command,wp_window,NIL,[GA_DISABLED,TRUE,GTTX_BORDER,TRUE,GTTX_TEXT,'',TAG_DONE])
        Gt_SetGadgetAttrsA(g_getcommand,wp_window,NIL,[GA_DISABLED,TRUE,TAG_DONE])
        Gt_SetGadgetAttrsA(g_exectype,wp_window,NIL,[GA_DISABLED,TRUE,TAG_DONE])
        Gt_SetGadgetAttrsA(g_stack,wp_window,NIL,[GA_DISABLED,TRUE,GTIN_NUMBER,NIL,TAG_DONE])
        Gt_SetGadgetAttrsA(g_pri,wp_window,NIL,[GA_DISABLED,TRUE,GTIN_NUMBER,NIL,TAG_DONE])
        Gt_SetGadgetAttrsA(g_actionlist,wp_window,NIL,[GA_DISABLED,TRUE,GTLV_SHOWSELECTED,NIL,GTLV_LABELS,mywvbase.adremptylist,TAG_DONE])
        Gt_SetGadgetAttrsA(g_rem,wp_window,NIL,[GA_DISABLED,TRUE,TAG_DONE])
        Gt_SetGadgetAttrsA(g_parenttype,wp_window,NIL,[GA_DISABLED,TRUE,GTTX_TEXT,'',TAG_DONE])
        Gt_SetGadgetAttrsA(g_parenttype,wp_window,NIL,[GA_DISABLED,TRUE,TAG_DONE])
    ENDIF
    Gt_SetGadgetAttrsA(g_idlist,wp_window,NIL,[GTLV_SHOWSELECTED,TRUE,GTLV_SELECTED,curidnode,GTLV_LABELS,mywvbase.adridlist,TAG_DONE])
    DrawBevelBoxA(wp_window.rport,offx+9,offy+61,305,16,[GT_VISUALINFO,visual,TAG_DONE])
    DrawBevelBoxA(wp_window.rport,offx+9,offy+13,305,46,[GT_VISUALINFO,visual,TAG_DONE])
    DrawBevelBoxA(wp_window.rport,offx+9,offy+79,305,68,[GT_VISUALINFO,visual,TAG_DONE])
    DrawBevelBoxA(wp_window.rport,offx+9,offy+147,305,33,[GT_VISUALINFO,visual,TAG_DONE,0])
    RefreshGList(g_command,wp_window,NIL,-1)
    Gt_RefreshWindow(wp_window,NIL)
ENDPROC
/**/
/*"p_OpenwpWindow()"*/
PROC p_OpenwpWindow() HANDLE 
    dWriteF(['p_OpenwvWindow()\n'],[0])
    IF (wp_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,10,
                       WA_TOP,10,
                       WA_WIDTH,offx+319,
                       WA_HEIGHT,offy+183,
                       WA_IDCMP,$400278+IDCMP_MENUPICK,
                       WA_FLAGS,$102E,
                       WA_GADGETS,wp_glist,
                       WA_CUSTOMSCREEN,screen,
                       WA_TITLE,title_req,
                       WA_SCREENTITLE,'Made With GadToolsBox v2.0 © 1991-1993',
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    IF SetMenuStrip(wp_window,wp_menu)=FALSE THEN Raise(ER_MENUS)
    p_RenderwpWindow()
    p_CheckGoodItem(defact)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RemwpWindow()"*/
PROC p_RemwpWindow() 
    dWriteF(['p_RemwvWindow()\n'],[0])
    IF wp_window THEN CloseWindow(wp_window)
    IF wp_menu THEN FreeMenus(wp_menu)
    IF wp_glist THEN FreeGadgets(wp_glist)
ENDPROC
/**/
/*"p_LockListView()"*/
PROC p_LockListView() 
    dWriteF(['p_LockListView()\n'],[0])
    Gt_SetGadgetAttrsA(g_actionlist,wp_window,NIL,[GTLV_LABELS,-1,TAG_DONE])
ENDPROC
/**/
/*"p_CheckGoodItem(a)"*/
PROC p_CheckGoodItem(a) 
    DEF adr_item:PTR TO menuitem
    DEF test=NIL
    DEF menu:PTR TO LONG,b
    menu:=[$F800,$F820,$F840,$F860,$F880]
    FOR b:=0 TO 4
        adr_item:=ItemAddress(wp_menu,menu[b])
        IF adr_item.flags=$157
            IF defact<>(b-1)
                adr_item.flags:=$57
            ENDIF
        ENDIF
    ENDFOR
    SELECT a
        CASE -1
            adr_item:=ItemAddress(wp_menu,$F800)
        CASE  0
            adr_item:=ItemAddress(wp_menu,$F820)
        CASE  1
            adr_item:=ItemAddress(wp_menu,$F840)
        CASE  2
            adr_item:=ItemAddress(wp_menu,$F860)
        CASE  3
            adr_item:=ItemAddress(wp_menu,$F880)
    ENDSELECT
    IF (test:=(adr_item.flags AND CHECKED))=FALSE
        adr_item.flags:=adr_item.flags+CHECKED
    ENDIF
ENDPROC
/**/
/**/
/*"Message proc"*/
/*"p_LookAllMessage()"*/
PROC p_LookAllMessage() 
    DEF sigreturn
    DEF wpport:PTR TO mp
    IF wp_window THEN wpport:=wp_window.userport ELSE wpport:=NIL
    sigreturn:=Wait(Shl(1,wpport.sigbit) OR
                    $F000)
    IF (sigreturn AND Shl(1,wpport.sigbit))
        p_LookwpMessage()
    ENDIF
    IF (sigreturn AND $F000)
        reelquit:=TRUE
    ENDIF
ENDPROC
/**/
/*"p_LookwpMessage()"*/
PROC p_LookwpMessage() 
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF gstr:PTR TO stringinfo
   DEF type=0,infos=NIL
   DEF actnode:PTR TO actionnode,usesb
   DEF myreq:requester
   WHILE (mes:=Gt_GetIMsg(wp_window.userport))
       type:=mes.class
       SELECT type
           CASE IDCMP_MENUPICK
              infos:=mes.code
              SELECT infos
                  CASE $F800 /* OPENWIN (def) */
                      defact:=-1
                      p_SavePrefsFile(mywvbase.adractionlist,'Env:WhatView.Prefs')
                  CASE $F820 /* WHATVIEW */
                      defact:=0
                      p_SavePrefsFile(mywvbase.adractionlist,'Env:WhatView.Prefs')
                  CASE $F840 /* INFO */
                      defact:=1
                      p_SavePrefsFile(mywvbase.adractionlist,'Env:WhatView.Prefs')
                  CASE $F860 /* ADDICON */
                      defact:=2
                      p_SavePrefsFile(mywvbase.adractionlist,'Env:WhatView.Prefs')
                  CASE $F880 /* EXECUTE */
                      defact:=3
                      p_SavePrefsFile(mywvbase.adractionlist,'Env:WhatView.Prefs')
                  CASE $F8A0 /* QUIT */
                      reelquit:=TRUE
                  CASE $F801 /* EditIcon */
                    IF p_EmptyList(mywvbase.adractionlist)<>-1 
                        IF beginWait(wp_window,myreq)
                            p_GetIconInfo(curactionnode)
                            endWait(wp_window,myreq)
                        ENDIF
                    ENDIF
              ENDSELECT
           CASE IDCMP_CLOSEWINDOW
              reelquit:=TRUE
           CASE IDCMP_GADGETDOWN
              type:=IDCMP_GADGETUP
           CASE IDCMP_GADGETUP
              g:=mes.iaddress
              infos:=g.gadgetid
              SELECT infos
                  CASE GA_G_COMMAND
                  CASE GA_G_GETCOMMAND
                      p_LockListView()
                      p_FileRequester(curactionnode,NIL)
                      p_RenderwpWindow()
                  CASE GA_G_EXECTYPE
                      actnode:=p_GetAdrNode(mywvbase.adractionlist,curactionnode)
                      actnode.exectype:=mes.code
                      IF actnode.exectype=MODE_WB
                          IF p_NoIcon(actnode.currentdir,actnode.command)=TRUE 
                              EasyRequestArgs(0,[20,0,0,get_WhatView_string(MSGWVPREFS_REQ_EXECNOICON),get_WhatView_string(MSGWHATVIEW_COMASS_GAD)],0,[actnode.command])
                              /*
                              actnode.exectype:=MODE_CLI
                              Gt_SetGadgetAttrsA(g_exectype,wp_window,NIL,[GA_DISABLED,FALSE,GTCY_ACTIVE,actnode.exectype,TAG_DONE])
                              p_RenderwpWindow()
                              */
                          ENDIF
                      ENDIF
                  CASE GA_G_STACK
                      gstr:=g.specialinfo
                      actnode:=p_GetAdrNode(mywvbase.adractionlist,curactionnode)
                      actnode.stack:=Val(gstr.buffer,NIL)
                  CASE GA_G_PRI
                      gstr:=g.specialinfo
                      actnode:=p_GetAdrNode(mywvbase.adractionlist,curactionnode)
                      actnode.stack:=Val(gstr.buffer,NIL)
                  CASE GA_G_LOAD
                      p_LockListView()
                      p_FileRequester(-1,LOAD_PREFS)
                      p_RenderwpWindow()
                  CASE GA_G_SAVE
                      p_LockListView()
                      p_SavePrefsFile(mywvbase.adractionlist,'Env:WhatView.Prefs')
                      p_SavePrefsFile(mywvbase.adractionlist,'Envarc:WhatView.Prefs')
                      p_RenderwpWindow()
                  CASE GA_G_SAVEAS
                      p_LockListView()
                      p_FileRequester(-1,SAVE_PREFS)
                      p_RenderwpWindow()
                  CASE GA_G_ADD
                      p_LockListView()
                      p_AjouteActionNode(curidnode,mywvbase.adractionlist)
                      p_RenderwpWindow()
                  CASE GA_G_REM
                      p_LockListView()
                      curactionnode:=p_EnleveActionNode(mywvbase.adractionlist,curactionnode)
                      p_RenderwpWindow()
                  CASE GA_G_IDLIST
                      curidnode:=mes.code
                  CASE GA_G_ACTIONLIST
                      curactionnode:=mes.code
                      p_RenderwpWindow()
                  CASE GA_G_USEPARENTTYPE
                      actnode:=p_GetAdrNode(mywvbase.adractionlist,curactionnode)
                      actnode.usesubtype:=mes.code
              ENDSELECT
       ENDSELECT
       Gt_ReplyIMsg(mes)
   ENDWHILE
ENDPROC
/**/
/**/
/*"Application proc"*/
/*"p_InitWVAPP()"*/
PROC p_InitWVAPP() HANDLE 
    dWriteF(['p_InitWVAPP()\n'],[0])
    mywvbase:=New(SIZEOF wvbase)
    mywvbase.adridlist:=p_InitList()
    mywvbase.adractionlist:=p_InitList()
    mywvbase.adremptylist:=p_InitList()
    p_AjouteNode(mywvbase.adremptylist,'')
    Raise(p_BuildIdList())
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RemWVAPP()"*/
PROC p_RemWVAPP() 
    dWriteF(['p_RemWVAPP()\n'],[0])
    IF mywvbase.adridlist THEN p_RemoveList(mywvbase.adridlist)
    IF mywvbase.adremptylist THEN p_RemoveList(mywvbase.adremptylist)
    IF mywvbase.adractionlist THEN p_RemoveActionList(mywvbase.adractionlist,TRUE)
    IF mywvbase THEN Dispose(mywvbase)
ENDPROC
/**/
/*"p_BuildIdList()"*/
PROC p_BuildIdList() 
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Clean the ListView and rebuild it with all filetype (whatis.library).
 *******************************************************************************/
    DEF next
    DEF id_str[9]:STRING
    DEF my_string[256]:STRING
    dWriteF(['p_BuildIdList()\n'],[0])
    mywvbase.adridlist:=p_CleanList(mywvbase.adridlist)
    next:=FirstType()
    WHILE next
        id_str:=GetIDString(next)
        StringF(my_string,'\s',id_str)
        p_AjouteNode(mywvbase.adridlist,my_string)
        next:=NextType(next)
    ENDWHILE
    RETURN ER_NONE
ENDPROC
/**/
/*"p_FileRequester(numactnode,action)"*/
PROC p_FileRequester(numactnode,action) 
  DEF fichier[256]:STRING
  DEF dossier[256]:STRING
  DEF piv_string[256]:STRING
  DEF reqload:PTR TO filerequestr
  DEF mnode:PTR TO actionnode
  DEF r
  IF reqload:=AllocAslRequest(ASL_FILEREQUEST,[ASL_OKTEXT,'Ok',ASL_DIR,defdir,0])
      IF RequestFile(reqload)
          StringF(dossier,'\s',reqload.dir)
          StringF(defdir,'\s',reqload.dir)
          StringF(fichier,'\s',reqload.file)
      ELSE
      ENDIF
      FreeAslRequest(reqload)
  ELSE
     RETURN FALSE
  ENDIF
  IF numactnode<>-1
      mnode:=p_GetAdrNode(mywvbase.adractionlist,numactnode)
      IF mnode.command THEN DisposeLink(mnode.command)
      mnode.command:=String(EstrLen(fichier))
      StrCopy(mnode.command,fichier,ALL)
      IF (r:=p_NoIcon(dossier,fichier))=TRUE THEN mnode.exectype:=MODE_CLI
      IF mnode.currentdir THEN DisposeLink(mnode.currentdir)
      mnode.currentdir:=String(EstrLen(dossier))
      StrCopy(mnode.currentdir,dossier,ALL)
  ELSE
      SELECT action
        CASE LOAD_PREFS
          AddPart(dossier,'',256)
          StringF(piv_string,'\s\s',dossier,fichier)
          p_ReadPrefsFile(piv_string)
        CASE SAVE_PREFS
          AddPart(dossier,'',256)
          StringF(piv_string,'\s\s',dossier,fichier)
          p_SavePrefsFile(mywvbase.adractionlist,piv_string)
      ENDSELECT
  ENDIF
ENDPROC
/**/
/*"p_SavePrefsFile(list:PTR TO lh,fichier)"*/
PROC p_SavePrefsFile(list:PTR TO lh,fichier) 
    DEF sactnode:PTR TO actionnode
    DEF node:PTR TO ln
    DEF h
    dWriteF(['p_SavePrefsFile()\n'],[0])
    IF h:=Open(fichier,1006)
        Write(h,[ID_WVPR]:LONG,4)
        sactnode:=list.head
        WHILE sactnode
            node:=sactnode
            IF node.succ<>0
                Write(h,[ID_WVAC]:LONG,4)
                Write(h,[sactnode.exectype]:INT,2)
                Write(h,[sactnode.stack]:LONG,4)
                Write(h,[sactnode.priority]:INT,2)
                Write(h,[sactnode.usesubtype]:INT,2)
                Write(h,node.name,EstrLen(node.name))
                IF Even(EstrLen(node.name))
                    Out(h,0)
                    Out(h,0)
                ELSE
                    Out(h,0)
                ENDIF
                Write(h,sactnode.command,EstrLen(sactnode.command))
                IF Even(EstrLen(sactnode.command))
                    Out(h,0)
                    Out(h,0)
                ELSE
                    Out(h,0)
                ENDIF
                Write(h,sactnode.currentdir,EstrLen(sactnode.currentdir))
                IF Even(EstrLen(sactnode.currentdir))
                    Out(h,0)
                    Out(h,0)
                ELSE
                    Out(h,0)
                ENDIF
            ENDIF
            sactnode:=node.succ
        ENDWHILE
        Write(h,[ID_DEFA]:LONG,4)
        Write(h,[defact]:LONG,4)
        IF h THEN Close(h)
    ENDIF
ENDPROC
/**/
/*"p_ReadPrefsFile(source)"*/
PROC p_ReadPrefsFile(source) 
    DEF len,a,adr,buf,handle,flen=TRUE,pos:PTR TO CHAR
    DEF chunk
    DEF pv[256]:STRING
    DEF node:PTR TO ln
    DEF addact:PTR TO actionnode
    DEF list:PTR TO lh,nn=NIL
    dWriteF(['p_readPrefsFile()\n'],[0])
    IF (flen:=FileLength(source))=-1 THEN RETURN FALSE
    IF (buf:=New(flen+1))=NIL THEN RETURN FALSE
    IF (handle:=Open(source,1005))=NIL THEN RETURN FALSE
    len:=Read(handle,buf,flen)
    Close(handle)
    IF len<1 THEN RETURN FALSE
    adr:=buf
    chunk:=Long(adr)
    IF chunk<>ID_WVPR
        Dispose(buf)
        RETURN FALSE
    ENDIF
    p_RemoveActionList(mywvbase.adractionlist,FALSE)
    FOR a:=0 TO len-1
        pos:=adr++
        IF Even(pos)
            chunk:=Long(pos)
            SELECT chunk
                CASE ID_WVAC
                    pos:=pos+4
                    node:=New(SIZEOF ln)
                    addact:=New(SIZEOF actionnode)
                    addact.exectype:=Int(pos)
                    addact.stack:=Long(pos+2)
                    addact.priority:=Int(pos+6)
                    addact.usesubtype:=Int(pos+8)
                    StringF(pv,'\s',pos+10)
                    node.name:=String(EstrLen(pv))
                    node.succ:=0
                    StrCopy(node.name,pv,ALL)
                    IF Even(EstrLen(pv))
                        pos:=pos+10+EstrLen(pv)+2
                    ELSE
                        pos:=pos+10+EstrLen(pv)+1
                    ENDIF
                    StringF(pv,'\s',pos)
                    addact.command:=String(EstrLen(pv))
                    StrCopy(addact.command,pv,ALL)
                    IF Even(EstrLen(pv))
                        pos:=pos+EstrLen(pv)+2
                    ELSE
                        pos:=pos+EstrLen(pv)+1
                    ENDIF
                    StringF(pv,'\s',pos)
                    addact.currentdir:=String(EstrLen(pv))
                    StrCopy(addact.currentdir,pv,ALL)
                    IF Even(EstrLen(pv))
                        pos:=pos+EstrLen(pv)+2
                    ELSE
                        pos:=pos+EstrLen(pv)+1
                    ENDIF
                    CopyMem(node,addact.node,SIZEOF ln)
                    AddTail(mywvbase.adractionlist,addact.node)
                    nn:=p_GetNumNode(mywvbase.adractionlist,addact.node)
                    IF nn=0
                        list:=mywvbase.adractionlist
                        list.head:=addact.node
                        node.pred:=0
                    ENDIF
                    IF node THEN Dispose(node)
                CASE ID_DEFA
                    pos:=pos+4
                    defact:=Long(pos)
            ENDSELECT
        ENDIF
    ENDFOR
    Dispose(buf)
    RETURN TRUE
ENDPROC
/**/
/*"p_NoIcon(d,f)"*/
PROC p_NoIcon(d,f) 
    DEF noicon[256]:STRING
    DEF do[256]:STRING
    DEF fi[256]:STRING
    StringF(do,'\s',d)
    StringF(fi,'\s',f)
    AddPart(do,'',256)
    StringF(noicon,'\s\s.info',do,fi)
    IF (FileLength(noicon))=-1 THEN RETURN TRUE
    RETURN FALSE
ENDPROC
/**/
/*"p_GetIconInfo(num)"*/
PROC p_GetIconInfo(num)
    DEF a:PTR TO ln
    DEF idtype,icname=NIL,icstr[80]:STRING,pv[256]:STRING
    DEF fpart,pos,lock,dl
    DEF e:PTR TO execbase,l:PTR TO lib,r
    e:=execbase
    l:=e
    IF l.version>=39
        IF workbenchbase:=OpenLibrary('workbench.library',0)
            a:=p_GetAdrNode(mywvbase.adractionlist,num)
            idtype:=GetIDType(a.name)
            icname:=GetIconName(idtype)
            IF icname
                StringF(icstr,'\s\s',icdir,icname)
                fpart:=FilePart(icstr)
                pos:=InStr(icstr,fpart,0)
                MidStr(pv,icstr,0,pos)
                IF lock:=Lock(pv,-2)
                    dl:=DupLock(lock)
                    lock:=UnLock(lock)
                    r:=p_WBInfo(dl,icstr,screen)
                    IF r=0 THEN EasyRequestArgs(0,[20,0,0,get_WhatView_string(MSGWVPREFS_REQ_NOICON),get_WhatView_string(MSGWHATVIEW_COMASS_GAD)],0,0)
                    IF dl THEN UnLock(dl)
                ENDIF
            ELSE
                EasyRequestArgs(0,[20,0,0,get_WhatView_string(MSGWVPREFS_REQ_NODEFICON),get_WhatView_string(MSGWHATVIEW_COMASS_GAD)],0,0)
            ENDIF
            IF workbenchbase THEN CloseLibrary(workbenchbase)
        ELSE
            EasyRequestArgs(0,[20,0,0,get_WhatView_string(MSGERWHATVIEW_ER_WORKBENCHLIB),get_WhatView_string(MSGWHATVIEW_COMASS_GAD)],0,0)
        ENDIF
    ELSE
        EasyRequestArgs(0,[20,0,0,'OS 3.0','Ok'],0,0)
    ENDIF
ENDPROC
/**/
/*"p_WBInfo(l (A0),name (A1),s (A2))"*/
PROC p_WBInfo(l,name,s:PTR TO screen)
    DEF ret
    DEF n[80]:STRING
    StrCopy(n,name,ALL)
    MOVE.L l,A0
    MOVE.L name,A1
    MOVE.L s,A2
    MOVE.L workbenchbase,A6
    JSR    -$5A(A6)
    MOVE.L D0,ret
    RETURN ret
ENDPROC
/**/
/*"beginWait(win,waitRequest)"*/
PROC beginWait(win, waitRequest)
 InitRequester(waitRequest)
 IF Request(waitRequest, win)
  RETURN TRUE
 ELSE
  RETURN FALSE
 ENDIF
ENDPROC
/**/
/*"endWait(win,waitRequest)"*/
PROC endWait(win, waitRequest)
 EndRequest(waitRequest, win)
ENDPROC
/**/

/**/
/*"main()"*/
PROC main() HANDLE 
    DEF testmain
    tattr:=['topaz.font',8,0,0]:textattr
    p_DoReadHeader({banner})
    localebase:=OpenLibrary('locale.library',0)
    open_WhatView_catalog(NIL,NIL)
    GetVar('WVICDEF',icdir,256,GVF_GLOBAL_ONLY)
    StrCopy(defdir,'Sys:',ALL)
    AddPart(icdir,'',256)
    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_SetUpScreen())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_InitwpWindow())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_InitWVAPP())<>ER_NONE THEN Raise(testmain)
    IF (FileLength('Env:Whatview.prefs'))<>-1 THEN p_ReadPrefsFile('env:whatview.prefs')
    p_SortList(mywvbase.adridlist)
    p_SortList(mywvbase.adractionlist)
    IF (testmain:=p_OpenwpWindow())<>ER_NONE THEN Raise(testmain)
    REPEAT
        p_LookAllMessage()
    UNTIL reelquit=TRUE
    Raise(ER_NONE)
EXCEPT
    IF wp_window THEN p_RemwpWindow()
    IF mywvbase THEN p_RemWVAPP()
    IF screen THEN p_SetDownScreen()
    p_CloseLibraries()
    SELECT exception
        CASE ER_INTUITIONLIB; WriteF(get_WhatView_string(MSGERWHATVIEW_ER_INTUITIONLIB))
        CASE ER_GADTOOLSLIB;  WriteF(get_WhatView_string(MSGERWHATVIEW_ER_GADTOOLSLIB))
        CASE ER_GRAPHICSLIB;  WriteF(get_WhatView_string(MSGERWHATVIEW_ER_GRAPHICSLIB))
        CASE ER_WHATISLIB;    WriteF(get_WhatView_string(MSGERWHATVIEW_ER_WHATISLIB))
        CASE ER_ASLLIB;       WriteF('Asl.library ??\n')
        CASE ER_LOCKSCREEN; WriteF(get_WhatView_string(MSGERWHATVIEW_ER_LOCKSCREEN))
        CASE ER_VISUAL;     WriteF(get_WhatView_string(MSGERWHATVIEW_ER_VISUAL))
        CASE ER_CONTEXT;    WriteF(get_WhatView_string(MSGERWHATVIEW_ER_CONTEXT))
        CASE ER_MENUS;      WriteF(get_WhatView_string(MSGERWHATVIEW_ER_MENUS))
        CASE ER_GADGET;     WriteF(get_WhatView_string(MSGERWHATVIEW_ER_GADGET))
        CASE ER_WINDOW;     WriteF(get_WhatView_string(MSGERWHATVIEW_ER_WINDOW))
    ENDSELECT
    close_WhatView_catalog()
    IF localebase THEN CloseLibrary(localebase)
ENDPROC
/**/
