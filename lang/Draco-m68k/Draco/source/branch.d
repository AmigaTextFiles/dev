#draco.g
#externs.g

/* code generation stuff for dealing with branches */

/*
 * opBranch - generate a branch instruction.
 */

proc opBranch(byte cond, displacement)void:

    if not Ignore then
	peepFlush();
	genWord(OP_Bcc | make(cond, uint) << 8 | displacement);
    fi;
corp;

/*
 * branchTo - branch to a given location.
 */

proc branchTo(byte cond; *byte where)void:
    register int offset;

    if not Ignore then
	peepFlush();
	offset := where - ProgramNext - 2;
	if offset < -128 or offset > 127 or offset = 0 then
	    opBranch(cond, 0);
	    genWord(offset);
	else
	    opBranch(cond, offset);
	fi;
    fi;
corp;

/*
 * fixChainTo - change all values on the given useage chain to point to
 *		the location indicated.
 */

proc fixChainTo(register uint head; *byte where)void:
    register *uint ptr;
    register uint p;

    if not Ignore then
	while head ~= BRANCH_NULL do
	    ptr := &ProgramBuffWord[0] + head;
	    p := ptr*;
	    ptr* := where - &ProgramBuff[head];
	    head := p;
	od;
    fi;
corp;

/*
 * fixChain - change all values on the given useage chain to point to the
 *	      current code position
 */

proc fixChain(uint head)void:

    if head ~= BRANCH_NULL then
	peepFlush();
	if not Ignore then
	    if BranchTableNext = &BranchTable[BRANCHSIZE] then
		errorThis(14);
	    fi;
	    BranchTableNext*.br_destination := ProgramNext - &ProgramBuff[0];
	    BranchTableNext*.br_chain := head;
	    BranchTableNext := BranchTableNext + sizeof(BRENTRY);
	fi;
    fi;
corp;

/*
 * fixChainImmediate - same as above, except that we actually do it instead of
 *	saving it up for a later 'shortenBranches'.
 */

proc fixChainImmediate(register uint head)void:
    register *uint ptr;
    register uint p;

    if head ~= BRANCH_NULL and not Ignore then
	peepFlush();
	while head ~= BRANCH_NULL do
	    ptr := &ProgramBuffWord[0] + head;
	    p := ptr*;
	    ptr* := ProgramNext - &ProgramBuff[head];
	    head := p;
	od;
    fi;
corp;

/*
 * fixRefChainImmediate - as above but for a constant or extern ref chain.
 */

proc fixRefChainImmediate(register uint head)void:
    register *uint ptr;
    register uint p;

    if head ~= REF_NULL and not Ignore then
	peepFlush();
	while head ~= REF_NULL do
	    ptr := &ProgramBuffWord[0] + head;
	    p := ptr*;
	    ptr* := ProgramNext - &ProgramBuff[head];
	    head := p;
	od;
    fi;
corp;

/*
 * ifJump - generate the closing JMP for an if ... elif sequence, and fix up
 *	    the previous jump to jump to just after this one
 */

proc ifJump(uint doneChain, lastBranch, branchChain)uint:

    if Ignore then
	doneChain
    else
	/* add this jump to chain of jumps: */
	opBranch(CC_T, 0);
	genWord(doneChain);
	fixChain(lastBranch);
	/* this is where we reset register state for that optimization */
	fixChain(branchChain);
	forgetRegs();
	/* return either the old chain or the new chain */
	ProgramNext - &ProgramBuff[2]
    fi
corp;

/*
 * moveRelocs - move a set of relocation information - part of 'moveCodeBack'
 *	Note: this routine is called BEFORE the code is moved.
 */

proc moveRelocs(register *RELOC start, end;
		register uint firstPos, amount)void:
    register *uint p;
    register uint temp;

    while start ~= end do
	temp := start*.r_head;
	if temp ~= RELOC_NULL then
	    if temp >= firstPos then
		start*.r_head := temp - amount;
	    fi;
	    while
		p := &ProgramBuffWord[0] + temp;
		temp := p*;
		temp ~= RELOC_NULL
	    do
		if temp > firstPos then
		    p* := temp - amount;
		fi;
	    od;
	fi;
	start := start + sizeof(RELOC);
    od;
corp;

/*
 * moveCodeBack - move a chunk of code ending at the current position backwards
 *	by the given amount. This is normally to change a long forward branch
 *	into a short one, but there are other uses.
 */

