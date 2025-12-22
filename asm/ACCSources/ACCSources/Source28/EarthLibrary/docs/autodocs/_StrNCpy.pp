
NAME
	_StrNCpy -- Copy the initial part of a null terminated string.

SYNOPSIS
	_StrCpy(dest,source,length)
	        a1   a0     d0

FUNCTION
	Copy at most <length> characters of a null terminated string.

INPUTS
	dest - The address of a buffer which is known to hold at least
		<length> bytes.

	source - The address of a null-terminated string to be copied.

	length - The maximum number of characters to be copied.

RESULT
	None.

NOTES
	In practice, if the source string is greater than <length>
	bytes in length, then only the first (<length>-1) bytes are
	copied. The last byte of the buffer is then filled will a
	null byte, which means that the destination string will always
	be null-terminated.

	For the convenience of assembler programmers, ALL registers
	are guaranteed to be preserved.
	
SEE ALSO
	_StrCpy(), _StrCat(), _StrNCat(), _StrMove() _StrMoveUpper()
