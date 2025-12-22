#include <libraries/mui.h>
#include <proto/intuition.h>

ULONG BCC_DoSuperNew(struct IClass *cl,Object *obj,ULONG tag1,...)
{
	return(DoSuperMethod(cl,obj,OM_NEW,&tag1,NULL));
}
