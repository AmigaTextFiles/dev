#draco.g
#externs.g

/* higher-level machine specific code generation routines */

*char SymNextSave;
uint TailOffsetWord;
byte TailMode;
ushort TailReg;

/*
 * getMode - given a DescTable entry, generate auxilliary code as needed and
 *	     return mode/register/extra information needed to address it.
 */

proc getMode(register *DESCRIPTOR d; *byte pMode; *ushort pReg; *uint pWord;
		    *bool pFreeA, pFreeD)void:
    register long lng;
    register ulong ulng @ lng;
    bool freeA, freeD;

    freeA := false;
    freeD := hasIndex(d) and d*.v_index & 0o7 <= DRTop;
    case d*.v_kind
    incase VVOID:
	errorThis(54);
	TailMode := M_DISP;
	TailReg := RFP;
    incase VERROR:
	TailMode := M_DISP;
	TailReg := RFP;
    incase VPROC:
    incase VAPROC:
    incase VNUMBER:
	TailMode := M_SPECIAL;
	TailReg := M_IMM;
    incase VCONST:
    incase VFLOAT:
	if d*.v_kind = VFLOAT then
	    d*.v_kind := VCONST;
	    d*.v_value.v_const := makeFloat(&d*.v_value.v_float[0]);
	fi;
	TailReg := 0;
	TailMode :=
	    if isSimple(d*.v_type) then
		/* a string constant */
		M_ADIR
	    else
		if d*.v_index = NOINDEX then
		    M_INDIR
		else
		    M_INDEX
		fi
	    fi;
	TailOffsetWord := 0;
	opRegister(OP_LEA, 0, M_SPECIAL << 3 | M_PCDISP);
	opReloc(d, true);
    incase VGVAR:
    incase VFVAR:
    incase VLVAR:
    incase VAVAR:
    incase VEXTERN:
	if d*.v_index = NOINDEX then
	    TailMode := M_SPECIAL;
	    TailReg := M_ABSLONG;
	else
	    opMove(OP_MOVEL, M_SPECIAL << 3 | M_IMM, M_ADIR << 3 | 0);
	    opReloc(d, true);
	    TailMode := M_INDEX;
	    TailReg := 0;
	    TailOffsetWord := 0;
	fi;
    incase VDVAR:
    incase VPAR:
	TailReg := RFP;
	lng := d*.v_value.v_long + ParSize + 8;
	TailOffsetWord := lng;
	if lng < -32768 or d*.v_index ~= NOINDEX and lng < -128 then
	    TailReg := 0;
	    if lng < -32768 then
		opMove(OP_MOVEL, M_ADIR << 3 | RFP, M_ADIR << 3 | 0);
		opModed(OP_ADD, 0, S_LADDR, M_SPECIAL << 3 | M_IMM);
		sourceLong(lng);
	    else
		opRegister(OP_LEA, 0, M_DISP << 3 | RFP);
		sourceWord(lng);
	    fi;
	    TailOffsetWord := 0;
	fi;
	TailMode :=
	    if d*.v_index ~= NOINDEX then
		M_INDEX
	    else
		if TailOffsetWord = 0 then M_INDIR else M_DISP fi
	    fi;
	if d*.v_kind = VPAR then
	    opMove(OP_MOVEL, TailMode << 3 | TailReg, M_ADIR << 3 | 0);
	    if TailMode ~= M_INDIR then
		sourceWord(TailOffsetWord);
	    fi;
	    TailMode := M_INDIR;
	    TailReg := 0;
	fi;
    incase VRVAR:
	TailReg := d*.v_value.v_reg;
	TailMode := if isAddress(d*.v_type) then M_ADIR else M_DDIR fi;
    incase VREG:
	TailReg := d*.v_value.v_reg;
	if isAddress(d*.v_type) then
	    TailMode := M_ADIR;
	    freeA := aActive(TailReg);
	else
	    TailMode := M_DDIR;
	    freeD := TailReg >= DRLIMIT and TailReg <= DRTop;
	fi;
    incase VINDIR:
	ulng := d*.v_value.v_indir.v_offset;
	TailOffsetWord := ulng;
	TailReg := d*.v_value.v_indir.v_base;
	if aActive(TailReg) then
	    needRegs(1, 0);
	fi;
	if d*.v_index = NOINDEX then
	    if ulng > 0L32767 then
		if TailReg > ARTop then
		    opMove(OP_MOVEL, M_ADIR << 3 | TailReg, M_ADIR << 3 | 0);
		    d*.v_value.v_indir.v_base := 0;
		    TailReg := 0;
		fi;
		opModed(OP_ADD, TailReg, S_LADDR, M_SPECIAL << 3 | M_IMM);
		sourceLong(ulng);
		TailOffsetWord := 0;
	    fi;
	    TailMode := if TailOffsetWord = 0 then M_INDIR else M_DISP fi;
	else
	    if ulng > 0L32767 then
		if TailReg > ARTop then
		    opMove(OP_MOVEL, M_ADIR << 3 | TailReg, M_ADIR << 3 | 0);
		    d*.v_value.v_indir.v_base := 0;
		    TailReg := 0;
		fi;
		opModed(OP_ADD, TailReg, S_LADDR, M_SPECIAL << 3 | M_IMM);
		sourceLong(ulng);
		TailOffsetWord := 0;
	    elif TailOffsetWord > 127 then
		if TailReg > ARTop then
		    opMove(OP_MOVEL, M_ADIR << 3 | TailReg, M_ADIR << 3 | 0);
		    d*.v_value.v_indir.v_base := 0;
		    TailReg := 0;
		fi;
		opModed(OP_ADD, TailReg, S_SADDR, M_SPECIAL << 3 | M_IMM);
		sourceWord(TailOffsetWord);
		TailOffsetWord := 0;
	    fi;
	    TailMode := M_INDEX;
	fi;
	freeA := aActive(TailReg);
    default:
	conCheck(12);
    esac;
    pMode* := TailMode;
    pReg* := TailReg;
    pWord* := TailOffsetWord;
    pFreeA* := freeA;
    pFreeD* := freeD;
