OPT MODULE
OPT EXPORT
MODULE '*pragmas/egs_pragmas',         '*egs'
MODULE '*pragmas/egsblit_pragmas',     '*egsblit'
MODULE '*pragmas/egslayers_pragmas',   '*egslayers'
MODULE '*pragmas/egsgfx_pragmas',      '*egsgfx'
MODULE '*pragmas/egsintui_pragmas',      '*egsintui'
MODULE '*pragmas/egsgadbox_pragmas',   '*egsgadbox'
MODULE '*pragmas/egsrequest_pragmas',  '*egsrequest'
MODULE '*pragmas/gbmenuselect_pragmas','*egb/gbmenuselect'
MODULE '*pragmas/gbradio_pragmas',     '*egb/gbradio'
MODULE '*pragmas/gbscrollbox_pragmas', '*egb/gbscrollbox'
MODULE '*pragmas/gbselect_pragmas',    '*egb/gbselect'
MODULE '*pragmas/gbsets_pragmas',      '*egb/gbsets'
MODULE '*pragmas/gbtextinfo_pragmas',  '*egb/gbtextinfo'
->> openEGSLibraries() HANDLE
PROC openEGSLibraries() HANDLE

    IF (egsbase:=OpenLibrary('egs.library',0))=NIL THEN Raise(0)
    IF (egsblitbase:=OpenLibrary('egsblit.library',0))=NIL THEN Raise(0)
    IF (egslayersbase:=OpenLibrary('egslayers.library',0))=NIL THEN Raise(0)
    IF (egsgfxbase:=OpenLibrary('egsgfx.library',0))=NIL THEN Raise(0)
    IF (egsintuibase:=OpenLibrary('egsintui.library',0))=NIL THEN Raise(0)
    IF (egbbase:=OpenLibrary('egsgadbox.library',0))=NIL THEN Raise(0)
    IF (egsrequestbase:=OpenLibrary('egsrequest.library',0))=NIL THEN Raise(0)

    IF (egbmenuselectbase:=OpenLibrary('egb/gbmenuselect.library',0))=NIL THEN Raise(0)
    IF (egbradiobase:=OpenLibrary('egb/gbradio.library',0))=NIL THEN Raise(0)
    IF (egbscrollbase:=OpenLibrary('egb/gbscrollbox.library',0))=NIL THEN Raise(0)
    IF (egbselectbase:=OpenLibrary('egb/gbselect.library',0))=NIL THEN Raise(0)
    IF (egbsetbase:=OpenLibrary('egb/gbsets.library',0))=NIL THEN Raise(0)
    IF (egbtextinfobase:=OpenLibrary('egb/gbtextinfo.library',0))=NIL THEN Raise(0)

    Raise(-1)
EXCEPT
    IF exception<>-1
        closeEGSLibraries()
        RETURN 0
    ELSE
        RETURN exception
    ENDIF
ENDPROC
-><
->> closeEGSLibraries()
PROC closeEGSLibraries()
    IF egbtextinfobase THEN CloseLibrary(egbtextinfobase)
    IF egbsetbase THEN CloseLibrary(egbsetbase)
    IF egbselectbase THEN CloseLibrary(egbselectbase)
    IF egbscrollbase THEN CloseLibrary(egbscrollbase)
    IF egbradiobase THEN CloseLibrary(egbradiobase)
    IF egbmenuselectbase THEN CloseLibrary(egbmenuselectbase)

    IF egsrequestbase THEN CloseLibrary(egsrequestbase)
    IF egbbase THEN CloseLibrary(egbbase)
    IF egsintuibase THEN CloseLibrary(egsintuibase)
    IF egsgfxbase THEN CloseLibrary(egsgfxbase)
    IF egslayersbase THEN CloseLibrary(egslayersbase)
    IF egsblitbase THEN CloseLibrary(egsblitbase)
    IF egsbase THEN CloseLibrary(egsbase)
ENDPROC
-><




