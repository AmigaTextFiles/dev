#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ParseBH.h"
#include "ParseBC.h"
#include "CreateInitCl.h"
#include "ParseDir.h"
#include "Global.h"
#include "ParseOptions.h"

ParseBC pbc;
ParseBH pbh;

unsigned char ver[] = "$VER: BCC 3.5 (15.3.98)";

int main( int argv, char **arg )
{
 unsigned char *a;

	a = ver;

	if( argv == 2 ) {

		ParseOptions *po = new ParseOptions;
		po->Start();
		delete po;

		if( !Prefs.noversion ) printf( "BCC precompiler v3.5\n\n" );

		if( !stricmp( arg[1], "initcl" ) ) {
			ParseDir pd( "#?.bh" );
			char *name;
			while( name = pd.Next() ) {
				if( pbh.Open( name, 0 ) ) {
					short res1 = pbh.Start();
					pbh.Close();
					if( !res1 ) return 20;
				}
			}
			CreateInitCl cicl;
			if( !cicl.Create() ) return 20;
		} else 
		if( pbc.Open( arg[1] ) ) {
			short res = pbc.Start();
			pbc.Close();
			if( !res ) return 20;
		}

	} else printf( "Usage: BCC <file>.bc\n       BCC initcl\n\n" );

}
