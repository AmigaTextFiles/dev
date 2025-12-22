
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
struct WildScene 	*SingleScene=NULL;
struct WildApp 		*SingleApp=NULL;
ULONG			*SingleMsg=NULL;		// WildPort.
struct WildExtension	*VektorialBase;
struct  Library		*__UtilityBase;

extern struct WildSector	*SingleSector;

ULONG	*debugfh=NULL;

#define DOSBase	WildBase->wi_DOSBase
#define SysBase	*(struct ExecBase **)4L

ULONG OpenLibs()
{
 if ((WildBase=OpenLibrary("wild.library",1))==0) return(FALSE);
 __UtilityBase=WildBase->wi_UtilityBase;
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
 if (SingleMsg=CreateMsgPort())
  {
   if (SingleApp=AddWildAppTags(SingleMsg,	WIAP_Name,"Single face debug demo!",WIAP_DisplayModule,"TryPeJam+",
   					WIAP_TDCoreModule,"Monkey",WIAP_BrokerModule,"TiX+",
   					WIAP_DrawModule,"Candy+",WIAP_LightModule,"Torch",
   					WIDI_Width,320,WIDI_Height,256,WIDI_Depth,8,
   					WITD_CutDistance,30000,WIAP_BaseName,"Single",
   					WIDI_DisplayID,0x0,WIAP_PrefsHandle,TRUE,0,0))
    {
     return(TRUE);
    }
  }
 return(FALSE);
}

void GoApp()
{
 SetWildAppTagsTags(SingleApp,WITD_Scene,SingleScene);
}

void KillApp()
{
 RemWildApp(SingleApp);
}

extern void InitScene();

void RotateSingle()
{
 UBYTE *mousetest=0xbfe001,joybut;
 UWORD *joytest=0xdff00c,joyact;
 BYTE mx=0,my=0;
 joyact=joytest[0];
 if (joyact & 0x0200)
  {
   mx=-5;
  }
 else
  {
   if (joyact & 0x0002)
    {
     mx=5;
    }
  }
 joyact+=((joyact<<1)&0x0202);
 if (joyact & 0x0200)
  {
   my=-5;
  }
 else
  {
   if (joyact & 0x0002)
    {
     my=5;
    }
  }
 joybut=(mousetest[0] & 128);
 if (joybut)			/* if NO button, move, if button, rotate */
  {
   SingleSector->sec_Entity.ent_Ref.ref_O.Rel.vek_X+=mx;
   SingleSector->sec_Entity.ent_Ref.ref_O.Rel.vek_Y+=my;
  }
 else
  {
   if (mx)
    {
     RotateDD(&SingleSector->sec_Entity.ent_Ref.ref_I.Rel,mx,ROT_X,ROT_Z);
     RotateDD(&SingleSector->sec_Entity.ent_Ref.ref_J.Rel,mx,ROT_X,ROT_Z);
     RotateDD(&SingleSector->sec_Entity.ent_Ref.ref_K.Rel,mx,ROT_X,ROT_Z);
    }
   if (my)
    {
     RotateDD(&SingleSector->sec_Entity.ent_Ref.ref_I.Rel,my,ROT_Z,ROT_Y);
     RotateDD(&SingleSector->sec_Entity.ent_Ref.ref_J.Rel,my,ROT_Z,ROT_Y);
     RotateDD(&SingleSector->sec_Entity.ent_Ref.ref_K.Rel,my,ROT_Z,ROT_Y);
    }
  }
}

void Cyc()
{
 UBYTE *mousetest=0xbfe001;
 ULONG frm=200;
 while (mousetest[0] & 64)
  {
   InitFrame(SingleApp);
   RealyzeFrame(SingleApp);
   DisplayFrame(SingleApp);
   RotateSingle();   
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