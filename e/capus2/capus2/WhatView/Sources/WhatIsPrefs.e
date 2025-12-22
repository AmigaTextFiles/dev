/*=========================================================================================*/
/* Source code generate by Gui2E v0.1 © 1994 NasGûl                                        */
/*=========================================================================================*/
/*"Peps Header"*/
/*======<<< Peps Header >>>======
 PRGVERSION '0'
 ================================
 PRGREVISION '13'
 ================================
 AUTHOR      'NasGûl'
 ===============================*/
/*======<<<   History   >>>======
 Gestion du fichier s:filetypes v 0.0
 ====================================
 Ajouts des commentaires        v 0.1
 ====================================
 Bug fixé dans la libération de
 la liste [p_CleanTypeList()]   v 0.11
 ====================================
 Bug de p_FileRequester() fixé  v 0.12
 ====================================
 Localisation                   v 0.13
 ===============================*/
/**/
OPT OSVERSION=37,LARGE
CONST DEBUG=FALSE
/*"Module Definitions"*/
MODULE 'intuition/intuition','gadtools','libraries/gadtools','intuition/gadgetclass','intuition/screens',
       'graphics/text','exec/lists','exec/nodes','exec/ports','eropenlib','utility/tagitem',
       'intuition/intuitionbase'
MODULE 'asl','libraries/asl'
MODULE 'mheader'
/**/
/*"Erreurs Definitions"*/
ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW
CONST F_LOAD=0,
      F_SAVE=1
/**/
/*"Objets definitions"*/
OBJECT infotype
    node:ln
    subtype:LONG          /*== STRING (14) ==*/
    insertafter:LONG      /*== STRING (18) ==*/
    iconname:LONG         /*== STRING (22) ==*/
    namepattern:LONG      /*== STRING (26) ==*/
    optnamepattern:LONG   /*== STRING (30)==*/
    comparebytes:LONG     /*== PTR TO lh (34) ==*/
    searchbyte:LONG       /*== STRING (38) ==*/
    searchpattern:LONG    /*== STRING (42)==*/
    matchpattern:LONG     /*== STRING (46)==*/
    comment:LONG          /*== STRING (50) ==*/
ENDOBJECT
/**/
/*"Golbals Definitions"*/
/*"Window Definitions"*/
DEF screen:PTR TO screen,
    visual=NIL,
    tattr:PTR TO textattr,
    reelquit=FALSE,
    offy,offx
/*=======================================
 = wip Definitions
 =======================================*/
DEF wip_window=NIL:PTR TO window
DEF wip_glist=NIL
/*==================*/
/*     Gadgets      */
/*==================*/
CONST GA_G_TYPELIST=0
CONST GA_G_SUBTYPE=1
CONST GA_G_INSERTAFTER=2
CONST GA_G_ICONNAME=3
CONST GA_G_NAMEPATTERN=4
CONST GA_G_OPTNAMEPATTERN=5
CONST GA_G_COMPAREBYTES=6
CONST GA_G_COMPAREBYTESSTR=7
CONST GA_G_SEARCHBYTES=8
CONST GA_G_SEARCHPATTERN=9
CONST GA_G_MATCHPATTERN=10
CONST GA_G_COMMENT=20
CONST GA_G_ADDTYPES=11
CONST GA_G_DELTYPES=12
CONST GA_G_ADDCOMPAREBYTES=13
CONST GA_G_DELCOMPAREBYTES=14
CONST GA_G_LOAD=15
CONST GA_G_SAVE=16
CONST GA_G_SAVEAS=17
CONST GA_G_QUIT=18
CONST GA_G_TYPESSTR=19
/*=============================
 = Gadgets labels of wip
 =============================*/
