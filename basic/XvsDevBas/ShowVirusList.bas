' *********************************************************************
'                   ShowVirusList.bas 1.0 (2.6.02)
'                 Dámaso D. Estévez <ast_dde@yahoo.es>
'                        All Rights Reserved
'
'              AmiSpaTra - http://www.arrakis.es/~amidde/
'
'          Little demo for to see how to use the XVS library
'          Pequeña demostración del uso de la biblioteca XVS
' *********************************************************************

REM $NOWINDOW
REM $NOLIBRARY

REM $include xvs.bh
REM $include exec.bc

'      Subroutine for to print an entry (node name -> virus name)
'
'                  Subrutina para imprimir una entrada
'                 (nombre del nodo -> nombre del virus)
' ---------------------------------------------------------------------

FUNCTION PrtVir&(vlist&,type$)
LOCAL ptr&

	IF vlist& <> NULL& THEN

		PRINT PEEKW(vlist&+xvsvl_Count%);" ";type$;" virus recognized...";CHR$(10)

		ptr& = vlist&+lh_Head%
	
		WHILE PEEKL(ptr&) <> NULL&
			PRINT PEEK$(PEEKL(PEEKL(ptr&)+ln_Name%))
			ptr& = PEEKL(ptr&)+ln_Succ%
		WEND

		xvsFreeVirusList(vlist&)

		PrtVir& = NULL&

	END IF

END FUNCTION

'                        Main code / Código principal
' ---------------------------------------------------------------------

LIBRARY OPEN "xvs.library",XVS_VERSION&

PRINT
PRINT "Little XVS demo #2 :)"
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

	' For to release the xvsVirusList struct
	'   if the user breaks this program ;)
	'
	' Para liberar la estructura xvsVirusList
	' si elusuario interrumpe el programa ;)
	' ---------------------------------------
	ON BREAK GOTO BrkRoutine

	vlist& = NULL&

	vlist& = xvsCreateVirusList(XVSLIST_BOOTVIRUSES&)
	vlist& = PrtVir&(vlist&,"boot")
	
	vlist& = xvsCreateVirusList(XVSLIST_FILEVIRUSES&)
	vlist& = PrtVir&(vlist&,"file")

	vlist& = xvsCreateVirusList(XVSLIST_LINKVIRUSES&)
	vlist& = PrtVir&(vlist&,"link")
		
	vlist& = xvsCreateVirusList(XVSLIST_DATAVIRUSES&)
	vlist& = PrtVir&(vlist&,"data")
	
	BrkRoutine:
	IF vlist& <> NULL& THEN xvsFreeVirusList(vlist&)

END IF

LIBRARY CLOSE "xvs.library"

END
