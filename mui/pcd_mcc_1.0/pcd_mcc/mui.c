/*---Erzeugen der MUI-Oberfläche---*/

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

#include "pcd_mcc.h"

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



	    app = ApplicationObject,
		MUIA_Application_Title  , "PCD_Test",
		MUIA_Application_Version , "$VER: 1.0 (06.09.18) PCD Test 2018 Carsten Siegner",
		MUIA_Application_Copyright , "©2018, Carsten Siegner",
		MUIA_Application_Author  , "Carsten Siegner",
		MUIA_Application_Description,"PCD Test",
		
		
		SubWindow, window = WindowObject,
			MUIA_Window_Title, "PCD Test",
			MUIA_Window_Menustrip, strip = MUI_MakeObject(MUIO_MenustripNM,MenuData1,MUIO_MenustripNM_CommandKeyCheck),
			

			MUIA_Window_ID ,"PCD_Test1",
			MUIA_Window_SizeGadget,TRUE,
			MUIA_Window_AppWindow, TRUE,
			 MUIA_Window_DragBar,TRUE,
			 MUIA_Window_DepthGadget,TRUE,
			 MUIA_Window_CloseGadget,TRUE,
            MUIA_Window_UseBottomBorderScroller,TRUE,
			MUIA_Window_UseRightBorderScroller,TRUE,
			 WindowContents, VGroup,
			 Child, VGroup, MUIA_Background, MUII_GroupBack,MUIA_Frame,MUIV_Frame_Group,
			 
			 
		
					  
				
				  
				  
				  
				Child, GroupObject,  
			
			    Child, xx = ScrollgroupObject,MUIA_Scrollgroup_UseWinBorder,TRUE,MUIA_Scrollgroup_Contents,vg = VirtgroupObject,MUIA_Virtgroup_Input,TRUE,

                 
				 
			
				 Child, PcdObject,MUIA_PCD_SIZE_NR,2,MUIA_PCD_PATH,temp->in,MUIA_PCD_WIDTH,100,MUIA_PCD_HEIGHT,100,End,
                
			 
			    End,End,
				
				
				
				End,
				
				
              End,
              End,
            
            
      End,
	  
	  SubWindow, window2 = AboutboxObject,
	            MUIA_Window_ID,"PCD_Test2",
	         
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

	
	
	
	
	
	
	DoMethod(window,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
	
	
   
 	  
	/*-----------------------------------*/
	
	
	

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