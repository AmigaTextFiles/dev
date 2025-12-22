type FileHandle_t = ulong;

extern
    OpenDosLibrary(ulong version)*byte,
    CloseDosLibrary()void,
    Exit(ulong stat)void,
    Output()FileHandle_t,
    DeleteFile(*char name)void,
    Open(*char name; ulong mode)FileHandle_t,
    Close(FileHandle_t fd)void,
    Write(FileHandle_t fd; *char buffer; ulong length)ulong;

ulong MODE_NEWFILE = 1006;

int Count;
FileHandle_t Stdout, DataFile;

proc putString(*char s)void:
    *char p;

    p := s;
    while p* ~= '\e' do
	p := p + 1;
    od;
    if Write(Stdout, s, p - s) ~= p - s then
	Close(DataFile);
	Exit(30);
    fi;
corp;

proc putWord(uint n)void:
    [6] char buff;
    *char p;

    p := &buff[5];
    p* := '\e';
    while
	p := p - 1;
	p* := n % 10 + '0';
	n := n / 10;
	n ~= 0
    do
    od;
    putString(p);
corp;

proc err(*char message)void:
    [64] char buffer;
    *char p;
    ushort i;

    i := 0;
    p := message;
    while p* ~= '\e' do
	if i ~= 64 then
	    buffer[i] := p*;
	    i := i + 1;
	fi;
	p := p + 1;
    od;
    if i >= 64 then
	putString("Error message \#");
	putWord(Count);
	putString(" is ");
	putWord(i - 64);
	putString(" characters too long.\n");
	i := 64;
    fi;
    while i ~= 64 do
	buffer[i] := '\e';
	i := i + 1;
    od;
    if Write(DataFile, &buffer[0], 64) ~= 64 then
	Close(DataFile);
	Exit(30);
    fi;
    Count := Count + 1;
corp;

proc err0()void:
    /* 0 */
    err("***unused***\n");
    err("***unused***\n");
    err("too many operator-type parameters to procedure\n");
    err("error on write to .r file\n");
    err("unexpected end-of-file on source input\n");
    err("program buffer overflow (procedure too long)\n");
    err("character buffer overflow (too much constant)\n");
    err("constant table overflow (too many constants)\n");
    err("case table overflow (too many alternatives)\n");
    err("descriptor table overflow (nesting too deep)\n");
corp;

proc err1()void:
    /* 10 */
    err("relocation table overflow (too many constant indexes)\n");
    err("symbol table overflow (too many identifiers)\n");
    err("type table overflow (too many types)\n");
    err("type information table overflow (types too complex)\n");
    err("branch table overflow - reduce procedure complexity\n");
    err("\" is already defined\n");
    err("\" is not defined\n");
    err("\" is not defined (subsequent use)\n");
    err("\" has been used but not defined\n");
    err("***unused***\n");
corp;

proc err2()void:
    /* 20 */
    err("expecting global declaration in include file\n");
    err("expecting procedure header or file global declaration\n");
    err("expecting procedure header for new procedure\n");
    err("value must be 0 - 255\n");
    err("'signed' range must be <= 2147483647\n");
    err("missing ')' in escaped character\n");
    err("bad digit in numeric constant\n");
    err("overflow in numeric constant\n");
    err("missing closing \"'\" in character constant\n");
    err("missing closing '\"' in string constant\n");
corp;

proc err3()void:
    /* 30 */
    err("illegal character\n");
    err("cannot use 'sizeof' on arrays with '*' dimensions\n");
    err("expecting identifier in declaration\n");
    err("expecting ',' as separator in list\n");
    err("expecting '{'\n");
    err("missing ']'\n");
    err("identifier is not a defined type\n");
    err("numeric constant required\n");
    err("positive value required\n");
    err("missing '}' in enumeration type\n");
corp;

