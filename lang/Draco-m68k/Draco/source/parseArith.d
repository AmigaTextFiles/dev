#draco.g
#externs.g

/* parse and code-gen for bit and arithmetic operators */

/* declare assembler interface stubs to floating point code */

extern
    _DPAbs(long lo, hi; *byte pF)void,
    _DPNeg(long lo, hi; *byte pF)void,
    _DPAdd(long rlo, rhi, llo, lhi; *byte pF)void,
    _DPSub(long rlo, rhi, llo, lhi; *byte pF)void,
    _DPMul(long rlo, rhi, llo, lhi; *byte pF)void,
    _DPDiv(long rlo, rhi, llo, lhi; *byte pF)void;

/* a type to let us work with floats */

type
    Float_t = union {
	struct {
	    long l_hi, l_lo;
	} l_;
	[8] byte b_arr;
    };

extern pAbsNeg()void;		/* forward declaration of recursive private */

/*
 * pEnref - parse and generate code for the '&' enreffing operator
 */

proc doEnref()void:
    register *DESCRIPTOR d0;

    scan();
    pIndSubDot();
    d0 := &DescTable[0];
    if d0*.v_kind = VRVAR then
	errorBack(157);
	d0*.v_value.v_reg := getAReg();
    else
	putAddrInReg();
    fi;
    d0*.v_kind := VREG;
    d0*.v_type := makePtrTo(d0*.v_type);
corp;

proc pEnref()void:

    if Token + '\e' = '&' then
	doEnref();
    else
	pIndSubDot();
    fi;
corp;

/*
 * pBitNot - parse and generate code for the bitwise ~ operator
 */

proc doBitNot()void:
    extern pBitNot()void;

    scan();
    pBitNot();
    if isOp() then
	checkOp(OPNOT);
    else
	checkNumber();
	if DescTable[0].v_kind = VNUMBER then
	    /* compile eval. if possible */
	    DescTable[0].v_value.v_ulong :=
		~ DescTable[0].v_value.v_ulong;
	else	    /* otherwise get it and complement it */
	    putInReg();
	    opSingle(OP_NOT, getSize(DescTable[0].v_type),
		M_DDIR << 3 | DescTable[0].v_value.v_reg);
	fi;
    fi;
corp;

proc pBitNot()void:

    if Token + '\e' = '~' then
	doBitNot();
    else
	pEnref();
    fi;
corp;

/*
 * isAXLR - return true if Token is '&', TXOR, TSHL or TSHR.
 */

proc isAXLR()bool:

    Token + '\e' = '&' or Token = TXOR or Token = TSHL or Token = TSHR
corp;

/*
 * pBitAndXorShift - parse and generate code for the bitwise '&', '><'
 *			 and shift ('<<' and '>>') operators
 */

