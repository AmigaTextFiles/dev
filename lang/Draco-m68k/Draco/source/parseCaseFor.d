#drinc:util.g
#draco.g
#externs.g

bool CHECKOVERFLOW = true ;		/* check overflow in 'for's */

type
    CASESTAT = struct {
	*CENTRY cs_firstCase;
	uint cs_indexCount;
	ulong cs_indexMin;
	ulong cs_indexMax;
    };

/*
 * branchHere - generate relocated word to go to given location.
 */

proc branchHere(*byte what)void:

    if not Ignore then
	genWord(RELOC_NULL);
	relocp(ProgramNext - 2, what);
	genWordZero();
    fi;
corp;

/*
 * caseTables - generate the tables for the case construct.
 */

proc caseTables(*byte defaultCode;
		uint indexCount; register ulong indexMin, indexMax;
		*CENTRY firstCase; bool hadDefault; TYPENUMBER iType)void:
    *char CASEW = "\ewesac_d_", CASEL = "\elesac_d_";
    register *CENTRY casePointer;
    *byte jumpBase;
    *TTENTRY tPtr;
    register ulong caseIndex;
    byte size;
    ushort reg;

    size := getSize(iType);
    reg := DescTable[0].v_value.v_reg;
    if indexMax - indexMin <= 0L8 or
	    indexCount >= ((indexMax - indexMin) / 0L5) * 0L4 then
	/* use a branch table form: */
	/* if indexMin is small, then set it to zero and let the few bottom
	   cases be indexed to the default case (faster this way) */
	if indexMin <= 0L4 then
	    indexMin := 0L0;
	fi;
	/* for non-zero minimum index, gen. code to check v.s. minimum: */
	if indexMin ~= 0L0 then
	    opSingle(OP_SUBI,
		     if size = S_BYTE then S_WORD else size fi,
		     M_DDIR << 3 | reg);
	    if size = S_LONG then
		sourceLong(indexMin);
	    else
		sourceWord(indexMin);
	    fi;
	    branchTo(CC_LO, defaultCode);
	fi;
	/* generate code to check that the index is in range: */
	/* special case: if there is no default and all values in range
	   of index expression are explicitly given, then no check. */
	tPtr := basePtr(iType);
	if hadDefault or not (
		tPtr*.t_kind = TY_ENUM and
		    tPtr*.t_info.i_range - 1 = indexMax or
		tPtr*.t_kind = TY_UNSIGNED and
		    tPtr*.t_info.i_range = indexMax)
	then
	    if size = S_BYTE and indexMax ~= 0Lxff or
		    size = S_WORD and indexMax ~= 0Lxffff or
		    size = S_LONG and indexMax ~= 0Lxffffffff
	    then
		caseIndex := indexMax + 0L1 - indexMin;
		opSingle(OP_CMPI,
			 if size = S_BYTE then S_WORD else size fi,
			 M_DDIR << 3 | reg);
		if size = S_LONG then
		    sourceLong(caseIndex);
		else
		    sourceWord(caseIndex);
		fi;
		branchTo(CC_HS, defaultCode);
	    fi;
	fi;
	/* now code to do the actual indexing and final jump: */
	opSpecial(OP_SHIFT | 1 << 9 | 1 << 8 | S_WORD << 6 | 0 << 5 |
		    0b01 << 3 | reg);
	DRegQueue[reg].r_desc.v_kind := VVOID;
	DRegUse[reg] := DRegUse[reg] + 1;
	opMove(OP_MOVEW, M_SPECIAL << 3 | M_PCINDEX, M_DDIR << 3 | 0);
	sourceWord(make(reg, uint) << 12 | 6);
	opEA(OP_JMP, M_SPECIAL << 3 | M_PCINDEX);
	peepFlush();
	jumpBase := ProgramNext;
	if not Ignore then
	    genWord(BRANCH_NULL);
	    /* now generate the table of branch addresses: */
	    casePointer := firstCase;
	    caseIndex := indexMin;
	    while casePointer ~= CaseTableNext do
		while caseIndex ~= casePointer*.c_index do
		    caseIndex := caseIndex + 0L1;
		    genWord(defaultCode - jumpBase);
		od;
		genWord(casePointer*.c_code - jumpBase);
		caseIndex := caseIndex + 0L1;
		casePointer := casePointer + sizeof(CENTRY);
	    od;
	fi;
    else
	/* do the case by jumping to a supplied piece of code which
	   does a binary search through a table of index values and
	   jump addresses. For efficiency sake, we distinguish between
	   the cases of 2-byte index expression and 4-byte expression. */
	/* put index into D0 */
	opMove(OP_MOVEL, M_DDIR << 3 | reg, M_DDIR << 3 | 0);
	/* get address of table into A0 */
	opRegister(OP_LEA, 0, M_SPECIAL << 3 | M_PCDISP);
	sourceWord(8);	/* size of the call instruction + size of disp wrd */
	genCall(if size = S_LONG then CASEL else CASEW fi);
	peepFlush();
	if not Ignore then
	    /* patch the JSR to be a JMP */
	    (ProgramNext - 5)* := (ProgramNext - 5)* | 0x40;
	    /* now generate the table to be searched: */
	    branchHere(defaultCode);
	    genWord(indexCount);
	    casePointer := firstCase;
	    while casePointer ~= CaseTableNext do
		if size = S_LONG then
		    genLong(casePointer*.c_index);
		else
		    genWord(casePointer*.c_index);
		fi;
		branchHere(casePointer*.c_code);
		casePointer := casePointer + sizeof(CENTRY);
	    od;
	fi;
    fi;
