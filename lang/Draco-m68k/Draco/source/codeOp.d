#drinc:util.g
#draco.g
#externs.g

/* low-level machine specific code generation routines */

bool PEEP_DEBUG = false;

uint PEEP_COUNT = 4;

type
    PeepKind_t = enum {
	pk_single,
	pk_register,
	pk_special,
	pk_move,
	pk_quick,
	pk_moded,
	pk_imm,
	pk_EA
    },

    OffKind_t = enum {pv_none, pv_word, pv_long, pv_value},

    Peep_t = struct {
	PeepKind_t p_kind;
	ushort p_reg;
	byte p_mode, p_size, p_data;
	byte p_sourceEA, p_destEA;
	uint p_opCode;
	OffKind_t p_source, p_dest;
	VALUEKIND p_sourceKind, p_destKind;
	VALUETYPE p_sourceValue, p_destValue;
    };

[PEEP_COUNT] Peep_t Peep;

/*
 * genReloc - generate a relocatable reference from a peepholed instruction.
 */

proc genReloc(register VALUEKIND kind; register *VALUETYPE v)void:
    register ulong lng;

    lng := v*.v_ulong;
    if kind = VPROC then
	genWord(v*.v_proc*);
	genWordZero();
	v*.v_proc* := ProgramNext - &ProgramBuff[4];
    elif kind = VAPROC or kind = VAVAR or kind = VNUMBER then
	genLong(lng);
    elif kind = VCONST then
	genWord(v*.v_const*.ct_use);
	v*.v_const*.ct_use := ProgramNext - &ProgramBuff[2];
    elif kind = VGVAR or kind = VFVAR or kind = VLVAR then
	genWordZero();		/* space for the address to be relocated */
	genWordZero();		/* 68K addresses are 32 bit */
	if kind = VGVAR then
	    /* global variable or array */
	    relocg(ProgramNext - 4, lng);
	elif kind = VFVAR then
	    /* file static variable or array */
	    relocf(ProgramNext - 4, lng);
	elif kind = VLVAR then
	    /* local static var. */
	    printString("Doing VLVAR in genReloc!\n");
	    relocl(ProgramNext - 4, lng);
	else
	    conCheck(14);
	fi;
    elif kind = VEXTERN then
	genWord(v*.v_extern.ve_chain*);
	genWord(v*.v_extern.ve_offset);
	v*.v_extern.ve_chain* := ProgramNext - &ProgramBuff[4];
    fi;
corp;

/*
 * peepGen - actually generate the frontmost instruction in the peephole
 */

proc peepGen()void:
    register *Peep_t p;
    register uint reg;
    bool sourceValid, destValid;

    PeepNext := PeepNext - 1;
    p := &Peep[PeepNext];

    /* at this point we fix up some instructions with alternatives that the
       CPU allows. */

    if p*.p_kind = pk_single then
	if p*.p_destEA & 0o70 = M_ADIR << 3 then
	    if p*.p_opCode = OP_CLR then
		/* CLR.L Ax => SUB.L Ax,Ax */
		p*.p_kind := pk_moded;
		p*.p_opCode := OP_SUB;
		p*.p_reg := p*.p_destEA & 0o7;
		p*.p_mode := S_LADDR;
		p*.p_sourceEA := p*.p_destEA;
	    elif p*.p_opCode = OP_TST then
		/* TST.L Ax => MOV.L Ax,D0 */
		p*.p_kind := pk_move;
		p*.p_opCode := OP_MOVEL;
		p*.p_sourceEA := p*.p_destEA;
		p*.p_destEA := M_DDIR << 3 | 0;
	    else
		/* opI #x,Ay => op #x,Ay */
		p*.p_kind := pk_moded;
		p*.p_opCode :=
		    case p*.p_opCode
		    incase OP_ADDI:
			OP_ADD
		    incase OP_SUBI:
			OP_SUB
		    incase OP_CMPI:
			OP_CMP
		    default:
			conCheck(7);
			OP_ILLEGAL
		    esac;
		p*.p_mode := S_LADDR;
		p*.p_reg := p*.p_destEA & 0o7;
		p*.p_sourceEA := M_SPECIAL << 3 | M_IMM;
		p*.p_dest := pv_none;
	    fi;
	elif p*.p_destEA & 0o70 = M_DDIR << 3 and p*.p_opCode = OP_CLR then
	    /* CLR.x Dy => MOVEQ.L #0,Dy */
	    p*.p_kind := pk_imm;
	    p*.p_reg := p*.p_destEA & 0o7;
	    p*.p_data := 0;
	    p*.p_dest := pv_none;
	elif p*.p_size = S_LONG and
	    (p*.p_destEA & 0o70 = M_DISP << 3 or
	     p*.p_destEA & 0o70 = M_DDIR << 3) and
	    (p*.p_opCode = OP_ORI and p*.p_sourceValue.v_ulong <= 0xffff or
	     p*.p_opCode = OP_ANDI and p*.p_sourceValue.v_ulong >= 0xffff0000)
	then
	    /* can use a word op! */
	    p*.p_size := S_WORD;
	    p*.p_source := pv_word;
	    if p*.p_destEA & 0o70 = M_DISP << 3 then
		p*.p_destValue.v_ulong := p*.p_destValue.v_ulong + 2;
	    fi;
	fi;
    elif p*.p_kind = pk_moded and p*.p_opCode = OP_EOR and
	p*.p_sourceEA = M_SPECIAL << 3 | M_IMM
    then
	/* EOR.s #x,Dy => EORI.s #x,Dy */
	p*.p_kind := pk_single;
	p*.p_opCode := OP_EORI;
	p*.p_size := p*.p_mode & 0b11;
	p*.p_destEA := M_DDIR << 3 | p*.p_reg;
    fi;

    sourceValid := false;
    destValid := false;

    case p*.p_kind
    incase pk_single:
	genWord(p*.p_opCode | make(p*.p_size, uint) << 6 | p*.p_destEA);
	destValid := true;
    incase pk_register:
	reg := p*.p_reg;
	genWord(p*.p_opCode | reg << 9 | p*.p_sourceEA);
	sourceValid := true;
	if p*.p_opCode = OP_LEA then
	    ARegUse[reg] := ARegUse[reg] + 1;
	else
	    DRegUse[reg] := DRegUse[reg] + 1;
	fi;
    incase pk_special:
	genWord(p*.p_opCode);
    incase pk_move:
	genWord(p*.p_opCode |
		make(p*.p_destEA & 0o07, uint) << 9 |
		    make(p*.p_destEA & 0o70, uint) << 3 |
		p*.p_sourceEA);
	sourceValid := true;
	destValid := true;
    incase pk_quick:
	genWord(p*.p_opCode | make(p*.p_data, uint) << 9 |
		make(p*.p_size, uint) << 6 | p*.p_sourceEA);
	sourceValid := true;
    incase pk_moded:
	reg := p*.p_reg;
	genWord(p*.p_opCode | reg << 9 |
		make(p*.p_mode, uint) << 6 | p*.p_sourceEA);
	sourceValid := true;
	if p*.p_mode = S_SADDR or p*.p_mode = S_LADDR then
	    ARegUse[reg] := ARegUse[reg] + 1;
	else
	    DRegUse[reg] := DRegUse[reg] + 1;
	fi;
    incase pk_imm:
	reg := p*.p_reg;
	genWord(OP_MOVEQ | reg << 9 | p*.p_data);
	DRegUse[reg] := DRegUse[reg] + 1;
    incase pk_EA:
	genWord(p*.p_opCode | p*.p_sourceEA);
	sourceValid := true;
    esac;
    case p*.p_source
    incase pv_word:
	genWord(p*.p_sourceValue.v_ulong);
    incase pv_long:
	genLong(p*.p_sourceValue.v_ulong);
    incase pv_value:
	genReloc(p*.p_sourceKind, &p*.p_sourceValue);
    esac;
    case p*.p_dest
    incase pv_word:
	genWord(p*.p_destValue.v_ulong);
    incase pv_long:
	genLong(p*.p_destValue.v_ulong);
    incase pv_value:
	genReloc(p*.p_destKind, &p*.p_destValue);
    esac;
    if sourceValid then
	reg := p*.p_sourceEA & 0o7;
	case p*.p_sourceEA >> 3
	incase M_DDIR:
	    DRegUse[reg] := DRegUse[reg] + 1;
	incase M_ADIR:
	incase M_INDIR:
	incase M_INC:
	incase M_DEC:
	incase M_DISP:
	    ARegUse[reg] := ARegUse[reg] + 1;
	incase M_INDEX:
	    ARegUse[reg] := ARegUse[reg] + 1;
	    reg := p*.p_sourceValue.v_ulong >> 12;
	    if p*.p_sourceValue.v_ulong & 0x8000 = 0 then
		DRegUse[reg] := DRegUse[reg] + 1;
	    else
		ARegUse[reg] := ARegUse[reg] + 1;
	    fi;
	incase M_SPECIAL:
	    if reg = M_PCINDEX then
		reg := p*.p_sourceValue.v_ulong >> 12;
		if p*.p_sourceValue.v_ulong & 0x8000 = 0 then
		    DRegUse[reg] := DRegUse[reg] + 1;
		else
		    ARegUse[reg] := ARegUse[reg] + 1;
		fi;
	    fi;
	esac;
    fi;
    if destValid then
	reg := p*.p_destEA & 0o7;
	case p*.p_destEA >> 3
	incase M_DDIR:
	    DRegUse[reg] := DRegUse[reg] + 1;
	incase M_ADIR:
	incase M_INDIR:
	incase M_INC:
	incase M_DEC:
	incase M_DISP:
	    ARegUse[reg] := ARegUse[reg] + 1;
	incase M_INDEX:
	    ARegUse[reg] := ARegUse[reg] + 1;
	    reg := p*.p_destValue.v_ulong >> 12;
	    if p*.p_destValue.v_ulong & 0x8000 = 0 then
		DRegUse[reg] := DRegUse[reg] + 1;
	    else
		ARegUse[reg] := ARegUse[reg] + 1;
	    fi;
	incase M_SPECIAL:
	    if reg = M_PCINDEX then
		reg := p*.p_destValue.v_ulong >> 12;
		if p*.p_destValue.v_ulong & 0x8000 = 0 then
		    DRegUse[reg] := DRegUse[reg] + 1;
		else
		    ARegUse[reg] := ARegUse[reg] + 1;
		fi;
	    fi;
	esac;
    fi;
corp;

/*
 * peepFlush - flush out all instructions queued in the peephole
 */

proc peepFlush()void:

    flushHereChain();
    while PeepNext ~= 0 do
	peepGen();
    od;
    CCIsReg := false;
    CCKind := VVOID;
corp;

/*
 * unDoTo - ungenerate peeped instructions back until PeepTotal is equal
 *	to the given value.
 */

proc unDoTo(uint pos)void:

    while PeepTotal ~= pos do
	PeepTotal := PeepTotal - 1;
	PeepNext := PeepNext - 1;
	if PeepNext ~= 0 then
	    BlockCopy(pretend(&Peep[0], *byte), pretend(&Peep[1], *byte),
		      PeepNext * sizeof(Peep_t));
	fi;
    od;
corp;

/*
 * peepAdd - get ready to add an instruction to the peephole.
 */

