/**************************************************************************** 

$Source: MASTER:include/clib/cpu_protos.h,v $
$Revision: 3.1 $
$Date: 1994/06/28 07:02:04 $

Prototypes for public functions of a cpu.resource.  This file is
expected to be included indirectly via <proto/cpu.h>, and/or the include
for a specific CPU board.

****************************************************************************/

char *AllocCPUResource(ULONG rescode, char *name);
void FreeCPUResource(ULONG rescode);
void SetSerialSettings(UBYTE port, struct SerialSettings *settings);
void GetSerialSettings(UBYTE port, struct SerialSettings *settings);
void CPU_PutChar(BYTE port, UBYTE b);
BOOL CPU_ReadChar(BYTE port, UBYTE *b);
UBYTE CPU_GetChar(BYTE port);
