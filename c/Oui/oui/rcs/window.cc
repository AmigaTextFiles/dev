head	1.5;
access;
symbols;
locks
	dlorre:1.5; strict;
comment	@// @;


1.5
date	98.01.13.19.55.59;	author dlorre;	state Exp;
branches;
next	1.4;

1.4
date	97.09.17.08.16.56;	author dlorre;	state Exp;
branches;
next	1.3;

1.3
date	97.07.14.04.21.30;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	96.08.28.20.07.00;	author dlorre;	state Exp;
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


1.5
log
@now use winlist
@
text
@// $Id: window.cc 1.4 1997/09/17 08:16:56 dlorre Exp $
#include <exec/types.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>
#include <stdio.h>
#include <string.h>
#include <mydebug.h>

#include "screen.h"
#include "window.h"
#include "locale.h"
#include "gadgetlist.h"
#include "gadgets/gadget.h"
#include "gadgets/string.h"
#include "gadgets/fbutton.h"

#include <proto/exec.h>
#include <proto/graphics.h>
#include <proto/layers.h>
#include <proto/intuition.h>
#include <proto/gadtools.h>
#include <proto/utility.h>
#include "compiler.h"

catalog  *ocat ;
slist    *winlist ;

extern "C" {
extern struct LocaleBase *LocaleBase ;

void _STI_4500_initouicat()
{
    ocat = new catalog("oui.catalog", "english", NULL) ;
}

void _STD_4500_closeouicat()
{
    delete ocat ;
}

void _STI_4500_initwinlist()
{
    winlist = new slist ;
}

void _STD_4500_closewinlist()
{
    delete winlist ;
}
}

lstring  FAR ok NPARMS(ocat, "_Ok", "MSG_OK_GAD", 1) ;
lstring  FAR cancel LPARMS(ocat, "_Cancel", "MSG_CANCEL_GAD") ;
lstring  FAR parent LPARMS(ocat, "_Parent", "MSG_PARENT_GAD") ;
lstring  FAR drawer LPARMS(ocat, "_Drawer:", "MSG_DRAWER_GAD") ;
lstring  FAR file LPARMS(ocat, "_File:", "MSG_FILE_GAD") ;
lstring  FAR comment LPARMS(ocat, "Co_mment:", "MSG_COMMENT_GAD") ;


// Constructor
// Initialisation of variables in a predefined state.
window::window(short l, short t, short w, short h) : rectangle(l, t, w, h),
                        ws(NULL),
                        win(NULL),
                        mp(NULL),
                        idcmp(NULL),
                        hasgadgets(FALSE),
                        hasmenus(FALSE),
                        active(FALSE),
                        initok(FALSE),
                        okflag(FALSE),
                        g(NULL),
                        rp(NULL),
                        signal(NULL),
                        reqfunc(NULL),
                        tags(NULL),
                        bgrp(NULL),
                        bgbm(NULL),
                        emode(0)
{
    link.win = this ;
    winlist->addtail(&link) ;
}


window::~window()
{
    if (initok) close() ;
    winlist->remove(&link) ;
}


// _open -- parameter list version
// calls same function with arrays
void window::_open(MsgPort *wp, ULONG iflags, ULONG data, ...)
{
    _open(wp, iflags, (TagItem *)&data) ;
}

// _open -- var-array version
// Calls OpenWindow, copy tags if any
void __saveds window::_open(MsgPort *wp, ULONG iflags, TagItem *t)
{
    tags = CloneTagItems(t) ; // A NULL result in cloning tags is tolerated
                              // Because either the window should fail or
                              // the parameter passed is already NULL.
                              // In other terms, the window will open
                              // with default parameters if enough memory.
    mp = wp ;

    // IDCMP_REFRESH...  obligatoire : il ne sera délivré aucun passe-droit.
    idcmp = iflags | IDCMP_REFRESHWINDOW ;

    initok = active = FALSE ;
    selfmsg = BOOL(!mp) ;
    win = OpenWindowTags(NULL,
        WA_Left,        left,
        WA_Top,         top,
        WA_InnerWidth,  width,
        WA_InnerHeight, height,
        WA_AutoAdjust,  TRUE,
        WA_CustomScreen, (LONG)ws->scr,
        TAG_MORE,       tags) ; // TAG_MORE is a terminaison point
                                // i.e. no TAG_DONE necessary.

    if (win) {
        active = initok = TRUE ;
        win->UserData = (BYTE *)this ;  // User data contains object pointer
        rp = win->RPort ;
        if (!selfmsg) win->UserPort = mp ;  // Shared message port
        if (ModifyIDCMP(win, idcmp)) {      // idcmp is never NULL (refresh at least)
            mp = win->UserPort ;
            signal = 1 << mp->mp_SigBit ;
        }
        else {  // This is probably a signal allocation failure, try to free some
            CloseWindow(win) ;
            win = NULL ;
            active = initok = FALSE ;
        }
    }
}

