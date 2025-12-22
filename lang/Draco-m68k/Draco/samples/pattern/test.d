#drinc:pattern.g
#drinc:util.g

proc main()void:
    [100] ulong comp, states;
    [100] char pattern, subject;
    register ulong i;
    PatternState_t ps;
    PatternCompileError_t err;

    if OpenPatternLibrary(0) ~= nil then
	ps.ps_pattern := &pattern[0];
	ps.ps_compiled := &comp[0];
	ps.ps_activeStates := &states[0];
	ps.ps_ignoreCase := true;
	while
	    write("Pattern: ");
	    readln(&pattern[0]) and pattern[0] ~= '\e'
	do
	    ps.ps_length := CharsLen(&pattern[0]);
	    Compile(&ps);
	    if ps.ps_error = pse_ok then
		for i from 0 upto ps.ps_length do
		    write(comp[i], ' ');
		od;
		writeln();
		while
		    write("Subject: ");
		    readln(&subject[0]) and subject[0] ~= '\e'
		do
		    if Match(&ps, &subject[0], CharsLen(&subject[0])) then
			writeln("Matched.");
		    else
			writeln("Not matched.");
		    fi;
		od;
	    else
		case ps.ps_error
		incase pse_missingPrimary:
		    writeln("Missing primary");
		incase pse_unexpectedRightParen:
		    writeln("Unexpected right paren");
		incase pse_unexpectedOr:
		    writeln("Unexecpted or");
		incase pse_missingRightParen:
		    writeln("Missing right paren");
		esac;
	    fi;
	od;
	ClosePatternLibrary();
    fi;
corp;
