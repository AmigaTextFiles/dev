
NAME
	_StrNCmp -- Compare initial part of two strings.

SYNOPSIS
	comparison = _StrNCmp(string1,string2,length)
	ccr                   a0      a1      d0

FUNCTION
	Compare the initial part of two strings alphabetically.
	Only the first <length> bytes are actually compared, the rest
	are ignored. Note that this is a case sensitive comparison.

INPUTS
	STRPTR string1 - The address of a null-terminated string.
	STRPTR string2 - The address of a null-terminated string.
	ULONG length - The number of bytes to compare.

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
	_StrCmp(), _StrICmp(), _StrNICmp()
