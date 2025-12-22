/*
 * uuencode.drc
 *   Encode a binary file into an ASCII representation that can be mailed
 *   around. No blanks are sent - graves (`) are used instead. If only one
 *   parameter is given on the run command, then that is the name of the
 *   file to endcode. It's name is used as the target machine name, and
 *   the encoded output is left in a file with the same name but with
 *   '.uue' appended. No check is made for file names too long. If a
 *   second parameter is given, it is the name to use for the target
 *   machine file name. Any path names are stripped off of all except the
 *   input file read and any explicit target machine name. Thus, the
 *   output file will be created in the current directory.
 *
 *   This is a very early program, written before the Amiga version of Draco
 *   had an I/O library and include files. Hence this source file is completely
 *   self contained (except for the interface routines and assembler support).
 */

uint
    BUFF_SIZE = 10000,		/* nice and big */
    MAX_BYTES = 45;		/* maximum bytes per encoded line */

ulong
    MODE_READ = 1005,
    MODE_WRITE = 1006;

type FileHandle_t = ulong;

extern
    OpenDosLibrary(ulong version)*char,
    CloseDosLibrary()void,
    Output()FileHandle_t,
    GetPars(*ulong pLen; **char pPtr)void,
    DeleteFile(*char name)void,
    Open(*char name; ulong mode)FileHandle_t,
    Close(FileHandle_t fd)void,
    Read(FileHandle_t fd; *byte buffer; ulong length)ulong,
    Write(FileHandle_t fd; *char buffer; ulong length)ulong,
    Exit(ulong status)void;

FileHandle_t StdOut, InFd, OutFd;

[BUFF_SIZE] byte InBuff;	/* buffer for input binary file */
[BUFF_SIZE] char OutBuff;	/* buffer for output ASCII file */
uint InMax, InPos, OutPos;	/* buffer positions and count */
bool Eof;			/* true => end-of-file on input */

ulong ParLen;			/* used for parameter scanning */
*char ParPtr;

/*
 * writeString - write a string to standard output.
 */

proc writeString(*char mess)void:
    *char p;

    p := mess;
    while p* ~= '\e' do
	p := p + 1;
    od;
    if Write(StdOut, mess, p - mess) ~= p - mess then
	Exit(40);
    fi;
corp;

/*
 * flush -
 *   Flush the contents of the output buffer to the output file.
 */

proc flush()void:

    if OutPos ~= 0 then
	if Write(OutFd, &OutBuff[0], OutPos) ~= OutPos then
	    writeString("Error on write - aborting.\n");
	    Exit(30);
	fi;
	OutPos := 0;
    fi;
corp;

/*
 * addChar -
 *   Add a single character to the output file, flushing if needed.
 */

proc addChar(char ch)void:

    OutBuff[OutPos] := ch;
    OutPos := OutPos + 1;
    if OutPos = BUFF_SIZE then
	flush();
    fi;
corp;

/*
 * addString -
 *   Add a string to the output file, using 'addChar'.
 */

proc addString(*char st)void:

    while st* ~= '\e' do
	addChar(st*);
	st := st + 1;
    od;
corp;

/*
 * encodeByte -
 *   Encode a six-bit value as an ASCII char and add it to the output.
 *   The main function is to replace blanks by graves.
 */

proc encodeByte(byte b)void:

    addChar(if b = 0 then '`' else b + ' ' fi);
corp;

/*
 * getByte -
 *   Get the next byte from the input binary file.
 */

proc getByte()byte:

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
 * encode -
 *   Encode the already opened input file into the already opened output
 *   file, using the given remote system file name.
 */