void window::open(screen *nws)
{
    ws = nws ;
    _open(NULL, IDCMP_CLOSEWINDOW,
        WA_CloseGadget, TRUE,
        TAG_DONE) ;
}

void window::close()
{
Menu    *m ;

                    // initok indique que TOUTES les opérations à
    if (initok) {   // l'initialisation ont réussi
        if (tags) FreeTagItems(tags) ;
        if (win) {
            strip();
            if (hasmenus) {
                ClearMenuStrip(win) ;
                while (menu) {
                    m = menu->NextMenu ;
                    FreeMenus(menu) ;
                    menu = m ;
                }
                hasmenus = FALSE ;
            }
            CloseWindow(win) ;
            if (hasgadgets) {
                delete g ;
                g = NULL ;
                hasgadgets = FALSE ;
            }
            win = NULL ;
        }
    }
    initok = active = FALSE ;
}


void window::strip()
{
    Forbid();
    stripimsg() ;
    if (!selfmsg)
        win->UserPort = NULL;
    ModifyIDCMP(win, NULL);
    Permit();
}


void window::stripimsg()
{
IntuiMessage *msg;
Node *succ;

    msg = (IntuiMessage *) mp->mp_MsgList.lh_Head;

    while( succ =  msg->ExecMessage.mn_Node.ln_Succ ) {

        if( msg->IDCMPWindow ==  win ) {

            /* Intuition is about to free this message.
             * Make sure that we have politely sent it back.
             */
            Remove( (Node *)msg );

            ReplyMsg( (Message *)msg );
        }

        msg = (IntuiMessage *) succ;
    }
}


void window::eventloop()
{
IntuiMessage *msg ;

    if (initok) {
        while (active) {
            Wait(signal) ;
            while (msg = (IntuiMessage *)GetMsg(win->UserPort)) {
                processevents(msg) ;
                ReplyMsg((Message *)msg) ;
            }
        }
    }
}

void window::processevents(IntuiMessage *msg)
{
IntuiMessage    *gt_msg, smsg ;
BOOL            doevents ;
static Gadget   *curgad = NULL ;
static ULONG    curattr ;

    gt_msg = NULL ;
    doevents = FALSE ;
    if (msg->Class & (IDCMP_MOUSEMOVE|IDCMP_GADGETUP|IDCMP_GADGETDOWN)) {
        switch(msg->Class) {
        case IDCMP_GADGETDOWN:
            curgad = (Gadget *)msg->IAddress ;
            curattr = ULONG(curgad->UserData) ;
            if (!curattr) gt_msg = GT_FilterIMsg(msg) ;
            break ;
        case IDCMP_GADGETUP:
            curgad = NULL ;
            gt_msg = GT_FilterIMsg(msg) ;
            break ;
        case IDCMP_MOUSEMOVE:
            if (curgad && curattr) {
            ULONG code, res ;
                msg->IAddress = curgad ;
                res = GetAttr(curattr, curgad, &code) ;
                msg->Code = USHORT(res) ;
                doevents = TRUE ;
            }
            else {
                gt_msg = GT_FilterIMsg(msg) ;
            }
            break ;
        }
    }
    else {
        gt_msg = GT_FilterIMsg(msg) ;
    }


    if (doevents || gt_msg) {
        doevents = TRUE ;
        smsg = (gt_msg)?*gt_msg:*msg ;
    }
    GT_PostFilterIMsg(gt_msg) ;
    if (doevents) simpleevent(&smsg) ;
}

