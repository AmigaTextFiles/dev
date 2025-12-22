/* $VER: PBCompiler-GUI.rexx ENG 1.2 (19-Nov-2000) by A.Greve */

editor      = 'CED:ed'
sourcepath  = 'PureBasic:Projects/'
quickhelp   = 1
usesettings = 1
forgetwin   = 1
mviewpath   = 'SYS:Utilities/MultiView'
createicon  = 1

/**********************************************************/
/**  Don't change the code below these lines, unless     **/
/**  You know what You're doin'...                       **/
/**********************************************************/

pbpath   = 'PureBasic:'
compiler = pbpath'Compilers/PBCompiler'
guipath  = pbpath'GUI/PBCompiler-GUI.rexx'
helppath = pbpath'Help/Reference.guide'
guihelp  = pbpath'GUI/PBCompiler-GUI.guide'
iconpath = pbpath'Compilers/Default_Icon.info'

new_out = 0
lf = '0a'x; qu = '22'x
srcfile  = ''; exefile = ''; resfile = ''; prio = 0
qh1 = 'Path and filename for the'lf
line1 = '; PBCompiler-GUI settings'

IF ~SHOW('L','tritonrexx.library') THEN DO
	IF ~ADDLIB('tritonrexx.library',10,-30,0) THEN DO
		SAY 'Couldn''t open <tritonrexx.library> !'
		EXIT(10)
	END
END
IF ~SHOW('L','rexxtricks.library') THEN DO
	IF ~ADDLIB('rexxtricks.library',10,-30,0) THEN DO
		SAY 'Couldn''t open <rexxtricks.library> !'
		EXIT(10)
	END
END
IF ~SHOW('L','rexxsupport.library') THEN DO
	IF ~ADDLIB('rexxsupport.library',10,-30,0) THEN DO
		SAY 'Couldn''t open <rexxsupport.library> !'
		EXIT(10)
	END
END

srcfile = RXTR_GETENV('PureBasic_SourceName')

get_ps = RXTR_GETTOOLTYPEVALUE(guipath,'PUBSCREEN')
IF get_ps ~= '' THEN DO
	PubScreen = get_ps
	IF ~RXTR_PUBSCREENTOFRONT(get_ps) THEN DO
		PARSE ARG PubScreen
		IF PubScreen = '' THEN PubScreen = 'Workbench'
	END
END
ELSE DO
	PARSE ARG PubScreen
	IF PubScreen = '' THEN PubScreen = 'Workbench'
	CALL RXTR_PUBSCREENTOFRONT(PubScreen)
END
CALL CLOSE STDOUT
new_out = OPEN(STDOUT, 'CON://640/100/Rx Output/SCREEN 'PubScreen, W)

SetVar(1,1,'quickhelp',0)
SetVar(1,0,'editor','ed')
SetVar(1,0,'sourcepath',pbpath)
SetVar(1,1,'usesettings',0)
SetVar(1,1,'forgetwin',0)
SetVar(0,0,'mviewpath','SYS:Utilities/MultiView')
SetVar(1,1,'createicon',0)

appname     = 'PBCompiler-GUI'
applongname = 'PBCompiler-GUI ENG - ©2000 by Axel Greve'
appinfo     = 'GUI for the PureBasic compiler'
appversion  = '1.2'
apprelease  = '3'
appdate     = '19-Nov-2000'

