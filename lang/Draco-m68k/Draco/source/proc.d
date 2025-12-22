#draco.g
#externs.g

/* main proc handling code - entry, exit, parameters, etc. */

[OPPARSIZE] *SYMBOL OpPars;
uint OpParCount;

/*
 * getExternRefs - called by system dependent code output to retrieve all
 *	of the references to extern symbols.
 */

proc getExternRefs()void:
    register *SYMBOL symPtr;
    register uint chain, temp;

    symPtr := &SymbolTable[0];
    while symPtr ~= &SymbolTable[SYSIZE] do
	/* loop - each symbol in table */
	if symPtr*.sy_kind & MMMMMM = MPROC or
	    symPtr*.sy_kind & MMMMMM = MEPROC or
	    symPtr*.sy_kind & MMMMMM = MEXTERN
	then
	    chain := symPtr*.sy_value.sy_uint;
	    if chain ~= REF_NULL then
		externRefName(symPtr*.sy_name);
		while chain ~= REF_NULL do
		    externRefUse(chain);
		    temp := chain;
		    chain := (&ProgramBuffWord[0] + chain)*;
		    (&ProgramBuffWord[0] + temp)* := 0;
		od;
		symPtr*.sy_value.sy_uint := REF_NULL;
	    fi;
	fi;
	symPtr := symPtr + sizeof(SYMBOL);  /* to next symbol */
    od;
corp;

/*
 * getFileVars - called by system dependent code to get the names and offsets
 *	of all file-level variables.
 */

proc getFileVars()void:
    register *SYMBOL symPtr;

    symPtr := &SymbolTable[0];
    while symPtr ~= &SymbolTable[SYSIZE] do
	if symPtr*.sy_kind & MMMMMM = MFVAR then
	    fileVarName(symPtr*.sy_name, symPtr*.sy_value.sy_ulong);
	fi;
	symPtr := symPtr + sizeof(SYMBOL);
    od;
corp;

/*
 * emitConstants - add the constants to the generated code/data.
 */

proc emitConstants()void:
    register *byte bPtr, bVal;
    register *CTENT cn;
    register uint chain, temp;

    bPtr := ByteNext;	/* end of previous constant in byte buffer */
    cn := ConstNext;
    while cn ~= &ConstTable[0] do	/* loop through ConstTable */
	cn := cn - sizeof(CTENT);
	if cn*.ct_use ~= REF_NULL then
	    /* this constant was used */
	    if InitData then
		chain := cn*.ct_use;
		while chain ~= REF_NULL do
		    temp := chain;
		    chain := (&ProgramBuffWord[0] + chain)*;
		    relocp(&ProgramBuff[0] + temp, ProgramNext);
		od;
	    else
		fixRefChainImmediate(cn*.ct_use);
	    fi;
	    cn*.ct_use := REF_NULL;	/* for next proc if global */
	    bVal := cn*.ct_value;
	    /* copy the body of the constant to end of the proc's code */
	    while bVal ~= bPtr do	/* go up to start of next constant */
		genByte(bVal*);
		bVal := bVal + 1;
	    od;
	    /* align to word boundary */
	    if (ProgramNext - &ProgramBuff[0]) & 1 ~= 0 then
		genByte(0);
	    fi;
	fi;
	bPtr := cn*.ct_value;
    od;
    ConstNext := cn;
corp;

/*
 * procTail - tail of proc processing, add constants to code buffer,
 *	      generate all relocation information, and generate refs to
 *	      external procedures.
 */

