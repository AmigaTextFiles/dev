#include <clib/alib_protos.h>
#include <clib/extras_protos.h>

#include <stdio.h>
#include <tagitemmacros.h>

#include <classes/supermodel.h>
#include <proto/classes/supermodel.h>

#include <proto/classes/gadgets/tcpalette.h>
#include <classes/gadgets/tcpalette.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include <proto/window.h>
#include <proto/label.h>
#include <proto/slider.h>
#include <proto/layout.h>
#include <proto/button.h>

#include <intuition/classes.h>

#include <classes/window.h>

#include <gadgets/layout.h>
#include <gadgets/button.h>
#include <gadgets/slider.h>

#include <images/label.h>

#include <reaction/reaction.h>
#include <reaction/reaction_macros.h>


#define APP_Test (TAG_USER + 1)
#define APP_Red (TAG_USER + 2)
#define APP_Green (TAG_USER + 3)
#define APP_Blue (TAG_USER + 4)

#define ID_BUTTON   	1
#define ID_FOREGROUND  	2
#define ID_BACKGROUND	3

struct Library  *WindowBase,
                *LayoutBase,
                *LabelBase,
                *ButtonBase,
                *BevelBase,
                *SliderBase,
                *TCPaletteBase,
                *SuperModelBase;
                
struct LocaleBase *LocaleBase;

struct Catalog *Catalog;

struct Libs MyLibs[]=
{
  (APTR *)&WindowBase,    "window.class",               44,     0,
  (APTR *)&LayoutBase,    "gadgets/layout.gadget",      44,     0,
  (APTR *)&ButtonBase,    "gadgets/button.gadget",      44,     0,
  (APTR *)&LabelBase,     "images/label.image",         44,     0,
  (APTR *)&BevelBase,     "images/bevel.image",         44,     0,
  (APTR *)&SliderBase,    "gadgets/slider.gadget",      44,     0,
  (APTR *)&TCPaletteBase, "gadgets/tcpalette.gadget",   44,     0,
  (APTR *)&SuperModelBase,"supermodel.class",           44,     0,
  0, 0, 0, 0
};


