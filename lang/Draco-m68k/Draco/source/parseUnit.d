#draco.g
#externs.g

/* parse some of the bottom-level stuff in recursive descent */

/* declare assembler interface stubs to floating point code */

extern
    _DPFix(long lo, hi)long,
    _DPFlt(long n; *byte pF)void;

/* a type to let us work with floats */

type
    Float_t = union {
	struct {
	    long l_hi, l_lo;
	} l_;
	[8] byte b_arr;
    };

/*
 * pSizeof - parse the 'sizeof' construct.
 */

proc pSizeof()void:

    scan();
    leftParen();
    DescTable[0].v_kind := VNUMBER;
    DescTable[0].v_type := TYULONG;
    DescTable[0].v_value.v_ulong := typeSize(pType());
    rightParen();
corp;

/*
 * chuckValue - throw away any value we may currently have.
 */

proc chuckValue()void:

    if DescTable[0].v_type ~= TYVOID then
	if TrueChain ~= BRANCH_NULL or FalseChain ~= BRANCH_NULL or
		DescTable[0].v_kind = VCC then
	    putInReg();
	fi;
	if DescTable[0].v_kind = VREG then
	    if isAddress(DescTable[0].v_type) then
		freeAReg();
	    elif DescTable[0].v_value.v_reg ~= 0 then
		/* IORESULT does not allocate a real register */
		freeDReg();
	    elif DescTable[0].v_type = TYFLOAT then
		FloatBusy := false;
	    fi;
	fi;
	voidIt();
	ignoreCheck();
    fi;
corp;

/*
 * pMake - parse the 'make' and 'pretend' constructs.
 */

proc pMake()void:
    register *DESCRIPTOR d0;
    register TYPENUMBER newType;
    register byte oldSize, newSize;
    register ushort reg;
    bool isMake;

    d0 := &DescTable[0];
    isMake := Token = TMAKE;
    scan();
    leftParen();
    pAssignment();
    if d0*.v_type = TYVOID then
	errorBack(80);
    fi;
    simpleComma();
    newType := pType();
    newSize := getSize(newType);
    oldSize := getSize(d0*.v_type);
    if newType = TYVOID then
	chuckValue();
    elif isMake or d0*.v_kind = VREG or d0*.v_kind = VRVAR then
	if isMake then
	    assignCompat(newType);
	fi;
	if newSize ~= oldSize then
	    if newSize = S_LADDR then
		fixSizeReg(TYULONG);
		reg := getAReg();
		opMove(OP_MOVEL, M_DDIR << 3 | d0*.v_value.v_reg,
			M_ADIR << 3 | reg);
		if d0*.v_kind = VREG then
		    freeDReg();
		fi;
		d0*.v_kind := VREG;
		d0*.v_value.v_reg := reg;
	    elif oldSize = S_LADDR then
		reg := getDReg();
		opMove(OP_MOVEL, M_ADIR << 3 | d0*.v_value.v_reg,
			M_DDIR << 3 | reg);
		if d0*.v_kind = VREG then
		    freeAReg();
		fi;
		d0*.v_kind := VREG;
		d0*.v_value.v_reg := reg;
	    else
		fixSizeReg(newType);
	    fi;
	fi;
	if not isSimple(newType) then
	    putInReg();
	    if oldSize ~= S_LADDR then
		reg := getAReg();
		opMove(OP_MOVEL, M_DDIR << 3 | d0*.v_value.v_reg,
			M_ADIR << 3 | reg);
		freeDReg();
		d0*.v_value.v_reg := reg;
	    fi;
	    makeIndir();
	    errorThis(103);
	fi;
    fi;
    d0*.v_type := newType;
    rightParen();
corp;

/*
 * pDim - parse the 'dim' construct.
 */

