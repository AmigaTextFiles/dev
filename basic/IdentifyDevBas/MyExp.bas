' *********************************************************************
'         MYEXP © 1997 by Richard Körber -- All Rights Reserved
'
'                        C to HBASIC conversion
'               by Dámaso D. Estévez [amidde,arrakis,es]
' *********************************************************************

REM $NOLIBRARY

REM $include dos.bh
REM $include exec.bh
REM $include identify.bh
REM $include expansion.bc

LIBRARY OPEN "identify.library",6&
LIBRARY OPEN "dos.library",LIBRARY_MINIMUM&
LIBRARY OPEN "exec.library",LIBRARY_MINIMUM&

	DIM tags&(5)
	tmp$ = ""

	expans&  = NULL&

	counter% = 0%
	size&    = 0&
	unit$    = ""

	REM ******** A method for create easily a buffer filled with zeroes *******
	REM ************ (but, beware with the Basic garbage collector!) **********
	REM ***********************************************************************
	REM ************** Un método para crear fácilmente una zona ***************
	REM ********** de memoria intermedia (buffer) rellena de ceros ************
	REM **** (pero, ¡tenga cuidado con el recolector de basura del Basic!) ****
	REM ***********************************************************************
	manuf$  = STRING$(IDENTIFYBUFLEN&,CHR$(0))
	prod$   = STRING$(IDENTIFYBUFLEN&,CHR$(0))
	pclass$ = STRING$(IDENTIFYBUFLEN&,CHR$(0))

	REM **************** A method for to create a structure *******************
	REM *********** (the variable contains the initial address) ***************
	REM ***********************************************************************
	REM *************** Un método para crear una estructura *******************
	REM ******* (la variable contiene la dirección donde comienza ésta) *******
	REM ***********************************************************************
	expans& = AllocMem&(ConfigDev_sizeof%,MEMF_PUBLIC& OR MEMF_CLEAR&)

	IF expans& <> NULL& THEN

		PRINT "Nr Address  Size Description"
		PRINT "----------------------------------------------------------"

		TAGLIST VARPTR(tags&(0)), _
			IDTAG_ManufStr& ,SADD(manuf$), _
			IDTAG_ProdStr&  ,SADD(prod$), _
			IDTAG_ClassStr& ,SADD(pclass$), _
			IDTAG_Expansion&,expans&, _
			TAG_DONE&

		WHILE IdExpansion&(VARPTR(tags&(0))) = NULL&

			unit$ = "K"                                       ' KBytes
			size& = PEEKL(PEEKL(expans&)+cd_BoardSize%) >> 10 ' Bytes -> KBytes
			IF size& >= 1024 THEN
				unit$ = "M"                                     ' MBytes
				size& = size& >> 10                             ' KBytes -> MBytes
			END IF


			REM ** The library generate C strings style: for to print with PRINT, **
			REM **** the strings are cut AND the CHR$(0) terminator is deleted *****
			REM ********************************************************************
			REM ** La biblioteca genera cadenas al estilo del C: para imprimirlas **
			REM ************* con el comando PRINT deben ser recortadas ************
			REM ************ y eliminado el terminador de cadena CHR$(0) ***********
			REM ********************************************************************
			manuf$  = LEFT$(manuf$,INSTR(1,manuf$,CHR$(0))-1)
			prod$   = LEFT$(prod$,INSTR(1,prod$,CHR$(0))-1)
			pclass$ = LEFT$(pclass$,INSTR(1,pclass$,CHR$(0))-1)

			INCR counter%
			PRINT USING "##";counter%;
			PRINT CHR$(32);

			REM **** With theses two lines, the program prints the hexadecimal ****
			REM ****** address with eight digits always (filled with zeroes) ******
			REM *******************************************************************
			REM ******* Con estas dos líneas, el programa imprime siempre *********
			REM ************** la dirección de memoria hexadecimal ****************
			REM ************* con ocho dígitos (la rellena con ceros) *************
			REM *******************************************************************
			tmp$=HEX$(PEEKL(PEEKL(expans&)+cd_BoardAddr%))
			PRINT LEFT$(STRING$(8,CHR$(48)),8-LEN(tmp$));tmp$;

			PRINT CHR$(32);
			PRINT USING "###";size&;
			PRINT unit$;CHR$(32);manuf$;CHR$(32);prod$;CHR$(32);"(";pclass$;")"

		WEND

		FreeMem& expans&,ConfigDev_sizeof%

	END IF

LIBRARY CLOSE

END
