#draco.g
#externs.g

/* parse/code-gen for 'if', 'while', and procedure calls */

/*
 * pIf - parse and generate code for if statements and expressions
 */

proc pIf()void:
    register *DESCRIPTOR d0;
    DESCRIPTOR resultDesc;
    *BRENTRY brStart;
    *ushort regStackPos;
    register uint branchChain, lastBranch, doneChain;
    uint falseChainSave, trueChainSave;
    ushort reg, reg1;
    TYPENUMBER oldType;
    bool first, decided, ignoreSave, thisTrue, wasConstant, allConstant;
    bool floatSaved;

    d0 := &DescTable[0];
    brStart := BranchTableNext;
    falseChainSave := FalseChain;
    trueChainSave := TrueChain;
    ignoreSave := Ignore;
    oldType := TYUNKNOWN;	/* don't have a valid type yet */
    first := true;		/* next alternative will be the first one */
    allConstant := true;	/* all conditions have been constants */
    decided := false;		/* not yet decided on the type of result */
    wasConstant := false;	/* last condition wasn't a constant */
    FalseChain := BRANCH_NULL;
    TrueChain := BRANCH_NULL;
    doneChain := BRANCH_NULL;	/* no end-alternative jumps to fix up yet */
    /* this is quite unfortunate, but I do not see an alternative. We need
       all possible routes to any given piece of code to have the same
       register stack state. Since even the initial condition might contain
       internal branches, the only universally known state is that before
       we start anything. Thus, all alternatives are forced to pop the stack
       to this early known state. (None will have to push to this state,
       since they all have this state as a predecessor.) If all temporary
       registers were occupied at this point, fixing to this state would
       wipe out the value of any conditional expression, so we have to
       make sure at least one of each type of register is available for use */
    floatSaved := false;
    if FloatBusy then
	FloatBusy := false;
	floatSaved := true;
	opSpecial(OP_SAVEM | M_DEC << 3 | RSP);
	sourceWord(0xc000);
	d0*.v_value.v_reg := 0xff;
    fi;
    reg := getDReg();
    freeDReg();
    reg := getAReg();
    freeAReg();
    regStackPos := NextRegStack;
    while			/* loop for each 'if' or 'elif' part */
	if not first then	/* if had prev alternative, close it off */
	    if oldType = TYIORESULT then
		oldType := TYBOOL;
	    fi;
	    /* don't generate code here if have already picked an alternative
	       or the entire if is being ignored or the last condition was a
	       constant and didn't generate a jump */
	    Ignore := decided or ignoreSave or wasConstant;
	    doneChain := ifJump(doneChain, lastBranch, branchChain);
	    /* put the register allocation state back to what it was at the
	       beginning of the previous alternative body */
	    if d0*.v_kind = VREG and
		baseKind1(d0*.v_type) ~= TY_OP and d0*.v_type ~= TYFLOAT
	    then
		if isAddress(oldType) then
		    freeAReg();
		else
		    freeDReg();
		fi;
	    fi;
	fi;
	scan(); 			/* skip the 'if' or 'elif' */
	/* don't generate code if result of the if is already decided (some
	   past condition was true) or if the whole if is being ignored */
	Ignore := decided or ignoreSave;
	reg1 := getDReg();
	freeDReg();
	pAssignment();	/* get cond. for this alternative */
	wasConstant := false;
	if d0*.v_kind = VNUMBER then  /* condition was a constant */
	    thisTrue := make(d0*.v_value.v_ulong, ushort) + false;
	    Ignore := true;
	    wasConstant := true;
	else
	    /* if the condition itself causes some stacking, then we must undo
	       the stacking before the conditional branch, since it is later,
	       after possibly much stacking/unstacking in an alternative, that
	       we need to get back to that state again. */
	    if NextRegStack ~= regStackPos then
		putInReg();
		/* this icky is needed so that we are sure we use the reg
		   that we know is free. If we don't, the 'fixTo' just
		   below might want to restore (and make busy) the reg we
		   have just put the boolean result into. This happened
		   in 'EmpCre.d'. */
		forceData();
		if d0*.v_value.v_reg ~= reg then
		    switchReg(reg1, TYBOOL);
		fi;
		fixTo(regStackPos);
	    fi;
	    if not decided then
		allConstant := false;
	    fi;
	fi;
	lastBranch := condition(false);  /* generate cond. jump */
	/* the body of this alternative is not generated if some other body
	   was unconditionally used or if the entire if is being ignored or
	   the condition was a false constant */
	Ignore := decided or ignoreSave or wasConstant and not thisTrue;
	/* we save the CurrentA and CurrentHL status here so that we can
	   put it back after this alternative. Note that it is OK to sample
	   before doing the fixChain since it is the fixChain to the start
	   of the next alternative that is the one which must reset any
	   knowledge of the contents of A and HL. */
	if Token = TTHEN then
	    scan();
	else
	    errorThis(60);
	    findStateOrExpr();
	fi;
	if TrueChain ~= BRANCH_NULL then
	    forgetRegs();
	    fixChain(TrueChain);	/* true branches of cond. come here*/
	fi;
	branchChain := FalseChain;	/* false branches go to next alt. */
	FalseChain := BRANCH_NULL;
	TrueChain := BRANCH_NULL;
	oldType := ifPart(oldType, allConstant);
	if d0*.v_kind = VREG and baseKind1(d0*.v_type) ~= TY_OP and
	    d0*.v_type ~= TYFLOAT
	then
	    if first then
		reg := d0*.v_value.v_reg;
	    elif d0*.v_value.v_reg ~= reg then
		switchReg(reg, oldType);
	    fi;
	fi;
	fixTo(regStackPos);
	if wasConstant and thisTrue and not decided then
	    /* if this alternative had a constant true condition, then no
	       other alternative need be generated */
	    resultDesc := d0*;
	    decided := true;
	fi;
	first := false;
	FloatBusy := false;
	Token = TELIF
    do
    od;
    if Token ~= TFI and Token ~= TELSE then
	errorThis(61);
	findStateOrExpr();
    fi;
    if Token = TELSE then
	Ignore := decided or ignoreSave or wasConstant;
	doneChain := ifJump(doneChain, lastBranch, branchChain);
	if d0*.v_kind = VREG and baseKind1(d0*.v_type) ~= TY_OP and
	    d0*.v_type ~= TYFLOAT
	then
	    if isAddress(oldType) then
		freeAReg();
	    else
		freeDReg();
	    fi;
	fi;
	Ignore := decided or ignoreSave;
	scan();
	oldType := ifPart(oldType, allConstant);
	if d0*.v_kind = VREG and baseKind1(d0*.v_type) ~= TY_OP and
	    d0*.v_type ~= TYFLOAT and d0*.v_value.v_reg ~= reg
	then
	    switchReg(reg, oldType);
	fi;
	fixTo(regStackPos);
	if allConstant and not decided then
	    resultDesc := d0*;
	    decided := true;
	fi;
    else
	if notStatement(oldType) then
	    errorThis(62);	/* if expressions must have an else part */
	    decided := true;
	fi;
	if regStackPos ~= NextRegStack then
	    doneChain := ifJump(doneChain, lastBranch, branchChain);
	else
	    /* do some of the stuff that ifJump would do otherwise */
	    fixChain(lastBranch);
	    fixChain(branchChain);
	    forgetRegs();
	fi;
	fixTo(regStackPos);
