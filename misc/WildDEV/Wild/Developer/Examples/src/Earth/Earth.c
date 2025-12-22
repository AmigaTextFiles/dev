
#include <exec/types.h>
#include <extensions/vektorial.h>
#include <wild/wild.h>
#include <wild/tdcore.h>
#include <exec/execbase.h>
#include <wild/objects.h>
#include <wild/animation.h>

struct WildBase 	*WildBase=NULL;
struct WildScene 	*EarthScene=NULL;
struct WildApp 		*EarthApp=NULL;
ULONG			*EarthMsg=NULL;		/* WildPort. */
struct WildExtension	*VektorialBase;
struct WildSector	*RingSector,*SpotSector,*EarthSector,*PlaneSector,*BaseSector;
struct Ref		*EarthCamera;
struct WildArena	*EarthArena;
struct WildWorld	*EarthWorld;
struct WildAction	*EarthAction;
struct WildAlien	*EarthAlien;
struct WildLight 	*SpotLight;

ULONG	*debugfh=NULL;

extern LONG Rnd();

ULONG OpenLibs()
{
 if (!(WildBase=((struct WildBase *)OpenLibrary("wild.library",1)))) return(FALSE);
 if (!(VektorialBase=((struct WildExtension *)LoadExtension("libs:wild/Vektorial.library",0)))) return(FALSE);
 return(TRUE);
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
 if (EarthMsg=((struct MsgPort *)CreateMsgPort()))
  {
   ULONG earthapptags[]={WIAP_Name,0,
   			WIAP_BaseName,0,
   			WIAP_DisplayModule,0,
   			WIAP_TDCoreModule,0,
   			WIAP_BrokerModule,0,
   			WIAP_DrawModule,0,
   			WIAP_LightModule,0,
   			WIAP_LoaderModule,0,
   			WIDI_Width,320,WIDI_Height,256,WIDI_Depth,8,
   			WITD_CutDistance,30000,
   			WIDI_DisplayID,0x0,WIAP_PrefsHandle,TRUE,0,0};
   earthapptags[1]=((ULONG)"Earth");
   earthapptags[3]=((ULONG)"Earth");
   earthapptags[5]=((ULONG)"TryPeJam+");
   earthapptags[7]=((ULONG)"Monkey");
   earthapptags[9]=((ULONG)"ShiX");
   earthapptags[11]=((ULONG)"Fluff");
   earthapptags[13]=((ULONG)"Torch");
   earthapptags[15]=((ULONG)"WSFF");
   if (EarthApp=((struct WildApp *)AddWildApp(EarthMsg,&earthapptags[0])))
    {
     return(TRUE);
    }
  }
 return(FALSE);
}

void GoApp()
{
 ULONG scetags[]={WITD_Scene,0,0,0};
 scetags[1]=((ULONG)EarthScene);
 SetWildAppTags(EarthApp,&scetags[0]);
}

void KillApp()
{
 RemWildApp(EarthApp);
}

static const struct WildMoveCommand SpinEarth[]={
	{MOVECOMMAND_SET,TARGET_RX,0},
	{MOVECOMMAND_SET,TARGET_RY,0x10000},
	{MOVECOMMAND_SET,TARGET_RZ,0},
	{MOVECOMMAND_SET,TARGET_R|TARGET_V,0x8000},	/* after 2 secs, v=2 */
	{MOVECOMMAND_END,0,0}};

static const struct WildMoveCommand SpinSpot[]={
	{MOVECOMMAND_SET,TARGET_RX,0x0000deb8},
	{MOVECOMMAND_SET,TARGET_RY,0xffffb0a4},
	{MOVECOMMAND_SET,TARGET_RZ,0x00005c28},
	{MOVECOMMAND_SET,TARGET_R|TARGET_V,3<<16},
	{MOVECOMMAND_END,0,0}};

static const struct WildMoveCommand SpinRing[]={
	{MOVECOMMAND_SET,TARGET_RX,0xffffd7f4},
	{MOVECOMMAND_SET,TARGET_RY,0x0000fcd9},
	{MOVECOMMAND_SET,TARGET_RZ,0},
	{MOVECOMMAND_SET,TARGET_R|TARGET_V,5<<16},
	{MOVECOMMAND_END,0,0}};

