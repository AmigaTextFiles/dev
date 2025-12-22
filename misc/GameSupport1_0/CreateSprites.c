/************************************************************************/
/*									*/
/* Take a bunch of FORM SPRT files and stuff them into a CAT SPRT	*/
/*									*/
/************************************************************************/

#include <proto/iffparse.h>

#include <MyLib.h>

/************************************************************************/

struct IFF
{
  struct IFFHandle *Handle;
  int Open;
};

/************************************************************************/

struct DosLibrary *DOSBase;
struct Library *IFFParseBase;

static struct
{
  char *CAT;
  char **SPRTs;
} Arguments;

static struct IFF Source;
static struct IFF Dest;

/************************************************************************/

static void ErrorClose(void)

{
  if (Dest.Handle)
    {
      if (Dest.Open)
	{
	  CloseIFF(Dest.Handle);
	}
      if (Dest.Handle->iff_Stream)
	{
	  if (!Close(Dest.Handle->iff_Stream))
	    {
	      PError(0,Arguments.CAT);
	    }
	}
      FreeIFF(Dest.Handle);
    }
  if (Source.Handle)
    {
      if (Source.Open)
	{
	  CloseIFF(Source.Handle);
	}
      if (Source.Handle->iff_Stream)
	{
	  Close(Source.Handle->iff_Stream);
	}
      FreeIFF(Source.Handle);
    }
  DeleteFile(Arguments.CAT);
}

/************************************************************************/

static int DoWork(void)

{
  LONG ErrorCode;
  char **SPRT;

  if (!(Dest.Handle=AllocIFF()))
    {
      PError(0,NULL);
      return RETURN_FAIL;
    }
  if (!(Dest.Handle->iff_Stream=Open(Arguments.CAT,MODE_NEWFILE)))
    {
      PError(0,Arguments.CAT);
      return RETURN_FAIL;
    }
  InitIFFasDOS(Dest.Handle);
  if ((ErrorCode=OpenIFF(Dest.Handle,IFFF_WRITE)))
    goto DestError;
  Dest.Open=TRUE;
  if ((ErrorCode=PushChunk(Dest.Handle,MAKE_ID('S','P','R','T'),MAKE_ID('C','A','T',' '),IFFSIZE_UNKNOWN)))
    goto DestError;
  for (SPRT=Arguments.SPRTs; *SPRT; SPRT++)
    {
      if (!(Source.Handle=AllocIFF()))
	{
	  PError(0,NULL);
	  return RETURN_FAIL;
	}
      if (!(Source.Handle->iff_Stream=Open(*SPRT,MODE_OLDFILE)))
	{
	  PError(0,*SPRT);
	  return RETURN_FAIL;
	}
      InitIFFasDOS(Source.Handle);
      if ((ErrorCode=OpenIFF(Source.Handle,IFFF_READ)))
	goto SourceError;
      Source.Open=TRUE;
      if ((ErrorCode=StopChunk(Source.Handle,MAKE_ID('S','P','R','T'),MAKE_ID('F','O','R','M'))))
	goto SourceError;
      do
	{
	  switch (ErrorCode=ParseIFF(Source.Handle,IFFPARSE_SCAN))
	    {
	    case 0:
	      {
		struct ContextNode *ContextNode;
		void *Memory;
		ULONG Size;

		ContextNode=CurrentChunk(Source.Handle);
		Size=ContextNode->cn_Size-4;
		if ((ErrorCode=PushChunk(Dest.Handle,ContextNode->cn_Type,ContextNode->cn_ID,Size+4)))
		  goto DestError;
		if (!(Memory=AllocMem(Size,0)))
		  {
		    PError(0,*SPRT);
		    return RETURN_FAIL;
		  }
		ErrorCode=ReadChunkBytes(Source.Handle,Memory,Size);
		if (ErrorCode!=Size)
		  {
		    if (ErrorCode>=0)
		      ErrorCode=IFFERR_READ;
		    FreeMem(Memory,Size);
		    goto SourceError;
		  }
		ErrorCode=WriteChunkBytes(Dest.Handle,Memory,Size);
		FreeMem(Memory,Size);
		if (ErrorCode!=Size)
		  {
		    if (ErrorCode>=0)
		      ErrorCode=IFFERR_WRITE;
		    goto DestError;
		  }
		if ((ErrorCode=PopChunk(Dest.Handle)))
		  goto DestError;
	      }
	      break;

	    case IFFERR_EOF:
	      break;

	    default:
	      goto SourceError;
	    }
	}
      while (ErrorCode!=IFFERR_EOF);
      CloseIFF(Source.Handle);
      Source.Open=FALSE;
      Close(Source.Handle->iff_Stream);
      Source.Handle->iff_Stream=MKBADDR(NULL);
      FreeIFF(Source.Handle);
      Source.Handle=NULL;
    }
  if ((ErrorCode=PopChunk(Dest.Handle)))	/* SPRT */
    goto DestError;
  CloseIFF(Dest.Handle);
  Dest.Open=FALSE;
  if (!Close(Dest.Handle->iff_Stream))
    {
      Dest.Handle->iff_Stream=MKBADDR(NULL);
      PError(0,Arguments.CAT);
      return RETURN_FAIL;
    }
  Dest.Handle->iff_Stream=MKBADDR(NULL);
  SetProtection(Arguments.CAT,FIBF_EXECUTE);
  return RETURN_OK;

 SourceError:
  FPrintf(StdErr,"IFF error %ld on file %s\n",ErrorCode,*SPRT);
  return RETURN_FAIL;

 DestError:
  FPrintf(StdErr,"IFF error %ld on file %s\n",ErrorCode,Arguments.CAT);
  return RETURN_FAIL;
}

/************************************************************************/

int AmigaMain(void)

{
  int RC;

  RC=RETURN_CATASTROPHY;
  if ((DOSBase=(struct DosLibrary *)OpenLibrary("dos.library",ROM_VERSION)))
    {
      RC=RETURN_FAIL;
      ErrorHandle();
      if ((IFFParseBase=OpenLibrary("iffparse.library",36)))
	{
	  struct RDArgs *RDArgs;

	  if ((RDArgs=ReadArgs("CATFILE/A,SPRTFILES/A/M",(LONG *)&Arguments,NULL)))
	    {
	      if ((RC=DoWork()))
		{
		  ErrorClose();
		}
	      FreeArgs(RDArgs);
	    }
	  else
	    {
	      PError(0,NULL);
	    }
	  CloseLibrary(IFFParseBase);
	}
      else
	{
	  VFPrintf(StdErr,"Unable to open iffparse.library V36 or newer.\n",NULL);
	}
      CloseLibrary(&DOSBase->dl_lib);
    }
  return RC;
}
