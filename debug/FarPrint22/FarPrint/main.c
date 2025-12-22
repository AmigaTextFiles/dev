/* $Revision Header *** Header built automatically - do not edit! ***********
 *
 *	(C) Copyright 1992 by Torsten Jürgeleit
 *
 *	Name .....: main.c
 *	Created ..: Wednesday 12-Feb-92 20:29:51
 *	Revision .: 3
 *
 *	Date        Author                 Comment
 *	=========   ====================   ====================
 *	16-Sep-92   Torsten Jürgeleit      list of listview gadget now
 *					   removed in free_text_list()
 *					   BEFORE freeing list entries
 *	14-Sep-92   Torsten Jürgeleit      calc num of lines in listview and
 *					   environment variable functions
 *	27-Apr-92   Torsten Jürgeleit      introduce global data structure
 *					   and serial io
 *	12-Feb-92   Torsten Jürgeleit      Created this file !
 ****************************************************************************
 *
 *	FarPrint ------	Debugging functions for programs which don't
 *			have links to their environment.
 *
 *			FarPrint 'harbour' to receive and distribute
 *			all incoming messages.
 *
 *	Author of the
 *	Original ------	Olaf Barthel of MXM
 *			Brabeckstrasse 35
 *			W-3000 Hannover 71
 *
 *			Federal Republic of Germany.
 *
 *	New version
 *	done by -------	Torsten Jürgeleit
 *			Am Sandberg 4
 *			W-5270 Gummersbach
 *
 *			Federal Republic of Germany.
 *
 * $Revision Header ********************************************************/

	/* Includes */

#include "includes.h"
#include "defines.h"
#include "imports.h"
#include "protos.h"

	/* Globals */

struct Library   *IntuiSupBase = NULL;   /* Clear for show_error() */

struct TextAttr  topaz60_attr = { (STRPTR)"topaz.font", TOPAZ_SIXTY,
						   FS_NORMAL, FPF_ROMFONT },
		 topaz80_attr = { (STRPTR)"topaz.font", TOPAZ_EIGHTY,
						   FS_NORMAL, FPF_ROMFONT };
	/* Globals needed for detach */

BYTE *_procname = PROCESS_NAME;
LONG _stack = PROCESS_STACK,
     _priority = PROCESS_PRIORITY,
     _BackGroundIO = PROCESS_BACKGROUND_IO;

	/* Statics */

STATIC struct NewWindow  new_window = {
   WINDOW_LEFT, WINDOW_TOP, WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_DETAIL_PEN,
   WINDOW_BLOCK_PEN, WINDOW_IDCMP, WINDOW_FLAGS, NULL, NULL, WINDOW_TITLE,
   NULL, NULL, MIN_WINDOW_WIDTH, MIN_WINDOW_HEIGHT, -1, -1, WBENCHSCREEN
};
	/* Defines for gadgets */

#define GADGET1_TYPE		GADGET_DATA_TYPE_LISTVIEW
#define GADGET1_FLAGS		GADGET_DATA_FLAG_LISTVIEW_READ_ONLY
#define GADGET1_LEFT_EDGE	20
#define GADGET1_TOP_EDGE	16
#define GADGET1_WIDTH		(WINDOW_WIDTH - 2 * GADGET1_LEFT_EDGE)
#define GADGET1_HEIGHT		(WINDOW_HEIGHT - GADGET1_TOP_EDGE - 45)
#define GADGET1_TEXT		"Messages"
#define GADGET1_TEXT_ATTR	&topaz80_attr
#define GADGET1_SPACING		0
#define GADGET1_TOP		0
#define GADGET1_LIST		NULL

#define GADGET2_TYPE		GADGET_DATA_TYPE_STRING
#define GADGET2_FLAGS		(GADGET_DATA_FLAG_HOTKEY | GADGET_DATA_FLAG_TEXT_LEFT)
#define GADGET2_LEFT_EDGE	(20 + (5 + 1) * 8)
#define GADGET2_TOP_EDGE	(WINDOW_HEIGHT - 32)
#define GADGET2_WIDTH		(WINDOW_WIDTH - GADGET2_LEFT_EDGE - 20)
#define GADGET2_HEIGHT		0
#define GADGET2_TEXT		"_Input"
#define GADGET2_TEXT_ATTR	&topaz80_attr
#define GADGET2_INPUT_LEN	MAX_INPUT_LENGTH
#define GADGET2_AUTO_ACTIVATE	0
#define GADGET2_INPUT_DEFAULT	NULL

