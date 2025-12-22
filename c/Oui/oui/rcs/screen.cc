head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@// @;


1.2
date	97.07.14.04.20.02;	author dlorre;	state Exp;
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
#include <exec/types.h>
#include <graphics/gfxbase.h>
#include <intuition/intuitionbase.h>
#include <intuition/screens.h>
#include <clib/macros.h>
#include <mydebug.h>

#include "screen.h"

#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/gadtools.h>

#include <stdio.h>

const UWORD NOMATCH = 0xFFFF ;

screen::screen(UWORD *xp, STRPTR name)
{
    status = FALSE ;
    owner = FALSE ;
    xpens = new UWORD[NUM_XPENS] ;
    if (xpens) {
        if (xp) {
            defpens = NULL ;
            setxpens(xp) ;
        }
        else {
            defpens = new UWORD[NUM_XPENS] ;
        }
        if (xp || defpens) {
            scr = LockPubScreen((UBYTE *)name) ;
            if (!scr)
                scr = LockPubScreen(NULL) ;
            if (scr)
                init() ;
        }
    }
}

screen::screen(UWORD *xp, ULONG tdata, ...)
{
TagItem *tags = (TagItem *)&tdata ;
    status = FALSE ;
    owner = TRUE ;
    xpens = new UWORD[NUM_XPENS] ;
    if (xpens) {
        if (xp) {
            defpens = NULL ;
            setxpens(xp) ;
        }
        else
            defpens = new UWORD[NUM_XPENS] ;
        if (xp || defpens) {
            scr = OpenScreenTags(NULL,
                SA_ErrorCode,   &error,
                TAG_MORE,       tags) ;

            if (scr)
                init() ;
        }
    }
}

screen::screen(UWORD *xp, TagItem *tags)
{
    status = FALSE ;
    owner = TRUE ;
    xpens = new UWORD[NUM_XPENS] ;
    if (xpens) {
        if (xp) {
            defpens = NULL ;
            setxpens(xp) ;
        }
        else
            defpens = new UWORD[NUM_XPENS] ;
        if (xp || defpens) {
            scr = OpenScreenTags(NULL,
                SA_ErrorCode,   &error,
                TAG_MORE,       tags) ;

            if (scr)
                init() ;
        }
    }
}

void screen::init()
{

    vi = GetVisualInfo(scr, TAG_DONE);
    if (vi) {
        font = OpenFont(scr->Font) ;
        if (font) {
            drawinfo = GetScreenDrawInfo(scr) ;
            if (drawinfo) {
                rp = &scr->RastPort ;
                getsize() ;
                if (defpens) {
                    setdefpens() ;
                }
                status = TRUE ;
            }
            else
                error = -3 ;
        }
        else
            error = -2 ;
    }
    else
        error = -1 ;
}

screen::~screen()
{
    if (xpens)
        delete xpens ;

    if (defpens) {
        if (GfxBase->LibNode.lib_Version >=39) {
            ColorMap *cm = scr->ViewPort.ColorMap ;
            ReleasePen(cm, defpens[GREEN_PEN]) ;
            ReleasePen(cm, defpens[RED_PEN]) ;
            ReleasePen(cm, defpens[WHITE_PEN]) ;
            ReleasePen(cm, defpens[BLACK_PEN]) ;
        }
        delete defpens ;
    }
    if (drawinfo)
        FreeScreenDrawInfo(scr, drawinfo) ;
    if (font)
        CloseFont(font) ;
    if (vi)
        FreeVisualInfo(vi) ;
    if (scr) {
        if (owner)
            CloseScreen(scr) ;
        else {
            UnlockPubScreen(NULL, scr) ;
        }
    }
}


