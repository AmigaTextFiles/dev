/*
 * editor.h
 *
 * Copyright © 1994 Mark Thomas
 *
 * Defines for the BOOPSI editor.gadget V1.
 */

#ifndef EDITORGADGET_H
#define EDITORGADGET_H

#include <utility/tagitem.h>

#define EDIT_TAG_BASE (TAG_USER + 0x04000000)

#define EDIT_Text         (EDIT_TAG_BASE + 1)
#define EDIT_InsertText   (EDIT_TAG_BASE + 2)
#define EDIT_TextFont     (EDIT_TAG_BASE + 3)
#define EDIT_Delimiters   (EDIT_TAG_BASE + 4)
#define EDIT_Top          (EDIT_TAG_BASE + 5)
#define EDIT_BlockCursor  (EDIT_TAG_BASE + 6)
#define EDIT_Size         (EDIT_TAG_BASE + 7)
#define EDIT_Visible      (EDIT_TAG_BASE + 8)
#define EDIT_Lines        (EDIT_TAG_BASE + 9)
#define EDIT_NoGhost      (EDIT_TAG_BASE + 10)
#define EDIT_MaxSize      (EDIT_TAG_BASE + 11)
#define EDIT_Border       (EDIT_TAG_BASE + 12)
#define EDIT_TextAttr     (EDIT_TAG_BASE + 13)
#define EDIT_FontStyle    (EDIT_TAG_BASE + 14)
#define EDIT_Up           (EDIT_TAG_BASE + 15)
#define EDIT_Down         (EDIT_TAG_BASE + 16)
#define EDIT_Alignment    (EDIT_TAG_BASE + 17)
#define EDIT_VCenter      (EDIT_TAG_BASE + 18)
#define EDIT_RuledPaper   (EDIT_TAG_BASE + 19)
#define EDIT_PaperPen     (EDIT_TAG_BASE + 20)
#define EDIT_InkPen       (EDIT_TAG_BASE + 21)
#define EDIT_LinePen      (EDIT_TAG_BASE + 22)
#define EDIT_UserAlign    (EDIT_TAG_BASE + 23)
#define EDIT_Spacing      (EDIT_TAG_BASE + 24)
#define EDIT_ClipStream   (EDIT_TAG_BASE + 25)
#define EDIT_ClipStream2  (EDIT_TAG_BASE + 26)
#define EDIT_BlinkRate    (EDIT_TAG_BASE + 27)
#define EDIT_Inverted     (EDIT_TAG_BASE + 28)
#define EDIT_Partial      (EDIT_TAG_BASE + 29)
#define EDIT_CursorPos    (EDIT_TAG_BASE + 30)

/*
 * EDIT_Border
 *
 * See docs for width and height sizes these borders are
 */

#define EDIT_BORDER_NONE              0
#define EDIT_BORDER_BEVEL             1
#define EDIT_BORDER_DOUBLEBEVEL       2

/*
 * EDIT_Alignment
 */

#define EDIT_ALIGN_LEFT             0
#define EDIT_ALIGN_CENTER           1
#define EDIT_ALIGN_RIGHT            2

#endif
