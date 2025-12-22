#draco.g
#externs.g

/* utility routines for code generation */

bool DUMPCODE = false;			/* set to enable dump of code */

/*
 * hasIndex - return true if the indicated descriptor requires an index
 *	register to access.
 */

proc hasIndex(*DESCRIPTOR d)bool:
    register VALUEKIND kind;

    kind := d*.v_kind;
    (kind = VINDIR or kind = VCONST or kind = VDVAR or kind = VGVAR or
	kind = VFVAR or kind = VLVAR or kind = VAVAR or kind = VEXTERN or
	kind = VPAR) and
	    d*.v_index ~= NOINDEX
corp;

/*
 * isPower2 - check to see if a value is a power of 2.
 */

proc isPower2(ulong val; *ushort pPower)bool:
    register ulong power;
    register ushort pow;

    pow := 0;
    power := 0L1;
    while val ~= power and pow ~= 32 do
	pow := pow + 1;
	power := power << 1;
    od;
    if pow = 32 then
	false
    else
	pPower* := pow;
	true
    fi
corp;

/*
 * genByte - add the given byte to the program buffer
 */

proc genByte(byte b)void:
    [4] char buff;

    if DUMPCODE then
	buff[0] :=
	    if b > 0x9f then
		(b >> 4) + ('A' - 10)
	    else
		(b >> 4) + '0'
	    fi;
	buff[1] :=
	    if b & 0x0f > 0x09 then
		(b & 0x0f) + ('A' - 10)
	    else
		(b & 0x0f) + '0'
	    fi;
	buff[2] := ' ';
	buff[3] := '\e';
	printString(&buff[0]);
	if (ProgramNext - &ProgramBuff[0]) % 32 = 0 then
	    printString("\n");
	fi;
    fi;
    ProgramNext* := b;
    ProgramNext := ProgramNext + 1;
    if pretend(ProgramNext, *char) >= SymNext then
	errorThis(5);
    fi;
corp;

/*
 * genWord - add the given word to the program buffer
 */

proc genWord(uint w)void:

    genByte(w >> 8);
    genByte(w);
corp;

/*
 * genWordZero - add a 16 bit 0 to the program buffer
 */

proc genWordZero()void:

    genWord(0);
corp;

/*
 * genLong - add a 32 bit value to the program buffer
 */

proc genLong(ulong l)void:

    genWord(l >> 16);
    genWord(l);
corp;

/*
 * reloc - produce a relocation table entry in table 'base', whose next free
 *	   slot is pointed to by 'current', whose top is pointed to by
 *	   'top', for the relocatable value 'what' used at location 'where'
 */

proc reloc(*byte where; register ulong what;
	   register *RELOC base, current, top)*RELOC:

    /* look for an entry already referencing the given value */
    while base < current and base*.r_what ~= what do
	base := base + sizeof(RELOC);
	if base >= top then	    /* ran out of slots! */
	    errorThis(10);
	fi;
    od;
    if base < current then	    /* found entry using this value */
	/* put new reference on front */
	pretend(where, *uint)* := base*.r_head;
    else	    /* must make a new entry */
	current := current + sizeof(RELOC);
	base*.r_what := what;
	pretend(where, *uint)* := RELOC_NULL;
    fi;
    base*.r_head := where - &ProgramBuff[0];	    /* put new in entry */
    current
corp;

/*
 * relocg - generate relocation table entry for a global variable reference
 */

proc relocg(*byte where; ulong what)void:

    GlobalRelocNext := reloc(where, what, &GlobalRelocTable[0],
	GlobalRelocNext, &GlobalRelocTable[GRTSIZE]);
corp;

/*
 * relocf - generate relocation table entry for a file static reference
 */

proc relocf(*byte where; ulong what)void:

    FileRelocNext := reloc(where, what, &FileRelocTable[0],
	FileRelocNext, &FileRelocTable[FRTSIZE]);
corp;

/*
 * relocl - generate relocation table entry for a local static reference
 */

proc relocl(*byte where; ulong what)void:

    LocalRelocNext := reloc(where, what, &LocalRelocTable[0],
	LocalRelocNext, &LocalRelocTable[LRTSIZE]);
corp;

/*
 * relocp - generate relocation table entry for a program label reference
 */

proc relocp(*byte where; *byte what)void:

    ProgramRelocNext := reloc(where, what - &ProgramBuff[0],
	&ProgramRelocTable[0], ProgramRelocNext,
	&ProgramRelocTable[PRTSIZE]);
corp;

/*
 * pushBusyAReg - push a register onto the front of the busy A reg queue.
 */

proc pushBusyAReg(register *REGQUEUE r)void:

    r*.r_next := ARegBusyHead;
    r*.r_prev := nil;
    if r*.r_next ~= nil then
	r*.r_next*.r_prev := r;
    else
	ARegBusyTail := r;
    fi;
    ARegBusyHead := r;
corp;

/*
 * pushBusyDReg - push a register onto the front of the busy D reg queue.
 */

proc pushBusyDReg(register *REGQUEUE r)void:

    r*.r_next := DRegBusyHead;
    r*.r_prev := nil;
    if r*.r_next ~= nil then
	r*.r_next*.r_prev := r;
    else
	DRegBusyTail := r;
    fi;
    DRegBusyHead := r;
corp;

/*
 * popBusyAReg - pop the head of the A reg busy queue.
 */

proc popBusyAReg()*REGQUEUE:
    register *REGQUEUE r;

    r := ARegBusyHead;
    if r = nil then
	conCheck(1);
    fi;
    ARegBusyHead := r*.r_next;
    if r*.r_next ~= nil then
	r*.r_next*.r_prev := nil;
    else
	ARegBusyTail := nil;
    fi;
    r