corp;

/*
 * tailStuff - generate source/dest words based on the stuff just computed.
 */

proc tailStuff(register *DESCRIPTOR d; bool isSource; byte mode; ushort reg;
			uint wrd; bool freeA, freeD)void:
    proc (uint wrd)void doWord;
    byte size;

    doWord := if isSource then sourceWord else destWord fi;
    case mode
    incase M_DISP:
	doWord(wrd);
    incase M_INDEX:
	doWord(make(d*.v_index & 0o7, uint) << 12 |
		if d*.v_index & WORDINDEX = 0 then
		    make(1 << 11, uint)
		else
		    0 << 11
		fi |
		(wrd & 0xff)
	);
    incase M_SPECIAL:
	case reg
	incase M_ABSLONG:
	    opReloc(d, isSource);
	incase M_PCDISP:
	    doWord(wrd);
	incase M_PCINDEX:
	    doWord(make(d*.v_index & 0o7, uint) << 12 |
		    if d*.v_index & WORDINDEX = 0 then
			make(1 << 11, uint)
		    else
			0 << 11
		    fi |
		    (wrd & 0xff)
	    );
	incase M_IMM:
	    /* M_IMM is always source */
	    size := getSize(d*.v_type);
	    if size = S_LONG or size = S_LADDR then
		opReloc(d, true);
	    else
		sourceWord(d*.v_value.v_ulong);
	    fi;
	esac;
    esac;
    if freeA then
	freeAReg();
    fi;
    if freeD then
	freeDReg();
    fi;
corp;

/*
 * opTail - generate the instruction portion based on the value in the
 *	    Top-of-Stack descriptor. Only instructions with an "effective
 *	    address" operand are generated here.
 */

