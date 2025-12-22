
NAME
	TOUPPER -- Convert a character to upper case.

SYNOPSIS
	TOUPPER  [d-reg]
	_TOUPPER [d-reg]

	This is an assembler macro defined in earth/earthbase.i

FUNCTION
	Convert a character to upper case.

INPUTS
	If using the macro _TOUPPER, then register a6 must contain the
	base address of earth.library.

	This is not necessary with TOUPPER, since this macro moves the
	address into a6 prior to doing _TOUPPER.

MACRO PARAMETERS
	reg - The name of the register containing the character to convert.
		This must be a data register.
		Bits 7 to 0 of this register should contain a character.
		Bits 15 to 8 should always contain zero.
		Bits 31 to 16 are ignored.

RESULT
	If the character is lower case then it is converted to upper case.
	Else it is unmodified.

NOTES
	This is just about the FASTEST possible way of converting a
	character to upper case. If a6 already contains the base
	address of earth.library then use _TOUPPER, else use TOUPPER.

	Note that the TOUPPER macro supports your SETDATA and SETA6
	settings (see the include file earth/earth.i) which means that
	the library base address will be moved from the correct _data
	relative address into a6, and a6 will be preserved if you
	require it.
	
SEE ALSO
	ISALPHA, ISALNUM, ISCNTRL, ISDIGIT, ISGRAPH, ISLOWER,
	ISPRINT, ISPUNCT, ISSPACE, ISUPPER  ISHEX,   TOLOWER
