#include "ParseBH.h"
#include <string.h>
#include <ctype.h>

void ParseBH::IfDefBeg( void )
{

 unsigned char *p;
 
 String def( (char*)ofname );
 
 for( p = (char*)def; *p; p++ ) {
 	if( *p == '.' ) *p = '_';
 	else if( isalpha( *p ) ) *p &= 0xdf;
 }
 
 fprintf( ofh, "#ifndef %s\n#define %s\n\n", (char*)def, (char*)def );

}

void ParseBH::IfDefEnd( void )
{
	fprintf( ofh, "\n#endif\n" );
}

