#drinc:util.g
#drinc:crt.g

char CSI = '\(0x9b)';

uint BUFFSIZE = 1024;

uint
    FILECOL = 12,
    ROCOL = 2,
    POSCOL = 33,
    POSLEN = 6,
    NUMLEN = 11,
    HEXCOL = 7,
    ERRORCOL = POSCOL + NUMLEN + 1;

uint NLines, NCols;

file(BUFFSIZE) Fyle;
channel input binary ChIn;
channel output binary ChOut;
channel output text CRTOut;

*char FileName;

ulong FilePos, WindowPos, EndPos;

uint CursorLine, CursorColHex, CursorColChar;

bool ReadOnly, Binary, HadError;

proc err(*char message)void:

    CRT_Move(NLines - 1, ERRORCOL);
    CRT_EnterHighLight();
    write(CRTOut; message);
    CRT_ExitHighLight();
    HadError := true;
corp;

proc abort(*char message)void:

    writeln("HEdit I/O error: ", message, ' ',
	    ioerror(ChIn), ' ', ioerror(ChOut));
    if not ReadOnly then
	close(ChOut);
    fi;
    close(ChIn);
    close(CRTOut);
    CRT_Abort();
corp;

proc endOfFile()void:

    err("End of file");
corp;

proc startOfFile()void:

    err("Beginning of file");
corp;

proc displayPos()void:

    CRT_Move(NLines - 1, POSCOL);
    write(CRTOut; FilePos : x : -POSLEN);
corp;

proc displayStatus()void:
    uint i;

    HadError := false;
    CRT_ClearLine(NLines - 1);
    for i from 0 upto NCols - 2 do
	write(CRTOut; '-');
    od;
    CRT_Move(NLines - 1, FILECOL);
    write(CRTOut; FileName);
    if ReadOnly then
	CRT_Move(NLines - 1, ROCOL);
	write(CRTOut; "[RO]");
    fi;
    displayPos();
    CRT_Move(NLines - 1, HEXCOL);
    write(CRTOut; if Binary then "hex-" else "char" fi);
corp;

proc clearError()void:
    uint i;

    if HadError then
	HadError := false;
	CRT_Move(NLines - 1, ERRORCOL);
	for i from ERRORCOL + 2 upto NCols do
	    write(CRTOut; '-');
	od;
    fi;
corp;

proc getChar()char:
    char ch;

    ch := CRT_ReadChar();
    clearError();
    ch
corp;

proc ASCIIPut(byte b)void:

    write(CRTOut; if b + '\e' >= ' ' and b + '\e' <= '~' then
		      b + '\e'
		  else
		      '.'
		  fi);
corp;

proc seek(ulong pos)void:

    if not SeekIn(ChIn, pos) then
	abort("Seek failed");
    fi;
corp;

proc unCursor()void:
    byte b;

    seek(FilePos);
    read(ChIn; b);
    CRT_Move(CursorLine, CursorColHex);
    write(CRTOut; b : x : -2);
    CRT_Move(CursorLine, CursorColChar);
    ASCIIPut(b);
corp;

proc putCursor()void:
    byte b;

    seek(FilePos);
    read(ChIn; b);
    CRT_EnterHighLight();
    CRT_Move(CursorLine, CursorColHex);
    write(CRTOut; b : x : -2);
    CRT_Move(CursorLine, CursorColChar);
    ASCIIPut(b);
    CRT_ExitHighLight();
corp;

proc displayLine(ulong pos)bool:
    uint c, c1;
    [16] byte buff;

    write(CRTOut; pos : x : -POSLEN, ":  ");
    c := 0;
    while c ~= 16 and read(ChIn; buff[c]) do
	write(CRTOut; buff[c] : x : -2, ' ');
	c := c + 1;
    od;
    for c1 from c upto 15 do
	buff[c1] := ' ' - '\e';
	write(CRTOut; "   ");
    od;
    write(CRTOut; " *");
    for c1 from 0 upto 15 do
	ASCIIPut(buff[c1]);
    od;
    write(CRTOut; "*\r\n");
    ioerror(ChIn) = CH_OK
corp;

