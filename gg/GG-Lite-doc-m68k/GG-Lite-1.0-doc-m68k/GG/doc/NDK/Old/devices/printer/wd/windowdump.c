/* Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 */

/* WindowDump.c 10/89 EC
 * Compiled with Lattice C 5.04: LC -b1 -cfist -v -y 
 * Linkage: lib:c.o+WindowDump.o to WindowDump Library lib:lc.lib+lib:amiga.lib
 */

#include <exec/types.h>
#include <devices/printer.h>
#include <exec/io.h>
#include <graphics/display.h>
#include <graphics/gfxbase.h>
#include <graphics/rastport.h>
#include <graphics/view.h>
#include <intuition/intuition.h>
#include <libraries/dos.h>
#include <libraries/dosextens.h>

#ifdef LATTICE
#include <proto/all.h>
#include <stdio.h>
#include <stdlib.h>
#endif

void main(void);
union printerIO *CreatePrtReq(void);
void DeletePrtReq(union printerIO *);
int OpenPrinter (union printerIO *);
void ClosePrinter(union printerIO *);
void DumpRPort(union printerIO *, struct RastPort *, struct ColorMap *,
                      ULONG, UWORD, UWORD, UWORD, UWORD, LONG, LONG, UWORD);
void openLibraries(void);
struct Window *doWindow(SHORT, SHORT);
void cleanexit(UBYTE *);

union printerIO {
    struct IOStdReq    ios;
    struct IODRPReq    iodrp;
    struct IOPrtCmdReq iopc;
};

static UBYTE *prtErrorText[] = {" EVERYTHING'S FINE", 
                                " USER CANCELED DUMP", 
                                " NOT A GRAPHICS PRINTER",
                                " SHOULDN'T GET THIS ONE",
                                " ILLEGAL DIMENSIONS", 
                                " SHOULDN'T GET THIS ONE", 
                                " NO MEMORY FOR VARIABLES", 
                                " NO MEMORY FOR BUFFER"};

struct IntuitionBase *IntuitionBase = NULL;
struct GfxBase *GfxBase = NULL;
struct Window *window;
union printerIO *printerReq;
BOOL PDOPEN = FALSE;

void
main()
{
    struct IntuiMessage *msg;
    struct MsgPort *port;
    struct RastPort *rp;
    struct ViewPort *vp;

    ULONG usersig, printersig, signal;
    BOOL P_ABORT = FALSE;
    BOOL U_ABORT = FALSE;
	
    openLibraries();
    window = doWindow(320, 100);

    if (!(printerReq = CreatePrtReq()))
        cleanexit("Can't create printer request");

    if (OpenPrinter(printerReq))
        cleanexit("Can't open printer device\n");

    PDOPEN = TRUE;

    port = printerReq->ios.io_Message.mn_ReplyPort;

    usersig = 1 << window->UserPort->mp_SigBit;
    printersig = 1 << port->mp_SigBit;

    rp = window->RPort;
    vp = &window->WScreen->ViewPort;

    DumpRPort(printerReq, rp, vp->ColorMap, vp->Modes,
              (UWORD)window->BorderLeft, (UWORD)window->BorderTop,
              (UWORD)(window->Width - window->BorderRight - window->BorderLeft),
              (UWORD)(window->Height - window->BorderBottom - window->BorderTop),
              0L, 0L,
              SPECIAL_ASPECT|SPECIAL_FULLROWS|SPECIAL_TRUSTME);

    FOREVER {
        signal = Wait(usersig | printersig);
        if (signal & usersig){ 
            while(msg = (struct IntuiMessage *)GetMsg(window->UserPort)) {
                if(msg->Class == CLOSEWINDOW) U_ABORT = TRUE;
                ReplyMsg((struct Message *)msg);
            }
        }
        if (signal & printersig) {
            if (printerReq->iodrp.io_Error != 0){
                  SetWindowTitles(window, 
                                  prtErrorText[printerReq->iodrp.io_Error], NULL);
                Delay(150);
	    }
            P_ABORT = TRUE;
            while((struct MsgPort *)GetMsg(port));
        }

        if (U_ABORT) {
            AbortIO((struct IORequest *)printerReq);
            WaitIO((struct IORequest *)printerReq);	
	}
        if (P_ABORT | U_ABORT)
           cleanexit("");
    }
}

/* open and fill a window on the Workbench screen */

