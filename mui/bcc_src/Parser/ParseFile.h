#ifndef PARSEFILE_H
#define PARSEFILE_H

#include <stdio.h>
#include <string.h>

#include "Replace.h"
#include "FParse.h"

#define PrevType (Prev.TokType)

#define chcmp( ch ) ( TokLen == 1 && *Tok == ch )

class ParseFile : public FParse {

	short copy, startcopy;	

public:


	short created;

	FILE *ofh;

	String ofname, sfname, Name;

	char PrevTok[ 100 ];
	
	void GetToken( void );

	short Open( char *name, short force = 1, short scanonly = 0 );
	void Close( void );

	~ParseFile();
	ParseFile( void );	

	void StartCopy( void ) { startcopy = 1; }
	void StopCopy( void ) { copy = 0; }
	void FastStartCopy( void ) { copy = 1 };

	short DoHeader( void );
	short RepCheck( Replace *r );

	char *ctype, crClName[30];
	short crcont;
	void SetCType( short write = 1 );
	short ClassPtrDefinition( Replace *rep, short write = 1, short once = 0 );
	void InitClassPtrDef( void ) { crcont = 0; }

	short ForbidCheck( void )
	{
		return (short)(( !strcmp( PrevTok, "->" ) || !strcmp( PrevTok, "struct" ) || !strcmp( PrevTok, "." ) ) ? 1 : 0);
	}

	short GetSGI( unsigned short *sw );

	char **ErrorStrings( void );

	void UpdateLineNo( void );

};

#endif