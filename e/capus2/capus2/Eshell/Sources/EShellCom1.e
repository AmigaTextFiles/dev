/*"»»»»»»»»»»»»»»» CD"*/
/*"cd(chemin)"*/
PROC cd(chemin)
    DEF lock,dlock
    DEF olddir,name[256]:STRING
    DEF rc[256]:STRING
    DEF m:PTR TO LONG
    m:=[0]
    MidStr(rc,chemin,3,ALL)
    StringF(name,'\s',rc)
    IF getArg(name,'Dossier',m)
        IF m[0]<>NIL
            IF lock:=Lock(rc,-2)
                dlock:=DupLock(lock)
                IF lock THEN UnLock(lock)
            ELSE
                WriteF('Directory error\n')
                JUMP cdend
            ENDIF
            olddir:=CurrentDir(dlock)
            pro.currentdir:=dlock
            NameFromLock(dlock,name,256)
            StringF(prompt,'\e[32m\d.\e[31m\s[\e[33m\d\e[31m]>',pro.tasknum,name,cl.returncode)
            StrCopy(cdn,name,ALL)
            m[0]:=NIL
        ELSE
            WriteF('\s\n',cdn)
        ENDIF
    ENDIF
    cdend:
ENDPROC
/**/
/**/
/*"»»»»»»»»»»»»»»» PSLIST"*/
/*"pslist()"*/
PROC pslist()
    DEF ps:PTR TO pubscreennode
    DEF sn:PTR TO ln
    DEF psl:PTR TO lh
    IF psl:=LockPubScreenList()
        sn:=psl.head
        WHILE sn
            ps:=sn
            IF sn.succ<>0
                WriteF('Name:\l\s[20] Adr Screen:\z\h[8] Flags:\z\h[8] SigTask:\z\h[8] SigBit:\z\h[8]\n',
                        sn.name,ps.screen,ps.flags,ps.sigtask,ps.sigbit)
            ENDIF
            sn:=sn.succ
        ENDWHILE
        UnlockPubScreenList()
    ENDIF
ENDPROC
/**/
/**/
/*"»»»»»»»»»»»»»»» RESET"*/
/*"reset()"*/
PROC reset()
    ColdReboot()
ENDPROC
/**/
/**/
/*"»»»»»»»»»»»»»»» PCDIR"*/
/*"pcdir(str)"*/
PROC pcdir(str)
    DEF dirw[100]:STRING
    DEF l,fib:fileinfoblock,dd=TRUE,df=TRUE,dr=FALSE,noic=FALSE
    DEF m:PTR TO LONG
    DEF argstr[256]:STRING
    DEF fn:PTR TO filenode
    DEF n:PTR TO ln
    DEF fileout=FALSE,nameout[80]:STRING,hout=NIL,oldout
    /*==================================================*/
    MidStr(argstr,str,5,ALL)
    m:=[0,0,0,0,0,0]
    IF getArg(argstr,'Dir,Dirs/S,Files/S,All/S,NoIcon/S,To/K',m)
        IF m[0] THEN StringF(dirw,'\s',m[0]) ELSE StrCopy(dirw,'',ALL)
        IF m[1] THEN df:=FALSE
        IF m[2] THEN dd:=FALSE
        IF m[3] THEN dr:=TRUE
        IF m[4] THEN noic:=TRUE
        IF m[5]
            fileout:=TRUE
            StrCopy(nameout,m[5],ALL)
        ENDIF
        l:=Lock(dirw,-2)
        IF l
            IF Examine(l,fib) AND (fib.direntrytype>0)
                AddPart(dirw,'#?',100)
            ENDIF
            UnLock(l)
        ENDIF
        makefilelist(dirw,dd,df,dr)
        IF fileout=TRUE
            IF hout:=Open(nameout,1006) 
                oldout:=stdout
                stdout:=hout 
            ELSE 
                JUMP pcdirend
            ENDIF
        ENDIF
        n:=filelist.head
        WHILE n
            IF CtrlC()
                WriteF('>>>> Break C\n')
                JUMP pcdirend
            ENDIF
            IF n.succ<>0
                fn:=n
                StringF(dirw,'\s\s',fn.curdirname,n.name)
                IF ((noic=TRUE) AND (InStr(n.name,'.info',0)<>-1))
                    NOP
                ELSE
                    l:=p_GetNumSlash(dirw)
                    FOR dd:=0 TO l-1
                        WriteF('\e[33m|   \e[0m')
                    ENDFOR
                    WriteF('\e[33m|---\e[0m')
                    IF fn.direntrytype>0
                        WriteF('\e[32m\s\e[0m\n',n.name)
                    ELSE
                        WriteF('\e[0m\s\n',n.name)
                    ENDIF
                ENDIF
            ENDIF
            n:=n.succ
        ENDWHILE
        pcdirend:
        filelist:=p_CleanList(filelist,TRUE,freenode,LIST_CLEAN)
        m[0]:=0;m[1]:=0;m[2]:=0;m[3]:=0;m[4]:=0;m[5]:=0
        IF (fileout=TRUE AND hout<>NIL)
            IF hout 
                Close(hout)
                stdout:=oldout
            ENDIF
        ENDIF
    ELSE
        WriteF('BadArgs !!.\n')
    ENDIF
