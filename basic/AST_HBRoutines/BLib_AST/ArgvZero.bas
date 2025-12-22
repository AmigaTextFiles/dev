' ---------------------------------------------------------------------------------------

REM ** $VER: ArgvZero.bas 1.1 (06.02.2009) by AmiSpaTra

REM ** AllocMem&, FreeMem
' LIBRARY OPEN "exec.library"
REM ** GetProgramName& (v36)
' LIBRARY OPEN "dos.library", 36

' REM $include exec.bh
' REM $include dos.bh

REM $NOBREAK
REM $NOEVENT

REM *************************************************************************

FUNCTION ArgvZero$()
  LOCAL buf&, long&

	' Hipótesis inicial
	' Initial hypothesis
	' ------------------
	ArgvZero$ = ""

	' ---------------------------------------------------------------
	'   Tamaño de tampón arbitrario (hasta el AmigaOS 3.9 el nombre
	'   de un fichero parece que podría alcanzar los 107 caracteres,
	'              según la estructura FileInfoBlock).
	' ---------------------------------------------------------------
	'  Arbitrary buffer size (under AmigaOS 3.9 the filename lenght
	'      would be 107 chars -see the FileInfoBlock struct-)
	' ---------------------------------------------------------------
	long&     = 1024&

	buf& = AllocMem&(long&, MEMF_CLEAR& OR MEMF_ANY&)

	IF buf& THEN

		'  Esta función solo funciona con programas invocados desde el Shell
		' This function only works when the program was started from the Shell
		' --------------------------------------------------------------------
		IF GetProgramName&(buf&, long&) THEN

			ArgvZero$ = PEEK$(buf&)

		END IF

		FreeMem& buf&, long&

	END IF

END FUNCTION


' ---------------------------------------------------------------------------------------
