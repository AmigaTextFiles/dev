#drinc:util.g
#draco.g
#externs.g

/* functions dealing with types */

uint
    CHANNELSIZE = 14,			/* # bytes in a channel */
    FILESIZE = 28;			/* # bytes (- buffer) in a file */

/*
 * allocTInfo - move up the next type info index, halting with an
 *		      error message if the table has overflowed.
 */

proc allocTInfo(ushort amount)void:

    NextTypeInfo := NextTypeInfo + amount;
    if NextTypeInfo > &TypeInfoTable[TITSIZE] then
	errorThis(13);
    fi;
corp;

/*
 * nxtFreTyp - move up and check for type table overflow.
 */

proc nxtFreTyp()void:

    NextType := NextType + 1;
    if NextType >= TTSIZE then
	errorThis(12);
    fi;
corp;

/*
 * tInit - initialize the known entries in the type table:
 */

proc tInit()void:
    uint TTCNT = 28;

    /* ***WARNING*** baseCompatible, isNumber will need changing if any
       TY_SPECIAL types are added (now TYBYTE, TYFLOAT).
       They assume that all TY_SPECIAL except floats are numeric. */

    /* ***WARNING*** this initialization is machine dependent on the HOST
       as well as the choices for the target - the numeric types assume the
       byte ordering of the host for the setup of the ranges. The same holds
       for the size of a TY_SPECIAL and range of enumerations. */

    *char TTDATA =
    /* unknown type is an undefined type */
	"\(TY_UNDEFINED - TY_POINTER)\(2)\(0)\(0)\(0)\(0)"
	"\(TY_NAMED - TY_POINTER)\(2)\(0)\(TYUNKNOWN - 1)\(0)\(0)"
    /* error type is an undefined type */
	"\(TY_NAMED - TY_POINTER)\(2)\(0)\(TYUNKNOWN - 1)\(0)\(0)"
    /* IOResult type is an undefined type */
	"\(TY_NAMED - TY_POINTER)\(1)\(0)\(TYUNKNOWN - 1)\(0)\(0)"
    /* void is an enumeration with no elements */
	"\(TY_ENUM - TY_POINTER)\(1)\(0)\(0)\(0)\(0)"
	"\(TY_NAMED - TY_POINTER)\(1)\(0)\(TYVOID - 1)\(0)\(0)"
    /* arbptr/nil is a pointer type (points to TYUNKNOWN) */
	"\(TY_POINTER - TY_POINTER)\(2)\(0)\(TYUNKNOWN)\(0)\(0)"
    /* bool is an enumeration with two constants, false and true */
	"\(TY_ENUM - TY_POINTER)\(1)\(0)\(0)\(0)\(2)"
	"\(TY_NAMED - TY_POINTER)\(1)\(0)\(TYBOOL - 1)\(0)\(0)"
    /* char is an enumeration type with 256 values */
	"\(TY_ENUM - TY_POINTER)\(1)\(0)\(0)\(1)\(0)"
	"\(TY_NAMED - TY_POINTER)\(1)\(0)\(TYCHAR - 1)\(0)\(0)"
    /* byte is a special type of size 1 */
	"\(TY_SPECIAL - TY_POINTER)\(1)\(0)\(0)\(0)\(1)"
	"\(TY_NAMED - TY_POINTER)\(1)\(0)\(TYBYTE - 1)\(0)\(0)"
    /* ushort is an unsigned type with upper bound of 255 */
	"\(TY_UNSIGNED - TY_POINTER)\(1)\(0)\(0)\(0)\(0xff)"
	"\(TY_NAMED - TY_POINTER)\(1)\(0)\(TYUSHORT - 1)\(0)\(0)"
    /* short is a signed type with upper bound of 127 */
	"\(TY_SIGNED - TY_POINTER)\(1)\(0)\(0)\(0)\(0x7f)"
	"\(TY_NAMED - TY_POINTER)\(1)\(0)\(TYSHORT - 1)\(0)\(0)"
    /* uint is an unsigned type with upper bound of 65535 */
	"\(TY_UNSIGNED - TY_POINTER)\(2)\(0)\(0)\(0xff)\(0xff)"
	"\(TY_NAMED - TY_POINTER)\(2)\(0)\(TYUINT - 1)\(0)\(0)"
    /* int is a signed type with upper bound of 32767 */
	"\(TY_SIGNED - TY_POINTER)\(2)\(0)\(0)\(0x7f)\(0xff)"
	"\(TY_NAMED - TY_POINTER)\(2)\(0)\(TYINT - 1)\(0)\(0)"
    /* TYCHARS is pointer to char */
	"\(TY_POINTER - TY_POINTER)\(2)\(0)\(TYCHAR)\(0)\(0)"
    /* long is a signed type with upper bound of 2147483647 */
	"\(TY_SIGNED - TY_POINTER)\(2)\(0x7f)\(0xff)\(0xff)\(0xff)"
	"\(TY_NAMED - TY_POINTER)\(2)\(0)\(TYLONG - 1)\(0)\(0)"
    /* ulong is an unsigned type with upper bound 4294967295 */
	"\(TY_UNSIGNED - TY_POINTER)\(2)\(0xff)\(0xff)\(0xff)\(0xff)"
	"\(TY_NAMED - TY_POINTER)\(2)\(0)\(TYULONG - 1)\(0)\(0)"
    /* float is special type of size FLOAT_BYTES */
	"\(TY_SPECIAL - TY_POINTER)\(2)\(0)\(0)\(0)\(FLOAT_BYTES)"
	"\(TY_NAMED - TY_POINTER)\(2)\(0)\(TYFLOAT - 1)\(0)\(0)";

    pretend(TypeTable, [TTCNT * sizeof(TTENTRY)] char) :=
	pretend(TTDATA, * [TTCNT * sizeof(TTENTRY)] char)*;
    NextType := TYFLOAT + 1;
    if TTCNT ~= TYFLOAT + 1 then
	error("TTCNT ~= TYFLOAT + 1 in 'tInit'");
    fi;
    NextTypeInfo := &TypeInfoTable[0];
