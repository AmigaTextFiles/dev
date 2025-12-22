/* This file contains empty template routines that
 * the IDCMP handler will call uppon. Fill out these
 * routines with your code or use them as a reference
 * to create your program.
 */

#include <graphics/text.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <gadgets/textfield.h>

#include <proto/intuition.h>
#include <proto/gadtools.h>

#include "prefs.h"

extern struct Window *window;
extern struct Gadget *text1_object;
extern ULONG style;
extern UWORD *pens;

int block_cursor_checkClicked( void )
{
	/* routine when gadget "Block Cursor" is clicked. */
	SetGadgetAttrs(text1_object, window, NULL,
					TEXTFIELD_BlockCursor, TextFieldPrefsGadgets[GDX_block_cursor_check]->Flags & GFLG_SELECTED,
					TAG_DONE);
	return TRUE;
}

int disable_checkClicked( void )
{
	/* routine when gadget "Disable" is clicked. */
	SetGadgetAttrs(text1_object, window, NULL,
					GA_Disabled, TextFieldPrefsGadgets[GDX_disable_check]->Flags & GFLG_SELECTED,
					TAG_DONE);
	return TRUE;
}

int no_ghost_checkClicked( void )
{
	/* routine when gadget "No Ghost" is clicked. */
	SetGadgetAttrs(text1_object, window, NULL,
					TEXTFIELD_NoGhost, TextFieldPrefsGadgets[GDX_no_ghost_check]->Flags & GFLG_SELECTED,
					TAG_DONE);
	return TRUE;
}

int readonly_checkClicked( void )
{
	/* routine when gadget "Read Only" is clicked. */
	SetGadgetAttrs(text1_object, window, NULL,
					TEXTFIELD_ReadOnly, TextFieldPrefsGadgets[GDX_readonly_check]->Flags & GFLG_SELECTED,
					TAG_DONE);
	return TRUE;
}

int italic_checkClicked( void )
{
	/* routine when gadget "Italic" is clicked. */
	if (TextFieldPrefsGadgets[GDX_italic_check]->Flags & GFLG_SELECTED) {
		style |= FSF_ITALIC;
	} else {
		style &= ~FSF_ITALIC;
	}
	SetGadgetAttrs(text1_object, window, NULL,
					TEXTFIELD_FontStyle, style,
					TAG_DONE);
	return TRUE;
}

int underline_checkClicked( void )
{
	/* routine when gadget "Underline" is clicked. */
	if (TextFieldPrefsGadgets[GDX_underline_check]->Flags & GFLG_SELECTED) {
		style |= FSF_UNDERLINED;
	} else {
		style &= ~FSF_UNDERLINED;
	}
	SetGadgetAttrs(text1_object, window, NULL,
					TEXTFIELD_FontStyle, style,
					TAG_DONE);
	return TRUE;
}

int bold_checkClicked( void )
{
	/* routine when gadget "Bold" is clicked. */
	if (TextFieldPrefsGadgets[GDX_bold_check]->Flags & GFLG_SELECTED) {
		style |= FSF_BOLD;
	} else {
		style &= ~FSF_BOLD;
	}
	SetGadgetAttrs(text1_object, window, NULL,
					TEXTFIELD_FontStyle, style,
					TAG_DONE);
	return TRUE;
}

int align_radioClicked( void )
{
	/* routine when gadget "" is clicked. */
	ULONG align;

	switch (TextFieldPrefsMsg.Code) {
		case 0:
			align = TEXTFIELD_ALIGN_LEFT;
			break;
		case 1:
			align = TEXTFIELD_ALIGN_CENTER;
			break;
		case 2:
			align = TEXTFIELD_ALIGN_RIGHT;
			break;
	}
	SetGadgetAttrs(text1_object, window, NULL,
					TEXTFIELD_Alignment, align,
					TAG_DONE);
	return TRUE;
}

int vcenter_checkClicked( void )
{
	/* routine when gadget "Vertical Centering" is clicked. */
	SetGadgetAttrs(text1_object, window, NULL,
					TEXTFIELD_VCenter, TextFieldPrefsGadgets[GDX_vcenter_check]->Flags & GFLG_SELECTED,
					TAG_DONE);
	return TRUE;
}

int ruled_paper_checkClicked( void )
{
	/* routine when gadget "Ruled Paper" is clicked. */
	SetGadgetAttrs(text1_object, window, NULL,
					TEXTFIELD_RuledPaper, TextFieldPrefsGadgets[GDX_ruled_paper_check]->Flags & GFLG_SELECTED,
					TAG_DONE);
	return TRUE;
}

int spacing_sliderClicked( void )
{
	/* routine when gadget "Spacing:" is clicked. */
	SetGadgetAttrs(text1_object, window, NULL,
					TEXTFIELD_Spacing, TextFieldPrefsMsg.Code,
					TAG_DONE);
	return TRUE;
}

int blink_radioClicked( void )
{
	/* routine when gadget "" is clicked. */
	ULONG blink;

	switch (TextFieldPrefsMsg.Code) {
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
	SetGadgetAttrs(text1_object, window, NULL,
					TEXTFIELD_BlinkRate, blink,
					TAG_DONE);
	return TRUE;
}

int border_radioClicked( void )
{
	/* routine when gadget "" is clicked. */
	ULONG border;

	switch (TextFieldPrefsMsg.Code) {
		case 0:
			border = TEXTFIELD_BORDER_NONE;
			break;
		case 1:
			border = TEXTFIELD_BORDER_BEVEL;
			break;
		case 2:
			border = TEXTFIELD_BORDER_DOUBLEBEVEL;
			break;
	}
	SetGadgetAttrs(text1_object, window, NULL,
					TEXTFIELD_Border, border,
					TAG_DONE);
	return TRUE;
}

int invert_checkClicked( void )
{
	/* routine when gadget "Inverted" is clicked. */
	SetGadgetAttrs(text1_object, window, NULL,
					TEXTFIELD_Inverted, TextFieldPrefsGadgets[GDX_invert_check]->Flags & GFLG_SELECTED,
					TAG_DONE);
	return TRUE;
}

int partial_checkClicked( void )
{
	/* routine when gadget "Partial" is clicked. */
	SetGadgetAttrs(text1_object, window, NULL,
					TEXTFIELD_Partial, TextFieldPrefsGadgets[GDX_partial_check]->Flags & GFLG_SELECTED,
					TAG_DONE);
	return TRUE;
}

int notepad_checkClicked( void )
{
	/* routine when gadget "Block Cursor" is clicked. */
	if (TextFieldPrefsGadgets[GDX_notepad_check]->Flags & GFLG_SELECTED) {
		SetGadgetAttrs(text1_object, window, NULL,
						TEXTFIELD_PaperPen,	pens[SHINEPEN],
						TEXTFIELD_LinePen,	pens[FILLPEN],
						TAG_DONE);
	} else {
		SetGadgetAttrs(text1_object, window, NULL,
						TEXTFIELD_PaperPen,	-1,
						TEXTFIELD_LinePen,	-1,
						TAG_DONE);
	}
	return TRUE;
}
