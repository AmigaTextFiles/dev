/*=========================================================================
 = Peps v0.1 © 1994 NasGûl
 =========================================================================*/

OPT OSVERSION=37

MODULE 'intuition/intuition','gadtools','libraries/gadtools','intuition/gadgetclass','intuition/screens',
       'graphics/text','exec/lists','exec/nodes','exec/ports','eropenlib','utility/tagitem',
       'rexxsyslib','rexx/storage'
MODULE 'dos/dosextens','peps','dos/dostags'
MODULE 'reqtools','libraries/reqtools','graphics/displayinfo'

CONST DEBUG=FALSE   /* for dWriteF() Proc */

CONST FIND_INTERNAL=0, /* for p_FindProcName() Proc */
      FIND_AREXX=1

/* All "programm don't work.." errors */

ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW,
     ER_BADARGS,ER_ONLYCLI,ER_NOFILE,ER_TEMPNOVALID,ER_PORTEXIST,ER_CREATEPORT,
     ER_MEM,ER_RUNED,ER_CONOUT,ER_EXENOVALID,ER_SAMEDIR,ER_OPENSCREEN,ER_SCREENSIG,
     ER_LIST,ER_MENUS,ER_NOMENUFILE

RAISE ER_MEM IF New()=NIL,
      ER_MEM IF String()=NIL

DEF screen:PTR TO screen,       /* like examples/gadtoolsdemo.e */
    visual=NIL,
    tattr:PTR TO textattr,
    menu=NIL,
    reelquit=FALSE,
    offy
/*=======================================
 = pp Definitions
 =======================================*/
DEF pp_window=NIL:PTR TO window            /* Window and gadgets list */
DEF pp_glist=NIL
/*==================*/
/*     Gadgets      */
/*==================*/
CONST GA_G_SOURCE=0                        /* gadgets num */
CONST GA_G_FILELIST=1
CONST GA_G_PROCLIST=2
CONST GA_G_ERRORSLIST=3
/*=============================
 = Gadgets labels of pp
 =============================*/
DEF g_source                              /* gadgets adr */
DEF g_filelist
DEF g_proclist
DEF g_errorslist
/*==========================
 = Arg Definitions
 ==========================*/
DEF esource[100]:STRING        /* the source name */
DEF ecsource[100]:STRING       /* the source file without .e */
DEF ec[100]:STRING             /* ec options (-e by default) */
DEF pubscreenname[100]:STRING  /* pubscreenname for window (Workbench by def) */
DEF menufile[256]:STRING       /* file who content menus */
DEF nomenu=FALSE               /* no menu */
DEF screensig=-1               /* signal for pubscreen */
DEF typescreen=SUPER_KEY       /* type of screen */
DEF screenbydefault=FALSE      /* pubscreen by def */
DEF screenshanghai=FALSE
DEF editorcommand[100]:STRING  /* the name of your text editor (ED <esource> byf def */
DEF tempfile[100]:STRING       /* name of the temp file ( T:PepsMain.e by def) */
DEF b_deletetemp=FALSE         /* delete temp (TRUE/FALSE) ( FALSE by def) */
DEF compilandexit=FALSE        /* Compil and exit */
DEF insertcomment=FALSE        /* InsertComment in PepsMain.e */
DEF prgportname[100]:STRING    /* the name of the Arexx Port (PepsPort by def) */
DEF edarexxportname[100]:STRING    /* Port arexx for Editor */
DEF arexxport:PTR TO mp        /* Arexx Port of Peps */
DEF dummyport:PTR TO mp        /* DummyReplyPort */
DEF execname[256]:STRING       /* Exec Name (the name of the source code without the .e by def) */
DEF myb:PTR TO eubase          /* My base (see Peps.m and Peps.doc) */
DEF myout                      /* handle for ec output */
DEF myconout[256]:STRING       /* window out description */
DEF emptylist:PTR TO lh        /* just a empty list (lh) */
DEF currentfilenode            /* the current filenode (seleted in the ListView gaget (File) */
DEF erscriptname[256]:STRING,arexxer=TRUE
DEF currentdir[256]:STRING     /* the current dir when launch */
PMODULE 'PepsData'
PMODULE 'PepsMenus'
PMODULE 'Pmodules:DWriteF'
PROC p_LookAllMessage() /*"p_LookAllMessage()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Look message on window,arexx port and Ctrl C/D/E/F.
 ==============================================================================*/
    DEF sigreturn
    DEF ppport:PTR TO mp
    IF pp_window THEN ppport:=pp_window.userport ELSE ppport:=NIL
    sigreturn:=Wait(Shl(1,ppport.sigbit) OR
            Shl(1,arexxport.sigbit) OR $F000)
    IF (sigreturn AND Shl(1,ppport.sigbit))
        p_LookppMessage()
    ENDIF
    IF (sigreturn AND Shl(1,arexxport.sigbit))
        p_LookArexxMessage()
    ENDIF
    IF (sigreturn AND $F000)
        reelquit:=TRUE
    ENDIF
