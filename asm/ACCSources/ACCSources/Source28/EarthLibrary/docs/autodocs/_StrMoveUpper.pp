
NAME
	_StrMove -- Copy a null terminated string.

SYNOPSIS
	nextdest = _StrMoveUpper(dest,source)
	a1                       a1   a0

FUNCTION
	Copy a null terminated string, converting the copy to
	upper case.

INPUTS
	dest - The address of a buffer which is known to be large
		enough to contain a copy of the string.

	source - The address of a null-terminated string to be copied.

RESULT
	nextdest - The address of the null-terminator of the copy.
		You can pass this value back into subsequent calls
		of _StrMove() or _StrMoveUpper() to repeatedly
		concatenate new strings into the same buffer.

NOTES
	It is legal to let <dest> = <source>, thereby converting a
	string to upper case in place.

	For the convenience of assembler programmers, ALL registers
	except a1 are guaranteed to be preserved.
	
SEE ALSO
	_StrCpy(), _StrNCpy(), _StrCat(), _StrNCat(), _StrMove()
