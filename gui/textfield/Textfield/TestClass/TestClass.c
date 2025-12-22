/*
 * TestClass.c
 *
 * This is a sample program that uses the TextField BOOPSI class.
 * It is modeled after an example in the RKRM Libraries book on
 * the RKMButClass.  It is provided to show how to use a TextField.gadget
 * BOOPSI object and shows general techniques and functionality.
 *
 * Opening the textfield.gadget library is done by TextFieldAuto.c.
 * The variable TextFieldBase has the library base, and the variable
 * TextFieldClass has the class pointer.
 *
 * See the autodoc if you do not use the SAS/C auto-open feature or
 * if you have another compiler.
 *
 * This code compiles with SAS/C 6.50+.
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>
#include <intuition/cghooks.h>
#include <intuition/icclass.h>
#include <graphics/gfxmacros.h>
#include <graphics/text.h>
#include <utility/tagitem.h>
#include <gadgets/textfield.h>
#include <libraries/gadtools.h>

#include <clib/alib_protos.h>

#include <proto/exec.h>
#include <proto/iffparse.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include <proto/textfield.h>
#include <proto/gadtools.h>

/*
 * External prototypes
 */

extern int SetupScreen( void );
extern void CloseDownScreen( void );
extern int HandleTextFieldPrefsIDCMP( void );
extern int OpenTextFieldPrefsWindow( void );
extern void CloseTextFieldPrefsWindow( void );
extern struct Window *TextFieldPrefsWnd;

/*
 * Local prototypes
 */

static void MainLoop(struct Menu *menu_strip);
static BOOL SetupPrefsWindow(void);
static void ShutdownPrefsWindow(void);
static void GetGadgetRect(struct Window *window, struct Gadget *gadget, struct Rectangle *rect);
static void ActivateTabGadget(struct Window *window);
static BOOL DoMenu(UWORD menu, UWORD item);

/*
 * Local variables
 */

static const char vers[] = "\0$VER: TestTextfield 3.1 " __AMIGADATE__;

static char initial_text[] = "Sample text placed immediately into the gadget.\nType into the object.\nOr try AMIGA-[, AMIGA-=, AMIGA-], or AMIGA-\\.\n",
            more_text[] = "I think the gadget looks best with the double-bevel border and a medium cursor speed.";

static struct TagItem prop2text[] = {
	{ PGA_Top, TEXTFIELD_Top },
	{ TAG_DONE }
};
static struct TagItem text2prop[] = {
	{ TEXTFIELD_Top, PGA_Top },
	{ TEXTFIELD_Visible, PGA_Visible },
	{ TEXTFIELD_Lines, PGA_Total },
	{ TAG_DONE }
};
static struct TagItem up2text[] = {
	{ GA_ID, TEXTFIELD_Up },
	{ TAG_DONE }
};
static struct TagItem down2text[] = {
	{ GA_ID, TEXTFIELD_Down },
	{ TAG_DONE }
};

enum {
	PROJECT_MENU,
	EDIT_MENU,
};

enum {
	ABOUT_ITEM,
	QUIT_ITEM = 2
};

enum {
	CUT_ITEM,
	COPY_ITEM,
	COPYALL_ITEM,
	PASTE_ITEM,
	UNDO_ITEM = 5,
	ERASE_ITEM = 7
};

