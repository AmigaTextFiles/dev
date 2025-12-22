#include <proto/alib.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/utility.h>
#include <proto/iffparse.h>
#include <proto/intuition.h>

#include "Global.h"

/************************************************************************/

struct ScoreHandle
{
  const struct GS_ScoreDef *ScoreDef;
  const char *UserName;
  BPTR DirLock;
  struct
    {
      struct DateStamp LastChanged;	/* the timestamp that was valid when we read Scores */
      struct GS_ScoreList Scores;	/* current file contents */
      char *Filename;			/* relative to DirLock */
    } FileData[3];
};

/************************************************************************/

static char LockFilename[]=".lock.scores";
static char TempFilename[]=".temp.scores";

/****** gamesupport.library/GS_ObtainScoreHandle *************************
*
*   NAME
*	GS_ObtainScoreHandle -- obtain a handle to access score files
*
*   SYNOPSIS
*	ScoreHandle = GS_ObtainScoreHandle(ScoreDef, SubPath, UserName)
*	     d0                              a0        a1        a2
*
*	void *GS_ObtainScoreHandle(const struct GS_ScoreDef *, const char *,
*	                           const char *);
*
*   FUNCTION
*	Get a handle for later access to the score files
*
*   INPUTS
*	ScoreDef    - an initialized GS_ScoreDef structure.
*	SubPath     - an optional path, which can be used if the
*	              game keeps several score files.
*	UserName    - the user name. NULL or "" specifies the
*	              generic ("unknown") user.
*
*   RESULT
*	ScoreHandle - a handle to use with the other score functions.
*	              NULL for failure.
*
*   NOTE
*	UserName and ScoreDef must remain valid and unchanged for the
*	lifespan of the handle.
*
*   NOTE
*	The current search path is
*	    GAMESTUFF:<GameName> scores/<SubPath/>
*	    <GameName>:<GameName> scores/<SubPath/>
*	    PROGDIR:<GameName> scores/<SubPath/>
*
*************************************************************************/

SAVEDS_ASM_A0A1A2(void *,LibGS_ObtainScoreHandle,const struct GS_ScoreDef *,ScoreDef,const char *,SubPath,const char *,UserName)

