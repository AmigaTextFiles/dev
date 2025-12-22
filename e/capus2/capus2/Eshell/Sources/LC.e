ENUM    C_ASS,
        C_CHANGEDPS,
        C_CD,
        C_DELAY,
        C_DEL,
        C_D,
        C_EXECUTE,
        C_FULLSIZE,
        C_LISTCOM,
        C_MDIR,
        C_MEM,
        C_PSLIST,
        C_PCDIR,
        C_QHELP,
        C_RESET,
        C_SYSLIST,
        C_SETCOM

CONST MAX_COMMAND=17

OBJECT ecom
    name:LONG
    version:LONG
    revision:LONG
    template:LONG
    help:LONG
    author:LONG
ENDOBJECT

DEF commandlist[MAX_COMMAND]:ARRAY OF LONG

/*"p_InitCommandList()"*/
PROC p_InitCommandList()
    commandlist[C_ASS]:=['ASS',0,0,'Nom,Dossier,Add/S,Late/S,Remove/S,V=VolList/S,D=DevList/S,A=AssList/S',0,'(ß version NasGûl)']
    commandlist[C_CHANGEDPS]:=['CHANGEDPS',0,1,'Nom,info/S',0,'NasGûl']
    commandlist[C_CD]:=['CD',0,1,'Dossier',0,'NasGûl']
    commandlist[C_DELAY]:=['DELAY',0,1,'Temps/N',0,'NasGûl']
    commandlist[C_DEL]:=['DEL',0,1,'File,Dirs/S,Files/S,All/S,Write/S',0,'NasGûl']
    commandlist[C_D]:=['D',0,0,'Dir,Dirs/S,Files/S,All/S,To/K',0,'Distribution AmigaE 2.1']
    commandlist[C_EXECUTE]:=['EXECUTE',0,0,'Script',0,'NasGûl']
    commandlist[C_FULLSIZE]:=['FULLSIZE',0,1,'Dossier',0,'NasGûl']
    commandlist[C_LISTCOM]:=['LISTCOM',0,0,'',0,'NasGûl']
    commandlist[C_MDIR]:=['MDIR',0,1,'Dossier',0,'NasGûl']
    commandlist[C_MEM]:=['MEM',0,1,'Adr',0,'Distribution AmigaE 2.1']
    commandlist[C_PSLIST]:=['PSLIST',0,1,'',0,'NasGûl']
    commandlist[C_PCDIR]:=['PCDIR',0,1,'Dir,Dirs/S,Files/S,All/S,NoIcon/S,To/K',0,'NasGûl']
    commandlist[C_QHELP]:=['QHELP',0,1,'',0,'NasGûl']
    commandlist[C_RESET]:=['RESET',0,0,'',0,'NasGûl']
    commandlist[C_SYSLIST]:=['SYSLIST',0,1,'T=Task/S,L=Library/S,D=Device/S,P=Port/S,W=Window/S,M=Memory/S',0,'NasGûl']
    commandlist[C_SETCOM]:=['SETCOM',0,1,'Fichier,C=Commentaire/K,Files/S,Dirs/S,All/S',0,'NasGûl']
ENDPROC
/**/
/*"lookinternalcommand(s)"*/
PROC lookinternalcommand(s,is) HANDLE
    DEF ret=FALSE,i,cn:PTR TO ecom,test,cs[80]:STRING
    IF StrCmp('\n',s,1) 
        updateprompt(0)
        ret:=TRUE;JUMP internalend
    ENDIF
    FOR i:=0 TO MAX_COMMAND-1
        cn:=commandlist[i]
        StrCopy(cs,cn.name,ALL)
        IF test:=StrCmp(cs,s,EstrLen(cs))
            SELECT i
                CASE C_ASS
                    ass(is)
                    ret:=TRUE;JUMP internalend
                CASE C_CHANGEDPS
                    changedps(is)
                    ret:=TRUE;JUMP internalend
                CASE C_CD
                    cd(is)
                    ret:=TRUE;JUMP internalend
                CASE C_DELAY
                    delay(is)
                    ret:=TRUE;JUMP internalend
                CASE C_DEL
                    del(is)
                    ret:=TRUE;JUMP internalend
                CASE C_D
                    IF Not(StrCmp('DIR',s,3))   /* For AmigaDos Dir Command */
                        d(is)
                        ret:=TRUE;JUMP internalend
                    ENDIF
                CASE C_EXECUTE
                    NOP
                CASE C_FULLSIZE
                    fullsize(is)
                    ret:=TRUE;JUMP internalend
                CASE C_LISTCOM
                    listcom()
                    ret:=TRUE;JUMP internalend
                CASE C_MDIR
                    mdir(is)
                    ret:=TRUE;JUMP internalend
                CASE C_MEM
                    mem(is)
                    ret:=TRUE;JUMP internalend
                CASE C_PSLIST
                    pslist()
                    ret:=TRUE;JUMP internalend
                CASE C_PCDIR
                    pcdir(is)
                    ret:=TRUE;JUMP internalend
                CASE C_QHELP
                    qhelp()
                    ret:=TRUE;JUMP internalend
                CASE C_RESET
                    reset()
                    ret:=TRUE;JUMP internalend
                CASE C_SYSLIST
                    syslist(is)
                    ret:=TRUE;JUMP internalend
                CASE C_SETCOM
                    setcom(is)
                    ret:=TRUE;JUMP internalend
            ENDSELECT
        ENDIF
    ENDFOR
    internalend:
EXCEPT
    IF exception<>0 THEN ret:=TRUE
    PrintFault(exception,NIL)
    /*WriteF('>> \s\n',Fault(exception))*/
ENDPROC ret
/**/

