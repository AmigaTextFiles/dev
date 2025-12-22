
#include <utility/utility.h>
#include <proto/exec.h>
#include <proto/utility.h>
#include <proto/dos.h>

#include <stdlib.h>
#include <stdio.h>

#include "SSProcLib_protos.h"

struct Library *DosBase = NULL;
struct Library *UtilityBase = NULL;

void printtoto(void *pm_arg);

int main(void)
{
	printf("main() : entry\n");

	// -------------------
	// Open Libraries
	// -------------------
	DosBase = OpenLibrary(DOSNAME, 0);
	if(DosBase == NULL) exit(EXIT_FAILURE);
	UtilityBase = OpenLibrary(UTILITYNAME, 0);
	if(UtilityBase == NULL)
	{
		if(DosBase != NULL) CloseLibrary(DosBase);
		exit(EXIT_FAILURE);
	}

	// -------------------
	// Test SSProc
	// -------------------
	if(ssproc_Init() == 0)
	{
		struct TagItem tags[3];
		tags[0].ti_Tag  = SSPT_STACK;
		tags[0].ti_Data = 132000;//0
		tags[1].ti_Tag  = SSPT_PRIORITY;
		tags[1].ti_Data = -10;//+10;
		tags[2].ti_Tag  = TAG_DONE;
		tags[2].ti_Data = 0;
		CreateProcessExe(/*"golded:golded"*/"scout", /*"toto"*/"", tags);
		CreateProcessFunc(printtoto, (void*)2, tags);

		ssproc_End();
	}

	// -------------------
	// Release libraries
	// -------------------
	if(DosBase != NULL) 	CloseLibrary(DosBase);
	if(UtilityBase != NULL)	CloseLibrary(UtilityBase);

	printf("main() : exit\n");

	exit(EXIT_SUCCESS);
}

void printtoto(void *pm_arg)
{
	Printf("toto %ld\n", (long)pm_arg);
	Delay(500);
}
