/***************************************************************************
 * WPP_Init.c
 *
 * wpad.library, Copyright ©1995 Lee Kindness.
 *
 * 
 */

#include "wpad_global.h"

BOOL WPP_Init( VOID )
{
	if(SysBase)
		return(TRUE);
	else
	{
		SysBase = *(struct ExecBase **)4;

		if(SysBase -> LibNode . lib_Version < 37)
		{
			SysBase = NULL;

			return(FALSE);
		}
		else
		{

			DOSBase = (struct DosLibrary *)OpenLibrary("dos.library", 37);
			IntuitionBase	= OpenLibrary("intuition.library",37);
			GfxBase = (struct GfxBase *)OpenLibrary("graphics.library",37);
			UtilityBase	= OpenLibrary("utility.library",37);
			GadToolsBase = OpenLibrary("gadtools.library",37);
			DiskfontBase = OpenLibrary("diskfont.library", 0);
			CxBase = OpenLibrary("commodities.library", 37);

			if( DOSBase && 
			    IntuitionBase && 
			    GfxBase && 
			    UtilityBase && 
			    GadToolsBase &&
			    DiskfontBase &&
			    CxBase )
				return(TRUE);
			
			WPP_Exit();

			return(FALSE);
		}
	}
}