void window::simpleevent(IntuiMessage *msg)
{
MenuItem *item ;
void (*menufunc)() ;
TagItem *tags ;
unsigned long id, classe ;
USHORT code ;
Gadget *gad ;
gadget *gd ;

    code = msg->Code ;
    classe = msg->Class ;
    gad = (Gadget *)msg->IAddress ;
    switch (classe) {
        case IDCMP_CLOSEWINDOW:
            active = FALSE ;
            break ;
        case IDCMP_MENUPICK:
            if (hasmenus) {
                while (code != MENUNULL) {
                    item = ItemAddress(menu, code);
                    menufunc = (void (*)())GTMENUITEM_USERDATA(item);
                    if (menufunc) {
                        menufunc();
                    }
                    code = item->NextSelect;
                }
            }
            break ;
        case IDCMP_IDCMPUPDATE:
            tags = (TagItem *)gad ;
            id = GetTagData(GA_ID, 0, tags) ;
            gd = g->getgadget(id) ;
            code = (unsigned short)GetTagData(ULONG(gd->gad->UserData), 0, tags) ;
            g->processgadget(id, classe, code) ;
            break ;
        case IDCMP_GADGETUP:
        case IDCMP_GADGETDOWN:
        case IDCMP_MOUSEMOVE:
            if (hasgadgets) {
                g->processgadget(gad->GadgetID, classe, code) ;
            }
            else if (gad->GadgetType & GTYP_REQGADGET)
                if (reqfunc) reqfunc(gad->GadgetID, classe, code) ;
            break ;
        case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh(win) ;
            GT_EndRefresh(win, TRUE) ;
            break ;
        case IDCMP_VANILLAKEY:
            handlevkey(code) ;
            break ;
        case IDCMP_RAWKEY:
            handlerawkey(code) ;
            break ;
        case IDCMP_MOUSEBUTTONS:
            handlemousebuttons(code, msg->MouseX, msg->MouseY, msg->Qualifier) ;
            break ;
    }
}


void window::setmenus(NewMenu *menu1, ...)
{
NewMenu **pmenu ;
NewMenu *cmenu ;
Menu *m, *pm ;

    menu = pm = NULL ;
    pmenu = &menu1 ;
    cmenu = *pmenu++ ;
    while (cmenu) {
        m = CreateMenus(cmenu,
            TAG_DONE) ;
        if (pm) {
            pm->NextMenu = m ;
            pm = m ;
        }
        else {
            menu = pm = m ;
        }
        cmenu = *pmenu++ ;
    }
    LayoutMenus(menu, ws->vi,
        GTMN_NewLookMenus,  TRUE,
        TAG_DONE) ;

    SetMenuStrip(win, menu) ;
    hasmenus = TRUE ;
}


void window::expandmenu(Menu *curm, NewMenu *extmenu)
{
Menu *sm, *pm, *nm ;

    if (!menu)                  // no menus ?
        return ;

    sm = curm->NextMenu ;
    if (curm == menu)
        pm = NULL ;
    else {
        pm = menu ;
        while (pm->NextMenu && pm->NextMenu != curm)
            pm = pm->NextMenu ;
    }

    nm = CreateMenus(extmenu,
                TAG_DONE) ;

    if (nm) {
        ClearMenuStrip(win) ;
        nm->NextMenu = sm ;
        if (pm) pm->NextMenu = nm ;
        LayoutMenus(menu, ws->vi,
            GTMN_NewLookMenus, TRUE,
            TAG_DONE) ;
        SetMenuStrip(win, menu) ;
        curm->NextMenu = NULL ;
        FreeMenus(curm) ;
    }
}

void window::menuchanges(menustate *ms, LONG count)
{
long i ;

    ClearMenuStrip(win) ;
    for (i=0; i<count; i++) {

        if (ms[i].checked)
            ms[i].item->Flags |=  CHECKED ;
        else
            ms[i].item->Flags &= ~CHECKED ;

        if (ms[i].enable)
            ms[i].item->Flags |=  ITEMENABLED ;
        else
            ms[i].item->Flags &=  ~ITEMENABLED ;

    }
    ResetMenuStrip(win, menu) ;
}


