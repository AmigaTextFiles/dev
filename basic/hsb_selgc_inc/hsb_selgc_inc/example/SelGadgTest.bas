' Select.gadget test (15.08.99)
' original C-Source © 1998 Massimo Tantignone
' HiSoftBASIC 2 - Port by Steffen Leistner

DEFLNG a-z

REM $JUMPS
REM $NOLIBRARY
REM $NOWINDOW


REM $INCLUDE exec.bh
REM $INCLUDE intuition.bh
REM $INCLUDE gadgets/select.bh
REM $INCLUDE utility.bh
REM $INCLUDE gadtools.bh



FUNCTION Main&

	LIBRARY OPEN "exec.library", 37&
	LIBRARY OPEN "intuition.library"
	LIBRARY OPEN "gadgets/select.gadget"

	DIM labels1&(4), labels2&(5), tags&(40)

	TAGLIST VARPTR(labels1&(0)), _
		"First option", "Second option", _
		"Third option", "Fourth option", _
	TAG_END&

	TAGLIST VARPTR(labels2&(0)), _
		"This is an", "example of", _
		"my BOOPSI", "pop-up", _
		"gadget class", _
	TAG_END&

	scr& = LockPubScreen&(NULL&)
	IF scr&
	
		s_width% = PEEKW(scr& + ScreenWidth%)
		s_height% = PEEKW(scr& + ScreenHeight%)
		
		UnlockPubScreen NULL&, scr&
	ELSE
		s_width% = 640%
		s_height% = 200%
	END IF
	
	TAGLIST VARPTR(tags&(0)), _
		WA_Left&,			(s_width% - 500%) \ 2, _
		WA_Top&,			(s_height% - 160%) \ 2, _
		WA_Width&,			500&, _
		WA_Height&,			160&, _
		WA_MinWidth&,		100&, _
		WA_MinHeight&,		100&, _
		WA_MaxWidth&,		NOT NULL&, _
		WA_MaxHeight&, 		NOT NULL&, _
		WA_CloseGadget&,	TRUE&, _
		WA_SizeGadget&,		TRUE&, _
		WA_DepthGadget&,	TRUE&, _
		WA_DragBar&,		TRUE&, _
		WA_SimpleRefresh&,	TRUE&, _
		WA_Activate&,		TRUE&, _
		WA_Title&,			"select.gadget test", _
		WA_IDCMP&,			IDCMP_CLOSEWINDOW& OR IDCMP_GADGETUP& OR IDCMP_REFRESHWINDOW&, _
	TAG_END&
	
	win& = OpenWindowTagList&(NULL&, VARPTR(tags&(0)))
	IF win&
	
		dri& = GetScreenDrawInfo&(PEEKL(win& + WScreen%))
		IF dri&
		
			TAGLIST VARPTR(tags&(0)), _
				GA_Left&,			40, _
                GA_Top&,			40 + PEEKB(win& + BorderTop%), _
                GA_RelVerify&,		TRUE&, _
                GA_DrawInfo&,		dri&, _
                GA_Text&,			"Click me", _
                GA_ID&,				1&, _
                SGA_TextPlace&,		PLACETEXT_ABOVE&, _
                SGA_Labels&,		VARPTR(labels1&(0)), _
                SGA_Separator&,		FALSE&, _
                SGA_ItemSpacing&,	2&, _
                SGA_FollowMode&,	SGFM_FULL&, _
                SGA_MinTime&,		200&, _ 
                SGA_MaxTime&,		200&, _
                SGA_PanelMode&,		SGPM_DIRECT_NB&, _
            TAG_END&
            gad1& = NewObjectA&(NULL&, SADD("selectgclass" + CHR$(0)), VARPTR(tags&(0)))
            
            TAGLIST VARPTR(tags&(0)), _
            	GA_Previous&,		gad1&, _
                GA_Top&,			80 + PEEKB(win& + BorderTop%), _
                GA_RelVerify&,		TRUE&, _
                GA_DrawInfo&,		dri&, _
                GA_Text&,			"Me, too!", _
                GA_ID&,				2&, _
                SGA_Labels&,		VARPTR(labels2&(0)), _
                SGA_PopUpPos&,		SGPOS_RIGHT&, _
                SGA_Quiet&,			TRUE&, _
                SGA_Separator&,		FALSE&, _
                SGA_ReportAll&,		TRUE&, _
                SGA_BorderSize&,	8&, _
                SGA_FullPopUp&,		TRUE&, _
                SGA_PopUpDelay&,	1&, _
                SGA_DropShadow&,	TRUE&, _
                SGA_ListJustify&,	SGJ_LEFT&, _
            TAG_END&
			gad2& = NewObjectA&(NULL&, SADD("selectgclass" + CHR$(0)), VARPTR(tags&(0)))
			
			IF gad1& AND gad2&
				TAGLIST VARPTR(tags&(0)), _
					GA_Left&,	PEEKW(gad1& + GadgetLeftEdge%) + PEEKW(gad1& + GadgetWidth%) _
								- PEEKW(gad2& + GadgetHeight%), _
                    GA_Width&,	PEEKW(gad2& + GadgetHeight%), _
                TAG_END&
                junk& = SetAttrsA&(gad2&, VARPTR(tags&(0)))
            END IF
            
            TAGLIST VARPTR(tags&(0)), _
            	GA_Previous&,		gad2&, _
                GA_Top&,			40 + PEEKB(win& + BorderTop%), _
                GA_RelVerify&,		TRUE&, _
                GA_DrawInfo&,		dri&, _
                GA_Text&,			"Sticky b_utton", _
                GA_ID&,				3&, _
                SGA_Underscore&,	"_"%, _
                SGA_Labels&,		VARPTR(labels1&(0)), _
                SGA_Active&,		3&, _
                SGA_ItemSpacing&,	4&, _
                SGA_SymbolOnly&,	TRUE&, _
                SGA_SymbolWidth&,	-21&, _
                SGA_Sticky&,		TRUE&, _
                SGA_PopUpPos&,		SGPOS_BELOW&, _
                SGA_BorderSize&,	4&, _
                SGA_PopUpDelay&,	1&, _
            TAG_END&
			gad3& = NewObjectA&(NULL&, SADD("selectgclass" + CHR$(0)), VARPTR(tags&(0)))
			
			IF gad3&
				TAGLIST VARPTR(tags&(0)), _
					GA_Left&,	PEEKW(win& + WindowWidth%) - PEEKW(gad3& + GadgetWidth%) - 40, _
                TAG_END&
                junk& = SetAttrsA&(gad3&, VARPTR(tags&(0)))
            END IF

			TAGLIST VARPTR(tags&(0)), _
				GA_Previous&,		gad3&, _
                GA_Top&,			80 + PEEKB(win& + BorderTop%), _
                GA_RelVerify&,		TRUE&, _
                GA_DrawInfo&,		dri&, _
                GA_Text&,			"S_imple", _
                GA_ID&,				4&, _
                SGA_Underscore&,	"_"%, _
                SGA_Labels&,		VARPTR(labels1&(0)), _
            TAG_END
            gad4& = NewObjectA&(NULL&, SADD("selectgclass" + CHR$(0)), VARPTR(tags&(0)))
            
            IF gad4&
            	TAGLIST VARPTR(tags&(0)), _
					GA_Left&,	PEEKW(win& + WindowWidth%) - PEEKW(gad4& + GadgetWidth%) - 40, _
                TAG_END&
                junk& = SetAttrsA&(gad4&, VARPTR(tags&(0)))
            END IF
            
            IF gad1& AND gad2& AND gad3& AND gad4&
            	
            	junk& = AddGList&(win&, gad1&, NOT NULL&, NOT NULL&, NULL&)
            	RefreshGList gad1&, win&, NULL&, NOT NULL&
            
            END IF
            
            REPEAT mainloop
            	
            	junk& = WaitPort&(PEEKL(win& + UserPort%))
            	
            	imsg& = GetMsg&(PEEKL(win& + UserPort%))
            	
            	IF imsg&
            		class& = PEEKL(imsg& + Class%)
            		code% = PEEKW(imsg& + IntuiMessageCode%)
            		iaddress& = PEEKL(imsg& + IAddress%)
            		ReplyMsg imsg&
            		
            		SELECT CASE class&
						CASE IDCMP_CLOSEWINDOW&
							EXIT mainloop
							
						CASE IDCMP_GADGETUP&
							PRINT "Gadget:";PEEKW(iaddress& + GadgetGadgetID%);" Item:";code%
						
						CASE IDCMP_REFRESHWINDOW&
							BeginRefresh win&
							EndRefresh win&, TRUE&
							
					END SELECT
					
				END IF
				
			END REPEAT mainloop
			
			IF gad1& AND gad2& AND gad3& AND gad4&
			
				junk& = RemoveGList(win&, gad1&, 4&)
			
			END IF
			
			DisposeObject gad1&
			DisposeObject gad2&
			DisposeObject gad3&
			DisposeObject gad4&
			
			FreeScreenDrawInfo PEEKL(win& + WScreen%), dri&
		END IF
		
		CloseWindow win&
	END IF
	
	LIBRARY CLOSE
	
	Main& = RETURN_OK&
END FUNCTION

SYSTEM Main&