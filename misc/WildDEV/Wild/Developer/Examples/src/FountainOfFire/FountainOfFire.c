
//#define	FLYAWAYDROPS

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
struct WildSector	*GroundSector;
struct Ref		*SimpleCamera;
struct WildSector	*SpotSector;
struct WildArena	*SimpleArena;
struct WildWorld	*SimpleWorld;

static struct WildMoveCommand DropCommands[]={
	{MOVECOMMAND_SET,TARGET_Y|TARGET_V,0},
	{MOVECOMMAND_SET,TARGET_Y|TARGET_A,1200},
	{MOVECOMMAND_SET,TARGET_X|TARGET_V,0},
	{MOVECOMMAND_SET,TARGET_Z|TARGET_V,0},
	{MOVECOMMAND_SET,TARGET_RX,0},
	{MOVECOMMAND_SET,TARGET_RY,0x10000},
	{MOVECOMMAND_SET,TARGET_RZ,0},
	{MOVECOMMAND_SET,TARGET_V|TARGET_R,10<<16},
	{MOVECOMMAND_END,0,0}};

#ifdef	FLYAWAYDROPS	
static const struct WildMoveCommand FlyAwayCommands[]={
	{MOVECOMMAND_SET,TARGET_Y|TARGET_V,0},
	{MOVECOMMAND_SET,TARGET_Y|TARGET_A,-1000},
	{MOVECOMMAND_SET,TARGET_X|TARGET_V,0},
	{MOVECOMMAND_SET,TARGET_Z|TARGET_V,0},
	{MOVECOMMAND_END,0,0}};
#endif

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
   					WIAP_Name,"Fountain of fire: animation simple demo",
   					WIAP_DisplayModule,"TryPeJam+",
   					WIAP_TDCoreModule,"SimplyFast",
   					WIAP_BrokerModule,"TiX+",
   					WIAP_DrawModule,"Candy+",
   					WIAP_LightModule,"Torch",
   					WIAP_LoaderModule,"WSFF",
   					WIDI_Width,320,WIDI_Height,256,WIDI_Depth,8,
   					WITD_CutDistance,30000,WIAP_BaseName,"FountainOfFire",
   					WIDI_DisplayID,0x0,WIAP_PrefsHandle,TRUE,0,0))
    {
     return(TRUE);
    }
  }
 return(FALSE);
}

void RotateSimple()
{
 RotateDD(&SimpleCamera->ref_O.Abs,5,ROT_X,ROT_Z);
 CamLookingAt(SimpleCamera,&GroundSector->sec_Entity.ent_Ref.ref_O.Abs,CAM_GROUND_ORIENTED);
}

void KillDrop(ASMREG(struct WildDoing,*doing,a2))
{
 Remove(((struct WildDoingSector *)doing->doi_Sectors.mlh_Head)->dse_Sector);
 FreeWildObject(((struct WildDoingSector *)doing->doi_Sectors.mlh_Head)->dse_Sector);
}

static const struct Hook KillDropHook={0,0,&KillDrop,0,0};