proc pDim()void:
    register *DESCRIPTOR d0;
    register *TTENTRY tp;
    register *ARRAYDIM dimPtr @ tp;
    register *ARRAYDESC ar @ tp;
    register ushort which;

    d0 := &DescTable[0];
    scan();
    leftParen();
    pAssignment();
    tp := basePtr(d0*.v_type);
    if tp*.t_kind ~= TY_ARRAY then
	errorBack(81);
    fi;
    simpleComma();
    which := getPosConst();
    d0*.v_kind := VREG;
    d0*.v_type := TYULONG;
    if tp*.t_kind = TY_ARRAY then
	ar := tp*.t_info.i_array;
	if which = 0 or which > ar*.ar_dimCount then
	    errorBack(83);
	else
	    dimPtr := &ar*.ar_dims[which - 1];
	    if dimPtr*.ar_kind = AR_FIXED then
		d0*.v_kind := VNUMBER;
		d0*.v_value.v_ulong := dimPtr*.ar_dim;
	    else
		d0*.v_value.v_reg := getDReg();
		getDim(dimPtr, M_DDIR, d0*.v_value.v_reg);
	    fi;
	fi;
    fi;
    rightParen();
corp;

/*
 * pNew - parse and generate code for the 'new' construct.
 */

proc pNew()void:
    TYPENUMBER t;
    bool pushedA1;

    scan();
    leftParen();
    t := pType();
    pushedA1 := A1Busy();
    if pushedA1 then
	opMove(OP_MOVEL, M_ADIR << 3 | 1, M_DEC << 3 | RSP);
    fi;
    opMove(OP_MOVEL, M_SPECIAL << 3 | M_IMM, M_DEC << 3 | RSP);
    sourceLong(typeSize(t));
    genCall("\ecollam_d_");
    if pushedA1 then
	opMove(OP_MOVEL, M_INC << 3 | RSP, M_ADIR << 3 | 1);
    fi;
    DescTable[0].v_type := makePtrTo(t);
    DescTable[0].v_kind := VREG;
    DescTable[0].v_value.v_reg := getAReg();
    opMove(OP_MOVEL, M_DDIR << 3 | 0,
	    M_ADIR << 3 | DescTable[0].v_value.v_reg);
    rightParen();
corp;

/*
 * pFree - parse and generate code for the 'free' construct.
 */

proc pFree()void:
    bool pushedA1;

    scan();
    leftParen();
    pushedA1 := A1Busy();
    if pushedA1 then
	opMove(OP_MOVEL, M_ADIR << 3 | 1, M_DEC << 3 | RSP);
    fi;
    pAssignment();
    opTail(OPT_LOAD, OP_MOVEL, M_DEC, RSP, false, false);
    if baseKind(DescTable[0].v_type) ~= TY_POINTER then
	if DescTable[0].v_type ~= TYERROR then
	    errorBack(121);
	fi;
    else
	opMove(OP_MOVEL, M_SPECIAL << 3 | M_IMM, M_DEC << 3 | RSP);
	sourceLong(typeSize(basePtr(DescTable[0].v_type)*.t_info.i_type));
    fi;
    genCall("\eeerfm_d_");
    if pushedA1 then
	opMove(OP_MOVEL, M_INC << 3 | RSP, M_ADIR << 3 | 1);
    fi;
    voidIt();
    rightParen();
corp;

/*
 * pRange - parse and handle the 'range' construct (no code).
 */

proc pRange()void:
    *TTENTRY tp;
    TYPEKIND tk;

    scan();
    leftParen();
    tp := basePtr(pType());
    tk := tp*.t_kind;
    DescTable[0].v_value.v_ulong :=
	if tk = TY_ENUM or tk = TY_UNSIGNED or tk = TY_SIGNED then
	    tp*.t_info.i_range
	else
	    errorBack(122);
	    0L1
	fi;
    DescTable[0].v_type := TYULONG;
    DescTable[0].v_kind := VNUMBER;
    rightParen();
corp;