static struct NewMenu menus[] = {
	{ NM_TITLE, "Project",		  0, 0, 0, 0 },
	{  NM_ITEM, "About",		"?", 0, 0, 0 },
	{  NM_ITEM, NM_BARLABEL,	  0, 0, 0, 0 },
	{  NM_ITEM, "Quit",			"Q", 0, 0, 0 },
	{ NM_TITLE, "Edit",			  0, 0, 0, 0 },
	{  NM_ITEM, "Cut",			"X", 0, 0, 0 },
	{  NM_ITEM, "Copy",			"C", 0, 0, 0 },
	{  NM_ITEM, "Copy All",		"K", 0, 0, 0 },
	{  NM_ITEM, "Paste",		"V", 0, 0, 0 },
	{  NM_ITEM, NM_BARLABEL,	  0, 0, 0, 0 },
	{  NM_ITEM, "Undo",			"U", 0, 0, 0 },
	{  NM_ITEM, NM_BARLABEL,	  0, 0, 0, 0 },
	{  NM_ITEM, "Erase",		"E", 0, 0, 0 },
	{   NM_END, NULL,			  0, 0, 0, 0 }
};

static struct EasyStruct about_req = {
	sizeof(struct EasyStruct),
	0,
	"About TestTextField",
	"TestTextField shows how to\nuse the textfield gadget.\n\n%s",
	"Okay"
};

/*
 * Global variables
 */

struct Window *window;
struct Gadget *text1_object, *prop_object, *up_object, *down_object;
ULONG length, window_sig, prefs_sig, sigs, style;
UWORD *pens;

/*
 * Functions
 */

