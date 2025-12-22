/*
    File: ball.c

    Description: This is a short demo code that shows how we could
                 handle OS3.x features to use fast blitter operation
                 that are compatible with graphics boards. Images,
                 3 balls, red, green and blue, will be remaped to the
                 current colortable useing ObtainBestPen().
                 Also the images will be converted to a friend format of
                 the window they are drawn into. This means it _could_
                 also be in chunky mode then, e.g. if used on a SD64 with
                 an EGS driver, this images are chunky with a memory area
                 located on the gfx board ! (I do not know if other board
                 driver do support allocating display memory).
                 All images are drawn transparent, check out masking and
                 miniterms. This demo should run in all colormodes, though
                 I haven't tryed true color cyber modes yet - do not know
                 if we get 24 bit images then (but I think we will).

                 There is still one problem, the biggest one games coders
                 will say. It does not double buffer. This is not possible
                 with the method I use herein. So, yes, there is a problem
                 with real smooth image movements...

                 I just wanted to show, that you can use OS3 to use effecient
                 methods of image handling, without worring of the destination
                 bitmap format ! This code generates the optimal bitmap format
                 for the images by itself - see the BMF_FRIEND flag !
                 This is important for me, since I want to write my own emulation.
                 
                 I know, this code is not the best you can get. There is some
                 space to make it better. One could try to use custom (public:)
                 screens, double buffering, background images etc. If you like
                 go ahead and try what's possible.

                 I hope you enjoy it :)

    Author: Jürgen Schober
            Muchargasse 35/1/4
            A-8010 Graz
            e-mail: jschober@campusart.com

    Date: 23.11.1996 (96/23/11)

*/

// this is set if we want to use WaitTOF() to sync to frame rate

#define SYNC_IT


#include <stdio.h>
#include <stdlib.h>

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/cybergraphics_protos.h>

#include <pragmas/exec_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/cybergraphics_pragmas.h>

#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <cybergraphics/cybergraphics.h>

#include <graphics/gfx.h>

#include <egs/egs.h>

// my images 
// they where drawn using a 24 bit package, dithered to 256 colors and
// saved to c source by PPaint 6.4 (and modified by me)

#include "BlueBall.h"
#include "GreenBall.h"
#include "RedBall.h"
#include "BallMaske.h"

#include "Spectrum.h"


#define BMF_SPECIALFMT (1<<7)

// Convert it:

#ifndef __SASC
    #define __asm
#endif

extern void __asm CopyPlane2Chunky(register __a2 APTR planes,register __a3 APTR chunky,
                                   register __d6 WORD depth,register __d7 long BMSize);

struct Library *GfxBase = NULL;
struct IntuitionBase *IntuitionBase = NULL;
struct Window *win = NULL;
struct Screen *screen = NULL;

struct BitMap *RedBall = NULL,*GreenBall = NULL,*BlueBall = NULL,*MaskBall = NULL ;
int rx, ry, gx, gy, bx, by;
int drx,dry,dgx,dgy,dbx,dby;
int visible_width,visible_height;

UBYTE pens[256],pen;
long background;
int cycle = 0;

int BitMapDepth;    // for TrueColor Modes
BOOL IsGfxBoard = FALSE;
BOOL verbose = FALSE;


#define PLANESIZE    128
#define IMAGE_WIDTH  32  
#define IMAGE_HEIGHT 32
#define IMAGE_DEPTH  8   // 8 planes

// ----------------------------------------------------------------------
// Basic Exit Code
// ----------------------------------------------------------------------
void CleanUp()
{
    int i;

    // ------------------------------------------------------------------
    // Free the pens again
    // ------------------------------------------------------------------

    ReleasePen(win->WScreen->ViewPort.ColorMap,background);
    for (i = 0; i < 256 ; i++)
       ReleasePen(win->WScreen->ViewPort.ColorMap,pens[i]);

    // ------------------------------------------------------------------
    // now we want to free the bitmaps again
    // ------------------------------------------------------------------

    WaitBlit();

    if (RedBall)   FreeBitMap(RedBall);
    if (GreenBall) FreeBitMap(GreenBall);
    if (BlueBall)  FreeBitMap(BlueBall);
    if (MaskBall)  FreeBitMap(MaskBall);


    if (win)    CloseWindow(win);
    if (screen) CloseScreen(screen);

    // ------------------------------------------------------------------
    // and don't forget to close the libraries !
    // ------------------------------------------------------------------

    if (GfxBase) CloseLibrary(GfxBase);
    if (IntuitionBase) CloseLibrary((struct Library*)IntuitionBase);

    exit(0);
}