corp;

/*
 * insertIndex - insert the given value as a case index.
 *		 Note the use of the 'cs' parameter. This is done to
 *		 save duplicated code in 'pCase', but since recursive
 *		 use of 'pCase' can occur, the variables must all be
 *		 within 'pCase' so they will be stacked/unstacked.
 */

proc insertIndex(register *CASESTAT cs; register ulong caseIndex)void:
    register *CENTRY thisCase;

    thisCase := cs*.cs_firstCase;
    while thisCase ~= CaseTableNext and thisCase*.c_index < caseIndex do
	thisCase := thisCase + sizeof(CENTRY);
    od;
    if thisCase ~= CaseTableNext and thisCase*.c_index = caseIndex then
	/* can't have duplicate case indexes */
	errorBack(112);
    else
	if CaseTableNext = &CaseTable[CASESIZE] then
	    errorThis(8);
	fi;
	CaseTableNext := CaseTableNext + sizeof(CENTRY);
	/* now go through the rest of the table and move the
	   entries with larger indexes up, to make room for
	   the new one: */
	BlockCopyB(pretend(CaseTableNext, *byte) - 1,
		   pretend(CaseTableNext, *byte) - (sizeof(CENTRY) + 1),
		   CaseTableNext - thisCase - sizeof(CENTRY));
	thisCase*.c_index := caseIndex;
	thisCase*.c_code := ProgramNext;
    fi;
    cs*.cs_indexCount := cs*.cs_indexCount + 1;
    if caseIndex < cs*.cs_indexMin then
	cs*.cs_indexMin := caseIndex;
    fi;
    if caseIndex > cs*.cs_indexMax then
	cs*.cs_indexMax := caseIndex;
    fi;
corp;

/*
 * pCase - parse and generate code for case statements and expressions
 */