#define GADGET3_TYPE		GADGET_DATA_TYPE_CHECK
#define GADGET3_FLAGS		(GADGET_DATA_FLAG_HOTKEY | GADGET_DATA_FLAG_TEXT_RIGHT)
#define GADGET3_LEFT_EDGE	20
#define GADGET3_TOP_EDGE	(WINDOW_HEIGHT - 15)
#define GADGET3_WIDTH		0
#define GADGET3_HEIGHT		0
#define GADGET3_TEXT		"_Stop"
#define GADGET3_TEXT_ATTR	&topaz80_attr

#define GADGET4_TYPE		GADGET_DATA_TYPE_CHECK
#define GADGET4_FLAGS		(GADGET_DATA_FLAG_HOTKEY | GADGET_DATA_FLAG_TEXT_LEFT)
#define GADGET4_LEFT_EDGE	(WINDOW_WIDTH - GADGET3_LEFT_EDGE - 21)
#define GADGET4_TOP_EDGE	GADGET3_TOP_EDGE
#define GADGET4_WIDTH		0
#define GADGET4_HEIGHT		0
#define GADGET4_TEXT		"_Refresh"
#define GADGET4_TEXT_ATTR	GADGET3_TEXT_ATTR

	/* Statics for gadgets */

STATIC struct GadgetData  gadget_data[] = {
   {
	GADGET1_TYPE,		/* gd_Type */
	GADGET1_FLAGS,		/* gd_Flags */
	GADGET1_LEFT_EDGE,	/* gd_LeftEdge */
	GADGET1_TOP_EDGE,	/* gd_TopEdge */
	GADGET1_WIDTH,		/* gd_Width */
	GADGET1_HEIGHT,		/* gd_Height */
	GADGET1_TEXT,		/* *gd_Text */
	GADGET1_TEXT_ATTR,	/* *gd_TextAttr */
	{
	GADGET1_SPACING,	/* gd_ListViewSpacing */
	GADGET1_TOP,		/* gd_ListViewTop */
	GADGET1_LIST		/* gd_ListViewList */
	}
   }, {
	GADGET2_TYPE,		/* gd_Type */
	GADGET2_FLAGS,		/* gd_Flags */
	GADGET2_LEFT_EDGE,	/* gd_LeftEdge */
	GADGET2_TOP_EDGE,	/* gd_TopEdge */
	GADGET2_WIDTH,		/* gd_Width */
	GADGET2_HEIGHT,		/* gd_Height */
	GADGET2_TEXT,		/* *gd_Text */
	GADGET2_TEXT_ATTR,	/* *gd_TextAttr */
	{
	GADGET2_INPUT_LEN,	/* gd_InputLen */
	GADGET2_AUTO_ACTIVATE,	/* gd_InputActivatePrev/Next */
	GADGET2_INPUT_DEFAULT	/* gd_InputDefault */
	}
   }, {
	GADGET3_TYPE,		/* gd_Type */
	GADGET3_FLAGS,		/* gd_Flags */
	GADGET3_LEFT_EDGE,	/* gd_LeftEdge */
	GADGET3_TOP_EDGE,	/* gd_TopEdge */
	GADGET3_WIDTH,		/* gd_Width */
	GADGET3_HEIGHT,		/* gd_Height */
	GADGET3_TEXT,		/* *gd_Text */
	GADGET3_TEXT_ATTR,	/* *gd_TextAttr */
	{ 0, 0, 0 }
   }, {
	GADGET4_TYPE,		/* gd_Type */
	GADGET4_FLAGS,		/* gd_Flags */
	GADGET4_LEFT_EDGE,	/* gd_LeftEdge */
	GADGET4_TOP_EDGE,	/* gd_TopEdge */
	GADGET4_WIDTH,		/* gd_Width */
	GADGET4_HEIGHT,		/* gd_Height */
	GADGET4_TEXT,		/* *gd_Text */
	GADGET4_TEXT_ATTR,	/* *gd_TextAttr */
	{ 0, 0, 0 }
   }, {
	INTUISUP_DATA_END	/* mark end of gadget data array */
   }
};
	/* Statics for menu */

