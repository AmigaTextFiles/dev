
NAME
	HookEntryC -- Prepare hook entry parameters for standard C usage.

SYNOPSIS
	Used internally. Do not call directly.
	For C programmers only.
	Assembler programmers do not need this function.

FUNCTION
	Transfer entry parameters (passed in registers) to the stack,
	and call the standard C language entry point.

INPUTS
	Not applicable.

RESULT
	Not applicable.

NOTES
	Suppose you have written a hookable function called MyFunction()
	in C. You could represent this function by filling in a Hook
	structure, as follows:

		/* Declarations */
		MyFunction();
		HookEntryC();
		struct Hook myHook;

		/* How to fill in the structure */
		myHook->h_Entry = &HookEntryC;
		myHook->h_SubEntry = &MyFunction;
		myHook->h_Data = NULL; /* could be anything */

	Note that HookEntryC() is a link-time function supplied as
	part of "earth.lib". It is not a part of "earth.library" and
	therefore has no library vector, and no LVO constant.

SEE ALSO
	autodocs/Hooks, autodocs/Trees, InitTree(), InitLibraryHook().
