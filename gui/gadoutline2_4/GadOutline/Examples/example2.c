
#include <graphics/gfxmacros.h>
#include <proto/graphics.h>
#include <proto/gadtools.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <proto/asl.h>
#include <stdlib.h>
#include <string.h>

#ifndef LINKLIB
    #include "proto/gadoutline.h"
#else
    #include "libraries/gadoutline.h"
    #include "interface.h"
#endif

#ifdef DEBUGMODULE
    
    #include "support/debug.h"

#else

    void __stdargs kprintf(UBYTE *fmt,...);  // Serial debugging...
    void __stdargs dprintf(UBYTE *fmt,...);  // Parallel debugging...

    #ifndef bug
    #define bug Printf
    #endif

    #ifndef DEBTIME
    #define DEBTIME 0
    #endif

    #ifdef DEBUG
    #define D(x) (x); if(DEBTIME>0) Delay(DEBTIME);
    #else
    #define D(x) ;
    #endif

#endif

enum {
    CURSCRN_ID = 1,
    SCRNMODE_ID,

    SCRNSTR_ID,
    MODESTR_ID,

    SCRNPAL_ID,
    PALRED_ID,
    PALREDKEY_ID,
    PALGREEN_ID,
    PALGREENKEY_ID,
    PALBLUE_ID,
    PALBLUEKEY_ID,

    TITLE_ID,
    SETFONT_ID,
    FONTNAME_ID,
    FONTSIZE_ID,

    OVERSCAN_ID,

    PENPAL_ID,
    CURPEN_ID,
    CURPENKEY_ID,

    RESETSCRN_ID,
    UPDATESCRNS_ID,
    MAKESCRN_ID,
    CLOSESCRN_ID,
    
    BOOPSIGAD_ID,
    DRAWIMG_ID,
    DODISABLE_ID
};

#define STRING_LEN 100

UBYTE *PenLabels[] = {
    "Detail", "Block", "Text", "Shine", "Shadow", "Fill", "FillText",
    "Backgrnd", "Highlight", NULL
};

struct TagItem palette_tags[] =
{
    { GTPA_Color, 0 },
    { GTPA_Depth, 2 },
    { TAG_END, 0 }
};

/*********************************************
 **
 ** Main window gadget outline
 **
 *********************************************/