wintags =	WindowID(1) WindowTitle(appname' ENG 'appversion) WindowPosition('TRWP_CENTERDISPLAY'),
			PubScreenName(PubScreen) QuickHelpOn(quickhelp),
				'VertGroupA' 'Space',
					'HorizGroupC' 'Space',
						TextID("_Sourcefile",11) 'SpaceS' GetFileButton(11),
						StringGadget(srcfile,12) QuickHelp(qh1"sourcefile (#?.pb)") 'Space',
					'EndGroup' 'SpaceS',
					'HorizGroupC' 'Space',
						TextID("E_xecutable",21) 'SpaceS' GetFileButton(21),
						StringGadget('',22) QuickHelp(qh1"executable to create") 'Space',
					'EndGroup' 'SpaceS',
					'HorizGroupC' 'Space',
						TextID("Create_Res.",31) 'SpaceS' GetFileButton(31),
						StringGadget('',32) QuickHelp(qh1"resident file to create") 'Space',
					'EndGroup' 'SpaceS',
					'HorizGroupC' 'Space',
						TextID("_Priority",41) 'SpaceS' ClippedTextBoxMW('   0',42,4),
						SliderGadget(0,254,127,41) QuickHelp("Priority for the compiler"lf"Usual values: -10 ... +10"),
						GetEntryButton(43) QuickHelp("Set priority to 0") TextID(" _0",43) 'Space',
					'EndGroup' 'SpaceS',
					'HorizGroupC' 'Space',
						CheckBox(51) TextID(" _Optimizations    ",51) QuickHelp("Enable compiler optimizations for"lf"shorter and faster executables"),
						'SpaceB' 'SpaceB' 'SpaceB',
						CheckBox(52) TextID(" MC680_20          ",52) QuickHelp("Enable optimizations"lf"for 020+ executables"),
					'EndGroup' 'SpaceS',
					'HorizGroupC' 'Space',
						CheckBox(61) TextID(" _Debugger         ",61) QuickHelp("Enable debugger support"),
						'SpaceB' 'SpaceB' 'SpaceB',
						CheckBox(62) TextID(" NoCo_mment        ",62) QuickHelp("Turn off comments in"lf"the assembler output"),
					'EndGroup' 'SpaceS',
					'HorizGroupC' 'Space',
						CheckBox(71) TextID(" _AmigaOS          ",71) QuickHelp("Load AmigaOS libraries support"),
						'SpaceB' 'SpaceB' 'SpaceB',
						CheckBox(72) TextID(" Po_werPC          ",72) QuickHelp("Create PPC executables for WarpOS"),
					'EndGroup' 'SpaceS',
					'HorizGroupC' 'Space',
						CheckBox(81) TextID(" _NoResident       ",81) QuickHelp("Disable resident loading"),
					'EndGroup' 'Space',
					'HorizSeparator' 'Space',
					'HorizGroupC' 'Space',
						CheckBox(951) TextID(" _Use settings     ",951) QuickHelp("Use GUI settings from the"lf"source directory (*.§§)"),
						'SpaceB' 'SpaceB' 'SpaceB',
						CheckBox(952) TextID(" _Forget window    ",952) QuickHelp("Forget window position"lf"after quitting the GUI"),
					'EndGroup' 'Space',
					'HorizGroupC' 'Space',
						CheckBox(953) TextID(" Create _Icon      ",953) QuickHelp("Create an icon for"lf"the executable file"),
						'SpaceB' 'SpaceB' 'SpaceB',
						TextID("Stack Si_ze ",954) StringGadget('4096',954) QuickHelp("Presetting"lf"for stack size"),
						GetEntryButton(955) QuickHelp("Set stack to 4096") TextID(" _4096",955) 'Space',
					'EndGroup' 'SpaceB',
					'HorizGroupEC' 'Space',
						Button("_Compile!",996) QuickHelp("Start compiling") 'Space',
						Button("_Fake",997) QuickHelp("View compiler call") 'SpaceB' 'SpaceB' TextN(" "),
						Button("_Edit Src",998) QuickHelp("Edit sourcefile") 'SpaceB' 'SpaceB',
						Button("Quit",999) QuickHelp("Quit GUI") 'Space',
					'EndGroup' 'Space',
				'EndGroup',
			'EndProject'

SIGNAL ON break_c
SIGNAL ON failure
SIGNAL ON halt
SIGNAL ON ioerr
SIGNAL ON syntax

