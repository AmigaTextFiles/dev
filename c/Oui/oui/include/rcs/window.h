head	1.5;
access;
symbols;
locks
	dlorre:1.5; strict;
comment	@ * @;


1.5
date	98.04.08.15.13.40;	author dlorre;	state Exp;
branches;
next	1.4;

1.4
date	98.01.13.20.03.07;	author dlorre;	state Exp;
branches;
next	1.3;

1.3
date	97.07.14.04.25.42;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	96.08.28.20.08.00;	author dlorre;	state Exp;
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


1.5
log
@sname size enlarged
@
text
@// $Id: window.h 1.4 1998/01/13 20:03:07 dlorre Exp dlorre $
#if !defined( CLASS_WINDOW_H )
#define CLASS_WINDOW_H 1


#if !defined( EXEC_TYPES_H )
#include <exec/types.h>
#endif

#if !defined( GRAPHICS_TYPES_H )
#include <graphics/gfxbase.h>
#endif

#if !defined( GRAPHICS_GFXMACROS_H )
#include <graphics/gfxmacros.h>
#endif

#if !defined( INTUITION_GADGETCLASS_H )
#include <intuition/gadgetclass.h>
#endif

#if !defined( LIBRARIES_GADTOOLS_H )
#include <libraries/gadtools.h>
#endif

#ifndef CLASS_SLIST_H
#include "slist.h"
#endif

#include "rectangle.h"
#include "screen.h"
#include "locale.h"

#ifndef CLASS_GADGETLIST_H
#include "gadgetlist.h"
#endif

#ifndef CLASS_GADGET_H
class window ;
#include "gadgets/gadget.h"
#endif

#ifndef CLASS_STRING_H
#include "gadgets/string.h"
#endif

#ifdef open
#undef open
#endif

#ifdef close
#undef close
#endif

class menustate {
public:
    MenuItem    *item ;
    BOOL        enable ;
    BOOL        checked ;
    menustate() : item(NULL), enable(TRUE), checked(FALSE) {}
} ;

class window ;

class wlink : public nlink
{
public:
    window *win ;
} ;

// ========================================================================
// ========================== WINDOW CLASS ================================
// ========================================================================



class window : public rectangle {
friend class gadgetlist ;
private:
    TagItem     *tags ;
    Region      *clipregion ;
    Rectangle   *cliprect ;

    short       awidth ;
    short       aheight ;
    int         asize ;
    WORD        *areaBuffer ;
    UBYTE       *tmpBuffer;     // PLANEPTR
    BitMap      *tmpBitMap ;
    AreaInfo    *areaInfo ;
    TmpRas      *tmpRas ;
    short       drawmode ;
    RastPort    *bgrp ;
    BitMap      *bgbm ;
    wlink       link ;
protected:
    gadgetlist  *g ;            // the gadgets attached to this window
    void        (*reqfunc)(long, unsigned long, unsigned short) ;

    ULONG       idcmp ;         // the IDCMP flags
    BOOL        hasgadgets ;    // window contains gadgets
    BOOL        hasmenus ;      // window contains menus
    BOOL        selfmsg ;       // the MsgPort is not shared
public:
    screen      *ws ;
    Window      *win ;          // useful pointers
    MsgPort     *mp ;
    Menu        *menu ;
    RastPort    *rp ;

    BOOL        active ;        // user did not request for closing
    BOOL        initok ;        // open window succeeds
    ULONG       signal ;        // the MsgPort signal bit

