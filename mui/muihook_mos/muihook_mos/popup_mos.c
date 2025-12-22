/***************************************************************************
 * 
 *  Morphos-GCC port of Popup.c from MUI 3.8 devkit
 *
 * => Shows how to use Hooks with GCC under MorphOS
 *
 *  (This may not be the better way to handle hooks under morphos but
 *   it works ;))
 *
 *  For an example of how to define macros for the creation of PPC Hooks, have a look
 *  at "SDI_hook.h" but do not directly use these macros as casting is missing
 *
 *  Note: I have left the parts that have changed with //68k: so that you can see
 *  ----  clearly where changes are needed
 *
 ***************************************************************************/

#include "demo.h"
#include "SDI_hook.h" // Registers and Structures definitions (from YAM CVS)


//68k: SAVEDS ASM LONG StrObjFunc(Object *pop __asm("a2"),Object *str __asm("a1"))
static LONG StrObjFunc(void)         
{ 
	// Get the paramters from the registers (REG_Ax are mapped to PPC registers: see include file <emul/emulregs.h>)
	Object *pop = (Object *)REG_A2; 
	Object *str = (Object *)REG_A1;
	// End MorphOS stuff


    // Your function starts here
    char *x,*s;
    int i;

    get(str,MUIA_String_Contents,&s);

    for (i=0;;i++)
    {
		DoMethod(pop,MUIM_List_GetEntry,i,&x);
		if (!x)
		{
			set(pop,MUIA_List_Active,MUIV_List_Active_Off);
			break;
		}
		else if (!stricmp(x,s))
		{
			set(pop,MUIA_List_Active,i);
			break;
		}
	}
    return(TRUE);
 } 
 
 // Here we define the Gate 
 static const struct SDI_EmulLibEntry Gate_StrObjFunc = 
 {
    SDI_TRAP_LIB, 
    0, 
    (void(*)()) StrObjFunc
 };                               

 // The hook that will be used in MUI
 struct Hook StrObjHook = 
 {
	 {NULL, NULL}, 
	 (HOOKFUNC)&Gate_StrObjFunc,    
      NULL, NULL
 };



//68k: SAVEDS ASM VOID ObjStrFunc(Object *pop __asm("a2"),Object *str __asm("a1"))
static void ObjStrFunc(void)         
{
        Object *pop = (Object *)REG_A2; 
    	Object *str = (Object *)REG_A1;
	   

		char *x;
        DoMethod(pop,MUIM_List_GetEntry,MUIV_List_GetEntry_Active,&x);
        set(str,MUIA_String_Contents,x);
}

 // Here we define the Gate 
 static const struct SDI_EmulLibEntry Gate_ObjStrFunc = 
 {
    SDI_TRAP_LIB, 
    0, 
    (void(*)()) ObjStrFunc
 };                               

 // The hook that will be used in MUI
 struct Hook ObjStrHook = 
 {
	 {NULL, NULL}, 
	 (HOOKFUNC)&Gate_ObjStrFunc,    
      NULL, NULL
 };


//68k: SAVEDS ASM VOID WindowFunc(Object *pop __asm("a2"),Object *win __asm("a1"))
static void WindowFunc(void)         
{
   	Object *pop = (Object *)REG_A2; 
	Object *win = (Object *)REG_A1;
	// End MorphOS stuff
		
	set(win,MUIA_Window_DefaultObject,pop);
}

 // Here we define the Gate 
 static const struct SDI_EmulLibEntry Gate_WindowFunc = 
 {
    SDI_TRAP_LIB, 
    0, 
    (void(*)()) WindowFunc
 };                               

 // The hook that will be used in MUI
 struct Hook WindowHook = 
 {
	 {NULL, NULL}, 
	 (HOOKFUNC)&Gate_WindowFunc,    
      NULL, NULL
 };


static const char *PopNames[] =
{
        "Stefan Becker",
        "Dirk Federlein",
        "Georg Heﬂmann",
        "Martin Horneffer",
        "Martin Huttenloher",
        "Kai Iske",
        "Oliver Kilian",
        "Franke Mariak",
        "Klaus Melchior",
        "Armin Sander",
        "Matthias Scheler",
        "Andreas Schildbach",
        "Wolfgang Schildbach",
        "Christian Scholz",
        "Stefan Sommerfeld",
        "Markus Stipp",
        "Henri Veistera",
        "Albert Weinert",
        "Michael-W. Hohmann", 
        "Stefan Burstroem",
        NULL
};


