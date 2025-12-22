/*
 *
 * $VER: Dynamic.c 1.1 (05.09.98)
 *
 * Popup Menu example program
 *
 * ©1996-1998 Henrik Isaksson
 * All Rights Reserved.
 *
 */

#include <intuition/intuition.h>
#include <exec/memory.h>

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

BOOL was_called=FALSE;	// Just used to find out if the destructor is called.

struct PopupMenu * __saveds __asm SubConstructFunc(register __a0 struct Hook *hook,
				     register __a2 struct PopupMenu *selected, register __a1 APTR *handle)
{
	struct PopupMenu *newpm, *itm;
	char bfr[128];
	int i;
	BOOL stop=FALSE;

	// Don't try to open windows, requesters or print text from this
	// hook, wich is called while the menu is still open.
	// The display might be locked!

	newpm=PM_MakeMenu(
		itm=PMItem("(loading...)"),		PM_ID,	300,	PM_Disabled, TRUE, PMEnd,
	PMEnd;		

	if(newpm) {
		if(selected->Sub) {
			// We don't have to worry about freeing the new menu,
			// as it will be freed automatically. But we do have
			// to take care of the old menu, since the library
			// won't know it exists.
			PM_FreePopupMenu(selected->Sub);
		}
		selected->Sub=newpm;

		PM_AbortHook(*handle);
		Delay(50);

		PM_RemoveMenuItem(newpm, itm);

		//
		// We can also add items to a previously created menu
		//
		PM_InsertMenuItem(newpm,
			PM_Insert_Last, TRUE,
			PM_Insert_Item,	PM_MakeItem(PM_Title, "These items have been added", TAG_DONE),
			PM_Insert_Item,	PM_MakeItem(PM_Title, "to the end of the menu!", TAG_DONE),
			PM_Insert_Item,	PM_MakeItem(PM_Title, "---------------- This item will be removed... ----------------", PM_ID, 100, TAG_DONE),
			TAG_DONE);

		//
		// Insert before an item
		// The menu must have a 'header' (an invisible item at
		// the top) for this to work reliably.
		//
		PM_InsertMenuItem(newpm,
			PM_Insert_BeforeID, 100,
			PM_Insert_Item,	PM_MakeItem(PM_Title, "This item has been inserted.", TAG_DONE),
			TAG_DONE);

		//
		// Insert after an item
		//
		PM_InsertMenuItem(newpm,
			PM_Insert_AfterID,	100,
			PM_Insert_Item,	PM_MakeItem(PM_Title, ",,^..^,,", TAG_DONE),
			TAG_DONE);


		PM_AbortHook(*handle);	// update the menu and give the user a chance to see it...
		Delay(50);

		//
		// Let's remove that long item
		//
		PM_RemoveMenuItem(newpm, PM_FindItem(newpm, 100));


		//
		// Add a few more items, and check if the user wants to abort
		//
		for(i=0;i<10;i++) {
			Delay(10);
			PM_InsertMenuItem(newpm,
				PM_Insert_Last,	TRUE,
				PM_Insert_Item,	PM_MakeItem(PM_Title, "new item", TAG_DONE),
				TAG_DONE);
			if(stop=PM_AbortHook(*handle)) break;
		}
	}

	if(!stop)
		return selected->Sub;	// If you return NULL, no menu will be opened.
	else
		return NULL;
}

void __saveds __asm SubDestructFunc(register __a0 struct Hook *hook,
				     register __a2 struct PopupMenu *parent)
{
	// Don't try to open windows, requesters or print text from this
	// hook, wich is called while the menu is still open.
	// The display might be locked, and input definitely is.

	//
	// Here you can do something with your item's userdata...
	//
	//	parent->Sub->UserData=0;
	//
	// ...or free the submenu, if you want to. Otherwise it will be free'd
	// when you free the rest of the menu. If you decide to free the menu,
	// remember to set parent->Sub to NULL.
	// (maybe it's a very large menu, and you want to return the used mem)
	//
	//	PM_FreePopupMenu(parent->Sub);
	//	parent->Sub=NULL;
	//

	was_called=TRUE;	// Only to find out if this works...
}

struct Hook SubConstruct;
struct Hook SubDestruct;

struct PopupMenu *MakeTestMenu(void);

void main()
{
	struct IntuiMessage *im,imsg;
	struct PopupMenu *p;
	BOOL r=TRUE;

	SubConstruct.h_Entry=(HOOKFUNC)SubConstructFunc;
	SubConstruct.h_Data=NULL;	// User Data - you can put anything you like to here.

	SubDestruct.h_Entry=(HOOKFUNC)SubDestructFunc;
	SubDestruct.h_Data=NULL;	// User Data - you can put anything you like to here.

	PopupMenuBase=(struct PopupMenuBase *)OpenLibrary(POPUPMENU_NAME,POPUPMENU_VERSION);			// Open the library
	if(PopupMenuBase) {
		IntuitionBase=(struct IntuitionBase *)PopupMenuBase->pmb_IntuitionBase;	// We let popupmenu.library open the libraries we need
		GfxBase=(struct GfxBase *)PopupMenuBase->pmb_GfxBase;			// They remain valid until the library is closed!

		p=MakeTestMenu(); // Declared at the end of this file.

		if(p) {
			w=OpenWindowTags(NULL,	WA_IDCMP,	IDCMP_CLOSEWINDOW|IDCMP_MOUSEBUTTONS|IDCMP_VANILLAKEY,	// Open a little window
					WA_RMBTrap,	TRUE,
					WA_DragBar,	TRUE,
					WA_Width,	150,
					WA_Height,	100,
					WA_Left,	0,
					WA_Top,		100,
					WA_Title,	"Dynamic Menus",
					WA_CloseGadget,	TRUE,
					TAG_DONE);
			if(w) {
				while(r) {
					WaitPort(w->UserPort);						// Wait for a message
					while((im=(struct IntuiMessage *)GetMsg(w->UserPort))) {	// Get the message
						CopyMem(im,&imsg,sizeof(struct IntuiMessage));		// Copy the contents of it
						ReplyMsg((struct Message *)im);				// Reply the message

						if(imsg.Class==IDCMP_MOUSEBUTTONS) {
							PM_OpenPopupMenu(w,
								PM_Menu,		p,
								TAG_DONE);
						}
						if(imsg.Class==IDCMP_CLOSEWINDOW) r=FALSE;		// See if the user wants to quit
					}
				}
				printf("The destructor hook was %scalled!\n", was_called?"":"NOT ");
				CloseWindow(w);
			} else printf("Window error!\n");
			PM_FreePopupMenu(p);
		} else printf("Menu error!\n");
		CloseLibrary((struct Library *)PopupMenuBase);
	}
}

struct PopupMenu *MakeTestMenu()
{
	struct PopupMenu *p;

	p=PM_MakeMenu(
		PMItem("Dynamic SubMenu"),
			PM_SubConstruct,	&SubConstruct,
			PM_SubDestruct,		&SubDestruct,
			PMSimpleSub,
				PMInfo("This won't work unless"),	End,	// this will be shown if the demo doesn't work
				PMInfo("you get version 7.50!"),	End,	// (maybe an old version of the library)
			End,
		End,
		PMBar,	End,
		PMItem("Quit"), End,
	End;

	return p;
}