proc moveCodeBack(register uint firstPos, amount)void:
    register *SYMBOL symPtr;
    register *CTENT ctPtr @ symPtr;
    register *RELOC r @ symPtr;
    register *uint p, q @ symPtr;
    register uint chain;

    peepFlush();

    /* the chains in all relocation entries must be moved back */

    moveRelocs(&GlobalRelocTable[0] , GlobalRelocNext , firstPos, amount);
    moveRelocs(&FileRelocTable[0]   , FileRelocNext   , firstPos, amount);
    moveRelocs(&LocalRelocTable[0]  , LocalRelocNext  , firstPos, amount);
    moveRelocs(&ProgramRelocTable[0], ProgramRelocNext, firstPos, amount);

    /* the DESTINATIONS of program relative branches (cases) move back */

    r := &ProgramRelocTable[0];
    while r ~= ProgramRelocNext do
	if r*.r_what >= firstPos then
	    r*.r_what := r*.r_what - amount;
	fi;
	r := r + sizeof(RELOC);
    od;

    /* the chain for 'return' must be moved back */

    p := &ReturnChain;
    while
	chain := p*;
	chain ~= BRANCH_NULL
    do
	if chain >= firstPos then
	    p* := chain - amount;
	fi;
	p := &ProgramBuffWord[0] + chain;
    od;

    /* the chains in external proc references must be moved back */

    symPtr := &SymbolTable[0];
    while symPtr ~= &SymbolTable[SYSIZE] do
	if symPtr*.sy_kind & MMMMMM = MPROC or
	    symPtr*.sy_kind & MMMMMM = MEPROC or
	    symPtr*.sy_kind & MMMMMM = MEXTERN
	then
	    chain := symPtr*.sy_value.sy_uint;
	    if chain ~= REF_NULL then
		if chain >= firstPos then
		    symPtr*.sy_value.sy_uint := chain - amount;
		fi;
		while
		    p := &ProgramBuffWord[0] + chain;
		    chain := p*;
		    chain ~= REF_NULL
		do
		    if chain >= firstPos then
			p* := chain - amount;
		    fi;
		od;
	    fi;
	fi;
	symPtr := symPtr + sizeof(SYMBOL);
    od;

    /* the chains in constant references must be moved back */

    ctPtr := &ConstTable[0];
    while ctPtr ~= ConstNext do
	chain := ctPtr*.ct_use;
	if chain ~= REF_NULL then
	    if chain >= firstPos then
		ctPtr*.ct_use := chain - amount;
	    fi;
	    while
		p := &ProgramBuffWord[0] + chain;
		chain := p*;
		chain ~= REF_NULL
	    do
		if chain >= firstPos then
		    p* := chain - amount;
		fi;
	    od;
	fi;
	ctPtr := ctPtr + sizeof(CTENT);
    od;

    /* now we actually move the code */

    if ProgramNext ~= &ProgramBuff[firstPos] then
	p := pretend(&ProgramBuff[firstPos - amount], *uint);
	q := pretend(&ProgramBuff[firstPos], *uint);
	for chain from (ProgramNext-&ProgramBuff[firstPos])/2 - 1 downto 0 do
	    p* := q*;
	    p := p + sizeof(uint);
	    q := q + sizeof(uint);
	od;
    fi;

    ProgramNext := ProgramNext - amount;
corp;

/*
 * shortenBranches - a closed section of code (if, while, case, for) has been
 *	finished. Shorten all branches within it. We are passed a pointer to
 *	the first BRENTRY that relates to the unit.
 */

proc shortenBranches(register *BRENTRY brStart)void:
    register *BRENTRY br, gr;
    register uint chain, greatest, offset;
    bool foundOne;

    flushHereChain();
    while
	foundOne := false;
	/* first, find the latest branch still remaining */
	greatest := 0;
	br := BranchTableNext;
	while br ~= brStart do
	    br := br - sizeof(BRENTRY);
	    chain := br*.br_chain;
	    while chain ~= BRANCH_NULL do
		if chain > greatest then
		    foundOne := true;
		    greatest := chain;
		    gr := br;
		fi;
		chain := (&ProgramBuffWord[0] + chain)*;
	    od;
	od;
	foundOne
    do
	/* it will be the first in a chain */
	gr*.br_chain := (&ProgramBuffWord[0] + greatest)*;
	offset := gr*.br_destination - greatest - 2;
	if offset < 128 and offset ~= 0 then
	    ShortenCount := ShortenCount + 1;
	    /* go patch all the others up */
	    br := BranchTableNext;
	    while br ~= brStart do
		br := br - sizeof(BRENTRY);
		if br*.br_destination > greatest then
		    /* the branches in this chain would be crossing the one
		       we will shorten - move their destination back */
		    br*.br_destination := br*.br_destination - 2;
		fi;
	    od;
	    ProgramBuff[greatest - 1] := offset;
	    moveCodeBack(greatest + 2, 2);
	else
	    (&ProgramBuffWord[0] + greatest)* := offset + 2;
	fi;
    od;
    BranchTableNext := brStart;
corp;

/*
 * flushHereChain - flush the chain of pending branches to the next
 *	instruction to come here.
 */

proc flushHereChain()void:
    uint chain;

    /* watch out for recursion inside fixChainImmediate:peepFlush! */
    chain := HereChain;
    HereChain := BRANCH_NULL;
    fixChainImmediate(chain);
corp;