proc displayScreen()void:
    ulong pos;
    uint l;

    CRT_Move(0, 0);
    pos := WindowPos;
    l := 0;
    seek(pos);
    while l ~= NLines - 1 and displayLine(pos) do
	l := l + 1;
	pos := pos + 16;
    od;
    l := l + 1;
    while l < NLines - 1 do
	CRT_ClearLine(l);
	l := l + 1;
    od;
    putCursor();
corp;

proc scrollUp()void:
    ulong pos;

    pos := WindowPos + (NLines - 1) * 16;
    if pos < EndPos then
	CRT_ClearLine(NLines - 1);
	seek(pos);
	pretend(displayLine(pos), void);
	WindowPos := WindowPos + 16;
	if CursorLine = 0 then
	    FilePos := FilePos + 16;
	    if FilePos > EndPos - 1 then
		CursorColHex := CursorColHex - 3 * (EndPos - 1 - FilePos);
		CursorColChar := CursorColChar - (EndPos - 1 - FilePos);
		FilePos := EndPos - 1;
	    fi;
	    putCursor();
	else
	    CursorLine := CursorLine - 1;
	fi;
	displayStatus();
    else
	endOfFile();
    fi;
corp;

proc cursorForward()void:

    if FilePos & 0xf = 0xf and CursorLine = NLines - 2 then
	scrollUp();
    fi;
    if FilePos < EndPos - 1 then
	unCursor();
	FilePos := FilePos + 1;
	if FilePos & 0xf = 0 then
	    CursorLine := CursorLine + 1;
	    CursorColHex := 9;
	    CursorColChar := 59;
	else
	    CursorColHex := CursorColHex + 3;
	    CursorColChar := CursorColChar + 1;
	fi;
	putCursor();
	displayPos();
    else
	endOfFile();
    fi;
corp;

proc cursorBackward()void:

    if FilePos ~= 0 then
	unCursor();
	FilePos := FilePos - 1;
	if FilePos & 0xf = 0xf then
	    CursorColHex := 9 + 30 + 15;
	    CursorColChar := 59 + 15;
	    if CursorLine = 0 then
		WindowPos := WindowPos - 16;
		CRT_ClearScreen();
		displayScreen();
		displayStatus();
	    else
		CursorLine := CursorLine - 1;
	    fi;
	else
	    CursorColHex := CursorColHex - 3;
	    CursorColChar := CursorColChar - 1;
	fi;
	putCursor();
	displayPos();
    else
	startOfFile();
    fi;
corp;

proc cursorUp()void:

    if FilePos >= 16 then
	unCursor();
	FilePos := FilePos - 16;
	if CursorLine = 0 then
	    WindowPos := WindowPos - 16;
	    CRT_ClearScreen();
	    displayScreen();
	    displayStatus();
	else
	    CursorLine := CursorLine - 1;
	fi;
	putCursor();
	displayPos();
    else
	startOfFile();
    fi;
corp;

proc cursorDown()void:

    if CursorLine = NLines - 2 then
	scrollUp();
    fi;
    if FilePos < EndPos - 16 then
	unCursor();
	FilePos := FilePos + 16;
	CursorLine := CursorLine + 1;
	putCursor();
	displayPos();
    else
	endOfFile();
    fi;
corp;

proc cursorHome()void:
    bool redraw;

    unCursor();
    redraw := WindowPos ~= 0;
    FilePos := 0;
    WindowPos := 0;
    CursorLine := 0;
    CursorColHex := 9;
    CursorColChar := 59;
    if redraw then
	CRT_ClearScreen();
	displayScreen();
	displayStatus();
	putCursor();
    else
	putCursor();
	displayPos();
    fi;
corp;

proc pageForward()void:
    ulong pos;

    pos := WindowPos + (NLines - 3) * 16;
    if pos < EndPos then
	WindowPos := pos;
	FilePos := FilePos + (NLines - 3) * 16;
	if FilePos >= EndPos then
	    FilePos := EndPos - 1;
	    CursorLine := (EndPos - WindowPos) / 16 - 1;
	    CursorColHex := 9 + FilePos % 16 * 3;
	    CursorColChar := 59 + FilePos % 16;
	fi;
	CRT_ClearScreen();
	displayScreen();
	displayStatus();
    else
	endOfFile();
    fi;
corp;