corp;

/*
 * popBusyDReg - pop the head of the D reg busy queue.
 */

proc popBusyDReg()*REGQUEUE:
    register *REGQUEUE r;

    r := DRegBusyHead;
    if r = nil then
	conCheck(2);
    fi;
    DRegBusyHead := r*.r_next;
    if r*.r_next ~= nil then
	r*.r_next*.r_prev := nil;
    else
	DRegBusyTail := nil;
    fi;
    r
corp;

/*
 * pushFreeAReg - push a register onto the front of the free A reg queue.
 */

proc pushFreeAReg(register *REGQUEUE r)void:

    r*.r_next := ARegFreeHead;
    r*.r_prev := nil;
    if r*.r_next ~= nil then
	r*.r_next*.r_prev := r;
    else
	ARegFreeTail := r;
    fi;
    ARegFreeHead := r;
corp;

/*
 * pushFreeDReg - push a register onto the front of the free D reg queue.
 */

proc pushFreeDReg(register *REGQUEUE r)void:

    r*.r_next := DRegFreeHead;
    r*.r_prev := nil;
    if r*.r_next ~= nil then
	r*.r_next*.r_prev := r;
    else
	DRegFreeTail := r;
    fi;
    DRegFreeHead := r;
corp;

/*
 * unlinkFreeAReg - remove a register from the free A reg queue.
 */

proc unlinkFreeAReg(register *REGQUEUE r)void:

    if r*.r_next ~= nil then
	r*.r_next*.r_prev := r*.r_prev;
    else
	ARegFreeTail := r*.r_prev;
    fi;
    if r*.r_prev ~= nil then
	r*.r_prev*.r_next := r*.r_next;
    else
	ARegFreeHead := r*.r_next;
    fi;
corp;

/*
 * unlinkFreeDReg - remove a register from the free D reg queue.
 */

proc unlinkFreeDReg(register *REGQUEUE r)void:

    if r*.r_next ~= nil then
	r*.r_next*.r_prev := r*.r_prev;
    else
	DRegFreeTail := r*.r_prev;
    fi;
    if r*.r_prev ~= nil then
	r*.r_prev*.r_next := r*.r_next;
    else
	DRegFreeHead := r*.r_next;
    fi;
corp;

/*
 * getAReg - allocate an address register.
 */

proc getAReg()byte:
    register *REGQUEUE r;
    register ushort reg;
    bool foundOne;

    r := ARegFreeHead;
    if r ~= nil then
	/* heuristic - use the largest numbered reg on the free queue which
	   doesn't have a known value. This should reduce the number of regs
	   that are used in a given function */
	foundOne := false;
	reg := 0;
	while r ~= nil do
	    if r*.r_desc.v_kind = VVOID then
		foundOne := true;
		if r*.r_reg > reg then
		    reg := r*.r_reg;
		fi;
	    fi;
	    r := r*.r_next;
	od;
	if foundOne then
	    r := &ARegQueue[reg];
	else
	    r := ARegFreeHead;
	    reg := r*.r_reg;
	fi;
	/* remove it from the free queue */
	unlinkFreeAReg(r);
	/* we have one more valid register now */
	ARegValidCount := ARegValidCount + 1;
    else
	/* no free A regs - stack one and reuse it */
	r := ARegBusyTail;
	reg := r*.r_reg;
	opMove(OP_MOVEL, M_ADIR << 3 | reg, M_DEC << 3 | RSP);
	NextRegStack* := r*.r_reg + 8;
	NextRegStack := NextRegStack + sizeof(ushort);
	ARegBusyTail := r*.r_prev;
	r*.r_prev*.r_next := nil;	/* there will always be another */
    fi;
    /* put it onto the head of the busy queue */
    pushBusyAReg(r);
    ARegQueue[reg].r_desc.v_kind := VVOID;
    reg
corp;

/*
 * getDReg - allocate a data register.
 */

proc getDReg()byte:
    register *REGQUEUE r;
    register ushort reg;
    bool foundOne;

    r := DRegFreeHead;
    if r ~= nil then
	/* heuristic - use the largest numbered reg on the free queue which
	   doesn't have a known value. This should reduce the number of regs
	   that are used in a given function */
	foundOne := false;
	reg := 0;
	while r ~= nil do
	    if r*.r_desc.v_kind = VVOID then
		foundOne := true;
		if r*.r_reg > reg then
		    reg := r*.r_reg;
		fi;
	    fi;
	    r := r*.r_next;
	od;
	if foundOne then
	    r := &DRegQueue[reg];
	else
	    r := DRegFreeHead;
	    reg := r*.r_reg;
	fi;
	/* remove it from the free queue */
	unlinkFreeDReg(r);
	/* we have one more valid register now */
	DRegValidCount := DRegValidCount + 1;
    else
	/* no free D regs - stack one and reuse it */
	r := DRegBusyTail;
	reg := r*.r_reg;
	opMove(OP_MOVEL, M_DDIR << 3 | reg, M_DEC << 3 | RSP);
	NextRegStack* := r*.r_reg;
	NextRegStack := NextRegStack + sizeof(ushort);
	DRegBusyTail := r*.r_prev;
	r*.r_prev*.r_next := nil;	/* there will always be another */
    fi;
    /* put it onto the head of the busy queue */
    pushBusyDReg(r);
    DRegQueue[reg].r_desc.v_kind := VVOID;
    reg
corp;

/*
 * freeAReg - free an address register.
 */

