
/* TdDBase.Library Autoopen and Autoclose functions for SAS/C */

#include <proto/exec.h> 
#include <constructor.h>

void __regargs __autoopenfail(char *);

struct Library *TdDBase;
static void *libbase;

/* Define this in your program if you wish to open a specific version */
extern long __tddbasever;

extern long __oslibversion;

CBMLIB_CONSTRUCTOR(opentddbase)
{
	TdDBase = libbase = 
		(void *)OpenLibrary("tddbase.library", __tddbasever);


	/* now, WHY doesnt OpenLibrary check these 2 places also? */
	if(TdDBase == NULL)
		TdDBase = libbase = 
           (void *)OpenLibrary("PROGDIR:tddbase.library", __tddbasever);

	if(TdDBase == NULL)
		TdDBase = libbase = 
			(void *)OpenLibrary("PROGDIR:libs/tddbase.library", __tddbasever);

	if(TdDBase == NULL)
	{
		/* This is necesery if we want autoopenfail to report right version */
		__oslibversion=__tddbasever;
		__autoopenfail("tddbase.library");
		return 1;
	}

	return 0;
}

CBMLIB_DESTRUCTOR(closetddbase)
{
   if(libbase)
   {
      CloseLibrary((struct Library *)libbase);
      libbase = TdDBase = NULL;
   }
}
