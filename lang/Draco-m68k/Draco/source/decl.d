#draco.g
#externs.g

/* declaration processing */

uint
    FILEMULT = 512;			/* multiple for file buffer size */

TYPENUMBER
    NamedType;				/* type if declaring a named type */

bool
    InProcHead; 			/* true if parsing proc decl */

/*
 * pId - parse an identifier for use in a declaration. If an identifier
 *	     is not found, then use DummyId to hold the type/value info.
 */

proc pId(IDKIND check)*SYMBOL:
    *SYMBOL idPtr;

    DummyId.sy_kind := DeclLevel | MUNDEF;
    DummyId.sy_type := TYERROR;
    if Token = TID then 	/* an identifier WAS given */
	idPtr :=
	    if check = ID_DUMMY then
		if CurrentId*.sy_kind = MFREE then
		    /* don't save the text of the identifier */
		    SymNext := CurrentId*.sy_name;
		fi;
		&DummyId
	    elif CurrentId*.sy_kind = MFREE then
		CurrentId*.sy_kind := DummyId.sy_kind;
		CurrentId*.sy_type := TYERROR;
		CurrentId
	    elif check = ID_TYPE and CurrentId*.sy_kind = DeclLevel | MTYPE or
		    check = ID_PROC and CurrentId*.sy_kind&MMMMMM = MEPROC then
		CurrentId
	    else
		errorThis(15);
		&DummyId
	    fi;
	scan();
	idPtr
    else	/* he gave something else, so use DummyId */
	errorThis(32);
	&DummyId
    fi
corp;

/*
 * pStruct - parse a struct/union type.
 */

proc pStruct(TYPENUMBER t; *TTENTRY tp)void:
    register *SYMBOL idPtr;
    INFOTYPE info;
    register ulong offset;
    ulong len, align, thisAlign;
    TYPENUMBER subType;
    uint lineSave1, lineSave2;
    byte size;
    ushort count, columnSave1, columnSave2;
    bool isStruct;

    tp*.t_kind := TY_STRUCT;
    tp*.t_info.i_ptr := NextTypeInfo;
    /* space for total size, count */
    allocTInfo((sizeof(ulong) + sizeof(ushort) + ALIGN - 1) / ALIGN * ALIGN);
    info.i_ptr := NextTypeInfo;
    isStruct := Token = TSTRUCT;
    lCurly();
    offset := 0L0;
    count := 0;
    align := 1;
    while Token + '\e' ~= '}' do
	lineSave1 := Line;
	columnSave1 := Column;
	subType := pType();
	len := typeSize(subType);
	size := getSize(subType);
	thisAlign := TypeTable[subType].t_align;
	if thisAlign > align then
	    align := thisAlign;
	fi;
	/* loop for each field of this type */
	while Token + '\e' ~= ';' and Token + '\e' ~= '}' do
	    lineSave2 := Line;
	    columnSave2 := Column;
	    count := count + 1;
	    idPtr := pId(ID_UNDEFINED);
	    /* put in the type/offset of this field */
	    idPtr*.sy_kind := DeclLevel | MFIELD;
	    idPtr*.sy_type := subType;
	    tFix(t, info.i_ptr, sizeof(*SYMBOL));
	    pretend(info.i_ptr, **SYMBOL)* := idPtr;
	    info.i_ptr := info.i_ptr + sizeof(*SYMBOL);
	    if isStruct then
		offset := (offset + thisAlign - 1) / thisAlign * thisAlign;
		idPtr*.sy_value.sy_ulong := offset;
		offset := offset + len;
	    else
		idPtr*.sy_value.sy_ulong := 0L0;
		if len > offset then
		    offset := len;
		fi;
	    fi;
	    pComma('}');
	    if Line = lineSave2 and Column = columnSave2 then
		scan();
	    fi;
	od;	/* end of loop for fields of this type */
	if Token + '\e' = ';' then
	    scan();
	elif Line = lineSave1 and Column = columnSave1 then
	    scan();
	fi;
    od; 	/* end of loop for sets of fields */
    scan();
    tp*.t_align := align;
    offset := (offset + align - 1) / align * align;
    info.i_ptr := tp*.t_info.i_ptr;
    info.i_struct*.st_size := offset;		/* fill in total size */
    info.i_struct*.st_fieldCount := count;	/* and field count */
corp;

