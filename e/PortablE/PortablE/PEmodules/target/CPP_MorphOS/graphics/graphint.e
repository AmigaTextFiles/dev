/* $VER: graphint.h 39.0 (23.9.1991) */
OPT NATIVE
MODULE 'target/exec/nodes'
MODULE 'target/exec/types'
{#include <graphics/graphint.h>}
NATIVE {GRAPHICS_GRAPHINT_H} CONST

/* structure used by AddTOFTask */
NATIVE {Isrvstr} OBJECT isrvstr
    {is_Node}	ln	:ln
    {Iptr}	iptr	:PTR TO isrvstr   /* passed to srvr by os */
    {code}	code	:NATIVE {LONG (*)()} PTR
    {ccode}	ccode	:NATIVE {LONG (*) __CLIB_PROTOTYPE((APTR))} PTR
    {Carg}	carg	:APTR
ENDOBJECT