/*
 * pBasicId - parse an ID at the bottom level of recursive descent.
 */

proc pBasicId()void:
    register *DESCRIPTOR d0;
    register *SYMBOL idSave;
    register *byte startPos @ idSave;
    register TYPENUMBER t;
    register ushort kind @ t;
    bool inConstSave;

    d0 := &DescTable[0];
    idSave := CurrentId;		/* save for proc useage chains */
    kind := idSave*.sy_kind & MMMMMM;	/* the kind of this identifier*/
    d0*.v_kind := VERROR;		/* safe in case of error */
    d0*.v_type := idSave*.sy_type;	/* type of result */
    d0*.v_value.v_ulong := idSave*.sy_value.sy_ulong;
    d0*.v_index := NOINDEX;
    if kind = MFREE then
	kind := MUNDEF;
	errorThis(16);		/* first complaint about undefined */
	idSave*.sy_kind := DeclLevel | MUNDEF;
	idSave*.sy_type := TYERROR;
	idSave*.sy_value.sy_ulong := 0L0;
	d0*.v_type := TYERROR;
	d0*.v_value.v_ulong := 0L0;
    elif kind = MUNDEF then
	errorThis(17);		/* subsequent use of undefined */
    fi;
    scan();
    case kind
    incase MUNDEF:
	;
    incase MPROC:
    incase MEPROC:
    incase MAPROC:
	/* it's a procedure name */
	d0*.v_kind :=
	    if kind = MPROC or kind = MEPROC then
		d0*.v_value.v_proc := &idSave*.sy_value.sy_uint;
		VPROC
	    else
		VAPROC
	    fi;
	if Token + '\e' = '(' then		/* we are calling it */
	    pCall();
	fi;
    incase MFIELD:
	/* can't use a field by itself */
	errorThis(88);
	d0*.v_value.v_ulong := 0L0;
    incase MNUMBER:
	/* id was a constant */
	d0*.v_kind := VNUMBER;
    incase MCONST:
	d0*.v_kind := VCONST;
	if d0*.v_type = TYFLOAT then
	    d0*.v_kind := VFLOAT;
	    d0*.v_value.v_float :=
		pretend(d0*.v_value.v_const*.ct_value, *[FLOAT_BYTES] byte)*;
	fi;
    incase MTYPE:
	inConstSave := InConst;
	t := d0*.v_type;
	if isSimple(t) then
	    errorThis(141);
	fi;
	startPos := constStart();
	pretend(constBuild(0L0, t), void);
	d0*.v_kind := VCONST;
	d0*.v_type := t;
	d0*.v_value.v_const := constEnd(startPos);
	InConst := inConstSave;
    incase MEXTERN:
	d0*.v_kind := VEXTERN;
	d0*.v_value.v_extern.ve_chain := &idSave*.sy_value.sy_uint;
	d0*.v_value.v_extern.ve_offset := 0;
    default:
	/* we have a variable */
	d0*.v_kind := kind + (VGVAR - MGVAR);
    esac;
corp;

/*
 * pCode - parse and generate code for the 'code' construct.
 */

proc pCode()void:
    register *DESCRIPTOR d0;
    register ushort kind;
    register byte size @ kind;

    d0 := &DescTable[0];
    scan();
    leftParen();
    peepFlush();
    while isExpression() do
	if Token = TID then
	    kind := CurrentId*.sy_kind & MMMMMM;
	fi;
	if Token = TID and
		(kind = MPROC or kind = MAPROC or kind = MEXTERN or
		 kind = MGVAR or kind = MFVAR or kind = MLVAR or
		 kind = MDVAR or kind = MPAR) then
	    pBasicId();
	    if not Ignore then
		if kind = MDVAR or kind = MPAR then
		    genWord(d0*.v_value.v_long + ParSize + 8);
		else
		    genReloc(d0*.v_kind, &d0*.v_value);
		fi;
	    fi;
	else
	    pAssignment();
	    if d0*.v_kind ~= VNUMBER then
		errorBack(45);
	    else
		if not Ignore then
		    size := getSize(d0*.v_type);
		    if size = S_BYTE then
			genByte(d0*.v_value.v_ulong);
		    elif size = S_WORD then
			genWord(d0*.v_value.v_ulong);
		    else
			genLong(d0*.v_value.v_ulong);
		    fi;
		fi;
	    fi;
	fi;
	pComma(')');
    od;
    voidIt();
    rightParen();
