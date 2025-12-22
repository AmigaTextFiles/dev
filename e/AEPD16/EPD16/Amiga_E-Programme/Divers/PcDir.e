/*============================================
 = PcDir v0.0 © 1994 NasGûl
 ============================================*/
MODULE 'dos/dos'
CONST ESC="\e["
CONST NOIR="0m"
DEF firstdir[80]:STRING
DEF dironly=FALSE
DEF dirall=FALSE
PROC main() /*"main()"*/
    DEF myargs:PTR TO LONG,rdargs=NIL
    myargs:=[0,0,0]
    IF rdargs:=ReadArgs('Dir,Dirs/S,All/S',myargs,NIL)
        IF myargs[0] THEN StrCopy(firstdir,myargs[0],ALL) ELSE StrCopy(firstdir,'',ALL)
        IF myargs[1] THEN dironly:=TRUE
        IF myargs[2] THEN dirall:=TRUE
        WriteF('PcDir v0.0 © 1994 NasGûl\n\s\n',firstdir)
        p_LookDir(firstdir)
        IF rdargs THEN FreeArgs(rdargs)
    ELSE
        WriteF('BadArgs !!.\n')
    ENDIF
ENDPROC
PROC p_LookDir(curdir) /*"p_LookDir(curdir)"*/
    DEF info:fileinfoblock,lock
    DEF currentdir[256]:STRING,pv[256]:STRING
    DEF filepiv[256]:STRING
    DEF tabnum,bb,break=FALSE
    IF lock:=Lock(curdir,-2)
        NameFromLock(lock,currentdir,256)
        AddPart(currentdir,'',256)
        IF Examine(lock,info)
            IF info.direntrytype>0
                WHILE ExNext(lock,info)
                    IF CtrlC() THEN break:=TRUE
                    IF info.direntrytype>0
                        StringF(pv,'\s\s',currentdir,info.filename)
                        tabnum:=p_GetNumSlash(pv)
                        FOR bb:=0 TO tabnum-1
                            WriteF('\e[33m|   \e[0m')
                        ENDFOR
                        WriteF('\e[33m|---\e[0m')
                        WriteF('\e[32m\s\e[0m\n',info.filename)
                        IF CtrlC() THEN break:=TRUE
                        IF dirall=TRUE THEN p_LookDir(pv)
                    ELSE
                        IF dironly=FALSE
                            StringF(filepiv,'\s\s',currentdir,info.filename)
                            tabnum:=p_GetNumSlash(filepiv)
                            FOR bb:=0 TO tabnum-1
                                WriteF('\e[33m|   \e[0m')
                            ENDFOR
                            WriteF('\e[33m|---\e[0m')
                            WriteF('\s\n',info.filename)
                        ENDIF
                        IF CtrlC() THEN break:=TRUE
                    ENDIF
                ENDWHILE
            ELSE
            ENDIF
        ENDIF
        IF lock THEN UnLock(lock)
    ELSE
        WriteF('What ?!?\n')
    ENDIF
    IF break
        IF lock THEN UnLock(lock)
        CleanUp(0)
    ENDIF
ENDPROC
PROC p_GetNumSlash(str) /*"p_GetNumSlash(str)"*/
    DEF b,s=0
    DEF carac[1]:STRING
    FOR b:=0 TO StrLen(str)-1
        MidStr(carac,str,b,1)
        IF Char(carac)=$2F THEN INC s
    ENDFOR
ENDPROC s
