#include "demo.h"

static char *Sex[]     = { "male","female",NULL };
static char *Pages[]   = { "Race","Class","Armor","Level",NULL };
static char *Races[]   = { "Human","Elf","Dwarf","Hobbit","Gnome",NULL };
static char *Classes[] = { "Warrior","Rogue","Bard","Monk","Magician","Archmage",NULL };

int main(int argc,char *argv[])
{
	APTR app,window;
	ULONG signals;
	BOOL running = TRUE;

	init();

	app = ApplicationObject,
		MUIA_Application_Title      , "Pages-Demo",
		MUIA_Application_Version    , "$VER: Pages-Demo 7.45 (10.02.94)",
		MUIA_Application_Copyright  , "©1992/93, Stefan Stuntz",
		MUIA_Application_Author     , "Stefan Stuntz",
		MUIA_Application_Description, "Show MUIs Page Groups",
		MUIA_Application_Base       , "PAGESDEMO",

		SubWindow, window = WindowObject,
			MUIA_Window_Title, "Character Definition",
			MUIA_Window_ID   , MAKE_ID('P','A','G','E'),

			WindowContents, VGroup,

				Child, ColGroup(2),
					Child, Label2("Name:"), Child, String("Frodo",32),
					Child, Label1("Sex:" ), Child, Cycle(Sex),
					End,

				Child, VSpace(2),

				Child, RegisterGroup(Pages),
					MUIA_Register_Frame, TRUE,

					Child, HCenter(Radio(NULL,Races)),

					Child, HCenter(Radio(NULL,Classes)),

					Child, HGroup,
						Child, HSpace(0),
						Child, ColGroup(2),
							Child, Label1("Cloak:" ), Child, CheckMark(TRUE),
							Child, Label1("Shield:"), Child, CheckMark(TRUE),
							Child, Label1("Gloves:"), Child, CheckMark(TRUE),
							Child, Label1("Helmet:"), Child, CheckMark(TRUE),
							End,
						Child, HSpace(0),
						End,

					Child, ColGroup(2),
						Child, Label("Experience:"  ), Child, Slider(0,100, 3),
						Child, Label("Strength:"    ), Child, Slider(0,100,42),
						Child, Label("Dexterity:"   ), Child, Slider(0,100,24),
						Child, Label("Condition:"   ), Child, Slider(0,100,39),
						Child, Label("Intelligence:"), Child, Slider(0,100,74),
						End,

					End,
				End,
			End,
		End;

	if (!app)
		fail(app,"Failed to create Application.");

	DoMethod(window,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
		app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);


/*
** Input loop...
*/

	set(window,MUIA_Window_Open,TRUE);

	while (running)
	{
		switch (DoMethod(app,MUIM_Application_Input,&signals))
		{
			case MUIV_Application_ReturnID_Quit:
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