struct Window *doWindow(width, height)
SHORT width, height;
{

    struct NewWindow nw = {
        0,0,0,0,0,1,CLOSEWINDOW,ACTIVATE|WINDOWCLOSE|WINDOWDEPTH|SMART_REFRESH|
        WINDOWDRAG|RMBTRAP,NULL,NULL,"<- Close To Abort Dump",
        NULL,NULL,-1,-1,-1,-1,WBENCHSCREEN
    };

    struct RastPort *rp;
    struct Window   *wn;
    register COUNT n;
    register SHORT mc, mr;

    nw.Height = height;
    nw.Width  = width;

    if(!(wn = (struct Window *)OpenWindow(&nw)))
        cleanexit("Can't open window\n");
    
    rp = wn->RPort;
    mc = wn->Width - (wn->BorderRight+1);
    mr = wn->Height - (wn->BorderBottom+1);

    SetDrMd(rp,0);
    SetAPen(rp, 1);
    RectFill(rp, wn->BorderLeft, wn->BorderTop, mc, mr);
    for (n = wn->BorderLeft; n < mc; n+=4) {
        Move(rp, (mc / 2) + wn->BorderLeft + 1, (mr / 2) + wn->BorderBottom + 1);
        SetAPen(rp, 0);
        Draw(rp, n, wn->BorderTop);
        Move(rp, (mc / 2) + wn->BorderLeft + 1, (mr / 2) + wn->BorderBottom + 1);
        SetAPen(rp, 3);
        Draw(rp, n, mr);
    }
    for (n = wn->BorderTop; n < mr; n+=4) {
        Move(rp, (mc / 2) + wn->BorderLeft + 1, (mr / 2) + wn->BorderBottom + 1);
        SetAPen(rp, 2);
        Draw(rp, wn->BorderLeft, n);
        Move(rp, (mc / 2) + wn->BorderLeft + 1, (mr / 2) + wn->BorderBottom + 1);
        Draw(rp, mc, n);
    }

    return(wn);
}


void openLibraries()
{
    if(!(GfxBase = (struct GfxBase *)OpenLibrary("graphics.library",33)))
        cleanexit("Can't open graphics.lib\n");
    if(!(IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 33)))
        cleanexit("Can't open intuition.lib\n");
}

void cleanexit(s)
UBYTE *s;
{
    struct IntuiMessage *msg;
    SHORT c;

    if (PDOPEN)
        CloseDevice((struct IORequest *)printerReq);

    if (printerReq)
        DeletePrtReq(printerReq);

    if(window) {
        while(msg = (struct IntuiMessage *)GetMsg(window->UserPort))
            ReplyMsg((struct Message *)msg);
        CloseWindow(window);
    }

    if(GfxBase) CloseLibrary((struct Library *)GfxBase);
    if(IntuitionBase) CloseLibrary((struct Library *)IntuitionBase);

    if (*s) {
        printf("%s\n", s);
        printf("<<< Hit Return to continue >>>\n"); /* just in case we're */
        c = getchar();                              /* run from Workbench */
        exit(RETURN_FAIL);
    }
    exit(RETURN_OK);
}


/* the printer i/o routines we use */

union printerIO *CreatePrtReq()
{
    struct MsgPort *prtport;
    union printerIO *request;

    if (!(prtport = CreatePort(NULL,0)))
        return(0);
    if (!(request = (union printerIO *)CreateExtIO(prtport, 
                        sizeof(union printerIO)))){
        DeletePort(prtport);
        return(0);
    }
    return(request);
}

void DeletePrtReq(request)
union printerIO *request;
{
    struct MsgPort *prtport;

    prtport = request->ios.io_Message.mn_ReplyPort;
    DeleteExtIO((struct IORequest *)request);
    DeletePort(prtport);
}
    
int
OpenPrinter(request)
union printerIO *request;
{
	return((int)OpenDevice("printer.device",0,(struct IORequest *)request,0));
}

void
DumpRPort(request,rastPort, colorMap, modes, sx,sy, sw,sh, dc,dr, s)
union printerIO *request;
struct RastPort *rastPort;
struct ColorMap *colorMap;
ULONG modes;
UWORD sx, sy, sw, sh;
LONG dc, dr;
UWORD s;
{
    request->iodrp.io_Command = PRD_DUMPRPORT;
    request->iodrp.io_RastPort = rastPort;
    request->iodrp.io_ColorMap = colorMap;
    request->iodrp.io_Modes = modes;
    request->iodrp.io_SrcX = sx;
    request->iodrp.io_SrcY = sy;
    request->iodrp.io_SrcWidth = sw;
    request->iodrp.io_SrcHeight = sh;
    request->iodrp.io_DestCols = dc;
    request->iodrp.io_DestRows = dr;
    request->iodrp.io_Special = s;
    SendIO((struct IORequest *)request);
}
