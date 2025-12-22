' *********************************************************************
'             xadLibInfo.c © 2002 SDI - All rights reserved
'                             v1.6 (07.08.02)
'
'                C to HBASIC conversion 1.0a (25.09.04)
'        by Dámaso D. Estévez {correoamidde-hbcoding,yahoo,es}
'              AmiSpaTra - http://www.arrakis.es/~amidde/
'
'
'         Shows informations about XAD clients (only from CLI).
'    Muestra información sobre los clientes XAD (sólo desde el CLI).
' *********************************************************************

REM $NOWINDOW
REM $NOLIBRARY
REM $NOBREAK

REM $include xadmaster.bh
REM $include exec.bc
REM $include dos.bc

ver$ = "$VER: xadLibInfo 1.6 (07.08.02) (Freeware) by Dirk Stöcker <stoecker@epost.de> - Hisoft Basic version by Dámaso D. Estévez"+CHR$(0)

' ---------------------------------------------------------------------

SUB PrtFlags(fl&,char$)

	IF fl& THEN
		PRINT ",";
	ELSE
		PRINT char$;
	END IF

END SUB

' ---------------------------------------------------------------------

SUB Start
	LOCAL char$,xc&,fl&
	LOCAL xadMasterBase&

	LIBRARY OPEN "xadmaster.library",1&

	ON BREAK GOTO Exiting

	xadMasterBase& = LIBRARY("xadmaster.library")

	xc& = xadGetClientInfo&

	PRINT CHR$(27);"[4m";
	PRINT "Clients of xadmaster.library ";
	PRINT LTRIM$(RTRIM$(STR$(PEEKW(xadMasterBase&+xmb_LibNode%+lib_Version%))));
	PRINT ".";LTRIM$(STR$(PEEKW(xadMasterBase&+xmb_LibNode%+lib_Revision%)));
	PRINT CHR$(27);"[0m"
	PRINT
	PRINT "Name                      |  ID  | MV |  VER  | Flags"
	PRINT "--------------------------+------+----+-------+------------------------------"

	DO WHILE xc&

		' First phase
		' Primera fase
		' ------------
		char$ = ""

		fl& = PEEKL(xc&+xc_Flags%)

		PRINT USING "\                        \";PEEK$(PEEKL(xc&+xc_ArchiverName%));
		PRINT ;"| ";

		IF PEEKL(xc&+xc_Identifier%) THEN
			PRINT USING "####";PEEKL(xc&+xc_Identifier%);
			PRINT " | ";
		ELSE
			PRINT "----";" | ";
		END IF

		PRINT USING "##";PEEKW(xc&+xc_MasterVersion%);
		PRINT " |  ";
		PRINT LTRIM$(RTRIM$(STR$(PEEKW(xc&+xc_ClientVersion%))));
		PRINT ".";
		PRINT LTRIM$(RTRIM$(STR$(PEEKW(xc&+xc_ClientRevision%))));
		IF PEEKW(xc&+xc_ClientVersion%) >= 100 THEN
			PRINT "";
		ELSE
			IF PEEKW(xc&+xc_ClientRevision%) >= 10 THEN
				PRINT " ";
			ELSE
				PRINT "  ";
			END IF
		END IF
		PRINT "| ";

		IF (fl& AND XADCF_FILEARCHIVER&) THEN
			fl& = fl& AND (NOT XADCF_FILEARCHIVER&)
			PRINT "FILE";
			PrtFlags fl&,char$
		END IF

		IF (fl& AND XADCF_DISKARCHIVER&) THEN
			fl& = fl& AND (NOT XADCF_DISKARCHIVER&)
			PRINT "DISK";
			PrtFlags fl&,char$
		END IF

		IF (fl& AND XADCF_FILESYSTEM&) THEN
			fl& = fl& AND (NOT XADCF_FILESYSTEM&)
			PRINT "FILESYS";
			PrtFlags fl&,char$
		END IF

		IF (fl& AND XADCF_EXTERN&) THEN
			fl& = fl& AND (NOT XADCF_EXTERN&)
			PRINT "EXTERN";
			PrtFlags fl&,char$
		END IF

		IF (fl& AND XADCF_NOCHECKSIZE&) THEN
			fl& = fl& AND (NOT XADCF_NOCHECKSIZE&)
			PRINT "NOCHECKSIZE";
			PrtFlags fl&,char$
		END IF

		IF (fl& AND XADCF_DATACRUNCHER&) THEN
			fl& = fl& AND (NOT XADCF_DATACRUNCHER&)
			PRINT "DATACRUNCHER";
			PrtFlags fl&,char$
		END IF

		IF (fl& AND  XADCF_EXECRUNCHER&) THEN
			fl& = fl& AND (NOT  XADCF_EXECRUNCHER&)
			PRINT "EXECRUNCHER";
			PrtFlags fl&,char$
		END IF

		IF (fl& AND XADCF_ADDRESSCRUNCHER&) THEN
			fl& = fl& AND (NOT XADCF_ADDRESSCRUNCHER&)
			PRINT "ADDRESSCRUNCHER";
			PrtFlags fl&,char$
		END IF

		IF (fl& AND XADCF_LINKER&) THEN
			fl& = fl& AND (NOT XADCF_LINKER&)
			PRINT "LINKER";
			PrtFlags fl&,char$
		END IF

		fl& = fl& AND (XADCF_FREEFILEINFO& OR XADCF_FREEDISKINFO& OR XADCF_FREETEXTINFO& OR XADCF_FREESKIPINFO& OR XADCF_FREETEXTINFOTEXT& OR XADCF_FREESPECIALINFO& OR XADCF_FREEXADSTRINGS&)

		IF fl& THEN

			'  Second phase (FREE attribs)
			' Segunda fase (atributos FREE)
			' -----------------------------
			char$ = ")"

			PRINT "FREE(";
			IF (fl& AND XADCF_FREEFILEINFO&) THEN
				fl& = fl& AND (NOT XADCF_FREEFILEINFO&)
				PRINT "FI";
				PrtFlags fl&,char$
			END IF
			
			IF (fl& AND XADCF_FREEDISKINFO&) THEN
				fl& = fl& AND (NOT XADCF_FREEDISKINFO&)
				PRINT "DI";
				PrtFlags fl&,char$
			END IF

			IF (fl& AND XADCF_FREETEXTINFO&) THEN
				fl& = fl& AND (NOT XADCF_FREETEXTINFO&)
				PRINT "TI";
				PrtFlags fl&,char$
			END IF

			IF (fl& AND XADCF_FREESKIPINFO&) THEN
				fl& = fl& AND (NOT XADCF_FREESKIPINFO&)
				PRINT "SI";
				PrtFlags fl&,char$
			END IF

			IF (fl& AND XADCF_FREESPECIALINFO&) THEN
				fl& = fl& AND (NOT XADCF_FREESPECIALINFO&)
				PRINT "SP";
				PrtFlags fl&,char$
			END IF

			IF (fl& AND XADCF_FREEXADSTRINGS&) THEN
				fl& = fl& AND (NOT XADCF_FREEXADSTRINGS&)
				PRINT "STR";
				PrtFlags fl&,char$
			END IF

			IF (fl& AND XADCF_FREETEXTINFOTEXT&) THEN
				PRINT "TEXT)";
			END IF
			
		END IF

		'   End of printed line
		' Fin de la línea impresa
		' -----------------------
		PRINT

		'   Jumping to next
		' Santando al siguiente
		' ---------------------
		xc& = PEEKL(xc&+xc_Next%)

	LOOP

	Exiting:
		LIBRARY CLOSE "xadmaster.library"

END SUB

' ---------------------------------------------------------------------

' ------------------------
'   The main program ;)
' El programa principal ;)
' ------------------------

Inicio:

' Only from CLI / Sólo desde CLI
' ------------------------------
IF PEEKL(SYSTAB+8) <> 0 THEN
	BEEP
ELSE
	Start
END IF

END

' ---------------------------------------------------------------------