/* This seems to be not necessary, and causes a concheck with
	if f then write(i) fi;
   anyway. Removed for now
*/
/*
	/* first part of the 'if' was an I/O construct which might return
	   a boolean. There is no 'else' part, so obviously this is
	   supposed to be a statement - so we free the register that we
	   have the boolean in */
	if oldType = TYIORESULT then
	    if d0*.v_kind = VREG and d0*.v_value.v_reg ~= 0 then
		freeDReg();
	    fi;
	fi;
*/
    fi;
    Ignore := ignoreSave;
    FalseChain := falseChainSave;
    TrueChain := trueChainSave;
    fixChain(doneChain);	/* all end-of-alternative jumps come here */
    shortenBranches(brStart);	/* magically shorten all the branches */
    forgetRegs();
    if Token = TFI then
	scan();
    else
	errorThis(63);
	findStateOrExpr();
    fi;
    if allConstant then 	/* all conditions were constants */
	if decided then 	/* some alternative was selected */
	    d0* := resultDesc;
	else			/* no alternative selected */
	    voidIt();
	fi;
    else
	if oldType ~= TYFLOAT and floatSaved then
	    opSpecial(OP_RESTM | M_INC << 3 | RSP);
	    sourceWord(0x0003);
	    FloatBusy := true;
	fi;
	condEnd(oldType);
    fi;
corp;

/*
 * pWhile - parse and generate code for while statements
 */