{
  struct ScoreHandle *ScoreHandle;
  char *ThePath;
  LONG Error;

  Error=0;
  ScoreHandle=NULL;
  if (UserName!=NULL && *UserName=='\0')
    {
      UserName=NULL;
    }

  /* construct the relative path string */
  {
    const char *Params[2];

    Params[0]=ScoreDef->GameName;
    Params[1]=SubPath;
    ThePath=GS_FormatString("%s scores/%s",Params,NULL,NULL);
  }

  if (ThePath!=NULL)
    {
      APTR WindowPtr;
      int MissingLevels;

      WindowPtr=((struct Process *)FindTask(NULL))->pr_WindowPtr;
      MissingLevels=0;
      do
	{
	  int DirNumber;

	  for (DirNumber=0; ScoreHandle==NULL && Error==0 && DirNumber<3; DirNumber++)
	    {
	      char *Path;

	      if (DirNumber==0)
		{
		  Path=GS_FormatString("GAMESTUFF:%s",&ThePath,NULL,NULL);
		}
	      else if (DirNumber==1)
		{
		  const char *Params[2];

		  Params[0]=ScoreDef->GameName;
		  Params[1]=ThePath;
		  Path=GS_FormatString("%s:%s",Params,NULL,NULL);
		}
	      else
		{
		  Path=GS_FormatString("PROGDIR:%s",&ThePath,NULL,NULL);
		}
	      if (Path!=NULL)
		{
		  BPTR PathLock;

		  ((struct Process *)FindTask(NULL))->pr_WindowPtr=(APTR)-1;
		  while (Error==0 && (PathLock=Lock(Path,SHARED_LOCK))==MKBADDR(NULL))
		    {
		      LONG Err;

		      Err=IoErr();
		      if (Err==ERROR_OBJECT_IN_USE)
			{
			  Delay(TICKS_PER_SECOND);
			}
		      else if (Err==ERROR_OBJECT_NOT_FOUND || Err==ERROR_DIR_NOT_FOUND || Err==ERROR_DEVICE_NOT_MOUNTED)
			{
			  break;
			}
		      else
			{
			  Error=Err;
			}
		    }
		  if (PathLock!=MKBADDR(NULL))
		    {
		      struct InfoData ALIGN(InfoData);

		      ((struct Process *)FindTask(NULL))->pr_WindowPtr=WindowPtr;
		      if (Info(PathLock,&InfoData))
			{
			  if (InfoData.id_DiskState==ID_WRITE_PROTECTED)
			    {
			      UnLock(PathLock);
			      PathLock=MKBADDR(NULL);
			    }
			}
		      else
			{
			  Error=IoErr();
			}
		    }
		  if (PathLock!=MKBADDR(NULL))
		    {
		      while (Error==0 && MissingLevels>0)
			{
			  BPTR DirLock;
			  char *NewDir;

			  if (ThePath[0]=='\0')
			    {
			      ThePath[0]=ScoreDef->GameName[0];
			      NewDir=ThePath;
			    }
			  else
			    {
			      NewDir=ThePath+strlen(ThePath);
			      assert(NewDir[0]=='\0');
			      *(NewDir++)='/';
			    }
			  PathLock=CurrentDir(PathLock);
			  if ((DirLock=CreateDir(NewDir))!=MKBADDR(NULL))
			    {
			      if (!ChangeMode(CHANGE_LOCK,DirLock,SHARED_LOCK))
				{
				  LONG Err;

				  Err=IoErr();
				  if (Err==ERROR_ACTION_NOT_KNOWN)
				    {
				      UnLock(DirLock);
				      if ((DirLock=Lock(NewDir,SHARED_LOCK))==MKBADDR(NULL))
					{
					  Error=IoErr();
					}
				    }
				  else
				    {
				      Error=Err;
				    }
				}
			      assert(DirLock!=MKBADDR(NULL) || Error!=0);
			      if (Error!=0 && DirLock!=MKBADDR(NULL))
				{
				  UnLock(DirLock);
				  DirLock=MKBADDR(NULL);
				}
			    }
			  else
			    {
			      LONG Err;

			      Err=IoErr();
			      if (Err==ERROR_OBJECT_EXISTS)
				{
				  while ((DirLock=Lock(NewDir,SHARED_LOCK))==MKBADDR(NULL) &&
					 (Err=IoErr())==ERROR_OBJECT_IN_USE)
				    {
				      Delay(TICKS_PER_SECOND);
				    }
				}
			    }
			  PathLock=CurrentDir(PathLock);
			  assert((DirLock!=MKBADDR(NULL) && Error==0) || (DirLock==MKBADDR(NULL) && Error!=0));
			  if (DirLock!=MKBADDR(NULL))
			    {
			      UnLock(PathLock);
			      PathLock=DirLock;
			      MissingLevels--;
			    }
			}
		      assert(PathLock!=MKBADDR(NULL));
		      if (Error==0)
			{
			  BPTR DirLock;

			  PathLock=CurrentDir(PathLock);
			  if ((DirLock=CreateDir("Personal scores"))==MKBADDR(NULL))
			    {
			      LONG Err;

			      Err=IoErr();
			      if (Err!=ERROR_OBJECT_EXISTS)
				{
				  Error=Err;
				}
			    }
			  else
			    {
			      UnLock(DirLock);
			    }
			  PathLock=CurrentDir(PathLock);
			  if ((ScoreHandle=GS_MemoryAlloc(sizeof(*ScoreHandle)))!=NULL)
			    {
			      int i;

			      ScoreHandle->ScoreDef=ScoreDef;
			      ScoreHandle->UserName=UserName;
			      ScoreHandle->DirLock=PathLock;
			      for (i=0; Error==0 && i<3; i++)
				{
				  ScoreHandle->FileData[i].LastChanged.ds_Days=0;
				  ScoreHandle->FileData[i].LastChanged.ds_Minute=0;
				  ScoreHandle->FileData[i].LastChanged.ds_Tick=0;
				  NewList((struct List *)&ScoreHandle->FileData[i].Scores.List);
				  ScoreHandle->FileData[i].Scores.Count=0;
				  switch (i)
				    {
				    case GS_SCORE_ROLL:
				      ScoreHandle->FileData[i].Filename="Roll of honour";
				      break;

				    case GS_SCORE_TODAY:
				      ScoreHandle->FileData[i].Filename="Todays contenders";
				      break;

				    case GS_SCORE_PERSONAL:
				      if (UserName!=NULL)
					{
					  char *Filename;

					  if ((Filename=GS_TransformUsername(UserName,NULL))!=NULL)
					    {
					      if ((ScoreHandle->FileData[i].Filename=GS_FormatString("Personal scores/%s",&Filename,NULL,NULL))==NULL)
						{
						  Error=ERROR_NO_FREE_STORE;
						}
					      GS_MemoryFree(Filename);
					    }
					  else
					    {
					      Error=ERROR_NO_FREE_STORE;
					    }
					}
				      else
					{
					  ScoreHandle->FileData[i].Filename=NULL;
					}
				    }
				}
			      if (Error==0)
				{
				  PathLock=MKBADDR(NULL);
				}
			      else
				{
				  GS_MemoryFree(ScoreHandle);
				}
			    }
			  else
			    {
			      Error=ERROR_NO_FREE_STORE;
			    }
			}
		      if (PathLock!=MKBADDR(NULL))
			{
			  UnLock(PathLock);
			}
		    }
		}
	      else
		{
		  Error=ERROR_NO_FREE_STORE;
		}
	      GS_MemoryFree(Path);
	    }
	  if (ScoreHandle==NULL && Error==0)
	    {
	      if (ThePath[0]=='\0')
		{
		  Error=-1;
		}
	      else
		{
		  char *t;

		  t=PathPart(ThePath);
		  *t='\0';
		  MissingLevels++;
		}
	    }
	}
      while (Error==0 && ScoreHandle==NULL);
      ((struct Process *)FindTask(NULL))->pr_WindowPtr=WindowPtr;
      GS_MemoryFree(ThePath);
    }
  else
    {
      Error=ERROR_NO_FREE_STORE;
    }
  SetIoErr(Error);
  return ScoreHandle;
}

