//
// $VER: PullDownMenu.c 2.2 (20.07.00)
//
// Popup Menu example program
//
// ©1996-1997 Henrik Isaksson
//
// This code is public domain.
//
// Changes:
//
// 2.2	Added support for PM_Toggle
//

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

ULONG __saveds __asm MenuHandlerFunc(register __a0 struct Hook *hook,
				     register __a2 APTR object,
				     register __a1 APTR msg)
{
	struct PopupMenu *pm=(struct PopupMenu *)object;

	printf("---\n");
	printf("Title:	  \"%s\"\n", pm->Title);
	printf("UserData: %lx\n", pm->UserData);
	printf("ID:	  %lx\n", pm->ID);

	// This is one (the fastest) way of finding out if the item is checked or not:
	// 0x40000000 = CHECKIT
	// 0x80000000 = CHECKED
	if(pm->Flags&0x40000000)
		printf("Checked?  %s\n", pm->Flags&0x80000000?"Yes":"No");

	if((int)pm->UserData==5) *((BOOL *)hook->h_Data)=FALSE;
}

struct PopupMenu *MakeTestMenu(void);

void main()
{
	BOOL r=TRUE;
	struct IntuiMessage *im,imsg;
	struct PopupMenu *p;
	struct Hook MenuHandler;

	MenuHandler.h_Entry=(HOOKFUNC)MenuHandlerFunc;
	MenuHandler.h_Data=&r;

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
					WA_Title,	"PullDown Menus",
					WA_CloseGadget,	TRUE,
					TAG_DONE);
			if(w) {
				while(r) {
					WaitPort(w->UserPort);						// Wait for a message
					while((im=(struct IntuiMessage *)GetMsg(w->UserPort))) {	// Get the message
						CopyMem(im,&imsg,sizeof(struct IntuiMessage));		// Copy the contents of it
						ReplyMsg((struct Message *)im);				// Reply the message

						PM_FilterIMsg(w, p, &imsg,				// Send the message to pmlib
							PM_AutoPullDown,	TRUE,			// We want the menu to open automatically
							PM_MenuHandler,		&MenuHandler,		// Our menuhandler function
							TAG_DONE);

						if(imsg.Class==IDCMP_CLOSEWINDOW) r=FALSE;		// See if the user wants to quit
					}
				}
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
		PMItem("Workbench"),
			PMSimpleSub,
				PMCheckItem("Backdrop?", 1),		PM_CommKey,	"B",	End,
				PMItem("Execute Command..."),		PM_CommKey,	"E",	End,
				PMItem("Redraw All"),	End,
				PMItem("Update All"),	End,
				PMItem("Last Message"),	End,
				PMItem("About..."),	PM_CommKey,	"?",	End,
				PMItem("Quit"),		PM_UserData,	5,	PM_CommKey,	"Q",	End,
			End,
			PM_NoSelect,	FALSE,  // A little trick that will make the menu selectable...
		End,
		PMItem("Window"),
			PMSimpleSub,
				PMItem("New Drawer"),		PM_CommKey,	"N",	PM_Disabled,	TRUE,	End,
				PMItem("Open Parent"),					PM_Disabled,	TRUE,	End,
				PMItem("Close"),		PM_CommKey,	"K",	PM_Disabled,	TRUE,	End,
				PMItem("Update"),					PM_Disabled,	TRUE,	End,
				PMItem("Select Contents"),	PM_CommKey,	"A",				End,
				PMItem("Clean Up"),		PM_CommKey,	".",				End,
				PMItem("Snapshot"),
					PMSimpleSub,
						PMItem("Window"),	End,
						PMItem("All"),		End,
					End,
				End,
				PMItem("Show"),
					PMSimpleSub,
						PMCheckItem("Only Icons", 2),	PM_Toggle, FALSE,	PM_Exclude,	PM_ExLst(3, 0),	PM_Checked,	TRUE,	End,
						PMCheckItem("All Files", 3),	PM_Toggle, FALSE,	PM_Exclude,	PM_ExLst(2, 0),	End,
					End,
					PM_Disabled,	TRUE,
					//PM_BuiltInIcon,	PMIMG_SHOW,
				End,
				PMItem("View By"),
					PMSimpleSub,
						PMCheckItem("Icon", 4),		PM_Toggle, FALSE,	PM_Exclude,	PM_ExLst(5, 6, 7, 0),	PM_Checked,	TRUE,	End,
						PMCheckItem("Name", 5),		PM_Toggle, FALSE,	PM_Exclude,	PM_ExLst(4, 6, 7, 0),	End,
						PMCheckItem("Date", 6),		PM_Toggle, FALSE,	PM_Exclude,	PM_ExLst(4, 5, 7, 0),	End,
						PMCheckItem("Size", 7),		PM_Toggle, FALSE,	PM_Exclude,	PM_ExLst(4, 5, 6, 0),	End,
					End,
					PM_Disabled,	FALSE,
				End,
			End,
		End,
		PMItem("Icons"),
			PMSimpleSub,
				PMItem("Open"),			PM_CommKey,	"O",	End,
				PMItem("Copy"),			PM_CommKey,	"C",	End,
				PMItem("Rename..."),		PM_CommKey,	"R",	End,
				PMItem("Information..."),	PM_CommKey,	"I",	End,
				PMItem("Snapshot"),		PM_CommKey,	"S",	End,
				PMItem("UnSnapshot"),		PM_CommKey,	"U",	End,
				PMItem("Leave Out"),		PM_CommKey,	"L",	End,
				PMItem("Put Away"),		PM_CommKey,	"P",	End,
				PMBar,							End,
				PMItem("Delete..."),		PM_Disabled,	TRUE,	End,
				PMItem("FormatDisk..."),				End,
				PMItem("Empty Trash"),		PM_Disabled,	TRUE,	End,
			End,
		End,
		PMItem("Tools"),
			PMSimpleSub,
				PMItem("ResetWB"),	End,
			End,
		End,
	End;

	return p;
}