void screen::getsize()
{
DisplayInfo displayinfo ;
DisplayInfoHandle handle ;
ULONG   modeid ;

    left = short(MAX(0, -scr->LeftEdge)) ;
    top = short(MAX(0, -scr->TopEdge) + scr->BarHeight + 1) ;
    height = short(scr->Height - scr->BarHeight) ;
    width = scr->Width ;
    winbarheight = short(scr->WBorTop + font->tf_YSize + 1) ;
    xratio = yratio = 1 ;
    modeid = GetVPModeID(&scr->ViewPort);

    if ((modeid != INVALID_ID) && (handle = FindDisplayInfo(modeid))) {
        if (GetDisplayInfoData(handle, (UBYTE *)&displayinfo, sizeof(DisplayInfo),
            DTAG_DISP, NULL) && displayinfo.PixelSpeed) {
            /* This two lines are code from Ghostscript amiga device */
                xratio = (35*140) / displayinfo.PixelSpeed ;
                yratio = (xratio * displayinfo.Resolution.x) / displayinfo.Resolution.y ;
        }
    }
}


void screen::front()
{
    ScreenToFront(scr) ;
}

void screen::back()
{
    ScreenToBack(scr) ;
}

void screen::cfront()
{
    if (IntuitionBase->LibNode.lib_Version >= 39)
        ScreenDepth(scr, SDEPTH_TOFRONT | SDEPTH_INFAMILY, NULL) ;
    else
        ScreenToFront(scr) ;
}

void screen::cback()
{
    if (IntuitionBase->LibNode.lib_Version >= 39)
        ScreenDepth(scr, SDEPTH_TOBACK | SDEPTH_INFAMILY, NULL) ;
    else
        ScreenToBack(scr) ;
}


void screen::beep()
{
    DisplayBeep(scr) ;
}

void screen::setxpens(UWORD *p)
{
int i = 0 ;

    while (p[i] != 0xFFFF) {
        xpens[i] = p[i++]  ;
    }
}

void screen::setdefpens()
{
int i ;
ColorMap *cm = scr->ViewPort.ColorMap ;

    if (GfxBase->LibNode.lib_Version >= 39) {

        defpens[GREEN_PEN] = ObtainBestPen(cm,
            0x00000000,
            0xffffffff,
            0x00000000,
            OBP_Precision,  PRECISION_IMAGE,
            OBP_FailIfBad,  TRUE,
            TAG_DONE) ;

        defpens[RED_PEN] = ObtainBestPen(cm,
            0xffffffff,
            0x00000000,
            0x00000000,
            OBP_Precision,  PRECISION_IMAGE,
            OBP_FailIfBad,  TRUE,
            TAG_DONE) ;

        defpens[WHITE_PEN] = ObtainBestPen(cm,
            0xffffffff,
            0xffffffff,
            0xffffffff,
            OBP_Precision,  PRECISION_IMAGE,
            OBP_FailIfBad,  TRUE,
            TAG_DONE) ;

        defpens[BLACK_PEN] = ObtainBestPen(cm,
            0x00000000,
            0x00000000,
            0x00000000,
            OBP_Precision,  PRECISION_IMAGE,
            OBP_FailIfBad,  TRUE,
            TAG_DONE) ;

    }
    else {
        defpens[GREEN_PEN] = drawinfo->dri_Pens[HIGHLIGHTTEXTPEN] ;
        defpens[RED_PEN] = drawinfo->dri_Pens[TEXTPEN] ;
        defpens[WHITE_PEN] = drawinfo->dri_Pens[HIGHLIGHTTEXTPEN] ;
        defpens[BLACK_PEN] = drawinfo->dri_Pens[TEXTPEN] ;
    }
    defpens[GFILL_PEN] = drawinfo->dri_Pens[BACKGROUNDPEN] ;
    defpens[GBORDER_PEN] = drawinfo->dri_Pens[TEXTPEN] ;
    defpens[BUTTONFILL_PEN] = drawinfo->dri_Pens[BACKGROUNDPEN] ;
    if (GfxBase->LibNode.lib_Version >= 39) {
        xpens[GREEN_PEN] =
            (defpens[GREEN_PEN] != NOMATCH) ? defpens[GREEN_PEN] :
            FindColor(cm,
                0x00000000,
                0xffffffff,
                0x00000000,
                -1) ;

        xpens[RED_PEN] =
            (defpens[RED_PEN] != NOMATCH) ? defpens[RED_PEN] :
            FindColor(cm,
                0xffffffff,
                0x00000000,
                0x00000000,
                -1) ;
        xpens[WHITE_PEN] =
            (defpens[WHITE_PEN] != NOMATCH) ? defpens[WHITE_PEN] :
            FindColor(cm,
                0xffffffff,
                0xffffffff,
                0xffffffff,
                -1) ;
        xpens[BLACK_PEN] =
            (defpens[BLACK_PEN] != NOMATCH) ? defpens[BLACK_PEN] :
            FindColor(cm,
                0x00000000,
                0x00000000,
                0x00000000,
                -1) ;

        if (xpens[WHITE_PEN] == 0) xpens[WHITE_PEN] = (drawinfo->dri_Depth > 1)?2:1 ;
        if (xpens[BLACK_PEN] == 0) xpens[BLACK_PEN] = 1 ;
        if (xpens[BLACK_PEN] >0x0F &&
            IntuitionBase->LibNode.lib_Version == 39)
                xpens[BLACK_PEN] = 1 ;
        if (xpens[GREEN_PEN] == 0) xpens[GREEN_PEN] = (drawinfo->dri_Depth > 1)?2:1 ;
        if (xpens[RED_PEN] == 0) xpens[RED_PEN] = 1 ;
        i = 4 ;
    }
    else
        i = 0 ;
    while (i < NUM_XPENS)
        xpens[i] = defpens[i++] ;
}@