void main(void)
{
	struct IntuiText text1_title;
	struct DrawInfo *draw_info;
	struct ClipboardHandle *clip_handle, *undo_handle;
	struct Image *up_image, *down_image;
	APTR *visual_info;
	UWORD gap_w, gap_h;
	struct Menu *menu_strip;

	if (!SetupPrefsWindow()) {
		printf("Cannot setup prefs window.\n");
		return;
	}
	prefs_sig = 1L << TextFieldPrefsWnd->UserPort->mp_SigBit;

	/* Open the window */
	window = OpenWindowTags(NULL,	WA_Flags,			WFLG_DEPTHGADGET|WFLG_DRAGBAR|WFLG_CLOSEGADGET|WFLG_SIZEGADGET
														|WFLG_SIZEBBOTTOM|WFLG_SIZEBRIGHT,
									WA_Activate,		TRUE,
									WA_IDCMP,			IDCMP_CLOSEWINDOW|IDCMP_VANILLAKEY|IDCMP_RAWKEY|IDCMP_MENUPICK,
									WA_Width,			320,
									WA_Height,			200,
									WA_NoCareRefresh,	TRUE,
									WA_NewLookMenus,	TRUE,
									WA_ScreenTitle,		"Testing textfield.gadget",
									TAG_END);

	if (window) {
		window_sig = 1L << window->UserPort->mp_SigBit;
		sigs = prefs_sig | window_sig;
		/* Get the DrawInfo since sysiclass needs it */
		draw_info = GetScreenDrawInfo(window->WScreen);

		if (draw_info) {
			pens = draw_info->dri_Pens;

			/* Make a title for the gadget */
			text1_title.FrontPen = pens[TEXTPEN];
			text1_title.BackPen = pens[BACKGROUNDPEN];  /* don't really need to set for JAM1 */
			text1_title.DrawMode = JAM1;
			text1_title.LeftEdge = 0;
			text1_title.TopEdge = -(window->WScreen->RastPort.TxHeight + 1);
			text1_title.ITextFont = NULL;
			text1_title.IText = "Gadget label:";
			text1_title.NextText = NULL;

			/* Setup the gaps */
			gap_w = 20;
			gap_h = window->RPort->TxHeight;

			/* Make some changes in the window limits */
			WindowLimits(window, 160, window->BorderTop + window->BorderBottom + window->WScreen->RastPort.TxHeight + 46, -1, -1);

			/* Create the gadgets/images with interconnection */
			prop_object = NewObject(NULL, "propgclass",
									GA_ID,			2,
									GA_Top,			window->BorderTop,
									GA_RelRight,	-(window->BorderRight - 5),
									GA_Width,		window->BorderRight - 8,
									GA_RelHeight,	-(window->BorderTop + (3 * window->BorderBottom)) - 2,
									GA_RightBorder,	TRUE,
									ICA_MAP,		prop2text,
									PGA_NewLook,	TRUE,
									PGA_Borderless,	TRUE,
									PGA_Visible,	50,		/* will get set later */
									PGA_Total,		50,		/* will get set later */
									TAG_END);

			up_image = NewObject(NULL, "sysiclass",
									SYSIA_DrawInfo,	draw_info,
									SYSIA_Which,	UPIMAGE,
									IA_Width,		window->BorderRight,
									IA_Height,		window->BorderBottom,
									TAG_END);

			down_image = NewObject(NULL, "sysiclass",
									SYSIA_DrawInfo,	draw_info,
									SYSIA_Which,	DOWNIMAGE,
									IA_Width,		window->BorderRight,
									IA_Height,		window->BorderBottom,
									TAG_END);

			up_object = NewObject(NULL, "buttongclass",
									GA_RelBottom,	-(3 * window->BorderBottom) - 1,
									GA_RelRight,	-(window->BorderRight - 1),
									GA_Height,		window->BorderBottom,
									GA_Width,		window->BorderRight,
									GA_Image,		up_image,
									GA_RightBorder,	TRUE,
									//GA_RelVerify,	TRUE,
									GA_Previous,	prop_object,
									ICA_MAP,		up2text,
									TAG_END);

			down_object = NewObject(NULL, "buttongclass",
									GA_RelBottom,	-(2 * window->BorderBottom),
									GA_RelRight,	-(window->BorderRight - 1),
									GA_Height,		window->BorderBottom,
									GA_Width,		window->BorderRight,
									GA_Image,		down_image,
									GA_RightBorder,	TRUE,
									//GA_RelVerify,	TRUE,
									GA_Previous,	up_object,
									ICA_MAP,		down2text,
									TAG_END);

			/* Open the clipboard; no need to verify */
			clip_handle = OpenClipboard(0);
			undo_handle = OpenClipboard(42);

			text1_object = NewObject(TextFieldClass, NULL,
									GA_ID,					1,
									GA_Top,					window->BorderTop + gap_h,
									GA_Left,				window->BorderLeft + gap_w,
									GA_RelWidth,			-(window->BorderLeft + window->BorderRight + 2 * gap_w),
									GA_RelHeight,			-(window->BorderTop + window->BorderBottom + 2 * gap_h),
									GA_Previous,			down_object,
									//GA_TabCycle,			TRUE,
									GA_IntuiText,			&text1_title,

									ICA_MAP,				text2prop,
									ICA_TARGET,				prop_object,

									TEXTFIELD_Text,			(ULONG)initial_text,
									TEXTFIELD_UserAlign,	TRUE,
									TEXTFIELD_ClipStream,	clip_handle,
									TEXTFIELD_UndoStream,	undo_handle,
									TEXTFIELD_Border,		TEXTFIELD_BORDER_DOUBLEBEVEL,
									TEXTFIELD_BlinkRate,	500000,
									TEXTFIELD_TabSpaces,	4,
									TEXTFIELD_NonPrintChars,	TRUE,

									/*TEXTFIELD_VCenter,		TRUE,
									TEXTFIELD_CursorPos,	10,
									TEXTFIELD_Partial,		TRUE,
									TEXTFIELD_MaxSize,		1000,
									TEXTFIELD_AcceptChars,	"+-1234567890\n",
									TEXTFIELD_Alignment,	TEXTFIELD_ALIGN_CENTER,
									TEXTFIELD_TextAttr,		(ULONG)&font,
									TEXTFIELD_Spacing,		10,
									TEXTFIELD_FontStyle,	style,*/
									TAG_END);

			/* Check if they were all created okay */
			if (text1_object && prop_object && up_image && down_image && up_object && down_object) {
				ULONG cur;

				/* Do menu stuff */
				visual_info = GetVisualInfo(window->WScreen, TAG_END);
				if (visual_info) {
					menu_strip = CreateMenus(menus, TAG_END);
					if (menu_strip) {
						if (LayoutMenus(menu_strip, visual_info, GTMN_NewLookMenus, TRUE, TAG_END)) {
							if (!SetMenuStrip(window, menu_strip)) {
								printf("Can't set menu strip; no menus.\n");
							}
						} else {
							printf("Can't layout menus; no menus.\n");
						}
					} else {
						printf("Can't create menus; no menus.\n");
					}
				} else {
					printf("Can't get visual info; no menus.\n");
				}

				/* Adjust some of the interconnections */
				SetGadgetAttrs(prop_object, window, NULL, ICA_TARGET, text1_object, TAG_END);
				SetGadgetAttrs(up_object, window, NULL, ICA_TARGET, text1_object, TAG_END);
				SetGadgetAttrs(down_object, window, NULL, ICA_TARGET, text1_object, TAG_END);

				AddGList(window, prop_object, -1, -1, NULL);
				RefreshGList(prop_object, window, NULL, -1);

				ActivateGadget(text1_object, window, NULL);
				SetWindowTitles(window, "<-- Scroll to bottom; click to go to top", (UBYTE *)-1);
				MainLoop(menu_strip);
				SetGadgetAttrs(text1_object, window, NULL, TEXTFIELD_CursorPos, 0, TAG_DONE);

				ActivateGadget(text1_object, window, NULL);
				SetWindowTitles(window, "<-- Move cursor; click to remember", (UBYTE *)-1);
				MainLoop(menu_strip);
				GetAttr(TEXTFIELD_CursorPos, text1_object, &cur);

				SetWindowTitles(window, "<-- Click to reset cursor", (UBYTE *)-1);
				MainLoop(menu_strip);
				SetGadgetAttrs(text1_object, window, NULL, TEXTFIELD_CursorPos, cur, TAG_DONE);
				ActivateGadget(text1_object, window, NULL);

				SetWindowTitles(window, "<-- Click to move gadget position", (UBYTE *)-1);
				MainLoop(menu_strip);
				{ // Shows how to change the size on the fly
				  // Also shows the special case of handling size change with GA_Rel#?
					struct Rectangle rect;

					GetGadgetRect(window, text1_object, &rect);
					SetAPen(window->RPort, pens[BACKGROUNDPEN]);
					RectFill(window->RPort, rect.MinX, rect.MinY, rect.MaxX, rect.MaxY);
					SetGadgetAttrs(text1_object, window, NULL,
									GA_Left,		window->BorderLeft,
									GA_Top,			window->BorderTop,
									GA_RelWidth,	-(window->BorderLeft + window->BorderRight),
									GA_RelHeight,	-(window->BorderTop + window->BorderBottom),
									GA_IntuiText,	NULL,
									TAG_DONE);
					RefreshGList(text1_object, window, NULL, 1);
				}
				//ActivateGadget(text1_object, window, NULL);

				SetWindowTitles(window, "<-- Click to replace text", (UBYTE *)-1);
				MainLoop(menu_strip);
				SetGadgetAttrs(text1_object, window, NULL, TEXTFIELD_Text, more_text, TAG_DONE);
				//ActivateGadget(text1_object, window, NULL);

				SetWindowTitles(window, "<-- Click to select 10 chars", (UBYTE *)-1);
				MainLoop(menu_strip);
				SetGadgetAttrs(text1_object, window, NULL, TEXTFIELD_SelectSize, 10, TAG_DONE);
				ActivateGadget(text1_object, window, NULL);

				SetWindowTitles(window, "<-- Click to print text and info", (UBYTE *)-1);
				MainLoop(menu_strip);
				SetGadgetAttrs(text1_object, window, NULL, TEXTFIELD_ReadOnly, TRUE, TAG_DONE);
				if (GetAttr(TEXTFIELD_Size, text1_object, &length)) {
					unsigned char *my_buffer = malloc(length + 1);
					if (my_buffer) {
						unsigned char *text_buffer;
						my_buffer[length] = 0;
						if (GetAttr(TEXTFIELD_Text, text1_object, (ULONG *)&text_buffer)) {
							if (text_buffer) {
								memcpy(my_buffer, text_buffer, length);
								printf("%s", my_buffer);
								printf("\n");
							}
						}
						free(my_buffer);
					}
				}
				SetGadgetAttrs(text1_object, window, NULL, TEXTFIELD_ReadOnly, FALSE, TAG_DONE);
				if (GetAttr(TEXTFIELD_Visible, text1_object, &length)) {
					printf("Visible lines: %d\n", length);
				}
				if (GetAttr(TEXTFIELD_Lines, text1_object, &length)) {
					printf("  Total lines: %d\n", length);
				}
				if (GetAttr(TEXTFIELD_Size, text1_object, &length)) {
					printf("         Size: %d\n", length);
				}
				if (GetAttr(TEXTFIELD_Top, text1_object, &length)) {
					printf("     Top line: %d\n", length);
				}
				if (GetAttr(TEXTFIELD_CursorPos, text1_object, &length)) {
					printf("       Cursor: %d\n", length);
				}
				if (GetAttr(TEXTFIELD_Modified, text1_object, &length)) {
					printf("     Modified: %s\n", (length ? "TRUE" : "FALSE"));
				}

				SetWindowTitles(window, "<-- Click to quit", (UBYTE *)-1);
				MainLoop(menu_strip);

				RemoveGList(window, prop_object, -1);

				/* Clean menu stuff */
				if (window->MenuStrip) {
					ClearMenuStrip(window);
				}
				if (menu_strip) {
					FreeMenus(menu_strip);
				}
				if (visual_info) {
					FreeVisualInfo(visual_info);
				}
			} else {
				printf("Couldn't get objects.\n");
			}

			/* Clean up any objects */
			DisposeObject(text1_object);
			DisposeObject(down_object);
			DisposeObject(up_object);
			DisposeObject(down_image);
			DisposeObject(up_image);
			DisposeObject(prop_object);

			/* Close the clipboard */
			if (undo_handle) {
				CloseClipboard(undo_handle);
			}
			if (clip_handle) {
				CloseClipboard(clip_handle);
			}

			FreeScreenDrawInfo(window->WScreen, draw_info);
		} else {
			printf("Couldn't get draw info.\n");
		}
		CloseWindow(window);
	} else {
		printf("Couldn't open window.\n");
	}

	ShutdownPrefsWindow();
}

