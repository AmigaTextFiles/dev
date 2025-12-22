
#include <exec/libraries.h>
#include <dos/dos.h>

#include <pragma/exec_lib.h>
#include <pragma/dos_lib.h>

struct Library *DOSBase;

void main(void)
{
	APTR mem1,mem2,mem3;
	BPTR f;

	Wait(SIGBREAKF_CTRL_C);

	mem1 = AllocMem(12,0);
	mem2 = AllocMem(32,0);
	mem3 = AllocMem(10,0);

	DOSBase = OpenLibrary("dos.library",37);

	f = Open("test",MODE_NEWFILE);

	if (mem2 != NULL)
		FreeMem(mem2,32);
}