ENDPROC
/**/
/*"p_GetNumSlash(str)"*/
PROC p_GetNumSlash(str) 
    DEF b,s=0
    DEF carac[1]:STRING
    FOR b:=0 TO StrLen(str)-1
        MidStr(carac,str,b,1)
        IF Char(carac)=$2F THEN INC s
    ENDFOR
ENDPROC s
/**/
/**/
/*"»»»»»»»»»»»»»»» D"*/
/*"d(str)"*/
PROC d(str) HANDLE
    DEF dirw[100]:STRING
    DEF l=NIL,fib:fileinfoblock
    DEF argstr[256]:STRING
    DEF m:PTR TO LONG,dd=TRUE,df=TRUE,dr=FALSE
    DEF fn:PTR TO filenode
    DEF n:PTR TO ln
    DEF fileout=FALSE,nameout[80]:STRING,hout=NIL,oldout
    /*==================================================*/
    MidStr(argstr,str,1,ALL)
    m:=[0,0,0,0,0]
    IF getArg(argstr,'Dir,Dirs/S,Files/S,All/S,To/K',m)
        IF m[0] THEN StringF(dirw,'\s',m[0]) ELSE StrCopy(dirw,'',ALL)
        IF m[1] THEN df:=FALSE
        IF m[2] THEN dd:=FALSE
        IF m[3] THEN dr:=TRUE
        IF m[4]
            fileout:=TRUE
            StrCopy(nameout,m[4],ALL)
        ENDIF
        l:=Lock(dirw,-2)
        IF l
            IF Examine(l,fib) AND (fib.direntrytype>0)
                AddPart(dirw,'#?',100)
            ENDIF
            UnLock(l)
        ENDIF
        makefilelist(dirw,dd,df,dr)
        IF fileout=TRUE
            IF hout:=Open(nameout,1006) 
                oldout:=stdout
                stdout:=hout 
            ELSE 
                JUMP dend
            ENDIF
        ENDIF
        l:=1
        n:=filelist.head
        WHILE n
            IF CtrlC()
                WriteF('>>>> Break C\n')
                JUMP dend
            ENDIF
            IF n.succ<>0
                fn:=n
                IF fn.direntrytype>0
                    WriteF('\e[32m\s[20] \e[0m\s[12]',n.name,'<dir>')
                ELSE
                    WriteF('\s[20] \d[12]',n.name,fn.size)
                ENDIF
                IF Even(l) THEN WriteF('\n')
                INC l
            ENDIF
            n:=n.succ
        ENDWHILE
        IF Even(l) THEN WriteF('\n')
        dend:
        filelist:=p_CleanList(filelist,TRUE,freenode,LIST_CLEAN)
        m[0]:=0;m[1]:=0;m[2]:=0;m[3]:=0;m[4]:=0
        IF (fileout=TRUE AND hout<>NIL)
            IF hout THEN Close(hout)
            stdout:=oldout
        ENDIF
    ELSE
        WriteF('Bad Args!!.\n')
    ENDIF
EXCEPT
    RETURN exception
