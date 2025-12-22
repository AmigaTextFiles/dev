
#include <exec/types.h>
#include <inline/wild.h>
#include <inline/exec.h>
#include <inline/dos.h>
#include <wild/wild.h>
#include <wild/tdcore.h>
#include <exec/execbase.h>
#include <gcc/compiler.h>
#include <utility/hooks.h>
#include <gcc/debug.h>
#include <debugoutput.h>
#include <wild/objects.h>

extern struct WildBase 	*WildBase;
extern struct WildScene	*SingleScene;
extern struct WildApp	*SingleApp;
extern	ULONG		*debugfh;

struct	WildSector	*SingleSector;

#define DOSBase		WildBase->wi_DOSBase

static const char	tex_chu[]=	{"images/Texture.chu24\0"};
static const char	Single_pal[]=	{"images/Single.pal\0"};

void	SingleTextureHook(LIB_FCT(struct WildTexture,*tex,a2),LIB_FCT(ULONG,action,a1),LIB_FCT(struct Hook,*hook,a0))
{
 switch (action)
  {
   case TEXACTION_Load:
    {
     tex->tex_Raw=LoadFile(NULL,hook->h_Data,0);
     break;
    }
   case TEXACTION_Free:
    {
     FreeVecPooled(tex->tex_Raw);
     break;
    }
  }
}

void InitScene()
{
 static ULONG	normal[]={	0,0,0,
 				1<<16,0,0,
 				0,1<<16,0,
 				0,0,1<<16};	// normal ref in O(0,0,0)
 static ULONG	camera[]={	0,0,-400,
 				1<<16,0,0,
 				0,1<<16,0,
 				0,0,1<<16};	// normal ref in O(0,0,-200)
 static ULONG	pointA[]={	 600, -600, 0};
 static ULONG	pointD[]={	   0,    0, 0};
 static ULONG	pointE[]={	 600,  600, 0};
 static ULONG	pointLight[]={	 200,-150, -210};
 
 static ULONG	hook[]={	0,0,&SingleTextureHook,0,0};

 static ULONG 	*world,*arena,*alien,*pa,*pd,*pe,*ea,*ei,*er,*fa,
	 	*tiger,*Single_palette,*light,*lightsector,*lightpoint;

 Single_palette=LoadFile(NULL,Single_pal,0);
DebugOut("Loaded Single palette.\n\0");
 if (SingleScene=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Scene,
 					WIBU_BuildObject,TRUE,
 					WIBU_WildApp,SingleApp,
 					ATTR_SCENE_PALETTE,Single_palette,
 					ATTR_SCENE_CAMERA,&camera,0,0))
  {
DebugOut("Made scene.\n\0");
   if (world=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_World,
   					WIBU_BuildObject,TRUE,
   					WIBU_WildApp,SingleApp,
   					FRIEND_WORLD_SCENE,SingleScene,0,0))
    {
DebugOut("Made world.\n\0");
     if (arena=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Arena,
     					WIBU_BuildObject,TRUE,
     					WIBU_WildApp,SingleApp,
     					FRIEND_ARENA_WORLD,world,
     					ATTR_ENTITY_REF,&normal,0,0))
      {
DebugOut("Made arena.\n\0");
       if (alien=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Alien,
       					WIBU_BuildObject,TRUE,
       					WIBU_WildApp,SingleApp,
       					FRIEND_ALIEN_ARENA,arena,
       					ATTR_ENTITY_REF,&normal,0,0))
        {
DebugOut("Made alien.\n\0");
         if (SingleSector=BuildWildObjectTags(WIBU_ObjectType,OBJECT_Sector,
         				WIBU_BuildObject,TRUE,
         				WIBU_WildApp,SingleApp,
         				FRIEND_SECTOR_ALIEN,alien,
         				FRIEND_ENTITY_PARENT,alien,
         				ATTR_ENTITY_REF,&normal,0,0))
          {
DebugOut("Made SingleSector.\n\0");
           pa=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Point,
           				WIBU_BuildObject,TRUE,
           				WIBU_WildApp,SingleApp,
           				FRIEND_POINT_SECTOR,SingleSector,
           				ATTR_POINT_COLOR,0xff0000,
           				ATTR_POINT_VEK,&pointA,0,0);	// No more checking!! Boring !!

           pd=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Point,
           				WIBU_BuildObject,TRUE,
           				WIBU_WildApp,SingleApp,
           				FRIEND_POINT_SECTOR,SingleSector,
           				ATTR_POINT_COLOR,0xff0000,
           				ATTR_POINT_VEK,&pointD,0,0);	// No more checking!! Boring !!

           pe=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Point,
           				WIBU_BuildObject,TRUE,
           				WIBU_WildApp,SingleApp,
           				FRIEND_POINT_SECTOR,SingleSector,
           				ATTR_POINT_COLOR,0xff0000,
           				ATTR_POINT_VEK,&pointE,0,0);	// No more checking!! Boring !!

