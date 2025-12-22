//
// $VER: Opus4.c 1.0 (21.08.00)
//
// Popup Menu example program
//
// ©1996-2000 Henrik Isaksson
// All Rights Reserved.
//
// This example shows how to use MultiSelect, Mutual Exclude items, MenuHandlers
// and how to share Item ID lists among a set of items. (saves memory and typing)
//

#include <intuition/intuition.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
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

void ShowMessage(STRPTR text);	// Shows a message in the window

//
// Some ID's for the items
//

enum SortBy {
	sbName=1, sbSize, sbProt, sbDate, sbComment, sbType,

	sbReverse=0x40000000	// So we can put in the same LONG, as a flag...
};

#define ID_SHOWDEBUG	100

//
// Here's the menu handler function.
//

ULONG __saveds __asm MenuHandlerFunc(register __a0 struct Hook *hook,
				     register __a2 APTR object,
				     register __a1 APTR msg)
{
	struct PopupMenu *pm=(struct PopupMenu *)object;
	static BOOL showdebug=FALSE;

	if(showdebug) printf("--- MenuHandler ---\n");

	if(pm->ID==sbReverse) {
		if(pm->Flags&PM_CHECKED) {
			*((ULONG *)hook->h_Data)|=sbReverse;	// Set flag

			if(showdebug) printf("Reverse order sorting was turned ON!\n");
		} else {
			*((ULONG *)hook->h_Data)&=~sbReverse;	// Clear flag

			if(showdebug) printf("Reverse order sorting was turned OFF!\n");
		}
	} else if(pm->ID>=sbName && pm->ID<=sbType) {
		if(pm->Flags & PM_CHECKED) {
			*((ULONG *)hook->h_Data)&=0xFFFF0000;	// We don't need all bits so we
			*((ULONG *)hook->h_Data)|=pm->ID;	// preserve the high ones for flags.

			if(showdebug) printf("Sort by = %ld\n", pm->ID);
		}
	} else if(pm->ID==ID_SHOWDEBUG) {
		if(pm->Flags & PM_CHECKED) showdebug=TRUE;
		else showdebug=FALSE;
	}

	return 0;
}

//
// Array of strings used to print out the selected sort order.
//

char *order[] = {"file name", "file size", "protection bits", "creation date", "file comment", "file type"};

void main()
{
	BOOL r=TRUE;
	struct IntuiMessage *im,imsg;
	struct PopupMenu *p;
	struct Hook MenuHandler;
	struct PM_IDLst *exlst;
	ULONG sortorder=sbName;		// Holds the current sort order
	ULONG oldorder=sortorder;	// To find out if changes has been made
	char bfr[128];			// Temp string buffer

	MenuHandler.h_Entry=(HOOKFUNC)MenuHandlerFunc;
	MenuHandler.h_Data=&sortorder;

	PopupMenuBase=(struct PopupMenuBase *)OpenLibrary(POPUPMENU_NAME,POPUPMENU_VERSION);			// Open the library
	if(PopupMenuBase) {
		IntuitionBase=(struct IntuitionBase *)PopupMenuBase->pmb_IntuitionBase;	// We let popupmenu.library open the libraries we need
		GfxBase=(struct GfxBase *)PopupMenuBase->pmb_GfxBase;			// They remain valid until the library is closed!

		exlst=PM_ExLst(sbName, sbSize, sbProt, sbDate, sbComment, sbType, NULL);

		p=PMMenu("Sort by"),
			PMMXItem("File name", sbName),		PM_Exclude, exlst, PM_ExcludeShared, TRUE, PM_Checked, TRUE, End,
			PMMXItem("File size", sbSize),		PM_Exclude, exlst, PM_ExcludeShared, TRUE, End,
			PMMXItem("Protection bits", sbProt),	PM_Exclude, exlst, PM_ExcludeShared, TRUE, End,
			PMMXItem("Creation date", sbDate),	PM_Exclude, exlst, PM_ExcludeShared, TRUE, End,
			PMMXItem("File comment", sbComment),	PM_Exclude, exlst, PM_ExcludeShared, TRUE, End,
			PMMXItem("File type", sbType),		PM_Exclude, exlst, PM_ExcludeShared, TRUE, End,

			PMBar,	End,

			PMCheckItem("Reverse order", sbReverse), End,

			PMBar,	End,

			PMCheckItem("Show debug output", ID_SHOWDEBUG), End,

		End; /* PMMenu */

		if(p) {
			w=OpenWindowTags(NULL,	WA_IDCMP,	IDCMP_CLOSEWINDOW|IDCMP_MOUSEBUTTONS,	// Open a little window
					WA_RMBTrap,	TRUE,
					WA_DragBar,	TRUE,
					WA_Width,	400,
					WA_Height,	75,
					WA_Left,	0,
					WA_Top,		0,
					WA_Title,	"DirectoryOpus4 Menu Test",
					WA_CloseGadget,	TRUE,
					TAG_DONE);
			if(w) {

				ShowMessage("Click right mouse button!");

				while(r) {
					WaitPort(w->UserPort);						// Wait for a message
					while((im=(struct IntuiMessage *)GetMsg(w->UserPort))) {	// Get the message
						CopyMem(im,&imsg,sizeof(struct IntuiMessage));		// Copy the contents of it
						ReplyMsg((struct Message *)im);				// Reply the message

						switch(imsg.Class) {
							case IDCMP_CLOSEWINDOW: r=FALSE; break;
							case IDCMP_MOUSEBUTTONS:			// The user has hit a mousebutton - time to open the menu!
								if(imsg.Code==MENUDOWN) {
									PM_OpenPopupMenu(w,
										PM_Menu,		p,
										PM_MenuHandler,		&MenuHandler,
										TAG_DONE);

									// This is one way of finding out if something has changed
									// It could also be managed in the MenuHandler or by checking
									// what is returned by PM_OpenPopupMenu(). But this method
									// seems appropriate in this case...
									if(sortorder!=oldorder) {
										int i=(sortorder&0xF)-1;	// Mask out the lower 4 bits

										i=i>5?0:i;	// Make sure i is inside the array
										i=i<0?0:i;	// even if something should fail

										sprintf(bfr, "Sort by %s %s", order[i],
											(sortorder&sbReverse)?"(REVERSE)":"");
										ShowMessage(bfr);
										oldorder=sortorder;
									}
								}
							break;
						}
					}
				}
				CloseWindow(w);
			} else printf("Window error!\n");
			PM_FreePopupMenu(p);
		} else printf("Menu error!\n");

		if(exlst)
			PM_FreeIDList(exlst);

		CloseLibrary((struct Library *)PopupMenuBase);
	} else {
		printf("PopupMenu V10+ is required!\n");
	}
}

void ShowMessage(STRPTR text)
{
	SetDrMd(w->RPort, 0);
	SetAPen(w->RPort, 0);
	RectFill(w->RPort, w->BorderLeft+5, w->BorderTop+5, w->Width-w->BorderRight-w->BorderLeft,
		w->BorderTop+w->RPort->Font->tf_YSize+5);
	SetAPen(w->RPort, 1);
	Move(w->RPort, w->BorderLeft+5, w->BorderTop+5+w->RPort->Font->tf_Baseline);
	Text(w->RPort, text, strlen(text));
}
