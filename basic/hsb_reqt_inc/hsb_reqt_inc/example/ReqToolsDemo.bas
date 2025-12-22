'	reqtoolsdemo.bas, based on demo.c from the reqtools package
'	for HiSoft/Maxon Basic by Steffen Leistner 1995
'	email: steffen.leistner@styx.in-chemnitz.de
'	this file is public domain
'	Tabwidth = 4
'	Includeversion 42 (3.1)

REM $NOWINDOW
REM $NOLIBRARY

REM $INCLUDE exec.bh
REM $INCLUDE dos.bh
REM $INCLUDE intuition.bh
REM $INCLUDE graphics.bh
REM $INCLUDE reqtools.bh
REM $INCLUDE utility.bh

CONST minver& 	= 37&			'needs Kickstart 37+ (2.0)
CONST rtver&	= 38&			'reqtools-version 38+
CONST wbufsize&	= 512&
CONST tagptr&	= 384&

LIBRARY OPEN "exec.library", minver&
LIBRARY OPEN "intuition.library", minver&
LIBRARY OPEN "reqtools.library", rtver&

'----------------------------------------------------------------------------

'a simpel filterhook for the file requester

FUNCTION FilterDemo&(BYVAL hk&, BYVAL freq&, BYVAL fib&)
	STATIC t$											'for more speed
	t$ = PEEK$(fib& + fib_Filename%)
	IF INSTR(t$, "a")
		PRINT t$
		FilterDemo& = FALSE&
	ELSE
		FilterDemo& = TRUE&
	END IF
END FUNCTION 

'---------------------------------------------------------------------------

