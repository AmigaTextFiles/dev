/*======<<< Peps Header >>>======
 PRGVERSION '0'
 ================================
 PRGREVISION '1'
 ================================
 AUTHOR      'NasGûl (ß version)'
 ===============================*/
/*======<<<   History   >>>======

 - 0.1 commands:
        cd/pslist/reset/pcdir/d/changedsp
        mdir/delay/setcom/del/ass en cours/fullsize
        syslist.

 ===============================*/

OPT OSVERSION=37
CONST DEBUG=FALSE
/*"MODULES LIST"*/
MODULE 'dos/dos'
MODULE 'dos/rdargs'
MODULE 'dos/dosextens'
MODULE 'dos/dosasl','utility','dos/dostags'
MODULE 'eropenlib'
MODULE 'intuition/intuition'
MODULE 'intuition/screens'
MODULE 'intuition/intuitionbase'
MODULE 'exec/nodes','exec/lists','exec/ports','exec/memory','exec/execbase','exec/tasks','exec/libraries'
MODULE 'mheader'
/*=== Commande ListCom ===*/
MODULE 'commodities'

/**/
/*"PMODULES LIST"*/
PMODULE 'EshellList'
PMODULE 'EShellCom1'
PMODULE 'lc'
PMODULE 'PModules:dWriteF'
PMODULE 'PModules:PMHeader'
/**/
/*"CONST/ENUM/OBJECTS/RAISE"*/

CONST MAXPATH=250

ENUM ER_NONE,ER_MEM

OBJECT filenode
    node:ln             /* ln.name=filename */
    direntrytype:LONG   /* like fileinfoblock */
    curdirname:LONG
    protection:LONG
    size:LONG
    numblocks:LONG
    comment:LONG
ENDOBJECT

RAISE ER_MEM IF New()=NIL,        /* set common exceptions:                */
      ER_MEM IF String()=NIL      /* every call to these functions will be */
      /*
      ERROR_BREAK IF CtrlC()=TRUE /* automatically checked against NIL,    */
                                  /* and the exception ER_MEM is raised    */
                                  */

/* Commande SysList */

SET  LIST_TASK,LIST_LIBRARY,LIST_DEVICE,LIST_PORT,LIST_WINDOW,
     LIST_MEMORY

/**/
/*"APPLICATION DEF"*/
DEF prompt[256]:STRING
DEF cdn[256]:STRING
DEF bdn[256]:STRING
DEF pro:PTR TO process
DEF cl:PTR TO commandlineinterface
DEF con
DEF filelist:PTR TO lh,freenode
/**/
/*"COMMANDS LIST"*/
/*"ASS COMMAND"*/
/*"ass(s)"*/
PROC ass(s)
    DEF m:PTR TO LONG
    DEF argstr[256]:STRING
    DEF l,ll
    DEF logicname[256]:STRING
    DEF physicname[256]:STRING
    DEF r
    DEF dl:PTR TO doslist,mask
    /* DosList */
    m:=[0,0,0,0,0,0,0,0]
    MidStr(argstr,s,3,ALL)
    IF getArg(argstr,'Nom,Dossier,Add/S,Late/S,Remove/S,V=VolList/S,D=DevicesList/S,A=AssignList/S',m)
        IF m[0] THEN StrCopy(logicname,m[0],ALL)
        IF m[1] THEN StrCopy(physicname,m[1],ALL)
        IF Not(m[4])
            r:=InStr(logicname,':',0)
            IF r<>-1
                MidStr(argstr,logicname,0,EstrLen(logicname)-1)
                StrCopy(logicname,argstr,ALL)
            ENDIF
        ENDIF
        IF m[2]
            IF m[0] AND m[1]
                IF l:=Lock(physicname,-2)
                    ll:=DupLock(l)
                    IF l THEN UnLock(l)
                    r:=AssignAdd(logicname,ll)
                ENDIF
            ENDIF
            JUMP assend
        ENDIF
        IF m[3]
            IF m[0] AND m[1]
                r:=AssignLate(logicname,physicname)
            ENDIF
            JUMP assend
        ENDIF
        IF m[4]
            IF m[0]
                IF l:=Lock(logicname,-2)
                    ll:=DupLock(l)
                    IF l THEN UnLock(l)
                    r:=AssignLock(logicname,NIL)
                ENDIF
            ENDIF
            JUMP assend
        ENDIF
        IF m[0] AND m[1]
            IF l:=Lock(physicname,-2)
                ll:=DupLock(l)
                UnLock(l)
                r:=AssignLock(logicname,ll)
                WriteF('\d\n',r)
                JUMP assend
            ENDIF
        ENDIF
        IF m[5]
            mask:=LDF_VOLUMES+LDF_READ
            dl:=LockDosList(mask)
            WHILE (dl:=NextDosEntry(dl,mask))
                WriteF('\s:\n',TrimStr(Shl(dl.name,2)))
            ENDWHILE
            UnLockDosList(mask)
        ENDIF
        IF m[6]
            mask:=LDF_DEVICES+LDF_READ
            dl:=LockDosList(mask)
            WHILE (dl:=NextDosEntry(dl,mask))
                WriteF('\s:\n',TrimStr(Shl(dl.name,2)))
            ENDWHILE
            UnLockDosList(mask)
        ENDIF
        IF m[7]
            mask:=LDF_ASSIGNS+LDF_READ
            dl:=LockDosList(mask)
            WHILE (dl:=NextDosEntry(dl,mask))
                WriteF('\s:\n',TrimStr(Shl(dl.name,2)))
            ENDWHILE
            UnLockDosList(mask)
        ENDIF
    ELSE
        WriteF('Bad Args!!.\n')
    ENDIF
    assend:
    m[0]:=0;m[1]:=0;m[2]:=0;m[3]:=0;m[4]:=0;m[5]:=0;m[6]:=0;m[7]:=0
