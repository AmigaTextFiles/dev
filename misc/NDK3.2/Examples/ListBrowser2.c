;/*
sc ListBrowser2.c LINK LIB lib:reaction.lib NOSTACKCHECK
quit
*/

#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <graphics/gfxmacros.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <intuition/icclass.h>
#include <libraries/asl.h>
#include <libraries/gadtools.h>
#include <utility/tagitem.h>
#include <reaction/reaction.h>
#include <reaction/reaction_macros.h>

#include <images/glyph.h>
#include <images/label.h>
#include <gadgets/layout.h>
#include <gadgets/listbrowser.h>
#include <classes/window.h>

#include <proto/asl.h>
#include <proto/dos.h>
#include <proto/diskfont.h>
#include <proto/exec.h>
#include <proto/gadtools.h>
#include <proto/graphics.h>
#include <proto/icon.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <proto/wb.h>
#include <clib/alib_protos.h>

#include <proto/button.h>
#include <proto/glyph.h>
#include <proto/label.h>
#include <proto/layout.h>
#include <proto/listbrowser.h>
#include <proto/window.h>
#include <clib/reaction_lib_protos.h>

#include <stdio.h>
#include <string.h>


ULONG __asm __saveds lb_hook(register __a0 struct Hook *hook, register
        				__a2 struct Node *node, register __a1 struct LBDrawMsg *msg);

struct ColumnInfo ci[] =
{
	{ 100, "Column Header", 0 },
	{ -1, (STRPTR)~0, -1 }
};

struct TextAttr emerald17 = { (STRPTR)"emerald.font", 18, FS_NORMAL, 0x01 };


/* Here's where it all starts.
 */
