#drinc:util.g
#drinc:crt.g

int
    SCANRANGE = 20,
    BINARYBLOCKCOUNT = 8,
    BUFFERSIZE = 8 * 1024,
    LINECOUNT = 25,
    LINEBUFFERSIZE = 4 * 1024;

channel input binary ChB1, ChB2;
channel input text ChT1, ChT2;
file(BUFFERSIZE) File1, File2;
channel output text CRT;

uint
    LineNext1,
    LineNext2,
    LineCount,
    FullLineLength,
    HalfLineLength;

uint
    LineNumber1,
    LineNumber2;

ushort LinesPerScreen;

bool
    TextMode,
    Visual,
    Wrappable,
    Eof1,
    Eof2;

[LINECOUNT] uint
    Line1,
    Line2;

[LINEBUFFERSIZE] char
    LineBuffer1,
    LineBuffer2;

proc closeBoth()void:

    if TextMode then
	close(ChT1);
	close(ChT2);
    else
	close(ChB1);
	close(ChB2);
    fi;
corp;

proc doAbort()void:

    closeBoth();
    CRT_Abort();
corp;

proc checkWait()void:
    char ch;

    if LineCount = LinesPerScreen - 1 then
	if TextMode then
	    write(CRT; '\t', ChT1, " line ", LineNumber1, " \t\t\t");
	else
	    write(CRT; '\t', ChB1, "  \t\t\t\t");
	fi;
	if TextMode then
	    write(CRT; ChT2, " line ", LineNumber2, '\r');
	else
	    write(CRT; ChB2, '\r');
	fi;
	ch := CRT_ReadChar();
	CRT_ClearLine(LinesPerScreen - 1);
	if ch = '\(0x03)' then
	    doAbort();
	elif ch = '\r' or ch = '\n' then
	    LineCount := LineCount - 1;
	    CRT_Scroll();
	    CRT_ClearLine(LinesPerScreen - 2);
	else
	    LineCount := 0;
	    CRT_ClearScreen();
	fi;
    fi;
    LineCount := LineCount + 1;
corp;

proc nl()void:

    write(CRT; "\r\n");
    checkWait();
corp;

proc removeLine1()void:
    uint pos, i, p;

    LineNumber1 := LineNumber1 + 1;
    pos := Line1[1];
    p := 0;
    i := Line1[LineNext1];
    while pos ~= i do
	LineBuffer1[p] := LineBuffer1[pos];
	p := p + 1;
	pos := pos + 1;
    od;
    LineNext1 := LineNext1 - 1;
    pos := Line1[1];
    for i from 0 upto LineNext1 do
	Line1[i] := Line1[i + 1] - pos;
    od;
corp;

proc removeLine2()void:
    uint pos, i, p;

    LineNumber2 := LineNumber2 + 1;
    pos := Line2[1];
    p := 0;
    i := Line2[LineNext2];
    while pos ~= i do
	LineBuffer2[p] := LineBuffer2[pos];
	p := p + 1;
	pos := pos + 1;
    od;
    LineNext2 := LineNext2 - 1;
    pos := Line2[1];
    for i from 0 upto LineNext2 do
	Line2[i] := Line2[i + 1] - pos;
    od;
corp;

proc flush1()void:
    uint pos, len, i;

    pos := 0;
    len := Line1[1] - 1;
    while pos ~= len do
	i := 0;
	CRT_EnterHighLight();
	while i ~= HalfLineLength and pos ~= len do
	    if LineBuffer1[pos] = '\t' then
		LineBuffer1[pos] := '\(0x80)' + ((i + 8) / 8 * 8 - i);
	    fi;
	    if LineBuffer1[pos] >= '\(0x80)' then
		while LineBuffer1[pos] ~= '\(0x80)' and
			i ~= HalfLineLength do
		    write(CRT; ' ');
		    i := i + 1;
		    LineBuffer1[pos] := LineBuffer1[pos] - 1;
		od;
		if LineBuffer1[pos] = '\(0x80)' then
		    pos := pos + 1;
		fi;
	    else
		write(CRT; LineBuffer1[pos]);
		i := i + 1;
		pos := pos + 1;
	    fi;
	od;
	while i ~= HalfLineLength do
	    write(CRT; ' ');
	    i := i + 1;
	od;
	CRT_ExitHighLight();
	write(CRT; '|');
	nl();
    od;
    removeLine1();
