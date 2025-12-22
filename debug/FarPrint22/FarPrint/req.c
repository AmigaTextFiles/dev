/* $Revision Header *** Header built automatically - do not edit! ***********
 *
 *	(C) Copyright 1992 by Torsten Jürgeleit
 *
 *	Name .....: req.c
 *	Created ..: Wednesday 12-Feb-92 21:22:57
 *	Revision .: 2
 *
 *	Date        Author                 Comment
 *	=========   ====================   ====================
 *	14-Sep-92   Torsten Jürgeleit      changed some requester flags
 *	27-Apr-92   Torsten Jürgeleit      now uses global data structure
 *	12-Feb-92   Torsten Jürgeleit      Created this file!
 *
 ****************************************************************************
 *
 *	Requesters
 *
 * $Revision Header ********************************************************/

	/* Includes */

#include "includes.h"
#include "defines.h"
#include "imports.h"
#include "protos.h"

	/* Defines for error requester */

#define ERROR_WINDOW_TITLE	" Error "

	/* Statics for error requester */

STATIC BYTE *error_text[] = {
   "Can't open arp.library v39+",
   "Can't open intuisup.library",
   "Can't open window",
   "Out of memory",
   "FarPrint already started",
   "Can't open `serial.device'",
   "Serial io failed",
   "Open save file failed",
   "Write save file failed"
};
	/* Defines for continue, ok/cancel requester */


#define AUTO_REQ_REQ_FLAGS	(AUTO_REQ_FLAG_TEXT_CENTER | AUTO_REQ_FLAG_TEXT_COLOR2 | AUTO_REQ_FLAG_HOTKEY | AUTO_REQ_FLAG_DRAW_RASTER | AUTO_REQ_FLAG_CENTER_MOUSE)

	/* Defines for about requester */

#define ABOUT_REQ_WIDTH		304
#define ABOUT_REQ_HEIGHT	131
#define ABOUT_REQ_FLAGS		(REQ_DATA_FLAG_DRAG_GADGET | REQ_DATA_FLAG_DEPTH_GADGET | REQ_DATA_FLAG_INNER_WINDOW | REQ_DATA_FLAG_DRAW_RASTER | REQ_DATA_FLAG_CENTER_WINDOW)
#define ABOUT_REQ_TITLE		" About "

#define ABOUT_TEXT1_TYPE	TEXT_DATA_TYPE_TEXT
#define ABOUT_TEXT1_FLAGS	(TEXT_DATA_FLAG_CENTER | TEXT_DATA_FLAG_BOLD)
#define ABOUT_TEXT1_LEFT_EDGE	0
#define ABOUT_TEXT1_TOP_EDGE	(ABOUT_BORDER_TOP_EDGE + 7)
#define ABOUT_TEXT1_TEXT	"FarPrint v2.2"
#define ABOUT_TEXT1_TEXT_ATTR	&topaz60_attr

#define ABOUT_TEXT2_TYPE	TEXT_DATA_TYPE_TEXT
#define ABOUT_TEXT2_FLAGS	(TEXT_DATA_FLAG_CENTER | TEXT_DATA_FLAG_COLOR2)
#define ABOUT_TEXT2_LEFT_EDGE	0
#define ABOUT_TEXT2_TOP_EDGE	(ABOUT_TEXT1_TOP_EDGE + 15)
#define ABOUT_TEXT2_TEXT	"© 09/92 by Torsten Jürgeleit    "
#define ABOUT_TEXT2_TEXT_ATTR	&topaz80_attr

#define ABOUT_TEXT3_TYPE	TEXT_DATA_TYPE_TEXT
#define ABOUT_TEXT3_FLAGS	(TEXT_DATA_FLAG_CENTER | TEXT_DATA_FLAG_COLOR2)
#define ABOUT_TEXT3_LEFT_EDGE	0
#define ABOUT_TEXT3_TOP_EDGE	(ABOUT_TEXT2_TOP_EDGE + 10)
#define ABOUT_TEXT3_TEXT	"           Am Sandberg 4        "
#define ABOUT_TEXT3_TEXT_ATTR	&topaz80_attr

#define ABOUT_TEXT4_TYPE	TEXT_DATA_TYPE_TEXT
#define ABOUT_TEXT4_FLAGS	(TEXT_DATA_FLAG_CENTER | TEXT_DATA_FLAG_COLOR2)
#define ABOUT_TEXT4_LEFT_EDGE	0
#define ABOUT_TEXT4_TOP_EDGE	(ABOUT_TEXT3_TOP_EDGE + 10)
#define ABOUT_TEXT4_TEXT	"           W-5270 Gummersbach   "
#define ABOUT_TEXT4_TEXT_ATTR	&topaz80_attr

