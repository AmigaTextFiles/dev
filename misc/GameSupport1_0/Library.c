/****** gamesupport.library/--background-- *******************************
*
*	gamesupport.library offsers various functions for
*	system-compliant, AUISG conforming games.
*
*	Some things should be noted:
*	a) don't access gamesupport.library-maintained files (such
*	   as high score tables) yourself. gamesupport.library uses
*	   various locking techniques to ensure proper operation
*	   with respect to multitasking and networked filesystems.
*
*	b) gamesupport.library uses various assigns to let the user
*	   override the default location for files. However,
*	   strange (although not fatal with respect to overall system
*	   operation) things might happen if you change these
*	   assigns "in the middle of a game". The intended usage
*	   is to setup any required assigns at boottime.
*
*	c) currently AmigaOS V39 (Release 3.0) or newer is required
*
*	d) there is no gamesupport memhandler. This is because you
*	   cannot call FreePooled() on a shared memory pool (as used
*	   by gamesupport.library) inside a memhandler. One of the
*	   many AmigaOS design problems.
*
*	e) gamesupport library ignores the starvation problem.
*
*************************************************************************/

#ifndef EXEC_INITIALIZERS_H
#include <exec/initializers.h>
#endif

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

#ifndef DOS_DOSEXTENS_H
#include <dos/dosextens.h>
#endif

#ifndef GRAPHICS_GFXBASE_H
#include <graphics/gfxbase.h>
#endif

#ifndef INTUITION_INTUITIONBASE_H
#include <intuition/intuitionbase.h>
#endif

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/iffparse.h>
#include <proto/intuition.h>

#include "Version.h"

/************************************************************************/

#include "Global.h"

/************************************************************************/

#include "StaticSavedsAsmD0A0A6.h"
#include "StaticSavedsAsmA6.h"
#include "StaticSaveds.h"

/************************************************************************/

const char LibName[]=LIBRARY_NAME;
const char LibIDString[]=LIBRARY_NAME " " LIBRARY_VERSION_STR " (" LIBRARY_DATE ")";

static const struct
{
  UBYTE Table1[4];
  UBYTE Table2[4];
  UBYTE Table3[2]; char *LibName;
  UBYTE Table4[4];
  UBYTE Table5[2]; UWORD Table6[1];
  UBYTE Table7[2]; UWORD Table8[1];
  UBYTE Table9[2]; char *IDString;
  UBYTE TableEnd;
} DataTable=
{
  0xa0,OFFSET(Node,ln_Type),NT_LIBRARY,0,
  0xa0,OFFSET(Node,ln_Pri),-5,0,
  0x80,OFFSET(Node,ln_Name),LibName,
  0xa0,OFFSET(Library,lib_Flags),LIBF_SUMUSED|LIBF_CHANGED,0,
  0x90,OFFSET(Library,lib_Version),LIBRARY_VERSION,
  0x90,OFFSET(Library,lib_Revision),LIBRARY_REVISION,
  0x80,OFFSET(Library,lib_IdString),LibIDString,
  0
};

/************************************************************************/

STATIC_SAVEDS_ASM_A6_PROTO(struct GameSupportBase *,LibOpen,struct GameSupportBase *);
STATIC_SAVEDS_ASM_A6_PROTO(BPTR,LibClose,struct GameSupportBase *);
STATIC_SAVEDS_ASM_A6_PROTO(BPTR,LibExpunge,struct GameSupportBase *);
static ULONG LibNull(void);

static const APTR LibFuncTable[]=
{
  (APTR)LibOpen,
  (APTR)LibClose,
  (APTR)LibExpunge,
  (APTR)LibNull,

#include "FunctionTable.c"

  (APTR)-1
};

/************************************************************************/

STATIC_SAVEDS_ASM_D0A0A6_PROTO(struct GameSupportBase *,LibInit,struct GameSupportBase *,BPTR,struct ExecBase *);

const APTR LibInitTable[4]=
{
  (APTR)sizeof(struct GameSupportBase),
  (APTR)LibFuncTable,
  (APTR)&DataTable,
  (APTR)LibInit
};

/************************************************************************/
/*									*/
/* Some string constants required by several modules.			*/
/*									*/
/************************************************************************/