corp;

proc flush2()void:
    uint pos, len, i;

    pos := 0;
    len := Line2[1] - 1;
    while pos ~= len do
	for i from 0 upto HalfLineLength - 1 do
	    write(CRT; ' ');
	od;
	write(CRT; '|');
	i := 0;
	CRT_EnterHighLight();
	while i ~= HalfLineLength and pos ~= len do
	    if LineBuffer2[pos] = '\t' then
		LineBuffer2[pos] := '\(0x80)' + ((i + 8) / 8 * 8 - i);
	    fi;
	    if LineBuffer2[pos] >= '\(0x80)' then
		while LineBuffer2[pos] ~= '\(0x80)' and
			i ~= HalfLineLength do
		    write(CRT; ' ');
		    i := i + 1;
		    LineBuffer2[pos] := LineBuffer2[pos] - 1;
		od;
		if LineBuffer2[pos] = '\(0x80)' then
		    pos := pos + 1;
		fi;
	    else
		write(CRT; LineBuffer2[pos]);
		i := i + 1;
		pos := pos + 1;
	    fi;
	od;
	CRT_ExitHighLight();
	if Wrappable and i = HalfLineLength then
	    checkWait();
	else
	    nl();
	fi;
    od;
    removeLine2();
corp;

proc flushBoth()void:
    uint pos1, pos2, len1, len2, i;

    pos1 := 0;
    pos2 := 0;
    len1 := Line1[1] - 1;
    len2 := Line2[1] - 1;
    if len1 = 0 and len2 = 0 then
	/* need this, since the main while wouldn't do anything */
	for i from 0 upto HalfLineLength - 1 do
	    write(CRT; ' ');
	od;
	write(CRT; '|');
	nl();
    fi;
    while pos1 ~= len1 or pos2 ~= len2 do
	i := 0;
	while i ~= HalfLineLength and pos1 ~= len1 do
	    if LineBuffer1[pos1] = '\t' then
		LineBuffer1[pos1] := '\(0x80)' + ((i + 8) / 8 * 8 - i);
	    fi;
	    if LineBuffer1[pos1] >= '\(0x80)' then
		while LineBuffer1[pos1] ~= '\(0x80)' and
			i ~= HalfLineLength do
		    write(CRT; ' ');
		    i := i + 1;
		    LineBuffer1[pos1] := LineBuffer1[pos1] - 1;
		od;
		if LineBuffer1[pos1] = '\(0x80)' then
		    pos1 := pos1 + 1;
		fi;
	    else
		write(CRT; LineBuffer1[pos1]);
		i := i + 1;
		pos1 := pos1 + 1;
	    fi;
	od;
	while i ~= HalfLineLength do
	    write(CRT; ' ');
	    i := i + 1;
	od;
	write(CRT; '|');
	i := 0;
	while i ~= HalfLineLength and pos2 ~= len2 do
	    if LineBuffer2[pos2] = '\t' then
		LineBuffer2[pos2] := '\(0x80)' + ((i + 8) / 8 * 8 - i);
	    fi;
	    if LineBuffer2[pos2] >= '\(0x80)' then
		while LineBuffer2[pos2] ~= '\(0x80)' and
			i ~= HalfLineLength do
		    write(CRT; ' ');
		    i := i + 1;
		    LineBuffer2[pos2] := LineBuffer2[pos2] - 1;
		od;
		if LineBuffer2[pos2] = '\(0x80)' then
		    pos2 := pos2 + 1;
		fi;
	    else
		write(CRT; LineBuffer2[pos2]);
		i := i + 1;
		pos2 := pos2 + 1;
	    fi;
	od;
	if Wrappable and i = HalfLineLength then
	    checkWait();
	else
	    nl();
	fi;
    od;
    removeLine1();
    removeLine2();
corp;

