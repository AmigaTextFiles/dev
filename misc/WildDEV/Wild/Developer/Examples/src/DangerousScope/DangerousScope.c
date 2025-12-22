
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
#include <wild/animation.h>

struct WildBase 	*WildBase=NULL;
struct WildScene 	*SimpleScene=NULL;
struct WildApp 		*SimpleApp=NULL;
ULONG			*SimpleMsg=NULL;		// WildPort.
struct WildExtension	*VektorialBase;
struct WildSector	*RingSector,*SostSector,*GiroSector,*LamaSector;
struct Ref		*SimpleCamera;
struct WildArena	*SimpleArena;
struct WildWorld	*SimpleWorld;
struct WildAction	*Roast;

ULONG	*debugfh=NULL;

#define DOSBase	WildBase->wi_DOSBase
#define SysBase	*(struct ExecBase **)4L

extern LONG Rnd();

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
   					WIAP_Name,"Dangerous Scope: animation rotational demo",
   					WIAP_DisplayModule,"TryPeJam+",
   					WIAP_TDCoreModule,"SimplyFast",
   					WIAP_BrokerModule,"TiX+",
   					WIAP_DrawModule,"Candy+",
   					WIAP_LightModule,"Koton",
   					WIAP_LoaderModule,"WABL",
   					WIDI_Width,320,WIDI_Height,256,WIDI_Depth,8,
   					WITD_CutDistance,30000,WIAP_BaseName,"DangerousScope",
   					WIDI_DisplayID,0x0,WIAP_PrefsHandle,TRUE,0,0))
    {
     return(TRUE);
    }
  }
 return(FALSE);
}

void RotateSimple()
{
// RotateDD(&SimpleCamera->ref_O.Abs,5,ROT_X,ROT_Z);
// CamLookingAt(SimpleCamera,&GroundSector->sec_Entity.ent_Ref.ref_O.Abs,CAM_GROUND_ORIENTED);
}

void GoApp()
{
 SetWildAppTagsTags(SimpleApp,WITD_Scene,SimpleScene);
}

void KillApp()
{
 RemWildApp(SimpleApp);
}

static const struct WildMoveCommand SostComms[]={
	{MOVECOMMAND_SET,TARGET_RX,0},
	{MOVECOMMAND_SET,TARGET_RY,1<<16},
	{MOVECOMMAND_SET,TARGET_RZ,0},
	{MOVECOMMAND_SET,TARGET_R|TARGET_V,1<<16},
	{MOVECOMMAND_END,0,0}};

static const struct WildMoveCommand GiroComms[]={
	{MOVECOMMAND_SET,TARGET_RX,0x0},		/*$b504 = ((sqrt(2)/2)<<16), is a 45 degrees axis*/
	{MOVECOMMAND_SET,TARGET_RY,0x10000},
	{MOVECOMMAND_SET,TARGET_RZ,0},
	{MOVECOMMAND_SET,TARGET_R|TARGET_V,5<<16},
	{MOVECOMMAND_END,0,0}};

static const struct WildMoveCommand LamaComms[]={
	{MOVECOMMAND_SET,TARGET_RX,1<<16},
	{MOVECOMMAND_SET,TARGET_RY,0},
	{MOVECOMMAND_SET,TARGET_RZ,0},
	{MOVECOMMAND_SET,TARGET_R|TARGET_V,1<<16},
	{MOVECOMMAND_END,0,0}};

void InitScene()
{
 SimpleScene=LoadWildObjectTags(SimpleApp,
 				WILO_FileName,"Danger.WABL",
 				WILO_ObjectType,OBJECT_Scene,
 				0,0);
 {
  struct WildArena *are;
  struct WildAlien *ali;
  struct WildWorld *wor;
  SimpleCamera=&SimpleScene->sce_Camera;
  SimpleWorld=GetWildObjectChild(SimpleScene,CHILD_SCENE_WORLD,1);
  SimpleArena=GetWildObjectChild(SimpleWorld,CHILD_WORLD_ARENA,1);
  RingSector=GetWildObjectChild(SimpleArena,CHILD_ALIEN_SECTOR,1);
  SostSector=GetWildObjectChild(SimpleArena,CHILD_ALIEN_SECTOR,2);
  GiroSector=GetWildObjectChild(SimpleArena,CHILD_ALIEN_SECTOR,3);
  LamaSector=GetWildObjectChild(SimpleArena,CHILD_ALIEN_SECTOR,4);
  if (Roast=BuildWildObjectTags(WIBU_ObjectType,OBJECT_Action,
  				WIBU_BuildObject,TRUE,
  				WIBU_WildApp,SimpleApp,
  				ATTR_ACTION_SECTORS,4,
  				0,0))
   {
    struct WildSector *sects[5]={RingSector,SostSector,GiroSector,LamaSector,0};

/* Note: the RingSector is included in the Action even if it does not move only because
         if I want to add a movement in the future I can, but you should not insert it
         in the action. Inserting simply wastes a bit of memory, no slowdown... */


/*    BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Move,
    				WIBU_BuildObject,TRUE,
    				WIBU_WildApp,SimpleApp,
    				ATTR_MOVE_SECTORID,2,
    				ATTR_MOVE_DURATION,0x7fffffff,	
				ATTR_MOVE_STARTER,0,
				ATTR_MOVE_COMMANDLIST,&SostComms[0],
				FRIEND_MOVE_ACTION,Roast,
				0,0);  */

    BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Move,
    				WIBU_BuildObject,TRUE,
    				WIBU_WildApp,SimpleApp,
    				ATTR_MOVE_SECTORID,3,
    				ATTR_MOVE_DURATION,0x7fffffff,	/*=1.36 years, enough ?*/
				ATTR_MOVE_STARTER,0,
				ATTR_MOVE_COMMANDLIST,&GiroComms[0],
				FRIEND_MOVE_ACTION,Roast,
				0,0);	

/*    BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Move,
    				WIBU_BuildObject,TRUE,
    				WIBU_WildApp,SimpleApp,
    				ATTR_MOVE_SECTORID,4,
    				ATTR_MOVE_DURATION,0x7fffffff,
				ATTR_MOVE_STARTER,0,
				ATTR_MOVE_COMMANDLIST,&LamaComms[0],
				FRIEND_MOVE_ACTION,Roast,
				0,0); */
				
    DoActionTags(SimpleApp,	WIDA_Alien,SimpleArena,
    				WIDA_Action,Roast,
    				WIDA_Sectors,&sects[0],
				0,0);
   }				
 }				
}

void Cyc()
{
 struct WildArena *ars[2]={SimpleArena,0};
 UBYTE *mousetest=0xbfe001;
 ULONG frm=200;
 while (mousetest[0] & 64)
  {
   InitFrame(SimpleApp);
   RealyzeFrame(SimpleApp);
   DisplayFrame(SimpleApp);
   WildAnimateTags(SimpleApp,WIAN_Arenas,&ars[0],0,0);
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