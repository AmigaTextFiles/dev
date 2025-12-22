/*=========================================================================================*/
/* Source code generate by Gui2E v0.1 © 1994 NasGûl                                        */
/*=========================================================================================*/
/*======<<< Peps Header >>>======
 PRGVERSION '0'
 ================================
 PRGREVISION '1'
 ================================
 AUTHOR      'NasGûl'
 ===============================*/
/*======<<<   History   >>>======
 ===============================*/

OPT OSVERSION=37
CONST DEBUG=FALSE
MODULE 'intuition/intuition','gadtools','libraries/gadtools','intuition/gadgetclass','intuition/screens',
       'graphics/text','exec/lists','exec/nodes','exec/ports','eropenlib','utility/tagitem',
       'exec/libraries','utility','reqtools','libraries/reqtools',
       'intuition/intuitionbase','icon','workbench/workbench','workbench/startup'


MODULE 'superplay','spobjects'

MODULE 'rexxsyslib','rexx/storage'

MODULE 'mheader'

ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW,
     ER_PORTEXIST,ER_CREATEPORT,ER_MEM,ER_HANDLE,ER_NOICON,ER_BADARGS

CONST ER_SUPERPLAYLIB=$2755

CONST F_MODULE=0,
      F_CONFIG_SAVE=1,
      F_CONFIG_LOAD=2



PMODULE 'PModules:Plist'
PMODULE 'PModules:DWriteF'
PMODULE 'Pmodules:PMHeader'

/*"WINDOW DEF"*/
DEF screen:PTR TO screen,
    visual=NIL,
    tattr:PTR TO textattr,
    reelquit=FALSE,
    offy,offx
/*=======================================
 = cp Definitions
 =======================================*/
DEF cp_window=NIL:PTR TO window
DEF cp_glist=NIL
DEF cp_menu=NIL
/*==================*/
/*     Gadgets      */
/*==================*/
CONST GA_G_SONGPRED=0
CONST GA_G_MODPRED=1
CONST GA_G_STOP=2
CONST GA_G_MODSUCC=3
CONST GA_G_SONGSUCC=4
CONST GA_G_PLAY=5
CONST GA_G_MODLIST=6
CONST GA_G_LOADMOD=7
CONST GA_G_REMMOD=8
CONST GA_G_UPMOD=9
CONST GA_G_DOWNMOD=10
/*=============================
 = Gadgets labels of cp
 =============================*/
DEF g_songpred
DEF g_songback
DEF g_stop
DEF g_succ
DEF g_songsucc
DEF g_play
DEF g_modlist
DEF g_loadmod
DEF g_remmod
DEF g_upmod
DEF g_downmod
/**/
/*"APPLICATION DEF"*/
DEF arexxport:PTR TO mp
DEF arexxportname[80]:STRING
DEF currentnode=-1
DEF modulelist:PTR TO lh
DEF soundhandle=NIL
DEF defaultdir[256]:STRING
DEF sourceconfig[256]:STRING
DEF prio=0,hide=FALSE
/**/
/*"SUPERPLAY INCLUDES"*/
/*"SuperPlay.h"*/
CONST SPLIB_VERSION=1

/* Possible FileTypes */

CONST SP_FILETYPE_NONE=0
CONST SP_FILETYPE_UNKNOWN=SP_FILETYPE_NONE

     /*
        above : External, user defined FileTypes
                (defined EACH TIME NEW at Library's startup-time).
     */

CONST SP_FILETYPE_ILLEGAL=$FFFFFFFF


/* Possible SubTypes of FileTypes */

CONST SP_SUBTYPE_NONE=0
CONST SP_SUBTYPE_UNKNOWN=SP_SUBTYPE_NONE

     /*
        above : External, user defined FileSubTypes
                (defined EACH TIME NEW at Library's startup-time).
     */

CONST SP_SUBTYPE_ILLEGAL=$FFFFFFFF


/* Possible Input and Output mediums */

CONST SPO_MEDIUM_NONE=0
CONST SPO_MEDIUM_ILLEGAL=$FFFFFFFF

CONST SPO_MEDIUM_DISK=1              /* Play and Write options   */
CONST SPO_MEDIUM_CLIP=2

     /* might not be supported by all kinds of File(Sub)Types */


/* *************************************************** */
/* *                                                 * */
/* * Function Error Codes                            * */
/* *                                                 * */
/* *************************************************** */

CONST SPERR_MAX_ERROR_TEXT_LENGTH=80       /* plus Null-Byte */

CONST SPERR_NO_ERROR=NIL
CONST SPERR_INTERNAL_ERROR=$FFFFFFFF