ENDPROC
/**/
/**/
/*"»»»»»»»»»»»»»»» CHANGEDPS"*/
/*"changedps(s)"*/
PROC changedps(s)
    DEF m:PTR TO LONG
    DEF argstr[256]:STRING
    DEF namescreen[80]:STRING,info=FALSE
    DEF scr
    m:=[0,0]
    MidStr(argstr,s,9,ALL)
    IF getArg(argstr,'Name,Info/S',m)
        IF m[0] THEN StrCopy(namescreen,m[0],ALL) ELSE StrCopy(namescreen,'Workbench',ALL)
        IF m[1]
            GetDefaultPubScreen(namescreen)
            JUMP cdpsend
        ENDIF
        IF scr:=LockPubScreen(namescreen)
            SetDefaultPubScreen(namescreen)
            SetPubScreenModes(SHANGHAI)
            UnlockPubScreen(NIL,scr)
        ELSE
            WriteF('écran introuvable.\n')
        ENDIF
    ELSE
        WriteF('Bad Arg!!.\n')
    ENDIF
    cdpsend:
    m[0]:=0;m[1]:=0
    WriteF('Ecran Public :\s\n',namescreen)
ENDPROC
/**/
/**/
/*"»»»»»»»»»»»»»»» EXECUTE"*/
/*"execute(cmd,dir,sta,pp,mode)"*/
PROC execute(cmd,dir,sta,pp,mode) HANDLE
    DEF ofh=NIL:PTR TO filehandle
    DEF ifh=NIL:PTR TO filehandle
    DEF newct=NIL:PTR TO mp
    DEF oldct:PTR TO mp
    DEF oldcd
    DEF newcd
    DEF r
    DEF rcmd[256]:STRING
    IF mode=TRUE THEN MidStr(rcmd,cmd,4,ALL) ELSE StrCopy(rcmd,cmd,ALL)
    IF ofh:=Open('NIL:',1006)
        IF IsInteractive(ofh)
            newct:=ofh.type
            oldct:=SetConsoleTask(newct)
            ifh:=Open('CONSOLE:',1005)
            SetConsoleTask(oldct)
            ELSE
            ifh:=Open('NIL:',1005)
        ENDIF
    ENDIF
    newcd:=Lock(dir,-2)
    oldcd:=CurrentDir(newcd)
    IF r:=SystemTagList(cmd,[SYS_OUTPUT,IF mode=TRUE THEN ofh ELSE con,
                         SYS_INPUT,IF mode=TRUE THEN ifh ELSE 0,
                         SYS_ASYNCH,mode,
                         SYS_USERSHELL,TRUE,
                         NP_STACKSIZE,sta,
                         NP_PRIORITY,pp,
                         NP_CLOSEINPUT,FALSE,
                         NP_CLOSEOUTPUT,FALSE,
                         0])
    ENDIF
    CurrentDir(oldcd)
    IF newcd THEN UnLock(newcd)
    IF ofh THEN Close(ofh)
    IF ifh THEN Close(ifh)
    Raise(r)
EXCEPT
    RETURN r
ENDPROC
/**/
/**/
/*"»»»»»»»»»»»»»»» MDIR"*/
/*"mdir(s)"*/
PROC mdir(s)
    DEF m:PTR TO LONG
    DEF name[80]:STRING
    DEF argstr[256]:STRING
    DEF r
    m:=[0]
    MidStr(argstr,s,4,ALL)
    IF getArg(argstr,'Dossier',m)
        IF m[0]
            StringF(name,'\s',m[0])
            r:=CreateDir(name)
            IF r=0 THEN WriteF('Impssible de créer \s\n',name) ELSE UnLock(r)
        ENDIF
    ELSE
        WriteF('Bad Arg!!.\n')
    ENDIF
    m[0]:=0
ENDPROC
/**/
/**/
/*"»»»»»»»»»»»»»»» DELAY"*/
/*"delay(s)"*/
PROC delay(s)
    DEF m:PTR TO LONG
    DEF argstr[256]:STRING
    DEF t
    m:=[0]
    MidStr(argstr,s,5,ALL)
    IF getArg(argstr,'Temps/N',m)
        IF m[0] THEN t:=Long(m[0]) ELSE t:=0
        Delay(t)
    ELSE
        WriteF('Bad Arg!!.\n')
    ENDIF
    m[0]:=0
