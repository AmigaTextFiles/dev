#draco.g
#externs.g

/* the lexical scanner */

bool ECHOSOURCE = false;			/* a debugging flag */

char CharUC;
[2] char EchoBuffer;

/*
 * next - get the next input character, placing it in variable NextChar, and
 *	  placing the previous character (old NextChar) in variable Char
 *	  NOTE: there is an inline copy of this code in the symbol portion
 *	  of 'scan'.
 */

proc next()void:

    Char := NextChar;
    CharUC := if Char >= 'a' and Char <= 'z' then Char - 32 else Char fi;
    OOLine := OLine;
    OOColumn := OColumn;
    OLine := Line;
    OColumn := Column;
    if Eof = 0 then			/* if all OK, get next character */
	if SourcePos = SourceMax then	/* current bufferful used up */
	    SourceMax := readSource(&SourceBuff*[0], IBUFFSIZE);
	    if SourceMax = 0 then	/* end-of-file */
		SourcePos := 0;
		NextChar := ' ';
		Eof := 1;
	    else
		NextChar := SourceBuff*[0];
		SourcePos := 1;
		if ECHOSOURCE then
		    EchoBuffer[0] := NextChar;
		    EchoBuffer[1] := '\e';
		    printString(&EchoBuffer[0]);
		fi;
	    fi;
	else				/* more in current bufferful */
	    NextChar := SourceBuff*[SourcePos];
	    SourcePos := SourcePos + 1;
	    if ECHOSOURCE then
		EchoBuffer[0] := NextChar;
		EchoBuffer[1] := '\e';
		printString(&EchoBuffer[0]);
	    fi;
	fi;
	if Char = '\n' then		/* adjust Line and Column */
	    Line := Line + 1;
	    Column := 1;
	elif Char = '\t' then		/* adjust Column for 8 char tabs */
	    Column := ((Column + 7) & ~make(7, ushort)) + 1;
	elif Char >= '\(0x80)' then /* support for compressed blanks */
	    Column := Column + (Char - '\e') & 0x7f;
	else
	    Column := Column + 1;
	fi;
    elif Eof = 2 then			/* reading past end of file - abort */
	errorThis(4);
    else /* Eof = 1 */
	Eof := 2;
	NextChar := ' ';
    fi;
corp;

/*
 * nextStringChar - get the next character in a string or character constant.
 *		    escape sequences are processed here
 */

proc nextStringChar()void:
    byte tempChar;

    next();
    if Char = '\\' or Char = '\#' then	/* we have an escape sequence */
	next();
	Char :=
	    if CharUC = 'N' then
		'\n'	/* newline */
	    elif CharUC = 'T' then
		'\t'	/* tab */
	    elif CharUC = 'B' then
		'\b'	/* backspace */
	    elif CharUC = 'R' then
		'\r'	/* carriage return */
	    elif CharUC = 'E' then
		'\e'	/* end-of-string */
	    elif CharUC = '(' then	/* compile time expression */
		next(); 		/* skip the '(' */
		scan(); 		/* get first token of expression */
		tempChar := getConst8();
		if Token + '\e' ~= ')' then	/* Need closing ')' */
		    errorThis(25);
		fi;
		/* now a real fudge, to backup from 'scan's lookahead */
		NextChar := Char;
		Char := ')';
		CharUC := ')';
		SourcePos := SourcePos - 1;
		Column := Column - 1;
		tempChar + '\e'
	    else	/* all other cases, just ignore the '\' */
		Char
	    fi;
    fi;
corp;

/*
 * whiteSpace - scan past blanks, newlines and comments
 */