/************************************************************************/
/*									*/
/* Free a score list							*/
/*									*/
/************************************************************************/

static void FreeScores(struct GS_ScoreList *Scores)

{
  struct GS_Score *Score;

  while ((Score=(struct GS_Score *)RemHead((struct List *)&Scores->List))!=NULL)
    {
      GS_MemoryFree(Score);
      Scores->Count--;
    }
  assert(Scores->Count==0);
}

/****** gamesupport.library/GS_ReleaseScoreHandle ************************
*
*   NAME
*	GS_ReleaseScoreHandle -- release a score handle
*
*   SYNOPSIS
*	GS_ReleaseScoreHandle(ScoreHandle)
*	                           a0
*
*	void GS_ReleaseScoreHandle(void *);
*
*   FUNCTION
*	Release a handle obtained from GS_ObtainScoreHandle().
*
*   INPUTS
*	ScoreHandle - the score handle to release, or NULL
*
*************************************************************************/

SAVEDS_ASM_A0(void,LibGS_ReleaseScoreHandle,struct ScoreHandle *,ScoreHandle)

{
  if (ScoreHandle!=NULL)
    {
      ULONG i;

      UnLock(ScoreHandle->DirLock);
      for (i=0; i<ARRAYSIZE(ScoreHandle->FileData); i++)
	{
	  FreeScores(&ScoreHandle->FileData[i].Scores);
	}
      GS_MemoryFree(ScoreHandle->FileData[2].Filename);
      GS_MemoryFree(ScoreHandle);
    }
}

/************************************************************************/
/*									*/
/*									*/
/************************************************************************/

static int MyStrcmp(const char *String1, const char *String2)

{
  if (String1==NULL)
    {
      String1="";
    }
  if (String2==NULL)
    {
      String2="";
    }
  return strcmp(String1,String2);
}

/************************************************************************/
/*									*/
/* Insert a score into a score list.					*/
/* If it returns non-NULL, the returned score fell out of the table.	*/
/*									*/
/************************************************************************/

static struct GS_Score *InsertScore(struct ScoreHandle *ScoreHandle, struct GS_Score *Score, struct GS_ScoreList *Scores, ULONG ScoreType)

{
  struct GS_Score *Current;
  struct GS_Score *Pred;
  int Flag;

  Flag=FALSE;
  for (Current=(struct GS_Score *)Scores->List.mlh_Head, Pred=NULL;
       Current->Node.mln_Succ!=NULL;
       Pred=Current, Current=(struct GS_Score *)Current->Node.mln_Succ)
    {
      if (ScoreType==GS_SCORE_PERSONAL)
	{
	  if ((LONG)CallHookPkt(ScoreHandle->ScoreDef->CompareHook,Score,Current)>0)
	    {
	      Insert((struct List *)&Scores->List,(struct Node *)&Score->Node,(struct Node *)&Pred->Node);
	      Scores->Count++;
	      Flag=TRUE;
	      break;
	    }
	}
      else
	{
	  if (Flag)
	    {
	      if (MyStrcmp(Score->Name,Current->Name)==0)
		{
		  Scores->Count--;
		  Remove((struct Node *)&Current->Node);
		  return Current;
		}
	    }
	  else
	    {
	      if ((LONG)CallHookPkt(ScoreHandle->ScoreDef->CompareHook,Score,Current)>0)
		{
		  Insert((struct List *)&Scores->List,(struct Node *)&Score->Node,(struct Node *)&Pred->Node);
		  Scores->Count++;
		  Flag=TRUE;
		}
	      else
		{
		  if (MyStrcmp(Score->Name,Current->Name)==0)
		    {
		      return NULL;
		    }
		}
	    }
	}
    }
  if (!Flag)
    {
      AddTail((struct List *)&Scores->List,(struct Node *)&Score->Node);
      Scores->Count++;
    }
  if (Scores->Count>ScoreHandle->ScoreDef->TableSize[ScoreType])
    {
      Scores->Count--;
      return (struct GS_Score *)RemTail((struct List *)&Scores->List);
    }
  return NULL;
}

