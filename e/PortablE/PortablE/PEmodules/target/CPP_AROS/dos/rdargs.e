/* $Id: rdargs.h 28622 2008-05-04 23:44:11Z sszymczy $ */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/types'
{#include <dos/rdargs.h>}
NATIVE {DOS_RDARGS_H} CONST

/* This structure emulates an input stream by using a buffer. */
NATIVE {CSource} OBJECT csource
      /* The buffer, which contains the stream. In most cases this may be NULL,
         in which case the current input stream is used. */
    {CS_Buffer}	buffer	:ARRAY OF UBYTE
    {CS_Length}	length	:VALUE /* The length of the buffer. */
    {CS_CurChr}	curchr	:VALUE /* The current position in the buffer. */
ENDOBJECT

/* The main structure used for ReadArgs(). It contains everything needed for
   ReadArgs() handling. Allocate this structure with AllocDosObject(). */
NATIVE {RDArgs} OBJECT rdargs
      /* Embedded CSource structure (see above). If CS_Buffer of this structure
         is != NULL, use this structure as source for parsing, otherwise use
         Input() as source. */
    {RDA_Source}	source	:csource

    {RDA_DAList}	dalist	:IPTR /* PRIVATE. Must be initialized to 0. */

    /* The next two fields allow an application to supply a buffer to be parsed
       to ReadArgs(). If either of these fields is 0, ReadArgs() allocates this
       buffer itself. */
    {RDA_Buffer}	buffer	:ARRAY OF UBYTE /* Pointer to buffer. May be NULL. */
    {RDA_BufSiz}	bufsiz	:VALUE /* Size of the supplied buffer. May be 0. */

      /* Additional help, if user requests it, by supplying '?' as argument. */
    {RDA_ExtHelp}	exthelp	:ARRAY OF UBYTE
    {RDA_Flags}	flags	:VALUE /* see below */
ENDOBJECT

/* RDA_Flags */
NATIVE {RDAB_STDIN}    CONST RDAB_STDIN    = 0 /* Use Input() instead of the supplied command line. */
NATIVE {RDAB_NOALLOC}  CONST RDAB_NOALLOC  = 1 /* Do not allocate more space. */
NATIVE {RDAB_NOPROMPT} CONST RDAB_NOPROMPT = 2 /* Do not prompt for input. */

NATIVE {RDAF_STDIN}    CONST RDAF_STDIN    = $1
NATIVE {RDAF_NOALLOC}  CONST RDAF_NOALLOC  = $2
NATIVE {RDAF_NOPROMPT} CONST RDAF_NOPROMPT = $4

/* Maximum number of items in a template. This may change in future versions.
*/
NATIVE {MAX_TEMPLATE_ITEMS} CONST MAX_TEMPLATE_ITEMS = 100

/* The maximum number of arguments in an item, which allows to specify multiple
   arguments (flag '/M'). This may change in future versions.*/
NATIVE {MAX_MULTIARGS}      CONST MAX_MULTIARGS      = 128
