// $Id: gadget.cc 1.3 1997/09/17 08:15:46 dlorre Exp dlorre $
#include <libraries/gadtools.h>

#include "gadgets/gadget.h"
#include "gadgetlist.h"
#include <ctype.h>
#include <mydebug.h>

// ========================================================================
// ==========================  GADGET CLASS ===============================
// ========================================================================


gadget::gadget(gadgetlist *gl,
               void (window::*func)(gadget *, unsigned long, unsigned short)
               ) : glist(gl), gfunc(func), gad(NULL)
{
    gl->ng->ng_LeftEdge = gl->left ;
    gl->ng->ng_TopEdge = gl->top ;
    gl->ng->ng_Width = gl->width ;
    gl->ng->ng_Height = gl->height ;
    id = gl->ng->ng_GadgetID = gl->count ;
    gl->gtab[gl->count] = this ;
    gl->count++ ;
    w = gl->wp ;
    key = '\0' ;
}

void gadget::action(unsigned long classe, unsigned short code)
{
    if (gfunc) (glist->win->*gfunc)(this, classe, code) ;
}

void gadget::select(BOOL sel)
{
}

void gadget::keystroke(BOOL shifted)
{
}

void gadget::underkey(const char *s)
{
int i ;

    key = '\0' ;
    if (s && *s) {
        for (i=1 ; s[i] ; i++) {
            if (s[i-1] == '_' ) {
                key = tolower(s[i]) ;
                break ;
            }
        }
    }
}

