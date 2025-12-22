#include <libraries/mui.h>

#include <proto/intuition.h>

LONG BCC_XGet(Object *obj,ULONG attribute)
{
	LONG x;
	get(obj,attribute,&x);
	return(x);
}