void NewDrop()
{
 static LONG ref[12]={0,-50,0,1<<16,0,0,0,1<<16,0,0,0,1<<16};
 struct WildSector *newdrop;
 struct WildAction *action;
 LONG px,pz,py;
 px=(Rnd()>>26);
 pz=(Rnd()>>26);
 py=(Rnd()>>24)^2;
 DropCommands[2].mcd_Value=px*2000;
 DropCommands[3].mcd_Value=pz*2000;
 DropCommands[0].mcd_Value=-(py+100000);
 if (newdrop=BuildWildObjectTags(WIBU_ObjectType,OBJECT_Sector,
 				WIBU_BuildObject,TRUE,
 				WIBU_WildApp,SimpleApp,
 				FRIEND_SECTOR_ALIEN,SimpleArena,
 				ATTR_ENTITY_REF,&ref[0],
 				FRIEND_ENTITY_PARENT,SimpleArena,
 				0,0))
  {
   static const LONG pointA[3]={-10,-25,0};
   static const LONG pointB[3]={10,-25,0};
   static const LONG pointC[3]={0,0,0};
   static const LONG pointD[3]={0,5,0};
   static const LONG pointE[3]={0,-20,10};
   static const LONG pointF[3]={0,-20,-10};
   
   struct WildTexture *tex;
   struct WildPoint *pa,*pb,*pc,*pd,*pe,*pf;
   struct WildEdge *ea,*eb,*ec,*ed,*ee,*ef;
   struct WildFace *fa,*fb;

   action=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Action,
   				WIBU_BuildObject,TRUE,
   				WIBU_WildApp,SimpleApp,
   				ATTR_ACTION_SECTORS,1,
   				ATTR_ACTION_STOPCALL,&KillDropHook,
   				0,0);
   BuildWildObjectTags(		WIBU_ObjectType,OBJECT_Move,
   				WIBU_BuildObject,TRUE,
   				WIBU_WildApp,SimpleApp,
   				ATTR_MOVE_SECTORID,1,
   				ATTR_MOVE_STARTER,0,
   				ATTR_MOVE_DURATION,200,
   				ATTR_MOVE_COMMANDLIST,&DropCommands[0],
   				FRIEND_MOVE_ACTION,action,0,0);
#ifdef	FLYAWAYDROPS	
   BuildWildObjectTags(		WIBU_ObjectType,OBJECT_Move,
   				WIBU_BuildObject,TRUE,
   				WIBU_WildApp,SimpleApp,
   				ATTR_MOVE_SECTORID,1,
   				ATTR_MOVE_STARTER,200,
   				ATTR_MOVE_DURATION,200,
   				ATTR_MOVE_COMMANDLIST,&FlyAwayCommands[0],
   				FRIEND_MOVE_ACTION,action,0,0);
#endif
   
   tex=GetWildObjectChild(SimpleWorld,CHILD_WORLD_TEXTURE,1);
   pa=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Point,
       				WIBU_BuildObject,TRUE,
            			WIBU_WildApp,SimpleApp,
           			FRIEND_POINT_SECTOR,newdrop,
           			ATTR_POINT_COLOR,0xff0000,
           			ATTR_POINT_VEK,&pointA,0,0);	// No more checking!! Boring !!
   pb=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Point,
       				WIBU_BuildObject,TRUE,
           			WIBU_WildApp,SimpleApp,
           			FRIEND_POINT_SECTOR,newdrop,
           			ATTR_POINT_COLOR,0xff0000,
           			ATTR_POINT_VEK,&pointB,0,0);	// No more checking!! Boring !!
   pc=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Point,
       				WIBU_BuildObject,TRUE,
           			WIBU_WildApp,SimpleApp,
           			FRIEND_POINT_SECTOR,newdrop,
           			ATTR_POINT_COLOR,0xff0000,
           			ATTR_POINT_VEK,&pointC,0,0);	// No more checking!! Boring !!
   pd=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Point,
       				WIBU_BuildObject,TRUE,
           			WIBU_WildApp,SimpleApp,
           			FRIEND_POINT_SECTOR,newdrop,
           			ATTR_POINT_COLOR,0xff0000,
           			ATTR_POINT_VEK,&pointD,0,0);	// No more checking!! Boring !!
   pe=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Point,
       				WIBU_BuildObject,TRUE,
           			WIBU_WildApp,SimpleApp,
           			FRIEND_POINT_SECTOR,newdrop,
           			ATTR_POINT_COLOR,0xff0000,
           			ATTR_POINT_VEK,&pointE,0,0);	// No more checking!! Boring !!
   pf=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Point,
       				WIBU_BuildObject,TRUE,
           			WIBU_WildApp,SimpleApp,
           			FRIEND_POINT_SECTOR,newdrop,
           			ATTR_POINT_COLOR,0xff0000,
           			ATTR_POINT_VEK,&pointF,0,0);	// No more checking!! Boring !!
   ea=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Edge,
	   			WIBU_BuildObject,TRUE,
	   			WIBU_WildApp,SimpleApp,
	   			FRIEND_EDGE_SECTOR,newdrop,
	   			FRIEND_EDGE_POINTA,pa,
	   			FRIEND_EDGE_POINTB,pb,0,0);
   eb=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Edge,
	   			WIBU_BuildObject,TRUE,
	   			WIBU_WildApp,SimpleApp,
	   			FRIEND_EDGE_SECTOR,newdrop,
	   			FRIEND_EDGE_POINTA,pb,
	   			FRIEND_EDGE_POINTB,pc,0,0);
   ec=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Edge,
	   			WIBU_BuildObject,TRUE,
	   			WIBU_WildApp,SimpleApp,
	   			FRIEND_EDGE_SECTOR,newdrop,
	   			FRIEND_EDGE_POINTA,pc,
	   			FRIEND_EDGE_POINTB,pa,0,0);
   ed=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Edge,
	   			WIBU_BuildObject,TRUE,
	   			WIBU_WildApp,SimpleApp,
	   			FRIEND_EDGE_SECTOR,newdrop,
	   			FRIEND_EDGE_POINTA,pf,
	   			FRIEND_EDGE_POINTB,pe,0,0);
   ee=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Edge,
	   			WIBU_BuildObject,TRUE,
	   			WIBU_WildApp,SimpleApp,
	   			FRIEND_EDGE_SECTOR,newdrop,
	   			FRIEND_EDGE_POINTA,pf,
	   			FRIEND_EDGE_POINTB,pd,0,0);
   ef=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Edge,
	   			WIBU_BuildObject,TRUE,
	   			WIBU_WildApp,SimpleApp,
	   			FRIEND_EDGE_SECTOR,newdrop,
	   			FRIEND_EDGE_POINTA,pd,
	   			FRIEND_EDGE_POINTB,pe,0,0);
   fa=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Face,
	   			WIBU_BuildObject,TRUE,
	   			WIBU_WildApp,SimpleApp,
	   			FRIEND_FACE_SECTOR,newdrop,
	   			FRIEND_FACE_POINTA,pa,
	   			FRIEND_FACE_POINTB,pb,
	   			FRIEND_FACE_POINTC,pc,
	   			FRIEND_FACE_EDGEA,ea,
	   			FRIEND_FACE_EDGEB,eb,
	   			FRIEND_FACE_EDGEC,ec,
	   			FRIEND_FACE_TEXTURE,tex,
	   			ATTR_FACE_TXA,128,
	   			ATTR_FACE_TYA,0,
	   			ATTR_FACE_TXB,128,
	   			ATTR_FACE_TYB,127,
	   			ATTR_FACE_TXC,255,
	   			ATTR_FACE_TYC,127,
	   			ATTR_FACE_FLAGS,0,0,0);
   fb=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Face,
	   			WIBU_BuildObject,TRUE,
	   			WIBU_WildApp,SimpleApp,
	   			FRIEND_FACE_SECTOR,newdrop,
	   			FRIEND_FACE_POINTA,pd,
	   			FRIEND_FACE_POINTB,pe,
	   			FRIEND_FACE_POINTC,pf,
	   			FRIEND_FACE_EDGEA,ed,
	   			FRIEND_FACE_EDGEB,ee,
	   			FRIEND_FACE_EDGEC,ef,
	   			FRIEND_FACE_TEXTURE,tex,
	   			ATTR_FACE_TXA,128,
	   			ATTR_FACE_TYA,0,
	   			ATTR_FACE_TXB,128,
	   			ATTR_FACE_TYB,127,
	   			ATTR_FACE_TXC,255,
	   			ATTR_FACE_TYC,127,
	   			ATTR_FACE_FLAGS,0,0,0);
   BuildWildObjectTags(		WIBU_ObjectType,OBJECT_Face,
	   			WIBU_ModifyObject,fa,
	   			FRIEND_FACE_PLUS,fb,0,0);
   BuildWildObjectTags(		WIBU_ObjectType,OBJECT_Face,
	   			WIBU_ModifyObject,fb,
	   			FRIEND_FACE_MINUS,fa,0,0);
   DoActionTags(SimpleApp,	WIDA_Alien,SimpleArena,
   				WIDA_Action,action,
   				WIDA_Sectors,&newdrop,0,0);
  }				
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
 				WILO_FileName,"Fountain.WSFF",
 				WILO_ObjectType,OBJECT_Scene,
 				0,0);
 {
  struct WildArena *are;
  struct WildAlien *ali;
  struct WildWorld *wor;
  SimpleCamera=&SimpleScene->sce_Camera;
  SimpleWorld=GetWildObjectChild(SimpleScene,CHILD_SCENE_WORLD,1);
  SimpleArena=GetWildObjectChild(SimpleWorld,CHILD_WORLD_ARENA,1);
  GroundSector=GetWildObjectChild(SimpleArena,CHILD_ALIEN_SECTOR,1);
 }
}

void Cyc()
{
 struct WildArena *ars[2]={SimpleArena,0};
 ULONG atags[]={WIAN_Arenas,0,0,0};
 UBYTE *mousetest=0xbfe001;
 ULONG frm=200;
 atags[1]=((ULONG)&ars[0]);
 while (mousetest[0] & 64)
  {
   InitFrame(SimpleApp);
   RealyzeFrame(SimpleApp);
   DisplayFrame(SimpleApp);

   WildAnimate(SimpleApp,&atags[0]);

   while ((mousetest[0] & 128)==0);

   NewDrop();
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