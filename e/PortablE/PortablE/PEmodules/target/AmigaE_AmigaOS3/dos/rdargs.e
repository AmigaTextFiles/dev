/* $VER: rdargs.h 36.6 (12.7.1990) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/nodes'
{MODULE 'dos/rdargs'}

NATIVE {csource} OBJECT csource
	{buffer}	buffer	:ARRAY OF UBYTE
	{length}	length	:VALUE
	{curchr}	curchr	:VALUE
ENDOBJECT

NATIVE {rdargs} OBJECT rdargs
	{source}	source	:csource	/* Select input source */
	{dalist}	dalist	:VALUE		/* PRIVATE. */
	{buffer}	buffer	:ARRAY OF UBYTE		/* Optional string parsing space. */
	{bufsiz}	bufsiz	:VALUE		/* Size of RDA_Buffer (0..n) */
	{exthelp}	exthelp	:ARRAY OF UBYTE		/* Optional extended help */
	{flags}		flags	:VALUE		/* Flags for any required control */
ENDOBJECT

NATIVE {RDAB_STDIN}	CONST RDAB_STDIN	= 0	/* Use "STDIN" rather than "COMMAND LINE" */
NATIVE {RDAF_STDIN}	CONST RDAF_STDIN	= 1
NATIVE {RDAB_NOALLOC}	CONST RDAB_NOALLOC	= 1	/* If set, do not allocate extra string space.*/
NATIVE {RDAF_NOALLOC}	CONST RDAF_NOALLOC	= 2
NATIVE {RDAB_NOPROMPT}	CONST RDAB_NOPROMPT	= 2	/* Disable reprompting for string input. */
NATIVE {RDAF_NOPROMPT}	CONST RDAF_NOPROMPT	= 4

NATIVE {MAX_TEMPLATE_ITEMS}	CONST MAX_TEMPLATE_ITEMS	= 100

NATIVE {MAX_MULTIARGS}		CONST MAX_MULTIARGS		= 128
