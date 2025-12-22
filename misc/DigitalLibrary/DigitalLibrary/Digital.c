/*
// ##########################################################################
// ####                                                                  ####
// ####     DigitalLibrary - An Amiga library for memory allocation      ####
// ####    =========================================================     ####
// ####                                                                  ####
// #### Digital.c                                                        ####
// ####                                                                  ####
// #### Version 1.00  --  October 06, 2000                               ####
// ####                                                                  ####
// #### Copyright (C) 1992  Thomas Dreibholz                             ####
// ####                     Molbachweg 7                                 ####
// ####                     51674 Wiehl/Germany                          ####
// ####                     EMail: Dreibholz@bigfoot.com                 ####
// ####                     WWW:   http://www.bigfoot.com/~dreibholz     ####
// ####                                                                  ####
// ##########################################################################
*/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/


#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/memory.h>
#include <exec/tasks.h>

#ifndef MEMF_NORM
#define MEMF_NORM MEMF_CLEAR|MEMF_PUBLIC
#endif

struct DRemember                  /* Zur Verkettung von Speicherlisten  */
{
 struct DRemember *NextRemember;  /* Zeiger auf nächste Liste */
 ULONG MemorySize;                /* Größe des Speicherblocks */
 ULONG MemoryBlock;                /* Zeiger auf Speicherblock */
};
struct DRememberHeader            /* Hauptstruktur der Verkettungsliste */
{
 struct DRemember *FirstRemember; /* Zeiger auf erste Liste   */
 struct DRemember *LastRemember;  /* Zeiger auf letzte Liste  */
 struct DRemember DRemember;      /* DRemember für 1. Block   */
};
struct DMemory                    /* Liste für unverkettete Blöcke      */
{
 ULONG MemorySize;                /* Größe des Blocks         */
 UBYTE Bytes[];                   /* Speicherblock            */
};
struct DAddress                   /* Liste für unverkettete Blöcke bei  */
{                                 /* AllocAddress()                     */
 ULONG MemorySize;                /* Größe des Blocks           */
 ULONG Align;                     /* 4 Bytes für gerade Adresse */
 UBYTE Bytes[];                   /* Speicherblock              */
};
struct DMemHeader                 /* MemList-Verwaltung                 */
{
 struct MemHeader ExecHeader;     /* MemHeader-Struktur       */
 struct MemChunk ExecChunk;       /* Erster MemChunk          */
};

/* Routine für die D-Memory-Belegung */
ULONG AllocDMemory(size,flags)
 ULONG size;
 ULONG flags;
{
 register struct DMemory *mem;
 size+=4;
 mem=AllocMem(size,flags);
 if(mem==NULL) return(NULL);
 mem->MemorySize=size;
 return((ULONG)mem+4L);
}
/* ================================= */

ULONG AllocChipMem(size)
 ULONG size;
{
 return(AllocDMemory(size,MEMF_CHIP|MEMF_NORM));
}
ULONG AllocFastMem(size)
 ULONG size;
{
 return(AllocDMemory(size,MEMF_FAST|MEMF_NORM));
}
ULONG AllocMemory(size)
 ULONG size;
{
 return(AllocDMemory(size,MEMF_FAST|MEMF_NORM));
}
VOID FreeMemory(mem)
 struct DMemory *mem;
{
 mem=(struct DMemory *)((ULONG)mem-4L);
 FreeMem(mem,mem->MemorySize);
}

/* Routine für die DRemember-Belegung */
ULONG AllocDRemember(size,flags)
 ULONG size;
 ULONG flags;
{
 REGISTER ULONG mem;
 register struct Task *task;
 register struct DRememberHeader *rh;
 register struct DRemember *rm;
 task=FindTask(NULL);
 rh=task->tc_UserData;
 if(rh==NULL)
  {
   rh=AllocMem(sizeof(struct DRememberHeader),MEMF_NORM);
   if(rh==NULL) return(0L);
   mem=AllocMem(size,flags);
   if(mem==NULL) { FreeMem(rh,sizeof(struct DRememberHeader)); return(0L); }
   Forbid();
   rh->FirstRemember=&rh->DRemember;
   rh->LastRemember=&rh->DRemember;
   rh->DRemember.NextRemember=NULL;
   rh->DRemember.MemorySize=size;
   rh->DRemember.MemoryBlock=mem;
   task->tc_UserData=rh;
   Permit();
   return(mem);
  }
 else
  {
   rm=AllocMem(sizeof(struct DRemember),MEMF_NORM);
   if(rm==NULL) return(NULL);
   mem=AllocMem(size,flags);
   if(mem==NULL) { FreeMem(rm,sizeof(struct DRemember)); return(0L); }
   rm->NextRemember=NULL;
   rm->MemorySize=size;
   rm->MemoryBlock=mem;
   Forbid();
   rh->LastRemember->NextRemember=rm;
   rh->LastRemember=rm;
   Permit();
   return(mem);
  }
}
/* ================================== */