/*
 * GetGadgetRect()
 *
 * This function gets the actual Rectangle where a gadget exists
 * in a window.  The special cases it handles are all the REL#?
 * (relative positioning flags).
 *
 * You need the actual position if you want to RectFill() to clear
 * the space a gadget covers or something like that.
 *
 * The function takes a struct Window pointer, a struct Gadget
 * pointer, and a struct Rectangle pointer.  It uses the window and
 * gadget to fill in the rectangle.
 */

static void GetGadgetRect(struct Window *window, struct Gadget *gadget, struct Rectangle *rect)
{
	rect->MinX = rect->MaxX = gadget->LeftEdge;
	if (gadget->Flags & GFLG_RELRIGHT) rect->MinX += window->Width - 1;
	rect->MinY = rect->MaxY = gadget->TopEdge;
	if (gadget->Flags & GFLG_RELBOTTOM) rect->MinY += window->Height - 1;
	rect->MaxX += gadget->Width;
	if (gadget->Flags & GFLG_RELWIDTH) rect->MaxX += window->Width - 1;
	rect->MaxY += gadget->Height;
	if (gadget->Flags & GFLG_RELHEIGHT) rect->MaxY += window->Height - 1;
}

/*
 * MainLoop()
 *
 * Handles all window IDCMP messages
 */

