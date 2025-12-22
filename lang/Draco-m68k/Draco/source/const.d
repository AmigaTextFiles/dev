#draco.g
#externs.g

/* functions dealing with string and structured constants */

/*
 * constStart - start generating a constant.
 */

proc constStart()*byte:

    if InConst then
	errorThis(84);
    fi;
    InConst := true;
    ConstLength := 0;
    ByteNext
corp;

/*
 * constByte - add a byte to the constant being built.
 */

proc constByte(byte b)void:

    if InitData then
	if not IgnoreConst then
	    genByte(b);
	fi;
    else
	if ByteNext = &ByteBuff[CBSIZE] then	/* buffer overflow! */
	    errorThis(6);
	fi;
	ByteNext* := b;
	ByteNext := ByteNext + 1;
	ConstLength := ConstLength + 1;
    fi;
corp;

/*
 * constEnd - end generation of a constant.
 */

proc constEnd(*byte startPos)*CTENT:
    register *CTENT tablePointer;
    register *byte p1, p2;
    register uint len;

    /* search for the same constant, already used. */
    tablePointer := &ConstTable[0];
    while
	/* tablePointer = ConstNext: we have hit this constant */
	if tablePointer = ConstNext then
	    false
	else
	    /* compare the constant in table with current constant */
	    p1 := tablePointer*.ct_value;
	    p2 := startPos;
	    len := ConstLength;
	    while p1* = p2* and len ~= 0 do
		len := len - 1;
		p1 := p1 + 1;
		p2 := p2 + 1;
	    od;
	    len ~= 0
	fi
    do
	tablePointer := tablePointer + sizeof(CTENT);
    od;
    if tablePointer < ConstNext then	/* no new entry, use old */
	ByteNext := startPos;
    else
	/* have a new entry, but check for ConstTable overflow.
	   We got here when tablePointer = ConstNext */
	if tablePointer >= &ConstTable[CTSIZE] then
	    errorThis(7);
	fi;
	/* put in the new ConstTable entry */
	tablePointer*.ct_value := startPos;
	tablePointer*.ct_use := REF_NULL;
	tablePointer*.ct_length := ConstLength;
	ConstNext := tablePointer + sizeof(CTENT);
    fi;
    tablePointer
corp;

/*
 * makeFloat - add a floating point constant.
 */

proc makeFloat(register *byte pFloat)*CTENT:
    *CTENT ct;
    *byte startPos;
    register uint i;
    bool wasConst;

    wasConst := InConst;
    if not wasConst then
	startPos := constStart();
    fi;
    for i from 0 upto FLOAT_BYTES - 1 do
	constByte(pFloat*);
	pFloat := pFloat + 1;
    od;
    if not wasConst then
	ct := constEnd(startPos);
    fi;
    InConst := wasConst;
    ct
corp;

/*
 * bArray - build an array constant.
 */

proc bArray(ulong lenSoFar; register *ARRAYDESC ar)ulong:
    register *ARRAYDIM dimPtr;
    register ulong count;
    TYPENUMBER t;
    register ushort i;
    bool hadError;

    t := ar*.ar_baseType;
    i := ar*.ar_dimCount;
    if i = 1 and t = TYCHAR and Token = TCHARS then
	lenSoFar := lenSoFar + ar*.ar_dims[0].ar_dim;
	if lenSoFar < ConstLength then
	    errorThis(78);
	else
	    /* pad with \e's to fill the character array */
	    while ConstLength ~= lenSoFar do
		constByte('\e' - '\e');
	    od;
	fi;
	scan();
    else
	dimPtr := &ar*.ar_dims[0];
	count := 0L1;
	while i ~= 0 do
	    i := i - 1;
	    count := count * dimPtr*.ar_dim;
	    dimPtr := dimPtr + sizeof(ARRAYDIM);
	od;
	leftParen();
	hadError := false;
	while isExpression() do
	    if count = 0L0 then
		if not hadError then
		    hadError := true;
		    errorThis(78);
		fi;
	    else
		count := count - 0L1;
	    fi;
	    lenSoFar := constBuild(lenSoFar, t);
	    pComma(')');
	od;
	if count ~= 0L0 then
	    errorThis(79);
	fi;
	rightParen();
    fi;
    lenSoFar
corp;

/*
 * constBuild - recursive routine to parse and build an array or structure
 *		constant.
 */

