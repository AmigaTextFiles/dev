
/*********************************************************************
----------------------------------------------------------------------

	global

----------------------------------------------------------------------
*********************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>

#include <exec/memory.h>
#include <proto/exec.h>

#include "defs.h"


static char versionstring[] = "$VER: " PROGNAME " " __VERSION__ "";

struct Library *MysticBase = NULL;
struct Library *GuiGFXBase = NULL;

static APTR MainPool = NULL;

static LONG alloccount = 0;
static LONG allocbytes = 0;


/*********************************************************************
----------------------------------------------------------------------

	InitGlobal()
	CloseGlobal()

----------------------------------------------------------------------
*********************************************************************/

void CloseGlobal(void)
{
	CloseLibrary(GuiGFXBase);
	GuiGFXBase = NULL;

	CloseLibrary(MysticBase);
	MysticBase = NULL;

	if (MainPool)
	{
		if (alloccount > 0 && allocbytes > 0)
		{
			printf("*** internal memory leak detected - %ld allocations (%ld bytes) pending.\n", alloccount, allocbytes);
			printf("*** don't worry: the memory will be returned to the system.\n");
		}
		else if (alloccount < 0 || allocbytes < 0)
		{
			printf("*** warning: pool memory structure might be corrupt.\n");
			if (alloccount < 0 && allocbytes < 0)
			{
				printf("*** more memory has been freed than allocated (%ld allocations, %ld bytes).\n", -alloccount, -allocbytes);
			}
		}

		DeletePool(MainPool);
		MainPool = NULL;

	}
}



BOOL InitGlobal(void)
{
	BOOL success = FALSE;

	MainPool = CreatePool(MEMF_FAST, POOLPUDSIZE, POOLTHRESHOLD);
	if (!MainPool)
	{
		MainPool = CreatePool(MEMF_ANY, POOLPUDSIZE, POOLTHRESHOLD);
	}

	GuiGFXBase = OpenLibrary("guigfx.library", GUIGFX_VERSION);

	MysticBase = OpenLibrary("mysticview.library", MYSTIC_VERSION);



	if (MysticBase && GuiGFXBase && MainPool)
	{
		success = TRUE;
	}

	if (!success)
	{
		CloseGlobal();
	}

	return success;
}





/*********************************************************************
----------------------------------------------------------------------

	wrapped memory management
	(implements simple allocation tracker)

	Malloc()
	Malloclear()
	Free()

----------------------------------------------------------------------
*********************************************************************/


void *Malloc(unsigned long size)
{
	ULONG *buf;

	if (buf = AllocPooled(MainPool, size + sizeof(ULONG)))
	{
		*buf++ = size;

		alloccount++;
		allocbytes += size + sizeof(ULONG);
	}

	return (void *) buf;
}


void *Malloclear(unsigned long size)
{
	ULONG *buf;

	if (buf = AllocPooled(MainPool, size + sizeof(ULONG)))
	{
		*buf++ = size;

		memset(buf, 0, size);

		alloccount++;
		allocbytes += size + sizeof(ULONG);
	}

	return (void *) buf;
}


void Free(void *mem)
{
	if (mem)
	{
		ULONG *buf = (ULONG *) mem;

		--buf;

		alloccount--;
		allocbytes -= *buf + sizeof(ULONG);

		FreePooled(MainPool, buf, *buf + sizeof(ULONG));
	}
}
