/* This file contains functions that create and manipulate Intuition Windows.
 *
 * Dominic Giampaolo © 1991
 */
#include "inc.h"    /* make sure to get the amiga includes */

#include "ezlib.h"


extern struct GfxBase *GfxBase;
extern struct IntuitionBase *IntuitionBase;


/* This function creates and opens a window of said dimensions.  The flags
 * and idcmp arguments are put into the Flags and Idcmp fields of a
 * NewWindow structure.
 *
 * On failure it returns NULL.
 */
struct Window *CreateWindow(struct Screen *screen, SHORT leftedge,
			    SHORT topedge, SHORT width, SHORT height,
			    ULONG flags, ULONG idcmp)
{
 int wb_height;
 struct NewWindow *tempwin;
 struct Window *win;

 /* some sanity checking - short and fast */
 if(GfxBase == NULL || IntuitionBase == NULL)
  if (OpenLibs(GFX | INTUITION) == NULL)
    return NULL;

 tempwin = (struct NewWindow *)AllocMem(sizeof(struct NewWindow), MEMF_CLEAR);
 if (tempwin == NULL)
   return NULL;

 if (width < 0)                /* more checking */
   width = GfxBase->NormalDisplayColumns;
 if (height < 0)
    height = 32000;  /* fixed below */

 tempwin->Flags    = flags;	       tempwin->IDCMPFlags = idcmp;
 tempwin->LeftEdge = (SHORT)leftedge;  tempwin->Width      = (SHORT)width;
 tempwin->TopEdge  = (SHORT)topedge;   tempwin->Height     = (SHORT)height;
 tempwin->MinWidth = 60;	       tempwin->MinHeight  = 30;
 tempwin->MaxWidth = -1;	       tempwin->MaxHeight  = -1;
 tempwin->DetailPen= -1;	       tempwin->BlockPen   = -1;
 tempwin->Type	   = WBENCHSCREEN;
 tempwin->Screen = screen;    /* if it's null that's o.k. too */

 /* if user has a custom screen, open up on that screen */
 if (screen)
  {
   tempwin->Type = CUSTOMSCREEN;
   if (leftedge + width > screen->Width)
     tempwin->Width = (screen->Width - leftedge);

   if (topedge + height > screen->Height)
     tempwin->Height = (screen->Height - topedge);
  }
 else
  {
   if (leftedge+width > GfxBase->NormalDisplayColumns)
     tempwin->Width = (GfxBase->NormalDisplayColumns - leftedge);

   /* gotta make sure to check for interlace */
   wb_height = (GfxBase->NormalDisplayRows * (1 + LacedWB()) );
   if (topedge + height > wb_height )
     tempwin->Height = wb_height - topedge;
  }

 win = OpenWindow(tempwin);

 FreeMem(tempwin, sizeof(struct NewWindow));

 return win;
}   /* end of CreateWindow() */



/* return TRUE (1) if wb screen is interlaced otherwise,
 * we return FALSE (0) if it is NOT interlaced
 */
LacedWB(void)
{
 struct Screen temp;

 if (GfxBase == NULL || IntuitionBase == NULL)
   if (OpenLibs(GFX | INTUI) == NULL)
     return 0;

 GetScreenData((char *)&temp, sizeof(struct Screen), WBENCHSCREEN, NULL);

 if (temp.ViewPort.Modes & LACE)
   return 1;
 else
   return 0;
}  /*  end of LacedWB()  */


/* Close a window and free its associated resources.
 *
 * If there is an associated menu strip with the window, it is cleared.
 * Any messages at the UserPort (if there is one) are replied to.
 * Then the window is closed.
 */
void KillWindow(struct Window *window)
{
 register struct IntuiMessage *msg;

 if (window == NULL)
   return;

 /* make sure this is NULL if you have already cleared out your menus. */
 if (window->MenuStrip != NULL)
   ClearMenuStrip(window);

 /* make sure there aren't any junk messages hanging here */
 while(window->UserPort != NULL &&
       (msg = (struct IntuiMessage *)GetMsg(window->UserPort)) != NULL )
   ReplyMsg((struct Message *)msg);

 /* then just close the window */
 CloseWindow(window);
}


/* this routine will make your standard Intuition Window.  It creates
 * a window with all the standard system gadgets on it, and makes it
 * the appropriate size (with sanity checking)
 */

struct Window *MakeWindow(struct Screen *screen, SHORT leftedge,
			  SHORT topedge, SHORT width, SHORT height)
{
  static ULONG idcmp =	CLOSEWINDOW,		/* IDCMP  Classes	*/
						/* system flags 	*/
	 flags =  WINDOWCLOSE|WINDOWDEPTH|WINDOWDRAG|WINDOWSIZING|NOCAREREFRESH|SMART_REFRESH|ACTIVATE;

 return CreateWindow(screen, leftedge, topedge, width, height, flags, idcmp);
}

