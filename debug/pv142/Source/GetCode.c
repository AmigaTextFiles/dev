/* Routine to get the code for a named key
	Works best in AmigaDOS 2.0
	In AmigaDOS 1.3 only special keys (like 'enter', 'esc', 'up', ...) work

Compile with :
	lc -v -cmsw -O GetCode
	blink GetCode.o to GetCode lib pv:pvdevelop/lib/PVCallStub.lib
*/



#include <exec/types.h>
#include "pv:PVDevelop/include/PV/pvcallroutines.h"
#include <pragmas/exec.h>
#include <pragmas/keymap.h>
#include <string.h>

APTR PVCallTable;

struct myCode
	{
		char *str;
		UWORD code;
	};

struct myCode Codes[] =
	{
		"f1",			0x50,
		"f2",			0x51,
		"f3",			0x52,
		"f4",			0x53,
		"f5",			0x54,
		"f6",			0x55,
		"f7",			0x56,
		"f8",			0x57,
		"f9",			0x58,
		"f10",		0x59,
		"esc",		0x45,
		"enter",	0x43,
		"ret",		0x44,
		"up",			0x4c,
		"down",		0x4d,
		"right",	0x4e,
		"left",		0x4f,
		"del",		0x46,
		"help",		0x5f,
		"tab",		0x42,
		"numl",		0x5a,
		"scrl",		0x5b,
		"prtsc",	0x5d,
		"home",		0x3d,
		"end",		0x1d,
		"nup",		0x3e,
		"nleft",	0x2d,
		"nright",	0x2f,
		"ndown",	0x1e,
		"pgup",		0x3f,
		"pgdn",		0x1f,
		"ins",		0x0f,
		"ndel",		0x3c,
		NULL,			0
	};


int __saveds __asm Code (register __a0 char *cmdline, register __a2 APTR table[])
{
	struct Library *KeymapBase;
	char codequal[3],*p;
	struct myCode *mc;

	PVCallTable = table;

	p = PVCParseString (cmdline);

	mc = Codes;
	while (mc->str)
		{
			if (!strcmp (mc->str,p))
				{
					return ((int)(mc->code));
					break;
				}
			mc++;
		}

	KeymapBase = (struct Library *)OpenLibrary ("keymap.library",0);
	if (KeymapBase)
		{
			MapANSI (p,1,codequal,1,NULL);
			CloseLibrary (KeymapBase);
			return ((int)codequal[0]);
		}
	else return (0);
}