corp;

/*
 * pError - handle the 'error' construct.
 */

proc pError()void:

    scan();
    leftParen();
    if Token = TCHARS then
	if not Ignore then
	    errorHead(OOLine, OOColumn, 255, false, true);
	    printString(pretend(String*.ct_value, *char));
	    printString("\n");
	fi;
	scan();
    else
	errorThis(146);
    fi;
    voidIt();
    rightParen();
corp;

/*
 * pReturn - handle the 'return' construct.
 */

proc pReturn()void:
    register *DESCRIPTOR d0;

    scan();
    if ResultType ~= TYVOID then
	pAssignment();
	doReturnValue();
    fi;
    opBranch(CC_T, 0);
    genWord(ReturnChain);
    ReturnChain := ProgramNext - &ProgramBuff[2];
    voidIt();
corp;

/*
 * pIgnore - handle the 'ignore' construct.
 */

proc pIgnore()void:

    scan();
    pAssignment();
    if DescTable[0].v_type = TYVOID then
	errorBack(154);
    else
	chuckValue();
    fi;
corp;

/*
 * pFix - handle the 'fix' construct.
 */

proc pFix()void:
    register *DESCRIPTOR d0;
    Float_t f;

    d0 := &DescTable[0];
    scan();
    leftParen();
    pAssignment();
    if d0*.v_kind = VFLOAT then
	f.b_arr := d0*.v_value.v_float;
	enableMath();
	d0*.v_value.v_ulong := _DPFix(f.l_.l_lo, f.l_.l_hi);
	d0*.v_kind := VNUMBER;
    else
	putInReg();
	if d0*.v_type ~= TYFLOAT then
	    if d0*.v_type ~= TYERROR then
		errorBack(171);
	    fi;
	    forceData();
	    freeDReg();
	else
	    if d0*.v_kind ~= VREG then
		floatRef(OP_RESTM, 0, d0);
		d0*.v_kind := VREG;
	    fi;
	    FloatBusy := false;
	fi;
	floatEntry(LVO_IEEEDP_FIX);
	d0*.v_value.v_reg := getDReg();
	opMove(OP_MOVEL, M_DDIR << 3 | 0, M_DDIR << 3 | d0*.v_value.v_reg);
    fi;
    d0*.v_type := TYLONG;
    rightParen();
corp;

/*
 * pFlt - handle the 'flt' construct.
 */

proc pFlt()void:
    register *DESCRIPTOR d0;

    d0 := &DescTable[0];
    scan();
    leftParen();
    pAssignment();
    checkNumber();
    if d0*.v_kind = VNUMBER then
	enableMath();
	_DPFlt(d0*.v_value.v_long, &d0*.v_value.v_float[0]);
	d0*.v_kind := VFLOAT;
    else
	fixSizeReg(TYLONG);
	opMove(OP_MOVEL, M_DDIR << 3 | d0*.v_value.v_reg,
	       M_DDIR << 3 | 0);
	freeDReg();
	floatEntry(LVO_IEEEDP_FLT);
	FloatBusy := true;
    fi;
    d0*.v_type := TYFLOAT;
    rightParen();
corp;

/*
 * pConst - handle case of a constant.
 */

proc pConst(VALUEKIND k; TYPENUMBER t; ulong val)void:

    DescTable[0].v_kind := k;
    DescTable[0].v_type := t;
    DescTable[0].v_value.v_ulong := val;
    DescTable[0].v_index := NOINDEX;
    scan();