ENDPROC
PROC p_LookppMessage() /*"p_LookppMessage()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Look Idcmp message.
 ==============================================================================*/
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF type=0,infos=NIL
   DEF curfile:PTR TO filenode,ret,adr_menu,ms,number
   ms:=pp_window.menustrip
   WHILE (mes:=Gt_GetIMsg(pp_window.userport))
       type:=mes.class
       SELECT type
       CASE IDCMP_MENUPICK
            ret:=mes.code
            IF ret<>$FFFF
                adr_menu:=ItemAddress(ms,ret)
                SELECT ret
                    CASE $F800
                        EasyRequestArgs(0,[20,0,0,'Peps v0.1','Ok'],0,NIL)
                    CASE $F820
                        Execute('Newshell',0,stdout)
                    CASE $F840
                        p_RebuildMenu()
                    CASE $F860
                        reelquit:=TRUE
                    DEFAULT
                        number:=p_ExecuteMenu(ms,adr_menu)
                ENDSELECT
            ENDIF
       CASE IDCMP_REFRESHWINDOW
           p_RenderppWindow()
       CASE IDCMP_CLOSEWINDOW
           reelquit:=TRUE
       CASE IDCMP_GADGETUP
          g:=mes.iaddress
          infos:=g.gadgetid
          SELECT infos
          CASE GA_G_SOURCE
          CASE GA_G_FILELIST
              currentfilenode:=mes.code
              curfile:=p_GetAdrNode(myb.pmodulelist,currentfilenode)
              Gt_SetGadgetAttrsA(g_proclist,pp_window,NIL,[GTLV_LABELS,p_EmptyList(curfile.proclist),TAG_DONE,0])
          CASE GA_G_PROCLIST
          CASE GA_G_ERRORSLIST
          ENDSELECT
       ENDSELECT
       Gt_ReplyIMsg(mes)
   ENDWHILE
   WHILE (mes:=Gt_GetIMsg(pp_window.userport)) DO Gt_ReplyIMsg(mes)
ENDPROC
PROC p_LookArexxMessage() /*"p_LookArexxMessage()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Process arexx Messge.
 ==============================================================================*/
    DEF mess_rexx:PTR TO rexxmsg
    DEF commande:PTR TO LONG
    DEF test
    DEF execcom[256]:STRING,dodel=TRUE
    DEF ret_str[256]:STRING
    dWriteF(['p_LookArexxMessge()\n'],0)
    WHILE (mess_rexx:=GetMsg(arexxport))
    IF IsRexxMsg(mess_rexx)
        commande:=mess_rexx.args
        IF StrCmp(commande[0],'EC',ALL) /* Make compilation */
            WindowToFront(pp_window)
            p_CleanAllList()
            IF (p_ReadSourceFile(esource,TRUE))<>FALSE
                p_RenderppWindow()
                p_WriteFPmoduleList(myb.pmodulelist)
                p_CalculTotalMem(myb.pmodulelist)
                StringF(execcom,'EC \s \s',ec,ecsource)
                IF (test:=p_Execute(execcom))<>0
                    WindowToFront(pp_window)
                    p_ParsingError(myb.pmodulelist,test)
                ELSE
                IF (test:=p_CopyFile(ecsource,execname))=FALSE
                    p_AjouteInfoNode(myb.infolist,'Error Copy Exec.')
                    dodel:=FALSE
                ENDIF
            ENDIF
        ELSE
            p_CleanAllList()
            p_AjouteInfoNode(myb.infolist,'Internal Error.')
        ENDIF
        IF ((b_deletetemp=TRUE) AND (dodel=TRUE))
            DeleteFile(tempfile)
            test:=InStr(tempfile,'.e',0)
            MidStr(execcom,tempfile,0,test)
            DeleteFile(execcom)
            p_AjouteInfoNode(myb.infolist,'Delete TempFile.')
         ENDIF
        ELSEIF StrCmp(commande[0],'QUIT',ALL) /* Quit */
            reelquit:=TRUE
        ELSEIF StrCmp(commande[0],'ECOPT',ALL)
            p_ChangeECOpt()
        ELSEIF StrCmp(commande[0],'FINDPROC',8)
            MidStr(execcom,commande[0],8,ALL)
            execcom:=TrimStr(execcom)
            ret_str:=p_FindProcName(myb.pmodulelist,execcom,FIND_AREXX)
            StringF(execcom,'\s',ret_str)
            mess_rexx.result2:=String(EstrLen(execcom))
            StrCopy(mess_rexx.result2,execcom,ALL)
        ELSEIF StrCmp(commande[0],'NEWSHELL',ALL)
            Execute('NewShell',0,stdout)
        ENDIF
    ENDIF
    ReplyMsg(mess_rexx)
    IF mess_rexx.result2 THEN DisposeLink(mess_rexx.result2)
    ENDWHILE
    WHILE (mess_rexx:=GetMsg(arexxport)) DO ReplyMsg(arexxport)
