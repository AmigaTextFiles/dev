#draco.g
#externs.g

/* parse and code-gen or boolean constructs and assignment statement */

/* declare assembler interface stub to floating point code */

extern
    _DPCmp(long rlo, rhi, llo, lhi)int;

/*
 * pComparison - parse and generate code for comparison operators. This
 *		     routines tries to do a fair job, so is a bit complex
 */

proc doComparison()void:
    register *DESCRIPTOR d0, d1;
    uint wrd;
    register COMPARISONKIND resultCC;
    VALUEKIND leftKind;
    union {
	[8] byte f;
	struct {long hi, lo} l;
    } f1, f2;
    register int res;
    register byte lSize, rSize;
    byte mode;
    ushort reg;
    bool wasConstant, wasRegVar, tSigned, tOp, freeA, freeD;

    resultCC :=
	case Token
	incase '=' - '\e':
	    VEQ
	incase TNE:
	    VNE
	incase '>' - '\e':
	    VGT
	incase '<' - '\e':
	    VLT
	incase TGE:
	    VGE
	incase TLE:
	    VLE
	esac;
    d0 := &DescTable[0];
    d1 := d0 + sizeof(DESCRIPTOR);
    lSize := getSize(d0*.v_type);
    leftKind := d0*.v_kind;
    /* comparison doesn't change the operand, so we can use a register
       variable directly, without copying it to another register */
    wasConstant := leftKind = VNUMBER or leftKind = VFLOAT;
    wasRegVar := leftKind = VRVAR;
    if not wasConstant and not wasRegVar then
	if d0*.v_type = TYFLOAT and hasIndex(d0) then
	    putAddrInReg();
	    makeIndir();
	else
	    putInReg();
	fi;
    fi;
    scan();
    tOp := isOp();
    pushDescriptor();
    pPlusMinus();
    if isOp() then
	tOp := true;
    fi;
    tSigned := isSigned(d1*.v_type);
    if not tOp then
	assignCompat(d1*.v_type);
    fi;
    if isOp() and (
	    basePtr1(d0*.v_type)*.t_info.i_op*.op_ops & OPCPR = 0 or
	    not tOp) then
	errorBack(145);
    elif tSigned ~= isSigned(d0*.v_type) then
	/* if either side was number, classed as unsigned, then we just
	   re-classify it as signed. */
	if wasConstant and not tSigned then
	    d1*.v_type :=
		if lSize = S_BYTE then
		    TYSHORT
		elif lSize = S_WORD then
		    TYINT
		else
		    TYULONG
		fi;
	    tSigned := true;
	elif leftKind = VCONST and not tSigned or
		(d0*.v_kind = VNUMBER or d0*.v_kind = VCONST) and tSigned then
	    ;
	elif resultCC >= VGT then
	    errorBack(104);
	fi;
    fi;
    if wasConstant and d0*.v_kind = VNUMBER then
	/* can evaluate this comparison at compile time */
	d1*.v_value.v_ulong :=
	    if resultCC = VEQ then
		d1*.v_value.v_ulong = d0*.v_value.v_ulong
	    elif resultCC = VNE then
		d1*.v_value.v_ulong ~= d0*.v_value.v_ulong
	    else
		if tSigned then
		    case resultCC
		    incase VGT:
			d1*.v_value.v_long > d0*.v_value.v_long
		    incase VLT:
			d1*.v_value.v_long < d0*.v_value.v_long
		    incase VGE:
			d1*.v_value.v_long >= d0*.v_value.v_long
		    incase VLE:
			d1*.v_value.v_long <= d0*.v_value.v_long
		    esac
		else
		    case resultCC
		    incase VGT:
			d1*.v_value.v_ulong > d0*.v_value.v_ulong
		    incase VLT:
			d1*.v_value.v_ulong < d0*.v_value.v_ulong
		    incase VGE:
			d1*.v_value.v_ulong >= d0*.v_value.v_ulong
		    incase VLE:
			d1*.v_value.v_ulong <= d0*.v_value.v_ulong
		    esac
		fi
	    fi - false;
	d1*.v_kind := VNUMBER;
    elif tOp then
	opCompat();
	checkOp(OPCPR);
	opSingle(OP_TST, S_BYTE, M_DDIR << 3 | 0);
	d1*.v_kind := VCC;
	d1*.v_value.v_comparison :=
	    if resultCC >= VGT then
		resultCC + (VGTS - VGT)
	    else
		resultCC
	    fi;
    elif d1*.v_type = TYFLOAT then
	if wasConstant and d1*.v_kind = VFLOAT then
	    d1*.v_kind := VNUMBER;
	    f1.f := d1*.v_value.v_float;
	    f2.f := d0*.v_value.v_float;
	    enableMath();
	    res := _DPCmp(f2.l.lo, f2.l.hi, f1.l.lo, f1.l.hi);
	    d1*.v_value.v_long :=
		case resultCC
		incase VEQ:
		    res = 0
		incase VNE:
		    res ~= 0
		incase VGT:
		    res = +1
		incase VLT:
		    res = -1
		incase VGE:
		    res ~= -1
		incase VLE:
		    res ~= +1
		esac - false;
	else
	    floatBinary(LVO_IEEEDP_CMP);
	    FloatBusy := false;
	    d1*.v_kind := VCC;
	    if resultCC >= VGT then
		resultCC := resultCC + (VGTS - VGT);
	    fi;
	    d1*.v_value.v_comparison := resultCC;
	fi;
    else    /* have to do it the hard way - with real live code */
	rSize := getSize(d0*.v_type);
	if wasConstant or not wasRegVar and d0*.v_kind = VRVAR then
	    /* if left was constant, swap descriptors and comparison */
	    swap();
	    mode := lSize;
	    lSize := rSize;
	    rSize := mode;
	    if resultCC >= VGT then
		resultCC := (resultCC - VEQ) >< 1 + VEQ;
	    fi;
	fi;
	if tSigned and resultCC >= VGT then
	    resultCC := resultCC + (VGTS - VGT);
	fi;
	if lSize = S_LONG and d0*.v_kind = VNUMBER and
	    d0*.v_value.v_ulong ~= 0 and
	    d0*.v_value.v_long >= -128 and d0*.v_value.v_long <= 127
	then
	    opImm(0, d0*.v_value.v_long);
	    getMode(d1, &mode, &reg, &wrd, &freeA, &freeD);
	    opModed(OP_CMP, 0, OM_REG | S_LONG, mode << 3 | reg);
	    tailStuff(d1, false, mode, reg, wrd, freeA, freeD);
	    if resultCC >= VGT then
		resultCC := (resultCC - VEQ) >< 1 + VEQ;
	    fi;
	elif d0*.v_kind = VNUMBER then
	    getMode(d1, &mode, &reg, &wrd, &freeA, &freeD);
	    if lSize = S_LADDR then
		lSize := S_LONG;
	    fi;
	    if d0*.v_value.v_ulong = 0L0 then
		if mode = M_ADIR then
		    opMove(OP_MOVEL,
			M_ADIR << 3 | d1*.v_value.v_reg,
			M_DDIR << 3 | 0
		    );
		else
		    opSingle(OP_TST, lSize, mode << 3 | reg);
		fi;
	    else
		opSingle(OP_CMPI, lSize, mode << 3 | reg);
		if lSize = S_LONG then
		    sourceLong(d0*.v_value.v_ulong);
		else
		    sourceWord(d0*.v_value.v_ulong);
		fi;
	    fi;
	    tailStuff(d1, false, mode, reg, wrd, freeA, freeD);
	elif lSize = S_LADDR then
	    if rSize = S_LADDR then
		opTail(OPT_MODED, OP_CMP, S_LADDR, d1*.v_value.v_reg,
		    d1*.v_kind = VREG, false);
	    else
		putInReg();
		freeDReg();
	    fi;
	    if d1*.v_kind = VREG then
		freeAReg();
	    fi;
	elif rSize = S_LADDR then
	    putInReg();
	    freeAReg();
	    if d1*.v_kind = VREG then
		freeDReg();
	    fi;
	else
	    modedBinary(OP_CMP);
	    if d1*.v_kind = VREG then
		freeDReg();
	    fi;
	fi;
	d1*.v_kind := VCC;
	d1*.v_value.v_comparison := resultCC;
    fi;
    /* result of comparison is a bool value */
    popDescriptor();
    d0*.v_type := TYBOOL;
