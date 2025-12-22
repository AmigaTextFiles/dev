#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "FParse.h"

short FParse::Load( char *name )
{
	FILE *fh;
	
	ClearData();
	
	Name = name;
	
	if( !(fh = fopen( name, "r" )) ) {
		printf( "Fail to open file \"%s\"\n", name );
		return 0;
	}
	
	if( fseek( fh, 0, SEEK_END ) ) return 0;
	
	Len = ftell( fh );
	
	if( !Len ) {
		printf( "File \"%s\" is empty\n", name );
		return 0;
	}
	
	rewind( fh );
	
	if( !(Data = (char*)malloc( (int)Len )) ) {
		printf( "Can not allocate memory\n" );
		Len = 0;
		return 0;
	}
	
	if( fread( Data, 1, Len, fh ) != Len ) {
		printf( "Error reading \"%s\"\n", name );
		Len = 0;
		return 0;
	}
	
	fclose( fh );
	
	ErrorBuf = 0;
	Reset();
	
	return 1;
}

FParse::~FParse()
{
	if( Data ) free( Data );
}


static const unsigned char ParseTab[ 260 ] = {

	NON, NON, NON, NON, NON, NON, NON, NON, NON, SEP,
	SEP, NON, NON, NON, NON, NON, NON, NON, NON, NON,
	NON, NON, NON, NON, NON, NON, NON, NON, NON, NON,
	NON, NON, SEP, NON, ALN, NON, NON, NON, NON, NON,
	BRC, BRC, CNT, OPR, OPR, OPR, OPR, CNT, ALN, ALN,
	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, OPR, OPR,
	OPR, OPR, OPR, NON, NON, ALN, ALN, ALN, ALN, ALN,
	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN,
	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN,
	ALN, BRC, NON, BRC, NON, ALN, NON, ALN, ALN, ALN,
	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN,
	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN,
	ALN, ALN, ALN, BRC, NON, BRC, ALN, NON, NON, NON,

	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN,
	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN,
	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN,
	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN,
	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN,
	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN,
	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN,
	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN,
	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN,
	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN,
	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN,
	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN,
	ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN, ALN

};


short FParse::Next( void )
{
	short comment = 0, lcomment = 0;

	Prev = (tpos)*this;

again:

	if( !Tok ) Tok = Data;
	
	Tok += TokLen;
	if( Tok >= Data + Len ) { TokLen = 0; return 1; }
	TokLen = 0;

	char *p, *ps;
	p = ps = Tok;
	TokType = ParseTab[ *p ];


	char prevch = 0;
	/* Strings */
	if( *p == '"' && !comment ) {
		while( 1 ) {
			p++;
			if( *p == '"' && *(p-1) != '\\' ) { p++; break; }
			if( !*p ) break;
		}

	} else 
	while( ParseTab[ *p ] == TokType && *p ) {
		if( TokType == CNT && !lcomment ) {
			if( prevch == '/' ) {
				if( *p == '*' ) comment++;
				if( *p == '/' ) {
					lcomment = 1;
					comment++;
				}
			}
			if( prevch == '*' && *p == '/' ) comment--;
			prevch = *p;
		}
		p++;
		if( ParseTab[ *p ] == BRC ) break;
	}

	TokLen = (short)(p - ps);
	
	if( TokType == BRC && !comment) {
		switch( *Tok ) {
			case '{': MBracket++; break;
			case '}': MBracket--; break;
			case '(': CBracket++; break;
			case ')': CBracket--; break;
			case '[': SBracket++; break;
			case ']': SBracket--; break;
		}
	}

	if( TokType == SEP ) {
		for( p = Tok; p < Tok+TokLen; p++ ) if( *p == 10 ) {
			if( lcomment ) { lcomment = 0; comment--; }
			LineN++;
		}
		goto again;
	}
	if( comment ) goto again;
	
	return 0;
	
}

void tpos::reset( void )
{
	memset( this, 0, sizeof( tpos ) );
	LineN = 1;
}

tpos::tpos( void )
{
	reset();
}

tpos &tpos::operator=( tpos &tp )
{
	memcpy( this, &tp, sizeof( tpos ) );
	
	return *this
}

void FParse::StartSurvey( void )
{

	Survey = (tpos)*this;
	SurveyPrev = Prev;

}

void FParse::StopSurvey( void )
{

	(tpos)*this = Survey;
	Prev = SurveyPrev;
	Survey.reset();

}

