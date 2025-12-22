/*
** $PROJECT: xrefsupport.lib
**
** $VER: scanpattern.c 1.2 (22.09.94) 
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994
** All Rights Reserved !
**
** $HISTORY:
**
** 22.09.94 : 001.002 :  SPM_DIR now gets the complete relative path
** 09.09.94 : 001.001 :  initial
*/

/* ------------------------------- includes ------------------------------- */

#include "/source/def.h"

#include "xrefsupport.h"

/* ------------------------------- defines -------------------------------- */

#define ANCHOR_BUFFER         512
#define PATH_BUFFER           512

#define EOS                   '\0'

/* ------------------------------ structures ------------------------------ */

struct ScanDirData
{
   struct FileInfoBlock *sdd_Fib;
   struct Hook *sdd_CallBack;
   APTR sdd_UserData;
   UBYTE sdd_Path[PATH_BUFFER];
   UBYTE sdd_RealPath[PATH_BUFFER];
};

/* --------------------------- local prototypes --------------------------- */

static LONG scan_dir(struct ScanDirData *dirdata);

/* ------------------------------ functions ------------------------------- */

LONG scan_patterns(STRPTR *patterns,struct Hook *callback,APTR userdata)
{
   LONG err = 0;
   struct ScanDirData *dirdata = NULL;
   struct AnchorPath *anchor;

   if((anchor = AllocMem(sizeof(*anchor)+ANCHOR_BUFFER, MEMF_ANY | MEMF_CLEAR)))
   {
      anchor->ap_Strlen    = ANCHOR_BUFFER;
      anchor->ap_BreakBits = SIGBREAKF_CTRL_C;

      do
      {
         if((err = MatchFirst(*patterns, anchor)) == 0)
         {
            do
            {
               if(anchor->ap_Info.fib_DirEntryType > 0)
               {
                  if(!dirdata)
                  {
                     if((dirdata = AllocMem(sizeof(*dirdata),MEMF_ANY | MEMF_CLEAR)))
                     {
                        dirdata->sdd_Fib      = AllocDosObject(DOS_FIB,NULL);
                        dirdata->sdd_CallBack = callback;
                        dirdata->sdd_UserData = userdata;
                     }
                  }

                  if(dirdata && dirdata->sdd_Fib)
                  {
                     BPTR old;
                     BPTR dir;

                     strcpy(dirdata->sdd_Path    ,"");
                     strcpy(dirdata->sdd_RealPath,anchor->ap_Buf);

                     old = CurrentDir(anchor->ap_Current->an_Lock);
                     if((dir = Lock(anchor->ap_Info.fib_FileName,SHARED_LOCK)))
                     {
                        CurrentDir(dir);
                        if(!(err = CallHook(callback,(Object *) userdata,
                                            SPM_DIR,
                                            dirdata->sdd_Fib,
                                            NULL,
                                            dirdata->sdd_Path,
                                            dirdata->sdd_RealPath)))
                        {
                           err = scan_dir(dirdata);
                        }
                     }
                     CurrentDir(old);
                     UnLock(dir);
                  } else
                     err = ERROR_NO_FREE_STORE;
               } else if(anchor->ap_Info.fib_DirEntryType < 0)
               {
                  BPTR fh;
                  BPTR olddir;

                  olddir = CurrentDir(anchor->ap_Current->an_Lock);
                  if((fh = Open(anchor->ap_Info.fib_FileName,MODE_OLDFILE)))
                  {
                     err = CallHook(callback,(Object *) userdata,
                                    SPM_FILE,
                                    &anchor->ap_Info,
                                    fh,
                                    anchor->ap_Info.fib_FileName,
                                    anchor->ap_Buf);
                     Close(fh);
                  }
                  CurrentDir(olddir);
               }

            } while(err == 0 && (err = MatchNext(anchor)) == 0);
         }

         if(err == ERROR_NO_MORE_ENTRIES)
         {
            SetIoErr(0);
            err = 0;
         }

         patterns++;
      } while(*patterns && err == 0);

      if(dirdata)
      {
         if(dirdata->sdd_Fib)
            FreeDosObject(DOS_FIB,dirdata->sdd_Fib);

         FreeMem(dirdata,sizeof(*dirdata));
      }

      FreeMem(anchor,sizeof(*anchor)+ANCHOR_BUFFER);
   }

   return(err);
}

static LONG scan_dir(struct ScanDirData *dirdata)
{
   LONG retval = 0;
   BPTR dir;

   if(dir = Lock(dirdata->sdd_Path,SHARED_LOCK))
   {
      if(Examine(dir,dirdata->sdd_Fib))
      {
         while(ExNext(dir,dirdata->sdd_Fib) && retval == 0)
         {
            if(SetSignal(0,SIGBREAKF_CTRL_C) & SIGBREAKF_CTRL_C)
            {
               SetIoErr(ERROR_BREAK);
               break;
            }

            if(AddPart(dirdata->sdd_Path,dirdata->sdd_Fib->fib_FileName,PATH_BUFFER))
            {
               if(AddPart(dirdata->sdd_RealPath,dirdata->sdd_Fib->fib_FileName,PATH_BUFFER))
               {
                  if(dirdata->sdd_Fib->fib_DirEntryType > 0)
                  {
                     if(!(retval = CallHook(dirdata->sdd_CallBack,(Object *) dirdata->sdd_UserData,
                                            SPM_DIR,
                                            dirdata->sdd_Fib,
                                            NULL,
                                            dirdata->sdd_Path,
                                            dirdata->sdd_RealPath)))
                        retval = scan_dir(dirdata);
                  }
                  else
                  {
                     BPTR fh;

                     if((fh = Open(dirdata->sdd_Path,MODE_OLDFILE)))
                     {
                        retval = CallHook(dirdata->sdd_CallBack,(Object *) dirdata->sdd_UserData,
                                          SPM_FILE,
                                          dirdata->sdd_Fib,
                                          fh,
                                          dirdata->sdd_Path,
                                          dirdata->sdd_RealPath);
                        Close(fh);
                     }
                  }

                  *PathPart(dirdata->sdd_RealPath) = EOS;
               }
               *PathPart(dirdata->sdd_Path) = EOS;
            }
         }

         if(retval == 0)
            if((retval = IoErr()) == ERROR_NO_MORE_ENTRIES)
            {
               retval = 0;
               SetIoErr(0);
            }

      }
      UnLock(dir);
   }

   return(retval);
}

static RegCall LONG stathook(REGA0 struct Hook *hook,REGA2 struct ScanStat *stat,REGA1 struct spMsg *msg)
{
   switch(msg->Msg)
   {
   case SPM_DIR:
      stat->ss_Directories++;
      break;
   case SPM_FILE:
      stat->ss_Files++;
      stat->ss_TotalFileSize += msg->Fib->fib_Size;
      break;
   }

   return(0);
}

void getscanstat(STRPTR *patterns,struct ScanStat *stat)
{
   struct Hook scanstat = {NULL};

   scanstat.h_Entry = (HOOKFUNC) stathook;

   stat->ss_Directories   = 0;
   stat->ss_Files         = 0;
   stat->ss_TotalFileSize = 0;

   scan_patterns(patterns,&scanstat,stat);
}