STATIC struct MenuData  menu_data[] = {
   {
	MENU_DATA_TYPE_TITLE, 0, "Project"
   }, {
	   MENU_DATA_TYPE_ITEM, MENU_DATA_FLAG_ATTRIBUTE, "Serial", "E", 0
   }, {
	   MENU_DATA_TYPE_ITEM, 0, "Flush", "F", 0
   }, {
	   MENU_DATA_TYPE_ITEM, 0, "Clear", "C", 0
   }, {
	   MENU_DATA_TYPE_ITEM, 0, "Mark", "M", 0
   }, {
	   MENU_DATA_TYPE_ITEM, 0, "Save", "S", 0
   }, {
	   MENU_DATA_TYPE_ITEM, 0, "About", "A", 0
   }, {
	   MENU_DATA_TYPE_ITEM, MENU_DATA_FLAG_EMPTY_LINE, "Quit", "Q", 0
   }, {
	INTUISUP_DATA_END	/* mark end of menu data */
   }
};
	/* Some stubs, we don't need these routines */

VOID _cli_parse(VOID) {}
VOID _wb_parse(VOID) {}

	/* Main routine */

   LONG
main(VOID)
{
   struct FarData  *fd;
   LONG  return_code = RETURN_ERROR;
   SHORT status = STATUS_NORMAL;

   /* First create and init global data struct */
   if (!(fd = AllocMem((LONG)sizeof(struct FarData), (LONG)MEMF_PUBLIC))) {
      show_error(NULL, ERROR_OUT_OF_MEM);
   } else {
      fd->fd_InputFarMessage = NULL;
      fd->fd_Window          = NULL;
      fd->fd_GadgetList      = NULL;
      fd->fd_NumFarMessages  = 0L;
      fd->fd_TopFarMessage   = 0L;
      NewList((struct List *)&fd->fd_FarMessageList);

      /* Now open libraries */
      if (!(IntuiSupBase = OpenLibrary(IntuiSupName, IntuiSupVersion))) {
	 show_error(fd, ERROR_NO_INTUISUP);
      } else {

	 /* First check if FarPrint already started */
	 if (FindPort(FARPRINT_PORT_NAME)) {
	    status = ERROR_FARPRINT_ALREADY_STARTED;
	 } else {

	    /* Get some resources */
	    status = init_resources(fd);
	 }

	 /* Show error before closing IntuiSup and prepare return code */
	 if (show_error(fd, status) == STATUS_NORMAL) {
	    return_code = RETURN_OK;
	 }
	 CloseLibrary(IntuiSupBase);
      }
      FreeMem(fd, (LONG)sizeof(struct FarData));
   }
   return(return_code);
}
	/* Init resources */

   STATIC SHORT
init_resources(struct FarData  *fd)
{
   SHORT status = STATUS_NORMAL;

   if (!(fd->fd_FarPort = CreatePort(FARPRINT_PORT_NAME, 0L))) {
      status = ERROR_OUT_OF_MEM;
   } else {
      if (!(fd->fd_SerPort = CreatePort(NULL, 0L))) {
	 status = ERROR_OUT_OF_MEM;
      } else {
	 if (!(fd->fd_SerReq = (struct IOExtSer *)CreateExtIO(fd->fd_SerPort,
					  (LONG)sizeof(struct IOExtSer)))) {
	    status = ERROR_OUT_OF_MEM;
	 } else {
	    if (!(fd->fd_RenderInfo = IGetRenderInfo(NULL,
						      RENDER_INFO_FLAGS))) {
	       status = ERROR_OUT_OF_MEM;
	    } else {
	       read_environment_var(fd, &new_window);
	       if (!(fd->fd_Window = IOpenWindow(fd->fd_RenderInfo,
					 &new_window, OPEN_WINDOW_FLAGS))) {
		  status = ERROR_NO_WINDOW;
	       } else {
		  if (!(fd->fd_MenuList = ICreateMenu(fd->fd_RenderInfo,
					       fd->fd_Window, &menu_data[0],
						   MENU_TEXT_ATTR, NULL))) {
		     status = ERROR_OUT_OF_MEM;
		  } else {

		     /* Alloc and init ARP file requester */
		     if (!(fd->fd_FileRequester = ArpAllocFreq())) {
			status = ERROR_OUT_OF_MEM;
		     } else {
			fd->fd_FileRequester->fr_FuncFlags |= FRF_DoColor;
			fd->fd_FileRequester->fr_Flags2    |= FR2F_LongPath;
			fd->fd_FileRequester->fr_Hail       = " Save text "
								    "list ";
			/* Attach menu and call display function */
			IAttachMenu(fd->fd_Window, fd->fd_MenuList);

			status = action_loop(fd);

			write_environment_var(fd, fd->fd_Window);
			IRemoveMenu(fd->fd_MenuList);
			free_text_list(fd);
		     }
		     IFreeMenu(fd->fd_MenuList);
		     fd->fd_MenuList = NULL;
		  }
		  ICloseWindow(fd->fd_Window, FALSE);
		  fd->fd_Window = NULL;
	       }
	       IFreeRenderInfo(fd->fd_RenderInfo);
	       fd->fd_RenderInfo = NULL;
	    }

	    /* Aborting any pending serial io and delete request + port */
	    close_serial(fd);
	    DeleteExtIO((struct IORequest *)fd->fd_SerReq);
	    fd->fd_SerReq = NULL;
	 }
	 DeletePort(fd->fd_SerPort);
	 fd->fd_SerPort = NULL;
      }

      /* Flushing FarMessages and delete FarPort */
      if (fd->fd_InputFarMessage) {
	 delete_message(fd->fd_InputFarMessage);
	 fd->fd_InputFarMessage = NULL;
      }
      RemPort(fd->fd_FarPort);
      flush_messages(fd);
      DeletePort(fd->fd_FarPort);
      fd->fd_FarPort = NULL;
   }
   return(show_error(fd, status));
}
	/* Action loop */

   STATIC SHORT
