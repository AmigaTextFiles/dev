#drinc:libraries/dos.g
#drinc:util.g
#draco.g
#externs.g

*char SymNextSave;			/* as initially setup */

bool StatsFlag;
ulong CodeTotal, OptTotal, RememberTotal, ShortenTotal;
ulong CodeGrand, OptGrand, RememberGrand, ShortenGrand;

/*
 * newSymbol - add the given symbol to the symbol table
 */

proc newSymbol(*char name; ushort kind; TYPENUMBER typ; uint valu)void:
    register *SYMBOL ptr;

    ptr := findSymbol(name);
    ptr*.sy_kind := B_SYS | kind;
    ptr*.sy_type := typ;
    ptr*.sy_name := name;
    ptr*.sy_value.sy_ulong := valu;
corp;

proc reservedWord(*char symbol; ushort tokenValue)void:

    newSymbol(symbol, MKEYW, tokenValue, 0);
corp;

proc systemType(*char symbol; TYPENUMBER typ)void:
    byte
	M = TMASK,
	H = 0xff,
	L = 0x7f;
    *char TRAP =
	    "\(('D'-'\e')><M&H)\(('r'-'\e')><M&H)"
	    "\(('a'-'\e')><M&L)\(('c'-'\e')><M&H)"
	    "\(('o'-'\e')><M&L)\((' '-'\e')><M&L)"
	    "\(('V'-'\e')><M&L)\(('e'-'\e')><M&H)"
	    "\(('r'-'\e')><M&H)\(('s'-'\e')><M&H)"
	    "\(('i'-'\e')><M&L)\(('o'-'\e')><M&L)"
	    "\(('n'-'\e')><M&H)\((' '-'\e')><M&L)"
	    "\((VERSION1-'\e')><M&H)\(('.'-'\e')><M&L)"
	    "\((VERSION2-'\e')><M&H)\((','-'\e')><M&H)"
	    "\((' '-'\e')><M&L)\(('C'-'\e')><M&L)"
	    "\(('o'-'\e')><M&H)\(('p'-'\e')><M&H)"
	    "\(('y'-'\e')><M&H)\(('r'-'\e')><M&L)"
	    "\(('i'-'\e')><M&L)\(('g'-'\e')><M&H)"
	    "\(('h'-'\e')><M&H)\(('t'-'\e')><M&L)"
	    "\((' '-'\e')><M&L)\(('('-'\e')><M&L)"
	    "\(('C'-'\e')><M&H)\((')'-'\e')><M&H)"
	    "\((' '-'\e')><M&L)\(('1'-'\e')><M&H)"
	    "\(('9'-'\e')><M&L)\((DATE1-'\e')><M&H)"
	    "\((DATE2-'\e')><M&L)\((' '-'\e')><M&H)"
	    "\(('b'-'\e')><M&L)\(('y'-'\e')><M&H)"
	    "\((' '-'\e')><M&H)\(('C'-'\e')><M&L)"
	    "\(('h'-'\e')><M&L)\(('r'-'\e')><M&H)"
	    "\(('i'-'\e')><M&H)\(('s'-'\e')><M&H)"
	    "\((' '-'\e')><M&L)\(('G'-'\e')><M&H)"
	    "\(('r'-'\e')><M&L)\(('a'-'\e')><M&L)"
	    "\(('y'-'\e')><M&H)\(('\n'-'\e')><M&H)"
	    "\(('\e'-'\e')><M&L)";

    if GOTCOPY then
	Trap := TRAP;
    fi;
    newSymbol(symbol, MTYPE, typ, 0);
corp;

proc initCTypes()void:
    *char TYPES =
	"\ediov\e\(TYVOID)"
	"\eloob\e\(TYBOOL)"
	"\erahc\e\(TYCHAR)"
	"\eetyb\e\(TYBYTE)"
	"\etrohsu\e\(TYUSHORT)"
	"\etrohs\e\(TYSHORT)"
	"\etniu\e\(TYUINT)"
	"\etni\e\(TYINT)"
	"\egnol\e\(TYLONG)"
	"\egnolu\e\(TYULONG)"
	"\etaolf\e\(TYFLOAT)"
	"\ertpbra\e\(TYNIL)"
	"\e";
    *char CONSTANTS = "\eeurt\eeslaf";
    register *char p;

    p := TYPES;
    p := p + 1;
    while
	p* ~= '\e'
    do
	while p* ~= '\e' do
	    p := p + 1;
	od;
	systemType(p - 1, (p + 1)* - '\e');
	p := p + 3;
    od;

    p := CONSTANTS;
    newSymbol(p + 4, MNUMBER, TYBOOL, 1);
    newSymbol(p + 10, MNUMBER, TYBOOL, 0);