// ----------------------------------------------------------------------
// As We have Shared Pens, We have to allocate Them Here
// ----------------------------------------------------------------------
void AllocateColors()
{
    int i,idx;

    // ------------------------------------------------------------------
    // Init the Background Color
    // ------------------------------------------------------------------

    background = ObtainPen(win->WScreen->ViewPort.ColorMap,-1,
                 SpectrumRGB32[0].Red,SpectrumRGB32[0].Green,SpectrumRGB32[0].Blue,PEN_EXCLUSIVE);
    
    if (background == -1)
    {
        // ----------------------------------------------------------------
        // No pen available for a cycling background
        // ----------------------------------------------------------------

        SetAPen(win->RPort, ObtainBestPen(win->WScreen->ViewPort.ColorMap,-1,0x20,0x20,0xAA,TAG_DONE));
        RectFill(win->RPort,0,0,win->Width,win->Height);
    }
    else
    {
        // ----------------------------------------------------------------
        // I want a cycling background
        // ----------------------------------------------------------------

        SetAPen(win->RPort,background);
        RectFill(win->RPort,0,0,win->Width,win->Height);

    }

    if (verbose) { printf("Obtaining pens...\n\tPen "); fflush(stdout); }

    // ------------------------------------------------------------------
    // here I try to get as many colors of my table in the windows colormap
    // ------------------------------------------------------------------

    idx = 0;
    for (i = 0; i < 256; i++)
    {
        pens[i] = ObtainBestPen(win->WScreen->ViewPort.ColorMap,
                                BallPaletteRGB32[idx++],
                                BallPaletteRGB32[idx++],
                                BallPaletteRGB32[idx++],
                                OBP_Precision,PRECISION_EXACT,
                                TAG_DONE);

        if (verbose) { printf("%d = %d ",i,pens[i]); fflush(stdout); }

    }
    if (verbose) { puts("done."); fflush(stdout); }

}