proc doBitAndXorShift()void:
    register *DESCRIPTOR d0, d1;
    STATE stateSave;
    register ulong leftValue;
    register ushort tokenSave;
    register uint reg;
    byte size;
    ulong length;
    bool wasConstant, reversible, vOp;

    while isAXLR() do
	d0 := &DescTable[0];
	d1 := d0 + sizeof(DESCRIPTOR);
	vOp := isOp();
	if not vOp then
	    if Token = TSHL or Token = TSHR then
		if d0*.v_type ~= TYERROR and
			(not isNumber(d0*.v_type) or
			    isSigned(d0*.v_type)) then
		    errorBack(99);
		    forceData();
		fi;
	    else
		checkNumber();
	    fi;
	fi;
	save(&stateSave);
	leftValue := d0*.v_value.v_ulong;
	wasConstant := d0*.v_kind = VNUMBER; /* left constant? */
	reversible := wasConstant and (Token + '\e' = '&' or Token = TXOR);
	if not reversible then
	    putInReg(); 	    /* put left operand in register */
	fi;
	tokenSave := Token;	    /* remember which operator it was */
	scan(); 		    /* skip the operator */
	pushDescriptor();
	pBitNot();	    /* get the right operand */
	if tokenSave = TSHL or tokenSave = TSHR or not vOp and not isOp() then
	    checkNumber();
	    if reversible then
		wasConstant := reverseOps();
	    fi;
	else
	    opCompat();
	fi;
	if wasConstant and d0*.v_kind = VNUMBER then
	    /* full compile-time evaluation - undo code and find result*/
	    restore(&stateSave, true);
	    d1*.v_value.v_ulong :=
		if tokenSave + '\e' = '&' then
		    leftValue & d0*.v_value.v_ulong
		elif tokenSave = TXOR then
		    leftValue >< d0*.v_value.v_ulong
		elif tokenSave = TSHL then
		    leftValue << make(d0*.v_value.v_ulong, uint)
		else
		    leftValue >> make(d0*.v_value.v_ulong, uint)
		fi;
	    d1*.v_kind := VNUMBER;
	    if tokenSave + '\e' = '&' or tokenSave = TXOR then
		mergeTypes();
	    fi;
	elif vOp or isOp() then
	    checkOp(
		if tokenSave + '\e' = '&' then
		    OPAND
		elif tokenSave = TXOR then
		    OPXOR
		elif tokenSave = TSHL then
		    fixSizeReg(TYUINT);
		    OPSHL
		else
		    fixSizeReg(TYUINT);
		    OPSHR
		fi
	    );
	else
	    size := getSize(d1*.v_type);
	    length := typeSize(d1*.v_type);
	    if tokenSave + '\e' = '&' then
		if d0*.v_kind = VNUMBER then
		    /* shrink the value down to the size of the non-const */
		    d0*.v_value.v_ulong :=
			d0*.v_value.v_ulong & ((1 << (length * 8)) - 1)
		fi;
		modedBinary(OP_AND);
		mergeTypes();
	    elif tokenSave = TXOR then
		if d0*.v_kind = VNUMBER then
		    /* shrink the value down to the size of the non-const */
		    d0*.v_value.v_ulong :=
			d0*.v_value.v_ulong & ((1 << (length * 8)) - 1)
		fi;
		/* stupid machine!!!! */
		if d0*.v_kind = VNUMBER and
		    (d1*.v_kind ~= VREG or size = S_BYTE)
		then
		    wasConstant := reverseOps();
		    modedBinary(OP_EOR);
		else
		    shrinkConsts();
		    fixSizeReg(d1*.v_type);
		    reg := d1*.v_value.v_reg;
		    d1*.v_value.v_reg := d0*.v_value.v_reg;
		    d0*.v_value.v_reg := reg;
		    modedBinary(OP_EOR);
		    d1*.v_value.v_reg := d0*.v_value.v_reg;
		fi;
		mergeTypes();
	    else
		if d0*.v_kind = VNUMBER and d0*.v_value.v_ulong >= length * 8
		then
		    warning(160);
		fi;
		wasConstant := isSigned(d1*.v_type);
		reversible := tokenSave = TSHL;
		reg := d1*.v_value.v_reg;
		if d0*.v_kind = VNUMBER then
		    if d0*.v_value.v_ulong <= 0L8 then
			/* shift by a constant amount */
			shift(reg, size, reversible,
			      wasConstant, d0*.v_value.v_ulong);
		    else
			/* put the shift amount into D0 */
			opImm(0, d0*.v_value.v_ulong);
			opSpecial(OP_SHIFT | 0 << 9 |
			    if reversible then
				make(1 << 8, uint)
			    else
				0 << 8
			    fi |
			    size << 6 | 1 << 5 |
			    if wasConstant then
				make(0b00 << 3, uint)
			    else
				0b01 << 3
			    fi |
			    reg
			);
			DRegQueue[reg].r_desc.v_kind := VVOID;
			DRegUse[reg] := DRegUse[reg] + 1;
		    fi;
		else
		    /* shift by some unknown amount */
		    putInReg();
		    needRegs(0, 2);
		    freeDReg();
		    opSpecial(OP_SHIFT | make(d0*.v_value.v_reg, uint) << 9 |
			if reversible then
			    make(1 << 8, uint)
			else
			    0 << 8
			fi |
			size << 6 | 1 << 5 |
			if wasConstant then
			    make(0b00 << 3, uint)
			else
			    0b01 << 3
			fi |
			reg
		    );
		    DRegQueue[reg].r_desc.v_kind := VVOID;
		    DRegUse[reg] := DRegUse[reg] + 1;
		fi;
	    fi;
	fi;
	popDescriptor();
    od;
