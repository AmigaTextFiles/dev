#include "ParseDir.h"
#include "string.h"

ParseDir::ParseDir( char *temp )
{
  memset( &ap, 0, sizeof( AnchorPath ) );
  ap.ap_BreakBits = SIGBREAKF_CTRL_C;

  first = 1;
  stat = MatchFirst( temp, &ap );
    
}

ParseDir::~ParseDir()
{

 if( stat && IoErr() == ERROR_NO_MORE_ENTRIES ) SetIoErr( 0 );
 MatchEnd( &ap );
 
}

char *ParseDir::Next( void )
{
	char *ret;

	if( !first ) stat = MatchNext( &ap );
	first = 0;

	if( stat ) return 0;

	while( !stat && ap.ap_Info.fib_DirEntryType > 0 ) stat = MatchNext( &ap );
	
	if( stat ) return 0;
	
	ret = (char*)ap.ap_Info.fib_FileName;
	
	return ret;
		
}

