/***************************************************************************
 * WPP_Exit.c
 *
 * wpad.library, Copyright ©1995 Lee Kindness.
 *
 * 
 */

#include "wpad_global.h"

VOID WPP_Exit( VOID )
{
	if(SysBase)
	{
		CloseLibrary(CxBase);
		CxBase = NULL;

		CloseLibrary(DiskfontBase);
		DiskfontBase = NULL;
		
		CloseLibrary(GadToolsBase);
		GadToolsBase = NULL;

		CloseLibrary(UtilityBase);
		UtilityBase = NULL;

		CloseLibrary(GfxBase);
		GfxBase = NULL;

		CloseLibrary(IntuitionBase);
		IntuitionBase = NULL;

		CloseLibrary(DOSBase);
		DOSBase = NULL;
		
		SysBase = NULL;
	}
}
