//
// $VER: MenuIcons.c 1.1 (09.09.00)
//
// Popup Menu example program
//
// ©1996-1997 Henrik Isaksson
// All Rights Reserved.
//
// This simple example shows how to use standard BOOPSI images as menu icons.
//

#include <intuition/intuition.h>
#include <intuition/imageclass.h>
#include <proto/intuition.h>
#include <proto/exec.h>
#include <clib/alib_protos.h>
#include <stdio.h>
#include <string.h>

#include <images/bitmap.h>
#include <images/bevel.h>
#include <images/glyph.h>
#include <proto/bitmap.h>
#include <proto/bevel.h>
#include <proto/glyph.h>

#include <libraries/pm.h>
#include <proto/pm.h>

//
// Declarations for the popup menu
//
struct PopupMenuBase	*PopupMenuBase=NULL;

struct PopupMenu	*popupmenu=NULL;

//
// Declarations for the image objects
//
struct Library		*BitMapBase=NULL;
struct Library		*BevelBase=NULL;
struct Library		*GlyphBase=NULL;

Class *bitmapclass=NULL;
Class *bevelclass=NULL;
Class *glyphclass=NULL;

APTR	image1=NULL;
APTR	image2=NULL;
APTR	image3=NULL;
APTR	image4=NULL;

//
// Declarations for the window
//
struct Window		*wnd=NULL;


BOOL Init(void);	// Initialise everything
void Cleanup(void);	// Tidy up a bit afterwards
void MainLoop(void);	// Main loop

void ShowMessage(STRPTR text);	// Show a message in the window

void main()
{
	if(Init()) {
		MainLoop();
		Cleanup();
	}
}

struct Window *OpenMyWindow(void);

