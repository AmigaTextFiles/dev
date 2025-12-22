#include "ParseFile.h"
#include "ParseBC.h"
#include <string.h>

short ParseFile::RepCheck( Replace *r )
{
 char *rs;

	if( (rs = r->Check( Tok, TokLen )) && !ForbidCheck() ) {
		fprintf( ofh, "%s", rs );
		StopCopy();
		StartCopy();
		return 1;
	}

 return 0;
}

short ParseBC::FullCheck( void )
{
 short rcr;

	short f;
	for( f = 0; f < BCC_block_cnt; f++ ) {
		rcr = RefCheck( BCC_block[f].rep );
		if( rcr ) return rcr;
	}
	

	if( cd ) { 
		rcr = RefCheck( &cd->clref );
		if( rcr ) return rcr;
	}

	rcr = RefCheck( &clref );
	if( rcr ) return rcr;

	if( cd ) {
		rcr = RepCheck( &cd->rep );
		if( rcr ) return rcr;
	}
	
	rcr = RepCheck( &reppar );
	if( rcr ) return rcr;

	rcr = NewDelCheck();
	return rcr;
	
}