proc peepAdd()*Peep_t:
    register *Peep_t p;

    flushHereChain();
    if PeepNext = PEEP_COUNT then
	peepGen();
    fi;
    if PeepNext ~= 0 then
	BlockCopyB(pretend(&Peep[PeepNext + 1] - 1, *byte),
		   pretend(&Peep[PeepNext] - 1, *byte),
		   PeepNext * sizeof(Peep_t));
    fi;
    PeepNext := PeepNext + 1;
    PeepTotal := PeepTotal + 1;
    p := &Peep[0];
    p*.p_source := pv_none;
    p*.p_dest := pv_none;
    p*.p_sourceKind := VVOID;
    p*.p_destKind := VVOID;
    /* these are needed so that comparisons in later tests can get away with
       just comparing the ulong values, regardless of what the actual
       instruction uses of the VALUEKIND */
    p*.p_sourceValue.v_ulong := 0;
    p*.p_destValue.v_ulong := 0;
    p
corp;

/*
 * veq - compare two VALUETYPEs to see if they reference the same value.
 */

proc veq(register VALUEKIND kind1; VALUEKIND kind2;
	 register *VALUETYPE d1, d2)bool:

    if kind1 ~= kind2 then
	false
    elif kind1 = VINDIR then
	d1*.v_indir.v_offset = d2*.v_indir.v_offset and
	    d1*.v_indir.v_base = d2*.v_indir.v_base
    elif kind1 = VEXTERN then
	d1*.v_extern.ve_offset = d2*.v_extern.ve_offset and
	    d1*.v_extern.ve_chain = d2*.v_extern.ve_chain
    else
	d1*.v_ulong = d2*.v_ulong
    fi
corp;

/*
 * autoFix - if an EA is an indirect through the given register, we want
 *	to turn it into auto-inc or auto-dec.
 */

proc autoFix(bool isInc; ushort reg; *byte pEA)bool:

    if pEA* = M_INDIR << 3 | reg then
	pEA* := if isInc then M_INC else M_DEC fi << 3 | reg;
	true
    else
	false
    fi
corp;

/*
 * checkAutoInc - see if we can turn ADDQ into an auto-increment mode.
 *	p1 is the ADDQ, and p2 is the previous instruction.
 */

proc checkAutoInc(register *Peep_t p1, p2)void:
    register ushort reg;

    reg := p1*.p_sourceEA & 0o7;
    if p2*.p_kind = pk_move and
	p1*.p_data =
	    if p2*.p_opCode = OP_MOVEB then
		make(1, byte)
	    elif p2*.p_opCode = OP_MOVEW then
		make(2, byte)
	    else
		make(4, byte)
	    fi and
	(autoFix(true, reg, &p2*.p_sourceEA) or
	 autoFix(true, reg, &p2*.p_destEA)) or
	p2*.p_kind = pk_single and
	p1*.p_data =
	    if p2*.p_size = S_BYTE then
		make(1, byte)
	    elif p2*.p_size = S_WORD then
		make(2, byte)
	    else
		make(4, byte)
	    fi and
	autoFix(true, reg, &p2*.p_destEA) or
	p2*.p_kind = pk_moded and
	p1*.p_data =
	    if p2*.p_mode & 0b11 = S_BYTE then
		make(1, byte)
	    elif p2*.p_mode & 0b11 = S_WORD then
		make(2, byte)
	    elif p2*.p_mode & 0b11 = S_LONG then
		make(4, byte)
	    else
		p1*.p_data - 1
	    fi and
	autoFix(true, reg, &p2*.p_sourceEA) or
	p2*.p_kind = pk_quick and
	p1*.p_data =
	    if p2*.p_size = S_BYTE then
		make(1, byte)
	    elif p2*.p_size = S_WORD then
		make(2, byte)
	    else
		make(4, byte)
	    fi and
	autoFix(true, reg, &p2*.p_sourceEA)
    then
	/* MOV.s (Ax),y; ADDQ #s,Ax => MOV.s (Ax)+,y
	   MOV.s x,(Ay); ADDQ #s,Ay => MOV.s x,(Ay)+
	   op.s (Ax); ADDQ #s,Ax => op.s (Ax)+
		for op = {CLR,NOT,NEG}
	   op.s (Ax),y; ADDQ #s,Ax => op.s (Ax)+,y
	   op.s y,(Ax); ADDQ #s,Ax => op.s y,(Ax)+
	   op.s (Ax); ADDQ #s,Ax => op.s (Ax)+
	 */
	if PEEP_DEBUG then
	    printString("checkAutoInc: auto-increment address mode used\n");
	fi;
	OptCount := OptCount + 1;
	unDoTo(PeepTotal - 1);
	CCIsReg := false;
	CCKind := VVOID;
    elif p2*.p_kind = pk_move and p2*.p_destEA = M_ADIR << 3 | reg and
	p2*.p_sourceEA >> 3 = M_ADIR
    then
	/* This turns a MOVEA/ADDQ into an LEA, which is then caught by
	   other code so that something like:
		movea.l    a5,a4		<= p2
		addq.l	   #4,a4		<= p1
		move.l	   (a4),-(sp)
	   can become just
		move.l	   4(a5),-(sp)
	 */
	p2*.p_kind := pk_register;
	p2*.p_opCode := OP_LEA;
	p2*.p_reg := reg;
	p2*.p_sourceEA := M_DISP << 3 | p2*.p_sourceEA & 0o7;
	p2*.p_source := pv_word;
	p2*.p_sourceValue.v_long :=
	    if p1*.p_data = 0 then 8 else p1*.p_data fi;
	if PEEP_DEBUG then
	    printString("checkAutoInc: base-displacement mode used\n");
	fi;
	OptCount := OptCount + 1;
	unDoTo(PeepTotal - 1);
    fi;
corp;

/*

/*
 * checkOffsetUse - check to see if a previous add of a constant to a value
 *	in a D-reg can be turned into a displacement on an EA.
 */

proc checkOffsetUse(byte ea; *VALUETYPE pValue)void:
    register *Peep_t p1, p2;
    register ushort indexReg;
    register uint value;
    uint incDec;
    bool longRef;

    if PeepNext < 2 then
	return;
    fi;
    if ea & 0o70 ~= M_INDEX << 3 then
	return;
    fi;
%%%% p1 not defined yet %%%%
    if p1*.p_kind ~= pk_quick then
	return;
    fi;
    value := pValue*.v_ulong;
    indexReg := (value >> 12) & 0o7;
    longRef := value & 0x00000800 ~= 0;
    p1 := &Peep[1];
    if p1*.p_sourceEA ~= M_DDIR << 3 | indexReg or indexReg > DRTop then
	return;
    fi;
    /* OK, the previous instruction is an addq/subq from the index reg, and
       the index reg is a scratch reg. */
    if longRef and p1*.p_size ~= S_LONG then
	return;
    fi;
    if not longRef and p1*.p_size ~= S_WORD then
	return;
    fi;
    incDec := p1*.p_data;
    if incDec = 0 then
	incDec := 8;
    fi;
    OptCount := OptCount + 1;
    if p1*.p_opCode = OP_ADDQ then
	if value & 0x80 = 0 and value & 0xff + incDec > 0x7f then
	    return;
	fi;
	value := value & 0xff00 | (value + incDec) & 0xff;
    else
	if value & 0x80 ~= 0 and value & 0xff - incDec > 0xff then
	    return;
	fi;
	value := value & 0xff00 | (value - incDec) & 0xff;
    fi;
    pValue*.v_ulong := value;
    p1* := Peep[0];
    unDoTo(PeepTotal - 1);
    DRegQueue[indexReg].r_desc.v_kind := VVOID;
    if PEEP_DEBUG then
	printString(
	    "ADDQ/SUBQ #x,dy; ref a(az, db.s) => ref a+/-x(az, db.s)\n");
    fi;
    if PeepNext < 3 then
	return;
    fi;
    if p1*.p_kind = pk_move and p1*.p_sourceEA & 0o70 = M_DDIR << 3 and
	p1*.p_destEA = M_DDIR << 3 | indexReg and
	p1*.p_opCode = if longRef then OP_MOVEL else OP_MOVEW fi
    then
	OptCount := OptCount + 1;
	pValue*.v_ulong :=
	    value & ~0o070000 | make(p1*.p_sourceEA & 0o7, uint) << 12;
	p1* := Peep[0];
	unDoTo(PeepTotal - 1);
	if PEEP_DEBUG then
	    printString("also avoid move of index reg to temp\n");
	fi;
    fi;
corp;
*/

/*
 * setCCDest - set the CC descriptor from the destination operand of the
 *	passed peephole slot.
 */

proc setCCDest(*Peep_t p)void:

    CCIsReg := false;
    CCKind := p*.p_destKind;
    CCValue := p*.p_destValue;
corp;

proc setCCSource(*Peep_t p)void:

    CCIsReg := false;
    CCKind := p*.p_sourceKind;
    CCValue := p*.p_sourceValue;
corp;

/*
 * copy peephole instruction values around. Receiver on left.
 */

proc copyDestFromDest(register *Peep_t p1, p2)void:

    p1*.p_destEA := p2*.p_destEA;
    p1*.p_dest := p2*.p_dest;
    p1*.p_destKind := p2*.p_destKind;
    p1*.p_destValue := p2*.p_destValue;
corp;

proc copyDestFromSource(register *Peep_t p1, p2)void:

    p1*.p_destEA := p2*.p_sourceEA;
    p1*.p_dest := p2*.p_source;
    p1*.p_destKind := p2*.p_sourceKind;
    p1*.p_destValue := p2*.p_sourceValue;
corp;

proc copySourceFromDest(register *Peep_t p1, p2)void:

    p1*.p_sourceEA := p2*.p_destEA;
    p1*.p_source := p2*.p_dest;
    p1*.p_sourceKind := p2*.p_destKind;
    p1*.p_sourceValue := p2*.p_destValue;
corp;

proc copySourceFromSource(register *Peep_t p1, p2)void:

    p1*.p_sourceEA := p2*.p_sourceEA;
    p1*.p_source := p2*.p_source;
    p1*.p_sourceKind := p2*.p_sourceKind;
    p1*.p_sourceValue := p2*.p_sourceValue;
corp;

/*
 * moveDone - completion of a MOV instruction - do peepholes based on
 *	its full form.
 */

