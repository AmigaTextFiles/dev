#include "GlobalDef.h"
#include "InsertFile.h"
#include "Family.h"

extern GlobalDef ClassList;

extern InsertFile ins_every;
extern InsertFile ins_header;
extern InsertFile ins_code;
extern InsertFile ins_initcl;

#ifndef min
#define min( x, y ) ( x < y ? x : y ) 
#endif

#ifndef max
#define max( x, y ) ( x > y ? x : y ) 
#endif

class Prf {

	Family textlist;

public:

	Prf( void );
	~Prf();
	char *AddText( char *t, short len = 0 );

	char *deftype, *incdir;

	short verbose, noversion, forcetrans, publicheader;
	short nosaveds, reallines;
	
	unsigned short tagbase;

};

extern Prf Prefs;

#define MAX_TAGS	100
