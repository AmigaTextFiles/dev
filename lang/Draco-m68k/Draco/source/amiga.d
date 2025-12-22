#drinc:exec/miscellaneous.g
#drinc:exec/tasks.g
#drinc:libraries/dos.g

#draco.g

/****************************************************\
*						     *
*  functions in the compiler proper referenced here  *
*						     *
\****************************************************/

extern
    printInt(ulong n)void,
	/* use 'printString' to print out an unsigned integer */
    errorThis(ushort errorCode)void,
	/* use 'errorHead' and 'errorThis' to print an error message */
    errorBack(ushort errorCode)void,
	/* associate message with previous token */
    getExternRefs()void,
	/* go get all references to external symbols. Will call
	   'externRefName' and 'externRefUse' */
    getFileVars()void,
	/* go get names and offset of file level variables. Will call
	   'fileVarName' for each one */
    startUp()void,
	/* called once to initialize the rest of the compiler */
    terminate()void,
	/* called once at the end of the entire run */
    setDebug()void,
	/* called to turn on debugging mode code generation */
    setVerbose()void,
	/* called to turn on verbose operation */
    setStats()void,
	/* called to turn on statistics output */
    process()void,
	/* go process the currently set up source file. */
    constByte(byte b)void;
	/* add a byte to the constant buffer */

uint
    DBLKSIZE = 512 - 6 * 4,		/* size of block on disk */
    OBUFFSIZE = DBLKSIZE * 10,		/* size of output disk buffer */

    NAME_BUFF_LEN = 100,		/* size for file name buffers */

    GLOBAL_RELOC_SIZE	= 500,
    FILE_RELOC_SIZE	= 500,
    PROGRAM_RELOC_SIZE	= 200,
    EXTERN_RELOC_SIZE	= 1000,
    EXTERN_REF_SIZE	= 200;

uint
    HUNK_UNIT		= 0999,
    HUNK_NAME		= 1000,
    HUNK_CODE		= 1001,
    HUNK_DATA		= 1002,
    HUNK_BSS		= 1003,
    HUNK_RELOC32	= 1004,
    HUNK_RELOC16	= 1005,
    HUNK_RELOC8 	= 1006,
    HUNK_EXT		= 1007,
    HUNK_SYMBOL 	= 1008,
    HUNK_DEBUG		= 1009,
    HUNK_END		= 1010;

byte
    EXT_SYMB		= 0,
    EXT_DEF		= 1,
    EXT_ABS		= 2,
    EXT_RES		= 3,
    EXT_REF32		= 129,
    EXT_COMMON		= 130,
    EXT_REF16		= 131,
    EXT_REF8		= 132;

*char GLOBAL_NAME = "\eataD labolG";
uint GLOBAL_NAME_LENGTH = 11;

type
    FileHandle_t = ulong,

/*
    RELOC = struct {
	ulong r_what;
	uint r_head;
    },
*/

    EXTERN_REF = struct {
	*char ext_name;
	uint ext_first;
    };

[NAME_BUFF_LEN] char MainFileName, IncludeFileName, CodeFileName;
*[NAME_BUFF_LEN] char SourceFileName;

*char ParPtr;
ulong ParLen;

FileHandle_t
    CodeFile,				/* output to .REL file */
    MainFile,				/* input from .DRC file */
    IncludeFile,			/* input from .G file */
    ErrorFile,				/* error message database */
    StdOutFile, 			/* standard output for messages */
    SourceFile; 			/* current input file */

[OBUFFSIZE] byte CodeBuff;		/* buffer for code output */

unsigned OBUFFSIZE CodePos;		/* current position in code buffer */

uint ErrorCount;			/* number of errors so far */
uint WarningCount;			/* number of warnings so far */

uint HunkNumber;			/* number of next hunk, this file */

bool
    ErrorOpen,				/* true if error file opened */
    MathOpen,				/* math library opened */
    NamePrinted,			/* true if file had error */
    LocalDebug; 			/* local copy of DebugFlag */

