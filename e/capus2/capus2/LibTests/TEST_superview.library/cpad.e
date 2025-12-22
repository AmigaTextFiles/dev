
OBJECT controlpad
    entryname:LONG
    entrycontent:LONG
    nextentry:LONG
ENDOBJECT


MODULE 'superviewsupport'

PROC main()
    DEF pad:PTR TO controlpad
    DEF fpad:PTR TO controlpad
    DEF inimg=FALSE
    IF svsupportbase:=OpenLibrary('superviewsupport.library',0)
        IF SvSUP_LoadControlPad(arg,{pad})
            fpad:=pad
            WHILE pad
                    /*
                    IF StrCmp(pad.entryname,'IMAGE',5)
                        IF inimg=TRUE THEN JUMP error
                        inimg:=TRUE
                    ELSEIF StrCmp(pad.entryname,'NAME',4)
                        WriteF('>>>Name\n')
                    ELSEIF StrCmp(pad.entryname,'DELAY',5)
                        WriteF('>>>Delay\n')
                    ELSEIF StrCmp(pad.entryname,'ENDIMAGE',8)
                        inimg:=FALSE
                    ENDIF
                    */
                    IF pad.entrycontent THEN WriteF('\s=\s\n',pad.entryname,pad.entrycontent) ELSE WriteF('\s\n',pad.entryname)
                    pad:=pad.nextentry
            ENDWHILE
            error:
            SvSUP_FreeControlPad(fpad)
        ENDIF
        IF svsupportbase THEN CloseLibrary(svsupportbase)
    ENDIF
ENDPROC


