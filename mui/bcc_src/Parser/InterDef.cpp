#include "InterDef.h"
#include "Global.h"


char *InterDef::FullName( void )
{
	if( !cd ) return Name;
	else {
		sprintf( fn, "%s%c_%s_%s", cd->type, GetTagType(), cd->Name, Name );
		return fn;
	}
}

unsigned long InterDef::GetTagVal( void )
{

	if( TagVal ) return TagVal;

	if( cd ) {
	
		if( Prefs.tagbase ) {
			TagVal = CalcTV();
			TagVal ^= TagVal >> 8;
			TagVal &= 0xff;
		} else {
			TagVal = CalcTV();
		}

		TagVal |= cd->GetTagVal();
	
		return TagVal;
		
	}
	return 0;

}