DebugOut("Made points. :)\n\0");

           lightsector=BuildWildObjectTags(WIBU_ObjectType,OBJECT_Sector,
         				WIBU_BuildObject,TRUE,
         				WIBU_WildApp,SingleApp,
         				FRIEND_SECTOR_ALIEN,arena,
         				FRIEND_ENTITY_PARENT,arena,
         				ATTR_ENTITY_REF,&normal,0,0);
         				
           lightpoint=BuildWildObjectTags(WIBU_ObjectType,OBJECT_Point,
           				WIBU_BuildObject,TRUE,
           				WIBU_WildApp,SingleApp,
           				FRIEND_POINT_SECTOR,lightsector,
           				ATTR_POINT_VEK,&pointLight,0,0);

	   light=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Light,
	   				WIBU_BuildObject,TRUE,
	   				WIBU_WildApp,SingleApp,
	   				FRIEND_LIGHT_ARENA,arena,
	   				ATTR_LIGHT_COLOR,0xffffff,
	   				ATTR_LIGHT_INTENSITY,1503,
	   				FRIEND_LIGHT_POINT,lightpoint,0,0);

DebugOut("Made light and his own sector.\n\0");
 

	   ea=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Edge,
	   				WIBU_BuildObject,TRUE,
	   				WIBU_WildApp,SingleApp,
	   				FRIEND_EDGE_SECTOR,SingleSector,
	   				FRIEND_EDGE_POINTA,pa,
	   				FRIEND_EDGE_POINTB,pd,0,0);
	   				
	   ei=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Edge,
	   				WIBU_BuildObject,TRUE,
	   				WIBU_WildApp,SingleApp,
	   				FRIEND_EDGE_SECTOR,SingleSector,
	   				FRIEND_EDGE_POINTA,pa,
	   				FRIEND_EDGE_POINTB,pe,0,0);

	   er=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Edge,
	   				WIBU_BuildObject,TRUE,
	   				WIBU_WildApp,SingleApp,
	   				FRIEND_EDGE_SECTOR,SingleSector,
	   				FRIEND_EDGE_POINTA,pe,
	   				FRIEND_EDGE_POINTB,pd,0,0);
DebugOut("Made edges.\n\0");
					
	   hook[4]=&tex_chu;
	   tiger=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Texture,
	   				WIBU_BuildObject,TRUE,
	   				WIBU_WildApp,SingleApp,
					ATTR_TEXTURE_HOOK,hook,		//check
					FRIEND_TEXTURE_WORLD,world,
					ATTR_TEXTURE_WIDTH,256,
					ATTR_TEXTURE_HEIGHT,256,0,0);
DebugOut("Loaded texture and palettes.\n\0");
	   
	   fa=BuildWildObjectTags(	WIBU_ObjectType,OBJECT_Face,
	   				WIBU_BuildObject,TRUE,
	   				WIBU_WildApp,SingleApp,
	   				FRIEND_FACE_SECTOR,SingleSector,
	   				FRIEND_FACE_POINTA,pe,
	   				FRIEND_FACE_POINTB,pa,
	   				FRIEND_FACE_POINTC,pd,
	   				FRIEND_FACE_EDGEA,ei,
	   				FRIEND_FACE_EDGEB,er,
	   				FRIEND_FACE_EDGEC,ea,
	   				FRIEND_FACE_TEXTURE,tiger,
	   				ATTR_FACE_TXA,255,
	   				ATTR_FACE_TYA,255,
	   				ATTR_FACE_TXB,0,
	   				ATTR_FACE_TYB,0,
	   				ATTR_FACE_TXC,0,
	   				ATTR_FACE_TYC,255,
	   				ATTR_FACE_FLAGS,0,0,0);

	   BuildWildObjectTags(		WIBU_ObjectType,OBJECT_Sector,
	   				WIBU_ModifyObject,SingleSector,
	   				FRIEND_SHELL_ROOT,fa,0,0);
DebugOut("Made BSP-Tree.\n\0");
	   				
          }//Sector
        }//Alien
      }//Arena					   
    }//World
  }//Scene
}
