' *********************************************************************
'                 GotoAmiSpaTra.bas 1.0a (21/04/2011)
'         Dámaso D. Estévez [correoamidde-aminet000,yahoo,es]
'         All Rights Reserved / Todos los derechos reservados
'
'         AmiSpaTra - http://www.xente.mundo-r.com/amispatra/
'
'        Little demo for to see how to use the OpenURL library
'        Pequeña demostración del uso de la biblioteca OpenURL
' *********************************************************************

REM $include exec.bh
REM $include dos.bh
REM $include openurl.bh

' Opening the library / Abriendo la biblioteca
' --------------------------------------------
LIBRARY OPEN "openurl.library",OPENURLVER&

PRINT CHR$(10);"A very little demo / Pequeña demostración";CHR$(10);"-----------------------------------------";CHR$(10)

' My home page / Mi página
' ------------------------
hp$ = "http://www.xente.mundo-r.com/amispatra/"+CHR$(0)

ok& = URL_OpenA&(SADD(hp$),NULL&)

' Info about the job / Información sobre el trabajo
' -------------------------------------------------
IF ok& THEN
	PRINT "Calling your browser and showing the AmiSpaTra homepage :-) ..."
	PRINT "Invocando al navegador y mostrando la página AmiSpaTra :-)..."
ELSE
	PRINT "The URL_OpenA&() function has failed! / ¡La función URL_OpenA&() ha fracasado!"
END IF

' Closing the library / Cerrando la biblioteca
' --------------------------------------------
LIBRARY CLOSE

END