ENDPROC
/**/
/**/
/*"LISTCOM COMMAND"*/
/*"listcom()"*/
PROC listcom()
    DEF l:PTR TO lh,r
    DEF n:PTR TO ln
    IF cxbase:=OpenLibrary('commodities.library',0)
        r:=p_InitList()
        CopyBrokerList(r)
        l:=r
        n:=l.head
        WHILE n
            IF n.succ<>0
                WriteF('Nom:\l\s[20] Pri:\d\n',n.name,n.pri)
            ENDIF
            n:=n.succ
        ENDWHILE
        p_CleanList(l,FALSE,0,LIST_REMOVE)
        IF cxbase THEN CloseLibrary(cxbase)
    ELSE
        WriteF('Commodities.library ??\n')
    ENDIF
ENDPROC
/**/
/**/
/**/
/*"APPLICATION PROCEDURES"*/
/*"updateprompt(rc)"*/
PROC updateprompt(rc)
    StringF(prompt,'\e[32m\d.\e[31m\s[\e[33m\d\e[31m]>',pro.tasknum,cdn,rc)
ENDPROC
/**/
/*"makefilelist(a,dirsf,filesf,recf)"*/
PROC makefilelist(a,dirsf,filesf,recf) HANDLE
    DEF er
    DEF i:PTR TO fileinfoblock,size=0
    DEF anchor=NIL:PTR TO anchorpath,fullpath
    DEF ascii[256]:STRING,x,work[256]:STRING,curdir[256]:STRING
    DEF fn:PTR TO filenode,l
    dWriteF(['makefilelist(\s,','\d,','\d,','\d)\n'],[a,dirsf,filesf,recf])
    anchor:=New(SIZEOF anchorpath+MAXPATH)
    anchor.breakbits:=4096
    anchor.strlen:=MAXPATH-1
    er:=MatchFirst(a,anchor)                   /* collect all strings */
    WHILE er=0
        fullpath:=anchor+SIZEOF anchorpath
        i:=anchor.info
        StringF(work,'\s',i.filename)
        IF IF i.direntrytype>0 THEN dirsf ELSE filesf
            fn:=New(SIZEOF filenode)
            fn.direntrytype:=i.direntrytype
            IF l:=Lock(fullpath,-2)
                NameFromLock(l,curdir,256)
                StrCopy(ascii,curdir,ALL)
                MidStr(curdir,fullpath,0,StrLen(fullpath)-StrLen(i.filename))
                fn.curdirname:=String(StrLen(curdir))
                StrCopy(fn.curdirname,curdir,ALL)
                IF l THEN UnLock(l)
            ENDIF
            fn.protection:=i.protection
            IF i.direntrytype>0 THEN fn.size:=0 ELSE fn.size:=i.size
            fn.numblocks:=i.numblocks
            fn.comment:=String(StrLen(i.comment))
            StrCopy(fn.comment,i.comment,ALL)
            p_AjouteNode(filelist,work,fn)
        ENDIF
        IF i.direntrytype<0 THEN size:=size+i.size
        IF recf AND (i.direntrytype>0)              /* do recursion(=tail) */
            x:=StrLen(fullpath)
            IF x+5<MAXPATH THEN CopyMem('/#?',fullpath+x,4)
            size:=size+makefilelist(fullpath,dirsf,filesf,recf)
            fullpath[x]:=0
        ENDIF
        er:=MatchNext(anchor)
    ENDWHILE
    IF er<>ERROR_NO_MORE_ENTRIES THEN Raise(er)
    MatchEnd(anchor)
    Dispose(anchor)
    anchor:=NIL
