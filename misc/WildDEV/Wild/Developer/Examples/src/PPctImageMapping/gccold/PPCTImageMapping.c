
#include <exec/types.h>
#include <startup.h>
#include <inline/wild.h>
#include <inline/ppct.h>
#include <inline/exec.h>
#include <inline/dos.h>
#include <wild/wild.h>
#include <wild/display_typeb2.h>
#include <extensions/ppct.h>

struct WildExtension *PPctExtensionBase=NULL;

struct WildApp *WApp=NULL;
UBYTE *Chunky=NULL;

void mousewait()
{
 UBYTE *mouse=0xbfe001;
 while (mouse[0] & 64);
}

void ShowImage()
{
 UWORD x,y;
 ULONG pa=0,pb=0;
 InitFrame(WApp);
 for (y=0;y<256;y++)
  {
   for (x=0;x<256;x++)
    {
     WApp->wap_FrameBuffer->fb_Chunky[pa]=Chunky[pb];pa++;pb++;
    }
   pa+=64;	//hakkful, used only because i know the width of the view and i'm too lazy 
   		// to code something better...
  }
 DisplayFrame(WApp);     
}

int main()
{
 if (PPctExtensionBase=LoadExtension("PPct.library",1))
  {
   ULONG args[2];
   if (ReadArgs("IMAGE/A,PALETTE/A",&args,0))
    {
     ULONG *Palette,*Image;
     if (Image=LoadFile(0,args[0],0))
      {
       if (Palette=LoadFile(0,args[1],0))
        {
         ULONG *ppct;
         ppct=MakePPCTTags(	PPCT_ChunkyArray,Palette,PPCT_MaxTreeDepth,10,
          			PPCT_ChunkyPixelsNum,256,PPCT_RGBMode,TRUE,
         			PPCT_MaxColorsPerNode,1,0,0);
         Chunky=AllocVec(262144,0);
         ImagePPCT(ppct,Image,Chunky,262144);
          {  
           ULONG *msg;
           msg=CreateMsgPort();
           if (WApp=AddWildAppTags(msg,	WIAP_Name,"PPCT Image Mapping!",WIAP_BaseName,"PPctMap",
           				WIAP_PrefsHandle,TRUE,WIAP_DisplayModule,"TryPeJam+",
           				WIAP_TypeABCD,0x00020000,WIAP_TypeEFGH,0x00000000,
           				WIDI_Width,320,WIDI_Height,256,WIDI_Depth,8,
           				WIDI_Palette,Palette,0,0))
            {
             ShowImage();	 
             mousewait(); 
             RemWildApp(WApp);
            }
           DeleteMsgPort(msg);
          }
         FreePPCT(ppct);
         FreeVec(Chunky);
         FreeVecPooled(Palette);
        }
       FreeVecPooled(Image);
      }
    }
   KillExtension(PPctExtensionBase); 
  }  
}