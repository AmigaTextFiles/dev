#include "ParseBC.h"
#include <string.h>

short ParseBC::ShortTags( void )
{

	if( chcmp( '#' ) ) {
	
		StopCopy();
		
		GetToken();
		if( !TokLen ) return -1;
		
		char buf[50];
		
		StartCopy();
	
	}

	return 0;
}


void CreateFullTag( char *MetAttr, char *clName )
{
	short i;
	for( i = 0; (i < TokLen) && (Tok[i] != '_'); i++ );
			
	if( Tok[i] != '_' ) {
		strcpy( MetAttr, clName );
		i = strlen( clName );
		MetAttr[i] = '_';
		memcpy( MetAttr + i + 1, Tok, TokLen );
		MetAttr[ i+1+TokLen ] = 0;
	} else {
		i = i ? 0 : 1;
		memcpy( MetAttr, Tok + i, TokLen - i );
		MetAttr[ TokLen - i ] = 0;
	}
}