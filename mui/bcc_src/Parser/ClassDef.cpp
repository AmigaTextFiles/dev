#include "ClassDef.h"
#include "Family.h"
#include "MethodDef.h"
#include "Global.h"

unsigned long ClassDef::GetTagVal( void )
{

	if( TagVal ) return TagVal;

	if( Prefs.tagbase ) {
		TagVal = CalcTV();
		TagVal ^= TagVal << 8;
		TagVal &= 0xff00;
		TagVal |= ((unsigned long)Prefs.tagbase)<<16;
	} else {
		TagVal = CalcTV() << 16;
		TagVal |= 0x80000000;
	}
	
	return TagVal;


}
