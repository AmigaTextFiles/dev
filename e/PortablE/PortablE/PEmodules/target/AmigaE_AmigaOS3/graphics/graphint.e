/* $VER: graphint.h 39.0 (23.9.1991) */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/types'
{MODULE 'graphics/graphint'}

/* structure used by AddTOFTask */
NATIVE {isrvstr} OBJECT isrvstr
    {ln}	ln	:ln
    {iptr}	iptr	:PTR TO isrvstr   /* passed to srvr by os */
    {code}	code	:PTR /*LONG (*code)()*/
    {ccode}	ccode	:PTR /*LONG (*ccode) __CLIB_PROTOTYPE((APTR))*/
    {carg}	carg	:APTR
ENDOBJECT
