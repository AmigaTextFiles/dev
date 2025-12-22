
NAME
	_StrNCat -- Concatenate two null terminated strings to a
		specified maximum length.

SYNOPSIS
	_StrCat(dest,source,length)
	        a1   a0     d0

FUNCTION
	Append a null terminated string onto the end of an existing
	null terminated string, within a fixed-size buffer.

INPUTS
	dest - The address of a buffer containing a null-terminated
		string. The buffer must be contain at least <length>
		bytes.

	source - The address of a null-terminated string to be copied.

RESULT
	None.

NOTES
	The strings are concatenated in the order <dest> <source>.

	If the total length of the concatenated string exceeds <length>
	then only the first (<length>-1) bytes of the buffer will
	contain valid characters from the strings. The last byte will
	be filled in with null, so that the destination string will
	always be null-terminated.

	For the convenience of assembler programmers, ALL registers
	are guaranteed to be preserved.
	
SEE ALSO
	_StrCpy(), _StrNCpy(), _StrCat(), _StrMove() _StrMoveUpper()
