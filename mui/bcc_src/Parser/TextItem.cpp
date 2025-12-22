#include "TextItem.h"
#include <string.h>

TextItem::TextItem( char *n, short len )
{

	tv = 0;
	if( n ) {
		if( !len ) strcpy( Name, n );
		else {
			strncpy( Name, n, len );
			Name[ len ] = 0;
		}
	}

}

unsigned long TextItem::CalcTV( void )
{

	if( tv ) return tv;
	
	short f;
	for( f = 0; f< strlen( Name ); f++ ) tv ^= Name[f]<<f;
	tv ^= (tv>>16);
	tv &= 0xffff;
	
	return tv;


}

TextItem *TextItem::FindItem( char *i, short len )
{

	if( !len ) len = strlen( i );

	FScan( TextItem, child, this ) {
		if( strlen( child->Name ) == len && !strncmp( i, child->Name, len ) ) return child;
	}

	return 0;

}
