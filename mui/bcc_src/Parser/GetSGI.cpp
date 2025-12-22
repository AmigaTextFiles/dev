#include "ParseFile.h"
#include "VarDef.h"

short ParseFile::GetSGI( unsigned short *sw )
{
	short i;
	
	if( chcmp( ':' ) && PrevTok[ 0 ] ) {

		GetToken();
		if( !TokLen ) return -1;

		if( TokType != ALN || TokLen > 3 ) {
			Error( 9 );
			return -1;
		}
		
		for( i = 0; i < TokLen; i++ ) {
			switch( Tok[i] ) {
				case 'S': *sw |= SW_SET; break;
				case 'G': *sw |= SW_GET; break;
				case 'I': *sw |= SW_INIT; break;
				default:
					Error( 9 );
					return -1;
			}
		}	

		GetToken();
		if( !TokLen ) return -1;
		
		return 1;
	}
	return 0;

}

