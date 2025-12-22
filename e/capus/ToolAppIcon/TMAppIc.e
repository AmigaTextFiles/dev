/********************************************************************************
 * << AUTO HEADER XDME >>
 ********************************************************************************
 ED          "EDG"
 EC          "EC"
 PREPRO      "EPP"
 SOURCE      "TMAppIc.e"
 EPPDEST     "TMA_EPP.e"
 EXEC        "TMAppIc"
 ISOURCE     "TM.i"
 HSOURCE     " "
 ERROREC     " "
 ERROREPP    " "
 VERSION     "0"
 REVISION    "1"
 NAMEPRG     "TMAppIc"
 NAMEAUTHOR  "NasGûl"
 ********************************************************************************
 * HISTORY :
 *******************************************************************************/

OPT OSVERSION=37
OPT LARGE

CONST DEBUG=FALSE

CONST ID_TMAP=$544D4150,
      ID_EXEC=$45584543,
      ID_MODE=$4D4F4445,
      ID_COMM=$434F4D4D,
      ID_HKEY=$484B4559,
      ID_STAK=$5354414B,
      ID_PRIO=$5052494F,
      ID_DELA=$44454C41,
      ID_CDIR=$43444952,
      ID_PATH=$50415448,
      ID_OUTP=$4F555450,
      ID_PSCR=$50534352,
      ID_ARGS=$41524753,
      ID_TOFR=$544F4652,
      ID_FILE=$46494C45,
      ID_POSX=$504F5358,
      ID_POSY=$504F5359,
      ID_SHNA=$53484E41,
      LIST_REMOVE=0,
      LIST_CLEAN=1,
      DIM_X=0,
      DIM_Y=1

ENUM GAD_NAME,GAD_EXECTYPE,GAD_GETCOMMAND,
     GAD_COMMAND,GAD_HOTKEY,GAD_STACK,GAD_PRIORITY,
     GAD_DELAY,GAD_CURRENTDIR,GAD_GETPATH,GA_PATH,
     GAD_GETOUTPUT,GAD_OUTPUT,GAD_GETPUBSCREEN,
     GAD_PUBSCREEN,GAD_ARGUMENTS,GAD_TOFRONT,
     GAD_ADD,GAD_REM,GAD_FILE,GAD_GETFILE,
     GAD_POSITION,GAD_POSX,GAD_POSY,
     GAD_SHOWNAME,GAD_SAVE,GAD_SAVEAS,
     GAD_USE,GAD_TEST,GAD_QUIT,GAD_GETCURRENTDIR,GAD_LIST

ENUM ER_NONE,
     ER_WB,ER_VISUAL,ER_CONTEXT,ER_MENU,ER_GADGET,ER_WINDOW,
     ER_TMHANDLE,
     ER_LIST,
     ER_EXECOBJ,
     ER_IMAGEOBJ,
     ER_ICONOBJ,
     ER_PORT,
     ER_REQ,
     ER_SIG,
     ER_NOFILE,ER_APPITEM,ER_FORMAT,OK_FICHIER,
     ER_NOTM

MODULE 'intuition/intuition'
MODULE 'gadtools','libraries/gadtools'
MODULE 'intuition/gadgetclass','intuition/screens','graphics/text'
MODULE 'exec/lists','exec/nodes','utility/tagitem','exec/ports'
MODULE 'libraries/toolmanager','toolmanager','eropenlib','reqtools','libraries/reqtools','wb'
MODULE 'workbench/workbench','mheader'
PMODULE 'pmodules:pmheader'
PMODULE 'pmodules:dwritef'
PMODULE 'TM_InitRem'
PMODULE 'TM_List'
/* DEFINITION GENERALES */
DEF execw_screen:PTR TO screen,
    execw_visual=NIL,
    execw_window=NIL:PTR TO window,
    execw_glist=NIL
/** GADGETLABELS **/
DEF g_name,g_exectype,g_getcommand,g_command,g_hotkey,
    g_stack,g_priority,g_delay,g_currentdir,g_getpath,
    g_path,g_getoutput,g_output,g_getpubscreen,
    g_pubscreen,g_arguments,g_tofront,g_add,
    g_rem,g_file,g_getfile,g_position,
    g_posx,g_posy,g_showname,g_save,
    g_saveas,g_use,g_test,g_quit,g_getcurrentdir,g_list
DEF tattr
DEF nofile=FALSE
DEF reelquit=FALSE  /* flags quit */
DEF tm_h:PTR TO tmhandle
DEF prgport:PTR TO mp
DEF prgsig=-1
DEF list_appicon:PTR TO lh
DEF list_empty:PTR TO LONG
DEF currentnode
DEF appitem
DEF winpos=NIL:PTR TO window
PROC tm_GoodFormat(file) HANDLE /*"tm_GoodFormat(file)"*/
    DEF len,buf,handle,flen=TRUE,chunk
    IF (flen:=FileLength(file))=-1 THEN Raise(FALSE)
    IF (buf:=New(flen+1))=NIL THEN Raise(FALSE)
    IF (handle:=Open(file,1005))=NIL THEN Raise(FALSE)
    len:=Read(handle,buf,flen)
    Close(handle)
    IF len<1 THEN Raise(FALSE)
    chunk:=Long(buf)
    IF chunk<>ID_TMAP
        tm_Request('ce n\aest pas un fichier TMAppIc.','_Ok',NIL)
        Dispose(buf)
        Raise(FALSE)
    ENDIF
    Raise(TRUE)
EXCEPT
    IF buf THEN Dispose(buf)
    dWriteF(['tm_GoodFormat() \d\n'],[exception])
    RETURN exception
