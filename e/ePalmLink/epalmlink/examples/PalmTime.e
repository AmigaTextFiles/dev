MODULE 'palmlink','libraries/palmlink','utility', 'utility/tagitem'

DEF socket=NIL
DEF ignoreError=FALSE

PROC connect()
    DEF error, code

    IF (socket) THEN RETURN TRUE

    socket := Pl_OpenSocket([PLTAG_ErrorPtr, error, TAG_DONE])

    IF (socket)
        WriteF('Please press the HotSync button now\n')
        code := Pl_Accept(socket,0)
        RETURN code
    ELSE
        WriteF('** Socket error \d\n',error)
    ENDIF
ENDPROC FALSE

PROC disconnect()
  IF (socket=NIL) THEN RETURN
  DlP_AddSyncLogEntry(socket,'-- AMIGA made it possible --\n')
  DlP_EndOfSync(socket,0)
  Pl_CloseSocket(socket)
ENDPROC

PROC show()
    DEF ptime:dlp_SysTime

    NEW ptime

    IF (connect()=FALSE) THEN RETURN
    IF (DlP_OpenConduit(socket)=FALSE) THEN RETURN
    IF (DlP_GetSysTime(socket,ptime)=FALSE)
        WriteF('** Couldn''t get time\n')
        RETURN
    ENDIF
    WriteF('\d.\d.\d \d:\d:\d',ptime.day,ptime.month,ptime.year,ptime.hour,ptime.minute,ptime.second)
ENDPROC


PROC main()
    IF (utilitybase:=OpenLibrary('utility.library',36))
        IF (palmlinkbase:=OpenLibrary('palmlink.library',0))

            show()

            IF (socket)
                IF (Not(ignoreError) AND (Pl_LastError(socket)<>0))
                    WriteF('** Socket error code \d\n',Pl_LastError(socket))
                ENDIF
                disconnect()
            ENDIF
            CloseLibrary(palmlinkbase)
        ELSE
            WriteF('** Couldn''t open palmlink.library\n')
            CloseLibrary(utilitybase)
        ENDIF
    ELSE
        WriteF('** Couldn''t open utility.library\n')
    ENDIF
ENDPROC
