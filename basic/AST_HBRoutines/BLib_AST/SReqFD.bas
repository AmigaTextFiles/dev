
' ---------------------------------------------------------------------------------------

REM ** $VER: SReqFD.bas 1.0 (01.09.2009) by AmiSpaTra

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

FUNCTION SReqFD&(BYVAL win&, BYVAL title$, _
                wx&, wy&, ww&, wh&, _
                ipat$, _
                idir$,  _
                ifile$, _
                BYVAL typeonlydir&, BYVAL noicons&)

  LOCAL fr&, mem&, size&, tmp$

	SReqFD& = FALSE&

	' ¡Recuerde! El tamaño mínimo del bloque = nº de etiquetas * 4 * 2 octetos
	'           Remember! Minimum block size = tags * 4 * 2 bytes
	' ------------------------------------------------------------------------

	size& = 120&

	mem& = AllocMem&(size&,MEMF_CLEAR& OR MEMF_ANY&)

	IF mem& THEN

		TAGLIST mem&, _
			ASLFR_Window&,          win&, _
			ASLFR_TitleText&,       title$+CHR$(0), _
			ASLFR_InitialLeftEdge&, wx&, _
			ASLFR_InitialTopEdge&,  wy&, _
			ASLFR_InitialWidth&,    ww&, _
			ASLFR_InitialHeight&,   wh&, _
			ASLFR_InitialPattern&,  ipat$ +CHR$(0), _
			ASLFR_InitialDrawer&,   idir$ +CHR$(0), _
			ASLFR_InitialFile&,     ifile$+CHR$(0), _
			ASLFR_DrawersOnly&,     typeonlydir&, _
			ASLFR_RejectIcons&,     noicons&, _
			ASLFR_DoPatterns&,      TRUE&, _
			ASLFR_FilterDrawers&,   typeonlydir&, _
			ASLFR_SleepWindow&,     TRUE&, _
			TAG_DONE&

		fr& = AllocAslRequest&(ASL_FileRequest&,mem&)

		IF fr& THEN

			IF AslRequest&(fr&,0) THEN

				idir$ = PEEK$(PEEKL(fr&+fr_Drawer%))

				tmp$ = RIGHT$(idir$,1)

				IF idir$<> "" AND tmp$ <> ":" AND tmp$ <> "/" THEN
					idir$ = idir$ + "/"
				END IF

				IF typeonlydir& = FALSE& THEN
					ifile$ = PEEK$(PEEKL(fr&+fr_File%))
				END IF

				wx& = PEEKW(fr&+fr_LeftEdge%)
				wy& = PEEKW(fr&+fr_TopEdge%)
				wh& = PEEKW(fr&+fr_Height%)
				ww& = PEEKW(fr&+fr_Width%)

				SReqFD& = TRUE&

			END IF

			FreeAslRequest fr&

		END IF

		FreeMem& mem&, size&

	END IF

END FUNCTION

' ---------------------------------------------------------------------------------------