DEF g_typelist
DEF g_subtype
DEF g_insertafter
DEF g_iconname
DEF g_namepattern
DEF g_optnamepattern
DEF g_comparebytes
DEF g_comparebytesstr
DEF g_searchbytes
DEF g_searchpattern
DEF g_matchpattern
DEF g_comment
DEF g_addtypes
DEF g_deltypes
DEF g_addcomparebytes
DEF g_delcomparebytes
DEF g_load
DEF g_save
DEF g_saveas
DEF g_quit
DEF g_typesstr
/**/
/*"Applications definitions"*/
DEF motcle:PTR TO LONG
DEF freeinfotype
DEF typelist:PTR TO lh
DEF curinfotype=0
DEF curcompbyte=0
/**/
/**/
/*"Pmodules definitions"*/
PMODULE 'WhatView_Cat'
PMODULE 'WhatIsPrefsList'
PMODULE 'PModules:pListView'
PMODULE 'Pmodules:DWriteF'
PMODULE 'Pmodules:PMHeader'
/**/
/*"Window Procedures"*/
/*"p_OpenLibraries()"*/
PROC p_OpenLibraries() HANDLE 
    dWriteF(['p_OpenLibraries()\n'],0)
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GRAPHICSLIB)
    IF (aslbase:=OpenLibrary('asl.library',37))=NIL THEN Raise(ER_ASLLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_CloseLibraries()"*/
PROC p_CloseLibraries()  
    dWriteF(['p_CloseLibraries()\n'],0)
    IF aslbase THEN CloseLibrary(aslbase)
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
/**/

/*"p_SetUpScreen()"*/
PROC p_SetUpScreen() HANDLE 
    dWriteF(['p_SetUpScreen()\n'],0)
    IF (screen:=LockPubScreen(p_LockActivePubScreen()))=NIL THEN Raise(ER_LOCKSCREEN)
    IF (visual:=GetVisualInfoA(screen,NIL))=NIL THEN Raise(ER_VISUAL)
    offy:=screen.wbortop+Int(screen.rastport+58)-10
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_SetDownScreen()"*/
PROC p_SetDownScreen() 
    dWriteF(['p_SetDownSrceen()\n'],0)
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
    dWriteF(['p_LockActivePubScreen()\n'],0)
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

/*"p_InitwipWindow()"*/
PROC p_InitwipWindow() HANDLE 
    DEF g:PTR TO gadget
    dWriteF(['p_InitwipWindow()\n'],0)
    IF (g:=CreateContext({wip_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (g_typelist:=CreateGadgetA(LISTVIEW_KIND,g,[offx+24,offy+28,121,64,'Types',tattr,0,4,visual,0]:newgadget,[GTLV_SHOWSELECTED,NIL,GTLV_LABELS,NIL,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_subtype:=CreateGadgetA(STRING_KIND,g_typelist,[offx+284,offy+16,145,13,'SubType',tattr,1,1,visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_insertafter:=CreateGadgetA(STRING_KIND,g_subtype,[offx+284,offy+31,145,13,'InsertAfter',tattr,2,1,visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_iconname:=CreateGadgetA(STRING_KIND,g_insertafter,[offx+284,offy+46,145,13,'IconName',tattr,3,1,visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_namepattern:=CreateGadgetA(STRING_KIND,g_iconname,[offx+284,offy+61,145,13,'NamePattern',tattr,4,1,visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_optnamepattern:=CreateGadgetA(STRING_KIND,g_namepattern,[offx+284,offy+76,145,13,'OptNamePattern',tattr,5,1,visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_comparebytes:=CreateGadgetA(LISTVIEW_KIND,g_optnamepattern,[offx+459,offy+27,165,48,'CompareBytes',tattr,6,4,visual,0]:newgadget,[GTLV_SHOWSELECTED,NIL,GTLV_LABELS,NIL,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_comparebytesstr:=CreateGadgetA(STRING_KIND,g_comparebytes,[offx+458,offy+74,165,13,'',tattr,7,0,visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_searchbytes:=CreateGadgetA(STRING_KIND,g_comparebytesstr,[offx+284,offy+91,145,13,'SearchBytes',tattr,8,1,visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_searchpattern:=CreateGadgetA(STRING_KIND,g_searchbytes,[offx+284,offy+106,145,13,'SearchPattern',tattr,9,1,visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_matchpattern:=CreateGadgetA(STRING_KIND,g_searchpattern,[offx+284,offy+121,145,13,'MatchPattern',tattr,10,1,visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)    
    IF (g_comment:=CreateGadgetA(STRING_KIND,g_matchpattern,[offx+170,offy+135,259,13,'',tattr,20,1,visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_addtypes:=CreateGadgetA(BUTTON_KIND,g_comment,[offx+24,offy+108,61,11,'Add',tattr,11,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_deltypes:=CreateGadgetA(BUTTON_KIND,g_addtypes,[offx+86,offy+108,61,11,'Del',tattr,12,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_addcomparebytes:=CreateGadgetA(BUTTON_KIND,g_deltypes,[offx+458,offy+91,61,11,'Add',tattr,13,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_delcomparebytes:=CreateGadgetA(BUTTON_KIND,g_addcomparebytes,[offx+562,offy+91,61,11,'Del',tattr,14,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_load:=CreateGadgetA(BUTTON_KIND,g_delcomparebytes,[offx+461,offy+114,77,13,get_WhatView_string(MSGWHATISPREFS_LOAD),tattr,15,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_save:=CreateGadgetA(BUTTON_KIND,g_load,[offx+549,offy+114,77,13,get_WhatView_string(MSGWHATISPREFS_SAVE),tattr,16,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_saveas:=CreateGadgetA(BUTTON_KIND,g_save,[offx+461,offy+129,77,13,get_WhatView_string(MSGWHATISPREFS_SAVEAS),tattr,17,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_quit:=CreateGadgetA(BUTTON_KIND,g_saveas,[offx+549,offy+129,77,13,get_WhatView_string(MSGWHATISPREFS_QUIT),tattr,18,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    IF (g_typesstr:=CreateGadgetA(STRING_KIND,g_quit,[offx+24,offy+92,121,13,'',tattr,19,0,visual,0]:newgadget,[GTST_STRING,'',GTST_MAXCHARS,100,GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RenderwipWindow()"*/
PROC p_RenderwipWindow() 
    DEF c:PTR TO infotype
    DEF cb:PTR TO ln
    DEF n:PTR TO ln
    dWriteF(['p_RenderwipWindow()\n'],0)
    c:=p_GetAdrNode(typelist,curinfotype)
    n:=c
    IF p_EmptyList(typelist)<>-1
        Gt_SetGadgetAttrsA(g_typelist,wip_window,NIL,[GTLV_SHOWSELECTED,TRUE,GTLV_SELECTED,curinfotype,GTLV_LABELS,typelist,TAG_DONE])
        Gt_SetGadgetAttrsA(g_typesstr,wip_window,NIL,[GTST_STRING,n.name,TAG_DONE])
        Gt_SetGadgetAttrsA(g_subtype,wip_window,NIL,[GTST_STRING,IF c.subtype<>0 THEN c.subtype ELSE '',TAG_DONE])
        Gt_SetGadgetAttrsA(g_insertafter,wip_window,NIL,[GTST_STRING,IF c.insertafter<>0 THEN c.insertafter ELSE '',TAG_DONE])
        Gt_SetGadgetAttrsA(g_iconname,wip_window,NIL,[GTST_STRING,IF c.iconname<>0 THEN c.iconname ELSE '',TAG_DONE])
        Gt_SetGadgetAttrsA(g_namepattern,wip_window,NIL,[GTST_STRING,IF c.namepattern<>0 THEN c.namepattern ELSE '',TAG_DONE])
        Gt_SetGadgetAttrsA(g_optnamepattern,wip_window,NIL,[GTST_STRING,IF c.optnamepattern<>0 THEN c.optnamepattern ELSE '',TAG_DONE])
        IF p_EmptyList(c.comparebytes)<>-1
            cb:=p_GetAdrNode(c.comparebytes,curcompbyte)
            Gt_SetGadgetAttrsA(g_comparebytes,wip_window,NIL,[GA_DISABLED,FALSE,GTLV_SHOWSELECTED,TRUE,GTLV_SELECTED,curcompbyte,GTLV_LABELS,c.comparebytes,TAG_DONE])
            Gt_SetGadgetAttrsA(g_comparebytesstr,wip_window,NIL,[GA_DISABLED,FALSE,GTST_STRING,cb.name,TAG_DONE])
            Gt_SetGadgetAttrsA(g_delcomparebytes,wip_window,NIL,[GA_DISABLED,FALSE,TAG_DONE])
        ELSE
            Gt_SetGadgetAttrsA(g_comparebytes,wip_window,NIL,[GA_DISABLED,TRUE,GTLV_SHOWSELECTED,NIL,GTLV_LABELS,NIL,TAG_DONE])
            Gt_SetGadgetAttrsA(g_comparebytesstr,wip_window,NIL,[GA_DISABLED,TRUE,GTST_STRING,'',TAG_DONE])
            Gt_SetGadgetAttrsA(g_delcomparebytes,wip_window,NIL,[GA_DISABLED,TRUE,TAG_DONE])
        ENDIF
        Gt_SetGadgetAttrsA(g_searchbytes,wip_window,NIL,[GTST_STRING,IF c.searchbyte<>0 THEN c.searchbyte ELSE '',TAG_DONE])
        Gt_SetGadgetAttrsA(g_searchpattern,wip_window,NIL,[GTST_STRING,IF c.searchpattern<>0 THEN c.searchpattern ELSE '',TAG_DONE])
        Gt_SetGadgetAttrsA(g_matchpattern,wip_window,NIL,[GTST_STRING,IF c.matchpattern<>0 THEN c.matchpattern ELSE '',TAG_DONE])
        Gt_SetGadgetAttrsA(g_comment,wip_window,NIL,[GTST_STRING,IF StrLen(c.comment)<>0 THEN c.comment ELSE '',TAG_DONE])
    ELSE
        Gt_SetGadgetAttrsA(g_typelist,wip_window,NIL,[GTLV_SHOWSELECTED,NIL,GTLV_LABELS,NIL,TAG_DONE])
    ENDIF
    DrawBevelBoxA(wip_window.rport,offx+440,offy+108,201,41,[GT_VISUALINFO,visual,TAG_DONE])
    DrawBevelBoxA(wip_window.rport,offx+440,offy+12,201,93,[GT_VISUALINFO,visual,TAG_DONE])
    DrawBevelBoxA(wip_window.rport,offx+8,offy+12,145,137,[GT_VISUALINFO,visual,TAG_DONE])
    DrawBevelBoxA(wip_window.rport,offx+156,offy+12,281,137,[GT_VISUALINFO,visual,TAG_DONE])
    RefreshGList(g_typelist,wip_window,NIL,-1)
    Gt_RefreshWindow(wip_window,NIL)
ENDPROC
/**/
/*"p_OpenwipWindow()"*/
PROC p_OpenwipWindow() HANDLE 
    dWriteF(['p_OpenwipWindow()\n'],0)
    IF (wip_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,127,
                       WA_TOP,46,
                       WA_WIDTH,offx+649,
                       WA_HEIGHT,offy+151,
                       WA_IDCMP,$200+$40+$20+$4+$400000,
                       WA_FLAGS,$102E,
                       WA_GADGETS,wip_glist,
                       WA_CUSTOMSCREEN,screen,
                       WA_TITLE,title_req,
                       WA_SCREENTITLE,'Made With GadToolsBox V2.0b © 1991-1993',
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    p_RenderwipWindow()
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RemwipWindow()"*/
PROC p_RemwipWindow() 
    dWriteF(['p_RemwipWindow()\n'],0)
    IF wip_window THEN CloseWindow(wip_window)
    IF wip_glist THEN FreeGadgets(wip_glist)
ENDPROC
/**/
/**/
/*"Message Procedures"*/
/*"p_LookAllMessage()"*/
PROC p_LookAllMessage() 
    DEF sigreturn
    DEF wipport:PTR TO mp
    IF wip_window THEN wipport:=wip_window.userport ELSE wipport:=NIL
    sigreturn:=Wait(Shl(1,wipport.sigbit) OR
                    $F000)
    IF (sigreturn AND Shl(1,wipport.sigbit))
        p_LookwipMessage()
    ENDIF
    IF (sigreturn AND $F000)
        reelquit:=TRUE
    ENDIF
ENDPROC
/**/
/*"p_LookwipMessage()"*/
PROC p_LookwipMessage() 
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF gstr:PTR TO stringinfo
   DEF type=0,infos=NIL
   DEF tinfotype:PTR TO infotype,pv[80]:STRING
   DEF nn:PTR TO ln
   DEF refresh=FALSE
   WHILE mes:=Gt_GetIMsg(wip_window.userport)
       type:=mes.class
       SELECT type
           CASE IDCMP_MENUPICK
              infos:=mes.code
              SELECT infos
              ENDSELECT
           /*CASE IDCMP_GADGETDOWN*/
           CASE IDCMP_CLOSEWINDOW
              reelquit:=TRUE
           CASE IDCMP_GADGETUP
              g:=mes.iaddress
              infos:=g.gadgetid
              gstr:=g.specialinfo
              SELECT infos
                  CASE GA_G_TYPELIST
                    curinfotype:=mes.code
                    tinfotype:=curinfotype
                    refresh:=TRUE
                  CASE GA_G_SUBTYPE
                    tinfotype:=p_GetAdrNode(typelist,curinfotype)
                    StringF(pv,'\s',gstr.buffer)
                    IF tinfotype.subtype<>0 THEN DisposeLink(tinfotype.subtype)
                    IF EstrLen(pv)<>0
                        tinfotype.subtype:=String(EstrLen(pv))
                        StrCopy(tinfotype.subtype,pv,EstrLen(pv))
                    ELSE
                        tinfotype.subtype:=0
                    ENDIF
                  CASE GA_G_INSERTAFTER
                    tinfotype:=p_GetAdrNode(typelist,curinfotype)
                    StringF(pv,'\s',gstr.buffer)
                    IF tinfotype.insertafter<>0 THEN DisposeLink(tinfotype.insertafter)
                    IF EstrLen(pv)<>0
                        tinfotype.insertafter:=String(EstrLen(pv))
                        StrCopy(tinfotype.insertafter,pv,EstrLen(pv))
                    ELSE
                        tinfotype.insertafter:=0
                    ENDIF
                  CASE GA_G_ICONNAME
                    tinfotype:=p_GetAdrNode(typelist,curinfotype)
                    StringF(pv,'\s',gstr.buffer)
                    IF tinfotype.iconname<>0 THEN DisposeLink(tinfotype.iconname)
                    IF EstrLen(pv)<>0
                        tinfotype.iconname:=String(EstrLen(pv))
                        StrCopy(tinfotype.iconname,pv,EstrLen(pv))
                    ELSE
                        tinfotype.iconname:=0
                    ENDIF
                  CASE GA_G_NAMEPATTERN
                    tinfotype:=p_GetAdrNode(typelist,curinfotype)
                    StringF(pv,'\s',gstr.buffer)
                    IF tinfotype.namepattern<>0 THEN DisposeLink(tinfotype.namepattern)
                    IF EstrLen(pv)<>0
                        tinfotype.namepattern:=String(EstrLen(pv))
                        StrCopy(tinfotype.namepattern,pv,EstrLen(pv))
                    ELSE
                        tinfotype.namepattern:=0
                    ENDIF
                  CASE GA_G_OPTNAMEPATTERN
                    tinfotype:=p_GetAdrNode(typelist,curinfotype)
                    StringF(pv,'\s',gstr.buffer)
                    IF tinfotype.optnamepattern<>0 THEN DisposeLink(tinfotype.optnamepattern)
                    IF EstrLen(pv)<>0
                        tinfotype.optnamepattern:=String(EstrLen(pv))
                        StrCopy(tinfotype.optnamepattern,pv,EstrLen(pv))
                    ELSE
                        tinfotype.optnamepattern:=0
                    ENDIF
                  CASE GA_G_COMPAREBYTES
                    curcompbyte:=mes.code
                    refresh:=TRUE
                  CASE GA_G_COMPAREBYTESSTR
                    tinfotype:=p_GetAdrNode(typelist,curinfotype)
                    nn:=p_GetAdrNode(tinfotype.comparebytes,curcompbyte)
                    StringF(pv,'\s',gstr.buffer)
                    IF nn.name<>0 THEN DisposeLink(nn.name)
                    nn.name:=String(EstrLen(pv))
                    StrCopy(nn.name,pv,EstrLen(pv))
                    refresh:=TRUE
                  CASE GA_G_SEARCHBYTES
                    tinfotype:=p_GetAdrNode(typelist,curinfotype)
                    StringF(pv,'\s',gstr.buffer)
                    IF tinfotype.searchbyte<>0 THEN DisposeLink(tinfotype.searchbyte)
                    IF EstrLen(pv)<>0
                        tinfotype.searchbyte:=String(EstrLen(pv))
                        StrCopy(tinfotype.searchbyte,pv,EstrLen(pv))
                    ELSE
                        tinfotype.searchbyte:=0
                    ENDIF
                  CASE GA_G_SEARCHPATTERN
                    tinfotype:=p_GetAdrNode(typelist,curinfotype)
                    StringF(pv,'\s',gstr.buffer)
                    IF EstrLen(tinfotype.searchpattern)<>0 THEN DisposeLink(tinfotype.searchpattern)
                    IF EstrLen(pv)<>0
                        tinfotype.searchpattern:=String(EstrLen(pv))
                        StrCopy(tinfotype.searchpattern,pv,EstrLen(pv))
                    ELSE
                        tinfotype.searchpattern:=0
                    ENDIF
                  CASE GA_G_MATCHPATTERN
                    tinfotype:=p_GetAdrNode(typelist,curinfotype)
                    StringF(pv,'\s',gstr.buffer)
                    IF tinfotype.matchpattern<>0 THEN DisposeLink(tinfotype.matchpattern)
                    IF EstrLen(pv)<>0
                        tinfotype.matchpattern:=String(EstrLen(pv))
                        StrCopy(tinfotype.matchpattern,pv,EstrLen(pv))
                    ELSE
                        tinfotype.matchpattern:=0
                    ENDIF
                    CASE GA_G_COMMENT
                    tinfotype:=p_GetAdrNode(typelist,curinfotype)
                    StringF(pv,'\s',gstr.buffer)
                    IF tinfotype.comment<>0 THEN DisposeLink(tinfotype.comment)
                    IF EstrLen(pv)<>0
                        tinfotype.comment:=String(EstrLen(pv))
                        StrCopy(tinfotype.comment,pv,EstrLen(pv))
                    ELSE
                        tinfotype.comment:=0
                    ENDIF
                  CASE GA_G_ADDTYPES
                    p_LockListView(g_typelist,wip_window)
                    tinfotype:=New(SIZEOF infotype)
                    tinfotype.comment:=0
                    tinfotype.subtype:=0
                    tinfotype.insertafter:=0
                    tinfotype.iconname:=0
                    tinfotype.namepattern:=0
                    tinfotype.optnamepattern:=0
                    tinfotype.comparebytes:=p_InitList()
                    tinfotype.searchbyte:=0
                    tinfotype.searchpattern:=0
                    tinfotype.matchpattern:=0
                    p_AjouteNode(typelist,get_WhatView_string(MSGWHATISPREFS_NEWNODE),tinfotype)
                    p_UnLockListView(g_typelist,wip_window,typelist)
                    refresh:=TRUE
                  CASE GA_G_DELTYPES
                    p_LockListView(g_typelist,wip_window)
                    /*curinfotype:=p_EnleveNode(typelist,curinfotype,TRUE,freeinfotype)*/
                    curinfotype:=p_EnleveWINode(typelist,curinfotype)
                    p_UnLockListView(g_typelist,wip_window,typelist)
                    refresh:=TRUE
                  CASE GA_G_ADDCOMPAREBYTES
                    tinfotype:=p_GetAdrNode(typelist,curinfotype)
                    p_LockListView(g_comparebytes,wip_window)
                    p_AjouteNode(tinfotype.comparebytes,get_WhatView_string(MSGWHATISPREFS_NEWNODE),0)
                    p_UnLockListView(g_comparebytes,wip_window,tinfotype.comparebytes)
                    refresh:=TRUE
                  CASE GA_G_DELCOMPAREBYTES
                    tinfotype:=p_GetAdrNode(typelist,curinfotype)
                    p_LockListView(g_comparebytes,wip_window)
                    curcompbyte:=p_EnleveNode(tinfotype.comparebytes,curcompbyte,0,0)
                    p_UnLockListView(g_comparebytes,wip_window,tinfotype.comparebytes)
                    refresh:=TRUE
                  CASE GA_G_LOAD
                    IF pv:=p_FileRequester(F_LOAD)
                        /*p_LockListView(g_typelist,wip_window)*/
                        typelist:=p_CleanTypeList(typelist)
                        p_ReadSourceFile(pv)
                        /*p_UnLockListView(g_typelist,wip_window,typelist)*/
                        curinfotype:=0
                        refresh:=TRUE
                    ENDIF
                  CASE GA_G_SAVE
                    p_SaveSourceFile('s:filetypes')
                  CASE GA_G_SAVEAS
                    IF pv:=p_FileRequester(F_SAVE)
                        /*p_LockListView(g_typelist,wip_window)*/
                        p_SaveSourceFile(pv)
                        /*p_UnLockListView(g_typelist,wip_window,typelist)*/
                    ENDIF
                  CASE GA_G_QUIT
                    reelquit:=TRUE
                  CASE GA_G_TYPESSTR
                    nn:=p_GetAdrNode(typelist,curinfotype)
                    StringF(pv,'\s',gstr.buffer)
                    IF EstrLen(nn.name)<>0 THEN DisposeLink(nn.name)
                    nn.name:=String(EstrLen(pv))
                    StrCopy(nn.name,pv,EstrLen(pv))
                    refresh:=TRUE
              ENDSELECT
       ENDSELECT
       Gt_ReplyIMsg(mes)
   ENDWHILE
   IF refresh=TRUE THEN p_RenderwipWindow()
ENDPROC
/**/
/**/
/*"Application Procedures"*/
/*"p_EnleveWINode(list;PTR TO lh,num)"*/
PROC p_EnleveWINode(list:PTR TO lh,num)
    DEF wn:PTR TO infotype
    DEF n:PTR TO ln
    DEF count=NIL,retour,newn:PTR TO ln
    n:=list.head
    WHILE n
        wn:=n
        IF count=num
            IF n.succ<>0
                IF n.name THEN DisposeLink(n.name)
                IF wn.subtype THEN DisposeLink(wn.subtype)
                IF wn.insertafter THEN DisposeLink(wn.insertafter)
                IF wn.iconname THEN DisposeLink(wn.iconname)
                IF wn.namepattern THEN DisposeLink(wn.namepattern)
                IF wn.optnamepattern THEN DisposeLink(wn.optnamepattern)
                p_CleanList(wn.comparebytes,FALSE,0,LIST_REMOVE)
                IF wn.searchbyte THEN DisposeLink(wn.searchbyte)
                IF wn.searchpattern THEN DisposeLink(wn.searchpattern)
                IF wn.matchpattern THEN DisposeLink(wn.matchpattern)
                IF wn.comment THEN DisposeLink(wn.comment)
            ENDIF
            IF n.succ=0
                RemTail(list)
                retour:=num-1
            ELSEIF n.pred=0
                RemHead(list)
                retour:=num
                newn:=p_GetAdrNode(list,num)
                list.head:=newn
                newn.pred:=0
            ELSEIF (n.succ<>0) AND (n.pred<>0)
                Remove(n)
                retour:=num-1
            ENDIF
        ENDIF
        INC count
        n:=n.succ
    ENDWHILE
    RETURN retour
ENDPROC
/**/
/*"readSourceFile(esource)"*/
PROC p_ReadSourceFile(esource)
/********************************************************************************
 * Para     : NONE
 * Return   : FALSE if error.
 * Description  : Read the source file (.e).
 *******************************************************************************/
    DEF len,adr,buf,handle,flen=TRUE,a,p
    DEF r_str[256]:STRING
    DEF str_line[256]:STRING
    DEF piv_str[256]:STRING
    DEF procstr[256]:STRING,pos
    DEF c
    DEF myinfotype:PTR TO infotype
    DEF iname[20]:STRING,pv[50]:STRING,buffer[50]:STRING,tt[50]:STRING
    DEF test
    dWriteF(['p_REadSourceFile() \s\n'],[esource])
    IF (flen:=FileLength(esource))=-1 THEN RETURN FALSE
    IF (buf:=New(flen+1))=NIL THEN RETURN FALSE
    IF (handle:=Open(esource,1005))=NIL THEN RETURN FALSE
    len:=Read(handle,buf,flen)
    Close(handle)
    IF len<1 THEN RETURN FALSE
    adr:=buf
    FOR a:=0 TO len-1
        IF buf[a]=10
            StrCopy(r_str,adr,a-p)
            str_line:=TrimStr(r_str)
            IF EstrLen(str_line)<>0
                IF (Not(test:=StrCmp(str_line,'##',2)) OR (test:=InStr(str_line,'#>',0)))
                    FOR c:=0 TO 11
                        IF StrCmp(str_line,motcle[c],StrLen(motcle[c]))
                            SELECT c
                                CASE 0
                                    myinfotype:=New(SIZEOF infotype)
                                    myinfotype.comparebytes:=0
                                    MidStr(pv,str_line,StrLen(motcle[c]),ALL)
                                    StrCopy(iname,TrimStr(pv),ALL)
                                    myinfotype.comment:=0
                                    myinfotype.subtype:=0
                                    myinfotype.insertafter:=0
                                    myinfotype.iconname:=0
                                    myinfotype.namepattern:=0
                                    myinfotype.optnamepattern:=0
                                    myinfotype.comparebytes:=p_InitList()
                                    myinfotype.searchbyte:=0
                                    myinfotype.searchpattern:=0
                                    myinfotype.matchpattern:=0
                                CASE 1
                                    MidStr(pv,str_line,StrLen(motcle[c]),ALL)
                                    buffer:=TrimStr(pv)
                                    myinfotype.comment:=String(EstrLen(buffer))
                                    StrCopy(myinfotype.comment,buffer,EstrLen(buffer))
                                CASE 2
                                    MidStr(pv,str_line,StrLen(motcle[c]),ALL)
                                    buffer:=TrimStr(pv)
                                    myinfotype.subtype:=String(EstrLen(buffer))
                                    StrCopy(myinfotype.subtype,buffer,EstrLen(buffer))
                                CASE 3
                                    MidStr(pv,str_line,StrLen(motcle[c]),ALL)
                                    buffer:=TrimStr(pv)
                                    myinfotype.insertafter:=String(EstrLen(buffer))
                                    StrCopy(myinfotype.insertafter,buffer,EstrLen(buffer))
                                CASE 4
                                    MidStr(pv,str_line,StrLen(motcle[c]),ALL)
                                    buffer:=TrimStr(pv)
                                    myinfotype.iconname:=String(EstrLen(buffer))
                                    StrCopy(myinfotype.iconname,buffer,EstrLen(buffer))
                                CASE 5
                                    MidStr(pv,str_line,StrLen(motcle[c]),ALL)
                                    buffer:=TrimStr(pv)
                                    myinfotype.namepattern:=String(EstrLen(buffer))
                                    StrCopy(myinfotype.namepattern,buffer,EstrLen(buffer))
                                CASE 6
                                    MidStr(pv,str_line,StrLen(motcle[c]),ALL)
                                    buffer:=TrimStr(pv)
                                    myinfotype.optnamepattern:=String(EstrLen(buffer))
                                    StrCopy(myinfotype.optnamepattern,buffer,EstrLen(buffer))
                                CASE 7
                                    MidStr(pv,str_line,StrLen(motcle[c]),ALL)
                                    buffer:=TrimStr(pv)
                                    p_AjouteNode(myinfotype.comparebytes,buffer,0)
                                CASE 8
                                    MidStr(pv,str_line,StrLen(motcle[c]),ALL)
                                    buffer:=TrimStr(pv)
                                    myinfotype.searchbyte:=String(EstrLen(buffer))
                                    StrCopy(myinfotype.searchbyte,buffer,EstrLen(buffer))
                                CASE 9
                                    MidStr(pv,str_line,StrLen(motcle[c]),ALL)
                                    buffer:=TrimStr(pv)
                                    myinfotype.searchpattern:=String(EstrLen(buffer))
                                    StrCopy(myinfotype.searchpattern,buffer,EstrLen(buffer))
                                CASE 10
                                    MidStr(pv,str_line,StrLen(motcle[c]),ALL)
                                    buffer:=TrimStr(pv)
                                    myinfotype.matchpattern:=String(EstrLen(buffer))
                                    StrCopy(myinfotype.matchpattern,buffer,EstrLen(buffer))
                                CASE 11
                                    p_AjouteNode(typelist,iname,myinfotype)
                            ENDSELECT
                        ENDIF
                    ENDFOR
                ENDIF
                StrCopy(str_line,'',ALL)
            ENDIF
            p:=a+1
            adr:=buf+a+1
        ENDIF
    ENDFOR
    Dispose(buf)
    RETURN TRUE
ENDPROC
/**/
/*"p_SaveSourceFile(s)"*/
PROC p_SaveSourceFile(s)
    DEF n:PTR TO ln
    DEF tn:PTR TO infotype
    DEF h
    DEF cl:PTR TO lh
    DEF cn:PTR TO ln
    dWriteF(['p_SaveSourceFile \s\n'],[s])
    IF (h:=Open(s,1006))=NIL THEN RETURN FALSE
    stdout:=h
    WriteF('##   Syntax\n')
    WriteF('##   TYPE "Src Ada"\n')
    WriteF('##       SUBTYPE "Text"\n')
    WriteF('##       INSERTAFTER "Script"\n')
    WriteF('##       ICONNAME "def_Src Ada"  # path internaly expanded to "ENV:Sys/def_Src Ada.info"\n')
    WriteF('##       NAMEPATTERN *.ada\n')
    WriteF('##   # or OPTNAMEPATTERN *.ada\n')
    WriteF('##   # The 4 upper lines are optional but order MUST be kept.\n')
    WriteF('##   # Lower lines are for information about syntax, and if used order MUST be kept.\n')
    WriteF('##       # COMPAREBYTE OFFSET BYTES\n')
    WriteF('##       COMPAREBYTE 12 $ABADCAFE    # hex bytes, offset decimal\n')
    WriteF('##       COMPAREBYTE $23 "Coucou"    # string bytes, offset in hex\n')
    WriteF('##       SEARCHBYTE  "Salut"\n')
    WriteF('##       SEARCHBYTE  $DEADBEEF\n')
    WriteF('##       SEARCHPATTERN [CASE] "ST-??"\n')
    WriteF('##       MATCHPATTERN [CASE] 45 "ST-??"\n')
    WriteF('##   ENDTYPE\n')
    WriteF('########################################################\n')
    n:=typelist.head
    WHILE n
        IF n.succ<>0
            tn:=n
            WriteF('TYPE \s\n',n.name)
            IF tn.comment<>0 THEN        WriteF('#> \s\n',tn.comment)
            IF tn.subtype<>0 THEN        WriteF('    SUBTYPE \s\n',tn.subtype)
            IF tn.insertafter<>0 THEN    WriteF('    INSERTAFTER \s\n',tn.insertafter)
            IF tn.iconname<>0 THEN       WriteF('    ICONNAME \s\n',tn.iconname)
            IF tn.namepattern<>0 THEN    WriteF('    NAMEPATTERN \s\n',tn.namepattern)
            IF tn.optnamepattern<>0 THEN WriteF('    OPTNAMEPATTERN \s\n',tn.optnamepattern)
            cl:=tn.comparebytes
            IF p_EmptyList(tn.comparebytes)<>-1
                cn:=cl.head
                WHILE cn
                    IF cn.succ<>0
                        WriteF('    COMPAREBYTE \s\n',cn.name)
                    ENDIF
                    cn:=cn.succ
                ENDWHILE
            ENDIF
            IF tn.searchbyte<>0 THEN    WriteF('    SEARCHBYTE \s\n',tn.searchbyte)
            IF tn.searchpattern<>0 THEN WriteF('    SEARCHPATTERN \s\n',tn.searchpattern)
            IF tn.matchpattern<>0  THEN WriteF('    MATCHPATTERN \s\n',tn.matchpattern)
            WriteF('ENDTYPE\n\n')
        ENDIF
        n:=n.succ
    ENDWHILE
    IF h THEN Close(h)
ENDPROC
/**/
/*"p_CleanTypeList(ptr_list:PTR TO lh)"*/
PROC p_CleanTypeList(ptr_list:PTR TO lh)
/*===============================================================================
 = Para         : Address of a list
 = Return       : NONE.
 = Description  : Write in stdout the list data and nodes.
 ==============================================================================*/
    DEF w_node:PTR TO ln
    DEF c
    DEF mit:PTR TO infotype
    dWriteF(['p_CleanTypeList()\n'],0)
    w_node:=ptr_list.head
    WHILE w_node
        IF w_node.succ<>0
            mit:=w_node
            dWriteF(['\h ','\h ','\h ','\h ','\h ','\h ','\h ','\h ','\h\n'],
                    [mit.subtype,mit.insertafter,mit.iconname,
                     mit.namepattern,mit.optnamepattern,
                     mit.searchbyte,mit.searchpattern,
                     mit.matchpattern,mit.comment])
            IF mit.subtype<>0 THEN DisposeLink(mit.subtype)
            IF mit.insertafter<>0 THEN DisposeLink(mit.insertafter)
            IF mit.iconname<>0 THEN DisposeLink(mit.iconname)
            IF mit.namepattern<>0 THEN DisposeLink(mit.namepattern)
            IF mit.optnamepattern<>0 THEN DisposeLink(mit.optnamepattern)
            p_CleanList(mit.comparebytes,0,0,LIST_REMOVE)
            IF mit.searchbyte<>0 THEN DisposeLink(mit.searchbyte)
            IF mit.searchpattern<>0 THEN DisposeLink(mit.searchpattern)
            IF mit.matchpattern<>0 THEN DisposeLink(mit.matchpattern)
            IF mit.comment<>0 THEN DisposeLink(mit.comment)
            IF w_node.succ=0 THEN RemTail(ptr_list)
            IF w_node.pred=0 THEN RemHead(ptr_list)
            IF (w_node.succ<>0) AND (w_node.pred<>0) THEN Remove(w_node)
            IF w_node.name THEN DisposeLink(w_node.name)
        ENDIF
        w_node:=w_node.succ
    ENDWHILE
    ptr_list.tail:=0
    ptr_list.head:=ptr_list.tail
    ptr_list.tailpred:=ptr_list.head
    ptr_list.type:=0
    ptr_list.pad:=0
    RETURN ptr_list
ENDPROC
/**/
/*"p_InitWIP()"*/
PROC p_InitWIP()
    dWriteF(['p_InitWIP()\n'],0)
    motcle:=['TYPE','#>','SUBTYPE','INSERTAFTER',
             'ICONNAME','NAMEPATTERN','OPTNAMEPATTERN',
             'COMPAREBYTE','SEARCHBYTE','SEARCHPATTERN',
             'MATCHPATTERN','ENDTYPE']
    typelist:=p_InitList()
    freeinfotype:=[DISL,14,DISL,18,DISL,22,DISL,26,DISL,30,DISP,34,DISL,38,DISL,42,DISL,46,DISL,50,DISE]
ENDPROC
/**/
/*"p_FileRequester(t)"*/
PROC p_FileRequester(t) 
    DEF req:PTR TO filerequestr
    DEF f=FALSE
    DEF tag,rr=TRUE
    DEF source[256]:STRING
    DEF rstr[256]:STRING
    dWriteF(['p_FileRequester()\n'],0)
    IF t=F_LOAD
        tag:=[ASL_HAIL,get_WhatView_string(MSGWHATISPREFS_REQ_HAILLOAD),ASL_OKTEXT,get_WhatView_string(MSGWHATISPREFS_LOAD),ASL_CANCELTEXT,get_WhatView_string(MSGWHATISPREFS_REQ_CANCEL),
              ASL_FILE,'filetypes',ASL_DIR,'s:',TAG_DONE]
    ELSE
        tag:=[ASL_FUNCFLAGS,FILF_SAVE,ASL_HAIL,get_WhatView_string(MSGWHATISPREFS_REQ_HAILSAVE),ASL_OKTEXT,get_WhatView_string(MSGWHATISPREFS_SAVE),ASL_CANCELTEXT,get_WhatView_string(MSGWHATISPREFS_REQ_CANCEL),
              ASL_FILE,'filetypes',ASL_DIR,'s:',TAG_DONE]

        f:=TRUE
    ENDIF
    IF req:=AllocAslRequest(ASL_FILEREQUEST,tag)
        IF RequestFile(req)
            AddPart(req.dir,'',256)
            StringF(source,'\s\s',req.dir,req.file)
            IF t=F_LOAD 
            ENDIF
        ELSE
            rr:=FALSE
        ENDIF
        FreeAslRequest(req)
        IF rr=FALSE THEN RETURN rr
    ENDIF
    StrCopy(rstr,source,ALL)
    RETURN rstr
ENDPROC
/**/
/**/
/*"main()"*/
PROC main() HANDLE 
    DEF testmain
    tattr:=['topaz.font',8,0,0]:textattr
    localebase:=OpenLibrary('locale.library',0)
    open_WhatView_catalog(NIL,NIL)
    p_DoReadHeader({banner})
    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
    p_InitWIP()
    p_ReadSourceFile('s:filetypes')
    IF (testmain:=p_SetUpScreen())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_InitwipWindow())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_OpenwipWindow())<>ER_NONE THEN Raise(testmain)
    REPEAT
        p_LookAllMessage()
    UNTIL reelquit=TRUE
    Raise(ER_NONE)
EXCEPT
    IF wip_window THEN p_RemwipWindow()
    IF screen THEN p_SetDownScreen()
    p_CloseLibraries()
    SELECT exception
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

