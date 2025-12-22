// $Id: window.cc 1.5 1998/01/13 19:55:59 dlorre Exp $
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
