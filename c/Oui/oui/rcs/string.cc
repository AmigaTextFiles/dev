head	1.4;
access;
symbols;
locks
	dlorre:1.4; strict;
comment	@// @;


1.4
date	98.01.13.20.02.05;	author dlorre;	state Exp;
branches;
next	1.3;

1.3
date	97.07.14.04.20.15;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	96.08.28.20.06.02;	author dlorre;	state Exp;
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


1.4
log
@changed colors and box
@
text
@// $Id: string.cc 1.3 1997/07/14 04:20:15 dlorre Exp dlorre $
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

@


1.3
log
@*** empty log message ***
@
text
@d1 1
a1 1
// $Id: string.cc 1.2 1996/08/28 20:06:02 dlorre Exp dlorre $
d32 2
a33 1
    pens = apens = gl->win->ws->xpens[BLACK_PEN] << 8 ;
d35 1
a35 2
    apens += gl->win->ws->xpens[GREEN_PEN] ;

d47 4
a50 4
        IA_Top,             -1,
        IA_Left,            -2,
        IA_Width,           gl->ng->ng_Width+4,
        IA_Height,          gl->ng->ng_Height+2,
d59 4
a62 4
            GA_Top,                 gl->ng->ng_TopEdge+1,
            GA_Left,                gl->ng->ng_LeftEdge+2,
            GA_Width,               gl->ng->ng_Width-4,
            GA_Height,              gl->ng->ng_Height-2,
@


1.2
log
@bug corrigé : affichage des pens
@
text
@d1 1
a1 1
// $Id$
d7 1
d9 2
a10 3
#include <cxxproto/dos.h>
#include <cxxproto/intuition.h>
#include <cclib/debug_protos.h>
d24 2
a25 2
               STRPTR title,
               STRPTR text,
d28 1
a28 1
               unsigned long justify) : gadget(gl, func)
d36 1
a36 1
    gl->ng->ng_GadgetText = title ;
d40 7
a46 1
    im = (Image *)NewObject(NULL, "frameiclass",
d49 3
a51 3
        IA_Width,           gl->ng->ng_Width,
        IA_Height,          gl->ng->ng_Height,
        IA_Recessed,        TRUE,
d53 1
d56 3
a58 1
    gad = gl->gad = (Gadget *)NewObject(NULL, "strgclass",
d76 2
a77 1

d81 1
a81 1
    strcpy(curstring, (STRPTR)((StringInfo *)gad->SpecialInfo)->Buffer) ;
d88 1
d90 1
d95 8
a102 1
    strcpy(curstring, (STRPTR)((StringInfo *)gad->SpecialInfo)->Buffer) ;
d108 7
@


1.1
log
@Initial revision
@
text
@d1 1
d32 1
a32 1
    pens = apens = gl->win->ws->xpens[BLACK_PEN] << 4 ;
a35 2


d46 1
@