proc pageBackward()void:

    if WindowPos ~= 0 then
	if WindowPos >= (NLines - 3) * 16 then
	    WindowPos := WindowPos - (NLines - 3) * 16;
	    FilePos := FilePos - (NLines - 3) * 16;
	else
	    FilePos := FilePos - WindowPos;
	    WindowPos := 0;
	fi;
	CRT_ClearScreen();
	displayScreen();
	displayStatus();
    else
	startOfFile();
    fi;
corp;

proc getHex()byte:
    char ch;

    while
	ch := CRT_ReadChar();
	not (ch >= '0' and ch <= '9' or
	     ch >= 'a' and ch <= 'f' or
	     ch >= 'A' and ch <= 'F' or
	     ch = '\r' or ch = '\b')
    do
    od;
    if ch >= 'A' and ch <= 'F' then
	ch - 'A' + 10
    elif ch >= 'a' and ch <= 'f' then
	ch - 'a' + 10
    elif ch = '\r' then
	255
    elif ch = '\b' then
	254
    else
	ch - '0'
    fi
corp;

proc gotoDisplay(ulong pos; bool redraw)void:

    if not redraw then
	unCursor();
	CursorLine := CursorLine + (pos / 16 - FilePos / 16);
    fi;
    FilePos := pos;
    CursorColHex := (FilePos & 0xf) * 3 + 9;
    CursorColChar := (FilePos & 0xf) + 59;
    if redraw then
	CRT_ClearScreen();
	CursorLine := 0;
	displayScreen();
	displayStatus();
    else
	displayPos();
    fi;
    putCursor();
corp;

proc goto()void:
    ulong pos, endPos;
    byte b;
    uint p, q;
    [POSLEN] byte buff;

    err("Enter location to go to");
    CRT_Move(NLines - 1, POSCOL);
    write(CRTOut; "      ");
    CRT_Move(NLines - 1, POSCOL);
    p := 0;
    while
	while
	    b := getHex();
	    b = 0 and p = 0
	do
	od;
	b ~= 255
    do
	if b = 254 then
	    if p ~= 0 then
		p := p - 1;
		write(CRTOut; "\b \b");
	    fi;
	elif p = POSLEN then
	    write(CRTOut; '\(0x07)');
	else
	    write(CRTOut; if b < 10 then b + '0' else b - 10 + 'a' fi);
	    buff[p] := b;
	    p := p + 1;
	fi;
    od;
    if p = 0 then
	clearError();
	err("OK - no goto done");
	displayPos();
    else
	q := POSLEN;
	while p ~= 0 do
	    p := p - 1;
	    q := q - 1;
	    buff[q] := buff[p];
	od;
	while q ~= 0 do
	    q := q - 1;
	    buff[q] := 0;
	od;
	pos := (make(buff[0], uint) << 20) +
	       (make(buff[1], uint) << 16) +
	       (make(buff[2], uint) << 12) +
	       (make(buff[3], uint) << 8) +
	       (make(buff[4], uint) << 4) +
		make(buff[5], uint);
	if pos = FilePos then
	    ;
	elif pos < FilePos then
	    if pos < WindowPos then
		WindowPos := pos & 0xfffff0;
		gotoDisplay(pos, true);
	    else
		gotoDisplay(pos, false);
	    fi;
	else
	    if pos >= EndPos then
		endOfFile();
		pos := EndPos - 1;
	    fi;
	    endPos := WindowPos + (NLines - 1) * 16;
	    if pos >= endPos then
		WindowPos := pos & 0xfffff0;
		gotoDisplay(pos, true);
	    else
		gotoDisplay(pos, false);
	    fi;
	fi;
	clearError();
    fi;
corp;