corp;

proc initSymbols()void:
    *char TOKENS =
	"\edengis\edengisnu\emune\etcurts\enoinu\enwonknu\eelif\elennahc"

	"\etxet\eyranib\eepyt\enretxe\ecilpub\eetavirp\eretsiger"
	"\edna\ero\eneht\emorf\eotpu\eotnwod\eyb"

	"\elin\emid\efoezis\eegnar\eekam\etupni\ewen\erorreoi\eton"

	"\efi\eesac\edneterp\enepo\eesolc\edaer\enldaer\eetirw\enletirw"

	"\ecorp\eproc\efile\eesle\eif\eod\edo"
	"\eesacni\etluafed\ehguorhtllaf\ecase"

	"\eelihw\erof\eeerf\eedoc\eerongi\enruter\erorre"
	
	"\etuptuo\eeludom\etropmi\etropxe\ediob\exif\etlf\epihc_\e"

	"\e";
    register *char p;
    register ushort tokenValue;

    BlockFill(pretend(&SymbolTable[0], *byte), SYSIZE*sizeof(SYMBOL), MFREE);

    p := TOKENS;
    tokenValue := 128;
    while
	p := p + 1;
	p* ~= '\e'
    do
	while p* ~= '\e' do
	    p := p + 1;
	od;
	reservedWord(p - 1, tokenValue);
	tokenValue := tokenValue + 1;
    od;

    initCTypes();

    DescNext := &DescTable[1];
    SymNext := pretend(&ProgramBuff[PBSIZE - 1], *char);
corp;

/*
 * findDecl - find something that can start a declaration.
 */

proc findDecl(ushort fudge)void:

    while Token ~= fudge and Token ~= TEOF and Token ~= TEXTERN and
	    Token + '\e' ~= '*' and Token + '\e' ~= '[' and
	    (Token < TSIGNED or Token > TCHANNEL) and
	    (Token < TTYPE or Token > TREGISTER) and
	    Token ~= TMODULE and Token ~= TIMPORT and Token ~= TEXPORT and
	    Token ~= TPROC and
	    (Token ~= TID or CurrentId*.sy_kind & MMMMMM ~= MTYPE) do
	scan();
    od;
corp;

/*
 * process - compile the procedures in the file just set up
 */