ENDPROC
PROC p_ChangeECOpt() /*"p_ChangeECOpt()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Call StringRequester to change EC Options.
 ==============================================================================*/
    DEF str_return[256]:STRING
    IF (str_return:=p_GetWithStringReq('Change EC options',ec))<>NIL THEN ec:=str_return
ENDPROC
PROC p_GetWithStringReq(titre,texte) /*"p_GetWithStringReq(titre,texte)"*/
/*===============================================================================
 = Para         : title of the StringRequester,Text in String Gadget.
 = Return       : new string if ok,else NIL.
 = Description  : PopUp a StringRequester (ReqTools.library).
 ==============================================================================*/
    DEF req:PTR TO rtfilerequester
    DEF return_string[256]:STRING
    DEF retour
    return_string:=NIL
    IF req:=RtAllocRequestA(RT_REQINFO,NIL)
    retour:=RtGetStringA(texte,300,titre,NIL,[RT_WINDOW,pp_window,RT_LOCKWINDOW,TRUE,TAG_DONE,0])
    IF retour THEN return_string:=texte
    RtFreeRequest(req)
    ENDIF
    RETURN return_string
ENDPROC return_string
PROC p_ReadSourceFile(s,inglobal) /*"p_ReadSourceFile(s,inglobal)"*/
/*===============================================================================
 = Para         : Source file (main file or pmodule),inglobal always TRUE.
 = Return       : FALSE if error,else TRUE.
 = Description  : Read Source File. (file who not exists are skipped).
 ==============================================================================*/
    DEF len,adr,buf,handle,flen=TRUE,a=0,p=0
    DEF r_str[256]:STRING
    DEF a_str[256]:STRING
    DEF str_line[256]:STRING
    DEF piv_str[256]:STRING
    DEF procstr[256]:STRING,pos,newmod[256]:STRING
    DEF debp,finp
    DEF myfilenode:PTR TO filenode
    DEF myprocnode:PTR TO procnode
    DEF lg=0
    DEF inproc=FALSE
    DEF nocopyproc=FALSE
    StringF(a_str,'Error File:\s',s)
    IF (flen:=FileLength(s))=-1
        p_AjouteInfoNode(myb.infolist,a_str)
        RETURN FALSE
    ELSEIF (buf:=New(flen+1))=NIL
        p_AjouteInfoNode(myb.infolist,a_str)
        RETURN FALSE
    ELSEIF (handle:=Open(s,1005))=NIL
        IF buf THEN Dispose(buf)
        p_AjouteInfoNode(myb.infolist,a_str)
        RETURN FALSE
    ENDIF
    len:=Read(handle,buf,flen)
    Close(handle)
    IF len<1
    IF buf THEN Dispose(buf)
        p_AjouteInfoNode(myb.infolist,a_str)
        RETURN FALSE
    ENDIF
    adr:=buf
    IF FindName(myb.pmodulelist,s)
        StringF(a_str,'File \s Exists.\n',s)
        p_AjouteInfoNode(myb.infolist,a_str)
        IF buf THEN Dispose(buf)
        RETURN FALSE
    ELSE
        myfilenode:=New(SIZEOF filenode)
        myfilenode.deflist:=p_InitList()
        myfilenode.proclist:=p_InitList()
        p_AjouteNode(myb.pmodulelist,s,myfilenode.node)
    ENDIF
    StringF(a_str,'New File :\s',s)
    p_AjouteInfoNode(myb.infolist,a_str)
    FOR a:=0 TO len-1
        IF buf[a]=10
            lg:=a-p
            IF lg<>0
                StrCopy(r_str,adr,lg)
                str_line:=TrimStr(r_str)
                IF StrCmp(str_line,'PROC',4)
                    inglobal:=FALSE
                    inproc:=TRUE
                    debp:=adr-buf
                    pos:=InStr(str_line,'(',0)
                    StrCopy(procstr,str_line,pos+1)
                    IF p_FindProcName(myb.pmodulelist,procstr,FIND_INTERNAL)
                        StringF(a_str,'Proc \s Exists.\n',procstr)
                        p_AjouteInfoNode(myb.infolist,a_str)
                        nocopyproc:=TRUE
                        JUMP suite
                    ELSE
                        myprocnode:=New(SIZEOF procnode)
                        p_AjouteNode(myfilenode.proclist,procstr,myprocnode.node)
                        p_AjouteNode(myb.proclist,procstr,0)
                        StringF(a_str,'New Proc :\s',procstr)
                        p_AjouteInfoNode(myb.infolist,a_str)
                       JUMP suite
                    ENDIF
                ELSEIF StrCmp(str_line,'ENDPROC',7)
                    IF nocopyproc=FALSE
                        inglobal:=TRUE
                        inproc:=FALSE
                        finp:=adr-buf
                        myprocnode.length:=finp-debp+EstrLen(str_line)
                        myprocnode.buffer:=New(myprocnode.length)
                        CopyMem(buf+debp,myprocnode.buffer,myprocnode.length)
                        JUMP suite
                    ELSE
                        inglobal:=TRUE
                        inproc:=FALSE
                        JUMP suite
                    ENDIF
                ELSEIF StrCmp(str_line,'PMODULE',7)
                    piv_str:=found_para('PMODULE',str_line,'\a')
                    IF piv_str
                        StringF(newmod,'\s.e',piv_str)
                        p_ReadSourceFile(newmod,TRUE)
                        inglobal:=TRUE
                        inproc:=FALSE
                    ENDIF
                    JUMP suite
                ELSEIF ((inglobal=TRUE) AND (inproc=FALSE))
                    p_AjouteNode(myfilenode.deflist,r_str,0)
                    JUMP suite
                ENDIF
            ENDIF
            suite:
            p:=a+1
            adr:=buf+a+1
        ENDIF
    ENDFOR
    Dispose(buf)
    RETURN TRUE
