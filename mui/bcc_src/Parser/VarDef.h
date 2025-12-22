#ifndef VARDEF_H
#define VARDEF_H

#include "InterDef.h"
#include "ClassDef.h"

class VarDef: public InterDef {

	void ClearParType( void ) { ParType[0][0] = ParType[1][0] = ParType[2][0] = 0; }

public:

	unsigned short passmsg;
	char ParType[3][50];

	char GetTagType( void ) { return 'A'; }

	VarDef( char *name, char *sgi, short sgilen, ClassDef *cld, unsigned short sw = 0 );
	VarDef( char *name, short nl, unsigned short sw = 0 )  : InterDef( name, nl, 0, sw ) { ClearParType(); }

	unsigned long GetTagVal( void );
	
	void SetParType( unsigned short sw, char *par, short len = 0 );
	
	char *SGIName( unsigned short sw );
	char *GetParType( unsigned short sw );

};

#define M_GET	0
#define M_SET	1
#define M_INIT	2

#define SW_SIMPLE		512
#define SW_GET			2048
#define SW_SET			4096
#define SW_INIT		8192
#define SW_SAMESI 1<<15

#endif
