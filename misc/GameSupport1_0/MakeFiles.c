#ifndef DOS_STDIO_H
#include <dos/stdio.h>
#endif

#include <MyLib.h>

/************************************************************************/

struct Function
{
  const char *Name;
  const char *Params;
};

static struct Function Functions[]=
{
  {"GS_MemoryAlloc","RESULT \"void **\" Memory D0 ULONG Size\n"},
  {"GS_MemoryFree", "A0 \"void **\" Memory\n"},
  {"GS_MemoryRealloc", "RESULT \"void **\" Memory A0 \"void **\" OldMemory D0 ULONG NewSize\n"},
  {"GS_AllocateColors", "RESULT ULONG Success A0 \"struct Screen **\" Screen A1 \"struct GS_ColorDef **\" Colors D0 ULONG Distinct\n"},
  {"GS_FreeColors", "A0 \"struct Screen **\" Screen A1 \"struct GS_ColorDef **\" Colors\n"},
  {"GS_FormatString", "RESULT \"char **\" String A0 \"const char **\" Template A1 \"const void **\" Parameters A2 \"ULONG **\" Length A3 \"struct Locale **\" Locale\n"},
  {"GS_FormatDate", "RESULT \"char **\" String A0 \"const char **\" Template D0 ULONG TimeStamp A1 \"ULONG **\" Length A2 \"struct Locale **\" Locale\n"},
  {"GS_DrawString", "A0 \"const char **\" Template A1 \"void **\" Parameters A2 \"struct RastPort **\" RastPort A3 \"struct Locale **\" Locale\n"},
  {"GS_DrawDate", "A0 \"char **\" Template D0 ULONG TimeStamp A1 \"struct RastPort **\" RastPort A2 \"struct Locale **\" Locale\n"},
  {"GS_StringWidth", "RESULT WORD Width A0 \"const char **\" Template A1 \"void **\" Parameters A2 \"struct RastPort **\" RastPort A3 \"struct Locale **\" Locale\n"},
  {"GS_DateWidth", "RESULT WORD Width A0 \"char **\" Template D0 ULONG TimeStamp A1 \"struct RastPort **\" RastPort A2 \"struct Locale **\" Locale\n"},
  {"GS_LoadSprites", "RESULT \"struct GS_Sprites **\" Sprites A0 \"const char **\" GameName A1 \"struct Screen **\" Screen\n"},
  {"GS_FreeSprites", "A0 \"struct GS_Sprites **\" Sprites A1 \"struct Screen **\" Screen\n"},
  {"GS_AllocateJoystick", "RESULT ULONG Success A0 \"struct MsgPort **\" ReplyPort D0 UBYTE ControllerType\n"},
  {"GS_SendJoystick", "\n"},
  {"GS_FreeJoystick", "\n"},
  {"GS_HappyBlanker", "RESULT ULONG Success\n"},
  {"GS_NoHappyBlanker", "\n"},
  {"GS_ObtainScoreHandle", "RESULT \"void **\" ScoreHandle A0 \"const struct GS_ScoreDef **\" ScoreDef A1 \"const char **\" SubPath A2 \"const char **\" UserName\n"},
  {"GS_ReleaseScoreHandle", "A0 \"void **\" ScoreHandle\n"},
  {"GS_ObtainScores", "RESULT \"struct GS_ScoreList **\" Scores A0 \"void **\" ScoreHandle D0 ULONG ScoreType\n"},
  {"GS_InsertScore", "RESULT LONG Error A0 \"void **\" ScoreHandle A1 \"struct GS_Score **\" Score\n"},
  {"GS_ReleaseScores", "A0 \"void **\" ScoreHandle A1 \"struct GS_ScoreList **\" Scores\n"},
  {"GS_WindowSleep", "RESULT ULONG Success A0 \"struct Window **\" Window\n"},
  {"GS_WindowWakeup", "A0 \"struct Window **\" Window\n"},
  {"GS_HappyBlanker", "RESULT ULONG Success\n"},
  {"GS_NoHappyBlanker", "\n"},
  {"GS_TransformUsername", "RESULT \"char **\" Filename A0 \"const char **\" Username A1 \"char **\" OldFilename\n"}
};

/************************************************************************/

struct DosLibrary *DOSBase;

static BPTR Filehandle;
static const char *Filename;