/*
 * pType - parse a type construct, either in a declaration of any
 *	       kind, or in a 'sizeof', 'pretend' or 'make' construct.
 */

proc pType()TYPENUMBER:
    register *TTENTRY tp;
    register *SYMBOL idPtr;
    *ARRAYDIM dimPtr;
    INFOTYPE info, infoSave;
    ulong typeRange, enCnt;
    uint lineSave;
    register TYPENUMBER t, subType;
    ushort dmCnt, columnSave;
    bool igSv, iPHSv, aPSv;

    if Token = TID then
	t := CurrentId*.sy_type;
	if CurrentId*.sy_kind & MMMMMM ~= MTYPE or
		TypeTable[t].t_kind = TY_UNDEFINED then
	    errorThis(36);
	    t := TYERROR;
	fi;
	scan();
    else
	iPHSv := InProcHead;
	InProcHead := false;		/* only allow '*' at top level */
	aPSv := ActualProc;
	ActualProc := false;
	igSv := Ignore;
	Ignore := true;
	if Token ~= TENUM then
	    /* we have some special handling for enumeration types - we have to
	       have the type number for the type already allocated, so that
	       the enumeration constants can have the correct type. If the
	       whole type is named, we will have preallocated in the type
	       declaration. */
	    NamedType := TYERROR;
	fi;
	t := NextType;
	nxtFreTyp();
	tp := &TypeTable[t];
	if Token = TUNKNOWN then
	    /* special type, given as a number of bytes */
	    tp*.t_kind := TY_UNKNOWN;
	    tp*.t_align := 2;	/* should use another expr, but this'll do */
	    scan();
	    tp*.t_info.i_ulong := getPosConst();
	elif Token = TSIGNED or Token = TUNSIGNED then
	    /* signed or unsigned numeric type */
	    tp*.t_kind :=
		if Token = TSIGNED then TY_SIGNED else TY_UNSIGNED fi;
	    scan();
	    typeRange := getPosConst();
	    if make(typeRange, long) < 0L0 and tp*.t_kind = TY_SIGNED then
		errorBack(24);
	    fi;
	    tp*.t_info.i_ptr := NextTypeInfo;
	    /* space for range */
	    allocTInfo(sizeof(ulong));
	    tp*.t_info.i_range := typeRange;
	    tp*.t_align := if typeSize(t) = 1 then 1 else 2 fi;
	    t := chkDup(t);
	elif Token + '\e' = '*' then
	    /* pointer type; we back up, then get new type after the
	       subtype has done all of it's chkDups */
	    NextType := NextType - 1;
	    scan();
	    info.i_type :=
		if Token = TID and CurrentId*.sy_kind = MFREE then
		    /* pointer to as yet undeclared type */
		    subType := NextType;
		    nxtFreTyp();
		    CurrentId*.sy_kind := DeclLevel | MTYPE;
		    CurrentId*.sy_type := subType;
		    scan();
		    TypeTable[subType].t_kind := TY_UNDEFINED;
		    TypeTable[subType].t_align := 1;
		    subType
		elif Token = TID and CurrentId*.sy_kind & MMMMMM = MTYPE then
		    /* allow pointer to previously set up undef type. If we
		       were to just call ourselves recursively, we would get
		       an undefined type error message */
		    subType := CurrentId*.sy_type;
		    scan();
		    subType
		else
		    pType()
		fi;
	    t := NextType;
	    nxtFreTyp();
	    tp := &TypeTable[t];
	    tp*.t_kind := TY_POINTER;
	    tp*.t_align := 2;
	    tp*.t_info.i_type := info.i_type;
	    t := chkDup(t);
	elif Token = TENUM then
	    /* enumerated type */
	    tp*.t_kind := TY_ENUM;
	    lCurly();
	    enCnt := 0;
	    while Token + '\e' ~= '}' and Token + '\e' ~= ';' do
		lineSave := Line;
		columnSave := Column;
		idPtr := pId(ID_UNDEFINED);
		idPtr*.sy_kind := DeclLevel | MNUMBER;
		/* see comment above about this */
		idPtr*.sy_type :=
		    if NamedType = TYERROR then t else NamedType fi;
		idPtr*.sy_value.sy_ulong := enCnt;
		enCnt := enCnt + 0L1;
		pComma('}');
		if Line = lineSave and Column = columnSave then
		    scan();
		fi;
	    od;
	    tp*.t_info.i_range := enCnt;
	    tp*.t_align := if enCnt < 256 then 1 else 2 fi;
	    if Token + '\e' = '}' then
		scan();
	    else
		errorThis(39);
	    fi;
	elif Token = TSTRUCT or Token = TUNION then
	    /* struct or union type */
	    pStruct(t, tp);
	elif Token + '\e' = '[' then
	    /* an array type */
	    scan();
	    infoSave.i_ptr := NextTypeInfo;
	    tp*.t_kind := TY_ARRAY;
	    tp*.t_info.i_ptr := NextTypeInfo;
	    /* element type & # of dimensions */
	    allocTInfo((sizeof(TYPENUMBER) + sizeof(ushort) + ALIGN - 1) /
			ALIGN * ALIGN);
	    dimPtr := &infoSave.i_array*.ar_dims[0];
	    dmCnt := 0;
	    while Token + '\e' ~= ']' and Token + '\e' ~= ';' do
		lineSave := Line;
		columnSave := Column;
		/* flag for this dim & size of this dim */
		allocTInfo(sizeof(ARRAYDIM));
		dimPtr*.ar_kind := AR_FIXED;	/* normally is range */
		if Token + '\e' = '*' then
		    if not iPHSv then
			errorThis(40);
			typeRange := 0L2;
		    else
			dimPtr*.ar_kind := AR_FLEX;
			if aPSv then
			    /* this is the declaration of a conformant array
			       parameter - leave stack space for the passed
			       dimension */
			    DeclOffset := DeclOffset - 0L4;
			fi;
			typeRange := DeclOffset;
		    fi;
		    scan();
		else
		    typeRange := getPosConst();
		fi;
		dimPtr*.ar_dim := typeRange;
		dimPtr := dimPtr + sizeof(ARRAYDIM);
		dmCnt := dmCnt + 1;
		pComma(']');
		if Line = lineSave and Column = columnSave then
		    scan();
		fi;
	    od;
	    if dmCnt = 0 then
		errorThis(153);
	    fi;
	    rSquare();
	    infoSave.i_array*.ar_dimCount := dmCnt;	/* # of dimensions */
	    infoSave.i_array*.ar_baseType := t; 	/*chkDup won't find*/
	    subType := pType();
	    infoSave.i_array*.ar_baseType := subType;	/* element type */
	    tp*.t_align := TypeTable[subType].t_align;
	    t := chkDup(t);
	elif Token = TPROC then
	    /* procedure type */
	    NextType := NextType - 1;	/* let pProcHead alloc type */
	    scan();
	    t := pProcHead();		/* proc head, not in proc decl */
	elif Token = TFILE then
	    /* file type */
	    tp*.t_kind := TY_FILE;
	    tp*.t_align := 2;
	    scan();
	    leftParen();
	    tp*.t_info.i_ulong := FILEMULT;
	    if Token + '\e' ~= ')' then
		tp*.t_info.i_ulong :=
		    (getPosConst() + FILEMULT - 1) / FILEMULT * FILEMULT;
	    fi;
	    rightParen();
	    t := chkDup(t);
	elif Token = TCHANNEL then
	    /* channel type */
	    scan();
	    tp*.t_kind := TY_CHANNEL;
	    tp*.t_align := 2;
	    tp*.t_info.i_channel.i_input := true;
	    tp*.t_info.i_channel.i_text := true;
	    if Token = TINPUT then
		scan();
	    elif Token = TOUTPUT then
		scan();
		tp*.t_info.i_channel.i_input := false;
	    else
		errorThis(124);
	    fi;
	    if Token = TTEXT then
		scan();
	    elif Token = TBINARY then
		scan();
		tp*.t_info.i_channel.i_text := false;
	    else
		errorThis(125);
	    fi;
	    t := chkDup(t);
	else
	    errorThis(42);
	    NextType := NextType - 1;
	    t := TYERROR;
	fi;
	Ignore := igSv;
	InProcHead := iPHSv;
	ActualProc := aPSv;
    fi;
    t