proc err4()void:
    /* 40 */
    err("only parameter arrays can have '*' dimensions\n");
    err("array dimension must be compile-time expression >= 0\n");
    err("syntax error - expecting type\n");
    err("missing '=' in type definition\n");
    err("constant value must be string or compile-time expression\n");
    err("parameters to 'code' must be constants or variables\n");
    err("missing 'corp' at end of procedure\n");
    err("'vector' procedures cannot return a result\n");
    err("missing ':' after procedure header\n");
    err("'vector' procedures cannot have parameters\n");
corp;

proc err5()void:
    /* 50 */
    err("result expression given for 'void' procedure\n");
    err("no result given for procedure when one was declared\n");
    err("statement cannot be used as 'bool' condition\n");
    err("only 'bool' values can be used as conditions\n");
    err("statement cannot be used as expression\n");
    err("constant is out of range for the destination type\n");
    err("statements cannot be used as expressions in assignments\n");
    err("value is not type compatible with destination\n");
    err("mixed statements/expressions in 'if' or 'case'\n");
    err("alternatives in 'if' or 'case' are not type compatible\n");
corp;

proc err6()void:
    /* 60 */
    err("missing 'then' in 'if'\n");
    err("missing 'else' or 'fi' in 'if'\n");
    err("'if' expressions must have an 'else' part\n");
    err("missing 'fi' in 'if'\n");
    err("missing 'do' in 'while' or 'for'\n");
    err("missing 'od' in 'while' or 'for'\n");
    err("body of 'while' must not be an expression\n");
    err("expressions cannot be used as statements\n");
    err("missing ';'\n");
    err("missing ','\n");
corp;

proc err7()void:
    /* 70 */
    err("missing ')'\n");
    err("value being called is not a procedure\n");
    err("too many parameters to procedure\n");
    err("actual parameter to procedure is of wrong type\n");
    err("actual array parameter does not match required type\n");
    err("array with '*' dim cannot be passed as fixed array\n");
    err("not enough parameters to procedure\n");
    err("missing '('\n");
    err("too many values\n");
    err("too few values\n");
corp;

proc err8()void:
    /* 80 */
    err("cannot change the type of statements\n");
    err("'dim' can only be used with arrays\n");
    err("dimension selector must be compile-time expression\n");
    err("dimension selector is 0 or too big\n");
    err("cannot nest structured constants\n");
    err("cannot bracket a statement\n");
    err("mismatched ')'\n");
    err("syntax error - undecipherable statement or expression\n");
    err("improper use of field name\n");
    err("cannot index anything except arrays\n");
corp;

proc err9()void:
    /* 90 */
    err("this value cannot be used as an array index\n");
    err("value is greater than declared array dimension\n");
    err("not enough indexes for this array\n");
    err("too many indexes for this array\n");
    err("this value is not a structure - can't select from it\n");
    err("this identifier is not a field name\n");
    err("this field is not an element of this structure/union\n");
    err("expecting field name\n");
    err("cannot take the address of this value\n");
    err("this value is not suitable for bit operations\n");
corp;

proc err10()void:
    /* 100 */
    err("this value is not suitable for integral operations\n");
    err("this value is not suitable for binary '+'/'-'\n");
    err("illegal combination of pointer or enum with number\n");
    err("expression cannot be made into array or structure\n");
    err("only '=' or '~=' allowed for signed v.s. unsigned\n");
    err("attempted division by zero\n");
    err("'not' can only be used with 'bool' values\n");
    err("'and' and 'or' can only be used with 'bool' values\n");
    err("cannot assign to this\n");
    err("'case' selectors must be numeric or an enum\n");
corp;

proc err11()void:
    /* 110 */
    err("'case' cannot have more than one 'default'\n");
    err("'case' index must be compile-time expression\n");
    err("'case' indexes cannot occur more than once\n");
    err("missing ':' after 'case' index\n");
    err("'case' must have at least one alternative\n");
    err("missing 'esac' in 'case'\n");
    err("body of 'for' must not be an expression\n");
    err("'for' counter must be numeric, enum or pointer var\n");
    err("missing 'from' in 'for'\n");
    err("missing 'upto' or 'downto' in 'for'\n");
corp;