static struct RDArgs *RDArgs;
static struct
{
  LONG FD;
  LONG Pragma;
  LONG Clib;
  LONG C;
  LONG H;
} Arguments;

/************************************************************************/

static void CloseAll(int, LONG, const char *) NORETURN;

static void CloseAll(int RC, LONG Error, const char *String)

{
  if (Filehandle!=MKBADDR(NULL))
    {
      if (!Close(Filehandle))
	{
	  if (Error==0)
	    {
	      Error=IoErr();
	      String=Filename;
	    }
	}
      DeleteFile((char *)Filename);
    }
  if (Error!=0)
    {
      PError(Error,String);
    }
  CloseStdErr();
  FreeArgs(RDArgs);
  CloseLibrary(&DOSBase->dl_lib);
  MyExit(RC,Error);
}

/************************************************************************/

static INLINE void Init(void)

{
  if ((DOSBase=(struct DosLibrary *)OpenLibrary("dos.library",ROM_VERSION))==NULL)
    {
      MyExit(RETURN_CATASTROPHY,0);
    }
  if ((RDArgs=ReadArgs("FD/S,PRAGMA/S,CLIB/S,C/S,H/S",(LONG *)&Arguments,NULL))==NULL)
    {
      CloseAll(RETURN_FAIL,IoErr(),NULL);
    }
}

/************************************************************************/
/*									*/
/* Get data about specific register.					*/
/* Register -1 designates the RESULT.					*/
/* Types:								*/
/*  0 -> type								*/
/*  1 -> name								*/
/*									*/
/************************************************************************/

static char *GetRegisterData(const char *Params, int Register, int Type)

{
  static char Buffer[100];

  struct CSource CSource;
  int State;
  int Found;
  LONG Item;

  CSource.CS_Buffer=Params;
  CSource.CS_Length=strlen(Params);
  CSource.CS_CurChr=0;
  State=0;
  Found=FALSE;
  while ((Item=ReadItem(Buffer,sizeof(Buffer),&CSource))!=ITEM_NOTHING)
    {
      switch (Item)
	{
	case ITEM_ERROR:
	  CloseAll(RETURN_ERROR,IoErr(),"Christine");

	case ITEM_QUOTED:
	case ITEM_UNQUOTED:
	  switch (State)
	    {
	    case 0:
	      if (strcmp("RESULT",Buffer)==0)
		{
		  if (Register==-1)
		    {
		      Found=TRUE;
		    }
		}
	      else
		{
		  if (Register==(Buffer[0]=='D' ? 0 : 8)+(Buffer[1]-'0'))
		    {
		      Found=TRUE;
		    }
		}
	      break;

	    case 1:
	      if (Found && Type==0)
		{
		  return Buffer;
		}
	      break;

	    case 2:
	      if (Found && Type==1)
		{
		  return Buffer;
		}
	      break;
	    }
	  break;
	}
      State=(State+1)%3;
    }
  if (Register==-1 && Type==0)
    {
      return "void";
    }
  return NULL;
}

/************************************************************************/

static INLINE void MakeFD(void)