corp;

/*
 * pConstruct - the bottom level of the recursive descent routines - this
 *		    calls most of the other construct parsers, bracketed sub-
 *		    expressions, constants, identifiers, etc.
 */

proc pConstruct()void:
    register *DESCRIPTOR d0;

    d0 := &DescTable[0];
    d0*.v_kind := VERROR;
    d0*.v_type := TYERROR;
    d0*.v_value.v_ulong := 0;
    case Token
    incase TNUMBER:			/* integer constant */
	pConst(VNUMBER, TYULONG, IntValue);
    incase TCHAR:			/* character constant */
	pConst(VNUMBER, TYCHAR, IntValue);
    incase TCHARS:			/* character string constant */
	pConst(VCONST, TYCHARS, pretend(String, ulong));
    incase TFNUM:			/* floating point constant */
	pConst(VFLOAT, TYFLOAT, 0);
	DescTable[0].v_value.v_float := FloatValue;
    incase TID: 			/* identifier */
	pBasicId();
    incase TWHILE:
	pWhile();
    incase TIF:
	pIf();
    incase TCASE:
	pCase();
    incase TFOR:
	pFor();
    incase '(' - '\e':			/* bracketed sub-expression */
	scan();
	pAssignment();
	if d0*.v_type = TYVOID then	/* can't bracket a statement */
	    errorThis(85);
	    d0*.v_type := TYERROR;
	fi;
	rightParen();
    incase ')' - '\e':
	errorThis(86);
	scan();
    incase TPRETEND:
    incase TMAKE:
	pMake();
    incase TSIZEOF:
	pSizeof();
    incase TDIM:
	pDim();
    incase TNIL:
	d0*.v_kind := VNUMBER;
	d0*.v_type := TYNIL;
	scan();
    incase TNEW:
	pNew();
    incase TFREE:
	pFree();
    incase TRANGE:
	pRange();
    incase TOPEN:
	pOpen();
    incase TCLOSE:
    incase TIOERROR:
	pCloseIOError();
    incase TREAD:
    incase TWRITE:
    incase TREADLN:
    incase TWRITELN:
	pReadWrite();
    incase TCODE:
	pCode();
    incase TERROR:
	pError();
    incase TRETURN:
	pReturn();
    incase TIGNORE:
	pIgnore();
    incase TFIX:
	pFix();
    incase TFLT:
	pFlt();
    default:	/* if get here, then lord knows what he entered! */
	errorThis(87);
    esac;
corp;

/*
 * statements - parse a sequence of statements
 */

proc statements()void:
    uint oldLine;
    ushort oldColumn;

    voidIt();
    while Token + '\e' = ';' or not isStateEnd() do
	if Token + '\e' = ';' then    /* ';' throws away value of previous */
	    chuckValue();
	    scan();
	else
	    /* the position in the input is saved before the call to
	       pAssignment (the top of the recursive descent parser)
	       and checked after it, to make sure we don't get into an
	       infinite loop with something totally unrecognizeable */
	    oldLine := Line;
	    oldColumn := Column;
	    if Token = TWHILE or Token = TFOR then
		/* Short circuit recursive descent to save stack space.
		   Note that we can't do this for 'if' or 'case', since
		   they might in fact be the start of an expression. */
		pConstruct();
	    else
		pAssignment();
	    fi;
	    if Token + '\e' = ';' then
		if notStatement(DescTable[0].v_type) then
		    errorBack(67);
		    chuckValue();
		fi;
	    elif not isStateEnd() then
		if notStatement(DescTable[0].v_type) then
		    errorThis(67);
		    chuckValue();
		fi;
		syntaxCheck(68);
		if oldLine = Line and oldColumn = Column then
		    scan();	/* skip one token if in loop */
		fi;
	    fi;
	fi;
    od;
corp;
