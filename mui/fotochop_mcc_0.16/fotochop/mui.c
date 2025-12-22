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
#include "fotochop_mcc/fotochop_mcc.h"
#include "printer_mcc/printer_mcc.h"

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
	{ NM_ITEM ,  "Fotochop..."                   ,"ß",0 ,0             ,(APTR)ID_F1  },
	


  

	{ NM_END,NULL,0,0,0,(APTR)0 },
};



static char *ps_cyc[] = { "2","3",NULL };
static char *pdf_cyc[] = { "1.4","1.5",NULL };


















int CreateGui(struct Args *temp)
{
ULONG sigs = 0;
Object *bottom,*right;	
Object **ed = (Object**)AllocVec(sizeof(Object*) * 10,MEMF_ANY | MEMF_CLEAR);	
int err;
struct zip *za;


	    app = ApplicationObject,
		MUIA_Application_Title  , "Fotochop Viewer",
		MUIA_Application_Version , "$VER: 1.0 (22.09.17) Reggea Viewer 2017 Carsten Siegner",
		MUIA_Application_Copyright , "©2017, Carsten Siegner",
		MUIA_Application_Author  , "Carsten Siegner",
		MUIA_Application_Description,"Demo",
		
		
		SubWindow, window = WindowObject,
			MUIA_Window_Title, "Fotochop Viewer",
			MUIA_Window_Menustrip, strip = MUI_MakeObject(MUIO_MenustripNM,MenuData1,MUIO_MenustripNM_CommandKeyCheck),
			

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
			 
			 
		
					  
				
				  
				  
				  
				Child, GroupObject,  
			
			    Child, xx = ScrollgroupObject,MUIA_Scrollgroup_UseWinBorder,TRUE,MUIA_Scrollgroup_Contents,vg = VirtgroupObject,MUIA_Virtgroup_Input,TRUE,

                 
				 
				  Child, ed[0] = Fotochopbject,MUIA_FOTOCHOP_ID,0,MUIA_FOTOCHOP_WIDTH,1000,MUIA_FOTOCHOP_HEIGHT,1000,MUIA_FOTOCHOP_FONT_PATH,"SYS:Fonts/_ttf",End,
				
				  
			 
			    End,End,
				
				
				
				End,
				
				Child, printer = PrinterObject,MUIA_ShowMe,FALSE,End,
			   
				
              End,
              End,
            
            
      End,
	  
	  SubWindow, window2 = AboutboxObject,
	            MUIA_Window_ID,"InstantUnpack02",
	         
	            End,

	  
	  SubWindow, window3 = WindowObject,
			MUIA_Window_Title, "Settings",
			
			MUIA_Window_ID ,"Demo2",
			MUIA_Window_SizeGadget,TRUE,
			
			 MUIA_Window_DragBar,TRUE,
			 MUIA_Window_DepthGadget,TRUE,
			 MUIA_Window_CloseGadget,TRUE,
         
			 WindowContents, VGroup,
			 
			 Child, GroupObject,MUIA_Group_Columns,2,

	  
	  
			             Child, Label("Device"),
						 Child, p_device = StringObject,MUIA_ObjectID,1,MUIA_FixWidthTxt,"wwwwwwwwwww",MUIA_String_Contents,"parallel.device",MUIA_Frame,MUIV_Frame_String,MUIA_Background,MUII_StringBack,End,
                         Child, Label("Unit"),
						 Child, p_unit = StringObject,MUIA_ObjectID,2,MUIA_String_Contents,"0",MUIA_Frame,MUIV_Frame_String,MUIA_Background,MUII_StringBack,End,
                         Child, Label("PS level"),
						 Child, ps = CycleObject,MUIA_ObjectID,3,MUIA_Cycle_Entries,ps_cyc,End,
                         Child, Label("PDF level"),
						 Child, pdf = CycleObject,MUIA_ObjectID,4,MUIA_Cycle_Entries,pdf_cyc,End,

	  
	  
	          End,
			  
			  Child, HGroup,MUIA_Background, MUII_GroupBack,MUIA_Frame,MUIV_Frame_Group,
	          Child, save = SimpleButton("Save"),
			  Child, use = SimpleButton("Use"),
			  Child, chanel = SimpleButton("Chanel"),
	  
	          End,
	  End,
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

	DoMethod(use,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_Save,MUIV_Application_Save_ENV);
    DoMethod(save,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_Save,MUIV_Application_Save_ENVARC);
    DoMethod(use,MUIM_Notify,MUIA_Pressed,FALSE,window3,3,MUIM_Set,MUIA_Window_Open,FALSE);
    DoMethod(save,MUIM_Notify,MUIA_Pressed,FALSE,window3,3,MUIM_Set,MUIA_Window_Open,FALSE);
    DoMethod(chanel,MUIM_Notify,MUIA_Pressed,FALSE,window3,3,MUIM_Set,MUIA_Window_Open,FALSE);

	
	
	
	
	
	DoMethod(window,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
	
	
    DoMethod(app,MUIM_Application_Load,MUIV_Application_Load_ENV );

 	  
	/*-----------------------------------*/
	
	
	 set(printer,MUIA_PRINTER_ED,ed);
	 set(printer,MUIA_PRINTER_DEVICE,p_device);
	 set(printer,MUIA_PRINTER_UNIT,p_unit);
	 set(printer,MUIA_PRINTER_PS_LEVEL,ps);
	 set(printer,MUIA_PRINTER_PDF_LEVEL,pdf);

	 set(ed[0],MUIA_FOTOCHOP_PRINTER,printer);

	 set(window,MUIA_Window_Open,TRUE);
	
	 set(ed[0],MUIA_FOTOCHOP_SLIDER,xx);
	 
	 
	 
	 
	 
	
	
	

	
	
	
	
	
	
	
	
    
    

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
     

  FreeVec(ed);

return 1;
}