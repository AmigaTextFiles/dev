
NAME
	_StrICmp -- Compare two strings with case insensitivity.

SYNOPSIS
	comparison = _StrICmp(string1,string2)
	ccr                   a0      a1

FUNCTION
	Compare two strings alphabetically.
	Note that this is a case insensitive comparison.

INPUTS
	STRPTR string1 - The address of a null-terminated string.
	STRPTR string2 - The address of a null-terminated string.

RESULT (ASSEMBLER PROGRAMMERS ONLY)
	This result is placed in the condition codes register, and is
	therefore only accessable to assembler programmers. Possible
	return codes are:
		lt	string2 is less than string1
		eq	string2 is equal to string1
		gt	string2 is greater than string1

RESULT (C PROGRAMMERS ONLY)
	The return value is a number which will be:
		negative if string2 is less than string1
		zero	 if string2 is equal to string1
		positive if string2 is greater than string1

NOTES
	This function is guaranteed to preserved ALL registers.
	
SEE ALSO
	_StrCmp(), _StrNCmp(), _StrNICmp()