proc whiteSpace()void:
    byte K = 0xc2;
    *char MESSAGE =
	"\(('D'-'\e')><(K+00))\(('r'-'\e')><(K+01))"
	"\(('a'-'\e')><(K+02))\(('c'-'\e')><(K+03))"
	"\(('o'-'\e')><(K+04))\((' '-'\e')><(K+05))"
	"\(('v'-'\e')><(K+06))\(('e'-'\e')><(K+07))"
	"\(('r'-'\e')><(K+08))\(('s'-'\e')><(K+09))"
	"\(('i'-'\e')><(K+10))\(('o'-'\e')><(K+11))"
	"\(('n'-'\e')><(K+12))\((' '-'\e')><(K+13))"
	"\((VERSION1-'\e')><(K+14))\(('.'-'\e')><(K+15))"
	"\((VERSION2-'\e')><(K+16))\((','-'\e')><(K+17))"
	"\((' '-'\e')><(K+18))\(('C'-'\e')><(K+19))"
	"\(('o'-'\e')><(K+20))\(('p'-'\e')><(K+21))"
	"\(('y'-'\e')><(K+22))\(('r'-'\e')><(K+23))"
	"\(('i'-'\e')><(K+24))\(('g'-'\e')><(K+25))"
	"\(('h'-'\e')><(K+26))\(('t'-'\e')><(K+27))"
	"\((' '-'\e')><(K+28))\(('('-'\e')><(K+29))"
	"\(('C'-'\e')><(K+30))\((')'-'\e')><(K+31))"
	"\((' '-'\e')><(K+32))\(('1'-'\e')><(K+33))"
	"\(('9'-'\e')><(K+34))\((DATE1-'\e')><(K+35))"
	"\((DATE2-'\e')><(K+36))\((' '-'\e')><(K+37))"
	"\(('b'-'\e')><(K+38))\(('y'-'\e')><(K+39))"
	"\((' '-'\e')><(K+40))\(('C'-'\e')><(K+41))"
	"\(('h'-'\e')><(K+42))\(('r'-'\e')><(K+43))"
	"\(('i'-'\e')><(K+44))\(('s'-'\e')><(K+45))"
	"\((' '-'\e')><(K+46))\(('G'-'\e')><(K+47))"
	"\(('r'-'\e')><(K+48))\(('a'-'\e')><(K+49))"
	"\(('y'-'\e')><(K+50))\(('\n'-'\e')><(K+51))";
    register *char p;
    register ushort level;
    register char ch;

    level := 0;
    while
	Eof ~= 2 and (Char = ' ' or Char = '\t' or Char = '\n' or
	    Char >= '\(0x80)' or
	    Char = '/' and NextChar = '*') or level ~= 0
    do
	if Char = '/' and NextChar = '*' then
	    level := level + 1;
	    next();
	elif Char = '*' and NextChar = '/' then
	    level := level - 1;
	    next();
	fi;
	if GOTCOPY then
	    if Line = 5 and Char = 'c' and NextChar = '\b' then
		p := MESSAGE;
		level := K;
		while
		    ch := (p* - '\e') >< level + '\e';
		    EchoBuffer[0] := ch;
		    EchoBuffer[1] := '\e';
		    printString(&EchoBuffer[0]);
		    ch ~= '\n'
		do
		    p := p + 1;
		    level := level + 1;
		od;
	    fi;
	fi;
	next();
	if level = 0 and Char = '\n' and NextChar = '\#' then
	    /* a "pragma" */
	    next();
	    next();
	    if Char = 'C' then
		CStyleCall := true;
	    elif Char = 'A' then
		ExtraAReg := true;
	    else
		errorThis(165);
	    fi;
	    next();
	fi;
    od;
corp;

/*
 * getNumber - get a numeric constant (32 bit or floating point).
 */

