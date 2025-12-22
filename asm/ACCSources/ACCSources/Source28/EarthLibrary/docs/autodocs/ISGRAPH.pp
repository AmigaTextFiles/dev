
NAME
	ISGRAPH -- Test whether or not a character is a graphical.

SYNOPSIS
	ISGRAPH  [reg]
	_ISGRAPH [reg]

	This is an assembler macro defined in earth/earthbase.i

FUNCTION
	Test whether or not a charater is a graphical. This includes
	all printable characters except space.

INPUTS
	If using the macro _ISGRAPH, then register a6 must contain the
	base address of earth.library.

	This is not necessary with ISGRAPH, since this macro moves the
	address into a6 prior to doing _ISGRAPH.

MACRO PARAMETERS
	reg - The name of the register containing the character to test.
		Bits 7 to 0 of this register should contain a character.
		Bits 15 to 8 should always contain zero.
		Bits 31 to 16 are ignored.

RESULT
	If the character is graphical then the zero flag is reset,
	Else the zero flag is set.

NOTES
	This is just about the FASTEST possible way of testing whether
	or not a character is graphical. If a6 already contains the
	base address of earth.library then use _ISGRAPH, else use
	ISGRAPH.

	Note that the ISGRAPH macro supports your SETDATA and SETA6
	settings (see the include file earth/earth.i) which means that
	the library base address will be moved from the correct _data
	relative address into a6, and a6 will be preserved if you
	require it.
	
SEE ALSO
	ISALPHA, ISALNUM, ISCNTRL, ISDIGIT, ISLOWER, ISPRINT,
	ISPUNCT, ISSPACE, ISUPPER, ISHEX,   TOUPPER, TOLOWER