proc opTail(OPTYPE opType; register uint opCode; register byte leftMode;
	    register ushort leftReg;
	    bool extraAddr, extraData)void:
    register byte ea;
    bool freeA, freeD, isSource;

    getMode(&DescTable[0], &TailMode, &TailReg, &TailOffsetWord,
	    &freeA, &freeD);
    ea := TailMode << 3 | TailReg;
    needRegs(
	if freeA then make(1, ushort) else 0 fi +
	if extraAddr then make(1, ushort) else 0 fi,
	if freeD then make(1, ushort) else 0 fi +
	if extraData then make(1, ushort) else 0 fi
    );
    case opType
    incase OPT_SINGLE:
	opSingle(opCode, leftMode, ea);
	isSource := false;
    incase OPT_REGISTER:
	/* putAddrInReg will re-use a register */
	if TailMode >= M_INDIR and TailMode <= M_INDEX and
		leftReg = TailReg then
	    freeA := false;
	fi;
	opRegister(opCode, leftReg, ea);
	isSource := true;
    incase OPT_LOAD:
	if leftMode = M_ADIR and leftReg = TailReg then
	    freeA := false;
	fi;
	if leftMode = M_DDIR and leftReg = DescTable[0].v_index & 0o7 then
	    freeD := false;
	fi;
	opMove(opCode, ea, leftMode << 3 | leftReg);
	isSource := true;
    incase OPT_STORE:
	opMove(opCode, leftMode << 3 | leftReg, ea);
	isSource := false;
    incase OPT_QUICK:
	opQuick(opCode, leftReg, leftMode, ea);
	isSource := true;
    incase OPT_MODED:
	opModed(opCode, leftReg, leftMode, ea);
	isSource := true;
    incase OPT_EA:
	opEA(opCode, ea);
	isSource := true;
    esac;
    tailStuff(&DescTable[0], isSource, TailMode, TailReg, TailOffsetWord,
		freeA, freeD);
corp;

/*
 * condition - generate a conditional branch based on the passed value.
 *	       Flip the condition if conditionFlag is true. The value
 *	       returned is the ProgramBuff address of the address portion
 *	       of the generated branch - will be filled in later
 */

proc condition(bool conditionFlag)uint:
    *char CCTABLE =
	"\(CC_EQ)\(CC_NE)"
	"\(CC_HI)\(CC_LO)\(CC_HS)\(CC_LS)"
	"\(CC_GT)\(CC_LT)\(CC_GE)\(CC_LE)";
    COMPARISONKIND kind;
    bool noBranch;

    noBranch := false;
    if DescTable[0].v_type = TYVOID then  /*can't use statement as cond.*/
	/* we don't bother doing a 'peepFlush' here - so what if some
	   instructions are out of order - the .r file will be gone */
	errorBack(52);
    elif DescTable[0].v_kind = VCC then
	/* this is the easy case - a comparison */
	kind := DescTable[0].v_value.v_comparison;
	if not conditionFlag then
	    kind := if kind <= VNE then
			VNE + (VEQ - VEQ)
		    elif kind <= VLE then
			VLE + (VGT - VEQ)
		    else
			VLES + (VGTS - VEQ)
		    fi - kind + VEQ
	fi;
	opBranch(pretend(CCTABLE, *[10] byte)*[kind], 0);
    elif (DescTable[0].v_type = TYBOOL or DescTable[0].v_type = TYIORESULT) and
	    DescTable[0].v_kind = VNUMBER then
	if DescTable[0].v_value.v_ulong + false then
	    if conditionFlag then
		opBranch(CC_T, 0);
	    else
		noBranch := true;
	    fi;
	else
	    if conditionFlag then
		noBranch := true;
	    else
		opBranch(CC_T, 0);
	    fi;
	fi;
    else	/* otherwise, we must test the value for being 0 or not */
	if DescTable[0].v_type ~= TYBOOL and DescTable[0].v_type ~= TYERROR
		and DescTable[0].v_type ~= TYIORESULT then
	    /* value must be of type bool */
	    errorBack(53);
	    forceData();
	fi;
	opTail(OPT_SINGLE, OP_TST, S_BYTE, 0, false, false);
	opBranch(if conditionFlag then CC_NE else CC_EQ fi, 0);
    fi;
    if noBranch then
	BRANCH_NULL
    else
	/* leave a gap for the jump address - may be forward */
	if Ignore then
	    BRANCH_NULL
	else
	    genWord(BRANCH_NULL);
	    ProgramNext - &ProgramBuff[2]
	fi
    fi