proc constBuild(register ulong lenSoFar; register TYPENUMBER t)ulong:
    register *DESCRIPTOR d0;
    *TTENTRY tp;
    **SYMBOL fieldPtr;
    INFOTYPE info;
    TYPEKIND tKind;
    register ushort i, depth;
    byte siz;
    bool hadError;

    d0 := &DescTable[0];
    if t ~= TYERROR and t ~= TYUNKNOWN then
	if TypeTable[t].t_align ~= 1 and lenSoFar & 0L1 ~= 0L0 then
	    constByte(0);
	    lenSoFar := lenSoFar + 0L1;
	fi;
	if t = TYBYTE then
	    lenSoFar := constBuild(lenSoFar, TYUSHORT);
	elif t = TYFLOAT then
	    pAssignment();
	    assignCompat(t);
	    if d0*.v_kind ~= VFLOAT then
		if d0*.v_type ~= TYERROR then
		    errorBack(37);
		fi;
	    else
		ignore makeFloat(&d0*.v_value.v_float[0]);
	    fi;
	    lenSoFar := lenSoFar + typeSize(t);
	else
	    tp := basePtr(t);
	    info.i_ptr := tp*.t_info.i_ptr;
	    tKind := tp*.t_kind;
	    case tKind
	    incase TY_NAMED:
		lenSoFar := constBuild(lenSoFar, tp*.t_info.i_type);
	    incase TY_UNSIGNED:
	    incase TY_SIGNED:
	    incase TY_ENUM:
		pAssignment();
		assignCompat(t);
		if d0*.v_kind ~= VNUMBER and
			d0*.v_type ~= TYERROR then
		    errorBack(37);
		fi;
		siz := getSize(t);
		if siz ~= S_BYTE then
		    if siz ~= S_WORD then
			constByte(d0*.v_value.v_ulong >> 24);
			constByte(d0*.v_value.v_ulong >> 16);
		    fi;
		    constByte(d0*.v_value.v_ulong >> 8);
		fi;
		constByte(d0*.v_value.v_ulong);
		lenSoFar := lenSoFar + typeSize(t);
	    incase TY_ARRAY:
		lenSoFar := bArray(lenSoFar, info.i_array);
	    incase TY_STRUCT:
		i := info.i_struct*.st_fieldCount;
		fieldPtr := &info.i_struct*.st_fields[0];
		leftParen();
		/* we haven't distinguished between structs and unions, so we
		   kludge it here by checking the offset of the second
		   field/member */
		if i ~= 1 and
		    info.i_struct*.st_fields[1]*.sy_value.sy_ulong = 0
		then
		    /* this is a union */
		    lenSoFar := constBuild(lenSoFar,
				    info.i_struct*.st_fields[0]*.sy_type);
		else
		    /* this is a struct */
		    hadError := false;
		    while isExpression() do
			if i = 0 then
			    if not hadError then
				hadError := true;
				errorThis(78);
			    fi;
			    if Token = '(' - '\e' then
				depth := 1;
				scan();
				while depth ~= 0 do
				    if Token = '(' - '\e' then
					depth := depth + 1;
					scan();
				    elif Token = ')' - '\e' then
					depth := depth - 1;
					scan();
				    else
					pAssignment();
					pComma(')');
				    fi;
				od;
			    else
				pAssignment();
			    fi;
			else
			    i := i - 1;
			    lenSoFar:=constBuild(lenSoFar, fieldPtr**.sy_type);
			    fieldPtr := fieldPtr + sizeof(*SYMBOL);
			fi;
			pComma(')');
		    od;
		    if i ~= 0 then
			errorThis(79);
		    fi;
		fi;
		rightParen();
	    incase TY_POINTER:
		if Token = TNIL then
		    lenSoFar := lenSoFar + 0L4;
		    constByte(0);
		    constByte(0);
		    constByte(0);
		    constByte(0);
		    scan();
		else
		    if InitData then
			lenSoFar := lenSoFar + 0L4;
			if Token = TCHARS then
			    genWord(String*.ct_use);
			    String*.ct_use := ProgramNext - &ProgramBuff[2];
			    genWordZero();
			    scan();
			else
			    if Token + '\e' = '&' then
				scan();
			    else
				errorThis(176);
			    fi;
			    pAssignment();
			    assignCompat(info.i_type);
			    case d0*.v_kind
			    incase VAVAR:
			    incase VGVAR:
			    incase VEXTERN:
				genReloc(d0*.v_kind, &d0*.v_value);
			    default:
				errorThis(178);
				genLong(0);
			    esac;
			fi;
		    else
			errorThis(152);
			findStateOrExpr();
		    fi;
		fi;
	    incase TY_PROC:
		if Token = TID then
		    lenSoFar := lenSoFar + 0L4;
		    d0*.v_type := CurrentId*.sy_type;
		    d0*.v_kind := VAPROC;
		    assignCompat(t);
		    case CurrentId*.sy_kind & MMMMMM
		    incase MPROC:
		    incase MEPROC:
			genWord(CurrentId*.sy_value.sy_uint);
			CurrentId*.sy_value.sy_uint :=
			    ProgramNext - &ProgramBuff[2];
			genWord(0);
		    incase MAPROC:
			genLong(CurrentId*.sy_value.sy_ulong);
		    default:
			errorThis(179);
			genLong(0);
		    esac;
		    scan();
		elif Token = TNIL then
		    lenSoFar := lenSoFar + 0L4;
		    constByte(0);
		    constByte(0);
		    constByte(0);
		    constByte(0);
		    scan();
		else
		    errorThis(179);
		fi;
	    default:
		errorThis(140);
		findStateOrExpr();
	    esac;
	fi;
    fi;
    lenSoFar
corp;