FUNCTION Demo&

	'512 byte, enough workspace for stringoperations and taglists:
	
	wbuf& = AllocVec& (wbufsize&, MEMF_PUBLIC& OR MEMF_CLEAR&)
	IF wbuf& = NULL&
		EXIT FUNCTION
	END IF
	tagb& = wbuf& + tagptr& 				'buffersection for taglists
	
	
	r$ = CHR$(10) : n$ = CHR$(0)			'newline, stringtermination
	
	'--- Startup ------------------------------------------------------------
	
	junk& = rtEZRequestA& (SADD("ReqTools 2.0 Demo" + r$ + _
								"~~~~~~~~~~~~~~~~~" + r$ + _
								"'reqtools.library' offers several" + r$ + _
								"different types of requesters:" + n$), _
							SADD("Let's see them" + n$), _
							NULL&, NULL&, NULL&)
							
	junk& = rtEZRequestA& (SADD("NUMBER 1:" + r$ + _
								"The larch :-)" + n$), + _
							SADD("Be serious!" + n$), _
							NULL&, NULL&, NULL&)
							
	'--- rtGetStringA -------------------------------------------------------
	
	junk& = rtEZRequestA& (SADD("NUMBER 1:" + r$ + _
								"String requester" + r$ + _
								"function: rtGetStringA&"+ n$), + _
							SADD("Show me" + n$), _
							NULL&, NULL&, NULL&)
	
	tmp$ = "A bit of text" + n$
	CopyMem SADD(tmp$), wbuf&, LEN(tmp$)
	
	IF rtGetStringA& (wbuf&, tagptr& - 2, SADD("Enter anything:" + n$), NULL&, NULL&)
		junk& = rtEZRequestA& (SADD("You entered this string:" + r$ + _ 
								"'" + PEEK$(wbuf&) + "'" + n$), + _
								SADD("So I did" + n$), _
								NULL&, NULL&, NULL&)
	ELSE
		junk& = rtEZRequestA& (SADD("You entered nothing :-(" + n$), + _
								SADD("I'm sorry" + n$), _
								NULL&, NULL&, NULL&)
	END IF
	
	TAGLIST tagb&, _
		RTGS_GadFmt&,	" _Ok |New _2.0 feature!|_Cancel", _
		RTGS_TextFmt&,	"These are two new features of ReqTools 2.0:" + r$ + _
	 					"Text above the entry gadget and more than" + r$ + _
			 			"one response gadget.", _
		RT_Underscore&,	"_"%, _
	TAG_END&
	
	IF rtGetStringA&	(wbuf&, tagptr& - 2, SADD("Enter anything:" + n$), _
						NULL&, tagb&) = 2

		junk& = rtEZRequestA& (SADD("Yep, this is a new" + r$ + _ 
								"ReqTools 2.0 feature!" + n$), + _
								SADD("Oh boy!" + n$), _
								NULL&, NULL&, NULL&)
	END IF

	TAGLIST tagb&, _
		RTGS_GadFmt&,	" _Ok |_Abort|_Cancel", _
		RTGS_TextFmt&,	"New is also the ability to switch off the" + r$ + _
					 	"backfill pattern.  You can also center the" + r$ + _
					 	"text above the entry gadget." + r$ + _
					 	"These new features are also available in" + r$ + _
					 	"the rtGetLong() requester.", _
		RTGS_BackFill&,	FALSE&, _
		RTGS_Flags&, 	GSREQ_CENTERTEXT& OR GSREQ_HIGHLIGHTTEXT&, _
		RT_Underscore&,	"_"%, _
	TAG_END&

	IF rtGetStringA&	(wbuf&, tagptr& - 2, SADD("Enter anything:" + n$), _
						NULL&, tagb&) = 2

		junk& = rtEZRequestA& (SADD("What!! You pressed abort!?!" + r$ + _ 
								"You must be joking :-)" + n$), + _
								SADD("Ok, Continue" + n$), _
								NULL&, NULL&, NULL&)
	END IF

	'--- rtGetLongA ---------------------------------------------------------

	junk& = rtEZRequestA& (SADD("NUMBER 2:" + r$ + _
								"Number requester" + r$ + _
								"function: rtGetLongA&"+ n$), + _
							SADD("Show me" + n$), _
							NULL&, NULL&, NULL&)

	TAGLIST tagb&, _
		RTGL_ShowDefault&,	FALSE&, _
		RTGL_Min&,			0&, _ 
		RTGL_Max&, 			666&, _
	TAG_END&

	IF rtGetLongA&(VARPTR(longnum&), SADD("Enter a number:" + n$), NULL&, tagb&)
		junk& = rtEZRequestA& (SADD("The number you entered was:" + r$ + _
									LTRIM$(STR$(longnum&)) + n$), + _
								SADD("So it was" + n$), _
								NULL&, NULL&, NULL&)
	ELSE
		junk& = rtEZRequestA& (SADD("You entered nothing :-(" + n$), + _
								SADD("I'm sorry" + n$), _
								NULL&, NULL&, NULL&)
	END IF

	'--- rtEZRequestA -------------------------------------------------------

	junk& = rtEZRequestA& (SADD("NUMBER 3:" + r$ + _
								"Message requester, the requester" + r$ + _
								"you've been using all the time!" + r$ + _
								"function: rtEZRequestA&"+ n$), + _
							SADD("Show me more" + n$), _
							NULL&, NULL&, NULL&)
	
	junk& = rtEZRequestA& (SADD("Simplest usage: some body text and" + r$ + _
								"a single centered gadget."+ n$), + _
							SADD("Go it" + n$), _
							NULL&, NULL&, NULL&)

	WHILE rtEZRequestA& (SADD("You can also use two gadgets to" + r$ + _
									"ask the user something." + r$ + _
									"Do you understand?"+ n$), + _
								SADD("Of course|Not really" + n$), _
								NULL&, NULL&, NULL&) = FALSE&

		junk& = rtEZRequestA& (SADD("You are not one of the brightest are you?" + r$ + _
									"We'll try again..."+ n$), + _
								SADD("Ok" + n$), _
								NULL&, NULL&, NULL&)
	WEND

	junk& = rtEZRequestA& (SADD("Great, we'll continue then." + n$), _
								SADD("Fine" + n$), _
								NULL&, NULL&, NULL&)

	ret& = rtEZRequestA& (SADD("You can also put up a requester with" + r$ + _
								"three choices." + r$ + _
								"How do you like the demo so far ?"+ n$), + _
							SADD("Great|So so|Rubbish" + n$), _
							NULL&, NULL&, NULL&)
	SELECT CASE ret&
		CASE FALSE&
			junk& = rtEZRequestA& (SADD("Too bad, I really hoped you" + r$ + _
										"would like it better." + n$), _
									SADD("So what" + n$), _
									NULL&, NULL&, NULL&)
		CASE TRUE&
			junk& = rtEZRequestA& (SADD("I'm glad you like it so much." + n$), _
									SADD("Fine" + n$), _
									NULL&, NULL&, NULL&)
		CASE 2&
			junk& = rtEZRequestA& (SADD("Maybe if you run the demo again" + r$ + _
										"you'll REALLY like it." + n$), _
									SADD("Perhaps" + n$), _
									NULL&, NULL&, NULL&)
	END SELECT
	
	TAGLIST tagb&, RTEZ_DefaultResponse&, 4&, TAG_END&
	
	ret& = rtEZRequestA& (SADD("The number of responses is not limited to three" + r$ + _
								"as you can see.  The gadgets are labeled with" + r$ + _
								"the return code from rtEZRequest()." + r$ + _
								"Pressing Return will choose 4, note that" + r$ + _
								"4's button text is printed in boldface." + n$), + _
							SADD("1|2|3|4|5|0" + n$), _
							NULL&, NULL&, tagb&)
	
	junk& = rtEZRequestA& (SADD("You picked " + LTRIM$(STR$(ret&)) + n$), + _
								SADD("How true" + n$), _
								NULL&, NULL&, NULL&)

	TAGLIST tagb&, RT_Underscore&, "_"%, TAG_END&						
	
	ret& = rtEZRequestA& (SADD("New for Release 2.0 of ReqTools (V38) is" + r$ + _
								"the possibility to define characters in the" + r$ + _
								"buttons as keyboard shortcuts." + r$ + _
								"As you can see these characters are underlined." + r$ + _
								"Pressing shift while still holding down the key" + r$ + _
								"will cancel the shortcut." + r$ + _
								"Note that in other requesters a string gadget may" + r$ + _
								"be active.  To use the keyboard shortcuts there" + r$ + _
								"you have to keep the Right Amiga key pressed down." + n$), + _
							SADD("_Great|_Fantastic|_Swell|Oh _Boy" + n$), _
							NULL&, NULL&, tagb&)

	TAGLIST tagb&, _
		RT_Underscore&, "_"%, _
		RT_IDCMPFlags&, IDCMP_DISKINSERTED&, _
	TAG_END&
	
	IF rtEZRequestA& (SADD("It is also possible to pass extra IDCMP flags" + r$ + _
							"that will satisfy rtEZRequest(). This requester" + r$ + _
							"has had DISKINSERTED passed to it." + r$ + _
							"(Try inserting a disk)." + n$), + _
						SADD("_Continue" + n$), _
						NULL&, NULL&, tagb&)

		junk& = rtEZRequestA& (SADD("You inserted a disk." + n$), _
								SADD("I did" + n$), _
							NULL&, NULL&, NULL&)
	ELSE
		junk& = rtEZRequestA& (SADD("You used the 'Continue' gadget." + n$), _
								SADD("I did" + n$), _
							NULL&, NULL&, NULL&)
	END IF

	TAGLIST tagb&, _
		RT_Underscore&, "_"%, _
		RT_ReqPos&,		REQPOS_TOPLEFTSCR&, _
	TAG_END&
	
	junk& = rtEZRequestA& (SADD("Finally, it is possible to specify the position" + r$ + _
								"of the requester." + r$ + _
								"E.g. at the top left of the screen, like this." + r$ + _
								"This works for all requesters, not just rtEZRequest()!" + n$), + _
							SADD("_Amazing" + n$), _
							NULL&, NULL&, tagb&)

	TAGLIST tagb&, RT_ReqPos&, REQPOS_CENTERSCR&, TAG_END&

	junk& = rtEZRequestA& (SADD("Alternatively, you can center the" + r$ + _
								"requester on the screen." + r$ + _
								"Check out 'reqtools.bh' for all the possibilities." + n$), + _
							SADD("I'll do that" + n$), _
							NULL&, NULL&, tagb&)

	'--- rtFileRequest ------------------------------------------------------

	TAGLIST tagb&, RT_Underscore&, "_"%, TAG_END&
	
	junk& = rtEZRequestA& (SADD("NUMBER 4:" + r$ + _
								"File requester" + r$ + _
								"function: rtFileRequestA&" + n$), + _
							SADD("_Demonstrate" + n$), _
							NULL&, NULL&, tagb&)
	
	fhook& = AllocVec&(Hook_sizeof%, MEMF_PUBLIC& OR MEMF_CLEAR&)
	INITHOOK fhook&, VARPTRS(FilterDemo&)
	
	POKEB wbuf&, 0%
	TAGLIST tagb&, RTFI_FilterFunc& , fhook&, TAG_END&
	
	filereq& = rtAllocRequestA&(RT_FILEREQ&, NULL&)
	IF filereq&
		
		WINDOW 1,"Simple Filterhook - Demo",(10,20) - (PEEKW(SYSTAB) \ 3, PEEKW(SYSTAB + 2) - 40), 23
		PRINT "These Filenames includes a 'a' and"
		PRINT "turn out in the Listview:" : PRINT
		
		IF rtFileRequestA&(filereq&, wbuf&, SADD("Pick a File:" + n$), tagb&)
			junk& = rtEZRequestA& (SADD("You picked the file:" + r$ +_
										PEEK$(wbuf&) + r$ + _
										"in directory:" + r$ + _
										PEEK$(PEEKL(filereq& + rtfi_Dir%)) + n$), _
									SADD("Right" + n$), _
									NULL&, NULL&, NULL&)
		ELSE
			junk& = rtEZRequestA& (SADD("You didn't pick a file." + n$), _
									SADD("No" + n$), _
									NULL&, NULL&, NULL&)
		END IF
	
		SetWindowTitles WINDOW(7), NULL&, NULL&
		CLS
		
		TAGLIST tagb&, RT_Underscore&, "_"%, TAG_END&
	
		junk& = rtEZRequestA& (SADD("The file requester has the ability" + r$ + _
									"to allow you to pick more than one" + r$ + _
									"file (use Shift to extend-select)." + r$ + _
									"Note the extra gadgets you get." + n$), + _
								SADD("_Interesting" + n$), _
								NULL&, NULL&, tagb&)
	
		TAGLIST tagb&, RTFI_Flags&, FREQ_MULTISELECT&, TAG_END&
	
		flist& = rtFileRequestA&(filereq&, wbuf&, SADD("Pick some Files:" + n$), tagb&)
	
		IF flist&
			SetWindowTitles WINDOW(7), SADD("Selected Entrys:" + n$), NULL&

			tempflist& = flist&
			WHILE tempflist&
				PRINT PEEK$(PEEKL(tempflist& + rtfl_Name%))
				tempflist& = PEEKL(tempflist& + rtfl_Next%)
			WEND
			rtFreeFileList flist&
		
			junk& = rtEZRequestA& (SADD("See results in the left window." + n$), _
										SADD("Yeah" + n$), _
										NULL&, NULL&, NULL&)
		END IF	
		WINDOW CLOSE 1
		
		junk& = rtEZRequestA& (SADD("The file requester can be used" + r$ + _
									"as a directory requester as well."+ n$), _
									SADD("Let's see that" + n$), _
									NULL&, NULL&, NULL&)
		
		TAGLIST tagb&, RTFI_Flags&, FREQ_NOFILES&, TAG_END&
		POKEB wbuf&, 0%
		
		IF rtFileRequestA&(filereq&, wbuf&, SADD("Pick a diretory:" + n$), tagb&)
			junk& = rtEZRequestA& (SADD("You picked the directory:" + r$ + _
										PEEK$(PEEKL(filereq& + rtfi_Dir%)) + n$), _
										SADD("Right" + n$), _
										NULL&, NULL&, NULL&)
		ELSE
			junk& = rtEZRequestA& (SADD("You didn't pick a directory." + n$), _
										SADD("No" + n$), _
										NULL&, NULL&, NULL&)
		END IF	
		rtFreeRequest filereq&
	END IF
	
	FreeVec fhook&
	
	'--- rtFontRequest ------------------------------------------------------

	junk& = rtEZRequestA& (SADD("NUMBER 5:" + r$ + _
								"Font Requester" + r$ + _
								"function: rtFontRequestA&" + n$), _
							SADD("Show" + n$), _
							NULL&, NULL&, NULL&)
		
	fontreq& = rtAllocRequestA&(RT_FONTREQ&, NULL&)
	IF fontreq&
		POKEL fontreq& + rtfo_Flags%, FREQ_STYLE& OR FREQ_COLORFONTS&
		
		IF rtFontRequestA&(fontreq&, SADD("Pick a Font:" + n$), NULL&)
			fontname$ = PEEK$(PEEKL(fontreq& + rtfo_Attr% + ta_Name%))
			fontsize% = PEEKW(fontreq& + rtfo_Attr% + ta_YSize%)
			junk& = rtEZRequestA& (SADD("You picked the font:" + r$ + _
										fontname$ + r$ + _
										"with size:" + STR$(fontsize%) + n$), _
									SADD("Right" + n$), _
									NULL&, NULL&, NULL&)
		ELSE
			junk& = rtEZRequestA& (SADD("You canceled." + r$ + _
										"Was there no font you liked ?" + n$), _
									SADD("Nope" + n$), _
									NULL&, NULL&, NULL&)
		END IF
		rtFreeRequest fontreq&
	END IF
	
	'--- rtPaletteRequest ---------------------------------------------------
	
	junk& = rtEZRequestA& (SADD("NUMBER 6:" + r$ + _
								"Palette Requester" + r$ + _
								"function: rtPaletteRequestA&" + n$), _
							SADD("Proceed" + n$), _
							NULL&, NULL&, NULL&)
		
	col& = rtPaletteRequestA& (SADD("Change palette:" + n$), NULL&, NULL&)
	
	IF col& = -1
		junk& = rtEZRequestA& (SADD("You canceled." + r$ + _
									"No nice colors to be picked ?" + n$), _
									SADD("Nah" + n$), _
									NULL&, NULL&, NULL&)
	ELSE
		junk& = rtEZRequestA& (SADD("You picked color number" + STR$(col&) + n$), _
									SADD("Sure did" + n$), _
									NULL&, NULL&, NULL&)
	END IF
	
	'--- [VolumeRequest] ----------------------------------------------------
	
	junk& = rtEZRequestA& (SADD("NUMBER 7: (ReqTools 2.0)" + r$ + _
								"Volume Requester" + r$ + _
								"function: rtFileRequestA&" + n$), _
							SADD("Show me" + n$), _
							NULL&, NULL&, NULL&)
	
	TAGLIST tagb&, RTFI_VolumeRequest&, NULL&, TAG_END&
	
	filereq& = rtAllocRequestA&(RT_FILEREQ&, NULL&)
	IF filereq&
				
		IF rtFileRequestA&(filereq&, wbuf&, SADD("Pick a Volume:" + n$), tagb&)
			junk& = rtEZRequestA& (SADD("You picked the Volume:" + r$ +_
										PEEK$(PEEKL(filereq& + rtfi_Dir%)) + n$), _
									SADD("Right" + n$), _
									NULL&, NULL&, NULL&)
		ELSE
			junk& = rtEZRequestA& (SADD("You didn't pick a volume." + n$), _
									SADD("I did not" + n$), _
									NULL&, NULL&, NULL&)
		END IF
		rtFreeRequest filereq&
	END IF
	
	'--- rtScreenModeRequest ------------------------------------------------

	junk& = rtEZRequestA& (SADD("NUMBER 8: (ReqTools 2.0)" + r$ + _
								"Screen mode requester" + r$ + _
								"function: rtScreenModeRequestA&" + n$), _
							SADD("Show me" + n$), _
							NULL&, NULL&, NULL&)
	
	scrmodereq& = rtAllocRequestA&(RT_SCREENMODEREQ&, NULL&)
	IF scrmodereq&
		
		TAGLIST tagb&, _
			RTSC_Flags&,	SCREQ_DEPTHGAD& OR SCREQ_SIZEGADS& OR SCREQ_AUTOSCROLLGAD& _
							OR SCREQ_OVERSCANGAD&, _
		TAG_END&
		
		IF rtScreenModeRequestA&(scrmodereq&, SADD("Pick a screen mode:" + n$), tagb&)
			
			smodeid& =	PEEKL(scrmodereq& + rtsc_DisplayID%)
			swidth% =	PEEKW(scrmodereq& + rtsc_DisplayWidth%)
			sheight% =	PEEKW(scrmodereq& + rtsc_DisplayHeight%)
			sdepth% =	PEEKW(scrmodereq& + rtsc_DisplayDepth%)
			oscant%	=	PEEKW(scrmodereq& + rtsc_OverscanType%)
			SELECT CASE oscant%
				CASE OSCAN_MAX& : oversc$ = "maximal"
				CASE OSCAN_STANDARD& : oversc$ = "standard"
				CASE OSCAN_TEXT& : oversc$ = "text"
				CASE OSCAN_VIDEO& : oversc$ = "video"
				CASE REMAINDER : oversc$ = "no"
			END SELECT
 			IF PEEKL(scrmodereq& + rtsc_AutoScroll%)
				ascroll$ = "on"
			ELSE
				ascroll$ = "off"
			END IF
			
			junk& = rtEZRequestA& (SADD("You picked this mode:" + r$ + _
										"ModeID: &H" + HEX$(smodeid&) + r$ + _
										"Size:" + STR$(swidth%) + " x "  + _
										STR$(sheight%) + r$ + _
										"Depth:" + STR$(sdepth%) + r$ + _
										"Overscan: " + oversc$ + r$ + _
										"AutoScroll: " + ascroll$ + n$), _
									SADD("Right" + n$), _
									NULL&, NULL&, NULL&)
		ELSE
			junk& = rtEZRequestA& (SADD("You didn't pick a screen mode." + n$), _
									SADD("Nope" + n$), _
									NULL&, NULL&, NULL&)
		END IF
		rtFreeRequest scrmodereq&
	END IF

	'--- Good bye! ----------------------------------------------------------

	TAGLIST tagb&, RT_Underscore&, "_"%, TAG_END&

	junk& = rtEZRequestA& (SADD("That's it!" + r$ + "Hope you enjoyed the demo." + n$), _
							SADD("_Sure did" + n$), _
							NULL&, NULL&, tagb&)
		
	FreeVec wbuf&	
	Demo& = RETURN_OK&
END FUNCTION

'----------------------------------------------------------------------------
	
STOP Demo&

DATA "$VER: ReqToolsDemo.bas V1.0 $"