ulong GlobSize, FileSize;

[GLOBAL_RELOC_SIZE] uint GlobalRelocs;
[FILE_RELOC_SIZE] uint FileRelocs;
[PROGRAM_RELOC_SIZE] uint ProgramRelocs;
[EXTERN_RELOC_SIZE] uint ExternRelocs;
[EXTERN_REF_SIZE] EXTERN_REF ExternRefs;
uint ExternRelocCnt, ExternRefCnt;

bool WantChip;


/*
 * abort - abort cleanly with the given exit code.
 */

proc abort(uint status)void:

    if CodeFile ~= 0 then
	Close(CodeFile);
    fi;
    if MainFile ~= 0 then
	Close(MainFile);
    fi;
    if IncludeFile ~= 0 then
	Close(IncludeFile);
    fi;
    if ErrorFile ~= 0 then
	Close(ErrorFile);
    fi;
    Exit(status);
corp;

/**********************************************\
*					       *
*  routines for printing error messages, etc.  *
*					       *
\**********************************************/

/*
 * printString - print the passed string on the console
 */

proc printString(*char st)void:
    register *char p;

    p := st;
    while p* ~= '\e' do
	p := p + 1;
    od;
    if Write(StdOutFile, st, p - st) ~= p - st then
	abort(20);
    fi;
corp;

/*
 * checkControlC - if the user has typed a control-C, then we assume he
 *	wants to abort the compilation. Print a message and exit nicely.
 */

proc checkControlC()void:

    if SetSignal(0, SIGBREAKF_CTRL_C) & SIGBREAKF_CTRL_C ~= 0 then
	printString("\nInterrupt! - Draco compiler exiting.\n");
	if CodeFile ~= 0 then
	    Close(CodeFile);
	fi;
	if MainFile ~= 0 then
	    Close(MainFile);
	fi;
	if IncludeFile ~= 0 then
	    Close(IncludeFile);
	fi;
	if ErrorFile ~= 0 then
	    Close(ErrorFile);
	fi;
	DeleteFile(&CodeFileName[0]);
	Exit(10);
    fi;
corp;

/*
 * printRevString - print the passed reversed string on the console
 */

proc printRevString(register *char st)void:

    while st* ~= '\e' do
	if Write(StdOutFile, st, 1) ~= 1 then
	    abort(20);
	fi;
	st := st - 1;
    od;
corp;

/*
 * printFileName - print the name of the main input file
 */

proc printFileName()void:

    printString(&SourceFileName*[0]);
corp;

/*
 * errorHead - start the printing of an error message at the given
 *	line and column.
 */

proc errorHead(uint line, column, errorCode; bool isWarning, isUser)void:
    *char
	USERERROR = " *User error: ",
	WARNING = " Warning ",
	ERROR = " **Error ",
	DASH = " - ";

    checkControlC();
    if not NamePrinted then
	NamePrinted := true;
	printFileName();
	printString(":\n");
    fi;
    printInt(line);
    printString(",");
    printInt(column);
    printString(
	if isUser then
	    ErrorCount := ErrorCount + 1;
	    USERERROR
	else
	    printString(
		if isWarning then
		    WarningCount := WarningCount + 1;
		    WARNING
		else
		    ErrorCount := ErrorCount + 1;
		    ERROR
		fi);
	    printInt(errorCode);
	    DASH
	fi);
corp;

/*
 * errorBody - print the body of an error message.
 */

proc errorBody(uint errorCode)bool:
    [64] char errorBuffer;

    if not ErrorOpen then
	ErrorOpen := true;
	ErrorFile := Open("drlib:dracoErrors", MODE_OLDFILE);
    fi;
    if ErrorFile ~= 0 then
	if Seek(ErrorFile, errorCode * 64, OFFSET_BEGINNING) = -1 or
	    Read(ErrorFile, &errorBuffer[0], 64) ~= 64
	then
	    printString("\n*** Bad seek/read in drlib:dracoErrors ***\n");
	    abort(20);
	fi;
	printString(&errorBuffer[0]);
	true
    else
	false
    fi
