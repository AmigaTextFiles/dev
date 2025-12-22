#ifndef REPLACE_H
#define REPLACE_H

#define MAXREP 100

#include "Str.h"

class repdat {

public:

	char *o, *n;
	short os, ns;

	String extra;

	repdat( char *old, short olds, char *_new, short news );
	~repdat();
	
	

};

class Replace {

 repdat *dat[100];
 
 short n, gec;
 
public:

	Replace();
	~Replace();
	
	void Clear( void );
	
	void Add( char *old, short olds, char *_new, short news, char *extra = 0 );
	char *Check( char *s, short sl );

	void InitGetExtra( void ) { gec = 0; }
	char *GetExtra( char **ex );

};

#endif