#define ABOUT_TEXT5_TYPE	TEXT_DATA_TYPE_TEXT
#define ABOUT_TEXT5_FLAGS	(TEXT_DATA_FLAG_CENTER | TEXT_DATA_FLAG_COLOR2)
#define ABOUT_TEXT5_LEFT_EDGE	0
#define ABOUT_TEXT5_TOP_EDGE	(ABOUT_TEXT4_TOP_EDGE + 10)
#define ABOUT_TEXT5_TEXT	"           Germany              "
#define ABOUT_TEXT5_TEXT_ATTR	&topaz80_attr

#define ABOUT_TEXT6_TYPE	TEXT_DATA_TYPE_TEXT
#define ABOUT_TEXT6_FLAGS	(TEXT_DATA_FLAG_CENTER | TEXT_DATA_FLAG_COLOR2)
#define ABOUT_TEXT6_LEFT_EDGE	0
#define ABOUT_TEXT6_TOP_EDGE	(ABOUT_TEXT5_TOP_EDGE + 10)
#define ABOUT_TEXT6_TEXT	"           Phone ++49 2261 27400"
#define ABOUT_TEXT6_TEXT_ATTR	&topaz80_attr

#define ABOUT_TEXT7_TYPE	TEXT_DATA_TYPE_TEXT
#define ABOUT_TEXT7_FLAGS	TEXT_DATA_FLAG_CENTER
#define ABOUT_TEXT7_LEFT_EDGE	0
#define ABOUT_TEXT7_TOP_EDGE	(ABOUT_TEXT6_TOP_EDGE + 15)
#define ABOUT_TEXT7_TEXT	"original version of FarPrint"
#define ABOUT_TEXT7_TEXT_ATTR	&topaz80_attr

#define ABOUT_TEXT8_TYPE	TEXT_DATA_TYPE_TEXT
#define ABOUT_TEXT8_FLAGS	TEXT_DATA_FLAG_CENTER
#define ABOUT_TEXT8_LEFT_EDGE	0
#define ABOUT_TEXT8_TOP_EDGE	(ABOUT_TEXT7_TOP_EDGE + 10)
#define ABOUT_TEXT8_TEXT	"done by Olaf Barthel in 1990"
#define ABOUT_TEXT8_TEXT_ATTR	&topaz80_attr

#define ABOUT_BORDER_TYPE	BORDER_DATA_TYPE_BOX2_OUT
#define ABOUT_BORDER_LEFT_EDGE	10
#define ABOUT_BORDER_TOP_EDGE	5
#define ABOUT_BORDER_WIDTH	(ABOUT_REQ_WIDTH - 2 * ABOUT_BORDER_LEFT_EDGE)
#define ABOUT_BORDER_HEIGHT	(ABOUT_REQ_HEIGHT - (3 * ABOUT_BORDER_TOP_EDGE + ABOUT_GADGET_HEIGHT))

#define ABOUT_GADGET_TYPE	GADGET_DATA_TYPE_BUTTON
#define ABOUT_GADGET_FLAGS	GADGET_DATA_FLAG_HOTKEY
#define ABOUT_GADGET_TEXT	"_Continue"
#define ABOUT_GADGET_LEFT_EDGE	((ABOUT_REQ_WIDTH - ABOUT_GADGET_WIDTH) / 2)
#define ABOUT_GADGET_TOP_EDGE	(ABOUT_REQ_HEIGHT - ABOUT_GADGET_HEIGHT - 5)
#define ABOUT_GADGET_WIDTH	((8 + 2) * 8)
#define ABOUT_GADGET_HEIGHT	15
#define ABOUT_GADGET_TEXT_ATTR	&topaz80_attr

	/* Statics for about requester */

