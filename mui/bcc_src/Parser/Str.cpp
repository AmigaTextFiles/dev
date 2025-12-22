#include "Str.h"

#define abs( a ) ( a > 0 ? a : -a )

StrBuf strbuf;

char *StrBuf::alloc( short size )
{
	short *p;
	
	if( size & 1 ) size++;
	
	p = b;
	
	while( 1 ) {
		if( !*p ) break;
		if( -*p >= size ) {
			if( size == -*p - 2 ) size += 2;
			if( -*p > size ) {
				p[ size/2 + 1 ] = *p + size + 2;
				break;
			}
			break;
		} 
		p += abs( *p )/2 + 1;
		
		if( p > b + STRBUF ) { printf( "String buffer overflow\n" ); exit( 10 ); }
	
	}
	
	if( !*p ) p[ 1 + size/2 ] = 0;
	*p = size;
	
	p++;
	
	return (char*)p;
	

}

void StrBuf::free( char *buf )
{

	short *p = (short*)buf;
	
	if( !buf ) return;
	
	p--;
	if( *p <= 0 ) { 
		printf( "String alloc/dealloc error\n" ); 
		exit( 10 ); 
	}
	
	*p = -*p; 
	
	for( p = b; *p; ) {
		if( *p < 0 ) {
			if( !p[ ((-*p)>>1) + 1 ] ) { *p = 0; break; }
			if( p[ ((-*p)>>1) + 1 ] < 0 ) *p = *p + p[ ((-*p)>>1) + 1 ] - 2;
			else p += ((-*p)>>1) + 1;
		}
		else p += (*p>>1) + 1;
	}

}


String &String::operator+( char c ) { 
		char *n;
		n = (char*)malloc( Len+1 );
		strcpy( n, str );
		remstr();
		n[Len] = c;
		n[Len+1] = 0;
		str = n;
		Len++;
		return *this;
}

short String::Pos( char *t, short s )
{
	short r, l;
	l = strlen( t );
	
	if( s >= 0 ) {
		for( r = s; r < Len - l + 1; r++ ) if( !strncmp( str+r, t, l ) ) return r;
		return -1;
	} else {
		for( r = Len-s; r >= 0; r-- ) if( !strncmp( str+r, t, l ) ) return r;
		return -1;
	}

}

void String::Cut( short p, short l )
{

	char *n;
	
	if( !l ) l = strlen( str + p );
	
	n = strbuf.alloc( Len - l );
	if( p ) memcpy( n, str, p );
	strcpy( n + p, str + p + l );
	
	remstr();
	str = n;
	Len -= l;

}

char *String::operator+=( char *a )
{
	char *s;
	
	if( !str ) {
		attach( a );
		return str;
	} else {
		s = strbuf.alloc( Len + strlen( a ) );
		strcpy( s, str );
		strcpy( s+Len, a );
		Len = strlen( s );
		remstr();
		str = s;
	}
	
	return s;
}