proc toDec()void:
    ulong num;
    uint p;
    byte b;

    err("Enter hex value to convert");
    CRT_Move(NLines - 1, POSCOL);
    write(CRTOut; "        ");
    CRT_Move(NLines - 1, POSCOL);
    num := 0;
    p := 0;
    while
	while
	    b := getHex();
	    b = 0 and p = 0
	do
	od;
	b ~= 255
    do
	if b = 254 then
	    if p ~= 0 then
		num := num >> 4;
		p := p - 1;
		write(CRTOut; "\b \b");
	    fi;
	elif p = 8 then
	    write(CRTOut; '\(0x07)');
	else
	    write(CRTOut; if b < 10 then b + '0' else b - 10 + 'a' fi);
	    num := (num << 4) + b;
	    p := p + 1;
	fi;
    od;
    clearError();
    if p ~= 0 then
	err("Decimal value is ");
	CRT_Move(NLines - 1, ERRORCOL + 17);
	CRT_EnterHighLight();
	write(CRTOut; num : u);
	CRT_ExitHighLight();
    fi;
    CRT_Move(NLines - 1, POSCOL + POSLEN);
    for p from POSLEN upto NUMLEN - 1 do
	write(CRTOut; '-');
    od;
    displayPos();
corp;

proc toHex()void:
    ulong num;
    uint p;
    char ch;

    err("Enter decimal value to convert");
    CRT_Move(NLines - 1, POSCOL);
    write(CRTOut; "           ");
    CRT_Move(NLines - 1, POSCOL);
    num := 0;
    p := 0;
    while
	while
	    while
		ch := CRT_ReadChar();
		not (ch >= '0' and ch <= '9' or
		     ch = '\r' or ch = '\b')
	    do
	    od;
	    ch = '0' and p = 0
	do
	od;
	ch ~= '\r'
    do
	if ch = '\b' then
	    if p ~= 0 then
		num := num / 10;
		p := p - 1;
		write(CRTOut; "\b \b");
	    fi;
	elif p = NUMLEN then
	    write(CRTOut; '\(0x07)');
	else
	    write(CRTOut; ch);
	    num := (num * 10) + (ch - '0');
	    p := p + 1;
	fi;
    od;
    clearError();
    if p ~= 0 then
	err("Hex value is ");
	CRT_Move(NLines - 1, ERRORCOL + 13);
	CRT_EnterHighLight();
	write(CRTOut; num : x : -8);
	CRT_ExitHighLight();
    fi;
    CRT_Move(NLines - 1, POSCOL + POSLEN);
    for p from POSLEN upto NUMLEN - 1 do
	write(CRTOut; '-');
    od;
    displayPos();
corp;

proc helpScreen()void:

    CRT_ClearScreen();
    write(CRTOut;
	    "\n"
	    "\t\tCommands are:\r\n"
	    "\n"
	    "\tESC - exit\r\n"
	    "\tarrow keys - move cursor\r\n"
	    "\tshift-left-arrow - move to beginning of file\r\n"
	    "\tshift-down-arrow - page forward\r\n"
	    "\tshift-up-arrow - page backward\r\n"
	    "\tshift-right-arrow - go to specific location\r\n"
	    "\tRETURN - scrollUp screen\r\n"
	    "\tF1 - convert decimal value to hex\r\n"
	    "\tF2 - convert hex value to decimal\r\n"
	    "\tF3 - toggle hex/char mode\r\n"
	    "\tF10 - redraw screen\r\n"
	    "\tothers - replace char when not Read-Only\r\n"
    );
    CRT_Move(16, 10);
    write(CRTOut; "       File size: ", EndPos : u : 8,
		  ", hex ", EndPos : x : 6);
    CRT_Move(17, 10);
    write(CRTOut; "Current position: ", FilePos : u : 8,
		  ", hex ", FilePos : x : 6);
    CRT_Continue();
    CRT_ClearScreen();
    displayScreen();
    displayStatus();
corp;

proc writeByte(byte b)void:

    if not SeekOut(ChOut, FilePos) then
	abort("Write seek failed");
    fi;
    write(ChOut; b);
    cursorForward();
corp;

proc eatTilde()bool:

    if getChar() = '~' then
	true
    else
	err("Invalid; Press HELP for help");
	false
    fi
corp;