corp;

proc pBitAndXorShift()void:

    pBitNot();
    if isAXLR() then
	doBitAndXorShift();
    fi;
corp;

/*
 * pBitOr - parse and generate code for bitwise '|' operator
 */

proc doBitOr()void:
    bool wasConstant, vOp;

    if not isOp() then
	checkNumber();
    fi;
    while Token + '\e' = '|' do
	vOp := isOp();
	wasConstant := DescTable[0].v_kind = VNUMBER;
	if not wasConstant then
	    putInReg();
	fi;
	scan();
	pushDescriptor();
	pBitAndXorShift();
	if vOp or isOp() then
	    opCompat();
	    checkOp(OPIOR);
	else
	    checkNumber();
	    if wasConstant then
		wasConstant := reverseOps();
	    fi;
	    if wasConstant and DescTable[0].v_kind = VNUMBER then
		DescTable[1].v_value.v_ulong :=
		    DescTable[1].v_value.v_ulong |
		    DescTable[0].v_value.v_ulong;
	    else
		if DescTable[0].v_kind ~= VNUMBER or
		    DescTable[0].v_value.v_ulong ~= 0
		then
		    modedBinary(OP_OR);
		fi;
	    fi;
	    mergeTypes();
	fi;
	popDescriptor();
    od;
corp;

proc pBitOr()void:

    pBitAndXorShift();
    if Token + '\e' = '|' then
	doBitOr();
    fi;
corp;

/*
 * doAbsNeg - common code for unary '|' and unary '-'.
 */

proc doAbsNeg(bool isAbs)void:
    register *DESCRIPTOR d0;
    Float_t f;
    byte size;

    scan();
    pAbsNeg();
    if isOp() then
	checkOp(if isAbs then OPABS else OPNEG fi);
    else
	checkArith();
	d0 := &DescTable[0];
	if d0*.v_type = TYFLOAT then
	    if d0*.v_kind = VFLOAT then
		/* compile time evaluate for float */
		f.b_arr := d0*.v_value.v_float;
		enableMath();
		if isAbs then
		    _DPAbs(f.l_.l_lo, f.l_.l_hi, &d0*.v_value.v_float[0]);
		else
		    _DPNeg(f.l_.l_lo, f.l_.l_hi, &d0*.v_value.v_float[0]);
		fi;
	    else
		if d0*.v_kind ~= VREG then
		    if FloatBusy then
			/* something already in D0/D1 - stack it */
			opSpecial(OP_SAVEM | M_DEC << 3 | RSP);
			sourceWord(0xc000);
			DescTable[1].v_value.v_reg := 0xff;
		    fi;
		    putInReg();
		    floatRef(OP_RESTM, 0, d0);
		    d0*.v_kind := VREG;
		    d0*.v_value.v_reg := 0;
		    FloatBusy := true;
		fi;
		floatEntry(
		    if isAbs then LVO_IEEEDP_ABS else LVO_IEEEDP_NEG fi);
	    fi;
	else
	    size := getSize(d0*.v_type);
	    if d0*.v_kind = VNUMBER then
		/* compile time evaluate */
		d0*.v_value.v_ulong :=
		    if isAbs then
			| d0*.v_value.v_ulong
		    else
			- d0*.v_value.v_ulong
		    fi;
	    else
		if isAbs then
		    /* make sure there is a move to test the value */
		    forgetRegs();
		fi;
		putInReg();
		if isAbs then
		    /* use of OptKludgeFlag2 tells 'opSingle' in 'codeOp.d' to
		       treat this as special - delete the TST when OK, but
		       don't replace a previous 'MOV' with the TST' */
		    OptKludgeFlag2 := true;
		    opSingle(OP_TST, size,
			M_DDIR << 3 | d0*.v_value.v_reg);
		    OptKludgeFlag2 := false;
		    opBranch(CC_GE, 2);
		fi;
		opSingle(OP_NEG, size,
		    M_DDIR << 3 | d0*.v_value.v_reg);
	    fi;
	    if not isSigned(d0*.v_type) then
		d0*.v_type :=
		    if size = S_BYTE then
			TYSHORT
		    elif size = S_WORD then
			TYINT
		    else
			TYLONG
		    fi;
	    fi;
	fi;
    fi;