proc process()void:
    [100] char includeFileName;
    register *char p1;
    unsigned IBUFFSIZE mainPos, mainMax;
    uint lineSave, oLineSave;
    ushort columnSave, oColumnSave;
    char nextCharSave;
    ushort eofSave;

    mainPos := 1;
    mainMax := 0;
    SourceBuff := &MainBuff;
    SourcePos := mainPos - 1;
    SourceMax := mainMax;
    SymNext := SymNextSave;
    InitData := false;
    Ignore := true;
    InConst := false;
    CStyleCall := false;
    ExtraAReg := false;
    TrueChain := BRANCH_NULL;
    FalseChain := BRANCH_NULL;
    ReturnChain := BRANCH_NULL;
    HereChain := BRANCH_NULL;
    DRTop := DRTOP;
    ARTop := ARTOP;
    /* purge the symbols from any previous source file: */
    purgeSymbol(B_FILE);
    purgeSymbol(B_GLOBAL);
    tInit();			/* set type pointers back to start */
    ConstNext := &ConstTable[0];
    ByteNext := &ByteBuff[0];
    lineSave := 1;
    OOLine := 0;
    OOColumn := 0;
    DeclOffset := 0L0;			/* no GLOBAL variables yet */
    columnSave := 0;
    CaseTableNext := &CaseTable[0];	/* in case he has one in decls */
    nextCharSave := ' ';
    eofSave := 0;
    while				/* process each include file */
	Line := lineSave;
	Column := columnSave;
	OLine := oLineSave;
	OColumn := oColumnSave;
	NextChar := nextCharSave;
	Token := '=' - '\e';
	Eof := eofSave;
	next();
	NextChar = '\\' or NextChar = '\#'
    do		/* we have an include file, process it */
	p1 := &includeFileName[0];
	while	/* put the include file's name into includeName */
	    next();
	    NextChar ~= '\n' and NextChar ~= ' ' and NextChar ~= '\t'
	do
	    p1* := NextChar;
	    p1 := p1 + 1;
	od;
	p1* := '\e';
	/* skip past any remaining characters */
	while NextChar ~= '\n' do
	    next();
	od;
	while NextChar = '\n' do
	    next();
	od;
	/* now try to read from the include file */
	mainPos := SourcePos;
	mainMax := SourceMax;
	SourcePos := 0;
	SourceMax := 0;
	SourceBuff := &IncludeBuff;
	lineSave := Line;
	columnSave := Column;
	oLineSave := OLine;
	oColumnSave := OColumn;
	nextCharSave := NextChar;
	eofSave := Eof;
	setIncludeFile(&includeFileName[0]);
	OOLine := 0;
	OOColumn := 0;
	Line := 1;
	Column := 0;
	NextChar := ' ';
	Eof := 0;
	next();
	next();
	scan();
	/* process the declarations in the include file */
	DeclLevel := B_GLOBAL;
	while Token ~= TEOF do
	    pDecls();
	    if Token ~= TEOF then
		errorThis(20);
		findDecl(TEOF);
	    fi;
	od;
	/* now switch back to the main file and check for more includes */
	SourceBuff := &MainBuff;
	SourcePos := mainPos - 1;
	SourceMax := mainMax;
	resetMainFile();
    od;
    /* write out the first of the object file (magic #, globals size) */
    GlobalSize := DeclOffset;
    setGlobalSize(GlobalSize);
    if Eof ~= 0 then
	Token := TEOF;
    else
	next();
	scan(); 			/* get first token of source */
    fi;
    DeclOffset := 0L0;			/* no FILE variables yet */
    /* process the FILE declarations at the beginning of the file */
    DeclLevel := B_FILE;
    while
	if Token = TPROC then
	    whiteSpace();
	fi;
	Token ~= TEOF and (Token ~= TPROC or Char = '(')
    do
	pDecls();
	if Token ~= TEOF and Token ~= TPROC then
	    errorThis(21);
	    findDecl(TPROC);
	fi;
    od;
    setFileSize(DeclOffset);
    /* process all of the proc's in the file */
    GlobARTop := ARTop;
    GlobDRTop := DRTop;
    CodeTotal := 0;
    OptTotal := 0;
    RememberTotal := 0;
    ShortenTotal := 0;
    while Token ~= TEOF do
	if Token ~= TPROC then
	    errorThis(22);
	    while Token ~= TEOF and Token ~= TPROC do
		scan();
	    od;
	else
	    pProc();
	    CodeTotal := CodeTotal + (ProgramNext - &ProgramBuff[0]);
	    OptTotal := OptTotal + OptCount;
	    RememberTotal := RememberTotal + RememberCount;
	    ShortenTotal := ShortenTotal + ShortenCount;
	    if Token + '\e' = ';' then
		scan();
	    fi;
	fi;
    od;
    if StatsFlag then
	printString("Total: ");
	printInt(CodeTotal);
	printString(" bytes, ");
	printInt(OptTotal);
	printString(" peepholes, ");
	printInt(RememberTotal);
	printString(" loads omitted, ");
	printInt(ShortenTotal);
	printString(" branches shortened.\n");
    fi;
    CodeGrand := CodeGrand + CodeTotal;
    OptGrand := OptGrand + OptTotal;
    RememberGrand := RememberGrand + RememberTotal;
    ShortenGrand := ShortenGrand + ShortenTotal;
corp;

/*
 * startUp - system independent initial startup.
 */

proc startUp()void:

    DebugFlag := false;
    VerboseFlag := false;
    StatsFlag := false;
    CodeGrand := 0;
    OptGrand := 0;
    RememberGrand := 0;
    ShortenGrand := 0;
    /* set up the keywords and predefined symbols */
    initSymbols();
    /* set up for code generation, just in case */
    DRTop := DRTOP;
    ARTop := ARTOP;
    codeInit();
    SymNextSave := SymNext;
corp;

/*
 * terminate - system independent final termination.
 */

proc terminate()void:

    if StatsFlag then
	printString("Grand total: ");
	printInt(CodeGrand);
	printString(" bytes, ");
	printInt(OptGrand);
	printString(" peepholes, ");
	printInt(RememberGrand);
	printString(" loads omitted, ");
	printInt(ShortenGrand);
	printString(" branches shortened.\n");
    fi;
corp;

/*
 * routines callable from system interface to set operation flags.
 */

proc setDebug()void:

    DebugFlag := true;
corp;

proc setVerbose()void:

    VerboseFlag := true;
corp;

proc setStats()void:

    StatsFlag := true;
corp;
