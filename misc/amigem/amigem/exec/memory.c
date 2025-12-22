#include <exec/alerts.h>
#include <exec/execbase.h>
#include <exec/tasks.h>
#include <exec/memory.h>
#include <exec/semaphores.h>
#include <exec/devices.h>
#include <exec/io.h>
#include <clib/_exec.h>
#include <stdio.h>

#include <amigem/fd_lib.h>
#define LIBBASE struct ExecBase *SysBase

/*
 * Allocate part of a MemChunk
 */
void SplitMemChunk(struct MemChunk **mc,APTR mem,ULONG size)
{
  struct MemChunk *next;
  next=(*mc)->mc_Next;
  if((ULONG)mem+size<(ULONG)(*mc)+(*mc)->mc_Bytes)
  {
    (*mc)->mc_Next=(struct MemChunk *)((ULONG)mem+size);
    (*mc)->mc_Next->mc_Next=next;
    (*mc)->mc_Next->mc_Bytes=((ULONG)(*mc)+(*mc)->mc_Bytes)-((ULONG)mem+size);
    next=(*mc)->mc_Next;
  }
  if((ULONG)(*mc)<(ULONG)mem)
  {
    (*mc)->mc_Bytes=(ULONG)mem-(ULONG)(*mc);
    next=*mc;
  }
  *mc=next;
}

FD2(31,void *,Allocate,struct MemHeader *mh,A0,ULONG size,D0)
{
  struct MemChunk *p1,*p2;
  size=(size+sizeof(struct MemChunk)-1)&~(sizeof(struct MemChunk)-1);
  if(mh->mh_Free<size)
    return NULL;
  p1=(struct MemChunk *)&mh->mh_First;
  p2=p1->mc_Next;
  if(p2!=NULL)
    for(;;)
    {
      if(p2->mc_Bytes>=size)
      {
        SplitMemChunk((struct MemChunk **)p1,p2,size);
        break;
      }
      p1=p2;
      p2=p1->mc_Next;
      if(p2==NULL)
        break;
      if((ULONG)p2<(ULONG)p1+p1->mc_Bytes)
        Alert(AN_MemCorrupt);
    }
  return p2;
}

FD3(32,void,Deallocate,struct MemHeader *mh,A0,APTR mem,A1,ULONG size,D0)
{
  struct MemChunk *p1,*p2;
  if(!(size=(size+sizeof(struct MemChunk)-1)&~(sizeof(struct MemChunk)-1)))
    return;
  p2  =(APTR)((ULONG)mem&~(sizeof(struct MemChunk)-1));
  p2->mc_Bytes=size;
  mh->mh_Free+=size;
  if((p1=mh->mh_First)==NULL)
  {
    p2->mc_Next=NULL;
    mh->mh_First=p2;
  }
  else
    for(;;)
    {
      if(p1->mc_Next==NULL||(ULONG)p1->mc_Next>(ULONG)p2)
      {
        p2->mc_Next=p1->mc_Next;
        p1->mc_Next=p2;
        if((ULONG)p1+p1->mc_Bytes==(ULONG)p2)
        {
          p1->mc_Bytes+=size;
          p2=p1;
        }else if((ULONG)p1+p1->mc_Bytes>(ULONG)p2)
          Alert(AN_FreeTwice);
        p1=p2->mc_Next;
        if(p1)
          if((ULONG)p2+p2->mc_Bytes==(ULONG)p1)
          {
            p1->mc_Bytes+=p1->mc_Bytes;
            p1->mc_Next=p1->mc_Next;
          }
          else if((ULONG)p2+p2->mc_Bytes>(ULONG)p1)
            Alert(AN_FreeTwice);
        break;
      }
      p1=p1->mc_Next;
    }
}

