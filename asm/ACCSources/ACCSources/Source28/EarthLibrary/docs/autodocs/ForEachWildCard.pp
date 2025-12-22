
NAME
	ForEachWildCard -- Call a function for each file referenced
		by a wildcard pattern.

SYNOPSIS
	failcode = ForEachWildCard(pattern,userfunc,userdata)
	d0                         a0      a1       a2

FUNCTION
	Find all files which match the specified wildcard pattern
	and call the specified <userfunc> function once for each
	match. This continues until either the user-function returns
	a non-zero return value, or there are no more wildcard pattern
	matches.

INPUTS
	STRPTR pattern - The address of a null-terminated string
		containing a wildcard pattern.

	LONG (*userfunc)() - The address of a function supplied by the
		user. This function will be called like this:

		failcode = userfunc(pathname,userdata)
		d0                  a0       a2

		INPUTS
			STRPTR pathname - The address of a null-terminated
				string containing the pathname of a file
				which matched the pattern.

			LONG userdata - For any purpose. See below.

		RESULTS
			LONG failcode - Zero for success, non-zero
				for failure.

		You can write this function either in 'C' or assembler.
		You will find the entry parameters BOTH on the stack
		(for 'C' programmers) AND in registers (for assembler
		programmers). Your function should return zero if all
		went well, or non-zero to abort ForEachArgument().

	ULONG userdata - Any value whatsoever. This value will be
		passed through to the user function.

RESULT
	ULONG failcode - If all calls to the user-function succeeded
		then this will be zero, otherwise it will be the
		failcode returned by the user-function which failed.
	
NOTES
	This will use AmigaDOS pattern matching under Workbench 2+, or
	ARP pattern matching under Workbench 1.3-. The difference
	between the two is that under AmigaDOS, the "*" wildcard is
	optional, wheras under ARP it is recognised always. Therefore,
	if you include the pattern as part of your program's source,
	you should always use "#?" instead of "*".

SEE ALSO
	ForEachArgument()