action_loop(struct FarData  *fd)
{
   struct Window   *win = fd->fd_Window;
   APTR  ri = fd->fd_RenderInfo;
   LONG  sig_mask = (1L << fd->fd_FarPort->mp_SigBit) |
		    (1L << fd->fd_SerPort->mp_SigBit) |
		    (1L << win->UserPort->mp_SigBit);
   SHORT status = STATUS_NORMAL;

   /* Start serial read */
   if (fd->fd_Flags & FARPRINT_FLAG_SERIAL) {
      SendIO((struct IORequest *)fd->fd_SerReq);
   }

   /* Main loop */
   do {
      if ((status = create_gadgets(fd)) == STATUS_NORMAL) {

	 /* Display gadgets, print request message and activate input gadget */
	 IDisplayGadgets(win, fd->fd_GadgetList);
	 if (!fd->fd_InputFarMessage) {
	   IPrintText(ri, win, "- No pending requests -",
			  REQ_MSG_LEFT_EDGE, REQ_MSG_TOP_EDGE, REQ_MSG_TYPE,
					  REQ_MSG_FLAGS, REQ_MSG_TEXT_ATTR);
	 } else {
	   IPrintText(ri, win, fd->fd_InputFarMessage->fm_Identifier,
			  REQ_MSG_LEFT_EDGE, REQ_MSG_TOP_EDGE, REQ_MSG_TYPE,
					  REQ_MSG_FLAGS, REQ_MSG_TEXT_ATTR);
	   ScreenToFront(fd->fd_Window->WScreen);
	   WindowToFront(fd->fd_Window);
	   IActivateInputGadget(fd->fd_GadgetList, GADGET_INPUT);
	 }

	 /* Resize loop */
	 do {
	    struct IntuiMessage  *im;
	    struct FarMessage    *fm;

	    /* Wait for message from window, FarPort or serial port */
	    Wait(sig_mask);

	    /* Message loop */
	    do {

	       /* Get message from window user port */
	       if (im = IGetMsg(win->UserPort)) {
		  status = perform_intuition_message(fd, im);
		  IReplyMsg(im);
	       }

	       /* Get serial request */
	       if (status == STATUS_NORMAL &&
				    (fd->fd_Flags & FARPRINT_FLAG_SERIAL) &&
				  !(fd->fd_Flags & FARPRINT_FLAG_STOPPED)) {
		  struct IOExtSer  *sio = fd->fd_SerReq;

		  if (CheckIO((struct IORequest *)sio)) {
		     Remove((struct Node *)sio);
		     status = perform_serial_request(fd, sio);
		     SendIO((struct IORequest *)sio);
		  }
	       }

	       /* Get message from FarPrint port */
	       if (status != STATUS_NORMAL || fd->fd_InputFarMessage ||
				   (fd->fd_Flags & FARPRINT_FLAG_STOPPED)) {
		  fm = NULL;
	       } else {
		  if (fm = (struct FarMessage *)GetMsg(fd->fd_FarPort)) {
		     status = perform_far_message(fd, fm);
		     if (fm->fm_Command == FM_ADDTXT) {
			delete_message(fm);
		     }
		  }
	       }
	    } while (status == STATUS_NORMAL &&
		   (im || (!(fd->fd_Flags & FARPRINT_FLAG_STOPPED) && fm)));
	 } while (status == STATUS_NORMAL);

	 /* Before removing gadget list save current listview top value */
	 fd->fd_TopFarMessage = ISetGadgetAttributes(fd->fd_GadgetList,
				     GADGET_LIST, 0L, 0L, USE_CURRENT_VALUE,
			      USE_CURRENT_VALUE, (VOID *)USE_CURRENT_VALUE);
	 IRemoveGadgets(fd->fd_GadgetList);
	 IFreeGadgets(fd->fd_GadgetList);

	 /* Check status */
	 switch (status) {
	    case STATUS_RESIZE :
	    case STATUS_ERROR :
	       status = STATUS_NORMAL;
	       break;

	    case STATUS_QUIT :
	       if (ok_cancel_requester(fd, " Quit ",
				  "Do you really want to quit?") == FALSE) {
		  status = STATUS_NORMAL;
	       }
	       break;
	 }
      }
   } while (status == STATUS_NORMAL);
   return(status);
}
	/* Create gadget list with new sizes needed for current window */

   STATIC SHORT