// ----------------------------------------------------------------------
// Images have to be brought into a usable format
// ----------------------------------------------------------------------
void CreateImages()
{
    int i;
    ULONG pixels;
    UBYTE *buffer;
    UBYTE *ChunkyData;
    UBYTE *Planes[8];
    struct BitMap *BitMaps[3],*MaskBuffer = NULL;
    struct RastPort tmpRastPort,tmpRastPort2;
    PLANEPTR BackupPlanes[8];
    char *Name[]  = { "RedBall","GreenBall", "BlueBall" };
    UBYTE *Image,*ImageArray[] = { (UBYTE*)RedBallData, (UBYTE*)GreenBallData, (UBYTE*)BlueBallData };


    // ------------------------------------------------------------------
    // This is some support code if we run on a TrueColor Cyber Screen
    // in this case the Color Cycling has to be done in a different way
    // ------------------------------------------------------------------

    struct Library *CyberGfxBase; 

    if (CyberGfxBase = OpenLibrary("cybergraphics.library",40))
    {
        if (GetCyberMapAttr(win->RPort->BitMap,CYBRMATTR_ISCYBERGFX))
        {
            BitMapDepth = GetCyberMapAttr(win->RPort->BitMap,CYBRMATTR_DEPTH);
        }
        CloseLibrary(CyberGfxBase);
    }

    // ------------------------------------------------------------------
    // the Mask is a window friend and it is BMF_DISPLAYABLE, this means
    // that if available board memory is used  - so you get full
    // blitter access - check out the EGS SD64 :)
    // ------------------------------------------------------------------

    MaskBall = AllocBitMap(MASK_WIDTH,MASK_HEIGHT,MASK_DEPTH,BMF_MINPLANES|BMF_DISPLAYABLE,win->RPort->BitMap);
    if (!MaskBall)
    { 
        CleanUp();
    }

    // ------------------------------------------------------------------
    // but I have to convert it first - WITHOUT MAPPING !!
    // BMF_MINPLANES tells the OS not to allocate memory for the planes
    // WARNING ! Do not use struct BitMap bm; bm.Planes[] = xyz !!!
    // ------------------------------------------------------------------

    if ((MaskBuffer = AllocBitMap(MASK_WIDTH,MASK_HEIGHT,MASK_DEPTH,BMF_MINPLANES,NULL)) == NULL)
    {
        CleanUp();
    }
    
    // ------------------------------------------------------------------
    // looks if BMF_MINPLANES does not what I want, so I backup the 
    // planepointers...
    // basically, I thought that BMF_MINPLANES does not allocate space
    // for the planes, but only the structure. Now it seems, that it also allocates
    // the planes, which are freed again by FreeBitMap()... so ..hm, this is not
    // really legal...but I have to patch them a bit :) I only need it temporary.
    // ------------------------------------------------------------------

    CopyMemQuick(&MaskBuffer->Planes[0],BackupPlanes,8*sizeof(PLANEPTR));

    // ------------------------------------------------------------------
    // now I connect my planepointers to this bitmap
    // the source array is WORD aligned, therefore I have PLANESIZE/2 here !
    // ------------------------------------------------------------------

    MaskBuffer->Planes[0] = (PLANEPTR)&BallMaskeData[0*(PLANESIZE>>1)];
    MaskBuffer->Planes[1] = (PLANEPTR)&BallMaskeData[1*(PLANESIZE>>1)];
    MaskBuffer->Planes[2] = (PLANEPTR)&BallMaskeData[2*(PLANESIZE>>1)];
    MaskBuffer->Planes[3] = (PLANEPTR)&BallMaskeData[3*(PLANESIZE>>1)];
    MaskBuffer->Planes[4] = (PLANEPTR)&BallMaskeData[4*(PLANESIZE>>1)];
    MaskBuffer->Planes[5] = (PLANEPTR)&BallMaskeData[5*(PLANESIZE>>1)];
    MaskBuffer->Planes[6] = (PLANEPTR)&BallMaskeData[6*(PLANESIZE>>1)];
    MaskBuffer->Planes[7] = (PLANEPTR)&BallMaskeData[7*(PLANESIZE>>1)];

    // ------------------------------------------------------------------
    // now convert the bitmap into a window friend format
    // ------------------------------------------------------------------

    WaitBlit();
    BltBitMap(MaskBuffer,0,0,MaskBall,0,0,MASK_WIDTH,MASK_HEIGHT,0xC0,0xff,0);

    // ------------------------------------------------------------------
    // wait for the blitter
    // ------------------------------------------------------------------

    WaitBlit();

    // ------------------------------------------------------------------
    // and free the buffer again
    // ...and install the old planes again, so I can call FreeBitMap()
    // ------------------------------------------------------------------

    CopyMemQuick(BackupPlanes,&MaskBuffer->Planes[0],8*sizeof(PLANEPTR));
    FreeBitMap(MaskBuffer);
    
    // ------------------------------------------------------------------
    // again I need 3 bitmaps for my images. In best case they should have
    // the same format as the bitmap on the display, better they should
    // be in the board memory for real fast blitting -> BMF_DISPLAYABLE
    // ------------------------------------------------------------------


    RedBall   = AllocBitMap(RED_WIDTH,RED_HEIGHT,RED_DEPTH,BMF_MINPLANES|BMF_DISPLAYABLE,win->RPort->BitMap);
    GreenBall = AllocBitMap(GREEN_WIDTH,GREEN_HEIGHT,GREEN_DEPTH,BMF_MINPLANES|BMF_DISPLAYABLE,win->RPort->BitMap);
    BlueBall  = AllocBitMap(BLUE_WIDTH,BLUE_HEIGHT,BLUE_DEPTH,BMF_MINPLANES|BMF_DISPLAYABLE,win->RPort->BitMap);

    // ------------------------------------------------------------------
    // make sure we got the Balls
    // ------------------------------------------------------------------

    if (!RedBall && !GreenBall && !BlueBall) 
    {
        CleanUp();
    }    

    // ------------------------------------------------------------------
    // we clone the windows rastport and set the layer to NULL
    // this is used to convert the then remaped image to my friendbitmaps, see below
    // ------------------------------------------------------------------

    CopyMem(win->RPort,&tmpRastPort,sizeof(struct RastPort));
    tmpRastPort.Layer = NULL;

    // ------------------------------------------------------------------
    // I support v39 now, so I need another RastPort for the WritePixelArray8()
    // ------------------------------------------------------------------

    CopyMem(win->RPort,&tmpRastPort2,sizeof(struct RastPort));
    tmpRastPort2.Layer = NULL;
    tmpRastPort2.BitMap = AllocBitMap(MASK_WIDTH,1,MASK_DEPTH,0,NULL);

    // ------------------------------------------------------------------
    // I also need my images in an array for the next loop, see there
    // ------------------------------------------------------------------

    BitMaps[0] = RedBall;
    BitMaps[1] = GreenBall;
    BitMaps[2] = BlueBall;

    // ------------------------------------------------------------------
    // we need a chunky buffer, we need it only once because of the same size
    // this chunky buffer is needed because I want to remap the images to 
    // the available colors. This is really easy if you have 8 bit chunky sources
    // ------------------------------------------------------------------

    if (!(ChunkyData = AllocVec(IMAGE_WIDTH * IMAGE_HEIGHT, 0))) 
    {
        CleanUp();
    }
    
    // ------------------------------------------------------------------
    // this loop converts my 3 plane sources to chunky images and
    // remaps them to the colors allocated above
    // ------------------------------------------------------------------

    for (i = 0; i < 3 ; i++) // 2 images
    { 
        if (verbose) { printf("Converting plane to chunky ..."); fflush(stdout); }

        // -------------------------------------------------------------------
        // my own convert routine wants the planes in an array of planepointers
        // -------------------------------------------------------------------

        Image = ImageArray[i];
        Planes[0] = (PLANEPTR)&Image[0*PLANESIZE];
        Planes[1] = (PLANEPTR)&Image[1*PLANESIZE];
        Planes[2] = (PLANEPTR)&Image[2*PLANESIZE];
        Planes[3] = (PLANEPTR)&Image[3*PLANESIZE];
        Planes[4] = (PLANEPTR)&Image[4*PLANESIZE];
        Planes[5] = (PLANEPTR)&Image[5*PLANESIZE];
        Planes[6] = (PLANEPTR)&Image[6*PLANESIZE];
        Planes[7] = (PLANEPTR)&Image[7*PLANESIZE];
    
        // ------------------------------------------------------------------
        // I use my own chunky converter.
        // well, this thing is really old, but does it's job...
        // It converts DEPTH planes with PLANESIZE and Planes[DEPTH] into
        // an UBYTE *ChunkyBuffer. - it does no selective (x/y) conversion.
        // ------------------------------------------------------------------

        buffer = ChunkyData;
        CopyPlane2Chunky(&Planes,buffer,IMAGE_DEPTH, PLANESIZE);

        if (verbose) { puts("done."); fflush(stdout);    }
        if (verbose) { printf("remapping image.."); fflush(stdout); }

        // ------------------------------------------------------------------
        // Now we remap <pixels> to the new colors
        // where we loose the original chunky data - we don't need them, see below
        // ------------------------------------------------------------------

        pixels = IMAGE_WIDTH * IMAGE_HEIGHT;
        while (pixels--)
        {
            pen = (ChunkyData[pixels]);
            ChunkyData[pixels] = pens[pen];
        }
        if (verbose) { puts("done"); fflush(stdout); }

        // ------------------------------------------------------------------
        // here we convert the remaped chunky image to a friend bitmap of the window
        // we use a temporary rastport here where we install the previous allocated
        // ball bitmaps. We use WriteChunkyPixels() here, so it will be converted
        // to the correct format ! This could also be a chunky format !
        // if we are on a gfxboard, this is just a plain copy, if we are on ECS/AGA,
        // it converts it to plane sources
        // ------------------------------------------------------------------

        tmpRastPort.BitMap = BitMaps[i];

        // ------------------------------------------------------------------
        // I really hate this WritePixelArray8() so I try to use the WriteChunkyPixels() if possible
        // ------------------------------------------------------------------

        if (GfxBase->lib_Version >= 40)
            WriteChunkyPixels(&tmpRastPort,0,0,IMAGE_WIDTH-1,IMAGE_HEIGHT-1,ChunkyData,IMAGE_WIDTH);
        else
            WritePixelArray8(&tmpRastPort,0,0,IMAGE_WIDTH-1,IMAGE_HEIGHT-1,ChunkyData,&tmpRastPort2);

        // ------------------------------------------------------------------
        // WARNING! This is available to OS 3.1 (v40) only, so this would be more
        // complicating on v39 system (OS2 is not supported , see ObtainPen())
        // -> check out the WritePixelLine8()/WritePixelArray8() functions
        // ^^^^^ you see, previously, I didn't even want to support v39 :)
        // ------------------------------------------------------------------
        
    }
    // ------------------------------------------------------------------
    // we don't need the chunky puffer any more, so dispose it
    // ------------------------------------------------------------------

    if (ChunkyData)  FreeVec(ChunkyData);

    // ------------------------------------------------------------------
    // I also don't need the tmpRastPort anymore, so I have to free another bitmap
    // ------------------------------------------------------------------

    WaitBlit();
    FreeBitMap(tmpRastPort2.BitMap);

}

