#drinc:libraries/dos.g
#drinc:util.g

uint BUFFER_SIZE = 1000;

proc main()void:
    [BUFFER_SIZE] char buffer;
    register *char p, q;
    register ulong len;
    register Handle_t stdin, stdout;

    if OpenDosLibrary(0) ~= nil then
	stdin := Input();
	stdout := Output();
	while
	    len := Read(stdin, &buffer[0], BUFFER_SIZE);
	    len ~= 0
	do
	    p := &buffer[0];
	    q := &buffer[len];
	    while p ~= q do
		if p* = '\n' then
		    BlockCopy(p, p + sizeof(char), (q - p - 1) / sizeof(char));
		    len := len - sizeof(char);
		    q := q - sizeof(char);
		else
		    p := p + sizeof(char);
		fi;
	    od;
	    if len ~= 0 then
		ignore Write(stdout, &buffer[0], len);
	    fi;
	od;
	ignore Write(stdout, "\n", 1);
	CloseDosLibrary();
    fi;
corp;