create_gadgets(struct FarData  *fd)
{
   struct Window      *win = fd->fd_Window;
   struct GadgetData  *gd, *gd_ptr = &gadget_data[0];
   SHORT i, deltax, deltay, status = STATUS_NORMAL;

   /* If no gadget list exists then calc initial window dimension */
   if (!fd->fd_GadgetList) {
      struct Screen  *scr = win->WScreen;

      fd->fd_Width  = WINDOW_WIDTH + scr->WBorLeft + scr->WBorRight;
      fd->fd_Height = WINDOW_HEIGHT + (scr->BarHeight - scr->BarVBorder +
					    scr->WBorTop) + scr->WBorBottom;
   }

   /* Now calc differences to default window */
   deltax = win->Width - fd->fd_Width;
   deltay = win->Height - fd->fd_Height;

   /* Change gadget data according to new size */
   for (i = 0, gd = gd_ptr; gd->gd_Type != INTUISUP_DATA_END; i++, gd++) {
      switch (i) {
	 case GADGET_LIST :
	    gd->gd_Width  += deltax;
	    gd->gd_Height += deltay;
	    break;

	 case GADGET_INPUT :
	    gd->gd_Width += deltax;

	 case GADGET_STOP :
	    gd->gd_TopEdge += deltay;
	    break;

	 case GADGET_REFRESH :
	    gd->gd_LeftEdge += deltax;
	    gd->gd_TopEdge  += deltay;
	    break;
      }
   }

   /* Save new window size */
   fd->fd_Width  += deltax;
   fd->fd_Height += deltay;

   /* If gadget list exists then clear window */
   if (fd->fd_GadgetList) {
      IClearWindow(fd->fd_RenderInfo, win, 0, 0, -1, -1, 0);
      RefreshWindowFrame(win);
   }

   /* Modify gadget data according to pending far request and far flags */
   gd = gd_ptr + GADGET_LIST;
   gd->gd_SpecialData.gd_ListViewData.gd_ListViewTop  = fd->fd_TopFarMessage;
   gd->gd_SpecialData.gd_ListViewData.gd_ListViewList = (struct List *)
						     &fd->fd_FarMessageList;
   gd = gd_ptr + GADGET_INPUT;
   if (!fd->fd_InputFarMessage) {
      gd->gd_Type   = GADGET_DATA_TYPE_STRING;
      gd->gd_Flags |= GADGET_DATA_FLAG_DISABLED;
   } else {
      gd->gd_Type   = (fd->fd_InputFarMessage->fm_Command == FM_REQNUM ?
			GADGET_DATA_TYPE_INTEGER : GADGET_DATA_TYPE_STRING);
      gd->gd_Flags &= ~GADGET_DATA_FLAG_DISABLED;
   }

   gd = gd_ptr + GADGET_STOP;
   gd->gd_SpecialData.gd_CheckData.gd_CheckSelected =
				     (fd->fd_Flags & FARPRINT_FLAG_STOPPED);
   gd = gd_ptr + GADGET_REFRESH;
   gd->gd_SpecialData.gd_CheckData.gd_CheckSelected =
				     (fd->fd_Flags & FARPRINT_FLAG_REFRESH);
   if (!(fd->fd_GadgetList = ICreateGadgets(fd->fd_RenderInfo, gd_ptr, 0, 0,
								   NULL))) {
      status = ERROR_OUT_OF_MEM;
   } else {
      struct Gadget  *gad = IGadgetAddress(fd->fd_GadgetList, GADGET_LIST);
      USHORT *dim = (USHORT *)(gad + 1);

      /* Get num of lines in listview gadgets */
      fd->fd_ListViewLines = (*(dim + 1) - 2 * 2) >> 3;
   }
   return(status);
}
	/* Read environment variable and change NewWindow structure */

   STATIC VOID
