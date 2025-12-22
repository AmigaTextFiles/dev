#include "ParseBC.h"
#include <string.h>

char *ParseBC::FindRef( void )
{
	char *ret;
	if( ret = clref.Check( Tok, TokLen ) ) return ret;
	if( cd && (ret = cd->clref.Check( Tok, TokLen )) ) return ret;
	short f;
	for( f = 0; f < BCC_block_cnt; f++ ) 
		if( ret = BCC_block[f].rep->Check( Tok, TokLen ) ) return ret;

	Error( 19 );
		
	return 0;
}

short ParseBC::NewDelCheck( void )
{
	if( TokType == ALN ) {
	
		if( TokLen == 6 && !strncmp( "Delete", Tok, 6 ) && !ForbidCheck() ) {
		
			StopCopy();
			StartCopy();

			GetToken();
			if( !TokLen ) return -1;
			
			char *ret;
			ret = FindRef();
			if( !ret ) return -1;

			switch( *ret ) {
				case 'B':
					fprintf( ofh, "DisposeObject( " );
					break;
		
				default:
					fprintf( ofh, "MUI_DisposeObject( " );
			}

			FullCheck();
			
			GetToken();
			if( !TokLen ) return -1;
			
			if( !chcmp( ';' ) ) {
				Error( 3 );
				return -1;
			}

			fprintf( ofh, " )" );
			return 1;

		} else
		if( TokLen == 3 && !strncmp( "New", Tok, 3 ) && !ForbidCheck() ) {

			StopCopy();

			GetToken();
			if( !TokLen ) return -1;
			
			String rname( Tok, TokLen );
				
			fprintf( ofh, "%sObject, ", (char*)rname );

			short brc = CBracket;

			GetToken();
			if( !TokLen ) return -1;
			
			if( !chcmp( '(' ) ) {
				Error( 5 );
				return -1;
			}

			StartCopy();
	
			while( 1 ) {

				GetToken();
				if( !TokLen ) return -1;
			
				if( chcmp( ')' ) && brc == CBracket ) break;

				FullCheck();
			
			}
			
			StopCopy();
			
			fprintf( ofh, ",End" );
				
			StartCopy();
		}
	
	}

  return 0;
}