proc procTail()void:
    register uint i;
    uint saveMask, restoreMask, which, count;

    saveMask := 0x0;
    restoreMask := 0x0;
    count := 0;
    /* ARLIMIT + 1 since we don't save A1 here - we save it on each call.
       This is necessary since the AmigaDOS and ROM Kernel routines consider
       A1 to be a scratch register and do not save it. We could save it in
       the interface stubs, but this method is likely to be more efficient
       since most programs will not use A1 at all during normal code. */
    for i from ARLIMIT + 1 upto GlobARTop do
	if ARegUse[i] ~= 0 or i > ARTop then
	    count := count + 1;
	    which := i + 8;
	    saveMask := saveMask | (1 << (7 - i));
	    restoreMask := restoreMask | (1 << (i + 8));
	fi;
    od;
    for i from DRLIMIT upto GlobDRTop do
	if DRegUse[i] ~= 0 or i > DRTop then
	    count := count + 1;
	    which := i;
	    saveMask := saveMask | (1 << (15 - i));
	    restoreMask := restoreMask | (1 << i);
	fi;
    od;
    if saveMask = 0 then
	/* no registers need to be saved or restored - zonk the save and
	   don't generate a restore */
	moveCodeBack(8, 4);
    elif count = 1 then
	/* only one register to be saved/restored - use a MOVE.L instead of
	   the MOVEM.L */
	moveCodeBack(6, 2);
	if which >= 8 then
	    /* it was an A reg */
	    ProgramBuffWord[2] := OP_MOVEL | RSP << 9 | M_DEC << 6 |
		M_ADIR << 3 | (which - 8);
	    opMove(OP_MOVEL, M_INC << 3 | RSP, M_ADIR << 3 | (which - 8));
	else
	    /* it was a D reg */
	    ProgramBuffWord[2] := OP_MOVEL | RSP << 9 | M_DEC << 6 |
		M_DDIR << 3 | which;
	    opMove(OP_MOVEL, M_INC << 3 | RSP, M_DDIR << 3 | which);
	fi;
    else
	ProgramBuffWord[3] := saveMask;
	opSpecial(OP_RESTM | M_INC << 3 | RSP);
	sourceWord(restoreMask);
    fi;
    /* if we have either locals or pars, we have to have frame pointer */
    if DeclOffset + 8 ~= 0 then
	opSpecial(OP_UNLK | RFP);
    else
	moveCodeBack(4, 4);
    fi;
    if ParSize = 0L0 then
	opSpecial(OP_RTS);
    else
	/* temporarily save return address in A0: */
	opMove(OP_MOVEL, M_INC << 3 | RSP, M_ADIR << 3 | 0);
	/* pop parameters: */
	addrCon(true, RSP, ParSize);
	/* return to caller: */
	opEA(OP_JMP, M_INDIR << 3 | 0);
    fi;
    peepFlush();
    /* add to the code all the constants USED in this proc */
    emitConstants();
    if Token ~= TCORP then
	errorThis(46);
	while Token ~= TCORP do
	    scan();
	od;
    fi;
    ExtraAReg := false;
    scan();
corp;

/*
 * queueInit - initialize the various register queues. We need to do this at
 *	the very start, incase declarations are mucked up and start generating
 *	code, but we also need to do it again when we finally know how many
 *	registers have been reserved.
 */

proc queueInit()void:
    register uint i;

    DRegValidCount := 0;
    ARegValidCount := 0;
    for i from 0 upto 7 do
	ARegUse[i] := 0;
	DRegUse[i] := 0;
    od;
    /* next goes from head to tail; prev goes from tail to head */
    for i from DRLIMIT upto DRTop do
	DRegQueue[i].r_next := &DRegQueue[i - 1];
	DRegQueue[i].r_prev := &DRegQueue[i + 1];
	DRegQueue[i].r_reg := i;
	DRegQueue[i].r_desc.v_kind := VVOID;
    od;
    DRegQueue[DRLIMIT].r_next := nil;
    DRegQueue[DRTop].r_prev := nil;
    DRegFreeHead := &DRegQueue[DRTop];
    DRegFreeTail := &DRegQueue[DRLIMIT];
    DRegBusyHead := nil;
    DRegBusyTail := nil;
    for i from ARLIMIT upto ARTop do
	ARegQueue[i].r_next := &ARegQueue[i - 1];
	ARegQueue[i].r_prev := &ARegQueue[i + 1];
	ARegQueue[i].r_reg := i;
	ARegQueue[i].r_desc.v_kind := VVOID;
    od;
    ARegQueue[ARLIMIT].r_next := nil;
    ARegQueue[ARTop].r_prev := nil;
    ARegFreeHead := &ARegQueue[ARTop];
    ARegFreeTail := &ARegQueue[ARLIMIT];
    ARegBusyHead := nil;
    ARegBusyTail := nil;

    CCKind := VVOID;
    CCIsReg := false;
corp;

/*
 * codeInit - initialize for possible code generation on 'scan'
 */