corp;

/*
 * pAbsNeg - parse and generate code for the unary '|' and '-' operators
 */

proc pAbsNeg()void:

    if Token + '\e' = '+' then
	scan();
	pAbsNeg();
    elif Token + '\e' = '-' then
	doAbsNeg(false);
    elif Token + '\e' = '|' then
	doAbsNeg(true);
    else
	pBitOr();
    fi;
corp;

/*
 * evalMDM - part of pMulDivMod that handles constant evaluation.
 */

proc evalMDM(ushort tokenSave; bool lSigned; register ulong leftValueU)void:
    register *byte trapPointer;
    register ulong rightValueU;
    register long leftValueS @ leftValueU, rightValueS @ rightValueU;
    [2] char buff;
    char c;

    rightValueU := DescTable[0].v_value.v_ulong;
    DescTable[1].v_value.v_ulong :=
	if tokenSave + '\e' = '*' then
	    if lSigned then
		leftValueS * rightValueS
	    else
		leftValueU * rightValueU
	    fi
	elif tokenSave + '\e' = '/' then
	    if lSigned then
		leftValueS / rightValueS
	    else
		leftValueU / rightValueU
	    fi
	else
	    if leftValueU = 0L0 and rightValueU = 0L0 and
		    Line = 1 then
		if GOTCOPY then
		    buff[1] := '\e';
		    trapPointer := pretend(Trap, *byte);
		    while
			c := trapPointer* >< TMASK & 0x7f + '\e';
			trapPointer := trapPointer + 1;
			c ~= '\e'
		    do
			buff[0] := c;
			printString(&buff[0]);
		    od;
		fi;
		0L0
	    else
		if lSigned then
		    leftValueS % rightValueS
		else
		    leftValueU % rightValueU
		fi
	    fi
	fi;
    DescTable[1].v_kind := VNUMBER;
    mergeTypes();
    popDescriptor();
corp;

/*
 * genMDM - part of pMulDivMod that does actual code generation.
 */

proc genMDM(ushort tokenSave; bool lSigned; byte lSize)void:
    *char
	MUL32 = "\e23lum_d_", MUL322 = "\e223lum_d_",
	DIV32S = "\es23vid_d_", DIV32U = "\eu23vid_d_",
	DIV32U2 = "\e2u23vid_d_";
    register *DESCRIPTOR d0, d1;
    byte rSize;
    register uint reg;
    TYPENUMBER t1, t2;

    d0 := &DescTable[0];
    d1 := d0 + sizeof(DESCRIPTOR);
    rSize := getSize(d0*.v_type);
    if lSize = S_LONG and d0*.v_kind = VNUMBER and not lSigned and
	tokenSave + '\e' ~= '%' and not isSigned(d0*.v_type) and
	d0*.v_value.v_ulong <= 65535
    then
	fixSizeReg(TYUINT);
	reg := d0*.v_value.v_reg;
	popDescriptor();
	fixSizeReg(TYULONG);
	needRegs(0, 2);
	opMove(OP_MOVEW, M_DDIR << 3 | reg, M_DDIR << 3 | 1);
	opMove(OP_MOVEL, M_DDIR << 3 | d0*.v_value.v_reg,
	       M_DDIR << 3 | 0);
	/* note that we do NOT save/restore A1 - it is not clobbered */
	genCall(
	    if tokenSave + '\e' = '*' then
		MUL322
	    else
		DIV32U2
	    fi
	);
	freeDReg();
	opMove(OP_MOVEL, M_DDIR << 3 | 0, M_DDIR << 3 | d0*.v_value.v_reg
	);
    elif rSize = S_LONG or lSize = S_LONG then
	fixSizeReg(TYULONG);
	reg := d0*.v_value.v_reg;
	t1 := d1*.v_type;
	mergeTypes();
	t2 := d1*.v_type;
	d1*.v_type := t1;
	popDescriptor();
	fixSizeReg(TYULONG);
	d0*.v_type := t2;
	needRegs(0, 2);
	opMove(OP_MOVEL, M_DDIR << 3 | reg, M_DDIR << 3 | 1);
	opMove(OP_MOVEL, M_DDIR << 3 | d0*.v_value.v_reg,
	    M_DDIR << 3 | 0);
	/* note: we do not save/restore A1 */
	genCall(
	    if tokenSave + '\e' = '*' then
		MUL32
	    else
		if lSigned then DIV32S else DIV32U fi
	    fi
	);
	freeDReg();
	opMove(OP_MOVEL,
	    M_DDIR << 3 |
		if tokenSave = '%' - '\e' then make(1, uint) else 0 fi,
	    M_DDIR << 3 | d0*.v_value.v_reg
	);
    else
	if d0*.v_kind ~= VREG and d1*.v_kind ~= VREG then
	    putInReg();
	fi;
	if d0*.v_kind = VREG and d1*.v_kind ~= VREG then
	    swap();
	fi;
	reg := d1*.v_value.v_reg;
	pretend(sizeIt(reg, d1*.v_type,
		if tokenSave + '\e' = '*' then TYUINT else TYULONG fi),void);
	mergeTypes();
	if rSize ~= S_WORD then
	    fixSizeReg(TYUINT);
	fi;
	opTail(OPT_REGISTER,
	    if tokenSave + '\e' = '*' then
		if lSigned then OP_MULS else OP_MULU fi
	    else
		if lSigned then OP_DIVS else OP_DIVU fi
	    fi,
	    0, reg, false, true
	);
	if tokenSave + '\e' = '%' then
	    opSpecial(OP_SWAP | reg);
	    /* value already zapped by the call in opTail */
	    DRegUse[reg] := DRegUse[reg] + 1;
	fi;
	popDescriptor();
    fi;