EXCEPT                                  /* nested exception handlers! */
    IF anchor THEN MatchEnd(anchor)
    Raise(exception)  /* this way, we call _all_ handlers in the recursion  */
ENDPROC size        /* and thus calling MatchEnd() on all hanging anchors */
/**/
/*"p_InitData()"*/
PROC p_InitData()
    DEF str[256]:STRING
    DEF cstr[256]:STRING
    pro:=FindTask(NIL)
    cl:=Shl(pro.cli,2)
    GetCurrentDirName(str,256)
    StringF(cstr,'CD \s',str)
    StringF(bdn,'CD \s',str)
    cd(cstr)
    freenode:=[18,DISL,34,DISL,DISE]
    filelist:=p_InitList()
    p_InitCommandList()
ENDPROC TRUE
/**/
/*"p_RemData()"*/
PROC p_RemData()
    p_CleanList(filelist,TRUE,freenode,LIST_REMOVE)
ENDPROC
/**/
/*"getArg(argu,temp,a:PTR TO LONG)"*/
PROC getArg(argu,temp,a)
    DEF myc:PTR TO csource
    DEF ma=NIL:PTR TO rdargs
    DEF rdargs=NIL
    DEF argstr[256]:STRING
    DEF ret=NIL
    StrCopy(argstr,argu,ALL)
    /*
    WriteF('\s\n',argstr)
    IF StrCmp('?',TrimStr(argstr),1) THEN RETURN NIL
    /*IF argu[0]="?" THEN RETURN NIL*/
    */
    StrAdd(argstr,'\n',1)
    IF ma:=AllocDosObject(DOS_RDARGS,NIL)
        myc:=New(SIZEOF csource)
        myc.buffer:=argstr
        myc.length:=EstrLen(argstr)
        ma.flags:=1
        CopyMem(myc,ma.source,SIZEOF csource)
        IF rdargs:=ReadArgs(temp,a,ma)
            /*
            StrCopy(argstr,a[0],ALL)
            WriteF('\s\n',argstr)
            */
            ret:=a
            IF rdargs THEN FreeArgs(rdargs)
        ENDIF
        IF myc THEN Dispose(myc)
        IF ma THEN FreeDosObject(DOS_RDARGS,ma)
    ELSE
        WriteF('AllocDosObject failed !!\n')
    ENDIF
ENDPROC ret
/**/
/*"main()"*/
PROC main()
    DEF inputstring[80]:STRING
    DEF comparestring[80]:STRING
    DEF ret
    DEF m:PTR TO LONG
    DEF rdargs=NIL
    m:=[0]
    IF rdargs:=ReadArgs('Interatif/F',m,NIL)
        IF con:=Open('CONSOLE:',NEWFILE)
            IF p_InitData()
                p_DoReadHeader({banner})
                IF m[0]
                    StrCopy(inputstring,m[0],ALL)
                    StrCopy(comparestring,inputstring,ALL)
                    UpperStr(comparestring)
                    lookinternalcommand(comparestring,inputstring)
                    JUMP mainend
                ENDIF
                qhelp()
                WHILE StrCmp(comparestring,'BYE',ALL)=FALSE
                    IF lookinternalcommand(comparestring,inputstring)=FALSE
                        ret:=execute(inputstring,'',4000,0,FALSE)
                        updateprompt(ret)
                    ENDIF
                    Write(con,prompt,EstrLen(prompt))
                    ReadStr(con,inputstring)
                    StrCopy(comparestring,inputstring,ALL)
                    UpperStr(comparestring)
                ENDWHILE
                mainend:
                p_RemData()
            ENDIF
            cd(bdn)
            Close(con)
        ENDIF
        IF rdargs THEN FreeArgs(rdargs)
    ELSE
        WriteF('Bad Arg!!\n')
    ENDIF
ENDPROC
/**/
/**/
