' Simple DTPic-Viewer in a Workbenchwindow
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

'****************************************************************************

FUNCTION ShowPic& (pname$)
	SHARED workbuf&
	LOCAL dtobjekt&, gplayout&, zscr&, zwin&, rp&, sig&, msg&, junk&
	LOCAL pwidth%, pheight%, title$
	ShowPic& = RETURN_ERROR&
	
	zscr& = LockPubScreen&(NULL&)

	IF zscr& THEN
		TAGLIST workbuf&, _
			DTA_SourceType&,	DTST_FILE&, _
			DTA_GroupID&,		GID_PICTURE&, _
			PDTA_Screen&, 		zscr&, _
			PDTA_Remap&,		TRUE&, _
		TAG_END&
		dtobjekt& = NewDTObjectA& (SADD(pname$ + CHR$(0)), workbuf&)

		IF dtobjekt& THEN
			gplayout& = AllocVec&(gpLayout_sizeof%, MEMF_PUBLIC& OR MEMF_CLEAR&)
			
			IF gplayout& THEN
				POKEL gplayout& + gpLayoutMethodID%, DTM_PROCLAYOUT&
				POKEL gplayout& + gpl_GInfo%, NULL&
				POKEL gplayout& + gpl_Initial%, TRUE&
				
				IF DoDTMethodA& (dtobjekt&, NULL&, NULL&, gplayout&) THEN
					TAGLIST workbuf&, _
						PDTA_BitMapHeader&, VARPTR(bmheader&), _
						PDTA_BitMap&, VARPTR(bitmapadr&), _
					TAG_END&
					
					IF GetDTAttrsA& (dtobjekt&, workbuf&) = 2 THEN
						pwidth% = PEEKW(bmheader& + bmh_Width%)
						pheight% = PEEKW(bmheader& + bmh_Height%)
						pdepth% = PEEKB(bmheader& + bmh_Depth%)
 
						title$ = PEEK$(FilePart&(SADD(pname$ + CHR$(0)))) + SPACE$(3) + _
								LTRIM$(STR$(pwidth%)) + "x" + LTRIM$(STR$(pheight%)) + _
								"x" + LTRIM$(STR$(pdepth%))

						TAGLIST workbuf&, _
							WA_Left&,			(PEEKW(SYSTAB) - pwidth%) \ 2, _
							WA_Top&,			(PEEKW(SYSTAB + 2%) - pheight%) \ 2, _
							WA_InnerWidth&,		pwidth%, _
							WA_InnerHeight&,	pheight%, _
							WA_RMBTrap&,		TRUE&, _
							WA_Borderless&,		bless&, _
							WA_CustomScreen&, 	zscr&, _
							WA_GimmeZeroZero&,	TRUE&, _
							WA_DragBar&,		TRUE&, _
							WA_CloseGadget&,	TRUE&, _
							WA_DepthGadget&,	TRUE&, _
							WA_SmartRefresh&,	TRUE&, _
							WA_Activate&,		TRUE&, _
							WA_Title&,			title$, _
							WA_IDCMP&,			IDCMP_CLOSEWINDOW& OR IDCMP_MOUSEBUTTONS&, _
						TAG_END&
						zwin& = OpenWindowTagList& (NULL&, workbuf&)
						IF zwin& <> NULL THEN
							
							rp& = PEEKL(zwin& + RPort%)
							junk& = BltBitMapRastPort& (bitmapadr&, 0%, 0%, rp&, _
														0%, 0%, pwidth%, pheight%, &HC0)
							WaitBlit

							DO
								sig& = xWait&((1& << PEEKB(PEEKL(zwin& + UserPort%) + mp_SigBit%)) OR SIGBREAKF_CTRL_C&) 
								IF sig& AND SIGBREAKF_CTRL_C& THEN
									EXIT LOOP
								ELSE
									msg& = GetMsg&(PEEKL(zwin& + UserPort%))
									WHILE msg&
										ReplyMsg msg&
										msg& = GetMsg&(PEEKL(zwin& + UserPort%))
									WEND
									EXIT LOOP
								END IF
							LOOP
							
							ShowPic& = RETURN_OK&
							CloseWindow zwin&
						END IF
					END IF
				END IF
				FreeVec gplayout&
			END IF
			DisposeDTObject dtobjekt&
		END IF
		UnLockPubScreen NULL, zscr&
	END IF
END FUNCTION


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

DATA "$VER: ViewDTPic_1 V1.01 by Ironbyte [29.01.96] "

