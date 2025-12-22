//
// Open a window, and use the menus defined in the file "Ram:TestMenus.h"
//


#include <intuition/intuition.h>
#include <clib/intuition_protos.h>

#include <exec/exec.h>
#include <clib/exec_protos.h>

#include <clib/gadtools_protos.h>

#include <stdio.h>


#include "ram:TestMenus.h"



void open_window(void);
char handle_input(void);
void close_window(void);


struct Library *IntuitionBase,*GadToolsBase;
struct Screen *TestScreen;
struct Window *TestWindow;
struct Menu *MenuStrip;
unsigned long *VisInfo;



int main()
{
	IntuitionBase = OpenLibrary("intuition.library",36);
	if (IntuitionBase == NULL)
	{
		printf("Sorry, I need v36 in order to run.\n");
		return(0);
	}
	
	GadToolsBase = OpenLibrary("gadtools.library",36);
	if (GadToolsBase == NULL)
	{
		printf("Unable to open gadtools.library v36.\n");
		CloseLibrary(IntuitionBase);
		return(0);
	}


	/* Lock the workbench screen so we can get VisualInfo */
	TestScreen = LockPubScreen(NULL);

	/* Get VisualInfo from our screen */
	VisInfo = GetVisualInfo(TestScreen,TAG_END);

	open_window();



	/* Use the 'struct NewMenu mbld[]' menu structure from Ram:MenuTest.h */
	/* to define the menus for the window. */
	MenuStrip=CreateMenus(mbld,TAG_END);
	LayoutMenus(MenuStrip,VisInfo,TAG_END);
	SetMenuStrip(TestWindow,MenuStrip);

	/* Unlock the screen */
	UnlockPubScreen(NULL,TestScreen);


	/* Wait for user to close the window */
	handle_input();


	/* Clean up and exit */
	ClearMenuStrip(TestWindow);
	close_window();
	FreeMenus(MenuStrip);
	FreeVisualInfo(VisInfo);

	CloseLibrary(IntuitionBase);
	CloseLibrary(GadToolsBase);

	return(0);
}



void open_window()
{
	TestWindow=OpenWindowTags(0,
						WA_Left,100,
						WA_Top,50,
						WA_Width,440,
						WA_Height,100,
						WA_CloseGadget,TRUE,
						WA_SizeGadget,TRUE,
						WA_DragBar,TRUE,
						WA_DepthGadget,TRUE,
						WA_Activate,TRUE,
						WA_Title,"MenuBuilder example",
						WA_IDCMP,IDCMP_CLOSEWINDOW,
						TAG_DONE);
}


void close_window()
{
	CloseWindow(TestWindow);
}







char handle_input()
{
	struct IntuiMessage *message;
	unsigned long signals,class,code;
	int finished = FALSE;


	do
	{
		signals=Wait(1L<<TestWindow->UserPort->mp_SigBit);	/* wait for msg */

		message=GetMsg(TestWindow->UserPort);
		class=message->Class;
		code=message->Code;
		ReplyMsg((struct Message*)message);

		switch (class)
		{
			case IDCMP_CLOSEWINDOW:
				finished = TRUE;
				break;
			default:
				break;
		}
	}
	while (finished == FALSE);
}