ENDPROC
PROC tm_ReadBINFile(mode) /*"tm_ReadBINFile(mode)"*/
    DEF len,a,adr,buf,handle,flen=TRUE,pos
    DEF f_s[256]:STRING,chunk
    DEF myappic:PTR TO appiconnode
    DEF node:PTR TO ln
    DEF nn
    DEF pv[256]:STRING
    /*****************************************/
    /* Stockage du fichier source dans buf   */
    /*****************************************/
    IF mode=NIL
        IF (flen:=FileLength('Env:TMAppIc.prefs'))<>-1
            StrCopy(f_s,'ENV:TMAppIc.Prefs',ALL)
            nofile:=FALSE
        ELSE
            IF (flen:=FileLength('Envarc:TMAppIc.Prefs'))<>-1
                StrCopy(f_s,'Envarc:TMAppIc.Prefs',ALL)
                nofile:=FALSE
            ELSE
                nofile:=TRUE
            ENDIF
        ENDIF
    ELSE
        StrCopy(f_s,mode,ALL)
        IF (flen:=FileLength(f_s))=-1 THEN RETURN ER_NOFILE
        nofile:=FALSE
    ENDIF
    IF nofile=TRUE THEN RETURN TRUE
    IF (buf:=New(flen+1))=NIL THEN RETURN ER_NOFILE
    IF (handle:=Open(f_s,1005))=NIL THEN RETURN ER_NOFILE
    len:=Read(handle,buf,flen)
    Close(handle)
    IF len<1 THEN RETURN ER_NOFILE
    adr:=buf
    chunk:=Long(adr)
    IF chunk<>ID_TMAP
        tm_Request('ce n\aest pas un fichier TMAppIc.','_Ok',NIL)
        Dispose(buf)
        RETURN ER_FORMAT
    ENDIF
    /***********/
    /* Lecture */
    /***********/
    FOR a:=0 TO len-1
        pos:=adr++
        chunk:=Long(pos)
        SELECT chunk
            CASE ID_EXEC
                node:=New(SIZEOF ln)
                myappic:=New(SIZEOF appiconnode)
                node.succ:=0
                StringF(pv,'\s',pos+4)
                node.name:=String(EstrLen(pv))
                StrCopy(node.name,pv,ALL)
                CopyMem(node,myappic.node,SIZEOF ln)
                AddTail(list_appicon,myappic.node)
                nn:=p_GetNumNode(list_appicon,myappic.node)
                IF nn=0
                    list_appicon.head:=myappic.node
                    node.pred:=0
                ENDIF
            CASE ID_MODE
                myappic.exectype:=Int(pos+4)
            CASE ID_COMM
                StringF(pv,'\s',pos+4)
                myappic.command:=String(EstrLen(pv))
                StrCopy(myappic.command,pv,ALL)
            CASE ID_HKEY
                StringF(pv,'\s',pos+4)
                myappic.hotkey:=String(EstrLen(pv))
                StrCopy(myappic.hotkey,pv,ALL)
            CASE ID_STAK
               myappic.stack:=Long(pos+4)
            CASE ID_PRIO
               myappic.priority:=Int(pos+4)
            CASE ID_DELA
               myappic.delay:=Int(pos+4)
            CASE ID_CDIR
                StringF(pv,'\s',pos+4)
                myappic.currentdir:=String(EstrLen(pv))
                StrCopy(myappic.currentdir,pv,ALL)
            CASE ID_PATH
                StringF(pv,'\s',pos+4)
                myappic.path:=String(EstrLen(pv))
                StrCopy(myappic.path,pv,ALL)
            CASE ID_OUTP
                StringF(pv,'\s',pos+4)
                myappic.output:=String(EstrLen(pv))
                StrCopy(myappic.output,pv,ALL)
            CASE ID_PSCR
                StringF(pv,'\s',pos+4)
                myappic.pubscreen:=String(EstrLen(pv))
                StrCopy(myappic.pubscreen,pv,ALL)
            CASE ID_ARGS
                myappic.arguments:=Char(pos+4)
            CASE ID_TOFR
                myappic.tofront:=Char(pos+4)
            CASE ID_FILE
                StringF(pv,'\s',pos+4)
                myappic.file:=String(EstrLen(pv))
                StrCopy(myappic.file,pv,ALL)
            CASE ID_POSX
                myappic.posx:=Int(pos+4)
            CASE ID_POSY
                myappic.posy:=Int(pos+4)
            CASE ID_SHNA
                myappic.showname:=Char(pos+4)
                IF node THEN Dispose(node)
        ENDSELECT
    ENDFOR
    Dispose(buf)
    dWriteF(['tm_ReadBINFile() ok\n'],0)
    RETURN OK_FICHIER
ENDPROC
PROC tm_RemMainWindow() /*"tm_RemMainWindow()"*/
    dWriteF(['tm_RemMainWindow()\n'],0)
    IF execw_visual THEN FreeVisualInfo(execw_visual)
    IF execw_window THEN CloseWindow(execw_window)
    IF execw_glist THEN FreeGadgets(execw_glist)
    IF execw_screen THEN UnlockPubScreen(execw_screen,NIL)
ENDPROC
PROC tm_OpenMainWindow() HANDLE /*"tm_OpenMainWindow()"*/
    IF (execw_window:=OpenW(4,12,634,210,$278,$100E,title_req,NIL,1,execw_glist))=NIL THEN Raise(ER_WINDOW)
    DrawBevelBoxA(execw_window.rport,9,181,335,25,[GT_VISUALINFO,execw_visual,TAG_DONE,0])
    DrawBevelBoxA(execw_window.rport,352,13,269,62,[GT_VISUALINFO,execw_visual,TAG_DONE,0])
    DrawBevelBoxA(execw_window.rport,352,110,269,96,[GT_VISUALINFO,execw_visual,TAG_DONE,0])
    DrawBevelBoxA(execw_window.rport,9,13,335,166,[GT_VISUALINFO,execw_visual,TAG_DONE,0])
    RefreshGList(g_name,execw_window,NIL,-1)
    Gt_SetGadgetAttrsA(g_list,execw_window,NIL,[GTLV_SHOWSELECTED,TRUE,GTLV_TOP,0,GTLV_SELECTED,0,GTLV_LABELS,p_EmptyList(list_appicon),0])
    IF p_EmptyList(list_appicon)=-1 THEN tm_RebuildGadgets(-1) ELSE tm_RebuildGadgets(0)
    Gt_RefreshWindow(execw_window,NIL)
    Raise(ER_NONE)
EXCEPT
    dWriteF(['tm_OpenMainWindow() \d\n'],[exception])
    RETURN exception
ENDPROC
PROC tm_CloseWindow(wnd:PTR TO window) /*"tm_CloseWindow(wnd:PTR TO window)"*/
    DEF mes:PTR TO intuimessage
    Forbid()
    WHILE mes:=Gt_GetIMsg(wnd.userport) DO Gt_ReplyIMsg(mes)
    IF wnd THEN CloseWindow(wnd)
    wnd:=NIL
    Permit()
    dWriteF(['tm_CloseWindow() \d\n'],[wnd])
    RETURN wnd
