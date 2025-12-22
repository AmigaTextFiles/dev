/* $VER: io.h 39.0 (15.10.1991) */
OPT NATIVE
MODULE 'target/exec/ports'
MODULE 'target/exec/devices', 'target/exec/types'
{MODULE 'exec/io'}

NATIVE {io} OBJECT io
    {mn}	mn	:mn
    {device}	device	:PTR TO dd     /* device node pointer  */
    {unit}	unit	:PTR TO unit	    /* unit (driver private)*/
    {command}	command	:UINT	    /* device command */
    {flags}	flags	:UBYTE
    {error}	error	:BYTE		    /* error or warning num */
ENDOBJECT

NATIVE {iostd} OBJECT iostd
    {mn}	mn	:mn
    {device}	device	:PTR TO dd     /* device node pointer  */
    {unit}	unit	:PTR TO unit	    /* unit (driver private)*/
    {command}	command	:UINT	    /* device command */
    {flags}	flags	:UBYTE
    {error}	error	:BYTE		    /* error or warning num */
    {actual}	actual	:ULONG		    /* actual number of bytes transferred */
    {length}	length	:ULONG		    /* requested number bytes transferred*/
    {data}	data	:APTR		    /* points to data area */
    {offset}	offset	:ULONG		    /* offset for block structured devices */
ENDOBJECT

/* library vector offsets for device reserved vectors */
NATIVE {DEV_BEGINIO}	CONST DEV_BEGINIO	= (-30)
NATIVE {DEV_ABORTIO}	CONST DEV_ABORTIO	= (-36)

/* io_Flags defined bits */
NATIVE {IOB_QUICK}	CONST IOB_QUICK	= 0
NATIVE {IOF_QUICK}	CONST IOF_QUICK	= $1


NATIVE {CMD_INVALID}	CONST CMD_INVALID	= 0
NATIVE {CMD_RESET}	CONST CMD_RESET	= 1
NATIVE {CMD_READ}	CONST CMD_READ	= 2
NATIVE {CMD_WRITE}	CONST CMD_WRITE	= 3
NATIVE {CMD_UPDATE}	CONST CMD_UPDATE	= 4
NATIVE {CMD_CLEAR}	CONST CMD_CLEAR	= 5
NATIVE {CMD_STOP}	CONST CMD_STOP	= 6
NATIVE {CMD_START}	CONST CMD_START	= 7
NATIVE {CMD_FLUSH}	CONST CMD_FLUSH	= 8

NATIVE {CMD_NONSTD}	CONST CMD_NONSTD	= 9