    char        sname[256] ;    // storage (name in dialog box)
    BOOL        okflag ;        // user accept dialog box
    BOOL        applique ;      // do the changes now
    LONG        emode ;         // extended mode set to 1 if special action
public:
    window(short l, short t, short w, short h) ;
    virtual ~window() ;
protected:
    // Standard Gadget Routines
    virtual void fok(gadget *g, unsigned long classe, unsigned short code) ;
    virtual void fcancel(gadget *g, unsigned long classe, unsigned short code) ;
    virtual void fapply(gadget *g, unsigned long classe, unsigned short code) ;
    virtual void fname(gadget *g, unsigned long classe, unsigned short code) ;
    virtual void handlevkey(USHORT code) ;
    virtual void handlerawkey(USHORT code) ;
    virtual void handlemousebuttons(USHORT code, WORD x, WORD y, UWORD qualifier) ;
public:
    virtual void open(screen *) ;
    virtual void close() ;
    virtual void simpleevent(IntuiMessage *msg) ;
    virtual void otext( long x, long y, const char *string ) ;
protected:
    void _open(MsgPort *, ULONG, ULONG, ...) ;
    void _open(MsgPort *, ULONG, TagItem *) ;

    void strip() ;
    void stripimsg() ;
    void resetidcmp() ;

public:
    void prepbox(BOOL center=FALSE) ;    // Initialization routine
    void eventloop() ;
    void processevents(IntuiMessage *msg) ;
    void setfunc(void (*func)(long , unsigned long, unsigned short)) ;

    // Window management functions
    void move(short dx, short dy=0) ;
    void size(short dw, short dh=0) ;
    void box(short x, short y, short w, short h) ;
    void limits(short wmin, short hmin, short wmax, short hmax) ;
    void titles(const char *wt, const char *st) ;
    void activate() ;
    void front() ;
    void back() ;

    // Gadtools & Menus routines
    void recessedbox(short x, short y, short w, short h) ;
    void bevelbox(short x, short y, short w, short h) ;
    void setmenus(struct NewMenu *menu1, ...) ;
    void expandmenu(Menu *, NewMenu *extmenu) ;
    void menuchanges(menustate *, LONG count) ;
    MenuItem *itemaddress( unsigned long menuNumber ) ;
    MenuItem *itemaddress(LONG m, LONG i, LONG s) ;
    void clearmenustrip(void) ;
    BOOL resetmenustrip(void) ;

    // Gfx routines
    void pmove(long x, long y) ;                    // Move(rp, ...)
    void draw(long x, long y) ;                     // Draw(rp, ...)
    void polydraw(long count, WORD *polyTable) ;
    void rectfill(long xMin, long yMin, long xMax, long yMax) ;
    void eraserect(long xMin, long yMin, long xMax, long yMax ) ;
    void setapen(unsigned long pen) ;
    void setbpen(unsigned long pen) ;
    void setopen(unsigned long pen) ;
    void setrast(unsigned long pen) ;
    void setdrmd(unsigned long drawMode) ;
    void setdrpt(UWORD pattern) ;
    void setafpt(const UWORD *pattern, BYTE count) ;
    short textlength(const char *string, unsigned long count ) ;
    void text( const char *string, unsigned long count ) ;
    unsigned long textfit(const char *string, unsigned long strLen,
        struct TextExtent *textExtent, struct TextExtent *constrainingExtent,
        long strDirection, unsigned long constrainingBitWidth,
        unsigned long constrainingBitHeight ) ;
    void setfont(TextFont *font) ;

    // Intuition Drawing Routines
    void printitext(IntuiText *iText, long left, long top ) ;
    void drawborder( Border *border, long leftOffset, long topOffset ) ;
    void drawimage( struct Image *image, long leftOffset, long topOffset ) ;
    void eraseimage( struct Image *image, long leftOffset, long topOffset ) ;

    // Clip Routines
    int newregion(void) ;
    void disposeregion(void) ;
    BOOL addregion(short l, short t, short w, short h) ;
    void installclip(void) ;
    void removeclip(void) ;

    // Pointer Routines
    void setpointer( UWORD *pointer, long height,
        long width, long xOffset, long yOffset ) ;
    void clearpointer() ;

    // Area Routines
    short initarea(short w, short h, int size=1000) ;
    void freearea() ;
    long areaellipse(long xCenter, long yCenter, long a, long b ) ;
    long areamove( long x, long y ) ;
    long areadraw( long x, long y ) ;
    long areaend() ;
    BOOL flood( unsigned long mode, long x, long y ) ;

