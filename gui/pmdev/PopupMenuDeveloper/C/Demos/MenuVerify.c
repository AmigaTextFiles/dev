//
// $VER: MenuVerify.c 1.2 (07.01.00)
//
// Popup Menu example program
//
// ©1996-1997 Henrik Isaksson
// All Rights Reserved.
//
// Run and click the mouse in the window!
//

//
// Note! Read the RKRMs for information about how to use MenuVerify
// correctly. I have done it the easy way.
//

#include <intuition/intuition.h>

#include <proto/intuition.h>
#include <proto/gadtools.h>
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
struct Window		*w;
struct Menu		*Intui_Menu=NULL;
APTR VisualInfo=NULL;

struct NewMenu MyNewMenu[]=
{
	NM_TITLE, "Project", NULL, NULL, NULL, NULL,
	NM_ITEM, "Load", "L", NULL, NULL, NULL,
	NM_ITEM, "Save", "S", NULL, NULL, NULL,
	NM_ITEM, NM_BARLABEL, NULL, NULL, NULL, NULL,
	NM_ITEM, "Quit", "Q", NULL, NULL, NULL,
	NM_END, NULL, NULL, NULL, NULL, NULL
};

BOOL CreateIntuiMenu(void)
{
	if(!(VisualInfo=GetVisualInfo(w->WScreen,TAG_DONE))) return FALSE;
	if(!(Intui_Menu=CreateMenus(MyNewMenu, GTMN_FrontPen, 0, TAG_DONE))) return FALSE;
	LayoutMenus(Intui_Menu, VisualInfo, TAG_DONE);

	return TRUE;
}

void FreeIntuiMenu(void)
{
	if(VisualInfo) FreeVisualInfo(VisualInfo);
	if(Intui_Menu) FreeMenus(Intui_Menu);
}

void main()
{
	BOOL r=TRUE, menu=FALSE;
	struct IntuiMessage *im,imsg;
	struct PopupMenu *p;

	PopupMenuBase=(struct PopupMenuBase *)OpenLibrary(POPUPMENU_NAME,POPUPMENU_VERSION);			// Open the library
	if(PopupMenuBase) {
		IntuitionBase=(struct IntuitionBase *)PopupMenuBase->pmb_IntuitionBase;	// We let popupmenu.library open the libraries we need
		GfxBase=(struct GfxBase *)PopupMenuBase->pmb_GfxBase;			// They remain valid until the library is closed!

		p=PMMenu("Inside the window!"),
			PMItem("This example shows"),	PM_NoSelect,	TRUE,	PMEnd,
			PMItem("how to use popup"),	PM_NoSelect,	TRUE,	PMEnd,
			PMItem("menus and intuition"),	PM_NoSelect,	TRUE,	PMEnd,
			PMItem("menus in the same"),	PM_NoSelect,	TRUE,	PMEnd,
			PMItem("window!"),		PM_NoSelect,	TRUE,	PMEnd,
			PMTitleBar,	PMEnd,
			PMItem("Quit"),	PM_UserData,	5,	PMEnd,
			End;

		if(p) {
			w=OpenWindowTags(NULL,	WA_IDCMP,	IDCMP_CLOSEWINDOW|IDCMP_MOUSEBUTTONS|IDCMP_MENUVERIFY|IDCMP_MENUPICK,
					WA_DragBar,	TRUE,
					WA_Width,	150,
					WA_Height,	100,
					WA_Left,	150,
					WA_Top,		0,
					WA_Title,	"MenuVerify Demo",
					WA_CloseGadget,	TRUE,
					TAG_DONE);
			if(w) {
				if(CreateIntuiMenu()) {
					SetMenuStrip(w, Intui_Menu);

					while(r) {
						WaitPort(w->UserPort);						// Wait for a message
						while((im=(struct IntuiMessage *)GetMsg(w->UserPort))) {	// Get the message
							CopyMem(im,&imsg,sizeof(struct IntuiMessage));		// Copy the contents of it

							if(im->Class==IDCMP_MENUVERIFY) {			// Check if the user wants to see the menu
								if(im->MouseY>0 && im->MouseY<w->Height &&
								   im->MouseX>0 && im->MouseX<w->Width  &&	// Check if the mouse is in our window
								   im->Code==MENUHOT) {				// Read the RKRMs
							   
								   im->Code=MENUCANCEL;				// Cancel the intuition menu
							   
								   imsg.Class=IDCMP_MOUSEBUTTONS;		// Make sure the menu gets opened...
								   imsg.Code=MENUDOWN;				// (we fake a IDCMP_MOUSEBUTTONS message)
								}
							}

							ReplyMsg((struct Message *)im);				// Reply the message

							switch(imsg.Class) {
								case IDCMP_CLOSEWINDOW: r=FALSE; break;
								case IDCMP_MOUSEBUTTONS:			// The user has hit a mousebutton - time to open the menu!
									if(imsg.Code==MENUUP ||
									   imsg.Code==MENUDOWN)	{		// Open only if the right (that is the right button, in this case :) ) button was hit
										r=(BOOL)((ULONG)(PM_OpenPopupMenu(w,
												PM_Menu,		p,
												PM_Code,		imsg.Code,	// This will ensure that the user can change
												TAG_DONE))-5);				// the time of apperance for the menu.
									}
								break;
							}
						}
					}
					ClearMenuStrip(w);
				} else printf("Can't create intuition menus!\n");
				FreeIntuiMenu();
				CloseWindow(w);
			} else printf("Window error!\n");
			PM_FreePopupMenu(p);
		} else printf("Menu error!\n");
		CloseLibrary((struct Library *)PopupMenuBase);
	}
}
