#draco.g
#externs.g

/* parse and code-gen for I/O constructs */

/*
 * pOpen - parse and generate code for the 'open' construct.
 */

proc pOpen()void:
    *char
	SOPEN1 = "\e1nepos_d_", SOPEN3 = "\e3nepos_d_",
	FOPEN1 = "\e1nepof_d_", FOPEN2 = "\e2nepof_d_",
	FOPEN3 = "\e3nepof_d_", FOPEN4 = "\e4nepof_d_",
	POPEN1 = "\e1nepop_d_", POPEN2 = "\e2nepop_d_",
	POPEN3 = "\e3nepop_d_", POPEN4 = "\e4nepop_d_",
	COPEN1 = "\e1nepoc_d_", COPEN3 = "\e3nepoc_d_";
    register *DESCRIPTOR d0;
    register *PROCDESC pd;
    register *TTENTRY tPtr;
    *ushort regStackPos;
    TYPEKIND kind;
    ushort reg;
    bool isInput, isText, unKnownType, bad, pushedA1;

    d0 := &DescTable[0];
    scan();
    leftParen();
    pushedA1 := A1Busy();
    if pushedA1 then
	opMove(OP_MOVEL, M_ADIR << 3 | 1, M_DEC << 3 | RSP);
    fi;
    reg := getAReg();
    freeAReg();
    regStackPos := NextRegStack;
    pAssignment();
    putAddrInReg();
    fixTo(regStackPos);
    opMove(OP_MOVEL, M_ADIR << 3 | d0*.v_value.v_reg,
	    M_DEC << 3 | RSP);
    freeAReg();
    tPtr := basePtr(d0*.v_type);
    unKnownType :=
	if tPtr*.t_kind ~= TY_CHANNEL then
	    if d0*.v_type ~= TYERROR then
		errorBack(126);
	    fi;
	    true
	else
	    isInput := tPtr*.t_info.i_channel.i_input;
	    isText := tPtr*.t_info.i_channel.i_text;
	    false
	fi;
    if Token + '\e' = ')' then
	if not isText and not unKnownType then
	    errorThis(127);
	fi;
	genCall(if isInput then SOPEN1 else SOPEN3 fi);
    else
	simpleComma();
	pAssignment();
	fixTo(regStackPos);
	tPtr := basePtr(d0*.v_type);
	pd := tPtr*.t_info.i_proc;
	kind := tPtr*.t_kind;
	if kind = TY_FILE then
	    putAddrInReg();
	    opMove(OP_MOVEL, M_ADIR << 3 | d0*.v_value.v_reg,
		    M_DEC << 3 | RSP);
	    freeAReg();
	    simpleComma();
	    pAssignment();
	    fixTo(regStackPos);
	    if d0*.v_type = TYCHARS then
		putInReg();
	    else
		if d0*.v_type ~= TYERROR then
		    errorBack(128);
		fi;
		putAddrInReg();
	    fi;
	    opMove(OP_MOVEL, M_ADIR << 3 | d0*.v_value.v_reg,
		   M_DEC << 3 | RSP);
	    freeAReg();
	    opMove(OP_MOVEL, M_SPECIAL << 3 | M_IMM, M_DEC << 3 | RSP);
	    sourceLong(tPtr*.t_info.i_ulong);
	    genCall(if isInput then
			if isText then FOPEN1 else FOPEN2 fi
		    else
			if isText then FOPEN3 else FOPEN4 fi
		    fi);
	elif kind = TY_PROC then
	    putInReg();
	    opMove(OP_MOVEL, M_ADIR << 3 | d0*.v_value.v_reg,
		    M_DEC << 3 | RSP);
	    freeAReg();
	    bad := false;
	    genCall(
		if isInput then
		    if pd*.p_parCount ~= 0 then
			bad := true;
		    fi;
		    if isText then
			if pd*.p_resultType ~= TYCHAR then
			    bad := true;
			fi;
			POPEN1
		    else
			if pd*.p_resultType ~= TYBYTE then
			    bad := true;
			fi;
			POPEN2
		    fi
		else
		    if pd*.p_parCount ~= 1 or
			    pd*.p_resultType ~= TYVOID then
			bad := true;
		    fi;
		    if isText then
			if pd*.p_parTypes[0] ~= TYCHAR then
			    bad := true
			fi;
			POPEN3
		    else
			if pd*.p_parTypes[0] ~= TYBYTE then
			    bad := true
			fi;
			POPEN4
		    fi
		fi);
	    if bad and not unKnownType then
		errorBack(129);
	    fi;
	elif d0*.v_type = TYCHARS then
	    putInReg();
	    opMove(OP_MOVEL, M_ADIR << 3 | d0*.v_value.v_reg,
		    M_DEC << 3 | RSP);
	    freeAReg();
	    if isText then
		genCall(if isInput then COPEN1 else COPEN3 fi);
	    else
		if not unKnownType then
		    errorBack(130);
		fi;
	    fi;
	else
	    if d0*.v_type ~= TYERROR then
		errorBack(131);
	    fi;
	    while
		pComma(')');
		isExpression()
	    do
		pAssignment();
	    od;
	fi;
    fi;
    rightParen();
    peepFlush();
    if pushedA1 then
	opMove(OP_MOVEL, M_INC << 3 | RSP, M_ADIR << 3 | 1);
    fi;
    d0*.v_kind := VREG;
    d0*.v_value.v_reg := 0;
    d0*.v_type := TYIORESULT;