corp;

/*
 * pMulDivMod - parse and generate code for '*', '/' and '%' binary ops
 */

proc doMulDivMod()void:
    register *DESCRIPTOR d0, d1;
    STATE stateSave;
    Float_t l, r;
    register ulong val;
    register ushort tokenSave;
    ushort pow;
    register byte lSize;
    bool wasConstant, lSigned, rSigned, reversible, vOp;

    if not isOp() then
	checkArith();
    fi;
    while Token + '\e' = '*' or Token + '\e' = '/' or Token + '\e' = '%' do
	d0 := &DescTable[0];
	d1 := d0 + sizeof(DESCRIPTOR);
	vOp := isOp();
	save(&stateSave);
	wasConstant := d0*.v_kind = VNUMBER or d0*.v_kind = VFLOAT;
	val := d0*.v_value.v_ulong;
	reversible := wasConstant and Token + '\e' = '*';
	if d0*.v_type = TYFLOAT and hasIndex(d0) then
	    putAddrInReg();
	    makeIndir();
	    wasConstant := false;
	elif not reversible or vOp then
	    putInReg();
	fi;
	tokenSave := Token;
	scan();
	pushDescriptor();
	pAbsNeg();
	if vOp or isOp() then
	    opCompat();
	elif d0*.v_type = TYFLOAT and tokenSave + '\e' = '%' then
	    errorThis(170);
	    tokenSave := '/' - '\e';
	else
	    checkArith();
	    if reversible then
		wasConstant := reverseOps();
	    fi;
	fi;
	lSigned := isSigned(d1*.v_type);
	rSigned := isSigned(d0*.v_type);
	lSigned :=
	    if not wasConstant and d0*.v_kind = VNUMBER then
		lSigned
	    elif wasConstant and d0*.v_kind ~= VNUMBER then
		rSigned
	    else
		lSigned or rSigned
	    fi;
	if d0*.v_kind = VNUMBER and tokenSave + '\e' ~= '*' and
	    d0*.v_value.v_ulong = 0L0
	then
	    errorThis(105);
	fi;
	if wasConstant and d0*.v_kind = VNUMBER then
	    /* compile time evaluate if possible */
	    restore(&stateSave, true);
	    evalMDM(tokenSave, lSigned, val);
	elif vOp or isOp() then
	    checkOp(
		if tokenSave + '\e' = '*' then
		    OPMUL
		elif tokenSave + '\e' = '/' then
		    OPDIV
		else
		    OPMOD
		fi
	    );
	    popDescriptor();
	elif d0*.v_type = TYFLOAT or d1*.v_type = TYFLOAT then
	    if d0*.v_type ~= TYFLOAT or d1*.v_type ~= TYFLOAT then
		errorBack(173);
	    elif wasConstant and d0*.v_kind = VFLOAT then
		/* compile time evaluate for floats */
		restore(&stateSave, true);
		enableMath();
		l.b_arr := d1*.v_value.v_float;
		r.b_arr := d0*.v_value.v_float;
		if tokenSave + '\e' = '*' then
		    _DPMul(r.l_.l_lo, r.l_.l_hi, l.l_.l_lo, l.l_.l_hi,
			    &d1*.v_value.v_float[0]);
		else
		    _DPDiv(r.l_.l_lo, r.l_.l_hi, l.l_.l_lo, l.l_.l_hi,
			    &d1*.v_value.v_float[0]);
		fi;
	    else
		floatBinary(
		    if tokenSave + '\e' = '*' then
			LVO_IEEEDP_MUL
		    else
			LVO_IEEEDP_DIV
		    fi);
	    fi;
	    popDescriptor();
	else
	    shrinkConsts();
	    lSize := getSize(d1*.v_type);
	    /* shrinkConsts may have changed val */
	    val := d0*.v_value.v_ulong;
	    if d0*.v_kind = VNUMBER and isPower2(val, &pow) then
		popDescriptor();
		if val = 1 then
		    ;
		elif tokenSave + '\e' = '*' then
		    putInReg();
		    shift(d0*.v_value.v_reg, lSize, true, lSigned, pow);
		elif tokenSave + '\e' = '/' then
		    if lSigned then
			/* signed division needs a bit of a fixup. E.g.
			   -1 shifted right arithmetic will always give
			   -1, whereas it should give 0. The proper fix is
			   to round them the other way by adding b-1 first if
			   they are negative. Note that we are relying on
			   the fact that the condition code is currently set
			   to represent the value we are dividing into. 
			   The way this compiler generates code, this will
			   be true, so long as we don't get mucked up by the
			   remembering, hence the forgetRegs before the call
			   to putInReg. */
			forgetRegs();
			putInReg();
			peepFlush();
			if val <= 8 then
			    /* rats, there is a limit to ADDQ */
			    branchTo(CC_GE, ProgramNext + 4);
			    opQuick(OP_ADDQ, val - 1, lSize,
				    M_DDIR << 3 | d0*.v_value.v_reg);
			else
			    branchTo(CC_GE, ProgramNext +
				if lSize = S_LONG then
				    8
				else
				    6
				fi);
			    opSingle(OP_ADDI, lSize,
				     M_DDIR << 3 | d0*.v_value.v_reg);
			    if lSize = S_LONG then
				sourceLong(val - 1);
			    else
				sourceWord(val - 1);
			    fi;
			fi;
		    else
			putInReg();
		    fi;
		    shift(d0*.v_value.v_reg, lSize, false, lSigned, pow);
		else
		    /* a similar fixup is needed for signed modulo */
		    if lSigned then
			forgetRegs();
			putInReg();
			peepFlush();
			branchTo(CC_GE,
			    ProgramNext + if lSize = S_LONG then 14 else 12 fi
			);
			opSingle(OP_NEG, lSize,
				 M_DDIR << 3 | d0*.v_value.v_reg);
			opSingle(OP_ANDI, lSize,
				 M_DDIR << 3 | d0*.v_value.v_reg);
			if lSize <= S_WORD then
			    sourceWord(val - 0L1);
			else
			    sourceLong(val - 0L1);
			fi;
			opSingle(OP_NEG, lSize,
				 M_DDIR << 3 | d0*.v_value.v_reg);
			peepFlush();
			branchTo(CC_T,
			    ProgramNext + if lSize = S_LONG then 8 else 6 fi);
		    else
			putInReg();
		    fi;
		    opSingle(OP_ANDI, lSize,
			M_DDIR << 3 | d0*.v_value.v_reg);
		    if lSize <= S_WORD then
			sourceWord(val - 0L1);
		    else
			sourceLong(val - 0L1);
		    fi;
		fi;
	    else
		genMDM(tokenSave, lSigned, lSize);
	    fi;
	fi;
    od;
