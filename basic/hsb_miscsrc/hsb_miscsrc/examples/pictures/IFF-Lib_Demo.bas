'****************************************************************************
'**                                                                        **
'**           IFF-Lib_Demo                                                 **
'**           FreeWare, use on your own Risk                               **
'**                                                                        **
'**           by Steffen "Ironbyte" Leistner 1995                          **
'**                                                                        **
'****************************************************************************

' Sorry: variablenames are in german :)

DEFLNG a-z

REM $DYNAMIC
REM $NOWINDOW
REM $NOLIBRARY

REM $INCLUDE exec.bh
REM $INCLUDE dos.bh
REM $INCLUDE graphics.bh
REM $INCLUDE intuition.bh
REM $INCLUDE iff.bh
REM $INCLUDE BLib/ILBMSupport.bas

LIBRARY OPEN "exec.library", 37&
LIBRARY OPEN "dos.library", 37&
LIBRARY OPEN "intuition.library", 37&
LIBRARY OPEN "graphics.library", 37&
LIBRARY OPEN "iff.library", 22&

DIM SHARED bilddaten&(PicDims%) 
DIM SHARED generictaglist&(28)

Basic1
Basic2
OS1
OS2

LIBRARY CLOSE
SYSTEM

'************** Demo - Sub's ************************************************

' BASIC-Window on Workbench without Colorsupport

SUB Basic1
	bildname$ = "Bilder/AmigaBack.brush"
	bitmapadresse& = LoadILBM& (bildname$, bilddaten&())
	IF bitmapadresse& > NULL& THEN
		WINDOW 2, bildname$,(20, 15)-(bilddaten&(PicWidth%)+36, _
				  bilddaten&(PicHeight%)+26), 2+4+8+16
		IF WINDOW(7) THEN
			junk& = BltBitMapRastPort& (bitmapadresse&, 0, 0, WINDOW(8), 10, 5, _
										bilddaten&(PicWidth%), _
										bilddaten&(PicHeight%), &HC0)
			SLEEP
			WINDOW CLOSE 2
		END IF
		RemoveBitMap bitmapadresse&, bilddaten&(PicWidth%), bilddaten&(PicHeight%)
		FreeVec bilddaten&(PicColW%)
	END IF
END SUB

' BASIC - Window on Custom(BASIC)Screen with Colorsupport

SUB Basic2
	bildname$ = "Bilder/AmigaBack.brush"
	bitmapadresse& = LoadILBM& (bildname$, bilddaten&())
	IF bitmapadresse& > NULL& THEN
		SCREEN 1, bilddaten&(PicPWidth%), bilddaten&(PicPHeight%), _
				  bilddaten&(PicDepth%), 5, bilddaten&(PicDMode%)
		screenstruktur& = PEEKL(SYSTAB + 12)
		IF screenstruktur& THEN
			viewportadresse& = screenstruktur& + ScreenViewPort%
			LoadRGB4 viewportadresse&, bilddaten&(PicColW%), bilddaten&(PicColN%)
			WINDOW 1, bildname$, , 2+4+8+16, 1
			IF WINDOW(7) THEN
				xoffset& = (WINDOW(2) - bilddaten&(PicWidth%)) \ 2
				junk& = BltBitMapRastPort& (bitmapadresse&, 0, 0, WINDOW(8), xoffset&, _
											5, bilddaten&(PicWidth%), _
											bilddaten&(PicHeight%), &HC0)
				SLEEP
				WINDOW CLOSE 1
			END IF
			SCREEN CLOSE 1
		END IF
		RemoveBitMap bitmapadresse&, bilddaten&(PicWidth%), bilddaten&(PicHeight%)
		FreeVec bilddaten&(PicColW%)
	END IF
END SUB

' Quickload on a Customscreen-Bitmap

SUB OS1
	bildname$ = "Bilder/ZX-6R.ilbm-ehb"
	bitmapadresse& = LoadILBM& (bildname$, bilddaten&())
	IF bitmapadresse& > NULL& THEN
		TAGLIST VARPTR(generictaglist&(0)), _
			SA_Width, bilddaten&(PicWidth%), _
			SA_Height, bilddaten&(PicHeight%), _
			SA_Depth, bilddaten&(PicDepth%), _
			SA_DisplayID, bilddaten&(PicDMode%), _
			SA_Behind, TRUE&, _
		TAG_END
		screenstruktur& = OpenScreenTagList& (NULL&, VARPTR(generictaglist&(0)))
		IF screenstruktur& THEN
			viewportadresse& = screenstruktur& + ScreenViewPort%
			rastportadresse& = screenstruktur& + RastPort%
			LoadRGB4 viewportadresse&, bilddaten&(PicColW%), bilddaten&(PicColN%)
			junk& = BltBitMapRastPort& (bitmapadresse&, 0, 0, rastportadresse&, _
										0, 0, bilddaten&(PicWidth%), _
										bilddaten&(PicHeight%), &HC0)
			ScreenToFront screenstruktur&
			Delay 300
			ScreenToBack screenstruktur&
			junk& = CloseScreen& (screenstruktur&)
		END IF
		RemoveBitMap bitmapadresse&, bilddaten&(PicWidth%), bilddaten&(PicHeight%)
		FreeVec bilddaten&(PicColW%)
	END IF
END SUB

' Using a Picture in a Window