{
  if (Arguments.FD)
    {
      ULONG Result;
      int i;

      Filename="GameSupport_lib.fd";
      if ((Filehandle=Open(Filename,MODE_NEWFILE))==MKBADDR(NULL))
	{
	  CloseAll(RETURN_ERROR,IoErr(),Filename);
	}
      if (FPuts(Filehandle,"##base _GameSupportBase\n##bias 30\n##public\n")!=0)
	{
	  CloseAll(RETURN_ERROR,IoErr(),Filename);
	}
      for (i=0; i<ARRAYSIZE(Functions); i++)
	{
	  struct CSource CSource;
	  LONG Item;
	  int Type;
	  int First;
	  int Result;
	  char Buffer[100];

	  if (VFPrintf(Filehandle,"%s(",&Functions[i].Name)==-1)
	    {
	      CloseAll(RETURN_ERROR,IoErr(),Filename);
	    }
	  CSource.CS_Buffer=(char *)Functions[i].Params;
	  CSource.CS_Length=strlen(Functions[i].Params);
	  CSource.CS_CurChr=0;
	  Type=0;
	  First=TRUE;
	  while ((Item=ReadItem(Buffer,sizeof(Buffer),&CSource))!=ITEM_NOTHING)
	    {
	      switch (Item)
		{
		case ITEM_ERROR:
		  CloseAll(RETURN_ERROR,IoErr(),"Christine");

		case ITEM_QUOTED:
		case ITEM_UNQUOTED:
		  if (Type==0)
		    {
		      Result=(strcmp("RESULT",Buffer)==0);
		    }
		  else if (Type==2)
		    {
		      if (!Result)
			{
			  if (FPrintf(Filehandle,(First ? "%s" : ",%s"),Buffer)==-1)
			    {
			      CloseAll(RETURN_ERROR,IoErr(),Filename);
			    }
			  First=FALSE;
			}
		    }
		  break;
		}
	      Type=(Type+1)%3;
	    }
	  if (FPuts(Filehandle,")(")!=0)
	    {
	      CloseAll(RETURN_ERROR,IoErr(),Filename);
	    }
	  CSource.CS_Buffer=(char *)Functions[i].Params;
	  CSource.CS_Length=strlen(Functions[i].Params);
	  CSource.CS_CurChr=0;
	  Type=0;
	  First=TRUE;
	  while ((Item=ReadItem(Buffer,sizeof(Buffer),&CSource))!=ITEM_NOTHING)
	    {
	      switch (Item)
		{
		case ITEM_ERROR:
		  CloseAll(RETURN_ERROR,IoErr(),"Christine");

		case ITEM_QUOTED:
		case ITEM_UNQUOTED:
		  if (Type==0)
		    {
		      Result=(strcmp("RESULT",Buffer)==0);
		      if (!Result)
			{
			  if (FPrintf(Filehandle,(First ? "%s" : "/%s"),Buffer)==-1)
			    {
			      CloseAll(RETURN_ERROR,IoErr(),Filename);
			    }
			  First=FALSE;
			}
		    }
		  break;
		}
	      Type=(Type+1)%3;
	    }
	  if (FPuts(Filehandle,")\n")!=0)
	    {
	      CloseAll(RETURN_ERROR,IoErr(),Filename);
	    }
	}
      if (FPuts(Filehandle,"##end\n")!=0)
	{
	  CloseAll(RETURN_ERROR,IoErr(),Filename);
	}
      Result=Close(Filehandle);
      Filehandle=NULL;
      if (!Result)
	{
	  LONG Error;

	  Error=IoErr();
	  DeleteFile(Filename);
	  CloseAll(RETURN_ERROR,Error,Filename);
	}
      SetProtection(Filename,FIBF_EXECUTE);
    }
}

/************************************************************************/

static INLINE void MakePragma(void)

{
  if (Arguments.Pragma)
    {
      ULONG Result;
      int i;
      ULONG Offset;

      Filename="include/pragmas/GameSupport_pragmas.h";
      if ((Filehandle=Open(Filename,MODE_NEWFILE))==MKBADDR(NULL))
	{
	  CloseAll(RETURN_ERROR,IoErr(),Filename);
	}
      if (FPuts(Filehandle,"#ifndef PRAGMA_GAMESUPPORT_PRAGMAS_H\n#define PRAGMA_GAMESUPPORT_PRAGMAS_H\n\n")!=0)
	{
	  CloseAll(RETURN_ERROR,IoErr(),Filename);
	}
      for (Offset=30, i=0; i<ARRAYSIZE(Functions); i++, Offset+=6)
	{
	  struct CSource CSource;
	  LONG Item;
	  int Type;
	  int ParamCount;
	  char Buffer[100];
	  char Registers[16];
	  int RegIndex;

	  if (FPrintf(Filehandle,"#pragma libcall GameSupportBase %s %lx ",Functions[i].Name,Offset)==-1)
	    {
	      CloseAll(RETURN_ERROR,IoErr(),Filename);
	    }
	  CSource.CS_Buffer=(char *)Functions[i].Params;
	  CSource.CS_Length=strlen(Functions[i].Params);
	  CSource.CS_CurChr=0;
	  Type=0;
	  ParamCount=0;
	  RegIndex=sizeof(Registers)-1;
	  Registers[RegIndex]='\0';
	  while ((Item=ReadItem(Buffer,sizeof(Buffer),&CSource))!=ITEM_NOTHING)
	    {
	      switch (Item)
		{
		case ITEM_ERROR:
		  CloseAll(RETURN_ERROR,IoErr(),"Christine");

		case ITEM_QUOTED:
		case ITEM_UNQUOTED:
		  if (Type==0)
		    {
		      if (strcmp("RESULT",Buffer)!=0)
			{
			  ULONG Register;

			  Register=(Buffer[0]=='A') ? 8 : 0;
			  Register=Register+(Buffer[1]-'0');
			  Registers[--RegIndex]=(Register<10 ? '0' : ('A'-10))+Register;
			  ParamCount++;
			}
		    }
		  break;
		}
	      Type=(Type+1)%3;
	    }
	  if (FPrintf(Filehandle,"%s0%lx\n",&Registers[RegIndex],ParamCount)==-1)
	    {
	      CloseAll(RETURN_ERROR,IoErr(),Filename);
	    }
	}
      if (FPuts(Filehandle,"\n#endif  /* PRAGMA_GAMESUPPORT_PRAGMAS_H */\n")!=0)
	{
	  CloseAll(RETURN_ERROR,IoErr(),Filename);
	}
      Result=Close(Filehandle);
      Filehandle=NULL;
      if (!Result)
	{
	  LONG Error;

	  Error=IoErr();
	  DeleteFile(Filename);
	  CloseAll(RETURN_ERROR,Error,Filename);
	}
      SetProtection(Filename,FIBF_EXECUTE);
    }
}

