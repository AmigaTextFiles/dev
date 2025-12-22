#ifndef PARSEBC_H
#define PARSEBC_H

#include "ParseFile.h"
#include "ClassDef.h"
#include "Replace.h"
#include "VarDef.h"

#define SW_NODATA	1
#define SW_CUSTOM 2
#define SW_PRESUPER 4
#define SW_POSTSUPER 8
#define SW_NOSUPER 16
#define SW_SUPERCHECK 32
#define SW_CLEARDATA 64
#define SW_SUPER 128
#define SW_NOEARLYDATA 256

#define MAXBCCBLOCKS	8


class ParseBC: public ParseFile {

	short DoMA( short attr = 0 );
	void CreateDisp( FILE *fh );
	void InsertIAttrPre( FILE *fh, unsigned short test = SW_INIT );
	void InsertIAttr( FILE *fh, unsigned short test = SW_INIT );

	short IsReferenced( char *s, Replace *rep = 0, short endmode = 0 );
	
	unsigned short switches;
	short cont;

	Replace reppar, clref;

	ClassDef *cd;

	char *FindRef( void );
	short RefCheck( Replace *r );
	short NewDelCheck( void );
	
	short FullCheck( void );

	short Params( void );
	short EarlyCode( void );
	
	inline void pDataDefAssign( void ) {
		if( !(switches & SW_NODATA ) ) fprintf( ofh, " %sData *data = INST_DATA( cl, obj );\n", cd->Name );
	}
	inline void pDataDef( void ) {
		if( !(switches & SW_NODATA ) ) fprintf( ofh, " %sData *data;\n", cd->Name );
	}

	struct { Replace *rep; short brc; } BCC_block[MAXBCCBLOCKS];
	short BCC_block_cnt;

	void InitData( void );
	
public:

	short Start( void );

};


#endif