corp;

/**********************************************************************\
*								       *
*  readSource - read a bufferfull of characters from the current input *
*	stream - either the main source of the include file.	       *
*								       *
\**********************************************************************/

proc readSource(*char sourceBuff; uint bufferSize)uint:

    checkControlC();
    Read(SourceFile, sourceBuff, bufferSize)
corp;

/****************************\
*			     *
*  code generation routines  *
*			     *
\****************************/

/*
 * flushCode - flush the code buffer to the code file.
 */

proc flushCode()void:

    if Write(CodeFile, &CodeBuff[0], CodePos) ~= CodePos then
	errorThis(3);
    fi;
    CodePos := 0;
corp;

/*
 * codeWrite - buffered write to the code file
 */

proc codeWrite(register *byte dataPtr; register uint count)void:

    while count ~= 0 do
	count := count - 1;
	if CodePos = OBUFFSIZE then
	    flushCode();
	fi;
	CodeBuff[CodePos] := dataPtr*;
	CodePos := CodePos + 1;
	dataPtr := dataPtr + 1;
    od;
corp;

/*
 * writeLong - write a long word to the code file.
 */

proc writeLong(ulong l)void:

    codeWrite(pretend(&l, *byte), 4);
corp;

/*
 * writeSymbol - write a symbol to the code file.
 */

proc writeSymbol(register *char s; byte topByte)void:
    register *char p;
    register uint len;

    p := s;
    while p* ~= '\e' do
	p := p + 1;
    od;
    len := (p - s + 3) & (-4);
    writeLong(make(topByte, ulong) << 24 | (len / 4));
    while len ~= 0 do
	len := len - 1;
	codeWrite(pretend(s, *byte), 1);
	if s* ~= '\e' then
	    s := s + 1;
	fi;
    od;
corp;

/*
 * writeRevSymbol - write a reversed symbol to the code file.
 */

proc writeRevSymbol(register *char s; byte topByte)void:
    register *char p;
    register uint len;

    p := s;
    while p* ~= '\e' do
	p := p - 1;
    od;
    len := (s - p + 3) & (-4);
    writeLong(make(topByte, ulong) << 24 | (len / 4));
    while len ~= 0 do
	len := len - 1;
	codeWrite(pretend(s, *byte), 1);
	if s* ~= '\e' then
	    s := s - 1;
	fi;
    od;
corp;

/*************************************************\
*						  *
*  routines for system dependent code generation  *
*						  *
\*************************************************/

/*
 * getRelocs - remake one set of relocation data.
 */

proc getRelocs(register *uint buf, base; *uint pCount;
	       *RELOC table; register *RELOC rNext; uint size)void:
    register uint temp, chain, count;

    count := 0;
    while rNext ~= table do
	rNext := rNext - sizeof(RELOC);
	chain := rNext*.r_head;
	while chain ~= RELOC_NULL do
	    if count = size then
		errorThis(10);
	    fi;
	    base* := chain;
	    base := base + sizeof(uint);
	    count := count + 1;
	    temp := chain;
	    /* we are all big-endian, so this works: */
	    chain := (buf + chain)*;
	    (buf + temp)* := rNext*.r_what >> 16;
	    (buf + temp + sizeof(uint))* := rNext*.r_what;
	od;
    od;
    pCount* := count;
corp;

/*
 * dumpRelocs - write out a set of relocation stuff.
 */

proc dumpRelocs(register *uint relocP; register uint count)void:

    while count ~= 0 do
	count := count - 1;
	writeLong(relocP*);
	relocP := relocP + sizeof(uint);
    od;
corp;

/*
 * externRefName - called from 'getExternRefs' with a new extern name.
 */