corp;

/*
 * putAddrInReg - put the address of something into a register.
 */

proc putAddrInReg()void:
    register ushort reg;
    bool alloced;

    if DescTable[0].v_kind = VINDIR and
	DescTable[0].v_value.v_indir.v_base <= ARTop
    then
	alloced := false;
	reg := DescTable[0].v_value.v_indir.v_base;
    else
	alloced := true;
	reg := getAReg();
    fi;
    if alloced or DescTable[0].v_value.v_indir.v_offset ~= 0L0 or
	    DescTable[0].v_index ~= NOINDEX
    then
	opTail(OPT_REGISTER, OP_LEA, 0, reg, alloced, false);
    fi;
    DescTable[0].v_kind := VREG;
    DescTable[0].v_value.v_reg := reg;
corp;

/*
 * putInReg - put the top-of-stack value into a register.
 */

proc putInReg()void:
    register *REGQUEUE r;
    uint brChain;
    uint moveType;
    uint peepTotalSave;
    VALUEKIND kind;
    register uint reg;
    byte size, rMode, mode;
    bool isAddr, alloced, pushedA1;

    if isOp() then
	if DescTable[0].v_kind ~= VREG then
	    pushedA1 := A1Busy();
	    if pushedA1 then
		opMove(OP_MOVEL, M_ADIR << 3 | 1, M_DEC << 3 | RSP);
	    fi;
	    putAddrInReg();
	    opMove(OP_MOVEL, M_ADIR << 3 | DescTable[0].v_value.v_reg,
		   M_DEC << 3 | RSP);
	    freeAReg();
	    DescTable[0].v_kind := VREG;
	    DescTable[0].v_value.v_reg := 0;
	    genOpCall("psh");
	    if pushedA1 then
		opMove(OP_MOVEL, M_INC << 3 | RSP, M_ADIR << 3 | 1);
	    fi;
	fi;
    elif DescTable[0].v_type = TYFLOAT then
	if hasIndex(&DescTable[0]) then
	    putAddrInReg();
	    makeIndir();
	fi;
    elif not isSimple(DescTable[0].v_type) then
	putAddrInReg();
    else
	isAddr := isAddress(DescTable[0].v_type);
	size := getSize(DescTable[0].v_type);
	if DescTable[0].v_type = TYIORESULT then
	    isAddr := false;
	    size := S_BYTE;
	fi;
	rMode := if isAddr then M_ADIR else M_DDIR fi;
	kind := DescTable[0].v_kind;
	moveType :=
	    if isAddr or size = S_LONG then
		OP_MOVEL
	    elif size = S_WORD then
		OP_MOVEW
	    else
		OP_MOVEB
	    fi;
	if kind = VCC or TrueChain ~= BRANCH_NULL or FalseChain ~= BRANCH_NULL
	then
	    /* he is stacking a true/false value */
	    brChain := condition(true);
	    reg := getDReg();	/* what if this needs to save a register?? */
	    fixChain(FalseChain);	/* false cases come here => 0 */
	    FalseChain := BRANCH_NULL;
	    opSingle(OP_CLR, S_BYTE, M_DDIR << 3 | reg);
	    opBranch(CC_T, 2);
	    fixChain(brChain);
	    fixChain(TrueChain);	/* true cases come here => 1 */
	    TrueChain := BRANCH_NULL;
	    opImm(reg, 1);
	    peepFlush();		/* don't want MOV/MOV done here! */
	    forgetRegs();
	    DescTable[0].v_type := TYBOOL;	/* type is bool */
	elif kind = VREG then
	    reg := DescTable[0].v_value.v_reg;
	    if reg = 0 then
		/* was TYIORESULT */
		reg := getDReg();
		opMove(OP_MOVEB, M_DDIR << 3 | 0, M_DDIR << 3 | reg);
	    fi;
	else
	    if (kind = VNUMBER or kind = VRVAR or kind = VDVAR or
		kind = VFVAR or kind = VGVAR or kind = VAVAR) and
		DescTable[0].v_index = NOINDEX
	    then
		/* see if the value is already in a register */
		r := if isAddr then ARegFreeHead else DRegFreeHead fi;
		while r ~= nil and
		    (r*.r_desc.v_kind ~= kind or
		     r*.r_desc.v_value.v_ulong~=DescTable[0].v_value.v_ulong or
		     r*.r_desc.v_kind = VNUMBER and
			size > getSize(r*.r_desc.v_type))
		do
		    r := r*.r_next;
		od;
	    else
		r := nil;
	    fi;
	    if r ~= nil then
		reg := r*.r_reg;
	    elif isAddr then
		if kind = VINDIR and
		    DescTable[0].v_value.v_indir.v_base <= ARTop
		then
		    alloced := false;
		    reg := DescTable[0].v_value.v_indir.v_base;
		else
		    alloced := true;
		    reg := getAReg();
		fi;
	    else
		if hasIndex(&DescTable[0]) and
		    DescTable[0].v_index & 0o7 <= DRTop
		then
		    alloced := false;
		    reg := DescTable[0].v_index & 0o7;
		else
		    alloced := true;
		    reg := getDReg();
		fi;
	    fi;
	    if r ~= nil then
		RememberCount := RememberCount + 1;
		/* move this register to the head of the busy reg queue */
		if isAddr then
		    unlinkFreeAReg(r);
		    pushBusyAReg(r);
		    ARegValidCount := ARegValidCount + 1;
		else
		    unlinkFreeDReg(r);
		    pushBusyDReg(r);
		    DRegValidCount := DRegValidCount + 1;
		fi;
	    elif kind = VNUMBER and DescTable[0].v_value.v_ulong = 0L0 then
		if size = S_LADDR then
		    opModed(OP_SUB, reg, S_LADDR, M_ADIR << 3 | reg);
		else
		    opSingle(OP_CLR, size, M_DDIR << 3 | reg);
		fi;
		/* don't remember these - they are easy to make */
	    elif not isAddr and kind = VNUMBER and
		    DescTable[0].v_value.v_long <= 0L127 and
		    DescTable[0].v_value.v_long >= - 0L128 then
		opImm(reg, DescTable[0].v_value.v_ulong);
		/* don't remember these either. This is in the way of a
		   heuristic - if we remember too much, then even simple
		   routines will end up using more temporary registers */
	    else
		peepTotalSave := PeepTotal;
		opTail(OPT_LOAD, moveType, rMode, reg,
		    isAddr and alloced, not isAddr and alloced
		);
		if PeepTotal > peepTotalSave and
		    (kind = VNUMBER or kind = VRVAR or kind = VDVAR or
		    kind = VFVAR or kind = VGVAR) and
		    DescTable[0].v_index = NOINDEX
		then
		    /* remember the value that is in the register. We do this
		       only if our MOVE instruction actually got generated. */
		    r :=if isAddr then &ARegQueue[reg] else &DRegQueue[reg] fi;
		    r*.r_desc.v_type := DescTable[0].v_type;
		    r*.r_desc.v_kind := kind;
		    r*.r_desc.v_value.v_ulong := DescTable[0].v_value.v_ulong;
		fi;
	    fi;
	fi;
	DescTable[0].v_kind := VREG;
	DescTable[0].v_value.v_reg := reg;
    fi;