proc encode(*char remFileName)void:
    *char p;
    [MAX_BYTES] byte buff;
    uint i, len;
    byte b1, b2, b3;

    /* add the 'begin' line */
    addString("begin 644 ");
    addString(remFileName);
    addChar('\n');
    /* add the encoded binary file */
    while not Eof do
	/* get a bufferful (or however much is left to get) */
	len := 0;
	while not Eof and len ~= MAX_BYTES do
	    buff[len] := getByte();
	    if not Eof then
		len := len + 1;
	    fi;
	od;
	/* first char on output line is encoded actual length */
	encodeByte(len);
	/* followed by up to MAX_BYTES * 4 / 3 characters of encoded data */
	i := 0;
	while i < len do
	    b1 := buff[i];
	    b2 := buff[i + 1];
	    b3 := buff[i + 2];
	    i := i + 3;
	    encodeByte(b1 >> 2);
	    encodeByte(b1 & 0x03 << 4 | b2 >> 4);
	    encodeByte(b2 & 0x0f << 2 | b3 >> 6);
	    encodeByte(b3 & 0x3f);
	od;
	/* and a newline */
	addChar('\n');
    od;
    /* add the zero length terminator line so the UNIX version will live */
    encodeByte(0);
    addChar('\n');
    /* add the 'end' line */
    addString("end\n");
corp;

/*
 * parBump -
 *   Move up one character in the command line tail.
 */

proc parBump()void:

    ParPtr := ParPtr + 1;
    ParLen := ParLen - 1;
corp;

/*
 * parSkipSpace -
 *   Skip over any space in the command line tail.
 */

proc parSkipSpace()void:

    while ParLen ~= 0 and
	    (ParPtr* = ' ' or ParPtr* = '\n' or ParPtr* = '\r') do
	parBump();
    od;
corp;

/*
 * parGetName -
 *   Isolate a name from the command tail.
 */

proc parGetName()void:

    while ParLen ~= 0 and ParPtr* ~= ' ' and ParPtr* ~= '\n' do
	parBump();
    od;
    ParPtr* := '\e';
    parBump();
corp;

/*
 * main -
 *   The main program. Get the command line parameters, parse them, open
 *   files as needed and pass the remote file name to 'encode'.
 */

proc main()void:
    *char inFileName, remFileName;
    [60] char nameBuffer;
    *char p, q;

    if OpenDosLibrary(0) ~= nil then
	StdOut := Output();
	GetPars(&ParLen, &ParPtr);
	parSkipSpace();
	if ParLen = 0 then
	    writeString("usage: uuencode localFileName [remoteFileName]\n");
	else
	    inFileName := ParPtr;
	    parGetName();
	    parSkipSpace();
	    /* find the final simple name of the given input name */
	    p := inFileName;
	    while p* ~= '\e' do
		p := p + 1;
	    od;
	    while p ~= inFileName and p* ~= '/' do
		p := p - 1;
	    od;
	    if p* = '/' then
		p := p + 1;
	    fi;
	    if ParLen = 0 then
		/* if no explicit remote file name is given, use the tail of
		   the input file name. */
		remFileName := p;
	    else
		remFileName := ParPtr;
		parGetName();
	    fi;
	    /* make a copy of input name so that we can append .uue to it */
	    q := &nameBuffer[0];
	    while
		q* := p*;
		p* ~= '\e'
	    do
		p := p + 1;
		q := q + 1;
	    od;
	    p := ".uue";
	    while
		q* := p*;
		p* ~= '\e'
	    do
		p := p + 1;
		q := q + 1;
	    od;
	    /* open files, etc. */
	    InFd := Open(inFileName, MODE_READ);
	    if InFd = 0 then
		writeString("Can't open input file '");
		writeString(inFileName);
		writeString("'\n");
		Exit(10);
	    fi;
	    DeleteFile(&nameBuffer[0]);
	    OutFd := Open(&nameBuffer[0], MODE_WRITE);
	    if OutFd = 0 then
		writeString("Can't open/create output file '");
		writeString(&nameBuffer[0]);
		writeString("'\n");
		Close(InFd);
		Exit(20);
	    fi;
	    /* initialize */
	    Eof := false;
	    InMax := 0;
	    InPos := 0;
	    OutPos := 0;
	    /* go encode the file */
	    encode(remFileName);
	    /* flush output buffer, and close files */
	    flush();
	    Close(OutFd);
	    Close(InFd);
	fi;
	CloseDosLibrary();
    fi;
corp;