static ULONG outline[] = {

GO_COMMANDTAGS(0,0),
TAG_END,
GOCT_SetHotKey, 0,
TAG_END,

GO_VERTGRP(0,0,1), TAG_END,

    GO_HORIZGRP(0,0,1), TAG_END,

        GO_VERTGRP(0,0,1), TAG_END,
        
            GO_GTBOX(LISTVIEW_KIND, 0, CURSCRN_ID, 1, (ULONG)&"P_ublic Screens",
                PLACETEXT_ABOVE|NG_HIGHLABEL),
            GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdMax,1000,GOT_PercCharW),
            GOCT_SizeBodyHeight, GO_TSIZE(GOM_StdMax,300,GOT_PercCharH),
            GOCT_AddTagLink, GO_MAKELINK(GTLV_ShowSelected,SCRNSTR_ID),
            TAG_END,
            GTLV_Selected, ~0,
            GTLV_Labels, NULL,
            GTLV_ShowSelected, NULL,
            GT_Underscore, '_',
            TAG_END,

            GO_GTBOX(STRING_KIND, 0, SCRNSTR_ID, 0, NULL, 0),
            GOCT_IgnoreMinDimens, TRUE, GOCT_IgnoreFinDimens, TRUE,
            TAG_END,
            GTST_MaxChars, STRING_LEN,
            GTST_String, (ULONG)&"",
            GT_Underscore, '_',
            TAG_END,

        GO_ENDGRP(),

        GO_VERTGRP(0,0,1), TAG_END,
        
            GO_GTBOX(LISTVIEW_KIND, 0, SCRNMODE_ID, 1, (ULONG)&"Screen _Modes",
                PLACETEXT_ABOVE|NG_HIGHLABEL),
            GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdMax,1000,GOT_PercCharW),
            GOCT_SizeBodyHeight, GO_TSIZE(GOM_StdMax,300,GOT_PercCharH),
            GOCT_LinkFromTag, GTLV_ShowSelected, GOCT_LinkToStdID, MODESTR_ID,
            TAG_END,
            GTLV_Selected, ~0,
            GTLV_Labels, NULL,
            GTLV_ShowSelected, NULL,
            GT_Underscore, '_',
            TAG_END,

            GO_GTBOX(STRING_KIND, 0, MODESTR_ID, 0, NULL, 0),
            GOCT_IgnoreMinDimens, TRUE, GOCT_IgnoreFinDimens, TRUE,
            TAG_END,
            GTST_MaxChars, STRING_LEN,
            GTST_String, (ULONG)&"",
            GT_Underscore, '_',
            TAG_END,

        GO_ENDGRP(),

        GO_VERTGRP(0,0,0), TAG_END,
        
            GO_GTBOX(PALETTE_KIND, 0, SCRNPAL_ID, 1, (ULONG)&"_Palette",
                PLACETEXT_ABOVE|NG_HIGHLABEL),
            GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdMax,600,GOT_PercCharW),
            GOCT_SizeBodyHeight, GO_TSIZE(GOM_StdMax,200,GOT_PercCharH),
            GOCT_CopyFromTSize, GO_TSIZE(GOM_StdSet,15,GOT_Pixels),
            GOCT_CopyTSizeToTag, GTPA_IndicatorHeight,
            GOCT_SizeUser1, GO_TSIZE(GOM_VarSet,20,GOT_PercBodyH),
            GOCT_SizeUser1, GO_TSIZE(GOM_VarMin,250,GOT_PercCharH),
            GOCT_SizeUser1, GO_TSIZE(GOM_VarMax,6,GOT_Pixels),
            GOCT_CopyUser1ToTag, GTPA_IndicatorHeight,
            TAG_END,
            GTPA_IndicatorHeight, 15,
            GT_Underscore, '_',
            TAG_MORE, (ULONG)&palette_tags[0],
            TAG_END,

            GO_HORIZGRP(0,0,0), TAG_END,

                GO_GTBOX(SLIDER_KIND, 0, PALRED_ID, 1, NULL, 0),
                GOCT_SizeSpaceRight, GO_TSIZE(GOM_AllSet,0,GOT_Pixels),
                TAG_END,
                GA_RelVerify, TRUE, GA_Immediate, TRUE,
                PGA_FREEDOM, LORIENT_HORIZ,
                GTSL_Min, 0, GTSL_Max, 15,
                GTSL_Level, 0, GTSL_LevelFormat, (ULONG)&"%02ld",
                GTSL_LevelPlace, PLACETEXT_LEFT, GTSL_MaxLevelLen, 2,
                GT_Underscore, '_',
                TAG_END,

                GO_GTBOX(TEXT_KIND, 0, PALREDKEY_ID, 0, (ULONG)&"_R",
                    PLACETEXT_IN|NG_HIGHLABEL),
                GOCT_SizeSpaceLeft, GO_TSIZE(GOM_AllSet,0,GOT_Pixels),
                GOCT_SetHotKeyCmd, PALRED_ID,
                TAG_END,
                GTTX_Border, TRUE, // GTTX_Text, GTTX_CopyText
                GT_Underscore, '_',
                TAG_END,

            GO_ENDGRP(),

            GO_HORIZGRP(0,0,0), TAG_END,
            
                GO_GTBOX(SLIDER_KIND, 0, PALGREEN_ID, 1, NULL, 0),
                GOCT_SizeSpaceRight, GO_TSIZE(GOM_AllSet,0,GOT_Pixels),
                TAG_END,
                GA_RelVerify, TRUE, GA_Immediate, TRUE,
                PGA_FREEDOM, LORIENT_HORIZ,
                GTSL_Min, 0, GTSL_Max, 15,
                GTSL_Level, 0, GTSL_LevelFormat, (ULONG)&"%02ld",
                GTSL_LevelPlace, PLACETEXT_LEFT, GTSL_MaxLevelLen, 2,
                GT_Underscore, '_',
                TAG_END,

                GO_GTBOX(TEXT_KIND, 0, PALGREENKEY_ID, 0, (ULONG)&"_G",
                    PLACETEXT_IN|NG_HIGHLABEL),
                GOCT_SizeSpaceLeft, GO_TSIZE(GOM_AllSet,0,GOT_Pixels),
                GOCT_SetHotKeyCmd, PALGREEN_ID,
                TAG_END,
                GTTX_Border, TRUE, // GTTX_Text, GTTX_CopyText
                GT_Underscore, '_',
                TAG_END,

            GO_ENDGRP(),

            GO_HORIZGRP(0,0,0), TAG_END,
            
                GO_GTBOX(SLIDER_KIND, 0, PALBLUE_ID, 1, NULL, 0),
                GOCT_SizeSpaceRight, GO_TSIZE(GOM_AllSet,0,GOT_Pixels),
                TAG_END,
                GA_RelVerify, TRUE, GA_Immediate, TRUE,
                PGA_FREEDOM, LORIENT_HORIZ,
                GTSL_Min, 0, GTSL_Max, 15,
                GTSL_Level, 0, GTSL_LevelFormat, (ULONG)&"%02ld",
                GTSL_LevelPlace, PLACETEXT_LEFT, GTSL_MaxLevelLen, 2,
                GT_Underscore, '_',
                TAG_END,

                GO_GTBOX(TEXT_KIND, 0, PALBLUEKEY_ID, 0, (ULONG)&"_B",
                    PLACETEXT_IN|NG_HIGHLABEL),
                GOCT_SizeSpaceLeft, GO_TSIZE(GOM_AllSet,0,GOT_Pixels),
                GOCT_SetHotKeyCmd, PALBLUE_ID,
                TAG_END,
                GTTX_Border, TRUE, // GTTX_Text, GTTX_CopyText
                GT_Underscore, '_',
                TAG_END,

            GO_ENDGRP(),

        GO_ENDGRP(),

    GO_ENDGRP(),

    GO_HORIZGRP(0,0,0), TAG_END,

        GO_GTBOX(STRING_KIND, 0, TITLE_ID, 1, (ULONG)&"_Title",
            PLACETEXT_LEFT|NG_HIGHLABEL),
        GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdMax,1000,GOT_PercCharW),
        TAG_END,
        GTST_MaxChars, 100, GTST_String, (ULONG)&"",
        GT_Underscore, '_',
        TAG_END,

    GO_ENDGRP(),

    GO_HORIZGRP(0,0,0), TAG_END,

        GO_GTBOX(BUTTON_KIND, 0, SETFONT_ID, 0, (ULONG)&"S_et", PLACETEXT_IN),
        TAG_END,
        GT_Underscore, '_',
        TAG_END,

        GO_GTBOX(STRING_KIND, 0, FONTNAME_ID, 1, (ULONG)&"_Font", PLACETEXT_LEFT|NG_HIGHLABEL),
        GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdMax,300,GOT_PercCharW),
        TAG_END,
        GTST_MaxChars, 100, GTST_String, (ULONG)&"",
        GT_Underscore, '_',
        TAG_END,

        GO_GTBOX(INTEGER_KIND, 0, FONTSIZE_ID, 0, (ULONG)&"_Size", PLACETEXT_LEFT|NG_HIGHLABEL),
        GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdMax,400,GOT_PercCharW),
        TAG_END,
        GTIN_MaxChars, 3, GTIN_Number, 0,
        GT_Underscore, '_',
        TAG_END,

    GO_ENDGRP(),

    GO_HORIZGRP(0,0,0), TAG_END,

        GO_VERTGRP(0,0,0), TAG_END,
        
            GO_GTBOX(TEXT_KIND, 0, CURPENKEY_ID, 0, (ULONG)&"Screen _Drawing Pens",
                PLACETEXT_IN|NG_HIGHLABEL),
            GOCT_SetHotKeyCmd, CURPEN_ID,
            TAG_END,
            GT_Underscore, '_',
            TAG_END,

            GO_HORIZGRP(0,0,0), TAG_END,
        
                GO_GTBOX(MX_KIND, 0, CURPEN_ID, 0, NULL, PLACETEXT_LEFT),
                TAG_END,
                GA_Immediate, TRUE,
                GTMX_Labels, (ULONG)&PenLabels[0],
                GTMX_Active, 0,
                GT_Underscore, '_',
                TAG_END,

                GO_GTBOX(PALETTE_KIND, 0, PENPAL_ID, 1, NULL, 0),
                GOCT_SizeBodyWidth, GO_TSIZE(GOM_StdSet,500,GOT_PercCharW),
                GOCT_CopyFromTSize, GO_TSIZE(GOM_StdSet,15,GOT_Pixels),
                GOCT_CopyTSizeToTag, GTPA_IndicatorHeight,
                GOCT_SizeUser1, GO_TSIZE(GOM_VarSet,20,GOT_PercBodyH),
                GOCT_SizeUser1, GO_TSIZE(GOM_VarMin,250,GOT_PercCharH),
                GOCT_SizeUser1, GO_TSIZE(GOM_VarMax,6,GOT_Pixels),
                GOCT_CopyUser1ToTag, GTPA_IndicatorHeight,
                GOCT_SetHotKey, 'w',
                TAG_END,
                GTPA_IndicatorHeight, 15,
                GT_Underscore, '_',
                TAG_MORE, (ULONG)&palette_tags[0],
                TAG_END,

            GO_ENDGRP(),
            
        GO_ENDGRP(),

        GO_VERTGRP(0,0,1), TAG_END,
        
            GO_HORIZGRP(0,0,1), TAG_END,
            
                GO_DRAWBOX(GOSD_Button,0,0,1), TAG_END,
                    
                    GODT_FillRect, GO_SCLPNT(BACKGROUNDPEN,0,0,63,63),
                    
                    GODT_MoveTo, GO_SCLPNT(0,0,0,0,0),
                    GODT_DrawTo, GO_SCLPNT(FILLPEN,63,0,0,0),
                    GODT_DrawTo2, GO_SCLPNT(SHINEPEN,63,63,0,63),
                    GODT_DrawTo, GO_SCLPNT(FILLPEN,0,0,0,0),
                    GODT_DrawLine, GO_SCLPNT(SHINEPEN,0,0,63,63),
                    GODT_DrawLine, GO_SCLPNT(FILLPEN,0,63,63,0),
                    
                    GODT_SetOrigin, GO_SCLPNT(0,10,10,53,53),
                    GODT_MoveTo, GO_PIXPNT(0,PX2(0),PY1(0),0,0),
                    GODT_DrawTo2, GO_PIXPNT(SHINEPEN,PX1(0),PY1(0),PX1(0),PY2(0)),
                    GODT_DrawLine, GO_PIXPNT(SHINEPEN,PX1(1),PY1(1),PX1(1),PY2(0)),
                    GODT_MoveTo, GO_PIXPNT(0,PX2(0),PY1(0),0,0),
                    GODT_DrawTo2, GO_PIXPNT(SHADOWPEN,PX2(0),PY2(0),PX1(1),PY2(0)),
                    GODT_DrawLine, GO_PIXPNT(SHADOWPEN,PX2(-1),PY2(0),PX2(-1),PY1(1)),
    
                    GODT_SetOrigin, GO_SCLPNT(0,20,20,43,43),
                    GODT_DrawRect, GO_PIXPNT(SHADOWPEN,PX1(2),PY1(2),PX2(2),PY2(2)),
                    GODT_DrawRect, GO_PIXPNT(FILLPEN,PX1(1),PY1(1),PX2(1),PY2(1)),
                    GODT_DrawRect, GO_PIXPNT(SHINEPEN,PX1(0),PY1(0),PX2(0),PY2(0)),
                    
                    GODT_ResetBounds, GO_FRMBOUNDS(1,1,1,1, 5,5,5,5),
                    GODT_FillRect, GO_SCLPNT(SHADOWPEN,0,0,63,31),
                    GODT_FillRect, GO_SCLPNT(SHADOWPEN,0,0,31,63),
                    GODT_FillRect, GO_SCLPNT(SHADOWPEN,32,0,63,63),
                    GODT_FillRect, GO_SCLPNT(SHADOWPEN,0,32,63,63),
                    TAG_END,
            
                GO_DRAWIMAGE(GOSD_BoopsiIm,0,DRAWIMG_ID),

                    GOCT_SetBodyLeft, GO_TSIZE(GOM_Set,0,GOT_Pixels),
                    GOCT_SetBodyTop, GO_TSIZE(GOM_Set,0,GOT_Pixels),
                    GOCT_SetBodyWidth, GO_BSIZE(GOM_Set,BOOPSIGAD_ID,GOTB_BodyWidth),
                    GOCT_SetBodyHeight, GO_BSIZE(GOM_Set,BOOPSIGAD_ID,GOTB_BodyHeight),
                    TAG_END,
                    
                    GODT_FillRect, GO_SCLPNT(BACKGROUNDPEN,0,0,63,63),

                    GODT_MoveTo, GO_SCLPNT(0,0,0,0,0),
                    GODT_DrawTo, GO_SCLPNT(FILLPEN,63,0,0,0),
                    GODT_DrawTo2, GO_SCLPNT(SHINEPEN,63,63,0,63),
                    GODT_DrawTo, GO_SCLPNT(FILLPEN,0,0,0,0),
                    GODT_DrawLine, GO_SCLPNT(SHINEPEN,0,0,63,63),
                    GODT_DrawLine, GO_SCLPNT(FILLPEN,0,63,63,0),
                    
                    GODT_SetOrigin, GO_SCLPNT(0,10,10,53,53),
                    GODT_MoveTo, GO_PIXPNT(0,PX2(0),PY1(0),0,0),
                    GODT_DrawTo2, GO_PIXPNT(SHINEPEN,PX1(0),PY1(0),PX1(0),PY2(0)),
                    GODT_DrawLine, GO_PIXPNT(SHINEPEN,PX1(1),PY1(1),PX1(1),PY2(0)),
                    GODT_MoveTo, GO_PIXPNT(0,PX2(0),PY1(0),0,0),
                    GODT_DrawTo2, GO_PIXPNT(SHADOWPEN,PX2(0),PY2(0),PX1(1),PY2(0)),
                    GODT_DrawLine, GO_PIXPNT(SHADOWPEN,PX2(-1),PY2(0),PX2(-1),PY1(1)),
    
                    GODT_SetOrigin, GO_SCLPNT(0,20,20,43,43),
                    GODT_DrawRect, GO_PIXPNT(SHADOWPEN,PX1(2),PY1(2),PX2(2),PY2(2)),
                    GODT_DrawRect, GO_PIXPNT(FILLPEN,PX1(1),PY1(1),PX2(1),PY2(1)),
                    GODT_DrawRect, GO_PIXPNT(SHINEPEN,PX1(0),PY1(0),PX2(0),PY2(0)),
                    TAG_END,
                
                GO_BOOPSIBOX(GOSB_AddGad,0,BOOPSIGAD_ID,1,(ULONG)&"buttongclass",NULL),
                GOCT_LinkFromTag, GA_Image, GOCT_LinkToStdID, DRAWIMG_ID,
                TAG_END,
                GA_Image, NULL,
                GA_RelVerify, TRUE,
                GA_Disabled, FALSE,
                TAG_END,
                    
            GO_ENDGRP(),

            GO_HORIZGRP(0,0,1), TAG_END,
            
                GO_DRAWBOX(GOSD_BoopsiGad,0,DODISABLE_ID,1), TAG_END,
                    
                    GODT_SetCustFillPat2, 0x5555AAAA,
                    GODT_ChooseBPen, SHADOWPEN,
                    GODT_SetRastMode, FLGALL(JAM2),
                    GODT_FillEllipse, GO_SCLPNT(BACKGROUNDPEN,0,0,63,63),
                    GODT_DrawEllipse, GO_SCLPNT(SHINEPEN,20,20,43,43),
    
                    GODT_MoveTo, GO_SCLPNT(0,0,0,0,0),
                    GODT_SetRastMode, FLGALL(JAM2 | INVERSVID),
                    GODT_SetTextMode,
                        FLGALL(TXTMD_LEFT | TXTMD_ENDRIGHT | TXTMD_RELTOP),
                    GODT_DrawStdText, (ULONG)&"This is a single really really long test...",
                    GODT_NewLine, 1,
    
                    GODT_SetRastMode, FLGALL(JAM2),
                    GODT_DrawFillText, (ULONG)&"This is a double line really really really",
                    GODT_NewLine, 1,
                    GODT_DrawOldText, (ULONG)&"really really REALLY ___R_E_A_L_L_Y___ LONG TEST!!",
    
                    GODT_SetRastMode, FLGALL(JAM1),
                    GODT_MoveTo, GO_SCLPNT(0,32,63,0,0),
                    GODT_SetTextMode,
                        FLGALL(TXTMD_RIGHT | TXTMD_ENDRIGHT | TXTMD_CHOPLEFT | TXTMD_RELBOTTOM),
                    GODT_DrawHighText, (ULONG)&"A long kind of label text: ",
                    GODT_SetRastMode, FLGALL(JAM2),
                    GODT_SetTextMode, SETMD_X(TXTMD_LEFT) | FLGOFF(TXTMD_CHOPLEFT),
                    GODT_DrawStdText, (ULONG)&"And long body to go with it.",
                    TAG_END,
                
            GO_ENDGRP(),
            
        GO_ENDGRP(),

    GO_ENDGRP(),

    GO_HORIZGRP(0,0,0), GOCT_EvenDistGroup, TRUE, TAG_END,

        GO_GTBOX(BUTTON_KIND, 0, RESETSCRN_ID, 1, (ULONG)&"Reset Scree_n",
            PLACETEXT_IN),
        TAG_END,
        GT_Underscore, '_',
        TAG_END,

        GO_GTBOX(BUTTON_KIND, 0, UPDATESCRNS_ID, 1, (ULONG)&"SMA_LL!!!!!!",
            PLACETEXT_IN),
        TAG_END,
        GT_Underscore, '_',
        TAG_END,

        GO_GTBOX(BUTTON_KIND, 0, MAKESCRN_ID, 1, (ULONG)&"big",
            PLACETEXT_IN),
        TAG_END,
        GT_Underscore, '_',
        TAG_END,

        GO_GTBOX(BUTTON_KIND, 0, CLOSESCRN_ID, 1, (ULONG)&"_Close Screen",
            PLACETEXT_IN),
        TAG_END,
        GT_Underscore, '_',
        TAG_END,

    GO_ENDGRP(),