proc getLine1()void:
    uint pos;
    char ch;
    bool first;

    pos := Line1[LineNext1];
    first := true;
    while
	if first then
	    if not read(ChT1; ch) then
		first := false;
	    fi;
	    true
	else
	    false
	fi
    do
	if pos = LINEBUFFERSIZE then
	    if LineNext1 = 0 then
		write(ChT1, ": input line too long.\r\n");
		doAbort();
	    fi;
	    Line1[LineNext1 + 1] := pos;
	    if CharsEqual(&LineBuffer1[Line1[0]],
			  &LineBuffer2[Line2[0]]) then
		flushBoth();
	    else
		flush1();
		flush2();
	    fi;
	fi;
	LineBuffer1[pos] := ch;
	pos := pos + 1;
    od;
    if pos ~= Line1[LineNext1] then
	LineBuffer1[pos - 1] := '\e';
	Line1[LineNext1 + 1] := pos;
	LineNext1 := LineNext1 + 1;
    fi;
    if ioerror(ChT1) = CH_EOF or not readln(ChT1;) then
	Eof1 := true;
    fi;
corp;

proc getLine2()void:
    uint pos;
    char ch;
    bool first;

    pos := Line2[LineNext2];
    first := true;
    while
	if first then
	    if not read(ChT2; ch) then
		first := false;
	    fi;
	    true
	else
	    false
	fi
    do
	if pos = LINEBUFFERSIZE then
	    if LineNext2 = 0 then
		write(ChT2, ": input line too long.\r\n");
		doAbort();
	    fi;
	    Line2[LineNext2 + 1] := pos;
	    if CharsEqual(&LineBuffer1[Line1[0]],
			  &LineBuffer2[Line2[0]]) then
		flushBoth();
	    else
		flush1();
		flush2();
	    fi;
	fi;
	LineBuffer2[pos] := ch;
	pos := pos + 1;
    od;
    if pos ~= Line2[LineNext2] then
	LineBuffer2[pos - 1] := '\e';
	Line2[LineNext2 + 1] := pos;
	LineNext2 := LineNext2 + 1;
    fi;
    if ioerror(ChT2) = CH_EOF or not readln(ChT2;) then
	Eof2 := true;
    fi;
corp;

proc visualTextCompare()void:
    uint i, j;

    CRT_ClearScreen();
    Eof1 := false;
    Eof2 := false;
    LineNext1 := 0;
    LineNext2 := 0;
    Line1[0] := 0;
    Line2[0] := 0;
    LineNumber1 := 1;
    LineNumber2 := 1;
    while
	if LineNext1 = 0 then
	    getLine1();
	fi;
	if LineNext2 = 0 then
	    getLine2();
	fi;
	not Eof1 or not Eof2
    do
	if CharsEqual(&LineBuffer1[Line1[0]],
		      &LineBuffer2[Line2[0]]) then
	    flushBoth();
	else
	    i := 1;
	    while
		if Eof1 and Eof2 then
		    false
		else
		    if i = LineNext1 and not Eof1 then
			getLine1();
		    fi;
		    if i = LineNext2 and not Eof2 then
			getLine2();
		    fi;
		    i ~= SCANRANGE and (not Eof1 or not Eof2) and
			if Eof2 then
			    true
			else
			    j := 0;
			    while j <= i and
				not CharsEqual(&LineBuffer1[Line1[j]],
					       &LineBuffer2[Line2[i]])
			    do
				j := j + 1;
			    od;
			    j > i
			fi and
			if Eof1 then
			    true
			else
			    j := 0;
			    while j <= i and
				not CharsEqual(&LineBuffer1[Line1[i]],
					       &LineBuffer2[Line2[j]])
			    do
				j := j + 1;
			    od;
			    j > i
			fi

		    fi
	    do
		i := i + 1;
	    od;
	    if Eof1 and Eof2 then
	    elif not Eof2 and CharsEqual(&LineBuffer1[Line1[j]],
					 &LineBuffer2[Line2[i]]) then
		while i ~= 0 do
		    flush2();
		    i := i - 1;
		od;
	    elif not Eof1 and CharsEqual(&LineBuffer1[Line1[i]],
					 &LineBuffer2[Line2[j]]) then
		while i ~= 0 do
		    flush1();
		    i := i - 1;
		od;
	    else
		if not Eof1 then
		    flush1();
		fi;
		if not Eof2 then
		    flush2();
		fi;
	    fi;
	fi;
    od;
    while LineNext1 ~= 0 do
	flush1();
    od;
    while not Eof1 do
	getLine1();
	while LineNext1 ~= 0 do
	    flush1();
	od;
    od;
    while LineNext2 ~= 0 do
	flush2();
    od;
    while not Eof2 do
	getLine2();
	while LineNext2 ~= 0 do
	    flush2();
	od;
    od;
    while LineCount ~= 1 do
	nl();
    od;
