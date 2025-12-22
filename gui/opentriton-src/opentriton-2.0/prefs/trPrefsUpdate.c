/*
 *  OpenTriton -- A free release of the triton.library source code
 *  Copyright (C) 1993-1998  Stefan Zeiger
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  trPrefsUpdate/trPrefsUpdate.c - Prefs updator
 *
 */


#define TRPREFSUPDATE_VERSION "3.2"
#define TRPREFSUPDATE_RELEASE "1.3"
#define TRPREFSUPDATE_DATE    "3.6.95"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON
#define TR_PREFSONLY

#include <exec/memory.h>
#include <dos/dos.h>
#include <graphics/gfx.h>
#include <libraries/gadtools.h>
#include <libraries/triton.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/dos.h>
#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <pragmas/exec_pragmas.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Triton.h"
#include "/internal.h"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////// Global variables //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct TR_AppPrefsV2
{
  // UBYTE version;
  BOOL  frames_width;
  UBYTE frames_title;
  UWORD frames_type[5];
  BOOL  frames_raised[5];
  UBYTE pens_windowback;
  UBYTE pens_reqback;
  UBYTE pubscreen[32];
};

struct TR_AppPrefsV3
{
  // UBYTE version;
  BOOL  frames_width;
  UBYTE frames_title;
  UWORD frames_type[5];
  BOOL  frames_raised[5];
  ULONG pentype[8];
  ULONG pendata[8];
  ULONG imgtype[4];
  ULONG imgdata[4];
  UBYTE pubscreen[32];
  ULONG flags;
};


struct PrefsNode
{
  struct Node node;
  struct TR_AppPrefs *prefs;
  UBYTE filename[50];
};

struct FileList
{
  struct List list;
  APTR mempool;
};


UBYTE *versionstring="\0$VER: trPrefsUpdate " TRPREFSUPDATE_VERSION " (" TRPREFSUPDATE_DATE ") Triton Preferences Updator, © 1994-1995 by Stefan Zeiger";
struct FileList *prefslist;


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////// Node and prefs handling //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

BOOL LoadAppPrefs(void *pool, struct PrefsNode *prefsnode)
{
  BPTR lock;
  int i;
  struct TR_AppPrefs *prefs;

  struct TR_AppPrefsV2 p2;
  struct TR_AppPrefsV3 p3;

  if(!(prefs=LibAllocPooled(pool,sizeof(struct TR_AppPrefs)))) return FALSE;
  CopyMem((APTR)(&TR_DefaultAppPrefs),(APTR)prefs,sizeof(struct TR_AppPrefs));
  prefsnode->prefs=prefs;

  if(!(lock=Open(prefsnode->filename,MODE_OLDFILE))) return FALSE;
  FRead(lock,(STRPTR)prefs,sizeof(UBYTE),1);
  switch(prefs->version)
  {
    case 2:
      FRead(lock,(STRPTR)(&p2),sizeof(struct TR_AppPrefsV2),1);
      prefs->frames_width=p2.frames_width;
      prefs->frames_title=p2.frames_title;
      //for(i=0;i<4;i++) prefs->frames_type[i]=p2.frames_type[i];
      //for(i=0;i<4;i++) prefs->frames_raised[i]=p2.frames_raised[i];
      //for(i=0;i<31;i++) prefs->pubscreen[i]=p2.pubscreen[i];
      printf("Loaded '%s' in format %d.\n",prefsnode->filename,prefs->version);
      break;
    case 3:
      FRead(lock,(STRPTR)(&p3),sizeof(struct TR_AppPrefsV3),1);
      CopyMem((APTR)(&p3),(APTR)(((ULONG)prefs)+1),sizeof(struct TR_AppPrefsV3));
      printf("Loaded '%s' in format %d.\n",prefsnode->filename,prefs->version);
      break;
    default:
      printf("File '%s' has wrong format (%d)!\n",prefsnode->filename,prefs->version);
      Close(lock);
      prefsnode->prefs=NULL;
      return FALSE;
  }
  Close(lock);

  return TRUE;
}


VOID SaveAllAppPrefs(struct FileList *fl)
{
  struct Node *worknode;
  BPTR lock;

  worknode=(struct Node *)(((struct List *)fl)->lh_Head);
  while(worknode)
  {
    if(((struct PrefsNode *)worknode)->prefs)
    {
      if(lock=Open(((struct PrefsNode *)worknode)->filename,MODE_NEWFILE))
      {
        FWrite(lock,(STRPTR)(((struct PrefsNode *)worknode)->prefs),sizeof(struct TR_AppPrefs),1);
        Close(lock);
        printf("Saved '%s' in format %d.\n",((struct PrefsNode *)worknode)->filename,TR_PREFSVERSION);
      } else printf("Can't save '%s'.\n",((struct PrefsNode *)worknode)->filename);
    }
    worknode=(struct Node *)(worknode->ln_Succ);
  }
}


void DeleteFileList(struct FileList *fl)
{
  if(!fl) return;
  LibDeletePool(fl->mempool);
}


struct FileList *CreatePrefsList(void)
{
  struct FileList *fl;
  struct Node *node;
  void *pool;
  struct FileInfoBlock *fib=NULL;
  BPTR lock;
  BOOL ok=TRUE;
  UBYTE totalfilename[50];

  if(!(pool=LibCreatePool(MEMF_CLEAR,1024,512))) return NULL;
  if(!(fl=LibAllocPooled(pool,sizeof(struct FileList)))) { LibDeletePool(pool); return NULL; }
  fl->mempool=pool;
  NewList((struct List *)fl);

  if(!(lock=Lock("envarc:Triton",ACCESS_READ))) { ok=FALSE; goto cleanup; }
  if(!(fib=(struct FileInfoBlock *)AllocDosObject(DOS_FIB,NULL))) { ok=FALSE; goto cleanup; }
  if(!(Examine(lock,fib))) { ok=FALSE; goto cleanup; }
  while(ExNext(lock,fib))
  {
    sprintf(totalfilename,"envarc:Triton/%s",fib->fib_FileName);
    if(strstr(totalfilename,".tri"))
    {
      if(node=LibAllocPooled(pool,sizeof(struct PrefsNode)))
      {
        strcpy(((struct PrefsNode *)node)->filename,totalfilename);
        if(LoadAppPrefs(pool,((struct PrefsNode *)node)))
        {
          AddTail((struct List *)fl,node);
        } else printf("Can't load '%s'.\n",totalfilename);
      }
      else printf("Not enough memory to load '%s'.\n",totalfilename);
    }
  }

  cleanup:
  if(fib) FreeDosObject(DOS_FIB,(void *)fib);
  if(lock) UnLock(lock);
  if(ok) return fl;
  DeleteFileList(fl);
  return NULL;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Check prefs //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

BOOL checkprefs(void)
{
  BPTR lock;

  if(lock=Lock("envarc:Triton",ACCESS_READ)) { UnLock(lock); return TRUE; }
  else return FALSE;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////// main() //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

int main(void)
{
  if(!checkprefs()) { puts("Triton Preferences system is not installed."); return 0; }

  if(prefslist=CreatePrefsList())
  {
    SaveAllAppPrefs(prefslist);
    Execute("c:delete env:Triton all",NULL,NULL);
    Execute("c:makedir env:Triton",NULL,NULL);
    Execute("c:copy envarc:Triton/#? env:Triton/",NULL,NULL);
    DeleteFileList(prefslist);
  } else { puts("Not enough memory to create preferences list."); return 20; }

  return 0;
}
