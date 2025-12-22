#drinc:exec/miscellaneous.g
#drinc:exec/libraries.g
#drinc:libraries/dos.g

proc message(*char m)void:
    register *char p;

    p := m;
    while p* ~= '\e' do
	p := p + sizeof(char);
    od;
    ignore Write(Output(), m, p - m);
corp;

proc main()void:
    uint
	R_A0 = 0,
	R_A5 = 5,
	R_LIB = 6,
	R_FP = 6,

	M_ADIR = 1,
	M_INDIR = 2,
	M_DISP = 5,

	OP_MOVEL = 0x2000,
	OP_JSR = 0x4e80;
    extern
	GetPars(*ulong pLen; **char pPtr)void;
    ulong parLen;
    *char parPtr, name;
    *Library_t lib;
    proc()void expungeEntry;
    register *char unusedARegWhichWillBeA5;

    if OpenDosLibrary(0) ~= nil then
	if OpenExecLibrary(0) ~= nil then
	    GetPars(&parLen, &parPtr);
	    while parPtr* = ' ' or parPtr* = '\t' do
		parPtr := parPtr + sizeof(char);
	    od;
	    if parPtr* = '\r' or parPtr* = '\n' or parPtr* = '\e' then
		message("use is: expunge <full-library-name>\n");
	    else
		name := parPtr;
		while parPtr* ~= ' ' and parPtr* ~= '\t' and
		    parPtr* ~= '\r' and parPtr* ~= '\n' and
		    parPtr* ~= '\e'
		do
		    parPtr := parPtr + sizeof(char);
		od;
		parPtr* := '\e';
		lib := OpenLibrary(name, 0);
		if lib ~= nil then
		    message("Opened library '");
		    message(name);
		    message("'\n");
		    expungeEntry := pretend(lib + LIB_EXPUNGE, proc()void);
		    code(
			OP_MOVEL | R_A0 << 9 | M_ADIR << 6 |
			    M_DISP << 3 | R_FP,
			expungeEntry,
			OP_MOVEL | R_A5 << 9 | M_ADIR << 6 |
			    M_ADIR << 3 | R_FP,
			OP_MOVEL | R_LIB << 9 | M_ADIR << 6 |
			    M_DISP << 3 | R_FP,
			lib,
			OP_JSR | M_INDIR << 3 | R_A0,
			OP_MOVEL | R_FP << 9 | M_ADIR << 6 |
			    M_ADIR << 3 | R_A5
		    );
		    message("Requested expunge of library '");
		    message(name);
		    message("'\n");
		    CloseLibrary(lib);
		else
		    message("Could not open library '");
		    message(name);
		    message("'\n");
		fi;
	    fi;
	    CloseExecLibrary();
	fi;
	CloseDosLibrary();
    fi;
corp;
