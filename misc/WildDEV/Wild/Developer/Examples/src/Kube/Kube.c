
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

struct WildBase 	*WildBase=NULL;
struct WildScene 	*KubeScene=NULL;
struct WildApp 		*KubeApp=NULL;
ULONG			*KubeMsg=NULL;		// WildPort.
struct WildExtension	*VektorialBase;

extern struct WildSector	*KubeSector;

ULONG	*debugfh=NULL;

#define DOSBase	WildBase->wi_DOSBase
#define SysBase	*(struct ExecBase **)4L

ULONG OpenLibs()
{
 if ((WildBase=OpenLibrary("wild.library",1))==0) return(FALSE);
 if ((VektorialBase=LoadExtension("libs:wild/Vektorial.library",0))==0) return(FALSE);
}

void CloseLibs()
{
 if (VektorialBase)
  {KillExtension(VektorialBase);
   VektorialBase=0;}
 if (WildBase)
  {CloseLibrary(WildBase);
   WildBase=0;}
}

BOOL InitApp()
{
 if (KubeMsg=CreateMsgPort())
  {
   if (KubeApp=AddWildAppTags(KubeMsg,	WIAP_Name,"Kubik demo!",WIAP_DisplayModule,"TryPeJam+",
   					WIAP_TDCoreModule,"Monkey",WIAP_BrokerModule,"ShiX",
   					WIAP_DrawModule,"Fluff",WIAP_LightModule,"Torch",
   					WIDI_Width,320,WIDI_Height,256,WIDI_Depth,8,
   					WITD_CutDistance,30000,WIAP_BaseName,"Kube",
   					WIDI_DisplayID,0x0,WIAP_PrefsHandle,TRUE,0,0))
    {
     return(TRUE);
    }
  }
 return(FALSE);
}

void GoApp()
{
 SetWildAppTagsTags(KubeApp,WITD_Scene,KubeScene);
}

void KillApp()
{
 RemWildApp(KubeApp);
}

extern void InitScene();

void RotateKube()
{
 RotateDD(&KubeSector->sec_Entity.ent_Ref.ref_I.Rel,10,ROT_X,ROT_Z);
 RotateDD(&KubeSector->sec_Entity.ent_Ref.ref_J.Rel,10,ROT_X,ROT_Z);
 RotateDD(&KubeSector->sec_Entity.ent_Ref.ref_K.Rel,10,ROT_X,ROT_Z);

 RotateDD(&KubeSector->sec_Entity.ent_Ref.ref_I.Rel,15,ROT_X,ROT_Y);
 RotateDD(&KubeSector->sec_Entity.ent_Ref.ref_J.Rel,15,ROT_X,ROT_Y);
 RotateDD(&KubeSector->sec_Entity.ent_Ref.ref_K.Rel,15,ROT_X,ROT_Y);
}

void Cyc()
{
 UBYTE *mousetest=0xbfe001;
 ULONG frm=200;
 while (mousetest[0] & 64)
  {
   InitFrame(KubeApp);
   RealyzeFrame(KubeApp);
   DisplayFrame(KubeApp);

   while ((mousetest[0] & 128)==0);

   RotateKube();   
  }
}   

void InitDebug()
{
 debugfh=Output();
}

int main()
{
 if (OpenLibs())
  {
   InitDebug();
   DebugOut("Debug init.\n\0");
   if (InitApp())
    {
     InitScene();
     GoApp();   
     Cyc();
     KillApp();
    } //APP
   CloseLibs();
  } //LIBS
}