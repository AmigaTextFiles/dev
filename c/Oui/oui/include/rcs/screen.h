head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@ * @;


1.2
date	97.07.14.04.25.13;	author dlorre;	state Exp;
branches;
next	1.1;

1.1
date	96.08.22.02.05.49;	author dlorre;	state Exp;
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
#ifndef CLASS_SCREEN_H
#define CLASS_SCREEN_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef GRAPHICS_RASTPORT_H
struct RastPort ;
#endif

#ifndef GRAPHICS_TEXT_H
struct TextFont ;
#endif

#ifndef INTUITION_SCREENS_H
struct Screen ;
struct DrawInfo ;
#endif

#ifndef UTILITY_TAGITEM_H
struct TagItem ;
#endif



#define GREEN_PEN       0   // Green color
#define RED_PEN         1   // Red color
#define WHITE_PEN       2   // White color
#define BLACK_PEN       3   // Black color
#define GFILL_PEN       4   // Fill color on cstring gadget
#define GBORDER_PEN     5   // Extra Border color (not used)
#define BUTTONFILL_PEN  6   // Fill color on fbutton gadget
#define NUM_XPENS       7

class screen {
    UWORD       *defpens ;
    void setxpens(UWORD *p) ;
    void setdefpens() ;
public:
    BOOL        owner ;
    BOOL        status ;
    APTR        vi ;
    WORD        winbarheight ;
    Screen      *scr ;
    RastPort    *rp ;
    TextFont    *font ;
    short       left, top, width, height ;
    short       xratio, yratio ;
    DrawInfo    *drawinfo ;
    UWORD        *xpens ;
    LONG        error ;
    screen(UWORD *xp, STRPTR name) ;
    screen(UWORD *xp, TagItem *tags) ;
    screen(UWORD *xp, ULONG tdata, ...) ;
    ~screen() ;
    void init() ;
    void getsize() ;
    void front() ;      // Standard depth arrange
    void back() ;
    void cfront() ;     // Family depth arrange (V39)
    void cback() ;
    void beep() ;
};

#endif
@


1.1
log
@Initial revision
@
text
@d1 1
d28 7
a34 7
#define GREEN_PEN       0
#define RED_PEN         1
#define WHITE_PEN       2
#define BLACK_PEN       3
#define GFILL_PEN       4
#define GBORDER_PEN     5
#define GHIGHFILL_PEN   6
d39 2
d46 1
a46 1
    Screen      *screen ;
d54 3
a56 3
    screen(STRPTR name) ;
    screen(TagItem *tags) ;
    screen(ULONG tdata, ...) ;
a64 1
    void setxpens(UWORD *p) ;
@
