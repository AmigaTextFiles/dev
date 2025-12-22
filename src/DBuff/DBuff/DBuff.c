/* #define DEMO 1 */

/***************************************************************************

   Program:    
   File:       DBuff.c
   
   Version:    V1.3
   Date:       05.02.91
   Function:   Setup routines for double buffering based on Intuition screens
   
   Copyright:  SciTech Software 1991
   Author:     Andrew C. R. Martin
   Address:    SciTech Software
               23, Stag Leys,
               Ashtead,
               Surrey,
               KT21 2TD.
   Phone:      +44 (0372) 275775
   EMail:      UUCP: cbmuk!cbmuka!scitec!amartin
               JANET: andrew@uk.ac.ox.biop
               
****************************************************************************

   This program is not in the public domain, but it may be freely copied
   and distributed for no charge providing this header is included.
   The code may be modified as required, but any modifications must be
   documented so that the person responsible can be identified. If someone
   else breaks this code, I don't want to be blamed for code that does not
   work! The code may not be sold commercially without prior permission from
   the author, although it may be given away free with commercial products,
   providing it is made clear that this program is free and that the source
   code is provided with the program.

****************************************************************************

   Description:
   ============

   These routines set up, manipulate and tidy up for double buffered
   animation using an Intuition Screen and Window

****************************************************************************

   Usage:
   ======

   5 routines are supplied:

>  RastPort = (struct RastPort *)InitDBuff(GfxBase,Screen,depth,Window)
   --------------------------------------------------------------------
   Given the GfxBase, Screen and Window, this routine returns the
   second RastPort

>  SetView1()
   ----------
>  SetView2()
   ----------
   Sets the required view ready for drawing. SetView1() sets the Intuition
   view, SetView2() sets the alternate view.
   
>  SwapView(Screen)
   ----------
   Displays the new view (after drawing)
   
>  FreeDBuff(screen,depth,RastPort)
   --------------------------------
   Frees up the memory, etc. for the second view.

   Notes:
   ======
   1. Assumes both graphics and intuition libraries are open
   2. The window should be NOBORDER and have a null title
   3. #define DEMO to see the demonstration.

****************************************************************************

   Revision History:
   =================

   V1.1  11.02.91
   Fixed SwapView()

   V1.2  16.12.91
   Tidied up and ANSIfied. Made globals static.
   
   V1.3  09.05.92
   Fixed example (SetView()'s were the wrong way round!). Removed various
   junk which didn't actually do anything!

***************************************************************************/
/* Includes
*/

#include <exec/types.h>
#include <exec/memory.h>
#include <intuition/intuition.h>
#include <graphics/display.h>
#include <graphics/gfxbase.h>

/**************************************************************************/
/* Global Amiga system variables
*/

static struct RasInfo *DB_rinfo = NULL; /* Intuition supplied rasinfo     */
static struct BitMap  *DB_bmap1 = NULL, /* Intuition supplied bitmap      */
                      *DB_bmap2 = NULL; /* Second bitmap                  */
static struct View    *DB_view  = NULL; /* Intuition View                 */

/**************************************************************************/
InitDBuff(struct GfxBase *GfxBase,
          struct Screen  *screen,
          int            depth,
          struct Window  *window)
{
   /* Amiga system variables */
   struct RastPort *rport1    = NULL;  /* Intuition supplied rastport     */
   struct ViewPort *vport     = NULL;  /* Intuition Viewport              */
   struct RastPort *rport2    = NULL;  /* new rastport                    */
   
   int    j,
          problem = 0;

   rport2 = NULL;

   /* Get the bitmap, rastport, viewport, view and rasinfo supplied by 
      Intuition from the window, screen and graphics base from the call.
   */
   rport1      = window->RPort;
   DB_bmap1    = rport1->BitMap;
   vport       = &(screen->ViewPort);
   DB_view     = GfxBase->ActiView;
   DB_rinfo    = (*vport).RasInfo;


   /*** Allocate second bitmap & memory for bitplanes ***/
   if(!(DB_bmap2=(struct BitMap *)
                 AllocMem(sizeof(struct BitMap), MEMF_PUBLIC|MEMF_CLEAR)))
   {
      printf("alloc bitmap failed\n");
      rport2   = NULL;
      problem  = 1;
      goto EXITING;
   }
   InitBitMap(DB_bmap2, depth, screen->Width, screen->Height);
   /* We'll use depth planes. */
   for(j=0; j<depth; j++)
   {
      if (!(DB_bmap2->Planes[j] =
         (PLANEPTR) AllocRaster(screen->Width, screen->Height)))
      {
         printf("alloc raster failed\n");
         rport2   = NULL;
         problem  = 1;
         goto EXITING;
      }
   }