GO_ENDGRP(),
GO_ENDOUTLINE()
};

/*********************************************
 **
 ** Program environment
 **
 *********************************************/

static struct Process *me = NULL;
static struct Window *oldwin = NULL;   /* what me->pr_WindowPtr previously was */

/*********************************************
 **
 ** Current program state
 **
 *********************************************/

static struct GadOutline *gad_outline = NULL;
static struct FontRequester *fr = NULL;
static UBYTE *go_error;        /* Where error results are returned */
static struct List scrn_list, mode_list;

/*********************************************
 **
 ** All library bases
 **
 *********************************************/

#define MIN_VERSION     37L      /* minimum version number for our libs */

long __oslibversion = MIN_VERSION;

#ifndef LINKLIB
struct Library *GadOutlineBase = NULL;
#endif

static void quit(UBYTE *err);
static void closedisplay(void);
static void closedown(void);
static void opendisplay(struct GadOutline *go);
static void handledisplay(struct GadOutline *go);

/*********************************************
 **
 ** Routines for a clean exit, with optional error display
 **
 *********************************************/

static struct EasyStruct error_es = {
    sizeof(struct EasyStruct), 0,
    "GadOutline Example2 Requester",
    "Problem during startup:\n%ls",
    "Quit"
};

static void quit(UBYTE *err)
{
    closedown();

    if(err == NULL) err = go_error;
    if(err != NULL) (void)EasyRequest(NULL,&error_es, NULL, err);

    _exit(0);
}