read_environment_var(struct FarData  *fd, struct NewWindow  *nw)
{
   struct Process  *pr = (struct Process *)FindTask(NULL);
   APTR old_win = pr->pr_WindowPtr;
   BPTR fh;

   /* First set default values */
   fd->fd_Flags = DEFAULT_FARPRINT_FLAGS;

   /* Open env var without AmigaDOS requester */
   pr->pr_WindowPtr = (APTR)-1L;
   if (fh = Open(FARPRINT_ENV_NAME, (LONG)MODE_OLDFILE)) {
      LONG len;

      /* Get length of file */
      if (Seek(fh, 0L, (LONG)OFFSET_END) != -1L) {
	 if ((len = Seek(fh, 0L, (LONG)OFFSET_BEGINNING)) != -1L) {
	    BYTE *buffer;

	    /*
	     * Alloc buffer and read file into it - one additional byte
	     * needed for end of string
	     */
	    if (buffer = AllocMem(len + 1, MEMF_PUBLIC)) {
	       if (Read(fh, buffer, len) == len) {
		  STATIC BYTE *template  = "LeftEdge/K,TopEdge/K,Width/K,"
					   "Height/K,STOPPED/S,REFRESH/S";
		  BYTE   *argv[MAX_ARGUMENTS];
		  USHORT i;

		  /* Clear argument array */
		  for (i = 0; i < MAX_ARGUMENTS; i++) {
		     argv[i] = NULL;
		  }

		  /* Null terminate argument string and parse it */
		  *(buffer + len) = '\0';
		  if (GADS(buffer, len, NULL, &argv[0], template) > 0L) {
		     BYTE *ptr;
		     LONG value;

		     /* Change FarData according to arguments */
		     if (ptr = argv[ARGUMENT_LEFT_EDGE]) {
			value = Atol(ptr);
			if (!IoErr()) {
			   nw->LeftEdge = value;
			}
		     }
		     if (ptr = argv[ARGUMENT_TOP_EDGE]) {
			value = Atol(ptr);
			if (!IoErr()) {
			   nw->TopEdge = value;
			}
		     }
		     if (ptr = argv[ARGUMENT_WIDTH]) {
			value = Atol(ptr);
			if (!IoErr()) {
			   nw->Width = value;
			}
		     }
		     if (ptr = argv[ARGUMENT_HEIGHT]) {
			value = Atol(ptr);
			if (!IoErr()) {
			   nw->Height = value;
			}
		     }
		     if (ptr = argv[ARGUMENT_STOPPED]) {
			fd->fd_Flags |= FARPRINT_FLAG_STOPPED;
		     } else {
			fd->fd_Flags &= ~FARPRINT_FLAG_STOPPED;
		     }
		     if (ptr = argv[ARGUMENT_REFRESH]) {
			fd->fd_Flags |= FARPRINT_FLAG_REFRESH;
		     } else {
			fd->fd_Flags &= ~FARPRINT_FLAG_REFRESH;
		     }
		  }
	       }
	       FreeMem(buffer, len + 1);
	    }
	 }
      }
      Close(fh);
   }
   pr->pr_WindowPtr = old_win;
}
	/* Write environment variable with data from FarData structure */

   STATIC VOID
write_environment_var(struct FarData  *fd, struct Window  *win)
{
   struct Process  *pr = (struct Process *)FindTask(NULL);
   APTR old_win = pr->pr_WindowPtr;
   BPTR fh;

   /* Open env var without AmigaDOS requester */
   pr->pr_WindowPtr = (APTR)-1L;
   if (fh = Open(FARPRINT_ENV_NAME, (LONG)MODE_NEWFILE)) {
      FPrintf(fh, "LeftEdge %d TopEdge %d Width %d Height %d %s %s",
		       win->LeftEdge, win->TopEdge, win->Width, win->Height,
		    (fd->fd_Flags & FARPRINT_FLAG_STOPPED ? "STOPPED" : ""),
		   (fd->fd_Flags & FARPRINT_FLAG_REFRESH ? "REFRESH" : ""));
      Close(fh);
   }
   pr->pr_WindowPtr = old_win;
}