corp;

proc pComparison()void:

    pPlusMinus();
    if Token = '=' - '\e' or Token = '>' - '\e' or Token = '<' - '\e' or
	Token = TGE or Token = TLE or Token = TNE
    then
	doComparison();
    fi;
corp;

/*
 * pBoolNot - parse and generate code for the boolean not operator
 */

proc doBoolNot()void:
    register *DESCRIPTOR d0;
    register ushort notCount;

    d0 := &DescTable[0];
    notCount := 0;
    while Token = TNOT do
	scan();
	notCount := notCount + 1;
    od;
    pComparison();
    if d0*.v_type ~= TYBOOL and d0*.v_type ~= TYIORESULT and
	    d0*.v_type ~= TYERROR then
	errorBack(106);
    fi;
    if d0*.v_kind = VNUMBER then
	/* evaluate expression at compile time */
	if notCount & 1 ~= 0 then   /* only flip if odd # 'not's */
	    d0*.v_value.v_ulong := d0*.v_value.v_ulong >< 0L1;
	    reverseChains();
	fi;
    else
	if d0*.v_kind ~= VCC then
	    /* the value we had was not a condition code setting, hence
	       we must produce one, in order to invert the branches.
	       However, we do not want to do this for a simple boolean
	       variable - a test of the variable is better. */
	    if d0*.v_kind >= VRVAR and d0*.v_kind <= VAVAR then
		opTail(OPT_SINGLE, OP_TST, S_BYTE, 0, false, false);
	    else
		putInReg();
		forceData();
		opSingle(OP_TST, S_BYTE, M_DDIR << 3 | d0*.v_value.v_reg);
		freeDReg();
	    fi;
	    d0*.v_kind := VCC;
	    d0*.v_value.v_comparison := VNE;
	fi;
	if notCount & 1 ~= 0 then
	    /* if we have an odd # of 'not's then we 'perform' the
	       operation by notting the condition tested by the VCC
	       branch and by interchanging TrueChain and FalseChain */
	    notCount := d0*.v_value.v_comparison - VEQ;
	    d0*.v_value.v_comparison :=
		if notCount + VEQ <= VNE then
		    VNE + (VEQ - VEQ)
		elif notCount + VEQ <= VLE then
		    VLE + (VGT - VEQ)
		else
		    VLES + (VGTS - VEQ)
		fi - notCount;
	    reverseChains();
	fi;
    fi;
    d0*.v_type := TYBOOL;