corp;

/*
 * pCloseIOError - parse and generate code for the 'close' and
 *		       'IOerror' constructs.
 */

proc pCloseIOError()void:
    register *DESCRIPTOR d0;
    bool isClose, pushedA1;

    d0 := &DescTable[0];
    isClose := Token = TCLOSE;
    scan();
    leftParen();
    pushedA1 := A1Busy();
    if pushedA1 then
	opMove(OP_MOVEL, M_ADIR << 3 | 1, M_DEC << 3 | RSP);
    fi;
    genCall(
	if not isClose and Token + '\e' = ')' then
	    "\erorreOIdts_d_"
	else
	    pAssignment();
	    putAddrInReg();
	    opMove(OP_MOVEL, M_ADIR << 3 | d0*.v_value.v_reg,
		    M_DEC << 3 | RSP);
	    freeAReg();
	    if baseKind(d0*.v_type) ~= TY_CHANNEL then
		errorBack(132);
	    fi;
	    if isClose then
		"\eesolc_d_"
	    else
		"\erorreOI_d_"
	    fi
	fi);
    rightParen();
    peepFlush();
    if pushedA1 then
	opMove(OP_MOVEL, M_INC << 3 | RSP, M_ADIR << 3 | 1);
    fi;
    d0*.v_kind := VREG;
    if isClose then
	d0*.v_value.v_reg := 0;
	d0*.v_type := TYIORESULT;
    else
	d0*.v_value.v_reg := getDReg();
	d0*.v_type := TYUSHORT;
	opMove(OP_MOVEB, M_DDIR << 3 | 0,
	       M_DDIR << 3 | d0*.v_value.v_reg);
    fi;
corp;

/*
 * getLen - used by pReadWrite to get a format size.
 */

proc getLen()void:

    pAssignment();
    if not isNumber(DescTable[0].v_type) then
	errorBack(137);
    fi;
    if DescTable[0].v_kind = VNUMBER then
	opMove(OP_MOVEW, M_SPECIAL << 3 | M_IMM, M_DEC << 3 | RSP);
	sourceWord(DescTable[0].v_value.v_ulong);
    else
	fixSizeReg(TYINT);
	opMove(OP_MOVEW, M_DDIR << 3 | DescTable[0].v_value.v_reg,
		M_DEC << 3 | RSP);
	freeDReg();
    fi;
corp;

/*
 * wrCall - generate a call for text formatted output.
 */

