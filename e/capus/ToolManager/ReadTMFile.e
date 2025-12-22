/********************************************************************************
 * << AUTO HEADER XDME >>
 ********************************************************************************
 ED             "EDG"
 EC             "EC"
 PREPRO         "EPP"
 SOURCE         "ReadTMFile.e"
 EPPDEST        "RTM_EPP.e"
 EXEC           "ReadTM"
 ISOURCE        " "
 HSOURCE        " "
 ERROREC        " "
 ERROREPP       " "
 VERSION        "0"
 REVISION       "0"
 NAMEPRG        "ReadTM"
 NAMEAUTHOR     "NasGûl"
 ********************************************************************************
 * HISTORY :
 *******************************************************************************/

OPT OSVERSION=37

CONST DEBUG=TRUE

CONST BUFSIZE=65536,
      ID_PREF=$50524546,
      ID_TMEX=$544D4558,
      ID_TMIM=$544D494D,
      ID_TMSO=$544D534F,
      ID_TMMO=$544D4D4F,
      ID_TMIC=$544D4943,
      ID_TMDO=$544D444F,
      ID_TMAC=$544D4143



ENUM ER_NONE,ER_BADARGS,ER_NOTMFILE

MODULE 'tm'
PROC tm_ReadTMFile(source) /*"tm_ReadBINFile(source)"*/
    DEF len,a,adr,buf,handle,flen=TRUE,pos
    DEF chunk,long
    /*****************************************/
    /* Stockage du fichier source dans buf   */
    /*****************************************/
    IF (flen:=FileLength(source))=-1 THEN RETURN FALSE
    IF (buf:=New(flen+1))=NIL THEN RETURN FALSE
    IF (handle:=Open(source,1005))=NIL THEN RETURN FALSE
    len:=Read(handle,buf,flen)
    Close(handle)
    IF len<1 THEN RETURN FALSE
    adr:=buf
    chunk:=Long(adr)
    /*
    IF chunk<>ID_FORM
        WriteF('ce n\aest pas un fichier IFF.\n')
        Dispose(buf)
        RETURN FALSE
    ENDIF
    */
    /***********/
    /* Lecture */
    /***********/
    FOR a:=0 TO len-1
        pos:=adr++
        chunk:=Long(pos)
        SELECT chunk
            CASE ID_PREF
                WriteF('ID_PREF.\n')
            CASE ID_TMEX
                long:=Long(pos+4)
                WriteF('ID_TMEX. Longueur :\d\n',long)
                tm_ReadTMExec(pos+8)
            CASE ID_TMIM
                WriteF('ID_TMIM. Longueur :\d\n',long)
                tm_ReadTMImage(pos+8)
            CASE ID_TMSO
                WriteF('ID_TMSO.\n')
                tm_ReadTMSound(pos+8)
            CASE ID_TMMO
                WriteF('ID_TMMO.\n')
                tm_ReadTMMenu(pos+8)
            CASE ID_TMIC
                WriteF('ID_TMIC.\n')
                tm_ReadTMIcon(pos+8)
            CASE ID_TMDO
                WriteF('ID_TMDO.\n')
                tm_ReadTMDock(pos+8)
            CASE ID_TMAC
                WriteF('ID_TMAC.\n')
        ENDSELECT
    ENDFOR
    Dispose(buf)
