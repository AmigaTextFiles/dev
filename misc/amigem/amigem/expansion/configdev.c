#include <clib/_exec.h>
#include <amigem/utils.h>
#include "expansion.h"

#include <amigem/fd_lib.h>
#define LIBBASE struct ExpansionBase *ExpansionBase

#define SysBase (ExpansionBase->SysBase)

FD1(5,void,AddConfigDev,struct ConfigDev *configDev,A0)
{
  Forbid();
    AddTail(&ExpansionBase->ConfigDevList,&configDev->cd_Node);
  Permit();
}

FD0(8,struct ConfigDev *,AllocConfigDev)
{
  return (struct ConfigDev *)AllocMem(sizeof(struct ConfigDev),MEMF_PUBLIC|MEMF_CLEAR);
}

FD3(12,struct ConfigDev *,FindConfigDev,struct ConfigDev *oldConfigDev,A0,LONG manufacturer,D0,LONG product,D1)
{/* No need to arbitrate for this list: ln_Succ always points to a valid node */
  if(oldConfigDev==NULL)
    oldConfigDev=(struct ConfigDev *)&ExpansionBase->ConfigDevList;
  for(;;)
  {
    oldConfigDev=(struct ConfigDev *)oldConfigDev->cd_Node.ln_Succ;
    if(!oldConfigDev->cd_Node.ln_Succ)
      return NULL;
    if((manufacturer==-1||manufacturer==oldConfigDev->cd_Rom.er_Manufacturer)&&
       (product     ==-1||product     ==oldConfigDev->cd_Rom.er_Product     ))
      return oldConfigDev;
  }
}

FD1(14,void,FreeConfigDev,struct ConfigDev *configDev,A0)
{
  FreeMem(configDev,sizeof(struct ConfigDev));
}

FD2(22,void,SetCurrentBinding,struct CurrentBinding *currentBinding,A0,ULONG size,D0)
{
  CopyMem(currentBinding,&ExpansionBase->LocalCurBind,size);
  while(size<sizeof(struct CurrentBinding))
    ((UBYTE *)&ExpansionBase->LocalCurBind)[size++]=0;
}

FD2(23,ULONG,GetCurrentBinding,struct CurrentBinding *currentBinding,A0,ULONG size,D0)
{
  CopyMem(&ExpansionBase->LocalCurBind,currentBinding,size);
  return sizeof(struct CurrentBinding);
}

FD0(20,void,ObtainConfigBinding)
{
  ObtainSemaphore(&ExpansionBase->ConfigBinding);
}

FD0(21,void,ReleaseConfigBinding)
{
  ReleaseSemaphore(&ExpansionBase->ConfigBinding);
}