corp;

/*
 * typeSize - return the size in bytes occupied by the passed
 *	      type.
 */

proc typeSize(register TYPENUMBER t)ulong:
    INFOTYPE info;
    register ulong size;
    register *ARRAYDIM dimPtr;
    register ushort i @ t;

    if t = TYERROR or t = TYUNKNOWN then
	0L2
    else
	info.i_ulong := TypeTable[t].t_info.i_ulong;
	case TypeTable[t].t_kind
	incase TY_POINTER:
	incase TY_PROC:
/*
	    sizeof(proc()void)
*/
	    0L4
	incase TY_UNSIGNED:
	    if info.i_range > 0L65535 then
		0L4
	    elif info.i_range > 0L255 then
		0L2
	    else
		0L1
	    fi
	incase TY_ENUM:
	    if info.i_range > 0L65536 then
		0L4
	    elif info.i_range > 0L256 then
		0L2
	    else
		0L1
	    fi
	incase TY_SIGNED:
	    if info.i_range > 0L32767 then
		0L4
	    elif info.i_range > 0L127 then
		0L2
	    else
		0L1
	    fi
	incase TY_ARRAY:
	    size := typeSize(info.i_array*.ar_baseType);
	    i := info.i_array*.ar_dimCount;
	    dimPtr := &info.i_array*.ar_dims[0];
	    while i ~= 0 do
		i := i - 1;
		if dimPtr*.ar_kind = AR_FIXED then
		    size := size * dimPtr*.ar_dim;
		else
		    errorBack(31);
		fi;
		dimPtr := dimPtr + sizeof(ARRAYDIM);
	    od;
	    size
	incase TY_FILE:
	    info.i_ulong + FILESIZE
	incase TY_CHANNEL:
	    make(CHANNELSIZE, ulong)
	incase TY_STRUCT:
	    info.i_struct*.st_size
	incase TY_SPECIAL:
	incase TY_UNKNOWN:
	    info.i_ulong
	incase TY_UNDEFINED:
	    0L2
	incase TY_NAMED:
	    typeSize(info.i_type)
	incase TY_OP:
	    typeSize(info.i_op*.op_baseType)
	default:
	    errorBack(14);
	    0L2
	esac
    fi