proc moveDone()void:
    register *Peep_t p1, p2, p3;
    register byte mode, size;
    register uint reg, r2;
    bool doneOne, stillAMove, doneAny;

    stillAMove := true;
    p1 := &Peep[0];
    mode := p1*.p_destEA & 0o70;
    reg := p1*.p_destEA & 0o7;
    if mode = M_ADIR << 3 then
	ARegQueue[reg].r_desc.v_kind := VVOID;
    elif mode = M_DDIR << 3 then
	DRegQueue[reg].r_desc.v_kind := VVOID;
	CCIsReg := true;
	CCReg := reg;
    else
	setCCDest(p1);
    fi;
    p2 := &Peep[1];
    if PeepNext >= 3 then
	if PEEP_DEBUG then
	    printString("moveDone: PeepNext >= 3\n");
	fi;
	mode := p1*.p_sourceEA & 0o70;
	reg := p1*.p_sourceEA & 0o7;
	p3 := &Peep[2];
	if (mode = M_DDIR << 3 or mode = M_ADIR << 3) and
	    reg <= if mode = M_DDIR << 3 then DRTop else ARTop fi and
	    p3*.p_kind = pk_move and p3*.p_opCode = p1*.p_opCode and
	    p3*.p_sourceEA = p1*.p_destEA and p3*.p_destEA = p1*.p_sourceEA and
	    p3*.p_source = p1*.p_dest and
	    veq(p3*.p_sourceKind, p1*.p_destKind,
		&p3*.p_sourceValue, &p1*.p_destValue)
	then
	    if PEEP_DEBUG then
		printString("moveDone: first big case\n");
	    fi;
	    size :=
		if p1*.p_opCode = OP_MOVEB then
		    S_BYTE
		elif p1*.p_opCode = OP_MOVEW then
		    S_WORD
		else
		    S_LONG
		fi;
	    if p2*.p_kind = pk_quick and p2*.p_sourceEA = p1*.p_sourceEA and
		    p2*.p_size = size or
		p2*.p_kind = pk_single and p2*.p_destEA = p1*.p_sourceEA and
		    p2*.p_size = size and
		    (p1*.p_destEA & 0o70 ~= M_ADIR << 3 or
		    p2*.p_opCode = OP_ADDI or p2*.p_opCode = OP_SUBI) or
		p2*.p_kind = pk_moded and
		    if p2*.p_mode = S_SADDR then
			p1*.p_destEA & 0o70 = M_ADIR << 3 and
			size = S_WORD and p2*.p_reg = reg and
			p2*.p_sourceEA & 0o70 = M_DDIR << 3
		    elif p2*.p_mode = S_LADDR then
			size = S_LONG and p2*.p_reg = reg and
			p2*.p_sourceEA & 0o70 <= M_ADIR << 3
		    elif p2*.p_mode & 0b100 = OM_REG then
			p2*.p_mode & 0b011 = size and p2*.p_reg = reg and
			p2*.p_sourceEA & 0o70 <= M_ADIR << 3
		    else
			p2*.p_mode & 0b011 = size and
			p2*.p_sourceEA = M_DDIR << 3 | reg
		    fi
	    then
		/* MOV.s x,Ry; {ADDQ.s | SUBQ.s} z,Ry; MOV.s Ry,x =>
						{ADDQ.s | SUBQ.s} z,x
		   MOV.s x,Ry; opI.s #z,Ry; MOV.s Ry,x => opI.s #z,x
			for op = {OR,AND,SUB,ADD,EOR}
		   MOV.s x,Dy; op.s Dy; MOV.s Dy,x => op.s x
			for op = {NEG,NOT}
		   MOV.s x,Ry; op.s Rz,Ry; MOV.s Ry,x => op.s Rz,x
			for op = {OR,AND,SUB,ADD,EOR}
		   so long as Ry is a temp reg. */
		OptCount := OptCount + 2;
		stillAMove := false;
		if mode = M_DDIR << 3 then
		    DRegQueue[reg].r_desc.v_kind := VVOID;
		else
		    ARegQueue[reg].r_desc.v_kind := VVOID;
		fi;
		p3* := p2*;
		if p3*.p_kind = pk_single then
		    /* ORI, ANDI, SUBI, ADDI, EORI, NEG, NOT */
		    /* NOTE: We can be generating some illegal instructions
		       here! (CPU does not allow opI #x,Ay). These will be
		       replaced during 'peepGen'. */
		    if PEEP_DEBUG then
			printString("moveDone: "
		      "MOVE.s x,Ry; opI.s \#z,Ry; MOVE.s Ry,x => OpI.s \#z,x\n"
			"              for op = {OR,AND,SUB,ADD,EOR}\n"
			"          "
			"MOVE.s x,Dy; op.s Dy; MOV.s Dy,x => op.s x\n"
			"              for op = {NEG,NOT}\n"
			);
		    fi;
		    copyDestFromDest(p3, p1);
		    if p3*.p_destEA & 0o70 = M_DDIR << 3 then
			CCIsReg := true;
			CCReg := p3*.p_destEA & 0o7;
		    elif p3*.p_destEA & 0o70 = M_ADIR << 3 then
			CCIsReg := false;
			CCKind := VVOID;
		    else
			setCCDest(p3);
		    fi;
		    unDoTo(PeepTotal - 2);
		elif p3*.p_kind = pk_moded then
		    /* OR, AND, SUB, ADD, EOR */
		    if PEEP_DEBUG then
			printString("moveDone: "
			"MOVE.s x,Ry; op.s Rz,Ry; MOVE.s Ry,x => op.s Rz,x\n"
			"              for op = {OR,AND,SUB,ADD,EOR}\n"
			);
		    fi;
		    if p1*.p_destEA & 0o70 = M_ADIR << 3 or
			p1*.p_destEA & 0o70 = M_DDIR << 3
		    then
			/* just operate on the A-reg directly.
			   Need this for D-regs as well, since that combination
			   turns out to be a SUBX instruction. Sigh. */
			p3*.p_reg := p1*.p_destEA & 0o7;
		    else
			if p3*.p_mode = S_LADDR or
			    p3*.p_mode & 0b100 = OM_REG
			then
			    /* have to switch it around since we need to use
			       the EA to access memory */
			    p3*.p_reg := p3*.p_sourceEA & 0o7;
			    if p3*.p_mode = S_LADDR then
				p3*.p_mode := OM_EA | S_LONG;
			    else
				p3*.p_mode := p3*.p_mode | OM_EA;
			    fi;
			fi;
			copySourceFromDest(p3, p1);
		    fi;
		    if p3*.p_mode = S_LADDR or p3*.p_mode = S_SADDR then
			CCIsReg := false;
			CCKind := VVOID;
		    else
			setCCSource(p3);
		    fi;
		    unDoTo(PeepTotal - 2);
		else
		    /* ADDQ, SUBQ */
		    if PEEP_DEBUG then
			printString("moveDone: "
			"MOVE.s x,Ry; {ADDQ.s | SUBQ.s} z,Ry; MOVE.s Ry,x =>\n"
			"              {ADDQ.s | SUBQ.s} z,x\n");
		    fi;
		    copySourceFromDest(p3, p1);
		    if p3*.p_sourceEA & 0o70 = M_DDIR << 3 then
			CCIsReg := true;
			CCReg := p3*.p_sourceEA & 0o7;
		    elif p3*.p_sourceEA & 0o70 = M_ADIR << 3 then
			CCIsReg := false;
			CCKind := VVOID;
		    else
			setCCSource(p3);
		    fi;
		    unDoTo(PeepTotal - 2);
		    /* further test to see if we can use auto-increment mode */
		    if PeepNext >= 2 and p1*.p_opCode = OP_ADDQ and
			p1*.p_sourceEA & 0o70 = M_ADIR << 3
		    then
			checkAutoInc(p1, p2);
		    fi;
		fi;
	    elif p2*.p_kind = pk_moded and
		(p2*.p_mode <= S_SADDR or p2*.p_mode = S_LADDR) and
		(p1*.p_destEA & 0o70 ~= M_ADIR << 3 or
		    p2*.p_opCode = OP_ADD or p2*.p_opCode = OP_SUB) and
		p2*.p_reg = reg and p2*.p_sourceEA = M_SPECIAL << 3 | M_IMM and
		    if p2*.p_mode & 0b011 = 0b011 then
			size = S_LONG
		    else
			p2*.p_mode & 0b011 = size
		    fi
	    then
		stillAMove := false;
		if p2*.p_mode <= S_LONG then
		    DRegQueue[reg].r_desc.v_kind := VVOID;
		else
		    ARegQueue[reg].r_desc.v_kind := VVOID;
		fi;
		if size = S_LONG and p2*.p_sourceKind = VNUMBER and
		    p2*.p_sourceValue.v_long >= -128 and
		    p2*.p_sourceValue.v_long <= 127 and
		    p1*.p_destEA ~= M_DDIR << 3 | 0
		then
		    /* MOVE.L x,Ry; op.L #z,Ry; MOVE.L Ry,x =>
			MOVEQ.L \#z,D0; op.L D0,x
			for op = {OR,AND,SUB,ADD,EOR} */
		    if PEEP_DEBUG then
			printString("moveDone: "
			    "MOVE.L x,Ry; op.L \#z,Ry; MOVE.L Ry,x => "
			    "MOVEQ.L \#z,D0; op.L D0,x\n");
		    fi;
		    OptCount := OptCount + 1;
		    p3*.p_source := pv_none;
		    p3*.p_kind := pk_imm;
		    p3*.p_reg := 0;
		    p3*.p_data := p2*.p_sourceValue.v_long;
		    p2*.p_mode := p2*.p_mode | OM_EA;
		    copySourceFromDest(p2, p1);
		    p2*.p_reg := 0;
		    if p2*.p_sourceEA & 0o70 = M_DDIR << 3 then
			/* special case in CPU. Have to swap the registers
			   and clear the OM_EA bit */
			p2*.p_mode := p2*.p_mode & ~OM_EA;
			p2*.p_reg := p2*.p_sourceEA & 0o07;
			p2*.p_sourceEA := M_DDIR << 3 | 0;
			CCIsReg := true;
			CCReg := p2*.p_reg;
		    elif p2*.p_sourceEA & 0o70 = M_ADIR << 3 then
			CCIsReg := false;
			CCKind := VVOID;
		    else
			setCCSource(p2);
		    fi;
		    unDoTo(PeepTotal - 1);
		else
		    /* MOV.s x,Ry; op.s #z,Ry; MOV.s Ry,x => opI.s #z,x
			    for op = {OR,AND,SUB,ADD,EOR}
		       so long as Ry is a temporary register */
		    if PEEP_DEBUG then
			printString("moveDone: "
		       "MOVE.s x,Ry; op.s \#z,Ry; MOVE.s Ry,x => opI.s \#z,x\n"
			    "              for op = {OR,AND,SUB,ADD,EOR}\n"
			);
		    fi;
		    OptCount := OptCount + 2;
		    p3* := p1*; 	    /* get the destEA stuff */
		    p3*.p_kind := pk_single;
		    p3*.p_opCode :=
			case p2*.p_opCode
			incase OP_OR:
			    OP_ORI
			incase OP_AND:
			    OP_ANDI
			incase OP_SUB:
			    OP_SUBI
			incase OP_ADD:
			    OP_ADDI
			incase OP_EOR:
			    OP_EORI
			esac;
		    p3*.p_source := p2*.p_source;
		    /* was a hard-to-find bug here. The constant may be a 32
		       bit value that needs relocating, so we need to copy the
		       kind as well (since VNUMBER ends up that way anyway) */
		    p3*.p_sourceKind := p2*.p_sourceKind;
		    p3*.p_sourceValue := p2*.p_sourceValue;
		    if p2*.p_mode = S_LADDR then
			p3*.p_size := S_LONG;
		    elif p2*.p_mode = S_SADDR then
			p3*.p_size := S_LONG;
			p3*.p_source := pv_long;
		    else
			p3*.p_size := p2*.p_mode;
		    fi;
		    if p3*.p_destEA & 0o70 = M_DDIR << 3 then
			CCIsReg := true;
			CCReg := p3*.p_destEA & 0o7;
		    elif p3*.p_destEA & 0o70 = M_ADIR << 3 then
			CCIsReg := false;
			CCKind := VVOID;
			/* special case - switch to using ADDA */
			if p2*.p_mode = S_SADDR then
			    p3*.p_opCode :=
				if p3*.p_opCode = OP_ADDI then
				    OP_ADD
				else
				    OP_SUB
				fi;
			    p3*.p_kind := pk_moded;
			    p3*.p_reg := p3*.p_destEA & 0o7;
			    p3*.p_sourceEA := M_SPECIAL << 3 | M_IMM;
			    p3*.p_mode := S_SADDR;
			    p3*.p_source := pv_word;
			fi;
		    else
			setCCDest(p3);
		    fi;
		    unDoTo(PeepTotal - 2);
		fi;
	    elif (p1*.p_destEA & 0o70 = M_DDIR << 3 or
		    p1*.p_destEA & 0o70 = M_ADIR << 3 and
		    (p2*.p_opCode = OP_ADD or p2*.p_opCode = OP_SUB)) and
		    (
			p2*.p_kind = pk_moded and
			    (p2*.p_mode <= S_SADDR or p2*.p_mode = S_LADDR) and
			    if p2*.p_mode & 0b011 = 0b011 then
				size = S_LONG
			    else
				p2*.p_mode & 0b011 = size
			    fi or
			(p2*.p_opCode = OP_MULU or p2*.p_opCode = OP_MULS) and
			    size = S_WORD
		    ) and p2*.p_reg = reg
	    then
		/* MOV.s Dx,Ry; op.s z,Ry; MOV.s Ry,Dx => op.s z,Dx
			for op = {OR,AND,SUB,ADD,EOR,MULU,MULS}
		   so long as Ry is a temporary register */
		if PEEP_DEBUG then
		    printString("moveDone: "
			"MOVE.s Dx,Ry; op.s z,Ry; MOVE.s Ry,Dx => op.s z,Dx\n"
		       "              for op = {OR,AND,SUB,ADD,EOR,MULU,MULS\n"
		    );
		fi;
		stillAMove := false;
		OptCount := OptCount + 2;
		DRegQueue[reg].r_desc.v_kind := VVOID;
		p3* := p2*;
		p3*.p_reg := p1*.p_destEA & 0o7;
		CCIsReg := true;
		CCReg := p3*.p_reg;
		unDoTo(PeepTotal - 2);
	    elif mode = M_DDIR << 3 and p2*.p_kind = pk_special and
		p2*.p_opCode & 0o170007 = 0o160000 | reg and
		p2*.p_opCode & 0o000300 ~= 0o000300 and
		(p1*.p_destEA & 0o70 = M_DDIR << 3 or
		 p2*.p_opCode & 0o177347 = 0o161100 | reg)
	    then
		/* MOV.s Dx,Dy; shift z,Dy; MOV.s Dy,Dx => shift z,Dx */
		if PEEP_DEBUG then
		    printString("moveDone: "
		     "MOVE.s Dx,Dy; shift z,Dy; MOVE.s Dy,Dx => shift z,Dx\n");
		fi;
		stillAMove := false;
		OptCount := OptCount + 2;
		DRegQueue[reg].r_desc.v_kind := VVOID;
		/* forced add when shift generated, so remove it here */
		DRegUse[reg] := DRegUse[reg] - 1;
		p3* := p2*;
		if p1*.p_destEA & 0o70 = M_DDIR << 3 then
		    p3*.p_opCode :=
			p3*.p_opCode & 0o177770 | p1*.p_destEA & 0o7;
		    CCIsReg := true;
		    CCReg := p1*.p_destEA & 0o7;
		else
		    p3*.p_opCode :=
			0o160300 | p3*.p_opCode & 0o000400 |
			    (p3*.p_opCode & 0o000030) << 6;
		    p3*.p_kind := pk_EA;
		    copySourceFromDest(p3, p1);
		    setCCSource(p3);
		fi;
		unDoTo(PeepTotal - 2);
	    fi;
	elif mode = M_DDIR << 3 and reg <= DRTop and
	    p3*.p_kind = pk_move and p3*.p_opCode = OP_MOVEL and
	    p3*.p_destEA = p1*.p_sourceEA and p1*.p_destEA = M_DDIR<<3 | 0 and
	    p2*.p_kind = pk_imm and p2*.p_reg = 1
	then
	    /* MOV.L x,Dt; MOVEQ #y,D1; MOV.L Dt,D0 =>
		    MOV.L x,D0; MOVEQ #y,D1
		(getting ready for long mul/div/mod by constant */
	    if PEEP_DEBUG then
		printString("moveDone: "
		    "MOVE.L x,Dt; MOVEQ \#y,D1; MOVE.L Dt,D0 =>\n"
		    "          MOVE.L x,D0; MOVEQ \#y,D1\n");
	    fi;
	    stillAMove := false;
	    OptCount := OptCount + 1;
	    p3*.p_destEA := M_DDIR << 3 | 0;
	    DRegQueue[reg].r_desc.v_kind := VVOID;
	    CCIsReg := false;
	    CCKind := VVOID;
	    unDoTo(PeepTotal - 1);
	elif p1*.p_opCode = OP_MOVEL and p1*.p_destEA = M_DDIR << 3 | 0 and
	    mode = M_ADIR << 3 and reg <= ARTop and
	    ARegQueue[p1*.p_sourceEA & 0o7].r_desc.v_kind ~= VVOID and
	    p2*.p_opCode = OP_MOVEL and p2*.p_sourceEA = p1*.p_sourceEA and
	    p3*.p_opCode = OP_MOVEL and p3*.p_destEA = p1*.p_sourceEA and
	    p2*.p_destEA & 0o70 ~= M_ADIR << 3
	then
	    /* gack! we are trying to avoid an extra move to test the CC value
	       of a pointer, but we get a bit messed up by previous
	       optimizations which have changed the move resulting from
	       putting the pointer value into a scratch A register.
		MOVE.L x,At; MOVE.L At,y; MOVE.L At,D0 => MOVE.L x,y */
	    if PEEP_DEBUG then
		printString("moveDone: "
		    "MOVE.L x,At; MOVE.L At,y; MOVE.L At,D0 => MOVE.L x,y\n");
	    fi;
	    OptCount := OptCount + 2;
	    ARegQueue[reg].r_desc.v_kind := VVOID;
	    copyDestFromDest(p3, p2);
	    unDoTo(PeepTotal - 2);