corp;

/*
 * pProcHead - parse a proc header (the brackets, the stuff between
 *		   them, and the result type). The type for the proc is
 *		   assumed to be under construction, so that info can be
 *		   directly added to the last type, and that chkDup
 *		   can be called. Symbol table entries are made if
 *		   InProcHead is true (we are actually declaring a proc).
 *		   The resulting type (after chkDup) is returned.
 */

proc pProcHead()TYPENUMBER:
    register *SYMBOL idPtr;
    register *TTENTRY tp;
    ulong len;
    uint lineSave1, lineSave2;
    INFOTYPE info;
    TYPENUMBER t, subType;
    bool iPHSv, wantRegister;
    ushort parCnt, columnSave1, columnSave2;

    iPHSv := InProcHead;
    InProcHead := true;
    leftParen();
    t := NextType;
    nxtFreTyp();
    tp := &TypeTable[t];
    tp*.t_kind := TY_PROC;
    tp*.t_align := 2;
    tp*.t_info.i_ptr := NextTypeInfo;
    pretend(NextTypeInfo, *PROCDESC)*.p_resultType := t;/*dummy result type*/
    pretend(NextTypeInfo, *PROCDESC)*.p_parCount := 0;	/* no params yet */
    /* space for result type & param count */
    allocTInfo((sizeof(TYPENUMBER) + sizeof(ushort) + ALIGN - 1) /
		ALIGN * ALIGN);
    info.i_ptr := NextTypeInfo;
    parCnt := 0;
    while Token + '\e' ~= ')' and Token + '\e' ~= ':' do
	/* loop through pars */
	lineSave1 := Line;
	columnSave1 := Column;
	wantRegister := false;
	if Token = TREGISTER then
	    wantRegister := true;
	    scan();
	fi;
	subType := pType();
	if wantRegister and not isSimple(subType) then
	    errorBack(155);
	    wantRegister := false;
	fi;
	while Token + '\e' ~= ';' and Token + '\e' ~= ')' and
		Token + '\e' ~= ':' do
	    /* loop through the parameters of this type */
	    lineSave2 := Line;
	    columnSave2 := Column;
	    parCnt := parCnt + 1;
	    idPtr := pId(if ActualProc then ID_UNDEFINED else ID_DUMMY fi);
	    idPtr*.sy_type := subType;
	    idPtr*.sy_kind :=
		if ActualProc then
		    if baseKind1(subType) = TY_OP then
			addOpPar(idPtr);
			MDVAR
		    elif isSimple(subType) or subType = TYFLOAT then
			/* can't do this outside of here, else will try to
			   find size of array with * parameter */
			len := typeSize(subType);
			DeclOffset := -((-(DeclOffset - len) + ALIGN - 1) /
					    ALIGN * ALIGN);
			if subType = TYFLOAT or wantRegister and
			    if isAddress(subType) then
				if ExtraAReg then
				    ARTop = ARLIMIT
				else
				    ARTop = ARLIMIT + 1
				fi
			    else
				DRTop = DRLIMIT + 1
			    fi
			then
			    wantRegister := false;
			fi;
			if wantRegister then
			    Ignore := false;
			    if isAddress(subType) then
				opMove(OP_MOVEL, M_DISP << 3 | RFP,
				       M_ADIR << 3 | ARTop);
				sourceWord(DeclOffset);
				idPtr*.sy_value.sy_reg := ARTop;
				ARTop := ARTop - 1;
			    else
				opMove(
				    case getSize(subType)
				    incase S_BYTE:
					OP_MOVEB
				    incase S_WORD:
					OP_MOVEW
				    incase S_LONG:
					OP_MOVEL
				    esac,
				    M_DISP << 3 | RFP,
				    M_DDIR << 3 + DRTop
				);
				sourceWord(DeclOffset);
				idPtr*.sy_value.sy_reg := DRTop;
				DRTop := DRTop - 1;
			    fi;
			    Ignore := true;
			    MRVAR
			else
			    idPtr*.sy_value.sy_ulong := DeclOffset;
			    MDVAR
			fi
		    else
			DeclOffset := DeclOffset - 0L4;
			idPtr*.sy_value.sy_ulong := DeclOffset;
			MPAR
		    fi | B_LOCAL	/* MLVAR non-stack */
		else
		    MFREE		/* i.e. no symbol! */
		fi;
	    tFix(t, info.i_ptr, sizeof(TYPENUMBER));
	    pretend(info.i_ptr, *TYPENUMBER)* := subType;
	    info.i_ptr := info.i_ptr + sizeof(TYPENUMBER);
	    pComma(')');
	    if Line = lineSave2 and Column = columnSave2 then
		scan();
	    fi;
	od;		/* end of loop for parameters of this type */
	if Token + '\e' = ';' then
	    scan();
	elif Line = lineSave1 and Column = columnSave1 then
	    scan();
	fi;
    od; 	/* end of loop for sets of parameters of a given type */
    rightParen();
    InProcHead := iPHSv;
    info.i_ptr := tp*.t_info.i_ptr;
    /* if this is a new type, it will be added at the end, also in the
       type info table. This is no problem here, since we have already
       left a slot in our entry for the result type */
    if Token = TBOID then
	info.i_proc*.p_resultType := TYIORESULT;
	scan();
    else
	info.i_proc*.p_resultType := pType();	/* final result type */
    fi;
    info.i_proc*.p_parCount := parCnt;		/* parameter count */
    chkDup(t)
