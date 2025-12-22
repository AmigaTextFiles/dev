#include "parsefile.h"
#include "global.h"
#include "ClassDef.h"
#include "Replace.h"
#include "MethodDef.h"
#include "VarDef.h"
#include "ParseBC.h"
#include <string.h>

short ParseBC::RefCheck( Replace *r )
{
  char *clName, clType[4];
  char *rn;

	if( (clName = r->Check( Tok, TokLen )) && !ForbidCheck() ) {
	
		memcpy( clType, clName, 3 );
		clType[3] = 0;
		clName += 3;
	
		String VarName( Tok, TokLen );
		
		rn = cd ? cd->rep.Check( (char*)VarName, 0 ) : 0;
		if( !rn ) rn = reppar.Check( (char*)VarName, 0 );
		if( !rn ) rn = (char*)VarName;
		
		StartSurvey();
		
		GetToken();
		if( !TokLen ) return -1;
		
		short isref = (TokLen == 2 && !strncmp( Tok, "->", 2 ));
		
		StopSurvey();
		
		if( isref ) {
		
			StopCopy();
		
			GetToken();
			if( !TokLen ) return -1;

			GetToken();
			if( !TokLen ) return -1;

			if( TokType != ALN ) {
				Error( 4 );
				return -1;
			}
			
			String MetAttr;
			
			short i;
			for( i = 0; (i < TokLen) && (Tok[i] != '_'); i++ );
			
			if( Tok[i] != '_' ) {
				MetAttr = clName;;
				MetAttr += "_";
				String ps( Tok, TokLen );
				MetAttr += (char*)ps;
			} else {
				i = i ? 0 : 1;
				MetAttr.Copy( Tok + i, TokLen - i );
			}

			short CLevel = CBracket;

			GetToken();
			if( !TokLen ) return -1;
			
			if( chcmp( '(' ) ) {

				fprintf( ofh, "DoMethod( %s, %sM_%s", rn, clType, (char*)MetAttr );
			
				StartCopy();
				
				short first = 1;
				
				while( 1 ) {

					GetToken();
					if( !TokLen ) return -1;

					if( chcmp( ')' ) && CBracket == CLevel ) break;
					if( first ) { first = 0; fprintf( ofh, ", " ); }

					short rcr;
					rcr = FullCheck( );
					if( rcr == -1 ) return -1;
				
					if( chcmp( ')' ) && CBracket == CLevel ) break;
					
				}
				
	
				return 1;
			}

			if( chcmp( '=' ) ) {

				fprintf( ofh, "BCC_Set( %s, %sA_%s, ",  rn, clType, (char*)MetAttr );
				StartCopy();

				while( 1 ) {

					GetToken();
					if( !TokLen ) return -1;

					short rcr;
					rcr = FullCheck( );
					if( rcr == -1 ) return -1;
				
					if( chcmp( ';' ) ) break;

				}
				
				StopCopy();
				fprintf( ofh, " );" );
				StartCopy();
				
				return 1;
			}
				

			fprintf( ofh, "BCC_XGet( %s, %sA_%s )", rn, clType, (char*)MetAttr );
			FastStartCopy();
					
			return 1;
				
		} else {
			return 0;
		}
		
	}
  
  return 0;
}


short ParseFile::ClassPtrDefinition( Replace *rep, short write, short once )
{

	SetCType( write );
	
	switch( crcont ) {
		case 0:
			if( (TokLen == 5) && !strncmp( Tok, "Class", 5 ) && !ForbidCheck()) {

				if( write ) {
					StopCopy();
					StartCopy();
					fprintf( ofh, "Object" );
				}
				
				crcont = 1;
				
				return 1;

			}
			
			break;
		
		case 1:
		
			if( TokType != ALN ) {
				Error( 18 );
				return -1;
			}

			if( write ) {
				StopCopy();
				StartCopy();
			}
		
			strcpy( crClName, ctype );
			memcpy( crClName+3, Tok, TokLen );
			crClName[TokLen+3] = 0;

			crcont = 2;

			return 1;
			
		case 2:
				
			if( !chcmp( '*' ) ) {
				Error( 15 );
				return -1;
			}
			
			crcont = 3;
			
			return 1;
			
		case 3:

			if( TokType != ALN ) {
				Error( 4 );
				return -1;
			}
			
			rep->Add( Tok, TokLen, crClName, 0 );
			
			if( once ) crcont = 0;
			else crcont = 4;
			
			return 1;
			
		case 4:
	
			if( chcmp( ';' ) ) crcont = 0;
			else {
				if( chcmp( ',' ) ) crcont = 2;
				else return -1;
			}

			return 1;
		
	}
	
	return 0;


}

void ParseFile::SetCType( short write )
{
	if( TokType == ALN && TokLen == 3 ) {
		if( !strncmp( "MUI", Tok, 3 ) ) {
				ctype = "MUI";
				if( write ) { StopCopy();	StartCopy(); }
				return;
		} else
		if( !strncmp( "BOP", Tok, 3 ) ) {
				ctype = "BOP";
				if( write ) { StopCopy();	StartCopy(); }
				return;
		} 
	}
	ctype = Prefs.deftype;
}

