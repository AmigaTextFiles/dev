//
// $VER: Disable.c 2.0 (05.09.98)
//
// Popup Menu example program
//
// ©1996-1997 Henrik Isaksson
// All Rights Reserved.
//
// Run and click the mouse in the window!
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
			// The font in this window's rastport will be used for the menu.

void main()
{
	BOOL r=TRUE;
	struct IntuiMessage *im,imsg;
	struct PopupMenu *p;

	PopupMenuBase=(struct PopupMenuBase *)OpenLibrary(POPUPMENU_NAME,POPUPMENU_VERSION);			// Open the library
	if(PopupMenuBase) {
		IntuitionBase=(struct IntuitionBase *)PopupMenuBase->pmb_IntuitionBase;	// We let popupmenu.library open the libraries we need
		GfxBase=(struct GfxBase *)PopupMenuBase->pmb_GfxBase;			// They remain valid until the library is closed!

		p=PMMenu("Plain Simple Menu!"),	// Create a very simple menu...

			PMCheckItem("Enable quit?",10),								PMEnd,

			PMTitleBar,										PMEnd,

			PMItem("Quit"),		PM_Sub,
				PM_MakeMenu(
					PMItem("Quit"),		PM_Disabled,	TRUE,	PM_UserData,	5,	PM_ID,	15,	PMEnd,
				PMEnd, /* MakeMenu */

			PMEnd, /* PMItem */

		End; /* PMMenu */

		if(p) {
			w=OpenWindowTags(NULL,	WA_IDCMP,	IDCMP_CLOSEWINDOW|IDCMP_MOUSEBUTTONS,	// Open a little window
					WA_RMBTrap,	TRUE,
					WA_DragBar,	TRUE,
					WA_Width,	150,
					WA_Height,	100,
					WA_Left,	0,
					WA_Top,		0,
					WA_Title,	"Disable & Enable",
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
										PM_Code,		imsg.Code,
										TAG_DONE))-5);
										
								if(PM_ItemChecked(p,10)) {	// See if "Enable quit?" is checked
									// Find the item and enable it
									PM_SetItemAttrs(PM_FindItem(p, 15), PM_Disabled, FALSE, TAG_DONE);
								} else {
									// Find the item and disable it
									PM_SetItemAttrs(PM_FindItem(p, 15), PM_Disabled, TRUE, TAG_DONE);
								}
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
