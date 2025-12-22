
#include <exec/types.h>
#include <inline/wild.h>
#include <inline/exec.h>
#include <inline/dos.h>
#include <inline/vektorial.h>
#include <extensions/vektorial.h>
#include <wild/wild.h>
#include <wild/tdcore.h>
#include <exec/execbase.h>
#include <gcc/compiler.h>
#include <debugoutput.h>
#include <gcc/debug.h>
#include <wild/objects.h>

struct WildBase 	*WildBase=NULL;
struct WildApp 		*LoadSaveApp=NULL;
ULONG			*LoadSaveMsg=NULL;		// WildPort.

char *infrm,*outfrm;

ULONG	*debugfh=NULL;

ULONG 	*outfh=NULL;

#define DOSBase	WildBase->wi_DOSBase
#define SysBase	*(struct ExecBase **)4L

ULONG OpenLibs()
{
 if ((WildBase=OpenLibrary("wild.library",1))==0) return(FALSE);
}

void CloseLibs()
{
 if (WildBase)
  {CloseLibrary(WildBase);
   WildBase=0;}
}

BOOL InitApp()
{
 if (LoadSaveMsg=CreateMsgPort())
  {
   if (LoadSaveApp=AddWildAppTags(LoadSaveMsg,	WIAP_Name,"LoadSave Wild converter",
   					WIAP_BaseName,"LoadSave",
   					WIAP_LoaderModule,infrm,
   					WIAP_SaverModule,outfrm,
   					WIAP_PrefsHandle,TRUE,0,0))
    {
     return(TRUE);
    }
  }
 return(FALSE);
}

void KillApp()
{
 RemWildApp(LoadSaveApp);
}

void InitDebug()
{
 debugfh=Output();
}

#define ARG_LOADER	0
#define	ARG_SAVER	1
#define	ARG_IN		2
#define	ARG_OUT		3

void Ko(char *in,char *out)
{
 void *obj;
 ULONG type=OBJECT_Scene;
 if (obj=LoadWildObjectTags(LoadSaveApp,WILO_FileName,in,
 				WILO_ObjectType,type,
 				0,0))
  {
   if (SaveWildObjectTags(LoadSaveApp,WISA_FileName,out,
   				WISA_Object,obj,
   				WISA_ObjectType,type,
   				0,0))
    {
     
    }					
  }					
}

int main()
{
 if (OpenLibs())
  {
   void *rd;
   ULONG *arg[4];
   if (rd=ReadArgs("Loader/A,Saver/A,IN/A,OUT/A",&arg[0],0))
    {
     infrm=arg[0];
     outfrm=arg[1];
     outfh=Output();
     DebugOut("Debug init.\n\0");
     if (InitApp())
      {
       Ko(arg[ARG_IN],arg[ARG_OUT]);
       KillApp();
      } //APP
    }
   CloseLibs();
  } //LIBS
}