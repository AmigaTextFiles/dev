//
// $VER: BigMenu.c 1.6 (05.09.98)
//
// Popup Menu library test program
//
// ©1996-1997 Henrik Isaksson
// All Rights Reserved.
//
// Run and click the mouse in the window!
// This little hack is intended to test the submenus.
//
// WARNING! When the menu runs out of stack, it will end in a crash!
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

struct Window *w;	// This window is only needed to find out when and where the menu should appear and wich screen it's on.

void main()
{
	BOOL r=TRUE;
	struct IntuiMessage *im,imsg;
	struct PopupMenu *p;
	struct PopupMenu *subs[20], *prev=0L;
	int i;

	PopupMenuBase=(struct PopupMenuBase *)OpenLibrary(POPUPMENU_NAME,POPUPMENU_VERSION);			// Open the library
	if(PopupMenuBase) {
		IntuitionBase=(struct IntuitionBase *)PopupMenuBase->pmb_IntuitionBase;	// We let popupmenu.library open the libraries we need
		GfxBase=(struct GfxBase *)PopupMenuBase->pmb_GfxBase;			// They remain valid until the library is closed!

		prev=PM_MakeMenu(
			PMInfo("Congratulations!!"), End,
			PMInfo("You've shown a great"), End,
			PMInfo("deal of patience"), End,
			PMInfo("working your way"), End,
			PMInfo("through all theese"), End,
			PMInfo("menus!"), End,
			PMInfo("You will now be"), End,
			PMInfo("rewarded with a"), End,
			PMInfo("menu option that"), End,
			PMInfo("lets you stop"), End,
			PMInfo("browsing through"), End,
			PMInfo("the menus..."), End,
			PMBar, End,
			PMItem("Quit"), PM_UserData, 5, End,
		End;

		for(i=0;i<20;i++) {
			char bfr[50];

			sprintf(bfr, "SubMenu #%ld", 20-i);

			prev=PM_MakeMenu(
				PMInfo(bfr), End,
				PMItem("Next Submenu"), PM_Sub, prev, End,
			End;
		}

		p=PMMenu("Big Menu"),	// Create a big menu...
			PMInfo("Welcome to the neverending"), End,
			PMInfo("submenu example."), End,
			PMBar, End,
			PMItem("Submenu"), PM_Sub, prev, End,
			PMBar,	End,
			PMItem("Quit"),	PM_UserData,	5,	End,
			End;

		if(p) {

			w=OpenWindowTags(NULL,	WA_IDCMP,	IDCMP_CLOSEWINDOW|IDCMP_MOUSEBUTTONS,	// Open a little window
					WA_RMBTrap,	TRUE,
					WA_DragBar,	TRUE,
					WA_Width,	150,
					WA_Height,	100,
					WA_Left,	150,
					WA_Top,		0,
					WA_Title,	"BigMenu",
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
								r=(BOOL)((ULONG)(PM_OpenPopupMenu(w,
										PM_Menu,		p,
										PM_Code,		imsg.Code,	// Must always be there!
										TAG_DONE))-5);
							break;
						}
					}
				}
				CloseWindow(w);
			} else printf("Window error!\n");

			PM_FreePopupMenu(p);

		} else printf("Menu error!\n");
		CloseLibrary((struct Library *)PopupMenuBase);
	}
}
