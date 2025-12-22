' *********************************************************************
'               ZLibExample68.c - All rights reserved
'               (C) Copyright Michel 'DMX' Bagmeijer"
'         http://aminet.net/package/util/pack/zlibexample
'
'     Compare the C source code with Hisoft Basic source code! :)
'  ¡Compare el código fuente en C con la versión en Hisoft Basic! :)
'
'                     C to Hisoft Basic conversion
'        by Dámaso D. Estévez {correoamidde-aminet000,yahoo,es}
'         AmiSpaTra - http://www.xente.mundo-r.com/amispatra/
' *********************************************************************

REM $NOWINDOW
REM $NOBREAK

REM $include exec.bh
REM $include dos.bh
REM $include zlib.bh

'       Simulating "enum" C / Simulando las ennumeraciones del C
' ---------------------------------------------------------------------
CONST SRC%               = 0%
CONST DST%               = 1%
CONST UNP%               = 2%
CONST CHECK%             = 3%
CONST MAX%               = 4%

CONST NO_ERROR%          = 0%
CONST UNABLE_TO_EXAMINE% = 1%
CONST UNABLE_TO_OPEN%    = 2%
CONST NO_MEMORY%         = 3%
CONST IS_DIRECTORY%      = 4%
CONST UNABLE_TO_CREATE%  = 5%
CONST ERROR_WRITING%     = 6%
CONST ERROR_READING%     = 7%

' =====================================================================
'             Function FileLength / Función FileLength
' =====================================================================

FUNCTION FileLength&(file&)
	SHARED fsize&
 	LOCAL  fblock&, dateilock&, e&

	'         ERROR is HBasic's word reserved: changed for e&
	' ERROR es una palabra reservada por el HBasic: cambiada por e&
	' -------------------------------------------------------------
	e&      = NO_ERROR%

	fsize&  = NULL&

	fblock& = AllocVec&(FileInfoBlock_sizeof%,MEMF_CLEAR&)

	IF fblock& THEN

		dateilock& = Lock&(file&,ACCESS_READ&)

		IF dateilock& THEN

			IF Examine&(dateilock&,fblock&) THEN

				IF PEEKL(fblock&+fib_DirEntryType%) > 0 THEN

					e& = IS_DIRECTORY%

				ELSE

					fsize& = PEEKL(fblock&+fib_Size%)

				END IF

			ELSE

				e& = UNABLE_TO_EXAMINE%

			END IF

			UnLock dateilock&

		ELSE

			e& = UNABLE_TO_OPEN%

		END IF

		FreeVec fblock&

	ELSE

		e& = NO_MEMORY%

	END IF

	FileLength& = e&

END FUNCTION

' =====================================================================
'                     Main code... as subroutine
'              Why? Best variables and constants control
'                 (not defined generates an error ;)

'                Código principal... como subrutina :)
' ¿Porqué? Porque permite un mejor control de constantes y variables
'        no definidas (se genera un error)... permite detectar
'           rápidamente errores al teclearlas por ejemplo.
' =====================================================================

