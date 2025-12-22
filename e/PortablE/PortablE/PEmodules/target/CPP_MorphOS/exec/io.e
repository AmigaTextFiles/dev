/* $VER: io.h 39.0 (15.10.1991) */
OPT NATIVE
MODULE 'target/exec/ports'
MODULE 'target/exec/devices', 'target/exec/types'
{#include <exec/io.h>}
NATIVE {EXEC_IO_H} CONST

NATIVE {IORequest} OBJECT io
    {io_Message}	mn	:mn
    {io_Device}	device	:PTR TO dd     /* device node pointer  */
    {io_Unit}	unit	:PTR TO unit	    /* unit (driver private)*/
    {io_Command}	command	:UINT	    /* device command */
    {io_Flags}	flags	:UBYTE
    {io_Error}	error	:BYTE		    /* error or warning num */
ENDOBJECT

NATIVE {IOStdReq} OBJECT iostd
    {io_Message}	mn	:mn
    {io_Device}	device	:PTR TO dd     /* device node pointer  */
    {io_Unit}	unit	:PTR TO unit	    /* unit (driver private)*/
    {io_Command}	command	:UINT	    /* device command */
    {io_Flags}	flags	:UBYTE
    {io_Error}	error	:BYTE		    /* error or warning num */
    {io_Actual}	actual	:ULONG		    /* actual number of bytes transferred */
    {io_Length}	length	:ULONG		    /* requested number bytes transferred*/
    {io_Data}	data	:APTR		    /* points to data area */
    {io_Offset}	offset	:ULONG		    /* offset for block structured devices */
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