static void MainLoop(struct Menu *menu_strip)
{
	struct IntuiMessage *msg;
	ULONG done = FALSE;
	UWORD menu_num;

	while (!done) {
		HandleTextFieldPrefsIDCMP();
		while (msg = (struct IntuiMessage *)GetMsg((struct MsgPort *)window->UserPort)) {
			if (msg->Class == IDCMP_CLOSEWINDOW) {
				done = TRUE;
			} else if (msg->Class == IDCMP_VANILLAKEY) {
				if (msg->Code == 0x09) {
					// Activate first gadget that supports tab cycling if TAB is pressed
					ActivateTabGadget(window);
				} else {
					DisplayBeep(NULL);
				}
			} else if (msg->Class == IDCMP_RAWKEY) {
				DisplayBeep(NULL);
			} else if (msg->Class == IDCMP_MENUPICK) {
				menu_num = msg->Code;
				while (!done && (menu_num != MENUNULL)) {
					done |= DoMenu(MENUNUM(menu_num), ITEMNUM(menu_num));
					menu_num = ItemAddress(menu_strip, menu_num)->NextSelect;
				}
				ActivateGadget(text1_object, window, NULL);
			}
			ReplyMsg((struct Message *)msg);
		}
		if (!done) {
			Wait(sigs);
		}
	}
}

