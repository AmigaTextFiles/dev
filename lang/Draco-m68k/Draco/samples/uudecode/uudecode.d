/*
 * uudecode.drc
 *   Decode an ASCII representation into a binary file. This is the
 *   reverse of uuencode. If a parameter is given, it is the name of the
 *   uuencoded file to decode. If no parameter is given, the standard
 *   is read. The input file contains the name to use for the binary file
 *   created. It can contain more than one file, even though uuencode
 *   can't directly produce such a beast.
 *
 *   This is a very early program, written before the Amiga version of Draco
 *   had an I/O library and include files. Hence this source file is completely
 *   self contained (except for the interface routines and assembler support).
 */

uint
    BUFF_SIZE = 10000,		/* nice and big */
    MAX_BYTES = 45,		/* maximum bytes per encoded line */
    MAX_LINE = 100;		/* maximum input line we use */

ulong
    MODE_READ = 1005,
    MODE_WRITE = 1006;

type FileHandle_t = ulong;

extern
    OpenDosLibrary(ulong version)*byte,
    CloseDosLibrary()void,
    GetPars(*ulong pLen; **char pPtr)void,
    Output()FileHandle_t,
    Input()FileHandle_t,
    DeleteFile(*char name)void,
    Open(*char name; ulong mode)FileHandle_t,
    Close(FileHandle_t fd)void,
    Read(FileHandle_t fd; *char buffer; ulong length)ulong,
    Write(FileHandle_t fd; *byte buffer; ulong length)ulong,
    Exit(ulong status)void;

FileHandle_t StdOut, InFd, OutFd;

[BUFF_SIZE] char InBuff;	/* buffer for input ASCII file */
[BUFF_SIZE] byte OutBuff;	/* buffer for output binary file */
[MAX_LINE] char LineBuff;	/* buffer for input line */
[MAX_LINE] char WordBuff;	/* buffer for input word */
uint InMax, InPos, OutPos, LineMax, LinePos;  /* buffer positions and counts */
bool Eof;			/* true => end-of-file on input */
bool GotFile;			/* true => reading from a file */

/*
 * abort -
 *   Local routine to cleanly abort with the given error level.
 */

proc abort(uint level)void:

    if GotFile then
	Close(InFd);
    fi;
    Exit(level);
corp;

/*
 * writeString -
 *   Write a string to the standard output.
 */

proc writeString(*char s)void:
    *char p;

    p := s;
    while p* ~= '\e' do
	p := p + 1;
    od;
    if Write(StdOut, pretend(s, *byte), p - s) ~= p - s then
	abort(40);
    fi;
corp;

/*
 * writeNumber -
 *   Write the ascii form of an integer to the standard output.
 */

proc writeNumber(uint n)void:
    [6] char buff;
    *char p;

    p := &buff[5];
    p* := '\e';
    while
	p := p - 1;
	p* := n % 10 + '0';
	n := n / 10;
	n ~= 0
    do
    od;
    writeString(p);
corp;

/*
 * flush -
 *   Flush the contents of the output buffer to the output file.
 */

proc flush()void:

    if OutPos ~= 0 then
	if Write(OutFd, &OutBuff[0], OutPos) ~= OutPos then
	    writeString("Error on write - aborting.\n");
	    Close(OutFd);
	    abort(30);
	fi;
	OutPos := 0;
    fi;
corp;

/*
 * addByte -
 *   Add a single byte to the output file, flushing if needed.
 */

proc addByte(byte b)void:

    OutBuff[OutPos] := b;
    OutPos := OutPos + 1;
    if OutPos = BUFF_SIZE then
	flush();
    fi;
corp;

/*
 * getChar -
 *   Get the next character from the input binary file.
 */

proc getChar()char:

    if InPos = InMax then
	InPos := 0;
	InMax := Read(InFd, &InBuff[0], BUFF_SIZE);
	if InMax = 0 then
	    Eof := true;
	fi;
    fi;
    InPos := InPos + 1;
    InBuff[InPos - 1]
corp;

/*
 * getLine -
 *   Read an input line into LineBuff/LineMax.
 */

proc getLine()void:
    char ch;

    LineMax := 0;
    while
	ch := getChar();
	not Eof and ch ~= '\n'
    do
	if LineMax ~= MAX_LINE then
	    LineBuff[LineMax] := ch;
	    LineMax := LineMax + 1;
	fi;
    od;
    LinePos := 0;
corp;

/*
 * getWord -
 *   Peel an input word off of the input line.
 */

proc getWord()*char:
    *char p;

    p := &WordBuff[0];
    while LinePos < LineMax and LineBuff[LinePos] ~= ' ' do
	p* := LineBuff[LinePos];
	p := p + 1;
	LinePos := LinePos + 1;
    od;
    p* := '\e';
    LinePos := LinePos + 1;
    &WordBuff[0]
corp;

/*
 * isWord -
 *   Compare two words for equality.
 */

proc isWord(*char p, q)bool:

    while p* = q* and p* ~= '\e' do
	p := p + 1;
	q := q + 1;
    od;
    p* = q*
corp;

/*
 * decodeChar -
 *   Decode a single character to a six bit value.
 */