proc edit()void:
    byte b, b2;
    char cmd;

    EndPos := GetInMax(ChIn);
    displayScreen();
    while
	CRT_Move(CursorLine,
		 if Binary then CursorColHex else CursorColChar fi);
	cmd := getChar();
	cmd ~= '\(0x1b)'
    do
	if cmd = '\r' then
	    scrollUp();
	elif cmd = CSI then
	    case getChar()
	    incase ' ':
		case getChar()
		incase 'A':
		    cursorHome();
		incase '@':
		    goto();
		default:
		    err("Invalid; Press HELP for help");
		esac;
	    incase '?':
		if eatTilde() then
		    helpScreen();
		fi;
	    incase 'C':
		cursorForward();
	    incase 'D':
		cursorBackward();
	    incase 'A':
		cursorUp();
	    incase 'B':
		cursorDown();
	    incase 'S':
		pageForward();
	    incase 'T':
		pageBackward();
	    incase '9':
		if eatTilde() then
		    CRT_Reset();
		    CRT_ClearScreen();
		    displayScreen();
		    displayStatus();
		fi;
	    incase '2':
		if eatTilde() then
		    CRT_Move(NLines - 1, HEXCOL);
		    if Binary then
			Binary := false;
			write(CRTOut; "char");
		    else
			Binary := true;
			write(CRTOut; "hex-");
		    fi;
		fi;
	    incase '1':
		if getChar() = '~' then
		    toDec();
		else
		    while getChar() ~= '~' do
		    od;
		    err("Invalid; Press HELP for help");
		fi;
	    incase '0':
		if eatTilde() then
		    toHex();
		fi;
	    default:
		while getChar() ~= '~' do
		od;
		err("Invalid; Press HELP for help");
	    esac;
	else
	    if cmd >= ' ' and cmd <= '~' then
		if ReadOnly then
		    err("Modifications not allowed");
		elif Binary then
		    if cmd >= '0' and cmd <= '9' or
			    cmd >= 'a' and cmd <= 'f' or
			    cmd >= 'A' and cmd <= 'F' then
			b :=
			    if cmd >= '0' and cmd <= '9' then
				cmd - '0'
			    elif cmd >= 'a' and cmd <= 'f' then
				cmd - 'a' + 10
			    else
				cmd - 'A' + 10
			    fi;
			CRT_EnterHighLight();
			write(CRTOut;
			      if b >= 10 then b - 10 + 'a' else b + '0' fi);
			CRT_ExitHighLight();
			b2 := getHex();
			if b2 = 255 then
			    writeByte(b);
			elif b2 = 254 then
			    putCursor();
			else
			    writeByte(b << 4 + b2);
			fi;
		    else
			err("Bad hexadecimal digit");
		    fi;
		else
		    write(CRTOut; cmd);
		    CRT_Move(CursorLine, CursorColHex);
		    write(CRTOut; cmd - '\e' : x : -2);
		    writeByte(cmd - '\e');
		fi;
	    else
		err("Invalid; Press HELP for help");
	    fi;
	fi;
    od;
    if not ReadOnly then
	close(ChOut);
    fi;
    close(ChIn);
corp;

proc badUse()void:

    writeln("Use is: HEdit [-w] file1 ... fileN");
    exit(1);
corp;

proc main()void:
    *char par;

    ReadOnly := true;
    Binary := true;
    par := GetPar();
    if par ~= nil and par* = '-' then
	while
	    par := par + 1;
	    par* ~= '\e'
	do
	    case par*
	    incase 'w':
	    incase 'W':
		ReadOnly := false;
	    default:
		badUse();
	    esac;
	od;
	par := GetPar();
    fi;
    if par = nil then
	badUse();
    fi;
    CRT_Initialize("HEdit - press HELP for help", 0, 0);
    CRT_AbortDisable();
    NLines := CRT_NLines();
    NCols := CRT_NCols();
    if NCols < 61 then
	writeln("HEdit: less than 61 columns - aborting.");
	CRT_Abort();
    fi;
    open(CRTOut, CRT_PutChar);
    while par ~= nil do
	FilePos := 0;
	WindowPos := 0;
	CursorLine := 0;
	CursorColHex := 9;
	CursorColChar := 59;
	CRT_ClearScreen();
	FileName := par;
	if open(ChIn, Fyle, FileName) then
	    displayStatus();
	    if not ReadOnly then
		ReOpen(ChIn, ChOut);
	    fi;
	    if not SeekIn(ChIn, 0) then
		err("Empty file - press a key");
		pretend(getChar(), void);
	    else
		edit();
	    fi;
	else
	    displayStatus();
	    err("No such file - press a key");
	    pretend(getChar(), void);
	fi;
	par := GetPar();
    od;
    close(CRTOut);
    CRT_Terminate();
corp;
