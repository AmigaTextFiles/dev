#include "ValidFile.h"
#include <proto/dos.h>

#include <string.h>


short ValidFile::isValid( char *s, char *d )
{
 BPTR ls, ld;

 	if( !(ls = Lock( s, ACCESS_READ )) ) return 0;
 	if( !(ld = Lock( d, ACCESS_READ )) ) { UnLock( ls ); return 0; }
 	
 	Examine( ls, &fibs );
 	Examine( ld, &fibd );
 	
 	short res = CompareDS( &(fibs.fib_Date), &(fibd.fib_Date) );
 	
 	UnLock( ls );
 	UnLock( ld );
 	
 	return ( res < 0 ? 0 : 1 );

}

short ValidFile::CompareDS( struct DateStamp *d1, struct DateStamp *d2 )
{
	short ret;

	if( d2->ds_Days == d1->ds_Days ) ret = 0;
	else ret = d2->ds_Days > d1->ds_Days ? 1 : -1;
	if( ret ) return ret;
	if( d2->ds_Minute == d1->ds_Minute ) ret = 0;
	else ret = d2->ds_Minute > d1->ds_Minute ? 1 : -1;
	if( ret ) return ret;
	if( d2->ds_Tick == d1->ds_Tick ) ret = 0;
	else ret = d2->ds_Tick > d1->ds_Tick ? 1 : -1;
	return ret;
}