int main( int argc, char *argv[] )
{
	struct Window *window;
	Object *Win_Object, *Pal1, *Red, *Green, *Blue;
  ULONG palette[]={0xff0000, 0x00ff00, 0x0000ff, 0xffffff, 0x000000, 0x888888},l,lrgb;
  struct TCPaletteRGB p[6],rgb;

	if(ex_OpenLibs(argc, "TCPaletteTest", 0,0,0, MyLibs))
  {
    Win_Object = (Object *)WindowObject,
  			WA_ScreenTitle, "TCPalette",
  			WA_Title,       "TCPalette",
  			WA_SizeGadget,  TRUE,
  			WA_DepthGadget, TRUE,
  			WA_DragBar,     TRUE,
  			WA_CloseGadget, TRUE,
  			WA_Activate,    TRUE,
  			WA_SmartRefresh,      TRUE,
   			WINDOW_ParentGroup,   VLayoutObject,
  				LAYOUT_DeferLayout, TRUE,
          LAYOUT_AddChild,    Button("Test",0), 
            CHILD_WeightedHeight,0,
          LAYOUT_AddChild,    Pal1=TCPaletteObject,
                                TCPALETTE_NumColors,    6,
                                TCPALETTE_LRGBPalette,  palette, 
                                TCPALETTE_Precision,    8,
                                End,          
            Label("_Palette"),
          
          LAYOUT_AddChild,    Red=SliderObject,
                                SLIDER_Max, 0xff,
                                SLIDER_Min, 0,
                                SLIDER_Orientation,FREEHORIZ,
                                End,          
            CHILD_WeightedHeight,0,
          
          LAYOUT_AddChild,    Green=SliderObject,
                                SLIDER_Max, 0xff,
                                SLIDER_Min, 0,
                                SLIDER_Orientation,FREEHORIZ,
                                End,
            CHILD_WeightedHeight,0,
            
          LAYOUT_AddChild,    Blue=SliderObject,
                                SLIDER_Max, 0xff,
                                SLIDER_Min, 0,
                                SLIDER_Orientation,FREEHORIZ,
                                End,                    
            CHILD_WeightedHeight,0,
   			EndMember,
  		EndWindow;
  
  		/*  Object creation sucessful?
  		 */
    if( Win_Object )
  	{
      Object *model;
      model=SM_NewSuperModel(
                  SMA_AddMember,  SM_SICMAP( Pal1,
                                    TCPALETTE_SelectedRGB,         APP_Test,
                                    TCPALETTE_SelectedRed,         APP_Red,
                                    TCPALETTE_SelectedGreen,       APP_Green,
                                    TCPALETTE_SelectedBlue,        APP_Blue,
                                    TAG_DONE),
                  SMA_AddMember,  SM_SICMAP( Red,
                                    SLIDER_Level,                   APP_Red,
                                    TAG_DONE),
                  SMA_AddMember,  SM_SICMAP( Green,
                                    SLIDER_Level,                   APP_Green,
                                    TAG_DONE),
                  SMA_AddMember,  SM_SICMAP( Blue,
                                    SLIDER_Level,                   APP_Blue,
                                    TAG_DONE),                              
                  TAG_DONE);
        
  			/*  Open the window. */
       
      if( window = (struct Window *) RA_OpenWindow(Win_Object) )
      {
  		  ULONG wait, signal, result, done = FALSE;
  			WORD Code;
  				
  			/* Obtain the window wait signal mask. */
  		  GetAttr( WINDOW_SigMask, Win_Object, &signal );
  
  			/* Input Event Loop */
  			while( !done )
  			{
  			  wait = Wait(signal|SIGBREAKF_CTRL_C);
 					if (wait & SIGBREAKF_CTRL_C) 
            done = TRUE;
 					else
          {
  					while ((result = RA_HandleInput(Win_Object,&Code)) != WMHI_LASTMSG)
  					{
  						switch (result & WMHI_CLASSMASK)
  						{
  							case WMHI_CLOSEWINDOW:
  								done = TRUE;
  								break;
  
  							case WMHI_GADGETUP:
  								switch(result & WMHI_GADGETMASK)
  								{
  									case ID_BUTTON:
  										break;
  								}
  								break;
  						}
  					}
  				}
  			}
  
  			/* Disposing of the window object will
  			 * also close the window if it is
  			 * already opened and it will dispose of
  			 * all objects attached to it.
  			 */
        GetAttr(TCPALETTE_RGBPalette, Pal1, p);
        
        for(l=0;l<6;l++)
        {
          printf("TCPALETTE_RGBPalette %d R:%08x G:%08x B:%08x\n",l,p[l].R,p[l].G,p[l].B);
        }
         
        GetAttr(TCPALETTE_LRGBPalette, Pal1, palette);
        for(l=0;l<6;l++)
        {
          printf("TCPALETTE_LRGBPalette %d 0x%06x\n",l,palette[l]);
        }
        
        GetAttr(TCPALETTE_SelectedColor, Pal1, &l);
        printf("TCPALETTE_SelectedColor %d\n",l);
        
        GetAttr(TCPALETTE_SelectedRGB, Pal1, &rgb);
        printf("TCPALETTE_PaletteRGB R:0%08x G:0%08x B:0%08x\n",rgb.R,rgb.G,rgb.B);
        
        GetAttr(TCPALETTE_SelectedLRGB, Pal1, &lrgb);
        printf("TCPALETTE_SelectedLRGB 0x%06x\n",lrgb);
        printf("Note: TCPALETTE_SelectedRed, Green & Blue use the folowing precision\n");
        
        GetAttr(TCPALETTE_Precision, Pal1, &l);
        printf("TCPALETTE_Precision   0x%08x\n",l);
        
        GetAttr(TCPALETTE_SelectedRed, Pal1, &l);
        printf("TCPALETTE_SelectedRed   0x%08x\n",l);
        
        GetAttr(TCPALETTE_SelectedGreen, Pal1, &l);
        printf("TCPALETTE_SelectedGreen 0x%08x\n",l);
        
        GetAttr(TCPALETTE_SelectedBlue, Pal1, &l);
        printf("TCPALETTE_SelectedBlue  0x%08x\n",l);
        
        GetAttr(TCPALETTE_ShowSelected, Pal1, &l);
        printf("TCPALETTE_ShowSelected  %d\n",l);
        
        GetAttr(TCPALETTE_NumColors, Pal1, &l);
        printf("TCPALETTE_NumColors  %d\n",l);
           
        DisposeObject(model);
  			DisposeObject( Win_Object );
  		}
    }
    ex_CloseLibs(MyLibs);
  }
}