corp;

/*
 * pOpType - parse an operator type.
 *	Note that operator types MUST be named directly.
 */

proc pOpType()void:
    register *TTENTRY tp;
    register *byte p @ tp;
    OPDESC dummy;
    INFOTYPE info;

    leftParen();
    if NamedType ~= TYERROR then
	tp := &TypeTable[NamedType];
	tp*.t_kind := TY_OP;
	tp*.t_align := 2;
	info.i_ptr := NextTypeInfo;
	tp*.t_info.i_ptr := info.i_ptr;
	allocTInfo(
	    (sizeof(TYPENUMBER) + sizeof(uint) + ALIGN - 1) / ALIGN * ALIGN);
    else
	info.i_op := &dummy;
    fi;
    if Token = TCHARS then
	p := String*.ct_value;
	while
	    if NamedType ~= TYERROR then
		NextTypeInfo* := p*;
		allocTInfo(sizeof(char));
	    fi;
	    p* ~= '\e' - '\e'
	do
	    p := p + 1;
	od;
	scan();
    else
	errorThis(142);
    fi;
	
    if NamedType ~= TYERROR and
	    (NextTypeInfo - &TypeInfoTable[0]) % 2 ~= 0 then
	/* use up a byte to ensure that we leave type info on word boundary */
	allocTInfo(1);
    fi;
    simpleComma();
    info.i_op*.op_baseType := pType();
    if NamedType ~= TYERROR then
	tp*.t_align := TypeTable[info.i_op*.op_baseType].t_align;
    fi;
    simpleComma();
    info.i_op*.op_ops := getPosConst();
    rightParen();