ENDPROC
PROC found_para(str_para,parse_str,sep) /*"found_para(str_para,parse_str,sep)"*/
/*===============================================================================
 = Para         : the string,the key word (ex: string=PMODULE 'Mod1' keywod=PMODULE).
 = Return       : the parameter if ok,else NIL.
 = Description  : found the paramater of a key word.
 ==============================================================================*/
    DEF p[256]:STRING,pos_dep,pos_fin
    pos_dep:=InStr(parse_str,str_para,0)
    IF pos_dep<>-1
    pos_dep:=InStr(parse_str,sep,pos_dep)
    pos_fin:=InStr(parse_str,sep,pos_dep+1)
    MidStr(p,parse_str,pos_dep+1,(pos_fin-pos_dep)-1)
    RETURN p
    ELSE
    RETURN FALSE
    ENDIF
ENDPROC
PROC p_WriteFPmoduleList(ptr_list:PTR TO lh) /*"p_WriteFPmoduleList(ptr_list:PTR TO lh)"*/
/*===============================================================================
 = Para         : Address of a list (the eubase.pmodulelist).
 = Return       : NONE.
 = Description  : Write the TemFile.
 ==============================================================================*/
    DEF w_fnode:PTR TO ln
    DEF w_pnode:PTR TO ln
    DEF w_filenode:PTR TO filenode
    DEF w_procnode:PTR TO procnode
    DEF pivlist:PTR TO lh
    DEF defnode:PTR TO ln
    DEF h,commentstr[256]:STRING
    IF h:=Open(tempfile,1006)
        w_filenode:=ptr_list.head
        WHILE w_filenode
            w_fnode:=w_filenode
            IF w_fnode.succ<>0
                IF p_EmptyList(w_filenode.deflist)<>-1
                    IF insertcomment=TRUE
                        StringF(commentstr,'/*============================\n'+
                                           ' = Def include From :\s\n'+
                                           ' ============================*/\n',w_fnode.name)
                        Write(h,commentstr,EstrLen(commentstr))
                    ENDIF
                    pivlist:=w_filenode.deflist
                    defnode:=pivlist.head
                    WHILE defnode
                        IF defnode.succ<>0
                            Write(h,defnode.name,EstrLen(defnode.name))
                            Write(h,'\n',1)
                        ENDIF
                        defnode:=defnode.succ
                    ENDWHILE
                ENDIF
            ENDIF
            w_filenode:=w_fnode.succ
        ENDWHILE
        w_filenode:=ptr_list.head
        WHILE w_filenode
            w_fnode:=w_filenode
            IF w_fnode.succ<>0
                IF p_EmptyList(w_filenode.proclist)<>-1
                    IF insertcomment=TRUE
                        StringF(commentstr,'/*============================\n'+
                                           ' = Proc include From :\s\n'+
                                           ' ============================*/\n',w_fnode.name)
                        Write(h,commentstr,EstrLen(commentstr))
                    ENDIF
                    pivlist:=w_filenode.proclist
                    w_procnode:=pivlist.head
                    WHILE w_procnode
                        w_pnode:=w_procnode
                        IF w_pnode.succ<>0
                            Write(h,w_procnode.buffer,w_procnode.length)
                            Write(h,'\n',1)
                            IF CtrlC() THEN JUMP fin
                        ENDIF
                        w_procnode:=w_pnode.succ
                    ENDWHILE
                ENDIF
            ENDIF
            w_filenode:=w_fnode.succ
        ENDWHILE
        fin:
        IF h THEN Close(h)
    ELSE
        p_AjouteInfoNode(myb.infolist,'Save Temp Error.')
    ENDIF