corp;

/*
 * checkOp - check to see that the current type supports the given
 *	     operation. Complain if it doesn't. Generate the call.
 */

proc checkOp(uint op)void:
    *char OPS =
	"add\esub\emul\ediv\emod\eneg\eabs\eior\e"
	"and\exor\eshl\eshr\enot\ecpr\eput\eget";
    ushort pow;
    bool pushedA1;

    if op ~= OPGET and op ~= OPPUT then
	putInReg();
    fi;
    if basePtr1(
	    if op = OPSHL or op = OPSHR or not isOp() then
		opMove(OP_MOVEL, M_DDIR << 3 | DescTable[0].v_value.v_reg,
		       M_DEC << 3 | RSP);
		freeDReg();
		DescTable[1].v_type
	    else
		DescTable[0].v_type
	    fi)*.t_info.i_op*.op_ops & op = 0 then
	errorThis(143);
    fi;
    pretend(isPower2(op, &pow), void);
    pushedA1 := A1Busy();
    if pushedA1 then
	opMove(OP_MOVEL, M_ADIR << 3 | 1, M_DEC << 3 | RSP);
    fi;
    genOpCall(pow * 4 + OPS);
    if pushedA1 then
	opMove(OP_MOVEL, M_INC << 3 | RSP, M_ADIR << 3 | 1);
    fi;
    DescTable[0].v_kind := VREG;
    DescTable[0].v_value.v_reg := 0;
