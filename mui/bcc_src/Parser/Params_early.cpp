#include "ParseBC.h"

short ParseBC::Params( void )
{

	short CLevel = CBracket;
			
	GetToken();
	if( !TokLen ) return 0;
			
	if( !chcmp( '(' ) ) {
		Error( 5 );
		return -1;
	}

	InitClassPtrDef();
	
	/* Parameters */

	StartCopy();
		
	short c_line, tok_c = 0, cnt = 0, first = 1;
			
	c_line = LineN;
		
	while( 1 ) {
	
		GetToken();
		if( !TokLen ) return -1;
				
		if( c_line != LineN ) {
			Error( 21 );
			return -1;
		}
				
		short ret;
		ret = ClassPtrDefinition( &clref, 1, 1 );
		if( ret == -1 ) return -1;

		if( chcmp( ',' ) || (chcmp( ')' ) && CBracket == CLevel) ) {

			StopCopy();

			if( !tok_c ) {
				if( chcmp( ')' ) && !cnt ) break;
				Error( 13 );
				return -1;
			}
			
			cnt++;
			
			String Buf( "(msg->" );
			Buf +=  PrevTok;
			Buf +=  ")";
			reppar.Add( PrevTok, 0, (char*)Buf, 0 );
			
			fprintf( ofh, ";" );

			if( chcmp( ')' ) ) break;
			
			StartCopy();
			tok_c = 0;
		
		}
		
		tok_c++;

		if( first ) {
			fprintf( ofh, "struct { unsigned long MethodID; " );
			first = 0;
		}
		
	}
	
	if( cnt ) fprintf( ofh, " } *msg" );
			
	return (cnt ? 1 : 0);
}


short ParseBC::EarlyCode( void )
{

	short sbrc = SBracket;

	GetToken();
	if( !TokLen ) return -1;

	if( chcmp( '[' ) ) {
		InitClassPtrDef();
		StartCopy();
		while( 1 ) {

			GetToken();
			if( !TokLen ) return -1;
			
			if( chcmp( ']' ) && sbrc == SBracket ) break;

			if( ClassPtrDefinition( &clref ) == -1 ) return -1;
			
		}
		StopCopy();

		GetToken();
		if( !TokLen ) return -1;

	}

}