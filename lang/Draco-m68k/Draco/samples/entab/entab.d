type FileHandle_t = ulong;

ulong
    MODE_OLDFILE = 1005,
    MODE_NEWFILE = 1006;

uint BUFFER_SIZE = 10000;
uint NAME_SIZE = 100;

extern
    OpenDosLibrary(ulong version)*byte,
    CloseDosLibrary()void,
    Rename(*char oldName, newName)ulong,
    Open(*char fileName; ulong mode)FileHandle_t,
    Close(FileHandle_t fd)void,
    Read(FileHandle_t fd; *char buffer; ulong length)ulong,
    Write(FileHandle_t fd; *char buffer; ulong length)ulong,
    Exit(ulong status)void,
    Output()FileHandle_t,
    GetPars(*ulong pLen; **char pPtr)void;

[BUFFER_SIZE] char InputBuffer, OutputBuffer;
uint InputPos, InputMax, OutputPos;
bool Eof;
FileHandle_t StdOut, InputFd, OutputFd;

proc print(*char message)void:
   *char p;

    p := message;
	while p* ~= '\e' do
    p := p + 1;
    od;
    if Write(StdOut, message, p - message) ~= p - message then
	Exit(40);
    fi;
corp;

proc getChar()char:

    if InputPos = InputMax then
	InputPos := 0;
	InputMax := Read(InputFd, &InputBuffer[0], BUFFER_SIZE);
	if InputMax = 0 then
	    Eof := true;
	fi;
    fi;
    InputPos := InputPos + 1;
    InputBuffer[InputPos - 1]
corp;

proc flushOutput()void:

   if Write(OutputFd, &OutputBuffer[0], OutputPos) ~= OutputPos then
      print("entab: bad write to output file - aborting.\n");
      Close(OutputFd);
      Close(InputFd);
      Exit(30);
   fi;
corp;

proc putChar(char ch)void:

    if OutputPos = BUFFER_SIZE then
	flushOutput();
	OutputPos := 0;
    fi;
    OutputBuffer[OutputPos] := ch;
    OutputPos := OutputPos + 1;
corp;

proc entab()void:
    char ch;
    uint column, doneColumn;
    char CPM_EOF = '\(0x1a)';

    Eof := false;
    column := 0;
    doneColumn := 0;
    while
	ch := getChar();
	not Eof and ch ~= CPM_EOF
    do
	if ch = '\t' then
	    column := (column + 8) & (0xfff8);
	elif ch = ' ' then
	    column := column + 1;
	else
	    if ch = '\n' then
		putChar('\n');
		column := 0;
		doneColumn := 0;
	    elif ch ~= '\r' then
		while (doneColumn + 8) & (0xfff8) <= column do
		    putChar('\t');
		    doneColumn := (doneColumn + 8) & (0xfff8);
		od;
		while doneColumn ~= column do
		    putChar(' ');
		    doneColumn := doneColumn + 1;
		od;
		putChar(ch);
		column := column + 1;
		doneColumn := doneColumn + 1;
	    fi;
	fi;
    od;
corp;

proc process(*char fileName)void:
    *char p, q;
    [NAME_SIZE] char nameBuffer;

    p := &nameBuffer[0];
    q := fileName;
    while
	p* := q*;
	p* ~= '\e'
    do
	p := p + 1;
	q := q + 1;
    od;
    (p + 0)* := '.';
    (p + 1)* := 'B';
    (p + 2)* := 'A';
    (p + 3)* := 'K';
    (p + 4)* := '\e';
    if Rename(fileName, &nameBuffer[0]) = 0 then
	print("Can't rename file to .BAK - aborting\n");
	Exit(30);
    fi;
    InputFd := Open(&nameBuffer[0], MODE_OLDFILE);
    if InputFd = 0 then
	print("Can't open old file for input - aborting\n");
	Exit(20);
    fi;
    OutputFd := Open(fileName, MODE_NEWFILE);
    if OutputFd = 0 then
	print("Can't open new file for output - aborting\n");
	Close(InputFd);
	Exit(30);
    fi;
    InputPos := 0;
    InputMax := 0;
    OutputPos := 0;
    entab();
    if OutputPos ~= 0 then
	flushOutput();
    fi;
    Close(InputFd);
    Close(OutputFd);
corp;

proc main()void:
    *char parPtr;
    ulong parLen;
    *char nameStart;
    bool doneFile;

    if OpenDosLibrary(0) ~= nil then
	GetPars(&parLen, &parPtr);
	StdOut := Output();
	doneFile := false;
	while
	    while parLen ~= 0 and
		    (parPtr* = ' ' or parPtr* = '\n' or parPtr* = '\r') do
		parLen := parLen - 1;
		parPtr := parPtr + 1;
	    od;
	    parLen ~= 0
	do
	    doneFile := true;
	    nameStart := parPtr;
	    while parLen ~= 0 and
		    parPtr* ~= ' ' and parPtr* ~= '\n' and parPtr* ~= '\r' do
		parLen := parLen - 1;
		parPtr := parPtr + 1;
	    od;
	    parPtr* := '\e';
	    parLen := parLen - 1;
	    parPtr := parPtr + 1;
	    print(nameStart);
	    print(":\n");
	    process(nameStart);
	od;
	if not doneFile then
	    print("Use is: entab file ... file\n");
	    Exit(10);
	fi;
	CloseDosLibrary();
    fi;
corp;