    // BackGround Drawing routines
    void setbgrp(RastPort *brp) ;
    void clearbgrp() ;

    void flushbg(int x, int y, int w, int h, int mode=0xC0) ;

    // Refresh routines
    void beginrefresh() ;
    void endrefresh(BOOL end) ;
    void refreshwindowframe() ;

} ;

inline void window::fok(gadget *g, unsigned long classe, unsigned short code)
{
    okflag = TRUE; active = FALSE ; emode = 0 ; applique = FALSE ;
}

inline void window::fcancel(gadget *g, unsigned long classe, unsigned short code)
{
    okflag = FALSE; active = FALSE ; emode = 0 ; applique = FALSE ;
}

inline void window::fapply(gadget *g, unsigned long classe, unsigned short code)
{
    okflag = TRUE; active = FALSE ; emode = 0 ; applique = TRUE ;
}

inline void window::handlevkey(USHORT code)
{
    if (code == 0x0D) {
        g->selectgadget(g->getcount()-2, FALSE) ;
    }
    else if (code == 0x1B) {
        g->selectgadget(g->getcount()-1, FALSE) ;
    }
    else
        g->parsegadgets(code) ;
}

inline void window::handlerawkey(USHORT code)
{
}

inline void window::handlemousebuttons(USHORT code, WORD x, WORD y, UWORD qualifier)
{
}

#if !defined( CLASS_WINDOW_INLINES_H ) && !defined( NO_CLASS_WINDOW_INLINES )
#include "window_inlines.h"
#endif

typedef void (window::*WFUNC)(gadget *, unsigned long, unsigned short) ;
#endif

@


1.4
log
@vanillakey handling changed
@
text
@d1 1
a1 1
// $Id: window.h 1.3 1997/07/14 04:25:42 dlorre Exp dlorre $
d115 1
a115 1
    char        sname[80] ;     // storage (name in dialog box)
@


1.3
log
@many changes to inlined functions
@
text
@d1 1
a1 1
// $Id: window.h 1.2 1996/08/28 20:08:00 dlorre Exp dlorre $
d63 8
d89 1
d95 1
d130 1
a231 5
inline window::~window()
{
    if (initok) close() ;
}

d249 8
d260 4
@


1.2
log
@passage en INLINE de beaucoup de fonctions
@
text
@d1 1
a1 1
// $Id$
d6 1
d8 3
d12 3
d16 3
d20 3
d24 1
a24 2
#include <stdio.h>
#include <string.h>
d29 1
d42 1
a45 6
#include <cxxproto/exec.h>
#include <cxxproto/graphics.h>
#include <cxxproto/layers.h>
#include <cxxproto/intuition.h>
#include <cxxproto/gadtools.h>
#include <cxxproto/utility.h>
d47 7
a93 33

    void _open(MsgPort *, ULONG, ULONG, ...) ;
    void _open(MsgPort *, ULONG, TagItem *) ;

    void strip() ;
    void stripimsg() ;
    void resetidcmp() { ModifyIDCMP(win, idcmp) ; }

    void prepbox(BOOL center=FALSE) ;    // Initialization routine

    // Standard Gadget Routines
    virtual void fok(gadget *g, unsigned long classe, unsigned short code)
    {
        okflag = TRUE; active = FALSE ; emode = 0 ; applique = FALSE ;
    }

    virtual void fcancel(gadget *g, unsigned long classe, unsigned short code)
    {
        okflag = FALSE; active = FALSE ; emode = 0 ; applique = FALSE ;
    }

    virtual void fapply(gadget *g, unsigned long classe, unsigned short code)
    {
        okflag = TRUE; active = FALSE ; emode = 0 ; applique = TRUE ;
    }

    virtual void fname(gadget *g, unsigned long classe, unsigned short code)
    {
        strcpy(sname, ((string *)g)->curstring) ;
    }

    virtual void handlevkey(USHORT code) {}
    virtual void handlerawkey(USHORT code) {}
d109 1
a109 1

d111 10
a120 2
    virtual ~window() { if (initok) close() ; }