FD2(33,void *,AllocMem,ULONG size,D0,ULONG attrib,D1)
{ 
  struct MemHeader *mh;
  struct MemChunk *ret=NULL;
  size=(size+sizeof(struct MemChunk)-1)&~(sizeof(struct MemChunk)-1);
  Forbid();
    mh=(struct MemHeader *)SysBase->MemList.lh_Head;
    while(mh->mh_Node.ln_Succ!=NULL)
    {
      if(mh->mh_Free>=size&&!(attrib&~(MEMF_CLEAR|MEMF_REVERSE|mh->mh_Attributes)))
      {
        if(!(attrib&MEMF_REVERSE))
          ret=Allocate(mh,size);
        else
        {
          struct MemChunk *p1,*p2;
          p1=(struct MemChunk *)&mh->mh_First;
          p2=p1->mc_Next;
          if(p2!=NULL)
            for(;;)
            {
              if(p2->mc_Bytes>=size)
                ret=p1;
              p1=p2;
              p2=p1->mc_Next;
              if(p2==NULL)
                break;
              if((ULONG)p2<(ULONG)p1+p1->mc_Bytes)
                Alert(AN_MemCorrupt);
            }
          if(ret!=NULL)
          {
            p1=ret;
            p2=p1->mc_Next;
            ret=(struct MemChunk *)((char *)p2+p2->mc_Bytes-size);
            SplitMemChunk((struct MemChunk **)p1,ret,size);
            mh->mh_Free-=size;
          }
        }
        if(ret!=NULL)
        {
          if(attrib&MEMF_CLEAR)
          {
            ULONG cnt,*p;
            p=(ULONG *)ret;
            cnt=size/sizeof(ULONG);
            while(cnt--)
              *p++=0;
          }
          break;
        }
      }
      mh=(struct MemHeader *)mh->mh_Node.ln_Succ;
    }
  Permit();
  return ret;
}

FD2(35,void,FreeMem,void *mem,A1,ULONG size,D0)
{
  struct MemHeader *mh;
  Forbid();
    mh=(struct MemHeader *)SysBase->MemList.lh_Head;
    while(mh->mh_Node.ln_Succ!=NULL)
    {
      if((ULONG)mem>=(ULONG)mh->mh_Lower&&(ULONG)mem<(ULONG)mh->mh_Upper)
        Deallocate(mh,mem,size);
    }
  Permit();
}

FD2(34,void *,AllocAbs,ULONG size,D0,void *mem,A1)
{
  struct MemChunk *ret=NULL;
  struct MemHeader *mh;
  size=(size+((ULONG)mem&(sizeof(struct MemChunk)-1))+
        sizeof(struct MemChunk)-1)&~(sizeof(struct MemChunk)-1);
  mem=(void *)((ULONG)mem&~(sizeof(struct MemChunk)-1));
  Forbid();
    mh=(struct MemHeader *)SysBase->MemList.lh_Head;
    while(mh->mh_Node.ln_Succ!=NULL)
    {
      if((ULONG)mem>=(ULONG)mh->mh_Lower&&(ULONG)mem<=(ULONG)mh->mh_Upper)
      {
        struct MemChunk *p1,*p2;
        p1=(struct MemChunk *)&mh->mh_First;
        p2=p1->mc_Next;
        if(p2!=NULL)
        {
          for(;;)
          {
            if((ULONG)p2+p2->mc_Bytes>=(ULONG)mem+size&&(ULONG)p2<=(ULONG)mem)
            {
              ret=p1;
              break;
            }
            p1=p2;
            p2=p1->mc_Next;
            if(p2==NULL)
              break;
            if((ULONG)p2<(ULONG)p1+p1->mc_Bytes)
              Alert(AN_MemCorrupt);
          }
          if(ret!=NULL)
          {
            ret=(struct MemChunk *)mem;
            SplitMemChunk((struct MemChunk **)p1,ret,size);
            mh->mh_Free-=size;
            break;
	  }
        }
      }
      mh=(struct MemHeader *)mh->mh_Node.ln_Succ;
    }
  Permit();
  return ret;
}

FD2(114,void *,AllocVec,ULONG size,D0,ULONG attrib,D1)
{
  ULONG *ret;
  size+=sizeof(ULONG);
  if((ret=(ULONG *)AllocMem(size,attrib))!=NULL)
    *ret=size;
  return ret+1;
}

FD1(115,void,FreeVec,void *mem,A1)
{
  ULONG *p=(ULONG *)mem;
  if(p!=NULL)
  {
    p--;
    FreeMem(p,*p);
  }
}