STATIC struct TextData  about_text_data[] = {
   {
	ABOUT_TEXT1_TYPE,	/* td_Type */
	ABOUT_TEXT1_FLAGS,	/* td_Flags */
	ABOUT_TEXT1_LEFT_EDGE,	/* td_LeftEdge */
	ABOUT_TEXT1_TOP_EDGE,	/* td_TopEdge */
	ABOUT_TEXT1_TEXT,	/* *td_Text */
	ABOUT_TEXT1_TEXT_ATTR	/* *td_TextAttr */
   }, {
	ABOUT_TEXT2_TYPE,	/* td_Type */
	ABOUT_TEXT2_FLAGS,	/* td_Flags */
	ABOUT_TEXT2_LEFT_EDGE,	/* td_LeftEdge */
	ABOUT_TEXT2_TOP_EDGE,	/* td_TopEdge */
	ABOUT_TEXT2_TEXT,	/* *td_Text */
	ABOUT_TEXT2_TEXT_ATTR	/* *td_TextAttr */
   }, {
	ABOUT_TEXT3_TYPE,	/* td_Type */
	ABOUT_TEXT3_FLAGS,	/* td_Flags */
	ABOUT_TEXT3_LEFT_EDGE,	/* td_LeftEdge */
	ABOUT_TEXT3_TOP_EDGE,	/* td_TopEdge */
	ABOUT_TEXT3_TEXT,	/* *td_Text */
	ABOUT_TEXT3_TEXT_ATTR	/* *td_TextAttr */
   }, {
	ABOUT_TEXT4_TYPE,	/* td_Type */
	ABOUT_TEXT4_FLAGS,	/* td_Flags */
	ABOUT_TEXT4_LEFT_EDGE,	/* td_LeftEdge */
	ABOUT_TEXT4_TOP_EDGE,	/* td_TopEdge */
	ABOUT_TEXT4_TEXT,	/* *td_Text */
	ABOUT_TEXT4_TEXT_ATTR	/* *td_TextAttr */
   }, {
	ABOUT_TEXT5_TYPE,	/* td_Type */
	ABOUT_TEXT5_FLAGS,	/* td_Flags */
	ABOUT_TEXT5_LEFT_EDGE,	/* td_LeftEdge */
	ABOUT_TEXT5_TOP_EDGE,	/* td_TopEdge */
	ABOUT_TEXT5_TEXT,	/* *td_Text */
	ABOUT_TEXT5_TEXT_ATTR	/* *td_TextAttr */
   }, {
	ABOUT_TEXT6_TYPE,	/* td_Type */
	ABOUT_TEXT6_FLAGS,	/* td_Flags */
	ABOUT_TEXT6_LEFT_EDGE,	/* td_LeftEdge */
	ABOUT_TEXT6_TOP_EDGE,	/* td_TopEdge */
	ABOUT_TEXT6_TEXT,	/* *td_Text */
	ABOUT_TEXT6_TEXT_ATTR	/* *td_TextAttr */
   }, {
	ABOUT_TEXT7_TYPE,	/* td_Type */
	ABOUT_TEXT7_FLAGS,	/* td_Flags */
	ABOUT_TEXT7_LEFT_EDGE,	/* td_LeftEdge */
	ABOUT_TEXT7_TOP_EDGE,	/* td_TopEdge */
	ABOUT_TEXT7_TEXT,	/* *td_Text */
	ABOUT_TEXT7_TEXT_ATTR	/* *td_TextAttr */
   }, {
	ABOUT_TEXT8_TYPE,	/* td_Type */
	ABOUT_TEXT8_FLAGS,	/* td_Flags */
	ABOUT_TEXT8_LEFT_EDGE,	/* td_LeftEdge */
	ABOUT_TEXT8_TOP_EDGE,	/* td_TopEdge */
	ABOUT_TEXT8_TEXT,	/* *td_Text */
	ABOUT_TEXT8_TEXT_ATTR	/* *td_TextAttr */
   }, {
	INTUISUP_DATA_END	/* mark end of text data array */
   }
};
STATIC struct BorderData  about_border_data[] = {
   {
	ABOUT_BORDER_TYPE,	/* bd_Type */
	ABOUT_BORDER_LEFT_EDGE,	/* bd_LeftEdge */
	ABOUT_BORDER_TOP_EDGE,	/* bd_TopEdge */
	ABOUT_BORDER_WIDTH,	/* bd_Width */
	ABOUT_BORDER_HEIGHT	/* bd_Height */
   }, {
	INTUISUP_DATA_END	/* mark end of border data array */
   }
};
STATIC struct GadgetData  about_gadget_data[] = {
   {
	ABOUT_GADGET_TYPE,	/* gd_Type */
	ABOUT_GADGET_FLAGS,	/* gd_Flags */
	ABOUT_GADGET_LEFT_EDGE,	/* gd_LeftEdge */
	ABOUT_GADGET_TOP_EDGE,	/* gd_TopEdge */
	ABOUT_GADGET_WIDTH,	/* gd_Width */
	ABOUT_GADGET_HEIGHT,	/* gd_Height */
	ABOUT_GADGET_TEXT,	/* *gd_Text */
	ABOUT_GADGET_TEXT_ATTR,	/* *gd_TextAttr */
	{ 0, 0, 0 }
   }, {
	INTUISUP_DATA_END	/* mark end of gadget data */
   }
};
STATIC struct RequesterData  about_requester_data = {
	0,			/* rd_LeftEdge */
	0,			/* rd_TopEdge */
	ABOUT_REQ_WIDTH,	/* rd_Width */
	ABOUT_REQ_HEIGHT,	/* rd_Height */
	ABOUT_REQ_FLAGS,	/* rd_Flags */
	ABOUT_REQ_TITLE,	/* *rd_Title */
	&about_text_data[0],	/* *rd_Texts */
	&about_border_data[0],	/* *rd_Borders */
	&about_gadget_data[0]	/* *rd_Gadgets */
};
	/* Show error message as continue requester */

   SHORT