corp;

proc pMulDivMod()void:

    pAbsNeg();
    if Token + '\e' = '*' or Token + '\e' = '/' or Token + '\e' = '%' then
	doMulDivMod();
    fi;
corp;

/*
 * checkPlusMinusOp - check the kind of an operand for '+' or '-'.
 */

proc checkPlusMinusOp()void:
    register TYPENUMBER t;

    t := DescTable[0].v_type;
    if baseKind(t) >= TY_FILE and t ~= TYERROR and t ~= TYBYTE and
	    t ~= TYFLOAT or t = TYNIL then
	errorBack(101);
    fi;
corp;

/*
 * pMType - figure out and set in the result type for add/subtract.
 */

proc pMType(bool isPlus)TYPENUMBER:
    register TYPENUMBER tLeft, tRight;
    TYPEKIND kLeft, kRight;
    byte lSize;
    bool lSpecial, rSpecial;

    tLeft := DescTable[1].v_type;
    tRight := DescTable[0].v_type;
    if tRight = TYFLOAT or tLeft = TYFLOAT then
	TYFLOAT
    else
	lSize := getSize(tLeft);
	kLeft := baseKind(tLeft);
	lSpecial := kLeft = TY_POINTER or kLeft = TY_ENUM;
	kRight := baseKind(tRight);
	rSpecial := kRight = TY_POINTER or kRight = TY_ENUM;
	if rSpecial or lSpecial then
	    if lSpecial and rSpecial and (isPlus or tLeft ~= tRight) then
		errorBack(102);
	    fi;
	    if kLeft = kRight then
		if lSize = S_BYTE then
		    TYUSHORT
		elif lSize = S_WORD then
		    TYUINT
		else
		    TYULONG
		fi
	    elif lSpecial then
		tLeft
	    else
		tRight
	    fi
	else
	    shrinkConsts();
	    TYUNKNOWN
	fi
    fi