proc codeInit()void:

    Ignore := false;
    FloatBusy := false;
    OptKludgeFlag2 := false;
    TrueChain := BRANCH_NULL;
    FalseChain := BRANCH_NULL;
    ReturnChain := BRANCH_NULL;
    NextRegStack := &RegStack[0];
    PeepNext := 0;
    PeepTotal := 0;
    OptCount := 0;
    RememberCount := 0;
    ShortenCount := 0;
    GlobalRelocNext := &GlobalRelocTable[0];
    FileRelocNext := &FileRelocTable[0];
    LocalRelocNext := &LocalRelocTable[0];
    ProgramRelocNext := &ProgramRelocTable[0];
    CaseTableNext := &CaseTable[0];
    BranchTableNext := &BranchTable[0];
    queueInit();
corp;

/*
 * addOpPar - called from 'pProcHead' to tell us about op-type pars.
 */

proc addOpPar(*SYMBOL sy)void:

    if OpParCount = OPPARSIZE then
	errorThis(2);
    fi;
    OpPars[OpParCount] := sy;
    OpParCount := OpParCount + 1;
corp;

/*
 * pSetup - subsidiary part of 'pProc'.
 */

proc pSetup()void:
    register ulong align;
    register *SYMBOL sy;
    register uint i;
    register TYPENUMBER t;

    Ignore := false;
    if Token + '\e' = ':' then
	scan();
    else
	warning(48);
    fi;
    pDecls();
    /* add space needed for operator-type parameters */
    i := 0;
    while i ~= OpParCount do
	sy := OpPars[i];
	i := i + 1;
	t := sy*.sy_type;
	align := basePtr(t)*.t_align;
	DeclOffset := -((-DeclOffset + align - 1) / align * align);
	DeclOffset := DeclOffset - typeSize(t);
	sy*.sy_value.sy_ulong := DeclOffset;
    od;
    DeclOffset := -((-DeclOffset + ALIGN - 1) / ALIGN * ALIGN);
    /* if we have either locals or pars, we have to have frame pointer */
    if DeclOffset + 8 ~= 0 then
	if ParSize + DeclOffset + 8 < 0xffff8000 then
	    errorThis(172);
	fi;
	opSpecial(OP_LINK | RFP);
	sourceWord(DeclOffset + ParSize + 8);
    else
	/* occupy space to keep offsets constant for when getting register
	   parameters */
	opSpecial(OP_NOP);
	opSpecial(OP_NOP);
    fi;
    opSpecial(OP_SAVEM | M_DEC << 3 | RSP);
    sourceWord(0);
    peepFlush();
    queueInit();
corp;

/*
 * doReturnValue - handle a value being returned from a proc.
 *	Used at end of proc and for 'return' statement.
 */

proc doReturnValue()void:
    byte siz;

    if DescTable[0].v_type = TYVOID then
	if ResultType ~= TYERROR then
	    errorThis(51);	    /* but DIDN'T have one */
	fi;
    else
	assignCompat(ResultType);
	if DescTable[0].v_type = TYFLOAT then
	    putInReg();
	    if DescTable[0].v_kind ~= VREG then
		floatRef(OP_RESTM, 0, &DescTable[0]);
	    fi;
	elif isOp() then
	    putInReg();
	else
	    fixSizeReg(ResultType);
	    siz := getSize(ResultType);
	    if siz = S_LADDR then
		opMove(OP_MOVEL, M_ADIR << 3 | DescTable[0].v_value.v_reg,
		       M_DDIR << 3 | 0);
		freeAReg();
	    else
		opMove(
		    if siz = S_BYTE then
			OP_MOVEB
		    elif siz = S_WORD then
			OP_MOVEW
		    else
			OP_MOVEL
		    fi,
		    M_DDIR << 3 | DescTable[0].v_value.v_reg,
		    M_DDIR << 3 | 0
		);
		freeDReg();
	    fi;
	fi;
    fi;
corp;

/*
 * pProc - parse and generate code for procedure entry/exit
 */

