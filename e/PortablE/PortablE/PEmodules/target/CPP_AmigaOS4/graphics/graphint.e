/* $Id: graphint.h,v 1.12 2005/11/10 15:36:43 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/nodes'
MODULE 'target/exec/types'
{#include <graphics/graphint.h>}
NATIVE {GRAPHICS_GRAPHINT_H} CONST

/* structure used by AddTOFTask */
NATIVE {Isrvstr} OBJECT isrvstr
    {is_Node}	ln	:ln
    {Iptr}	iptr	:PTR TO isrvstr    /* passed to srvr by os */
    {code}	code	:NATIVE {LONG          (*)()} PTR
    {ccode}	ccode	:NATIVE {LONG (*) __CLIB_PROTOTYPE((APTR))} PTR
    {Carg}	carg	:APTR
ENDOBJECT
