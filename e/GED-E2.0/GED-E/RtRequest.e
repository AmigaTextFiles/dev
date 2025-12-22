/* Sauve les noms complets ainsi que le chemin des fichiers choisis   */
/* par l'intermédaire du filerequester de la la reqtools.library dans */
/* les variables spécifiées.                                          */

    OPT OSVERSION=36

    MODULE 'dos/dos'
    MODULE 'reqtools','libraries/reqtools'
    MODULE 'utility/tagitem'
    MODULE 'intuition/screens','intuition/intuitionbase'

    ENUM MEM_ERROR=21,IO_ERROR,FIND_ERROR

    DEF file[108]:STRING,req:PTR TO rtfilerequester,efile[255]:STRING,
        epath[108]:STRING,path,bpath,filelist:PTR TO rtfilelist,
        fstruct:PTR TO rtfilelist,rdargs,cliarg:PTR TO LONG,fhandle,phandle,
        lock,ib:PTR TO intuitionbase

/*FOLDER "main()"*/
PROC main()
    cliarg:=[0,0,'Select files',0]
    IF (rdargs:=ReadArgs('FILESVAR/A,PATHVAR,TITLE/K,EXIST/S',cliarg,NIL))
        IF (reqtoolsbase:=OpenLibrary('reqtools.library',37))
            IF (req:=RtAllocRequestA(RT_FILEREQ,0))
                IF cliarg[1]
                    IF (phandle:=Open(cliarg[1],MODE_OLDFILE))
                        IF ReadStr(phandle,epath)<>-1 THEN RtChangeReqAttrA(req,[RTFI_DIR,epath,TAG_END])
                        Close(phandle) ; phandle:=0
                    ENDIF
                ENDIF
                ib:=intuitionbase
                IF (filelist:=RtFileRequestA(req,file,cliarg[2],[RTFI_FLAGS,FREQF_MULTISELECT,RT_SCREEN,ib.activescreen,TAG_DONE]))
                    fstruct:=filelist
                    path:=req.dir
                    IF cliarg[1]
                        IF (phandle:=Open(cliarg[1],MODE_NEWFILE))=0 THEN quit(IO_ERROR,cliarg[1])
                        IF Fputs(phandle,path) THEN quit(IO_ERROR,cliarg[1])
                    ENDIF
                    IF StrLen(path)
                        bpath:=TRUE
                        StrCopy(epath,path,ALL)
                        IF epath[EstrLen(epath)-1]<>$3A THEN StrAdd(epath,'/',ALL)
                    ENDIF
                    IF bpath THEN StrCopy(efile,epath,ALL)
                    StrAdd(efile,fstruct.name,ALL)
                    IF cliarg[3]
                        IF (lock:=Lock(efile,ACCESS_READ))=0
                            UnLock(lock)
                            quit(RETURN_WARN,NIL)
                        ELSE ; UnLock(lock)
                        ENDIF
                    ENDIF
                    WHILE (fstruct:=fstruct.next)<>0
                        StrAdd(efile,' ',ALL)
                        IF bpath THEN StrCopy(efile,epath,ALL)
                        StrAdd(efile,fstruct.name,ALL)
                    ENDWHILE
                    IF (fhandle:=Open(cliarg[0],MODE_NEWFILE))
                        IF Fputs(fhandle,efile) THEN quit(IO_ERROR,cliarg[0])
                    ELSE ; quit(IO_ERROR,NIL)
                    ENDIF
                ELSE ; quit(RETURN_WARN,NIL)
                ENDIF
            ELSE ; quit(MEM_ERROR,'RtAllocRequest()')
            ENDIF
        ELSE ; quit(FIND_ERROR,'reqtools.library!')
        ENDIF
    ELSE ; quit(IO_ERROR,NIL)
    ENDIF
    quit(RETURN_OK,NIL)
ENDPROC
/*FEND*/
CHAR '$VER: RtRequest 1.007 (26 Oct 1994) © BURGHARD Eric | WANABOSO/AGOA'

/*FOLDER "quit(err,obj)"*/
PROC quit(err,obj)
    DEF flt=0

    IF (err<>RETURN_OK) AND (err<>RETURN_WARN)
        SELECT err
            CASE IO_ERROR  ; flt:=IoErr()
            CASE MEM_ERROR ; flt:=ERROR_NO_FREE_STORE
            CASE FIND_ERROR; flt:=ERROR_OBJECT_NOT_FOUND
        ENDSELECT
        err:=RETURN_ERROR
        PrintFault(flt,obj)
    ENDIF
    IF rdargs THEN FreeArgs(rdargs)
    IF fhandle THEN Close(fhandle)
    IF phandle THEN Close(phandle)
    IF req THEN RtFreeRequest(req)
    IF filelist THEN RtFreeFileList(filelist)
    CleanUp(err)
ENDPROC
/*FEND*/

