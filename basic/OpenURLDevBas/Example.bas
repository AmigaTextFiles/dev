' *********************************************************************
'                    Example by Troels Walsted Hansen
'                    Ejemplo de Troels Walsted Hansen
'
'     C -> HBasic conversion and enhacing 1.0d (22/04/2011) done by
'  Conversión de C a Hisoft Basic y mejora 1.0d (22/04/2011) hecha por
'          Dámaso D. Estévez [correoamidde-aminet000,yahoo,es]
'
'          All Rights Reserved / Todos los derechos reservados
' *********************************************************************

OPTION BASE 1

REM $NOWINDOW

REM $include dos.bh
REM $include exec.bh
REM $include openurl.bh

LIBRARY OPEN "dos.library",36&
LIBRARY OPEN "exec.library",NULL&

' Version string / Cadena de versión
' ----------------------------------
strver$ = "$VER: (Pseudo)OpenURL 7.9.2 (23/04/2011) "+CHR$(0)

' Template string / Cadena de sintaxis
' ------------------------------------
strtpt$ = "URL,NOSHOW/S,NOFRONT/S,NOLAUNCH/S,NEWWIN/S,PUBSCREEN/K,INFOPREFS/S,LAUNCHPREFS/S"+CHR$(0)

' Simulating "enum" (C language) / Simulando "enum" del lenguaje C
' ----------------------------------------------------------------
A_URL%         = 1%
A_NOSHOW%      = 2%
A_NOFRONT%     = 3%
A_NOLAUNCH%    = 4%
A_NEWWIN%      = 5%
A_PUBSCREEN%   = 6%
A_INFOPREFS%   = 7%
A_LAUNCHPREFS% = 8%
A_MAX%         = 9% ' The last-the end / El último-el final

DIM args&(A_MAX%)

' Others vars / Otras variables
' -----------------------------
DIM tags&(12%)      ' Nº de etiquetas * 2 / # tags * 2

OpenURLBase& = NULL&
rda&         = NULL&
d&           = NULL&
ov&          = NULL&

' ---------------------------------------------------------------------

' Initial hypothesys / Hipótesis inicial
' --------------------------------------
retval& = RETURN_FAIL&

' Opening the library / Abriendo la biblioteca
' --------------------------------------------
OpenURLBase& = OpenLibrary&(SADD("openurl.library"+CHR$(0)),1&)

IF OpenURLBase& THEN

	' Saving the library version / Guardando la versión de la biblioteca
	' ------------------------------------------------------------------
	ov& = PEEKW(OpenURLBase&+lib_Version%)

	LIBRARY VARPTR "openurl.library",OpenURLBase&

	' Marking the end / Señalando el final
	' ------------------------------------
	args&(A_MAX%) = 0&

	rda& = ReadArgs&(SADD(strtpt$),VARPTR(args&(1)),NULL&)

	IF rda& THEN

		IF args&(A_INFOPREFS%) THEN

			IF ov& < 4 THEN

				PRINT "INFOPREFS requires openurl.library v4+"
				PRINT "INFOPREFS exige la versión 4.0+ de la biblioteca OpenURL"

			ELSE

				TAGLIST VARPTR(tags&(1)), _
				  URL_GetPrefs_Mode&, URL_GetPrefs_Mode_InUse%, _
				  TAG_DONE&

				' API 4.0+
				' --------
				d& = URL_GetPrefsA&(VARPTR(tags&(1)))

				IF d& THEN

					'              Info only with struct release 4 (internally can change)
					' Información sólo con la versión 4 de la estructura (podría cambiar en un futuro)
					' --------------------------------------------------------------------------------

					IF CLNG(PEEKB(d&)) = PREFS_VERSION& THEN

						PRINT "PREFS IN USE  / PREFERENCIAS EN USO"
						PRINT " * Launch?    / ¿Poner en marcha el navegador? ";

						IF PEEKL(d&+up_DefLaunch%) = 1 THEN
							PRINT "YES/SÍ";
						ELSE
							PRINT "NO";
						END IF

						PRINT

						PRINT " * Show?      / ¿Reabrir la interfaz?          ";

						IF PEEKL(d&+up_DefShow%) = 1 THEN
							PRINT "YES/SÍ";
						ELSE
							PRINT "NO";
						END IF

						PRINT

						PRINT " * ToFront?   / ¿Traer a primer plano?         ";

						IF PEEKL(d&+up_DefBringToFront%) = 1 THEN
							PRINT "YES/SÍ";
						ELSE
							PRINT "NO";
						END IF

						PRINT

						PRINT " * NewWindow? / ¿Abrir una nueva ventana?      ";

						IF PEEKL(d&+up_DefNewWindow%) = 1 THEN
							PRINT "YES/SÍ";
						ELSE
							PRINT "NO";
						END IF

						PRINT

					ELSE

						PRINT "This option works only if the struct is the v4, because this would be future changes"
						PRINT "Esta opción funciona sólo con la versión 4 de la estructura, pues podría cambiar en el futuro"

					END IF

				' Releasing the prefs / Liberando las preferencias
				' ------------------------------------------------
				URL_FreePrefsA d&,NULL&

				END IF
				
			END IF

		ELSE
		
			IF args&(A_LAUNCHPREFS%) THEN

				IF ov& < 3 THEN

					PRINT "LAUNCHPREFS requires openurl.library v3+"
					PRINT "LAUNCHPREFS exige la versión 3+ de la biblioteca OpenURL"

				ELSE

					IF ov& = 3 THEN

						' API pre 4.0
						' -----------
						d&  = URL_OldLaunchPrefsApp&

					ELSE

						' API 4.0+
						' --------
						d& = URL_LaunchPrefsAppA&(NULL&)

					END IF

				END IF

			ELSE

				IF args&(A_URL%) THEN

					TAGLIST VARPTR(tags&(1)), _
					  URL_Show&,         NOT(args&(A_NOSHOW%)), _
					  URL_BringToFront&, NOT(PEEKL(VARPTR(args&(A_NOFRONT%)))),_
					  URL_NewWindow&,    PEEKL(VARPTR(args&(A_NEWWIN%))), _
					  URL_Launch&,       NOT(PEEKL(VARPTR(args&(A_NOLAUNCH%)))), _
					  URL_PubScreenName&,PEEK$(args&(A_PUBSCREEN%)), _
					  TAG_DONE&

					d& = URL_OpenA&(args&(A_URL%),VARPTR(tags&(1)))

				ELSE

					PRINT "Either URL, LAUNCHPREFS or INFOPREFS must be specified"
					PRINT "Ha de especificarse el argumento URL, LAUNCHPREFS o INFOPREFS"

				END IF

			END IF

		END IF

		IF d& THEN retval& = RETURN_OK&

		FreeArgs rda&

	ELSE

		dummy& = PrintFault&(IoErr&,SADD("Failed to parse arguments / Fracaso en el procesado de argumentos"+CHR$(0)))

	END IF

	LIBRARY VARPTR "openurl.library",0&
	CloseLibrary OpenURLBase&

ELSE

	PRINT "Requires openurl.library v1+"
	PRINT "Se exige la versión 1+ de la biblioteca OpenURL"

END IF

LIBRARY CLOSE

STOP retval&

' ---------------------------------------------------------------------
