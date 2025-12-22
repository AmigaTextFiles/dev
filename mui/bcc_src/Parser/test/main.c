#include <proto/exec.h>
#include <proto/muimaster.h>
#include <proto/intuition.h>

#include <libraries/mui.h>

#include "initcl.h"
#include "MyApplication.h"

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

struct Library *MUIMasterBase;

/*extern ULONG __stack = 10000;
extern ULONG __OSlibversion = 36;*/

short SetApp( void );


Object *app, *win;

main()
{
	ULONG running = TRUE, ret = RETURN_OK;
	ULONG sigs = 0;
	
	if( MUIMasterBase = OpenLibrary( MUIMASTER_NAME, MUIMASTER_VMIN) ) {
		if( _initclasses() && SetApp() ) {

		   while( DoMethod( app, MUIM_Application_NewInput, &sigs )
		          != MUIV_Application_ReturnID_Quit ) {
		      if( sigs ) {
		         sigs = Wait( sigs | SIGBREAKF_CTRL_C );
		         if( sigs & SIGBREAKF_CTRL_C ) break;
	   	   }
		   }

		} else ret = RETURN_ERROR;
		MUI_DisposeObject( app );
		_freeclasses();

		CloseLibrary( MUIMasterBase );
	} else ret = RETURN_ERROR;
	
	return ret;
}


short SetApp( void )
{

	app = MyApplicationObject,
	End;

	if( !app ) return 0;

	
	return 1;

}
