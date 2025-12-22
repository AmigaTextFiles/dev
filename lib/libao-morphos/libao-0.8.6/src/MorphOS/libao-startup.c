#include <proto/exec.h>
#include <proto/muimaster.h>
#include <constructor.h>

#define LIBRARY_BASENAME AOBase
#define VERSION 1

void _INIT_4_AOBase(void) __attribute__((alias("__CSTP_init_AOBase")));
void _EXIT_4_AOBase(void) __attribute__((alias("__DSTP_cleanup_AOBase")));

struct Library * LIBRARY_BASENAME ;

STATIC CONST TEXT libname[] = "ao.library";

static CONSTRUCTOR_P(init_AOBase, 100)
{
	LIBRARY_BASENAME = OpenLibrary(libname, VERSION);
	if (!(LIBRARY_BASENAME))
	{
		struct Library *MUIMasterBase = OpenLibrary("muimaster.library", 0);

		if (MUIMasterBase)
		{
			ULONG args[1] = { VERSION };
			MUI_RequestA(NULL, NULL, 0, "Startup message", "Abort", "Need version %.10ld of ao.library", &args);
			CloseLibrary(MUIMasterBase);
		}
	}

	return (LIBRARY_BASENAME == NULL);
}

static DESTRUCTOR_P(cleanup_AOBase, 100)
{
	CloseLibrary(LIBRARY_BASENAME);
}