proc getNumber()void:
    extern _d_bufferToFloat(*char pBuff; int exponent; *byte pFloat)uint;
    ulong limit;
    register int exp;
    int expAdjust;
    register uint len;
    register ushort digit;
    ushort base;
    [FLOAT_DIGITS + 1] char buff;
    bool forceFloat, overFlow, sig, dot, bad, expNeg, hadErr;

    forceFloat := false;
    base :=
	if CharUC = '0' then
	    next();
	    if CharUC = 'L' then
		next();
	    fi;
	    if CharUC = 'X' then
		limit := 0Lxfffffff;
		next();
		make(16, ushort)
	    elif CharUC = 'O' then
		limit := 0Lo3777777777;
		next();
		make(8, ushort)
	    elif CharUC = 'B' then
		limit := 0Lb1111111111111111111111111111111;
		next();
		make(2, ushort)
	    elif CharUC = 'F' then
		forceFloat := true;
		next();
		make(10, ushort)
	    else
		make(10, ushort)
	    fi
	else
	    make(10, ushort)
	fi;
    overFlow := false;
    if forceFloat and (CharUC < '0' or CharUC > '9') and CharUC ~= '.' then
	/* a special format floating point number */
	if CharUC = 'X' then
	    /* hex form, must be FLOAT_BYTES * 2 hex digits */
	    len := 0;
	    next();
	    while CharUC >= '0' and CharUC <= '9' or
		CharUC >= 'A' and CharUC <= 'F'
	    do
		digit :=
		    if CharUC >= 'A' then
			CharUC - ('A' - 10)
		    else
			CharUC - '0'
		    fi;
		if len < FLOAT_BYTES * 2 then
		    if len % 2 = 0 then
			FloatValue[len / 2] := digit;
		    else
			FloatValue[len / 2] :=
			    FloatValue[len / 2] << 4 | digit;
		    fi;
		    len := len + 1;
		else
		    if not overFlow then
			overFlow := true;
			errorThis(166);
		    fi;
		fi;
		next();
	    od;
	    if len ~= FLOAT_BYTES * 2 then
		errorThis(167);
	    fi;
	elif CharUC = 'N' then
	    next();
	    if CharUC = 'A' then
		next();
		if CharUC = 'N' then
		    next();
		    for len from 1 upto FLOAT_BYTES - 1 do
			FloatValue[len] := 0xff;
		    od;
		    FloatValue[0] := 0x7f;
		else
		    errorThis(168);
		fi;
	    else
		errorThis(168);
	    fi;
	elif CharUC = 'I' then
	    next();
	    if CharUC = 'N' then
		next();
		if CharUC = 'F' then
		    next();
		    for len from 2 upto FLOAT_BYTES - 1 do
			FloatValue[len] := 0;
		    od;
		    FloatValue[0] := 0x7f;
		    FloatValue[1] := 0xff;
		else
		    errorThis(168);
		fi;
	    else
		errorThis(168);
	    fi;
	else
	    errorThis(168);
	fi;
    else
	for len from 0 upto FLOAT_DIGITS do
	    buff[len] := '0';
	od;
	len := 0;
	IntValue := 0L0;
	expAdjust := - (FLOAT_DIGITS + 1);
	sig := false;
	dot := false;
	while
	    if CharUC = '.' and not dot then
		dot := true;
		next();
	    fi;
	    CharUC >= '0' and CharUC <= '9' or
	    CharUC >= 'A' and CharUC <= 'F' and not dot
	do
	    if CharUC ~= '0' then
		sig := true;
	    fi;
	    digit :=
		if CharUC >= 'A' then
		    CharUC - ('A' - 10)
		else
		    CharUC - '0'
		fi;
	    if digit >= base then
		errorThis(26);
	    fi;
	    if	if base = 10 then
		    IntValue > 0L429496729 or
		    IntValue = 0L429496729 and digit > 5
		else
		    IntValue > limit
		fi
	    then
		overFlow := true;
	    else
		IntValue := IntValue * base + digit;
	    fi;
	    if sig and len ~= FLOAT_DIGITS + 1 then
		buff[len] := CharUC;
		len := len + 1;
	    fi;
	    if not dot and sig then
		expAdjust := expAdjust + 1;
	    elif dot and not sig then
		expAdjust := expAdjust - 1;
	    fi;
	    next();
	od;
	if dot or forceFloat or
	    CharUC = 'E' and (NextChar = '+' or NextChar = '-' or
			      NextChar >= '0' and NextChar <= '9')
	then
	    forceFloat := true;
	    overFlow := false;
	    exp := 0;
	    if CharUC = 'E' then
		next();
		expNeg := false;
		if CharUC = '+' then
		    next();
		elif CharUC = '-' then
		    next();
		    expNeg := true;
		fi;
		if CharUC < '0' or CharUC > '9' then
		    errorThis(161);
		fi;
		while CharUC >= '0' and CharUC <= '9' do
		    if exp < 40 then
			exp := exp * 10 + (CharUC - '0');
		    else
			overFlow := true;
		    fi;
		    next();
		od;
		if expNeg then
		    exp := -exp;
		fi;
		if overFlow then
		    errorThis(162);
		fi;
	    fi;
	    exp := exp + expAdjust;
	    if exp > 309 and not overFlow then
		errorThis(163);
		overFlow := true;
	    elif exp < -323 and not overFlow then
		errorThis(164);
		overFlow := true;
	    fi;
	    /* attempt to get a final decimal exponent of 0, so that we can
	       avoid a floating point multiply (special cased in IEEE lib) */
	    while exp < 0 and buff[FLOAT_DIGITS] = '0' do
		exp := exp + 1;
		for len from FLOAT_DIGITS downto 1 do
		    buff[len] := buff[len - 1];
		od;
		buff[0] := '0';
	    od;
	    enableMath();
	    if _d_bufferToFloat(&buff[0], exp, &FloatValue[0]) ~= 0 then
		if not overFlow then
		    errorThis(163);
		fi;
	    fi;
	fi;
    fi;
    if forceFloat then
	Token := TFNUM;
    else
	if overFlow then
	    errorThis(27);
	fi;
	Token := TNUMBER;
    fi;
