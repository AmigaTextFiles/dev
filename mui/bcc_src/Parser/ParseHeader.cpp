#include <string.h>

#include "ParseFile.h"
#include "Global.h"
#include "ParseBH.h"


short ParseFile::DoHeader( void )
{

	GetToken();
	if( !TokLen ) return 0;
	
	if( *Tok == '"' && TokLen > 5 && !strncmp( Tok+TokLen-4, ".bh\"", 4 ) ) {
	
		StopCopy();
		String buf( Tok+1, TokLen );
		buf.Cut( TokLen - 2, 0 );
		String buf2( Tok, TokLen );
		buf2.Cut( TokLen-3, 1 );
		buf2.Cut( TokLen-1, 0 );
		fprintf( ofh, "%s", (char*)buf2 );
		
		buf2 = buf;
		buf2.Cut( buf2.Len - 3, 0 );

		if( !ClassList.FindItem( (char*)buf2, 0 ) ) {

			ParseBH pbh;
			if( pbh.Open( (char*)buf, 0 ) ) {
				short res = pbh.Start();
				pbh.Close();
				if( !res ) return 0;
			
			}
			
		}
			
		StartCopy();
		
		
	}

	return 1;
}
