/*
 * EditorClassText.c
 *
 * This is a sample program that uses the Editor BOOPSI class.
 * It is modeled after an example in the RKRM Libraries book on
 * the RKMButClass.  It is provided to show how to use a EditorClass
 * BOOPSI object and shows general techniques and functionality.
 *
 * Opening the editor.gadget library is done by EditorAuto.c.
 *
 * This code compiles with SAS/C 6.51.
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
#include <utility/hooks.h>
#include <gadgets/editor.h>

#include <clib/alib_protos.h>

#include <proto/exec.h>
#include <proto/iffparse.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include <proto/editor.h>

extern int SetupScreen( void );
extern void CloseDownScreen( void );
extern int HandleEditorPrefsIDCMP( void );
extern int OpenEditorPrefsWindow( void );
extern void CloseEditorPrefsWindow( void );
extern struct Window        *EditorPrefsWnd;

static const char vers[] = "\0$VER: EditorClassTest 1.0 " __AMIGADATE__;

void MainLoop(void);
BOOL SetupPrefsWindow(void);
void ShutdownPrefsWindow(void);

Class *editor_class;
struct Window *window;
struct DrawInfo *draw_info;
struct Gadget *edit_object, *prop_object, *up_object, *down_object;
struct Image *up_image, *down_image;
struct IntuiMessage *msg;
struct ClipboardHandle *clip_handle, *undo_handle;
unsigned char *text_buffer, *my_buffer;
ULONG length, window_sig, prefs_sig, sigs, style;
UWORD *pens;

char initial_text[] = "Sample text placed immediately into the gadget.\nType into the object.\nOr try AMIGA-[, AMIGA-=, AMIGA-], or AMIGA-\\.\n";

struct TagItem prop2edit[] = {
	{ PGA_Top, EDIT_Top },
	{ TAG_DONE }
};

struct TagItem edit2prop[] = {
	{ EDIT_Top, PGA_Top },
	{ EDIT_Visible, PGA_Visible },
	{ EDIT_Lines, PGA_Total },
	{ TAG_DONE }
};

struct TagItem up2edit[] = {
	{ GA_ID, EDIT_Up },
	{ TAG_DONE }
};

struct TagItem down2edit[] = {
	{ GA_ID, EDIT_Down },
	{ TAG_DONE }
};

void main(void)
{
	if (!SetupPrefsWindow()) {
		return;
	}
	prefs_sig = 1L << EditorPrefsWnd->UserPort->mp_SigBit;

	/* Open the window */
	window = OpenWindowTags(NULL,	WA_Flags,			WFLG_DEPTHGADGET|WFLG_DRAGBAR|WFLG_CLOSEGADGET|WFLG_SIZEGADGET
														|WFLG_SIZEBBOTTOM|WFLG_SIZEBRIGHT,
									WA_Activate,		TRUE,
									WA_IDCMP,			IDCMP_CLOSEWINDOW,
									WA_Width,			320,
									WA_Height,			200,
									WA_NoCareRefresh,	TRUE,
									WA_ScreenTitle,		"Testing editor.gadget",
									TAG_END);

	if (window) {
		window_sig = 1L << window->UserPort->mp_SigBit;
		sigs = prefs_sig | window_sig;
		/* Get the DrawInfo since sysiclass needs it */
		draw_info = GetScreenDrawInfo(window->WScreen);

		if (draw_info) {
			pens = draw_info->dri_Pens;

			/* Make some changes in the window limits */
			WindowLimits(window, 160, window->BorderTop + window->BorderBottom + window->WScreen->RastPort.TxHeight + 46, -1, -1);

			/* Get the handle on the editor class */
			editor_class = EDIT_GetClass();

			/* Create the gadgets/images with interconnection */
			prop_object = NewObject(NULL, "propgclass",
									GA_ID,			2,
									GA_Top,			window->BorderTop,
									GA_RelRight,	-(window->BorderRight - 5),
									GA_Width,		window->BorderRight - 8,
									GA_RelHeight,	-(window->BorderTop + (3 * window->BorderBottom)) - 2,
									GA_RightBorder,	TRUE,
									ICA_MAP,		prop2edit,
									PGA_NewLook,	TRUE,
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
									GA_RelVerify,	TRUE,
									GA_Previous,	prop_object,
									ICA_MAP,		up2edit,
									TAG_END);

			down_object = NewObject(NULL, "buttongclass",
									GA_RelBottom,	-(2 * window->BorderBottom),
									GA_RelRight,	-(window->BorderRight - 1),
									GA_Height,		window->BorderBottom,
									GA_Width,		window->BorderRight,
									GA_Image,		down_image,
									GA_RightBorder,	TRUE,
									GA_RelVerify,	TRUE,
									GA_Previous,	up_object,
									ICA_MAP,		down2edit,
									TAG_END);

			/* Open the clipboard; no need to verify */
			clip_handle = OpenClipboard(0);
			undo_handle = OpenClipboard(42);

			edit_object = NewObject(editor_class, NULL,
									GA_ID,				1,
									GA_Top,				window->BorderTop + 20,
									GA_Left,			window->BorderLeft + 20,
									GA_RelWidth,		-(window->BorderLeft + window->BorderRight + 40),
									GA_RelHeight,		-(window->BorderTop + window->BorderBottom + 40),
									GA_Previous,		down_object,

									ICA_MAP,			edit2prop,
									ICA_TARGET,			prop_object,

									EDIT_Text,			(ULONG)initial_text,
									EDIT_UserAlign,		TRUE,
									EDIT_ClipStream,	clip_handle,
									EDIT_ClipStream2,	undo_handle,
									EDIT_CursorPos,		10,

									/*EDIT_VCenter,		TRUE,
									EDIT_BlinkRate,		500000,
									EDIT_Border,		EDIT_BORDER_DOUBLEBEVEL,
									EDIT_Partial,		TRUE,
									EDIT_MaxSize,		1000,
									EDIT_Alignment,		EDIT_ALIGN_CENTER,
									EDIT_TextAttr,		(ULONG)&font,
									EDIT_Spacing,		10,
									EDIT_FontStyle,		style,*/
									TAG_END);

			/* Check if they were all created okay */
			if (edit_object && prop_object && up_image && down_image && up_object && down_object) {
				ULONG cur;

				/* Adjust some of the interconnection problems */
				SetGadgetAttrs(prop_object, window, NULL, ICA_TARGET, edit_object, TAG_END);
				SetGadgetAttrs(up_object, window, NULL, ICA_TARGET, edit_object, TAG_END);
				SetGadgetAttrs(down_object, window, NULL, ICA_TARGET, edit_object, TAG_END);

				AddGList(window, prop_object, -1, -1, NULL);
				RefreshGList(prop_object, window, NULL, -1);

				ActivateGadget(edit_object, window, NULL);
				SetWindowTitles(window, "<-- Click to remember cursor position", (UBYTE *)-1);
				MainLoop();
				GetAttr(EDIT_CursorPos, edit_object, &cur);

				SetWindowTitles(window, "<-- Click to reset cursor position", (UBYTE *)-1);
				MainLoop();
				SetGadgetAttrs(edit_object, window, NULL, EDIT_CursorPos, cur, TAG_DONE);
				ActivateGadget(edit_object, window, NULL);

				SetWindowTitles(window, "<-- Click to print text and info", (UBYTE *)-1);
				MainLoop();
				SetGadgetAttrs(edit_object, window, NULL, GA_Disabled, TRUE, EDIT_NoGhost, TRUE, TAG_DONE);
				if (GetAttr(EDIT_Size, edit_object, &length)) {
					my_buffer = malloc(length + 1);
					if (my_buffer) {
						my_buffer[length] = 0;
						if (GetAttr(EDIT_Text, edit_object, (ULONG *)&text_buffer)) {
							if (text_buffer) {
								memcpy(my_buffer, text_buffer, length);
								printf("%s", my_buffer);
								printf("\n");
							}
						}
						free(my_buffer);
					}
				}
				SetGadgetAttrs(edit_object, window, NULL, GA_Disabled, FALSE, EDIT_NoGhost, FALSE, TAG_DONE);
				if (GetAttr(EDIT_Visible, edit_object, &length)) {
					printf("Visible lines: %d\n", length);
				}
				if (GetAttr(EDIT_Lines, edit_object, &length)) {
					printf("  Total lines: %d\n", length);
				}
				if (GetAttr(EDIT_Size, edit_object, &length)) {
					printf("         Size: %d\n", length);
				}
				if (GetAttr(EDIT_Top, edit_object, &length)) {
					printf("     Top line: %d\n", length);
				}

				SetWindowTitles(window, "<-- Click to quit", (UBYTE *)-1);
				MainLoop();

				RemoveGList(window, prop_object, -1);
			} else {
				printf("Couldn't get objects.\n");
			}

			/* Clean up any objects */
			DisposeObject(edit_object);
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

void MainLoop(void)
{
	ULONG done = FALSE;

	while (!done) {
		HandleEditorPrefsIDCMP();
		while (msg = (struct IntuiMessage *)GetMsg((struct MsgPort *)window->UserPort)) {
			if (msg->Class == IDCMP_CLOSEWINDOW) {
				done = TRUE;
			}
			ReplyMsg((struct Message *)msg);
		}
		if (!done) {
			Wait(sigs);
		}
	}
}

BOOL SetupPrefsWindow(void)
{
	if (SetupScreen() == 0) {
		if (OpenEditorPrefsWindow() == 0) {
			return TRUE;
		} else {
			CloseDownScreen();
		}
	}

	return FALSE;
}

void ShutdownPrefsWindow(void)
{
	CloseEditorPrefsWindow();
	CloseDownScreen();
}