proc freeAReg()void:
    register *REGQUEUE r;

    if ARegValidCount = 0 then
	conCheck(3);
    fi;
    ARegValidCount := ARegValidCount - 1;
    /* take it from the head of the busy queue and move it to the free queue.
       We try to optimize: if it has a useful value in it, we put it on the
       tail of the free queue, else we put it on the head */
    r := popBusyAReg();
    if r*.r_desc.v_kind = VVOID then
	/* no useful value */
	pushFreeAReg(r);
    else
	/* try to not reuse the reg, in case the value is needed later */
	r*.r_next := nil;
	r*.r_prev := ARegFreeTail;
	if r*.r_prev ~= nil then
	    r*.r_prev*.r_next := r;
	else
	    ARegFreeHead := r;
	fi;
	ARegFreeTail := r;
    fi;
corp;

/*
 * freeDReg - free an address register.
 */

proc freeDReg()void:
    register *REGQUEUE r;

    if DRegValidCount = 0 then
	conCheck(4);
    fi;
    DRegValidCount := DRegValidCount - 1;
    /* take it from the head of the busy queue and move it to the free queue.
       We try to optimize: if it has a useful value in it, we put it on the
       tail of the free queue, else we put it on the head */
    r := popBusyDReg();
    if r*.r_desc.v_kind = VVOID then
	/* no useful value */
	pushFreeDReg(r);
    else
	/* try to not reuse the reg, in case the value is needed later */
	r*.r_next := nil;
	r*.r_prev := DRegFreeTail;
	if r*.r_prev ~= nil then
	    r*.r_prev*.r_next := r;
	else
	    DRegFreeHead := r;
	fi;
	DRegFreeTail := r;
    fi;
corp;

/*
 * popReg - pop a register from the stack.
 */

proc popReg()void:
    register ushort reg;
    register uint conCheckCounter;
    register *REGQUEUE r;

    /* the register will be in the free queue at this point */
    NextRegStack := NextRegStack - sizeof(ushort);
    reg := NextRegStack*;
    if reg >= 8 then
	/* popping an A reg */
	reg := reg - 8;
	r := ARegBusyHead;
	conCheckCounter := 0;
	while r ~= nil and r*.r_reg ~= reg do
	    r := r*.r_next;
	    conCheckCounter := conCheckCounter + 1;
	    if conCheckCounter = 8 then
		conCheck(10);
	    fi;
	od;
	if r = nil then
	    /* this DOES happen and seems to be as needed */
	    r := &ARegQueue[reg];
	    unlinkFreeAReg(r);
	    /* put it onto the tail of the busy queue */
	    r*.r_next := nil;
	    r*.r_prev := ARegBusyTail;
	    if r*.r_prev ~= nil then
		r*.r_prev*.r_next := r;
	    else
		ARegBusyHead := r;
	    fi;
	    ARegBusyTail := r;
	fi;
	ARegValidCount := ARegValidCount + 1;
	opMove(OP_MOVEL, M_INC << 3 | RSP, M_ADIR << 3 | reg);
    else
	/* popping a D reg */
	r := DRegBusyHead;
	conCheckCounter := 0;
	while r ~= nil and r*.r_reg ~= reg do
	    r := r*.r_next;
	    conCheckCounter := conCheckCounter + 1;
	    if conCheckCounter = 8 then
		conCheck(11);
	    fi;
	od;
	if r = nil then
	    /* this DOES happen and seems to be as needed */
	    r := &DRegQueue[reg];
	    unlinkFreeDReg(r);
	    /* put it onto the tail of the busy queue */
	    r*.r_next := nil;
	    r*.r_prev := DRegBusyTail;
	    if r*.r_prev ~= nil then
		r*.r_prev*.r_next := r;
	    else
		DRegBusyHead := r;
	    fi;
	    DRegBusyTail := r;
	fi;
	DRegValidCount := DRegValidCount + 1;
	opMove(OP_MOVEL, M_INC << 3 | RSP, M_DDIR << 3 | reg);
    fi;
corp;

/*
 * needRegs - the specified counts of top-of-stack registers are needed for
 *	      the next instruction - ensure they are in registers.
 */

proc needRegs(ushort aRCount, dRCount)void:

    if not Ignore then
	if aRCount = 2 and ExtraAReg then
	    conCheck(13);
	fi;
	while ARegValidCount < aRCount or DRegValidCount < dRCount do
	    if NextRegStack <= &RegStack[0] then
		conCheck(5);
	    fi;
	    popReg();
	od;
    fi;
corp;

/*
 * aActive - return true if the passed
 *	address register is one that needs to be dragged into a real one.
 */

proc aActive(ushort reg)bool:

    reg >= ARLIMIT and reg <= ARTop
corp;

/*
 * fixTo - make the current stack state (which saved values are still in
 *	   their registers and which have been stacked) the same as the
 *	   passed state. This is done at the end of each branch in an 'if'
 *	   or 'case' construct to make the state the same as at the beginning
 *	   of the branch, so all states end up the same. To make sure that
 *	   there is a register available for any result of such a construct,
 *	   they must allocate and free a single register of each type before
 *	   going into the alternatives.
 */

proc fixTo(*ushort stackPos)void:

    if stackPos > NextRegStack then
	conCheck(9);
    fi;
    while NextRegStack ~= stackPos do
	popReg();
    od;
corp;

/*
 * switchReg - a conditional or case expression has a subsequent branch leave
 *	the value in a register different than the first branch. We must move
 *	the value, and fix up the register queues.
 */