proc pWhile()void:
    register *byte loopPosition;
    *ushort regStackPos;
    *BRENTRY brStart;
    uint lastBranch, branchChain, falseChainSave, trueChainSave, brSize;

    falseChainSave := FalseChain;
    trueChainSave := TrueChain;
    FalseChain := BRANCH_NULL;
    TrueChain := BRANCH_NULL;
    scan();
    peepFlush();
    forgetRegs();
    loopPosition := ProgramNext;	/* jump back here */
    regStackPos := NextRegStack;
    brStart := BranchTableNext;
    statements();			/* the condition */
    checkDo();
    if Token = TOD then
	/* special optimization: if there is no body, then just do a
	   conditional branch back to the beginning. */
	fixTo(regStackPos);
	lastBranch := condition(true);
	if TrueChain = BRANCH_NULL and not Ignore then
	    /* only one backwards branch - we can handle it here */
	    peepFlush();
	    if &ProgramBuff[lastBranch] - loopPosition <= 128 then
		ProgramNext := ProgramNext - 2;
		brSize := 2;
	    else
		brSize := 4;
	    fi;
	    fixChain(FalseChain);
	    shortenBranches(brStart);
	    /* the above call may have moved lots of code back. We now fix up
	       the looping branch to still be correct. We carefully make sure
	       it doesn't change size! */
	    if not Ignore then
		if brSize = 2 then
		    (ProgramNext - 1)* := loopPosition - ProgramNext;
		else
		    (ProgramNextWord - 2)* := loopPosition - ProgramNext + 2;
		fi;
	    fi;
	else
	    fixChainImmediate(FalseChain);
	    fixChainTo(lastBranch, loopPosition);
	    fixChainTo(TrueChain, loopPosition);
	    BranchTableNext := brStart; 	    /* can't shorten them */
	fi;
    else
	lastBranch := condition(false);
	if TrueChain ~= BRANCH_NULL then
	    forgetRegs();
	    fixChain(TrueChain);
	fi;
	branchChain := FalseChain;
	FalseChain := BRANCH_NULL;
	TrueChain := BRANCH_NULL;
	statements();		/* the body of the while loop */
	if notStatement(DescTable[0].v_type) then
	    errorBack(66);	/* it had better not be an expression */
	fi;
	fixTo(regStackPos);
	/* jump back to the beginning of the loop */
	fixChainTo(HereChain, loopPosition);
	HereChain := BRANCH_NULL;
	peepFlush();
	brSize := if ProgramNext + 2 - loopPosition > 128 then 4 else 2 fi;
	branchTo(CC_T, loopPosition);
	/* fix exit jump to come here */
	fixChain(lastBranch);
	fixChain(branchChain);	/* also fix any false branches to jump here*/
	shortenBranches(brStart);
	/* the above call may have moved lots of code back. We now fix up
	   the looping branch to still be correct. We carefully make sure
	   it doesn't change size! */
	if not Ignore then
	    if brSize = 2 then
		(ProgramNext - 1)* := loopPosition - ProgramNext;
	    else
		(ProgramNextWord - 2)* := loopPosition - ProgramNext + 2;
	    fi;
	fi;
    fi;
    forgetRegs();
    voidIt();
    FalseChain := falseChainSave;
    TrueChain := trueChainSave;
    checkOd();
corp;

/*
 * callTail - tail end of procedure calling.
 */

proc callTail(uint parCnt)void:
    register *DESCRIPTOR d0;
    *TTENTRY tp;
    byte size;

    d0 := &DescTable[0];
    if d0*.v_kind = VREG or d0*.v_kind = VRVAR then
	if not isAddress(d0*.v_type) then
	    /* e.g. undefined symbol, will yield data reg */
	    size := getAReg();
	    opMove(OP_MOVEL, M_DDIR << 3 | d0*.v_value.v_reg,
		   M_ADIR << 3 | size);
	    freeDReg();
	    d0*.v_value.v_reg := size;
	fi;
	if d0*.v_kind = VREG then
	    needRegs(1, 0);
	fi;
	opEA(OP_JSR, M_INDIR << 3 | d0*.v_value.v_reg);
	if d0*.v_kind = VREG then
	    freeAReg();
	fi;
    elif d0*.v_kind = VPROC or d0*.v_kind = VAPROC then
	opEA(OP_JSR, M_SPECIAL << 3 | M_ABSLONG);
	opReloc(d0, true);
    else
	conCheck(6);
    fi;
    if CStyleCall then
	CStyleCall := false;
	addrCon(true, RSP, parCnt);
    fi;
    tp := basePtr(d0*.v_type);
    d0*.v_type :=
	if tp*.t_kind = TY_PROC then
	    tp*.t_info.i_proc*.p_resultType
	else
	    TYERROR
	fi;
    condEnd(d0*.v_type);
    if d0*.v_type ~= TYVOID and d0*.v_type ~= TYFLOAT and
	baseKind1(d0*.v_type) ~= TY_OP
    then
	size := getSize(d0*.v_type);
	if size = S_LADDR then
	    d0*.v_value.v_reg := getAReg();
	    opMove(OP_MOVEL, M_DDIR << 3 | 0, M_ADIR << 3 | d0*.v_value.v_reg);
	    if not isSimple(d0*.v_type) then
		makeIndir();
	    fi;
	else
	    d0*.v_value.v_reg := getDReg();
	    opMove(
		if size = S_BYTE then
		    OP_MOVEB
		elif size = S_WORD then
		    OP_MOVEW
		else
		    OP_MOVEL
		fi,
		M_DDIR << 3 | 0, M_DDIR << 3 | d0*.v_value.v_reg
	    );
	fi;
    fi;
    forgetFreeRegs();
    CCIsReg := false;
    CCKind := VVOID;
