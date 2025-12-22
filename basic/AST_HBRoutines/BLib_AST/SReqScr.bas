' ---------------------------------------------------------------------------------------

REM ** $VER: SReqScr.bas 1.0 (01.09.2009) by AmiSpaTra

REM ** AllocMem&, FreeMem
' LIBRARY OPEN "exec.library"
REM ** AllocAslRequest& (v36), AslRequest& (v36), FreeAslRequest (v36)
' LIBRARY OPEN "asl.library", 36

' REM $include exec.bh
' REM $include utility.bc
' REM $include asl.bh

REM $NOBREAK
REM $NOEVENT

REM *************************************************************************

FUNCTION SReqScr&(BYVAL win&, BYVAL title$, _
                  wx&, wy&, ww&, wh&, _
                  imodscr&, iwscr&, ihscr&, _
                  BYVAL showsize&, BYVAL showinfo&, _
                  iwx&, iwy&)

  LOCAL fr&, mem&, size&

	SReqScr& = 0&

	' ¡Recuerde! El tamaño mínimo del bloque = nº de etiquetas * 4 * 2 octetos
	'           Remember! Minimum block size = tags * 4 * 2 bytes
	' ------------------------------------------------------------------------

	size& = 128&

	mem& = AllocMem&(size&,MEMF_CLEAR& OR MEMF_ANY&)

	IF mem& THEN

		TAGLIST mem&, _
			ASLSM_Window&,               win&, _
			ASLSM_TitleText&,            title$+CHR$(0), _
			ASLSM_InitialLeftEdge&,      wx&, _
			ASLSM_InitialTopEdge&,       wy&, _
			ASLSM_InitialWidth&,         ww&, _
			ASLSM_InitialHeight&,        wh&, _
			ASLSM_InitialDisplayID&,     imodscr&, _
			ASLSM_InitialDisplayWidth&,  iwscr&, _
			ASLSM_InitialDisplayHeight&, ihscr&, _
			ASLSM_DoWidth&,              showsize&, _
			ASLSM_DoHeight&,             showsize&, _
			ASLSM_InitialInfoOpened&,    showinfo&, _
			ASLSM_InitialInfoLeftEdge&,  iwx&, _
			ASLSM_InitialInfoTopEdge&,   iwy&, _
			ASLSM_SleepWindow&,          TRUE&, _
			TAG_DONE&

		fr& = AllocAslRequest&(ASL_ScreenModeRequest&,mem&)

		IF fr& THEN

			IF AslRequest&(fr&,0&) THEN

				imodscr&  = PEEKL(fr&+sm_DisplayID%)
				iwscr&    = PEEKL(fr&+sm_DisplayWidth%)
				ihscr&    = PEEKL(fr&+sm_DisplayHeight%)

				wx&       = PEEKW(fr&+sm_LeftEdge%)
				wy&       = PEEKW(fr&+sm_TopEdge%)
				wh&       = PEEKW(fr&+sm_Height%)
				ww&       = PEEKW(fr&+sm_Width%)

				IF showinfo& THEN
					iwx&      = PEEKW(fr&+sm_InfoLeftEdge%)
					iwy&      = PEEKW(fr&+sm_InfoTopEdge%)
				END IF

			END IF

			FreeAslRequest fr&

		END IF

		FreeMem& mem&, size&

		SReqScr& = TRUE&

	END IF

END FUNCTION
' ---------------------------------------------------------------------------------------
