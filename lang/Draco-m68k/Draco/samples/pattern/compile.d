#patternInternal.g

/*
 * nextItem - move up to the next item in the input pattern. Here, an item
 *	is either a single character or an escaped character.
 */

proc nextItem(register *PatternState_t ps)void:
    register *[2]char pattern;
    register ulong pos;

    pattern := ps*.ps_pattern;
    pos := ps*.ps_position;
    if ps*.ps_char = '\'' then
	if pos ~= ps*.ps_length then
	    ps*.ps_char := pattern*[pos];
	    pos := pos + 1;
	else
	    ps*.ps_char := ' ';
	    ps*.ps_end := true;
	fi;
    fi;
    if pos ~= ps*.ps_length then
	ps*.ps_char := pattern*[pos];
	pos := pos + 1;
    else
	ps*.ps_char := ' ';
	ps*.ps_end := true;
    fi;
    ps*.ps_position := pos;
corp;

/*
 * primary - recursive descent parser for expression primaries. Return the
 *	head of the exit chain within the compiled vector for this primary.
 */

proc primary(register *PatternState_t ps)ulong:
    extern expression(*PatternState_t ps; ulong chain)ulong;
    register *[2]ulong comp;
    register *ulong pComp;
    register ulong startPos, chain;
    register char operator;

    startPos := ps*.ps_position;
    if ps*.ps_end then
	ps*.ps_error := pse_missingPrimary;
    else
	operator := ps*.ps_char;
	nextItem(ps);
	if operator = ')' then
	    ps*.ps_error := pse_unexpectedRightParen;
	elif operator = '|' then
	    ps*.ps_error := pse_unexpectedOr;
	elif operator = '\#' then
	    chain := primary(ps);
	    /* point all of the exits from the primary to the '#', thus
	       forming the repetition loop */
	    comp := ps*.ps_compiled;
	    while chain ~= 0 do
		pComp := &comp*[chain];
		chain := pComp*;
		pComp* := startPos;
	    od;
	elif operator = '(' then
	    /* recurse down to get a nested subpattern */
	    startPos := expression(ps, startPos);
	    if ps*.ps_end then
		ps*.ps_error := pse_missingRightParen;
	    else
		if ps*.ps_char ~= ')' then
		    ps*.ps_error := pse_missingRightParen;
		fi;
		/* skip the ')' */
		nextItem(ps);
	    fi;
	fi;
    fi;
    startPos
corp;

/*
 * expression - recursive descent parser - parse an alternation.
 *	'chain' is the head of a chain in the compiled vector of the
 *	exits that already exist on the same level as this expression. The
 *	same chain, augmented by the alternatives here, is returned.
 */

proc expression(register *PatternState_t ps; ulong oldChain)ulong:
    register *[2]ulong comp;
    register *ulong pComp;
    register ulong newChain, exits, temp;
    register char operator;

    comp := ps*.ps_compiled;
    exits := 0;
    while
	newChain := primary(ps);
	if ps*.ps_end then
	    /* end of the pattern - join together the exits built from any
	       alternation at this level with those from the primary */
	    if exits = 0 then
		exits := newChain;
	    else
		temp := exits;
		while
		    pComp := &comp*[temp];
		    pComp* ~= 0
		do
		    temp := pComp*;
		od;
		pComp* := newChain;
	    fi;
	    false
	else
	    operator := ps*.ps_char;
	    if operator = '|' or operator = ')' then
		/* end of an alterative sub-pattern - join the exits from it
		   with those from any previous alteratives at this level */
		if exits = 0 then
		    exits := newChain;
		else
		    temp := exits;
		    while
			pComp := &comp*[temp];
			pComp* ~= 0
		    do
			temp := pComp*;
		    od;
		    pComp* := newChain;
		fi;
		if operator = '|' then
		    /* there should be another alterative - make the last
		       '|' or '(' point to this one */
		    comp*[oldChain] := ps*.ps_position;
		    oldChain := ps*.ps_position;
		    nextItem(ps);
		    true
		else
		    /* ')' - end of this subpattern */
		    false
		fi
	    else
		/* a non-special character - make all of the exits from the
		   primary point to this element as their successors */
		while newChain ~= 0 do
		    pComp := &comp*[newChain];
		    temp := pComp*;
		    pComp* := ps*.ps_position;
		    newChain := temp;
		od;
		true
	    fi
	fi
    do
    od;
    exits
corp;

/*
 * Compile - the top-level entry for pattern compilation.
 */

proc Compile(/* register *PatternState_t ps */)void:
    uint
	R_A0 = 0,
	R_FP = 6,
	OP_MOVEL = 0x2000,
	M_ADIR = 1,
	M_DISP = 5;
    *PatternState_t patternState;
    register *PatternState_t ps;
    register *[2]ulong comp;
    register *ulong cPtr;
    register ulong i, temp;

    /* This peculiar looking stuff is generating a move instruction to take
       the value from register A0, and put it into local variable
       'patternState'. This handles the special register linkage used for
       library entry points in AmigaDOS. See the Draco documentation for
       details on the 'code' construct. */

    code(
	OP_MOVEL | R_FP << 9 | M_DISP << 6 | M_ADIR << 3 | R_A0,
	patternState
    );
    ps := patternState;
    if ps*.ps_length = 0 then
	ps*.ps_error := pse_missingPrimary;
    else
	cPtr := &ps*.ps_compiled*[0];
	for i from ps*.ps_length downto 0 do
	    cPtr* := 0;
	    cPtr := cPtr + sizeof(ulong);
	od;
	ps*.ps_error := pse_ok;
	ps*.ps_end := false;
	ps*.ps_char := ps*.ps_pattern*[0];
	ps*.ps_position := 1;
	i := expression(ps, 0);
	if ps*.ps_char = ')' then
	    ps*.ps_error := pse_unexpectedRightParen;
	fi;
	/* Any pointers left coming out of the expression subpattern will
	   be for a successful match. Give them a compiled value of 0, which
	   indicates the final success. */
	comp := ps*.ps_compiled;
	while i ~= 0 do
	    cPtr := &comp*[i];
	    temp := cPtr*;
	    cPtr* := 0;
	    i := temp;
	od;
    fi;
corp;
