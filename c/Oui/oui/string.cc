// $Id: string.cc 1.4 1998/01/13 20:02:05 dlorre Exp dlorre $
#include <exec/lists.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>
#include <string.h>
#include <mydebug.h>

#include <proto/dos.h>
#include <proto/intuition.h>

#include "gadgets/string.h"
#include "gadgetlist.h"
#include "window.h"
#include "screen.h"


// ========================================================================
// ==========================  STRING CLASS ===============================
// ========================================================================

string::string(gadgetlist *gl,
               void (window::*func)(gadget *, unsigned long, unsigned short),
               const char *title,
               const char *text,
               long max,
               unsigned long flags,
               unsigned long justify) : gadget(gl, func), maxsize(max)
{
long pens, apens ;

    pens =  gl->win->ws->xpens[BLACK_PEN] << 8 ;
    apens = gl->win->ws->xpens[WHITE_PEN] << 8 ;
    pens += gl->win->ws->xpens[WHITE_PEN] ;
    apens += gl->win->ws->xpens[BLACK_PEN] ;
    gl->ng->ng_GadgetText = (UBYTE *)title ;
    underkey(title) ;
    gl->ng->ng_Flags = flags ;

    // since the font style can be modified several times
    // in a window opening process, this is a reliable way to be sure
    // that the wanted font will be used

    gfont = OpenFont(gl->ng->ng_TextAttr) ;

    im = (Image *)NewObject(NULL, (UBYTE *)"frameiclass",
        IA_Top,             -2,
        IA_Left,            -3,
        IA_Width,           gl->ng->ng_Width+6,
        IA_Height,          gl->ng->ng_Height+4,
        IA_Recessed,        FALSE,
        IA_EdgesOnly,       TRUE,
        IA_FrameType,       FRAME_RIDGE,
        TAG_DONE) ;

    buffer = new char[max+1] ;

    gad = gl->gad = (Gadget *)NewObject(NULL, (UBYTE *)"strgclass",
            GA_Top,                 gl->ng->ng_TopEdge,
            GA_Left,                gl->ng->ng_LeftEdge,
            GA_Width,               gl->ng->ng_Width,
            GA_Height,              gl->ng->ng_Height,
            GA_ID,                  id,
            GA_Image,               im,

            GA_RelVerify,           TRUE,

            GA_Previous,            gl->gad,
            GA_TabCycle,            TRUE,

            STRINGA_MaxChars,       max,
            text?STRINGA_TextVal:TAG_IGNORE,        text,
            STRINGA_Pens,           pens,
            STRINGA_ActivePens,     apens,
            STRINGA_Justification,  justify,
            STRINGA_Buffer,         buffer,
            STRINGA_Font,           gfont,
            TAG_END) ;

    curstring = new char[max+1] ;
    strcpy(curstring, buffer) ;
}

string::~string()
{
    if (gad) DisposeObject(gad) ;
    if (im) DisposeObject(im) ;
    if (buffer) delete buffer ;
    if (curstring) delete curstring ;
    if (gfont) CloseFont(gfont) ;
}

void string::action(unsigned long classe, unsigned short code)
{
LONG l = strlen(buffer) ;

    if (maxsize < l) {
        maxsize = l ;
        delete curstring ;
        curstring = new char[maxsize+1] ;
    }
    strcpy(curstring, buffer) ;
    gadget::action(classe, code) ;
}

void string::set(STRPTR text)
{
LONG l = strlen(text) ;

    if (maxsize < l) {
        maxsize = l ;
        delete curstring ;
        curstring = new char[maxsize+1] ;
    }
    strcpy(curstring, text) ;
    SetGadgetAttrs(gad, w, NULL,
        STRINGA_TextVal,    text,
        TAG_END) ;
}

void string::keystroke(BOOL shifted)
{
    ActivateGadget(gad, w, NULL) ;
}

