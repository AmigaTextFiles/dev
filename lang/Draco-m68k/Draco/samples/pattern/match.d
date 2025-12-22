#patternInternal.g

/*
 * addState - add the given state to the set of active states.
 */

proc addState(register *PatternState_t ps; register ulong state)void:
    register *ulong pState;
    register ulong i, count;

    if state = 0 then

	/* state 0 is the special end-of-pattern state. If we see it, then
	   we mark the match as being successful, and if we have run out
	   of subject string, all has gone well */

	ps*.ps_matched := true;
    else

	/* check for duplicates of this state in the set of active states */

	pState := &ps*.ps_activeStates*[0];
	count := ps*.ps_stateCount;
	i := 0;
	while i ~= count and pState* ~= state do
	    pState := pState + sizeof(ulong);
	    i := i + 1;
	od;
	if i = count then

	    /* this state not already in the set - add it */

	    pState := pState + sizeof(ulong);
	    pState* := state;
	    i := i + 1;
	    ps*.ps_stateCount := i;
	fi;
    fi;
corp;

/*
 * Match - match the compiled pattern against a subject string. Return 'true'
 *	if the subject matches the pattern.
 */

proc Match(/* register *PatternState_t ps;
	      register *char subject; ulong subjectLength */)bool:
    uint
	R_A0 = 0,
	R_A1 = 1,
	R_D0 = 0,
	R_FP = 6,
	OP_MOVEL = 0x2000,
	M_DDIR = 0,
	M_ADIR = 1,
	M_DISP = 5;
    register *PatternState_t ps;
    register *[2]ulong comp;
    register *char subject;
    *PatternState_t patternState;
    *char subjectPointer, subjectEnd;
    register ulong stateNum, state, compValue, temp;
    ulong subjectLength, stateCount;
    register char patternChar @ temp, subjectChar @ compValue;

    /* Inline code to access the parameters passed in registers. See the
       comment in 'compile.d'. */

    code(
	OP_MOVEL | R_FP << 9 | M_DISP << 6 | M_ADIR << 3 | R_A0,
	patternState,
	OP_MOVEL | R_FP << 9 | M_DISP << 6 | M_ADIR << 3 | R_A1,
	subjectPointer,
	OP_MOVEL | R_FP << 9 | M_DISP << 6 | M_DDIR << 3 | R_D0,
	subjectLength
    );
    ps := patternState;
    comp := ps*.ps_compiled;
    subject := subjectPointer;
    ps*.ps_stateCount := 0;	/* no active states yet */
    subjectEnd := subject + subjectLength * sizeof(char);
    ps*.ps_matched := false;

    /* for the first subject character, the only active state is that
       associated with the first pattern character */

    addState(ps, 1);

    /* if the pattern has top-level alternation, add the head of that
       alternation list to the set of active states */

    if comp*[0] ~= 0 then
	addState(ps, comp*[0]);
    fi;

    /* loop until we have matched the entire subject string, or we have no
       active states */

    while

	/* each time around, we must first add in all of those states that
	   are the successors to the set of states we have now. In the
	   following loop, note that the value of ps*.ps_stateCount can
	   change inside the loop, so a Draco 'for' will not work. */

	stateNum := 1;
	while stateNum <= ps*.ps_stateCount do
	    state := ps*.ps_activeStates*[stateNum];
	    compValue := comp*[state];
	    case ps*.ps_pattern*[state - 1]
	    incase '\#':

		/* since '#' allows 0 or more, both the '#'ed item and
		   the thing after it are OK now */

		addState(ps, state + 1);
		addState(ps, compValue);
	    incase '%':

		/* if a match-nothing is OK now, then so is whatever comes
		   after it in the pattern */

		addState(ps, compValue);
	    incase '(':
	    incase '|':

		/* part of an alternative chain - this alternative is OK */

		addState(ps, state + 1);
		if compValue ~= 0 then

		    /* this is chaining down a list of alternatives */

		    addState(ps, compValue);
		fi;
	    esac;
	    stateNum := stateNum + 1;
	od;

	subject < subjectEnd and ps*.ps_stateCount ~= 0
    do

	subjectChar := subject*;
	subject := subject + sizeof(char);
	if ps*.ps_ignoreCase and subjectChar >= 'a' and subjectChar <= 'z' then
	    subjectChar := subjectChar - 32;
	fi;

	/* go through the built-up set of active states, and see which ones
	   are successful, i.e. describe the current subject character. For
	   those that do, add the resulting state to the set of active states.
	   Note: we are re-using the active state vector when we do this. The
	   new set will be no larger than the old in this phase - it is in
	   the previous expansion phase, for the next time around, that it
	   might grow. */

	temp := ps*.ps_stateCount;
	ps*.ps_stateCount := 0;
	ps*.ps_matched := false;
	for stateNum from 1 upto temp do
	    state := ps*.ps_activeStates*[stateNum];
	    patternChar := ps*.ps_pattern*[state - 1];
	    case patternChar
	    incase '\#':
	    incase '|':
	    incase '%':
	    incase '(':
		/* just ignore these characters - their effect is handled
		   by the compiled vector */
		;
	    incase '?':
		/* match any character, so just unconditionally add the
		   successor state */
		addState(ps, comp*[state]);
	    incase '\'':
		/* quote - get the quoted character, then handle it just
		   like we do for normal characters */
		patternChar := ps*.ps_pattern*[state];
		if ps*.ps_ignoreCase and
		    patternChar >= 'a' and patternChar <= 'z'
		then
		    patternChar := patternChar - 32;
		fi;
		if subjectChar = patternChar then
		    addState(ps, comp*[state]);
		fi;
	    default:
		/* a normal character - if it is the same as the subject
		   character, then add the successor state, otherwise this
		   state is failing and we do nothing for it */
		if ps*.ps_ignoreCase and
		    patternChar >= 'a' and patternChar <= 'z'
		then
		    patternChar := patternChar - 32;
		fi;
		if subjectChar = patternChar then
		    addState(ps, comp*[state]);
		fi;
	    esac;
	od;
    od;

    if subject = subjectEnd then
	ps*.ps_matched
    else
	false
    fi
corp;