/************************************************************************/
/*									*/
/* Check whether a score has expired.					*/
/*									*/
/************************************************************************/

static int CheckExpire(ULONG TimeStamp, const struct DateStamp *Now)

{
  ULONG Day, Minute, Second;

  Second=TimeStamp;
  Day=Second/(60*60*24);
  Second=Second%(60*60*24);
  Minute=Second/60;
  if (!(Day==Now->ds_Days || (Day==Now->ds_Days-1 && Now->ds_Minute<12*60 && Minute>=21*60)))
    {
      return TRUE;
    }
  return FALSE;
}

/************************************************************************/
/*									*/
/* Read a score table.							*/
/* Returns a DOS (>0) or IFF (<0) error code.				*/
/* In case of error, the scores are unchanged.				*/
/*									*/
/************************************************************************/

static INLINE LONG ReadScoreTable(struct ScoreHandle *ScoreHandle, ULONG ScoreType, BPTR Filehandle, const struct DateStamp *Now)

{
  LONG Error;
  struct Library *IFFParseBase;

  Error=0;
  if ((IFFParseBase=OpenLibrary(IFFParseName,36))!=NULL)
    {
      struct IFFHandle *IFFHandle;

      if ((IFFHandle=AllocIFF())!=NULL)
	{
	  IFFHandle->iff_Stream=(ULONG)Filehandle;
	  InitIFFasDOS(IFFHandle);
	  if (!(Error=OpenIFF(IFFHandle,IFFF_READ)))
	    {
	      if (!(Error=PropChunk(IFFHandle,MAKE_ID('S','C','O','R'),MAKE_ID('P','L','Y','R'))) &&
		  !(Error=PropChunk(IFFHandle,MAKE_ID('S','C','O','R'),MAKE_ID('T','I','M','E'))) &&
		  !(Error=StopOnExit(IFFHandle,MAKE_ID('S','C','O','R'),MAKE_ID('F','O','R','M'))))
		{
		  const struct GS_ScoreDef *ScoreDef;
		  const struct GS_ScoreChunkDef *ChunkDef;
		  LONG i;

		  ScoreDef=ScoreHandle->ScoreDef;
		  for (i=ScoreDef->ChunkCount, ChunkDef=(const struct GS_ScoreChunkDef *)(ScoreDef+1);
		       i-->0 && !(Error=PropChunk(IFFHandle,MAKE_ID('S','C','O','R'),ChunkDef->ChunkID));
		       ChunkDef++)
		    ;
		  if (!Error)
		    {
		      ULONG ScoreSize;
		      struct GS_ScoreList Scores;

		      Scores.Count=0;
		      NewList((struct List *)&Scores.List);
		      ScoreSize=sizeof(struct GS_Score)+sizeof(ULONG)*ScoreDef->ChunkCount;
		      do
			{
			  Error=ParseIFF(IFFHandle,IFFPARSE_SCAN);
			  if (Error==IFFERR_EOC)
			    {
			      const struct StoredProperty *TimeProp;

			      Error=0;
			      TimeProp=FindProp(IFFHandle,MAKE_ID('S','C','O','R'),MAKE_ID('T','I','M','E'));
			      if (TimeProp!=NULL &&
				  TimeProp->sp_Size==sizeof(ULONG) &&
				  (ScoreType!=GS_SCORE_TODAY || !CheckExpire(*(ULONG *)TimeProp->sp_Data,Now)))
				{
				  struct GS_Score *Score;
				  ULONG Size;

				  Size=ScoreSize;

				  for (i=0, ChunkDef=(const struct GS_ScoreChunkDef *)(ScoreDef+1);
				       !Error && i<ScoreDef->ChunkCount;
				       i++, ChunkDef++)
				    {
				      struct StoredProperty *Prop;

				      Prop=FindProp(IFFHandle,MAKE_ID('S','C','O','R'),ChunkDef->ChunkID);
				      if (Prop!=NULL)
					{
					  if (ChunkDef->Flags & GS_SCOREDEFF_INTEGER)
					    {
					      if (Prop->sp_Size!=sizeof(ULONG))
						{
						  continue;
						}
					    }
					}
				      else
					{
					  continue;
					}
				    }
				  if (!Error)
				    {
				      const struct StoredProperty *NameProp;

				      NameProp=FindProp(IFFHandle,MAKE_ID('S','C','O','R'),MAKE_ID('P','L','Y','R'));
				      if (NameProp!=NULL && NameProp->sp_Size!=0)
					{
					  Size+=NameProp->sp_Size+1;
					}
				      if ((Score=GS_MemoryAlloc(Size))!=NULL)
					{
					  char *t;

					  t=((char *)Score)+sizeof(*Score)+sizeof(ULONG)*ScoreDef->ChunkCount;
					  Score->TimeStamp=*(ULONG *)TimeProp->sp_Data;

					  for (i=0, ChunkDef=(const struct GS_ScoreChunkDef *)(ScoreDef+1);
					       i<ScoreDef->ChunkCount;
					       i++, ChunkDef++)
					    {
					      struct StoredProperty *Prop;

					      Prop=FindProp(IFFHandle,MAKE_ID('S','C','O','R'),ChunkDef->ChunkID);
					      if (ChunkDef->Flags & GS_SCOREDEFF_INTEGER)
						{
						  ((ULONG *)(Score+1))[i]=*(ULONG *)Prop->sp_Data;
						}
					    }
					  if (NameProp!=NULL && NameProp->sp_Size!=0)
					    {
					      Score->Name=t;
					      CopyMem(NameProp->sp_Data,t,NameProp->sp_Size);
					      t[NameProp->sp_Size]='\0';
					    }
					  else
					    {
					      Score->Name=NULL;
					    }
					  GS_MemoryFree(InsertScore(ScoreHandle,Score,&Scores,ScoreType));
					}
				      else
					{
					  Error=ERROR_NO_FREE_STORE;
					}
				    }
				}
			    }
			}
		      while (!Error);
		      if (Error==IFFERR_NOMEM)
			{
			  Error=ERROR_NO_FREE_STORE;
			}
		      else if (Error==IFFERR_EOF)
			{
			  Error=0;
			}
		      if (Error!=0)
			{
			  FreeScores(&Scores);
			}
		      else
			{
			  struct GS_Score *Score;

			  FreeScores(&ScoreHandle->FileData[ScoreType].Scores);
			  while ((Score=(struct GS_Score *)RemHead((struct List *)&Scores.List))!=NULL)
			    {
			      AddTail((struct List *)&ScoreHandle->FileData[ScoreType].Scores.List,
				      (struct Node *)&Score->Node);
			      ScoreHandle->FileData[ScoreType].Scores.Count++;
			    }
			  assert(ScoreHandle->FileData[ScoreType].Scores.Count==Scores.Count);
			}
		    }
		}
	      CloseIFF(IFFHandle);
	    }
	  FreeIFF(IFFHandle);
	}
      CloseLibrary(IFFParseBase);
    }
  return Error;
}

