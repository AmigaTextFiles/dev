#include <stdio.h>
#include <string.h>
#include "ParseOptions.h"
#include "Global.h"


short ParseOptions::Start( void )
{
 char *fname;
 FILE *fh;
	
	fname = "BCCOptions";
	
	if( fh = fopen( fname, "r" ) ) {
		fclose( fh );
	} else {
		fname = "ENV:bcc/BCCOptions";
	}
	
	if( !Load( fname ) ) return 0;
	
	while( 1 ) {
	
		if( Next() ) break;
		
		if( TokLen == 7 && !strncmp( "deftype", Tok, 7 ) ) {

			if( Next() ) break;
			
			if( TokLen != 3 ) {
				Error( 1 );
				break;
			}
			Prefs.deftype = Prefs.AddText( Tok, TokLen );

		} 

		if( TokLen == 6 && !strncmp( "incdir", Tok, 6 ) ) {

			if( Next() ) break;
			
			if( TokLen < 3 || *Tok != '"' || Tok[TokLen-1] != '"' ) {
				Error( 2 );
				break;
			}
			Prefs.incdir = Prefs.AddText( Tok+1, TokLen-2 );

		} 

		if( TokLen == 7 && !strncmp( "verbose", Tok, 7 ) ) Prefs.verbose = 1;
		if( TokLen == 7 && !strncmp( "bclines", Tok, 7 ) ) Prefs.reallines = 1;
		if( TokLen == 9 && !strncmp( "noversion", Tok, 9 ) ) Prefs.noversion = 1;
		if( TokLen == 10 && !strncmp( "forcetrans", Tok, 10 ) ) Prefs.forcetrans = 1;
		if( TokLen == 8 && !strncmp( "nosaveds", Tok, 8 ) ) Prefs.nosaveds = 1;

		if( TokLen == 7 && !strncmp( "tagbase", Tok, 7 ) ) {
		
			if( Next() ) break;
			if( TokLen != 4 ) {
				Error( 3 );
				break;
			}
			
			short i, f;
			Prefs.tagbase = 0;
			for( i = 0; i < 4; i++ ) {
				Prefs.tagbase <<= 4;
				f = Tok[i];
				if( f >= '0' && f <= '9' ) f -= '0';
				else {
					f &= 0xdf;
					f -= 'A' - 10;
				}
				if( f < 0 || f > 15 ) {
					Error( 3 );
					break;
				}
				Prefs.tagbase |= f;
			}
			
		}

	}

	return 1;

}

static char *errtab[] = {
	"Unknown error",
	"Bad deftype string",
	"Bad incdir parameter",
	"<tagbase> should be four digit hex number"
};

char **ParseOptions::ErrorStrings( void ) { return errtab; }
