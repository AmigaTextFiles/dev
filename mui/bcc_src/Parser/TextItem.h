#ifndef TEXTITEM_H
#define TEXTITEM_H

#include "family.h"
#include <stdio.h>

#define MAXTINAME 50

class TextItem: public Family {

	unsigned long tv;

public:

	char Name[MAXTINAME];
	
	TextItem( char *n = 0, short len = 0 );

	unsigned long CalcTV( void );

	TextItem *FindItem( char *i, short len = 0 );

};

#endif
