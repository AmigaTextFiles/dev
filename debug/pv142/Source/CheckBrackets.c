/* Routine to check brackets on the PowerVisor commandline

Compile with :
	lc -v -cmsw -O CheckBrackets
	blink CheckBrackets.o to CheckBrackets lib pv:pvdevelop/lib/PVCallStub.lib
*/


#include <exec/types.h>
#include "pv:PVDevelop/include/PV/screenbase.h"
#include "pv:PVDevelop/include/PV/pvcallroutines.h"
#include <pragmas/exec.h>
#include <string.h>

APTR PVCallTable;

int __saveds __asm Bracket (register __a0 char *cmdline, register __a2 APTR table[])
{
	char *p,t,o;
	struct StringInfo *si;
	int i,d,l,found;

	PVCallTable = table;

	p = PVCGetStringGBuf ();
	si = PVCGetStringInfo ();

	i = si->BufferPos;

	switch (t = p[i])
		{
			case '(' : o = ')'; d= 1; break;
			case ')' : o = '('; d=-1; break;
			case '{' : o = '}'; d= 1; break;
			case '}' : o = '{'; d=-1; break;
			case '[' : o = ']'; d= 1; break;
			case ']' : o = '['; d=-1; break;
			default  : return;
		}

	i += d;
	l = 1;
	found = -1;
	while (i >= 0 && i <= si->NumChars)
		{
			if (p[i] == t) l++;
			else if (p[i] == o) l--;
			if (!l)
				{
					found = i;
					i = -2;
				}
			else i += d;
		}

	if (found >= 0) si->BufferPos = found;

	PVCRefreshStringG ();
}