CONST SPERR_UNKNOWN_FILE_FORMAT=    1
CONST SPERR_FILE_NOT_FOUND=         2
CONST SPERR_NO_MEMORY=              3
CONST SPERR_IFFPARSE_ERROR=         4
CONST SPERR_NO_CLIPBOARD=           5
CONST SPERR_NO_FILE=                6
CONST SPERR_NO_HANDLE=              7
CONST SPERR_NO_DATA=                8
CONST SPERR_NO_INFORMATION=         9
CONST SPERR_ILLEGAL_ACCESS=         10
CONST SPERR_DECODE_ERROR=           11
CONST SPERR_UNKNOWN_PARAMETERS=     12
CONST SPERR_ACTION_NOT_SUPPORTED=   13
CONST SPERR_NO_CHANNELS=            14

        /* Each new Library-Subversion may contain new Codes above
           the last one of these.
           So do not interpret the codes directly, but use
           SPL_GetErrorString.
           Maybe, newer Codes might not be listed up here.
        */
/**/
/*"SuperPlayBase.h"*/
OBJECT superplaybase
    libnode:lib
    seglist:LONG
    exec_base:LONG
    dos_lib:LONG
    intuition_lib:LONG
    spobjectlist:lh
    private1:LONG
    private2:LONG
ENDOBJECT
/**/
/*"spobjects.h"*/
OBJECT objectnode
    node:ln
    version:LONG
    objecttype:LONG
    filename:LONG
    typeid:LONG
    typeode:LONG
    subtypenum:LONG
    subtypeid:LONG
    subtypecode:LONG
    backgroundreplay:LONG
ENDOBJECT

CONST SPO_VERSION=1

CONST SPO_OBJECTTYPE_NONE=0
CONST SPO_OBJECTTYPEUNKNOWN=SPO_OBJECTTYPE_NONE
CONST SPO_OBJECTTYPE_ILLEGAL=$FFFFFFFF

CONST SPO_OBJECTTYPE_SAMPLE=1
CONST SPO_OBJECTTYPE_MODULE=2
/**/
/*"spobjectbase.h"*/
OBJECT objectbase
    libnode:lib
    spobject:LONG
    reserved:LONG
