#drinc:util.g

/*
 * ACK - simple program to calculate Ackerman's function.
 */

proc ack(int m, n)int:

    if m = 0 then
	n + 1
    elif n = 0 then
	ack(m - 1, 1)
    else
	ack(m - 1, ack(m, n - 1))
    fi
corp;

proc usage()void:

    writeln("Use is: ack m n    m & n are positive integers");
    exit(1);
corp;

proc main()void:
    channel input text chin;
    int m, n;

    open(chin, GetPar());
    if not read(chin; m) or m < 0 then
	usage();
    fi;
    open(chin, GetPar());
    if not read(chin; n) or n < 0 then
	usage();
    fi;
    /* we write a BEL at the end, since this can be kinda slooooooow */
    writeln("Ack(", m, ", ", n, ") = ", ack(m, n), '\(0x07)');
corp;