corp;

/*
 * basePtr1 - skip down past a TY_NAMED level in a type structure.
 */

proc basePtr1(TYPENUMBER t)*TTENTRY:
    *TTENTRY tp;

    tp := &TypeTable[t];
    if tp*.t_kind = TY_NAMED then
	tp := &TypeTable[tp*.t_info.i_type];
    fi;
    tp
corp;

/*
 * basePtr - return the base type info pointer for the given type.
 */

proc basePtr(TYPENUMBER t)*TTENTRY:
    *TTENTRY tp;

    tp := basePtr1(t);
    if tp*.t_kind = TY_OP then
	tp := &TypeTable[tp*.t_info.i_op*.op_baseType];
    fi;
    tp
corp;

/*
 * baseKind - return the base kind of the given type.
 */

proc baseKind(TYPENUMBER t)TYPEKIND:

    basePtr(t)*.t_kind
corp;

/*
 * baseKind1 - return the base kind of the type if not TY_OP.
 */

proc baseKind1(TYPENUMBER t)TYPEKIND:

    basePtr1(t)*.t_kind
corp;

/*
 * isNumber - quick check to see if a type is a numeric type.
 */

proc isNumber(TYPENUMBER t)bool:

    t = TYBYTE or
	(baseKind(t) - TY_POINTER) & 0xfe + TY_POINTER = TY_UNSIGNED
corp;

/*
 * isSigned - quick check to see if a type is a signed numeric type.
 */

proc isSigned(TYPENUMBER t)bool:

    baseKind(t) = TY_SIGNED
corp;

/*
 * isSimple - quick check to see if a type is a simple type.
 */

proc isSimple(register TYPENUMBER t)bool:
    register TYPEKIND k @ t;

    if t = TYERROR or t = TYUNKNOWN or t = TYBYTE or t = TYIORESULT then
	true
    else
	k := baseKind1(t);
	k = TY_POINTER or k = TY_ENUM or k = TY_UNSIGNED or k = TY_SIGNED or
	    k = TY_PROC
    fi
corp;

/*
 * isOp - return 'true' if the TOS type is an operator type.
 */

proc isOp()bool:

    baseKind1(DescTable[0].v_type) = TY_OP
corp;

/*
 * isAddress - return 'true' if the passed type lives in an address register.
 */

proc isAddress(register TYPENUMBER t)bool:
    register TYPEKIND kind @ t;

    if t = TYBYTE or t = TYIORESULT or t = TYERROR or t = TYUNKNOWN then
	false
    else
	kind := baseKind(t);
	kind ~= TY_SIGNED and kind ~= TY_UNSIGNED and kind ~= TY_ENUM
    fi
corp;

/*
 * getSize - return the size code for the given value.
 */

proc getSize(register TYPENUMBER t)byte:
    *TTENTRY tp;
    INFOTYPE info @ tp;
    register TYPEKIND kind @ t;

    if t = TYBYTE or t = TYIORESULT then
	S_BYTE
    elif t = TYERROR or t = TYUNKNOWN then
	/* be consistent with 'typeSize' */
	S_WORD
    else
	tp := basePtr(t);
	kind := tp*.t_kind;
	info.i_ulong := tp*.t_info.i_ulong;
	if kind = TY_ENUM then
	    if info.i_range <= 0L256 then
		S_BYTE
	    elif info.i_range <= 0L65536 then
		S_WORD
	    else
		S_LONG
	    fi
	elif kind = TY_UNSIGNED then
	    if info.i_range <= 0L255 then
		S_BYTE
	    elif info.i_range <= 0L65535 then
		S_WORD
	    else
		S_LONG
	    fi
	elif kind = TY_SIGNED then
	    if info.i_range <= 0L127 then
		S_BYTE
	    elif info.i_range <= 0L32767 then
		S_WORD
	    else
		S_LONG
	    fi
	else
	    S_LADDR
	fi
    fi