ENDPROC
PROC p_FindProcName(ptr_list:PTR TO lh,pname,mode) /*"p_FindProcName(ptr_list:PTR TO lh,pname,mode)"*/
/*===============================================================================
 = Para     : address of list,name of proc
 = Return   : TRUE if proc is already in list else FALSE.
 = Description  : Find a proc name.
 ==============================================================================*/
    DEF w_fnode:PTR TO ln
    DEF w_filenode:PTR TO filenode
    DEF return_str[256]:STRING
    DEF bufstr[256]:STRING,lock
    w_filenode:=ptr_list.head
    WHILE w_filenode
    w_fnode:=w_filenode
    IF w_fnode.succ<>0
        IF p_EmptyList(w_filenode.proclist)<>-1
            IF FindName(w_filenode.proclist,pname) 
                IF mode=FIND_INTERNAL 
                    RETURN TRUE
                ELSEIF mode=FIND_AREXX
                    IF lock:=Lock(w_fnode.name,-2)
                        NameFromLock(lock,bufstr,256)
                        AddPart(bufstr,'',256)
                        StrAdd(bufstr,w_fnode.name,ALL)
                        UnLock(lock)
                    ENDIF
                    IF (p_LookIfFullName(bufstr))=TRUE
                        StringF(return_str,'\s \s',bufstr,w_fnode.name)
                    ELSE
                        StringF(return_str,'\s\s \s',currentdir,bufstr,w_fnode.name)
                    ENDIF
                    RETURN return_str
                ENDIF
            ENDIF
        ENDIF
    ENDIF
    w_filenode:=w_fnode.succ
    ENDWHILE
    IF mode=FIND_INTERNAL THEN RETURN FALSE ELSE RETURN ''