corp;

proc pBoolNot()void:

    if Token = TNOT then
	doBoolNot();
    else
	pComparison();
    fi;
corp;

/*
 * checkBool - small routine common for boolean 'and' and 'or'.
 */

proc checkBool()void:
    register *DESCRIPTOR d0;

    d0 := &DescTable[0];
    if d0*.v_type ~= TYERROR and d0*.v_type ~= TYBOOL and
	    d0*.v_type ~= TYIORESULT then
	errorBack(107);
    fi;
    if d0*.v_kind = VNUMBER then
	putInReg();	/* force 'condition' to make code */
    fi;
    d0*.v_type := TYBOOL;
corp;

/*
 * boolAndOr - common routine to handle boolean and/or.
 */

proc boolAndOr(ushort token; *uint chainP, other;
	       bool cond; proc()void lower)void:
    *ushort regStackPos;
    register uint branchPosition;
    uint branchChain;
    bool hadExpr;

    /* we have to get the position BEFORE any expressions, since the first
       expression might push things in its later parts that are not pushed
       in its earlier parts, thus we need the earliest possible regStackPos
       to restore everybody to */
    regStackPos := NextRegStack;
    lower();
    branchChain := BRANCH_NULL; 	/* no branches yet */
    hadExpr := false;
    while Token = token do
	hadExpr := true;
	/* if the boolean expression resulted in some pushing of registers
	   onto the stack, we want to undo that pushing, so that the various
	   branches coming out of and/or groups will all have the same
	   set of registers when they come together. Unfortunately, the moves
	   that we use clobber the condition codes, so we have to save them. */
	if NextRegStack ~= regStackPos then
	    putInReg();
	    fixTo(regStackPos);
	fi;
	/* test the left condition, saving the position of its jump */
	branchPosition := condition(cond);
	scan();
	if not Ignore and branchPosition ~= BRANCH_NULL then
	    /* if we are generating code, then add the just produced branch
	       to the front of the existing branchChain. Note -
	       'shortenBranches' wants them in strictly reverse order */
	    (&ProgramBuffWord[0] + branchPosition)* := chainP*;
	    chainP* := branchPosition;
	    while (&ProgramBuffWord[0] + branchPosition)* ~= BRANCH_NULL do
		branchPosition := (&ProgramBuffWord[0] + branchPosition)*;
	    od;
	    (&ProgramBuffWord[0] + branchPosition)* := branchChain;
	    branchChain := chainP*;
	fi;
	/* fix up all other branches to come here (just before right opnd) */
	if other* ~= BRANCH_NULL then
	    forgetRegs();
	    fixChain(other*);
	fi;
	TrueChain := BRANCH_NULL;
	FalseChain := BRANCH_NULL;
	lower();		/* get the right operand */
	checkBool();
	/* repeat for all right operands, treating the entire left part as
	   the new left operand (chain has been merged to make it so) */
    od;
    if hadExpr and NextRegStack ~= regStackPos then
	putInReg();
	fixTo(regStackPos);
    fi;
    /* add any branches produced by the last operand to the chain,
       leaving the entire thing in global chain */
    if chainP* = BRANCH_NULL then
	chainP* := branchChain;
    else
	/* again, 'shortenBranches' wants it in reverse order */
	branchPosition := chainP*;
	while (&ProgramBuffWord[0] + branchPosition)* ~= BRANCH_NULL do
	    branchPosition := (&ProgramBuffWord[0] + branchPosition)*;
	od;
	(&ProgramBuffWord[0] + branchPosition)* := branchChain;
    fi;