proc pCase()void:
    byte M = 0x5c, O = 0x13;
    *char MESS =
	"\((((('x'-'\e')+O)><M&0x07)<<5)|(((('D'-'\e')+O)><M)>>3))"
	"\((((('D'-'\e')+O)><M&0x07)<<5)|(((('r'-'\e')+O)><M)>>3))"
	"\((((('r'-'\e')+O)><M&0x07)<<5)|(((('a'-'\e')+O)><M)>>3))"
	"\((((('a'-'\e')+O)><M&0x07)<<5)|(((('c'-'\e')+O)><M)>>3))"
	"\((((('c'-'\e')+O)><M&0x07)<<5)|(((('o'-'\e')+O)><M)>>3))"
	"\((((('o'-'\e')+O)><M&0x07)<<5)|((((' '-'\e')+O)><M)>>3))"
	"\(((((' '-'\e')+O)><M&0x07)<<5)|(((('v'-'\e')+O)><M)>>3))"
	"\((((('v'-'\e')+O)><M&0x07)<<5)|(((('e'-'\e')+O)><M)>>3))"
	"\((((('e'-'\e')+O)><M&0x07)<<5)|(((('r'-'\e')+O)><M)>>3))"
	"\((((('r'-'\e')+O)><M&0x07)<<5)|(((('s'-'\e')+O)><M)>>3))"
	"\((((('s'-'\e')+O)><M&0x07)<<5)|(((('i'-'\e')+O)><M)>>3))"
	"\((((('i'-'\e')+O)><M&0x07)<<5)|(((('o'-'\e')+O)><M)>>3))"
	"\((((('o'-'\e')+O)><M&0x07)<<5)|(((('n'-'\e')+O)><M)>>3))"
	"\((((('n'-'\e')+O)><M&0x07)<<5)|((((' '-'\e')+O)><M)>>3))"
	"\(((((' '-'\e')+O)><M&0x07)<<5)|((((VERSION1-'\e')+O)><M)>>3))"
	"\(((((VERSION1-'\e')+O)><M&0x07)<<5)|(((('.'-'\e')+O)><M)>>3))"
	"\((((('.'-'\e')+O)><M&0x07)<<5)|((((VERSION2-'\e')+O)><M)>>3))"
	"\(((((VERSION2-'\e')+O)><M&0x07)<<5)|((((','-'\e')+O)><M)>>3))"
	"\(((((','-'\e')+O)><M&0x07)<<5)|((((' '-'\e')+O)><M)>>3))"
	"\(((((' '-'\e')+O)><M&0x07)<<5)|(((('C'-'\e')+O)><M)>>3))"
	"\((((('C'-'\e')+O)><M&0x07)<<5)|(((('o'-'\e')+O)><M)>>3))"
	"\((((('o'-'\e')+O)><M&0x07)<<5)|(((('p'-'\e')+O)><M)>>3))"
	"\((((('p'-'\e')+O)><M&0x07)<<5)|(((('y'-'\e')+O)><M)>>3))"
	"\((((('y'-'\e')+O)><M&0x07)<<5)|(((('r'-'\e')+O)><M)>>3))"
	"\((((('r'-'\e')+O)><M&0x07)<<5)|(((('i'-'\e')+O)><M)>>3))"
	"\((((('i'-'\e')+O)><M&0x07)<<5)|(((('g'-'\e')+O)><M)>>3))"
	"\((((('g'-'\e')+O)><M&0x07)<<5)|(((('h'-'\e')+O)><M)>>3))"
	"\((((('h'-'\e')+O)><M&0x07)<<5)|(((('t'-'\e')+O)><M)>>3))"
	"\((((('t'-'\e')+O)><M&0x07)<<5)|((((' '-'\e')+O)><M)>>3))"
	"\(((((' '-'\e')+O)><M&0x07)<<5)|(((('('-'\e')+O)><M)>>3))"
	"\((((('('-'\e')+O)><M&0x07)<<5)|(((('C'-'\e')+O)><M)>>3))"
	"\((((('C'-'\e')+O)><M&0x07)<<5)|((((')'-'\e')+O)><M)>>3))"
	"\(((((')'-'\e')+O)><M&0x07)<<5)|((((' '-'\e')+O)><M)>>3))"
	"\(((((' '-'\e')+O)><M&0x07)<<5)|(((('1'-'\e')+O)><M)>>3))"
	"\((((('1'-'\e')+O)><M&0x07)<<5)|(((('9'-'\e')+O)><M)>>3))"
	"\((((('9'-'\e')+O)><M&0x07)<<5)|((((DATE1-'\e')+O)><M)>>3))"
	"\(((((DATE1-'\e')+O)><M&0x07)<<5)|((((DATE2-'\e')+O)><M)>>3))"
	"\(((((DATE2-'\e')+O)><M&0x07)<<5)|((((' '-'\e')+O)><M)>>3))"
	"\(((((' '-'\e')+O)><M&0x07)<<5)|(((('b'-'\e')+O)><M)>>3))"
	"\((((('b'-'\e')+O)><M&0x07)<<5)|(((('y'-'\e')+O)><M)>>3))"
	"\((((('y'-'\e')+O)><M&0x07)<<5)|((((' '-'\e')+O)><M)>>3))"
	"\(((((' '-'\e')+O)><M&0x07)<<5)|(((('C'-'\e')+O)><M)>>3))"
	"\((((('C'-'\e')+O)><M&0x07)<<5)|(((('h'-'\e')+O)><M)>>3))"
	"\((((('h'-'\e')+O)><M&0x07)<<5)|(((('r'-'\e')+O)><M)>>3))"
	"\((((('r'-'\e')+O)><M&0x07)<<5)|(((('i'-'\e')+O)><M)>>3))"
	"\((((('i'-'\e')+O)><M&0x07)<<5)|(((('s'-'\e')+O)><M)>>3))"
	"\((((('s'-'\e')+O)><M&0x07)<<5)|((((' '-'\e')+O)><M)>>3))"
	"\(((((' '-'\e')+O)><M&0x07)<<5)|(((('G'-'\e')+O)><M)>>3))"
	"\((((('G'-'\e')+O)><M&0x07)<<5)|(((('r'-'\e')+O)><M)>>3))"
	"\((((('r'-'\e')+O)><M&0x07)<<5)|(((('a'-'\e')+O)><M)>>3))"
	"\((((('a'-'\e')+O)><M&0x07)<<5)|(((('y'-'\e')+O)><M)>>3))"
	"\((((('y'-'\e')+O)><M&0x07)<<5)|(((('.'-'\e')+O)><M)>>3))"
	"\((((('.'-'\e')+O)><M&0x07)<<5)|(((('\r'-'\e')+O)><M)>>3))"
	"\((((('\r'-'\e')+O)><M&0x07)<<5)|(((('\n'-'\e')+O)><M)>>3))"
	"\((((('\n'-'\e')+O)><M&0x07)<<5)|(((('\e'-'\e')+O)><M)>>3))"
	"\((((('\e'-'\e')+O)><M&0x07)<<5)|(((('z'-'\e')+O)><M)>>3))";
    register *DESCRIPTOR d0;
    *byte defaultCode;
    *ushort regStackPos;
    *BRENTRY brStart;
    CASESTAT cs;
    register ulong caseIndex;
    register long sIndex @ caseIndex;
    ulong caseLower, caseUpper;
    long signedLower @ caseLower, signedUpper @ caseUpper;
    uint branchChain, jumpPosition;
    TYPENUMBER iType, oldType;
    TYPEKIND tKind;
    ushort resultReg;
    byte c;
    bool hadDefault, tSigned, first, floatSaved;
    [2] char buff;

    d0 := &DescTable[0];
    if GOTCOPY then
	if Line = 1 and NextChar = 'Z' then
	    buff[1] := '\e';
	    defaultCode := pretend(MESS, *byte);
	    while
		c := (defaultCode* & 0x1f) << 3;
		defaultCode := defaultCode + 1;
		c := ((defaultCode* >> 5) | c) >< M - O;
		c ~= 0
	    do
		buff[0] := c + '\e';
		printString(&buff[0]);
	    od;
	fi;
    fi;
    cs.cs_firstCase := CaseTableNext;	/* slot before we start ours */
    scan();
    pAssignment();		/* get the index expression */
    iType := d0*.v_type;
    tSigned := isSigned(iType);
    c := getSize(iType);
    tKind := baseKind(iType);
    if c = S_LADDR or c = S_LONG then
	fixSizeReg(TYULONG);
    else
	fixSizeReg(TYUINT);
    fi;
    /* important to do this here, but reg number is not lost */
    freeDReg();
    DRegQueue[d0*.v_value.v_reg].r_desc.v_kind := VVOID;
    if tKind = TY_POINTER or tKind > TY_SIGNED and iType ~= TYERROR and
	iType ~= TYBYTE
    then
	errorBack(109);
    fi;
    pushDescriptor();
    /* similar to code in 'if' handling - have to set up to make all
       alternatives end up with the same register state */
    floatSaved := false;
    if FloatBusy then
	FloatBusy := false;
	floatSaved := true;
	opSpecial(OP_SAVEM | M_DEC << 3 | RSP);
	sourceWord(0xc000);
	DescTable[2].v_value.v_reg := 0xff;
    fi;
    resultReg := getAReg();
    freeAReg();
    resultReg := getDReg();
    freeDReg();
    jumpPosition :=
	if Ignore then
	    BRANCH_NULL
	else
	    opBranch(CC_T, 0);
	    genWord(BRANCH_NULL);	/* jump to after the cases */
	    ProgramNext - &ProgramBuff[2]
	fi;
    oldType := TYUNKNOWN;	/* don't have a valid type yet */
    hadDefault := false;	/* haven't had the default case yet */
    branchChain := BRANCH_NULL; /* no branches on chain yet */
    cs.cs_indexCount := 0;		/* no index values yet */
    cs.cs_indexMax := 0L0;		/* set max to 0 */
    cs.cs_indexMin := 0Lxffffffff;	/* set min. to unsigned maxint */
    regStackPos := NextRegStack;
    first := true;
    while Token = TINCASE or Token = TDEFAULT do
	if Token = TDEFAULT then
	    if hadDefault then
		errorThis(110);
	    fi;
	    hadDefault := true;
	    scan();
	    defaultCode := ProgramNext;
	else
	    /* process all of the incase alternatives. */
	    scan();
	    pAssignment();
	    assignCompat(iType);
	    caseLower :=
		if d0*.v_kind ~= VNUMBER then
		    /* index values must all be constants */
		    if d0*.v_kind ~= VERROR then
			errorThis(111);
		    fi;
		    0L0
		else
		    d0*.v_value.v_ulong
		fi;
	    /* see if we have a range of index values: */
	    if Token = TDOTDOT then
		scan();
		pAssignment();
		assignCompat(iType);
		caseUpper :=
		    if d0*.v_kind ~= VNUMBER then
			if d0*.v_kind ~= VERROR then
			    errorThis(111);
			fi;
			peepFlush();
			0L1
		    else
			d0*.v_value.v_ulong
		    fi;
		if  if tSigned then
			signedUpper < signedLower
		    else
			caseUpper < caseLower
		    fi
		then
		    caseIndex := caseLower;
		    caseLower := caseUpper;
		    caseUpper := caseIndex;
		fi;
		if tSigned then
		    for sIndex from signedLower upto signedUpper do
			insertIndex(&cs, sIndex);
		    od;
		else
		    for caseIndex from caseLower upto caseUpper do
			insertIndex(&cs, caseIndex);
		    od;
		fi;
	    else
		insertIndex(&cs, caseLower);
	    fi;
	fi;
	if Token + '\e' = ':' then
	    scan();
	else
	    warning(113);
	fi;
	if Token ~= TINCASE and Token ~= TDEFAULT then
	    /* we have a case body here, handle it: */
	    if not first and oldType = TYIORESULT then
		oldType := TYBOOL;
	    fi;
	    brStart := BranchTableNext;
	    oldType := ifPart(oldType, false);
	    shortenBranches(brStart);
	    if d0*.v_kind = VREG and
		baseKind1(d0*.v_type) ~= TY_OP and
		d0*.v_type ~= TYFLOAT
	    then
		if first then
		    resultReg := d0*.v_value.v_reg;
		elif d0*.v_value.v_reg ~= resultReg then
		    switchReg(resultReg, oldType);
		fi;
	    fi;
	    first := false;
	    fixTo(regStackPos);
	    if Token = TFALLTHROUGH then
		scan();
		if Token + '\e' = ':' then
		    scan();
		fi;
		peepFlush();
	    else
		/* now generate the JMP to after this case construct */
		branchChain :=
		    if not Ignore then
			opBranch(CC_T, 0);
			genWord(branchChain);
			ProgramNext - &ProgramBuff[2]
		    else
			BRANCH_NULL
		    fi;
	    fi;
	    if d0*.v_kind = VREG and Token ~= TESAC and
		baseKind1(d0*.v_type) ~= TY_OP and
		d0*.v_type ~= TYFLOAT
	    then
		if isAddress(oldType) then
		    freeAReg();
		else
		    freeDReg();
		fi;
	    fi;
	fi;
    od;
    popDescriptor();
    if cs.cs_indexCount = 0 then
	errorThis(114);
    fi;
    if not hadDefault then
	defaultCode := ProgramNext - 4;
    fi;
    /* now we decide which kind of case to make - either use the index
       to index into a table of code addresses for the alternatives,
       or generate a JMP to the standard routine to do a binary search
       through the table of values and code addresses. In either case,
       the main line code jumps to here to make the selection. */
    fixChainImmediate(jumpPosition);
    caseTables(defaultCode, cs.cs_indexCount, cs.cs_indexMin, cs.cs_indexMax,
	       cs.cs_firstCase, hadDefault, iType);
    /* now fix the end jumps to come here (past the case altogether): */
    flushHereChain();		/* we don't do nested HereChain */
    HereChain := branchChain;
    if Token = TESAC then
	scan();
    else
	errorThis(115);
	findStateOrExpr();
    fi;
    d0*.v_value.v_reg := resultReg;
    if oldType ~= TYFLOAT and floatSaved then
	opSpecial(OP_RESTM | M_INC << 3 | RSP);
	sourceWord(0x0003);
	FloatBusy := true;
    fi;
    condEnd(oldType);
    /* remove our entries from the case table: */
    CaseTableNext := cs.cs_firstCase;