// ----------------------------------------------------------------------
// I used this to set some default values
// ----------------------------------------------------------------------
void InitPosition()
{
    // ------------------------------------------------------------------
    // some start values for the ball movement
    // ------------------------------------------------------------------

    rx = 100; ry = 50; 
    gx = 4;   gy = 350;
    bx = 600; by = 300;

#ifdef SYNC_IT

    drx = 12;  dry = 10;
    dgx = 28;  dgy = -28;
    dbx = -8; dby = -10;

#else

    drx = 6;  dry = 5;
    dgx = 7;  dgy = -7;
    dbx = -4; dby = -5;

#endif
    // ------------------------------------------------------------------
    // I set them to their default position in the window
    // if not, we must wait for the blitter...borddriver usually do this internally
    // ------------------------------------------------------------------

    WaitBlit();
    BltBitMapRastPort(MaskBall, 0,0,win->RPort,rx,ry,MASK_WIDTH, MASK_HEIGHT, 0x20);
    WaitBlit();
    BltBitMapRastPort(RedBall,  0,0,win->RPort,rx,ry,RED_WIDTH,  RED_HEIGHT,  0xE0);
    WaitBlit();
    BltBitMapRastPort(MaskBall, 0,0,win->RPort,gx,gy,MASK_WIDTH, MASK_HEIGHT, 0x20);
    WaitBlit();
    BltBitMapRastPort(GreenBall,0,0,win->RPort,gx,gy,GREEN_WIDTH,GREEN_HEIGHT,0xE0);
    WaitBlit();
    BltBitMapRastPort(MaskBall, 0,0,win->RPort,bx,by,MASK_WIDTH, MASK_HEIGHT, 0x20);
    WaitBlit();
    BltBitMapRastPort(BlueBall, 0,0,win->RPort,bx,by,BLUE_WIDTH, BLUE_HEIGHT, 0xE0);
}

