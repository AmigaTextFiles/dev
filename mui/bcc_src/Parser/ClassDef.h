#ifndef CLASSDEF_H
#define CLASSDEF_H

#include "TextItem.h"
#include "Replace.h"
#include <stdio.h>

class ClassDef: public TextItem {

	unsigned long TagVal;

public:

	Replace rep, clref;

	char *type;
	Family Var;
	char PSuper[ 30 ];
	short superpriv;
	unsigned short sw;

	ClassDef(  char *n, short len = 0 ) : TextItem( n, len ) { TagVal = 0; superpriv = 0; }

	short CheckDoubleTags( void );

	unsigned long GetTagVal( void );

};


#define SW_SELFCREATE 1

#define SW_VIRTUAL	1024

#endif