proc switchReg(ushort reg; TYPENUMBER typ)void:
    register *REGQUEUE r;
    byte siz;
    ushort oldReg;

    oldReg := DescTable[0].v_value.v_reg;
    siz := getSize(typ);
    if siz = S_LADDR then
	opMove(OP_MOVEL, M_ADIR << 3 | oldReg, M_ADIR << 3 | reg);
	r := popBusyAReg();
	pushFreeAReg(r);
	r := &ARegQueue[reg];
	unlinkFreeAReg(r);
	pushBusyAReg(r);
    else
	opMove(
	    if siz = S_LONG then
		OP_MOVEL
	    elif siz = S_WORD then
		OP_MOVEW
	    else
		OP_MOVEB
	    fi,
	    M_DDIR << 3 | oldReg, M_DDIR << 3 | reg);
	r := popBusyDReg();
	pushFreeDReg(r);
	r := &DRegQueue[reg];
	unlinkFreeDReg(r);
	pushBusyDReg(r);
    fi;
    DescTable[0].v_value.v_reg := reg;
corp;

/*
 * save - save the current code generation state in the passed structure.
 */

proc save(register *STATE s)void:

    s*.s_peepTotal := PeepTotal;
    s*.s_nextRegStack := NextRegStack;
    s*.s_ARegUse := ARegUse;
    s*.s_DRegUse := DRegUse;
    s*.s_ARegValidCount := ARegValidCount;
    s*.s_DRegValidCount := DRegValidCount;
    s*.s_ARegQueue := ARegQueue;
    s*.s_DRegQueue := DRegQueue;
    s*.s_ARegFreeHead := ARegFreeHead;
    s*.s_ARegFreeTail := ARegFreeTail;
    s*.s_DRegFreeHead := DRegFreeHead;
    s*.s_DRegFreeTail := DRegFreeTail;
    s*.s_ARegBusyHead := ARegBusyHead;
    s*.s_ARegBusyTail := ARegBusyTail;
    s*.s_DRegBusyHead := DRegBusyHead;
    s*.s_DRegBusyTail := DRegBusyTail;
corp;

/*
 * restore - restore the code generation state to the save situation.
 */

proc restore(register *STATE s; bool undoCode)void:

    if undoCode then
	unDoTo(s*.s_peepTotal);
    fi;
    NextRegStack := s*.s_nextRegStack;
    ARegUse := s*.s_ARegUse;
    DRegUse := s*.s_DRegUse;
    ARegValidCount := s*.s_ARegValidCount;
    DRegValidCount := s*.s_DRegValidCount;
    ARegQueue := s*.s_ARegQueue;
    DRegQueue := s*.s_DRegQueue;
    ARegFreeHead := s*.s_ARegFreeHead;
    ARegFreeTail := s*.s_ARegFreeTail;
    DRegFreeHead := s*.s_DRegFreeHead;
    DRegFreeTail := s*.s_DRegFreeTail;
    ARegBusyHead := s*.s_ARegBusyHead;
    ARegBusyTail := s*.s_ARegBusyTail;
    DRegBusyHead := s*.s_DRegBusyHead;
    DRegBusyTail := s*.s_DRegBusyTail;
corp;

/*
 * forgetRegs - forget the values in all registers.
 */

proc forgetRegs()void:
    register uint i;

    for i from 0 upto 7 do
	ARegQueue[i].r_desc.v_kind := VVOID;
	DRegQueue[i].r_desc.v_kind := VVOID;
    od;
corp;

/*
 * forgetFreeRegs - forget the values in all FREE registers.
 */

proc forgetFreeRegs()void:
    register *REGQUEUE r;

    r := ARegFreeHead;
    while r ~= nil do
	r*.r_desc.v_kind := VVOID;
	r := r*.r_next;
    od;
    r := DRegFreeHead;
    while r ~= nil do
	r*.r_desc.v_kind := VVOID;
	r := r*.r_next;
    od;
corp;

/*
 * isAvailable - return true if the TOS value is in an available register.
 */

proc isAvailable()bool:
    register *REGQUEUE r;
    register VALUEKIND kind;
    register ushort size;

    kind := DescTable[0].v_kind;
    size := getSize(DescTable[0].v_type);
    if kind = VNUMBER or kind = VRVAR or kind = VDVAR or
	kind = VFVAR or kind = VGVAR or kind = VAVAR
    then
	/* see if the value is already in a register */
	r :=
	    if size = S_SADDR or size = S_LADDR then
		ARegFreeHead
	    else
		DRegFreeHead
	    fi;
	while r ~= nil and
	    (r*.r_desc.v_kind ~= kind or
	     r*.r_desc.v_value.v_ulong ~= DescTable[0].v_value.v_ulong or
	     r*.r_desc.v_kind = VNUMBER and size > getSize(r*.r_desc.v_type))
	do
	    r := r*.r_next;
	od;
	r ~= nil
    else
	false
    fi
corp;

/*
 * A1Busy - return 'true' if A1 is currently holding a value which we need.
 */

proc A1Busy()bool:
    register *REGQUEUE r;

    r := ARegBusyHead;
    while r ~= nil and r*.r_reg ~= 1 do
	r := r*.r_next;
    od;
    r ~= nil
corp;

/*
 * D23Busy - return 'true' if D2 or D3 is currently holding a value we need.
 */

proc D23Busy()bool:
    register *REGQUEUE r;

    r := DRegBusyHead;
    while r ~= nil and r*.r_reg ~= 2 and r*.r_reg ~= 3 do
	r := r*.r_next;
    od;
    r ~= nil
corp;

/*
 * sizeIt - common code to shrink/grow a value that's in a reg.
 */