/*
	    checkOffsetUse(p1*.p_sourceEA, &p1*.p_sourceValue);
	    checkOffsetUse(p1*.p_destEA, &p1*.p_destValue);
*/
	elif (mode = M_INDIR << 3 or mode = M_DISP << 3) and
	    (p1*.p_destEA & 0o70 = M_INDIR << 3 or
	     p1*.p_destEA & 0o70 = M_DISP << 3)
	then
	    r2 := p1*.p_destEA & 0o7;
	    if reg ~= r2 and reg <= ARTop and r2 <= ARTop and
		veq(ARegQueue[reg].r_desc.v_kind, ARegQueue[r2].r_desc.v_kind,
		    &ARegQueue[reg].r_desc.v_value,
		    &ARegQueue[r2].r_desc.v_value) and
		p2*.p_opCode = OP_MOVEL and
		(p2*.p_destEA = M_ADIR << 3 | r2 or
		 p2*.p_destEA = M_ADIR << 3 | reg)
	    then
		/* x in Ax; MOVEL x,Ay; MOVE.s (Av),(Ay): drop the MOVE into
		   Ay, modify the current to use Ax, and decrement the use
		   of Ay and forget its value */
		if PEEP_DEBUG then
		    printString("moveDone: "
			"x in Az; MOVE.L x,Ay; MOVE.s (Av),(Ay): use Ax\n");
		fi;
		OptCount := OptCount + 1;
		if p2*.p_destEA = M_ADIR << 3 | r2 then
		    p1*.p_destEA := p1*.p_destEA & 0o70 | reg;
		else
		    p1*.p_sourceEA := mode | r2;
		    r2 := reg;
		fi;
		ARegQueue[r2].r_desc.v_kind := VVOID;
		p2* := p1*;
		unDoTo(PeepTotal - 1);
	    fi;
	elif (p2*.p_opCode = OP_NOT or p2*.p_opCode = OP_NEG) and
	    p3*.p_kind = pk_move and p1*.p_opCode = p3*.p_opCode and
	    p3*.p_destEA = M_DDIR << 3 | reg and
	    p2*.p_destEA = M_DDIR << 3 | reg and
	    mode = M_DDIR << 3 and reg <= DRTop and
	    p1*.p_destEA & 0o70 = M_DDIR << 3
	then
	    /* MOVE.s x,Dt; {NOT | NEG}.s Dt; MOVE.s Dt,Dy =>
		MOVE.s x,Dy; {NOT | NEG}.s Dy  so long as Dt is scratch */
	    if PEEP_DEBUG then
		printString("moveDone: "
		    "MOVE.s x,Dt; {NOT | NEG}.s Dt; MOVE.s Dt,Dy =>\n"
		    "          MOVE.s x,Dy; {NOT | NEG}.s Dy\n");
	    fi;
	    stillAMove := false;
	    OptCount := OptCount + 1;
	    p3*.p_destEA := M_DDIR << 3 | p1*.p_destEA & 0o7;
	    p2*.p_destEA := p3*.p_destEA;
	    DRegQueue[reg].r_desc.v_kind := VVOID;
	    unDoTo(PeepTotal - 1);
	fi;
    fi;
    while PeepNext >= 2 and stillAMove do
	if PEEP_DEBUG then
	    printString("moveDone, PeepNext >= 2\n");
	fi;
	if p2*.p_kind = pk_move and p2*.p_opCode = p1*.p_opCode and
	    p2*.p_sourceEA = M_DDIR << 3 | 0 and
	    p1*.p_sourceEA = p2*.p_destEA and
	    p1*.p_source = p2*.p_dest and
	    veq(p1*.p_sourceKind, p2*.p_destKind,
		&p1*.p_sourceValue, &p2*.p_destValue)
	then
	    /* MOV.s D0,x; MOV.s x,y => MOV.s D0,x; MOV.s D0,y */
	    if PEEP_DEBUG then
		printString("moveDone: "
		    "MOVE.s D0,x; MOVE.s x,y => MOVE.s D0,x; MOVE.s D0,y\n");
	    fi;
	    p1*.p_sourceEA := M_DDIR << 3 | 0;
	    p1*.p_source := pv_none;
	elif p2*.p_kind = pk_move and p2*.p_opCode = p1*.p_opCode and
	    (p1*.p_destEA & 0o70 = M_ADIR << 3 or
	     p1*.p_destEA & 0o70 = M_DDIR << 3) and
	    (p2*.p_destEA = M_SPECIAL << 3 | M_ABSLONG or
	     p2*.p_destEA = M_DISP << 3 | RFP) and
	    p2*.p_sourceEA = p1*.p_sourceEA and p2*.p_source = p1*.p_source and
	    veq(p2*.p_sourceKind, p1*.p_sourceKind,
		&p2*.p_sourceValue, &p1*.p_sourceValue)
	then
	    /* MOVE.s x,VAR; MOVE.s x,Rx => MOVE.s x,Rx; MOVE.s Rx,VAR */
	    if PEEP_DEBUG then
		printString("moveDone: "
		    "MOVE.s x,VAR; MOVE.s x,Ry => MOVE.s x,Rx; MOVE.s Rx,VAR\n"
		);
	    fi;
	    p1*.p_sourceEA := p1*.p_destEA;
	    p1*.p_source := pv_none;
	    copyDestFromDest(p1, p2);
	    p2*.p_destEA := p1*.p_sourceEA;
	    p2*.p_dest := pv_none;
	    setCCDest(p1);