void InitScene()
{
 ULONG loadtags[]={WILO_FileName,0,WILO_ObjectType,OBJECT_Scene,0,0};
 loadtags[1]=((ULONG)"earth.wsff");
 if (EarthScene=((struct WildScene *)LoadWildObject(EarthApp,&loadtags[0])))
  {
   struct WildArena *are;
   struct WildAlien *ali;
   struct WildWorld *wor;
   EarthCamera=&EarthScene->sce_Camera;
   EarthWorld=((struct WildWorld *)GetWildObjectChild(EarthScene,CHILD_SCENE_WORLD,1));
   EarthArena=((struct WildArena *)GetWildObjectChild(EarthWorld,CHILD_WORLD_ARENA,1));
   EarthAlien=((struct WildAlien *)GetWildObjectChild(EarthArena,CHILD_ARENA_ALIEN,1));
   BaseSector=((struct WildSector *)GetWildObjectChild(EarthAlien,CHILD_ALIEN_SECTOR,2));
   EarthSector=((struct WildSector *)GetWildObjectChild(EarthAlien,CHILD_ALIEN_SECTOR,4));
   SpotSector=((struct WildSector *)GetWildObjectChild(EarthAlien,CHILD_ALIEN_SECTOR,3));
   RingSector=((struct WildSector *)GetWildObjectChild(EarthAlien,CHILD_ALIEN_SECTOR,1));
   SpotLight=((struct WildLight *)GetWildObjectChild(EarthArena,CHILD_ARENA_LIGHT,1));
   {
    ULONG acttags[]={	WIBU_ObjectType,OBJECT_Action,
    			WIBU_BuildObject,TRUE,
    			WIBU_WildApp,0,
    			ATTR_ACTION_SECTORS,3,0,0};
    acttags[5]=((ULONG)EarthApp);
    if (EarthAction=((struct WildAction *)BuildWildObject(&acttags[0])))
     {
      ULONG movtags[]={	WIBU_ObjectType,OBJECT_Move,
      			WIBU_BuildObject,TRUE,
      			WIBU_WildApp,0,
      			ATTR_MOVE_SECTORID,0,
      			ATTR_MOVE_DURATION,0x7fffffff,
      			ATTR_MOVE_STARTER,0,
      			ATTR_MOVE_COMMANDLIST,0,
      			FRIEND_MOVE_ACTION,0,0,0};
      movtags[5]=((ULONG)EarthApp);
      movtags[15]=((ULONG)EarthAction);
      
/* sector ids: Earth=1 Spot=2 Ring=3 */
      
      movtags[7]=2;			/* sectorID */
      movtags[11]=0;			/* starter  */
      movtags[13]=((ULONG)&SpinSpot);	/* commands */
      BuildWildObject(&movtags[0]);

      movtags[7]=3;			/* sectorID */
      movtags[11]=250;			/* starter  */
      movtags[13]=((ULONG)&SpinRing);	/* commands */
      BuildWildObject(&movtags[0]);

      movtags[7]=1;			/* sectorID */
      movtags[11]=500;			/* starter  */
      movtags[13]=((ULONG)&SpinEarth);	/* commands */
      BuildWildObject(&movtags[0]);

       {
        ULONG dotags[]={	WIDA_Alien,0,
        			WIDA_Action,0,
        			WIDA_Sectors,0,0,0};
        struct WildSectors *secs[4]={0,0,0,0};
        secs[0]=EarthSector;
        secs[1]=SpotSector;
        secs[2]=RingSector;
        dotags[1]=((ULONG)EarthAlien);
        dotags[3]=((ULONG)EarthAction);
        dotags[5]=((ULONG)&secs[0]);
        DoAction(EarthApp,&dotags[0]);
       }
     }
   }
  }				
}

void SunLight()
{
 LONG i;
 i=(WildBase->wi_Ticker & 255);
 if (i>128) i=255-i;
 i=i*2+50;
 SpotLight->lig_Intensity=i;
}

void Cyc()
{
 UBYTE *mousetest=0xbfe001;
 struct WildArena *ars[2];
 ULONG animtags[]={WIAN_Arenas,0,0,0};
 ars[0]=EarthArena;
 ars[1]=NULL;
 animtags[1]=((ULONG)&ars[0]);
 while (mousetest[0] & 64)
  {
   InitFrame(EarthApp);
   RealyzeFrame(EarthApp);
   DisplayFrame(EarthApp);
   WildAnimate(EarthApp,&animtags[0]);
   while ((mousetest[0] & 128)==0);
   EarthCamera->ref_O.Abs.vek_Z-=1;
   SunLight();
  }
}   

int main()
{
 if (OpenLibs())
  {
   if (InitApp())
    {
     InitScene();
     GoApp();   
     Cyc();
     KillApp();
    } 
   CloseLibs();
  } 
}
