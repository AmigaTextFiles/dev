' Simple DTPic-Viewer on a Customscreen
' Author: steffen.leistner@styx.in-chemnitz.de

DEFLNG a-z

REM $NOARRAY
REM $NOOVERFLOW
REM $NOEVENT
REM $NOSTACK
REM $NOLIBRARY
REM $NOWINDOW
REM $DYNAMIC

REM $INCLUDE exec.bh
REM $INCLUDE dos.bh
REM $INCLUDE graphics.bh
REM $INCLUDE diskfont.bh
REM $INCLUDE intuition.bh
REM $INCLUDE utility.bh
REM $INCLUDE datatypes.bh
REM $INCLUDE datatypes/datatypesclass.bc
REM $INCLUDE datatypes/pictureclass.bc

CONST workbufsize&	= 1024&
CONST PicDims% 		= 5%
CONST PicWidth% 	= 0%
CONST PicHeight% 	= 1%
CONST PicDepth% 	= 2%
CONST PicColW%		= 3%	'Pointer to RGB32-Colortable
CONST PicColN% 		= 4%	'NumColors
CONST PicDMode% 	= 5%	'DisplaymodeID

'****************************************************************************
'** LoadDTPic - Load a Datatype-Picture in a Bitmap and the Colortable
'**             in a RGB32-Structure
'**
'** res& = LoadDTPic&(filenam$, picdatas&())
'**
'** res&		Pointer to a Bitmap or NULL&
'** filename$	:)
'** picdatas&() see constants above
'**

FUNCTION LoadDTPic& (filename$, picdim&())
	SHARED workbuf&
	LoadDTPic& = NULL&
	TAGLIST workbuf, _
		DTA_SourceType&, DTST_FILE&, _
		DTA_GroupID&, GID_PICTURE&, _
		PDTA_REMAP&, FALSE&, _
	TAG_END&
	dtobjekt& = NewDTObjectA&(SADD(filename$ + CHR$(0)), workbuf&)
	
	IF dtobjekt& THEN
		TAGLIST workbuf&, _
			PDTA_ModeID&, VARPTR(picdim&(PicDMode%)), _
			PDTA_BitMapHeader&, VARPTR(bmheader&), _
		TAG_END&
		
		IF GetDTAttrsA& (dtobjekt&, workbuf&) = 2 THEN
			picdim&(PicWidth%) = PEEKW(bmheader& + bmh_Width%)
			picdim&(PicHeight%) = PEEKW(bmheader& + bmh_Height%)
			picdim&(PicDepth%) = PEEKB(bmheader& + bmh_Depth%)
			gplayout& = AllocVec&(gpLayout_sizeof%, MEMF_PUBLIC& OR MEMF_CLEAR&)
			
			IF gplayout& THEN
				POKEL gplayout& + gpLayoutMethodID%, DTM_PROCLAYOUT&
				POKEL gplayout& + gpl_GInfo%, NULL&
				POKEL gplayout& + gpl_Initial%, TRUE&
				
				IF DoDTMethodA& (dtobjekt&, NULL&, NULL&, gplayout&) THEN
					TAGLIST workbuf&, _
						PDTA_BitMap&, VARPTR(bitmapadr&), _
        	        	PDTA_CRegs&, VARPTR(colorfield&), _
        	            PDTA_NumColors&, VARPTR(numcolors&), _
					TAG_END&
					
					IF GetDTAttrsA& (dtobjekt&, workbuf&) = 3 THEN
						
						colmsize& = ((numcolors& * 3) * 4) + 8
						colors32& = AllocVec& (colmsize&, MEMF_PUBLIC& OR MEMF_CLEAR&)
						POKEW colors32&, numcolors&
						CopyMem colorfield&, (colors32& + 4), (colmsize& - 8)
						picdim&(PicColW%) = colors32&
						picdim&(PicColN%) = numcolors&
						
						tempbm& = AllocBitMap& (picdim&(PicWidth%), picdim&(PicHeight%), _
											 	picdim&(PicDepth%), bmap_flags&, NULL&)
						
						junk& = BltBitMap& (bitmapadr&, 0&, 0&, tempbm&, 0&, 0& , _
											picdim&(PicWidth%), picdim&(PicHeight%), _
											&HC0, &HFF, NULL&)
						WaitBlit
						LoadDTPic& = tempbm&
					END IF
					
				END IF
				FreeVec gplayout&
				
			END IF
		END IF
		DisposeDTObject dtobjekt&
		
	END IF