d123 9
d133 2
d137 1
a137 1
    virtual void simpleevent(IntuiMessage *msg) ;
d139 9
a147 44
    void setfunc(void (*func)(long , unsigned long, unsigned short))
    {
        reqfunc = func ;
    }

    void move(short dx, short dy=0)
    {
        rectangle::move(dx, dy) ;
        if (win) ChangeWindowBox(win, left, top, width, height) ;
    }
    void size(short dw, short dh=0)
    {
        rectangle::size(dw, dh) ;
        if (win) ChangeWindowBox(win, left, top, width, height) ;
    }
    void box(short x, short y, short w, short h)
    {
        rectangle::box(x, y, w, h) ;
        if (win) ChangeWindowBox(win, left, top, width, height) ;
    }


    void limits(short wmin, short hmin, short wmax, short hmax)
    {
        rectangle::limits(wmin, hmin, wmax, hmax) ;
        if (win) WindowLimits(win, minw, minh, maxw, maxh) ;
    }

    void titles(STRPTR wt, STRPTR st)
    {
        if (win) SetWindowTitles(win, wt, st) ;
    }
    void activate()
    {
        if (win) ActivateWindow(win) ;
    }
    void front()
    {
        if (win) WindowToFront(win) ;
    }
    void back()
    {
        if (win) WindowToBack(win) ;
    }
d150 2
a151 16

    void recessedbox(short x, short y, short w, short h)
    {
        if (win)
            DrawBevelBox(rp, x, y, w, h,
            GT_VisualInfo, ws->vi,
            GTBB_Recessed, TRUE,
            TAG_END);
    }
    void bevelbox(short x, short y, short w, short h)
    {
        if (win)
            DrawBevelBox(rp, x, y, w, h,
            GT_VisualInfo, ws->vi,
            TAG_END);
    }
d155 4
a158 8
    MenuItem *itemaddress( unsigned long menuNumber )
    {
        return ItemAddress( menu, menuNumber) ;
    }
    MenuItem *itemaddress(LONG m, LONG i, LONG s)
    {
        return ItemAddress(menu, FULLMENUNUM(m, i, s)) ;
    }
d161 15
a175 59

    void pmove(long x, long y)                      // Move(rp, ...)
    {
        Move(rp, x, y) ;
    }
    void draw(long x, long y)                       // Draw(rp, ...)
    {
        Draw(rp, x, y) ;
    }
    void polydraw(long count, WORD *polyTable)
    {
        PolyDraw(rp, count, polyTable) ;
    }
    void rectfill(long xMin, long yMin, long xMax, long yMax)
    {
        RectFill(rp, xMin, yMin, xMax, yMax) ;
    }
    void eraserect(long xMin, long yMin, long xMax, long yMax )
    {
        EraseRect(rp, xMin, yMin, xMax, yMax) ;
    }
    void setapen(unsigned long pen)
    {
        SetAPen(rp, pen) ;
    }
    void setbpen(unsigned long pen)
    {
        SetBPen(rp, pen) ;
    }
    void setopen(unsigned long pen)
    {
        SafeSetOutlinePen(rp, char(pen)) ;
    }
    void setrast(unsigned long pen)
    {
        SetRast(rp, pen) ;
    }
    void setdrmd(unsigned long drawMode)
    {
        SetDrMd(rp, drawMode) ;
    }
    void setdrpt(unsigned short pattern)
    {
        SetDrPt(rp, pattern) ;
    }
    short textlength(STRPTR string, unsigned long count )
    {
        return TextLength(rp, string, count );
    }
    void text( STRPTR string, unsigned long count )
    {
        Text(rp, string, count) ;
    }
    virtual void otext( long x, long y, STRPTR string )
    {
        pmove(x, y) ;
        text(string, strlen(string)) ;
    }
    unsigned long textfit(STRPTR string, unsigned long strLen,
d178 2
a179 10
        unsigned long constrainingBitHeight )
    {
        return TextFit(rp, string, strLen, textExtent, constrainingExtent,
            strDirection, constrainingBitWidth, constrainingBitHeight) ;
    }
    void setfont(TextFont *font)
    {
        SetFont( rp, font) ;
    }