corp;

/*
 * opCompat - check that the top two types are both the same op type.
 */

proc opCompat()void:

    if DescTable[0].v_type ~= DescTable[1].v_type then
	errorThis(144);
	DescTable[0].v_type := TYERROR;
    fi;
corp;

/*
 * externRef - generate an instruction referencing an external symbol.
 */

proc externRef1(uint opCode; *char name)void:
    register *SYMBOL ptr;

    ptr := findSymbol(name);
    if ptr*.sy_kind = MFREE then
	ptr*.sy_kind := B_LOCAL | MPROC;
	ptr*.sy_name := name;
	ptr*.sy_value.sy_uint := REF_NULL;
    else
	SymNext := SymNextSave;
    fi;
    peepFlush();
    genWord(opCode);
    genWord(ptr*.sy_value.sy_uint);
    ptr*.sy_value.sy_uint := ProgramNext - &ProgramBuff[2];
    genWordZero();
corp;

proc externRef(uint opCode; *char name)void:

    SymNextSave := SymNext;
    externRef1(opCode, name);
corp;

/*
 * genCall1 - the actual lookup and call for genCall, genCall2.
 */

proc genCall1(*char name)void:

    externRef1(OP_JSR | M_SPECIAL << 3 | M_ABSLONG, name);
corp;

/*
 * genCall - generate a call to the named system support routine
 */

proc genCall(register *char name)void:

    if not Ignore then
	while
	    name := name + 1;
	    name* ~= '\e'
	do
	od;
	SymNextSave := SymNext;
	genCall1(name - 1);
    fi;
corp;

/*
 * genCall2 - build a procedure name and make a call to it.
 */

proc genCall2(register *char name1, name2)void:

    if not Ignore then
	SymNextSave := SymNext;
	while name1* ~= '\e' do
	    SymNext* := name1*;
	    name1 := name1 + 1;
	    SymNext := SymNext - 1;
	od;
	while
	    SymNext* := name2*;
	    SymNext := SymNext - 1;
	    name2* ~= '\e'
	do
	    name2 := name2 + 1;
	od;
	if SymNext <= pretend(ProgramNext, *char) then
	    errorThis(5);
	fi;
	genCall1(SymNextSave);
    fi;
corp;

/*
 * genOpCall - generate a call based on an operator type.
 */

proc genOpCall(*char name2)void:

    genCall2(&basePtr1(
	if isOp() then
	    DescTable[0].v_type
	else
	    DescTable[1].v_type
	fi)*.t_info.i_op*.op_name[0], name2);
corp;