show_error(struct FarData  *fd, SHORT status)
{
   if (status < STATUS_NORMAL) {
      BYTE *error = error_text[-(status + 1)];

      if (IntuiSupBase) {
	 continue_requester(fd, ERROR_WINDOW_TITLE, error);
      } else {
	 if (IntuitionBase) {
	    intuition_error_requester(error);
	 }
      }
      status = STATUS_ERROR;
   }
   return(status);
}
	/* Show IntuiSup continue requester */

   VOID
continue_requester(struct FarData  *fd, BYTE *title, BYTE *text)
{
   IAutoRequest(fd->fd_Window, title, text, "_Continue", NULL, 0L, 0L,
						  AUTO_REQ_REQ_FLAGS, NULL);
}
	/* Show Intuition error requester */

   STATIC VOID
intuition_error_requester(BYTE *text)
{
   struct Screen     screen, *scr = &screen;
   struct IntuiText  itext_error, itext_ok;
   USHORT border_left, border_top, width, height, max_width;

   /* Get screen dimension */
   GetScreenData((BYTE *)scr, (LONG)sizeof(struct Screen),
					    (LONG)WBENCHSCREEN, (LONG)NULL);
   border_left = scr->BarHeight - scr->BarVBorder + scr->WBorTop;
   border_top  = scr->WBorTop;

   /* Init message text */
   itext_error.LeftEdge  = border_left;
   itext_error.TopEdge   = border_top + 4;
   itext_error.DrawMode  = JAM1;
   itext_error.FrontPen  = 2;
   itext_error.IText     = (UBYTE *)text;
   itext_error.ITextFont = &topaz80_attr;
   itext_error.NextText  = NULL;
   max_width             = IntuiTextLength(&itext_error);

   /* Init ok text */
   itext_ok.LeftEdge  = 6;
   itext_ok.TopEdge   = 4;
   itext_ok.DrawMode  = JAM1;
   itext_ok.FrontPen  = 3;
   itext_ok.ITextFont = &topaz60_attr;
   itext_ok.IText     = (UBYTE *)"Ok";
   itext_ok.NextText  = NULL;
   if ((width = IntuiTextLength(&itext_ok) + 2 * 16) * 2 > max_width) {
      max_width = width;
   }

   /* Calc requester dimension and scale it if neccessary */
   width = max_width + border_left + scr->WBorRight + 2 * 16;
   if (width > scr->Width) {
      width = scr->Width;
   }
   height = border_top + scr->WBorBottom + 8 + 10 + 9 + 2 * 8 + 2 * 4;
   if (height > scr->Height) {
      height = scr->Height;
   }
   AutoRequest((LONG)NULL, &itext_error, &itext_ok, &itext_ok, 0L, 0L,
						 (LONG)width, (LONG)height);
}
	/* Show about requester */

   VOID
about_requester(struct FarData  *fd)
{
   APTR rl;

   if (rl = IDisplayRequester(fd->fd_Window, &about_requester_data, NULL)) {
      struct MsgPort  *up = fd->fd_Window->UserPort;
      BOOL keepon = TRUE;

      do {
	 struct IntuiMessage  *msg;

	 WaitPort(up);
	 while (msg = IGetMsg(up)) {
	    if (msg->Class == ISUP_ID) {
	       keepon = FALSE;
	    }
	    IReplyMsg(msg);
	 }
      } while (keepon == TRUE);
      IRemoveRequester(rl);
   }
}
	/* Show IntuiSup ok/cancel requester */

   BOOL
ok_cancel_requester(struct FarData  *fd, BYTE *title, BYTE *text)
{
   return(IAutoRequest(fd->fd_Window, title, text, "_Ok", "_Cancel", 0L, 0L,
						 AUTO_REQ_REQ_FLAGS, NULL));
}
