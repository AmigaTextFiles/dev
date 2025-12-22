OPT PREPROCESS

MODULE	'intuition/intuition',
	'intuition/screens',
	'dos/dos',
	'libraries/swazblanker','swazblanker',
	'libraries/swazconfig','swazconfig'

/*
 * Initialize blank-module!
 */

PROC main()
DEF sbinit:PTR TO sbinit,met
IF (swazblankerbase:=OpenLibrary(SWAZBLANKERNAME,0))
	IF (swazconfigbase:=OpenLibrary(SWAZCONFIGNAME,0))
		IF (sbinit:=Sb_InitTagList([SBINIT_Name, 'Example', 0]))
			met:=sbinit.method
			SELECT met
				CASE SBINIT_METHOD_BLANK		/**** Now blanker ***/
					blank()
				CASE SBINIT_METHOD_PREFS		/**** Configuration of blank ***/
					prefs()
				CASE SBINIT_METHOD_INFO			/**** Informations ***/
					Sb_PrintInfoTagList(sbinit,[
					SBINFO_Author,		'Authors Name (Nick)',
					SBINFO_EMail,		'author@author.com',
					SBINFO_ShortDesc,	'Very short description',
					SBINFO_LongDesc,	'Long multi line description',
					SBINFO_Version,		20,
					SBINFO_Revision,	2,
					SBINFO_CPULoading,	SBINFOLOAD_MEDIUM,
					0])
			ENDSELECT
		Sb_FreeInit( sbinit )
		ENDIF
	CloseLibrary(swazconfigbase)
	ENDIF
CloseLibrary(swazblankerbase)
ENDIF
ENDPROC

/*
 * Blank screen. (short example!)
 */

PROC blank()
DEF screen:PTR TO screen
DEF window:PTR TO window,cspec
cspec:=[0,0,0,0,-1]:INT
screen := Sb_OpenScreenTagList(
			[SA_DISPLAYID,	0,
			 SA_DEPTH,	1,
			 SA_COLORS,	cspec,
			 0])

IF (screen)
	window:= Sb_OpenWindowTagList([
			WA_CUSTOMSCREEN, screen,
			0])

	IF (window)
		Sb_SetBlankerScreen( screen, window)
		Sb_BlankerReady()

		Wait(SIGBREAKF_CTRL_C)

		Sb_ClrBlankerScreen( screen, window)
		CloseWindow(window)
	ENDIF
	CloseScreen(screen)
ENDIF
ENDPROC

/*
 * Preferences open.
 */

PROC prefs()
DEF bpn:PTR TO blankerprefsnode
	IF (bpn := Sb_AddPrefsTaskTagList('BlankExample',NIL) )
		req('BLANK EXAMPLE','Prefs not found!','OK')
		Sb_RemPrefsTask(bpn)
	ENDIF
ENDPROC

/*
 * sys-requester.
 */

PROC req(a,b,c) RETURN EasyRequestArgs(NIL,[SIZEOF easystruct,0,a,b,c]:easystruct,NIL,NIL)

/*
 * Must be that!
 * Identify blank module across SwazBlanker main-program.
 */

CHAR 0,'$BLANKER:Ver 2:',0