corp;

/*
 * pBoolAnd - parse and generate code for the boolean 'and' operator
 */

proc pBoolAnd()void:

    boolAndOr(TAND, &FalseChain, &TrueChain, false, pBoolNot);
corp;

/*
 * pBoolOr - parse and generate code for the boolean 'or' operator
 */

proc pBoolOr()void:

    boolAndOr(TOR, &TrueChain, &FalseChain, true, pBoolAnd);
corp;

/*
 * pAssignment - parse and generate code for the assignment statement.
 *		     This routine is the top of the recursive descent parser
 */

proc needsA0(register *DESCRIPTOR d)bool:
    register VALUEKIND kind;

    kind := d*.v_kind;
    if d*.v_index = NOINDEX then
	kind = VINDIR and d*.v_value.v_indir.v_offset > 0x7fff
    else
	if kind = VDVAR or kind = VPAR then
	    d*.v_value.v_long + ParSize + 8 < -128
	elif kind = VINDIR then
	    d*.v_value.v_indir.v_offset > 127
	else
	    kind = VCONST or kind = VGVAR or kind = VFVAR or kind = VLVAR or
	    kind = VAVAR or kind = VEXTERN
	fi
    fi
corp;

proc doAssignment()void:
    register *DESCRIPTOR d0, d1;
    register *REGQUEUE r;
    *BRENTRY brStart;
    register ulong byteSize;
    uint lWrd, rWrd;
    uint peepTotalSave;
    register VALUEKIND lKind;
    byte lMode, rMode;
    ushort lReg, rReg;
    bool lFreeA, lFreeD, rFreeA, rFreeD;
    register byte size;
    bool isBig, isAddr, pushedA1;

    d0 := &DescTable[0];
    d1 := d0 + sizeof(DESCRIPTOR);
    isBig := not isSimple(d0*.v_type);
    lKind := d0*.v_kind;
    /* NOTE: lKind is not used in any of the three special cases, so we don't
       have to worry about updating it after a 'putInReg', etc. */
    if lKind <= VCONST or lKind = VCC or lKind = VREG then
	if lKind ~= VERROR then
	    errorBack(108);
	fi;
	d0*.v_kind := VDVAR;
    fi;
    if isOp() then
	pushedA1 := A1Busy();
	if pushedA1 then
	    opMove(OP_MOVEL, M_ADIR << 3 | 1, M_DEC << 3 | RSP);
	fi;
	putAddrInReg();
	opMove(OP_MOVEL, M_ADIR << 3 | d0*.v_value.v_reg,
	       M_DEC << 3 | RSP);
	freeAReg();
    elif d0*.v_type = TYFLOAT then
	if hasIndex(d0) then
	    putAddrInReg();
	    makeIndir();
	fi;
    elif isBig then
	putAddrInReg();
    fi;
    scan();	    /* past the ':=' */
    pushDescriptor();
    brStart := BranchTableNext;
    pBoolOr();		    /* get the right-hand-side */
    assignCompat(d1*.v_type);
    if isOp() then
	putInReg();
	genOpCall("pop");
	if pushedA1 then
	    opMove(OP_MOVEL, M_INC << 3 | RSP, M_ADIR << 3 | 1);
	fi;
    elif d1*.v_type = TYFLOAT then
	if hasIndex(d0) then
	    putAddrInReg();
	    makeIndir();
	    if d1*.v_kind = VINDIR then
		if d1*.v_value.v_indir.v_base <= ARTop then
		    needRegs(2, 0);
		else
		    needRegs(1, 0);
		fi;
	    fi;
	fi;
	if d0*.v_kind ~= VREG then
	    if FloatBusy then
		/* something already in D0/D1 - save it */
		opSpecial(OP_SAVEM | M_DEC << 3 | RSP);
		sourceWord(0xc000);
		DescTable[2].v_value.v_reg := 0xff;
	    fi;
	    floatRef(OP_RESTM, 0, d0);
	    /* floatRef will free the A reg if needed */
	fi;
	floatRef(OP_SAVEM, 0, d1);
	/* floatRef will free the A reg if needed */
	FloatBusy := false;
    elif isBig then
	putAddrInReg();
	/* do in one piece so doing source doesn't change our setup */
	needRegs(2, 0);
	byteSize := typeSize(d0*.v_type);
	if byteSize <= 0L128 then
	    opImm(0, byteSize - 1);
	elif byteSize <= 0x10000 then
	    opMove(OP_MOVEW, M_SPECIAL << 3 | M_IMM, M_DDIR << 3 | 0);
	    sourceWord(byteSize - 1);
	else
	    opMove(OP_MOVEL, M_SPECIAL << 3 | M_IMM, M_DDIR << 3 | 0);
	    sourceLong(byteSize);
	fi;
	opMove(OP_MOVEB, M_INC << 3 | d0*.v_value.v_reg,
			 M_INC << 3 | d1*.v_value.v_reg);
	if byteSize <= 0x10000 then
	    /* use a DBCC loop */
	    peepFlush();
	    genWord(OP_DBcc | make(CC_F, uint) << 8 | 0);
	    genWord(pretend(-4, uint));
	else
	    opQuick(OP_SUBQ, 1, S_LONG, M_DDIR << 3 | 0);
	    opBranch(CC_NE, -6);
	fi;
	ARegQueue[d0*.v_value.v_reg].r_desc.v_kind := VVOID;
	ARegQueue[d1*.v_value.v_reg].r_desc.v_kind := VVOID;
	freeAReg();
	freeAReg();
    else
	/* if LHS and RHS are indexed and would need to use A0 as a temporary,
	   we must do a two-step assignment */
	size := getSize(d1*.v_type);
	if d0*.v_kind ~= VNUMBER and getSize(d0*.v_type) ~= size or
	    d0*.v_kind = VCC or
	    TrueChain ~= BRANCH_NULL or FalseChain ~= BRANCH_NULL or
	    needsA0(d0) and needsA0(d1)
	then
	    fixSizeReg(d1*.v_type);
	    shortenBranches(brStart);
	fi;
	if d0*.v_kind = VNUMBER and d0*.v_value.v_ulong = 0L0 then
	    popDescriptor();
	    opTail(OPT_SINGLE, OP_CLR,
		if size = S_LADDR then S_LONG else size fi,
		0, false, false);
	    pushDescriptor();
	else
	    isAddr := isAddress(d1*.v_type);
	    if size = S_LONG and d0*.v_kind = VNUMBER and
		d0*.v_value.v_long >= -0L128 and d0*.v_value.v_long <= 0L127 or
		isAvailable()
	    then
		/* MOVEQ/MOVE is shorter/faster; also if the value is
		   already in a register, just use it */
		putInReg();
	    fi;
	    getMode(d1, &lMode, &lReg, &lWrd, &lFreeA, &lFreeD);
	    getMode(d0, &rMode, &rReg, &rWrd, &rFreeA, &rFreeD);
	    needRegs((lFreeA - false) + (rFreeA - false),
		     (lFreeD - false) + (rFreeD - false)
	    );
	    peepTotalSave := PeepTotal;
	    OptKludgeFlag1 := false;
	    opMove(
		if size = S_BYTE then
		    OP_MOVEB
		elif size = S_WORD then
		    OP_MOVEW
		else
		    OP_MOVEL
		fi,
		rMode << 3 | rReg,
		lMode << 3 | lReg
	    );
	    tailStuff(d0,  true, rMode, rReg, rWrd, rFreeA, rFreeD);
	    tailStuff(d1, false, lMode, lReg, lWrd, lFreeA, lFreeD);
	    if PeepTotal > peepTotalSave then
		/* Now remove any OTHER indication of the variable
		   (it is now out of date). We only do it if our move
		   instruction actually did get generated. */
		r := if isAddr then ARegFreeHead else DRegFreeHead fi;
		while r ~= nil do
		    if r*.r_desc.v_kind = lKind and
			r*.r_desc.v_value.v_ulong = d1*.v_value.v_ulong
		    then
			r*.r_desc.v_kind := VVOID;
		    fi;
		    r := r*.r_next;
		od;
		if d0*.v_kind = VREG and
		    (lKind = VDVAR or lKind = VFVAR or
		     lKind = VGVAR or lKind = VAVAR) and
		    d0*.v_index = NOINDEX and not OptKludgeFlag1
		then
		    /* remember that the current value of this variable is in
		       the register. We very carefully do this after calling
		       'opMove', so that the clearing done there will be
		       overidden. Bug-fix: do not do the remembering if the
		       LHS is a register variable. It might be mapped with
		       other variables (using '@'), and can thus be modified
		       in ways we do not see, via that aliasing. Hmm. This
		       applies to all kinds of variables! Ick. However, this
		       is much more likely for register variables, and in
		       that case, I've seen worse code generated if we do
		       not just go directly to the register of the variable. */
		    r :=
			if isAddr then
			    &ARegQueue[d0*.v_value.v_reg]
			else
			    &DRegQueue[d0*.v_value.v_reg]
			fi;
		    r*.r_desc.v_kind := lKind;
		    r*.r_desc.v_value.v_ulong := d1*.v_value.v_ulong;
		    /* the register will be appropriately placed on the free
		       queue when it is freed */
		fi;
	    fi;
	fi;
    fi;
    popDescriptor();
    voidIt();
corp;

proc pAssignment()void:

    pBoolOr();
    if Token = TASS then
	doAssignment();
    fi;
corp;