d182 4
a185 16
    void printitext(IntuiText *iText, long left, long top )
    {
        PrintIText( rp, iText, left, top) ;
    }
    void drawborder( Border *border, long leftOffset, long topOffset )
    {
        DrawBorder( rp, border, leftOffset, topOffset );
    }
    void drawimage( struct Image *image, long leftOffset, long topOffset )
    {
        DrawImage( rp, image, leftOffset, topOffset );
    }
    void eraseimage( struct Image *image, long leftOffset, long topOffset )
    {
        EraseImage( rp, image, leftOffset,  topOffset );
    }
d188 5
a192 28
    int newregion(void)
    {
        clipregion = NewRegion() ;
        if (clipregion)
            cliprect = new Rectangle ;
        return (clipregion != NULL) ;
    }
    void disposeregion(void)
    {
        delete cliprect ;
        DisposeRegion( clipregion );
    }
    void addregion(short l, short t, short w, short h)
    {
        cliprect->MinX = l ;
        cliprect->MaxX = short(l+w) ;
        cliprect->MinY = t ;
        cliprect->MaxY = short(t+h) ;
        OrRectRegion(clipregion, cliprect) ;
    }
    void installclip(void)
    {
        InstallClipRegion(win->WLayer, clipregion) ;
    }
    void removeclip(void)
    {
        clipregion = InstallClipRegion(win->WLayer, NULL) ;
    }
d196 2
a197 8
        long width, long xOffset, long yOffset )
    {
        SetPointer(win, pointer, height, width, xOffset, yOffset) ;
    }
    void clearpointer()
    {
        ClearPointer(win) ;
    }
d202 5
a206 20
    long areaellipse(long xCenter, long yCenter, long a, long b )
    {
        return AreaEllipse( rp, xCenter, yCenter, a, b ) ;
    }
    long areamove( long x, long y )
    {
        return AreaMove( rp, x, y );
    }
    long areadraw( long x, long y )
    {
        return AreaDraw( rp, x, y );
    }
    long areaend()
    {
        return AreaEnd( rp );
    }
    BOOL flood( unsigned long mode, long x, long y )
    {
        return Flood( rp, mode, x, y );
    }
d208 3
d212 1
a212 12
    // BackGround Drawing routines
    void setbgrp(RastPort *brp)
    {
        rp = bgrp = brp ;
        bgbm = bgrp->BitMap ;
    }
    void clearbgrp() { rp = win->RPort ; }

    void flushbg(int x, int y, int w, int h, int mode=0xC0)
    {
        BltBitMapRastPort(bgbm, 0, 0, win->RPort, x, y, w, h, mode);
    }
d215 3
a217 12
    void beginrefresh()
    {
        GT_BeginRefresh(win) ;
    }
    void endrefresh(BOOL end)
    {
        GT_EndRefresh(win, end) ;
    }
    void refreshwindowframe()
    {
        RefreshWindowFrame(win) ;
    }
d221 27
a247 5
class winnode : public slink {
public:
    window  *wptr ;
    long    type ;      // window's kind
};
d249 3
a252 4
class winlist : public slist {
public:
    void dumplist() ;
};
@


1.1
log
@Initial revision
@
text
@d1 1
a4 34
#if !defined( EXEC_PORTS_H )
struct MsgPort ;
#endif

#if !defined( GRAPHICS_RASTPORT_H )
struct RastPort ;
struct AreaInfo ;
struct TmpRas ;
#endif

#if !defined( GRAPHICS_GFX_H )
struct Rectangle ;
struct BitMap ;
#endif

#if !defined( GRAPHICS_REGIONS_H )
struct Region ;
#endif


#if !defined( GRAPHICS_TEXT_H )
struct TextExtent ;
struct TextFont ;
#endif

#if !defined( INTUITION_INTUITION_H )
struct Window ;
struct Menu ;
struct MenuItem ;
struct IntuiMessage ;
struct Image ;
struct Border ;
struct IntuiText ;
#endif
d6 7
a12 7
#if !defined( LIBRARIES_GADTOOLS_H )
struct NewMenu ;
#endif

