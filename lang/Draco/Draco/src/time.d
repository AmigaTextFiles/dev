#drinc:libraries/dos.g

proc printStr(register *char message)void:
    register *char p;

    p := message;
    while p* ~= '\e' do
	p := p + sizeof(char);
    od;
    ignore Write(Output(), message, p - message);
corp;

proc printNum(register ulong n)void:
    [12] char buffer;
    register *char p;

    p := &buffer[11];
    p* := '\e';
    while
	p := p - sizeof(char);
	p* := n % 10 + '0';
	n := n / 10;
	n ~= 0
    do
    od;
    printStr(p);
corp;

proc abort(*char message)void:

    printStr(message);
    Exit(20);
corp;

proc main()void:
    uint
	OP_MOVEL = 0x2000,
	M_DDIR = 0o0,
	M_ADIR = 0o1,
	M_DISP = 0o5,
	R_A0 = 0,
	R_FP = 6,
	R_D0 = 0;
    extern GetPars(*ulong pLen; **char pPtr)void;
    *char xptr;
    ulong xlen;
    register *char ptr, start;
    register long len;
    register int minutes, ticks, fraction;
    proc()void procPtr;
    Segment_t seg;
    DateStamp_t startTime, endTime;

    if OpenDosLibrary(0) ~= nil then
	GetPars(&xlen, &xptr);
	ptr := xptr;
	len := xlen;
	while len ~= 0 and (ptr* = ' ' or ptr* = '\t') do
	    ptr := ptr + sizeof(char);
	    len := len - 1;
	od;
	if len = 0 or ptr* = '\e' or ptr* = '\r' or ptr* = '\n' then
	    abort("Use is: time prog [args]\n");
	fi;
	start := ptr;
	while len ~= 0 and ptr* ~= ' ' and ptr* ~= '\e' and ptr* ~= '\r' and
	    ptr* ~= '\n'
	do
	    ptr := ptr + sizeof(char);
	    len := len - 1;
	od;
	if ptr* ~= '\e' then
	    ptr* := '\e';
	    ptr := ptr + sizeof(char);
	    len := len - 1;
	fi;
	seg := LoadSeg(start);
	if seg = 0 then
	    printStr("time: could not load '");
	    printStr(start);
	    abort("'\n");
	fi;
	procPtr := pretend((seg + 1) << 2, proc()void);
	DateStamp(&startTime);
	xptr := ptr;
	xlen := len;
	code(
	    OP_MOVEL | R_A0 << 9 | M_ADIR << 6 | M_DISP << 3 | R_FP,
	    xptr,
	    OP_MOVEL | R_D0 << 9 | M_DDIR << 6 | M_DISP << 3 | R_FP,
	    xlen
	);
	procPtr();
	DateStamp(&endTime);
	if not UnLoadSeg(seg) then
	    abort("time: can't unload program\n");
	fi;
	minutes := endTime.ds_Minute - startTime.ds_Minute;
	ticks := endTime.ds_Tick - startTime.ds_Tick;
	if ticks < 0 then
	    ticks := ticks + 50 * 60;
	    minutes := minutes - 1;
	fi;
	fraction := ticks % 50 * 2;
	printStr("Run time = ");
	if minutes = 0 then
	    printNum(ticks / 50);
	    printStr(".");
	    if fraction < 10 then
		printStr("0");
	    fi;
	    printNum(fraction);
	    printStr(" seconds\n");
	else
	    printNum(minutes);
	    printStr(" minutes, ");
	    printNum(ticks / 50);
	    printStr(".");
	    if fraction < 10 then
		printStr("0");
	    fi;
	    printNum(fraction);
	    printStr(" seconds (");
	    minutes := minutes * (50 * 60);
	    ticks := ticks + minutes;
	    printNum(ticks / 50);
	    printStr(".");
	    fraction := ticks % 50 * 2;
	    if fraction < 10 then
		printStr("0");
	    fi;
	    printNum(fraction);
	    printStr(" seconds)\n");
	fi;
	CloseDosLibrary();
    fi;
corp;
