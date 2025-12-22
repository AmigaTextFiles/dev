'	WBStarter.bas V1.0
'	Start Workbench - Programs an Projects via wbstart.library
'   by Steffen Leistner 1996, for HiSoft/Maxon BASIC Compiler
'	TABWIDTH = 4

REM $NOLIBRARY
REM $NOWINDOW

REM $INCLUDE exec.bh
REM $INCLUDE dos.bh
REM $INCLUDE asl.bh
REM $INCLUDE icon.bh
REM $INCLUDE wbstart.bh
REM $INCLUDE workbench.bh
REM $INCLUDE utility.bh			'for div. constants

CONST minver& = 37&				'Kickstart 2.0+
CONST wbufsize& = 512&			'enough for filename - operations and taglists!

LIBRARY OPEN "exec.library", minver&
LIBRARY OPEN "dos.library", minver&
LIBRARY OPEN "asl.library", minver&
LIBRARY OPEN "icon.library", minver&
LIBRARY OPEN "wbstart.library", 2&

'----------------------------------------------------------------------------

FUNCTION WBObjectFilter&(BYVAL hk&, BYVAL rq&, BYVAL ap&)
	SHARED wbuf&
	STATIC fln$, tmp$, flh&, dob&, junk&			'static for more speed
	WBObjectFilter& = FALSE&
	
	IF PEEKL(ap& + ap_Info% + fib_DirEntryType%) > NULL&
		WBObjectFilter& = TRUE&
		EXIT FUNCTION								'a directory -> listed
	END IF	
	
	fln$ = PEEK$(ap& + ap_Info% + fib_FileName%)
	IF RIGHT$(fln$, 5) == ".info"
		EXIT FUNCTION								'a icon -> not listed
	END IF
	
	tmp$ = PEEK$(PEEKL(rq& + fr_Drawer%)) + CHR$(0)
	CopyMem SADD(tmp$), wbuf&, LEN(tmp$)
	
	IF AddPart&(wbuf&, ap& + ap_Info% + fib_FileName%, wbufsize&)
		tmp$ = PEEK$(wbuf&) + CHR$(0)
		flh& = xOpen&(wbuf&, MODE_OLDFILE&)
		IF flh&
			junk& = xRead&(flh&, wbuf&, 4&)
			junk& = xClose&(flh&)
			IF PEEKL(wbuf&) = &H000003F3&	
				WBObjectFilter& = TRUE&				'a executable file
				EXIT FUNCTION
			END IF
		ELSE
			EXIT FUNCTION
		END IF		
		
		dob& = GetDiskObject& (SADD(tmp$))			'check for icon
		IF dob&
			IF PEEK$(PEEKL(dob& + do_DefaultTool%)) > ""
				WBObjectFilter& = TRUE&				'a project with defaulttool
			END IF
			FreeDiskObject dob&
		END IF
	END IF
END FUNCTION


FUNCTION SelectProgram$
	SHARED wbuf&, objfilterhook&
	LOCAL req&, dir$
	SelectProgram$ = ""
	
	req& = AllocAslRequest&(ASL_FileRequest&, NULL&)
	IF req&
		TAGLIST wbuf&, _
			ASLFR_FilterFunc&,		objfilterhook&, _
			ASLFR_TitleText&,		"Select a Program or Project:", _
			ASLFR_PositiveText&,	"Run it!", _
			ASLFR_InitialDrawer&,	CURDIR$, _
		TAG_END&

		IF AslRequest&(req&, wbuf&)
			dir$ = PEEK$(PEEKL(req& + fr_Drawer%)) + CHR$(0)
			CopyMem SADD(dir$), wbuf&, LEN(dir$)
			IF AddPart&(wbuf&, PEEKL(req& + fr_File%), wbufsize&)
				SelectProgram$ = PEEK$(wbuf&)
			END IF
		END IF
		FreeAslRequest req&
	END IF
END FUNCTION


FUNCTION WBRun&(pn$)
	SHARED wbuf&
	LOCAL oldlock&, junk&
	WBRun& = RETURN_WARN&

	oldlock& = CurrentDir&(NULL&)		'the current dir
	TAGLIST wbuf&, _
		WBStart_Name&,			pn$, _
		WBStart_DirectoryLock,	oldlock&, _
	TAG_END&
	
	WBRun& = WBStartTagList&(wbuf&)		'result = dos-returncode
	
	junk& = CurrentDir&(oldlock&)		'restore current dir
END FUNCTION


FUNCTION Main&							';-)
	SHARED wbuf&, objfilterhook&
	LOCAL para$
	Main& = RETURN_ERROR&
	wbuf& = AllocVec& (wbufsize&, MEMF_PUBLIC& OR MEMF_CLEAR&)

	IF wbuf&
		Main& = RETURN_FAIL&
		para$ = COMMAND$
		
		IF (para$ = "") OR (FEXISTS(para$) = NULL&)
			objfilterhook& = AllocVec&(Hook_sizeof%, MEMF_PUBLIC& OR MEMF_CLEAR&)
			IF objfilterhook&
				INITHOOK objfilterhook&, VARPTRS(WBObjectFilter&)
			
				para$ = SelectProgram$
			
				FreeVec objfilterhook&
			END IF
		END IF
		IF FEXISTS(para$)
			Main& = WBRun&(para$)
		ELSE
			Main& = RETURN_WARN&
		END IF
		
		FreeVec wbuf&
	END IF
END FUNCTION

'----------------------------------------------------------------------------

STOP Main&

DATA	"$VER: WBStarter in Basic V1.0 $"