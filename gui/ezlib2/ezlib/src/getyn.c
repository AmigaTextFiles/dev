/*    This function will get a yes or no answer from a users.  It tries
 * to be smart about how it opens the AutoRequest().
 *
 *    Also you should know that the idea for this code came from the DME
 * function of the same name.  However I have changed it a fair amount,
 * so I don't think there's any problem (mainly I made it smarter about
 * sizing)....
 *
 *    Arguments :  win : a window pointer so that this AutoRequest() appears
 *		   on the right screen.
 *
 *		   text : a character string you would like to appear in
 *		   the AutoRequest.  Be careful that it isn't too long.
 *
 *  Dominic Giampaolo © 1991
 */
#include "inc.h"    /* make sure to get the amiga includes */

#include "ezlib.h"


GetYN(struct Window *win, char *text)
{
    int result, width;
    struct IntuiText *body, *pos, *neg;

    if (win <= (struct Window *)100)       /* quick sanity check */
      return NULL;

    if (text == NULL)
      return NULL;

    /* this is a sneaky way to only have to do a single AllocMem instead
     * of 3 seperate ones (each with error checking).
     */
    body = (struct IntuiText *)AllocMem( (3*sizeof(struct IntuiText)), MEMF_CLEAR);
    if (body == NULL)
      return NULL;

    pos = &body[1]; neg = &body[2];

    body->BackPen  = pos->BackPen  = neg->BackPen  = 1;
    body->DrawMode = pos->DrawMode = neg->DrawMode = AUTODRAWMODE;
    body->LeftEdge = 10;
    body->TopEdge  = 12;
    body->IText    = (UBYTE *)text;
    pos->LeftEdge  = pos->TopEdge  = AUTOTOPEDGE;
    pos->IText	   = (UBYTE *)" OK ";
    neg->LeftEdge  = neg->TopEdge  = AUTOTOPEDGE;
    neg->IText	   = (UBYTE *)" CANCEL";

    width = IntuiTextLength(body) + 50;
    if (width < 150)
      width = 225;

    result = AutoRequest(win, body, pos, neg, 0, 0, width, win->RPort->TxHeight + 50);

    FreeMem(body, (3*sizeof(struct IntuiText)));
    return(result);
}

