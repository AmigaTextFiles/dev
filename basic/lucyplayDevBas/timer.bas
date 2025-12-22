' *********************************************************************
'                         `Timer.bas' example based
'               over the C example wrote by Oliver Gantert
'
'              Ejemplo `Timer.bas' basado en la versión en C
'                      escrita por Olivert Gantert
'
'                  C to HBASIC conversion 1.0 (10.4.03)
'                by Dámaso D. Estévez <amidde@arrakis.es>
'               AmiSpaTra - http://www.arrakis.es/~amidde/
' *********************************************************************

REM $include timer.bc        ' timeval struct / estructura timeval
REM $include lucyplay.bh

' =====================================================================
'                    Global vars / Variables globales
' =====================================================================

lpb&    = NULL&              ' LucyPlayBase
bool&   = NULL&
dummy&  = NULL&

'   timeval struct
' Estructura timeval
' ------------------
tv$      = STRING$(timeval_sizeof%,CHR$(0))

' =====================================================================
'                    The main code / El código principal
' =====================================================================

'    Timer functions available only from v5
' Funciones de temporización desde la versión 5
' ---------------------------------------------
LIBRARY OPEN "lucyplay.library",5&

PRINT "---------------------"
PRINT " `Timer.bas' example "
PRINT " Ejemplo `Timer.bas' "
PRINT "---------------------"
PRINT

bool& = lucTimerInit&

IF bool& THEN

	dummy& = lucGetSysTime&(SADD(tv$))

	PRINT "SysTime:";
	PRINT PEEKL(SADD(tv$)+tv_secs%);"s";
	PRINT PEEKL(SADD(tv$)+tv_micro%);"µs."
	PRINT

	PRINT "TimeDelay/Espera de 10 s."
	PRINT

	POKEL (SADD(tv$)+tv_secs%), 10&
	POKEL (SADD(tv$)+tv_micro%),  0&
	dummy& = lucTimeDelay&(SADD(tv$))

	dummy& = lucGetSysTime&(SADD(tv$))

	PRINT "SysTime:";
	PRINT PEEKL(SADD(tv$)+tv_secs%);"s";
	PRINT PEEKL(SADD(tv$)+tv_micro%);"µs."
	PRINT

	lucTimerKill

END IF

LIBRARY CLOSE

END