ENDPROC
/**/
/**/
/*"»»»»»»»»»»»»»»» SETCOM"*/
/*"setcom(s)"*/
PROC setcom(s) HANDLE
    DEF m:PTR TO LONG
    DEF argstr[256]:STRING
    DEF file[256]:STRING
    DEF com[256]:STRING
    DEF r
    DEF fn:PTR TO filenode
    DEF n:PTR TO ln,dd=TRUE,df=TRUE,dr=FALSE
    MidStr(argstr,s,6,ALL)
    m:=[0,0,0,0,0]
    IF getArg(argstr,'Fichier,C=Commentaire/K,Files/S,Dirs/S,All/S',m)
        IF m[0] THEN StrCopy(file,m[0],ALL)
        IF m[1] THEN StrCopy(com,m[1],ALL)
        IF m[2] THEN dd:=FALSE
        IF m[3] THEN df:=FALSE
        IF m[4] THEN dr:=TRUE
        IF m[4]
            r:=makefilelist(file,dd,df,dr)
            n:=filelist.head
            WHILE n
                IF n.succ<>0
                    fn:=n
                    StringF(file,'\s\s',fn.curdirname,n.name)
                    r:=SetComment(file,com)
                    IF r=0 THEN WriteF('\s non trouvé.\n',file)
                ENDIF
                n:=n.succ
            ENDWHILE
            filelist:=p_CleanList(filelist,TRUE,freenode,LIST_CLEAN)
        ELSE
            r:=SetComment(file,com)
            IF r=0 THEN WriteF('\s non trouvé.\n',file) ELSE WriteF('\s "\s"\n',file,com)
        ENDIF
    ELSE
        WriteF('Bad Arg!!.\n')
    ENDIF
    m[0]:=0;m[1]:=0;m[2]:=0;m[3]:=0;m[4]:=0
EXCEPT
    RETURN exception
ENDPROC
/**/
/**/
/*"»»»»»»»»»»»»»»» QHELP"*/
/*"qhelp()"*/
PROC qhelp()
    DEF i,com:PTR TO ecom
    WriteF('\e[32m\s\e[0m\n',title_req)
    FOR i:=0 TO MAX_COMMAND-1
        com:=commandlist[i]
        WriteF('\l\s[15] v \d[2].\d[2] Auteur:\s\n',com.name,com.version,com.revision,com.author)
    ENDFOR
    /*
    WriteF('cd,pslist,reset,pcdir,d,changedsp\n')
    WriteF('mdir,delay,setcom,ass,del,bye,fullsize,syslist\n')
    WriteF('mem\n')
    */
ENDPROC
/**/
/**/
/*"»»»»»»»»»»»»»»» DEL"*/
/*"del(s)"*/
PROC del(s)
    DEF m:PTR TO LONG
    DEF dd=TRUE,df=TRUE,dr=FALSE
    DEF argstr[256]:STRING
    DEF file[256]:STRING
    DEF r
    DEF n:PTR TO ln
    DEF fn:PTR TO filenode
    DEF nbrs,t,l,fname[256]:STRING,w=FALSE
    MidStr(argstr,s,3,ALL)
    m:=[0,0,0,0,0]
    IF getArg(argstr,'File,Dirs/S,Files/S,All/S,Write/S',m)
        IF m[0] THEN StrCopy(file,m[0],ALL) ELSE StrCopy(file,'',ALL)
        IF m[1] THEN df:=FALSE
        IF m[2] THEN dd:=FALSE
        IF m[3] THEN dr:=TRUE
        IF m[4] THEN w:=TRUE
        IF m[0]
            r:=makefilelist(file,dd,df,dr)
            nbrs:=p_CountNodes(filelist)
            FOR r:=nbrs-1 TO 0 STEP -1
                n:=p_GetAdrNode(filelist,r)
                fn:=n
                IF CtrlC()
                    WriteF('>>>> Break C\n')
                    JUMP delend
                ENDIF
                IF StrCmp(fn.curdirname,n.name,EstrLen(n.name))
                    StringF(argstr,'\s',n.name)
                ELSE
                    StringF(argstr,'\s\s',fn.curdirname,n.name)
                ENDIF
                t:=DeleteFile(argstr)
                IF t<>-1 THEN WriteF('Impossible d\aeffacer \s\n',argstr)
                IF (w=TRUE AND t=-1) THEN WriteF('Del \s\n',argstr)
            ENDFOR
            delend:
            filelist:=p_CleanList(filelist,TRUE,freenode,LIST_CLEAN)
        ENDIF
    ELSE
        WriteF('Bad Args!!.\n')
    ENDIF
    m[0]:=0;m[1]:=0;m[2]:=0;m[3]:=0;m[4]:=0