ULONG AllocRChipMem(size)
 ULONG size;
{
 return(AllocDRemember(size,MEMF_CHIP|MEMF_NORM));
}
ULONG AllocRFastMem(size)
 ULONG size;
{
 return(AllocDRemember(size,MEMF_FAST|MEMF_NORM));
}
ULONG AllocRMemory(size)
 ULONG size;
{
 return(AllocDRemember(size,MEMF_NORM));
}
VOID FreeRMemory()
{
 register struct Task *task;
 register struct DRememberHeader *rh;
 register struct DRemember *rm,*copy;
 task=FindTask(NULL);
 rh=task->tc_UserData;
 if(rh!=NULL)
  {
   rm=rh->FirstRemember;
   while(rm!=NULL)
    {
     copy=rm->NextRemember;
     FreeMem(rm->MemoryBlock,rm->MemorySize);
     FreeMem(rm,sizeof(struct DRemember));
     rm=copy;
    }
   FreeMem(rh,8L);
   task->tc_UserData=NULL;
  }
}

struct DMemHeader *CreateMemHeader(size,attr,pri,mem,name)
 ULONG size;
 ULONG attr;
 ULONG pri;
 ULONG mem;
 UBYTE *name;
{
 register struct DMemHeader *hd;
 hd=AllocMem(sizeof(struct DMemHeader),MEMF_NORM);
 if(hd==NULL) return(NULL);
 hd->ExecChunk.mc_Next=NULL;
 hd->ExecChunk.mc_Bytes=size;
 hd->ExecHeader.mh_Node.ln_Succ=NULL;
 hd->ExecHeader.mh_Node.ln_Pred=NULL;
 hd->ExecHeader.mh_Node.ln_Type=NT_MEMORY;
 hd->ExecHeader.mh_Node.ln_Name=name;
 hd->ExecHeader.mh_Node.ln_Pri=pri;
 hd->ExecHeader.mh_Attributes=attr;
 hd->ExecHeader.mh_First=&hd->ExecChunk;
 hd->ExecHeader.mh_Lower=mem;
 hd->ExecHeader.mh_Upper=mem+(ULONG)size;
 hd->ExecHeader.mh_Free=size;
 return(hd);
}
VOID DeleteMemHeader(hd)
 struct DMemHeader *hd;
{
 FreeMem(hd,sizeof(struct DMemHeader));
}
ULONG AllocLMemory(hd,size)
 struct DMemHeader *hd;
 ULONG size;
{
 register struct DMemory *mem;
 size+=4;
 mem=Allocate(hd,size);
 if(mem==NULL) return(0L);
 mem->MemorySize=size;
 return((ULONG)mem+4L);
}
VOID FreeLMemory(hd,mem)
 struct DMemHeader *hd;
 struct DMemory *mem;
{
 mem=(struct DMemory *)((ULONG)mem-4L);
 Deallocate(hd,mem,mem->MemorySize);
}

ULONG AvailChipMem()
{
 return(AvailMem(MEMF_CHIP));
}
ULONG AvailFastMem()
{
 return(AvailMem(MEMF_FAST));
}
ULONG AvailMemory()
{
 return(AvailMem(MEMF_PUBLIC));
}
ULONG AvailLMemory(hd)
 struct DMemHeader *hd;
{
 return(hd->ExecHeader.mh_Free);
}

/* ######### New functions added for Version 38 ######################### */

struct DRememberHeader *BackupRList()
{
 register struct Task *task;
 task=FindTask(NULL);
 return(task->tc_UserData);
}
VOID RestoreRList(rh)
 struct DRememberHeader *rh;
{
 register struct Task *task;
 task=FindTask(NULL);
 task->tc_UserData=rh;
}

ULONG AllocAddress(size,location)
 ULONG size;
 ULONG location;
{
 register struct DAddress *mem;
 size+=8;
 location-=8;
 mem=AllocAbs(size,location);
 if(mem==NULL) return(NULL);
 mem->MemorySize=size;
 return((ULONG)mem+8L);
}

ULONG AllocRAddress(size,location)
 ULONG size;
 ULONG location;
{
 REGISTER ULONG mem;
 register struct Task *task;
 register struct DRememberHeader *rh;
 register struct DRemember *rm;
 task=FindTask(NULL);
 rh=task->tc_UserData;
 if(rh==NULL)
  {
   rh=AllocMem(sizeof(struct DRememberHeader),MEMF_NORM);
   if(rh==NULL) return(0L);
   mem=AllocAbs(size,location);
   if(mem==NULL) { FreeMem(rh,sizeof(struct DRememberHeader)); return(0L); }
   Forbid();
   rh->FirstRemember=&rh->DRemember;
   rh->LastRemember=&rh->DRemember;
   rh->DRemember.NextRemember=NULL;
   rh->DRemember.MemorySize=size;
   rh->DRemember.MemoryBlock=mem;
   task->tc_UserData=rh;
   Permit();
   return(mem);
  }
 else
  {
   rm=AllocMem(sizeof(struct DRemember),MEMF_NORM);
   if(rm==NULL) return(NULL);
   mem=AllocAbs(size,location);
   if(mem==NULL) { FreeMem(rm,sizeof(struct DRemember)); return(0L); }
   rm->NextRemember=NULL;
   rm->MemorySize=size;
   rm->MemoryBlock=mem;
   Forbid();
   rh->LastRemember->NextRemember=rm;
   rh->LastRemember=rm;
   Permit();
   return(mem);
  }
}