1.1
log
@Initial revision
@
text
@d1 1
d6 2
a7 2
#include <cclib/macros.h>
#include <cclib/debug_protos.h>
d11 3
a13 3
#include <cxxproto/graphics.h>
#include <cxxproto/intuition.h>
#include <cxxproto/gadtools.h>
d17 3
a19 1
screen::screen(STRPTR name)
d25 12
a36 6
        defpens = new UWORD[NUM_XPENS] ;
        if (defpens) {
            screen = LockPubScreen(name) ;
            if (!screen)
                screen = LockPubScreen(NULL) ;
            if (screen)
d42 1
a42 1
screen::screen(ULONG tdata, ...)
d49 8
a56 3
        defpens = new UWORD[NUM_XPENS] ;
        if (defpens) {
            screen = OpenScreenTags(NULL,
d60 1
a60 1
            if (screen)
d66 1
a66 1
screen::screen(TagItem *tags)
d72 8
a79 3
        defpens = new UWORD[NUM_XPENS] ;
        if (defpens) {
            screen = OpenScreenTags(NULL,
d83 1
a83 1
            if (screen)
a90 2
int i ;
ColorMap *cm = screen->ViewPort.ColorMap ;
d92 1
a92 1
    vi = GetVisualInfo(screen, TAG_DONE);
d94 1
a94 1
        font = OpenFont(screen->Font) ;
d96 1
a96 1
            drawinfo = GetScreenDrawInfo(screen) ;
d98 1
a98 1
                rp = &screen->RastPort ;
d100 2
a101 40
                if (GfxBase->LibNode.lib_Version >= 39) {

                    defpens[GREEN_PEN] = ObtainBestPen(cm,
                        0x00000000,
                        0xffffffff,
                        0x00000000,
                        OBP_Precision,  PRECISION_IMAGE,
                        OBP_FailIfBad,  TRUE,
                        TAG_DONE) ;

                    defpens[RED_PEN] = ObtainBestPen(cm,
                        0xffffffff,
                        0x00000000,
                        0x00000000,
                        OBP_Precision,  PRECISION_IMAGE,
                        OBP_FailIfBad,  TRUE,
                        TAG_DONE) ;

                    defpens[WHITE_PEN] = ObtainBestPen(cm,
                        0xffffffff,
                        0xffffffff,
                        0xffffffff,
                        OBP_Precision,  PRECISION_IMAGE,
                        OBP_FailIfBad,  TRUE,
                        TAG_DONE) ;

                    defpens[BLACK_PEN] = ObtainBestPen(cm,
                        0x00000000,
                        0x00000000,
                        0x00000000,
                        OBP_Precision,  PRECISION_IMAGE,
                        OBP_FailIfBad,  TRUE,
                        TAG_DONE) ;

                }
                else {
                    defpens[GREEN_PEN] = drawinfo->dri_Pens[HIGHLIGHTTEXTPEN] ;
                    defpens[RED_PEN] = drawinfo->dri_Pens[TEXTPEN] ;
                    defpens[WHITE_PEN] = drawinfo->dri_Pens[HIGHLIGHTTEXTPEN] ;
                    defpens[BLACK_PEN] = drawinfo->dri_Pens[TEXTPEN] ;
a102 38
                defpens[GFILL_PEN] = drawinfo->dri_Pens[BACKGROUNDPEN] ;
                defpens[GBORDER_PEN] = drawinfo->dri_Pens[TEXTPEN] ;
                if (GfxBase->LibNode.lib_Version >= 39) {
                    xpens[GREEN_PEN] =
                        (defpens[GREEN_PEN] != -1) ? defpens[GREEN_PEN] :
                        FindColor(cm,
                            0x00000000,
                            0xffffffff,
                            0x00000000,
                            -1) ;
                    xpens[RED_PEN] =
                        (defpens[RED_PEN] != -1) ? defpens[RED_PEN] :
                        FindColor(cm,
                            0xffffffff,
                            0x00000000,
                            0x00000000,
                            -1) ;
                    xpens[WHITE_PEN] =
                        (defpens[WHITE_PEN] != -1) ? defpens[WHITE_PEN] :
                        FindColor(cm,
                            0xffffffff,
                            0xffffffff,
                            0xffffffff,
                            -1) ;
                    xpens[BLACK_PEN] =
                        (defpens[BLACK_PEN] != -1) ? defpens[BLACK_PEN] :
                        FindColor(cm,
                            0x00000000,
                            0x00000000,
                            0x00000000,
                            -1) ;
                    i = 4 ;

                }
                else
                    i = 0 ;
                while (i < NUM_XPENS)
                    xpens[i] = defpens[i++] ;
d122 1
a122 1
            ColorMap *cm = screen->ViewPort.ColorMap ;
d131 1
a131 1
        FreeScreenDrawInfo(screen, drawinfo) ;
d136 1
a136 1
    if (screen) {
d138 1
a138 1
            CloseScreen(screen) ;
d140 1
a140 1
            UnlockPubScreen(NULL, screen) ;
d152 5
a156 5
    left = short(MAX(0, -screen->LeftEdge)) ;
    top = short(MAX(0, -screen->TopEdge) + screen->BarHeight + 1) ;
    height = short(screen->Height - screen->BarHeight) ;
    width = screen->Width ;
    winbarheight = short(screen->WBorTop + font->tf_YSize + 1) ;
d158 1
a158 1
    modeid = GetVPModeID(&screen->ViewPort);
d173 1
a173 1
    ScreenToFront(screen) ;
d178 1
a178 1
    ScreenToBack(screen) ;
d184 1
a184 1
        ScreenDepth(screen, SDEPTH_TOFRONT | SDEPTH_INFAMILY, NULL) ;
d186 1
a186 1
        ScreenToFront(screen) ;
d192 1
a192 1
        ScreenDepth(screen, SDEPTH_TOBACK | SDEPTH_INFAMILY, NULL) ;
d194 1
a194 1
        ScreenToBack(screen) ;
d200 1
a200 1
    DisplayBeep(screen) ;
d207 1
a207 1
    while (p[i] != ~0) {
d211 95
@