ENDPROC
PROC p_ParsingError(ptr_list:PTR TO lh,errorline) /*"p_ParsingError(ptr_list:PTR TO lh,errorline)"*/
/*===============================================================================
 = Para         : Address of a list (eubase.pmodulelist),num line error.
 = Return       : NONE
 = Description  : Count line to find the file/proc error.
 ==============================================================================*/
    DEF w_fnode:PTR TO ln
    DEF w_pnode:PTR TO ln
    DEF w_filenode:PTR TO filenode
    DEF w_procnode:PTR TO procnode
    DEF curline=0,numline=0
    DEF pivlist:PTR TO lh
    DEF defnode:PTR TO ln
    DEF debline=0
    DEF strarexx[256]:STRING
    DEF fullname[256]:STRING
    DEF bufstr[256]:STRING
    DEF lock
    w_filenode:=ptr_list.head
    WHILE w_filenode
    w_fnode:=w_filenode
    IF w_fnode.succ<>0
        IF p_EmptyList(w_filenode.deflist)<>-1
        IF insertcomment=TRUE
            curline:=curline+3
        ENDIF
        pivlist:=w_filenode.deflist
        defnode:=pivlist.head
        WHILE defnode
            IF defnode.succ<>0
            IF curline=errorline
                p_AjouteInfoNode(myb.infolist,'Error In Globals Def.')
                IF arexxer=TRUE
                StringF(fullname,'\s',w_fnode.name)
                IF lock:=Lock(fullname,-2)
                    NameFromLock(lock,bufstr,256)
                    AddPart(bufstr,'',256)
                    StrAdd(bufstr,fullname,ALL)
                    dWriteF(['p_ParsingError() Lock ok Full\s ','Name\s\n'],[bufstr,w_fnode.name])
                    UnLock(lock)
                ENDIF
                IF (p_LookIfFullName(fullname))=TRUE
                    StringF(strarexx,'\s \s \s',erscriptname,bufstr,w_fnode.name)
                ELSE
                    StringF(strarexx,'\s \s\s \s',erscriptname,currentdir,bufstr,w_fnode.name)
                ENDIF
                p_SendRexxCommand(strarexx,'REXX',RXCOMM+RXFF_RESULT)
                ENDIF
                JUMP errorfound
            ENDIF
            INC curline
            ENDIF
            defnode:=defnode.succ
        ENDWHILE
        ENDIF
    ENDIF
    w_filenode:=w_fnode.succ
    ENDWHILE
    w_filenode:=ptr_list.head
    WHILE w_filenode
    w_fnode:=w_filenode
    IF w_fnode.succ<>0
        IF p_EmptyList(w_filenode.proclist)<>-1
        IF insertcomment=TRUE
            curline:=curline+3
        ENDIF
        pivlist:=w_filenode.proclist
        w_procnode:=pivlist.head
        WHILE w_procnode
            w_pnode:=w_procnode
            IF w_pnode.succ<>0
            debline:=curline
            numline:=p_CountLine(w_procnode.buffer,w_procnode.length)
            curline:=curline+numline
            IF ((errorline>debline) AND (errorline<curline))
                p_AjouteInfoNode(myb.infolist,'Error In File:')
                p_AjouteInfoNode(myb.infolist,w_fnode.name)
                p_AjouteInfoNode(myb.infolist,'Error In Proc:')
                p_AjouteInfoNode(myb.infolist,w_pnode.name)
                IF compilandexit
                WriteF('Error In File:\s\n',w_fnode.name)
                WriteF('Error In Proc:\s\n',w_pnode.name)
                ENDIF
                IF arexxer=TRUE
                StringF(fullname,'\s',w_fnode.name)
                IF lock:=Lock(fullname,-2)
                    NameFromLock(lock,bufstr,256)
                    AddPart(bufstr,'',256)
                    StrAdd(bufstr,w_fnode.name,ALL)
                    dWriteF(['p_ParsingError() Lock ok Full\s ','Name\s\n'],[bufstr,fullname])
                    UnLock(lock)
                ENDIF
                IF p_LookIfFullName(fullname)
                    StringF(strarexx,'\s \s \s \s',erscriptname,bufstr,w_fnode.name,w_pnode.name)
                ELSE
                    StringF(strarexx,'\s \s\s \s \s',erscriptname,currentdir,bufstr,w_fnode.name,w_pnode.name)
                ENDIF
                p_SendRexxCommand(strarexx,'REXX',RXCOMM+RXFF_RESULT)
                ENDIF
                JUMP errorfound
            ENDIF
            ENDIF
            w_procnode:=w_pnode.succ
        ENDWHILE
        ENDIF
    ENDIF
    w_filenode:=w_fnode.succ
    ENDWHILE
    errorfound:
ENDPROC
PROC p_CountLine(buff,l) /*"p_CountLine(buff,l)"*/
/*===============================================================================
 = Para         : address of buffer (procnode.buffer),length of buffer (procnode.length)
 = Return       : the number of line (PROC=1 and ENDPROC=number of line).
 = Description  : count buffer line.
 ==============================================================================*/
    DEF adr,pos,line=0,longlu=0
    adr:=buff
    REPEAT
    pos:=InStr(adr,'\n',1)
    INC line
    adr:=adr+pos+1
    longlu:=longlu+pos+1
    UNTIL ((pos=-1) OR (longlu=l))
    RETURN line
ENDPROC
PROC p_CalculTotalMem(list:PTR TO lh) /*"p_CalculTotalMem(list:PTR TO lh)"*/
/*===============================================================================
 = Para         : Address of a list (eubase.pmodulelist).
 = Return       : NONE.
 = Description  : count total mem use.
 ==============================================================================*/
    DEF fnode:PTR TO ln
    DEF pnode:PTR TO ln
    DEF mfilenode:PTR TO filenode
    DEF mprocnode:PTR TO procnode
    DEF totalsize=0,pivlist:PTR TO lh
    DEF a_str[256]:STRING
    mfilenode:=list.head
    WHILE mfilenode
    fnode:=mfilenode
    IF fnode.succ<>0
        totalsize:=totalsize+EstrLen(fnode.name)+SIZEOF filenode
        pivlist:=mfilenode.proclist
        mprocnode:=pivlist.head
        IF p_EmptyList(mfilenode.proclist)<>-1
        totalsize:=totalsize+SIZEOF lh
        WHILE mprocnode
            pnode:=mprocnode
            IF pnode.succ<>0
                totalsize:=totalsize+EstrLen(pnode.name)+SIZEOF procnode+mprocnode.length
            ENDIF
            mprocnode:=pnode.succ
        ENDWHILE
        ENDIF
    ENDIF
    mfilenode:=fnode.succ
    ENDWHILE
    StringF(a_str,'»»»» TotalBytes :\d',totalsize)
    p_AjouteInfoNode(myb.infolist,a_str)