static void closedown(void)
{
    closedisplay();

    if(gad_outline) FreeGadOutline(gad_outline);
    if(fr) FreeAslRequest(fr);
    if(me) me->pr_WindowPtr = (APTR)oldwin;
    #ifndef LINKLIB
    if(GadOutlineBase) CloseLibrary(GadOutlineBase);
    #endif
}

/*********************************************
 **
 ** Routine for opening/closing the screen, window and gadgets
 **
 *********************************************/

static void create_node(struct List *list,UBYTE *name)
{
    struct Node *nd;
    
    if( nd=AllocVec(sizeof(struct Node)+strlen(name)+5,MEMF_CLEAR) ) {
        nd->ln_Name = (char *)(nd+1);
        strcpy((UBYTE *)(nd+1),name);
        AddHead(list,nd);
    }
}

static void free_list(struct List *list)
{
    struct Node *nd;
    
    while( nd=RemTail(list) ) {
        FreeVec(nd);
    }
}

static void closedisplay(void)
{
    if(gad_outline) GO_CloseWindow(gad_outline);
    free_list(&scrn_list);
    free_list(&mode_list);
}

static void opendisplay(struct GadOutline *go)
{
    closedisplay();

    GO_OpenWindow(go,
                WA_AutoAdjust,    TRUE,
                WA_IDCMP,         IDCMP_CLOSEWINDOW | IDCMP_VANILLAKEY |
                                  IDCMP_REFRESHWINDOW,
                WA_Activate,      TRUE,
                WA_CloseGadget,   TRUE,
                WA_DepthGadget,   TRUE,
                WA_DragBar,       TRUE,
                WA_SizeGadget,    TRUE,
                WA_SizeBBottom,   TRUE,
                WA_ReportMouse,   TRUE,
                WA_SimpleRefresh, TRUE,
                WA_PubScreen,     NULL,
                TAG_END
                );

    if(go->go_LastReqReturn || !go->go_Window) return;

    create_node(&scrn_list,"Screen #0");
    create_node(&scrn_list,"Screen #1");
    create_node(&scrn_list,"Screen #2");
    create_node(&scrn_list,"Screen #3");
    create_node(&scrn_list,"Screen #4");
    create_node(&scrn_list,"Screen #5");
    create_node(&scrn_list,"Screen #6");
    create_node(&scrn_list,"Screen #7");
    create_node(&scrn_list,"Screen #8");
    create_node(&scrn_list,"Screen #9");
    create_node(&mode_list,"Display Mode #0");
    create_node(&mode_list,"Display Mode #1");
    create_node(&mode_list,"Display Mode #2");
    create_node(&mode_list,"Display Mode #3");
    create_node(&mode_list,"Display Mode #4");
    create_node(&mode_list,"Display Mode #5");
    create_node(&mode_list,"Display Mode #6");
    create_node(&mode_list,"Display Mode #7");
    create_node(&mode_list,"Display Mode #8");
    create_node(&mode_list,"Display Mode #9");

    GO_SetObjAttrs(go,CURSCRN_ID,0,GTLV_Labels,&scrn_list,TAG_END);
    GO_SetObjAttrs(go,SCRNMODE_ID,0,GTLV_Labels,&mode_list,TAG_END);

    me->pr_WindowPtr = (APTR)go->go_Window;
}