/************************************************************************/
/*									*/
/* Update the score list.						*/
/*									*/
/************************************************************************/

static LONG UpdateScores(struct ScoreHandle *ScoreHandle, ULONG ScoreType, int Force)

{
  LONG Error;
  char *Filename;

  Error=0;
  if ((Filename=ScoreHandle->FileData[ScoreType].Filename)!=NULL)
    {
      BPTR OldCurrentDir;
      BPTR FileLock;
      struct DateStamp Now;

      DateStamp(&Now);
      OldCurrentDir=CurrentDir(ScoreHandle->DirLock);
      if (Force)
	{
	  while ((FileLock=Lock(Filename,SHARED_LOCK))==MKBADDR(NULL) && (Error=IoErr())==ERROR_OBJECT_IN_USE)
	    {
	      Delay(TICKS_PER_SECOND);
	    }
	}
      else
	{
	  if ((FileLock=Lock(Filename,SHARED_LOCK))==MKBADDR(NULL))
	    {
	      Error=IoErr();
	    }
	}
      CurrentDir(OldCurrentDir);
      if (FileLock!=MKBADDR(NULL))
	{
	  struct FileInfoBlock ALIGN(FileInfoBlock);

	  Error=0;
	  if (Examine(FileLock,&FileInfoBlock))
	    {
	      if (CompareDates(&FileInfoBlock.fib_Date,&ScoreHandle->FileData[ScoreType].LastChanged))
		{
		  BPTR File;

		  if ((File=OpenFromLock(FileLock))!=MKBADDR(NULL))
		    {
		      FileLock=MKBADDR(NULL);
		      if ((Error=ReadScoreTable(ScoreHandle,ScoreType,File,&Now))==0)
			{
			  ScoreHandle->FileData[ScoreType].LastChanged=FileInfoBlock.fib_Date;
			}
		      Close(File);
		    }
		  else
		    {
		      Error=IoErr();
		    }
		}
	    }
	  else
	    {
	      Error=IoErr();
	    }
	  if (FileLock!=MKBADDR(NULL))
	    {
	      UnLock(FileLock);
	    }
	}
      else
	{
	  if (Error==ERROR_OBJECT_NOT_FOUND)
	    {
	      FreeScores(&ScoreHandle->FileData[ScoreType].Scores);
	      Error=0;
	    }
	}
      if (ScoreType==GS_SCORE_TODAY)
	{
	  struct GS_Score *Score, *Next;

	  for (Score=(struct GS_Score *)ScoreHandle->FileData[ScoreType].Scores.List.mlh_Head;
	       (Next=(struct GS_Score *)Score->Node.mln_Succ)!=NULL;
	       Score=Next)
	    {
	      if (CheckExpire(Score->TimeStamp,&Now))
		{
		  Remove((struct Node *)&Score->Node);
		  GS_MemoryFree(Score);
		}
	    }
	}
    }
  return Error;
}