corp;

/*
 * readDataFile - read a file as the value of an initialized variable.
 */

proc readDataFile(ulong len)void:
    *char fileName;
    ulong offset;

    scan();
    if Token = TCHARS then
	fileName := pretend(String*.ct_value, *char);
	scan();
	offset := 0;
	if Token = TNUMBER then
	    offset := IntValue;
	    scan();
	fi;
	insertDataFile(fileName, len, offset);
    else
	errorThis(184);
    fi;
corp;

/*
 * declVars - declare a set of variables.
 */

proc declVars(bool isExtern)void:
    register *SYMBOL idPtr;
    register *byte p;
    *byte startPos;
    *CTENT constNextSave;
    *byte byteNextSave;
    register *TTENTRY tp;
    register ulong len;
    uint lineSave;
    TYPENUMBER typ;
    byte varMode, origVarMode;
    ushort align, oldKind, columnSave;
    bool wantRegister;

    /* set up the kind of the variable for use in the symbol table.
    This is based on the variable DeclLevel, which is one of:
    B_GLOBAL - variable is in an include file
    B_FILE - variable is global only to one file of procs
    B_LOCAL - variable is a local variable */
    varMode :=
	if DeclLevel = B_GLOBAL then
	    MGVAR
	elif DeclLevel = B_FILE then
	    MFVAR
	else
	    MDVAR			/* MLVAR on non-stack */
	fi;
    origVarMode := varMode;
    wantRegister := false;
    if Token = TREGISTER then
	wantRegister := true;
	scan();
    fi;
    typ := pType();
    if wantRegister and not isSimple(typ) then
	wantRegister := false;
	errorBack(155);
    elif wantRegister and isExtern then
	wantRegister := false;
	errorBack(180);
    fi;
    /* find the length in bytes of the variable */
    len := typeSize(typ);
    align := TypeTable[typ].t_align;
    if varMode = MDVAR then
	/* differing processors may do signed divides a bit different */
	DeclOffset := -((-DeclOffset + align - 1) / align * align);
    else
	DeclOffset := (DeclOffset + align - 1) / align * align;
    fi;
    if wantRegister then
	varMode := MRVAR;
    fi;
    while Token + '\e' ~= ';' do
	/* loop - each variable of this type */
	lineSave := Line;
	columnSave := Column;
	idPtr := pId(ID_UNDEFINED);
	idPtr*.sy_type := typ;
	if Token + '\e' = '=' then   /* defining a constant */
	    if isExtern then
		warning(181);
	    fi;
	    scan();
	    tp := basePtr1(typ);
	    if Token + '\e' = '(' and not isSimple(typ) or
		tp*.t_kind = TY_ARRAY and
		tp*.t_info.i_array*.ar_dimCount = 1 and
		tp*.t_info.i_array*.ar_baseType = TYCHAR and
		Token = TCHARS
	    then
		/* a structured constant */
		startPos := constStart();
		if Token = TCHARS then
		    p := String*.ct_value;
		    len := String*.ct_length;
		    while len ~= 0 do
			len := len - 1;
			constByte(p*);
			p := p + 1;
		    od;
		    len := tp*.t_info.i_array*.ar_dims[0].ar_dim;
		    if String*.ct_length > len then
			errorThis(78);
		    else
			while len ~= String*.ct_length do
			    len := len - 1;
			    constByte('\e' - '\e');
			od;
		    fi;
		    scan();
		else
		    pretend(constBuild(0L0, typ), void);
		fi;
		idPtr*.sy_value.sy_ulong :=
		    pretend(constEnd(startPos), ulong);
		idPtr*.sy_kind := MCONST | DeclLevel;
		InConst := false;
	    else
		pAssignment();	    /* get value of it */
		assignCompat(typ);
		/* enter value (ptr to const entry for MCONST) */
		idPtr*.sy_value.sy_ulong := DescTable[0].v_value.v_ulong;
		if DescTable[0].v_kind = VCONST then
		    idPtr*.sy_kind := MCONST | DeclLevel;
		elif DescTable[0].v_kind = VFLOAT then
		    idPtr*.sy_value.sy_ulong := pretend(
			makeFloat(&DescTable[0].v_value.v_float[0]), ulong);
		    idPtr*.sy_kind := MCONST | DeclLevel;
		else
		    if DescTable[0].v_kind ~= VNUMBER and
			DescTable[0].v_type ~= TYERROR
		    then
			errorBack(44);
		    fi;
		    idPtr*.sy_kind := MNUMBER | DeclLevel;
		fi;
	    fi;
	elif Token + '\e' = '@' then
	    if isExtern then
		warning(182);
	    fi;
	    scan();
	    if
		if Token = TID then
		    oldKind := CurrentId*.sy_kind & MMMMMM;
		    (oldKind = MDVAR or
			oldKind = MGVAR or oldKind = MFVAR or
			oldKind = MLVAR or oldKind = MAVAR) and
			typeSize(CurrentId*.sy_type) >= len or
			oldKind = MRVAR and isSimple(typ) and
			    isAddress(typ) = isAddress(CurrentId*.sy_type)
		else
		    false
		fi
	    then
		idPtr*.sy_value.sy_ulong := CurrentId*.sy_value.sy_ulong;
		idPtr*.sy_kind := oldKind | DeclLevel;
		scan();
	    else
		idPtr*.sy_value.sy_ulong := getPosConst();
		idPtr*.sy_kind := MAVAR | DeclLevel;
	    fi;
	elif Token = TASS then
	    /* an initialized variable */
	    if isExtern then
		warning(183);
	    fi;
	    scan();
	    if Token = TCHIP then
		setChip();
		scan();
	    fi;
	    if varMode ~= MFVAR then
		IgnoreConst := true;
		errorThis(175);
	    else
		IgnoreConst := false;
	    fi;
	    idPtr*.sy_value.sy_uint := REF_NULL;
	    idPtr*.sy_kind := MEXTERN | DeclLevel;
	    constNextSave := ConstNext;
	    byteNextSave := ByteNext;
	    InitData := true;
	    codeInit();
	    ProgramNext := &ProgramBuff[0];
	    InConst := true;
	    if Token = TREAD then
		readDataFile(len);
	    else
		pretend(constBuild(0L0, typ), void);
	    fi;
	    emitConstants();
	    if (ProgramNext - &ProgramBuff[0]) & 1 ~= 0 then
		genByte(0);
	    fi;
	    if (ProgramNext - &ProgramBuff[0]) & 2 ~= 0 then
		genWord(0);
	    fi;
	    writeProgram(idPtr*.sy_name, &ProgramBuffWord[0],
			 ProgramNext - &ProgramBuff[0],
			 &GlobalRelocTable[0], GlobalRelocNext,
			 &FileRelocTable[0], FileRelocNext,
			 &ProgramRelocTable[0], ProgramRelocNext);
	    InitData := false;
	    InConst := false;
	    ConstNext := constNextSave;
	    ByteNext := byteNextSave;
	else
	    if varMode = MRVAR and
		if isAddress(typ) then
		    if ExtraAReg then
			ARTop = ARLIMIT
		    else
			ARTop = ARLIMIT + 1
		    fi
		else
		    DRTop = DRLIMIT + 1
		fi
	    then
		varMode := origVarMode;
	    fi;
	    if isExtern then
		idPtr*.sy_value.sy_uint := REF_NULL;
		idPtr*.sy_kind := MEXTERN | DeclLevel;
	    else
		if varMode = MRVAR then
		    if isAddress(typ) then
			idPtr*.sy_value.sy_reg := ARTop;
			ARTop := ARTop - 1;
		    else
			idPtr*.sy_value.sy_reg := DRTop;
			DRTop := DRTop - 1;
		    fi;
		else
		    if varMode = MDVAR then
			DeclOffset := DeclOffset - len;
		    fi;
		    idPtr*.sy_value.sy_ulong := DeclOffset;
		    if varMode ~= MDVAR then
			DeclOffset := DeclOffset + len;
		    fi;
		fi;
		idPtr*.sy_kind := varMode | DeclLevel;
	    fi;
	fi;
	pComma(';');
	if Line = lineSave and Column = columnSave then
	    scan();
	fi;
    od;