/*
	    checkOffsetUse(p1*.p_destEA, &p1*.p_destValue);
*/
	elif p2*.p_kind = pk_move and p2*.p_opCode = p1*.p_opCode and
	    (p1*.p_destEA & 0o70 = M_ADIR << 3 or
	     p1*.p_destEA & 0o70 = M_DDIR << 3) and
	    (p1*.p_sourceEA = M_SPECIAL << 3 | M_ABSLONG or
	     p1*.p_sourceEA = M_DISP << 3 | RFP) and
	    p2*.p_destEA = p1*.p_sourceEA and p2*.p_dest = p1*.p_source and
	    veq(p2*.p_destKind, p1*.p_sourceKind,
		&p2*.p_destValue, &p1*.p_sourceValue)
	then
	    /* MOVE.s x,VAR; MOVE.s VAR,Rt => MOVE.s x,Rt; MOVE.s Rt,VAR */
	    if PEEP_DEBUG then
		printString("moveDone: "
		    "MOVE.s x,VAR; MOVE.s VAR,Rt => MOVE.s x,Rt; MOVE.s Rt,VAR"
		    "\n");
	    fi;
	    p2*.p_destEA := p1*.p_destEA;
	    p2*.p_dest := pv_none;
	    copyDestFromSource(p1, p1);
	    p1*.p_sourceEA := p2*.p_destEA;
	    p1*.p_source := pv_none;
	    if p2*.p_destEA = p2*.p_sourceEA then
		/* this can come about from some CC testing stuff */
		if PEEP_DEBUG then
		    printString("moveDone: subOpt \#1\n");
		fi;
		OptCount := OptCount + 1;
		p2* := p1*;
		unDoTo(PeepTotal - 1);
	    fi;
/*
	    checkOffsetUse(p1*.p_destEA, &p1*.p_destValue);
*/
	elif p2*.p_kind = pk_imm and p2*.p_reg <= DRTop and
	    p1*.p_sourceEA = M_DDIR << 3 | p2*.p_reg and p2*.p_reg ~= 0
	then
	    /* MOVEQ #x,Dt; MOVE.s Dt,y => MOVEQ #x,D0; MOVE.s D0,y */
	    /* don't count this as a peephole optimization */
	    if PEEP_DEBUG then
		printString("moveDone: "
		   "MOVEQ \#x,Dt; MOVE.s Dt,y => MOVEQ \#x,D0; MOVE.s D0,y\n");
	    fi;
	    OptKludgeFlag1 := true;
	    DRegQueue[p2*.p_reg].r_desc.v_kind := VVOID;
	    CCIsReg := false;
	    CCKind := VVOID;
	    p2*.p_reg := 0;
	    p1*.p_sourceEA := M_DDIR << 3 | 0;
	elif p2*.p_opCode = OP_LEA and p1*.p_sourceEA & 0o7 <= ARTop and
	    p1*.p_sourceEA = M_ADIR << 3 | p2*.p_reg and p2*.p_reg ~= 0
	then
	    ARegQueue[p2*.p_reg].r_desc.v_kind := VVOID;
	    if p1*.p_destEA & 0o70 = M_ADIR << 3 then
		/* LEA x,Ay; MOVE.L Ay,Az => LEA x,Az */
		if PEEP_DEBUG then
		    printString("moveDone: "
				"LEA x,Ay; MOVE.L Ay,Az => LEA x,Az\n");
		fi;
		OptCount := OptCount + 1;
		p2*.p_reg := p1*.p_destEA & 0o7;
		unDoTo(PeepTotal - 1);
		stillAMove := false;
	    else
		/* LEA x,Ay; MOV.L Ay,z => LEA x,A0; MOV.L A0,z */
		if PEEP_DEBUG then
		    printString("moveDone: "
			"LEA x,Ay; MOVE.L Ay,z => LEA x,A0; MOVE.L A0,z\n");
		fi;
		p2*.p_reg := 0;
		p1*.p_sourceEA := M_ADIR << 3 | 0;
		OptKludgeFlag1 := true;
	    fi;
	    CCIsReg := false;
	    CCKind := VVOID;
	elif p2*.p_kind = pk_register and p2*.p_opCode = OP_LEA and
	    p2*.p_reg <= ARTop and
	    (p1*.p_sourceEA = M_INDIR << 3 | p2*.p_reg or
	     p1*.p_destEA = M_INDIR << 3 | p2*.p_reg)
	then
	    /* LEA <ea1>,At; MOVE.s (At),<ea2> => MOVE.s <ea1>,<ea2>
	       LEA <ea1>,At; MOVE.s <ea2>,(At) => MOVE.s <ea2>,<ea1> */
	    if PEEP_DEBUG then
		printString("opMove: "
		    "LEA <ea1>,At; MOVE.s (At),<ea2> => MOVE.s <ea1>,<ea2>\n"
		    "        "
		    "LEA <ea1>,At; MOVE.s <ea2>,(At) => MOVE.s <ea2>,<ea1>\n");
	    fi;
	    OptCount := OptCount + 1;
	    ARegQueue[p2*.p_reg].r_desc.v_kind := VVOID;
	    p2*.p_kind := pk_move;
	    p2*.p_opCode := p1*.p_opCode;
	    if p1*.p_sourceEA = M_INDIR << 3 | p2*.p_reg then
		copyDestFromDest(p2, p1);
	    else
		copyDestFromSource(p2, p2);
		copySourceFromSource(p2, p1);
	    fi;
	    unDoTo(PeepTotal - 1);
	    if p1*.p_destEA >> 3 = M_DDIR then
		CCIsReg := true;
		CCReg := p1*.p_destEA & 0o7;
	    else
		setCCDest(p1);
	    fi;
	else
	    /* we treat this as a while loop just in case we can turn both
	       addressing modes of a MOVE into predecrement */
	    doneOne := true;
	    doneAny := false;
	    stillAMove := false;
	    while doneOne and PeepNext >= 2 and p1*.p_kind = pk_move and
		p2*.p_kind = pk_quick and
		p2*.p_sourceEA & 0o70 = M_ADIR << 3 and
		p2*.p_opCode = OP_SUBQ and p2*.p_data =
		    case p1*.p_opCode
		    incase OP_MOVEB:
			1
		    incase OP_MOVEW:
			2
		    incase OP_MOVEL:
			4
		    esac
	    do
		reg := p2*.p_sourceEA & 0o7;
		if autoFix(false, reg, &p1*.p_sourceEA) or
		    autoFix(false, reg, &p1*.p_destEA)
		then
		    /* SUBQ.l #s,Ax; ref<(Ax)> => ref<-(Ax)> */
		    if PEEP_DEBUG then
			printString("moveDone: "
			    "SUBQ.L \#s,Ax; ref<(Ax)> => ref<-(Ax)>\n");
		    fi;
		    OptCount := OptCount + 1;
		    p2* := p1*;
		    unDoTo(PeepTotal - 1);
		    CCIsReg := false;
		    CCKind := VVOID;
		    doneAny := true;
		else
		    doneOne := false;
		fi;
	    od;
	    if doneAny and p1*.p_kind = pk_move then
		stillAMove := true;
	    fi;
	fi;
    od;
corp;

/*
 * opSingle - instruction with a single operand.
 */

proc opSingle(uint opCode; byte size, ea)void:
    register *Peep_t p;
    VALUETYPE offSave;
    OffKind_t pvSave;
    VALUEKIND kindSave;
    register uint reg;

    if not Ignore then
	reg := ea & 0o7;
	p := &Peep[0];
	/* this test comes first with the kludge test to make the absolute
	   value operator work as desired. */
	if OptKludgeFlag2 and CCIsReg and CCReg = reg and
	    ea & 0o70 = M_DDIR << 3
	then
	    /* TST not needed */
	    if PEEP_DEBUG then
		printString("opSingle: "
			    "TST not needed\n");
	    fi;
	    OptCount := OptCount + 1;
	elif opCode = OP_TST and ea & 0o70 = M_DDIR << 3 and
	    reg <= DRTop and PeepNext ~= 0 and
	    p*.p_kind = pk_move and
		(p*.p_destEA = M_DDIR << 3 | reg or
		 p*.p_sourceEA = M_DDIR << 3 | reg) and
	    if p*.p_opCode = OP_MOVEB then
		S_BYTE
	    elif p*.p_opCode = OP_MOVEW then
		S_WORD
	    else
		S_LONG
	    fi = size
	then
	    if p*.p_destEA = M_DDIR << 3 | reg then
		/* MOV.s x,Dt; TST.s Dt => TST.s x */
		if PEEP_DEBUG then
		    printString("opSingle: "
				"MOVE.s x,Dt; TST.s Dt => TST.s x\n");
		fi;
		OptCount := OptCount + 1;
		DRegQueue[reg].r_desc.v_kind := VVOID;
		if p*.p_opCode = OP_MOVEL and size = S_WORD then
		    p*.p_sourceValue.v_ulong := p*.p_sourceValue.v_ulong + 2;
		elif p*.p_opCode = OP_MOVEL and size = S_BYTE then
		    p*.p_sourceValue.v_ulong := p*.p_sourceValue.v_ulong + 3;
		elif p*.p_opCode = OP_MOVEW and size = S_BYTE then
		    p*.p_sourceValue.v_ulong := p*.p_sourceValue.v_ulong + 1;
		fi;
		p*.p_kind := pk_single;
		p*.p_opCode := OP_TST;
		p*.p_size := size;
		copyDestFromSource(p, p);
		p*.p_source := pv_none;
	    else
		/* TST not needed */
		if PEEP_DEBUG then
		    printString("opSingle: TST not needed\n");
		fi;
		OptCount := OptCount + 1;
	    fi;
	elif opCode = OP_TST and ea & 0o70 = M_DDIR << 3 and
	    CCIsReg and CCReg = reg
	then
	    /* TST not needed */
	    if PEEP_DEBUG then
		printString("opSingle: TST not needed\n");
	    fi;
	    OptCount := OptCount + 1;
	else
	    pvSave := pv_none;
	    if opCode = OP_CMPI and ea & 0o70 = M_DDIR << 3 and
		reg <= DRTop and p*.p_kind = pk_move and PeepNext ~= 0 and
		p*.p_sourceEA ~= M_INC << 3 | RSP and
		p*.p_destEA = M_DDIR << 3 | reg and
		if p*.p_opCode = OP_MOVEB then
		    S_BYTE
		elif p*.p_opCode = OP_MOVEW then
		    S_WORD
		else
		    S_LONG
		fi = size
	    then
		/* MOVE.s x,Dt; CMPI.s #y,Dt => CMPI.s #y,x */
		/* see note in 'opModed' for disallowing the pop one */
		if PEEP_DEBUG then
		    printString("opSingle: "
			       "MOVE.s x,Dt; CMPI.s \#y,Dt => CMPI.s \#y,x\n");
		fi;
		OptCount := OptCount + 1;
		DRegQueue[reg].r_desc.v_kind := VVOID;
		ea := p*.p_sourceEA;
		pvSave := p*.p_source;
		kindSave := p*.p_sourceKind;
		offSave := p*.p_sourceValue;
		/* KLUDGE! KLUDGE! - see definition of VALUETYPE */
		if p*.p_opCode = OP_MOVEL and size = S_WORD then
		    offSave.v_ulong := offSave.v_ulong + 2;
		elif p*.p_opCode = OP_MOVEL and size = S_BYTE then
		    offSave.v_ulong := offSave.v_ulong + 3;
		elif p*.p_opCode = OP_MOVEW and size = S_BYTE then
		    offSave.v_ulong := offSave.v_ulong + 1;
		fi;
		unDoTo(PeepTotal - 1);
	    fi;
	    p := peepAdd();
	    if pvSave ~= pv_none then
		p*.p_dest := pvSave;
		p*.p_destKind := kindSave;
		p*.p_destValue := offSave;
	    fi;
	    p*.p_kind := pk_single;
	    p*.p_opCode := opCode;
	    p*.p_size := size;
	    p*.p_destEA := ea;
	    if ea & 0o70 = M_ADIR << 3 then
		if opCode ~= OP_CMPI then
		    ARegQueue[ea & 0o7].r_desc.v_kind := VVOID;
		fi;
		CCIsReg := false;
		CCKind := VVOID;
	    elif ea & 0o70 = M_DDIR << 3 then
		if opCode ~= OP_CMPI and opCode ~= OP_TST then
		    DRegQueue[ea & 0o7].r_desc.v_kind := VVOID;
		fi;
		CCIsReg := true;
		CCReg := ea & 0o7;
	    elif opCode ~= OP_TST then
		CCIsReg := false;
		CCKind := VVOID;
	    fi;
	fi;
    fi;