SUB Main
	SHARED fsize&
	LOCAL  args$, rda&, size&, inp&, out&, inbuffer&, handle&, e&, dummy&

	'                       Template / Sintaxis

	'        Changed the CHECK keyword for INFO, because using
	'   this didn't check if the file is compressed: show info about
	'    the file size like the file is compressed (always, because
	'              the library can't know if a data are
	'                 previoysly compressed or not).
	'
	' Cambiada la palabra clave CHECK por INFO, puesto que utilizándola
	'   no se comprobaba si el fichero estaba comprimido: sólo muestra
	'     información sobre el tamaño del fichero suponiendo que
	'     está comprimido (siempre, porque la biblioteca no sabe
	'      si los datos han sido comprimidos previamente o no).
	' ------------------------------------------------------------------
	args$ = "SRC/A,DST,DEC=DECOMPRESS/S,INFO/S"+CHR$(0)

	'                   Table of pointers for args
	'              Tabla de punteros para los argumentos
	' ------------------------------------------------------------------
	DIM fargs&(MAX%)

	'     Other vars -  INPUT, OUTPUT and ERROR are reserved words
	'  Otras variables - INPUT, OUTPUT y ERROR son palabras reservadas
	' ------------------------------------------------------------------
	inp&       = NULL&
	out&       = NULL&
	inbuffer&  = NULL&
	handle&    = NULL&
	e&         = NULL&     ' err
	rda&       = NULL&
	dummy&     = NULL&

	'             Reading the args / Leyendo los argumentos
	' ----------------------------------------------------------------
	rda& = ReadArgs&(SADD(args$),VARPTR(fargs&(0)),NULL&)

	IF rda&

		'               INFO argument / Argumento INFO
		' -------------------------------------------------------------
		IF fargs&(CHECK%) THEN

			handle& = GZ_Open&(fargs&(SRC%),MODE_OLDFILE&,0&,0&)

			IF handle& THEN

				size& = GZ_FileLength&(handle&)

				IF size& >0& THEN

					dummy& = GZ_Close&(handle&)

					PRINT "Unpacked file / Fichero descomprimido =";size&;"bytes / octetos."

				ELSE

					PRINT "Source file doesn't exists! / ¡El fichero fuente no existe!"

				END IF

			END IF

		END IF

		'    Without DEC y INFO args / Sin los argumentos DEC y INFO
		' ----------------------------------------------------------------

		IF (NOT fargs&(UNP%)) AND (NOT fargs&(CHECK%)) THEN

			'         User function / Función del usuario :)
			' --------------------------------------------------------
			e& = FileLength&(fargs&(SRC%))

			IF e& = NULL& AND fsize& > 0& THEN

				inbuffer& = AllocVec&(fsize&,MEMF_CLEAR& OR MEMF_PUBLIC&)

				IF inbuffer& THEN

					inp& = xOpen&(fargs&(SRC%),MODE_OLDFILE&)

					IF inp& THEN

						IF xRead&(inp&,inbuffer&,fsize&) <> -1 THEN

							handle& = GZ_Open&(fargs&(DST%),MODE_NEWFILE&,GZ_STRATEGY_FILTERED&,GZ_COMPRESS_BEST&)

							IF handle& THEN

								dummy& = GZ_Write&(handle&,inbuffer&,fsize&)
								dummy& = GZ_Close&(handle&)

								e&     = FileLength&(fargs&(DST%))
								IF e&  = NULL& THEN PRINT "Packed file / Fichero comprimido =";fsize&;"bytes / octetos."

							ELSE

								PRINT "Can't open the dest file! / ¡Imposible abrir el fichero de destino!"

							END IF

							dummy& = xClose&(inp&)

						ELSE

							PRINT "Can't read the file! / ¡Imposible leer el fichero!"

						END IF

					ELSE

						PRINT "Can't open the source file! / Imposible abrir el fichero fuente"

					END IF

					FreeVec& inbuffer&

				ELSE

					PRINT "No memory for inbuffer! / ¡Memoria insuficiente para el tampón de entrada!"

				END IF


			ELSE

				PRINT "Source file doesn't exists! / ¡El fichero fuente no existe!"

			END IF

		ELSE

			'      DEC argument / Argumento DEC (="descomprimir")
			' --------------------------------------------------------
			IF fargs&(UNP%) THEN

				handle& = GZ_Open&(fargs&(SRC%),MODE_OLDFILE&,0&,0&)

				IF handle& THEN

					size& = GZ_FileLength&(handle&)

					IF size& > 0 THEN

						inbuffer& = AllocVec&(size&,MEMF_CLEAR& OR MEMF_PUBLIC&)

						IF inbuffer& THEN

							IF GZ_Read&(handle&,inbuffer&,size&) THEN

								out& = xOpen&(fargs&(DST%),MODE_NEWFILE&)

								IF out& THEN

									dummy& = xWrite&(out&,inbuffer&,size&)

									dummy& = xClose&(out&)

									PRINT "Unpacked file / Fichero descomprimido =";size&;"bytes / octetos."

								ELSE

									PRINT "Can't open the dest file! / ¡Imposible abrir el fichero de destino!"

								END IF


							ELSE

								PRINT "Can't read the source file! / ¡Imposible leer el fichero fuente!"

							END IF

							FreeVec& inbuffer&

						ELSE

							PRINT "No memory for inbuffer! / ¡Memoria insuficiente para tampón de entrada!"

						END IF

					ELSE

						PRINT "Source file doesn't exist! / ¡El fichero fuente no existe!"

					END IF

					dummy& = GZ_Close(handle&)

				ELSE

					PRINT "Can't open the src file / Imposible abrir el fichero fuente"

				END IF

			END IF

		END IF

		FreeArgs rda&

	ELSE

		dummy& = PrintFault&(IoErr&(),SADD("ZLib_Example"+CHR$(0)))

	END IF

	LIBRARY CLOSE

END SUB
' =====================================================================
'                      Main code / Código principal
' =====================================================================

LIBRARY OPEN "exec.library"
LIBRARY OPEN "dos.library"
LIBRARY OPEN "zlib.library", 3&

CALL Main

'                  String version / Cadena de versión
' ---------------------------------------------------------------------
DATA "$VER: ZLib_Example 1.2d (18.06.2011) by  AmiSpaTra based over Michel 'DMX' Bagmeijer's C code "

END