app = 	TR_CREATEAPP('TRCA_Name'     '"'appname'"',
					 'TRCA_LongName' '"'applongname'"',
					 'TRCA_Info'     '"'appinfo'"',
					 'TRCA_Version'  '"'appversion'"',
					 'TRCA_Release'  '"'apprelease'"',
					 'TRCA_Date'     '"'appdate'"',
					 'TAG_END')

IF app ~= '00000000'x THEN DO
	win = TR_OPENPROJECT(app,wintags)
	IF win ~= '00000000'x THEN DO

		IF usesettings THEN TR_SETATTRIBUTE(win,951,'TRAT_Value',1)
		IF forgetwin   THEN TR_SETATTRIBUTE(win,952,'TRAT_Value',1)
		IF createicon  THEN TR_SETATTRIBUTE(win,953,'TRAT_Value',1)
		ELSE CALL ToggleStack
		IF srcfile ~= '' THEN DO
			TR_SETATTRIBUTE(win,998,'TRAT_Disabled',1)
			IF usesettings THEN CALL LoadSettings
		END

		wind = C2D(win)
		ende = 0
		DO WHILE ende ~= 1
			CALL TR_WAIT(app,'')
			DO WHILE TR_HANDLEMSG(app,'event')

				IF event.trm_class = 'TRMS_KEYPRESSED' THEN DO
					qual = D2C(event.trm_qualifier)
					code = event.trm_code
					IF code = 95 & ~BITTST(qual,9) THEN DO
						IF BITTST(qual,0) | BITTST(qual,1) THEN
							ADDRESS COMMAND 'Run >NIL: 'qu''mviewpath''qu' 'qu''guihelp''qu' SCREEN'
						ELSE
							ADDRESS COMMAND 'Run >NIL: 'qu''mviewpath''qu' 'qu''helppath''qu' SCREEN'
					END
				END

				IF event.trm_class = 'TRMS_NEWVALUE' THEN DO
					id = event.trm_id
					SELECT
						WHEN id = 12 THEN DO
							srcfile = TR_GETATTRIBUTE(win,id,'TROB_String')
							IF TR_GETATTRIBUTE(win,951,'TRAT_Value') THEN CALL LoadSettings
						END
						WHEN id = 22 THEN DO
							exefile = TR_GETATTRIBUTE(win,id,'TROB_String')
							CALL LoadStackVal
						END
						WHEN id = 32 THEN resfile = TR_GETATTRIBUTE(win,id,'TROB_String')
						WHEN id = 41 THEN DO
							prio = event.trm_data - 127
							TR_SETATTRIBUTE(win,42,'TRAT_Text',RIGHT('   'prio,4))
						END
						WHEN id = 952 THEN forgetwin = TR_GETATTRIBUTE(win,id,'TRAT_Value')
						WHEN id = 953 THEN CALL ToggleStack
					OTHERWISE
						NOP
					END
				END

				IF event.trm_class = 'TRMS_ACTION' THEN DO
					id = event.trm_id
					SELECT
						WHEN id = 11 | id = 21 | id = 31 THEN CALL Request
						WHEN id = 43 THEN DO
							prio = 0
							TR_SETATTRIBUTE(win,41,'TRAT_Value',127)
							TR_SETATTRIBUTE(win,42,'TRAT_Text','   0')
						END
						WHEN id = 955 THEN TR_SETATTRIBUTE(win,954,'TROB_String','4096')
						WHEN id = 996 THEN CompileIt(1)
						WHEN id = 997 THEN CompileIt(0)
						WHEN id = 998 THEN ADDRESS COMMAND editor' 'qu''srcfile''qu
						WHEN id = 999 THEN ende = 1
					OTHERWISE
						NOP
					END
				END

				IF event.trm_class = 'TRMS_CLOSEWINDOW' THEN ende = 1

			END
		END
		CALL TR_CLOSEPROJECT(win)
	END
	CALL TR_DELETEAPP(app)
END

IF new_out THEN CALL CLOSE STDOUT
IF forgetwin THEN CALL RXTR_UNSETENV('Triton/PBCompiler-GUI.win.1')
EXIT(0)

