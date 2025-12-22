/*---Erzeugen der MUI-Oberfläche---*/

#include <libraries/mui.h>
#include <libraries/asl.h>

#include <proto/intuition.h>
#include <proto/exec.h>
#include <proto/muimaster.h>
#include <proto/cybergraphics.h>
#include <proto/layers.h>
#include <proto/utility.h>

#include <clib/alib_protos.h>

#include <proto/utility.h>

#include "epub_mcc/epub_mcc.h"
#include "mui_def.c"
#include "main.h"

int CreateGui(struct Args *temp)
{
ULONG sigs = 0;


  app = ApplicationObject,
		MUIA_Application_Title  , "Epub Reader",
		MUIA_Application_Version , "$VER: 0.2 (02.09.17) Epub Reader 2017 Carsten Siegner",
		MUIA_Application_Copyright , "©2017, Carsten Siegner",
		MUIA_Application_Author  , "Carsten Siegner",
		MUIA_Application_Description,"Testprog, use the Epub.mcc to show Epub's",
	
		
		SubWindow, window = WindowObject,
			MUIA_Window_Title, "Epub Reader",
			
			MUIA_Window_ID ,"EpubViewer",
			MUIA_Window_SizeGadget,TRUE,
			MUIA_Window_AppWindow, TRUE,
			 MUIA_Window_DragBar,TRUE,
			 MUIA_Window_DepthGadget,TRUE,
			 MUIA_Window_CloseGadget,TRUE,
            MUIA_Window_UseBottomBorderScroller,TRUE,
		 	MUIA_Window_UseRightBorderScroller,TRUE,
			 WindowContents, VGroup,
			 Child, VGroup, MUIA_Background, MUII_GroupBack,MUIA_Frame,MUIV_Frame_Group,
			 
			   Child, hyp_obj = PopaslObject, ASLFR_TitleText, "Ebook...",ASLFR_InitialDrawer,"Ram:",
                       MUIA_Popstring_Button, PopButton(MUII_PopFile),
                     	MUIA_Popstring_String, hyp_string = StringObject,MUIA_Frame,MUIV_Frame_String,MUIA_Background,MUII_StringBack,End,
	                  End,
			 
			 Child, HGroup,
			
			
			
			
			   Child,VGroup,
			 
			 
			 
	             Child, main_group = ScrollgroupObject,MUIA_Scrollgroup_UseWinBorder,TRUE,MUIA_Scrollgroup_Contents,vg = VirtgroupObject,MUIA_Virtgroup_Input,TRUE,

			 
	       		  Child, zip = EpubObject,End,//MUIA_EPUB_COVER_FIRST,TRUE,End,
			 
			 
	            End,End,		 
			 
			 
	   		          Child, info = GaugeObject,MUIA_Gauge_Horiz,TRUE,MUIA_VertWeight,3,End,
			          Child, strip = SliderObject,MUIA_Slider_Min,1,MUIA_Slider_Horiz,TRUE,MUIA_VertWeight,0,MUIA_Slider_Max,10,End,
			   
			     End,
			 End,
			 
		    End,
            End,
            
            
            
        End,
	    End;

	if (!app){
		printf("I can't create the app!\n");
		return 0;
	}
	
	
	
	
	 DoMethod(hyp_string,MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,zip,3,MUIM_Set,MUIA_EPUB_OPEN,MUIV_TriggerValue);
	 DoMethod(hyp_string,MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,strip,3,MUIM_Set,MUIA_Slider_Level,1);
     DoMethod(window,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
	 DoMethod(strip,MUIM_Notify,MUIA_Slider_Level,MUIV_EveryTime,zip,3,MUIM_Set,MUIA_EPUB_SELECT_PAGE,MUIV_TriggerValue);
	 
	 
	 
	 
	 
    set(window,MUIA_Window_Open,TRUE);
   

   /*----------------*/
   
   set(zip,MUIA_EPUB_H1_FONT,"Arial");
   set(zip,MUIA_EPUB_H2_FONT,"Arial");
   set(zip,MUIA_EPUB_H3_FONT,"Arial");
   set(zip,MUIA_EPUB_H4_FONT,"Arial");
   set(zip,MUIA_EPUB_H5_FONT,"Arial");
   set(zip,MUIA_EPUB_P_FONT,"Arial");
   set(zip,MUIA_EPUB_URL_FONT,"Arial");
   
   /*----------------*/
   
   set(zip,MUIA_EPUB_URL_COLOR,"#0000ff");
   
   /*----------------*/
   
   set(zip,MUIA_EPUB_H1_SIZE,28);
   set(zip,MUIA_EPUB_H2_SIZE,24);
   set(zip,MUIA_EPUB_H3_SIZE,22);
   set(zip,MUIA_EPUB_H4_SIZE,18);
   set(zip,MUIA_EPUB_H5_SIZE,15);
   set(zip,MUIA_EPUB_P_SIZE,11);
   set(zip,MUIA_EPUB_URL_SIZE,11);
   
   /*---------------*/
   
   set(zip,MUIA_EPUB_MARGIN_TOP,5);
   set(zip,MUIA_EPUB_MARGIN_BOTTOM,5);
   set(zip,MUIA_EPUB_MARGIN_LEFT,5);
   set(zip,MUIA_EPUB_MARGIN_RIGHT,5);
   
   
   /*---------------*/
   
   set(zip,MUIA_EPUB_GAUGE,info);
   set(zip,MUIA_EPUB_SCROLLGROUP,main_group);
   set(zip,MUIA_EPUB_SLIDER,strip);
   set(zip,MUIA_EPUB_DEVICE,"netprinter.device");
   set(zip,MUIA_EPUB_UNIT,0);
   
   
   
   
   
   
       while (DoMethod(app,MUIM_Application_NewInput,&sigs)!=MUIV_Application_ReturnID_Quit)
	   {
	      if (sigs)
	      {
	         sigs = Wait(sigs | SIGBREAKF_CTRL_C);
	         if (sigs & SIGBREAKF_CTRL_C) break;
	      }
	   }
	   
	   set(window,MUIA_Window_Open,FALSE);
	   
	   	MUI_DisposeObject(app);
   



return 1;
}