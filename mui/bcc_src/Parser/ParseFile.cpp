#include "ParseFile.h"
#include "ValidFile.h"
#include "Global.h"

#include <string.h>

short ParseFile::Open( char *name, short force, short scanonly )
{
	created = 0;

	if( !Load( name ) ) return 0;

	Name = name;
	sfname = name;
	ofname = name;
	
	short p;
	p = sfname.Pos( ".b", -1 );
	if( p < 0 ) {
		printf( "File %s has bad extension\n", name );
		return 0;
	}

	sfname.Cut( p, sfname.Len-p );
	ofname.Cut( p+1 );
	
	ValidFile vf;
	if( !Prefs.forcetrans && ((!force && vf.isValid( name, ofname )) || scanonly) ) {
		strcpy( ofname, "NIL:" );
		if( Prefs.verbose ) printf( "Scanning \"%s\"\n", name );
	} else {
		if( Prefs.verbose ) printf( "Translating \"%s\" into \"%s\"\n", name, (char*)ofname );
		created = 1;
	}

	if( !(ofh = fopen( ofname, "w" )) ) {
		printf( "Can not open output file\n" );
 		Close();
		return 0;
	}
			
	copy = 1; startcopy = 0;

	return 1;

}

void ParseFile::Close( void )
{

	if( ofh ) {
		fclose( ofh );
		ofh = 0;
	}

}

ParseFile::~ParseFile()
{
	Close();
}

ParseFile::ParseFile( void )
{
	ofh = 0;
}


void ParseFile::GetToken( void )
{

	if( TokLen ) {
		memcpy( PrevTok, Tok, TokLen );
		PrevTok[TokLen] = 0;
		PrevType = TokType;
	} else PrevTok[0] = 0;

	if( copy && !Survey.Tok && TokLen ) {
		if( fwrite( Tok, 1, TokLen, ofh ) != TokLen ) {
			printf( "IO Error\n" );
		}
	}

	if( startcopy ) { copy = 1; startcopy = 0; }

	char *lch = Tok+TokLen;

	Next();

	if( copy && !Survey.Tok && lch && Tok-lch ) {
		if( fwrite( lch, 1, Tok-lch, ofh ) != Tok-lch ) {
			printf( "IO Error\n" );
		}
	}

}

static char *ErrTab[] = {
	"Unknown error",
	"Class name must be the same as file name",
	"\"{\" must follow",
	"Missing \";\"",
	"Alfa-numerical string expected",
	"\"(\" must follow",
	"Non defined class",
	"Missing \"::\"",
	"Not a member of class",
	"[S][G][I] must follow \":\"",
	"Attribute must be 'S', 'G', 'I' or 'SI'",
	"Non defined attribute",
	"Unexpected end of file",
	"Bad method parameter",
	"Simple attributes don't need declaration",
	"Current BCC version can handle only Class pointers",
	"Bad class pointer definition",
	"Can not declare code for virtual object",
	"Missing Class type",
	"Pointer doesn't point to class",
	"Options syntax error",
	"Parameter must be all in one line",
	"Constructor must be AFTER all init attributes",
	"Attribute can't be SET/INIT and GET at the same time",
	"Too many nested BCCBlocks",
	"Not closed BCCBlock",
	"When custom OM_SET/OM_GET defined use ONLY virtual attributes",
	"Empty brackets not allowded for Attributes"
};

char **ParseFile::ErrorStrings( void ) { return ErrTab; }


void ParseFile::UpdateLineNo( void )
{

	if( Prefs.reallines ) fprintf( ofh, "#line %hd \"%s\"\n", LineN - ( *(Tok+TokLen-1)==10 ? 1 : 0 ) , (char*)Name );

}