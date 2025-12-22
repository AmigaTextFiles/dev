#ifndef METHODDEF_H
#define METHODDEF_H

#include "InterDef.h"

#define MMET_ASKMINMAX	1

#define SW_LOCAL 1<<14

class MethodDef: public InterDef {

public:
	char *msgtype;

	char GetTagType( void ) { return 'M'; }

	MethodDef( char *n, short len, ClassDef *clsd, unsigned short sw );

};

#endif