#if !defined( UTILITY_TAGITEM_H )
struct TagItem ;
#endif
d14 1
a14 1
#if !defined( CLASS_SLIST_H )
a16 2

#if !defined( CLASS_RECTANGLE_H )
d18 2
a19 1
#endif
d21 2
a22 2
#if !defined( CLASS_SCREEN_H )
class screen ;
d25 13
a37 3
#if !defined( CLASS_GADGETLIST_H )
#include "gadgetlist.h"
#endif
d85 1
a85 1
    void resetidcmp() ;
d90 19
a108 4
    virtual void fok(gadget *g, unsigned long classe, unsigned short code) ;
    virtual void fcancel(gadget *g, unsigned long classe, unsigned short code) ;
    virtual void fapply(gadget *g, unsigned long classe, unsigned short code) ;
    virtual void fname(gadget *g, unsigned long classe, unsigned short code) ;
d110 2
a111 2
    virtual void handlevkey(USHORT code) ;
    virtual void handlerawkey(USHORT code) ;
d126 1
a126 1
    int         emode ;         // extended mode set to 1 if special action
d138 44
a181 11
    void setfunc(void (*func)(long , unsigned long, unsigned short)) ;

    void move(short dx, short dy=0) ;
    void size(short dw, short dh=0) ;
    void box(short x, short y, short w, short h) ;
    void limits(short minw, short minh, short maxw, short maxh) ;

    void titles(STRPTR, STRPTR) ;
    void activate() ;
    void front() ;
    void back() ;
d185 15
a199 2
    void recessedbox(short x, short y, short w, short h) ;
    void bevelbox(short x, short y, short w, short h) ;
d203 8
a210 2
    MenuItem *itemaddress( unsigned long menuNumber );
    MenuItem *itemaddress(LONG m, LONG i, LONG s) ;
d214 57
a270 14
    void pmove(long x, long y) ;                    // Move(rp, ...)
    void draw(long x, long y) ;                     // Draw(rp, ...)
    void polydraw(long count, WORD *polyTable) ;
    void rectfill(long xMin, long yMin, long xMax, long yMax) ;
    void eraserect(long xMin, long yMin, long xMax, long yMax );
    void setapen(unsigned long pen) ;
    void setbpen(unsigned long pen) ;
    void setopen(unsigned long pen) ;
    void setrast(unsigned long pen) ;
    void setdrmd(unsigned long drawMode) ;
    void setdrpt(unsigned short pattern) ;
    short textlength(STRPTR string, unsigned long count );
    void text( STRPTR string, unsigned long count );
    virtual void otext( long x, long y, STRPTR string );
d274 9
a282 2
        unsigned long constrainingBitHeight );
    void setfont(TextFont *) ;
d286 16
a301 4
    void printitext(IntuiText *iText, long left, long top );
    void drawborder( Border *border, long leftOffset, long topOffset );
    void drawimage( struct Image *image, long leftOffset, long topOffset );
    void eraseimage( struct Image *image, long leftOffset, long topOffset );
d304 28
a331 5
    int newregion(void) ;
    void disposeregion(void) ;
    void addregion(short l, short t, short w, short h) ;
    void installclip(void);
    void removeclip(void) ;
d335 8
a342 2
        long width, long xOffset, long yOffset );
    void clearpointer() ;
d347 21
a367 5
    long areaellipse(long xCenter, long yCenter, long a, long b );
    long areamove( long x, long y );
    long areadraw( long x, long y );
    long areaend();
    BOOL flood( unsigned long mode, long x, long y );
d370 11
a380 3
    void setbgrp(RastPort *brp) ;
    void clearbgrp() ;
    void flushbg(int x, int y, int w, int h, int mode=0xC0) ;
d383 12
a394 3
    void beginrefresh() ;
    void endrefresh(BOOL) ;
    void refreshwindowframe() ;
a410 2


@