corp;

proc visualBinaryCompare()void:
    [BINARYBLOCKCOUNT] byte block1, block2;
    uint pos;
    ushort i;
    byte b1, b2;
    bool different;

    CRT_ClearScreen();
    pos := 0;
    while
	for i from 0 upto BINARYBLOCKCOUNT - 1 do
	    block1[i] := 1;
	    block2[i] := 2;
	od;
	read(ChB1; block1) and read(ChB2; block2)
    do
	write(CRT; pos : x : -4);
	for i from 0 upto BINARYBLOCKCOUNT - 1 do
	    b1 := block1[i];
	    b2 := block2[i];
	    write(CRT; if i = 0 then ':' else ' ' fi);
	    if b1 ~= b2 then
		CRT_EnterHighLight();
	    fi;
	    write(CRT; b1 : x : -2);
	    if b1 ~= b2 then
		CRT_ExitHighLight();
	    fi;
	od;
	write(CRT; '*');
	different := false;
	for i from 0 upto BINARYBLOCKCOUNT - 1 do
	    b1 := block1[i];
	    b2 := block2[i];
	    if b1 ~= b2 then
		if not different then
		    different := true;
		    CRT_EnterHighLight();
		fi;
	    else
		if different then
		    different := false;
		    CRT_ExitHighLight();
		fi;
	    fi;
	    write(CRT;
		if b1 >= 0x20 and b1 <= 0x7f then
		    b1 + '\e'
		else
		    '.'
		fi);
	od;
	if different then
	    CRT_ExitHighLight();
	fi;
	write(CRT; "*|", pos : x : -4);
	for i from 0 upto BINARYBLOCKCOUNT - 1 do
	    b1 := block1[i];
	    b2 := block2[i];
	    write(CRT; if i = 0 then ':' else ' ' fi);
	    if b1 ~= b2 then
		CRT_EnterHighLight();
	    fi;
	    write(CRT; b2 : x : -2);
	    if b1 ~= b2 then
		CRT_ExitHighLight();
	    fi;
	od;
	write(CRT; '*');
	different := false;
	for i from 0 upto BINARYBLOCKCOUNT - 1 do
	    b1 := block1[i];
	    b2 := block2[i];
	    if b1 ~= b2 then
		if not different then
		    different := true;
		    CRT_EnterHighLight();
		fi;
	    else
		if different then
		    different := false;
		    CRT_ExitHighLight();
		fi;
	    fi;
	    write(CRT;
		if b2 >= 0x20 and b2 <= 0x7f then
		    b2 + '\e'
		else
		    '.'
		fi);
	od;
	if different then
	    CRT_ExitHighLight();
	fi;
	write(CRT; '*');
	nl();
	pos := pos + BINARYBLOCKCOUNT;
    od;
    while LineCount ~= 1 do
	nl();
    od;
corp;

proc showChar(char c)void:

    write('\'', if c < ' ' or c > '~' then '.' else c fi, "' (hex ",
	    c - '\e' : x : -2, ')');
corp;

proc textCompare()void:
    char c1, c2;
    uint line, col;
    bool eof1, eof2;

    line := 1;
    col := 1;
    while
	while if read(ChT1; c1) then 1 else 0 fi &
		if read(ChT2; c2) then 1 else 0 fi ~= 0 and c1 = c2 do
	    if c1 = '\t' then
		col := (col + 7) & (-8) + 1;
	    else
		col := col + 1;
	    fi;
	od;
	eof1 := ioerror(ChT1) = CH_EOF;
	eof2 := ioerror(ChT2) = CH_EOF;
	not eof1 and not eof2 and c1 = c2
    do
	readln(ChT1;);
	readln(ChT2;);
	line := line + 1;
	col := 1;
    od;
    if eof1 and eof2 then
	ignore writeln("Files ", ChT1, " and ", ChT2, " are identical.")
    elif eof1 then
	ignore writeln("File ", ChT2, " contains more text than file ", ChT1,'.')
    elif eof2 then
	ignore writeln("File ", ChT1, " contains more text than file ", ChT2,'.')
    else
	write("Line ", line, ", col ", col, ", ", ChT1, " has ");
	showChar(c1);
	write(", but ", ChT2, " has ");
	showChar(c2);
	ignore writeln('.')
    fi;