char IFFParseName[]="iffparse.library";
char GameStuff[]="GAMESTUFF:";
char ProgDir[]="PROGDIR:";

/************************************************************************/

struct ExecBase *SysBase;
struct Library *UtilityBase;
struct DosLibrary *DOSBase;
struct GfxBase *GfxBase;
struct Library *LocaleBase;
struct IntuitionBase *IntuitionBase;

struct SignalSemaphore GameSupportSemaphore;

struct GameSupportBase *GameSupportBase;

static BPTR SegList;
static struct SignalSemaphore BaseSemaphore;
static ULONG BaseInitialized;

static void *MemoryPool;
static struct SignalSemaphore MemorySemaphore;

/************************************************************************/
/*									*/
/*									*/
/************************************************************************/

#if !defined(__GNUC__) || !defined(__OPTIMIZE__)

char *Stpcpy(char *Dest, const char *Source)

{
  while ((*Dest++=*Source++))
    ;
  return Dest-1;
}

#endif

/************************************************************************/
/*									*/
/* Wrappers for some iffparse functions					*/
/*									*/
/************************************************************************/

LONG (MyWriteChunkBytes)(struct Library *IFFParseBase, struct IFFHandle *IFFHandle, const void *Data, ULONG Size)

{
  LONG Error;

  Error=WriteChunkBytes(IFFHandle,Data,Size);
  if (Error==Size)
    {
      Error=0;
    }
  else if (Error>=0)
    {
      Error=IFFERR_WRITE;
    }
  return Error;
}

/*----------------------------------------------------------------------*/

LONG (MyReadChunkBytes)(struct Library *IFFParseBase, struct IFFHandle *IFFHandle, void *Data, ULONG Size)

{
  LONG Error;

  Error=ReadChunkBytes(IFFHandle,Data,Size);
  if (Error==Size)
    {
      Error=0;
    }
  else if (Error>=0)
    {
      Error=IFFERR_READ;
    }
  return Error;
}

/************************************************************************/
/*									*/
/* Library init function.						*/
/*									*/
/************************************************************************/

STATIC_SAVEDS_ASM_D0A0A6(struct GameSupportBase *,LibInit,struct GameSupportBase *,TheGameSupportBase,BPTR,TheSegList,struct ExecBase *,TheSysBase)

{
  GameSupportBase=TheGameSupportBase;
  SysBase=TheSysBase;
  SegList=TheSegList;
  InitSemaphore(&BaseSemaphore);
  return TheGameSupportBase;
}

/************************************************************************/
/*									*/
/* Cleanup the library base.						*/
/*									*/
/************************************************************************/

static void CleanupLibraryBase(struct GameSupportBase *GameSupportBase)

{
  if (IntuitionBase!=NULL)
    {
      if (DOSBase!=NULL)
	{
	  if (GfxBase!=NULL)
	    {
	      if (UtilityBase!=NULL)
		{
		  if (GameSupportBase->LayersBase!=NULL)
		    {
		      if (GameSupportBase->KeymapBase!=NULL)
			{
			  CloseLibrary(LocaleBase);
			  if (MemoryPool!=NULL)
			    {
			      DeletePool(MemoryPool);
			    }
			  CloseLibrary(GameSupportBase->KeymapBase);
			}
		      CloseLibrary(GameSupportBase->LayersBase);
		    }
		  CloseLibrary(GameSupportBase->UtilityBase);
		}
	      CloseLibrary(&GfxBase->LibNode);
	    }
	  CloseLibrary(&IntuitionBase->LibNode);
	}
      CloseLibrary(&DOSBase->dl_lib);
    }
  BaseInitialized=FALSE;
}

/************************************************************************/
/*									*/
/* Initialize the library base						*/
/* Note that this may break Forbid()					*/
/*									*/
/************************************************************************/

static int InitLibraryBase(struct GameSupportBase *GameSupportBase)

