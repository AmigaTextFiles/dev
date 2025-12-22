/* this file contains a function called getstring() which will prompt
 * a user for a string, and the return it to you if they clicked o.k.
 * or hit return in the string gadget
 *
 * The arguments are : win : a pointer to a window.  This is used to
 *		       ensure that the getstring window is on the same
 *		       screen as your window.
 *
 *		       title : a character string which becomes the title
 *		       of the window we open
 *
 *		       def_string : a character string which is the default
 *		       string in the string gadget.
 *
 * The window we open is font-sensitive (lays itself out appropriately) and
 * centers itself on the screen which it opens.
 *
 *  Dominic Giampaolo © 1991
 */
#include "inc.h"    /* make sure to get the amiga includes */

#include "ezlib.h"


/* some defines for our gadget id's for this window... */
#define CANCEL_GADG 351
#define OK_GADG     352
#define STRING_GADG 353


char *GetString(struct Window *window, char *title, char *def_string)
{
 SHORT	height, l_edge, t_edge;
 char  *string = NULL, *buff;
 struct Screen	     *screen = NULL, scr;
 struct Window	     *win = NULL;
 struct IntuiMessage *msg;
 struct Gadget *gadg,*string_gadget, *ok_gadget, *cancel_gadget;
 USHORT len;
 LONG	go_on = TRUE;
 ULONG	idcmp = GADGETUP+CLOSEWINDOW+ACTIVEWINDOW,   /* IDCMP flags */
	flags = WINDOWDRAG+WINDOWDEPTH+WINDOWCLOSE+ACTIVATE+NOCAREREFRESH+WINDOWACTIVE;

 /* make the string, cancel, and o.k. gadgets */
 string_gadget = CreateStringGadget(13, 18, 295, GADGHCOMP, RELVERIFY, def_string,   STRING_GADG);
 cancel_gadget = CreateBoolGadget(  10, 36, GADGHCOMP, RELVERIFY, "Cancel", CANCEL_GADG);
 ok_gadget     = CreateBoolGadget( 230, 36, GADGHCOMP, RELVERIFY, " O.K. ", OK_GADG);

 if (cancel_gadget == NULL || ok_gadget == NULL || string_gadget == NULL)
   {
    KillGadget(NULL, cancel_gadget);   /* handles NULL values o.k. */
    KillGadget(NULL, ok_gadget);       /* handles NULL values o.k. */
    KillGadget(NULL, string_gadget);   /* handles NULL values o.k. */
    return NULL;
   }

 buff = (char *)(((struct StringInfo *)string_gadget->SpecialInfo)->Buffer);

 if (window)
   screen = window->WScreen;
 else
  {
    GetScreenData((char *)&scr, sizeof(struct Screen), WBENCHSCREEN, NULL);
    screen = &scr;
  }

 /* now we lay out the display as appropriate for the current font */
 string_gadget->LeftEdge = screen->WBorLeft + 10;
 string_gadget->TopEdge  = screen->WBorTop + screen->BarLayer->rp->Font->tf_YSize + 1 + 5;
 string_gadget->NextGadget = cancel_gadget;

 cancel_gadget->LeftEdge = screen->WBorLeft + 7;
 cancel_gadget->TopEdge  = string_gadget->TopEdge + string_gadget->Height + 6;
 cancel_gadget->NextGadget = ok_gadget;

 ok_gadget->LeftEdge	 = string_gadget->LeftEdge + string_gadget->Width - ok_gadget->Width;
 ok_gadget->TopEdge	 = cancel_gadget->TopEdge;

 height = ok_gadget->TopEdge + ok_gadget->Height + 4;

 l_edge = (screen->Width  - 320) / 2;
 t_edge = (screen->Height - height) / 2;

 if (window == NULL)
   screen = NULL;

 win = CreateWindow(screen, l_edge, t_edge, 320, height, flags, idcmp);
 if ( win == NULL)
   { return NULL; }

 /* put the window title in */
 SetWindowTitles(win, title, (char *)-1L);

 /* now add the gadgets */
 AddGList(win, string_gadget, 0, 3, NULL);
 RefreshGList(string_gadget, win, NULL, 3);

 while (go_on)
  {
   Wait(1L << win->UserPort->mp_SigBit);

   while( go_on && (msg = (struct IntuiMessage *)GetMsg(win->UserPort)) )
    {
     switch(msg->Class)
      {
	case GADGETUP : gadg = (struct Gadget *)msg->IAddress;
			switch( gadg->GadgetID )
			 {
			   case CANCEL_GADG : go_on = FALSE;
					      break;

			   case OK_GADG     : /* fall through here...  */

			   case STRING_GADG : go_on = FALSE;
					      /* buff is a ptr into the string gadget buffer */
					      len = strlen(buff) + 1;
					      if (len == 1)   /* empty gadget */
						 break;
					      string = (char *)AllocMem(len, 0L);
					      if (string == NULL)
						 break;
					      strcpy(string, buff);
					      break;

			  default	    : break;
			 }
			break;

	case ACTIVEWINDOW : ActivateGadget(string_gadget, win, NULL);
			    break;

	case CLOSEWINDOW : go_on = FALSE;
			   break;

	default : break;

      } /* end of switch(msg->Class) */
     ReplyMsg((struct Message *)msg);

    } /* end of while(msg....) */

  } /* end of while (go_on) */

 KillGadget(win, cancel_gadget);
 KillGadget(win, ok_gadget);
 KillGadget(win, string_gadget);
 KillWindow(win);

 return string;
}

