#ifndef STR_H
#define STR_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define STRBUF 10000


class StrBuf {
	short b[STRBUF];
public:
	char *alloc( short size );
	void free( char *buf );

};


extern StrBuf strbuf;

class String {

	char *str;

	void remstr( void ) { if( str ) { 
//		if( str ) 		printf( "Free: %s\n", str );
		strbuf.free( str ); str = 0; } }
	void attach( char *s ) {
		Len = strlen( s );
		str = strbuf.alloc( Len+1 );
		strcpy( str, s );
//		printf( "Attach: %s\n", str );
	}
	void attach( char *s, short l ) {
		Len = l;
		str = strbuf.alloc( Len+1 );
		memcpy( str, s, Len );
		str[Len] = 0;
//		printf( "Attach: %s\n", str );
	}
	
public:

	short Len;

	String( char *s ) { attach( s ); }
	String( char *s, short l ) { attach( s, l ); }
	
	String( void ) {
		str = 0;
	}
	
	~String() { remstr(); }
	
	char *operator=( char *s ) { remstr(); attach( s ); return str; }
	char *operator=( String &s ) { remstr(); attach( s ); return str; } 
	char *operator+=( char *a );
	String &operator+( char c );
	operator char*() { return str; }
	short Pos( char *t, short s = 0 );
	void Cut( short p, short l = 1 );
	void Copy( char *s, short l ) { remstr(); attach( s, l ); }
	

};

#endif
