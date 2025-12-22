// $Id: scroller.cc 1.2 1997/07/14 04:23:32 dlorre Exp dlorre $

#include <exec/lists.h>
#include <libraries/gadtools.h>

#include "gadgets/scroller.h"
#include "gadgetlist.h"

#include <proto/gadtools.h>

// ========================================================================
// ==========================  SCROLLER CLASS =============================
// ========================================================================


scroller::scroller(gadgetlist *gl,
                   void (window::*func)(gadget *, unsigned long, unsigned short),
                   long top, long view, long total,
                   unsigned short arrows) : gadget(gl, func)
{
   gad = gl->gad = CreateGadget(SCROLLER_KIND, gl->gad, gl->ng,
            GTSC_Top,   top,
            GTSC_Total, total,
            GTSC_Visible,   view,
            GTSC_Arrows,    arrows,
            GT_Underscore,  '_',
            TAG_END) ;
}


