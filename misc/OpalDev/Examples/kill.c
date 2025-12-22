#include "opal/opallib.h"
#include <stdlib.h>

#ifndef	AZTEC_C
#include <proto/all.h>
#endif

struct OpalBase *OpalBase;


main()
{
	OpalBase = (struct OpalBase *) OpenLibrary ("opal.library",0L);
	if (OpalBase==NULL) exit (10);
	CloseScreen24();
	CloseLibrary ((struct Library *)OpalBase);
}
