/*  MRGadgets - Miscellaneous gadget support routines.
 *  Author:     Mark R. Rinfret
 *  Date:       09/02/89
 *
 *  This package contains a set of routines which assist in the use and
 *  management of gadgets. Many of these were developed while writing
 *  MRBackup.
 *
 *  Note that an attempt was made to maintain consistency in the order
 *  that parameters are passed.  For most routines, the parameter list
 *  will begin with
 *      (gadget, window, requester, ...)
 *  followed by any additional required parameters. 
 */

#include <intuition/intuition.h>
#include "Strings.h"
#include "MRGadgets.h"

/*  FUNCTION
        EraseGadgetBox - clear the area inside a gadget's border.

    SYNOPSIS
        void EraseGadgetBox(gadget, window, requester)
             struct Gadget      *gadget;
             struct Window      *window;
             struct Requester   *requester;

    DESCRIPTION
        EraseGadgetBox must be called with a gadget for which a border
        has been defined.  It erases the area contained by the border.
        This routine supports other routines, such as SetOptionGadget.
        If <requester> is non-null, the <requester>'s RastPort is used.
        Otherwise, the <window>'s rastport is used.

*/

void
EraseGadgetBox(gadget, window, requester)
    struct Gadget       *gadget; 
    struct Window       *window;
    struct Requester    *requester;
{
    struct RastPort     *rp;
    ULONG               savePen;
    ULONG               xmin,ymin,xmax,ymax ;

    rp = SelectRastPort(window, requester);
    xmin = gadget->LeftEdge;
    xmax = xmin + gadget->Width;
    ymin = gadget->TopEdge;
    ymax = ymin + gadget->Height;
    savePen = rp->FgPen;
    SetAPen(rp, 0L);
    SetDrMd(rp, JAM1);
    RectFill(rp, xmin, ymin, xmax, ymax);
    SetAPen(rp, savePen);
}
/*  FUNCTION
        GetGadget - get gadget pointer, given gadget ID.

    SYNOPSIS
        struct Gadget *GetGadget(id, window)
                                 int            id;
                                 struct Window *window;

    DESCRIPTION
        GetGadget attempts to locate a non-system gadget in <window>
        that has the specified <id>. If found, a pointer to the gadget
        is found. Otherwise, NULL is returned.
*/
struct Gadget *
GetGadget(id, window)
    int             id;
    struct Window   *window;
{
    struct Gadget   *testGadget;

    for (testGadget = window->FirstGadget; testGadget; 
         testGadget = testGadget->NextGadget) {
        /* All system gadget types have high bit set (I think...). */
        if ( testGadget->GadgetType & 0x8000 ) 
            continue;
        if ( testGadget->GadgetID == id ) 
            break;
    }
    return testGadget;
}

/*  FUNCTION
        ResetStringInfo - reset information in a StringInfo structure.

    SYNOPSIS
        void ResetStringInfo(s)
             struct StringInfo *s;

    DESCRIPTION
        ResetStringInfo resets certain parameters in the StringInfo
        structure pointed to by <s>, including:

            UndoBuffer
            DispPos
            UndoPos
            NumChars
*/
void
ResetStringInfo(s)
    struct StringInfo *s;
{
    *(s->UndoBuffer) = '\0';
    s->BufferPos = 0;
    s->DispPos = 0;
    s->UndoPos = 0;
    s->NumChars = strlen(s->Buffer);
}

/* Indicate that a gadget is selected by turning on its highlight
 * and SELECTED flags.
 * Called with:
 *      gadget:     pointer to gadget structure
 *      window:     pointer to window containing gadget
 *      state
 */