proc wrCall(bool freeFormat; char format)void:
    *char
	FLT = "_d_XXX\e\e_d_fltf",
	LNG = "_d_lng\e\e_d_lngf",
	BYTE = "_d_byte\e_d_bytef",
	WORD = "_d_word\e_d_wordf",
	IPUT = "iput", UPUT = "uput", XPUT = "xput", OPUT = "oput",
	    BPUT = "bput", FPUT = "fput", EPUT = "eput", GPUT = "gput";
    byte size;

    if DescTable[0].v_type = TYCHAR then
	genCall("\etuprahc_d_");
    else
	genCall2(
	    if DescTable[0].v_type = TYFLOAT then
		FLT
	    else
		size := getSize(DescTable[0].v_type);
		if size = S_LONG or size = S_LADDR then
		    LNG
		elif size = S_WORD then
		    WORD
		else
		    BYTE
		fi
	    fi + if freeFormat then 0 else 8 fi,
	    case format
	    incase 'I':
		IPUT
	    incase 'U':
		UPUT
	    incase 'X':
		XPUT
	    incase 'O':
		OPUT
	    incase 'B':
		BPUT
	    incase 'F':
		FPUT
	    incase 'E':
		EPUT
	    incase 'G':
		GPUT
	    esac);
    fi;
corp;

/*
 * rCall - generate a call for text formatted input.
 */

proc rCall(char format; byte size)void:
    *char
	FLT = "_d_flt", LNG = "_d_lng",
	BYTE = "_d_byte", WORD = "_d_word",
	IGET = "iget", UGET = "uget", XGET = "xget", OGET = "oget",
	    BGET = "bget", GET = "get";

    if DescTable[0].v_type = TYCHAR then
	genCall("\etegrahc_d_");
    else
	genCall2(
	    if DescTable[0].v_type = TYFLOAT then
		FLT
	    elif size = S_LONG then
		LNG
	    elif size = S_WORD then
		WORD
	    else
		BYTE
	    fi,
	    case format
	    incase 'I':
		IGET
	    incase 'U':
		UGET
	    incase 'X':
		XGET
	    incase 'O':
		OGET
	    incase 'B':
		BGET
	    default:
		GET
	    esac
	);
    fi;
corp;

/*
 * pReadWrite - parse and generate code for the 'read', 'write',
 *		    'readln' and 'writeln' constructs.
 */