static void handledisplay(struct GadOutline *go)
{
    struct GOIMsg *msg;
    struct Gadget *gadget;
    ULONG class;
    UWORD code;
    UWORD qual;

    if(go == NULL || go->go_Window == NULL) return;

    while (1)
    {
        Wait( (1L<<go->go_Window->UserPort->mp_SigBit) );

        while (msg = GO_GetGOIMsg(go))
        {
            class = msg->StdIMsg.Class;
            code = msg->StdIMsg.Code;
            qual = msg->StdIMsg.Qualifier;
            gadget=msg->StdIMsg.IAddress;

            gadget = (struct Gadget *)msg->StdIMsg.IAddress;

            GO_ReplyGOIMsg(msg);

            switch (class) {

                case IDCMP_CLOSEWINDOW:
                    return;

                case IDCMP_REFRESHWINDOW:
                    GO_BeginRefresh(go);
                    GO_EndRefresh(go, TRUE);
                    break;

                case IDCMP_GADGETUP:
                case IDCMP_GADGETDOWN:
                    D(bug("A gadget of type: %ld\n",gadget->GadgetID));
                    if(gadget->GadgetID == DODISABLE_ID) {
                        GO_SetObjAttrs(go,BOOPSIGAD_ID,0,
                            GA_Disabled,
                                !GO_GetObjAttr(go,BOOPSIGAD_ID,0,GA_Disabled,TRUE),
                            TAG_END);
                    } else if(gadget->GadgetID == SETFONT_ID) {

                        /* Pop up the requester */
                        if (AslRequestTags(fr,
                            /* Supply initial values for requester */
                            ASL_FontName, (ULONG)go->go_TargetTA.tta_Name,
                            ASL_FontHeight, go->go_TargetTA.tta_YSize,
                            ASL_FontStyles, go->go_TargetTA.tta_Style,
                            ASL_FuncFlags, FONF_STYLES,
                            ASL_Window, go->go_Window,
                            TAG_END)) {

                            DimenGadOutline(go,
                                            GOA_TextAttr,&fr->fo_Attr,
                                            TAG_END);
                            GO_SetObjAttrs(go,FONTNAME_ID,0,
                                GTST_String,go->go_TargetTA.tta_Name,TAG_END);
                            GO_SetObjAttrs(go,FONTSIZE_ID,0,
                                GTIN_Number,go->go_TargetTA.tta_YSize,TAG_END);
                        }
                    }
                    break;
            }
        }
    }
}

/*********************************************
 **
 ** Program's main entry point
 **
 *********************************************/

void __regargs main(int argc,char **argv)
{
    NewList(&scrn_list);
    NewList(&mode_list);

    if( !(me = (struct Process *)FindTask(NULL)) ) quit("Can't find	myself!");
    oldwin = (struct Window *)me->pr_WindowPtr;

    if( (fr = (struct FontRequester *)
        AllocAslRequestTags(ASL_FontRequest,TAG_END)) == NULL) {
        quit("Can't allocate font requester!");
    }
            
#ifndef LINKLIB
    GadOutlineBase = OpenLibrary("gadoutline.library", 0);
    if (!GadOutlineBase)
       quit("Can't open gadoutline.library.");
    D(bug("Opened the library.  Creating outline...\n",NULL));
#endif
    
    gad_outline = AllocGadOutline(outline,
           GOA_ErrorText,   &go_error,
           TAG_END);
    if(gad_outline == NULL) {
        quit(go_error);
    }

    opendisplay(gad_outline);
    handledisplay(gad_outline);

    quit(NULL);
}
