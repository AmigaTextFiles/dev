#include "VarDef.h"
#include "ClassDef.h"
#include "ParseBC.h"


VarDef::VarDef( char *name, char *sgi, short sgilen, ClassDef *cld, unsigned short sw ) : InterDef( name, 0, cld, sw ) {

	char *p = sgi;
	short f;
	
	ParType[0][0] = 0;
	ParType[1][0] = 0;
	ParType[2][0] = 0;

	for( f = 0; f< sgilen; f++, p++ ) {
		switch( *p ) {
			case 'S': switches |= SW_SET; break;
			case 'G': switches |= SW_GET; break;
			case 'I': switches |= SW_INIT; break;
		}
	}
	
}

unsigned long VarDef::GetTagVal( void )
{

	return (InterDef::GetTagVal() ^ (unsigned long)'A');

}

void VarDef::SetParType( unsigned short sw, char *par, short len )
{
	short i, l;
	
	l = len ? len : strlen( par );
	
	for( i = 0; i < 3; i++ ) {
		if( sw & (1<<(11+i)) ) {
			memcpy( ParType[i], par, l );
			ParType[i][l] = 0;
		}
	}


}

char *VarDef::SGIName( unsigned short sw )
{
	if( switches & SW_SAMESI ) return "SI";
	if( sw & SW_INIT ) return "Init";
	return "Set";

}

char *VarDef::GetParType( unsigned short sw )
{
	if( sw & SW_INIT ) return ParType[M_INIT];
	return ParType[M_SET];

}
