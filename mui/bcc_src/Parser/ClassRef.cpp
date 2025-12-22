#include "parsefile.h"
#include "global.h"
#include "ClassDef.h"


short ParseFile::ClassDCheck( void )
{
 ClassDef *cd;

	if( (TokType == ALN) && (cd = (ClassDef*)ClassList.FindItem( Tok, TokLen ) ) ) {
	
		StopCopy();
		fprintf( ofh, "Object" );
		StartCopy();
		
		while( 1 ) {
		
			GetToken();
			if( !TokLen ) return 0;
			
			if( !chcmp( '*' ) ) {
				Error( 15 );
				return 0;
			}

			GetToken();
			if( !TokLen ) return 0;
			
			if( TokType != ALN ) {
				Error( 4 );
				return 0;
			}

			GetToken();
			if( !TokLen ) return 0;

			if( chcmp( ';' ) ) break;
			
			if( !chcmp( ',' ) ) {
				Error( 16 );
				return 0;
			}
		
		}
	
	}

 return 1;
}