FD1(37,struct MemList *,AllocEntry,struct MemList *ml,A0)
{
  struct MemList *ret;
  ULONG i;
  if((ret=(struct MemList *)AllocMem(sizeof(struct MemList)-sizeof(struct MemEntry)+
          sizeof(struct MemEntry)*ml->ml_NumEntries,MEMF_PUBLIC))==NULL)
    return (struct MemList *)(MEMF_PUBLIC|0x80ul<<(sizeof(APTR)-1)*8);
  ret->ml_NumEntries=ml->ml_NumEntries;
  for(i=0;i<ml->ml_NumEntries;i++)
  {
    if((ret->ml_ME[i].me_Addr=AllocMem(ml->ml_ME[i].me_Length,ml->ml_ME[i].me_Reqs))==NULL)
    {
      ml=(struct MemList *)((ULONG)ml->ml_ME[i].me_Reqs|0x80ul<<(sizeof(APTR)-1)*8);
      for(;i-->0;)
        FreeMem(ret->ml_ME[i].me_Addr,ret->ml_ME[i].me_Length);
      FreeMem(ret,sizeof(struct MemList)-sizeof(struct MemEntry)+
                  sizeof(struct MemEntry)*ret->ml_NumEntries);
      return ml;
    }
    ret->ml_ME[i].me_Length=ml->ml_ME[i].me_Length;
  }
  return ret;
}

FD1(38,void,FreeEntry,struct MemList *ml,A0)
{
  ULONG i;
  for(i=0;i<ml->ml_NumEntries;i++)
    FreeMem(ml->ml_ME[i].me_Addr,ml->ml_ME[i].me_Length);
  FreeMem(ml,sizeof(struct MemList)-sizeof(struct MemEntry)+
             sizeof(struct MemEntry)*ml->ml_NumEntries);
}

FD5(103,void,AddMemList,ULONG size,D0,ULONG attributes,D1,LONG pri,D2,APTR base,A0,STRPTR name,A1)
{
  struct MemHeader *mh;
  /* Should have to look here if it matches some other memheader */
  mh=(struct MemHeader *)base;
  mh->mh_Node.ln_Pri=pri;
  mh->mh_Node.ln_Name=name;
  mh->mh_Attributes=attributes;
  mh->mh_First=(struct MemChunk *)(mh+1);
  mh->mh_First->mc_Next=NULL;
  mh->mh_First->mc_Bytes=size-sizeof(struct MemHeader);
  mh->mh_Lower=base;
  mh->mh_Upper=(APTR)((char *)base+size);
  mh->mh_Free=size-sizeof(struct MemHeader);
  Forbid();
    Enqueue(&SysBase->MemList,&mh->mh_Node);
  Permit();
}

FD1(89,ULONG,TypeOfMem,void *mem,A1)
{
  ULONG ret=0;
  struct MemHeader *mh;
  Forbid();
    mh=(struct MemHeader *)SysBase->MemList.lh_Head;
    while(mh->mh_Node.ln_Succ!=NULL)
    {
      if((ULONG)mem>=(ULONG)mh->mh_Lower&&(ULONG)mem<=(ULONG)mh->mh_Upper)
      {
        ret=mh->mh_Attributes;
        break;
      }
      mh=(struct MemHeader *)mh->mh_Node.ln_Succ;
    }
  Permit();
  return ret;
}

FD3(104,void,CopyMem,APTR source,A0,APTR dest,A1,unsigned long size,D0)
{
  UBYTE *s=(UBYTE *)source,*d=(UBYTE *)dest;
  if(size&1)
  {
    *d++=*s++;
    size--;
  }
  if(size&2)
  {
    *d++=*s++;
    *d++=*s++;
    size-=2;
  }
  size>>=2;
  if(size)
    do
    {
      *d++=*s++;
      *d++=*s++;
      *d++=*s++;
      *d++=*s++;      
    }
    while(--size);    
}

FD3(105,void,CopyMemQuick,ULONG *source,A0,ULONG *dest,A1,ULONG size,D0)
{
  if(size&4)
  {
    *dest++=*source++;
    size-=4;
  }
  if(size&8)
  {
    *dest++=*source++;
    *dest++=*source++;
    size-=8;
  }
  size>>=4;
  if(size)
    do
    {
      *dest++=*source++;
      *dest++=*source++;
      *dest++=*source++;
      *dest++=*source++;      
    }
    while(--size);
}

FD1(36,ULONG,AvailMem,ULONG attributes,D1)
{ return 0; }

FD3(116,void *,CreatePool,ULONG memFlags,D0,ULONG puddleSize,D1,ULONG treshSize,D2)
{ return NULL; }

FD1(117,void,DeletePool,void *poolHeader,A0)
{}

FD2(118,void *,AllocPooled,void *poolHeader,A0,ULONG memSize,D0)
{ return NULL; }

FD3(119,void,FreePooled,void *poolHeader,A0,void *memory,A1,ULONG memSize,D0)
{}

FD1(129,void,AddMemHandler,struct Interrupt *memHandler,A1)
{}

FD1(130,void,RemMemHandler,struct Interrupt *memHandler,A1)
{}
