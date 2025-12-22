
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
struct WildScene 	*SimpleScene=NULL;
struct WildApp 		*SimpleApp=NULL;
ULONG			*SimpleMsg=NULL;		// WildPort.
struct WildExtension	*VektorialBase;
struct WildSector	*GroundSector;
struct Ref		*SimpleCamera;
struct WildSector	*SpotSector;

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
 if (SimpleMsg=CreateMsgPort())
  {
   if (SimpleApp=AddWildAppTags(SimpleMsg,
   					WIAP_Name,"SimpleWorld: a WABL fileload demo!",
   					WIAP_DisplayModule,"TryPeJam+",
   					WIAP_TDCoreModule,"SimplyFast",
   					WIAP_BrokerModule,"TiX+",
   					WIAP_DrawModule,"Candy+",
   					WIAP_LightModule,"Torch",
   					WIAP_LoaderModule,"WABL",
   					WIDI_Width,320,WIDI_Height,256,WIDI_Depth,8,
   					WITD_CutDistance,30000,WIAP_BaseName,"SimpleWorld",
   					WIDI_DisplayID,0x0,WIAP_PrefsHandle,TRUE,0,0))
    {
     return(TRUE);
    }
  }
 return(FALSE);
}

void GoApp()
{
 SetWildAppTagsTags(SimpleApp,WITD_Scene,SimpleScene);
}

void KillApp()
{
 RemWildApp(SimpleApp);
}

void InitScene()
{
 SimpleScene=LoadWildObjectTags(SimpleApp,
 				WILO_FileName,"Simple.WABL",
 				WILO_ObjectType,OBJECT_Scene,
 				0,0);
 {
  struct WildArena *are;
  struct WildAlien *ali;
  struct WildWorld *wor;
  SimpleCamera=&SimpleScene->sce_Camera;
//  are=(SimpleScene->sce_World->wor_Arenas.mlh_Head);
  wor=GetWildObjectChild(SimpleScene,CHILD_SCENE_WORLD,1);
  are=GetWildObjectChild(wor,CHILD_WORLD_ARENA,1);
//  ali=(are->are_Aliens.mlh_Head);
  ali=GetWildObjectChild(are,CHILD_ARENA_ALIEN,1);
//  SpotSector=(ali->ali_Sectors.mlh_Head);
  SpotSector=GetWildObjectChild(ali,CHILD_ALIEN_SECTOR,1);
//  GroundSector=(are->are_Alien.ali_Sectors.mlh_Head);  
  GroundSector=GetWildObjectChild(are,CHILD_ALIEN_SECTOR,1);
 }
}

void RotateSimple()
{
 RotateDD(&SpotSector->sec_Entity.ent_Ref.ref_O.Rel,10,ROT_X,ROT_Z);
 RotateDD(&SimpleCamera->ref_O.Abs,4,ROT_X,ROT_Z);
 SimpleCamera->ref_O.Abs.vek_Y--;
 CamLookingAt(SimpleCamera,&GroundSector->sec_Entity.ent_Ref.ref_O.Abs,CAM_GROUND_ORIENTED);
}

void Cyc()
{
 UBYTE *mousetest=0xbfe001;
 ULONG frm=200;
 while (mousetest[0] & 64)
  {
   InitFrame(SimpleApp);
   RealyzeFrame(SimpleApp);
   DisplayFrame(SimpleApp);

   while ((mousetest[0] & 128)==0);

   RotateSimple();   
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