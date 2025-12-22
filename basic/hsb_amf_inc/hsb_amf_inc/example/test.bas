' test.bas, based on test.c by Henk Jonas
' Version : $Id: test.bas V0.1
' Compiler:	HBC 2.0+
' Includes:	3.1
' Author:   steffen.leistner@styx.in-chmenitz.de

REM $NOLIBRARY
REM $NOWINDOW

DEFLNG a-z

REM $INCLUDE exec.bh
REM $INCLUDE dos.bh
REM $INCLUDE intuition.bh
REM $INCLUDE graphics.bh
REM $INCLUDE iffparse.bh
REM $INCLUDE amigametaformat.bh
REM $INCLUDE utility.bc

LIBRARY OPEN "exec.library", 37&
LIBRARY OPEN "dos.library"
LIBRARY OPEN "iffparse.library"
LIBRARY OPEN "intuition.library"
LIBRARY OPEN "amigametaformat.library"

IF LEN(COMMAND$) = NULL&
	file$ = "metaview_logo.amf"
ELSE
	file$ = COMMAND$
END IF

IF NOT FEXISTS(file$)
	PRINT "Can't open "; file$
	SYSTEM RETURN_FAIL&
END IF

DIM tags&(40%), pens%(0%), mydata&(10%)
pens%(0%) = NOT 0%

TAGLIST VARPTR(tags&(0%)), _
	SA_LikeWorkbench&,	TRUE&, _
	SA_Width&,			NOT NULL&, _
	SA_Height&,			NOT NULL&, _
	SA_Depth&,			4&, _
	SA_Pens&,			VARPTR(pens%(0%)), _
	SA_FullPalette&,	TRUE&, _
	SA_Type&,			CUSTOMSCREEN&, _
	SA_SharePens&,		TRUE&, _
TAG_END&
scr& = OpenScreenTagList&(NULL&, VARPTR(tags&(0%)))

IF scr&
	TAGLIST VARPTR(tags&(0%)), _
		WA_CustomScreen&,	scr&, _
		WA_IDCMP&,			IDCMP_MOUSEBUTTONS&, _
		WA_Title&,			"Simple AMF Viewer in BASIC", _
	TAG_END&
	win& = OpenWindowTagList&(NULL&, VARPTR(tags&(0%)))
	IF win&
		file& = xOpen&(SADD(file$ + CHR$(0%)), MODE_OLDFILE&)
		IF file&
			iff& = AllocIFF&
			IF iff&
				InitIFFasDOS(iff&)
				POKEL iff& + iff_Stream%, file&
				IF OpenIFF&(iff&, IFFF_READ&) = NULL&
					mydata&(0%) = ID_AMFF&
					mydata&(1%) = ID_VERS&
					mydata&(2%) = ID_AMFF&
					mydata&(3%) = ID_FVER&
					mydata&(4%) = ID_AMFF&
					mydata&(5%) = ID_HEAD&
					mydata&(6%) = ID_AMFF&
					mydata&(7%) = ID_BODY&
					IF PropChunks&(iff&, VARPTR(mydata&(0%)), 4&) = NULL&
						IF StopChunk&(iff&, ID_AMFF&, ID_BODY&) = NULL&
							IF ParseIFF&(iff&, IFFPARSE_SCAN&) = NULL&
								mydata&(0%) = win&
								mydata&(1%) = PEEKL(scr& + ScreenViewPort% + Colormap%)
								amf& = AmfOpen&(AMF_WINDOW&, VARPTR(mydata&(0%)))
								IF amf&
									WHILE ReadChunkBytes&(iff&, VARPTR(func&), 4&) = 4&
										IF ReadChunkBytes&(iff&, VARPTR(count&), 4&) = 4&
											vbuf& = AllocVec&(count& * 4&, MEMF_CLEAR&)
											IF vbuf&
												IF ReadChunkBytes&(iff&, vbuf&, count& * 4&) = count& * 4&
													errnum& = AmfFunction&(amf&, vbuf&, func&, count&)
													IF errnum&
														PRINT "Function:";func&;" count:";count&;" error:";errnum&
													END IF
												END IF
												FreeVec vbuf&
											END IF
										END IF
									WEND
									AmfClose amf&
								END IF
							END IF
						END IF
					END IF
					CloseIFF iff&
				END IF
				FreeIFF iff&
			END IF
			junk& = xClose&(file&)
		END IF
		userport& = PEEKL(win& + UserPort%)
		sig& = xWait&((1& << PEEKB(userport& + mp_SigBit%)) OR SIGBREAKF_CTRL_C&)
		SELECT CASE sig&
			CASE SIGBREAKF_CTRL_C&
			CASE REMAINDER
				msg& = GetMsg&(userport&)
				WHILE msg&
					ReplyMsg msg&
					msg& = GetMsg&(userport&)
				WEND
		END SELECT
		CloseWindow win&
	ELSE
		PRINT "Can't open Window."
	END IF
	junk& = CloseScreen&(scr&)
ELSE
	PRINT "Can't open Screen."
END IF

LIBRARY CLOSE
SYSTEM RETURN_OK&	