#include "FileDate.h"
#include <proto/dos.h>
#include <string.h>

void FileDate::Set( char *f )
{

	struct FileInfoBlock fib;
	BPTR l;
	
 	if( !(l = Lock( f, ACCESS_READ )) ) return;
 	
 	Examine( l, &fib );

	memcpy( data, &(fib.fib_Date), 8 );

}

short FileDate::Compare( FileDate &fd )
{
	short ret;
	struct DateStamp *d1, *d2;
	
	d1 = (struct DateStamp*)data;
	d2 = (struct DateStamp*)fd.data;

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
