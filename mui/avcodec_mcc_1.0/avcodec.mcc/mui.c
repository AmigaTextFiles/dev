/*---Erzeugen der MUI-Oberfläche---*/

#include <clib/alib_protos.h>
#include <clib/macros.h>
#include <clib/utility_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/debug_protos.h>
#include <libraries/asl.h>

#include <graphics/gfx.h>

#include <graphics/rpattr.h>
#include <graphics/gfxmacros.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>




/* prototypes */


#include <proto/intuition.h>
#include <proto/exec.h>
#include <proto/muimaster.h>


#include "main.h"
#include "avcodec_mcc/avcodec_mcc.h"
#include "mui_def.c"

int CreateGui(struct Args *temp)
{
ULONG sigs = 0;


	    app = ApplicationObject,
		MUIA_Application_Title  , "Avcodec Viewer",
		MUIA_Application_Version , "$VER: 1.0 (31.03.18) Avcodec Viewer 2018 Carsten Siegner",
		MUIA_Application_Copyright , "©2018, Carsten Siegner",
		MUIA_Application_Author  , "Carsten Siegner",
		MUIA_Application_Description,"Demo",
		
		
		SubWindow, window = WindowObject,
			MUIA_Window_Title, "Avcodec Viewer",
			
			MUIA_Window_ID ,"Demo",
			MUIA_Window_SizeGadget,TRUE,
			MUIA_Window_AppWindow, TRUE,
			 MUIA_Window_DragBar,TRUE,
			 MUIA_Window_DepthGadget,TRUE,
			 MUIA_Window_CloseGadget,TRUE,
            MUIA_Window_UseBottomBorderScroller,TRUE,
			MUIA_Window_UseRightBorderScroller,TRUE,
			 WindowContents, VGroup,
			 Child, VGroup, MUIA_Background, MUII_GroupBack,MUIA_Frame,MUIV_Frame_Group,
			  Child, hyp_obj = PopaslObject, ASLFR_TitleText, "mpg,wmv,avi,svg...",ASLFR_InitialDrawer,"Ram:",
                       MUIA_Popstring_Button, PopButton(MUII_PopFile),
                     	MUIA_Popstring_String, hyp_string = StringObject,MUIA_Frame,MUIV_Frame_String,MUIA_Background,MUII_StringBack,End,
	                  End,
			
			 Child, zip = AvcodecObject,End,
			 
			       Child, HGroup,
				   Child, GroupObject,End,
			             Child, ss = ImageObject,MUIA_Image_Spec,MUII_TapePlay,MUIA_InputMode,MUIV_InputMode_RelVerify,End,
			             Child, st = ImageObject,MUIA_Image_Spec,MUII_TapeStop,MUIA_InputMode,MUIV_InputMode_RelVerify,End,
   
			       
			       Child, GroupObject,End,
			    End,
			
              End,
              End,
            
            
      End,
	  End;

	if (!app){
		printf("I can't create the app!\n");
		return 0;
	}
	
	
	DoMethod(window,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
    DoMethod(hyp_string,MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,zip,3,MUIM_Set,MUIA_AVCODEC_PATH,MUIV_TriggerValue);
    DoMethod(ss,MUIM_Notify,MUIA_Pressed,FALSE,zip,1,MUIM_AVCODEC_START);
	DoMethod(st,MUIM_Notify,MUIA_Pressed,FALSE,zip,1,MUIM_AVCODEC_STOP);
	
	
	 set(window,MUIA_Window_Open,TRUE);
   

   
    

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