ENDPROC
/**/
/**/
/*"»»»»»»»»»»»»»»» FULLSIZE"*/
/*"fullsize(str)"*/
PROC fullsize(str)
    DEF m:PTR TO LONG
    DEF argstr[256]:STRING
    DEF firstdir[256]:STRING
    DEF data:PTR TO LONG
    m:=[0]
    data:=[0,0,0]
    MidStr(argstr,str,8,ALL)
    IF getArg(argstr,'Dossier',m)
        IF m[0] THEN StringF(firstdir,m[0],ALL) ELSE StrCopy(firstdir,'',ALL)
        p_LookDir(firstdir,data)
        WriteF('\n\e[1m\e[31mNumber of File(s) :\e[33m\d\e[0m\n',data[2])
        WriteF('\e[1m\e[31mNumber of Dir(s)  :\e[33m\d\e[0m\n',data[1])
    ELSE
        WriteF('Bad Args!!\n')
    ENDIF
    m[0]:=0;data[0]:=0;data[1]:=0;data[2]:=0
ENDPROC
/**/
/*"p_LookDir(curdir)"*/
PROC p_LookDir(curdir,dd:PTR TO LONG)
  DEF info:fileinfoblock,lock
  DEF currentdir[256]:STRING,pv[256]:STRING
  IF lock:=Lock(curdir,-2)
    NameFromLock(lock,currentdir,256)
    AddPart(currentdir,'',256)
    IF Examine(lock,info)
      IF info.direntrytype>0
        WHILE ExNext(lock,info)
            IF info.direntrytype>0
              StringF(pv,'\s\s',currentdir,info.filename)
              dd[1]:=dd[1]+1
              p_LookDir(pv,dd)
            ELSE
              dd[0]:=dd[0]+info.size
              WriteF('\b\e[1m\e[31mFullSize v0.1 © 1994 NasGûl:\e[1m\e[32m\d \e[1m\e[0mOctets.',dd[0])
              dd[2]:=dd[2]+1
            ENDIF
        ENDWHILE
      ELSE
      ENDIF
    ENDIF
    UnLock(lock)
  ELSE
    WriteF('What ?!?\n')
  ENDIF
ENDPROC
/**/
/**/
/*"»»»»»»»»»»»»»»» SYSLIST"*/
/*"syslist(s)"*/
PROC syslist(s)
    DEF m:PTR TO LONG
    DEF argstr[256]:STRING
    DEF slist:PTR TO lh
    DEF disp=NIL
    DEF n:PTR TO ln
    m:=[0,0,0,0,0,0]
    MidStr(argstr,s,7,ALL)
    IF getArg(argstr,'T=Task/S,L=Library/S,D=Device/S,P=Port/S,W=Window/S,M=Memory/S',m)
        IF m[0] THEN disp:=disp+LIST_TASK
        IF m[1] THEN disp:=disp+LIST_LIBRARY
        IF m[2] THEN disp:=disp+LIST_DEVICE
        IF m[3] THEN disp:=disp+LIST_PORT
        IF m[4] THEN disp:=disp+LIST_WINDOW
        IF m[5] THEN disp:=disp+LIST_MEMORY
        IF slist:=p_InitList()
            IF (disp AND LIST_TASK)
                displaytasks(slist,execbase)
            ENDIF
            IF (disp AND LIST_LIBRARY)
                displaylibraries(slist,execbase)
            ENDIF
            IF (disp AND LIST_DEVICE)
                displaydevices(slist,execbase)
            ENDIF
            IF (disp AND LIST_PORT)
                displayports(slist,execbase)
            ENDIF
            IF (disp AND LIST_WINDOW)
                displaywindows(slist,execbase)
            ENDIF
            IF (disp AND LIST_MEMORY)
                displaymemory(slist,execbase)
            ENDIF
            n:=slist.head
            WHILE n
                IF n.succ<>0
                    WriteF('\s\n',n.name)
                ENDIF
                n:=n.succ
            ENDWHILE
            IF slist THEN p_CleanList(slist,FALSE,0,LIST_REMOVE)
        ENDIF
    ELSE
        WriteF('Bad Args !!.\n')
    ENDIF
    m[0]:=0;m[1]:=0;m[2]:=0;m[3]:=0;m[4]:=0;m[5]:=0