corp;

proc binaryCompare()void:
    uint pos;
    byte b1, b2;
    bool eof1, eof2;

    pos := 0;
    while if read(ChB1; b1) then 1 else 0 fi &
	    if read(ChB2; b2) then 1 else 0 fi ~= 0 and b1 = b2 do
	pos := pos + 1;
    od;
    eof1 := ioerror(ChB1) = CH_EOF;
    eof2 := ioerror(ChB2) = CH_EOF;
    if eof1 and eof2 then
	ignore writeln("Files ", ChB1, " and ", ChB2, " are identical.")
    elif eof1 then
	ignore writeln("File ", ChB2, " contains more data than file ", ChB1,'.')
    elif eof2 then
	ignore writeln("File ", ChB1, " contains more data than file ", ChB2,'.')
    else
	ignore writeln("At ", pos, " (hex ", pos : x : -4, "), ", ChB1,
		" has hex ", b1 : x : -2, ", but ", ChB2,
		" has hex ", b2 : x : -2, '.')
    fi;
corp;

proc badUsage()void:

    writeln("Use is: cmp [-?tbv] file1 file2");
    exit(1);
corp;

proc instructions()void:

    CRT_Initialize("Cmp V1.0", 23, 77);
    CRT_Chars(
	"\n\n\n"
	"Cmp can compare text and binary files, either visually or using a "
	"quick, non-visual mode. Flags 'b' and 't' select either binary or "
	"text mode (default binary). Flag 'v' selects a visual compare, "
	"quick being the default. Cmp will wait at the end of each "
	"screenful. When waiting, a carriage "
	"return will advance 1 line, any other key will advance 1 screen. "
	"Examples:\n\n"
	"    cmp fyle1.dat fyle2.dat\n"
	"          - compare files as binary, using non-visual compare\n\n"
	"    cmp -vt fyle1.txt fyle2.txt\n"
	"          - compare text files in visual\n\n"
	"    cmp -t fyle1.txt fyle2.txt\n"
	"          - non-visual compare of text files"
    );
    CRT_Terminate();
    exit(1);
corp;

proc main()void:
    *char par;

    par := GetPar();
    TextMode := false;
    Visual := false;
    if par ~= nil and par* = '-' then
	while
	    par := par + 1;
	    par* ~= '\e'
	do
	    case par*
	    incase '?':
		instructions();
	    incase 'v':
	    incase 'V':
		Visual := true;
	    incase 't':
	    incase 'T':
		TextMode := true;
	    incase 'b':
	    incase 'B':
		TextMode := false;
	    default:
		badUsage();
	    esac;
	od;
	par := GetPar();
    fi;
    if par = nil then
	badUsage();
    fi;
    if not
	if TextMode then
	    open(ChT1, File1, par)
	else
	    open(ChB1, File1, par)
	fi
    then
	writeln("Can't open file \"", par, "\".");
	exit(1);
    fi;
    par := GetPar();
    if par = nil then
	badUsage();
    fi;
    if not
	if TextMode then
	    open(ChT2, File2, par)
	else
	    open(ChB2, File2, par)
	fi
    then
	writeln("Can't open file \"", par, "\".");
	if TextMode then
	    close(ChT1);
	else
	    close(ChB1);
	fi;
	exit(1);
    fi;
    if Visual then
	CRT_Initialize("Cmp V1.0", 0, 1);
	open(CRT, CRT_PutChar);
	LinesPerScreen := CRT_NLines();
	LineCount := 1;
	if TextMode then
	    FullLineLength := CRT_NCols();
	    HalfLineLength := (FullLineLength - 1) / 2;
	    Wrappable := HalfLineLength * 2 + 1 = FullLineLength;
	    visualTextCompare();
	else
	    if CRT_NCols() < 78 then
		writeln("Cmp: less than 78 columns - aborting.");
	    else
		visualBinaryCompare();
	    fi;
	fi;
	CRT_Terminate();
    else
	if TextMode then
	    textCompare();
	else
	    binaryCompare();
	fi;
    fi;
    closeBoth();
corp;
