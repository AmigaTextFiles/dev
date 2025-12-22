#draco.g
#externs.g

/* parse the array indexing, dereference and field selection operations */

bool LastWasSigned;

/*
 * lengthenIndex - extend a word index into a long index, paying attention to
 *	whether it is a signed value or not. If it is a register variable,
 *	allocate a temporary and use it.
 */

proc lengthenIndex(ushort reg; bool signedIndex)ushort:
    ushort newReg;

    if reg > DRTop then
	newReg := getDReg();
	if signedIndex then
	    opMove(OP_MOVEL, M_DDIR << 3 | reg, M_DDIR << 3 | newReg);
	    opSpecial(OP_EXT | 0b011 << 6 | newReg);
	else
	    opImm(newReg, 0);
	    opMove(OP_MOVEW, M_DDIR << 3 | reg, M_DDIR << 3 | newReg);
	fi;
	newReg
    else
	if signedIndex then
	    opSpecial(OP_EXT | 0b011 << 6 | reg);
	else
	    opSingle(OP_ANDI, S_LONG, M_DDIR << 3 | reg);
	    sourceLong(0x0000ffff);
	fi;
	reg
    fi
corp;

/*
 * doIndex - nitty gritty of indexing.
 */

proc doIndex(*TTENTRY tp)void:
    register *DESCRIPTOR d0;
    register *ARRAYDIM dimPtr;
    register *ARRAYDESC ad;
    register ulong localV_value, constantOffset, multiplier;
    ulong elemSize;
    register ushort dimCount;
    ushort reg, indexSize, pow;
    TYPEKIND k;
    bool hadRunTime, firstDim, wordIndex, signedIndex, gotIndex, hadCode;
    bool bigArray, oldSignedIndex;
    byte iMode;
    ushort iReg;
    uint iWrd;
    bool freeA, freeD;

    d0 := &DescTable[0];
    ad := tp*.t_info.i_array;
    wordIndex := true;
    signedIndex := true;
    oldSignedIndex := true;
    if tp*.t_kind ~= TY_ARRAY then
	if d0*.v_type ~= TYERROR then
	    errorBack(89);	/* can't index one of these */
	fi;
	d0*.v_kind := VDVAR;	/* VLVAR on 8080 */
	d0*.v_type := TYERROR;
	dimCount := 0;
	bigArray := true;
    else
	bigArray := false;
	dimCount := ad*.ar_dimCount;
	dimPtr := &ad*.ar_dims[0];
	while dimCount ~= 0 do
	    dimCount := dimCount - 1;
	    if dimPtr*.ar_kind = AR_FLEX then
		bigArray := true;
	    fi;
	    dimPtr := dimPtr + sizeof(ARRAYDIM);
	od;
	if not bigArray then
	    bigArray := typeSize(d0*.v_type) > 0x7fff;
	fi;
	dimCount := ad*.ar_dimCount;
	dimPtr := &ad*.ar_dims[0];
	elemSize := typeSize(ad*.ar_baseType);
    fi;
    constFix();
    scan();			/* skip the '[' */
    pushDescriptor();
    hadRunTime := false;
    gotIndex := false;
    constantOffset := 0L0;
    firstDim := true;
    multiplier := 0L1;
    while Token + '\e' ~= ']' and isExpression() do
	localV_value := if dimCount = 0 then 0L1 else dimPtr*.ar_dim fi;
	/* can't check dimPtr* if run out of dims */
	if dimCount ~= 0 and dimPtr*.ar_kind = AR_FLEX then
	    /* a flex array; NOTE: the dimension passed for a flex array is
	       a 32 bit value, therefore we always use it as such */
	    if constantOffset ~= 0L0 then
		/* can ONLY get here if have had a previous index
		   which was a constant */
		wordIndex := false;
		if hadRunTime then
		    needRegs(0, 1);
		    if constantOffset <= 8 then
			opQuick(OP_ADDQ, constantOffset, S_LONG,
				M_DDIR << 3 | reg);
		    else
			opSingle(OP_ADDI, S_LONG, M_DDIR << 3 | reg);
			sourceLong(constantOffset);
		    fi;
		else
		    hadRunTime := true;
		    reg := getDReg();
		    if constantOffset <= 0xff then
			opImm(reg, constantOffset);
		    else
			opMove(OP_MOVEL, M_SPECIAL << 3 | M_IMM,
			       M_DDIR << 3 | reg);
			sourceLong(constantOffset);
		    fi;
		fi;
		constantOffset := 0L0;
		multiplier := 0L1;
	    fi;
	    if hadRunTime then
		opMove(OP_MOVEL, M_DDIR << 3 | reg, M_DDIR << 3 | 0);
		getDim(dimPtr, M_DDIR, 1);
		genCall("\e23lum_d_");
		opMove(OP_MOVEL, M_DDIR << 3 | 0, M_DDIR << 3 | reg);
		multiplier := 0L1;
	    fi;
	elif not firstDim then
	    constantOffset := constantOffset * localV_value;
	    multiplier := multiplier * localV_value;
	fi;
	if hadRunTime then
	    /* already done for FLEX, but will do nothing extra */
	    if wordIndex and multiplier > 0x7fff then
		reg := lengthenIndex(reg, signedIndex);
		wordIndex := false;
	    fi;
	    if multiplier ~= 0L1 then
		needRegs(0, 1);
		if wordIndex then
		    if isPower2(multiplier, &pow) then
			shift(reg, S_WORD, true, signedIndex, pow);
		    else
			opRegister(if signedIndex then OP_MULS else OP_MULU fi,
				   reg, M_SPECIAL << 3 | M_IMM);
			sourceWord(multiplier);
		    fi;
		else
		    multiplyBy(reg, TYULONG, multiplier);
		fi;
		multiplier := 0L1;
	    fi;
	fi;
	pAssignment();	/* get an index value */
	k := baseKind(d0*.v_type);
	if (k = TY_POINTER or k > TY_SIGNED) and
	    d0*.v_type ~= TYBYTE and d0*.v_type ~= TYERROR
	then
	    errorBack(90);
	    forceData();
	fi;
	indexSize := getSize(d0*.v_type);
	/* indexSize is size of index expression */
	if indexSize ~= S_LONG and not wordIndex then
	    fixSizeReg(TYULONG);
	    indexSize := S_LONG;
	fi;
	oldSignedIndex := signedIndex;
	if not isSigned(d0*.v_type) then
	    signedIndex := false;
	fi;
	if d0*.v_kind = VNUMBER then
	    /* a constant index - combine at compile time */
	    constantOffset := constantOffset + d0*.v_value.v_ulong;
	    if dimCount ~= 0 and dimPtr*.ar_kind = AR_FIXED and
		d0*.v_value.v_ulong > localV_value
	    then
		/* [N] t m - allow m[N] but not m[N+1] */
		errorBack(91);
	    fi;
	else
	    /* can't use word indexing if:
		index value is a long	 or
		previous indexing calculations used a long    or
		the array is too big to index with a word */
	    if indexSize ~= S_LONG and (firstDim or wordIndex) and not bigArray
	    then
		hadCode := false;
		if indexSize ~= S_WORD or d0*.v_kind ~= VRVAR then
		    fixSizeReg(TYUINT);
		    hadCode := true;
		fi;
		if hadRunTime then
		    /* if we have had run-time code, then we must have gotten
		       a scratch register, 'reg' */
		    getMode(d0, &iMode, &iReg, &iWrd, &freeA, &freeD);
		    needRegs(if freeA then 1 else 0 fi,
			     if freeD then 2 else 1 fi);
		    opModed(OP_ADD, reg, OM_REG | S_WORD, iMode << 3 | iReg);
		    tailStuff(d0, false, iMode, iReg, iWrd, freeA, freeD);
		else
		    /* first index - use register variable directly if can */
		    if elemSize ~= 1 or dimCount ~= 1 then
			putInReg();
			hadCode := true;
		    fi;
		    reg := d0*.v_value.v_reg;
		    gotIndex := true;
		fi;
		if hadCode then
		    hadRunTime := true;
		fi;
	    elif not hadRunTime and d0*.v_kind = VRVAR and elemSize = 1 and
		dimCount = 1
	    then
		if indexSize = S_BYTE then
		    fixSizeReg(TYUINT);
		    hadRunTime := true;
		elif indexSize ~= S_WORD then
		    wordIndex := false;
		fi;
		reg := d0*.v_value.v_reg;
		gotIndex := true;
	    else
		hadCode := false;
		if elemSize ~= 1 or dimCount ~= 1 or d0*.v_kind ~= VRVAR then
		    putInReg();
		    hadCode := true;
		fi;
		if wordIndex and hadRunTime then
		    reg := lengthenIndex(reg, oldSignedIndex);
		    hadCode := true;
		fi;
		if indexSize ~= S_LONG then
		    fixSizeReg(TYULONG);
		    reg := d0*.v_value.v_reg;
		    hadCode := true;
		fi;
		if hadRunTime then
		    getMode(d0, &iMode, &iReg, &iWrd, &freeA, &freeD);
		    needRegs(if freeA then 1 else 0 fi,
			     if freeD then 2 else 1 fi);
		    opModed(OP_ADD, reg, OM_REG | S_LONG, iMode << 3 | iReg);
		    tailStuff(d0, false, iMode, iReg, iWrd, freeA, freeD);
		else
		    reg := d0*.v_value.v_reg;
		    gotIndex := true;
		fi;
		if hadCode then
		    hadRunTime := true;
		fi;
		wordIndex := false;
	    fi;
	    multiplier := 0L1;
	fi;
	if dimCount = 0 then
	    if DescTable[1].v_type ~= TYERROR then
		errorThis(93);
	    fi;
	else
	    dimCount := dimCount - 1;
	    dimPtr := dimPtr + sizeof(ARRAYDIM);
	fi;
	pComma(']');
	firstDim := false;
    od;
    popDescriptor();
    if d0*.v_type ~= TYERROR and dimCount ~= 0 then
	errorThis(92);
    fi;
    localV_value := if d0*.v_type = TYERROR then 0L2 else elemSize fi;
    constantOffset := constantOffset * localV_value;
    multiplier := multiplier * localV_value;
    if d0*.v_kind = VPAR then
	putAddrInReg();
	makeIndir();
	d0*.v_value.v_indir.v_offset := constantOffset;
    elif d0*.v_kind = VEXTERN then
	d0*.v_value.v_extern.ve_offset :=
	    d0*.v_value.v_extern.ve_offset + constantOffset;
    else
	d0*.v_value.v_ulong := d0*.v_value.v_ulong + constantOffset;
    fi;
    if hadRunTime or gotIndex then
	if reg <= DRTop then
	    needRegs(0, 1);
	fi;
	if multiplier ~= 0L1 then
	    if reg > DRTop then
		iReg := getDReg();
		opMove(if wordIndex then OP_MOVEW else OP_MOVEL fi,
		       M_DDIR << 3 | reg, M_DDIR << 3 | iReg);
		reg := iReg;
	    fi;
	    if wordIndex then
		if isPower2(multiplier, &pow) then
		    shift(reg, S_WORD, true, signedIndex, pow);
		else
		    opRegister(if signedIndex then OP_MULS else OP_MULU fi,
			       reg, M_SPECIAL << 3 | M_IMM);
		    sourceWord(multiplier);
		fi;
	    else
		/* it would be nice to use the answer coming back from
		   the multiply call directly, but that won't work if a
		   move instruction ends up using two such indexes */
		multiplyBy(reg, TYULONG, multiplier);
	    fi;
	fi;
	if d0*.v_index ~= NOINDEX then
	    needRegs(0, if reg <= DRTop then 2 else 1 fi);
	    if wordIndex then
		if d0*.v_index & WORDINDEX = 0 then
		    reg := lengthenIndex(reg, signedIndex);
		    wordIndex := false;
		fi;
	    else
		if d0*.v_index & WORDINDEX ~= 0 then
		    d0*.v_index :=
			lengthenIndex(d0*.v_index & 0o7, LastWasSigned);
		fi;
	    fi;
	    opModed(OP_ADD, d0*.v_index & 0o7,
		    if wordIndex then OM_REG | S_WORD else OM_REG | S_LONG fi,
		    M_DDIR << 3 | reg);
	    if reg <= DRTop then
		freeDReg();
	    fi;
	else
	    d0*.v_index := if wordIndex then WORDINDEX else 0 fi | reg;
	fi;
    fi;
    if not signedIndex then
	LastWasSigned := false;
    fi;
    d0*.v_type :=
	if d0*.v_type = TYERROR then
	    TYERROR
	else
	    ad*.ar_baseType
	fi;
