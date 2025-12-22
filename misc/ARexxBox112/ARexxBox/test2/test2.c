/*
 * Auto: rx "say 'compiling <path><file>'"
 * Auto: make test2
 * Buto: rx "address 'rexx_ced' 'change current directory' '<path>'"
 *
 */

#include "test2.h"
#include "rx_test2.h"


extern struct Library *SysBase, *DOSBase;
struct Library *IconBase = NULL;
struct Library *RexxSysBase = NULL;
struct RexxHost *myhost = NULL;

struct DiskObject *program_icon = NULL;
char **ttypes = NULL;

char *portname = NULL;


/* Wenn ich die folgenden beiden Funktionen aus der amiga.lib
 * importiere, dann muß ich anscheinend auch die commodities.lib
 * öffnen. Der Grund ist mir schleierhaft, deshalb nehme ich
 * lieber meine eigenen Routinen.
 */

void argArrayDone( void )
{
	if( program_icon )
		FreeDiskObject( program_icon );
}

char **argArrayInit( LONG argc, char **argv )
{
	if( argc )
		return argv;
	
	else
	{
		struct WBStartup *wbs = (struct WBStartup *) argv;
		
		if( program_icon = GetDiskObject((char *) wbs->sm_ArgList->wa_Name) )
			return( (char **) program_icon->do_ToolTypes );
	}
	
	return NULL;
}


void closedown( void )
{
	argArrayDone();
	if( myhost ) CloseDownARexxHost( myhost );
	if( IconBase ) CloseLibrary( IconBase );
	if( RexxSysBase ) CloseLibrary( RexxSysBase );
}


void init( int argc, char *argv[] )
{
	if( !(RexxSysBase = OpenLibrary( "rexxsyslib.library", 35 )) )
		exit( 20 );
	
	if( !(IconBase = OpenLibrary( "icon.library", 37 )) )
		exit( 20 );
	
	if( ttypes = argArrayInit( argc, (char **) argv ) )
	{
		portname = FindToolType( (UBYTE **) ttypes, "PORTNAME" );
	}
}


/* Hauptprogramm */
extern int Enable_Abort;

int main( int argc, char *argv[] )
{
	BPTR fh;

	/* Initialisieren */
	
#ifdef __AZTEC__
	Enable_Abort = 0;
#endif

	atexit( closedown );
	init( argc, argv );
	
	if( !(myhost = SetupARexxHost(portname, NULL)) )
	{
		printf( "No Host\n" );
		return( 20 );
	}
	
	/* Erst eine CommandShell... */
	
	if( fh = Open( "CON:////CommandShell/AUTO", MODE_NEWFILE ) )
	{
		CommandShell( myhost, fh, fh, "test> " );
		Close( fh );
	}
	else
		printf( "No Console\n" );
	
	/* ...und dann 'richtiger' ARexx-Betrieb */
	
	printf( "Address me on Port %s!\n", myhost->portname );
	printf( "Cancel me with CTRL-C\n" );
	
	while( 1 )
	{
		long s = Wait( SIGBREAKF_CTRL_C | (1L<<myhost->port->mp_SigBit) );
		
		if( s & SIGBREAKF_CTRL_C )
		{
			if( myhost->flags & ARB_HF_CMDSHELL )
				printf( "can't quit, commandshell still open!\n" );
			else
				break;
		}
		
		if( s & (1L<<myhost->port->mp_SigBit) )
		{
			ARexxDispatch( myhost );
		}
	}
	
	return( 0 );
}