corp;

/*
 * pCall - parse and generate code for a procedure call
 */

proc pCall()void:
    register *DESCRIPTOR d0;
    register *TTENTRY tPtr1;
    register *ARRAYDIM dimPtr1 @ tPtr1;
    register *ARRAYDESC ad @ tPtr1;
    *TTENTRY tp, tPtr2;
    *ARRAYDIM dimPtr2 @ tPtr2;
    register *TYPENUMBER p;
    *ushort regStackPos;
    uint parCnt;
    register TYPENUMBER thisFormal, thisActual;
    TYPENUMBER lastFormal, lastActual;
    register ushort dimCount;
    ushort pCount;
    byte size;
    bool kludged, pushedA1;

    d0 := &DescTable[0];
    if d0*.v_kind ~= VPROC and d0*.v_kind ~= VAPROC and d0*.v_kind ~= VRVAR
    then
	putInReg();
    fi;
    /* for much the same reason as in 'if' and 'case', we have to make sure
       there is one register of each type available for parameters */
    if FloatBusy then
	FloatBusy := false;
	opSpecial(OP_SAVEM | M_DEC << 3 | RSP);
	sourceWord(0xc000);
	d0*.v_value.v_reg := 0xff;
    fi;
    dimCount := getDReg();
    freeDReg();
    dimCount := getAReg();
    freeAReg();
    /* note that this A1 save/restore must be after the previous register
       fiddling, since it will be done first after the call */
    pushedA1 := A1Busy();
    if pushedA1 then
	peepFlush();	/* in case proc value ended up in A1 */
	opMove(OP_MOVEL, M_ADIR << 3 | 1, M_DEC << 3 | RSP);
    fi;
    regStackPos := NextRegStack;
    tp := basePtr(d0*.v_type);
    p :=
	if tp*.t_kind ~= TY_PROC then
	    if d0*.v_type ~= TYERROR then
		errorBack(71);
	    fi;
	    nil
	else
	    pCount := tp*.t_info.i_proc*.p_parCount;
	    &tp*.t_info.i_proc*.p_parTypes[0]
	fi;
    scan();			/* skip the opening parenthesis */
    pushDescriptor();
    lastFormal := TYUNKNOWN;
    lastActual := TYUNKNOWN;
    parCnt := 0;		/* no parameters yet */
    while isExpression() do
	pAssignment();
	thisActual := d0*.v_type;
	if p ~= nil and pCount ~= 0 then
	    thisFormal := p*;
	else
	    thisFormal := TYUNKNOWN;
	fi;
	size := getSize(thisFormal);
	if isAvailable() or thisActual = TYFLOAT then
	    putInReg();
	elif d0*.v_kind = VCC or
	    TrueChain ~= BRANCH_NULL or FalseChain ~= BRANCH_NULL or
	    d0*.v_kind = VNUMBER and ((size = S_LONG or size = S_LADDR) and
	    d0*.v_value.v_long < 128 and d0*.v_value.v_long >= -128 or
	    d0*.v_value.v_long = 0)
	then
	    if thisFormal = TYUNKNOWN then
		putInReg();
	    else
		fixSizeReg(thisFormal);
	    fi;
	fi;
	if thisFormal ~= TYUNKNOWN then
	    if thisFormal ~= thisActual then
		if d0*.v_kind = VNUMBER then
		    d0*.v_type := thisFormal;
		elif isSimple(thisActual) then
		    fixSizeReg(thisFormal);
		fi;
	    fi;
	fi;
	/* have to do this, since we don't want saved registers in the middle
	   of the parameters! */
	fixTo(regStackPos);
	if p = nil then
	    putInReg();
	    if thisActual ~= TYFLOAT then
		if isAddress(d0*.v_type) then
		    freeAReg();
		else
		    freeDReg();
		fi;
	    fi;
	else
	    if pCount = 0 then
		errorBack(72);
	    else
		dimCount := 4;
		if isSimple(thisFormal) then
		    if size = S_LONG or size = S_LADDR then
			opTail(OPT_LOAD, OP_MOVEL, M_DEC, RSP, false, false);
		    else
			dimCount := 2;
			opTail(OPT_LOAD,
			    if size = S_BYTE then OP_MOVEB else OP_MOVEW fi,
			    M_DEC, RSP, false, false
			);
		    fi;
		elif thisActual = TYFLOAT then
		    if d0*.v_kind ~= VREG then
			floatRef(OP_RESTM, 0, d0);
		    fi;
		    opSpecial(OP_SAVEM | M_DEC << 3 | RSP);
		    sourceWord(0xc000);
		    FloatBusy := false;
		elif isOp() then
		    putInReg();
		else
		    /* there was a reason why this couldn't be just an opTail
		       call using OPT_LOAD, but I forget what it was. It may
		       have had something to do with string constants */
		    putAddrInReg();
		    freeAReg();
		    opMove(OP_MOVEL,
			M_ADIR << 3 | d0*.v_value.v_reg,
			M_DEC << 3 | RSP
		    );
		fi;
		parCnt := parCnt + dimCount;
		tPtr1 := basePtr(thisFormal);
		if thisFormal = lastFormal then
		    /* the special dim parameters should only be done once
		       for each special array type, not once for each
		       special array parameter */
		    if thisActual ~= lastActual and thisActual ~= TYERROR then
			errorBack(73);
		    fi;
		elif tPtr1*.t_kind = TY_ARRAY then
		    ad := tPtr1*.t_info.i_array;
		    dimCount := ad*.ar_dimCount;
		    lastFormal := thisFormal;
		    lastActual := thisActual;
		    tPtr2 := basePtr(lastActual);
		    if tPtr2*.t_kind ~= TY_ARRAY or
			 pretend(tPtr2*.t_info.i_array*.ar_baseType, uint) ~=
			 pretend(ad*.ar_baseType, uint)
		    then
			if lastActual ~= TYERROR then
			    errorBack(74);
			fi;
			lastFormal := TYUNKNOWN;
		    else
			/* start of actual dims */
			dimPtr1 := &ad*.ar_dims[0];
			dimPtr2 := &tPtr2*.t_info.i_array*.ar_dims[0];
			kludged := false;
			while dimCount ~= 0 do
			    if dimPtr1*.ar_kind = AR_FLEX then
				/* pass dimension as extra parameter */
				if not kludged then
				    kludged := true;
				    opMove(OP_MOVEL, M_INC << 3 | RSP,
					    M_ADIR << 3 | 0);
				fi;
				getDim(dimPtr2, M_DEC, RSP);
				parCnt := parCnt + 4;
			    elif dimPtr2*.ar_kind = AR_FLEX or
				    dimPtr2*.ar_dim ~= dimPtr1*.ar_dim then
				errorBack(75);
			    fi;
			    dimPtr1 := dimPtr1 + sizeof(ARRAYDIM);
			    dimPtr2 := dimPtr2 + sizeof(ARRAYDIM);
			    dimCount := dimCount - 1;
			od;
			if kludged then
			    opMove(OP_MOVEL, M_ADIR << 3 | 0,
				    M_DEC << 3 | RSP);
			fi;
		    fi;
		else
		    d0*.v_type := thisActual;
		    assignCompat(thisFormal);
		fi;
	    fi;
	fi;
	if p ~= nil and pCount ~= 0 then
	    pCount := pCount - 1;
	    p := p + sizeof(TYPENUMBER);
	fi;
	pComma(')');
    od;
    if p ~= nil and pCount ~= 0 then
	errorThis(76);
    fi;
    popDescriptor();
    rightParen();
    callTail(parCnt);
    if pushedA1 then
	opMove(OP_MOVEL, M_INC << 3 | RSP, M_ADIR << 3 | 1);
    fi;
corp;