SetVar:
	PARSE ARG CheckTT,Logical,VarName,Default
	IF CheckTT THEN DO
		get_tt = RXTR_GETTOOLTYPEVALUE(guipath,UPPER(VarName))
		IF Logical THEN DO
			IF get_tt ~= '' THEN DO
				IF get_tt = 'YES' | get_tt = 'ON' | get_tt = '1' THEN INTERPRET VarName' = 1'
				ELSE INTERPRET VarName' = 0'
			END
		END
		ELSE DO
			IF get_tt ~= '' THEN INTERPRET VarName' = 'get_tt
		END
	END
	IF VALUE(VarName) == UPPER(VarName) THEN INTERPRET VarName' = 'Default
RETURN 0

Request:
	sel = LEFT(id, 1)
    pattern = ''
	IF sel = 1 THEN pattern = '#?.pb'
	title = 'Select 'SUBWORD('sourcefile executable residentfile', sel, 1)
	actpath = VALUE(SUBWORD('source source pb', sel, 1)'path')
	bool = ASL_REQUESTFILE(win,fname,"ASLFR_PubScreenName "PubScreen "ASLFR_TitleText "title,
			   "ASLFR_RejectIcons" 1 "ASLFR_InitialDrawer" actpath "ASLFR_InitialPattern" pattern)
	IF bool = 1 THEN DO
		TR_SETATTRIBUTE(win,event.trm_id+1,'TROB_String',fname.1)
		SELECT
			WHEN sel = 1 THEN DO
				srcfile = fname.1
				IF TR_GETATTRIBUTE(win,951,'TRAT_Value') THEN CALL LoadSettings
			END
			WHEN sel = 2 THEN DO
				exefile = fname.1
				CALL LoadStackVal
			END
			WHEN sel = 3 THEN resfile = fname.1
		OTHERWISE
			NOP
		END
	END
RETURN

SaveSettings:
	IF EXISTS(srcfile) THEN DO
		IF UPPER(RIGHT(RXTR_FILEPART(srcfile), 3)) == '.PB' THEN DO
			out_txt = line1''lf
			out_txt = out_txt'; This file was created on 'DATE()', 'TIME()'  by PBCompiler-GUI'lf
			out_txt = out_txt'; for the PureBasic source file 'qu''srcfile''qu''lf
			out_txt = out_txt'; Don''t edit this file by hand!!!'lf';'lf
			IF exefile ~= '' THEN out_txt = out_txt'TO='exefile''lf
			IF resfile ~= '' THEN out_txt = out_txt'CR='resfile''lf
			IF TR_GETATTRIBUTE(win,51,'TRAT_Value') THEN out_txt = out_txt'OPT'lf
			IF TR_GETATTRIBUTE(win,52,'TRAT_Value') THEN out_txt = out_txt'MC68020'lf
			IF TR_GETATTRIBUTE(win,61,'TRAT_Value') THEN out_txt = out_txt'DB'lf
			IF TR_GETATTRIBUTE(win,62,'TRAT_Value') THEN out_txt = out_txt'NC'lf
			IF TR_GETATTRIBUTE(win,71,'TRAT_Value') THEN out_txt = out_txt'OS'lf
			IF TR_GETATTRIBUTE(win,72,'TRAT_Value') THEN out_txt = out_txt'PPC'lf
			IF TR_GETATTRIBUTE(win,81,'TRAT_Value') THEN out_txt = out_txt'NR'lf
			out_txt = out_txt'PRI='prio''lf
			out_txt = out_txt'###'

			CALL OPEN('outfile', LEFT(srcfile, LENGTH(srcfile) -2)'§§', 'W')
			CALL WRITECH('outfile', out_txt)
			CALL CLOSE('outfile')
			DROP out_txt
		END
	END
RETURN