corp;

/*
 * pMCode - actually generate code for add/subtract.
 */

proc pMCode(bool isPlus)void:
    register *DESCRIPTOR d0, d1;
    uint opCode;
    ushort reg;
    byte lSize, rSize;

    d0 := &DescTable[0];
    d1 := d0 + sizeof(DESCRIPTOR);
    lSize := getSize(d1*.v_type);
    rSize := getSize(d0*.v_type);
    opCode := if isPlus then OP_ADD else OP_SUB fi;
    if lSize = S_LADDR then
	if d0*.v_kind = VNUMBER then
	    addrCon(isPlus, d1*.v_value.v_reg, d0*.v_value.v_ulong);
	elif rSize = S_LADDR then
	    /* subtracting two pointers - move the first to a D reg, and do
	       the subtract from there. This can avoid using an A reg */
	    reg := getDReg();
	    opMove(OP_MOVEL, M_ADIR << 3 | d1*.v_value.v_reg,
		   M_DDIR << 3 | reg);
	    freeAReg();
	    opTail(OPT_MODED, opCode, S_LONG, reg, false, true);
	    d1*.v_value.v_reg := reg;
	    d1*.v_type := TYULONG;
	else
	    if rSize = S_BYTE then
		rSize := S_WORD;
		fixSizeReg(TYUINT);
	    fi;
	    opTail(OPT_MODED, opCode,
		if rSize = S_WORD then S_SADDR else S_LADDR fi,
		d1*.v_value.v_reg, true, false
	    );
	fi;
    else
	if d0*.v_kind = VNUMBER and d0*.v_value.v_ulong <= 0L8 then
	    if d0*.v_value.v_ulong ~= 0L0 then
		opQuick(
		    if isPlus then OP_ADDQ else OP_SUBQ fi,
		    make(d0*.v_value.v_ulong, ushort) & 7,
		    lSize, M_DDIR << 3 | d1*.v_value.v_reg
		);
	    fi;
	else
	    if rSize = S_LADDR then
		pretend(sizeIt(d1*.v_value.v_reg, d1*.v_type, TYLONG), void);
		opTail(OPT_MODED, opCode, S_LONG, d1*.v_value.v_reg,
			false, true);
		/* move it to an address reg */
		d0*.v_value.v_reg := d1*.v_value.v_reg;
		d1*.v_value.v_reg := getAReg();
		/* do this BEFORE the opMove, so that the needRegs will use
		   the type that we now want, based on the above register
		   switch-around */
		d0*.v_type := d1*.v_type;
		d1*.v_type := TYCHARS;
		opMove(OP_MOVEL,
		    M_DDIR << 3 | d0*.v_value.v_reg,
		    M_ADIR << 3 | d1*.v_value.v_reg
		);
		freeDReg();
	    else
		modedBinary(opCode);
	    fi;
	fi;
    fi;
