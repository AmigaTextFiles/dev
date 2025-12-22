
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
    GAD1_ID = 1,
    GAD2_ID,
    GAD3_ID,
    GAD4_ID,
    GAD5_ID,
    GAD6_ID
};

/*********************************************
 **
 ** Main window gadget outline
 **
 *********************************************/

static ULONG outline[] = {

GO_HORIZGRP(0,0,1), TAG_END,

    GO_VERTGRP(0,0,1), TAG_END,
    
        GO_GTBOX(BUTTON_KIND, 0, GAD1_ID, 1, (ULONG)&"Gadget One", PLACETEXT_IN),
        GOCT_SetHotKey, '1',
        TAG_END,
        TAG_END,

        GO_GTBOX(BUTTON_KIND, 0, GAD2_ID, 1, (ULONG)&"Gadget Two", PLACETEXT_IN),
        GOCT_SetHotKey, '2',
        TAG_END,
        TAG_END,

        GO_GTBOX(BUTTON_KIND, 0, GAD3_ID, 1, (ULONG)&"Gadget Three", PLACETEXT_IN),
        GOCT_SetHotKey, '3',
        TAG_END,
        TAG_END,

    GO_ENDGRP(),

    GO_VERTGRP(0,0,1), TAG_END,
    
        GO_GTBOX(BUTTON_KIND, 0, GAD4_ID, 1, (ULONG)&"Gadget Four", PLACETEXT_IN),
        GOCT_SetHotKey, '4',
        TAG_END,
        TAG_END,

        GO_GTBOX(BUTTON_KIND, 0, GAD5_ID, 1, (ULONG)&"Gadget Five", PLACETEXT_IN),
        GOCT_SetHotKey, '5',
        TAG_END,
        TAG_END,

        GO_GTBOX(BUTTON_KIND, 0, GAD6_ID, 1, (ULONG)&"Gadget Six", PLACETEXT_IN),
        GOCT_SetHotKey, '6',
        TAG_END,
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
static struct GadOutline *sml_outline = NULL;
static struct GadOutline *big_outline = NULL;
static UBYTE *go_error;        /* Where error results are returned */

/*********************************************
 **
 ** All library bases
 **
 *********************************************/

#define MIN_VERSION     37L      /* minimum version number for our libs */

long __oslibversion = MIN_VERSION;

#ifndef LINKLIB
struct Library *GadOutlineBase = NULL;      /* Testing, 1... 2... 3... */
#endif

static void quit(UBYTE *err);
static void closedown(void);
static void opendisplay(struct GadOutline *go,WORD num,UBYTE *,ULONG,ULONG);
static void handledisplay(struct GadOutline *go);

/*********************************************
 **
 ** Routines for a clean exit, with optional error display
 **
 *********************************************/

/* Data for displaying pre-2.0 error requester */

static struct IntuiText req_text[] = {
{       AUTOFRONTPEN,AUTOBACKPEN,AUTODRAWMODE,AUTOLEFTEDGE,AUTOTOPEDGE,
        NULL,"Example1 Problem:",&req_text[1] },
{       AUTOFRONTPEN,AUTOBACKPEN,AUTODRAWMODE,AUTOLEFTEDGE,AUTOTOPEDGE+12,
        NULL,"Release 2.0 required.",NULL },
{       AUTOBACKPEN+1,AUTOBACKPEN,AUTODRAWMODE,AUTOLEFTEDGE,AUTOTOPEDGE,
        NULL,"Quit",NULL } };

static void do_old_request(UBYTE *err)
{
    struct IntuitionBase *IntuitionBase;

    if( (IntuitionBase=(struct IntuitionBase *)
        OpenLibrary("intuition.library",0)) != 0 ) {
            AutoRequest(NULL,&req_text[0],&req_text[2],&req_text[2],NULL,
                    NULL,320,70);
            CloseLibrary((void *)IntuitionBase);
    }
}

static struct EasyStruct error_es = {
    sizeof(struct EasyStruct), 0,
    "GadOutline Example1 Requester",
    "Problem during startup:\n%ls",
    "Quit"
};

static void quit(UBYTE *err)
{
    closedown();

    if(err == NULL) err = go_error;
    if(err != NULL ) {

        (void)EasyRequest(NULL,&error_es, NULL, err);

    }
    _exit(0);
}

static void closedown(void)
{
    if(big_outline) FreeGadOutline(big_outline);
    if(sml_outline) FreeGadOutline(sml_outline);
    if(gad_outline) FreeGadOutline(gad_outline);

#ifndef LINKLIB
    if(GadOutlineBase) CloseLibrary(GadOutlineBase);
#endif

    if(me) {
        me->pr_WindowPtr = (APTR)oldwin;
    }
}

/*********************************************
 **
 ** Routine for opening the window and gadgets
 **
 *********************************************/

static void opendisplay(struct GadOutline *go,WORD num,UBYTE *fname,ULONG fsize,ULONG idcmp)
{
    DimenGadOutline(go, GOA_TextAttr, NULL,
                        GOA_FontName, fname, GOA_FontSize, fsize,
                        idcmp ? GOA_UserIDCMP : TAG_IGNORE, idcmp,
                        TAG_END);
    if(go->go_LastReqReturn) return;

    GO_OpenWindow(go,
                WA_Left,            num*50,
                WA_Top,             num*50,
                WA_AutoAdjust,      TRUE,
                WA_IDCMP,           IDCMP_CLOSEWINDOW | IDCMP_REFRESHWINDOW,
                WA_Activate,        TRUE,
                WA_CloseGadget,     TRUE,
                WA_DepthGadget,     TRUE,
                WA_DragBar,         TRUE,
                WA_SizeGadget,      TRUE,
                WA_SizeBBottom,     TRUE,
                WA_ReportMouse,     TRUE,
                WA_SimpleRefresh,   TRUE,
                WA_PubScreen,       NULL,
                TAG_END
                );

    if(go->go_LastReqReturn || !go->go_Window) return;

    me->pr_WindowPtr = (APTR)go->go_Window;
}

static void handledisplay(struct GadOutline *go)
{
    struct GadOutline *cur_go;
    struct GOIMsg *msg;
    struct Gadget *gadget;
    ULONG class;
    WORD code;

    if(!go || !go->go_Window || !go->go_Window->UserPort) return;

    while (1)
    {
        Wait( (1L<<go->go_Window->UserPort->mp_SigBit) );

        while (msg = GO_GetGOIMsg(go))
        {
            cur_go = GO_GetGOFromGOIMsg(msg);
            class = msg->StdIMsg.Class;
            code = msg->StdIMsg.Code;
            gadget=msg->StdIMsg.IAddress;
            gadget = (struct Gadget *)msg->StdIMsg.IAddress;

            GO_ReplyGOIMsg(msg);

            switch (class) {

                case IDCMP_CLOSEWINDOW:
                    return;

                case IDCMP_REFRESHWINDOW:
                    if(cur_go) {
                        GO_BeginRefresh(cur_go);
                        GO_EndRefresh(cur_go, TRUE);
                    }
                    break;

                case IDCMP_GADGETUP:

                    D(bug("A gadget of type: %ld\n",gadget->GadgetID));
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
    if( !(me = (struct Process *)FindTask(NULL)) ) quit("Can't find	myself!");

    oldwin = (struct Window *)me->pr_WindowPtr;

#ifdef DEBUGLIB
    {
        void *ptr;

        D(bug("Started...  Flushing memory...\n",NULL));
        ptr = (void *)AllocMem(0x0FFFFFFF,0);
        if(ptr) FreeMem(ptr,0x0FFFFFFF);

        D(bug("OK, in a sec we'll try this thing.\n",NULL));
        Delay(60);
    }
#endif

#ifndef LINKLIB
    GadOutlineBase = OpenLibrary("gadoutline.library", 0);
    if (!GadOutlineBase)
       quit("Can't open gadoutline.library.");
    D(bug("Opened the library.  Creating outline...\n",NULL));
#endif
    
    gad_outline = AllocGadOutline(outline,
           GOA_ErrorText,    &go_error,
           TAG_END);
    if(gad_outline == NULL) {
        quit(go_error);
    }

    sml_outline = AllocGadOutline(outline,
           GOA_ErrorText,    &go_error,
           TAG_END);
    if(sml_outline == NULL) {
        quit(go_error);
    }

    big_outline = AllocGadOutline(outline,
           GOA_ErrorText,    &go_error,
           TAG_END);
    if(big_outline == NULL) {
        quit(go_error);
    }

    D(bug("Outline created OK.",NULL));

    opendisplay(gad_outline,0,NULL,0,~0);
    opendisplay(sml_outline,1,"topaz",8,(ULONG)gad_outline->go_MsgPort);
    opendisplay(big_outline,2,"Garnet",16,(ULONG)gad_outline->go_MsgPort);
    handledisplay(gad_outline);

    quit(NULL);
}
