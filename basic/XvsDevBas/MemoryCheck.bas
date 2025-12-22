' *********************************************************************
'                     MemoryCheck.bas 1.0 (2.6.02)
'                 Dámaso D. Estévez <ast_dde@yahoo.es>
'                        All Rights Reserved
'
'              AmiSpaTra - http://www.arrakis.es/~amidde/
'
'          Little demo for to see how to use the XVS library
'          Pequeña demostración del uso de la biblioteca XVS
' *********************************************************************

REM $NOLIBRARY

REM $include xvs.bh
REM $include exec.bc

LIBRARY OPEN "xvs.library",XVS_VERSION&

PRINT
PRINT "Little XVS demo #1 :)"
PRINT

infected& = xvsSelfTest&()

IF infected& = NULL&

	PRINT "DANGER !!!"
	PRINT "The XVS library was modified/manipulated..."
	PRINT "the checking/removing virus isn´t reliable !!!"
	PRINT
	PRINT "¡¡¡ PELIGRO !!!"
	PRINT "¡¡¡ La biblioteca XVS ha sido modificada/manipulada..."
	PRINT "la verificación/eliminación de virus no es fiable !!!"

ELSE

	'        Reserve the XVS' structs only with this function!!!!
	' ¡¡¡Reserve las estructuras XVS necesarias sólo con esta función!!!
	' ------------------------------------------------------------------
	mi& = xvsAllocObject&(XVSOBJ_MEMORYINFO&)

	IF mi& <> NULL& THEN

		' Checking if there are virus in the memory
		'    Comprobando si hay virus en memoria
		' -----------------------------------------
		count& = xvsSurveyMemory&(mi&)

		IF count& = NULL& THEN

			PRINT "This XVS release didn´t found any virus at your system."
			PRINT "Esta versión de la biblioteca XVS no ha encontrado ningún virus en su sistema."

		ELSE

			PRINT count;" VIRUS FOUND !!"
			PRINT "Use a good antivirus program for to remove them !"
			PRINT
			PRINT "¡¡ ";count;" VIRUS ENCONTRADOS !!"
			PRINT "¡ Utilice un buen antivirus para eliminarlos !"

		END IF
		
	xvsFreeObject&(mi&)

	ELSE
	
		PRINT "Allocating XVSMemoryInfo struct failed !!!"

	END IF

END IF

LIBRARY CLOSE "xvs.library"

END