END FUNCTION

'**
'******************************************************************************
'**
'** ShowPic - checks the Displaymode, 
'**           open a Customscreen and a borderless Window,
'**           blit the Picture and wait for Mouseclick...

FUNCTION ShowPic&(pn$)
	SHARED workbuf&
	DIM picdimensions&(PicDims%)
	bm& = LoadDTPic&(pn$, picdimensions&())
	IF bm& THEN
		IF ModeNotAvailable&(picdimensions&(PicDMode%)) THEN
			TAGLIST workbuf&, _
				BIDTAG_NominalHeight&,	picdimensions&(PicHeight%), _
				BIDTAG_NominalWidth&,	picdimensions&(PicWidth%), _
				BIDTAG_Depth&,			picdimensions&(PicDepth%), _
				BIDTAG_SourceID&,		picdimensions&(PicDMode%), _
			TAG_END&
			newid& = BestModeIDA&(workbuf&)
			IF newid& <> INVALID_ID& THEN
				picdimensions&(PicDMode%) = newid&
			ELSE
				picdimensions&(PicDMode%) = PAL_MONITOR_ID& OR HIRESLACE_KEY&
			END IF
		END IF
		TAGLIST workbuf&, _
			SA_Width&,		picdimensions&(PicWidth%), _
			SA_Height&, 	picdimensions&(PicHeight%), _
			SA_Depth&,		picdimensions&(PicDepth%), _
			SA_DisplayID&,	picdimensions&(PicDMode%), _
			SA_Colors32&,	picdimensions&(PicColW%), _
			SA_Quiet&, 		TRUE&, _
			SA_ShowTitle&, 	FALSE&, _
			SA_Behind&, 	TRUE&, _
			SA_Type&,		CUSTOMSCREEN&, _
			SA_Overscan&,	OSCAN_TEXT&, _
			SA_BackFill&,	LAYERS_NOBACKFILL&, _
		TAG_END&
		scr& = OpenScreenTagList& (NULL&, workbuf&)
		IF scr& THEN
			TAGLIST workbuf&, _
				WA_Width&,			picdimensions&(PicWidth%), _
				WA_Height&,			picdimensions&(PicHeight%), _
				WA_CustomScreen&, 	scr&, _
				WA_IDCMP&, 			IDCMP_MOUSEBUTTONS&, _
				WA_Backdrop&, 		TRUE&, _
				WA_Borderless&,		TRUE&, _
				WA_Activate&,		TRUE&, _
				WA_RMBTrap&,		TRUE&, _
				WA_SimpleRefresh&,	TRUE&, _
				WA_BackFill&,		LAYERS_NOBACKFILL&, _
			TAG_END&
			win& = OpenWindowTagList& (NULL&, workbuf&)
			IF win& THEN
				rp& = PEEKL(win& + RPort%)
				junk& = BltBitMapRastPort& (bm&, 0, 0, rp&, 0, 0, _
											picdimensions&(PicWidth%), _
											picdimensions&(PicHeight%), &HC0)
				WaitBlit
				ScreenToFront scr&
				up& = PEEKL(win& + UserPort%)
				DO
					warten& = WaitPort& (up&)
					msg& = GetMsg& (up&)
					IF msg& THEN
						ReplyMsg msg&
						EXIT LOOP
					END IF
				LOOP
				ScreenToBack scr&
				CloseWindow win&
			END IF
			junk& = CloseScreen&(scr&)
		END IF 
		FreeBitMap bm&
		FreeVec picdimensions&(PicColW%)
	END IF
	ERASE picdimensions&
END FUNCTION

'******************************************************************************

LIBRARY OPEN "exec.library", 39
LIBRARY OPEN "dos.library"
LIBRARY OPEN "graphics.library"
LIBRARY OPEN "intuition.library"
LIBRARY OPEN "datatypes.library"

workbuf& = AllocVec& (workbufsize&, MEMF_PUBLIC& OR MEMF_CLEAR&)
IF workbuf& THEN
	IF COMMAND$ <> ""
		okay& = ShowPic&(COMMAND$)
	ELSE
		okay& = ShowPic&("Bilder/Test.ilbm")
	END IF
	FreeVec workbuf&
END IF

LIBRARY CLOSE
STOP okay&

DATA "$VER: ViewDTPic_2 V1.0 by Ironbyte [29.01.96] "