/*
 * ActivateTabGadget()
 *
 * This function scans a window's gadget list and activates the
 * first gadget that supports tab cycling.
 *
 * It should be called when your window gets a VANILLAKEY message
 * with a TAB code (0x09).  This gives the user a way to start
 * tab cycling through gadgets.
 */

static void ActivateTabGadget(struct Window *window)
{
	struct Gadget *gad;

	for (gad = window->FirstGadget; gad != NULL; gad = gad->NextGadget) {
		if ((gad->Flags & GFLG_TABCYCLE) && !(gad->Flags & GFLG_DISABLED)) {
			ActivateGadget(gad, window, NULL);
			break;
		}
	}
}

/*
 * DoMenu()
 *
 * Handle the Edit menu items
 */

static BOOL DoMenu(UWORD menu, UWORD item)
{
	switch (menu) {
		case PROJECT_MENU:
			switch (item) {
				case ABOUT_ITEM:
					EasyRequest(window, &about_req, NULL, TEXTFIELD_GetCopyright());
					break;

				case QUIT_ITEM:
					return TRUE;
					break;
			}
			break;

		case EDIT_MENU:
			{
				ULONG tag = 0;

				switch (item) {
					case CUT_ITEM:
						tag = TEXTFIELD_Cut;
						break;

					case COPY_ITEM:
						tag = TEXTFIELD_Copy;
						break;

					case COPYALL_ITEM:
						tag = TEXTFIELD_CopyAll;
						break;

					case PASTE_ITEM:
						tag = TEXTFIELD_Paste;
						break;

					case UNDO_ITEM:
						tag = TEXTFIELD_Undo;
						break;

					case ERASE_ITEM:
						tag = TEXTFIELD_Erase;
						break;
				}
				if (tag > 0) {
					SetGadgetAttrs(text1_object, window, NULL, tag, 0, TAG_DONE);
				}
			}
			break;
	}

	return FALSE;
}

/*
 * SetupPrefsWindow()
 *
 * Opens the preferences window generated by GadToolsBox
 */

static BOOL SetupPrefsWindow(void)
{
	if (SetupScreen() == 0) {
		if (OpenTextFieldPrefsWindow() == 0) {
			return TRUE;
		} else {
			CloseDownScreen();
		}
	}

	return FALSE;
}

/*
 * ShutdownPrefsWindow()
 *
 * Closes the preferences window generated by GadToolsBox
 */

static void ShutdownPrefsWindow(void)
{
	CloseTextFieldPrefsWindow();
	CloseDownScreen();
}