BOOL Init(void)
{
	if(OPEN_PM_LIB) {	/* A little macro from libraries/pm.h. */
		IntuitionBase=(struct IntuitionBase *)PopupMenuBase->pmb_IntuitionBase;

		wnd=OpenMyWindow();	/* Open a little window. (declared below) */
		if(wnd) {

			ShowMessage("Loading images...");

			BevelBase=OpenLibrary("images/bevel.image", 0);
			if(BevelBase) {
				bevelclass=BEVEL_GetClass();
				if(bevelclass) {
					image1=NewObject(bevelclass, NULL,
						BEVEL_LabelPlace,	BVJ_IN_CENTER,
						BEVEL_Style,		BVS_BUTTON,
						BEVEL_Transparent,	TRUE,
						IA_Height,		18,
						IA_Width,		20,
						TAG_DONE);
				}
			} else printf("Could not locate bevel.image!\n");

			BitMapBase=OpenLibrary("images/bitmap.image", 0);
			if(BitMapBase) {
				bitmapclass=BITMAP_GetClass();
				if(bitmapclass) {
					image2=NewObject(bitmapclass, NULL,
						BITMAP_SourceFile,	"popupmenu.bsh",
						BITMAP_Screen,		wnd->WScreen,
						BITMAP_Masking,		TRUE,
						TAG_DONE);
					image4=NewObject(bitmapclass, NULL,
						BITMAP_SourceFile,	"boing.bsh",
						BITMAP_SelectSourceFile, "boingsel.bsh",
						BITMAP_Screen,		wnd->WScreen,
						BITMAP_Masking,		TRUE,
						TAG_DONE);
				}
			} else printf("Could not locate bitmap.image!\n");

			GlyphBase=OpenLibrary("images/glyph.image", 0);
			if(GlyphBase) {
				glyphclass=GLYPH_GetClass();
				if(glyphclass) {
					image3=NewObject(glyphclass, NULL,
						GLYPH_Glyph, GLYPH_RETURNARROW,
						IA_Height, 20,
						TAG_DONE);
				}
			} else printf("Could not locate glyph.image!\n");

			if(image1 && image2 && image3 && image4)
				ShowMessage("Done.");
			else
				ShowMessage("Some images could not be loaded.");

			popupmenu=PM_MakeMenu(
				PM_Item, PM_MakeItem(PM_Hidden, TRUE, TAG_DONE),
				PMItem(""),	PM_ImageUnselected,	image2,		PM_Center, TRUE, PM_NoSelect, TRUE, PMEnd,
				PM_Item, PM_MakeItem(PM_WideTitleBar, TRUE, TAG_DONE),
				PMInfo("This example shows how to use"), PMEnd,
				PMInfo("BOOPSI image objects."), PMEnd,
				PMBar,	PMEnd,
				PMItem("SYS:Classes/images/bevel.image"),	PM_IconUnselected,	image1,		PMEnd,
				PMItem("SYS:Classes/images/glyph.image"),	PM_IconUnselected, 	image3,		PMEnd,
				PMItem("SYS:Classes/images/bitmap.image"),	PM_IconUnselected, 	image4,		PMEnd,
				PMBar,	PMEnd,
				PMItem("Quit"),	PM_UserData, 5,	PMEnd,
			  PMEnd;

			if(popupmenu) {
				return TRUE;
			}

		}

	}

	return FALSE;
}

void Cleanup(void)
{
	if(PopupMenuBase) {
		if(popupmenu) {
			PM_FreePopupMenu(popupmenu);
		}
		CLOSE_PM_LIB;
	}
	if(wnd) CloseWindow(wnd);
	if(image1) DisposeObject(image1);
	if(image2) DisposeObject(image2);
	if(image2) DisposeObject(image3);
	if(image4) DisposeObject(image4);
	if(BitMapBase) CloseLibrary(BitMapBase);
	if(BevelBase) CloseLibrary(BevelBase);
	if(GlyphBase) CloseLibrary(GlyphBase);
}

struct Window *OpenMyWindow(void)
{

	/* Open the window. I'm keeping this code here just to make the other */
	/* code more readable. */

	return OpenWindowTags(NULL,
			WA_IDCMP,	IDCMP_CLOSEWINDOW|IDCMP_MOUSEBUTTONS,	// Open a little window
			WA_RMBTrap,	TRUE,
			WA_DragBar,	TRUE,
			WA_Width,	350,
			WA_Height,	50,
			WA_Left,	0,
			WA_Top,		15,
			WA_Title,	"SimpleMenu",
			WA_CloseGadget,	TRUE,
		TAG_DONE);
}

void MainLoop(void)
{
	BOOL			r=TRUE;	/* Keep running until this gets FALSE */
	struct IntuiMessage	*im,imsg;

	/* A standard event loop follows: */
	while(r) {
		WaitPort(wnd->UserPort);
		while((im=(struct IntuiMessage *)GetMsg(wnd->UserPort))) {
			CopyMem(im,&imsg,sizeof(struct IntuiMessage));
			ReplyMsg((struct Message *)im);

			switch(imsg.Class) {
				case IDCMP_CLOSEWINDOW: r=FALSE; break;
				case IDCMP_MOUSEBUTTONS:
					if(imsg.Code==MENUDOWN) {
						r=PM_OpenPopupMenu(wnd,
							PM_Menu,	popupmenu,
							TAG_DONE);

						/* If r is 5, we want to quit: */
							
						if(r==5) r=0;
						else r=1;
					}
					break;
			}
		}
	}
}

void ShowMessage(STRPTR text)
{
	SetDrMd(wnd->RPort, 0);
	SetAPen(wnd->RPort, 0);
	RectFill(wnd->RPort, wnd->BorderLeft+5, wnd->BorderTop+5, wnd->Width-wnd->BorderRight-wnd->BorderLeft,
		wnd->BorderTop+wnd->RPort->Font->tf_YSize+5);
	SetAPen(wnd->RPort, 1);
	Move(wnd->RPort, wnd->BorderLeft+5, wnd->BorderTop+5+wnd->RPort->Font->tf_Baseline);
	Text(wnd->RPort, text, strlen(text));
}
