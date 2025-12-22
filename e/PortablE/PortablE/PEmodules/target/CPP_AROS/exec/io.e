/* $Id: io.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/ports'
MODULE 'target/exec/devices', 'target/exec/types'
{#include <exec/io.h>}
NATIVE {EXEC_IO_H} CONST

NATIVE {DEV_BEGINIO} CONST DEV_BEGINIO = (-30)
NATIVE {DEV_ABORTIO} CONST DEV_ABORTIO = (-36)

NATIVE {IORequest} OBJECT io
    {io_Message}	mn	:mn
    {io_Device}	device	:PTR TO dd
    {io_Unit}	unit	:PTR TO unit
    {io_Command}	command	:UINT
    {io_Flags}	flags	:UBYTE
    {io_Error}	error	:BYTE
ENDOBJECT

NATIVE {IOStdReq} OBJECT iostd
    {io_Message}	mn	:mn
    {io_Device}	device	:PTR TO dd
    {io_Unit}	unit	:PTR TO unit
    {io_Command}	command	:UINT
    {io_Flags}	flags	:UBYTE
    {io_Error}	error	:BYTE
/* fields that are different from IORequest */
    {io_Actual}	actual	:ULONG
    {io_Length}	length	:ULONG
    {io_Data}	data	:APTR
    {io_Offset}	offset	:ULONG
ENDOBJECT

NATIVE {CMD_INVALID} CONST CMD_INVALID = 0
NATIVE {CMD_RESET}   CONST CMD_RESET   = 1
NATIVE {CMD_READ}    CONST CMD_READ    = 2
NATIVE {CMD_WRITE}   CONST CMD_WRITE   = 3
NATIVE {CMD_UPDATE}  CONST CMD_UPDATE  = 4
NATIVE {CMD_CLEAR}   CONST CMD_CLEAR   = 5
NATIVE {CMD_STOP}    CONST CMD_STOP    = 6
NATIVE {CMD_START}   CONST CMD_START   = 7
NATIVE {CMD_FLUSH}   CONST CMD_FLUSH   = 8
NATIVE {CMD_NONSTD}  CONST CMD_NONSTD  = 9

NATIVE {IOB_QUICK}     CONST IOB_QUICK     = 0
NATIVE {IOF_QUICK} CONST IOF_QUICK = $1