// ----------------------------------------------------------------------
// This is the loop that moves the balls around
// ----------------------------------------------------------------------
void MoveBalls()
{
    int rx_old, ry_old, gx_old, gy_old, bx_old, by_old;
    struct ViewPort *ViewPort;

#ifdef SYNC_IT
    WaitTOF();
#endif

    // ------------------------------------------------------------------
    // I calculate the new values first because the drawing should be done
    // as smooth as possible. As we draw the images direct to the screen,
    // we can not avoid some flickering...this could be done with another
    // buffer...but if you like...some exercise for you
    // ------------------------------------------------------------------

    // ------------------------------------------------------------------
    // The Red Image
    // ------------------------------------------------------------------

    rx_old = rx; ry_old = ry;
    rx += drx;   ry += dry;
    if ((rx > (visible_width - RED_WIDTH - abs(drx))) || (rx < abs(drx)))
    {
        drx *= -1;
    }
    if ((ry > (visible_height - RED_HEIGHT - abs(dry))) || (ry < abs(dry)))
    {
        dry *= -1;
    }

    // ------------------------------------------------------------------
    // The Green Image
    // ------------------------------------------------------------------

    gx_old = gx;  gy_old = gy;
    gx += dgx;    gy += dgy;
    if ((gx > (visible_width - RED_WIDTH - abs(dgx))) || (gx < abs(dgx)))
    {
        dgx *= -1;
    }
    if ((gy > (visible_height - RED_HEIGHT - abs(dgy))) || (gy < abs(dgy)))
    {
        dgy *= -1;
    }

    // ------------------------------------------------------------------
    // The Blue Image
    // ------------------------------------------------------------------

    bx_old = bx;  by_old = by;
    bx += dbx;    by += dby;
    if ((bx > (visible_width - RED_WIDTH - abs(dbx))) || (bx < abs(dbx)))
    {
        dbx *= -1;
    }
    if ((by > (visible_height - RED_HEIGHT - abs(dby))) || (by < abs(dby)))
    {
        dby *= -1;
    }

    // ------------------------------------------------------------------
    // I clear the old position with a simple RectFill, better
    // would be to backup the background first...so we could use
    // a backdrop pattern...but that's for the next exercise
    // ------------------------------------------------------------------

    // ------------------------------------------------------------------
    // cycle the backgroundcolor - if we have a pen
    // ------------------------------------------------------------------

    if (background != -1L)
    {
        if (++cycle >= SPECTRUM_COLORS) cycle = 0; // modulo does not work here
        ViewPort = &win->WScreen->ViewPort; 
        SetRGB32(ViewPort,background,
                    SpectrumRGB32[cycle].Red,SpectrumRGB32[cycle].Green,SpectrumRGB32[cycle].Blue);
    }

    // ------------------------------------------------------------------
    // Palette cycling is not available on NON Indexed modes...so, hm, simulate it
    // and... we don't have to clear the images then...should flicker, eh ?
    // ------------------------------------------------------------------

    if (IsGfxBoard && (BitMapDepth > 8))
    {
        RectFill(win->RPort,0,0,win->Width,win->Height);
    }
    else
    {
        RectFill(win->RPort,rx_old,ry_old,rx_old + RED_WIDTH,   ry_old + RED_HEIGHT);
        RectFill(win->RPort,gx_old,gy_old,gx_old + GREEN_WIDTH, gy_old + GREEN_HEIGHT);
        RectFill(win->RPort,bx_old,by_old,bx_old + BLUE_WIDTH,  by_old + BLUE_HEIGHT);
    }

    WaitBlit();
    BltBitMapRastPort(MaskBall,0,0,win->RPort,rx,ry,MASK_WIDTH ,MASK_HEIGHT ,0x20);

    WaitBlit();
    BltBitMapRastPort(RedBall ,0,0,win->RPort,rx,ry,IMAGE_WIDTH,IMAGE_HEIGHT,0xE0);

    WaitBlit();
    BltBitMapRastPort(MaskBall ,0,0,win->RPort,gx,gy,MASK_WIDTH ,MASK_HEIGHT ,0x20);

    WaitBlit();
    BltBitMapRastPort(GreenBall,0,0,win->RPort,gx,gy,IMAGE_WIDTH,IMAGE_HEIGHT,0xE0);

    WaitBlit();
    BltBitMapRastPort(MaskBall,0,0,win->RPort,bx,by,MASK_WIDTH ,MASK_HEIGHT ,0x20);

    WaitBlit();
    BltBitMapRastPort(BlueBall,0,0,win->RPort,bx,by,IMAGE_WIDTH,IMAGE_HEIGHT,0xE0);
    
}