/****** gamesupport.library/GS_ObtainScores ******************************
*
*    NAME
*	GS_ObtainScores -- obtain a score table
*
*    SYNOPSIS
*	Scores = GS_ObtainScores(ScoreHandle,ScoreType)
*	  d0                        a0         d0
*
*	const GS_ScoreList *GS_ObtainScores(void *, ULONG);
*
*    FUNCTION
*	Return a score table.
*
*    INPUTS
*	ScoreHandle  - a handle describing the files
*	ScoreType    - the file type that we want to read
*
*    RESULT
*	Scores - a (read-only) linked list of scores. NULL for no
*	         scores.
*
*    NOTE
*	This function cannot fail: if we can't read the new scores,
*	the old scores are returned instead. This is because the
*	only thing we can do with the scores is to display them,
*	and it's better to display old scores instead of no scores
*	at all.
*
*    SEE ALSO
*	GS_ObtainScoreHandle(), GS_ReleaseScores()
*
*************************************************************************/

SAVEDS_ASM_D0A0(struct GS_ScoreList *,LibGS_ObtainScores,ULONG,ScoreType,struct ScoreHandle *,ScoreHandle)

{
  struct GS_ScoreList *Scores;

  if (ScoreHandle!=NULL)
    {
      SetIoErr(UpdateScores(ScoreHandle,ScoreType,FALSE));
      Scores=&ScoreHandle->FileData[ScoreType].Scores;
      if (Scores->Count==0)
	{
	  assert(IsListEmpty((struct List *)&Scores->List));
	  Scores=NULL;
	}
    }
  else
    {
      Scores=NULL;
    }
  return Scores;
}

/****** gamesupport.library/GS_ReleaseScores *****************************
*
*    NAME
*	GS_ReleaseScores -- release a score table
*
*    SYNOPSIS
*	GS_ReleaseScores(ScoreHandle, Scores)
*	                   a0           a1
*
*************************************************************************/

SAVEDS_ASM_A0A1(void,LibGS_ReleaseScores,struct ScoreHandle *,ScoreHandle,struct GS_ScoreList *,Scores)

{
}

/************************************************************************/
/*									*/
/* Write a score file							*/
/*									*/
/************************************************************************/

static INLINE LONG WriteScoreTable(const struct ScoreHandle *ScoreHandle, ULONG ScoreType)