ENDPROC
PROC p_Execute(command) /*"p_Execute(command)"*/
/*===============================================================================
 = Para         : the command string.
 = Return       : the returncode.
 = Description  : run a prg.
 ==============================================================================*/
    DEF ret
    ret:=SystemTagList(command,[SYS_OUTPUT,myout,
                SYS_INPUT,Input(),
             NP_STACKSIZE,8000,
             NP_PRIORITY,0,
             0])
    RETURN ret
ENDPROC
PROC p_RunEditor() /*"p_RunEditor()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : the returncode.
 = Description  : Runback the editor.
 ==============================================================================*/
    DEF r
    r:=SystemTagList(editorcommand,[SYS_OUTPUT,myout,SYS_INPUT,NIL,SYS_ASYNCH,TRUE,SYS_USERSHELL,TRUE,NP_STACKSIZE,8000,
               NP_PRIORITY,0,NP_PATH,NIL,NP_CONSOLETASK,NIL,TAG_DONE])
    RETURN r
ENDPROC
PROC p_CopyFile(source,destination) /*"p_CopyFile(source,destination)"*/
/*===============================================================================
 = Para         : source file,destination file
 = Return       : TRUE if ok,else FALSE.
 = Description  : Copy a file.
 ==============================================================================*/

    DEF hs,hd,buf,lo,lt,lf
    DEF ret=FALSE
    IF hs:=Open(source,1005)
    IF (lf:=FileLength(source))<>-1
        IF buf:=New(lf+1)
        IF lo:=Read(hs,buf,lf)
            IF hd:=Open(destination,1006)
            lt:=Write(hd,buf,lo)
            IF lt=lo THEN ret:=TRUE
            Close(hd)
            ENDIF
        ENDIF
        ENDIF
        IF buf THEN Dispose(buf)
    ENDIF
    Close(hs)
    ENDIF
    RETURN ret
ENDPROC
PROC p_SendRexxCommand(comrexx,portname,action_mode) /*"p_SendRexxCommand(comrexx,portname,action_mode)"*/
/*===============================================================================
 = Para         : Arexx script name.
 = Return       : NONE.
 = Description  : send arexx message (parsing errors).
 ==============================================================================*/
    DEF rc=FALSE
    DEF rarg:PTR TO rexxarg
    DEF rxmsg:PTR TO rexxmsg
    DEF retxmsg:PTR TO rexxmsg
    DEF ap:PTR TO mp
    DEF test:PTR TO LONG
    DEF execmsg:PTR TO mn
    DEF node:PTR TO ln
    DEF return_str[256]:STRING
    dWriteF(['p_SendRexxCommand() \s',' \s','\h\n'],[comrexx,portname,action_mode])
    IF rxmsg:=CreateRexxMsg(dummyport,NIL,NIL)
        execmsg:=rxmsg
        node:=execmsg
        node.name:='REXX'
        node.type:=NT_MESSAGE
        node.pri:=0
        execmsg.replyport:=dummyport
        IF test:=CreateArgstring(comrexx,EstrLen(comrexx))
            CopyMem({test},rxmsg.args,4)
            rxmsg.action:=action_mode
            rxmsg.passport:=dummyport
            rxmsg.stdin:=Input()
            rxmsg.stdout:=myout
            Forbid()
            ap:=FindPort(portname)
            IF ap
                PutMsg(ap,rxmsg)
            ENDIF
            Permit()
            IF ap
                WaitPort(dummyport)
                IF retxmsg:=GetMsg(dummyport)
                    rc:=retxmsg.result1
                    rarg:=retxmsg.result2
                    IF rc=0
                        p_AjouteInfoNode(myb.infolist,'Arexx Macro.')
                    ELSE
                        StringF(return_str,'Arexx Error :\d',rc)
                        p_AjouteInfoNode(myb.infolist,return_str)
                    ENDIF
                    /*IF retxmsg THEN ReplyMsg(retxmsg)*/
                ENDIF
            ELSE
                p_AjouteInfoNode(myb.infolist,'Editor Port no found.')
            ENDIF
            IF test THEN ClearRexxMsg(rxmsg,16)
        ENDIF
        IF rxmsg THEN DeleteRexxMsg(rxmsg)
    ENDIF