corp;

/*
 * notStatement - test to see if the given type isn't a statement.
 */

proc notStatement(TYPENUMBER t)bool:

    t > TYVOID or t = TYUNKNOWN
corp;

/*
 * chkDup - check the latest type entered into the type table
 *		    to see if it is equivalent to one already in the
 *		    table. If so, we want to replace the new type with the
 *		    older one, deleting the new one from the table. We
 *		    return whatever type we end up with.
 *		    Note that TY_UNKNOWN types are never equivalent here since
 *		    their equivalence is based on names, not structures.
 */

proc chkDup(register TYPENUMBER newType)TYPENUMBER:
    INFOTYPE newInfo, oldInfo, info;
    register *TTENTRY tp;
    register *ARRAYDIM dimPtr, oldDimPtr;
    register *TYPENUMBER parPtr @ dimPtr, oldParPtr @ oldDimPtr;
    register TYPENUMBER oldType;
    register TYPEKIND newKind;
    register ushort count;
    bool foundOne;

    tp := &TypeTable[newType];
    newKind := tp*.t_kind;
    newInfo.i_ulong := tp*.t_info.i_ulong;
    /* scan the type table looking for an equivalent type: */
    foundOne := false;
    tp := &TypeTable[0];
    oldType := 0;
    while not foundOne and oldType ~= newType do
	oldType := oldType + 1;
	if tp*.t_kind = newKind then
	    /* an entry of the same kind */
	    oldInfo.i_ulong := tp*.t_info.i_ulong;
	    info.i_ulong := newInfo.i_ulong;
	    if newKind = TY_UNSIGNED or newKind = TY_SIGNED then
		/* they are the same if the ranges are the same */
		if oldInfo.i_range = newInfo.i_range then
		    foundOne := true;
		fi;
	    elif newKind = TY_FILE then
		if oldInfo.i_ulong = newInfo.i_ulong then
		    foundOne := true;
		fi;
	    elif newKind = TY_CHANNEL then
		/* cheat, using a word to test the two booleans */
		if oldInfo.i_uint = newInfo.i_uint then
		    foundOne := true;
		fi;
	    elif newKind = TY_POINTER then
		/* a pointer type, just use the TYPENUMBER */
		if oldInfo.i_type = newInfo.i_type then
		    foundOne := true;
		fi;
	    elif newKind = TY_ARRAY then
		/* compare two array types. scan all of the dimensions */
		count := info.i_array*.ar_dimCount;
		if oldInfo.i_array*.ar_baseType =
			    info.i_array*.ar_baseType and
			oldInfo.i_array*.ar_dimCount = count then
		    oldDimPtr := &oldInfo.i_array*.ar_dims[0];
		    dimPtr := &info.i_array*.ar_dims[0];
		    /* flex array types ([*]) are never equivalent */
		    while count ~= 0 and oldDimPtr*.ar_kind ~= AR_FLEX and
			    dimPtr*.ar_kind ~= AR_FLEX and
			    dimPtr*.ar_dim = oldDimPtr*.ar_dim do
			count := count - 1;
			dimPtr := dimPtr + sizeof(ARRAYDIM);
			oldDimPtr := oldDimPtr + sizeof(ARRAYDIM);
		    od;
		    if count = 0 then
			foundOne := true;
		    fi;
		fi;
	    elif newKind = TY_PROC then
		/* compare two proc types. scan all of the param types */
		count := info.i_proc*.p_parCount;
		if oldInfo.i_proc*.p_resultType =
			    info.i_proc*.p_resultType and
			oldInfo.i_proc*.p_parCount = count then
		    oldParPtr := &oldInfo.i_proc*.p_parTypes[0];
		    parPtr := &info.i_proc*.p_parTypes[0];
		    while count ~= 0 and oldParPtr* = parPtr* do
			count := count - 1;
			parPtr := parPtr + sizeof(TYPENUMBER);
			oldParPtr := oldParPtr + sizeof(TYPENUMBER);
		    od;
		    if count = 0 then
			foundOne := true;
		    fi;
		fi;
	    else
		errorThis(14);
	    fi;
	fi;
	tp := tp + sizeof(TTENTRY);
    od;
    if foundOne then
	/* found an earlier equivalent type. Delete new one and its info. */
	NextType := newType;
	if newKind = TY_ARRAY or newKind = TY_PROC then
	    NextTypeInfo := newInfo.i_ptr;
	fi;
	oldType - 1
    else
	newType
    fi