corp;

/*
 * pPlusMinus - parse and generate code for binary '+' and '-' operators
 */

proc doPlusMinus()void:
    register *DESCRIPTOR d0, d1;
    STATE stateSave;
    Float_t l, r;
    ulong leftValue;
    register TYPENUMBER tRes;
    bool wasConstant, isPlus, reversible, vOp;

    if not isOp() then
	checkPlusMinusOp();
    fi;
    while Token + '\e' = '+' or Token + '\e' = '-' do
	d0 := &DescTable[0];
	d1 := d0 + sizeof(DESCRIPTOR);
	isPlus := Token + '\e' = '+';
	vOp := isOp();
	save(&stateSave);
	leftValue := d0*.v_value.v_ulong;
	wasConstant := d0*.v_kind = VNUMBER or d0*.v_kind = VFLOAT;
	reversible := wasConstant and isPlus;
	if d0*.v_type = TYFLOAT and hasIndex(d0) then
	    putAddrInReg();
	    makeIndir();
	    wasConstant := false;
	elif not reversible then
	    putInReg();
	fi;
	scan();
	pushDescriptor();
	pMulDivMod();
	if vOp or isOp() then
	    opCompat();
	else
	    checkPlusMinusOp();
	    if reversible then
		wasConstant := reverseOps();
	    fi;
	fi;
	tRes := pMType(isPlus);
	if d0*.v_kind = VNUMBER and wasConstant then
	    /* compile time evaluate when possible */
	    restore(&stateSave, true);
	    d1*.v_kind := VNUMBER;
	    d1*.v_value.v_ulong :=
		if isPlus then
		    leftValue + d0*.v_value.v_ulong
		else
		    leftValue - d0*.v_value.v_ulong
		fi;
	elif tRes = TYFLOAT then
	    if d0*.v_type ~= TYFLOAT or d1*.v_type ~= TYFLOAT then
		errorBack(173);
	    elif d0*.v_kind = VFLOAT and wasConstant then
		/* compile time evaluate for floats */
		restore(&stateSave, true);
		enableMath();
		l.b_arr := d1*.v_value.v_float;
		r.b_arr := d0*.v_value.v_float;
		if isPlus then
		    _DPAdd(r.l_.l_lo, r.l_.l_hi, l.l_.l_lo, l.l_.l_hi,
			    &d1*.v_value.v_float[0]);
		else
		    _DPSub(r.l_.l_lo, r.l_.l_hi, l.l_.l_lo, l.l_.l_hi,
			    &d1*.v_value.v_float[0]);
		fi;
	    else
		floatBinary(
		    if isPlus then LVO_IEEEDP_ADD else LVO_IEEEDP_SUB fi);
	    fi;
	elif vOp or isOp() then
	    checkOp(if isPlus then OPADD else OPSUB fi);
	else
	    wasConstant := false;
	    pMCode(isPlus);
	fi;
	if tRes = TYFLOAT or vOp or isOp() then
	    popDescriptor();
	elif tRes ~= TYUNKNOWN then
	    popDescriptor();
	    if not wasConstant then
		/* want to fix the size to the needed size (e.g. down to
		   a 'char', but don't do it for constants, since we
		   don't want to stack them. */
		fixSizeReg(tRes);
	    fi;
	    d0*.v_type := tRes;
	else
	    tRes := d1*.v_type;
	    mergeTypes();
	    popDescriptor();
	    /* this seems to be needed in some awful error-recovery cases */
	    if isAddress(d0*.v_type) then
		if not isAddress(tRes) then
		    freeDReg();
		    d0*.v_value.v_reg := getAReg();
		fi;
	    else
		if isAddress(tRes) then
		    freeAReg();
		    d0*.v_value.v_reg := getDReg();
		fi;
	    fi;
	fi;
    od;
corp;

proc pPlusMinus()void:

    pMulDivMod();
    if Token + '\e' = '+' or Token + '\e' = '-' then
	doPlusMinus();
    fi;
corp;
