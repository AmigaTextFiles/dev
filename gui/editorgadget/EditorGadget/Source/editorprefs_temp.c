/* This file contains empty template routines that
 * the IDCMP handler will call uppon. Fill out these
 * routines with your code or use them as a reference
 * to create your program.
 */

#include <graphics/text.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <gadgets/editor.h>

#include <proto/intuition.h>
#include <proto/gadtools.h>

#include "editorprefs.h"

extern struct Window *window;
extern struct Gadget *edit_object;
extern ULONG style;
extern UWORD *pens;

int block_cursor_checkClicked( void )
{
	/* routine when gadget "Block Cursor" is clicked. */
	SetGadgetAttrs(edit_object, window, NULL,
					EDIT_BlockCursor, EditorPrefsGadgets[GDX_block_cursor_check]->Flags & GFLG_SELECTED,
					TAG_DONE);
	return TRUE;
}

int disable_checkClicked( void )
{
	/* routine when gadget "Disable" is clicked. */
	SetGadgetAttrs(edit_object, window, NULL,
					GA_Disabled, EditorPrefsGadgets[GDX_disable_check]->Flags & GFLG_SELECTED,
					TAG_DONE);
	return TRUE;
}

int no_ghost_checkClicked( void )
{
	/* routine when gadget "No Ghost" is clicked. */
	SetGadgetAttrs(edit_object, window, NULL,
					EDIT_NoGhost, EditorPrefsGadgets[GDX_no_ghost_check]->Flags & GFLG_SELECTED,
					TAG_DONE);
	return TRUE;
}

int italic_checkClicked( void )
{
	/* routine when gadget "Italic" is clicked. */
	if (EditorPrefsGadgets[GDX_italic_check]->Flags & GFLG_SELECTED) {
		style |= FSF_ITALIC;
	} else {
		style &= ~FSF_ITALIC;
	}
	SetGadgetAttrs(edit_object, window, NULL,
					EDIT_FontStyle, style,
					TAG_DONE);
	return TRUE;
}

int underline_checkClicked( void )
{
	/* routine when gadget "Underline" is clicked. */
	if (EditorPrefsGadgets[GDX_underline_check]->Flags & GFLG_SELECTED) {
		style |= FSF_UNDERLINED;
	} else {
		style &= ~FSF_UNDERLINED;
	}
	SetGadgetAttrs(edit_object, window, NULL,
					EDIT_FontStyle, style,
					TAG_DONE);
	return TRUE;
}

int bold_checkClicked( void )
{
	/* routine when gadget "Bold" is clicked. */
	if (EditorPrefsGadgets[GDX_bold_check]->Flags & GFLG_SELECTED) {
		style |= FSF_BOLD;
	} else {
		style &= ~FSF_BOLD;
	}
	SetGadgetAttrs(edit_object, window, NULL,
					EDIT_FontStyle, style,
					TAG_DONE);
	return TRUE;
}

int align_radioClicked( void )
{
	/* routine when gadget "" is clicked. */
	ULONG align;

	switch (EditorPrefsMsg.Code) {
		case 0:
			align = EDIT_ALIGN_LEFT;
			break;
		case 1:
			align = EDIT_ALIGN_CENTER;
			break;
		case 2:
			align = EDIT_ALIGN_RIGHT;
			break;
	}
	SetGadgetAttrs(edit_object, window, NULL,
					EDIT_Alignment, align,
					TAG_DONE);
	return TRUE;
}

int vcenter_checkClicked( void )
{
	/* routine when gadget "Vertical Centering" is clicked. */
	SetGadgetAttrs(edit_object, window, NULL,
					EDIT_VCenter, EditorPrefsGadgets[GDX_vcenter_check]->Flags & GFLG_SELECTED,
					TAG_DONE);
	return TRUE;
}

int ruled_paper_checkClicked( void )
{
	/* routine when gadget "Ruled Paper" is clicked. */
	SetGadgetAttrs(edit_object, window, NULL,
					EDIT_RuledPaper, EditorPrefsGadgets[GDX_ruled_paper_check]->Flags & GFLG_SELECTED,
					TAG_DONE);
	return TRUE;
}

int spacing_sliderClicked( void )
{
	/* routine when gadget "Spacing:" is clicked. */
	SetGadgetAttrs(edit_object, window, NULL,
					EDIT_Spacing, EditorPrefsMsg.Code,
					TAG_DONE);
	return TRUE;
}

int blink_radioClicked( void )
{
	/* routine when gadget "" is clicked. */
	ULONG blink;

	switch (EditorPrefsMsg.Code) {
		case 0:
			blink = 0;
			break;
		case 1:
			blink = 750000;
			break;
		case 2:
			blink = 500000;
			break;
		case 3:
			blink = 250000;
			break;
	}
	SetGadgetAttrs(edit_object, window, NULL,
					EDIT_BlinkRate, blink,
					TAG_DONE);
	return TRUE;
}

int border_radioClicked( void )
{
	/* routine when gadget "" is clicked. */
	ULONG border;

	switch (EditorPrefsMsg.Code) {
		case 0:
			border = EDIT_BORDER_NONE;
			break;
		case 1:
			border = EDIT_BORDER_BEVEL;
			break;
		case 2:
			border = EDIT_BORDER_DOUBLEBEVEL;
			break;
	}
	SetGadgetAttrs(edit_object, window, NULL,
					EDIT_Border, border,
					TAG_DONE);
	return TRUE;
}

int invert_checkClicked( void )
{
	/* routine when gadget "Inverted" is clicked. */
	SetGadgetAttrs(edit_object, window, NULL,
					EDIT_Inverted, EditorPrefsGadgets[GDX_invert_check]->Flags & GFLG_SELECTED,
					TAG_DONE);
	return TRUE;
}

int partial_checkClicked( void )
{
	/* routine when gadget "Partial" is clicked. */
	SetGadgetAttrs(edit_object, window, NULL,
					EDIT_Partial, EditorPrefsGadgets[GDX_partial_check]->Flags & GFLG_SELECTED,
					TAG_DONE);
	return TRUE;
}

int notepad_checkClicked( void )
{
	/* routine when gadget "Block Cursor" is clicked. */
	if (EditorPrefsGadgets[GDX_notepad_check]->Flags & GFLG_SELECTED) {
		SetGadgetAttrs(edit_object, window, NULL,
						EDIT_PaperPen,	pens[SHINEPEN],
						EDIT_LinePen,	pens[FILLPEN],
						TAG_DONE);
	} else {
		SetGadgetAttrs(edit_object, window, NULL,
						EDIT_PaperPen,	-1,
						EDIT_LinePen,	-1,
						TAG_DONE);
	}
	return TRUE;
}
