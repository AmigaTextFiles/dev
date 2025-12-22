leteCxObjAll(broker)
    IF ttypes THEN argArrayDone()
    IF brokerPort THEN deletePortSafely(brokerPort)
    IF utilitybase THEN CloseLibrary(utilitybase)
    IF cxbase THEN CloseLibrary(cxbase)
    IF iconbase THEN CloseLibrary(iconbase)
    IF xpkbase THEN CloseLibrary(xpkbase)
    IF aslbase THEN CloseLibrary(aslbase)
    IF exception>1 THEN report_exception()
ENDPROC

PROC opengui()
    IF gh THEN RETURN
    gh:=guiinit('PsiloPlayer',  [ROWS,
 