proc externRefName(*char revName)void:

    if ExternRefCnt = EXTERN_REF_SIZE then
	errorThis(10);
    fi;
    ExternRefs[ExternRefCnt].ext_name := revName;
    ExternRefs[ExternRefCnt].ext_first := ExternRelocCnt;
    ExternRefCnt := ExternRefCnt + 1;
corp;

/*
 * externRefUse - a use of the previous external name.
 */

proc externRefUse(uint where)void:

    if ExternRelocCnt = EXTERN_RELOC_SIZE then
	errorThis(10);
    fi;
    ExternRelocs[ExternRelocCnt] := where;
    ExternRelocCnt := ExternRelocCnt + 1;
corp;

/*
 * setChip - allow external caller to force the next hunk to be CHIP
 */

proc setChip()void:

    WantChip := true;
corp;

/*
 * writeProgram - write all reloc information, etc. to code file.
 */

proc writeProgram(*char thisProc; *uint codeBuffer; uint codeSize;
		  *RELOC globalStart, globalEnd, fileStart, fileEnd,
			 programStart, programEnd)void:
    register *char p;
    register uint temp;
    uint globalRelocCnt, fileRelocCnt, programRelocCnt;
    bool isMain;

    p := thisProc;
    isMain := p* = 'm' and (p - 1)* = 'a' and (p - 2)* = 'i' and
		(p - 3)* = 'n' and (p - 4)* = '\e';
    /* for each type, we have to go through them and put them in our
       tables, counting them as we go. */
    getRelocs(codeBuffer, &GlobalRelocs[0], &globalRelocCnt,
	      globalStart, globalEnd, GLOBAL_RELOC_SIZE);
    getRelocs(codeBuffer, &FileRelocs[0], &fileRelocCnt,
	      fileStart, fileEnd, FILE_RELOC_SIZE);
    getRelocs(codeBuffer, &ProgramRelocs[0], &programRelocCnt,
	      programStart, programEnd, PROGRAM_RELOC_SIZE);
    /* call back into the compiler proper to get external references */
    ExternRefCnt := 0;
    ExternRelocCnt := 0;
    getExternRefs();
    /* if there are no file variables, make each function a separate unit,
       thus having the hunks numbered from 0 */
    if FileSize = 0 or InitData then
	writeLong(HUNK_UNIT);
	writeRevSymbol(thisProc, 0);
	writeLong(HUNK_END);
	HunkNumber := 0;
    fi;
    /* now we can write out the code as a text hunk */
    writeLong(
	if InitData then
	    if WantChip then
		WantChip := false;
		HUNK_DATA | 0x40000000
	    else
		HUNK_DATA
	    fi
	else
	    HUNK_CODE
	fi);
    /* note that we are assuming that the code is a multiple of 4 long */
    writeLong(codeSize / 4);
    codeWrite(pretend(codeBuffer, *byte), codeSize);
    /* write out self references */
    if programRelocCnt ~= 0 then
	writeLong(HUNK_RELOC32);
	writeLong(programRelocCnt);
	writeLong(HunkNumber);
	dumpRelocs(&ProgramRelocs[0], programRelocCnt);
	writeLong(0L0);
    fi;
    /* write out references to file variables. (hunk #0) */
    if fileRelocCnt ~= 0 then
	writeLong(HUNK_RELOC32);
	writeLong(fileRelocCnt);
	writeLong(0L0);
	dumpRelocs(&FileRelocs[0], fileRelocCnt);
	writeLong(0L0);
    fi;
    /* start external reference stuff: */
    writeLong(HUNK_EXT);
    /* define the current function: */
    writeRevSymbol(thisProc, EXT_DEF);
    writeLong(0L0);
    /* dump out references to globals */
    if globalRelocCnt ~= 0 then
	writeRevSymbol(GLOBAL_NAME + GLOBAL_NAME_LENGTH, EXT_REF32);
	writeLong(globalRelocCnt);
	dumpRelocs(&GlobalRelocs[0], globalRelocCnt);
    fi;
    /* dump out references to external symbols */
    while ExternRefCnt ~= 0 do
	ExternRefCnt := ExternRefCnt - 1;
	writeRevSymbol(ExternRefs[ExternRefCnt].ext_name, EXT_REF32);
	temp := ExternRelocCnt - ExternRefs[ExternRefCnt].ext_first;
	writeLong(temp);
	while temp ~= 0 do
	    temp := temp - 1;
	    ExternRelocCnt := ExternRelocCnt - 1;
	    writeLong(ExternRelocs[ExternRelocCnt]);
	od;
    od;
    /* end of external references */
    writeLong(0L0);
    if LocalDebug then
	/* write out a HUNK_SYMBOL to define the current function */
	writeLong(HUNK_SYMBOL);
	writeRevSymbol(thisProc, 0);
	writeLong(0L0); 		/* offset in previous code/data */
	writeLong(0L0); 		/* end of symbolic hunk */
    fi;
    /* end of the unit: */
    writeLong(HUNK_END);
    HunkNumber := HunkNumber + 1;
    if isMain and GlobSize ~= 0L0 then
	writeLong(HUNK_BSS);
	writeLong((GlobSize + 0L3) / 0L4);
	writeLong(HUNK_EXT);
	writeRevSymbol(GLOBAL_NAME + GLOBAL_NAME_LENGTH, EXT_DEF);
	writeLong(0L0);
	writeLong(0L0);
	writeLong(HUNK_END);
	HunkNumber := HunkNumber + 1;
    fi;