LoadSettings:
	TR_LOCKPROJECT(win)
	IF EXISTS(srcfile) THEN DO
		IF UPPER(RIGHT(RXTR_FILEPART(srcfile), 3)) == '.PB' THEN DO
			CALL RXTR_READFILE(LEFT(srcfile, LENGTH(srcfile) -2)'§§', 'infile')
			IF infile.0 ~= 'INFILE.0' THEN DO
				IF infile.1 == line1 THEN DO
					TR_SETATTRIBUTE(win,22,'TROB_String',''); exefile = ''
					TR_SETATTRIBUTE(win,32,'TROB_String',''); resfile = ''
					TR_SETATTRIBUTE(win,41,'TRAT_Value',127); TR_SETATTRIBUTE(win,42,'TRAT_Text','   0')
					TR_SETATTRIBUTE(win,51,'TRAT_Value',0);   TR_SETATTRIBUTE(win,52,'TRAT_Value',0)
					TR_SETATTRIBUTE(win,61,'TRAT_Value',0);   TR_SETATTRIBUTE(win,62,'TRAT_Value',0)
					TR_SETATTRIBUTE(win,71,'TRAT_Value',0);   TR_SETATTRIBUTE(win,72,'TRAT_Value',0)
					TR_SETATTRIBUTE(win,81,'TRAT_Value',0);   prio = 0

					DO i = 2 TO infile.0
						SELECT
							WHEN LEFT(infile.i, 3) == 'TO=' THEN DO
								exefile = RIGHT(infile.i, LENGTH(infile.i) - 3)
								TR_SETATTRIBUTE(win,22,'TROB_String',exefile)
							END
							WHEN LEFT(infile.i, 3) == 'CR=' THEN DO
								resfile = RIGHT(infile.i, LENGTH(infile.i) - 3)
								TR_SETATTRIBUTE(win,32,'TROB_String',resfile)
							END
							WHEN LEFT(infile.i, 4) == 'PRI=' THEN DO
								prio = RIGHT(infile.i, LENGTH(infile.i) - 4)
								TR_SETATTRIBUTE(win,41,'TRAT_Value',127 + prio)
								TR_SETATTRIBUTE(win,42,'TRAT_Text',RIGHT('   'prio,4))
							END
							WHEN infile.i == 'OPT'     THEN TR_SETATTRIBUTE(win,51,'TRAT_Value',1)
							WHEN infile.i == 'MC68020' THEN TR_SETATTRIBUTE(win,52,'TRAT_Value',1)
							WHEN infile.i == 'DB'      THEN TR_SETATTRIBUTE(win,61,'TRAT_Value',1)
							WHEN infile.i == 'NC'      THEN TR_SETATTRIBUTE(win,62,'TRAT_Value',1)
							WHEN infile.i == 'OS'      THEN TR_SETATTRIBUTE(win,71,'TRAT_Value',1)
							WHEN infile.i == 'PPC'     THEN TR_SETATTRIBUTE(win,72,'TRAT_Value',1)
							WHEN infile.i == 'NR'      THEN TR_SETATTRIBUTE(win,81,'TRAT_Value',1)
							WHEN infile.i == '###'     THEN LEAVE
						OTHERWISE
							NOP
						END
					END
				END
			END
		END
	END
	DROP infile.
	TR_UNLOCKPROJECT(win)
RETURN