corp;

/*
 * opRegister - instruction which works on a register.
 */

proc opRegister(uint opCode; ushort reg; byte ea)void:
    register *Peep_t p;
    bool doneOpt;

    if not Ignore then
	doneOpt := false;
	if PeepNext ~= 0 then
	    p := &Peep[0];
	    if opCode = OP_LEA and ea = M_INDIR << 3 | 0 and
		p*.p_opCode = OP_MOVEL and p*.p_destEA = M_ADIR << 3 | 0
	    then
		/* MOVE.L x,A0; LEA (A0),Ay => MOVE.L x,Ay */
		if PEEP_DEBUG then
		    printString("opRegister: "
				"MOVE.L x,A0; LEA (A0),Ay => MOVE.L x,Ay\n");
		fi;
		OptCount := OptCount + 1;
		p*.p_destEA := M_ADIR << 3 | reg;
		ARegQueue[reg].r_desc.v_kind := VVOID;
		doneOpt := true;
	    fi;
	fi;
	if not doneOpt then
	    p := peepAdd();
	    if opCode = OP_LEA and ea & 0o70 = M_INDIR << 3 then
		/* replace LEA (Ax),Ay with MOVE.L Ax,Ay */
		if PEEP_DEBUG then
		    printString("opRegister: "
				"LEA (Ax),Ay => MOVE.L Ax,Ay\n");
		fi;
		p*.p_kind := pk_move;
		p*.p_opCode := OP_MOVEL;
		p*.p_sourceEA := M_ADIR << 3 | ea & 0o7;
		p*.p_destEA := M_ADIR << 3 | reg;
		ARegQueue[reg].r_desc.v_kind := VVOID;
		moveDone();
	    else
		p*.p_kind := pk_register;
		p*.p_opCode := opCode;
		p*.p_reg := reg;
		p*.p_sourceEA := ea;
		if opCode = OP_LEA then
		    ARegQueue[reg].r_desc.v_kind := VVOID;
		else
		    DRegQueue[reg].r_desc.v_kind := VVOID;
		    CCIsReg := true;
		    CCReg := reg;
		fi;
	    fi;
	fi;
    fi;
corp;

/*
 * opSpecial - special case instruction.
 */

proc opSpecial(uint opCode)void:
    register *Peep_t p;
    ushort reg;

    if not Ignore then
	if opCode & 0xf020 = 0xe020 and PeepNext ~= 0 then
	    reg := (opCode & 0o7000) >> 9;
	    p := &Peep[0];
	    if p*.p_kind = pk_move and p*.p_destEA = M_DDIR << 3 | reg and
		reg <= DRTop and p*.p_sourceEA & 0o70 = M_DDIR << 3
	    then
		/* shift x by Dy: if the previous instruction was
		   a move of another reg into Dy, just use it directly */
		if PEEP_DEBUG then
		    printString("opSpecial: use shift amnt reg directly\n");
		fi;
		OptCount := OptCount + 1;
		DRegQueue[reg].r_desc.v_kind := VVOID;
		opCode := opCode & 0o170777 |
		    make(p*.p_sourceEA & 0o7, uint) << 9;
		unDoTo(PeepTotal - 1);
	    fi;
	fi;
	p := peepAdd();
	p*.p_kind := pk_special;
	p*.p_opCode := opCode;
	/* value forgetting is done specifically for each use */
	CCIsReg := false;
	CCKind := VVOID;
    fi;
corp;

/*
 * opMove - a MOVE instruction.
 */

proc opMove(uint opCode; byte source, dest)void:
    register uint reg;
    register byte mode;
    register *Peep_t p, p2;
    long val;
    bool doneNone;

    if not Ignore then
	mode := source & 0o70;
	reg := source & 0o7;
	doneNone := true;
	if PeepNext ~= 0 then
	    if PEEP_DEBUG then
		printString("opMove, PeepNext ~= 0\n");
	    fi;
	    doneNone := false;
	    p := &Peep[0];
	    p2 := &Peep[1];
	    if p*.p_kind = pk_move and p*.p_opCode = opCode and
		p*.p_destEA = source and
		(mode = M_DDIR << 3 or mode = M_ADIR << 3) and
		reg <= if mode = M_DDIR << 3 then DRTop else ARTop fi
	    then
		/* MOVs x,Ry; MOVs Ry,z => MOVs x,z  so long as Ry
		   is a temporary register */
		if PEEP_DEBUG then
		    printString("opMove: "
				"MOVE.s x,Ry; MOVE.s Ry,z => MOVE.s x,z\n");
		fi;
		OptCount := OptCount + 1;
		if mode = M_DDIR << 3 then
		    DRegQueue[reg].r_desc.v_kind := VVOID;
		else
		    ARegQueue[reg].r_desc.v_kind := VVOID;
		fi;
		p*.p_destEA := dest;
		/* note: the destination words haven't been given to us yet -
		   they will be stuck on the previous instruction */
		if dest = M_DDIR << 3 | 0 and p*.p_sourceEA = dest and
		    (mode ~= M_ADIR << 3 or
			PeepNext > 1 and p2*.p_opCode = opCode and
			p2*.p_sourceEA = M_DDIR << 3 | 0)
		then
		    /* special case which comes as a result of our CC
		       stuff and two other optimizations!! */
		    if PEEP_DEBUG then
			printString("opMove: omit MOVE.s D0,D0\n");
		    fi;
		    OptCount := OptCount + 1;
		    unDoTo(PeepTotal - 1);
		elif p*.p_sourceEA = M_ADIR << 3 | 0 and
		    dest & 0o70 = M_ADIR << 3 and PeepNext > 1 and
		    p2*.p_opCode = OP_LEA and p2*.p_reg = 0
		then
		    /* LEA x,A0; MOVE.L A0,Ay => LEA x,Ay */
		    if PEEP_DEBUG then
			printString("opMove: "
				    "LEA x,A0; MOVE.L A0,Ay => LEA x,Ay\n");
		    fi;
		    OptCount := OptCount + 1;
		    p2*.p_reg := dest & 0o7;
		    unDoTo(PeepTotal - 1);
		fi;
	    elif mode = M_ADIR << 3 and dest = M_DEC << 3 | RSP and
		p*.p_kind = pk_register and p*.p_opCode = OP_LEA and
		p*.p_reg = reg and reg <= ARTop
	    then
		/* LEA x,Ay; MOVE.L Ay,-(A7) => PEA x */
		if PEEP_DEBUG then
		    printString("opMove: "
				"LEA x,Ay; MOVE.L Ay,-(A7) => PEA x\n");
		fi;
		OptCount := OptCount + 1;
		p*.p_kind := pk_EA;
		p*.p_opCode := OP_PEA;
		if p*.p_sourceEA = M_INDIR << 3 | 0 and
		    PeepNext >= 2 and p2*.p_kind = pk_register and
		    p2*.p_opCode = OP_LEA and p2*.p_reg = 0
		then
		    /* LEA x,A0; PEA (A0) => PEA x (happens for op consts) */
		    if PEEP_DEBUG then
			printString("opMove: "
				    "LEA x,A0; PEA (A0) => PEA x\n");
		    fi;
		    OptCount := OptCount + 1;
		    p2*.p_kind := pk_EA;
		    p2*.p_opCode := OP_PEA;
		    unDoTo(PeepTotal - 1);
		fi;
	    elif mode = M_ADIR << 3 and dest = M_DEC << 3 | RSP and
		p*.p_kind = pk_moded and p*.p_opCode = OP_SUB and
		p*.p_mode = S_LADDR and p*.p_reg = reg and
		p*.p_sourceEA = M_ADIR << 3 | reg and reg <= ARTop
	    then
		/* SUBA.L At,At; MOVE.L At,-(SP) => CLR.L -(SP) */
		if PEEP_DEBUG then
		    printString("opMove: "
			    "SUBA.L At,At; MOVE.L At,-(SP) => CLR.L -(SP)\n");
		fi;
		OptCount := OptCount + 1;
		p*.p_kind := pk_single;
		p*.p_opCode := OP_CLR;
		p*.p_size := S_LONG;
		p*.p_dest := pv_none;
		p*.p_destEA := M_DEC << 3 | RSP;
		ARegQueue[reg].r_desc.v_kind := VVOID;
	    elif mode = M_ADIR << 3 and dest & 0o70 = M_ADIR << 3 and
		p*.p_kind = pk_register and p*.p_opCode = OP_LEA and
		p*.p_reg = reg and reg <= ARTop
	    then
		/* LEA x,Ay; MOVEL Ay,Az => LEA x,Az */
		if PEEP_DEBUG then
		    printString("opMove: "
				"LEA x,Ay; MOVE.L Ay,Az => LEA x,Az\n");
		fi;
		OptCount := OptCount + 1;
		p*.p_reg := dest & 0o7;
		if p*.p_sourceEA = M_DISP << 3 | p*.p_reg and
		    p*.p_sourceValue.v_ulong <= 8
		then
		    /* LEA d(Ax),Ax => ADDQ #d,Ax
		       We do this so that we can check for autoinc mode.
		       This patch is needed after adding the MOVEA/ADDQ
		       conversion in 'checkAutoInc', since that prevents
		       the normal conversion to ADDQ here in 'moveDone'. */
		    if PEEP_DEBUG then
			printString("moveDone: LEA d(Ax),Ax => ADDQ \#d,Ax\n");
		    fi;
		    p*.p_kind := pk_quick;
		    p*.p_source := pv_none;
		    p*.p_opCode := OP_ADDQ;
		    p*.p_size := S_LONG;
		    p*.p_data := make(p*.p_sourceValue.v_ulong, byte) & 0x7;
		    p*.p_sourceEA := M_ADIR << 3 | p*.p_reg;
		    checkAutoInc(p, p2);
		fi;
	    elif mode = M_DDIR << 3 and dest & 0o70 = M_DDIR << 3 and
		p*.p_kind = pk_imm and p*.p_reg = reg and reg <= DRTop
	    then
		/* MOVEQ x,Dy; MOVs Dy,Dz => MOVEQ x,Dz  so long as Dy is
		   a temporary register */
		if PEEP_DEBUG then
		    printString("opMove: "
			       "MOVEQ \#x,Dy; MOVE.s Dy,Dz => MOVEQ \#x,Dz\n");
		fi;
		OptCount := OptCount + 1;
		p*.p_reg := dest & 0o7;
		DRegQueue[reg].r_desc.v_kind := VVOID;
	    elif mode = M_DDIR << 3 and reg <= DRTop and
		p*.p_kind = pk_single and p*.p_opCode = OP_CLR and
		p*.p_destEA = M_DDIR << 3 | reg
	    then
		/* CLR.s Dx; MOVs Dx,Dy => CLR.s Dy  so long as Dx is
		   a temporary register */
		if PEEP_DEBUG then
		    printString("opMove: "
				"CLR.s Dx; MOVE.s Dx,y => CLR.s Dy\n");
		fi;
		OptCount := OptCount + 1;
		p*.p_destEA := dest;
		p*.p_dest := pv_none;
		DRegQueue[reg].r_desc.v_kind := VVOID;
		CCIsReg := false;
		CCKind := VVOID;
		/* any upcoming address words will be stuck on the CLR */
	    elif dest = M_DEC << 3 | RSP and source = M_ADIR << 3 | 6 and
		p*.p_kind = pk_move and p*.p_sourceEA = M_INC << 3 | RSP and
		p*.p_destEA = M_ADIR << 3 | 6
	    then
		/* MOVE.L (SP)+,A6; MOVE.L A6,-(SP) => nothing */
		if PEEP_DEBUG then
		    printString("opMove: "
				"MOVE.L (SP)+,A6; MOVE.L A6,-(SP) =>\n");
		fi;
		OptCount := OptCount + 2;
		unDoTo(PeepTotal - 1);
		CCIsReg := false;
		CCKind := VVOID;
	    elif mode = M_ADIR << 3 and dest & 0o70 = M_ADIR << 3 and
		reg <= ARTop and
		(p*.p_kind = pk_quick and
		    p*.p_sourceEA = M_ADIR << 3 | reg or
		 p*.p_kind = pk_moded and
		    (p*.p_opCode = OP_ADD or p*.p_opCode = OP_SUB) and
		    p*.p_mode = S_SADDR and p*.p_reg = reg and
			p*.p_sourceEA = M_SPECIAL << 3 | M_IMM) and
		PeepNext ~= 1 and
		p2*.p_kind = pk_move and p2*.p_destEA = source and
		p2*.p_sourceEA & 0o70 = M_ADIR << 3 and
		p2*.p_sourceEA & 0o7 ~= dest & 0o7
	    then
		/* MOVE.L Am,An; {ADDQ, SUBQ, ADD.w, SUB.w} #y,An;
		   MOVE.L An,Af => LEA #y(Am),Af */
		/* NOTE: the last check above makes sure that we do NOT do
		   the fix here when Am = Af. This is so that it will get
		   done in 'moveDone', which will also go further and try
		   to use the auto-increment addressing mode. Even if it
		   doesn't, just the ADDQ is shorter than an LEA. */
		if PEEP_DEBUG then
		    printString("opMove: "
			   "MOVE.L Am,An; {ADDQ, SUBQ, ADD.w, SUB.w} \#y,An;\n"
			    "        MOVE.L An,Af => LEA \#y(Am),Af\n");
		fi;
		OptCount := OptCount + 2;
		reg := p2*.p_sourceEA & 0o7;
		val :=
		    if p*.p_kind = pk_quick then
			if p*.p_data = 0 then
			    p*.p_data := 8;
			fi;
			if p*.p_opCode = OP_SUBQ then
			    - make(p*.p_data, ulong)
			else
			    make(p*.p_data, ulong)
			fi
		    else
			if p*.p_opCode = OP_SUB then
			    - p*.p_sourceValue.v_long
			else
			    p*.p_sourceValue.v_long
			fi
		    fi;
		unDoTo(PeepTotal - 1);
		p*.p_kind := pk_register;
		p*.p_opCode := OP_LEA;
		p*.p_reg := dest & 0o7;
		p*.p_sourceEA := M_DISP << 3 | reg;
		p*.p_sourceValue.v_long := val;
		p*.p_source := pv_word;
		ARegQueue[p*.p_reg].r_desc.v_kind := VVOID;
		CCIsReg := false;
		CCKind := VVOID;
	    else
		doneNone := true;
	    fi;
	fi;
	if doneNone then
	    p := peepAdd();
	    p*.p_kind := pk_move;
	    p*.p_opCode := opCode;
	    p*.p_sourceEA := source;
	    p*.p_destEA := dest;
	    if mode <= M_DEC << 3 and dest & 0o70 <= M_DEC << 3 then
		/* i.e. there will be no source or dest word or long */
		moveDone();
	    fi;
	fi;
    fi;