corp;

/*
 * setGlobalSize - called when we know the size of the global variables.
 */

proc setGlobalSize(ulong globalSize)void:

    GlobSize := globalSize;
corp;

/*
 * fileVarName - called with the name of a file-level variable.
 */

proc fileVarName(*char revName; ulong offset)void:

    writeRevSymbol(revName, 0);
    writeLong(offset);
corp;

/*
 * setFileSize - called when we know the size of the file variables.
 */

proc setFileSize(ulong fileSize)void:

    FileSize := fileSize;
    if fileSize ~= 0 then
	/* write out hunk 0 as a BSS hunk to contain the file variables */
	writeLong(HUNK_UNIT);
	writeSymbol(&SourceFileName*[0], 0);
	writeLong(HUNK_BSS);
	writeLong((fileSize + 0L3) / 0L4);
	HunkNumber := 1;
	if LocalDebug then
	    /* write out a HUNK_SYMBOL to describe all the file-level vars */
	    writeLong(HUNK_SYMBOL);
	    getFileVars();
	    writeLong(0L0);		    /* end of symbolic hunk */
	fi;
	writeLong(HUNK_END);
    fi;
corp;

/*************************************\
*				      *
*  support routines and main program  *
*				      *
\*************************************/

/*
 * resetMainFile - do whatever is needed to end include file processing
 */

proc resetMainFile()void:

    Close(IncludeFile);
    IncludeFile := 0;
    NamePrinted := not NamePrinted;
    SourceFile := MainFile;
    SourceFileName := &MainFileName;
corp;

/*
 * setIncludeFile - start reading from the named include file.
 */

proc setIncludeFile(register *char name)void:
    register *char p;

    p := &IncludeFileName[0];
    while
	p* := name*;
	p* ~= '\e'
    do
	p := p + 1;
	name := name + 1;
    od;
    SourceFileName := &IncludeFileName;
    IncludeFile := Open(&IncludeFileName[0], MODE_OLDFILE);
    if IncludeFile = 0 then
	printFileName();
	printString(": cannot open include file\n");
	abort(10);
    fi;
    /* save position info in main file, and reset for include file */
    SourceFile := IncludeFile;
    NamePrinted := false;
corp;

