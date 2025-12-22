#draco.g
#externs.g

/* utilities useful during parsing */

/*
 * getPosConst - get a positive constant expression.
 */

proc getPosConst()ulong:
    ulong n;

    pushDescriptor();
    pAssignment();
    n := 0L1;
    if DescTable[0].v_kind ~= VNUMBER then
	if DescTable[0].v_kind ~= VERROR then
	    errorBack(37);
	fi;
    elif isSigned(DescTable[0].v_type) and
	    DescTable[0].v_value.v_long < 0L0 then
	errorBack(38);
    else
	n := DescTable[0].v_value.v_ulong;
    fi;
    popDescriptor();
    n
corp;

/*
 * getConst8 - get an 8-bit unsigned constant expression.
 */

proc getConst8()byte:
    ulong u;

    u := getPosConst();
    if u > 0Lxff then
	errorBack(23);
    fi;
    u
corp;

/*
 * pComma - expect and scan past a separating comma in a declaration
 */

proc pComma(char terminator)void:

    if Token + '\e' ~= ',' and Token + '\e' ~= ';' and
	Token + '\e' ~= terminator
    then
	errorThis(33);
	while Token + '\e' ~= ',' and Token + '\e' ~= terminator and
	    Token ~= TID and Token + '\e' ~= ';' and Token + '\e' ~= '('
	do
	    scan();
	od;
    fi;
    if Token + '\e' = ',' then
	scan();
    fi;
corp;

/*
 * lCurly - skip a token, then want a '{'.
 */

proc lCurly()void:

    scan();
    if Token + '\e' = '{' then
	scan();
    else
	errorThis(34);
	while Token + '\e' ~= ';' and Token + '\e' ~= '}' and Token ~= TID do
	    scan();
	od;
    fi;
corp;

/*
 * rSquare - expect and scan a right square bracket
 */

proc rSquare()void:

    if Token + '\e' = ']' then
	scan();
    else
	warning(35);
    fi;
corp;

/*
 * isStatement - return true if current token can only delimit a statement
 */

proc isStatement()bool:

    Token + '\e' = ';' or Token = TID or Token = TEOF or
	Token >= TIF and Token <= TERROR
corp;

/*
 * isStateEnd - return true if current token can end a statement
 */

proc isStateEnd()bool:

    Token + '\e' = ';' or Token = TEOF or
	Token >= TPROC and Token <= TESAC
corp;

/*
 * isExpression - return true if current token can head an expression
 */

proc isExpression()bool:
    register ushort token;

    token := Token;
    token + '\e' = '-' or token + '\e' = '+' or token + '\e' = '~' or
	token + '\e' = '|' or token + '\e' = '(' or token + '\e' = '&' or
	token >= TNUMBER and token <= TID or
	token >= TNIL and token <= TWRITELN or
	token = TFIX or token = TFLT
corp;

/*
 * findStateOrExpr - skip tokens up to something that can start a statement
 *		     or an expression
 */

proc findStateOrExpr()void:

    while not isStatement() and not isExpression() do
	scan();
    od;
corp;

/*
 * proc voidIt - turn top-of-stack into a void.
 */

proc voidIt()void:

    DescTable[0].v_kind := VVOID;
    DescTable[0].v_type := TYVOID;
corp;

/*
 * checkDo - check for and scan a 'do'.
 */

proc checkDo()void:

    if Token = TDO then
	scan();
    else
	errorThis(64);
	while not isStatement() do
	    scan();
	od;
    fi;
corp;

/*
 * checkOd - chec for and scan an 'od'.
 */

proc checkOd()void:

    if Token = TOD then
	scan();
    else
	errorThis(65);
    fi;
corp;

/*
 * syntaxCheck - issue warning or issue error and find unit start.
 */

proc syntaxCheck(ushort errno)void:

    if isStatement() or isExpression() then
	warning(errno);
    else
	errorThis(errno);
	findStateOrExpr();
    fi;
corp;

/*
 * simpleComma - check for and scan a comma
 */

proc simpleComma()void:

    if Token + '\e' = ',' then
	scan();
    else
	syntaxCheck(69);
    fi;
corp;

/*
 * rightParen - check for and scan a right parenthesis
 */

proc rightParen()void:

    if Token + '\e' = ')' then
	scan();
    else
	errorThis(70);
	findStateOrExpr();
    fi;
corp;

/*
 * leftParen - check for and scan a left parenthesis
 */

proc leftParen()void:

    if Token + '\e' = '(' then
	scan();
    else
	warning(77);
    fi;
corp;

/*
 * checkNumber - check that the value is a numeric one.
 */

proc checkNumber()void:

    if not isNumber(DescTable[0].v_type) then
	if DescTable[0].v_type ~= TYERROR then
	    errorBack(100);
	fi;
	forceData();
    fi;
corp;

/*
 * checkArith - check that the value is an arithmetic one.
 */

proc checkArith()void:

    if not isNumber(DescTable[0].v_type) and DescTable[0].v_type ~= TYFLOAT
    then
	if DescTable[0].v_type ~= TYERROR then
	    errorBack(169);
	fi;
	forceData();
    fi;
corp;

/*
 * reverseChains - reverse the true and false branch chains.
 */

proc reverseChains()void:
    uint chain;

    chain := TrueChain;
    TrueChain := FalseChain;
    FalseChain := chain;
corp;