proc sizeIt(ushort reg; TYPENUMBER typeNow, typeWant)TYPENUMBER:
    byte sizeNow, sizeWant;
    bool vSigned;

    sizeNow := getSize(typeNow);
    sizeWant := getSize(typeWant);
    vSigned := isSigned(typeNow);
    if sizeWant > sizeNow then
	if vSigned then
	    if sizeNow = S_BYTE then
		opSpecial(OP_EXT | 0b010 << 6 | reg);
		DRegUse[reg] := DRegUse[reg] + 1;
	    fi;
	    if sizeWant = S_LONG then
		opSpecial(OP_EXT | 0b011 << 6 | reg);
		DRegUse[reg] := DRegUse[reg] + 1;
	    fi;
	else
	    opSingle(OP_ANDI, sizeWant, M_DDIR << 3 | reg);
	    if sizeNow = S_BYTE then
		if sizeWant = S_WORD then
		    sourceWord(0x00ff);
		else
		    sourceLong(0Lx000000ff);
		fi;
	    else
		sourceLong(0Lx0000ffff);
	    fi;
	fi;
    fi;
    /* sometimes don't want this, but doesn't hurt */
    if vSigned = isSigned(typeWant) then
	typeWant
    else
	case sizeWant
	incase S_BYTE:
	    if vSigned then TYSHORT else TYUSHORT fi
	incase S_WORD:
	    if vSigned then TYINT else TYUINT fi
	incase S_LONG:
	    if vSigned then TYLONG else TYULONG fi
	esac
    fi
corp;

/*
 * floatRef - reference a float variable.
 */

proc floatRef(uint opCode, reg; register *DESCRIPTOR d)void:
    register VALUEKIND kind;

    /* this only works if d = &DescTable[0]. For the other cases, we have
       to have called 'putAddrInReg' first. These are currently in
       'floatBinary' in this file, and 'pAssignment' in 'parseBoolAssign.d'.
       Thus, we have to handle the callers of 'floatBinary' (their LHS's) */
    if hasIndex(d) then
	putAddrInReg();
	makeIndir();
    fi;
    kind := d*.v_kind;
    opSpecial(
	opCode |
	if kind = VINDIR then
	    if aActive(d*.v_value.v_indir.v_base) then
		needRegs(1, 0);
	    fi;
	    if d*.v_value.v_indir.v_offset = 0 then
		M_INDIR << 3 | d*.v_value.v_indir.v_base
	    else
		M_DISP << 3 | d*.v_value.v_indir.v_base
	    fi
	elif kind = VFLOAT then
	    M_SPECIAL << 3 | M_PCDISP
	elif kind = VDVAR then
	    M_DISP << 3 | RFP
	elif kind = VGVAR or kind = VFVAR or kind = VAVAR or
	    kind = VEXTERN
	then
	    M_SPECIAL << 3 | M_ABSLONG
	else
	    conCheck(8);
	    M_INDIR << 3 | 0
	fi);
    sourceWord(if reg = 0 then 0x0003 else 0x000c fi);
    if kind = VDVAR then
	destWord(d*.v_value.v_ulong + ParSize + 8);
    elif kind = VFLOAT or kind = VGVAR or kind = VFVAR or kind = VAVAR or
	kind = VEXTERN
    then
	opReloc(d, false);
    elif kind = VINDIR then
	if d*.v_value.v_indir.v_offset ~= 0 then
	    destWord(d*.v_value.v_indir.v_offset);
	fi;
	if aActive(d*.v_value.v_indir.v_base) then
	    freeAReg();
	fi;
    fi;
corp;

/*
 * fixSizeReg - stack a value, making sure it is of the right size.
 */

proc fixSizeReg(TYPENUMBER t)void:
    register *DESCRIPTOR d0;
    bool isAddr;

    d0 := &DescTable[0];
    isAddr := isAddress(t);
    if d0*.v_kind = VNUMBER and not isAddr then
	d0*.v_type := t;
    fi;
    putInReg();
    if d0*.v_type = TYFLOAT then
	if d0*.v_kind ~= VREG then
	    floatRef(OP_RESTM, 0, d0);
	    d0*.v_kind := VREG;
	    d0*.v_value.v_reg := 0;
	fi;
    else
	if isAddress(d0*.v_type) then
	    if not isAddr then
		freeAReg();
		d0*.v_value.v_reg := getDReg();
		d0*.v_type := TYUINT;
	    fi;
	elif isAddr then
	    freeDReg();
	    d0*.v_value.v_reg := getAReg();
	    d0*.v_type := TYCHARS;
	else
	    d0*.v_type := sizeIt(d0*.v_value.v_reg, d0*.v_type, t);
	fi;
    fi;
corp;

/*
 * ifPart - parse and generate code for the body of one if alternative,
 *	    also fix up the type of the whole if (mostly for if expressions)
 */

proc ifPart(TYPENUMBER oldType; bool noStack)TYPENUMBER:
    *ushort regStackPos;

    regStackPos := NextRegStack;
    statements();
    oldType := ifCompatible(oldType);
    if oldType ~= TYVOID and DescTable[0].v_type ~= TYVOID and
	(/*DescTable[0].v_kind ~= VNUMBER or */ not noStack)
    then
	/* if expressions leave result on the stack */
	fixSizeReg(oldType);
    fi;
    forgetRegs();
    fixTo(regStackPos);
    /* return the (possibly modified) type of the if expression */
    oldType
corp;

/*
 * condEnd - termination of 'if' or 'case' processing.
 */

