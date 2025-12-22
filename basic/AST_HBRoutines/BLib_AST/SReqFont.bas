' ---------------------------------------------------------------------------------------

REM ** $VER: SReqFont.bas 1.0 (01.09.2009) by AmiSpaTra

REM ** AllocMem&, FreeMem
' LIBRARY OPEN "exec.library"
REM ** AllocAslRequest& (v36), AslRequest& (v36), FreeAslRequest (v36)
' LIBRARY OPEN "asl.library", 36

' REM $include exec.bh
' REM $include graphics.bc
' REM $include utility.bc
' REM $include asl.bh

REM $NOBREAK
REM $NOEVENT

REM *************************************************************************

FUNCTION SReqFont&(BYVAL win&, BYVAL title$, _
                   wx&, wy&, ww&, wh&, _
                   ifont$, _
                   isize&, _
                   istyle&, _
                   BYVAL showonlyfixed&, BYVAL showstyle&)

  LOCAL fr&, mem&, size&

	SReqFont& = FALSE&

	' ¡Recuerde! El tamaño mínimo del bloque = nº de etiquetas * 4 * 2 octetos
	'           Remember! Minimum block size = tags * 4 * 2 bytes
	' ------------------------------------------------------------------------

	size& = 112&

	mem& = AllocMem&(size&,MEMF_CLEAR& OR MEMF_ANY&)

	IF mem& THEN

		' ASLFO_SampleText& (v45) = &H80085                
		' ---------------------------------

		TAGLIST mem&, _
			ASLFO_Window&,          win&, _
			ASLFO_TitleText&,       title$+CHR$(0), _
			ASLFO_InitialLeftEdge&, wx&, _
			ASLFO_InitialTopEdge&,  wy&, _
			ASLFO_InitialWidth&,    wh&, _
			ASLFO_InitialHeight&,   ww&, _
			ASLFO_InitialName&,     ifont$+CHR$(0), _
			ASLFO_InitialSize&,     isize&, _
			ASLFO_InitialStyle&,    istyle&, _
			ASLFO_FixedWidthOnly&,  showonlyfixed&, _
			ASLFO_DoStyle&,         showstyle&, _
			&H80085,                TRUE&, _
			ASLFO_SleepWindow&,     TRUE&, _
			TAG_DONE&

		fr& = AllocAslRequest&(ASL_FontRequest&,mem&)

		IF fr& THEN

			IF AslRequest&(fr&,0&) THEN

				'     La estructura TextAttr está incrustada en la estructura FontRequester
				' The TextAttr is IN the FontRequester struct (this isn't referenced as a pointer)
				' --------------------------------------------------------------------------------
				ifont$  = PEEK$(PEEKL(fr&+fo_Attr%+ta_Name%))
				isize&  = PEEKW(fr&+fo_Attr%+ta_YSize%)
				istyle& = PEEKB(fr&+fo_Attr%+ta_Style%)

				wx& = PEEKW(fr&+fr_LeftEdge%)
				wy& = PEEKW(fr&+fr_TopEdge%)
				wh& = PEEKW(fr&+fr_Height%)
				ww& = PEEKW(fr&+fr_Width%)

			END IF

			FreeAslRequest fr&

		END IF

		FreeMem& mem&, size&

		SReqFont& = TRUE&

	END IF

END FUNCTION

' ---------------------------------------------------------------------------------------
