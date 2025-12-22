
NAME
	_StrCat -- Concatenate two a null terminated strings.

SYNOPSIS
	_StrCat(dest,source)
	        a1   a0

FUNCTION
	Append a null terminated string onto the end of an existing
	null terminated string.

INPUTS
	dest - The address of a buffer containing a null-terminated
		string. The buffer must be large enough to contain
		the concatenation of the two strings.

	source - The address of a null-terminated string to be copied.

RESULT
	None.

NOTES
	The strings are concatenated in the order <dest> <source>.

	For the convenience of assembler programmers, ALL registers
	are guaranteed to be preserved.
	
SEE ALSO
	_StrCpy(), _StrNCpy(), _StrNCat(), _StrMove() _StrMoveUpper()