int main(int argc,char *argv[])
{
        // PPC MorphOS Hooks structures are defined below 

		//68k: static const struct Hook StrObjHook = { { NULL,NULL },(VOID *)StrObjFunc,NULL,NULL };
        //68k: static const struct Hook ObjStrHook = { { NULL,NULL },(VOID *)ObjStrFunc,NULL,NULL };
        //68k: static const struct Hook WindowHook = { { NULL,NULL },(VOID *)WindowFunc,NULL,NULL };
       
		APTR app,window,pop1,pop2,pop3,pop4,pop5,plist;
        ULONG signals;
        BOOL running = TRUE;

        init();

        app = ApplicationObject,
                MUIA_Application_Title      , "Popup-Demo",
                MUIA_Application_Version    , "$VER: Popup-Demo 19.5 (12.02.97)",
                MUIA_Application_Copyright  , "©1993, Stefan Stuntz",
                MUIA_Application_Author     , "Stefan Stuntz",
                MUIA_Application_Description, "Demostrate popup objects.",
                MUIA_Application_Base       , "POPUP",

                SubWindow, window = WindowObject,
                        MUIA_Window_Title, "Popup Objects",
                        MUIA_Window_ID   , MAKE_ID('P','O','P','P'),
                        WindowContents, VGroup,

                                Child, ColGroup(2),

                                        Child, KeyLabel2("File:",'f'),
                                        Child, pop1 = PopaslObject,
                                                MUIA_Popstring_String, KeyString(0,256,'f'),
                                                MUIA_Popstring_Button, PopButton(MUII_PopFile),
                                                ASLFR_TitleText, "Please select a file...",
                                                End,

                                        Child, KeyLabel2("Drawer:",'d'),
                                        Child, pop2 = PopaslObject,
                                                MUIA_Popstring_String, KeyString(0,256,'d'),
                                                MUIA_Popstring_Button, PopButton(MUII_PopDrawer),
                                                ASLFR_TitleText  , "Please select a drawer...",
                                                ASLFR_DrawersOnly, TRUE,
                                                End,

                                        Child, KeyLabel2("Font:",'o'),
                                        Child, pop3 = PopaslObject,
                                                MUIA_Popstring_String, KeyString(0,80,'o'),
                                                MUIA_Popstring_Button, PopButton(MUII_PopUp),
                                                MUIA_Popasl_Type , ASL_FontRequest,
                                                ASLFO_TitleText  , "Please select a font...",
                                                End,

                                        Child, KeyLabel2("Fixed Font:",'i'),
                                        Child, pop4 = PopaslObject,
                                                MUIA_Popstring_String, KeyString(0,80,'i'),
                                                MUIA_Popstring_Button, PopButton(MUII_PopUp),
                                                MUIA_Popasl_Type , ASL_FontRequest,
                                                ASLFO_TitleText  , "Please select a fixed font...",
                                                ASLFO_FixedWidthOnly, TRUE,
                                                End,

                                        Child, KeyLabel2("Thanks To:",'n'),
                                        Child, pop5 = PopobjectObject,
                                                MUIA_Popstring_String, KeyString(0,60,'n'),
                                                MUIA_Popstring_Button, PopButton(MUII_PopUp),
                                                MUIA_Popobject_StrObjHook, &StrObjHook,
                                                MUIA_Popobject_ObjStrHook, &ObjStrHook,
                                                MUIA_Popobject_WindowHook, &WindowHook,
                                                MUIA_Popobject_Object, plist = ListviewObject,
                                                        MUIA_Listview_List, ListObject,
                                                                InputListFrame,
                                                                MUIA_List_SourceArray, PopNames,
                                                                End,
                                                        End,
                                                End,
                                        End,
                                End,
                        End,
                End;

        if (!app)
                fail(app,"Failed to create Application.");

        DoMethod(window,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
                app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

        DoMethod(window,MUIM_Window_SetCycleChain,pop1,pop2,pop3,pop4,pop5,NULL);

        /* A double click terminates the popping list with a successful return value. */
        DoMethod(plist,MUIM_Notify,MUIA_Listview_DoubleClick,TRUE,
                pop5,2,MUIM_Popstring_Close,TRUE);


/*
** Input loop...
*/

        set(window,MUIA_Window_Open,TRUE);

        while (running)
        {
                switch (DoMethod(app,MUIM_Application_Input,&signals))
                {
                        case MUIV_Application_ReturnID_Quit:
                        {
                LONG active;

                                get(pop1,MUIA_Popasl_Active,&active);
                                if (!active) get(pop2,MUIA_Popasl_Active,&active);
                                if (!active) get(pop3,MUIA_Popasl_Active,&active);
                                if (!active) get(pop4,MUIA_Popasl_Active,&active);

                                if (active)
                                        MUI_Request(app,window,0,NULL,"OK","Cannot quit now, still\nsome asl popups opened.");
                                else
                                        running = FALSE;
                        }
                        break;
                }

                if (running && signals) Wait(signals);
        }

        set(window,MUIA_Window_Open,FALSE);

/*
** Shut down...
*/

        fail(app,NULL);
}