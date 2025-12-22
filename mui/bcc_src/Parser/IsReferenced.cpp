#include "ParseBC.h"


short ParseBC::IsReferenced( char *s, Replace *rep, short endmode )
{
 short ret = 0, l;

	StartSurvey();
	
	l = strlen( s );
	
	short Level = MBracket;
	
	
	while( 1 ) {
		GetToken();
		if( !TokLen ) goto end;


		if( TokLen == l && !strncmp( s, Tok, l ) && !ForbidCheck() ) {
			ret = 1;
			break;
		}
		if( rep && rep->Check( Tok, TokLen ) && !ForbidCheck() ) {
			ret = 1;
			break;
		}
			

		if( endmode == 0 && chcmp( '}' ) && MBracket == Level ) break;
		if( endmode == 1 && chcmp( '{' ) ) break;
		
	}


end:
	StopSurvey();
 
 return ret;

}
