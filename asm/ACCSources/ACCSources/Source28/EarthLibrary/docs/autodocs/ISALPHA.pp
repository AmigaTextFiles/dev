
NAME
	ISALPHA -- Test whether or not a character is alphabetic.

SYNOPSIS
	ISALPHA  [reg]
	_ISALPHA [reg]

	This is an assembler macro defined in earth/earthbase.i

FUNCTION
	Test whether or not a charater is alphabetic.

INPUTS
	If using the macro _ISALPHA, then register a6 must contain the
	base address of earth.library.

	This is not necessary with ISALPHA, since this macro moves the
	address into a6 prior to doing _ISALPHA.

MACRO PARAMETERS
	reg - The name of the register containing the character to test.
		Bits 7 to 0 of this register should contain a character.
		Bits 15 to 8 should always contain zero.
		Bits 31 to 16 are ignored.

RESULT
	If the character is alphabetic then the zero flag is reset,
	Else the zero flag is set.

NOTES
	This is just about the FASTEST possible way of testing whether
	or not a character is alphabetic. If a6 already contains the
	base address of earth.library then use _ISALPHA, else use
	ISALPHA.

	Note that the ISALPHA macro supports your SETDATA and SETA6
	settings (see the include file earth/earth.i) which means that
	the library base address will be moved from the correct _data
	relative address into a6, and a6 will be preserved if you
	require it.
	
SEE ALSO
	ISALNUM, ISCNTRL, ISDIGIT, ISGRAPH, ISLOWER, ISPRINT,
	ISPUNCT, ISSPACE, ISUPPER, ISHEX,   TOUPPER, TOLOWER