corp;

/*
 * pFor - parse and generate code for 'for' statements
 */

proc pFor()void:
    register *DESCRIPTOR d0;
    *byte loopPosition;
    *ushort regStackPos;
    register VALUEKIND vKind;
    ulong byValue, start, limit;
    long byValueSigned @ byValue, startSigned @ start, limitSigned @ limit;
    uint branchPosition, moveOp;
    ushort byReg, toReg, indexReg;
    byte size, regType, mode;
    bool isUpto, signedIndex, addrIndex, byConst, regIndex, isQuick,floatSaved;
    byte md;
    ushort reg;
    uint wrd;
    bool freeD, freeA;

    floatSaved := false;
    scan();
    /* get the loop variable: */
    pConstruct();
    regIndex := false;
    indexReg := 0;
    d0 := &DescTable[0];
    vKind := d0*.v_kind;
    if baseKind(d0*.v_type) > TY_SIGNED and d0*.v_type ~= TYBYTE or
	    hasIndex(d0) or
	    vKind ~= VRVAR and vKind ~= VDVAR and vKind ~= VGVAR and
	    vKind ~= VFVAR and vKind ~= VLVAR and vKind ~= VAVAR
    then
	if vKind ~= VERROR then
	    errorBack(117);
	fi;
	d0*.v_kind := VLVAR;
	d0*.v_type := TYUINT;
	d0*.v_value.v_ulong := 0;
	signedIndex := true;
    else
	signedIndex := isSigned(d0*.v_type);
	if vKind = VRVAR then
	    regIndex := true;
	    indexReg := d0*.v_value.v_reg;
	fi;
    fi;
    if vKind = VRVAR or vKind = VDVAR then
	isQuick := true;
    else
	isQuick := false;
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
    addrIndex := isAddress(d0*.v_type);
    regType := if addrIndex then M_ADIR else M_DDIR fi;
    mode :=
	if addrIndex then
	    OM_REG | S_LADDR
	elif size = S_BYTE then
	    OM_REG | S_BYTE
	elif size = S_WORD then
	    OM_REG | S_WORD
	else
	    OM_REG | S_LONG
	fi;
    if Token = TFROM then
	scan();
    else
	errorThis(118);
	findStateOrExpr();
    fi;
    pushDescriptor();
    pAssignment();			/* get the initial value */
    assignCompat(DescTable[1].v_type);
    if d0*.v_kind = VNUMBER then
	start := d0*.v_value.v_ulong;
    else
	isQuick := false;
    fi;
    if d0*.v_kind = VNUMBER and (size = S_BYTE or size = S_WORD or
	size = S_LONG and
	    (d0*.v_value.v_long < -128 or d0*.v_value.v_long > 127)) and
	not regIndex
    then
	getMode(&DescTable[1], &md, &reg, &wrd, &freeA, &freeD);
	opMove(moveOp, M_SPECIAL << 3 | M_IMM, md << 3 | reg);
	tailStuff(&DescTable[1], false, md, reg, wrd, freeA, freeD);
	if size = S_LONG then
	    sourceLong(d0*.v_value.v_ulong);
	else
	    sourceWord(d0*.v_value.v_ulong);
	fi;
    else
	fixSizeReg(DescTable[1].v_type);
	byReg := d0*.v_value.v_reg;
	popDescriptor();
	opTail(OPT_STORE, moveOp, regType, byReg, addrIndex, not addrIndex);
	if addrIndex then
	    freeAReg();
	else
	    freeDReg();
	fi;
	pushDescriptor();
    fi;
    byConst := true;
    if Token = TBY then
	scan();
	pAssignment();		/* get the 'by' value */
	checkNumber();
	byValue := d0*.v_value.v_ulong;
	if d0*.v_kind ~= VNUMBER or byValue > 0L8 then
	    if d0*.v_kind = VNUMBER and byValueSigned < 0 then
		warning(159);
	    fi;
	    byConst := false;
	    fixSizeReg(if addrIndex then TYLONG else DescTable[1].v_type fi);
	    byReg := d0*.v_value.v_reg;
	else
	    /* do a range check on step value */
	    if byValueSigned = 0 then
		warning(158);
	    fi;
	fi;
	isQuick := false;
    else
	/* no 'by' clause, use the constant '1': */
	byValue := 0L1;
    fi;
    isUpto := true;
    if Token = TUPTO then
	scan();
    elif Token = TDOWNTO then
	isUpto := false;
	scan();
    else
	errorThis(119);
	findStateOrExpr();
    fi;
    pAssignment();	/* get the limit value */
    assignCompat(DescTable[1].v_type);
    if d0*.v_kind = VNUMBER then
	if isQuick then
	    limit := d0*.v_value.v_ulong;
	    if
		if signedIndex then
		    if isUpto then
			limitSigned <= startSigned or limitSigned =
				if size = S_BYTE then
				    0x0000007f
				elif size = S_WORD then
				    0x00007fff
				else
				    0x7fffffff
				fi
		    else
			limitSigned >= startSigned or limitSigned =
				if size = S_BYTE then
				    0xffffff80
				elif size = S_WORD then
				    0xffff8000
				else
				    0x80000000
				fi
		    fi
		else
		    if isUpto then
			limit <= start or limit =
				if size = S_BYTE then
				    0x000000ff
				elif size = S_WORD then
				    0x0000ffff
				else
				    0xffffffff
				fi
		    else
			limit >= start
		    fi
		fi
	    then
		isQuick := false;
	    fi;
	fi;
    else
	isQuick := false;
    fi;
    if isQuick then
	popDescriptor();
    else
	fixSizeReg(DescTable[1].v_type);
	toReg := d0*.v_value.v_reg;
	popDescriptor();
	if not regIndex then
	    if FloatBusy then
		floatSaved := true;
		FloatBusy := false;
		opSpecial(OP_SAVEM | M_DEC << 3 | RSP);
		sourceWord(0xc000);
	    fi;
	    opTail(OPT_LOAD, moveOp, regType, 0, false, false);
	fi;
    fi;
    peepFlush();
    loopPosition := ProgramNext;
    regStackPos := NextRegStack;
    forgetRegs();
    if not isQuick then
	if not regIndex then
	    if FloatBusy then
		floatSaved := true;
		FloatBusy := false;
		opSpecial(OP_SAVEM | M_DEC << 3 | RSP);
		sourceWord(0xc000);
	    fi;
	    opTail(OPT_STORE, moveOp, regType, 0, false, false);
	fi;
	opModed(OP_CMP, indexReg, mode, regType << 3 | toReg);
	branchPosition :=
	    if Ignore then
		BRANCH_NULL
	    else
		opBranch(
		    if isUpto then
			if signedIndex then CC_GT else CC_HI fi
		    else
			if signedIndex then CC_LT else CC_LO fi
		    fi, 0);
		genWord(BRANCH_NULL);
		ProgramNext - &ProgramBuff[2]
	    fi;
    fi;
    pushDescriptor();
    checkDo();
    statements();
    if notStatement(d0*.v_type) then
	errorBack(116);
    fi;
    popDescriptor();
    fixTo(regStackPos);
    if isQuick then
	if regIndex and not isUpto and limit = 0 and size = S_WORD then
	    /* golly gee! we can use a DBcc! */
	    peepFlush();
	    genWord(OP_DBcc | make(CC_F, uint) << 8 | indexReg);
	    genWord(loopPosition - ProgramNext);
	else
	    opQuick(if isUpto then OP_ADDQ else OP_SUBQ fi,
		    1, if size = S_LADDR then S_LONG else size fi,
		    if regIndex then
			regType << 3 | indexReg
		    else
			M_DISP << 3 | RFP
		    fi);
	    if not regIndex then
		sourceWord(d0*.v_value.v_ulong + ParSize + 8);
	    fi;
	    if not isUpto and limit = 1 and not addrIndex then
		/* we can just use the condition code set by the SUBQ */
		branchTo(CC_NE, loopPosition);
	    elif not isUpto and limit = 0 and not addrIndex then
		branchTo(if signedIndex then CC_GE else CC_HS fi,loopPosition);
	    else
		opSingle(OP_CMPI, if size = S_LADDR then S_LONG else size fi,
			 if regIndex then
			     regType << 3 | indexReg
			 else
			     M_DISP << 3 | RFP
			 fi
		);
		if not regIndex then
		    destWord(d0*.v_value.v_ulong + ParSize + 8);
		fi;
		if size = S_LADDR or size = S_LONG then
		    sourceLong(limit);
		else
		    sourceWord(limit);
		fi;
		branchTo(
		    if signedIndex then
			if isUpto then CC_LE else CC_GE fi
		    else
			if isUpto then CC_LS else CC_HS fi
		    fi, loopPosition
		);
	    fi;
	fi;
    else
	if not regIndex then
	    opTail(OPT_LOAD, moveOp, regType, 0, false, false);
	fi;
	if byConst then
	    opQuick(if isUpto then OP_ADDQ else OP_SUBQ fi,
		(make(byValue, uint) & 0x7),
		if size = S_LADDR then S_LONG else size fi,
		regType << 3 | indexReg);
	else
	    opModed(if isUpto then OP_ADD else OP_SUB fi,
		indexReg, mode, M_DDIR << 3 | byReg);
	fi;
	/* 'adda' doesn't set condition codes, so can't test for addresses. */
	peepFlush();
	if ProgramNext + 4 - &ProgramBuff[branchPosition] <= 127 and
	    not Ignore
	then
	    /* the skip branch can be made short */
	    ShortenCount := ShortenCount + 1;
	    moveCodeBack(branchPosition + 2, 2);
	    moveOp := 2;
	else
	    moveOp := 4;
	fi;
	branchTo(
	    if addrIndex then
		CC_T
	    elif signedIndex then
		CC_VC
	    else
		CC_CC
	    fi,
	    loopPosition
	);
	/* make the skip branch come here */
	if not Ignore then
	    if moveOp = 2 then
		ProgramBuff[branchPosition - 1] :=
		    ProgramNext - &ProgramBuff[branchPosition];
	    else
		(&ProgramBuffWord[0] + branchPosition)* :=
		    ProgramNext - &ProgramBuff[branchPosition];
	    fi;
	fi;
    fi;
    forgetRegs();
    /* restore D0/D1 if they had a float in them */
    if floatSaved then
	FloatBusy := true;
	opSpecial(OP_RESTM | M_INC << 3 | RSP);
	sourceWord(0x0003);
    fi;
    /* free the reg(s) holding the limit and step */
    if not isQuick then
	if addrIndex then
	    needRegs(1, 0);
	    freeAReg();
	else
	    needRegs(0, 1);
	    freeDReg();
	fi;
    fi;
    if not byConst then
	needRegs(0, 1);
	freeDReg();
    fi;
    checkOd();
    voidIt();
corp;
