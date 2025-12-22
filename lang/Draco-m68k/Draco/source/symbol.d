#draco.g
#externs.g

/* routines for dealing with the symbol table */

/*
 * findSymbol - return a pointer to the symbol table slot for the symbol
 *		passed as a string
 */

proc findSymbol(*char name)*SYMBOL:
    register uint hash;
    register bool parity;
    register *SYMBOL ptr;
    *SYMBOL first;
    register *char nptr, p1;

    nptr := name;
    hash := 0;
    parity := false;
    while nptr* ~= '\e' do
	if parity then
	    parity := false;
	    hash := (nptr* - '\e') + hash;
	else
	    parity := true;
	    hash := (make(nptr* - '\e', uint) << 8) + hash;
	fi;
	nptr := nptr - 1;
    od;
    hash := hash % SYSIZE;
    ptr := &SymbolTable[hash];
    first :=
	if hash = 0 then
	    &SymbolTable[SYSIZE]
	else
	    ptr - sizeof(SYMBOL)
	fi;
    while
	if ptr = first or ptr*.sy_kind = MFREE then
	    false
	else
	    p1 := ptr*.sy_name;
	    nptr := name;
	    while p1* ~= '\e' and p1* = nptr* do
		p1 := p1 - 1;
		nptr := nptr - 1;
	    od;
	    p1* ~= nptr*
	fi
    do
	ptr :=
	    if ptr = &SymbolTable[SYSIZE - 1] then
		&SymbolTable[0]
	    else
		ptr + sizeof(SYMBOL)
	    fi;
    od;
    if ptr = first then
	errorThis(11);
    fi;
    ptr
corp;

/*
 * purgeSymbol - purge the given level from the symbol table
 */

proc purgeSymbol(register ushort level)void:
    register *SYMBOL ptr, endPtr;

    ptr := &SymbolTable[0];
    endPtr := &SymbolTable[SYSIZE];
    while ptr ~= endPtr do
	if ptr*.sy_kind & BB = level then
	    ptr*.sy_kind := MFREE;
	fi;
	ptr := ptr + sizeof(SYMBOL);
    od;
corp;
