/*
// $VER: LocaleMenu.c 1.0 (23.08.99)
//
// Popup Menu example program
//
// ©1996-1997 Henrik Isaksson
// All Rights Reserved.
//
// This example shows how to use the LocaleHook feature of
// popupmenu.library.
*/

#include <intuition/intuition.h>
#include <proto/intuition.h>
#include <proto/exec.h>
#include <clib/alib_protos.h>
#include <stdio.h>
#include <utility/hooks.h>

#include <libraries/pm.h>
#include <proto/pm.h>

struct PopupMenuBase	*PopupMenuBase;

struct Window *OpenMyWindow(void);

#define	ID_QUIT		1	/* Use anything but 0 for the ID. */
#define ID_ITEM		2
#define ID_TITLE	3

char *strings[] = {
	"Quit", "Menu Item", "Menu Title"
};

STRPTR __asm __saveds GetStringFunc(register __a1 ULONG *args)
{
	return strings[*args-1];
	
	/* You should call the locale.library function */
	/* GetCatalogStr() (or similar) here. */

	/* Example: */

	/* return GetCatalogStr(catalog, *args, strings[*args-1]); */

	/* (the last argument is the default string, which is */
	/* returned if the ID was not fount in the catalog.) */
	
}

void main()
{
	BOOL			r=TRUE;	/* Keep running until this gets FALSE */
	struct Window		*w;	/* One window. */
	struct IntuiMessage	*im,imsg;
	struct PopupMenu	*p;	/* One menu. */

	struct Hook		getstringhook;
	
	getstringhook.h_Entry = (HOOKFUNC) GetStringFunc;

	if(OPEN_PM_LIB) {	/* A little macro from libraries/pm.h. */
		IntuitionBase=(struct IntuitionBase *)PopupMenuBase->pmb_IntuitionBase;

		/* Create a PopupMenu using the macros defined in pm.h: */

		p=PMMenuID(ID_TITLE),
			PMItemID(ID_ITEM),			PMEnd,
			PMBar,					PMEnd,
			PMItemID(ID_QUIT),	PM_UserData, 5,	PMEnd,
		  PMEnd;

		if(p) {
			w=OpenMyWindow();	/* Open a little window. (declared below) */
			if(w) {

				/* A standard event loop follows: */
				while(r) {
					WaitPort(w->UserPort);
					while((im=(struct IntuiMessage *)GetMsg(w->UserPort))) {
						CopyMem(im,&imsg,sizeof(struct IntuiMessage));
						ReplyMsg((struct Message *)im);

						switch(imsg.Class) {
							case IDCMP_CLOSEWINDOW: r=FALSE; break;
							case IDCMP_MOUSEBUTTONS:
								r=PM_OpenPopupMenu(w,
									PM_Menu,	p,
									PM_LocaleHook,	&getstringhook,
									TAG_DONE);

								/* If r is 5, we want to quit: */
								
								if(r==5) r=0;
								else r=1;
								
								/* Maybe a bit confusing... Well, PM_OpenPopupMenu */
								/* returns 0 if no item was select, so we can't just */
								/* assign the return value to r. */
								/* There is another (better?) way of handling the input; */
								/* the PM_MenuHandler tag. */

								break;
						}
					}
				}
				CloseWindow(w);
			} else printf("Window error!\n");
			PM_FreePopupMenu(p);
		} else printf("Menu error!\n");

		CLOSE_PM_LIB;
	}
}

struct Window *OpenMyWindow(void)
{

	/* Open the window. I'm keeping this code here just to make the other */
	/* code more readable. */

	return OpenWindowTags(NULL,
			WA_IDCMP,	IDCMP_CLOSEWINDOW|IDCMP_MOUSEBUTTONS,	// Open a little window
			WA_RMBTrap,	TRUE,
			WA_DragBar,	TRUE,
			WA_Width,	150,
			WA_Height,	100,
			WA_Left,	150,
			WA_Top,		0,
			WA_Title,	"LocaleHook",
			WA_CloseGadget,	TRUE,
		TAG_DONE);
}
