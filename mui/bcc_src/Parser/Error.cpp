#include "FParse.h"
#include <stdio.h>


void FParse::Error( short num )
{

	printf( "%s %ld Error %hd: %s\n", (char*)Name, (long)LineN, num, ErrorStrings()[ num ] );
	
	if( Tok ) {
		char *p;
		for( p = Tok; p > Data && *p != 10; p-- );
		if( p != Data ) p++;
		char *e;
		for( e = Tok; e < Data+Len && *e != 10; e++ );
		if( *e == 10 ) e--;
		String errline( p, (short)(e-p+1) );
		printf( "%s\n", (char*)errline );
		short f;
		for( f = 0; f< Tok-p; f++ ) {
			if( ((char*)errline)[f] == 9 ) printf( "	" );
			else printf( " " );
		}
		printf( "^\n\n" );
	}

	ErrorBuf = num;

}