proc condEnd(TYPENUMBER t)void:

    DescTable[0].v_kind :=
	if t = TYVOID then
	    VVOID
	else
	    if baseKind1(t) = TY_OP then
		VREG
	    else
		if t = TYFLOAT then
		    DescTable[0].v_value.v_reg := 0;
		    FloatBusy := true;
		    VREG
		elif isSimple(t) then
		    VREG
		else
		    makeIndir();
		    VINDIR
		fi
	    fi
	fi;
    DescTable[0].v_type := t;
corp;

/*
 * getDim - get an array dimension (FLEX or FIX) into the given destination.
 */

proc getDim(*ARRAYDIM ar; byte mode; ushort reg)void:
    register *DESCRIPTOR d0;

    pushDescriptor();
    d0 := &DescTable[0];
    d0*.v_type := TYULONG;
    d0*.v_index := NOINDEX;
    d0*.v_value.v_ulong := ar*.ar_dim;
    d0*.v_kind :=
	if ar*.ar_kind = AR_FLEX then
	    VDVAR
	else
	    VNUMBER
	fi;
    opTail(OPT_LOAD, OP_MOVEL, mode, reg, false, false);
    popDescriptor();
corp;

/*
 * makeIndir - make the TOS element into a pointer.
 */

proc makeIndir()void:
    register *DESCRIPTOR d0;

    d0 := &DescTable[0];
    d0*.v_kind := VINDIR;
    d0*.v_value.v_indir.v_base := d0*.v_value.v_reg;
    d0*.v_value.v_indir.v_offset := 0L0;
    d0*.v_index := NOINDEX;
corp;

/*
 * constFix - fix a structure/array constant.
 */

proc constFix()void:

    if DescTable[0].v_kind = VCONST then
	putAddrInReg();
	makeIndir();
    fi;
corp;

/*
 * forceData - make sure a value is in a data register.
 */

proc forceData()void:
    register *DESCRIPTOR d0;

    d0 := &DescTable[0];
    if d0*.v_kind = VERROR or isOp() then
	d0*.v_kind := VREG;
	d0*.v_value.v_reg := getDReg();
    elif isAddress(d0*.v_type) then
	/* this test is needed to handle the possible loop with
	   putInReg/condition */
	if d0*.v_kind ~= VREG then
	    putInReg();
	fi;
	freeAReg();
	d0*.v_value.v_reg := getDReg();
	d0*.v_type := TYERROR;
    fi;
corp;

/*
 * swap - swap the top two descriptors.
 */

proc swap()void:
    DESCRIPTOR temp;

    temp := DescTable[0];
    DescTable[0] := DescTable[1];
    DescTable[1] := temp;
corp;

/*
 * reverseOps - for commutative operators, if the left hand operand
 *		was a constant we want to flip the two around.
 */

proc reverseOps()bool:
    bool wasConstant;

    wasConstant := DescTable[0].v_kind = VNUMBER or
		   DescTable[0].v_kind = VFLOAT;
    if not wasConstant then
	putInReg();
	swap();
    fi;
    wasConstant
corp;

/*
 * shrCon - if the passed descriptor is a constant, shrink it down.
 */

proc shrCon(register *DESCRIPTOR d)void:
    register ulong uValue;
    register long sValue @ uValue;

    if d*.v_kind = VNUMBER then
	uValue := d*.v_value.v_ulong;
	d*.v_type :=
	    if isSigned(d*.v_type) then
		if sValue < 0L128 and sValue > -0L129 then
		    TYSHORT
		elif sValue < 0L32768 and sValue > -0L32769 then
		    TYINT
		else
		    TYLONG
		fi
	    else
		if uValue < 0L256 then
		    TYUSHORT
		elif uValue < 0L65536 then
		    TYUINT
		else
		    TYULONG
		fi
	    fi;
    fi;
corp;

/*
 * shrinkConsts - if both operands aren't constants, then shrink the size
 *		  indicated by the type of the constants down to the smallest
 *		  which can hold the contained value.
 */

proc shrinkConsts()void:

    if DescTable[0].v_kind ~= VNUMBER or DescTable[1].v_kind ~= VNUMBER then
	shrCon(&DescTable[0]);
	shrCon(&DescTable[1]);
    fi;
corp;

/*
 * mergeTypes - set the type of the left argument to the type which fits
 *		the size/signedness of the type of both arguments
 */

proc mergeTypes()void:
    byte lSize;
    register byte rSize;

    shrinkConsts();
    lSize := getSize(DescTable[1].v_type);
    rSize := getSize(DescTable[0].v_type);
    if lSize > rSize then
	rSize := lSize;
    fi;
    DescTable[1].v_type :=
	if isSigned(DescTable[1].v_type) or
		isSigned(DescTable[0].v_type) then
	    if rSize = S_BYTE then
		TYSHORT
	    elif rSize = S_WORD then
		TYINT
	    else
		TYLONG
	    fi
	else
	    if rSize = S_BYTE then
		TYUSHORT
	    elif rSize = S_WORD then
		TYUINT
	    else
		TYULONG
	    fi
	fi;
corp;

/*
 * modedBinary - generate an OPT_MODED binary instruction.
 *	Note that this only works for DATA values (not address values).
 */