corp;

/*
 * opQuick - a QUICK instruction (small constant internal) (ADDQ, SUBQ).
 */

proc opQuick(uint opCode; byte data, size, ea)void:
    register *Peep_t p;

    if not Ignore then
	p := peepAdd();
	p*.p_kind := pk_quick;
	p*.p_opCode := opCode;
	p*.p_data := data;
	p*.p_size := size;
	p*.p_sourceEA := ea;
	if ea & 0o70 = M_ADIR << 3 then
	    ARegQueue[ea & 0o7].r_desc.v_kind := VVOID;
	elif ea & 0o70 = M_DDIR << 3 then
	    DRegQueue[ea & 0o7].r_desc.v_kind := VVOID;
	    CCIsReg := true;
	    CCReg := ea & 0o7;
	fi;
	if opCode = OP_ADDQ and PeepNext >= 2 and ea & 0o70 = M_ADIR << 3 then
	    checkAutoInc(&Peep[0], &Peep[1]);
	fi;
    fi;
corp;

/*
 * opModed - an instruction with one of those op-modes.
 */

proc opModed(uint opCode; register ushort reg; byte mode, ea)void:
    register *Peep_t p;
    VALUETYPE offSave;
    OffKind_t pvSave;
    VALUEKIND kindSave;
    register uint regT;
    bool replaced;

    if not Ignore then
	pvSave := pv_none;
	replaced := false;
	if PeepNext ~= 0 then
	    p := &Peep[0];
	    regT := ea & 0o7;
	    if p*.p_kind = pk_move and ea & 0o70 = M_DDIR << 3 and
		p*.p_destEA & 0o7 <= DRTop and
		p*.p_sourceEA ~= M_INC << 3 | RSP and
		((mode = S_SADDR and p*.p_opCode = OP_MOVEW or
		  mode = S_LADDR and p*.p_opCode = OP_MOVEL or
		  mode & 0b100 = OM_REG and
		    mode & 0b011 =
			if p*.p_opCode = OP_MOVEB then
			    S_BYTE
			elif p*.p_opCode = OP_MOVEW then
			    S_WORD
			else
			    S_LONG
			fi
		 ) and p*.p_destEA = ea or
		 mode & 0b100 = OM_EA and
		    mode & 0b011 =
			if p*.p_opCode = OP_MOVEB then
			    S_BYTE
			elif p*.p_opCode = OP_MOVEW then
			    S_WORD
			else
			    S_LONG
			fi and
		    p*.p_sourceEA & 0o70 = M_DDIR << 3 and
		    p*.p_destEA = M_DDIR << 3 | reg
		)
	    then
		/* MOVE.s x,Dt; op.s Dt,Dy => op.s x,Dy
		   MOVE.s Dx,Dt; op.s Dt,Dy => op.s Dx,Dy (catches EOR) */
		/* NOTE: do NOT do this if the move is a pop from the stack.
		   This is normally restoring a saved register. If the
		   register is a for-loop parameter, we need it again in
		   that register! */
		if PEEP_DEBUG then
		    printString("opModed: "
				"MOVE.s x,Dt; op.s Dt,Dy => op.s x,Dy\n"
			"         MOVE.s Dx,Dt; op.s Dt,Dy => op.s Dx,Dy\n");
		fi;
		OptCount := OptCount + 1;
		if mode & 0b100 = OM_EA and mode ~= S_LADDR then
		    DRegQueue[reg].r_desc.v_kind := VVOID;
		    reg := p*.p_sourceEA & 0o7;
		else
		    DRegQueue[regT].r_desc.v_kind := VVOID;
		    ea := p*.p_sourceEA;
		    pvSave := p*.p_source;
		    kindSave := p*.p_sourceKind;
		    offSave := p*.p_sourceValue;
		fi;
		unDoTo(PeepTotal - 1);
	    elif opCode = OP_ADD and mode & 0o3 = S_SADDR and
		(ea >> 3 = M_DDIR or ea = M_SPECIAL << 3 | M_IMM) and
		p*.p_kind = pk_move and p*.p_opCode = OP_MOVEL and
		p*.p_destEA = M_ADIR << 3 | reg and
		p*.p_sourceEA >> 3 = M_ADIR
	    then
		OptCount := OptCount + 1;
		replaced := true;
		p*.p_kind := pk_register;
		p*.p_opCode := OP_LEA;
		p*.p_reg := reg;
		if ea >> 3 = M_DDIR then
		    /* MOVEA Ax,At; ADDA.s Dy,At => LEA 0(Ax,Dy.s),At */
		    if PEEP_DEBUG then
			printString("opModed: "
			   "MOVEA Ax,At; ADDA.s Dy,At => LEA 0(Ax,Dy.s),At\n");
		    fi;
		    p*.p_sourceEA := M_INDEX << 3 | p*.p_sourceEA & 0o7;
		    p*.p_source := pv_word;
		    p*.p_sourceValue.v_ulong := make(ea & 0o7, uint) << 12 |
			if mode = S_LADDR then 1 << 11 else 0 fi;
		else
		    /* MOVEA Ax,At; ADDA.s #N,At => LEA N(Ax),At */
		    if PEEP_DEBUG then
			printString("opModed: "
			    "MOVEA Ax,At; ADDA.s #N,At => LEA N(Ax),At\n");
		    fi;
		    p*.p_sourceEA := M_DISP << 3 | p*.p_sourceEA & 0o7;
		    /* other values are already correct */
		fi;
		ARegQueue[reg].r_desc.v_kind := VVOID;
	    fi;
	fi;
	if not replaced then
	    p := peepAdd();
	    if pvSave ~= pv_none then
		p*.p_source := pvSave;
		p*.p_sourceKind := kindSave;
		p*.p_sourceValue := offSave;
	    fi;
	    p*.p_kind := pk_moded;
	    p*.p_opCode := opCode;
	    p*.p_reg := reg;
	    p*.p_mode := mode;
	    p*.p_sourceEA := ea;
	    if mode = S_SADDR or mode = S_LADDR then
		ARegQueue[reg].r_desc.v_kind := VVOID;
	    elif mode & 0b100 = OM_REG then
		DRegQueue[reg].r_desc.v_kind := VVOID;
		CCIsReg := true;
		CCReg := reg;
	    else
		CCIsReg := false;
		CCKind := VVOID;
	    fi;
	fi;
    fi;
