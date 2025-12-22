
NAME
	_StrCpy -- Copy a null terminated string.

SYNOPSIS
	_StrCpy(dest,source)
	        a1   a0

FUNCTION
	Copy a null terminated string.

INPUTS
	dest - The address of a buffer which is known to be large
		enough to contain a copy of the string.

	source - The address of a null-terminated string to be copied.

RESULT
	None.

NOTES
	For the convenience of assembler programmers, ALL registers
	are guaranteed to be preserved.
	
SEE ALSO
	_StrNCpy(), _StrCat(), _StrNCat(), _StrMove() _StrMoveUpper()
