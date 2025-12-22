/* Routine to copy the contents of the memory given on the commandline
	to the active logical window

Compile with (SAS/C) :
	lc -v -cmsw -O GetLogWin
	blink GetLogWin.o to GetLogWin lib pv:pvdevelop/lib/PVCallStub.lib
*/



#include <exec/types.h>
#include "pv:PVDevelop/include/PV/screenbase.h"
#include "pv:PVDevelop/include/PV/pvcallroutines.h"
#include <pragmas/exec.h>
#include <pragmas/keymap.h>
#include <string.h>

APTR PVCallTable;

int __saveds __asm GetLogWin (register __a0 char *cmdline, register __a2 APTR table[])
{
	struct ScreenBase *ScreenBase;
	struct LogicalWindow *ActiveLogWin;
	PVBLOCK block;
	WORD CCols,CLines,Cols,Lines,i,j;
	APTR *buf;

	PVCallTable = table;

	ScreenBase = PVCGetScreenBase ();

	ActiveLogWin = ScreenBase->TheGlobal->ActiveLogWin;
	block = (PVBLOCK)PVCEvaluate (cmdline);

	CLines = *(UWORD *)block;
	Lines = ActiveLogWin->NrLinesInBuf;
	CCols = *(((UWORD *)block)+1);
	Cols = ActiveLogWin->NrColsInLine;
	buf = (APTR *)(ActiveLogWin->Buffer);

	Cols++; CCols++;	/* Attribute */

	for (i=0 ; i<Lines && i<CLines ; i++)
		if (buf[i])
			for (j=0 ; j<Cols && j<CCols ; j++)
				((UBYTE *)buf[i])[j] = *(((UBYTE *)block)+4+i*CCols+j);
	PVCRefreshLogWin (ActiveLogWin);
}
