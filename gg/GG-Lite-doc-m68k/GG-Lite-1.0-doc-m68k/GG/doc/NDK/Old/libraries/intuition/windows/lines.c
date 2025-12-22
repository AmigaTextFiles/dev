
/* Lines.c -- implements a superbitmap with scroll gadgets */
/* Compiled with Lattice C v5.02                                     */
/* Compiler invoked with: lc -b1 -cfist -L -v -w                     */

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

#include <exec/types.h>
#include <exec/memory.h>
#include <intuition/intuition.h>

#include <proto/all.h>

#define	WIDTH_SUPER	800
#define	HEIGHT_SUPER	600
#define	DEPTH_SUPER	2

extern struct GfxBase *GfxBase;
extern struct IntuitionBase *IntuitionBase;

struct LayersBase *LayersBase;

/* WindowInfo helps keep track of where the line is */
struct WindowInfo {
                  SHORT LineX1;
                  SHORT LineY1;
                  SHORT LineX2;
                  SHORT LineY2;
                  SHORT LineX1d;
                  SHORT LineY1d;
                  SHORT LineX2d;
                  SHORT LineY2d;
                  SHORT pen;
                  };

#define GetGadgetID(x) (((struct Gadget *)(msg->IAddress))->GadgetID)

#define GetLayerXOffset(x) (x->RPort->Layer->Scroll_X)
#define GetLayerYOffset(x) (x->RPort->Layer->Scroll_Y)

#define UP_DOWN_GADGET    0
#define LEFT_RIGHT_GADGET 1
#define NO_GADGET         2

#define MAXVAL 0xFFFFL

struct Image Images[2];

/* The special data needed for the two proportional gadgets */
struct PropInfo GadgetsSInfo[2] = {
	{FREEVERT|AUTOKNOB,0,0,-1,-1,},
	{FREEHORIZ|AUTOKNOB,0,0,-1,-1,}
                                  };

/* The usual data needed for any gadget */
struct Gadget Gadgets[2] = {

/* Gadgets[0] */
	{&Gadgets[1],-15,10,16,-18,
	GRELRIGHT|GRELHEIGHT,
	RELVERIFY|GADGIMMEDIATE|RIGHTBORDER,PROPGADGET|GZZGADGET,
	(APTR)&Images[0],NULL,NULL,NULL,
	(APTR)&GadgetsSInfo[0],UP_DOWN_GADGET,NULL},

/* Gadgets[1] */
	{NULL,0,-8,-14,9,
	GRELBOTTOM|GRELWIDTH,
	RELVERIFY|GADGIMMEDIATE|BOTTOMBORDER,PROPGADGET|GZZGADGET,
	(APTR)&Images[1],NULL,NULL,NULL,
	(APTR)&GadgetsSInfo[1],LEFT_RIGHT_GADGET,NULL}
                           };

static struct NewWindow NewLinesWindow = {
	150,55,	/* window XY origin relative to TopLeft of screen */
	165,94,	/* window width and height */
	0,1,	/* detail and block pens */

	GADGETUP |
	GADGETDOWN |
	NEWSIZE |
	INTUITICKS |
	CLOSEWINDOW,			/* IDCMP flags */

	WINDOWSIZING |
	WINDOWDRAG |
	WINDOWDEPTH |
	WINDOWCLOSE |
	SUPER_BITMAP |
	GIMMEZEROZERO |
	NOCAREREFRESH,			/* other window flags */

	Gadgets,			/* first gadget in gadget list */
	NULL,				/* custom CHECKMARK imagery */
	"Lines 2.0",			/* window title */
	NULL,				/* custom screen pointer */
	NULL,				/* custom bitmap */
	90,40,				/* minimum width and height */
	WIDTH_SUPER,HEIGHT_SUPER,	/* maximum width and height */
	WBENCHSCREEN			/* destination screen type */
};

ULONG Seed=0x1437289L;
SHORT Rand(SHORT max)    /* A simple random number generator */
{
ULONG tmp;

    tmp=(Seed<<8) + (Seed>>8);
    Seed-=tmp;
    return(tmp % max);
}

