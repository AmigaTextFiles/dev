head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@// @;


1.2
date	97.07.14.04.23.37;	author dlorre;	state Exp;
branches;
next	1.1;

1.1
date	96.08.22.02.05.10;	author dlorre;	state Exp;
branches;
next	;


desc
@Oui.lib -- Object User Interface
Projet créé en 1994
Auteur: Dominique Lorre
@


1.2
log
@*** empty log message ***
@
text
@// $Id$

#include <libraries/gadtools.h>
#include <intuition/gadgetclass.h>
#include "gadgets/slider.h"
#include "gadgetlist.h"
#include <proto/gadtools.h>

// ========================================================================
// ==========================  SLIDER CLASS ===============================
// ========================================================================


slider::slider(gadgetlist *gl,
               void (window::*func)(gadget *, unsigned long, unsigned short),
               long min, long max, long level,
               long freedom,
               const char *text,
               const char *lformat,
               unsigned short mlen,
               long tplace,
               long lplace,
               long (*fdisp)(Gadget *, unsigned short)) : gadget(gl, func)
{
   gl->ng->ng_GadgetText = (UBYTE *)text ;
   underkey(text) ;
   gl->ng->ng_Flags = tplace ;
   vmin = min ;
   vmax = max ;
   gad = gl->gad = CreateGadget(SLIDER_KIND, gl->gad, gl->ng,
            GTSL_Min,           min,
            GTSL_Max,           max,
            GTSL_Level,         level,
            GTSL_LevelFormat,   lformat,
            GTSL_MaxLevelLen,   mlen,
            GTSL_LevelPlace,    lplace,
            GTSL_DispFunc,      fdisp,
            PGA_Freedom,        freedom,
            GT_Underscore,  '_',
            TAG_END) ;
}

void slider::set(long level, long min, long max)
{
    vmin = min ;
    vmax = max ;
    GT_SetGadgetAttrs(gad, w, NULL,
        (min != -1)?GTSL_Min:TAG_IGNORE, min,
        (max != -1)?GTSL_Max:TAG_IGNORE, max,
        (level != -1)?GTSL_Level:TAG_IGNORE, level,
        TAG_DONE) ;

}

void slider::action(unsigned long classe, unsigned short code)
{
    cursel = code ;
    gadget::action(classe, code) ;
}

void slider::keystroke(BOOL shifted)
{
    if (shifted) {
        if (cursel > vmin)
            cursel-- ;
    }
    else {
        if (cursel < vmax)
            cursel++ ;
    }
    gadget::action(NULL, cursel) ;
    GT_SetGadgetAttrs(gad, w, NULL, GTSL_Level, cursel, TAG_DONE) ;
}

@


1.1
log
@Initial revision
@
text
@d1 2
d7 1
a7 9

extern "C" {
extern struct Library *GadToolsBase ;
struct Gadget *CreateGadget( unsigned long kind, struct Gadget *gad,
        struct NewGadget *ng, Tag tag1, ... );
void GT_SetGadgetAttrs( struct Gadget *gad, struct Window *win,
        struct Requester *req, Tag tag1, ... );
#include <pragmas/gadtools_pragmas.h>
}
d18 2
a19 2
               STRPTR text,
               STRPTR lformat,
d25 1
a25 1
   gl->ng->ng_GadgetText = text ;
@
