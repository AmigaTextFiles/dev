#include <exec/alerts.h>
#include <clib/_exec.h>
#include "exec.h"
#include <stdio.h>

#include <amigem/fd_lib.h>
#define LIBBASE struct ExecBase *SysBase

void putChar();

FD1(18,void,Alert,ULONG alertnum,D7)
{
  UBYTE buf[29];
  ULONG d[2];
  Disable();
    d[0]=alertnum;
    d[1]=(ULONG)SysBase->ThisTask;
    RawDoFmt("Guru: 0x%08lx 0x%08lx\n",d,&putChar,buf);
    (*(void (*)(int,char *,int))SysBase->functable[12])(2,buf,28);
    if(alertnum&AT_DeadEnd)
      ColdReboot();
  Enable();
}

FD0(121,void,ColdReboot)
{
  (*(void (*)(int))SysBase->functable[13])(20);
}

FD1(19,void,Debug,ULONG flags,D0)
{}

/* Very bad stuff. I hope nobody needs it. */

FD2(108,ULONG,CacheControl,ULONG bits,D0,ULONG mask,D1)
{ return 0; }

FD1(5,ULONG,Supervisor,void *userFunc,A5)
{ return 0; }

FD0(25,APTR,SuperState)
{ return NULL; }

FD1(26,void,UserState,APTR sysStack,D0)
{}

FD1(57,LONG,AllocTrap,LONG trapNum,D0)
{ return 0; }

FD1(58,void,FreeTrap,ULONG trapNum,D0)
{}

/* Useless on other CPUs */

FD2(24,ULONG,SetSR,ULONG newSR,D0,ULONG mask,D1)
{ return 0; }

FD0(88,void,GetCC)
{}
