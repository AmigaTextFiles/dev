
#include <exec/types.h>
#include <startup.h>
#include <wild/wild.h>
#include <wild/display_typeb2.h>
#include <extensions/ppct.h>

struct WildExtension *PPctppcExtensionBase=NULL;
struct Library *PowerPCBase;

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
   pa+=64;	/*hakkful, used only because i know the width of the view and i'm too lazy 
     		  to code something better...*/
  }
 DisplayFrame(WApp);     
}

struct WildBase *WildBase;

int main()
{
 WildBase=((WildBase *)OpenLibrary("wild.library",1));
 PowerPCBase=WildBase->wi_PowerPCBase;
 if (PPctppcExtensionBase=((struct WildExtension *)LoadExtension("PPctppc.library",1)))
  {
   ULONG args[2];
   if (ReadArgs("IMAGE/A,PALETTE/A",&args,0))
    {
     ULONG *Palette,*Image;
     if (Image=((ULONG *)LoadFile(0,args[0],0)))
      {
       if (Palette=((ULONG *)LoadFile(0,args[1],0)))
        {
         ULONG *ppct;
         ULONG ppcttags[]={	PPCT_ChunkyArray,0,PPCT_MaxTreeDepth,10,
          			PPCT_ChunkyPixelsNum,256,PPCT_RGBMode,TRUE,
         			PPCT_MaxColorsPerNode,1,0,0};
         ppcttags[1]=((ULONG)Palette);
         ppct=((ULONG *)ppcMakePPCT(PPctppcExtensionBase,&ppcttags[0]));
         Chunky=((UBYTE *)AllocVec(262144,0));
         ppcImagePPCT(PPctppcExtensionBase,ppct,Image,Chunky,262144);
          {  
           ULONG *msg;
           ULONG wapptags[]={	WIAP_Name,0,
           			WIAP_BaseName,0,
           			WIAP_PrefsHandle,TRUE,
           			WIAP_DisplayModule,0,
				WIDI_Palette,0,
           			WIAP_TypeABCD,0x00020000,
           			WIAP_TypeEFGH,0x00000000,
           			WIDI_Width,320,
           			WIDI_Height,256,
           			WIDI_Depth,8,
           			0,0};
           wapptags[1]=((ULONG)"PPCT Image Mapping!");
           wapptags[3]=((ULONG)"PPctMap");
           wapptags[7]=((ULONG)"TryPeJam+");
	   wapptags[9]=((ULONG)Palette);           
           msg=((ULONG *)CreateMsgPort());
           if (WApp=((struct WildApp *)AddWildApp(msg,&wapptags[0])))
            {
             ShowImage();	 
             mousewait(); 
             RemWildApp(WApp);
            }
           DeleteMsgPort(msg);
          }
         ppcFreePPCT(PPctppcExtensionBase,ppct);
         FreeVec(Chunky);
         FreeVecPooled(Palette);
        }
       FreeVecPooled(Image);
      }
    }
   KillExtension(PPctppcExtensionBase); 
  }  
}
