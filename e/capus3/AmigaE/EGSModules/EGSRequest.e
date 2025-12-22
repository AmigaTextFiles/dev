->> EDEVHEADER
/*= © NasGûl =========================
 ESOURCE EGSRequest.e
 EDIR    Workbench:AmigaE/Sources/EGS
 ECOPT   ERRLINE
 EXENAME EGSRequest
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
DEF s_body[256]:STRING
DEF s_gad[256]:STRING
DEF exitvalue=0
-><
->> main()
PROC main()
    DEF liber
    DEF args=NIL,myargs:PTR TO LONG
    VOID '$VER: EGSRequest 0.1 (24.1.96) © NasGûl'
    myargs:=[0,0]
    IF args:=ReadArgs('Body,Gadgets/K',myargs,NIL)
        IF myargs[0] THEN StrCopy(s_body,myargs[0],ALL)
        IF myargs[1] THEN StrCopy(s_gad,myargs[1],ALL)
        liber:=openEGSLibraries()
        IF liber=-1
            reqEGS()
            closeEGSLibraries()
        ENDIF
        FreeArgs(args)
    ENDIF
    CleanUp(exitvalue)
ENDPROC
-><
->> reqEGS()
PROC reqEGS()
    DEF sreq:PTR TO ersimplerequest
    DEF cmd[256]:STRING,r
    IF sreq:=Er_CreateSimpleRequest(NIL,s_body,s_gad)
        r:=Er_DoRequest(sreq)
        IF r=-1
            exitvalue:=sreq.selected
        ELSE
            exitvalue:=20
        ENDIF
    ENDIF
ENDPROC
-><

