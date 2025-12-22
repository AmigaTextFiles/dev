//
// $VER: EndlessMenu.c 1.1 (25.08.00)
//
// Popup Menu library test program
//
// ©1996-2000 Henrik Isaksson
// All Rights Reserved.
//
// Run and click the mouse in the window!
// This little hack is intended to test the submenus.
//
// Changes:
//
// 1.1	Displays remaining stack and free RAM now
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

struct Hook SubConstruct;
struct Hook SubDestruct;

ULONG SubNum=1;

struct PopupMenu * __saveds __asm SubConstructFunc(register __a0 struct Hook *hook,
				     register __a2 struct PopupMenu *selected, register __a1 APTR *handle)
{
	struct PopupMenu *newpm;
	char bfr[50], stack[50], mem[50];
	struct Task *tsk=FindTask(NULL);

	// Don't try to open windows, requesters or print text etc from this
	// hook, wich is called while the menu is still open.
	// The display may be locked! (If window mode is not used)

	sprintf(bfr, "SubMenu #%ld", SubNum++);
	sprintf(stack, "Stack: %ld b", (ULONG)tsk->tc_SPReg-(ULONG)tsk->tc_SPLower);
	sprintf(mem, "Mem: %ld kb", AvailMem(0)/1024);

	newpm=PM_MakeMenu(
		PMInfo(bfr), End,
		PMBar, End,
		PMItem("Next SubMenu"),
			PM_SubConstruct,	&SubConstruct,
			PM_SubDestruct,		&SubDestruct,
			PM_Sub, PM_MakeMenu(
				PMBar, PMEnd,
			PMEnd,
		PMEnd,
		PMBar, End,
		PMInfo(stack), End,
		PMInfo(mem), End,
	PMEnd;		

	if(selected->Sub) {
		PM_FreePopupMenu(selected->Sub);	// free the old one (if there is one)
	}

	selected->Sub=newpm;

	return selected->Sub;	// If you return NULL, no menu will be opened.
}

void __saveds __asm SubDestructFunc(register __a0 struct Hook *hook,
				     register __a2 struct PopupMenu *parent)
{
	// Don't try to open windows, requesters or print text from this
	// hook, wich is called while the menu is still open.
	// The display might be locked, and input definitively is.
	
	SubNum--;
}

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
					WA_Title,	"Endless Menus",
					WA_CloseGadget,	TRUE,
					TAG_DONE);
			if(w) {
				while(r) {
					WaitPort(w->UserPort);						// Wait for a message
					while((im=(struct IntuiMessage *)GetMsg(w->UserPort))) {	// Get the message
						CopyMem(im,&imsg,sizeof(struct IntuiMessage));		// Copy the contents of it
						ReplyMsg((struct Message *)im);				// Reply the message

						if(imsg.Class==IDCMP_MOUSEBUTTONS) {
							if(imsg.Code==MENUDOWN || imsg.Code==MENUUP) {
								if(PM_OpenPopupMenu(w, PM_Menu, p, TAG_DONE)==5) r=0;
							}
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

	p=PMMenu("Endless Menu"),
		PMInfo("Welcome to the neverending"), End,
		PMInfo("submenu example."), End,
		PMInfo("This time it's for real..."), End,
		PMInfo("Note! The menu stops when it"), End,
		PMInfo("runs out of stack or memory."), End,
		PMBar, End,
		PMItem("Submenu"),
			PM_SubConstruct,	&SubConstruct,
			PM_SubDestruct,		&SubDestruct,
			PM_Sub, PMMenu("Error!"),
				PMBar, End,
			PMEnd,
		End,
		PMBar,	End,
		PMItem("Quit"),	PM_UserData,	5,	End,
	End;

	return p;
}