proc modedBinary(uint opCode)void:
    register *DESCRIPTOR d0, d1;
    register byte lSize, rSize;
    ushort reg;

    d0 := &DescTable[0];
    d1 := d0 + sizeof(DESCRIPTOR);
    shrinkConsts();
    /* if the RHS is a variable which is currently in a register, then we
       want to use that copy. */
    if isAvailable() then
	putInReg();
    fi;
    lSize := getSize(d1*.v_type);
    rSize := getSize(d0*.v_type);
    if rSize < lSize and d0*.v_kind = VNUMBER then
	d0*.v_type := d1*.v_type;
	rSize := lSize;
    fi;
    if lSize > rSize then
	fixSizeReg(d1*.v_type);
	reg := d1*.v_value.v_reg;
    else
	needRegs(
	    if d0*.v_kind = VINDIR and
		aActive(d0*.v_value.v_indir.v_base) then 1 else 0 fi +
	    if lSize = S_LADDR then
		if d0*.v_kind = VREG then 1 else 0 fi +
		if d1*.v_kind = VREG then 1 else 0 fi
	    else
		0
	    fi,
	    if hasIndex(d0) and d0*.v_index & 0o7 <= DRTop
		then 1 else 0 fi +
	    if lSize ~= S_LADDR then
		if d0*.v_kind = VREG then 1 else 0 fi +
		if d1*.v_kind = VREG then 1 else 0 fi
	    else
		0
	    fi
	);
	if lSize ~= rSize and d1*.v_kind = VRVAR then
	    opMove(OP_MOVEL, M_DDIR << 3 | d1*.v_value.v_reg,
			     M_DDIR << 3 | 0);
	    reg := 0;
	else
	    reg := d1*.v_value.v_reg;
	fi;
	pretend(sizeIt(reg, d1*.v_type, d0*.v_type), void);
	lSize := rSize;
    fi;
    if d0*.v_kind = VNUMBER and d1*.v_kind = VREG and lSize = S_LONG and
	d0*.v_value.v_long >= -128 and d0*.v_value.v_long <= 127
    then
	opImm(0, d0*.v_value.v_ulong);
	opModed(opCode, d1*.v_value.v_reg, OM_REG | S_LONG,
		M_DDIR << 3 | 0);
    else
	opTail(OPT_MODED, opCode,
		if opCode = OP_EOR then lSize | OM_EA else lSize | OM_REG fi,
		reg,
		lSize = S_LADDR and d1*.v_kind = VREG,
		lSize ~= S_LADDR and d1*.v_kind = VREG);
    fi;
corp;

/*
 * addrCon - add/subtract a constant from an address register. This is
 *	also used for procedure entry/exit.
 */

proc addrCon(bool isPlus; ushort reg; register ulong len)void:

    if len = 0L0 then
	;
    elif len <= 0L8 then
	opQuick(if isPlus then OP_ADDQ else OP_SUBQ fi,
		make(len, ushort) & 7, S_LONG, M_ADIR << 3 | reg);
    elif len <= 0L32767 then
	opModed(if isPlus then OP_ADD else OP_SUB fi,
		reg, S_SADDR, M_SPECIAL << 3 | M_IMM);
	sourceWord(len);
    else
	opModed(if isPlus then OP_ADD else OP_SUB fi,
		reg, S_LADDR, M_SPECIAL << 3 | M_IMM);
	sourceLong(len);
    fi;
corp;

/*
 * shift - utility data register shift by constant routine.
 *	NOTE: it is assumed that the register is currently valid.
 */

proc shift(ushort reg; byte size; bool left, tSigned; ushort amount)void:

    if amount = 0 then
	;
    elif amount <= 8 then
	opSpecial(OP_SHIFT | make(amount & 0x7, uint) << 9 |
		if left then 0b1 else 0b0 fi << 8 |
		size << 6 | 0b0 << 5 |
		if tSigned then 0b00 else 0b01 fi << 3 |
		reg);
	DRegQueue[reg].r_desc.v_kind := VVOID;
	DRegUse[reg] := DRegUse[reg] + 1;
    else
	opImm(0, amount);
	opSpecial(OP_SHIFT | 0 << 9 |
		if left then 0b1 else 0b0 fi << 8 |
		size << 6 | 0b1 << 5 |
		if tSigned then 0b00 else 0b01 fi << 3 |
		reg);
	DRegQueue[reg].r_desc.v_kind := VVOID;
	DRegUse[reg] := DRegUse[reg] + 1;
    fi;
corp;

/*
 * multiplyBy - multiply the data value in the given reg by the given
 *	constant. Only works if values are unsigned.
 *	NOTE: the data register is assumed to be valid.
 */

proc multiplyBy(ushort reg; TYPENUMBER typ; register ulong val)void:
    ushort power;
    byte size;

    size := getSize(typ);
    if val = 0L1 then
	;
    elif isPower2(val, &power) then
	shift(reg, size, true, false, power);
    else
	if val <= 0L65535 and size ~= S_LONG then
	    opRegister(OP_MULU, reg, M_SPECIAL << 3 | M_IMM);
	    sourceWord(val);
	else
	    opMove(OP_MOVEL, M_DDIR << 3 | reg, M_DDIR << 3 | 0);
	    if val <= 0xff then
		opImm(1, val);
	    else
		opMove(OP_MOVEL, M_SPECIAL << 3 | M_IMM, M_DDIR << 3 | 1);
		sourceLong(val);
	    fi;
	    /* NOTE: A1 is not saved/restored even if it is in use */
	    genCall("\e23lum_d_");
	    opMove(OP_MOVEL, M_DDIR << 3 | 0, M_DDIR << 3 | reg);
	fi;
    fi;
corp;

/*
 * floatEntry - calling a floating point library entry point.
 */

proc floatEntry(int libOffset)void:
    bool pushedA1;

    pushedA1 := A1Busy();
    if pushedA1 then
	opMove(OP_MOVEL, M_ADIR << 3 | 1, M_DEC << 3 | RSP);
    fi;
    opMove(OP_MOVEL, M_ADIR << 3 | 6, M_DEC << 3 | RSP);
    externRef(OP_MOVEL | 6 << 9 | M_ADIR << 6 | M_SPECIAL << 3 | M_ABSLONG,
	      "\eesaBsaBbuoDeeeIhtaM_" + 20);
    opEA(OP_JSR, M_DISP << 3 | 6);
    sourceWord(libOffset);
    opMove(OP_MOVEL, M_INC << 3 | RSP, M_ADIR << 3 | 6);
    if pushedA1 then
	opMove(OP_MOVEL, M_INC << 3 | RSP, M_ADIR << 3 | 1);
    fi;