main()
{
	struct Screen *screen = NULL;

	if (!ButtonBase) return(20);

	/* We'll just open up on the default public screen, and use its screen font.
	 */
	if (screen = LockPubScreen(NULL))
	{
	struct TextAttr emerald17 = { (STRPTR)"emerald.font", 18, FS_NORMAL, 0x01 };
		struct DrawInfo *drinfo = GetScreenDrawInfo(screen);
		Object *layout;
		struct Gadget *lb_gad;
		struct List list;
		struct Image *limage, *gimage;
		struct Hook lbhook;

		NewList(&list);

		if (layout = LayoutObject,
						GA_DrawInfo, drinfo,
						LAYOUT_DeferLayout, TRUE,	/* Layout refreshes done on
													 * task's context (by the
													 * window class) */
						LAYOUT_SpaceOuter, TRUE,
						LAYOUT_AddChild, lb_gad = ListBrowserObject,
							GA_ID, 1,
							GA_RelVerify, TRUE,
							LISTBROWSER_Labels, &list,
							LISTBROWSER_ColumnInfo, &ci,
							LISTBROWSER_ColumnTitles, TRUE,
							LISTBROWSER_Separators, TRUE,
							LISTBROWSER_Hierarchical, TRUE,
							LISTBROWSER_Editable, TRUE,
							LISTBROWSER_MultiSelect, TRUE,
							LISTBROWSER_ShowSelected, TRUE,
							ListBrowserEnd,

						LayoutEnd)
		{
			struct MsgPort *app_port;
			Object *window_obj;

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 1,
				LBNA_Column, 0,
					LBNCA_CopyText, TRUE,
					LBNCA_Text, "Demo of ListBrowserNode features",
				TAG_DONE);

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 1,
				LBNA_Flags, LBFLG_HASCHILDREN | LBFLG_SHOWCHILDREN,
				LBNA_Column, 0,
					LBNCA_CopyText, TRUE,
					LBNCA_Text, "Editable node",
				TAG_DONE);

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 2,
				LBNA_Column, 0,
					LBNCA_CopyText, TRUE,
					LBNCA_Text, "Click twice to edit",
					LBNCA_Editable, TRUE,
					LBNCA_MaxChars, 60,
				TAG_DONE);

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 1,
				LBNA_Flags, LBFLG_HASCHILDREN | LBFLG_SHOWCHILDREN,
				LBNA_Column, 0,
					LBNCA_CopyText, TRUE,
					LBNCA_Text, "Change colours",
				TAG_DONE);

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 2,
				LBNA_Flags, LBFLG_CUSTOMPENS,
				LBNA_Column, 0,
					LBNCA_CopyText, TRUE,
					LBNCA_Text, "Colourful!",
					LBNCA_FGPen, 19,
					LBNCA_BGPen, 18,
				TAG_DONE);

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 1,
				LBNA_Flags, LBFLG_HASCHILDREN | LBFLG_SHOWCHILDREN,
				LBNA_Column, 0,
					LBNCA_CopyText, TRUE,
					LBNCA_Text, "Checkbox item",
				TAG_DONE);

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 2,
				LBNA_CheckBox, TRUE,
				LBNA_Checked, TRUE,
				LBNA_Column, 0,
					LBNCA_CopyText, TRUE,
					LBNCA_Text, "Checked by default",
				TAG_DONE);

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 2,
				LBNA_CheckBox, TRUE,
				LBNA_Checked, FALSE,
				LBNA_Column, 0,
					LBNCA_CopyText, TRUE,
					LBNCA_Text, "Unchecked by default",
				TAG_DONE);

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 1,
				LBNA_Flags, LBFLG_HASCHILDREN | LBFLG_SHOWCHILDREN,
				LBNA_Column, 0,
					LBNCA_CopyText, TRUE,
					LBNCA_Text, "Justifications",
				TAG_DONE);

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 2,
				LBNA_Column, 0,
					LBNCA_CopyText, TRUE,
					LBNCA_Text, "Left",
					LBNCA_Justification, LCJ_LEFT,
				TAG_DONE);

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 2,
				LBNA_Column, 0,
					LBNCA_CopyText, TRUE,
					LBNCA_Text, "Centre",
					LBNCA_Justification, LCJ_CENTRE,
				TAG_DONE);

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 2,
				LBNA_Column, 0,
					LBNCA_CopyText, TRUE,
					LBNCA_Text, "Right",
					LBNCA_Justification, LCJ_RIGHT,
				TAG_DONE);

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 1,
				LBNA_Flags, LBFLG_HASCHILDREN | LBFLG_SHOWCHILDREN,
				LBNA_Column, 0,
					LBNCA_CopyText, TRUE,
					LBNCA_Text, "Read-Only node",
				TAG_DONE);

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 2,
				LBNA_Flags, LBFLG_READONLY,
				LBNA_Column, 0,
					LBNCA_CopyText, TRUE,
					LBNCA_Text, "Can't select me!",
				TAG_DONE);

			gimage = GlyphObject,
						IA_Width, 20,
						IA_Height, 20,
						GLYPH_Glyph, GLYPH_POPTIME,
						GlyphEnd;
			limage = LabelObject,
						IA_Font, &emerald17,
						LABEL_Text, "Created using _label.image\n",
						IA_Font, screen->Font,
						LABEL_SoftStyle, FSF_BOLD | FSF_ITALIC,
						LABEL_Image, gimage,
						IA_FGPen, 35,
						LABEL_Text, " Cool eh?",
						LabelEnd;

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 1,
				LBNA_Flags, LBFLG_HASCHILDREN | LBFLG_SHOWCHILDREN,
				LBNA_Column, 0,
					LBNCA_CopyText, TRUE,
					LBNCA_Text, "Some images",
				TAG_DONE);

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 2,
				LBNA_Column, 0,
					LBNCA_Image, limage,
				TAG_DONE);

			lbhook.h_Entry = (ULONG (*)())lb_hook;
			lbhook.h_SubEntry = NULL;
			lbhook.h_Data = NULL;

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 1,
				LBNA_Flags, LBFLG_HASCHILDREN | LBFLG_SHOWCHILDREN,
				LBNA_Column, 0,
					LBNCA_CopyText, TRUE,
					LBNCA_Text, "Rendering hook",
				TAG_DONE);

			LBAddNode(lb_gad, NULL, NULL, (struct Node *)~0,
				LBNA_Generation, 2,
				LBNA_Column, 0,
					LBNCA_RenderHook, &lbhook,
					LBNCA_HookHeight, 20,
				TAG_DONE);

			/* Create a message port for App* messages.  This is needed for
			 * iconification.  We're being a touch naughty by not checking
			 * the return code, but that just means that iconification won't
			 * work, nothing really bad will happen.
			 */
			app_port = CreateMsgPort();

			/* Create the window object.
			 */
			if (window_obj = WindowObject,
								WA_Left, 0,
								WA_Top, screen->Font->ta_YSize + 3,
								WA_CustomScreen, screen,
								WA_IDCMP, IDCMP_CLOSEWINDOW | IDCMP_REFRESHWINDOW,
								WA_Flags, WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET |
											WFLG_SIZEGADGET | WFLG_ACTIVATE | WFLG_SMART_REFRESH,
								WA_Title, "ReAction ListBrowser Example 2",
								WA_InnerWidth, 300,
								WA_InnerHeight, 200,
								WA_NewLookMenus, TRUE,
								WINDOW_ParentGroup, layout,
								WINDOW_IconifyGadget, TRUE,
								WINDOW_Icon, GetDiskObject("PROGDIR:ListBrowser2"),
								WINDOW_IconTitle, "ReAction Example",
								WINDOW_AppPort, app_port,
								TAG_DONE))
			{
				struct Window *win;

				/*  Open the window.
				 */
				if (win = (struct Window*) RA_OpenWindow(window_obj))
				{
					ULONG signal;
					BOOL ok = TRUE;

					/* Obtain the window wait signal mask.
					 */
					GetAttr(WINDOW_SigMask, window_obj, &signal);

					/* Input Event Loop
					 */
					while (ok)
					{
						ULONG result;

						Wait(signal | (1L << app_port->mp_SigBit));

						/* RA_HandleInput() returns the gadget ID of a clicked
						 * gadget, or one of several pre-defined values.  For
						 * this demo, we're only actually interested in a
						 * close window and a couple of gadget clicks.
						 */
						while ((result = RA_HandleInput(window_obj, NULL)) != WMHI_LASTMSG)
						{
							switch(result & WMHI_CLASSMASK)
							{
								case WMHI_CLOSEWINDOW:
									ok = FALSE;
									break;

								case WMHI_GADGETUP:
									switch (result & WMHI_GADGETMASK)
									{
										default:
											break;
									}
									break;

								case WMHI_ICONIFY:
									if (RA_Iconify(window_obj))
										win = NULL;
									break;
							 
								case WMHI_UNICONIFY:
									win = RA_OpenWindow(window_obj);
									break;

								default:
									break;
							}
						}
					}
 				}
				else
					PutStr("ERROR: failed to start.  Couldn't open window\n");

				/* Disposing of the window object will also close the
				 * window if it is already opened and it will dispose of
				 * all objects attached to it.
				 */
				DisposeObject(window_obj);
			}
			else
				PutStr("ERROR: failed to start.  Couldn't create window\n");

			/* Lose the App* message port.
			 */
			if (app_port)
				DeleteMsgPort(app_port);
		}
		else
			PutStr("ERROR: failed to start.  Couldn't create layout\n");

		if (drinfo)
			FreeScreenDrawInfo(screen, drinfo);

	    UnlockPubScreen(0, screen);
	}
	else
		PutStr("ERROR: failed to start.  Couldn't lock destination screen\n");

	return 0;
}

ULONG __asm __saveds lb_hook(register __a0 struct Hook *hook, register
        				__a2 struct Node *node, register __a1 struct LBDrawMsg *msg)
{
	// UWORD patterndata[2] = { 0x2222, 0x8888 };
	WORD width = msg->lbdm_Bounds.MaxX - msg->lbdm_Bounds.MinX;
	WORD height = msg->lbdm_Bounds.MaxY - msg->lbdm_Bounds.MinY;

    if(msg->lbdm_MethodID != LV_DRAW)
        return(LBCB_UNKNOWN);

	SetAPen(msg->lbdm_RastPort, 69);
	DrawEllipse(msg->lbdm_RastPort,
		msg->lbdm_Bounds.MinX + (width / 2), msg->lbdm_Bounds.MinY + (height / 2),
		width / 2, height / 2);
		
    return(LVCB_OK);
}
