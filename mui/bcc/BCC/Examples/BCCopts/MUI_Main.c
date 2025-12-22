#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/lowlevel.h>

#include "initcl.h"
#include "App.h"

#include <libraries/bcc.h>

struct Library *MUIMasterBase;
Object *app;

extern ULONG __stack = 10000;
extern ULONG __OSlibversion = 36;

main()
{
	int running = TRUE, ret = RETURN_OK;
	ULONG signals;
	
	if( MUIMasterBase = OpenLibrary( MUIMASTER_NAME, MUIMASTER_VMIN ) ) {
		if( _initclasses() ) {
			if( app = AppObject, End ) {
 
				while (running)
				{
					switch( DoMethod( app, MUIM_Application_Input, &signals ) ) {
						case MUIV_Application_ReturnID_Quit:
							running = FALSE;
							break;
					}
				
					if( running && signals ) Wait( signals );

				}
				MUI_DisposeObject( app );
			}
			_freeclasses();
		} else ret = RETURN_ERROR;
		CloseLibrary( MUIMasterBase );
	} else ret = RETURN_ERROR;
	
	return ret;
}