/* Checks to see if a delta would cause a point to be outside of
 * its range, and adjusts the delta accordingly.
*/
VOID CheckBounce(SHORT point,SHORT *delta,SHORT *pen,SHORT max)
{
    point+=*delta;
    if (point < 0)
    {
        *delta=Rand(8)+1;
        *pen=(*pen % 3) + 1;
    }
    if (point > max)
    {
        *delta=-(Rand(8)+1);
        *pen=(*pen % 3) + 1;
    }
}

/* This function does all the work of drawing the lines */
VOID Do_DrawStuff(struct Window *window)
{
struct RastPort *rp;
struct WindowInfo *myinfo;

    rp=window->RPort;
    myinfo=(struct WindowInfo *)(window->UserData);

    Move(rp,myinfo->LineX1,myinfo->LineY1);
    Draw(rp,myinfo->LineX2,myinfo->LineY2);

    CheckBounce(myinfo->LineX1,&myinfo->LineX1d,&myinfo->pen,WIDTH_SUPER);
    CheckBounce(myinfo->LineY1,&myinfo->LineY1d,&myinfo->pen,HEIGHT_SUPER);
    CheckBounce(myinfo->LineX2,&myinfo->LineX2d,&myinfo->pen,WIDTH_SUPER);
    CheckBounce(myinfo->LineY2,&myinfo->LineY2d,&myinfo->pen,HEIGHT_SUPER);

    SetAPen(rp,myinfo->pen);

    myinfo->LineX1+=myinfo->LineX1d;
    myinfo->LineY1+=myinfo->LineY1d;
    myinfo->LineX2+=myinfo->LineX2d;
    myinfo->LineY2+=myinfo->LineY2d;
}

/* This function provides a simple interface to ScrollLayer */
VOID Slide_BitMap(struct Window *window,SHORT Dx,SHORT Dy)
{
    ScrollLayer(0,window->RPort->Layer,Dx,Dy);
}

VOID Do_NewSize(struct Window *window)
{
ULONG tmp;

    tmp=GetLayerXOffset(window) + window->GZZWidth;
    if (tmp>=WIDTH_SUPER) Slide_BitMap(window,WIDTH_SUPER-tmp,0);

    NewModifyProp(&Gadgets[LEFT_RIGHT_GADGET],window,NULL,AUTOKNOB|FREEHORIZ,
               ( (GetLayerXOffset(window) * MAXVAL) /
                 (WIDTH_SUPER - window->GZZWidth) ),
               NULL,
               ( (window->GZZWidth * MAXVAL) / WIDTH_SUPER ),
               MAXVAL,
               1);

    tmp=GetLayerYOffset(window) + window->GZZHeight;
    if (tmp>=HEIGHT_SUPER) Slide_BitMap(window,0,HEIGHT_SUPER-tmp);

    NewModifyProp(&Gadgets[UP_DOWN_GADGET],window,NULL,AUTOKNOB|FREEVERT,
               NULL,
               ( (GetLayerYOffset(window) * MAXVAL) /
                 (HEIGHT_SUPER - window->GZZHeight) ),
               MAXVAL,
               ( (window->GZZHeight * MAXVAL) / HEIGHT_SUPER ),
               1);
}

VOID Check_Gadget(struct Window *window,USHORT gadgetID)
{
ULONG tmp;
SHORT dX=0;
SHORT dY=0;

    switch (gadgetID)
    {
    case UP_DOWN_GADGET:    tmp=HEIGHT_SUPER - window->GZZHeight;
                            tmp=tmp*GadgetsSInfo[UP_DOWN_GADGET].VertPot;
                            tmp=tmp / MAXVAL;
                            dY=tmp - GetLayerYOffset(window);
                            break;
    case LEFT_RIGHT_GADGET: tmp=WIDTH_SUPER - window->GZZWidth;
                            tmp=tmp*GadgetsSInfo[LEFT_RIGHT_GADGET].HorizPot;
                            tmp=tmp / MAXVAL;
                            dX=tmp - GetLayerXOffset(window);
                            break;
    }
    if (dX || dY) Slide_BitMap(window,dX,dY);
}