/************************************************************************/

static INLINE void MakeClib(void)

{
  if (Arguments.Clib)
    {
      ULONG Result;
      int i;

      Filename="include/clib/GameSupport_protos.h";
      if ((Filehandle=Open(Filename,MODE_NEWFILE))==MKBADDR(NULL))
	{
	  CloseAll(RETURN_ERROR,IoErr(),Filename);
	}
      if (FPuts(Filehandle,"#ifndef CLIB_GAMESUPPORT_PROTOS_H\n#define CLIB_GAMESUPPORT_PROTOS_H\n\n")!=0)
	{
	  CloseAll(RETURN_ERROR,IoErr(),Filename);
	}
      for (i=0; i<ARRAYSIZE(Functions); i++)
	{
	  struct CSource CSource;
	  LONG Item;
	  int Type;
	  int First;
	  int Result;
	  char Buffer[100];

	  if (FPrintf(Filehandle,"%s %s(",GetRegisterData(Functions[i].Params,-1,0),Functions[i].Name)==-1)
	    {
	      CloseAll(RETURN_ERROR,IoErr(),Filename);
	    }
	  CSource.CS_Buffer=(char *)Functions[i].Params;
	  CSource.CS_Length=strlen(Functions[i].Params);
	  CSource.CS_CurChr=0;
	  Type=0;
	  First=TRUE;
	  while ((Item=ReadItem(Buffer,sizeof(Buffer),&CSource))!=ITEM_NOTHING)
	    {
	      switch (Item)
		{
		case ITEM_ERROR:
		  CloseAll(RETURN_ERROR,IoErr(),"Christine");

		case ITEM_QUOTED:
		case ITEM_UNQUOTED:
		  if (Type==0)
		    {
		      Result=(strcmp("RESULT",Buffer)==0);
		    }
		  else if (Type==1)
		    {
		      if (!Result)
			{
			  if (FPrintf(Filehandle,(First ? "%s" : ",%s"),Buffer)==-1)
			    {
			      CloseAll(RETURN_ERROR,IoErr(),Filename);
			    }
			  First=FALSE;
			}
		    }
		  break;
		}
	      Type=(Type+1)%3;
	    }
	  if (FPuts(Filehandle,(First ? "void);\n" : ");\n"))!=0)
	    {
	      CloseAll(RETURN_ERROR,IoErr(),Filename);
	    }
	}
      if (FPuts(Filehandle,"\n#endif  /* CLIB_GAMESUPPORT_PROTOS_H */\n")!=0)
	{
	  CloseAll(RETURN_ERROR,IoErr(),Filename);
	}
      Result=Close(Filehandle);
      Filehandle=NULL;
      if (!Result)
	{
	  LONG Error;

	  Error=IoErr();
	  DeleteFile(Filename);
	  CloseAll(RETURN_ERROR,Error,Filename);
	}
      SetProtection(Filename,FIBF_EXECUTE);
    }
}

/************************************************************************/