/*
 * compileFile - process each file in turn.
 */

proc compileFile()void:

    SourceFile := MainFile;
    printFileName();
    printString(":\n");
    NamePrinted := true;
    CodePos := 0;			/* code buffer initially empty */
    IncludeFile := 0;
    /* create the code file: */
    DeleteFile(&CodeFileName[0]);
    CodeFile := Open(&CodeFileName[0], MODE_NEWFILE);
    if CodeFile = 0 then
	printString(&CodeFileName[0]);
	printString(": cannot open/create output .r file\n");
	abort(10);
    fi;
    SourceFile := MainFile;
    SourceFileName := &MainFileName;
    ErrorCount := 0;
    WarningCount := 0;
    process();
    /* flush the code buffer */
    if CodePos ~= 0 then
	flushCode();
    fi;
    Close(CodeFile);
    Close(MainFile);
    CodeFile := 0;
    MainFile := 0;
    if ErrorCount ~= 0 then
	DeleteFile(&CodeFileName[0]);
	printFileName();
	printString(": ");
	printInt(ErrorCount);
	printString(" errors, ");
	printInt(WarningCount);
	printString(" warnings; .r file deleted.\n");
    elif WarningCount ~= 0 then
	printFileName();
	printString(": ");
	printInt(WarningCount);
	printString(" warnings\n");
    fi;
corp;

/*
 * enableMath - called when the compiler needs to do floating point math.
 */

proc enableMath()void:
    extern OpenMathieeedoubbasLibrary(ulong version)*char;

    if not MathOpen then
	if OpenMathieeedoubbasLibrary(0) = nil then
	    /* can't open the libary - we must abort */
	    printFileName();
	    printString(": cannot open IEEE double precision math library\n");
	    abort(10);
	fi;
	MathOpen := true;
    fi;
corp;

/*
 * skipBlanks - skip past any blanks in the input command line.
 */

proc skipBlanks()void:

    while ParLen ~= 0 and
	    (ParPtr* = ' ' or ParPtr* = '\n' or ParPtr* = '\r') do
	ParPtr := ParPtr + 1;
	ParLen := ParLen - 1;
    od;
corp;

/*
 * main - the compiler starts here.
 *
 */

