#ifndef INTERDEF_H
#define INTERDEF_H

#include "TextItem.h"
#include "ClassDef.h"

class InterDef: public TextItem {

	char fn[120];
	unsigned long TagVal;

public:
	char *FullName( void );
	unsigned long GetTagVal( void );
	
	InterDef( char *name, short len, ClassDef *cld, short sw = 0 ) : TextItem( name, len ) { switches = sw; cd = cld; }
	
	ClassDef *cd;
	unsigned short switches;
	
	virtual char GetTagType();

};


#endif
