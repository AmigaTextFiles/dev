' *********************************************************************
'                     `BestMode.bas' example based
'              over the C example wroter by Oliver Gantert
'
'           Ejemplo `BestMode.bas' basado en la versión en C
'                      escrita por Olivert Gantert
'
'                  C to HBASIC conversion 1.0 (24.8.00)
'                by Dámaso D. Estévez <amidde@arrakis.es>
'               AmiSpaTra - http://www.arrakis.es/~amidde/
' *********************************************************************

REM $include graphics.bc    ' INVALID_ID& (tag/etiqueta)
REM $include lucyplay.bh

' =====================================================================
'                    Global vars / Variables globales
' =====================================================================

lpb&    = NULL&             ' LucyPlayBase

'     LucyPlayJoystick struct pointer
' Puntero a la estructura LucyPlayJoystick
' ----------------------------------------
j&      = NULL&

ModeID& = NULL&

' =====================================================================
'                    The main code / El código principal
' =====================================================================

'        The function lucBestModeID& requires v2+
' La función lucBestModeID& requiere versión 2 o superior
' -------------------------------------------------------
LIBRARY OPEN "lucyplay.library",2&

PRINT "----------------------"
PRINT "`BestMode.bas' example"
PRINT "Ejemplo `BestMode.bas'"
PRINT "----------------------"
PRINT

ModeID& = lucBestModeID&(640&,480&,8&)

IF ModeID& <> INVALID_ID& THEN
	PRINT "ModeID/Identificador del modo: 0x";HEX$(ModeID&)
ELSE
	PRINT "[ENGLISH] No valid screenmode found."
	PRINT "[ESPAÑOL] Modo de pantalla válido no encontrado."
END IF

LIBRARY CLOSE "lucyplay.library"

END
