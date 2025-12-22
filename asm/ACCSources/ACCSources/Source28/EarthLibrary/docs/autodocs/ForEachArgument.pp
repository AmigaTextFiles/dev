
NAME
	ForEachArgument -- Call a function for each argument in an array.

SYNOPSIS
	failcode = ForEachArgument(argc,argv,userfunc,userdata)
	d0                         d0   a0   a1       a2

FUNCTION
	Call the specified <userfunc> function at most <argc> times.
	Each time the function is called it is passed a different
	element from the supplied <argv> array. This continues until
	either the user-function returns a non-zero return value, or
	there are no more elements in the array.

INPUTS
	ULONG argc - The number of elements in the <argv> array. You
		can pass -1 here, which indicates that the array is
		of indefinate length (and must be terminated by a zero
		longword).

	LONG *argv - A longword array containing <argc> elements. It is
		forbidden for any array element to contain longword
		zero, as this will terminate the array.

	LONG (*userfunc)() - The address of a function supplied by the
		user. This function will be called like this:

		failcode = userfunc(argv_i,userdata)
		d0                  a0      a2

		INPUTS
			LONG argv_i - The next element from the array.
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
	
SEE ALSO
	ForEachWildCard()
