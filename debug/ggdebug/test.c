#include <proto/exec.h>
#include <proto/ggdebug.h>
#include <proto/dos.h>

struct Library *GGDebugBase;

void main(void)
{
	if(GGDebugBase=OpenLibrary("ggdebug.library",0L))
	{
		LONG args[3],i;

		PutStr("This small program tests ggdebug.library, you need\nsushi/sashimi or a serial terminal to see the output.\n");
		KPrintf("KPrintf test: %s %s %ld %s\n","ciao", "come", 11, "va?");
		KPutStr("KPutStr test...\n");

		args[0]=(LONG) "Ciao!";
		args[1]=1234;
		args[2]=NULL;

		VKPrintf("VKPrintf test: %s %ld\nKPutChar test: ",args);

		for(i=0;i<5;i++)
		{
			KPutChar('a'+i);
		}

		KPutStr("\n");

		PutStr("Test completed.\n");

		CloseLibrary(GGDebugBase);
	}
	else PutStr("Unable to open the library!\n");
}