ENDPROC
PROC p_LookIfFullName(nom) /*"p_LookIfFullName(nom)"*/
/*===============================================================================
 = Para         : filename.
 = Return       : TRUE if filename content : or /.
 = Description  : like name proc.
 ==============================================================================*/
    DEF lpos
    IF ((lpos:=InStr(nom,':',0)<>-1) OR
       (lpos:=InStr(nom,'/',0)<>-1)) THEN RETURN TRUE
    RETURN FALSE
ENDPROC

PROC main() HANDLE /*"main()"*/
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else FALSE.
 = Description  : Main Proc.
 ==============================================================================*/
    DEF testmain
    DEF execcom[256]:STRING
    tattr:=['topaz.font',8,0,0]:textattr
    VOID '$VER:Peps v0.1 © 1994 NasGûl (26-05-94)'
    IF wbmessage<>NIL
        Raise(ER_ONLYCLI)
    ELSE
        IF (testmain:=p_StartCli())<>ER_NONE THEN Raise(testmain)
    ENDIF
    IF compilandexit=FALSE
        IF (testmain:=p_RunEditor())>0 THEN Raise(ER_RUNED)
    ENDIF
    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_CreateArexxPort(prgportname,0))<>ER_NONE THEN Raise(testmain)
    IF (dummyport:=CreateMsgPort())=NIL THEN Raise(ER_CREATEPORT)
    IF (testmain:=p_InitPeps())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_SetUpScreen())<>ER_NONE THEN Raise(testmain)
    IF nomenu=FALSE
        p_RebuildMenu()
    ENDIF
    IF (testmain:=p_InitppWindow())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_OpenppWindow())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_OpenConsole())<>ER_NONE THEN Raise(testmain)
    p_CleanAllList()
    p_ReadSourceFile(esource,TRUE)
    p_RenderppWindow()
    IF compilandexit
        p_WriteFPmoduleList(myb.pmodulelist)
        p_CalculTotalMem(myb.pmodulelist)
        StringF(execcom,'EC \s \s',ec,ecsource)
        IF (testmain:=p_Execute(execcom))<>0
            WindowToFront(pp_window)
            p_ParsingError(myb.pmodulelist,testmain)
        ELSE
            StringF(execcom,'Copy \s \s',ecsource,execname)
            Execute(execcom,0,stdout)
        ENDIF
        Raise(ER_NONE)
    ENDIF
    REPEAT
        p_LookAllMessage()
    UNTIL reelquit=TRUE
    Raise(ER_NONE)
EXCEPT
    IF myout THEN p_CloseConsole()
    IF pp_window THEN p_RemppWindow()
    IF screen THEN p_SetDownScreen()
    IF myb THEN p_RemPeps()
    IF dummyport THEN DeleteMsgPort(dummyport)
    IF arexxport THEN p_DeleteArexxPort(arexxport)
    p_CloseLibraries()
    SELECT exception
    /*============= CLI ERROR ==================*/
    CASE ER_BADARGS;    WriteF('Bad Args.\n')
    CASE ER_ONLYCLI;    WriteF('Only Cli.\n')
    CASE ER_NOFILE;     WriteF('Can\at find file \s.\n',esource)
    CASE ER_TEMPNOVALID; WriteF('TempFile Invalid.\n')
    CASE ER_PORTEXIST;   WriteF('Port \s exist.\n',prgportname)
    CASE ER_CREATEPORT;  WriteF('can\at create port.\n')
    CASE ER_EXENOVALID;  WriteF('ExecName Invalid.\n')
    CASE ER_SAMEDIR;     WriteF('Peps Same dir than source code.\n')
    CASE ER_NOMENUFILE;  WriteF('can\at find the menufile \s.\n',menufile)
    /*============= WINDOW ERROR ================*/
    CASE ER_LOCKSCREEN; WriteF('Lock Screen Failed.')
    CASE ER_VISUAL;     WriteF('Error Visual.')
    CASE ER_CONTEXT;    WriteF('Error Context.')
    CASE ER_MENUS;      WriteF('Error Menus.')
    CASE ER_GADGET;     WriteF('Error Gadget.')
    CASE ER_WINDOW;     WriteF('Error Window.')
    CASE ER_OPENSCREEN; WriteF('Can\at Open Screen.\n')
    CASE ER_CONOUT;     WriteF('Error Console Window.\n')
    CASE ER_SCREENSIG;  WriteF('Can\at Allocate Signal for the screen.\n')
    /*============= APP ERROR =================*/
    CASE ER_RUNED;      WriteF('Need Editor.\n')
    ENDSELECT
    CleanUp(0)
ENDPROC