corp;

/*
 * opImm - an immediate mode instruction (MOVEQ).
 */

proc opImm(ushort reg; byte data)void:
    Peep_t temp;
    register *Peep_t p;

    if not Ignore then
	p := peepAdd();
	p*.p_kind := pk_imm;
	p*.p_reg := reg;
	p*.p_data := data;
	DRegQueue[reg].r_desc.v_kind := VVOID;
	if reg = 0 and PeepNext > 1 and Peep[1].p_kind = pk_move and
	    Peep[1].p_destEA & 0o70 = M_DDIR << 3 and
	    Peep[1].p_sourceEA ~= M_DDIR << 3 | 0
	then
	    if PEEP_DEBUG then
		printString("opImm: "
		   "MOVE.s x,Dy; MOVEQ \#z,D0 => MOVEQ \#z,D0; MOVE.s x,Dy\n");
	    fi;
	    temp := Peep[1];
	    Peep[1] := Peep[0];
	    Peep[0] := temp;
	    CCIsReg := false;
	    CCKind := VVOID;
	else
	    CCIsReg := true;
	    CCReg := reg;
	fi;
    fi;
corp;

/*
 * opEA - an instruction with just an effective address operand.
 */

proc opEA(uint opCode; byte ea)void:
    register *Peep_t p;

    if not Ignore then
	p := peepAdd();
	p*.p_kind := pk_EA;
	p*.p_opCode := opCode;
	p*.p_sourceEA := ea;
    fi;
corp;

/*
 * sourceWord - a tail word for a source operand.
 */

proc sourceWord(uint w)void:
    register *Peep_t p, p2;
    register uint reg;

    if not Ignore then
	p := &Peep[0];
	p2 := &Peep[1];
	p*.p_source := pv_word;
	p*.p_sourceValue.v_ulong := w;
	if p*.p_kind = pk_move and p*.p_destEA & 0o7 <= M_DEC << 3 then
	    /* i.e. there will be no destination word or long */
	    moveDone();
	elif p*.p_kind = pk_single and p*.p_opCode = OP_ANDI and
	    p*.p_destEA & 0o70 = M_DDIR << 3 and PeepNext >= 2 and w = 0xff
	then
	    reg := p*.p_destEA & 0o7;
	    if p2*.p_kind = pk_moded and p2*.p_opCode = OP_AND and
		p2*.p_reg = reg and p2*.p_sourceEA = M_SPECIAL << 3 | M_IMM and
		p2*.p_mode = OM_REG | S_BYTE
	    then
		/* AND.B #x,Dt; ANDI.W #ff,Dt => AND.W #x,Dt */
		if PEEP_DEBUG then
		    printString("sourceWord: "
			"AND.B \#x,Dt; ANDI.W \#ff,Dt => AND.W \#x,Dt\n");
		fi;
		OptCount := OptCount + 1;
		p2*.p_mode := OM_REG | S_WORD;
		unDoTo(PeepTotal - 1);
	    elif p2*.p_kind = pk_move and p2*.p_opCode = OP_MOVEB and
		p2*.p_destEA = M_DDIR << 3 | reg and
		(p2*.p_sourceEA & 0o70 ~= M_INDEX << 3 or
		    (p2*.p_sourceValue.v_ulong >> 12) & 0o7 ~= reg)
	    then
		/* MOVE.B x,Dy; ANDI.W #ff,Dy => CLR.W Dy; MOVE.B x,Dy */
		if PEEP_DEBUG then
		    printString("sourceWord: "
		     "MOVE.B x,Dy; ANDI.W \#ff,Dy => CLR.W Dy; MOVE.B x,Dy\n");
		fi;
		p* := p2*;
		p2*.p_kind := pk_single;
		p2*.p_opCode := OP_CLR;
		p2*.p_size := S_WORD;
		p2*.p_destEA := M_DDIR << 3 | reg;
		p2*.p_dest := pv_none;
		p2*.p_source := pv_none;
	    fi;
	fi;
    fi;
corp;

/*
 * sourceLong - a tail long word for a source operand.
 */

proc sourceLong(ulong l)void:
    register *Peep_t p, p2;
    register uint reg;

    if not Ignore then
	p := &Peep[0];
	p2 := &Peep[1];
	p*.p_source := pv_long;
	p*.p_sourceValue.v_ulong := l;
	if p*.p_kind = pk_move and p*.p_destEA & 0o7 <= M_DEC << 3 then
	    /* i.e. there will be no destination word or long */
	    moveDone();
	elif p*.p_kind = pk_single and p*.p_opCode = OP_ANDI and
	    p*.p_destEA & 0o70 = M_DDIR << 3 and PeepNext >= 2
	then
	    reg := p*.p_destEA & 0o7;
	    if p2*.p_kind = pk_moded and p2*.p_opCode = OP_AND and
		p2*.p_reg = reg and p2*.p_sourceEA = M_SPECIAL << 3 | M_IMM and
		(l = 0xff and p2*.p_mode = OM_REG | S_BYTE or
		 l = 0xffff and p2*.p_mode = OM_REG | S_WORD)
	    then
		/* AND.B #x,Dt; ANDI.L #ff,Dt => AND.L #x,Dt
		   AND.W #x,Dt; ANDI.L #ffff,Dt => AND.L #x,Dt */
		if PEEP_DEBUG then
		    printString("sourceLong: "
			"AND.B \#x,Dt; ANDI.L \#ff,Dt => AND.L \#x,Dt\n"
			"            "
			"AND.W \#x,Dt; ANDI.L \#ffff,Dt => AND.L \#x,Dt\n");
		fi;
		OptCount := OptCount + 1;
		p2*.p_mode := OM_REG | S_LONG;
		p2*.p_source := pv_long;
		unDoTo(PeepTotal - 1);
	    elif p2*.p_kind = pk_move and p2*.p_destEA = M_DDIR << 3 | reg and
		(p2*.p_opCode = OP_MOVEB and l = 0xff or
		 p2*.p_opCode = OP_MOVEW and l = 0xffff) and
		(p2*.p_sourceEA & 0o70 ~= M_INDEX << 3 or
		    (p2*.p_sourceValue.v_ulong >> 12) & 0o7 ~= reg)
	    then
		/* MOVE.B x,Dy; ANDI.L #ff,Dy => CLR.L Dy; MOVE.B x,Dy
		   MOVE.W x,Dy; ANDI.L #ffff,Dy => CLR.L Dy; MOVE.W x,Dy */
		if PEEP_DEBUG then
		    printString("sourceLong: "
		       "MOVE.B x,Dy; ANDI.L \#ff,Dy => CLR.L Dy; MOVE.B x,Dy\n"
			"            "
		       "MOVE.W x,Dy; ANDI.L \#ffff,Dy => CLR.L Dy; MOVE.W x,Dy"
			"\n");
		fi;
		p* := p2*;
		p2*.p_kind := pk_single;
		p2*.p_opCode := OP_CLR;
		p2*.p_size := S_LONG;
		p2*.p_destEA := M_DDIR << 3 | reg;
		p2*.p_dest := pv_none;
		p2*.p_source := pv_none;
	    fi;
	fi;
    fi;
corp;

/*
 * destWord - a tail word for a destination operand.
 */

proc destWord(uint w)void:

    if not Ignore then
	Peep[0].p_dest := pv_word;
	Peep[0].p_destValue.v_ulong := w;
	if Peep[0].p_kind = pk_move then
	    moveDone();
	fi;
    fi;
corp;

/*
 * destLong - a tail long word for a destination operand.
 */

proc destLong(ulong l)void:

    if not Ignore then
	Peep[0].p_dest := pv_long;
	Peep[0].p_destValue.v_ulong := l;
	if Peep[0].p_kind = pk_move then
	    moveDone();
	fi;
    fi;
corp;

/*
 * opReloc - set up to put an entry into the appropriate relocation table.
 */

proc opReloc(*DESCRIPTOR d; bool isSource)void:
    register *Peep_t this;

    if not Ignore then
	if d*.v_kind = VFLOAT then
	    d*.v_kind := VCONST;
	    d*.v_value.v_const := makeFloat(&d*.v_value.v_float[0]);
	fi;
	this := &Peep[0];
	if isSource then
	    this*.p_source := pv_value;
	    this*.p_sourceKind := d*.v_kind;
	    this*.p_sourceValue := d*.v_value;
	    if this*.p_kind = pk_move and this*.p_destEA & 0o7 <= M_DEC << 3
	    then
		/* i.e. there will be no destination word or long */
		moveDone();
	    elif this*.p_kind = pk_quick then
		CCIsReg := false;
		CCKind := d*.v_kind;
		CCValue := d*.v_value;
	    fi;
	else
	    if this*.p_kind = pk_single and this*.p_opCode = OP_TST and
		not CCIsReg and veq(d*.v_kind, CCKind, &d*.v_value, &CCValue)
	    then
		/* the TST is not necessary */
		if PEEP_DEBUG then
		    printString("opReloc: TST omitted\n");
		fi;
		OptCount := OptCount + 1;
		unDoTo(PeepTotal - 1);
	    elif this*.p_kind = pk_move and this*.p_opCode = OP_MOVEL and
		this*.p_destEA = M_DDIR << 3 | 0 and not CCIsReg and
		veq(d*.v_kind, CCKind, &d*.v_value, &CCValue)
	    then
		/* the MOVE of a pointer to D0 to test it is not needed */
		if PEEP_DEBUG then
		    printString("opReloc: MOVE ptr to D0 to test omitted\n");
		fi;
		OptCount := OptCount + 1;
		unDoTo(PeepTotal - 1);
	    else
		this*.p_dest := pv_value;
		this*.p_destKind := d*.v_kind;
		this*.p_destValue := d*.v_value;
		if this*.p_kind = pk_move then
		    moveDone();
		fi;
	    fi;
	fi;
    fi;
corp;

/*
 * ignoreCheck - we are ignoring something - if the previous instruction
 *	was a move into a temp reg from D0, then chuck it.
 */

proc ignoreCheck()void:
    register *Peep_t p;
    register uint reg;

    if PeepNext ~= 0 then
	p := &Peep[0];
	reg := p*.p_destEA & 0o7;
	if p*.p_kind = pk_move and p*.p_sourceEA = M_DDIR << 3 | 0 and
	    (p*.p_destEA & 0o70 = M_DDIR << 3 and reg <= DRTop or
	     p*.p_destEA & 0o70 = M_ADIR << 3 and reg <= ARTop)
	then
	    /* MOVE.s D0,Rt; ignore => nothing */
	    if PEEP_DEBUG then
		printString("ignoreCheck: MOVE.s D0,Rt =>\n");
	    fi;
	    OptCount := OptCount + 1;
	    unDoTo(PeepTotal - 1);
	fi;
    fi;
corp;