ENDPROC
PROC tm_BuildTMObject(list:PTR TO lh) HANDLE /*"tm_BuildTMObject(list:PTR TO lh)"*/
    DEF node:PTR TO ln
    DEF mappic:PTR TO appiconnode
    mappic:=list.head
    WHILE mappic
        node:=mappic
        IF node.succ<>0
            IF (CreateTMObjectTagList(tm_h,node.name,TMOBJTYPE_EXEC,
                                  [TMOP_EXECTYPE,mappic.exectype,
                                   TMOP_COMMAND,mappic.command,
                                   TMOP_HOTKEY,mappic.hotkey,
                                   TMOP_STACK,mappic.stack,
                                   TMOP_PRIORITY,mappic.priority,
                                   TMOP_DELAY,mappic.delay,
                                   TMOP_CURRENTDIR,mappic.currentdir,
                                   TMOP_PATH,mappic.path,
                                   TMOP_OUTPUT,mappic.output,
                                   TMOP_PUBSCREEN,mappic.pubscreen,
                                   TMOP_ARGUMENTS,mappic.arguments,
                                   TMOP_TOFRONT,mappic.tofront,TAG_DONE,0]))=NIL THEN Raise(ER_EXECOBJ)
            IF (CreateTMObjectTagList(tm_h,node.name,TMOBJTYPE_IMAGE,
                                  [TMOP_FILE,mappic.file,
                                   TAG_DONE,0]))=NIL THEN Raise(ER_IMAGEOBJ)
            IF (CreateTMObjectTagList(tm_h,node.name,TMOBJTYPE_ICON,
                                            [TMOP_EXEC,node.name,
                                             TMOP_IMAGE,node.name,
                                             TMOP_SOUND,NIL,
                                             TMOP_LEFTEDGE,mappic.posx,
                                             TMOP_TOPEDGE,mappic.posy,
                                             TMOP_SHOWNAME,mappic.showname,
                                             TAG_DONE,0]))=NIL THEN Raise(ER_ICONOBJ)
        ENDIF
        mappic:=node.succ
    ENDWHILE
    Raise(ER_NONE)
EXCEPT
    IF exception<>ER_NONE
        SELECT exception
            CASE ER_EXECOBJ;   tm_Request('Erreur de création : \s (Objet Exec) .','_Ok',[node.name])
            CASE ER_IMAGEOBJ;  tm_Request('Erreur de création : \s (Objet Image).','_Ok',[node.name])
            CASE ER_ICONOBJ;   tm_Request('Erreur de création : \s (objet Icon).','_Ok',[node.name])
        ENDSELECT
    ENDIF
    dWriteF(['tm_BuidTMObject() \d\n'],[exception])
    RETURN exception