proc main()void:
    extern
	GetPars(*ulong pParlen; **char pParPtr)void,
	CloseMathieeedoubbasLibrary()void;
    register *char p, q, r;
    *char nameStart;
    [2] char buff;
    bool hadErrors, hadWarnings;

    if OpenExecLibrary(0) ~= nil then
	if OpenDosLibrary(0) ~= nil then
	    StdOutFile := Output();
	    ErrorOpen := false;
	    ErrorFile := 0;
	    LocalDebug := false;
	    MathOpen := false;
	    WantChip := false;
	    GetPars(&ParLen, &ParPtr);
	    skipBlanks();
	    if IS_BETA then
		printString(
		    "Draco compiler version \(VERSION1).\(VERSION2) (beta), "
		    "Copyright 19\(DATE1)\(DATE2) by Chris Gray\n");
	    else
		printString(
		    "Draco compiler version \(VERSION1).\(VERSION2), "
		    "Copyright 19\(DATE1)\(DATE2) by Chris Gray\n");
	    fi;
	    if ParLen = 0 then
		printString("Use is: draco [-d] [-v] f1[.d] ... fn[.d]\n");
		Exit(20);
	    fi;
	    /* start up the compiler proper */
	    startUp();
	    /* process each argument file in turn */
	    hadErrors := false;
	    hadWarnings := false;
	    while ParLen ~= 0 do
		if ParPtr* = '-' then
		    while
			ParPtr := ParPtr + 1;
			ParLen := ParLen - 1;
			ParLen ~= 0 and ParPtr* ~= ' ' and
			    ParPtr* ~= '\n' and ParPtr* ~= '\r'
		    do
			case ParPtr*
			incase 'd':
			incase 'D':
			    setDebug();
			    LocalDebug := true;
			incase 'v':
			incase 'V':
			    setVerbose();
			incase 's':
			incase 'S':
			    setStats();
			default:
			    printString("draco: *** unknown flag '");
			    buff[0] := ParPtr*;
			    buff[1] := '\e';
			    printString(&buff[0]);
			    printString("' - ignored.\n");
			esac;
		    od;
		else
		    nameStart := ParPtr;
		    while ParLen ~= 0 and
			ParPtr* ~= '\n' and ParPtr* ~= ' ' and ParPtr* ~= '\r'
		    do
			ParPtr := ParPtr + 1;
			ParLen := ParLen - 1;
		    od;
		    ParPtr* := '\e';
		    if ParLen ~= 0 then
			ParLen := ParLen - 1;
			ParPtr := ParPtr + 1;
		    fi;
		    /* set up the file names: first, find the end of it */
		    p := nameStart;
		    while p* ~= '\e' do
			p := p + 1;
		    od;
		    /* then look back for any final '.' */
		    while
			p := p - 1;
			p ~= nameStart and p* ~= '.'
		    do
		    od;
		    /* chop off a final ".d" */
		    if p* = '.' and (p + 1)* = 'd' and (p + 2)* = '\e' then
			p* := '\e';
		    fi;
		    /* create names XXX.d and XXX.r */
		    p := nameStart;
		    q := &MainFileName[0];
		    r := &CodeFileName[0];
		    while p* ~= '\e' do
			q* := p*;
			q := q + 1;
			r* := p*;
			r := r + 1;
			p := p + 1;
		    od;
		    q* := '.';
		    (q + 1)* := 'd';
		    (q + 2)* := '\e';
		    r* := '.';
		    (r + 1)* := 'r';
		    (r + 2)* := '\e';
		    /* now try to open the source file */
		    SourceFileName := &MainFileName;
		    MainFile := Open(&MainFileName[0], MODE_OLDFILE);
		    if MainFile = 0 then
			printFileName();
			printString(": cannot open source file\n");
			hadErrors := true;
		    else
			GlobSize := 0;
			FileSize := 0;
			compileFile();
			if ErrorCount ~= 0 then
			    hadErrors := true;
			elif WarningCount ~= 0 then
			    hadWarnings := true;
			fi;
		    fi;
		fi;
		skipBlanks();
	    od;
	    /* terminate the compiler proper */
	    terminate();
	    if ErrorOpen then
		Close(ErrorFile);
	    fi;
	    if hadErrors then
		Exit(10);
	    elif hadWarnings then
		Exit(5);
	    fi;
	    if MathOpen then
		CloseMathieeedoubbasLibrary();
	    fi;
	    CloseDosLibrary();
	fi;
	CloseExecLibrary();
    fi;
corp;

/*
 * insertDataFile - try to insert the contents of a data file as the
 *	value of an initialized file variable.
 */

proc insertDataFile(*char fileName; ulong len, offset)void:
    ulong BUFF_LEN = 512;
    Handle_t fd;
    register long want, got;
    [BUFF_LEN] byte buffer;
    bool hadError;

    fd := Open(fileName, MODE_OLDFILE);
    if fd = 0 then
	errorBack(185);
    else
	if offset ~= 0 and Seek(fd, offset, OFFSET_BEGINNING) < 0 then
	    errorBack(185);
	else
	    hadError := false;
	    while not hadError and len ~= 0 do
		want := if len > BUFF_LEN then BUFF_LEN else len fi;
		len := len - want;
		got := Read(fd, &buffer[0], want);
		if got ~= want then
		    errorBack(186);
		    hadError := true;
		else
		    want := 0;
		    while got ~= 0 do
			got := got - 1;
			constByte(buffer[want]);
			want := want + 1;
		    od;
		fi;
	    od;
	fi;
	Close(fd);
    fi;
corp;
