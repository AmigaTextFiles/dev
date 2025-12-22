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

#include "rtf_mcc.h"

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
char path[200]="";
int err;
char *title,*subject,*author;

  strcpy(path,temp->in);

	    app = ApplicationObject,
		MUIA_Application_Title  , "RTF_Test",
		MUIA_Application_Version , "$VER: 1.0 (06.09.18) RTF Test 2018 Carsten Siegner",
		MUIA_Application_Copyright , "©2018, Carsten Siegner",
		MUIA_Application_Author  , "Carsten Siegner",
		MUIA_Application_Description,"RTF Test",
		
		
		SubWindow, window = WindowObject,
			MUIA_Window_Title, "RTF Test",
			MUIA_Window_Menustrip, strip = MUI_MakeObject(MUIO_MenustripNM,MenuData1,MUIO_MenustripNM_CommandKeyCheck),
			

			MUIA_Window_ID ,"RTF_Test1",
			MUIA_Window_SizeGadget,TRUE,
			MUIA_Window_AppWindow, TRUE,
			 MUIA_Window_DragBar,TRUE,
			 MUIA_Window_DepthGadget,TRUE,
			 MUIA_Window_CloseGadget,TRUE,
            MUIA_Window_UseBottomBorderScroller,TRUE,
			MUIA_Window_UseRightBorderScroller,TRUE,
			 WindowContents, VGroup,
			 Child, VGroup, MUIA_Background, MUII_GroupBack,MUIA_Frame,MUIV_Frame_Group,
			 
			     Child, GroupObject, MUIA_Group_Columns,2,MUIA_Background, MUII_GroupBack,MUIA_Frame,MUIV_Frame_Group,
			     Child , Label("Title"),
				 Child, t1 = TextObject,MUIA_Background, MUII_TextBack ,MUIA_Frame,MUIV_Frame_Text,End,
		         Child , Label("Subject"),
				 Child, t2 = TextObject,MUIA_Background, MUII_TextBack ,MUIA_Frame,MUIV_Frame_Text,End,
		         Child , Label("Author"),
				 Child, t3 = TextObject,MUIA_Background, MUII_TextBack ,MUIA_Frame,MUIV_Frame_Text,End,
		
					  
				
				 End,
				  
				  
				Child, GroupObject,  
			
			    Child, xx = ScrollgroupObject,MUIA_Prop_Entries,100,MUIA_Scrollgroup_UseWinBorder,TRUE,MUIA_Scrollgroup_Contents,vg = VirtgroupObject,MUIA_Virtgroup_Input,TRUE,
                Child, zip2 = RectangleObject,MUIA_FixWidth,595,MUIA_FixHeight,850,End,
                 
				 
			
                
			 
			    End,End,
				
				Child, HGroup,
				         Child, Label("Tile"),
						 Child, PopaslObject, ASLFR_TitleText, "Open tile...",ASLFR_InitialDrawer,"ram:",
                         MUIA_Popstring_Button, PopButton(MUII_PopFile),
                     	 MUIA_Popstring_String,dpath = StringObject,MUIA_Frame,MUIV_Frame_String,MUIA_Background,MUII_StringBack,End,
                         End,
				End,
				End,
				
				
              End,
              End,
            
            
      End,
	  
	  SubWindow, window2 = AboutboxObject,
	            MUIA_Window_ID,"RTF_Test2",
	         
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
	
	 
	 
	 
	 
	 
	
	
	

	   if(DoMethod(vg,MUIM_Group_InitChange))
	  {  
	
	    zip1 = RtfObject,MUIA_RTF_PATH,path,MUIA_RTF_WIDTH,595,MUIA_RTF_HEIGHT,858,End;

	     DoMethod(vg,OM_ADDMEMBER,zip1);
         set(zip2,MUIA_ShowMe,FALSE);		  
	
	   DoMethod(vg,MUIM_Group_ExitChange);
	  }
	
	   get(zip1,MUIA_RTF_TITLE,&title);
       set(t1,MUIA_Text_Contents,title);
  
       get(zip1,MUIA_RTF_SUBJECT,&subject);
       set(t2,MUIA_Text_Contents,subject);
  
       get(zip1,MUIA_RTF_AUTHOR,&author);
       set(t3,MUIA_Text_Contents,author);
	
    
    

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