{
  if ((IntuitionBase=GameSupportBase->IntuitionBase=(struct IntuitionBase *)OpenLibrary("intuition.library",37)))
    {
      if (IntuitionBase->LibNode.lib_Version>=39)
	{
	  if ((DOSBase=GameSupportBase->DOSBase=(struct DosLibrary *)OpenLibrary("dos.library",39))!=NULL)
	    {
	      if ((GfxBase=GameSupportBase->GfxBase=(struct GfxBase *)OpenLibrary("graphics.library",39)))
		{
		  if ((UtilityBase=GameSupportBase->UtilityBase=OpenLibrary("utility.library",39)))
		    {
		      if ((GameSupportBase->LayersBase=OpenLibrary("layers.library",39)))
			{
			  if ((GameSupportBase->KeymapBase=OpenLibrary("keymap.library",39))!=NULL)
			    {
			      LocaleBase=GameSupportBase->LocaleBase=OpenLibrary("locale.library",38);
			      InitSemaphore(&GameSupportSemaphore);
#if 0
			      InitSemaphore(&UserlistSemaphore);
#endif
			      InitSemaphore(&MemorySemaphore);
			      InitSemaphore(&JoystickSemaphore);
			      InitSemaphore(&HappyBlankerSemaphore);
			      InitSemaphore(&HappyBlankerSemaphore2);
			      if ((MemoryPool=CreatePool(0,4096,4096)))
				{
				  GameSupportBase->Joystick.Request.io_Device=NULL;
				  BaseInitialized=TRUE;
				  return TRUE;
				}
			    }
			}
		    }
		}
	    }
	}
      else
	{
	  static struct EasyStruct EasyStruct=
	    {
	      5*4,
	      0,
	      "gamesupport.library",
	      "gamesupport.library requires AmigaOS V39\n(Release 3.0) or any newer version",
	      "Quit"
	    };

	  EasyRequestArgs(NULL,&EasyStruct,NULL,NULL);
	}
      CleanupLibraryBase(GameSupportBase);
    }
  return FALSE;
}

/************************************************************************/
/*									*/
/* Library open function.						*/
/*									*/
/************************************************************************/

STATIC_SAVEDS_ASM_A6(struct GameSupportBase *,LibOpen,struct GameSupportBase *,GameSupportBase)

{
  GameSupportBase->Library.lib_OpenCnt++;
  ObtainSemaphore(&BaseSemaphore);
  if (!BaseInitialized)
    {
      InitLibraryBase(GameSupportBase);
    }
  ReleaseSemaphore(&BaseSemaphore);
  if (BaseInitialized)
    {
      GameSupportBase->Library.lib_Flags&=~LIBF_DELEXP;
      return GameSupportBase;
    }
  GameSupportBase->Library.lib_OpenCnt--;
  return NULL;
}

/************************************************************************/
/*									*/
/* Library expunge function.						*/
/*									*/
/************************************************************************/

static BPTR MyLibExpunge(struct GameSupportBase *GameSupportBase)

{
  if (GameSupportBase->Library.lib_OpenCnt)
    {
      GameSupportBase->Library.lib_Flags|=LIBF_DELEXP;
      return MKBADDR(NULL);
    }
  Remove(&GameSupportBase->Library.lib_Node);
  return SegList;
}

/*----------------------------------------------------------------------*/

STATIC_SAVEDS_ASM_A6(BPTR,LibExpunge,struct GameSupportBase *,GameSupportBase)

{
  return MyLibExpunge(GameSupportBase);
}

/************************************************************************/
/*									*/
/* Library close function.						*/
/*									*/
/************************************************************************/

STATIC_SAVEDS_ASM_A6(BPTR,LibClose,struct GameSupportBase *,GameSupportBase)

{
  GameSupportBase->Library.lib_OpenCnt--;
  if (GameSupportBase->Library.lib_OpenCnt==0)
    {
      CleanupLibraryBase(GameSupportBase);
      if (GameSupportBase->Library.lib_Flags & LIBF_DELEXP)
	{
	  return MyLibExpunge(GameSupportBase);
	}
    }
  return MKBADDR(NULL);
}

/************************************************************************/
/*									*/
/* Library dummy function.						*/
/*									*/
/************************************************************************/

static ULONG LibNull(void)

{
  return 0;
}

