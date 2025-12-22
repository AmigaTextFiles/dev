/* Routine to copy the contents of the active logical window to the
	memory given on the commandline

Compile with (SAS/C) :
	lc -v -cmsw -O CopyLogWin
	blink CopyLogWin.o to CopyLogWin lib pv:pvdevelop/lib/PVCallStub.lib
*/



#include <exec/types.h>
#include "pv:PVDevelop/include/PV/screenbase.h"
#include "pv:PVDevelop/include/PV/pvcallroutines.h"
#include <pragmas/exec.h>
#include <pragmas/keymap.h>
#include <string.h>

APTR PVCallTable;

int __saveds __asm CopyLogWin (register __a0 char *cmdline, register __a2 APTR table[])
{
	struct ScreenBase *ScreenBase;
	struct LogicalWindow *ActiveLogWin;
	PVBLOCK block;
	WORD Cols,Lines,i,j;
	APTR *buf;

	PVCallTable = table;

	ScreenBase = PVCGetScreenBase ();

	ActiveLogWin = ScreenBase->TheGlobal->ActiveLogWin;
	block = (PVBLOCK)PVCEvaluate (cmdline);

	*(UWORD *)block = Lines = ActiveLogWin->NrLinesInBuf;
	*(((UWORD *)block)+1) = Cols = ActiveLogWin->NrColsInLine;
	buf = (APTR *)(ActiveLogWin->Buffer);

	Cols++;	/* Attribute */

	for (i=0 ; i<Lines ; i++)
		if (buf[i])
			for (j=0 ; j<Cols ; j++)
				*(((UBYTE *)block)+4+i*Cols+j) = ((UBYTE *)buf[i])[j];
}