SUB OS2
	bildname$ = "Bilder/Harley's.ilbm"
	textname$ = "Bilder/Harley's.text"
	screentitel$ = "Select a Harley::"
	DIM scrntexte$(3)
	IF FEXISTS(textname$) THEN
		OPEN textname$ FOR INPUT AS #1
			FOR z% = 0 TO 3
				INPUT #1, scrntexte$(z%)
			NEXT z%
		CLOSE #1
	END IF
	bitmapadresse& = LoadILBM& (bildname$, bilddaten&())
	IF bitmapadresse& > NULL& THEN
		displaymodeid& = DBLPALHIRESFF_KEY&
		IF ModeNotAvailable (displaymodeid&) THEN
			displaymodeid& = PAL_MONITOR_ID& OR HIRESLACE_KEY&
		END IF
		TAGLIST VARPTR(generictaglist&(0)), _
			SA_Depth&, bilddaten&(2), _
			SA_DisplayID&, displaymodeid&, _
			SA_Overscan&, OSCAN_MAX&, _
			SA_AutoScroll&, TRUE&, _
			SA_Behind&, TRUE&, _
			SA_Title&, screentitel$, _
		TAG_END
		screenstruktur& = OpenScreenTagList& (NULL&, VARPTR(generictaglist&(0)))
		IF screenstruktur& THEN
			viewportadresse& = screenstruktur& + ScreenViewPort%
			LoadRGB4 viewportadresse&, bilddaten&(PicColW%), bilddaten&(PicColN%)
			TAGLIST VARPTR(generictaglist&(0)), _
				WA_CustomScreen&, screenstruktur&, _
				WA_InnerWidth&, bilddaten&(PicWidth%), _
				WA_InnerHeight&, bilddaten&(PicHeight%), _
				WA_Title&, bildname$, _
				WA_IDCMP&, IDCMP_CLOSEWINDOW& OR IDCMP_MOUSEBUTTONS&, _
				WA_DragBar&, TRUE&, _
				WA_DepthGadget&, TRUE&, _
				WA_CloseGadget&, TRUE&, _
				WA_AutoAdjust&, TRUE&, _
				WA_SimpleRefresh&, TRUE&, _
				WA_Activate&, TRUE&, _
			TAG_END&
			windowstruktur& = OpenWindowTagList& (NULL&, VARPTR(generictaglist&(0)))
			IF windowstruktur& THEN
				rastportadresse& = PEEKL(windowstruktur& + RPort%)
				userportadresse& = PEEKL(windowstruktur& + UserPort%)
				linkerrand% = PEEKB(windowstruktur& + BorderLeft%)
				obererrand% = PEEKB(windowstruktur& + BorderTop%)
				rechterrand% = PEEKW(windowstruktur& + WindowWidth%) - PEEKB(windowstruktur& + BorderRight%)
				untererrand% = PEEKW(windowstruktur& + WindowHeight%) - PEEKB(windowstruktur& + BorderBottom%)
				bildhaelftex% = bilddaten&(PicWidth%) \ 2
				bildhaelftey% = bilddaten&(PicHeight%) \ 2
				junk& = BltBitMapRastPort& (bitmapadresse&, 0, 0, rastportadresse&, _
											linkerrand%, obererrand%, _
											bilddaten&(PicWidth%), _
											bilddaten&(PicHeight%), &HC0)
				RefreshWindowFrame windowstruktur&
				ScreenToFront screenstruktur&
				DO
					warten& = WaitPort& (userportadresse&)
					idcmpmeldung& = GetMsg& (userportadresse&)
					IF idcmpmeldung& THEN
						idcmpklasse& = PEEKL(idcmpmeldung& + Class%)
						idcmpmausx%  = PEEKW(idcmpmeldung& + IntuiMessageMouseX%)
						idcmpmausy%  = PEEKW(idcmpmeldung& + IntuiMessageMouseY%)
						ReplyMsg idcmpmeldung&	
						SELECT CASE idcmpklasse&
							CASE IDCMP_CLOSEWINDOW&
								EXIT LOOP
							CASE IDCMP_MOUSEBUTTONS&
								SELECT CASE idcmpmausx%
									CASE linkerrand% TO linkerrand% + bildhaelftex%
										textnr% = 0
									CASE linkerrand% + bildhaelftex% TO rechterrand%
										textnr% = 1
									CASE REMAINDER
										textnr% = -1
								END SELECT
								IF textnr% > -1 THEN
									SELECT CASE idcmpmausy%
										CASE obererrand% TO obererrand% + bildhaelftey%
											textnr% = textnr% + 0
										CASE obererrand% + bildhaelftey% TO untererrand%
											textnr% = textnr% + 2
										CASE REMAINDER
											textnr% = -1
									END SELECT
								END IF
								IF textnr% > -1 THEN
									SetWindowTitles windowstruktur&, SADD(bildname$ + _
									CHR$(0)), SADD(scrntexte$(textnr%) + CHR$(0))
								END IF
						END SELECT
					END IF
				LOOP
				CloseWindow windowstruktur&
			END IF
			junk& = CloseScreen& (screenstruktur&)
		END IF
		RemoveBitMap bitmapadresse&, bilddaten&(PicWidth%), bilddaten&(PicHeight%)
		FreeVec bilddaten&(PicColW%)
	END IF	
END SUB

DATA "$VER: IFF-Lib-Demo 1.0 [22.12.95] "