   /*** Create a rastport for this bitmap to simplify drawing ***/
   if(!(rport2 = (struct RastPort *)
                 AllocMem(sizeof(struct RastPort), MEMF_PUBLIC)))
   {
      printf("alloc rastport failed\n");
      rport2   = NULL;
      problem  = 1;
      goto EXITING;
   }
   InitRastPort(rport2);
   rport2->BitMap = DB_bmap2;

   SetRast(rport2, 0);

   /*** Swap views back and forth to get the MakeScreen()
        out of the way    
   ***/
   SetView2();
   MakeScreen(screen);
   MrgCop(DB_view);

   SetView1();
   MrgCop(DB_view);
   
EXITING:
   if(problem) FreeDBuff(screen,depth,rport2);
   
   return((int)rport2);
}

/**************************************************************************/
SetView1(void)
{
   DB_rinfo->BitMap  = DB_bmap1;
   return(0);
}

/**************************************************************************/
SetView2(void)
{
   DB_rinfo->BitMap  = DB_bmap2;
   
   return(0);
}

/**************************************************************************/
SwapView(struct Screen *scrn)
{
   MakeScreen(scrn);
   MrgCop(DB_view);
   
   return(0);
}

/**************************************************************************/
FreeDBuff(struct Screen    *screen,
          int              depth,
          struct RastPort  *rport2)
{
   int j;
   
   /* Ensure we're on the Intuition-supplied bit map before exiting */
   SetView1();
   MrgCop(DB_view);

   /* Free up the second rastport */
   if(rport2) FreeMem(rport2, sizeof(struct RastPort));

   /* Free up the second bit map */
   if(DB_bmap2) 
   {
      for(j=0;j<depth;j++)
      {
         if(DB_bmap2->Planes[j])
            FreeRaster(DB_bmap2->Planes[j], screen->Width, screen->Height);
      }
      FreeMem(DB_bmap2, sizeof (struct BitMap));
   }
   
   return(0);
}

/***************************************************************************
*                                                                          *
*              DEMO CODE --- Compiled if DEMO defined                      *
*                                                                          *
***************************************************************************/
#ifdef DEMO

#include <exec/types.h>
#include <intuition/intuition.h>
#include <graphics/display.h>

#define DEPTH 1      /* Screen depth (number of bitplanes)                */

/* Global Amiga system variables */
struct  IntuitionBase   *IntuitionBase = NULL;
struct  GfxBase         *GfxBase       = NULL;

main()
{
   /* Amiga system variables */
   struct Screen   *screen    = NULL;  /* Intuition screen                */
   struct Window   *window    = NULL;  /* Intuition window                */
   struct RastPort *rport1    = NULL,  /* Intuition supplied rastport     */
                   *rport2    = NULL;

   int    j,
          exitval = 0;


   /*** Open Libraries ***/
   if(!(IntuitionBase = (struct IntuitionBase *)
                        OpenLibrary("intuition.library", 0)))
   {
      printf("NO INTUITION LIBRARY\n");
      exitval = 1;
      goto CRAPOUT;
   }

   if(!(GfxBase = (struct GfxBase *)
                  OpenLibrary("graphics.library", 0)))
   {
      printf("NO GRAPHICS LIBRARY\n");
      exitval = 2;
      goto CRAPOUT;
   }

   /*** Open Intuition screen and window ***/
   if((screen = (struct Screen *)make_screen(0,640,400,DEPTH,-1,-1,
                HIRES|INTERLACE,"***Test Screen***"))==NULL)
   {
      printf("Can't open screen\n");
      exitval = 1;
      goto CRAPOUT;
   }

   /*** Open a window on the new screen ***/
   if((window = (struct Window *)make_window(0,0,640,400,NULL,
                BORDERLESS|SIMPLE_REFRESH,NULL,-1,-1,screen,NULL))==NULL)
   {
      printf("Can't open window\n");
      exitval = 1;
      goto CRAPOUT;
   }

   rport1 = window->RPort;
   rport2 = (struct RastPort *)InitDBuff(GfxBase,screen,DEPTH,window);

   /*** Loop which draws into alternate bitmaps and swaps view ***/
   for(j=0;j<500;j++)
   {
      if(j%2)  /* Odd cases --- Draw to rport1 */
      {
         SetView1();

         if(j-2 > 0)  DrawFigure(rport1,j-2,0); /* Clear previous version */
         DrawFigure(rport1,j,1);                /* Draw this version      */
      }
      else     /* Even cases --- Draw to rport2 */
      {
         SetView2();

         if(j-2 >= 0) DrawFigure(rport2,j-2,0); /* Clear previous version */
         DrawFigure(rport2,j,1);                /* Draw this version      */
      }
      
      SwapView(screen);
      Delay(1);
   }
   
   

CRAPOUT:
   FreeDBuff(screen,DEPTH,rport2);
   
   /* Close stuff */
   if(window)        CloseWindow(window);
   if(screen)        CloseScreen(screen);
   if(GfxBase)       CloseLibrary(GfxBase);
   if(IntuitionBase) CloseLibrary(IntuitionBase);

   exit(exitval);
}

