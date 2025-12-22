	IFND	LIBRARIES_EXAMPLE_I
LIBRARIES_EXAMPLE_I	SET	1

**      $VER: example.i 1.0 (21.09.2002)
**
**      main include file for example.library

	IFND	EXEC_LIBRARIES_I
	INCLUDE "exec/libraries.i"
	ENDC

/* This is the official part of ExampleBase. It has private fields as well. */
	STRUCTURE ExampleBase,LIB_SIZE
	APTR	exb_LibNode
	ULONG	exb_NumCalls; /* example field */
	ULONG	exb_NumHookCalls; /* example field */

	ENDC	; LIBRARIES_EXAMPLE_I