corp;

/*
 * tFix - shuffle up the type info table to make room for new stuff.
 */

proc tFix(register TYPENUMBER t; *byte info; ushort amount)void:
    register *TTENTRY tp;
    register TYPENUMBER tt;
    register TYPEKIND kind;

    /* here comes a wierd bit. If the type parsed was or contained a
       proc, array or structure type, then that type could have used up
       some entries in the type information table. If that happened,
       those entries must be moved up, beyond the slots needed by this
       proc or structure type. This must be done each time any parameter
       or field is declared, since that declaration uses up space in the
       table. */
    allocTInfo(amount);
    /* as mentioned above, must move type info up one */
    BlockCopyB(NextTypeInfo - 1, NextTypeInfo - amount - 1,
	       NextTypeInfo - info - amount);
    /* we must also change any entries in the type table */
    tt := NextType - 1;
    tp := &TypeTable[tt];
    while tt ~= t do
	tt := tt - 1;
	kind := tp*.t_kind;
	if kind = TY_STRUCT or kind = TY_ARRAY or
		kind = TY_OP or kind = TY_PROC then
	    tp*.t_info.i_ptr := tp*.t_info.i_ptr + amount;
	fi;
	tp := tp - sizeof(TTENTRY);
    od;
corp;

/*
 * bCmpat - if possible, fix a constant so that it matches the
 *		    type required. Complain if it works but is too big.
 *		    Also check resulting types for compatibility, and
 *		    complain when necessary. Return true if are compat.
 */

