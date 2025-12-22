#include <exec/resident.h>
#include <clib/_exec.h>

#include <amigem/fd_lib.h>
#define LIBBASE struct ExecBase *SysBase

FD2(12,void,InitCode,ULONG startClass,D0,ULONG version,D1)
{}

FD1(16,struct Resident *,FindResident,STRPTR name,A1)
{ return NULL; }

FC3(0,APTR,InitFunc,A1,APTR dummy,D0,BPTR segList,A0,struct ExecBase *SysBase,A6)
;

FD2(17,APTR,InitResident,struct Resident *resident,A1,ULONG segList,d1)
{
  if(resident->rt_MatchWord!=RTC_MATCHWORD||resident!=resident->rt_MatchTag)
    return NULL;
  if(resident->rt_Flags&RTF_AUTOINIT)
    return (APTR)MakeLibrary(((APTR *)resident->rt_Init)[1],
                             ((struct InitStruct **)resident->rt_Init)[2],
                             ((APTR *)resident->rt_Init)[3],
                             ((ULONG *)resident->rt_Init)[0],segList);
  else
    return InitFunc(resident->rt_Init,0,segList,SysBase);
}

FD0(102,ULONG,SumKickData)
{ return 0; }