proc decodeChar(char ch)byte:

    if ch >= ' ' and ch <= ' ' + ((1 << 6) - 1) then
	ch - ' '
    elif ch = '`' then
	0
    else
	writeString("Bad encoded character: ");
	writeNumber(ch - '\e');
	writeString("\n");
	Close(OutFd);
	abort(20);
	0
    fi
corp;

/*
 * decodeFile -
 *   Decode the file given already opened descriptors, etc.
 */

proc decodeFile()void:
    [MAX_BYTES] byte buff;
    uint count, i, j;
    byte b1, b2, b3, b4;

    /* fetch and decode lines until we find one starting with "end" */
    while
	getLine();
	not isWord(getWord(), "end")
    do
	/* check for a valid length line */
	if LineMax < 1 or LineMax > MAX_BYTES * 4 / 3 + 1 or
		(LineMax - 1) % 4 ~= 0 then
	    writeString("Invalid line length: ");
	    writeNumber(LineMax);
	    writeString(".\n");
	    Close(OutFd);
	    abort(20);
	fi;
	/* get and check the actual count of encoded bytes on this line */
	count := decodeChar(LineBuff[0]);
	if (LineMax - 1) / 4 ~= (count + 2) / 3 then
	    writeString("Invalid record length: ");
	    writeNumber(count);
	    writeString(" : ");
	    writeNumber(LineMax);
	    writeString(".\n");
	    Close(OutFd);
	    abort(20);
	fi;
	/* decode the line - groups of 4 characters yield three bytes */
	j := 0;
	i := 1;
	while i ~= LineMax do
	    b1 := decodeChar(LineBuff[i + 0]);
	    b2 := decodeChar(LineBuff[i + 1]);
	    b3 := decodeChar(LineBuff[i + 2]);
	    b4 := decodeChar(LineBuff[i + 3]);
	    buff[j + 0] := b1 << 2 | b2 >> 4;
	    buff[j + 1] := b2 << 4 | b3 >> 2;
	    buff[j + 2] := b3 << 6 | b4;
	    j := j + 3;
	    i := i + 4;
	od;
	/* write out the correct number (1 - 45) of bytes */
	i := 0;
	while i ~= count do
	    addByte(buff[i]);
	    i := i + 1;
	od;
    od;
corp;

/*
 * decode -
 *   Decode all of the encoded files in the already opened input file.
 */

proc decode()void:
    *char outFileName;
    bool gotBegin, doneFile;

    doneFile := false;
    /* decode files until there are no more left */
    while not Eof do
	gotBegin := false;
	/* skip lines until we find a 'begin' line or we hit end-of-file */
	while not Eof and not gotBegin do
	    getLine();
	    outFileName := getWord();
	    if isWord(outFileName, "begin") then
		outFileName := getWord();
		while outFileName* >= '0' and outFileName* <= '7' do
		    outFileName := outFileName + 1;
		od;
		if outFileName* = '\e' then
		    outFileName := getWord();
		    if outFileName* ~= '\e' then
			gotBegin := true;
		    fi;
		fi;
	    fi;
	od;
	/* if we just found a 'begin' line, go decode an encoded file */
	if gotBegin then
	    writeString("Decoding file '");
	    writeString(outFileName);
	    writeString("'\n");
	    /* open output file, etc. */
	    DeleteFile(outFileName);
	    OutFd := Open(outFileName, MODE_WRITE);
	    if OutFd = 0 then
		writeString("Can't open/create output file '");
		writeString(outFileName);
		writeString("'\n");
		abort(20);
	    fi;
	    /* initialize */
	    OutPos := 0;
	    /* go decode the file */
	    decodeFile();
	    /* flush output buffer, and close file */
	    flush();
	    Close(OutFd);
	    doneFile := true;
	fi;
    od;
    /* if we found no 'begin' line in the whole input file, then complain */
    if not doneFile then
	writeString("No 'begin' line found.\n");
	abort(20);
    fi;
corp;

/*
 * main -
 *   The main program. Get the command line parameters and parse a file
 *   name from them, else just use the standard input. The input file is
 *   decoded into 1 or more output binary files.
 */

proc main()void:
    *char parPtr, inFileName;
    ulong parLen;

    if OpenDosLibrary(0) ~= nil then
	StdOut := Output();
	GetPars(&parLen, &parPtr);
	while parLen ~= 0 and
		(parPtr* = ' ' or parPtr* = '\n' or parPtr* = '\r') do
	    parPtr := parPtr + 1;
	    parLen := parLen - 1;
	od;
	if parLen = 0 then
	    /* no parameter given - read from standard input */
	    InFd := Input();
	    GotFile := false;
	else
	    inFileName := parPtr;
	    while parLen ~= 0 and parPtr* ~= ' ' and
		    parPtr* ~= '\n' and parPtr* ~= '\r' do
		parPtr := parPtr + 1;
		parLen := parLen - 1;
	    od;
	    parPtr* := '\e';
	    /* try to open the specified input file */
	    InFd := Open(inFileName, MODE_READ);
	    if InFd = 0 then
		writeString("Can't open input file '");
		writeString(inFileName);
		writeString("'\n");
		Exit(10);
	    fi;
	    GotFile := true;
	fi;
	/* initialize for reading the input line */
	Eof := false;
	InMax := 0;
	InPos := 0;
	decode();
	if GotFile then
	    Close(InFd);
	fi;
	CloseDosLibrary();
    fi;
corp;