short window::initarea(short w, short h, int size)
{
short retval = TRUE ;

    if (areaBuffer = new WORD[size]) {
        if (areaInfo = new AreaInfo) {
            if (tmpRas = new TmpRas) {
                if (GfxBase->LibNode.lib_Version >= 39) {
                    tmpBitMap = AllocBitMap(w, h, 1,
                        BMF_CLEAR|BMF_INTERLEAVED|BMF_DISPLAYABLE, ws->scr->RastPort.BitMap) ;
                    if (!tmpBitMap)
                        retval = FALSE ;
                    else {
                        tmpBuffer = tmpBitMap->Planes[0] ;
                        InitTmpRas(tmpRas, tmpBuffer, tmpBitMap->BytesPerRow * h);
                    }
                }
                else {
                    tmpBuffer = (PLANEPTR)AllocRaster(w, h);
                    if (!tmpBuffer)
                        retval = FALSE ;
                    else
                        InitTmpRas(tmpRas, tmpBuffer, RASSIZE(w, h));
                }

                if (retval) {
                    InitArea(areaInfo, areaBuffer, (size*2)/5);
                    awidth = w ;
                    aheight = h ;
                    asize = size ;
                    rp->AreaInfo = areaInfo;
                    rp->TmpRas = tmpRas;
                }
            }
        }
    }
    if (!retval) freearea() ;
    return retval ;
}

void window::freearea()
{

    if (GfxBase->LibNode.lib_Version >= 39) {
        if (tmpBitMap) FreeBitMap(tmpBitMap) ;
    }
    else
        if (tmpBuffer) FreeRaster(tmpBuffer, awidth, aheight);
    tmpBitMap = NULL ;
    tmpBuffer = NULL ;

    if (tmpRas) {
        delete tmpRas ;
        tmpRas = NULL ;
    }
    if (areaInfo) {
        delete areaInfo ;
        areaInfo = NULL ;
    }
    if (areaBuffer) {
        delete [] areaBuffer ;
        areaBuffer = NULL ;
    }

}


void window::prepbox(BOOL center)
{
long mw = g->lmax(ok, cancel, NULL) + 20 ;

    g->box( ws->scr->WBorLeft+20,
            g->maxh+8,
            mw,
            g->fontheight*3/2) ;

    g->setgpen(ws->xpens[GREEN_PEN]) ;
    new fbutton(g, WFUNC(&window::fok), ok, TRUE) ;

    g->move(g->maxw-g->left-mw) ;
    g->setgpen(ws->xpens[RED_PEN]) ;
    new fbutton(g, WFUNC(&window::fcancel), cancel, FALSE) ;


    width = short(g->maxw-ws->scr->WBorLeft+20) ;
    height = short(g->maxh-ws->winbarheight+8) ;

    if (center) {
        left = short((ws->width - width - ws->scr->WBorLeft-ws->scr->WBorRight) / 2) ;
        top = short((ws->height - height - ws->winbarheight - ws->scr->WBorBottom) / 2) ;
    }

}

void window::move(short dx, short dy)
{
    rectangle::move(dx, dy) ;
    if (win) ChangeWindowBox(win, left, top, width, height) ;
}

void window::size(short dw, short dh)
{
    rectangle::size(dw, dh) ;
    if (win) ChangeWindowBox(win, left, top, width, height) ;
}

void window::box(short x, short y, short w, short h)
{
    rectangle::box(x, y, w, h) ;
    if (win) ChangeWindowBox(win, left, top, width, height) ;
}

void window::limits(short wmin, short hmin, short wmax, short hmax)
{
    rectangle::limits(wmin, hmin, wmax, hmax) ;
    if (win) WindowLimits(win, minw, minh, maxw, maxh) ;
}
void window::pmove(long x, long y)                     // Move(rp, ...)
{
    Move(rp, x, y) ;
}

void window::text( const char *string, unsigned long count )
{
    Text(rp, STRPTR(string), count) ;
}

