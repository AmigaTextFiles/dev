/*
** The Settings Demo shows how to load and save object contents.
*/

#include "demo.h"

#define ID_CANCEL 1
#define ID_SAVE   2
#define ID_USE    3

int main(int argc,char *argv[])
{
	APTR app,window,str1,str2,str3,str4,sl1,cy1,btsave,btuse,btcancel;
	ULONG signals;
	BOOL running = TRUE;
	char *sex[] = { "male", "female", NULL };

	init();

	app = ApplicationObject,
		MUIA_Application_Title      , "Settings",
		MUIA_Application_Version    , "$VER: Settings 7.37 (10.02.94)",
		MUIA_Application_Copyright  , "©1992/93, Stefan Stuntz",
		MUIA_Application_Author     , "Stefan Stuntz",
		MUIA_Application_Description, "Show saving and loading of settings",
		MUIA_Application_Base       , "SETTINGS",

		SubWindow, window = WindowObject,
			MUIA_Window_Title, "Save/use me and start me again!",
			MUIA_Window_ID   , MAKE_ID('S','E','T','T'),

			WindowContents, VGroup,

				Child, ColGroup(2), GroupFrameT("User Identification"),
					Child, Label2("Name:"),
					Child, str1 = StringObject, StringFrame, MUIA_ExportID, 1, End,
					Child, Label2("Street:"),
					Child, str2 = StringObject, StringFrame, MUIA_ExportID, 2, End,
					Child, Label2("City:"),
					Child, str3 = StringObject, StringFrame, MUIA_ExportID, 3, End,
					Child, Label1("Password:"),
					Child, str4 = StringObject, StringFrame, MUIA_ExportID, 4, MUIA_String_Secret, TRUE, End,
					Child, Label1("Sex:"),
					Child, cy1  = CycleObject, MUIA_Cycle_Entries, sex, MUIA_ExportID, 6, End,
					Child, Label("Age:"),
					Child, sl1  = SliderObject, MUIA_ExportID, 5, MUIA_Slider_Min, 9, MUIA_Slider_Max, 99, End,
					End,

				Child, VSpace(2),

				Child, HGroup, MUIA_Group_SameSize, TRUE,
					Child, btsave   = KeyButton("Save",'s'),
					Child, HSpace(0),
					Child, btuse    = KeyButton("Use",'u'),
					Child, HSpace(0),
					Child, btcancel = KeyButton("Cancel",'>'),
					End,

				End,
			End,
		End;

	if (!app)
		fail(app,"Failed to create Application.");


/*
** Install notification events...
*/

	DoMethod(window,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
		app,2,MUIM_Application_ReturnID,ID_CANCEL);

	DoMethod(btcancel,MUIM_Notify,MUIA_Pressed,FALSE,
		app,2,MUIM_Application_ReturnID,ID_CANCEL);

	DoMethod(btsave,MUIM_Notify,MUIA_Pressed,FALSE,
		app,2,MUIM_Application_ReturnID,ID_SAVE);

	DoMethod(btuse,MUIM_Notify,MUIA_Pressed,FALSE,
		app,2,MUIM_Application_ReturnID,ID_USE);


/*
** Cycle chain for keyboard control
*/

	DoMethod(window,MUIM_Window_SetCycleChain,
		str1,str2,str3,str4,cy1,sl1,btsave,btuse,btcancel,NULL);


/*
** Concatenate strings, <return> will activate the next one
*/

	DoMethod(str1,MUIM_Notify,MUIA_String_Acknowledge,MUIV_EveryTime,
		window,3,MUIM_Set,MUIA_Window_ActiveObject,str2);

	DoMethod(str2,MUIM_Notify,MUIA_String_Acknowledge,MUIV_EveryTime,
		window,3,MUIM_Set,MUIA_Window_ActiveObject,str3);

	DoMethod(str3,MUIM_Notify,MUIA_String_Acknowledge,MUIV_EveryTime,
		window,3,MUIM_Set,MUIA_Window_ActiveObject,str4);

	DoMethod(str4,MUIM_Notify,MUIA_String_Acknowledge,MUIV_EveryTime,
		window,3,MUIM_Set,MUIA_Window_ActiveObject,btuse);


/*
** The application is set up, now load
** a previously saved configuration from env:
*/

	DoMethod(app,MUIM_Application_Load,MUIV_Application_Load_ENV);



/*
** Input loop...
*/

	set(window,MUIA_Window_Open,TRUE);
	set(window,MUIA_Window_ActiveObject,str1);

	while (running)
	{
		switch (DoMethod(app,MUIM_Application_Input,&signals))
		{
			case MUIV_Application_ReturnID_Quit:
			case ID_CANCEL:
				running = FALSE;
				break;

			case ID_SAVE:
				DoMethod(app,MUIM_Application_Save,MUIV_Application_Save_ENVARC);
				/* fall through */

			case ID_USE:
				DoMethod(app,MUIM_Application_Save,MUIV_Application_Save_ENV);
				running = FALSE;
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
