/* Routine to get the named qualifier value

Compile with :
	lc -v -cmsw -O GetQual
	blink GetQual.o to GetQual lib pv:pvdevelop/lib/PVCallStub.lib
*/


#include <exec/types.h>
#include "pv:PVDevelop/include/PV/pvcallroutines.h"
#include <pragmas/exec.h>
#include <pragmas/keymap.h>
#include <string.h>

APTR PVCallTable;

struct myQual
	{
		char *str;
		UWORD qual;
	};

struct myQual Quals[] =
	{
		"lshift",	0x1,
		"rshift",	0x2,
		"ctrl",		0x8,
		"lalt",		0x10,
		"ralt",		0x20,
		"lcmd",		0x40,
		"rcmd",		0x80,
		NULL,			0
	};


int __saveds __asm Qual (register __a0 char *cmdline, register __a2 APTR table[])
{
	char *p;
	struct myQual *mq;

	PVCallTable = table;

	p = PVCParseString (cmdline);

	mq = Quals;
	while (mq->str)
		{
			if (!strcmp (mq->str,p)) return ((int)(mq->qual));
			mq++;
		}

	return (0);
}
