OPT PREPROCESS

MODULE '*app','*cx','utility/tagitem','amigalib/cx','amigalib/lists',
       'commodities','libraries/commodities'

DEF done=FALSE
DEF app:PTR TO application

PROC main()
    DEF type,id

    NEW app.application('TestCx',[APPT_CX,TRUE,
                                  APPT_CXTAGS,[CXT_TITLE,'TextCx 00.11 © Aris Basic',
                                               CXT_CXNAME,'TestCx',
                                               CXT_DESCRIPTION,'Small Test Commodity',
                                               CXT_HOTKEYS,['lalt u',10,{key_1},
                                                            'lalt t',11,{key_2},
                                                             NIL,NIL],
                                               CXT_CMDFUNCS,[CXF_ENABLE,{enable},
                                                             CXF_DISABLE,{disable},
                                                             CXF_UNIQUE,{unique},
                                                             NIL,NIL],
                                               CXT_UNIQUE,CXC_UNQNOTIFY],
                                  TAG_DONE])
    IF app.error
        IF app.error=CX_ERRDUP OR app.error=APP_DOUBLE
            PrintF('Double Running Tryed!!\n')
        ELSEIF app.error=CX_ERRSYS
            PrintF('No Memory or Other System Error!!\n')
        ELSE
            PrintF('Error \d\n',app.error)
            ENDIF
        END app
        CleanUp(5)
        RETURN
        ENDIF
    REPEAT
        type,id:=app.handleInput()
        IF type=APPI_CX AND id=CXCMD_KILL THEN done:=TRUE
        UNTIL done

    END app
    ENDPROC
PROC key_1()
    app.cx.removeHotkey('lalt t')
    PrintF('Key1\n')
    ENDPROC
PROC key_2()
    PrintF('Key2\n')
    ENDPROC
PROC enable()
    ActivateCxObj(app.CXBROKER,TRUE)
    ENDPROC
PROC disable()
    ActivateCxObj(app.CXBROKER,FALSE)
    ENDPROC
PROC unique()
    PrintF('Dont Start it Again\n')
    ENDPROC
PROC apear() IS 0