ENDPROC




/*"MAN COMMAND"*/
/*"man(str)"*/
PROC man(str)
    DEF fh,buf[1000]:ARRAY,n=0,last=NIL,sl,first=NIL
    DEF a[100]:STRING,pa[100]:STRING,found=FALSE
    DEF m:PTR TO LONG
    DEF argstr[256]:STRING
    MidStr(argstr,str,3,ALL)
    m:=[0]
    IF getArg(argstr,'Command',m)
        IF m[0]
            IF fh:=Open('ESH:Eshell.Doc',OLDFILE)
                WHILE Fgets(fh,buf,1000)
                    IF (sl:=String(StrLen(buf)))=NIL THEN Raise("MEM")
                    StrCopy(sl,buf,ALL)
                    IF last THEN Link(last,sl) ELSE first:=sl
                    last:=sl
                    /*
                    StringF(a,'\s',argstr)
                    UpperStr(a)
                    StringF(pa,'Commande \s',a)
                    StrCopy(argstr,pa,ALL)
                    IF found=TRUE
                        IF StrCmp(sl,'Commande',8) THEN JUMP manend1
                        WriteF('\s\n',sl)
                    ELSEIF StrCmp(sl,argstr,EstrLen(argstr))
                        WriteF('\s\n',sl)
                        found:=TRUE
                    ENDIF
                    */
                    INC n
                ENDWHILE
                manend1:
                Close(fh)
                StringF(a,'\s',argstr)
                UpperStr(a)
                StringF(pa,'Commande \s',a)
                StrCopy(argstr,pa,ALL)
                WriteF('\s \s \s \s\n',pa,argstr,m[0],a)
                sl:=first
                WHILE sl
                    StringF(argstr,'\s',sl)
                    IF found=TRUE
                        IF StrCmp(argstr,'Commande',8) THEN JUMP manend
                        PutStr(sl)
                        /*
                        WriteF('\s\n',argstr)
                        */
                    ELSEIF StrCmp(sl,pa,EstrLen(pa))
                        PutStr(sl)
                        /*
                        WriteF('\s\n',argstr)
                        */
                        found:=TRUE
                    ENDIF
                    sl:=Next(sl)
                ENDWHILE
            ELSE
                WriteF('Pas de fichier doc..\n')
            ENDIF
        ENDIF
    ELSE
        WriteF('Bad Arg!!.')
    ENDIF
    manend:
    /*DisposeLink(first)*/
    m[0]:=0
