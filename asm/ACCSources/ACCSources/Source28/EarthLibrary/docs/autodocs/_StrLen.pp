
NAME
	_StrLen -- Count the length of a string.

SYNOPSIS
	length = _StrLen(string)
	d0,Z             a0

FUNCTION
	Count the length in bytes of a null-terminated (ie. 'C')
	string.

INPUTS
	STRPTR string - The address of a null-terminated string.

RESULT
	ULONG count - The number of characters in the string, excluding
	the null-terminator itself.

NOTES
	For the benefit of assembler programmers, this function is
	guaranteed to preserved ALL registers except d0, which will
	contain the return value. Also, please note that the zero
	flag will be set if the length was zero, or reset otherwise.
	
SEE ALSO