{
  BPTR File;
  LONG Error;

  Error=0;
  if ((File=Open(TempFilename,MODE_NEWFILE))!=MKBADDR(NULL))
    {
      struct Library *IFFParseBase;

      if ((IFFParseBase=OpenLibrary(IFFParseName,36))!=NULL)
	{
	  struct IFFHandle *IFFHandle;

	  if ((IFFHandle=AllocIFF()))
	    {
	      LONG Error;

	      IFFHandle->iff_Stream=File;
	      InitIFFasDOS(IFFHandle);
	      if (!(Error=OpenIFF(IFFHandle,IFFF_WRITE)))
		{
		  if (!(Error=PushChunk(IFFHandle,MAKE_ID('S','C','O','R'),MAKE_ID('L','I','S','T'),IFFSIZE_UNKNOWN)))
		    {
		      if (!(Error=PushChunk(IFFHandle,MAKE_ID('S','C','O','R'),
					    MAKE_ID('P','R','O','P'),IFFSIZE_UNKNOWN)))
			{
			  ULONG Length;

			  if (!(Error=PushChunk(IFFHandle,MAKE_ID('S','C','O','R'),MAKE_ID('G','A','M','E'),Length=strlen(ScoreHandle->ScoreDef->GameName))) &&
			      !(Error=MyWriteChunkBytes(IFFParseBase,IFFHandle,ScoreHandle->ScoreDef->GameName,Length)) &&
			      !(Error=PopChunk(IFFHandle)))
			    {
			      const struct GS_Score *Score;

			      if (ScoreType==GS_SCORE_PERSONAL)
				{
				  if (!(Error=PushChunk(IFFHandle,MAKE_ID('S','C','O','R'),MAKE_ID('P','L','Y','R'),Length=strlen(ScoreHandle->UserName))) &&
				      !(Error=MyWriteChunkBytes(IFFParseBase,IFFHandle,ScoreHandle->UserName,Length)))
				    {
				      Error=PopChunk(IFFHandle);
				    }
				}
			      if (Error==0)
				{
				  Error=PopChunk(IFFHandle);	/* PROP SCOR */
				}
			      Score=(struct GS_Score *)ScoreHandle->FileData[ScoreType].Scores.List.mlh_Head;
			      while (!Error && Score->Node.mln_Succ!=NULL)
				{
				  if (!(Error=PushChunk(IFFHandle,MAKE_ID('S','C','O','R'),
							MAKE_ID('F','O','R','M'),IFFSIZE_UNKNOWN)))
				    {
				      LONG j;

				      for (j=-2; !Error && j<ScoreHandle->ScoreDef->ChunkCount; j++)
					{
					  const void *Data;
					  ULONG Size;
					  ULONG ChunkID;

					  Data=NULL;
					  if (j==-2)
					    {
					      /* player name */
					      if (ScoreType!=GS_SCORE_PERSONAL)
						{
						  if (Score->Name!=NULL)
						    {
						      ChunkID=MAKE_ID('P','L','Y','R');
						      Data=Score->Name;
						      Size=strlen(Data);
						    }
						}
					    }
					  else if (j==-1)
					    {
					      /* timestamp */
					      ChunkID=MAKE_ID('T','I','M','E');
					      Data=&Score->TimeStamp;
					      Size=sizeof(Score->TimeStamp);
					    }
					  else
					    {
					      const struct GS_ScoreChunkDef *ChunkDef;

					      ChunkDef=((const struct GS_ScoreChunkDef *)(ScoreHandle->ScoreDef+1))+j;
					      ChunkID=ChunkDef->ChunkID;
					      if (ChunkDef->Flags & GS_SCOREDEFF_INTEGER)
						{
						  Data=&((const ULONG *)(Score+1))[j];
						  Size=sizeof(ULONG);
						}
					    }
					  if (Data!=NULL)
					    {
					      if (!(Error=PushChunk(IFFHandle,MAKE_ID('S','C','O','R'),ChunkID,Size)) &&
						  !(Error=MyWriteChunkBytes(IFFParseBase,IFFHandle,Data,Size)))
						{
						  Error=PopChunk(IFFHandle);
						}
					    }
					}
				      if (!Error)
					{
					  Error=PopChunk(IFFHandle);	/* FORM SCOR */
					}
				    }
				  Score=(struct GS_Score *)Score->Node.mln_Succ;
				}
			    }
			}
		      if (!Error)
			{
			  Error=PopChunk(IFFHandle);	/* LIST SCOR */
			}
		    }
		  CloseIFF(IFFHandle);
		}
	      FreeIFF(IFFHandle);
	    }
	  else
	    {
	      Error=ERROR_NO_FREE_STORE;
	    }
	  CloseLibrary(IFFParseBase);
	}
      else
	{
	  Error=-1;
	}
      if (!Close(File) && Error==0)
	{
	  Error=IoErr();
	}
      if (Error==0)
	{
	  SetProtection(TempFilename,FIBF_EXECUTE);
	}
      else
	{
	  DeleteFile(TempFilename);
	}
    }
  else
    {
      Error=IoErr();
    }
  return Error;
}