ENDPROC
PROC tm_ReadTMExec(my_execp:PTR TO execprefsobject) /*"ReadTMExec(my_execp:PTR TO execprefsobject)"*/
    DEF buffer
    DEF pv[256]:STRING
    WriteF('StringBits:\d Flags:\d Delay:\d Stack:\d ExecType:\d Pri:\d\n',my_execp.stringbits,my_execp.flags,my_execp.delay,my_execp.stack,my_execp.exectype,my_execp.priority)
    buffer:=my_execp+20
    IF (my_execp.stringbits AND EXPO_NAME)
        StringF(pv,'\s',buffer)
        WriteF('EXPO_NAME :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_execp.stringbits AND EXPO_COMMAND)
        StringF(pv,'\s',buffer)
        WriteF('EXPO_COMMAND :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_execp.stringbits AND EXPO_CURDIR)
        StringF(pv,'\s',buffer)
        WriteF('EXPO_CURDIR :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_execp.stringbits AND EXPO_HOTKEY)
        StringF(pv,'\s',buffer)
        WriteF('EXPO_HOTKEY :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_execp.stringbits AND EXPO_OUTPUT)
        StringF(pv,'\s',buffer)
        WriteF('EXPO_OUTPUT :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_execp.stringbits AND EXPO_PATH)
        StringF(pv,'\s',buffer)
        WriteF('EXPO_PATH :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_execp.stringbits AND EXPO_PSCREEN)
        StringF(pv,'\s',buffer)
        WriteF('EXPO_PSCREEN :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_execp.flags AND EXPOF_ARGS) THEN NOP
    IF (my_execp.flags AND EXPOF_TOFRONT) THEN NOP
    WriteF('\n')
ENDPROC
PROC tm_ReadTMImage(my_imagep:PTR TO imageprefsobject) /*"ReadTMImage(my_imagep:PTR TO imageprefsobject)"*/
    DEF buffer
    DEF pv[256]:STRING
    WriteF('StringBits:\d ',my_imagep.stringbits)
    buffer:=my_imagep+4
    IF (my_imagep.stringbits AND IMPO_NAME)
        StringF(pv,'\s',buffer)
        WriteF('IMPO_NAME :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_imagep.stringbits AND IMPO_FILE)
        StringF(pv,'\s',buffer)
        WriteF('IMPO_FILE :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    WriteF('\n')
ENDPROC
PROC tm_ReadTMSound(my_soundp:PTR TO soundprefsobject) /*"ReadTMSound(my_soundp:PTR TO soundprefsobject)"*/
    DEF buffer
    DEF pv[256]:STRING
    WriteF('StringBits:\d ',my_soundp.stringbits)
    buffer:=my_soundp+4
    IF (my_soundp.stringbits AND SOPO_NAME)
        StringF(pv,'\s',buffer)
        WriteF('SOPO_NAME :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_soundp.stringbits AND SOPO_COMMAND)
        StringF(pv,'\s',buffer)
        WriteF('SOPO_COMMAND :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_soundp.stringbits AND SOPO_PORT)
        StringF(pv,'\s',buffer)
        WriteF('SOPO_COMMAND :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    WriteF('\n')
ENDPROC
PROC tm_ReadTMMenu(my_menup:PTR TO menuprefsobject) /*"ReadTMMenu(my_menup:PTR TO menuprefsobject)"*/
    DEF buffer
    DEF pv[256]:STRING
    WriteF('StringBits:\d ',my_menup.stringbits)
    buffer:=my_menup+4
    IF (my_menup.stringbits AND MOPO_NAME)
        StringF(pv,'\s',buffer)
        WriteF('MOPO_NAME :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_menup.stringbits AND MOPO_EXEC)
        StringF(pv,'\s',buffer)
        WriteF('MOPO_EXEC :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_menup.stringbits AND MOPO_SOUND)
        StringF(pv,'\s',buffer)
        WriteF('SOPO_COMMAND :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    WriteF('\n')
ENDPROC
PROC tm_ReadTMIcon(my_iconp:PTR TO iconprefsobject) /*"ReadTMIcon(my_iconp:PTR TO iconprefsobject)"*/
    DEF buffer
    DEF pv[256]:STRING
    WriteF('StringBits:\d Flags :\d ',my_iconp.stringbits,my_iconp.flags)
    buffer:=my_iconp+16
    IF (my_iconp.stringbits AND ICPO_NAME)
        StringF(pv,'\s',buffer)
        WriteF('ICPO_NAME :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_iconp.stringbits AND ICPO_EXEC)
        StringF(pv,'\s',buffer)
        WriteF('ICPO_EXEC :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_iconp.stringbits AND ICPO_IMAGE)
        StringF(pv,'\s',buffer)
        WriteF('ICPO_IMAGE :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_iconp.stringbits AND ICPO_SOUND)
        StringF(pv,'\s',buffer)
        WriteF('ICPO_SOUND :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_iconp.flags AND ICPOF_SHOWNAME) THEN NOP
    WriteF('\n')
ENDPROC
PROC tm_ReadTMDock(my_dockp:PTR TO dockprefsobject) /*"ReadTMDock(my_dockp:PTR TO dockprefsobject)"*/
    DEF buffer
    DEF pv[256]:STRING
    DEF tf
    DEF quit=FALSE
    WriteF('StringBits:\d Flags:\d Xpos:\d Ypos:\d Col:\d ',my_dockp.stringbits,my_dockp.flags,my_dockp.xpos,my_dockp.ypos,my_dockp.columns)
    buffer:=my_dockp+SIZEOF dockprefsobject
    IF (my_dockp.stringbits AND DOPO_NAME)
        StringF(pv,'\s',buffer)
        WriteF('DOPO_NAME :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_dockp.stringbits AND DOPO_HOTKEY)
        StringF(pv,'\s',buffer)
        WriteF('DOPO_HOTKEY :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_dockp.stringbits AND DOPO_PSCREEN)
        StringF(pv,'\s',buffer)
        WriteF('DOPO_PSCREEN :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_dockp.stringbits AND DOPO_TITLE)
        StringF(pv,'\s',buffer)
        WriteF('DOPO_TITLE :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    IF (my_dockp.stringbits AND DOPO_FONTNAME)
        StringF(pv,'\s',buffer)
        WriteF('DOPO_FONTNAME :\s ',pv)
        buffer:=buffer+EstrLen(pv)+1
    ENDIF
    REPEAT
        tf:=Char(buffer)
        IF (tf AND DOPOT_EXEC)
            StringF(pv,'\s',buffer)
            WriteF('DOPOT_EXEC :\s ',pv)
            buffer:=buffer+EstrLen(pv)+1
        ENDIF
        IF (tf AND DOPOT_IMAGE)
            StringF(pv,'\s',buffer)
            WriteF('DOPOT_IMAGE :\s ',pv)
            buffer:=buffer+EstrLen(pv)+1
        ENDIF
        IF (tf AND DOPOT_SOUND)
            StringF(pv,'\s',buffer)
            WriteF('DOPOT_SOUND :\s ',pv)
            buffer:=buffer+EstrLen(pv)+1
        ENDIF
    UNTIL tf=0
    IF (my_dockp.flags AND DOPOF_ACTIVATED) THEN WriteF('DOPOF_ACTIVATED ')
    IF (my_dockp.flags AND DOPOF_CENTERED) THEN WriteF('DOPOF_CENTERED ')
    IF (my_dockp.flags AND DOPOF_FRONTMOST) THEN WriteF('DOPOF_FRONTMOST ')
    IF (my_dockp.flags AND DOPOF_MENU) THEN WriteF('DOPOF_MENU ')
    IF (my_dockp.flags AND DOPOF_PATTERN) THEN WriteF('DOPOF_PATTERN ')
    IF (my_dockp.flags AND DOPOF_POPUP) THEN WriteF('DOPOF_POPUP ')
    IF (my_dockp.flags AND DOPOF_TEXT) THEN WriteF('DOPOF_TEXT ')
    IF (my_dockp.flags AND DOPOF_VERTICAL) THEN WriteF('DOPOF_VERTICAL ')
    IF (my_dockp.flags AND DOPOF_BACKDROP) THEN WriteF('DOPOF_BACKDROP ')
    IF (my_dockp.flags AND DOPOF_STICKY) THEN WriteF('DOPOF_STICKY ')
    WriteF('\n')
ENDPROC
PROC main() HANDLE /*"main()"*/
    tm_ReadTMFile(arg)
    Raise(ER_NONE)
EXCEPT
ENDPROC
