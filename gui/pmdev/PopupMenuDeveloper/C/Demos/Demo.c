//
// $VER: Demo.c 2.2 (05.09.98)
//
// Popup Menu example program
//
// ©1996-1997 Henrik Isaksson
// All Rights Reserved.
//
// Run and click the mouse in the window and over the dragbar!
// (two different menus)
//

#include <intuition/intuition.h>

#include <proto/intuition.h>
#include <proto/exec.h>

#include <clib/alib_protos.h>

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include <libraries/pm.h>
#include <proto/pm.h>

struct IntuitionBase	*IntuitionBase;
struct GfxBase		*GfxBase;
struct PopupMenuBase	*PopupMenuBase;

struct Window *w;	// This window is only needed to find out when and where the menu should appear.

ULONG __saveds __asm MenuHandlerFunc(register __a0 struct Hook *hook,
				     register __a2 APTR object,
				     register __a1 APTR msg)
{
	struct PopupMenu *pm=(struct PopupMenu *)object;
	char bfr[128];

	if(pm->UserData) {
		sprintf(bfr, "RUN <>NIL: %s", pm->UserData);
		system(bfr);
	}

	if(pm->ID==5) *((BOOL *)hook->h_Data)=FALSE;	// ID 5 means quit
}

void main()
{
	BOOL r=TRUE;
	struct IntuiMessage *im,imsg;
	struct PopupMenu *p1,*p2;
	struct Hook MenuHandler;

	MenuHandler.h_Entry=(HOOKFUNC)MenuHandlerFunc;
	MenuHandler.h_Data=&r;

	PopupMenuBase=(struct PopupMenuBase *)OpenLibrary(POPUPMENU_NAME,POPUPMENU_VERSION);			// Open the library
	if(PopupMenuBase) {
		IntuitionBase=(struct IntuitionBase *)PopupMenuBase->pmb_IntuitionBase;	// We let popupmenu.library open the libraries we need
		GfxBase=(struct GfxBase *)PopupMenuBase->pmb_GfxBase;			// They remain valid until the library is closed!

		p1=PMMenu("Run Demos"),
			PMItem("Disable"), PMSimpleSub,
				PMInfo("This demo shows how to read the"),	End,
				PMInfo("state of a checkmark, and"),		End,
				PMInfo("how to disable & enable an item"),	End,
				PMInfo("and its submenu."),			End,
				PMBar,	End,
				PMItem("Run the demo!"),	PM_UserData,	"Disable",	End,
				End,
			End,
			PMItem("PullDownMenu"), PMSimpleSub,
				PMInfo("The PullDownMenu demo shows how"),	End,
				PMInfo("you can use the popupmenu.library"),	End,
				PMInfo("for pulldown menus!"),			End,
				PMBar,	End,
				PMItem("Run the demo!"),	PM_UserData,	"PullDownMenu",	End,
				End,
			End,
			PMItem("MenuVerify"), PMSimpleSub,
				PMInfo("This example uses the"),		End,
				PMInfo("IDCMP_MENUVERIFY flag to"),		End,
				PMInfo("combine standard intuition"),		End,
				PMInfo("menus with popupmenus int"),		End,
				PMInfo("the same window!"),			End,
				PMBar,	End,
				PMItem("Run the demo!"),	PM_UserData,	"MenuVerify",	End,
				End,
			End,
			PMItem("StartMenu"), PMSimpleSub,
				PMInfo("This demo shows how to put"),		End,
				PMInfo("images in you menus."),			End,
				PMInfo("You can find the menu at the"),		End,
				PMInfo("bottom of the screen."),		End,
				PMBar,	End,
				PMItem("Run the demo!"),	PM_UserData,	"StartMenu",	End,
				End,
			End,
			PMItem("Palette"), PMSimpleSub,
				PMInfo("Popup menus can be used to"),		End,
				PMInfo("choose colours from too..."),		End,
				PMBar, End,
				PMItem("Colours"), PMSimpleSub,
					PMCheckItem("Background", 1),	PM_ColourBox,	0,	End,
					PMCheckItem("Shadow", 1),	PM_ColourBox,	1,	End,
					PMCheckItem("Shine", 1),	PM_ColourBox,	2,	End,
					PMCheckItem("Fill", 1),	PM_ColourBox,	3,	End,
					PMCheckItem("Halfshadow", 1),	PM_ColourBox,	4,	End,
					PMCheckItem("Halfshine", 1),	PM_ColourBox,	5,	End,
					PMBar, End,
					PMItem("Use colour 1"), PM_ColourBox, 9,  End,
					PMItem("Use colour 2"), PM_ColourBox, 10, End,
					PMItem("Use colour 3"), PM_ColourBox, 11, End,
					End,
				End,
				End,
			End,
		End;

		p2=PMMenu("PopupMenu Demo"),
			PMItem("About..."),				End,
			PMTitleBar,					End,
			PMItem("Quit"),		PM_ID,		5,	End,
		End;

		if(p1 && p2) {
			w=OpenWindowTags(NULL,	WA_IDCMP,	IDCMP_CLOSEWINDOW|IDCMP_MOUSEBUTTONS,	// Open a little window
					WA_RMBTrap,	TRUE,
					WA_DragBar,	TRUE,
					WA_Left,	150,
					WA_Top,		100,
					WA_Width,	150,
					WA_Height,	100,
					WA_SizeGadget,	TRUE,
					WA_DepthGadget,	TRUE,
					WA_MinWidth,	150,
					WA_MaxWidth,	1280,
					WA_MinHeight,	100,
					WA_MaxHeight,	1024,
					WA_Title,	"Popup Menu Demo",
					WA_CloseGadget,	TRUE,
					TAG_DONE);
			if(w) {

				while(r) {
					WaitPort(w->UserPort);						// Wait for a message
					while((im=(struct IntuiMessage *)GetMsg(w->UserPort))) {	// Get the message
						CopyMem(im,&imsg,sizeof(struct IntuiMessage));		// Copy the contents of it
						ReplyMsg((struct Message *)im);				// Reply the message

						switch(imsg.Class) {
							case IDCMP_CLOSEWINDOW: r=FALSE; break;
							case IDCMP_MOUSEBUTTONS:			// The user has hit a mousebutton - time to open the menu!
								if(imsg.Code==MENUDOWN || imsg.Code==MENUUP) {
									if(w->MouseY>w->BorderTop) {
										PM_OpenPopupMenu(w,
											PM_Menu,		p1,
											PM_Code,		imsg.Code,
											PM_MenuHandler,		&MenuHandler,
											TAG_DONE);
									} else {
										PM_OpenPopupMenu(w,
											PM_Menu,		p2,
											PM_Code,		imsg.Code,
											PM_MenuHandler,		&MenuHandler,
											TAG_DONE);
									}
								}
							break;
						}
					}
				}
				CloseWindow(w);
			} else printf("Window error!\n");
		} else printf("Menu error!\n");
		if(p1) PM_FreePopupMenu(p1);
		if(p2) PM_FreePopupMenu(p2);
		CloseLibrary((struct Library *)PopupMenuBase);
	}
}
