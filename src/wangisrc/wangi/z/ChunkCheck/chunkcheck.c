#include <exec/types.h>
#include <graphics/gfxbase.h>
#include <proto/exec.h>
#include <proto/graphics.h>
#include <proto/dos.h>

void main( void )
{
	if( (GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 0)) &&
	    (DOSBase->dl_lib.lib_Version >= 36) )
	{
		Printf("You have graphics.library version %ld.%ld\n", GfxBase->LibNode.lib_Version,
		                                                      GfxBase->LibNode.lib_Revision);
		if( GfxBase->LibNode.lib_Version >= 40 )
			Printf("You have software chunky->planer support\n");
		else
			Printf("You do not have OS software chunky->planer support\n");
		
		if( GfxBase->ChunkyToPlanarPtr )
			Printf("You have hardware chunky->planer support (at 0x%lx)\n", GfxBase->ChunkyToPlanarPtr);
		else
			Printf("You do not have hardware chunky->planer support\n");
		
		CloseLibrary((struct Library *)GfxBase);
	}
}