corp;

/*
 * pIndSubDot - parse and generate code for indirection, array indexing
 *		    and field selection
 */

proc pIndSubDot()void:
    register *DESCRIPTOR d0;
    *TTENTRY tp;
    register **SYMBOL fieldPtr;
    register *STRUCTDESC sd;
    register ushort fieldCount;
    TYPEKIND tKind;
    bool isStruct;

    LastWasSigned := true;
    d0 := &DescTable[0];
    pConstruct();
    while
	tp := basePtr(d0*.v_type);
	tKind := tp*.t_kind;
	/* the checks below on 'Char' would be better if we skipped over
	   white-space first, but that messes up error positioning, and
	   deletes white-space after an escaped expression in string
	   constants. Note that we would be doing one unconditionally in
	   every expression if we did one here. */
	if Token + '\e' = '*' and
	    (tKind = TY_POINTER or Char = '.' or Char = '[' or Char = ':')
	then
	    /* indirection operator */
	    if d0*.v_kind ~= VRVAR then
		putInReg();
	    fi;
	    d0*.v_type :=
		if tKind = TY_POINTER then
		    if basePtr1(tp*.t_info.i_type)*.t_kind = TY_UNKNOWN then
			errorBack(156);
			TYERROR
		    elif basePtr(tp*.t_info.i_type)*.t_kind = TY_UNDEFINED then
			errorBack(151);
			TYERROR
		    else
			tp*.t_info.i_type	  /* remove one '*' */
		    fi
		else
		    if d0*.v_type ~= TYERROR then
			errorBack(120);
		    fi;
		    TYERROR
		fi;
	    makeIndir();
	    scan();
	    true
	elif Token + '\e' = '[' then		/* index an array */
	    doIndex(tp);
	    rSquare();			/* skip the ']' */
	    true
	elif Token + '\e' = '.' then			/* field selection */
	    sd := tp*.t_info.i_struct;
	    isStruct := true;
	    if tKind ~= TY_STRUCT then
		if d0*.v_type ~= TYERROR then
		    errorBack(94);		/* can't select from these */
		fi;
		d0*.v_kind := VDVAR;   /* VLVAR on 8080 */
		isStruct := false;
	    fi;
	    constFix();
	    scan();				/* skip the '.' */
	    if Token = TID then 		/* it had better be an id! */
		if CurrentId*.sy_kind & MMMMMM ~= MFIELD then
		    d0*.v_kind := VLVAR;
		    if CurrentId*.sy_kind = MFREE then
			errorThis(16);
			CurrentId*.sy_kind := MUNDEF;
		    elif CurrentId*.sy_kind = MUNDEF then
			errorThis(17);
		    elif CurrentId*.sy_type ~= TYERROR then
			errorThis(95);		/* wasn't a field! */
		    fi;
		else	/* add in the field's offset to current offset */
		    if isStruct then
			/* see if the field is in this structure */
			fieldCount := sd*.st_fieldCount;
			fieldPtr := &sd*.st_fields[0];
			while fieldPtr* ~= CurrentId and fieldCount ~= 0 do
			    fieldCount := fieldCount - 1;
			    fieldPtr := fieldPtr + sizeof(*SYMBOL);
			od;
			if fieldCount = 0 then
			    errorThis(96);
			fi;
		    fi;
		    if d0*.v_kind = VPAR or
			d0*.v_kind = VEXTERN and
			    d0*.v_value.v_extern.ve_offset +
				CurrentId*.sy_value.sy_ulong > 0xffff
		    then
			putAddrInReg();
			makeIndir();
		    fi;
		    if d0*.v_kind = VINDIR then
			d0*.v_value.v_indir.v_offset :=
			    d0*.v_value.v_indir.v_offset +
				CurrentId*.sy_value.sy_ulong;
		    elif d0*.v_kind = VEXTERN then
			d0*.v_value.v_extern.ve_offset :=
			    d0*.v_value.v_extern.ve_offset +
				CurrentId*.sy_value.sy_ulong;
		    else
			d0*.v_value.v_ulong :=
			    d0*.v_value.v_ulong +
				CurrentId*.sy_value.sy_ulong;
		    fi;
		fi;
		/* type of result is determined from field */
		d0*.v_type := CurrentId*.sy_type;
		scan(); 		/* skip the field name */
	    else
		d0*.v_kind := VDVAR;
		d0*.v_type := TYERROR;
		errorThis(97);		/* wierd field! */
	    fi;
	    true
	elif Token + '\e' = '(' then	/* calling a proc expression */
	    pCall();
	    true
	else
	    false
	fi
    do
    od;
corp;