/**************************************************************************/
make_screen(SHORT    y,
            SHORT    w,
            SHORT    h,
            SHORT    d,
            UBYTE    colour0,
            UBYTE    colour1,
            USHORT   mode,
            UBYTE    *name)
{
   struct NewScreen NewScreen;


   NewScreen.LeftEdge      = 0;
   NewScreen.TopEdge       = y;
   NewScreen.Width         = w;
   NewScreen.Height        = h;
   NewScreen.Depth         = d;
   NewScreen.DetailPen     = colour0;
   NewScreen.BlockPen      = colour1;
   NewScreen.ViewModes     = mode;
   NewScreen.Type          = CUSTOMSCREEN;
   NewScreen.Font          = NULL;
   NewScreen.DefaultTitle  = name;
   NewScreen.Gadgets       = NULL;
   NewScreen.CustomBitMap  = NULL;

   return(OpenScreen(&NewScreen));
}

/**************************************************************************/
/* Initialize a NewWindow and Open it.
*/
make_window(SHORT         x,
            SHORT         y,
            SHORT         w,
            SHORT         h,
            UBYTE         *name, 
            ULONG         flags,
            ULONG         iflags,
            UBYTE         colour0,
            UBYTE         colour1,
            struct Screen *screen,
            struct Gadget *gadg)
{
   struct NewWindow NewWindow;

   NewWindow.LeftEdge      = x;
   NewWindow.TopEdge       = y;
   NewWindow.Width         = w;
   NewWindow.Height        = h ;
   NewWindow.DetailPen     = colour0;
   NewWindow.BlockPen      = colour1;
   NewWindow.Title         = name;
   NewWindow.Flags         = flags;
   NewWindow.IDCMPFlags    = iflags;
   NewWindow.Type          = CUSTOMSCREEN;
   NewWindow.FirstGadget   = gadg;
   NewWindow.CheckMark     = NULL;
   NewWindow.Screen        = screen;
   NewWindow.BitMap        = NULL;
   NewWindow.MinWidth      = 0;
   NewWindow.MinHeight     = 0;
   NewWindow.MaxWidth      = 0;
   NewWindow.MaxHeight     = 0;

   return(OpenWindow(&NewWindow));
}

/**************************************************************************/
DrawFigure(struct RastPort *rp,
           int             n,
           int             p)
{
   SetAPen(rp,p);
   Move(rp,n+20,270);
   Draw(rp,n+0,250);
   Draw(rp,n+0,220);
   Draw(rp,n+20,200);
   Draw(rp,n+40,220);
   Draw(rp,n+40,250);
   Draw(rp,n+20,270);
   Draw(rp,n+20,300);
   Draw(rp,n+40,320);
   Draw(rp,n+20,340);
   Move(rp,n+40,320);
   Draw(rp,n+70,320);
   Draw(rp,n+70,340);
   Move(rp,n+70,320);
   Draw(rp,n+90,300);

   Move(rp,n+20, 70);
   Draw(rp,n+0,  50);
   Draw(rp,n+0,  20);
   Draw(rp,n+20, 00);
   Draw(rp,n+40, 20);
   Draw(rp,n+40, 50);
   Draw(rp,n+20, 70);
   Draw(rp,n+20,100);
   Draw(rp,n+40,120);
   Draw(rp,n+20,140);
   Move(rp,n+40,120);
   Draw(rp,n+70,120);
   Draw(rp,n+70,140);
   Move(rp,n+70,120);
   Draw(rp,n+90,100);

   return(0);
}
               
#endif /* DEMO */
