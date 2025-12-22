#drinc:libraries/dos.g
#draco.g
#externs.g

/*
 * printInt - print the passed positive integer on the console
 */

proc printInt(register ulong number)void:
    register *char pointer;
    [12] char buffer;

    pointer := &buffer[11];
    pointer* := '\e';
    while
	pointer := pointer - 1;
	pointer* := make(number % 10, short) + '0';
	number := number / 10;
	number ~= 0
    do
    od;
    printString(pointer);
corp;

/*
 * printHex - print the passed value in hex on the console.
 *	      this is only for debugging - normally commented out
 */

proc printHex(register ulong number)void:
    register *char pointer;
    [9] char buffer;
    register ushort digit;

    pointer := &buffer[8];
    pointer* := '\e';
    while
	pointer := pointer - 1;
	digit := make(number, ushort) & 0x0f;
	pointer* := digit + if digit > 9 then 'A' - 10 else '0' fi;
	number := number >> 4;
	number ~= 0
    do
    od;
    printString(pointer);
corp;

/*
 * printSymbol - print out the name of passed symbol table entry
 */

proc printSymbol(*SYMBOL symbol)void:

    printRevString(symbol*.sy_name);
corp;

/*
 * eHeadHere - do error heading here - useful for con-check aborts.
 */

proc eHeadHere()void:

    errorHead(OOLine, OOColumn, 0, false, false);
corp;

/*
 * error1 - print out the message, line # and column # of an error
 */

proc error1(uint line; ushort column, errorCode; bool isWarning)void:
    *char CRLF = "\n";

    errorHead(line, column, errorCode, isWarning, errorCode = 255);
    if errorCode >= 15 and errorCode <= 18 then
	printString(
	    if errorCode = 18 then
		"Type \""
	    else
		"\""
	    fi);
	printSymbol(CurrentId);
    fi;
    if not errorBody(errorCode) then
	/* can't access error messages - make do with just the number */
	if errorCode >= 15 and errorCode <= 18 then
	    printString("\"");
	fi;
	printString(CRLF);
    fi;
    if errorCode <= 14 or errorCode = 139 then
	abort(10);
    fi;
corp;

/*
 * errorThis - flag the current token with the given error
 */

proc errorThis(ushort errorCode)void:

    error1(OOLine, OOColumn, errorCode, false);
corp;

/*
 * errorBack - flag the previous token with the given error
 */

proc errorBack(ushort errorCode)void:

    error1(OldLine, OldColumn, errorCode, false);
corp;

/*
 * warning - flag the current token with the given warning
 */

proc warning(ushort errorCode)void:

    error1(OOLine, OOColumn, errorCode, true);
corp;

/*
 * conCheck - issue a compiler consistency check message and abort.
 */

proc conCheck(ushort conCode)void:

    eHeadHere();
    printString("**** compiler consistency check \#");
    printInt(conCode);
    printString(" ****\n");
    abort(20);
corp;