void window::otext( long x, long y, const char *string )
{
    pmove(x, y) ;
    text(string, strlen(string)) ;
}

void window::fname(gadget *g, unsigned long classe, unsigned short code)
{
    strcpy(sname, ((string *)g)->curstring) ;
}

#if defined( __GNUG__ )
ADD2INIT(_STI_4500_initouicat, -40);
ADD2INIT(_STI_4500_initwinlist, -40);
ADD2EXIT(_STD_4500_closeouicat,-40);
ADD2EXIT(_STD_4500_closewinlist,-40);
#endif
@


1.4
log
@*** empty log message ***
@
text
@d1 1
a1 1
// $Id: window.cc 1.3 1997/07/14 04:21:30 dlorre Exp dlorre $
d28 1
d42 10
d83 9
d94 1
d336 3
d429 1
a429 1
short retval = FALSE ;
d434 10
a443 3
                tmpBuffer = (UBYTE *)AllocRaster( w, h ) ;
                if (!tmpBuffer)
                    retval = FALSE ;
d445 8
a453 4

                   // docs say don't use RASSIZE in V39 but I don't know yet
                   // another way of doing this
                    InitTmpRas(tmpRas, tmpBuffer, RASSIZE( w, h )) ;
a458 1
                    retval = TRUE ;