proc err12()void:
    /* 120 */
    err("value is not a pointer\n");
    err("can only 'free' pointers\n");
    err("can only take 'range' of numerics and enumerations\n");
    err("'by' value is out of range for loop variable\n");
    err("expecting 'input' or 'output' in channel type\n");
    err("expecting 'text' or 'binary' in channel type\n");
    err("first operand of 'open' must be a channel\n");
    err("channel for standard input/output must be text channel\n");
    err("file name for 'open' must be a text channel\n");
    err("wrong proc type for this channel type\n");
corp;

proc err13()void:
    /* 130 */
    err("cannot open binary channel on a *char value\n");
    err("illegal second operand of 'open'\n");
    err("operand to 'close'/'IOerror' must be a channel\n");
    err("special first operand of 'read'/'write' must be channel\n");
    err("invalid operation for a channel of this type\n");
    err("format codes can only be used with numeric values\n");
    err("invalid format code\n");
    err("field width must be numeric value\n");
    err("invalid type for text I/O\n");
    err("input/output constructs not supported by this version\n");
corp;

proc err14()void:
    /* 140 */
    err("this type has no constants\n");
    err("type is not an array or structure\n");
    err("missing external name in operator type\n");
    err("operation not supported by this operator type\n");
    err("operator types cannot be mixed with other types\n");
    err("can only compare with '=' or '~=' for this type\n");
    err("'error' must have string argument\n");
    err("can't redefine non-unknown type\n");
    err("declaration as unknown doesn't match previous known size\n");
    err("declaration as known doesn't match previous unknown size\n");
corp;

proc err15()void:
    /* 150 */
    err("can't give local declaration of global unknown type\n");
    err("pointed-to type is not defined\n");
    err("only pointer value in display is 'nil'\n");
    err("at least one dimension required\n");
    err("value is already void\n");
    err("can't put this type into registers\n");
    err("can't dereference 'arbptr'\n");
    err("can't take the address of register variables\n");
    err("'by' value is 0\n");
    err("'by' value is negative\n");
corp;

proc err16()void:
    /* 160 */
    err("shift amount is greater than size of value being shifted\n");
    err("syntax error in floating point constant\n");
    err("overflow in floating point exponent\n");
    err("overflow in floating point constant\n");
    err("underflow in floating point constant\n");
    err("invalid pragma\n");
    err("too many hex digits for floating point constant\n");
    err("too few hex digits for floating point constant\n");
    err("syntax error in special floating point constant\n");
    err("this value is not suitable for arithmetic operations\n");
corp;

proc err17()void:
    /* 170 */
    err("modulo operator not available for floats\n");
    err("operand to 'fix' must be of type float\n");
    err("only 32768 bytes of local variables supported\n");
    err("can't mix float and non-float operands\n");
    err("can't use register variables with binary I/O\n");
    err("initialized variables can only be at file level\n");
    err("expecting '&' in front of address constant\n");
    err("***unused***\n");
    err("invalid value in variable initialization\n");
    err("expecting proc identifier in variable initialization\n");
corp;

proc err18()void:
    /* 180 */
    err("can't have 'extern' register variables\n");
    err("'extern' ignored for constant\n");
    err("'extern' ignored for overlayed variable\n");
    err("'extern' redundant for initialized variable\n");
    err("expecting file name string for 'read' initialization\n");
    err("can't read file for 'read' initialization\n");
    err("unsufficient data for 'read' initialization\n");
corp;

proc main()void:

    if OpenDosLibrary(0) ~= nil then
	Stdout := Output();
	DeleteFile("dracoErrors");
	DataFile := Open("dracoErrors", MODE_NEWFILE);
	if DataFile = 0 then
	    putString("Can't create file 'dracoErrors'\n");
	    Exit(30);
	fi;
	Count := 0;
	err0();
	err1();
	err2();
	err3();
	err4();
	err5();
	err6();
	err7();
	err8();
	err9();
	err10();
	err11();
	err12();
	err13();
	err14();
	err15();
	err16();
	err17();
	err18();
	Close(DataFile);
	putWord(Count);
	putString(" error messages written\n");
	CloseDosLibrary();
    fi;
corp;
