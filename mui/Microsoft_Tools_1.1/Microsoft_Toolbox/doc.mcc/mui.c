/*---Erzeugen der MUI-Oberfläche---*/

#include <stdio.h>
#include <string.h>
#include <clib/alib_protos.h>
#include <clib/macros.h>
#include <clib/utility_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/debug_protos.h>

#include <graphics/gfx.h>
#include <libraries/asl.h>

#include <graphics/rpattr.h>
#include <graphics/gfxmacros.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>




/* prototypes */


#include <proto/intuition.h>
#include <proto/exec.h>
#include <proto/muimaster.h>


#include "main.h"

#include "doc_mcc.h"

#include <mui/Aboutbox_mcc.h>




#include "mui_def.c"

#define ID_INFO      1
#define ID_MUIINFO   2
#define ID_MUI1      3
#define ID_F1      4



struct NewMenu MenuData1[] =
{
	{ NM_TITLE, "Project"                             ,0,0 ,0             ,(APTR)0  },
   

    
    
    
  
   	{ NM_ITEM ,  "About..."                   ,"I",0 ,0             ,(APTR)ID_INFO  },
	{ NM_ITEM ,  "About MUI..."                   ,".",0 ,0             ,(APTR)ID_MUIINFO  },
	
	{ NM_ITEM ,  NM_BARLABEL               , 0 ,0 ,0             ,(APTR)0            },
	
	{ NM_ITEM ,  "Quit..."                    ,"Q",0 ,0             ,(APTR)MUIV_Application_ReturnID_Quit},
    { NM_TITLE, "Settings"                  ,0,0 ,0             ,(APTR)0  },

	{ NM_ITEM ,  "MUI..."                   ,"ß",0 ,0             ,(APTR)ID_MUI1  },
	


  

	{ NM_END,NULL,0,0,0,(APTR)0 },
};



static char *ps_cyc[] = { "2","3",NULL };
static char *pdf_cyc[] = { "1.4","1.5",NULL };


