corp;

/*
 * floatBinary - perform a binary operation on floating point values.
 */

proc floatBinary(int libOffset)void:
    register uint opMoveL;
    register *DESCRIPTOR d1;
    bool saved;

    DRegUse[2] := DRegUse[2] + 1;
    DRegUse[3] := DRegUse[3] + 1;
    opMoveL := OP_MOVEL;
    d1 := &DescTable[1];
    saved := false;
    if DescTable[0].v_kind = VREG then
	/* right operand is currently in D0/D1 */
	if libOffset ~= LVO_IEEEDP_ADD and libOffset ~= LVO_IEEEDP_MUL then
	    /* operation not commutative, need RHS in D2/D3 */
	    if D23Busy() then
		if d1*.v_kind = VREG then
		    /* we need to do a rotate of the values */
		    opMove(opMoveL, M_DDIR << 3 | 0, M_ADIR << 3 | 0);
		    opMove(opMoveL, M_INDIR << 3 | RSP, M_DDIR << 3 | 0);
		    opMove(opMoveL, M_DDIR << 3 | 2, M_INDIR << 3 | RSP);
		    opMove(opMoveL, M_ADIR << 3 | 0, M_DDIR << 3 | 2);

		    opMove(opMoveL, M_DDIR << 3 | 1, M_ADIR << 3 | 0);
		    opMove(opMoveL, M_DISP << 3 | RSP, M_DDIR << 3 | 1);
		    sourceWord(4);
		    opMove(opMoveL, M_DDIR << 3 | 3, M_DISP << 3 | RSP);
		    destWord(4);
		    opMove(opMoveL, M_ADIR << 3 | 0, M_DDIR << 3 | 3);
		else
		    opSpecial(OP_SAVEM | M_DEC << 3 | RSP);
		    sourceWord(0x3000);
		    opMove(opMoveL, M_DDIR << 3 | 0, M_DDIR << 3 | 2);
		    opMove(opMoveL, M_DDIR << 3 | 1, M_DDIR << 3 | 3);
		    floatRef(OP_RESTM, 0, d1);
		fi;
		saved := true;
	    else
		opMove(opMoveL, M_DDIR << 3 | 0, M_DDIR << 3 | 2);
		opMove(opMoveL, M_DDIR << 3 | 1, M_DDIR << 3 | 3);
		if d1*.v_kind = VREG then
		    /* LHS on stack - pop to D0/D1 */
		    opSpecial(OP_RESTM | M_INC << 3 | RSP);
		    sourceWord(0x0003);
		else
		    floatRef(OP_RESTM, 0, d1);
		fi;
	    fi;
	else
	    /* operation commutative, just put LHS into D2/D3 */
	    if d1*.v_kind = VREG then
		/* LHS is on stack */
		if D23Busy() then
		    /* have to swap stack with D2/D3 */
		    opMove(opMoveL, M_DDIR << 3 | 2, M_ADIR << 3 | 0);
		    opMove(opMoveL, M_INDIR << 3 | RSP, M_DDIR << 3 | 2);
		    opMove(opMoveL, M_ADIR << 3 | 0, M_INDIR << 3 | RSP);

		    opMove(opMoveL, M_DDIR << 3 | 3, M_ADIR << 3 | 0);
		    opMove(opMoveL, M_DISP << 3 | RSP, M_DDIR << 3 | 3);
		    sourceWord(4);
		    opMove(opMoveL, M_ADIR << 3 | 0, M_DISP << 3 | RSP);
		    destWord(4);
		else
		    /* just pop LHS into D2/D3 */
		    opSpecial(OP_RESTM | M_INC << 3 | RSP);
		    sourceWord(0x000c);
		fi;
	    else
		/* LHS in memory somewhere */
		if D23Busy() then
		    opSpecial(OP_SAVEM | M_DEC << 3 | RSP);
		    sourceWord(0x3000);
		    saved := true;
		fi;
		floatRef(OP_RESTM, 2, d1);
	    fi;
	fi;
    else
	/* right operand is simple; put left in D0/D1 if needed */
	if d1*.v_kind = VREG then
	    if d1*.v_value.v_reg = 0xff then
		/* somebody stacked it - restore it */
		opSpecial(OP_RESTM | M_INC << 3 | RSP);
		sourceWord(0x0003);
	    fi;
	else
	    if FloatBusy then
		/* something already in D0/D1 - stack it */
		opSpecial(OP_SAVEM | M_DEC << 3 | RSP);
		sourceWord(0xc000);
		DescTable[2].v_value.v_reg := 0xff;
	    fi;
	    floatRef(OP_RESTM, 0, d1);
	fi;
	if D23Busy() then
	    opSpecial(OP_SAVEM | M_DEC << 3 | RSP);
	    sourceWord(0x3000);
	    saved := true;
	fi;
	floatRef(OP_RESTM, 2, &DescTable[0]);
    fi;
    floatEntry(libOffset);
    if saved then
	opSpecial(OP_RESTM | M_INC << 3 | RSP);
	sourceWord(0x000c);
    fi;
    d1*.v_kind := VREG;
    d1*.v_value.v_reg := 0;
    FloatBusy := true;
corp;
