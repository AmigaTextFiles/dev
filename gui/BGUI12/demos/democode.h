/*
 *	DEMOCODE.H
 *
 *	(C) Copyright 1995 Jaba Development.
 *	(C) Copyright 1995 Jan van den Baard.
 *	    All Rights Reserved.
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <libraries/gadtools.h>
#include <libraries/bgui.h>
#include <libraries/bgui_macros.h>
#include <intuition/sghooks.h>
#include <graphics/gfxmacros.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>

#include <clib/alib_protos.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/dos.h>
#include <proto/bgui.h>
#include <proto/graphics.h>
#include <proto/diskfont.h>

#include <stdlib.h>

#ifdef _DCC
#define SAVEDS __geta4
#define ASM
#define REG(x) __ ## x
#define CHIP(t) __chip t
#else
#define SAVEDS __saveds
#define ASM __asm
#define REG(x) register __ ## x
#define CHIP(t) t chip
#endif

/*
 *	The entry point of all demo programs.
 */
extern VOID StartDemo( void );

/*
 *	Output file handle and BGUI
 *	library base.
 */
BPTR		StdOut;
struct Library *BGUIBase;

/*
 *	Output text to the CLI or Workbench console.
 */
VOID Tell( UBYTE *fstr, ... )
{
	if ( StdOut ) VFPrintf( StdOut, fstr, ( ULONG * )&fstr + 1 );
}

/*
 *	Main entry point.
 */
int main( int argc, char **argv )
{
	struct Process			*this_task = ( struct Process * )FindTask( NULL );
	BOOL				 is_wb = FALSE;

	if ( this_task->pr_CLI )
		/*
		 *	Started from the CLI. Simply pickup
		 *	the CLI output handle.
		 */
		StdOut = Output();
	else {
		/*
		 *	Workbench startup. Open a console
		 *	for output.
		 */
		StdOut = Open( "CON:10/10/500/100/BGUI Demo Output/WAIT/AUTO", MODE_NEWFILE );
		is_wb = TRUE;
	}

	/*
	 *	Open BGUI.
	 */
	if ( BGUIBase = OpenLibrary( BGUINAME, BGUIVERSION )) {
		/*
		 *	Run the demo.
		 */
		StartDemo();
		CloseLibrary( BGUIBase );
	} else
		Tell( "Unable to open %s version %ld\n", BGUINAME, BGUIVERSION );

	/*
	 *	Close console if ran from
	 *	the workbench.
	 */
	if ( is_wb ) {
		if ( StdOut ) Close( StdOut );
	}

	return( 0 );
}

/*
 *	DICE stub which simply calls
 *	main() when run from the
 *	workbench.
 */
#ifdef _DCC
int wbmain( struct WBStartup *wbs )
{
	return( main( NULL, 0 ));
}
#endif
