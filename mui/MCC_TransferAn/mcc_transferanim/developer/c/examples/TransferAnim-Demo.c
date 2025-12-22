/***************************************************************************/
/**                                                                       **/
/**     TransferAnim-Demo, an example program for TransferAnim.mcc        **/
/**                                                                       **/
/**                                                                       **/
/**     Feel free to use the source and please notify me about errors,    **/
/**     bugs, good and bad things.                                        **/
/**                                                                       **/
/**     by Linus McCabe, sparkle@hehe.com                                 **/
/**                      http://sparkle.amiga.tm                          **/
/**                                                                       **/
/***************************************************************************/

#define progname "TAnimExample"
#define progbase "TANIME"
#define vsion "V1.1 (15-May-99)"

#define aboutanim "mui:images/TransferAnim/aboutanim"
#define aboutbutton "mui:images/TransferAnim/about"
#define playbutton "mui:images/TransferAnim/play"
#define stopbutton "mui:images/TransferAnim/stop"
#define checkmark "mui:images/TransferAnim/checkmark"
#define mainanim "mui:images/TransferAnim/mainanim"

/* System */
#include <dos/dos.h>
#include <workbench/workbench.h>
#include <exec/memory.h>
#include <libraries/mui.h>
#include <datatypes/datatypes.h>
#include <datatypes/pictureclass.h>
#include <datatypes/PictureClassExt.h>
#include <graphics/gfxmacros.h>
#include <devices/timer.h>
#include <libraries/asl.h>
#include <mui/TransferAnim_mcc.h>

/* Prototypes */

#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/icon_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/utility_protos.h>
#include <clib/asl_protos.h>
#include <clib/muimaster_protos.h>
#include <clib/datatypes_protos.h>
#include <clib/rexxsyslib_protos.h>

/* ANSI C */
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#ifdef __SASC
#include <pragmas/exec_sysbase_pragmas.h>
#else
#include <pragmas/exec_pragmas.h>
#endif
#include <pragmas/dos_pragmas.h>
#include <pragmas/icon_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/utility_pragmas.h>
#include <pragmas/asl_pragmas.h>
#include <pragmas/muimaster_pragmas.h>
#include <pragmas/rexxsyslib_pragmas.h>

extern struct Library *SysBase, *IconBase, *IntuitionBase, *GfxBase, *UtilityBase, *DOSBase; 
extern struct Library * MUIMasterBase, *RexxSysBase, *AslBase;

__saveds __asm VOID aboutmui(register __a0 struct Hook *hook ,	register __a2 Object *appl ,	register __a1 APTR *args );
__saveds __asm VOID about(register __a0 struct Hook *hook ,	register __a2 Object *appl ,	register __a1 APTR *args );
__saveds __asm VOID closeabout(register __a0 struct Hook *hook ,	register __a2 Object *appl ,	register __a1 APTR *args );


struct Library * MUIMasterBase;

  /*************************/
 /* Menues                */
/*************************/

enum { MenQuit=1, MenAbout, MenAboutMUI, MenMUIPrefs};

static const struct NewMenu MenuData1[] =
{
{ NM_TITLE, progname                   , 0 ,0 ,0             ,(APTR)0 },
{ NM_ITEM ,  "About"                   ,"?",0 ,0             ,(APTR)MenAbout },
{ NM_ITEM ,  "About MUI"               , 0 ,0 ,0             ,(APTR)MenAboutMUI },
{ NM_ITEM ,  NM_BARLABEL               , 0 ,0 ,0             ,(APTR)0 },
{ NM_ITEM ,  "Quit"                    ,"Q",0 ,0             ,(APTR)MenQuit },

{ NM_TITLE, "Settings"                 , 0 ,0 ,0             ,(APTR)0 },
{ NM_ITEM ,  "Mui..."                  , 0 ,0 ,0             ,(APTR)MenMUIPrefs },

{ NM_END,NULL,0,0,0,(APTR)0 }
};


/**** Hooks ***/

const struct Hook aboutmuiHook = {
   {NULL,NULL},
   (void *)aboutmui,
   NULL,NULL
};

const struct Hook aboutHook = {
   {NULL,NULL},
   (void *)about,
   NULL,NULL
};

const struct Hook closeAboutHook = 
{
	{NULL,NULL},
	(void *)closeabout,
	NULL,NULL
};




/*** Main code ***/