corp;

/*
 * pDecls - parse a set of declarations. These can be global variables,
 *		file static variables or local variables; along with
 *		externs, constants and type declarations.
 */

proc pDecls()void:
    register *SYMBOL idPtr;
    register *TTENTRY oldPtr;
    *TTENTRY parsedPtr, topOldPtr;
    TYPENUMBER typ, parsedType;
    uint lineSave;
    ushort columnSave;

    InProcHead := false;
    ActualProc := false;
    NamedType := TYERROR;
    while
	/* slight ambiguity with file variables of proc types, and actual
	   procs in the file. If the first non-blank after the 'proc'
	   isn't a '(', then it is assumed to be an actual proc. */
	if Token = TPROC or Token = TID then
	    whiteSpace();
	fi;
	if Token = TEXTERN then 	/* declaration of external procs */
	    scan();
	    InProcHead := true; 	/* allow '*' dimensions */
	    while Token + '\e' ~= ';' do
		if Token = TID then
		    whiteSpace();
		fi;
		lineSave := Line;
		columnSave := Column;
		if Char = '(' then
		    /* it is an extern proc declaration */
		    idPtr := pId(ID_UNDEFINED);
		    idPtr*.sy_kind := DeclLevel | MEPROC;
		    idPtr*.sy_type := pProcHead();
		    idPtr*.sy_value.sy_uint := REF_NULL;  /* no use yet */
		    if Token + '\e' = '@' then
			scan();
			idPtr*.sy_value.sy_ulong := getPosConst();
			idPtr*.sy_kind := DeclLevel | MAPROC;
		    fi;
		    pComma(';');
		else
		    /* it is an extern variable declaration */
		    declVars(true);
		fi;
		if Line = lineSave and Column = columnSave then
		    scan();
		fi;
	    od;
	    InProcHead := false;
	    true
	elif Token = TTYPE then
	    /* have some type declarations */
	    scan();
	    while Token + '\e' ~= ';' do
		lineSave := Line;
		columnSave := Column;
		idPtr := pId(ID_TYPE);
		if idPtr*.sy_kind & MMMMMM = MTYPE then
		    typ := idPtr*.sy_type;
		    oldPtr := &TypeTable[typ];
		    topOldPtr := oldPtr;
		    if oldPtr*.t_kind = TY_NAMED then
			typ := oldPtr*.t_info.i_type;
			oldPtr := &TypeTable[typ];
		    fi;
		    NamedType := TYERROR;
		else
		    typ := NextType;
		    oldPtr := &TypeTable[typ];
		    nxtFreTyp();
		    idPtr*.sy_kind := DeclLevel | MTYPE;
		    idPtr*.sy_type := typ;
		    oldPtr*.t_kind := TY_UNDEFINED;
		    oldPtr*.t_align := 1;
		    NamedType := typ;
		fi;
		if Token + '\e' = '=' then
		    scan();
		else
		    errorThis(43);
		fi;
		if Token + '\e' = '(' then
		    if oldPtr*.t_kind ~= TY_UNDEFINED and
			    oldPtr*.t_kind ~= TY_UNKNOWN then
			errorBack(147);
		    fi;
		    pOpType();
		else
		    parsedType := pType();
		    parsedPtr := &TypeTable[parsedType];
		    if parsedPtr*.t_kind = TY_NAMED then
			parsedType := parsedPtr*.t_info.i_type;
			parsedPtr := &TypeTable[parsedType];
		    fi;
		    NamedType := TYERROR;
		    if oldPtr*.t_kind ~= TY_UNDEFINED and
			    oldPtr*.t_kind ~= TY_UNKNOWN and
			    parsedPtr*.t_kind ~= TY_UNKNOWN then
			/* attemting to redefine an existing type */
			errorBack(147);
		    elif oldPtr*.t_kind = TY_UNDEFINED then
			/* just plug in the new type */
			if DeclLevel = B_LOCAL and
				idPtr*.sy_kind & BB ~= B_LOCAL or
				DeclLevel = B_FILE and
				idPtr*.sy_kind & BB = B_GLOBAL then
			    errorBack(150);
			else
			    oldPtr*.t_kind := TY_NAMED;
			    oldPtr*.t_align := parsedPtr*.t_align;
			    oldPtr*.t_info.i_type := parsedType;
			fi;
		    elif typeSize(typ) ~= typeSize(parsedType) then
			if oldPtr*.t_kind ~= TY_UNKNOWN then
			    /* old wasn't unknown - keep old def'n */
			    errorBack(148);
			else
			    /* old was unknown - use new type */
			    if DeclLevel = B_LOCAL and
				    idPtr*.sy_kind & BB ~= B_LOCAL or
				    DeclLevel = B_FILE and
				    idPtr*.sy_kind & BB = B_GLOBAL then
				errorBack(150);
			    fi;
			    errorBack(149);
			    topOldPtr*.t_kind := TY_NAMED;
			    topOldPtr*.t_align := parsedPtr*.t_align;
			    topOldPtr*.t_info.i_type := parsedType;
			fi;
		    else
			if oldPtr*.t_kind = TY_UNKNOWN then
			    /* replace the unknown with the now known */
			    if DeclLevel = B_LOCAL and
				    idPtr*.sy_kind & BB ~= B_LOCAL or
				    DeclLevel = B_FILE and
				    idPtr*.sy_kind & BB = B_GLOBAL then
				errorBack(150);
			    elif parsedPtr*.t_kind ~= TY_UNKNOWN then
				topOldPtr*.t_kind := TY_NAMED;
				topOldPtr*.t_align := parsedPtr*.t_align;
				topOldPtr*.t_info.i_type := parsedType;
			    fi;
			fi;
		    fi;
		fi;
		pComma(';');
		if Line = lineSave and Column = columnSave then
		    scan();
		fi;
	    od;
	    true
	elif Token + '\e' = '[' or Token + '\e' = '*' or Token = TREGISTER or
		Token >= TSIGNED and Token <= TCHANNEL and Token ~= TUNKNOWN or
		Token = TPROC and Char = '(' or
		Token = TID and CurrentId*.sy_kind & MMMMMM = MTYPE and
		    Char ~= '(' then
	    /* have a variable or constant declaration. Note that we do NOT
	       include 'unknown' here, so that all unknown types MUST have
	       a name attached to them. The bracket test, I think, makes us
	       stop on a constant display. */
	    declVars(false);
	    true
	else
	    Token + '\e' = ';'
	fi
    do
	if Token + '\e' = ';' then
	    scan();
	fi;
    od;
corp;