ENDPROC
PROC tm_RebuildGadgets(numnode) /*"tm_RebuildGadgets(numnode)"*/
    DEF mya:PTR TO appiconnode
    DEF node:PTR TO ln
    DEF s_stack[20]:STRING
    DEF s_pri[20]:STRING
    DEF s_delay[20]:STRING
    DEF s_posx[20]:STRING
    DEF s_posy[20]:STRING
    IF numnode<>-1
        mya:=p_GetAdrNode(list_appicon,numnode)
        node:=mya
        /* NAME */
        Gt_SetGadgetAttrsA(g_name,execw_window,NIL,[GA_DISABLED,FALSE,GTST_STRING,node.name,TAG_DONE,0])
        /* EXECTYPE */
        Gt_SetGadgetAttrsA(g_exectype,execw_window,NIL,[GA_DISABLED,FALSE,GTCY_ACTIVE,mya.exectype,TAG_DONE,0])
        /* COMMAND */
        Gt_SetGadgetAttrsA(g_command,execw_window,NIL,[GA_DISABLED,FALSE,GTST_STRING,mya.command,TAG_DONE,0])
        /* HOTKEY */
        Gt_SetGadgetAttrsA(g_hotkey,execw_window,NIL,[GA_DISABLED,FALSE,GTST_STRING,mya.hotkey,TAG_DONE,0])
        /* STACK  */
        StringF(s_stack,'\d',mya.stack)
        Gt_SetGadgetAttrsA(g_stack,execw_window,NIL,[GA_DISABLED,FALSE,GTST_STRING,s_stack,TAG_DONE,0])
        /* PRI */
        StringF(s_pri,'\d',mya.priority)
        Gt_SetGadgetAttrsA(g_priority,execw_window,NIL,[GA_DISABLED,FALSE,GTST_STRING,s_pri,TAG_DONE,0])
        /* DELAY */
        StringF(s_delay,'\d',mya.delay)
        Gt_SetGadgetAttrsA(g_delay,execw_window,NIL,[GA_DISABLED,FALSE,GTST_STRING,s_delay,TAG_DONE,0])
        /* CURRENTDIR */
        Gt_SetGadgetAttrsA(g_currentdir,execw_window,NIL,[GA_DISABLED,FALSE,GTST_STRING,mya.currentdir,TAG_DONE,0])
        /* PATH */
        Gt_SetGadgetAttrsA(g_path,execw_window,NIL,[GA_DISABLED,FALSE,GTST_STRING,mya.path,TAG_DONE,0])
        /* OUTPUT */
        Gt_SetGadgetAttrsA(g_output,execw_window,NIL,[GA_DISABLED,FALSE,GTST_STRING,mya.output,TAG_DONE,0])
        /* PUBSCREEN */
        Gt_SetGadgetAttrsA(g_pubscreen,execw_window,NIL,[GA_DISABLED,FALSE,GTST_STRING,mya.pubscreen,TAG_DONE,0])
        /* ARGUMENTS */
        Gt_SetGadgetAttrsA(g_arguments,execw_window,NIL,[GA_DISABLED,FALSE,GTCB_CHECKED,mya.arguments,TAG_DONE,0])
        /* TOFRONT */
        Gt_SetGadgetAttrsA(g_tofront,execw_window,NIL,[GA_DISABLED,FALSE,GTCB_CHECKED,mya.tofront,TAG_DONE,0])
        /* FILE */
        Gt_SetGadgetAttrsA(g_file,execw_window,NIL,[GA_DISABLED,FALSE,GTST_STRING,mya.file,TAG_DONE,0])
        /* GETCOMMAND */
        Gt_SetGadgetAttrsA(g_getcommand,execw_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        /* GETCURRENTDIR */
        Gt_SetGadgetAttrsA(g_getcurrentdir,execw_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        /* GETPATH */
        Gt_SetGadgetAttrsA(g_getpath,execw_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        /* GETOUTPUT */
        Gt_SetGadgetAttrsA(g_getoutput,execw_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        /* GETPUBSCREEN */
        Gt_SetGadgetAttrsA(g_getpubscreen,execw_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        /* GETFILE */
        Gt_SetGadgetAttrsA(g_getfile,execw_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        /* POSX */
        StringF(s_posx,'\d',mya.posx)
        Gt_SetGadgetAttrsA(g_posx,execw_window,NIL,[GA_DISABLED,FALSE,GTST_STRING,s_posx,TAG_DONE,0])
        /* POSY */
        StringF(s_posy,'\d',mya.posy)
        Gt_SetGadgetAttrsA(g_posy,execw_window,NIL,[GA_DISABLED,FALSE,GTST_STRING,s_posy,TAG_DONE,0])
        /* SHOWNAME */
        Gt_SetGadgetAttrsA(g_showname,execw_window,NIL,[GA_DISABLED,FALSE,GTCB_CHECKED,mya.showname,TAG_DONE,0])
        /* POSITION */
        Gt_SetGadgetAttrsA(g_position,execw_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        /* REM */
        Gt_SetGadgetAttrsA(g_rem,execw_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        /* SAVE */
        Gt_SetGadgetAttrsA(g_save,execw_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        /* SAVEAS */
        Gt_SetGadgetAttrsA(g_saveas,execw_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        /* TESTER */
        Gt_SetGadgetAttrsA(g_test,execw_window,NIL,[GA_DISABLED,FALSE,TAG_DONE,0])
        /* LISTVIEW */
        Gt_SetGadgetAttrsA(g_list,execw_window,NIL,[GA_DISABLED,FALSE,GTLV_SHOWSELECTED,TRUE,GTLV_TOP,numnode,GTLV_SELECTED,numnode,GTLV_LABELS,p_EmptyList(list_appicon),0])
    ELSEIF numnode=-1
        Gt_SetGadgetAttrsA(g_name,execw_window,NIL,[GA_DISABLED,TRUE,GTST_STRING,'',TAG_DONE,0])
        /* EXECTYPE */
        Gt_SetGadgetAttrsA(g_exectype,execw_window,NIL,[GA_DISABLED,TRUE,GTCY_ACTIVE,0,TAG_DONE,0])
        /* COMMAND */
        Gt_SetGadgetAttrsA(g_command,execw_window,NIL,[GA_DISABLED,TRUE,GTST_STRING,'',TAG_DONE,0])
        /* HOTKEY */
        Gt_SetGadgetAttrsA(g_hotkey,execw_window,NIL,[GA_DISABLED,TRUE,GTST_STRING,'',TAG_DONE,0])
        /* STACK  */
        StringF(s_stack,'\d',mya.stack)
        Gt_SetGadgetAttrsA(g_stack,execw_window,NIL,[GA_DISABLED,TRUE,GTST_STRING,'',TAG_DONE,0])
        /* PRI */
        StringF(s_pri,'\d',mya.priority)
        Gt_SetGadgetAttrsA(g_priority,execw_window,NIL,[GA_DISABLED,TRUE,GTST_STRING,'',TAG_DONE,0])
        /* DELAY */
        StringF(s_delay,'\d',mya.delay)
        Gt_SetGadgetAttrsA(g_delay,execw_window,NIL,[GA_DISABLED,TRUE,GTST_STRING,'',TAG_DONE,0])
        /* CURRENTDIR */
        Gt_SetGadgetAttrsA(g_currentdir,execw_window,NIL,[GA_DISABLED,TRUE,GTST_STRING,'',TAG_DONE,0])
        /* PATH */
        Gt_SetGadgetAttrsA(g_path,execw_window,NIL,[GA_DISABLED,TRUE,GTST_STRING,'',TAG_DONE,0])
        /* OUTPUT */
        Gt_SetGadgetAttrsA(g_output,execw_window,NIL,[GA_DISABLED,TRUE,GTST_STRING,'',TAG_DONE,0])
        /* PUBSCREEN */
        Gt_SetGadgetAttrsA(g_pubscreen,execw_window,NIL,[GA_DISABLED,TRUE,GTST_STRING,'',TAG_DONE,0])
        /* ARGUMENTS */
        Gt_SetGadgetAttrsA(g_arguments,execw_window,NIL,[GA_DISABLED,TRUE,GTCB_CHECKED,0,TAG_DONE,0])
        /* TOFRONT */
        Gt_SetGadgetAttrsA(g_tofront,execw_window,NIL,[GA_DISABLED,TRUE,GTCB_CHECKED,0,TAG_DONE,0])
        /* FILE */
        Gt_SetGadgetAttrsA(g_file,execw_window,NIL,[GA_DISABLED,TRUE,GTST_STRING,'',TAG_DONE,0])
        /* POSX */
        StringF(s_posx,'\d',mya.posx)
        Gt_SetGadgetAttrsA(g_posx,execw_window,NIL,[GA_DISABLED,TRUE,GTST_STRING,'',TAG_DONE,0])
        /* POSY */
        StringF(s_posy,'\d',mya.posy)
        Gt_SetGadgetAttrsA(g_posy,execw_window,NIL,[GA_DISABLED,TRUE,GTST_STRING,'',TAG_DONE,0])
        /* SHOWNAME */
        Gt_SetGadgetAttrsA(g_showname,execw_window,NIL,[GA_DISABLED,TRUE,GTCB_CHECKED,0,TAG_DONE,0])
        /* GETCOMMAND */
        Gt_SetGadgetAttrsA(g_getcommand,execw_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        /* GETCURRENTDIR */
        Gt_SetGadgetAttrsA(g_getcurrentdir,execw_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        /* GETPATH */
        Gt_SetGadgetAttrsA(g_getpath,execw_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        /* GETOUTPUT */
        Gt_SetGadgetAttrsA(g_getoutput,execw_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        /* GETPUBSCREEN */
        Gt_SetGadgetAttrsA(g_getpubscreen,execw_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        /* GETFILE */
        Gt_SetGadgetAttrsA(g_getfile,execw_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        /* POSITION */
        Gt_SetGadgetAttrsA(g_position,execw_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        /* REM */
        Gt_SetGadgetAttrsA(g_rem,execw_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        /* SAVE */
        Gt_SetGadgetAttrsA(g_save,execw_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        /* SAVEAS */
        Gt_SetGadgetAttrsA(g_saveas,execw_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        /* TESTER */
        Gt_SetGadgetAttrsA(g_test,execw_window,NIL,[GA_DISABLED,TRUE,TAG_DONE,0])
        /* LISTVIEW */
        Gt_SetGadgetAttrsA(g_list,execw_window,NIL,[GTLV_SHOWSELECTED,FALSE,GA_DISABLED,TRUE,GTLV_LABELS,list_empty,0])
    ENDIF
    dWriteF(['tm_RebuildGadgets() \d\n'],[numnode])
ENDPROC
PROC tm_FileRequester(titre,flags) /*"tm_FileRequester(titre,flags)"*/
    DEF reqfile:PTR TO rtfilerequester
    DEF buffer[120]:STRING
    DEF ret[256]:STRING
    IF reqfile:=RtAllocRequestA(RT_FILEREQ,NIL)
        buffer[0]:=0
        IF RtFileRequestA(reqfile,buffer,titre,flags)
            AddPart(reqfile.dir,'',256)
            StringF(ret,'\s\s',reqfile.dir,buffer)
        ELSE
            ret:=FALSE
        ENDIF
        IF reqfile THEN RtFreeRequest(reqfile)
    ELSE
        ret:=FALSE
    ENDIF
    dWriteF(['tm_FileRequester() \d\n'],[ret])
    RETURN ret
ENDPROC
PROC tm_LookMessage() /*"tm_LookMessage()"*/
    DEF return_sig
    DEF wndport:PTR TO mp
    DEF ret_close=FALSE
    IF execw_window<>NIL THEN wndport:=execw_window.userport ELSE wndport:=NIL
    dWriteF(['tm_LookMessage() \h \h\n'],[execw_window,wndport])
    return_sig:=Wait(Shl(1,prgport.sigbit) OR Shl(1,wndport.sigbit) OR $F000)
    IF (return_sig AND Shl(1,prgport.sigbit))
        IF execw_window=0 THEN tm_OpenMainWindow()
    ELSEIF (return_sig AND Shl(1,wndport.sigbit))
        ret_close:=tm_LookWinMessage()
        IF ret_close THEN execw_window:=tm_CloseWindow(execw_window)
    ELSEIF (return_sig AND $F000)
        reelquit:=TRUE
    ENDIF
ENDPROC
PROC tm_LookWinMessage() /*"tm_LookWinMessage()"*/
    DEF execw_mes:PTR TO intuimessage
    DEF execw_g:PTR TO gadget
    DEF execw_gstr:PTR TO stringinfo
    DEF c_ic:PTR TO appiconnode
    DEF c_node:PTR TO ln
    DEF code
    DEF piv_str[256]:STRING
    DEF req_str[256]:STRING
    DEF l_r=FALSE
    DEF erreur
    DEF execw_type=0,execw_infos /*,execw_menu*/
    DEF pivcurnode
    dWriteF(['tm_LookWinMessage()\n'],0)
    IF execw_mes:=Gt_GetIMsg(execw_window.userport)
        execw_type:=execw_mes.class
        IF execw_type=IDCMP_MENUPICK
            execw_infos:=execw_mes.code
            SELECT execw_infos
                CASE $F800
            ENDSELECT
        ELSEIF (execw_type=IDCMP_GADGETDOWN) OR (execw_type=IDCMP_GADGETUP)
            execw_g:=execw_mes.iaddress
            execw_infos:=execw_g.gadgetid
            c_ic:=p_GetAdrNode(list_appicon,currentnode)
            c_node:=c_ic
            code:=execw_mes.code
            SELECT execw_infos
                CASE GAD_NAME
                    Gt_SetGadgetAttrsA(g_list,execw_window,NIL,[GTLV_SHOWSELECTED,TRUE,GTLV_TOP,0,GTLV_SELECTED,0,GTLV_LABELS,-1,0])
                    execw_gstr:=execw_g.specialinfo
                    StringF(piv_str,'\s',execw_gstr.buffer)
                    IF c_node.name THEN DisposeLink(TrimStr(c_node.name))
                    c_node.name:=String(EstrLen(piv_str))
                    StrCopy(c_node.name,piv_str,ALL)
                    Gt_SetGadgetAttrsA(g_list,execw_window,NIL,[GTLV_SHOWSELECTED,TRUE,GTLV_TOP,currentnode,GTLV_SELECTED,currentnode,GTLV_LABELS,p_EmptyList(list_appicon),0])
                CASE GAD_EXECTYPE
                    c_ic.exectype:=code
                CASE GAD_GETCOMMAND
                    IF req_str:=tm_FileRequester('Get Command',[RT_LOCKWINDOW,TRUE,RT_WINDOW,execw_window,TAG_DONE,0])
                        execw_gstr:=execw_g.specialinfo
                        StringF(piv_str,'\s',req_str)
                        IF c_ic.command THEN DisposeLink(TrimStr(c_ic.command))
                        c_ic.command:=String(EstrLen(piv_str))
                        StrCopy(c_ic.command,piv_str,ALL)
                        Gt_SetGadgetAttrsA(g_command,execw_window,NIL,[GTST_STRING,c_ic.command,TAG_DONE,0])
                    ENDIF
                CASE GAD_COMMAND
                    execw_gstr:=execw_g.specialinfo
                    StringF(piv_str,'\s',execw_gstr.buffer)
                    IF c_ic.command THEN DisposeLink(TrimStr(c_ic.command))
                    c_ic.command:=String(EstrLen(piv_str))
                    StrCopy(c_ic.command,piv_str,ALL)
                CASE GAD_HOTKEY
                    execw_gstr:=execw_g.specialinfo
                    StringF(piv_str,'\s',execw_gstr.buffer)
                    IF c_ic.hotkey THEN DisposeLink(TrimStr(c_ic.hotkey))
                    c_ic.hotkey:=String(EstrLen(piv_str))
                    StrCopy(c_ic.hotkey,piv_str,ALL)
                CASE GAD_STACK
                    execw_gstr:=execw_g.specialinfo
                    StringF(piv_str,'\s',execw_gstr.buffer)
                    c_ic.stack:=Val(piv_str,NIL)
                CASE GAD_PRIORITY
                    execw_gstr:=execw_g.specialinfo
                    StringF(piv_str,'\s',execw_gstr.buffer)
                    c_ic.priority:=Val(piv_str,NIL)
                CASE GAD_DELAY
                    execw_gstr:=execw_g.specialinfo
                    StringF(piv_str,'\s',execw_gstr.buffer)
                    c_ic.delay:=Val(piv_str,NIL)
                CASE GAD_GETCURRENTDIR
                    IF req_str:=tm_FileRequester('Get CurrentDir',[RTFI_FLAGS,FREQF_NOFILES,RT_LOCKWINDOW,TRUE,RT_WINDOW,execw_window,TAG_DONE,0])
                        execw_gstr:=execw_g.specialinfo
                        StringF(piv_str,'\s',req_str)
                        IF c_ic.currentdir THEN DisposeLink(TrimStr(c_ic.currentdir))
                        c_ic.currentdir:=String(EstrLen(piv_str))
                        StrCopy(c_ic.currentdir,piv_str,ALL)
                        Gt_SetGadgetAttrsA(g_currentdir,execw_window,NIL,[GTST_STRING,c_ic.currentdir,TAG_DONE,0])
                    ENDIF
                CASE GAD_CURRENTDIR
                    execw_gstr:=execw_g.specialinfo
                    StringF(piv_str,'\s',execw_gstr.buffer)
                    IF c_ic.currentdir THEN DisposeLink(TrimStr(c_ic.currentdir))
                    c_ic.currentdir:=String(EstrLen(piv_str))
                    StrCopy(c_ic.currentdir,piv_str,ALL)
                CASE GAD_GETPATH
                    IF req_str:=tm_FileRequester('Get Path',[RTFI_FLAGS,FREQF_NOFILES,RT_LOCKWINDOW,TRUE,RT_WINDOW,execw_window,TAG_DONE,0])
                        execw_gstr:=execw_g.specialinfo
                        StringF(piv_str,'\s',req_str)
                        IF c_ic.path THEN DisposeLink(TrimStr(c_ic.path))
                        c_ic.path:=String(EstrLen(piv_str))
                        StrCopy(c_ic.path,piv_str,ALL)
                        Gt_SetGadgetAttrsA(g_path,execw_window,NIL,[GTST_STRING,c_ic.path,TAG_DONE,0])
                    ENDIF
                CASE GA_PATH
                    execw_gstr:=execw_g.specialinfo
                    StringF(piv_str,'\s',execw_gstr.buffer)
                    IF c_ic.path THEN DisposeLink(TrimStr(c_ic.path))
                    c_ic.path:=String(EstrLen(piv_str))
                    StrCopy(c_ic.path,piv_str,ALL)
                CASE GAD_GETOUTPUT
                    IF req_str:=tm_FileRequester('Get OutPut',[RTFI_FLAGS,FREQF_SAVE,RT_LOCKWINDOW,TRUE,RT_WINDOW,execw_window,TAG_DONE,0])
                        execw_gstr:=execw_g.specialinfo
                        StringF(piv_str,'\s',req_str)
                        IF c_ic.output THEN DisposeLink(TrimStr(c_ic.output))
                        c_ic.output:=String(EstrLen(piv_str))
                        StrCopy(c_ic.output,piv_str,ALL)
                        Gt_SetGadgetAttrsA(g_output,execw_window,NIL,[GTST_STRING,c_ic.output,TAG_DONE,0])
                    ENDIF
                CASE GAD_OUTPUT
                    execw_gstr:=execw_g.specialinfo
                    StringF(piv_str,'\s',execw_gstr.buffer)
                    IF c_ic.output THEN DisposeLink(TrimStr(c_ic.output))
                    c_ic.output:=String(EstrLen(piv_str))
                    StrCopy(c_ic.output,piv_str,ALL)
                CASE GAD_GETPUBSCREEN
                CASE GAD_PUBSCREEN
                    execw_gstr:=execw_g.specialinfo
                    StringF(piv_str,'\s',execw_gstr.buffer)
                    IF c_ic.pubscreen THEN DisposeLink(TrimStr(c_ic.pubscreen))
                    c_ic.pubscreen:=String(EstrLen(piv_str))
                    StrCopy(c_ic.pubscreen,piv_str,ALL)
                CASE GAD_ARGUMENTS
                    IF execw_mes.code=0 THEN c_ic.arguments:=FALSE ELSE c_ic.arguments:=TRUE
                CASE GAD_TOFRONT
                    IF execw_mes.code=0 THEN c_ic.tofront:=FALSE ELSE c_ic.tofront:=TRUE
                CASE GAD_ADD
                    Gt_SetGadgetAttrsA(g_list,execw_window,NIL,[GTLV_SHOWSELECTED,TRUE,GTLV_TOP,0,GTLV_SELECTED,0,GTLV_LABELS,-1,0])
                    currentnode:=tm_AddAppIconNode(list_appicon)
                    Gt_SetGadgetAttrsA(g_list,execw_window,NIL,[GTLV_SHOWSELECTED,TRUE,GTLV_TOP,currentnode,GTLV_SELECTED,currentnode,GTLV_LABELS,p_EmptyList(list_appicon),0])
                    tm_RebuildGadgets(currentnode)
                CASE GAD_REM
                    Gt_SetGadgetAttrsA(g_list,execw_window,NIL,[GTLV_SHOWSELECTED,TRUE,GTLV_TOP,0,GTLV_SELECTED,0,GTLV_LABELS,-1,0])
                    pivcurnode:=currentnode
                    currentnode:=tm_RemAppIconNode(list_appicon,pivcurnode)
                    Gt_SetGadgetAttrsA(g_list,execw_window,NIL,[GTLV_SHOWSELECTED,TRUE,GTLV_TOP,currentnode,GTLV_SELECTED,currentnode,GTLV_LABELS,p_EmptyList(list_appicon),0])
                    IF p_EmptyList(list_appicon)=-1 THEN tm_RebuildGadgets(-1) ELSE tm_RebuildGadgets(currentnode)
                CASE GAD_FILE
                    execw_gstr:=execw_g.specialinfo
                    StringF(piv_str,'\s',execw_gstr.buffer)
                    IF c_ic.file THEN DisposeLink(TrimStr(c_ic.file))
                    c_ic.file:=String(EstrLen(piv_str))
                    StrCopy(c_ic.file,piv_str,ALL)
                CASE GAD_GETFILE
                    IF req_str:=tm_FileRequester('Get Image',[RTFI_FLAGS,FREQF_PATGAD,RT_LOCKWINDOW,TRUE,RT_WINDOW,execw_window,TAG_DONE,0])
                        execw_gstr:=execw_g.specialinfo
                        StringF(piv_str,'\s',req_str)
                        IF c_ic.file THEN DisposeLink(TrimStr(c_ic.file))
                        c_ic.file:=String(EstrLen(piv_str))
                        StrCopy(c_ic.file,piv_str,ALL)
                        Gt_SetGadgetAttrsA(g_file,execw_window,NIL,[GTST_STRING,c_ic.file,TAG_DONE,0])
                    ENDIF
                CASE GAD_POSITION
                    IF execw_mes.code=1
                        IF (winpos:=OpenW(c_ic.posx,c_ic.posy+execw_screen.barheight,100,10,$100,$1002,'Move',execw_screen,1,NIL))=NIL
                            winpos:=OpenW(c_ic.posx,c_ic.posy+execw_screen.barheight,100,10,$100,$1002,'Move',execw_screen,1,NIL)
                        ENDIF
                    ELSEIF execw_mes.code=0
                        c_ic.posy:=winpos.topedge-execw_screen.barheight
                        c_ic.posx:=winpos.leftedge
                        winpos:=tm_CloseWindow(winpos)
                        tm_RebuildGadgets(currentnode)
                    ENDIF
                CASE GAD_POSX
                    execw_gstr:=execw_g.specialinfo
                    StringF(piv_str,'\s',execw_gstr.buffer)
                    c_ic.posx:=Val(piv_str,NIL)
                CASE GAD_POSY
                    execw_gstr:=execw_g.specialinfo
                    StringF(piv_str,'\s',execw_gstr.buffer)
                    c_ic.posy:=Val(piv_str,NIL)
                CASE GAD_SHOWNAME
                    IF execw_mes.code=0 THEN c_ic.showname:=FALSE ELSE c_ic.showname:=TRUE
                CASE GAD_SAVE
                    tm_SaveBINFile(GAD_SAVE)
                CASE GAD_SAVEAS
                    tm_SaveBINFile(GAD_SAVEAS)
                CASE GAD_USE
                    IF req_str:=tm_FileRequester('Load New Config',[RT_LOCKWINDOW,TRUE,RT_WINDOW,execw_window,TAG_DONE,0])
                        Gt_SetGadgetAttrsA(g_list,execw_window,NIL,[GTLV_SHOWSELECTED,TRUE,GTLV_TOP,0,GTLV_SELECTED,0,GTLV_LABELS,-1,0])
                        StringF(piv_str,'\s',req_str)
                        IF tm_GoodFormat(piv_str)
                            tm_CleanAppIconList(list_appicon,LIST_CLEAN)
                            erreur:=tm_ReadBINFile(piv_str)
                            IF erreur=OK_FICHIER
                                IF tm_h THEN FreeTMHandle(tm_h)
                                IF tm_h:=AllocTMHandle()
                                    tm_BuildTMObject(list_appicon)
                                ENDIF
                            ENDIF
                            Gt_SetGadgetAttrsA(g_list,execw_window,NIL,[GTLV_SHOWSELECTED,TRUE,GTLV_TOP,currentnode,GTLV_SELECTED,currentnode,GTLV_LABELS,p_EmptyList(list_appicon),0])
                            IF p_EmptyList(list_appicon)=-1 THEN tm_RebuildGadgets(-1) ELSE tm_RebuildGadgets(currentnode)
                            /*
                            IF p_EmptyList(list_appicon)=-1
                                currentnode:=-1
                                tm_RebuildGadgets(-1)
                            ELSE
                                currentnode:=NIL
                                tm_RebuildGadgets(currentnode)
                            ENDIF
                            */
                        ENDIF
                    ENDIF
                CASE GAD_TEST
                    Gt_SetGadgetAttrsA(g_list,execw_window,NIL,[GTLV_SHOWSELECTED,TRUE,GTLV_TOP,0,GTLV_SELECTED,0,GTLV_LABELS,-1,0])
                    IF tm_h THEN FreeTMHandle(tm_h)
                    IF tm_h:=AllocTMHandle()
                        tm_BuildTMObject(list_appicon)
                    ENDIF
                    IF p_EmptyList(list_appicon)=-1 THEN tm_RebuildGadgets(-1) ELSE tm_RebuildGadgets(currentnode)
                    Gt_SetGadgetAttrsA(g_list,execw_window,NIL,[GTLV_SHOWSELECTED,TRUE,GTLV_TOP,currentnode,GTLV_SELECTED,currentnode,GTLV_LABELS,p_EmptyList(list_appicon),0])
                CASE GAD_QUIT
                    reelquit:=TRUE
                CASE 31
                    currentnode:=execw_mes.code
                    tm_RebuildGadgets(currentnode)
            ENDSELECT
        ELSEIF execw_type=IDCMP_CLOSEWINDOW
            l_r:=TRUE
        ENDIF
        Gt_ReplyIMsg(execw_mes)
    ENDIF
    RETURN l_r
ENDPROC
PROC tm_SaveBINFile(where) /*"tm_SaveBINFile(where)"*/
    DEF piv_str[256]:STRING
    DEF destin[256]:STRING
    DEF d_h
    DEF node:PTR TO ln
    DEF mappic:PTR TO appiconnode
    SELECT where
        CASE GAD_TEST
            StrCopy(destin,'Env:TMAppIc.Prefs',ALL)
        CASE GAD_SAVE
            StrCopy(destin,'Envarc:TMAppIc.Prefs',ALL)
        CASE GAD_SAVEAS
            IF piv_str:=tm_FileRequester('Save Configuration',NIL)
                StrCopy(destin,piv_str,ALL)
            ELSE
                RETURN FALSE
            ENDIF
    ENDSELECT
    IF d_h:=Open(destin,1006)
        Write(d_h,[ID_TMAP]:LONG,4)
        mappic:=list_appicon.head
        WHILE mappic
            node:=mappic
            IF node.succ
                Write(d_h,[ID_EXEC]:LONG,4)
                Write(d_h,node.name,EstrLen(node.name))
                Out(d_h,0)
                Write(d_h,[ID_MODE]:LONG,4)
                Write(d_h,[mappic.exectype]:INT,2)
                Write(d_h,[ID_COMM]:LONG,4)
                Write(d_h,mappic.command,EstrLen(mappic.command))
                Out(d_h,0)
                Write(d_h,[ID_HKEY]:LONG,4)
                Write(d_h,mappic.hotkey,EstrLen(mappic.hotkey))
                Out(d_h,0)
                Write(d_h,[ID_STAK]:LONG,4)
                Write(d_h,[mappic.stack]:LONG,4)
                Write(d_h,[ID_PRIO]:LONG,4)
                Write(d_h,[mappic.priority]:INT,2)
                Write(d_h,[ID_DELA]:LONG,4)
                Write(d_h,[mappic.delay]:INT,2)
                Write(d_h,[ID_CDIR]:LONG,4)
                Write(d_h,mappic.currentdir,EstrLen(mappic.currentdir))
                Out(d_h,0)
                Write(d_h,[ID_PATH]:LONG,4)
                Write(d_h,mappic.path,EstrLen(mappic.path))
                Out(d_h,0)
                Write(d_h,[ID_OUTP]:LONG,4)
                Write(d_h,mappic.output,EstrLen(mappic.output))
                Out(d_h,0)
                Write(d_h,[ID_PSCR]:LONG,4)
                Write(d_h,mappic.pubscreen,EstrLen(mappic.pubscreen))
                Out(d_h,0)
                Write(d_h,[ID_ARGS]:LONG,4)
                Write(d_h,[mappic.arguments]:CHAR,1)
                Write(d_h,[ID_TOFR]:LONG,4)
                Write(d_h,[mappic.tofront]:CHAR,1)
                Write(d_h,[ID_FILE]:LONG,4)
                Write(d_h,mappic.file,EstrLen(mappic.file))
                Out(d_h,0)
                Write(d_h,[ID_POSX]:LONG,4)
                Write(d_h,[mappic.posx]:INT,2)
                Write(d_h,[ID_POSY]:LONG,4)
                Write(d_h,[mappic.posy]:INT,2)
                Write(d_h,[ID_SHNA]:LONG,4)
                Write(d_h,[mappic.showname]:CHAR,1)
            ENDIF
            mappic:=node.succ
        ENDWHILE
        Close(d_h)
    ENDIF
    dWriteF(['tm_SaveBINFile() \d\n'],0)
ENDPROC
PROC tm_Request(bodytext,gadgettext,the_arg) /*"tm_Request(bodytext,gadgettext,the_arg)"*/
/********************************************************************************
 * Para         : text (STRING), gadget (STRING), arg PTR TO LONG
 * Return       : FALSE if cancel selected,else TRUE
 * Description  : PopUp a Requester.
 *******************************************************************************/
    DEF ret
    DEF taglist
    IF execw_window
        taglist:=[RT_WINDOW,execw_window,RT_LOCKWINDOW,TRUE,RTEZ_REQTITLE,title_req,RT_UNDERSCORE,"_",0]
    ELSE
        taglist:=[RTEZ_REQTITLE,title_req,RT_UNDERSCORE,"_",0]
    ENDIF
    ret:=RtEZRequestA(bodytext,gadgettext,0,the_arg,taglist)
    RETURN ret
ENDPROC
PROC main() HANDLE /*"main()"*/
    DEF test_main
    tattr:=['topaz.font',8,0,0]:textattr
    p_DoReadHeader({prg_banner})
    IF (test_main:=tm_OpenLibraries())<>ER_NONE THEN Raise(test_main)
    IF (test_main:=tm_InitAPP())<>ER_NONE THEN Raise(test_main)
    test_main:=tm_ReadBINFile(NIL)
    IF test_main=ER_NOFILE THEN Raise(test_main)
    IF (test_main:=tm_BuildTMObject(list_appicon))<>ER_NONE THEN Raise(test_main)
    REPEAT
        tm_LookMessage()
    UNTIL reelquit=TRUE
    Raise(ER_NONE)
EXCEPT
    SELECT exception
        CASE ER_INTUITIONLIB; WriteF('Intuition.library ?')
        CASE ER_GADTOOLSLIB;  WriteF('GadTools.library ?')
        CASE ER_GRAPHICSLIB;  WriteF('Graphics.library ?')
        CASE ER_REQTOOLSLIB;  WriteF('Reqtools.library ?')
        CASE ER_TOOLMANAGERLIB;  WriteF('ToolManager.library ?')
        CASE ER_WB;           tm_Request('Ecran Workbench introuvable','_Ok',NIL)
        CASE ER_VISUAL;       tm_Request('Erreur Visual.','_Ok',NIL)
        CASE ER_CONTEXT;      tm_Request('Erreur Context.','_Ok',NIL)
        CASE ER_MENU;         tm_Request('Erreur Menu.','_Ok',NIL)
        CASE ER_GADGET;       tm_Request('Erreur Gadget.','_Ok',NIL)
        CASE ER_WINDOW;       tm_Request('Erreur Window.','_Ok',NIL)
        CASE ER_TMHANDLE;     tm_Request('Impposible de créer le handle.','_Ok',NIL)
        CASE ER_LIST;         tm_Request('Erreur Mémoire','_Ok',NIL)
        CASE ER_EXECOBJ;      tm_Request('Erreur de création d\aun objet Exec.','_Ok',NIL)
        CASE ER_IMAGEOBJ;     tm_Request('Erreur de création d\aun objet Image.','_Ok',NIL)
        CASE ER_ICONOBJ;      tm_Request('Erreur de création d\aun objet Icon.','_Ok',NIL)
        CASE ER_PORT;         tm_Request('Création du port impossible','_Ok',NIL)
        CASE ER_SIG;          tm_Request('Allocation du signal impossible','_Ok',NIL)
        CASE ER_NOFILE;
        CASE ER_APPITEM;
        DEFAULT;              NOP
    ENDSELECT
    tm_RemAPP()
    tm_CloseLibraries()
ENDPROC
prg_banner:
INCBIN 'TMAppIc.header'