int main(int argc,char ** argv)
{
	
	/** A few variables. ctrlwin = main window, app = application object
		menustrip = the programs menue, titlewin = the 'open while loading' window.
		about button is the programs only gadget. */
	
	Object * ctrlwin, *app, *menustrip, *TitleWin;
	Object *AboutButton;
	Object *play, *stop, *noloop, *mainanimobj, *prop;
	
	/* Open muimaster library */
	
  	if (!(MUIMasterBase = OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN)))
	{
		printf("Unable to open muimaster.library\n");
		return(5);
	}
	
	/* Create apploication object */
	/* I chose to make this a small thing with only a simple window with a text.
		This way I can open the window quickly to confirm that the program is started.
		Especially when the 'real' main windows contains alot of datatypes and other
		'slow' stuff this makes sence. And especially on slow machines. */
		
	app=ApplicationObject,
		MUIA_Application_Title	, progname,
		MUIA_Application_Version    , "$VER: "progname" "vsion,
		MUIA_Application_Copyright  , "©1998, Linus McCabe.",
		MUIA_Application_Author     , "Linus McCabe",
		MUIA_Application_Description, "TransferAnim.mcc example.", 
		MUIA_Application_Base       , progbase,
		MUIA_Application_Menustrip	 , menustrip=MUI_MakeObject(MUIO_MenustripNM,MenuData1,0),
	
		SubWindow,TitleWin=WindowObject,
			MUIA_Window_SizeGadget,FALSE,
			MUIA_Window_DragBar,FALSE,
			MUIA_Window_CloseGadget,FALSE,
			MUIA_Window_DepthGadget,FALSE,

			MUIA_Window_Activate,FALSE,

			WindowContents,
				VGroup,
					Child,TextObject,
						MUIA_Text_Contents,"TransferAnim.mcc, \nMUI Customclass by Linus McCabe",
					End,
				End,
			End,
		End;
		
		if(app)	/* If the application could be opened */
		{
			
			/* Open the title window */
			set(TitleWin, MUIA_Window_Open, TRUE);	
			
			/* Create main window */
			ctrlwin=WindowObject,
				MUIA_Window_Title,progname" "vsion" by Linus McCabe",
				MUIA_Window_ID   , MAKE_ID('M','A','I','N'),
				
				WindowContents,
					VGroup,
						MUIA_Background,"2:00000000,00000000,00000000",
						Child,HGroup,
							Child, mainanimobj=TransferAnimObject,
								MUIA_TransferAnim_File, mainanim,
								MUIA_InputMode,MUIV_InputMode_RelVerify,
							End,
							Child, TextObject,
								MUIA_Text_SetMax,TRUE,
								MUIA_Text_Contents,"\338"progname" "vsion"\nby Linus McCabe",
							End,
							Child, AboutButton=TransferAnimObject,
											MUIA_TransferAnim_File,(ULONG) aboutbutton,
											MUIA_TransferAnim_NoAnim,TRUE,
											MUIA_InputMode,MUIV_InputMode_RelVerify,
											MUIA_TransferAnim_SelectedFrame,1,
											MUIA_TransferAnim_DisabledFrame,2,
							End,
						End,
						Child, HGroup,
							Child, play=TransferAnimObject,
											MUIA_TransferAnim_File,(ULONG) playbutton,
											MUIA_InputMode,MUIV_InputMode_RelVerify,
											MUIA_TransferAnim_NoAnim,TRUE,
							End,
							Child, stop=TransferAnimObject,
											MUIA_TransferAnim_File,(ULONG) stopbutton,
											MUIA_InputMode,MUIV_InputMode_RelVerify,
											MUIA_TransferAnim_NoAnim,TRUE,
							End,
							Child, noloop=TransferAnimObject,
											MUIA_TransferAnim_File,(ULONG) checkmark,
											MUIA_InputMode,MUIV_InputMode_Toggle,
											MUIA_TransferAnim_NoAnim,TRUE,
							End,
							Child, prop=SliderObject,
								MUIA_Group_Horiz, TRUE,
							End,
							
						End,
					End,
				End;
	
			if (ctrlwin)	/*If the creation was successful */
			{
				
				ULONG tmp;
				
				/* add to application */
				DoMethod(app, OM_ADDMEMBER, ctrlwin);	
	

			/*Main methods*/

			
				/* set up some basic notifiactions, closegadget, menues etc*/
				DoMethod(ctrlwin,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
				DoMethod(app,MUIM_Notify,MUIA_Application_MenuAction,MenQuit,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
				DoMethod(app,MUIM_Notify,MUIA_Application_MenuAction,MenAbout,app,4,MUIM_CallHook,&aboutHook,menustrip,AboutButton);
				DoMethod(app,MUIM_Notify,MUIA_Application_MenuAction,MenAboutMUI,app,4,MUIM_CallHook,&aboutmuiHook,ctrlwin,menustrip);
				DoMethod(app,MUIM_Notify,MUIA_Application_MenuAction,MenMUIPrefs,app,2,MUIM_Application_OpenConfigWindow,0);

				DoMethod(AboutButton,MUIM_Notify,MUIA_Pressed,FALSE,app,4,MUIM_CallHook,&aboutHook,menustrip,AboutButton);

				DoMethod(play, MUIM_Notify, MUIA_Pressed, FALSE, mainanimobj, 1, MUIM_TransferAnim_StartAnim);
				DoMethod(stop, MUIM_Notify, MUIA_Pressed, FALSE, mainanimobj, 1, MUIM_TransferAnim_StopAnim);
				DoMethod(noloop, MUIM_Notify, MUIA_Selected, MUIV_EveryTime, mainanimobj, 3, MUIM_Set, MUIA_TransferAnim_NoLoop, MUIV_TriggerValue);

				DoMethod(mainanimobj, MUIM_Notify, MUIA_TransferAnim_Frame, MUIV_EveryTime, prop, 3, MUIM_Set, MUIA_Slider_Level, MUIV_TriggerValue);
				DoMethod(prop, MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime, mainanimobj, 3, MUIM_Set, MUIA_TransferAnim_Frame, MUIV_TriggerValue);
				
				/* CLose the title win and open main window instead.
				On this little example, the title window only flashes if I
				do this, so I'll just let it remain open for now... */
				
//				set(TitleWin,MUIA_Window_Open,FALSE);   
				set(ctrlwin,MUIA_Window_Open,TRUE);

				get(mainanimobj, MUIA_TransferAnim_Frames, &tmp);
				set(prop, MUIA_Slider_Max, tmp);

				/* The usual wait for exit loop */
				{
				   ULONG sigs = 0;
	
				   while (DoMethod(app,MUIM_Application_NewInput,&sigs)	
			          !=MUIV_Application_ReturnID_Quit)
				   {
				      if (sigs)
				      {
				         sigs = Wait(sigs | SIGBREAKF_CTRL_C);	
				         if (sigs & SIGBREAKF_CTRL_C) break;		
				      }
				   }
				}

				/* dispose the application and delete the customclass */
				MUI_DisposeObject(app); 
			}
		}
	CloseLibrary(MUIMasterBase);
	return(0);
}


/** Hooks code **/

__saveds __asm VOID aboutmui(
	register __a0 struct Hook *hook ,
	register __a2 Object *appl ,
	register __a1 APTR *args )
{

	APTR aboutwinMUI,menu;


	/* create the mui about object */
	
	aboutwinMUI = AboutmuiObject,
		MUIA_Window_RefWindow, args[0],
		MUIA_Aboutmui_Application, appl,
		End;
	
	
	/*open if success */
		
	if (aboutwinMUI)
		set(aboutwinMUI,MUIA_Window_Open,TRUE);
	else
		DisplayBeep(0);
		
	/* disable the menu entry */	
		
	menu=(APTR) DoMethod(args[1],MUIM_FindUData,MenAboutMUI);
	set(menu,MUIA_Menuitem_Enabled,FALSE);

	/* enable it again when the window is closed */
	
	DoMethod(aboutwinMUI,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,menu,3,MUIM_Set,MUIA_Menuitem_Enabled,TRUE);

}

/* open and display our own aboutwindow */

__saveds __asm VOID about(
	register __a0 struct Hook *hook ,
	register __a2 Object *appl ,
	register __a1 APTR *args)
{
	Object *portobj, *aboutwin,*menu; 
	char string[155],*strp;
	
	/* create the object */
	
	aboutwin=WindowObject,
		MUIA_Window_Title, "About",
		MUIA_Window_ID   , MAKE_ID('B','O','U','T'),

		WindowContents,
			VGroup,MUIA_Background,"2:00000000,00000000,00000000",
				Child, HGroup,
					Child, TransferAnimObject, 
						MUIA_TransferAnim_File, aboutanim,
					End,
					Child,HVSpace,
						Child, TextObject,
							MUIA_Text_Contents,"\338"progname" "vsion"\nby Linus McCabe",
						End,
					Child,HVSpace,
					Child, TransferAnimObject, 
						MUIA_TransferAnim_File, mainanim,
						MUIA_TransferAnim_ViewMode, MUIV_TransferAnim_Scale,
						MUIA_TransferAnim_ObjWidth, 50,
						MUIA_TransferAnim_ObjHeight, 50,
					End,
				End,
				Child,ScrollgroupObject,
					MUIA_Background,MUII_TextBack,
					MUIA_Scrollgroup_FreeHoriz,FALSE,
					MUIA_Scrollgroup_Contents,VirtgroupObject,
						VirtualFrame,
						Child,TextObject,
							MUIA_Text_Contents, "\n\33c\33b"progname"\n"vsion"\n",
						End,
						Child,TextObject,
							MUIA_Text_Contents, "\n\nMain coding by Linus McCabe\nCopyright © 1999 by Linus McCabe\n",
						End,
						Child,portobj=TextObject,
							MUIA_Text_Contents, "Arexx Port: Zensiba",	
						End,
						Child,BalanceObject,
						End,
						Child,TextObject,
							MUIA_Text_Contents, 
							"\n This is a small programming example in mui\n"\
							"to use TransferAnim.mcc, a mui customclass for display\n"\
							"of transferanimations.\n\n"\
							"\nThanx to\n\n"\
							"  Jessica, for bringing light to my life\n"\
							"  Ai, for being a good friend\n"\
							"  Märta, for being kind and helpful\n"\
							"  The folks at MUI mailinglist"\
							"\n\n"\
							"Greetings to\n\n"\
							"  TJOMME, Snipey, redpirk, MrXZY, _44\n"\
							"  GAZ, MazzleBoy, HighScore, RawHeadRex\n"\
							"  ChaoZer, MiLD, Tipop, AngelFire, UMBRO\n"\
							"  HarryO, Raven-X & Duff."\
							"\n\33l\n"\
							"Contact me at\n"\
							"Sparkle@hehe.com\n"\
							"www.come.to/sparkle\n"\
							"sparkle.amiga.tm\n\n"\
							"\33iThe program is released 'as is',\n"\
							"i e programmer or distributor takes no responsibility\n"\
							"to any loss of data or other damages this program may\n"\
							"cause.\n\n\33n",
						End,
					End,
				End,
			End,
		End;
		
	if(aboutwin)
	{			
		/* add the window to the application */
		DoMethod(appl,OM_ADDMEMBER,aboutwin);
		
		/* call hook when closegadget is pressed */
		DoMethod(aboutwin,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,appl,5,MUIM_CallHook,&closeAboutHook,aboutwin,args[0],args[1]);

		/*get the arexx port */
		get(appl,MUIA_Application_Base,&strp);
		sprintf(&string[0],"\33cArexx Port: \33b%s\n",strp);
		set(portobj,MUIA_Text_Contents,string);

		/* diable menu entry and gadget */
		menu=(APTR) DoMethod(args[0],MUIM_FindUData,MenAbout);
		set(menu,MUIA_Menuitem_Enabled,FALSE);
		set(args[1],MUIA_Disabled,TRUE);

		/* open the window */
		set(aboutwin,MUIA_Window_Open,TRUE);
		
	}

}


/* hook to close the about window */

__saveds __asm VOID closeabout(
	register __a0 struct Hook *hook ,
	register __a2 Object *appl ,
	register __a1 APTR *args)
{

	APTR menu;
	

	/* close the window */
	set(args[0],MUIA_Window_Open,FALSE);
	
	/* remove the object from the application */
	DoMethod(appl,OM_REMMEMBER,args[0]);

	/* dispose the object */
	DoMethod(appl,MUIM_Application_PushMethod,args[0], 1,OM_DISPOSE);

	/* enable the menu and gadget again*/
	menu=(APTR) DoMethod(args[1],MUIM_FindUData,MenAbout);
	set(menu,MUIA_Menuitem_Enabled,TRUE);
	set(args[2],MUIA_Disabled,FALSE);
}



