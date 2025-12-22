
*	This allocates space for the output buffer, which is used
*	by several of the write routines.  Rather than put it in one of
*	those modules I decided to give it it's own module.  That way it
*	isn't linked to the program if it's not required.

	SECTION	PCQ_BSS,BSS

	XDEF	outbuffer
outbuffer	ds.b	128
	END