/****** gamesupport.library/GS_MemoryAlloc *******************************
*
*   NAME
*	GS_MemoryAlloc -- allocate a block of memory
*
*   SYNOPSIS
*	Memory = GS_MemoryAlloc(Size)
*	  d0                     d0
*
*	void *GS_MemoryAlloc(ULONG);
*
*   FUNCTION
*	Allocate a block of memory. You must call GS_MemoryFree() when
*	you don't need the memory any longer.
*
*   INPUTS
*	Size - the size of the memory block. 0 will return NULL and
*	    ERROR_BAD_NUMBER.
*
*   RESULT
*	Memory - a pointer to the allocated memory, or NULL.
*	   In case of NULL, IoErr() will be set.
*
*   NOTE
*	This is different from malloc(). You are responsible for freeing
*	the block!
*
*   SEE ALSO
*	GS_MemoryFree()
*
*************************************************************************/

SAVEDS_ASM_D0(void *,LibGS_MemoryAlloc,ULONG,Size)

{
  ULONG *Memory;

  Memory=NULL;
  if (Size)
    {
      Size+=sizeof(*Memory);
      ObtainSemaphore(&MemorySemaphore);
      Memory=AllocPooled(MemoryPool,Size);
      ReleaseSemaphore(&MemorySemaphore);
      if (Memory)
	{
	  *(Memory++)=Size;
	}
      else
	{
	  SetIoErr(ERROR_NO_FREE_STORE);
	}
    }
  else
    {
      SetIoErr(ERROR_BAD_NUMBER);
    }
  return Memory;
}

/****** gamesupport.library/GS_MemoryFree ********************************
*
*   NAME
*	GS_MemoryFree -- free a memory block.
*
*   SYNOPSIS
*	GS_MemoryFree(Memory)
*	                a0
*
*	void GS_MemoryFree(void *);
*
*   FUNCTION
*	The memory block is returned to the pool.
*
*   INPUTS
*	Memory - the memory block. Must have been allocated by
*	    MemoryAlloc(). NULL is valid.
*
*   SEE ALSO
*	GS_MemoryAlloc()
*
*************************************************************************/

SAVEDS_ASM_A0(void,LibGS_MemoryFree,void *,Memory)

{
  if (Memory)
    {
      ULONG *t;

      t=Memory;
      t--;
      ObtainSemaphore(&MemorySemaphore);
      FreePooled(MemoryPool,t,*t);
      ReleaseSemaphore(&MemorySemaphore);
    }
}

/****** gamesupport.library/GS_MemoryRealloc *****************************
*
*   NAME
*	GS_MemoryRealloc -- reallocate a block of memory
*
*   SYNOPSIS
*	NewMemory = GS_MemoryRealloc(OldMemory,NewSize)
*	   d0                           a0        d0
*
*	void *GS_MemoryRealloc(void *, ULONG);
*
*   FUNCTION
*	Reallocates a block of memory. This function will free the
*	block passed in, allocate a new one and copy the old contents
*	to the new block. If the new block is smaller, it copies as
*	much as will fit (the rest is lost). If the new block is larger,
*	the additional bytes are not initialized. If the new block has
*	the same size, why did you call GS_MemoryRealloc()??
*
*   INPUTS
*	OldMemory - the old memory block. Must have been allocated by
*	    GS_MemoryMalloc() or GS_MemoryRealloc(). NULL is valid:
*	    GS_MemoryRealloc(NULL,Size) is equivalent to
*	    GS_MemoryMalloc(Size).
*	NewSize   - the size of the new block. 0 is valid here; it will
*	    return NULL and ERROR_BAD_NUMBER.
*
*   RESULT
*	NewMemory - the new memory block. In case of NULL, the old
*	    pointer is still valid and must still be freed; in case
*	    of non-NULL, you must not use the old pointer anymore.
*
*   SEE ALSO
*	GS_MemoryAlloc(), GS_MemoryFree(), realloc()
*
*************************************************************************/

SAVEDS_ASM_D0A0(void *,LibGS_MemoryRealloc,ULONG,Size,void *,Memory)

{
  ULONG *NewMemory;

  NewMemory=NULL;
  if (Size)
    {
      if (!(NewMemory=GS_MemoryAlloc(Size)))
	{
	  return NULL;
	}
      if (Memory)
	{
	  ULONG CopySize;

	  CopySize=(*(((ULONG *)Memory)-1) < *(NewMemory-1)) ? *(((ULONG *)Memory)-1) : *(NewMemory-1);
	  CopyMemQuick(Memory,NewMemory,CopySize-sizeof(*NewMemory));
	}
    }
  else
    {
      SetIoErr(ERROR_BAD_NUMBER);
    }
  GS_MemoryFree(Memory);
  return NewMemory;
}