d469 3
a471 3
    if (tmpBuffer) {
        FreeRaster(tmpBuffer, awidth, aheight ) ;
        tmpBuffer = NULL ;
d473 5
d567 1
d569 1
@


1.3
log
@*** empty log message ***
@
text
@d1 1
a1 1
// $Id: window.cc 1.2 1996/08/28 20:07:00 dlorre Exp dlorre $
d83 1
a83 1
void window::_open(MsgPort *wp, ULONG iflags, TagItem *t)
d96 1
a96 1
    selfmsg = BOOL(!mp  && idcmp) ;
d112 9
a120 3
        ModifyIDCMP(win, idcmp);            // idcmp is never NULL (refresh at least)
        mp = win->UserPort ;
        signal = 1 << mp->mp_SigBit ;
@


1.2
log
@toutes les fonctions d'une ligne sont passées en INLINE dans window.h
@
text
@d1 1
a1 1
// $Id$
d9 1
d13 1
a17 1
#include "locale.h"
d19 7
a25 7
#include <cxxproto/exec.h>
#include <cxxproto/graphics.h>
#include <cxxproto/layers.h>
#include <cxxproto/intuition.h>
#include <cxxproto/gadtools.h>
#include <cxxproto/utility.h>
#include <cclib/debug_protos.h>
d28 4
d41 9
a49 6
lstring  ok(ocat, "_Ok", 1) ;
lstring  cancel(ocat, "_Cancel") ;
lstring  parent(ocat, "_Parent") ;
lstring  drawer(ocat, "_Drawer:") ;
lstring  file(ocat, "_File:") ;
lstring  comment(ocat, "Co_mment:") ;
d103 1
a103 1
        WA_CustomScreen, (LONG)ws->screen,
d112 1
a112 1
        ModifyIDCMP(win, idcmp);            // idcmp is never NULL (refresh at list)
d129 1
d399 1
a399 1
short retval ;
d401 21
a421 19
    areaBuffer = new WORD[size] ;
    areaInfo = new AreaInfo ;
    tmpRas = new TmpRas ;

    tmpBuffer = (UBYTE *)AllocRaster( w, h ) ;
    if (!tmpBuffer)
        retval = FALSE ;
    else {
        InitArea(areaInfo, areaBuffer, (size*2)/5);

       // docs say don't use RASSIZE in V39 but I don't know yet
       // another way of doing this
        InitTmpRas(tmpRas, tmpBuffer, RASSIZE( w, h )) ;
        awidth = w ;
        aheight = h ;
        asize = size ;
        rp->AreaInfo = areaInfo;
        rp->TmpRas = tmpRas;
        retval = TRUE ;
d423 1
d429 17
a445 4
    FreeRaster(tmpBuffer, awidth, aheight ) ;
    delete tmpRas ;
    delete areaInfo ;
    delete [] areaBuffer ;
d453 1
a453 1
    g->box( ws->screen->WBorLeft+20,
d456 1
a456 1
            g->fontheight*2) ;
d466 1
a466 1
    width = short(g->maxw-ws->screen->WBorLeft+20) ;
d470 2
a471 2
        left = short((ws->width - width - ws->screen->WBorLeft-ws->screen->WBorRight) / 2) ;
        top = short((ws->height - height - ws->winbarheight - ws->screen->WBorBottom) / 2) ;
d476 24
a499 1
void winlist::dumplist()
d501 1
d504 15
d520 4
@


1.1
log
@Initial revision
@
text
@d1 1
d12 1
d61 2
a62 1
                        bgbm(NULL)
a181 4
void window::resetidcmp()
{
    ModifyIDCMP(win, idcmp) ;
}
a302 63
void window::setfunc(void (*func)(long, unsigned long, unsigned short))
{
    reqfunc = func ;
}

void window::move(short dx, short dy)
{
    rectangle::move(dx, dy) ;
    if (win) ChangeWindowBox(win, left, top, width, height) ;
}
void window::size(short dw, short dh)
{
    rectangle::size(dw, dh) ;
    if (win) ChangeWindowBox(win, left, top, width, height) ;
}
void window::box(short x, short y, short w, short h)
{
    rectangle::box(x, y, w, h) ;
    if (win) ChangeWindowBox(win, left, top, width, height) ;
}

void window::limits(short wmin, short hmin, short wmax, short hmax)
{
    rectangle::limits(wmin, hmin, wmax, hmax) ;
    if (win) WindowLimits(win, minw, minh, maxw, maxh) ;
}

void window::titles(STRPTR wt, STRPTR st)
{
    if (win) SetWindowTitles(win, wt, st) ;
}

void window::activate()
{
    if (win) ActivateWindow(win) ;
}

void window::front()
{
    if (win) WindowToFront(win) ;
}

void window::back()
{
    if (win) WindowToBack(win) ;
}

void window::recessedbox(short x, short y, short w, short h)
{
    if (win)
        DrawBevelBox(rp, x, y, w, h,
        GT_VisualInfo, ws->vi,
        GTBB_Recessed, TRUE,
        TAG_END);
}

void window::bevelbox(short x, short y, short w, short h)
{
    if (win)
        DrawBevelBox(rp, x, y, w, h,
        GT_VisualInfo, ws->vi,
        TAG_END);
}
a386 175
MenuItem *window::itemaddress( unsigned long menuNumber )
{
    return ItemAddress( menu, menuNumber) ;
}

MenuItem *window::itemaddress(LONG m, LONG i, LONG s)
{
    return ItemAddress(menu, FULLMENUNUM(m, i, s)) ;
}

void window::pmove(long x, long y)
{
    Move(rp, x, y) ;
}

void window::draw(long x, long y)
{
    Draw(rp, x, y) ;
}

void window::polydraw(long count, WORD *polyTable)
{
    PolyDraw(rp, count, polyTable) ;
}

void window::rectfill(long xMin, long yMin, long xMax, long yMax)
{
    RectFill(rp, xMin, yMin, xMax, yMax) ;
}

void window::eraserect(long xMin, long yMin, long xMax, long yMax )
{
    EraseRect(rp, xMin, yMin, xMax, yMax) ;
}

void window::setapen(unsigned long pen)
{
    SetAPen(rp, pen) ;
}

void window::setbpen(unsigned long pen)
{
    SetBPen(rp, pen) ;
}

void window::setopen(unsigned long pen)
{
    SafeSetOutlinePen(rp, pen) ;
}

void window::setrast(unsigned long pen)
{
    SetRast(rp, pen) ;
}

void window::setdrmd(unsigned long drawMode)
{
    SetDrMd(rp, drawMode) ;
}

void window::setdrpt(unsigned short pattern)
{
    SetDrPt(rp, pattern) ;
}

void window::text( STRPTR string, unsigned long count )
{
    Text(rp, string, count) ;
}

void window::otext( long x, long y, STRPTR string )
{
    pmove(x, y) ;
    text(string, strlen(string)) ;
}

short window::textlength(STRPTR string, unsigned long count )
{
    return TextLength(rp, string, count );
}

unsigned long window::textfit(STRPTR string, unsigned long strLen,
        struct TextExtent *textExtent, struct TextExtent *constrainingExtent,
        long strDirection, unsigned long constrainingBitWidth,
        unsigned long constrainingBitHeight )
{
    return TextFit(rp, string, strLen, textExtent, constrainingExtent,
        strDirection, constrainingBitWidth, constrainingBitHeight) ;
}


void window::setfont(TextFont *font)
{
    SetFont( rp, font) ;
}
void window::printitext(IntuiText *iText, long left, long top )
{
    PrintIText( rp, iText, left, top) ;
}

void window::drawborder( Border *border, long leftOffset, long topOffset )
{
    DrawBorder( rp, border, leftOffset, topOffset );
}

void window::drawimage( Image *image, long leftOffset, long topOffset )
{
    DrawImage( rp, image, leftOffset, topOffset );
}

void window::eraseimage( Image *image, long leftOffset, long topOffset )
{
    EraseImage( rp, image, leftOffset,  topOffset );
}

int window::newregion(void)
{
    clipregion = NewRegion() ;
    if (clipregion)
        cliprect = new Rectangle ;
    return (clipregion != NULL) ;

}

void window::addregion(short l, short t, short w, short h)
{
    cliprect->MinX = l ;
    cliprect->MaxX = short(l+w) ;
    cliprect->MinY = t ;
    cliprect->MaxY = short(t+h) ;
    OrRectRegion(clipregion, cliprect) ;
}

void window::disposeregion(void)
{
    delete cliprect ;
    DisposeRegion( clipregion );
}

void window::installclip(void)
{
    InstallClipRegion(win->WLayer, clipregion) ;
}

void window::removeclip(void)
{
    clipregion = InstallClipRegion(win->WLayer, NULL) ;
}

void window::setpointer( UWORD *pointer, long height, long width,
                         long xOffset, long yOffset )
{
    SetPointer(win, pointer, height, width, xOffset, yOffset) ;
}

void window::clearpointer()
{
    ClearPointer(win) ;
}

void window::beginrefresh()
{
    GT_BeginRefresh(win) ;
}

void window::endrefresh(BOOL end)
{
    GT_EndRefresh(win, end) ;
}

void window::refreshwindowframe()
{
    RefreshWindowFrame(win) ;
}

a422 60
long window::areaellipse( long xCenter, long yCenter, long a, long b )
{
    return AreaEllipse( rp, xCenter, yCenter, a, b ) ;
}

long window::areamove( long x, long y )
{
    return AreaMove( rp, x, y );
}

long window::areadraw( long x, long y )
{
    return AreaDraw( rp, x, y );
}

long window::areaend()
{
    return AreaEnd( rp );
}

BOOL window::flood( unsigned long mode, long x, long y )
{
    return Flood( rp, mode, x, y );
}

void window::setbgrp(RastPort *brp)
{
    rp = bgrp = brp ;
    bgbm = bgrp->BitMap ;
}

void window::clearbgrp()
{
    rp = win->RPort ;
}

void window::flushbg(int x, int y, int w, int h, int mode)
{
    BltBitMapRastPort(bgbm, 0, 0, win->RPort, x, y, w, h, mode);
}

void window::fok(gadget *g, unsigned long classe, unsigned short code)
{
    okflag = TRUE; active = FALSE ; emode = 0 ; applique = FALSE ;
}

void window::fcancel(gadget *g, unsigned long classe, unsigned short code)
{
    okflag = FALSE; active = FALSE ; emode = 0 ; applique = FALSE ;
}

void window::fapply(gadget *g, unsigned long classe, unsigned short code)
{
    okflag = TRUE; active = FALSE ; emode = 0 ; applique = TRUE ;
}

void window::fname(gadget *g, unsigned long classe, unsigned short code)
{
    strcpy(sname, ((string *)g)->curstring) ;
}
d431 1
a431 1
            g->fontheight+4) ;
a448 8
}

void window::handlevkey(USHORT code)
{
}

void window::handlerawkey(USHORT code)
{
@