/*  FUNCTION
        SelectGadget - set a gadget to the SELECTED or !SELECTED state.

    SYNOPSIS
        void SelectGadget(gadget, window, requester, state)
             struct Gadget      *gadget;
             struct Window      *window;
             struct Requester   *requester;
             BOOL               state;

    DESCRIPTION
        SelectGadget removes the <gadget> from the <window's> gadget list,
        sets or clears the SELECTED bit according to <state>, then adds
        the gadget back to the gadget list and refreshes list. If the
        gadget belongs to a requester, then <requester> must be supplied.
        Otherwise, it must be NULL.
*/
void
SelectGadget(gadget, window, requester, state)
    struct Gadget       *gadget; 
    struct Window       *window; 
    struct Requester    *requester;
    BOOL                state;
{
    long position;

    position = RemoveGadget(window, gadget);
    if (state)
        gadget->Flags |= SELECTED;
    else
        gadget->Flags &= ~SELECTED;
    AddGadget(window, gadget, position);
    RefreshGList(gadget, window, NULL, 1L);
}


/*  FUNCTION
        SetOptionGadget - set string value for multi-option gadget.

    SYNOPSIS
        void SetOptionGadget(gadget, window, requester, option)
                struct Gadget       *gadget;
                struct Window       *window;
                struct Requester    *requester;
                char                *option;

    DESCRIPTION
        SetOptionGadget sets the text string of the -last- IntuiText entry
        of the <gadget> to the string value in <option>.  This supports
        the cycling of mode values in a boolean gadget.  The <gadget> must
        reside in <window> or a <requester> that belongs to <window>. If
        the gadget is not part of a requester, <requester> must be NULL.

*/
void
SetOptionGadget(gadget, window, requester, option)
    struct Gadget       *gadget; 
    struct Window       *window;
    struct Requester    *requester;
    char                *option;
{
    struct IntuiText *itp;
    long              position;

    /* This is IMPORTANT! The IntuiText structure we are going to modify
       MUST be the last entry in the list.  The first entry encountered
       whose NextText field is NULL is the entry we are looking for.
     */

    for (itp = gadget->GadgetText; itp && itp->NextText;
         itp = itp->NextText) ;

    if (itp)
        EraseGadgetBox(gadget, window, requester);
        position = RemoveGList(window, gadget, 1L);
        itp->IText = (UBYTE *) option;
        AddGList(window, gadget, position, 1L, requester);
        RefreshGList(gadget, window, requester, 1L);
}

/*  FUNCTION
        SetStringGadget - set the value of a string gadget.

    SYNOPSIS
        void SetStringGadget(gadget, window, requester, s)
             struct Gadget      *gadget;
             struct Window      *window;
             struct Requester   *requester;
             char               *s;

    DESCRIPTION
        SetStringGadget sets the string value of a <gadget>, which
        belongs to <window>, to the character string pointed to by <s>.
        It does this in a "polite" way, first removing the gadget from
        the list, modifying it, then adding it back and refreshing the
        gadget list. 

        If the <gadget> belongs to a requester, <requester> must contain
        the address of that requester.  Otherwise, it must be NULL.

        If <window> is NULL, the gadget is modified without attempting
        to remove/restore it to/from a window gadget list.
*/
void
SetStringGadget(gadget, window, requester, s)
    struct Gadget       *gadget;
    struct Window       *window;
    struct Requester    *requester;
    char                *s;
{
    char    *gs;                        /* pointer to gadget's text */
    int     max;
    ULONG   position;
    struct StringInfo *sInfo;
    char    *s1;

    /* Make sure we are trying to modify a string gadget. If we aren't,
     * just don't do anything.
     */
    if (gadget->GadgetType & STRGADGET) {
        gs = (char *) GadgetString(gadget);
        sInfo = (struct StringInfo *) (gadget->SpecialInfo);
        max = sInfo->MaxChars;
        if (window)
            position = RemoveGList(window, gadget, 1L);
        strncpy(gs, s, max);            /* Don't exceed gadget capacity. */
        if (s1 = index(gs, '\n'))       /* Eliminate newline characters. */
            *s1 = '\0';
        ResetStringInfo(sInfo);
        if (window) {
            AddGList(window, gadget, position, 1L, requester);
            RefreshGList(gadget, window, requester, 1L);
        }
    }
}
