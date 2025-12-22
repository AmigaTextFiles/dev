OPT	DOSARGONLY

MODULE	'dbplayer/dbplayerbase',
			'dbplayer/dbplayer',
			'dbplayer'

DEF	Mod[]:CHAR,ModSize

DEF	DBPlayerBase:PTR TO DBPlayerBase

PROC main()
	DEF	fp
	DEFUL	InstrNum,ChanNum,PattNum
	DEF	ModName[]:CHAR,InstNames[][]:CHAR
	DEFL	i

	IFN DBPlayerBase:=OpenLibrary('dbplayer.library',DBPLAYER_VERSION) THEN Raise("DBPL")

	ModSize:=FileLength(arg)
	IFN Mod:=New(ModSize) THEN Raise("MEM")

	IF fp:=Open(arg,OLDFILE)
		Read(fp,Mod,ModSize)
		Close(fp)
	ELSE Raise("FILE")
	IF Long(Mod)<>"DBM0" THEN Raise("FILE")

	IF DBM_StartModule(Mod,ModSize,-1,0,DBF_AUTOBOOST) THEN Raise("PLAY")
	PrintF('Playing... (press CTRL+C to stop)\n')

	DBM_GetModuleAttr(
		DBMATTR_InstNum,&InstrNum,
      DBMATTR_ChanNum,&ChanNum,
      DBMATTR_PattNum,&PattNum,
      DBMATTR_ModName,&ModName,
      DBMATTR_InstNames,&InstNames,
      TAG_DONE)
	PrintF(
		'module name: \s\n'+
		'# of instruments: \d\n'+
		'# of channels:    \d\n'+
		'# of patterns:    \d\n',
		ModName,InstrNum,ChanNum,PattNum)
	FOR i:=0 TO InstrNum-1 DO PrintF('\t%s\n',InstNames[i])

	WHILEN CtrlC() DO Delay(10)

	DBM_StopModule()

EXCEPTDO
	DEF	str:PTR TO CHAR
	IF Mod THEN Dispose(Mod)
	IF DBPlayerBase THEN CloseLibrary(DBPlayerBase)
	SELECT exception
	CASE "DBPL";	str:='Cannot open dbplayer.library, version %d\n'
	CASE "ASLL";	str:='Cannot open asl.library version 37!\n'
	CASE "ASLI";	str:='Cannot init AslRequester!\n'
	CASE "ASLR";	str:='Cannot open AslRequester!\n'
	CASE "FILE";	str:='Cannot open the module!\n'
	CASE "PLAY";	str:='Cannot play the module!\n'
	CASE "MEM";		str:='Not enough memory!\n'
	DEFAULT;			str:=NIL
	ENDSELECT
	IF str THEN PrintF(str,DBPLAYER_VERSION)
ENDPROC