CompileIt:
	PARSE ARG RealMode
	TR_LOCKPROJECT(win)

	opts = qu''srcfile''qu
	IF exefile ~= '' THEN opts = opts' TO='qu''exefile''qu
	IF resfile ~= '' THEN opts = opts' CR='qu''resfile''qu
	IF TR_GETATTRIBUTE(win,51,'TRAT_Value') THEN opts = opts' OPT'
	IF TR_GETATTRIBUTE(win,52,'TRAT_Value') THEN opts = opts' MC68020'
	IF TR_GETATTRIBUTE(win,61,'TRAT_Value') THEN opts = opts' DB'
	IF TR_GETATTRIBUTE(win,62,'TRAT_Value') THEN opts = opts' NC'
	IF TR_GETATTRIBUTE(win,71,'TRAT_Value') THEN opts = opts' OS'
	IF TR_GETATTRIBUTE(win,72,'TRAT_Value') THEN opts = opts' PPC'
	IF TR_GETATTRIBUTE(win,81,'TRAT_Value') THEN opts = opts' NR'
	opts = opts' PRI='prio

	IF RealMode THEN DO
		IF srcfile = '' THEN DO
			EasyRequester(1,"Please select a PureBasic source!")
			TR_UNLOCKPROJECT(win)
			RETURN 0
		END

		flag1 = 0; flag2 = 0; exeprops = ''
		IF TR_GETATTRIBUTE(win,951,'TRAT_Value') THEN CALL SaveSettings
		IF TR_GETATTRIBUTE(win,953,'TRAT_Value') THEN DO
			flag1 = 1
			IF EXISTS(exefile) THEN exeprops = STATEF(exefile)
		END
		ADDRESS COMMAND compiler' 'opts
		SAY '*** Returncode: 'RC
		SAY ''
		IF flag1 THEN DO
			IF exeprops ~= '' THEN DO
				IF exeprops ~= STATEF(exefile) THEN flag2 = 1
			END
			ELSE flag2 = 1
		END
		IF flag2 THEN DO
			ergo = 1
			IF EXISTS(exefile'.info') THEN DO
				ergo = EasyRequester(2,"Icon already exists !"lf"Overwrite it ?")
				IF ergo = 1 THEN
					ADDRESS COMMAND 'Delete >NIL: 'qu''exefile'.info'qu
			END
			IF ergo = 1 THEN DO
				ADDRESS COMMAND 'Copy >NIL: 'qu''iconpath''qu' TO 'qu''exefile'.info'qu
				IF TR_GETATTRIBUTE(win,953,'TRAT_Value') THEN DO
					tmpstack = TR_GETATTRIBUTE(win,954,'TROB_String')
					IF DATATYPE(tmpstack,'w') THEN DO
						IF ~RXTR_SETSTACK(exefile,tmpstack) THEN
							EasyRequester(1,"Couldn''t enter stack size!")
					END
					ELSE EasyRequester(1,"Stack size is no integer value!")
				END
			END
		END
	END
	ELSE DO
		SAY 'PBCompiler-GUI fake mode:'
		SAY compiler' 'opts
		SAY ''
	END
	TR_UNLOCKPROJECT(win)
RETURN 0

ToggleStack:
	stackdis = ABS(TR_GETATTRIBUTE(win,953,'TRAT_Value') - 1)
	TR_SETATTRIBUTE(win,954,'TRAT_Disabled',stackdis)
	TR_SETATTRIBUTE(win,955,'TRAT_Disabled',stackdis)
RETURN 0

LoadStackVal:
	IF EXISTS(exefile'.info') THEN DO
		xstack = RXTR_GETSTACK(exefile)
		IF xstack ~= '' THEN TR_SETATTRIBUTE(win,954,'TROB_String',xstack)
	END
RETURN 0

EasyRequester:
	PARSE ARG typ,bodytext
	IF typ = 1 THEN DO
		buttontext = '  O K  '
		easytitle = 'PBCompiler-GUI Message'
	END
	ELSE DO
		buttontext = ' Y E S |  N O  '
		easytitle = 'PBCompiler-GUI Request'
	END
	easyergo = TR_EASYREQUEST(app,bodytext,buttontext,"TREZ_Title" '"'easytitle'"' "TREZ_LockProject" wind)
	IF typ = 1 THEN easyergo = 0
RETURN easyergo

break_c:
failure:
halt:
ioerr:
syntax:
	SAY '+++ Error' rc 'in line' sigl '-' ERRORTEXT(rc)
	SAY SOURCELINE(sigl)
	IF app ~= '00000000'x THEN CALL TR_DELETEAPP(app)
	IF new_out THEN DO
		DELAY(250)
		CALL CLOSE STDOUT
	END
	EXIT(10)