/****** gamesupport.library/GS_TransformUsername *************************
*
*    NAME
*	GS_TransformUsername -- transform username to filename
*
*    SYNOPSIS
*	Filename = GS_TransformUsername(Username,OldFilename)
*	   d0                              a0         a1
*
*	char *GS_TransformUsername(const char *, char *);
*
*    FUNCTION
*	Transform a username into something that most filesystems
*	will accept as filename.
*	OldFilename is a Filename that was returned from this
*	function. If it is non-NULL, OldFilename will be freed
*	and a new filename will be returned.
*
*	The intended use for this function is as follows:
*
*	int Success;
*	char *Filename;
*
*	Success=FALSE;
*	Filename=NULL;
*	while (!Success)
*	  {
*	    Filename=GS_TransformUsername(Username,Filename);
*	    if (Filename==NULL)
*	      Error();
*	    File=OpenFile(Filename);
*           if (File does not exist)
*	      Success=TRUE;
*	    else
*	      {
*	        FileUsername=ReadUsernameFromFile();
*	        if (FileUsername is equal to Username)
*	          Success=TRUE;
*	      }           
*	  }
*
*	Since the returned Filename is not unique, we read the
*	Username from the file to check whether we catched the
*	correct file. If we didn't, we just try the "next"
*	transformation.
*
*    INPUTS
*	Username    - the name of the user
*	OldFilename - previous Filename, or NULL
*
*    RESULT
*	Filename - a string to use as filename. NULL for error.
*                  Call GS_MemoryFree(Filename) when done.
*
*************************************************************************/

SAVEDS_ASM_A0A1(char *,LibGS_TransformUsername,const char *,Username,char *,OldFilename)

{
  if (OldFilename!=NULL)
    {
      unsigned char c;

      c=*(unsigned char *)OldFilename;
      c=(c+1)&0x7f;
      if (c<0x20)
	{
	  c+=0x20;
	}
      if (c=='/' || c==':')
	{
	  c++;
	}
      *(unsigned char *)OldFilename=c;
      return OldFilename;
    }
  else
    {
      char *Filename;
      unsigned char Sum;
      int Pass;

      Sum=0;
      for (Pass=0; Pass<2; Pass++)
	{
	  union
	    {
	      LONG Length;
	      unsigned char *Dest;
	    } Param;
	  const unsigned char *Source;
	  unsigned char c;
	  int Space;

	  if (Pass==0)
	    {
	      Param.Length=2;	/* Sum and terminating '\0' */
	    }
	  else
	    {
	      Param.Dest=(unsigned char *)Filename;
	      *(Param.Dest++)=Sum;
	    }
	  Space=TRUE;
	  for (Source=(const unsigned char *)Username; (c=*Source)!='\0'; Source++)
	    {
	      if (c=='\t')
		{
		  c=' ';
		}
	      if (c==' ')
		{
		  if (!Space)
		    {
		      Space=TRUE;
		      if (Pass==0)
			{
			  Param.Length++;
			}
		      else
			{
			  *(Param.Dest++)=c;
			}
		    }
		}
	      else
		{
		  Space=FALSE;
		  if (Pass==0)
		    {
		      Sum+=c;
		    }
		  if (c>0x20 && c<0x80)
		    {
		      if (c!='/' && c!=':')
			{
			  if (Pass==0)
			    {
			      Param.Length++;
			    }
			  else
			    {
			      *(Param.Dest++)=c;
			    }
			}
		    }
		}
	    }
	  if (Pass==0)
	    {
	      if ((Filename=GS_MemoryAlloc(Param.Length))==NULL)
		{
		  Pass=2;
		}
	      else
		{
		  Sum&=0x7f;
		  if (Sum<0x20)
		    {
		      Sum+=0x20;
		    }
		  if (Sum=='/' || Sum==':')
		    {
		      Sum++;
		    }
		}
	    }
	  else
	    {
	      *(Param.Dest)='\0';
	    }
	}
      return Filename;
    }
  /* not reached */
}