// ----------------------------------------------------------------------
// The Main Part 
// ----------------------------------------------------------------------
void main(int argc,char **argv)
{
    int i;
    USHORT class;
    USHORT code;
    struct IntuiMessage *message;
    ULONG sig;
    BOOL out = FALSE;
    UWORD zoom[] = { 100,100,1074,768 };

    GfxBase = OpenLibrary("graphics.library",39); // we need a v39+ OS, see below
    IntuitionBase = (struct IntuitionBase*)OpenLibrary("intuition.library",0);

    if (GfxBase && IntuitionBase);
    {
//        screen = OpenScreenTags(NULL,SA_LikeWorkbench,TRUE,TAG_DONE);
        
        if (win = OpenWindowTags(NULL,
                                WA_Title, "Check this out!",
                                WA_AutoAdjust,TRUE,
//                                WA_CustomScreen,screen,
//                                WA_Backdrop, TRUE,
//                                WA_Borderless,  TRUE,
                                WA_InnerWidth,  640, //screen->Width, 
                                WA_InnerHeight, 400, //screen->Height,
                                WA_MaxWidth,2000,
                                WA_MaxHeight,2000,
                                WA_MinWidth,10,
                                WA_MinHeight,10,
                                WA_DragBar, TRUE,
                                WA_CloseGadget, TRUE,
                                WA_DepthGadget,TRUE,
                                WA_GimmeZeroZero, TRUE,
//                                WA_SimpleRefresh, TRUE,
                                WA_SmartRefresh, TRUE,
                                WA_SizeGadget,TRUE,
                                WA_SizeBBottom, TRUE,
                                WA_Zoom, zoom,
                                WA_IDCMP,IDCMP_CLOSEWINDOW | IDCMP_NEWSIZE,
                                TAG_DONE))
        {
            // ----------------------------------------------------------------
            // I need some colors so I allocate some (see above)
            // ----------------------------------------------------------------

            AllocateColors();

            // ----------------------------------------------------------------
            // check out if we are on a gfx board:
            // ----------------------------------------------------------------

            i = GetBitMapAttr(win->RPort->BitMap,BMA_FLAGS);
            IsGfxBoard = (i & BMF_STANDARD) ? FALSE : TRUE;

            // ----------------------------------------------------------------
            // now I have to create the images in an usably format
            // ----------------------------------------------------------------

            CreateImages();

            // ----------------------------------------------------------------
            // and I want some init values
            // ----------------------------------------------------------------

            InitPosition();

            visible_width = win->Width - win->BorderLeft - win->BorderRight;
            visible_height = win->Height - win->BorderTop - win->BorderBottom;   

            sig = (1L<<win->UserPort->mp_SigBit);
            while (!out)
            {
                // ----------------------------------------------------------------
                // This moves my balls around
                // ----------------------------------------------------------------

                MoveBalls();

                // ----------------------------------------------------------------
                // I use a busy loop to check window events,
                // this is not really a problem since we run in endless mode
                // ----------------------------------------------------------------

                if (message = (struct IntuiMessage *)GetMsg(win->UserPort))
                {
            	    class = message->Class;
        	        code  = message->Code;
                    switch(class)
            	    {
           	    	    case CLOSEWINDOW:
                            out = TRUE;
                            break;
        		        case NEWSIZE:
                            // refresh the background

                            visible_width = win->Width - win->BorderLeft - win->BorderRight;
                            visible_height = win->Height - win->BorderTop - win->BorderBottom;   
                            RectFill(win->RPort,0,0,visible_width,visible_height);

                            // bring the images back to window if window size gets to small

                            rx %= visible_width;
                            ry %= visible_height;
                            gx %= visible_width;
                            gy %= visible_height;
                            bx %= visible_width;
                            by %= visible_height;
                            break;
                        default :
                            break;
               	    }
                }
            }

            // ----------------------------------------------------------------
            // we should make sure there is no bitmap used when we free it
            // ----------------------------------------------------------------

            WaitBlit();

            // ----------------------------------------------------------------
            // Free all Pens and Bitmaps
            // ----------------------------------------------------------------
            
        }
        CleanUp();
    }
}