ENDOBJECT
/**/
/**/
/*"WINDOWS PROCEDURES"*/
/*"p_OpenLibraries()"*/
PROC p_OpenLibraries() HANDLE 
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL THEN Raise(ER_GRAPHICSLIB)
    IF (superplaybase:=OpenLibrary('superplay.library',0))=NIL THEN Raise(ER_SUPERPLAYLIB)
    IF (rexxsysbase:=OpenLibrary('rexxsyslib.library',36))=NIL THEN Raise(ER_REXXSYSLIBLIB)
    IF (utilitybase:=OpenLibrary('utility.library',0))=NIL THEN Raise(ER_UTILITYLIB)
    IF (reqtoolsbase:=OpenLibrary('reqtools.library',0))=NIL THEN Raise(ER_REQTOOLSLIB)
    IF (iconbase:=OpenLibrary('icon.library',0))=NIL THEN Raise(ER_ICONLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_CloseLibraries()"*/
PROC p_CloseLibraries()  
    IF iconbase THEN CloseLibrary(iconbase)
    IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
    IF utilitybase THEN CloseLibrary(utilitybase)
    IF rexxsysbase THEN CloseLibrary(rexxsysbase)
    IF superplaybase THEN CloseLibrary(superplaybase)
    IF gfxbase THEN CloseLibrary(gfxbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
ENDPROC
/**/
/*"p_SetUpScreen()"*/
PROC p_SetUpScreen() HANDLE 
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
    IF visual THEN FreeVisualInfo(visual)
    IF screen THEN UnlockPubScreen(NIL,screen)
ENDPROC
/**/
/*"p_InitcpWindow()"*/
PROC p_InitcpWindow() HANDLE 
    DEF g:PTR TO gadget
    IF (g:=CreateContext({cp_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (cp_menu:=CreateMenusA([1,0,'Fichier',0,0,0,0,
                                  2,0,'Charger Liste.','C',0,0,0,
                                  2,0,'Sauver Liste.','S',0,0,0,
                                  2,0,'    Infos.   ','I',0,0,0,
                                  2,0,'   Quitter.  ','Q',0,0,0,
                                   0,0,0,0,0,0,0]:newmenu,NIL))=NIL THEN Raise(ER_MENUS)
    IF LayoutMenusA(cp_menu,visual,NIL)=FALSE THEN Raise(ER_MENUS)
    IF (g_songpred:=CreateGadgetA(BUTTON_KIND,g,[offx+4,offy+11,61,13,'|<',tattr,0,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_songback:=CreateGadgetA(BUTTON_KIND,g_songpred,[offx+76,offy+11,61,13,'<<',tattr,1,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_stop:=CreateGadgetA(BUTTON_KIND,g_songback,[offx+148,offy+11,61,13,'#',tattr,2,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_succ:=CreateGadgetA(BUTTON_KIND,g_stop,[offx+292,offy+11,61,13,'>>',tattr,3,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_songsucc:=CreateGadgetA(BUTTON_KIND,g_succ,[offx+364,offy+11,61,13,'>|',tattr,4,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_play:=CreateGadgetA(BUTTON_KIND,g_songsucc,[offx+220,offy+11,61,13,'>',tattr,5,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_modlist:=CreateGadgetA(LISTVIEW_KIND,g_play,[offx+4,offy+24,421,56,'',tattr,6,0,visual,0]:newgadget,[GA_RELVERIFY,FALSE,GA_IMMEDIATE,FALSE,GTLV_SHOWSELECTED,NIL,GTLV_LABELS,NIL,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_loadmod:=CreateGadgetA(BUTTON_KIND,g_modlist,[offx+4,offy+77,105,13,'Add Mod(s).',tattr,7,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_remmod:=CreateGadgetA(BUTTON_KIND,g_loadmod,[offx+109,offy+77,105,13,'Rem Mod.',tattr,8,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_upmod:=CreateGadgetA(BUTTON_KIND,g_remmod,[offx+214,offy+77,105,13,'Up Mod.',tattr,9,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (g_downmod:=CreateGadgetA(BUTTON_KIND,g_upmod,[offx+319,offy+77,105,13,'Down Mod.',tattr,10,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RendercpWindow()"*/
PROC p_RendercpWindow() 
    IF p_EmptyList(modulelist)<>-1
        Gt_SetGadgetAttrsA(g_modlist,cp_window,NIL,[GA_DISABLED,FALSE,GTLV_SHOWSELECTED,TRUE,GTLV_SELECTED,currentnode,GTLV_LABELS,modulelist,TAG_DONE])
    ELSE
        Gt_SetGadgetAttrsA(g_modlist,cp_window,NIL,[GA_DISABLED,TRUE,GTLV_SHOWSELECTED,NIL,GTLV_LABELS,NIL,TAG_DONE])
    ENDIF
    RefreshGList(g_songpred,cp_window,NIL,-1)
    Gt_RefreshWindow(cp_window,NIL)
ENDPROC
/**/
/*"p_OpencpWindow()"*/
PROC p_OpencpWindow() HANDLE 
    DEF mx,my
    DEF winx,winy,offyz
    mx:=screen.mousex-215
    my:=screen.mousey-46
    winx:=429+offx
    winy:=92+offy
    offyz:=26+offy
    IF (cp_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,mx,
                       WA_TOP,my,
                       WA_WIDTH,winx,
                       WA_HEIGHT,winy,
                       WA_IDCMP,$400378+IDCMP_REFRESHWINDOW,
                       WA_FLAGS,$102E+WFLG_HASZOOM,
                       WA_GADGETS,cp_glist,
                       WA_ZOOM,[mx,my,429,offyz]:INT,
                       WA_CUSTOMSCREEN,screen,
                       WA_TITLE,title_req,
                       WA_SCREENTITLE,'Made With GadToolsBox V2.0b © 1991-1993',
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    IF SetMenuStrip(cp_window,cp_menu)=FALSE THEN Raise(ER_MENUS)
    Gt_RefreshWindow(cp_window,NIL)
    p_RendercpWindow()
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RemcpWindow()"*/
PROC p_RemcpWindow() 
    IF cp_window THEN CloseWindow(cp_window)
    IF cp_menu THEN FreeMenus(cp_menu)
    IF cp_glist THEN FreeGadgets(cp_glist)
ENDPROC
/**/
/*"p_CloseWindow()"*/
PROC p_CloseWindow()
    IF cp_window THEN p_RemcpWindow()
    IF screen THEN p_SetDownScreen()
    cp_window:=NIL
    screen:=NIL
ENDPROC
/**/
/*"p_OpenWindow()"*/
PROC p_OpenWindow() HANDLE
    DEF t
    IF (t:=p_SetUpScreen())<>ER_NONE THEN Raise(t)
    IF (t:=p_InitcpWindow())<>ER_NONE THEN Raise(t)
    IF (t:=p_OpencpWindow())<>ER_NONE THEN Raise(t)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_LockGads(ar)"*/
PROC p_LockGads(ar)
    IF cp_window<>NIL
        Gt_SetGadgetAttrsA(g_songpred,cp_window,NIL,[GA_DISABLED,ar,TAG_DONE])
        Gt_SetGadgetAttrsA(g_songback,cp_window,NIL,[GA_DISABLED,ar,TAG_DONE])
        Gt_SetGadgetAttrsA(g_stop,cp_window,NIL,[GA_DISABLED,ar,TAG_DONE])
        Gt_SetGadgetAttrsA(g_succ,cp_window,NIL,[GA_DISABLED,ar,TAG_DONE])
        Gt_SetGadgetAttrsA(g_songsucc,cp_window,NIL,[GA_DISABLED,ar,TAG_DONE])
        Gt_SetGadgetAttrsA(g_play,cp_window,NIL,[GA_DISABLED,ar,TAG_DONE])
    ENDIF
ENDPROC
/**/

/**/
/*"MESSAGES PROCEDURES"*/
/*"p_LookAllMessage()"*/
PROC p_LookAllMessage() 
    DEF sigreturn
    DEF cpport:PTR TO mp
    IF cp_window THEN cpport:=cp_window.userport ELSE cpport:=NIL
    sigreturn:=Wait(Shl(1,cpport.sigbit) OR
                    Shl(1,arexxport.sigbit) OR
                    $F000)
    IF (sigreturn AND Shl(1,cpport.sigbit))
        p_LookcpMessage()
    ENDIF
    IF (sigreturn AND Shl(1,arexxport.sigbit))
        p_LookArexxMessage()
    ENDIF
    IF (sigreturn AND $F000)
        reelquit:=TRUE
    ENDIF
ENDPROC
/**/
/*"p_LookcpMessage()"*/
PROC p_LookcpMessage() 
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF gstr:PTR TO stringinfo
   DEF type=0,infos=NIL
   DEF cn:PTR TO ln,tn
   WHILE mes:=Gt_GetIMsg(cp_window.userport)
       type:=mes.class
       SELECT type
           CASE IDCMP_MENUPICK
              infos:=mes.code
              SELECT infos
                CASE $F800 /* Charger */
                    p_DoConfig(F_CONFIG_LOAD)
                CASE $F820 /* Sauver */
                    p_DoConfig(F_CONFIG_SAVE)
                CASE $F840 /* Info */
                    p_DoReqInfo()
                CASE $F860 /* Quit */
                    reelquit:=TRUE
              ENDSELECT
           CASE IDCMP_GADGETDOWN 
           CASE IDCMP_REFRESHWINDOW
              p_RendercpWindow()
           CASE IDCMP_GADGETUP
              g:=mes.iaddress
              infos:=g.gadgetid
              SELECT infos
                  CASE GA_G_MODSUCC
                    p_DoModSucc()
                  CASE GA_G_MODPRED
                    p_DoModPred()
                  CASE GA_G_STOP
                    p_DoModStop()
                  CASE GA_G_SONGPRED
                    p_DoSongPred()
                  CASE GA_G_SONGSUCC
                    p_DoSongSucc()
                  CASE GA_G_PLAY
                    p_DoModPlay()
                  CASE GA_G_MODLIST
                    currentnode:=mes.code
                    p_RendercpWindow()
                  CASE GA_G_LOADMOD
                    p_DoLoad()
                  CASE GA_G_REMMOD
                    currentnode:=p_EnleveNode(modulelist,currentnode,FALSE,0)
                    p_RendercpWindow()
                  CASE GA_G_UPMOD
                    IF p_EmptyList(modulelist)<>-1 
                        currentnode:=p_DoUpNode(modulelist,currentnode)
                        p_RendercpWindow()
                    ENDIF
                  CASE GA_G_DOWNMOD
                    IF p_EmptyList(modulelist)<>-1  
                        currentnode:=p_DoDownNode(modulelist,currentnode)
                        p_RendercpWindow()
                    ENDIF
              ENDSELECT
       ENDSELECT
       Gt_ReplyIMsg(mes)
   ENDWHILE
ENDPROC
/**/
/*"p_LookArexxMessage()"*/
PROC p_LookArexxMessage()
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Process arexx Messge.
 ==============================================================================*/
    DEF mess_rexx:PTR TO rexxmsg
    DEF commande:PTR TO LONG
    DEF retstr[256]:STRING
    DEF pv[256]:STRING
    DEF tn,ret
    DEF pvn:PTR TO ln
    WHILE mess_rexx:=GetMsg(arexxport)
        IF IsRexxMsg(mess_rexx)
            commande:=mess_rexx.args
            IF StrCmp(commande[0],'MODINFO',7)
                IF currentnode<>-1
                    mess_rexx.result1:=0
                    pvn:=p_GetAdrNode(modulelist,currentnode)
                    StringF(retstr,'\s',pvn.name)
                    mess_rexx.result2:=String(EstrLen(retstr))
                    StrCopy(mess_rexx.result2,retstr,EstrLen(retstr))
                ENDIF
            ELSEIF StrCmp(commande[0],'REQINFO',7)
                mess_rexx.result1:=0
                p_DoReqInfo()
            ELSEIF StrCmp(commande[0],'MODNUMINFO',10)
                IF currentnode<>-1
                    mess_rexx.result1:=0
                    MidStr(pv,commande[0],11,ALL)
                    StringF(retstr,'\s',pv)
                    tn:=Val(pv,NIL)
                    pvn:=p_GetAdrNode(modulelist,tn)
                    StringF(retstr,'\s',pvn.name)
                    mess_rexx.result2:=String(EstrLen(retstr))
                    StrCopy(mess_rexx.result2,retstr,EstrLen(retstr))
                ENDIF
            ELSEIF StrCmp(commande[0],'NBRSMOD',7)
                mess_rexx.result1:=0
                StringF(retstr,'\d',p_CountNodes(modulelist))
                mess_rexx.result2:=String(EstrLen(retstr))
                StrCopy(mess_rexx.result2,retstr,EstrLen(retstr))
            ELSEIF StrCmp(commande[0],'NEXTSONG',8)
                p_DoSongSucc()
            ELSEIF StrCmp(commande[0],'PREDSONG',8)
                p_DoSongPred()
            ELSEIF StrCmp(commande[0],'ADDMOD',6)
                MidStr(pv,commande[0],7,ALL)
                currentnode:=p_AjouteNode(modulelist,pv,0)
                IF cp_window<>NIL THEN p_RendercpWindow()
            ELSEIF StrCmp(commande[0],'PLAYMOD',7)
                MidStr(pv,commande[0],8,ALL)
                p_PlayModule(pv)
            ELSEIF StrCmp(commande[0],'PLAY',4)
                p_DoModPlay()
            ELSEIF StrCmp(commande[0],'STOP',4)
                p_DoModStop()
            ELSEIF StrCmp(commande[0],'QUIT',4)
                reelquit:=TRUE
            ELSEIF StrCmp(commande[0],'CLEARLIST',9)
                modulelist:=p_CleanList(modulelist,FALSE,0,LIST_CLEAN)
                IF cp_window<>NIL THEN p_RendercpWindow()
            ELSEIF StrCmp(commande[0],'CONFIGLOAD',10)
                MidStr(pv,commande[0],11,ALL)
                IF p_ReadFile(pv)
                    IF cp_window<>NIL THEN p_RendercpWindow()
                ENDIF
            ELSEIF StrCmp(commande[0],'CONFIGSAVE',10)
                MidStr(pv,commande[0],11,ALL)
                p_WriteFile(pv)
            ELSEIF StrCmp(commande[0],'LOAD',4)
                p_DoLoad()
            ELSEIF StrCmp(commande[0],'HIDE',4)
                IF cp_window<>NIL THEN p_CloseWindow()
            ELSEIF StrCmp(commande[0],'SHOW',4)
                IF cp_window=NIL 
                    ret:=p_OpenWindow()
                    IF ret<>ER_NONE
                        mess_rexx.result1:=20
                        mess_rexx.result2:=''
                    ENDIF
                ENDIF
            ELSE
                mess_rexx.result1:=20
                mess_rexx.result2:=String(EstrLen(''))
                StrCopy(mess_rexx.result2,retstr,EstrLen(''))
            ENDIF
        ENDIF
        IF mess_rexx THEN ReplyMsg(mess_rexx)
        IF mess_rexx.result2 THEN DisposeLink(mess_rexx.result2)
    ENDWHILE
    WHILE mess_rexx:=GetMsg(arexxport) DO ReplyMsg(arexxport)
ENDPROC
/**/
/**/
/*"APPLICATIONS PROCEDURES"*/
/*"p_DoModSucc()"*/
PROC p_DoModSucc()
    dWriteF(['MODSUCC\n'],0)
    IF soundhandle<>NIL
        SpL_FastForward(soundhandle)
    ENDIF
ENDPROC
/**/
/*"p_DoModPred()"*/
PROC p_DoModPred()
    dWriteF(['MODPRED\n'],0)
    IF soundhandle<>NIL
        SpL_FastBackward(soundhandle)
    ENDIF
ENDPROC
/**/
/*"p_DoModStop()"*/
PROC p_DoModStop()
    dWriteF(['STOP\n'],0)
    IF soundhandle
        SpL_FreeHandle(soundhandle)
        soundhandle:=NIL
    ENDIF
ENDPROC
/**/
/*"p_DoSongPred()"*/
PROC p_DoSongPred()
    DEF cn:PTR TO ln
    dWriteF(['SONGPRED\n'],0)
    IF currentnode>0
        currentnode:=currentnode-1
        IF cp_window THEN p_RendercpWindow()
        cn:=p_GetAdrNode(modulelist,currentnode)
        p_PlayModule(cn.name)
    ELSE
        p_Request('ZigBoom! a quelque chose a vous dire\n'+
                  '      <<< Debut de liste.>>>          ','Merci',0)
    ENDIF
ENDPROC
/**/
/*"p_DoSongSucc()"*/
PROC p_DoSongSucc()
    DEF tn
    DEF cn:PTR TO ln
    dWriteF(['SONGSUCC\n'],0)
    tn:=p_CountNodes(modulelist)
    IF (currentnode<(tn-1))
        currentnode:=currentnode+1
        IF cp_window THEN p_RendercpWindow()
        cn:=p_GetAdrNode(modulelist,currentnode)
        p_PlayModule(cn.name)
    ELSE
        p_Request('ZiqBoom! a quelque chose a vous dire\n'+
                  '         <<< Fin de liste.>>>         ','Merci',0)
    ENDIF
ENDPROC
/**/
/*"p_DoModPlay()"*/
PROC p_DoModPlay()
    DEF cn:PTR TO ln
    IF currentnode<>-1
        cn:=p_GetAdrNode(modulelist,currentnode)
        p_PlayModule(cn.name)
    ENDIF
    dWriteF(['PLAY\n'],0)
ENDPROC
/**/
/*"p_DoLoad()"*/
PROC p_DoLoad()
    IF p_FileRequester(F_MODULE)
        IF cp_window THEN p_RendercpWindow()
    ENDIF
ENDPROC
/**/
/*"p_DoConfig()"*/
PROC p_DoConfig(p)
    IF p_FileRequester(p)
        SELECT p
            CASE F_CONFIG_LOAD; p_ReadFile(sourceconfig)
            CASE F_CONFIG_SAVE; p_WriteFile(sourceconfig)
        ENDSELECT
        IF cp_window THEN p_RendercpWindow()
    ENDIF
ENDPROC
/**/
/*"p_DoReqInfo()"*/
PROC p_DoReqInfo()
    DEF reqstr[1000]:STRING
    DEF cn:PTR TO ln,stat:PTR TO LONG
    IF currentnode<>-1
        cn:=p_GetAdrNode(modulelist,currentnode)
    ELSE
        cn.name:='Ancun.'
    ENDIF
    stat:=['Current:','Playing:']
    StringF(reqstr,'«««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»\n'+
                   '««« AmigaE             © Wouter Van Oortmerssen.»»»\n'+
                   '««« reqtools.library   © Nico François.         »»»\n'+
                   '««« Arexx              © William S. Hawes       »»»\n'+
                   '««« superplay.library  © Andreas R. Kleinert.   »»»\n'+
                   '««« gadtoolsbox        © Jaba Dev.              »»»\n'+
                   '««« GoldED             © Dietmar Eilert.        »»»\n'+
                   '«««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»\n'+
                   '««« \s\l\s[36]»»»\n'+
                   '«««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»',IF soundhandle THEN stat[1] ELSE stat[0],cn.name)
    p_Request(reqstr,'Tous ce monde..|C\aest pas vrai..',0)
ENDPROC
/**/
/*"p_ReadFile(str)"*/
PROC p_ReadFile(str)
    DEF fh,buf[1000]:ARRAY,n=0,last=NIL,s,first=NIL
    DEF nom[256]:STRING,rn[256]:STRING
    IF fh:=Open(str,OLDFILE)
        WHILE Fgets(fh,buf,1000)
            IF n<>0
                StringF(nom,'\s',buf)
                StrCopy(rn,nom,(EstrLen(nom)-1))
                currentnode:=p_AjouteNode(modulelist,rn,0)
            ENDIF
            n:=n+1
        ENDWHILE
        Close(fh)
    ENDIF
ENDPROC
/**/
/*"p_WriteFile(str)"*/
PROC p_WriteFile(str)
    DEF fh,oldout
    DEF cn:PTR TO ln
    oldout:=stdout
    IF fh:=Open(str,1006)
        stdout:=fh
        WriteF('MODLIST\n')
        cn:=modulelist.head
        WHILE cn
            IF cn.succ<>0
                WriteF('\s\n',cn.name)
            ENDIF
            cn:=cn.succ
        ENDWHILE
        Close(fh)
    ENDIF
    stdout:=oldout
ENDPROC
/**/

/*"p_CreateArexxPort(nom,pri)"*/
PROC p_CreateArexxPort(nom,pri) HANDLE
/*===============================================================================
 = Para         : name (STRING),pri (NUM).
 = Return       : the address of the port if ok,else NIL.
 = Description  : Create a public port.
 ==============================================================================*/
    DEF dat_port:PTR TO ln
    DEF myt:PTR TO ln
    IF FindPort(nom)<>0 THEN Raise(ER_PORTEXIST)
    arexxport:=CreateMsgPort()
    IF arexxport=0
        Raise(ER_CREATEPORT)
    ENDIF
    myt:=FindTask(NIL)
    SetTaskPri(myt,prio)
    dat_port:=arexxport.ln
    dat_port.name:=nom
    dat_port.pri:=pri
    dat_port.type:=NT_MSGPORT
    arexxport.sigtask:=myt
    arexxport.flags:=PA_SIGNAL
    IF nom<>NIL
        AddPort(arexxport)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_DeleteArexxPort(adr_port:PTR TO mp)"*/
PROC p_DeleteArexxPort(adr_port:PTR TO mp)
/*===============================================================================
 = Para         : Address of port.
 = Return       : NONE
 = Description  : Remove a public port.
 ==============================================================================*/
    DEF data_port:PTR TO ln
    data_port:=adr_port.ln
    IF data_port.name<>NIL THEN RemPort(adr_port)
    IF adr_port THEN DeleteMsgPort(adr_port)
    SetTaskPri(FindTask(NIL),0)
ENDPROC
/**/
/*"p_InitAPP()"*/
PROC p_InitAPP() HANDLE
    DEF t
    IF (t:=p_CreateArexxPort(arexxportname,0))<>ER_NONE THEN Raise(t)
    IF (modulelist:=p_InitList())=NIL THEN Raise(ER_MEM)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RemAPP()"*/
PROC p_RemAPP()
    IF arexxport THEN p_DeleteArexxPort(arexxport)
    IF modulelist THEN p_CleanList(modulelist,FALSE,0,LIST_REMOVE)
    IF soundhandle<>NIL THEN SpL_FreeHandle(soundhandle)
ENDPROC
/**/
/*"p_PlayModule(name)"*/
PROC p_PlayModule(name)
    DEF retval
    IF soundhandle 
        SpL_FreeResources(soundhandle)
        SpL_FreeHandle(soundhandle)
    ENDIF
    p_LockGads(TRUE)
    IF cp_window<>NIL THEN SetWindowTitles(cp_window,name,'Made With GadToolsBox V2.0b © 1991-1993')
    IF soundhandle:=SpL_AllocHandle(NIL)
        retval:=SpL_InitHandleAsDOS(soundhandle,NIL)
        IF retval=0
            retval:=SpL_SuperPlay(soundhandle,name)
            IF retval<>0 THEN p_Request(SpL_GetErrorString(retval),'Error',0)
        ELSE
            p_Request(SpL_GetErrorString(retval),'Error',0)
        ENDIF
    ELSE
        p_Request(SpL_GetErrorString(retval),'Error',0)
    ENDIF
    IF cp_window<>NIL THEN SetWindowTitles(cp_window,title_req,'Made With GadToolsBox V2.0b © 1991-1993')
    p_LockGads(FALSE)
ENDPROC
/**/
/*"p_FileRequester(a)"*/
PROC p_FileRequester(a)
/*===============================================================================
 = Para         : NONE
 = Return       : False if cancel selected.
 = Description  : PopUp a MultiFileRequester,build the whatview arguments.
 ==============================================================================*/
    DEF reqfile:PTR TO rtfilerequester
    DEF liste:PTR TO rtfilelist
    DEF buffer[120]:STRING
    DEF add_liste=0
    DEF ret=FALSE
    DEF the_reelname[256]:STRING
    DEF lock,taglist
    reqfile:=NIL
    dWriteF(['p_WVFileRequester()\n'],[0])
    IF a=F_MODULE
        taglist:=[RT_PUBSCRNAME,p_LockActivePubScreen(),RTFI_FLAGS,FREQF_MULTISELECT+FREQF_PATGAD,RTFI_OKTEXT,'Charger',RTFI_HEIGHT,200,
                  RT_UNDERSCORE,"_",TAG_DONE]
    ELSEIF a=F_CONFIG_LOAD
        taglist:=[RT_PUBSCRNAME,p_LockActivePubScreen(),RTFI_FLAGS,FREQF_PATGAD,RTFI_OKTEXT,'Charger',RTFI_HEIGHT,200,
                  RT_UNDERSCORE,"_",TAG_DONE]
    ELSEIF a=F_CONFIG_SAVE
        taglist:=[RT_PUBSCRNAME,p_LockActivePubScreen(),RTFI_FLAGS,FREQF_SAVE+FREQF_PATGAD,RTFI_OKTEXT,'Sauver',RTFI_HEIGHT,200,
                  RT_UNDERSCORE,"_",TAG_DONE]
    ENDIF
    IF reqfile:=RtAllocRequestA(RT_FILEREQ,NIL)
        buffer[0]:=0
        RtChangeReqAttrA(reqfile,[RTFI_DIR,defaultdir,RTFI_MATCHPAT,'(#?.mod|mod.#?)',TAG_DONE])
        add_liste:=RtFileRequestA(reqfile,buffer,title_req,taglist)
        StrCopy(defaultdir,reqfile.dir,ALL)
        IF reqfile THEN RtFreeRequest(reqfile)
        IF add_liste THEN ret:=TRUE
    ELSE
        dWriteF(['p_WVFileRequester() Bad\n'],[0])
        ret:=FALSE
    ENDIF
    AddPart(defaultdir,'',256)
    IF ret=TRUE
        IF a=F_MODULE
            liste:=add_liste
            IF add_liste
                WHILE liste
                    StringF(the_reelname,'\s\s',defaultdir,liste.name)
                    currentnode:=p_AjouteNode(modulelist,the_reelname,0)
                    liste:=liste.next
                ENDWHILE
                IF add_liste THEN RtFreeFileList(add_liste)
            ELSE
            ENDIF
        ELSE
            StringF(sourceconfig,'\s\s',defaultdir,buffer)
        ENDIF
    ELSE
        ret:=FALSE
    ENDIF
    RETURN ret
ENDPROC
/**/
/*"p_Request(bodytext,gadgettext,the_arg)"*/
PROC p_Request(bodytext,gadgettext,the_arg)
/*===============================================================================
 = Para         : texte (STRING),gadgets (STRING),the_arg.
 = Return       : FALSE if cancel selected,else TRUE.
 = Description  : PopUp a requester (reqtools.library).
 ==============================================================================*/
    DEF ret
    DEF taglist
    dWriteF(['p_MakeWVRequest()\n'],[0])
    IF cp_window<>NIL
        taglist:=[RT_WINDOW,cp_window,RT_LOCKWINDOW,TRUE,RTEZ_REQTITLE,title_req,RT_UNDERSCORE,"_",0]
    ELSE
        taglist:=[RT_PUBSCRNAME,p_LockActivePubScreen(),RTEZ_REQTITLE,title_req,RT_UNDERSCORE,"_",0]
    ENDIF
    ret:=RtEZRequestA(bodytext,gadgettext,0,the_arg,taglist)
    RETURN ret
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
/*"p_StartCLI()"*/
PROC p_StartCLI() HANDLE
    DEF myargs:PTR TO LONG,rdargs=NIL
    myargs:=[0,0,0,0]
    IF rdargs:=ReadArgs('ArexxPortName/K,Priority/N,Def_Dir/K,Hide/S',myargs,NIL)
        IF myargs[0] THEN StrCopy(arexxportname,myargs[0],ALL) ELSE StrCopy(arexxportname,'ZiqBoom!Port',ALL)
        IF myargs[1] THEN prio:=Long(myargs[1])
        IF myargs[2] THEN StrCopy(defaultdir,myargs[2],ALL) ELSE StrCopy(defaultdir,'',ALL)
        IF myargs[3] THEN hide:=TRUE
    ELSE
        Raise(ER_BADARGS)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF rdargs THEN FreeArgs(rdargs)
    RETURN exception
ENDPROC
/**/
/*"p_StartWB()"*/
PROC p_StartWB() HANDLE
    DEF bl,disk:PTR TO diskobject
    DEF wb:PTR TO wbstartup
    DEF args:PTR TO wbarg
    DEF prgname[80]:STRING,str[256]:STRING,np=NIL
    wb:=wbmessage
    args:=wb.arglist
    StrCopy(prgname,args[0].name,ALL)
    bl:=CurrentDir(args[0].lock)
    IF (disk:=GetDiskObject(prgname))=NIL THEN Raise(ER_NOICON)
    IF str:=FindToolType(disk.tooltypes,'AREXXPORTNAME')
        StrCopy(arexxportname,str,ALL)
    ELSE
        StrCopy(arexxportname,'ZiqBoom!Port',ALL)
    ENDIF
    IF str:=FindToolType(disk.tooltypes,'PRIORITY')
        np:=Val(str,NIL)
        prio:=np
    ENDIF
    IF str:=FindToolType(disk.tooltypes,'HIDE') THEN hide:=TRUE
    IF str:=FindToolType(disk.tooltypes,'DEF_DIR')
        StrCopy(defaultdir,str,ALL)
    ELSE
        StrCopy(defaultdir,'',ALL)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF bl THEN CurrentDir(bl)
    IF disk THEN FreeDiskObject(disk)
    RETURN exception
ENDPROC
/**/
/**/
/*"main()"*/
PROC main() HANDLE 
    DEF testmain
    tattr:=['topaz.font',8,0,0]:textattr
    StrCopy(defaultdir,'Hd2:Modules/Pro',ALL)
    p_DoReadHeader({banner})
    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
    IF wbmessage<>NIL
        IF (testmain:=p_StartWB())<>ER_NONE THEN Raise(testmain)
    ELSE
        IF (testmain:=p_StartCLI())<>ER_NONE THEN Raise(testmain)
    ENDIF
    IF (testmain:=p_InitAPP())<>ER_NONE THEN Raise(testmain)
    IF hide=FALSE
        IF (testmain:=p_SetUpScreen())<>ER_NONE THEN Raise(testmain)
        IF (testmain:=p_InitcpWindow())<>ER_NONE THEN Raise(testmain)
        IF (testmain:=p_OpencpWindow())<>ER_NONE THEN Raise(testmain)
    ENDIF
    REPEAT
        p_LookAllMessage()
    UNTIL reelquit=TRUE
    Raise(ER_NONE)
EXCEPT
    IF cp_window THEN p_RemcpWindow()
    IF screen THEN p_SetDownScreen()
    p_RemAPP()
    p_CloseLibraries()
    SELECT exception
        CASE ER_LOCKSCREEN;     WriteF('Lock Screen Failed.\n')
        CASE ER_VISUAL;         WriteF('Error Visual.\n')
        CASE ER_CONTEXT;        WriteF('Error Context.\n')
        CASE ER_MENUS;          WriteF('Error Menus.\n')
        CASE ER_GADGET;         WriteF('Error Gadget.\n')
        CASE ER_WINDOW;         WriteF('Error Window.\n')
        CASE ER_SUPERPLAYLIB;   WriteF('superplay.library ??\n')
        CASE ER_REQTOOLSLIB;    WriteF('reqtools.library ??\n')
        CASE ER_REXXSYSLIBLIB;     WriteF('rexxsyslib.library ??\n')
        CASE ER_UTILITYLIB;     WriteF('utility.library ??\n')
        CASE ER_PORTEXIST;      WriteF('Arexx port \s exist.\n',arexxportname)
        CASE ER_CREATEPORT;     WriteF('Error Create arexx port.\n')
        CASE ER_BADARGS;        WriteF('Bad Args.\n')
        CASE ER_NOICON;         WriteF('No Icon.\n')
    ENDSELECT
ENDPROC
/**/