proc pReadWrite()void:
    *char
	SETSTDIN = "\enidtstes_d_", SETSTDOUT = "\etuodtstes_d_",
	CHARSGET = "\etegsrahc_d_", CHARSPUT = "\etupsrahc_d_",
	CHARAGET = "\etegarahc_d_", CHARAPUT = "\etuparahc_d_",
	GET = "\eteg_d_", PUT = "\etup_d_",
	READLN = "\enldaer_d_", WRITELN = "\enletirw_d_";
    register *DESCRIPTOR d0;
    register *TTENTRY tPtr;
    *char startPos;
    *ushort regStackPos;
    *ARRAYDESC ad;
    ulong SOSave;
    uint moveOp;
    ushort reg;
    register char format;
    byte size;
    register bool isRead, isText;
    bool isLine, unKnownType, noChannel, first, freeFormat,
	 tNumber, tFloat, pushedA1, tAddress;

    d0 := &DescTable[0];
    isRead := Token = TREAD or Token = TREADLN;
    isLine := Token = TREADLN or Token = TWRITELN;
    scan();
    leftParen();
    pushedA1 := A1Busy();
    if pushedA1 then
	opMove(OP_MOVEL, M_ADIR << 3 | 1, M_DEC << 3 | RSP);
    fi;
    unKnownType := false;
    noChannel := false;
    isText := true;
    first := true;
    if Token + '\e' = '*' then
	noChannel := true;
	first := false;
	scan();
	if Token + '\e' = ';' then
	    scan();
	fi;
    fi;
    reg := getDReg();
    freeDReg();
    reg := getAReg();
    freeAReg();
    regStackPos := NextRegStack;
    while isExpression() do
	pAssignment();
	fixTo(regStackPos);
	tPtr := basePtr(d0*.v_type);
	if Token + '\e' = ';' and first then
	    /* we have a channel to do the I/O on */
	    putAddrInReg();
	    opMove(OP_MOVEL, M_ADIR << 3 | d0*.v_value.v_reg,
		    M_DEC << 3 | RSP);
	    freeAReg();
	    if tPtr*.t_kind ~= TY_CHANNEL then
		unKnownType := true;
		if d0*.v_type ~= TYERROR then
		    errorBack(133);
		fi;
	    else
		isText := tPtr*.t_info.i_channel.i_text;
		if not isText and isLine or
			tPtr*.t_info.i_channel.i_input ~= isRead then
		    errorBack(134);
		fi;
	    fi;
	    genCall("\elennahctes_d_");
	else
	    ad := tPtr*.t_info.i_array;
	    if isRead and (d0*.v_kind <= VCONST or d0*.v_kind >= VREG) and
		    d0*.v_kind ~= VINDIR and
		    (d0*.v_kind ~= VREG or d0*.v_type ~= TYCHARS) or
		d0*.v_kind = VRVAR and not isText
	    then
		if d0*.v_type ~= TYERROR then
		    if d0*.v_kind = VRVAR and not isText then
			errorBack(174);
		    else
			errorBack(108);
		    fi;
		fi;
		d0*.v_kind := VINDIR;
		d0*.v_index := NOINDEX;
		d0*.v_value.v_indir.v_base := getAReg();
		d0*.v_value.v_indir.v_offset := 0L0;
	    fi;
	    freeFormat := true;
	    format :=
		if d0*.v_type = TYFLOAT then
		    freeFormat := false;
		    'G'
		elif isAddress(d0*.v_type) then
		    'X'
		else
		    if isSigned(d0*.v_type) then
			'I'
		    else
			'U'
		    fi
		fi;
	    size := getSize(d0*.v_type);
	    moveOp :=
		if size = S_BYTE then
		    OP_MOVEB
		elif size = S_WORD then
		    OP_MOVEW
		else
		    OP_MOVEL
		fi;
	    tFloat := d0*.v_type = TYFLOAT;
	    tNumber := tFloat or isNumber(d0*.v_type);
	    tAddress := isAddress(d0*.v_type);
	    if tFloat and isText then
		if isRead then
		    putAddrInReg();
		    opMove(OP_MOVEL, M_ADIR << 3 | d0*.v_value.v_reg,
			   M_DEC << 3 | RSP);
		    freeAReg();
		else
		    putInReg();
		    if d0*.v_kind ~= VREG then
			floatRef(OP_RESTM, 0, d0);
		    fi;
		    opSpecial(OP_SAVEM | M_DEC << 3 | RSP);
		    sourceWord(0xc000);
		fi;
	    elif (d0*.v_type = TYCHAR or isNumber(d0*.v_type)) and isText or
		tAddress and isText and not isRead
	    then
		if not isRead then
		    if d0*.v_kind = VNUMBER and
			(size = S_BYTE or size = S_WORD)
		    then
			/* avoid the MOVEQ, MOVE syndrome */
			opMove(moveOp, M_SPECIAL << 3 | M_IMM,
			       M_DEC << 3 | RSP);
			sourceWord(d0*.v_value.v_ulong);
		    else
			putInReg();
			if tAddress then
			    opMove(OP_MOVEL, M_ADIR << 3 | d0*.v_value.v_reg,
				   M_DEC << 3 | RSP);
			    freeAReg();
			else
			    opMove(moveOp, M_DDIR << 3 | d0*.v_value.v_reg,
				   M_DEC << 3 | RSP);
			    freeDReg();
			fi;
		    fi;
		fi;
		/* no action needed for read - result is returned */
	    elif baseKind1(d0*.v_type) = TY_OP and isText and not isRead then
		putInReg();
	    else
		if not isText or isRead and d0*.v_type ~= TYCHARS or
		    not isSimple(d0*.v_type)
		then
		    putAddrInReg();
		else
		    putInReg();
		fi;
		opMove(OP_MOVEL,
			M_ADIR << 3 | d0*.v_value.v_reg,
			M_DEC << 3 | RSP);
		freeAReg();
	    fi;
	    if first then
		/* default to standard I/O */
		genCall(if isRead then SETSTDIN else SETSTDOUT fi);
	    fi;
	    if Token + '\e' = ':' then
		if not isText then
		    errorThis(134);
		fi;
		if not tNumber and not tAddress or d0*.v_type = TYCHARS then
		    errorThis(135);
		fi;
		startPos := SymNext;
		scan();
		if  if Token = TID and (startPos - 1)* = '\e' then
			format := startPos*;
			if format >= 'a' and format <= 'z' then
			    format := format - 32;
			fi;
			if tFloat and format ~= 'E' and format ~= 'F' and
				format ~= 'G' or
			    d0*.v_type ~= TYFLOAT and
				format ~= 'I' and format ~= 'U' and
				format ~= 'X' and format ~= 'O' and
				format ~= 'B'
			then
			    errorThis(136);
			    format := if tFloat then 'E' else 'I' fi;
			fi;
			SymNext := startPos;
			scan();
			if Token + '\e' = ':' then
			    scan();
			    true
			else
			    false
			fi
		    else
			true
		    fi and not isRead
		then
		    pushDescriptor();
		    getLen();
		    fixTo(regStackPos);
		    if tFloat then
			if Token + '\e' = ':' then
			    scan();
			    getLen();
			    fixTo(regStackPos);
			else
			    opSingle(OP_CLR, S_WORD, M_DEC << 3 | RSP);
			fi;
		    fi;
		    popDescriptor();
		    freeFormat := false;
		elif tFloat and not isRead then
		    opSingle(OP_CLR, S_LONG, M_DEC << 3 | RSP); /* 2 ints */
		fi;
	    elif tFloat and not isRead then
		opSingle(OP_CLR, S_LONG, M_DEC << 3 | RSP);	/* 2 ints */
	    fi;
	    if isText then
		if tNumber or d0*.v_type = TYCHAR then
		    if isRead then
			rCall(format, size);
			if not tFloat then
			    opTail(OPT_STORE, moveOp, M_DDIR, 0, false, false);
			fi;
		    else
			wrCall(freeFormat, format);
		    fi;
		elif d0*.v_type = TYCHARS then
		    genCall(if isRead then CHARSGET else CHARSPUT fi);
		elif tPtr*.t_kind = TY_ARRAY and
			ad*.ar_baseType = TYCHAR and
			ad*.ar_dimCount = 1 then
		    getDim(&ad*.ar_dims[0], M_DEC, RSP);
		    genCall(if isRead then CHARAGET else CHARAPUT fi);
		elif tPtr*.t_kind = TY_CHANNEL and not isRead then
		    genCall("\etuplennahc_d_");
		elif not isRead and tAddress then
		    wrCall(freeFormat, format);
		elif isOp() then
		    if isRead then
			checkOp(OPGET);
			genOpCall("pop");
		    else
			checkOp(OPPUT);
		    fi;
		else
		    if d0*.v_type ~= TYERROR then
			errorBack(138);
		    fi;
		fi;
	    else
		opMove(OP_MOVEL, M_SPECIAL << 3 | M_IMM, M_DEC << 3 | RSP);
		sourceLong(typeSize(d0*.v_type));
		genCall(if isRead then GET else PUT fi);
	    fi;
	    if isRead then
		forgetRegs();	/* just in case! */
	    fi;
	fi;
	if Token + '\e' = ';' then
	    scan();
	else
	    pComma(')');
	fi;
	first := false;
    od;
    if first and isLine then
	/* default to standard I/O */
	genCall(if isRead then SETSTDIN else SETSTDOUT fi);
    fi;
    if isLine then
	genCall(if isRead then READLN else WRITELN fi);
    fi;
    rightParen();
    if not noChannel and (not first or isLine) then
	genCall("\elennahcnu_d_");
    fi;
    if pushedA1 then
	opMove(OP_MOVEL, M_INC << 3 | RSP, M_ADIR << 3 | 1);
    fi;
    peepFlush();
    if noChannel then
	d0*.v_kind := VVOID;
	d0*.v_type := TYVOID;
    else
	d0*.v_kind := VREG;
	d0*.v_value.v_reg := 0;
	d0*.v_type := TYIORESULT;
    fi;
corp;
