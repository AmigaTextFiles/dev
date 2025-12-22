#include "InsertFile.h"
#include "Global.h"
#include <stdlib.h>
#include <string.h>

short InsertFile::Insert( FILE *fh )
{

	if( !data ) Load();
	
	if( !data || !size ) return 0;
	
	if( fwrite( data, 1, size, fh ) != size ) {
		printf( "IO Error\n" );
		return 0;
	}

	return 1;

}

void InsertFile::Free( void )
{

	if( data ) {
		free( data );
		data = 0;
	}
	
}

void InsertFile::Load( void )
{
 FILE *fh;
 
 if( data ) Free();

	if( !(fh = fopen( fname, "r" )) ) {
		char aname[ 30 ];
		strcpy( aname, Prefs.incdir );
		strcpy( aname+strlen( aname ), fname );
		if( !(fh = fopen( aname, "r" )) ) return;
	}
	
	if( fseek( fh, 0, SEEK_END ) ) return;
	
	size = ftell( fh );
	if( !size ) return;
	
	rewind( fh );
	
	if( data = malloc( size ) ) {
 		fread( data, 1, size, fh );
 	}
	
 	fclose( fh );

}