ENDPROC
/**/
/**/
/**/
/*"displaytasks(wlist,exec:PTR TO execbase)"*/
PROC displaytasks(wlist,exec:PTR TO execbase)
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Build String and copy them to wlist.
 ==============================================================================*/
  DEF tlist:PTR TO tc,tlist2:PTR TO tc,node:PTR TO ln
  DEF list:PTR TO lh
  DEF pro:PTR TO process
  DEF cl:PTR TO commandlineinterface
  DEF datastr[256]:STRING
  DEF tname[80]:STRING
  p_AjouteNode(wlist,'  Adr    Taskname                 Pri    Sig       Stack',0)
  p_AjouteNode(wlist,'--------------------------------------------------------',0)
  Forbid()
  list:=exec.taskwait
  tlist2:=list.head
  list:=exec.taskready
  tlist:=list.head
  WHILE tlist
    node:=tlist
    pro:=tlist
    IF node.succ
        IF (node.type=NT_PROCESS AND pro.tasknum<>0)
            cl:=Shl(pro.cli,2)
            StringF(tname,'\s [\d]',TrimStr(Shl(cl.commandname,2)),pro.tasknum)
        ELSE
            StrCopy(tname,node.name,ALL)
        ENDIF
        StringF(datastr,'\z\h[8] \l\s[20]  \r\d[5]  $\z\h[8]  \r\d[6]',
                tlist,tname,node.pri,tlist.sigwait,tlist.spupper-tlist.splower)
                p_AjouteNode(wlist,datastr,0)
    ENDIF
    tlist:=node.succ
    IF (tlist=NIL) AND (tlist2<>NIL)
      tlist:=tlist2
      tlist2:=NIL
    ENDIF
  ENDWHILE
  Permit()
  tlist:=FindTask(NIL)
  node:=tlist
  pro:=tlist
  IF (node.type=NT_PROCESS AND pro.tasknum<>0)
      cl:=Shl(pro.cli,2)
      StringF(tname,'\s [\d]',TrimStr(Shl(cl.commandname,2)),pro.tasknum)
  ELSE
      StrCopy(tname,node.name,ALL)
  ENDIF
  StringF(datastr,'\z\h[8] \l\s[20]  \r\d[5]  $\z\h[8]  \r\d[6]',
          tlist,tname,node.pri,tlist.sigwait,tlist.spupper-tlist.splower)
  p_AjouteNode(wlist,datastr,0)
ENDPROC
/**/
/*"displaylibraries(wlist,exec:PTR TO execbase)"*/
PROC displaylibraries(wlist,exec:PTR TO execbase)
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Build String and copy them to wlist.
 ==============================================================================*/
  DEF llist:PTR TO lib,node:PTR TO ln
  DEF list:PTR TO lh
  DEF datastr[256]:STRING
  p_AjouteNode(wlist,'  Adr    Libraryname                  Pri   Version  OpenCnt',0)
  p_AjouteNode(wlist,'------------------------------------------------------------',0)
  Forbid()
  list:=exec.liblist
  llist:=list.head
  WHILE llist
    node:=llist
    IF node.succ
      StringF(datastr,'\z\h[8] \l\s[25]  \r\d[5]  \d[3].\l\d[4]  \d[3]',
        llist,node.name,node.pri,llist.version,llist.revision,llist.opencnt)
        p_AjouteNode(wlist,datastr,0)
    ENDIF
    llist:=node.succ
  ENDWHILE
  Permit()
ENDPROC
/**/
/*"displaydevices(wlist,exec:PTR TO execbase)"*/
PROC displaydevices(wlist,exec:PTR TO execbase)
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Build String and copy them to wlist.
 ==============================================================================*/
  DEF dlist:PTR TO lib,node:PTR TO ln,list:PTR TO lh
  DEF datastr[256]:STRING
  p_AjouteNode(wlist,'  Adr    Devicename                   Pri   Version  OpenCnt',0)
  p_AjouteNode(wlist,'------------------------------------------------------------',0)
  Forbid()
  list:=exec.devicelist
  dlist:=list.head
  WHILE dlist
    node:=dlist
    IF node.succ
      StringF(datastr,'\z\h[8] \l\s[25]  \r\d[5]  \d[3].\l\d[4]  \d[3]',
        dlist,node.name,node.pri,dlist.version,dlist.revision,dlist.opencnt)
        p_AjouteNode(wlist,datastr,0)
    ENDIF
    dlist:=node.succ
  ENDWHILE
  Permit()
ENDPROC
/**/
/*"displayports(wlist,exec:PTR TO execbase)"*/
PROC displayports(wlist,exec:PTR TO execbase)
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Build String and copy them to wlist.
 ==============================================================================*/
  DEF plist:PTR TO mp,taskname,portname,node:PTR TO ln,t:PTR TO ln,list:PTR TO lh
  DEF datastr[256]:STRING
  p_AjouteNode(wlist,'  Adr    Portname                   Pri    Bit#    Task',0)
  p_AjouteNode(wlist,'-------------------------------------------------------',0)
  Forbid()
  list:=exec.portlist
  plist:=list.head
  WHILE plist
    node:=plist
    IF node.succ
      portname:=node.name
      IF (portname<>NIL) AND (portname[]<>0)
        t:=plist.sigtask
        taskname:=t.name
        IF taskname=NIL THEN taskname:='-'
        StringF(datastr,'\z\h[8] \l\s[25]  \d[5]  \d[5]   \s[20]',
          plist,node.name,node.pri,plist.sigbit,taskname)
        p_AjouteNode(wlist,datastr,0)
      ENDIF
    ENDIF
    plist:=node.succ
  ENDWHILE
  Permit()