proc bCmpat(register TYPENUMBER oldType)bool:
    register *TTENTRY tp;
    ulong typeRange;
    long typeRangeS @ typeRange;
    register TYPENUMBER newType;
    TYPENUMBER newBaseType, oldBaseType;
    register TYPEKIND newBaseKind, oldBaseKind;
    TYPEKIND oldKind, newKind;

    newType := DescTable[0].v_type;
    if newType = TYIORESULT and oldType = TYBOOL then
	newType := TYBOOL;
    elif oldType = TYIORESULT and newType = TYBOOL then
	oldType := TYBOOL;
    fi;
    if newType = oldType or newType = TYERROR or oldType = TYERROR then
	true
    else
	newBaseType := newType;
	tp := &TypeTable[newType];
	newKind := tp*.t_kind;
	newBaseKind := newKind;
	if newKind = TY_NAMED then
	    newBaseType := tp*.t_info.i_type;
	    tp := &TypeTable[newBaseType];
	    newBaseKind := tp*.t_kind;
	    if newBaseKind = TY_OP then
		newBaseType := tp*.t_info.i_op*.op_baseType;
		newBaseKind := TypeTable[newBaseType].t_kind;
	    fi;
	fi;
	oldBaseType := oldType;
	tp := &TypeTable[oldType];
	oldKind := tp*.t_kind;
	oldBaseKind := oldKind;
	if oldKind = TY_NAMED then
	    oldBaseType := tp*.t_info.i_type;
	    tp := &TypeTable[oldBaseType];
	    oldBaseKind := tp*.t_kind;
	    if oldBaseKind = TY_OP then
		oldBaseType := tp*.t_info.i_op*.op_baseType;
		tp := &TypeTable[oldBaseType];
		oldBaseKind := tp*.t_kind;
	    fi;
	fi;
	if DescTable[0].v_kind = VNUMBER and newBaseKind ~= TY_ENUM and
		newType ~= TYNIL and
		(oldBaseKind = TY_SIGNED or oldBaseKind = TY_UNSIGNED or
		 oldType = TYBYTE) then
	    typeRange :=
		if oldType = TYBYTE then 0L255 else tp*.t_info.i_range fi;
	    if oldBaseKind = TY_SIGNED and
		    (DescTable[0].v_value.v_long > typeRangeS or
		     DescTable[0].v_value.v_long < - (typeRangeS + 0L1)) or
		oldBaseKind = TY_UNSIGNED and
		     DescTable[0].v_value.v_ulong > typeRange
	    then
		errorBack(55);
	    fi;
	    newType := oldType;
	    DescTable[0].v_type := newType;
	    newKind := oldKind;
	    newBaseType := oldBaseType;
	    newBaseKind := oldBaseKind;
	fi;
	(oldBaseKind = TY_SIGNED or oldBaseKind = TY_UNSIGNED or
		oldType = TYBYTE) and
	    (newBaseKind = TY_SIGNED or newBaseKind = TY_UNSIGNED or
		newType = TYBYTE) or
	(newKind ~= TY_NAMED or oldKind ~= TY_NAMED) and
	    (newBaseType = oldBaseType or
	     oldType = TYNIL and (newBaseKind = TY_POINTER or
				  newBaseKind = TY_PROC) or
	     newType = TYNIL and (oldBaseKind = TY_POINTER or
				  oldBaseKind = TY_PROC))
    fi
corp;

/*
 * assignCompat - test the given new value to see if it is of a type which
 *		  is assignment compatible with the given type. This routine
 *		  is used for assignment statements, constant declarations
 *		  and to check the final results of procs.
 */

proc assignCompat(TYPENUMBER oldType)void:

    if DescTable[0].v_type = TYVOID then
	errorBack(56);
	DescTable[0].v_type := TYERROR;
	DescTable[0].v_kind := VREG;
    elif not bCmpat(oldType) then
	errorBack(57);
    fi;
corp;

/*
 * ifCompatible - test the given new value to see if it is of a type which
 *		  is compatible with the already established type. If the
 *		  old type isn't set yet, then just use, and return, the
 *		  type of the new value. This routine is intended to be
 *		  used in the branches of 'if's and 'case's.
 */

proc ifCompatible(register TYPENUMBER oldType)TYPENUMBER:
    register TYPENUMBER d0Type;

    d0Type := DescTable[0].v_type;
    if oldType = TYUNKNOWN then
	oldType := d0Type;
    else
	if oldType = TYVOID or d0Type = TYVOID then
	    if	oldType = TYVOID and d0Type ~= TYVOID and
		    d0Type ~= TYIORESULT and d0Type ~= TYERROR or
		d0Type = TYVOID and oldType ~= TYVOID and
		    oldType ~= TYIORESULT and oldType ~= TYERROR
	    then
		errorBack(58);
	    fi;
	elif not bCmpat(oldType) then
	    errorBack(59);
	fi;
    fi;
    oldType
corp;

/*
 * makePtrTo - make a type which is a pointer to another type.
 */

proc makePtrTo(TYPENUMBER t)TYPENUMBER:
    *TTENTRY tp;

    if t = TYERROR then
	TYNIL
    else
	tp := &TypeTable[NextType];
	tp*.t_kind := TY_POINTER;
	tp*.t_info.i_type := t;
	nxtFreTyp();
	chkDup(NextType - 1)
    fi
corp;
