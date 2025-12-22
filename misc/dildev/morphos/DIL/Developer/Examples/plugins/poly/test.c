
#define __NOLIBBASE__

#include <exec/exec.h>
#include <dos/dos.h>
#include <libraries/dilplugin.h>
#include <utility/tagitem.h>

#include <proto/alib.h>
#include <proto/debug.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/dilplugin.h>
#include <proto/utility.h>

//-----------------------------------------------------------------------------

struct ExecBase *SysBase = NULL;
struct DosLibrary *DOSBase = NULL;
struct Library *UtilityBase = NULL;
struct DILPluginBase *DILPluginBase = NULL;

//-----------------------------------------------------------------------------

int main(void)
{
	struct Library *lib;

	SysBase = *(APTR *)4l;
	if ((DOSBase = (struct DosLibrary *)OpenLibrary(DOSNAME, 37)))
	{
		if ((UtilityBase = OpenLibrary("utility.library", 37l)))
		{
			if ((DILPluginBase = (struct DILPluginBase *)OpenLibrary("LIBS:DIL/poly.dilp", 1l)))
			{
				struct TagItem *ti = dilGetInfo();
		
				Printf("Ok\n");
				//Printf("--> '%s'\n", (UBYTE *)GetTagData(DILP_Updates, (ULONG)"---", ti));
		
				CloseLibrary((struct Library *)DILPluginBase);

			} else Printf("Fail\n");

			Forbid();
			if ((lib = (struct Library *)FindName(&SysBase->LibList, "poly.dilp")))
				RemLibrary(lib);
			Permit();

			CloseLibrary(UtilityBase);
		}
		CloseLibrary((struct Library *)DOSBase);
	}
	return 0;
}

#ifdef __MORPHOS__
void exit(int rc) {}
#endif

//-----------------------------------------------------------------------------
