ENDPROC
/**/
/*"displaywindows(wlist,exec:PTR TO execbase)"*/
PROC displaywindows(wlist,exec:PTR TO execbase)
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Build String and copy them to wlist.
 ==============================================================================*/
  DEF slist:PTR TO screen,winlist:PTR TO window,
      intui:PTR TO intuitionbase,datastr[256]:STRING
  intui:=intuitionbase
  p_AjouteNode(wlist,'  Adr    Windowname               Width Height  IDCMP      FLAGS',0)
  p_AjouteNode(wlist,'----------------------------------------------------------------',0)
  slist:=intui.firstscreen
  Forbid()
  WHILE slist
    StringF(datastr,'\z\h[8] \l\s[25]  \d[5]  \d[3]',
      slist,slist.title,slist.width,slist.height)
      p_AjouteNode(wlist,datastr,0)
    winlist:=slist.firstwindow
    WHILE winlist
      StringF(datastr,'\z\h[8] \l\s[25]  \d[5]  \d[3]  $\z\r\h[8]  $\z\r\h[8]',
      winlist,winlist.title,winlist.width,winlist.height,winlist.idcmpflags,winlist.flags)
      winlist:=winlist.nextwindow
      p_AjouteNode(wlist,datastr,0)
    ENDWHILE
    slist:=slist.nextscreen
  ENDWHILE
  Permit()
ENDPROC
/**/
/*"displaymemory(wlist,exec:PTR TO execbase)"*/
PROC displaymemory(wlist,exec:PTR TO execbase)
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Build String and copy them to wlist.
 ==============================================================================*/
    DEF dlist:PTR TO mh,node:PTR TO ln
    DEF list:PTR TO lh
    DEF datastr[256]:STRING
    DEF f_mem:PTR TO mc,num_c
    list:=exec.memlist
    dlist:=list.head
    p_AjouteNode(wlist,'  Adr    Memoryname               Free    NumBlock  Attrs',0)
    p_AjouteNode(wlist,'---------------------------------------------------------',0)
    WHILE dlist
        node:=dlist
        IF node.succ
            f_mem:=dlist.first
            num_c:=0
            Forbid()
            WHILE f_mem
                num_c:=num_c+1
                f_mem:=f_mem.next
            ENDWHILE
            Permit()
            StringF(datastr,'\z\h[8] \l\s[20] \d[12] \d[3]      $\h[8]',dlist,node.name,dlist.free,num_c,dlist.attributes)
            p_AjouteNode(wlist,datastr,0)
        ENDIF
        dlist:=node.succ
    ENDWHILE
ENDPROC
/**/
/**/
/*"»»»»»»»»»»»»»»» MEM"*/
/*"mem(s)"*/
PROC mem(s)
    DEF m:PTR TO LONG
    DEF argstr[256]:STRING
    DEF adr,a,b,radr:PTR TO LONG,c,r
    m:=[0]
    MidStr(argstr,s,3,ALL)
    IF getArg(argstr,'Adr',m)
        IF m[0]
            adr:=Val(m[0],{r})
            IF r=0
                WriteF('Usage: MEM <adr>\n')
            ELSE
                adr:=adr AND -2     /* no odd adr */
                FOR a:=0 TO 7
                    radr:=a*16+adr
                    WriteF('$\r\z\h[8]:   ',radr)
                    FOR b:=0 TO 3 DO WriteF('\r\z\h[8] ',radr[b])
                    WriteF('  "'); c:=radr
                    FOR b:=0 TO 15 DO Out(stdout,IF (c[b]<32) OR (c[b]>126) THEN "." ELSE c[b])
                    WriteF('"\n')
                ENDFOR
            ENDIF
        ENDIF
    ELSE
        WriteF('Bad Args!!.\n')
    ENDIF
    memend:
    m[0]:=0
ENDPROC
/**/
/**/