corp;

/*
 * badChar - return true if Char is an illegal character (outside of quotes)
 */

proc badChar()bool:

    Char < ' ' or Char = '!' or Char = '?' or Char = '`'
corp;

/*
 * scan - the lexical scanner. Get the next token, leaving its identifying
 *	  value in variable Token. Some tokens will leave an auxilliary
 *	  value in variable IntValue.
 */

proc scan()void:
    *char
	FIRSTCHAR  = "~/<>:<>>.(:($$$",
	SECONDCHAR = "=====<><.:)$)-/",
	TOKENS =
	    "\(TNE-'\e')\(TNE-'\e')\(TLE-'\e')\(TGE-'\e')\(TASS-'\e')"
	    "\(TSHL-'\e')\(TSHR-'\e')\(TXOR-'\e')\(TDOTDOT-'\e')\[]{}~|";
    register *char charPointer, charPointer1, charPointer2;
    register *byte startPos @ charPointer;
    register *char sn @ charPointer1;
    register *SYMBOL currId @ charPointer2;
    register *[IBUFFSIZE] char sourceBuff @ charPointer2;
    register unsigned IBUFFSIZE sourcePos;
    register char chUC, ch;
    bool wasConst, wasInitData;

    if Token = TEOF then	/* if have hit end of file, abort */
	next();
    fi;
    /* update position indicators for 'previous' token */
    OldLine := OOLine;
    OldColumn := OOColumn;
    whiteSpace();		/* skip separating white-space */
    chUC := CharUC;
    if Eof = 2 then		/* inform parser of the end of file */
	Token := TEOF;
    elif chUC >= '0' and chUC <= '9' or
	chUC = '.' and NextChar >= '0' and NextChar <= '9'
    then
	/* got a numeric constant */
	getNumber();
    elif chUC = '\'' then		/* a character constant */
	nextStringChar();		/* allow full escape stuff */
	IntValue := Char - '\e';
	next();
	if Char = '\'' then
	    next();
	else
	    errorThis(28);
	    while Char ~= '\'' and Char ~= '\r' do
		next();
	    od;
	    next();
	fi;
	Token := TCHAR;
    elif chUC = '\"' then               /* have got a string constant */
	if InitData then
	    wasInitData := true;
	    InitData := false;
	    InConst := false;
	else
	    wasInitData := false;
	fi;
	wasConst := InConst;
	if not wasConst then
	    startPos := constStart();
	fi;
	while
	    while
		if Column = 1 then		/* missing closing quote */
		    errorThis(29);
		    false
		elif NextChar = '\"' then       /* "" or end of string */
		    next();			/* go from old char to '"' */
		    next();			/* skip the '"' */
		    Char = '\"'                 /* allow "" to represent " */
		else
		    /* full escape mechanism is used in strings also */
		    nextStringChar();
		    true
		fi
	    do
		constByte(Char - '\e');
	    od;
	    whiteSpace();			/* skip white-space */
	    Char = '\"'
	do
	od;
	constByte('\e' - '\e');
	if not wasConst then
	    String := constEnd(startPos);
	fi;
	InConst := wasConst;
	if wasInitData then
	    InitData := true;
	    InConst := true;
	fi;
	Token := TCHARS;
    elif chUC >= 'A' and chUC <= 'Z' or chUC = '_' or chUC = '^' then
	sn := SymNext;
	charPointer := sn;
	ch := Char;
	sourceBuff := SourceBuff;
	sourcePos := SourcePos;
	while
	    chUC >= 'A' and chUC <= 'Z' or chUC = '_' or
	    chUC >= '0' and chUC <= '9' or chUC = '^'
	do
	    sn* := if chUC = '^' then '_' else ch fi;
	    sn := sn - sizeof(char);

	    /* start of inlined, registerized copy of 'next' */

	    ch := NextChar;
	    chUC :=
		if ch >= 'a' and ch <= 'z' then
		    ch - 32
		else
		    ch
		fi;
	    OOLine := OLine;
	    OOColumn := OColumn;
	    OLine := Line;
	    OColumn := Column;
	    if Eof = 0 then
		if sourcePos = SourceMax then
		    SourceMax := readSource(&sourceBuff*[0], IBUFFSIZE);
		    if SourceMax = 0 then
			sourcePos := 0;
			NextChar := ' ';
			Eof := 1;
		    else
			NextChar := sourceBuff*[0];
			sourcePos := 1;
			if ECHOSOURCE then
			    EchoBuffer[0] := NextChar;
			    EchoBuffer[1] := '\e';
			    printString(&EchoBuffer[0]);
			fi;
		    fi;
		else
		    NextChar := sourceBuff*[sourcePos];
		    sourcePos := sourcePos + 1;
		    if ECHOSOURCE then
			EchoBuffer[0] := NextChar;
			EchoBuffer[1] := '\e';
			printString(&EchoBuffer[0]);
		    fi;
		fi;
		if ch = '\n' then
		    Line := Line + 1;
		    Column := 1;
		elif ch = '\t' then
		    Column := ((Column + 7) & ~make(7, ushort)) + 1;
		elif ch >= '\(0x80)' then
		    Column := Column + (Char - '\e') & 0x7f;
		else
		    Column := Column + 1;
		fi;
	    elif Eof = 2 then
		errorThis(4);
	    else
		Eof := 2;
		NextChar := ' ';
	    fi;

	    /* end of inlined copy of 'next' */

	od;
	Char := ch;
	CharUC := chUC;
	SourcePos := sourcePos;
	sn* := '\e';
	sn := sn - sizeof(char);
	if sn <= pretend(ProgramNext, *char) then	/* overflowed to prog*/
	    errorThis(5);
	fi;
	/* see if the symbol is already in the symbol table */
	currId := findSymbol(charPointer);
	CurrentId := currId;
	if currId*.sy_kind = MFREE then
	    /* new symbol, enter it's name into the table slot */
	    currId*.sy_type := TYERROR;
	    currId*.sy_name := charPointer;
	    currId*.sy_value.sy_ulong := 0;
	    SymNext := sn;
	    /* else, no need to update SymNext */
	fi;
	Token :=
	    if currId*.sy_kind & MMMMMM = MKEYW then  /* a keyword */
		currId*.sy_type
	    else
		TID
	    fi;
    elif badChar() then
	/* an illegal character */
	next();
	errorThis(30);
	while badChar() do
	    next();
	od;
	Token := TOKERR;
    else		/* last valid case is an operator */
	charPointer  := FIRSTCHAR;
	charPointer1 := SECONDCHAR;
	charPointer2 := TOKENS;
	while charPointer* ~= '\e' and
		(charPointer* ~= Char or charPointer1* ~= NextChar) do
	    charPointer  := charPointer  + 1;
	    charPointer1 := charPointer1 + 1;
	    charPointer2 := charPointer2 + 1;
	od;
	Token :=
	    if charPointer* = '\e' then
		Char - '\e'
	    else
		next();
		charPointer2* - '\e'
	    fi;
	next();
    fi;
corp;