/************************************************************************/
/*									*/
/* Copy a score								*/
/*									*/
/************************************************************************/

static INLINE struct GS_Score *CopyScore(const struct ScoreHandle *ScoreHandle, const struct GS_Score *Score)

{
  struct GS_Score *NewScore;
  ULONG NameSize;
  ULONG ScoreSize;

  ScoreSize=sizeof(*NewScore)+sizeof(ULONG)*ScoreHandle->ScoreDef->ChunkCount;
  if (Score->Name!=NULL)
    {
      NameSize=strlen(Score->Name)+1;
    }
  else
    {
      NameSize=0;
    }
  if ((NewScore=GS_MemoryAlloc(ScoreSize+NameSize))!=NULL)
    {
      CopyMem((APTR)Score,NewScore,ScoreSize);
      if (NameSize!=0)
	{
	  NewScore->Name=((char *)NewScore)+ScoreSize;
	  Stpcpy(((char *)NewScore)+ScoreSize,Score->Name);
	}
      else
	{
	  NewScore->Name=NULL;
	}
    }
  return NewScore;
}

/****** gamesupport.library/GS_InsertScore *******************************
*
*   NAME
*	GS_InsertScore -- insert a score into the score tables
*
*   SYNOPSIS
*	Error = GS_InsertScore(ScoreHandle, Score)
*	 d0                        a0         a1
*
*	LONG GS_InsertScore(void *, struct GS_Score *);
*
*   FUNCTION
*	Check if we want to insert the new score. If yes, insert
*	it. Basically, you are expected to call this function
*	whenever a game is finished --- we determine ourselves
*	whether we actually want to insert the score.
*
*   INPUTS
*	ScoreHandle  - a handle describing the files
*	Score        - the new score to insert
*
*   RESULT
*	Error - error code (0 for success)
*	        In any case, the Score->Name and Score->TimeStamp
*	        will be set.
*
*************************************************************************/

SAVEDS_ASM_A0A1(LONG,LibGS_InsertScore,struct ScoreHandle *,ScoreHandle,struct GS_Score *,Score)

{
  BPTR OldCurrentDir;
  LONG Error;
  BPTR LockFile;

  Error=0;
  Score->Name=ScoreHandle->UserName;
  {
    ULONG Micros;

    CurrentTime(&Score->TimeStamp,&Micros);
  }
  OldCurrentDir=CurrentDir(ScoreHandle->DirLock);
  while ((LockFile=Open(LockFilename,MODE_NEWFILE))==MKBADDR(NULL) && 
	 ((Error=IoErr())==ERROR_OBJECT_EXISTS || Error==ERROR_OBJECT_IN_USE))
    {
      Delay(TICKS_PER_SECOND);
    }
  if (LockFile!=MKBADDR(NULL))
    {
      ULONG i;

      Error=0;
      for (i=0; Error==0 && i<3; i++)
	{
	  Error=UpdateScores(ScoreHandle,i,TRUE);
	}
      for (i=0; Error==0 && i<3; i++)
	{
	  struct GS_Score *NewScore;

	  if ((NewScore=CopyScore(ScoreHandle,Score))!=NULL)
	    {
	      struct GS_ScoreList *Scores;
	      struct GS_Score *TrashScore;

	      Scores=&ScoreHandle->FileData[i].Scores;
	      TrashScore=InsertScore(ScoreHandle,NewScore,Scores,i);
	      GS_MemoryFree(TrashScore);
	      if (TrashScore!=NewScore)
		{
		  if ((Error=WriteScoreTable(ScoreHandle,i))==0)
		    {
		      do
			{
			  if (DeleteFile(ScoreHandle->FileData[i].Filename) ||
			      (Error=IoErr())==ERROR_OBJECT_NOT_FOUND)
			    {
			      Error=0;
			    }
			}
		      while (Error==0 && !Rename(TempFilename,ScoreHandle->FileData[i].Filename));
		      if (Error!=0)
			{
			  DeleteFile(TempFilename);
			}
		    }
		  if (Error!=0)
		    {
		      ScoreHandle->FileData[i].LastChanged.ds_Days=0;
		      ScoreHandle->FileData[i].LastChanged.ds_Minute=0;
		      ScoreHandle->FileData[i].LastChanged.ds_Tick=0;
		    }
		}
	    }
	  else
	    {
	      Error=ERROR_NO_FREE_STORE;
	    }
	}
      Close(LockFile);
      DeleteFile(LockFilename);
    }
  CurrentDir(OldCurrentDir);
  return Error;
}