proc pProc()void:
    *CTENT cNSave;
    register *SYMBOL procIdPtr;
    *SYMBOL tempId;
    *byte bNSave;
    *TYPENUMBER tLast;
    *byte nTISave;
    *byte afterParPos;
    TYPENUMBER typ, resultType, nTSave;

    codeInit();
    ARTop := GlobARTop;
    DRTop := GlobDRTop;
    scan();
    DeclLevel := B_LOCAL;
    procIdPtr := pId(ID_PROC);
    resultType := procIdPtr*.sy_type;
    procIdPtr*.sy_kind := B_FILE | MPROC;
    procIdPtr*.sy_type := TYVOID;	/* some initial type */
    procIdPtr*.sy_value.sy_uint := REF_NULL;  /* no refs yet */
    /* save symbol and constant positions for next proc. These saves are
       done here so this proc will stay in the symbol table */
    cNSave := ConstNext;
    bNSave := ByteNext;
    Ignore := true;	/* turn code generation off in case of bad decls */
    DeclOffset := 0L0;
    ActualProc := true;
    DeclLevel := B_LOCAL;
    /* get ready for the code to fetch register parameters */
    ProgramNext := &ProgramBuff[8];	/* magic value - see pSetup */
    OpParCount := 0;
    typ := pProcHead();
    peepFlush();
    afterParPos := ProgramNext;
    ProgramNext := &ProgramBuff[0];	/* reset so entry code works */
    ActualProc := false;
    ParSize := - DeclOffset;
    DeclOffset := DeclOffset - 8;
    if resultType ~= TYERROR and resultType ~= typ then
	tempId := CurrentId;
	CurrentId := procIdPtr;
	errorThis(15);
	CurrentId := tempId;
    fi;
    procIdPtr*.sy_type := typ;
    resultType := TypeTable[typ].t_info.i_proc*.p_resultType;
    ResultType := resultType;
/*	ALSO CHECK FOR NO PARAMETERS IF IS 'vector'
    if resultType ~= TYVOID and isVector then
	errorThis(47);
    fi;
*/
    nTISave := NextTypeInfo;
    nTSave := NextType;
    pSetup();
    /* run through the moves that were generated to move the register
       parameters to their registers and fix up the offsets */
    ProgramNext := &ProgramBuff[8];
    while ProgramNext ~= afterParPos do
	ProgramNext := ProgramNext + 2;
	ProgramNextWord* := ProgramNextWord* + ParSize + 8;
	ProgramNext := ProgramNext + 2;
    od;
    /* run through and get operator-type parameters */
    while OpParCount ~= 0 do
	OpParCount := OpParCount - 1;
	tempId := OpPars[OpParCount];
	opEA(OP_PEA, M_DISP << 3 | RFP);
	sourceWord(tempId*.sy_value.sy_ulong + ParSize + 8);
	genCall2(&basePtr1(tempId*.sy_type)*.t_info.i_op*.op_name[0], "pop");
    od;
    /* now parse and generate code for the body of the procedure: */
    statements();
    /* done, now check that the result, if any, is of the right type: */
    if resultType = TYVOID then 	/* shouldn't have a result value */
	if notStatement(DescTable[0].v_type) then
	    errorThis(50);			/* but DID have one */
	fi;
    else	/* should have a value */
	doReturnValue();
    fi;
    peepFlush();
    shortenBranches(&BranchTable[0]);	/* handle a conditional result */
    fixChainImmediate(ReturnChain);	/* make all the 'return's come here */
    ReturnChain := BRANCH_NULL; 	/* so procTail doesn't mess up */
    procTail();
    /* length is a multiple of 2 (code, constants - see procTail) */
    if (ProgramNext - &ProgramBuff[0]) & 2 ~= 0 then
	genWord(OP_NOP);
    fi;
    writeProgram(procIdPtr*.sy_name, &ProgramBuffWord[0],
		 ProgramNext - &ProgramBuff[0],
		 &GlobalRelocTable[0], GlobalRelocNext,
		 &FileRelocTable[0], FileRelocNext,
		 &ProgramRelocTable[0], ProgramRelocNext);
    if VerboseFlag then
	printRevString(procIdPtr*.sy_name);
	printString(": ");
	printInt(ProgramNext - &ProgramBuff[0]);
	printString(" bytes, ");
	printInt(OptCount);
	printString(" peepholes, ");
	printInt(RememberCount);
	printString(" loads omitted, ");
	printInt(ShortenCount);
	printString(" branches shortened.\n");
    fi;
    ByteNext := bNSave;
    ConstNext := cNSave;		/* restore constant table pointer */
    purgeSymbol(B_LOCAL);   /* purge all local symbols from symbol table */
    NextTypeInfo := nTISave;
    NextType := nTSave;
    DeclLevel := B_FILE;
corp;