VOID Do_MainLoop(struct Window *window)
{
struct IntuiMessage *msg;
SHORT flag=TRUE;
USHORT CurrentGadget=NO_GADGET;

    SetDrMd(window->RPort,JAM1);
    Do_NewSize(window);
    while (flag)
    {

        /* Whenever you want to wait on just one message port */
        /* you can use WaitPort(). WaitPort() doesn't require */
        /* the setting of a signal bit. The only argument it  */
        /* requires is the pointer to the window's UserPort   */
        WaitPort(window->UserPort);
        while (msg=(struct IntuiMessage *)GetMsg(window->UserPort))
        {
            switch (msg->Class)
            {
            case CLOSEWINDOW: flag=FALSE;
                              break;
            case NEWSIZE:     Do_NewSize(window);
                              break;
            case GADGETDOWN:  CurrentGadget=GetGadgetID(msg);
                              break;
            case GADGETUP:    Check_Gadget(window,CurrentGadget);
                              CurrentGadget=NO_GADGET;
                              break;
            case INTUITICKS:  Check_Gadget(window,CurrentGadget);
            }
            ReplyMsg((struct Message *)msg);
        }
        Do_DrawStuff(window);
    }
}

VOID main(int argc, char *argv[])
{
struct BitMap *BigOne;
struct Window *window;
struct WindowInfo MyWindowInfo;
ULONG RasterSize;
SHORT Loop;
SHORT Flag;

    if (IntuitionBase=(struct IntuitionBase *)
                                    OpenLibrary("intuition.library",33L))
    {
        if (GfxBase=(struct GfxBase *)
                                    OpenLibrary("graphics.library",33L))
        {
            if (LayersBase=(struct LayersBase *)
                                    OpenLibrary("layers.library",33L))
            {
                if (BigOne=AllocMem(sizeof(struct BitMap),MEMF_PUBLIC|MEMF_CLEAR))
                {
                    InitBitMap(BigOne,DEPTH_SUPER,WIDTH_SUPER,HEIGHT_SUPER);
                    RasterSize=BigOne->BytesPerRow * BigOne->Rows;
                    Flag=TRUE;
                    for (Loop=0;Loop<DEPTH_SUPER;Loop++)
                    {
                        BigOne->Planes[Loop]=AllocMem(RasterSize,
                                       MEMF_CHIP|MEMF_CLEAR|MEMF_PUBLIC);
                        if (!BigOne->Planes[Loop]) Flag=FALSE;
                    }
                    if (Flag)
                    {
                        NewLinesWindow.BitMap=BigOne;
                        if (window=OpenWindow(&NewLinesWindow))
                        {

                            MyWindowInfo.LineX1=0;
                            MyWindowInfo.LineY1=0;
                            MyWindowInfo.LineX1d=5;
                            MyWindowInfo.LineY1d=2;
                            MyWindowInfo.LineX2=WIDTH_SUPER >> 2;
                            MyWindowInfo.LineY2=HEIGHT_SUPER >> 2;
                            MyWindowInfo.LineX2d=2;
                            MyWindowInfo.LineY2d=-5;
                            MyWindowInfo.pen=3;

                            window->UserData=(BYTE *)&MyWindowInfo;

                            Do_MainLoop(window);

                            CloseWindow(window);
                        }
                    }
                    for (Loop=0;Loop<DEPTH_SUPER;Loop++)
                    {
                        if (BigOne->Planes[Loop])
                        {
                            FreeMem(BigOne->Planes[Loop],RasterSize);
                        }
                    }
                    FreeMem(BigOne,sizeof(struct BitMap));
                }
                CloseLibrary((struct Library *)LayersBase);
            }
            CloseLibrary((struct Library *)GfxBase);
        }
        CloseLibrary((struct Library *)IntuitionBase);
    }
}
