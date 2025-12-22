->> EDEVHEADER
/*= © NasGûl =========================
 ESOURCE EGSFileRequester.e
 EDIR    Workbench:AmigaE/Sources/EGS
 ECOPT   ERRLINE
 EXENAME EGSFileRequester
 MAKE    EC
 AUTHOR  NasGûl
 TYPE    EXEDOS
 =====================================*/
-><
->> ©/DISTRIBUTION/UTILISATION
/*=====================================

 - TOUTE UTILISATION COMMERCIALE DES CES SOURCES EST
   INTERDITE SANS MON AUTORISATION.

 - TOUTE DISTRIBUTION DOIT ETRE FAITES EN TOTALITE (EXECUTABLES/MODULES E/SOURCES E).

 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 !! TOUTE INCLUSION SUR UN CD-ROM EST INTERDITE SANS MON AUTORISATION.!!
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

=====================================*/
-><
->> MODULES
MODULE '*pragmas/egs_pragmas'
MODULE '*pragmas/egsintui_pragmas'
MODULE '*pragmas/egsgfx_pragmas'
MODULE '*pragmas/egslayers_pragmas'
MODULE '*pragmas/egsrequest_pragmas'


MODULE '*egs','*egsintui','*egsrequest','*EGSlib'

-><
->> DEFINITINS GLOBALES
DEF s_title[256]:STRING
DEF s_path[256]:STRING
DEF s_pat[256]:STRING
DEF s_file[256]:STRING
DEF exitvalue=0
-><
->> main()
PROC main()
    DEF liber
    DEF args=NIL,myargs:PTR TO LONG
    VOID '$VER: EGSFileRequester 0.1 (24.1.96) © NasGûl'
    myargs:=[0,0,0]
    IF args:=ReadArgs('Drawer,File/K,Pattern/K',myargs,NIL)
        IF myargs[0] THEN StrCopy(s_path,myargs[0],ALL)
        IF myargs[1] THEN StrCopy(s_file,myargs[1],ALL)
        IF myargs[2] THEN StrCopy(s_pat,myargs[2],ALL)
        liber:=openEGSLibraries()
        IF liber=-1
            fileReqEGS()
            closeEGSLibraries()
        ENDIF
        FreeArgs(args)
    ENDIF
    CleanUp(exitvalue)
ENDPROC
-><
->> fileReqEGS()
PROC fileReqEGS()
    DEF freq:PTR TO erfilerequest
    DEF cmd[256]:STRING,r
    IF freq:=Er_CreateFileReq(NIL)
        Er_PutValuesInFileReq(freq,s_file,s_path,s_pat)
        r:=Er_DoRequest(freq)
        IF r=-1
            StringF(cmd,'\s',freq.path)
            AddPart(cmd,freq.name,256)
            WriteF('\s',cmd)
        ELSE
            exitvalue:=5
        ENDIF
    ENDIF
ENDPROC
-><

