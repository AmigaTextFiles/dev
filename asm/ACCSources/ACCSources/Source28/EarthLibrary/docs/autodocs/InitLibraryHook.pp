
NAME
	InitLibraryHook -- Initialise a hook to perform a library function.

SYNOPSIS
	InitLibraryHook(hook,libbase,offset)
	                a0   a1      d0

FUNCTION
	Initialise a Hook structure to represent a library function.
	Note that you can't use any old library function here - it
	must be a library function specially written to execute
	callback hooks. There are three such functions within
	earth.library - these are NodeValueCmp(), NodeNameCmp() and
	NodeNameICmp().

INPUTS
	struct Hook *hook - This is the address of an uninitialised
		standard WB2.0+ hook structure. Note that it is not
		neccessary to have WB2.0+ in order to use hooks. If
		you are using WB1.3 or earlier you will find the Hook
		structure defined in earth/earth.i or earth/earth.h.

	struct Library *libbase - The library base address of the
		library containing the desired function.

	LONG offset - The _LVO offset of the desired function. 'C'
		programmers may omit the underscore. 'C' programmers
		must also remember to declare the offset as an external
		value, for example like this:

		/* Example declaration */
		extern LONG LVONodeValueCmp;

		/* Example call */
		InitLibraryHook( myHook, EarthBase, LVONodeValueCmp );

		For "earth.library" functions, the _LVO offset is
		declared in the linker-library "earth.lib" and the
		assembler include file "earth/earth_lib.i".

RESULT
	None
	
NOTES
	The hook is initialised as follows:
		h_Entry		Entry point within "earth.library".
		h_SubEntry	Address of library vector.
		h_Data		Library base address.

	When the hook is called, the code within "earth.library"
	calls h_SubEntry with a6 initialised to h_Data.
	
SEE ALSO
	NodeValueCmp(), NodeNameCmp(), NodeNameICmp()
