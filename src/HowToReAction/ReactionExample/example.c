/*
** This is a simple example about how to write applications using
** ReAction and GUIs build with ReActor.
*/

#define NO_INLINE_STDARG
#include "example_gui.h"
#include <dos/dos.h>
#include <classes/window.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/locale.h>
#include <proto/resource.h>
#include <proto/gadtools.h>
#include <clib/alib_protos.h>
#include <stdio.h>


struct Screen  *glbScreen;
struct MsgPort *glbAppPort;
struct Catalog *glbCatalog;
RESOURCEFILE   *glbResource;
struct Window  *glbWindow;
struct Gadget **glbGadgets;
Object *glbWinobj;

APTR glbVisualInfo;
struct Menu *glbMenu;

enum { MENU_IGNORE_ID, MENU_ABOUT_ID, MENU_QUIT_ID };


/**********************************************************************/

void sleep(void)
{
	if(glbWinobj)
		SetAttrs(glbWinobj, WA_BusyPointer,TRUE, TAG_DONE);
}


void wakeup(void)
{
	if(glbWinobj)
		SetAttrs(glbWinobj, WA_BusyPointer,FALSE, TAG_DONE);
}

/**********************************************************************/

void vreport(const char *fstr, APTR args)
{
	struct EasyStruct req =
	{
		sizeof(struct EasyStruct),
		0,
		"HowToReAction",
		(char*)fstr,
		"Ok"
	};
	EasyRequestArgs(glbWindow, &req, NULL, args);
}


void report(const char *fstr, ...)
{
	vreport(fstr, (&fstr) + 1);
	/*            ^^^^^^^^^^^
	**This solution only works on Amiga 68k and PPC. */
}

/**********************************************************************/

int openGUI(void)
{
	/* Get a pointer to the default public screen. */
	glbScreen = LockPubScreen(NULL);
	if(!glbScreen)
	{
		fputs("Failed to lock default public screen.\n", stderr);
		return FALSE;
	}

	/* We need an application message port for iconification. */
	glbAppPort = CreateMsgPort();
	if(!glbAppPort)
	{
		fputs("Failed to create message port.\n", stderr);
		return FALSE;
	}

	/* Open the catalog if existing. */
	glbCatalog = OpenCatalogA(NULL, "example.catalog", NULL);
	/* Open the RCTResource which is linked to our executable. */
	glbResource = RL_OpenResource(RCTResource, glbScreen, glbCatalog);
	if(!glbResource)
	{
		fputs("Failed to create GUI resource.\n", stderr);
		return FALSE;
	}

	/* To use the menu layout functions of gadtools, we have to obtain
	** some information about the screen. */
	glbVisualInfo = GetVisualInfoA(glbScreen, NULL);
	if(glbVisualInfo)
	{
		struct NewMenu newmenus[] = {
			{ NM_TITLE, "Project", NULL, 0, 0, NULL },
			{ NM_ITEM,  "About",   "?",  0, 0, (APTR)MENU_ABOUT_ID },
			{ NM_ITEM,  "Quit",    "Q",  0, 0, (APTR)MENU_QUIT_ID  },
			{ NM_END }
		};
		glbMenu = CreateMenus(newmenus, GTMN_FullMenu,TRUE, TAG_DONE);
		if(glbMenu)
		{
			LayoutMenus(glbMenu, glbVisualInfo,
				GTMN_NewLookMenus, TRUE,
				TAG_DONE);
		}
	}

	/* Create the window. */
	glbWinobj = RL_NewObject(glbResource, WIN_MAIN_ID,
		WINDOW_AppPort, glbAppPort,
		WINDOW_MenuStrip, glbMenu,
		WA_PubScreen, glbScreen,
		TAG_DONE);
	if(!glbWinobj)
	{
		fputs("Failed to create window object.\n", stderr);
		return FALSE;
	}

	/* Obtain the array of gadgets of our window. From now on you can
	** access the gadgets through glbGadgets[GAD_ID]. */
	glbGadgets = (struct Gadget**) RL_GetObjectArray(glbResource, glbWinobj, GROUP_MAIN_ID);
	if(!glbGadgets)
	{
		fputs("Could not obtain gadget array.\n", stderr);
		return FALSE;
	}

	/* Open the window (make it visible). */
	glbWindow = (struct Window*) DoMethod(glbWinobj, WM_OPEN);
	if(!glbWindow)
	{
		fputs("Failed to open window.\n", stderr);
		return FALSE;
	}

	/* Now everything is setup correctly. */
	return TRUE;
}