static INLINE void MakeH(void)

{
  if (Arguments.H)
    {
      ULONG Result;
      int i;

      Filename="protos.h";
      if ((Filehandle=Open(Filename,MODE_NEWFILE))==MKBADDR(NULL))
	{
	  CloseAll(RETURN_ERROR,IoErr(),Filename);
	}
      if (FPuts(Filehandle,"#ifndef PROTOS_H\n#define PROTOS_H\n\n")!=0)
	{
	  CloseAll(RETURN_ERROR,IoErr(),Filename);
	}
      for (i=0; i<ARRAYSIZE(Functions); i++)
	{
	  ULONG Registers;
	  LONG Register;

	  if (FPuts(Filehandle,"SAVEDS")<0)
	    {
	      CloseAll(RETURN_ERROR,IoErr(),Filename);
	    }
	  Registers=0;
	  for (Register=0; Register<16; Register++)
	    {
	      if (GetRegisterData(Functions[i].Params,Register,0)!=NULL)
		{
		  Registers|=(1<<Register);
		}
	    }
	  if (Registers!=0)
	    {
	      if (FPuts(Filehandle,"_ASM_")<0)
		{
		  CloseAll(RETURN_ERROR,IoErr(),Filename);
		}
	      for (Register=0; Register<16; Register++)
		{
		  if ((Registers&(1<<Register)) &&
		      (FPutC(Filehandle,Register<8 ? 'D' : 'A')==EOF ||
		       FPutC(Filehandle,'0'+(Register&7))==EOF))
		    {
		      CloseAll(RETURN_ERROR,IoErr(),Filename);
		    }
		}
	    }
	  if (FPuts(Filehandle,"_PROTO(")<0)
	    {
	      CloseAll(RETURN_ERROR,IoErr(),Filename);
	    }
	  for (Register=-1; Register<16; Register++)
	    {
	      const char *String;

	      if ((String=GetRegisterData(Functions[i].Params,Register,0))!=NULL)
		{
		  if (VFPrintf(Filehandle,(Register==-1 ? "%s" : ",%s"),&String)==-1)
		    {
		      CloseAll(RETURN_ERROR,IoErr(),Filename);
		    }
		  if (Register==-1)
		    {
		      if (VFPrintf(Filehandle,",Lib%s",&Functions[i].Name)==-1)
			{
			  CloseAll(RETURN_ERROR,IoErr(),Filename);
			}
		    }
		}
	    }
	  if (FPuts(Filehandle,");\n")<0)
	    {
	      CloseAll(RETURN_ERROR,IoErr(),Filename);
	    }
	}
      if (FPuts(Filehandle,"\n#endif  /* PROTOS_H */\n")!=0)
	{
	  CloseAll(RETURN_ERROR,IoErr(),Filename);
	}
      Result=Close(Filehandle);
      Filehandle=NULL;
      if (!Result)
	{
	  LONG Error;

	  Error=IoErr();
	  DeleteFile(Filename);
	  CloseAll(RETURN_ERROR,Error,Filename);
	}
      SetProtection(Filename,FIBF_EXECUTE);
    }
}

/************************************************************************/

static INLINE void MakeC(void)

{
  if (Arguments.C)
    {
      ULONG Result;
      int i;

      Filename="FunctionTable.c";
      if ((Filehandle=Open(Filename,MODE_NEWFILE))==MKBADDR(NULL))
	{
	  CloseAll(RETURN_ERROR,IoErr(),Filename);
	}
      for (i=0; i<ARRAYSIZE(Functions); i++)
	{
	  if (VFPrintf(Filehandle,"(APTR)Lib%s,\n",&Functions[i].Name)==-1)
	    {
	      CloseAll(RETURN_ERROR,IoErr(),Filename);
	    }
	}
      Result=Close(Filehandle);
      Filehandle=NULL;
      if (!Result)
	{
	  LONG Error;

	  Error=IoErr();
	  DeleteFile(Filename);
	  CloseAll(RETURN_ERROR,Error,Filename);
	}
      SetProtection(Filename,FIBF_EXECUTE);
    }
}

/************************************************************************/

void AmigaMain(void)

{
  Init();
  MakeFD();
  MakePragma();
  MakeClib();
  MakeC();
  MakeH();
  CloseAll(RETURN_OK,0,NULL);
}
