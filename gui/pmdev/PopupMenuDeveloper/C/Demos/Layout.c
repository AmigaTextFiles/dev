/*
 *
 * $VER: Layout.c 1.1 (23.08.00)
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

struct Window *w;

struct PopupMenu *MakeTestMenu(void);

void main()
{
	struct IntuiMessage *im,imsg;
	struct PopupMenu *p;
	BOOL r=TRUE;

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
					WA_Title,	"Layout",
					WA_CloseGadget,	TRUE,
					TAG_DONE);
			if(w) {
				while(r) {
					WaitPort(w->UserPort);						// Wait for a message
					while((im=(struct IntuiMessage *)GetMsg(w->UserPort))) {	// Get the message
						CopyMem(im,&imsg,sizeof(struct IntuiMessage));		// Copy the contents of it
						ReplyMsg((struct Message *)im);				// Reply the message

						if(imsg.Class==IDCMP_MOUSEBUTTONS && imsg.Code==MENUDOWN) {
							if(PM_OpenPopupMenu(w, PM_Menu, p, TAG_DONE)==5) r=FALSE;
						}
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

	p=PMMenu("Group Layout"),

		PMHoriz,
			PMMembers,

				PMItem("Left"), PM_Center, TRUE, End,

				PMVert,
					PMMembers,
						PMItem("Item 1"), PM_Center, TRUE, End,
						PMItem("Item 2"), PM_Center, TRUE, End,
						PMItem("Item 3"), PM_Center, TRUE, End,
						PMItem("Item 4"), PM_Center, TRUE, End,
						PMItem("Item 5"), PM_Center, TRUE, End,
						PMItem("Item 6"), PM_Center, TRUE, End,
					End,
				End,

				PMItem("Right"), PM_Center, TRUE, End,

			End,
		End,

		PMBar,	End,

		PMVert,
			PMMembers,

				PMHoriz,
					PMMembers,
						PMColBox(1), End,
						PMColBox(2), End,
						PMColBox(3), End,
						PMColBox(4), End,
						PMColBox(5), End,
						PMColBox(6), End,
						PMColBox(7), End,
						PMColBox(8), End,
						PMColBox(9), End,
						PMColBox(0), End,
					End,
				End,

				PMHoriz,
					PMMembers,
						PMColBox(11), End,
						PMColBox(12), End,
						PMColBox(13), End,
						PMColBox(14), End,
						PMColBox(15), End,
						PMColBox(16), End,
						PMColBox(17), End,
						PMColBox(18), End,
						PMColBox(19), End,
						PMColBox(10), End,
					End,
				End,

				PMHoriz,
					PMMembers,
						PMColBox(21), End,
						PMColBox(22), End,
						PMColBox(23), End,
						PMColBox(24), End,
						PMColBox(25), End,
						PMColBox(26), End,
						PMColBox(27), End,
						PMColBox(28), End,
						PMColBox(29), End,
						PMColBox(20), End,
					End,
				End,

				PMHoriz,
					PMMembers,
						PMColBox(31), End,
						PMColBox(32), End,
						PMColBox(33), End,
						PMColBox(34), End,
						PMColBox(35), End,
						PMColBox(36), End,
						PMColBox(37), End,
						PMColBox(38), End,
						PMColBox(39), End,
						PMColBox(30), End,
					End,
				End,

				PMHoriz,
					PMMembers,
						PMColBox(41), End,
						PMColBox(42), End,
						PMColBox(43), End,
						PMColBox(44), End,
						PMColBox(45), End,
						PMColBox(46), End,
						PMColBox(47), End,
						PMColBox(48), End,
						PMColBox(49), End,
						PMColBox(40), End,
					End,
				End,

			End,
		End,

		PMBar,	End,
		PMItem("Quit"), PM_UserData, 5, End,
	End;
	
	return p;
}