void closeGUI(void)
{
	/* Close the window if open. */
	if(glbWindow)
	{
		DoMethod(glbWinobj, WM_CLOSE);
		glbWindow = NULL;
	}
	/* Free all created objects. */
	RL_CloseResource(glbResource);
	glbGadgets = NULL;
	glbWinobj = NULL;
	glbResource = NULL;
	/* Destroy the menu. */
	FreeMenus(glbMenu);
	FreeVisualInfo(glbVisualInfo);
	glbMenu = NULL;
	glbVisualInfo = NULL;
	/* Close the catalog. */
	CloseCatalog(glbCatalog);
	glbCatalog = NULL;
	/* Destroy the application message port. */
	DeleteMsgPort(glbAppPort);
	glbAppPort = NULL;
	/* Unlock the default public screen. */
	UnlockPubScreen(NULL, glbScreen);
	glbScreen = NULL;
}


void loopGUI(void)
{
	BOOL running = TRUE;
	ULONG winsig = 1 << glbWindow->UserPort->mp_SigBit;
	ULONG appsig = 1 << glbAppPort->mp_SigBit;
	ULONG sigs, result;
	UWORD code;
	struct MenuItem *msel;

	while(running)
	{
		sigs = Wait(SIGBREAKF_CTRL_C | winsig | appsig);
		/* Handle CTRL-C. */
		if(sigs & SIGBREAKF_CTRL_C)
		{
			running = FALSE;
		}
		/* Handle messages for our window and the application port. */
		if((sigs & winsig) || (sigs & appsig))
		{
			/* Process all pending messages.
			** Both ports are handled by this method WM_HANDLEINPUT.
			** The winobj knows of our app-Port, because we provided it in RL_NewObject(). */
			while((result = DoMethod(glbWinobj, WM_HANDLEINPUT, &code)) != WMHI_LASTMSG)
			{
				switch(result & WMHI_CLASSMASK)
				{
					case WMHI_CLOSEWINDOW:
						running = FALSE;
						break;

					case WMHI_GADGETUP:
						switch(result & RL_GADGETMASK)
						{
							case GAD_CANCEL_ID:
								running = FALSE;
								break;
							/* ... other gadgets can be handled here ... */
						}
						break;

					case WMHI_MENUPICK:
						msel = ItemAddress(glbMenu, result & WMHI_MENUMASK);
						if(msel)
						{
							switch((ULONG)GTMENUITEM_USERDATA(msel))
							{
								case MENU_ABOUT_ID:
									sleep();
									report("HowToReAction 1.1\nAuthor: m.poellmann@haage-partner.com");
									wakeup();
									break;

								case MENU_QUIT_ID:
									running = FALSE;
									break;
							}
						}
						break;

					case WMHI_ICONIFY:
						DoMethod(glbWinobj, WM_ICONIFY);
						glbWindow = NULL;
						winsig = 0;
						break;

					case WMHI_UNICONIFY:
						glbWindow = (struct Window*) DoMethod(glbWinobj, WM_OPEN);
						if(!glbWindow)
						{
							fputs("Failed to reopen window.\n", stderr);
							running = FALSE;
						}
						else
						{
							winsig = 1 << glbWindow->UserPort->mp_SigBit;
						}
						break;
				}
			}
		}
	}
}


int main(void)
{
	if(openGUI())
		loopGUI();
	closeGUI();
	return 0;
}