int CreateGui(struct Args *temp)
{
ULONG sigs = 0;
Object *bottom,*right;	

int err;
int maxl;
Object **t = (Object**)AllocVec(sizeof(Object*) * 4,MEMF_ANY | MEMF_CLEAR);

 

	    app = ApplicationObject,
		MUIA_Application_Title  , "Doc Viewer",
		MUIA_Application_Version , "$VER: 1.0 (01.10.18) Doc_Viewer 2018 Carsten Siegner",
		MUIA_Application_Copyright , "©2018, Carsten Siegner",
		MUIA_Application_Author  , "Carsten Siegner",
		MUIA_Application_Description,"Viewer for Microsoft Word files",
		
		
		SubWindow, window = WindowObject,
			MUIA_Window_Title, "DOC Viewer",
			MUIA_Window_Menustrip, strip = MUI_MakeObject(MUIO_MenustripNM,MenuData1,MUIO_MenustripNM_CommandKeyCheck),
			

			MUIA_Window_ID ,"DOC_Viewer1",
			MUIA_Window_SizeGadget,TRUE,
			MUIA_Window_AppWindow, TRUE,
			 MUIA_Window_DragBar,TRUE,
			 MUIA_Window_DepthGadget,TRUE,
			 MUIA_Window_CloseGadget,TRUE,
            MUIA_Window_UseBottomBorderScroller,TRUE,
			MUIA_Window_UseRightBorderScroller,TRUE,
			 WindowContents, VGroup,
			 Child, VGroup, MUIA_Background, MUII_GroupBack,MUIA_Frame,MUIV_Frame_Group,
			 
			     Child, HGroup,MUIA_Background, MUII_GroupBack,MUIA_Frame,MUIV_Frame_Group,
				         Child, Label("File"),
						 Child, PopaslObject, ASLFR_TitleText, "Open DOC files...",ASLFR_InitialDrawer,"ram:",
                         MUIA_Popstring_Button, PopButton(MUII_PopFile),
                     	 MUIA_Popstring_String,dpath = StringObject,MUIA_Frame,MUIV_Frame_String,MUIA_Background,MUII_StringBack,End,
                         End,
				End,
				End,
			 
			     Child, GroupObject, MUIA_Group_Columns,2,MUIA_Background, MUII_GroupBack,MUIA_Frame,MUIV_Frame_Group,
			     Child , Label("Title"),
				 Child, t[0] = TextObject,MUIA_Background, MUII_TextBack ,MUIA_Frame,MUIV_Frame_Text,End,
		         Child , Label("Subject"),
				 Child, t[1] = TextObject,MUIA_Background, MUII_TextBack ,MUIA_Frame,MUIV_Frame_Text,End,
		         Child , Label("Author"),
				 Child, t[2] = TextObject,MUIA_Background, MUII_TextBack ,MUIA_Frame,MUIV_Frame_Text,End,
		         Child , Label("Company"),
				 Child, t[3] = TextObject,MUIA_Background, MUII_TextBack ,MUIA_Frame,MUIV_Frame_Text,End,
		
					  
				
				 End,
				  
				  
				Child, GroupObject,  
			
			    Child, xx = ScrollgroupObject,MUIA_Prop_Entries,100,MUIA_Scrollgroup_UseWinBorder,TRUE,MUIA_Scrollgroup_Contents,vg = VirtgroupObject,MUIA_Virtgroup_Input,TRUE,
                Child,  zip1 = DocObject,MUIA_DOC_WIDTH,595,MUIA_DOC_HEIGHT,842,End,
                 
				 
			
                
			 
			    End,End,
				
				Child, gg = GaugeObject,MUIA_Gauge_Horiz,TRUE,MUIA_Weight,3,End,
				Child, slider = SliderObject,MUIA_Slider_Min,1,MUIA_Slider_Horiz,TRUE,End,
				
				
				
				
				
				
              End,
              End,
            
            
      End,
	  
	  SubWindow, window2 = AboutboxObject,
	            MUIA_Window_ID,"DOC_VIEWER2",
	         
	            End,

	  
	
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  End;

	if (!app){
		printf("I can't create the app!\n");
		return 0;
	}
	
	
	info  = (APTR)DoMethod(strip,MUIM_FindUData,ID_INFO);
    muiinfo  = (APTR)DoMethod(strip,MUIM_FindUData,ID_MUIINFO);
    muiset  = (APTR)DoMethod(strip,MUIM_FindUData,ID_MUI1);
    zip  = (APTR)DoMethod(strip,MUIM_FindUData,ID_F1);

	
	
	
	
	
	
	
	
	
	
	
	
	
	DoMethod(info,MUIM_Notify,MUIA_Menuitem_Trigger,MUIV_EveryTime,window2,3,MUIM_Set,MUIA_Window_Open,TRUE);
    DoMethod(muiinfo,MUIM_Notify,MUIA_Menuitem_Trigger,MUIV_EveryTime,app,2,MUIM_Application_AboutMUI,window  );
	DoMethod(muiset,MUIM_Notify,MUIA_Menuitem_Trigger,MUIV_EveryTime,app,3,MUIM_Application_OpenConfigWindow,0,0);
	DoMethod(zip,MUIM_Notify,MUIA_Menuitem_Trigger,MUIV_EveryTime,window3,3,MUIM_Set,MUIA_Window_Open,TRUE);
	DoMethod(window3,MUIM_Notify,MUIA_Window_CloseRequest,MUIV_EveryTime,window3,3,MUIM_Set,MUIA_Window_Open,FALSE);
	
    DoMethod(slider,MUIM_Notify,MUIA_Slider_Level,MUIV_EveryTime,zip1,3,MUIM_Set,MUIA_DOC_PAGENUMBER,MUIV_TriggerValue);
    DoMethod(dpath,MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,zip1,3,MUIM_Set,MUIA_DOC_PATH,MUIV_TriggerValue);

	
	
	
	
	
	
	DoMethod(window,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
	
	
   
 	  
	/*-----------------------------------*/
	
	  set(zip1,MUIA_DOC_GAUGE,gg);
	  set(zip1,MUIA_DOC_INFO,t);
	  set(zip1,MUIA_DOC_SLIDER,slider);

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
     

  
  FreeVec(t);
return 1;
}