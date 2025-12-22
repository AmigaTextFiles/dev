/* This file contains Screen and BitMap functions -- creating and
 * closing/freeing them.
 *
 * Dominic Giampaolo © 1991.
 */
#include "inc.h"    /* make sure to get the amiga includes */

#include "ezlib.h"


extern struct GfxBase *GfxBase;
extern struct IntuitionBase *IntuitionBase;


/* structure will be copied and filled in later */
static struct NewScreen ez_DefaultScreen =
 {
  0L, 0L,		    /* left edge, top edge   */
  320L, 200L,		    /* width,	  height     */
  1L,			    /* depth		     */
  0L, 1L,		    /* detailpen, blockpen   */
  0L,			    /* ViewModes,	     */
  CUSTOMSCREEN|SCREENQUIET, /* type,		     */
  NULL, 		    /* Font,		     */
  NULL, 		    /* title,		     */
  NULL, NULL		    /* Gadgets, BitMap	     */
 };


/* This function will opens a custom screen for you. It returns NULL on
 * failure to open the screen.
 *
 *    Arguments :
 *	  modes : The viewmodes you would like (HIRES, LACE, etc.).
 *	  depth : the number of bitplanes (presently less than 6)
 *
 */
struct Screen *CreateScreen(int modes, int depth)
{
 struct Screen *temp_ptr;
 struct NewScreen NewScreen;

 /* some sanity checking - short and fast */
 if(GfxBase == NULL || IntuitionBase == NULL)
  if ( OpenLibs(GFX | INTUITION) == NULL)
    return NULL;

 NewScreen = ez_DefaultScreen;		 /* copy in the default struct */

 NewScreen.ViewModes = modes;		 /* assume modes value is o.k. */

 if (modes & HIRES)
   NewScreen.Width = 640;
 if (modes & LACE)
   NewScreen.Height = (SHORT)( 2 * GfxBase->NormalDisplayRows );
 else
   NewScreen.Height = (SHORT)GfxBase->NormalDisplayRows;

 /* check depth field to make sure it agrees with resolution type */
 if (depth > 4 && (modes & HIRES))
   depth = 4;

 if (depth <= 0)
   depth = 1;

 if (modes & HAM)                          /* make sure we have ok vals */
   { depth = 6; NewScreen.Width = 320; }

 if (modes & EXTRA_HALFBRITE)              /* give valid values */
   { depth = 6; NewScreen.Width = 320; }

 /* make sure no foolishness here */
 if (depth > 6)
   depth = 6;

 NewScreen.Depth = depth;		   /* o.k. to do this now */

 /* now see if we have to allocate bitmap stuff */
 if (depth > 2) {
   NewScreen.CustomBitMap = (struct BitMap *)GetBitMap( depth, NewScreen.Width, NewScreen.Height );
   if (NewScreen.CustomBitMap == NULL)
     return NULL;
   NewScreen.Type |= CUSTOMBITMAP;
 }

 temp_ptr = OpenScreen(&NewScreen);

 /* we shove the bitmap ptr into the user data field so we can free it
  * properly later on.	READ: don't use the ExtData field of your screen,
  * or if you do, save it first and then restore it before calling
  * killscreen()!
  */

 if (temp_ptr != NULL && depth > 2)
   temp_ptr->ExtData = (UBYTE *)NewScreen.CustomBitMap;

 return temp_ptr;
}     /*  end of CreateScreen()  */


/* This function allocates and initializes a struct BitMap to your said
 * dimensions.	It returns NULL on any failure.
 *
 *   Arguments :
 *	 depth : depth of the desired bitmap (upto 8)
 *	 width : width of the desired bitmap (upto 32768)
 *	 height: height of the desired bitmap (upto 32768)
 */

struct BitMap *GetBitMap(int depth, int width, int height)
{
 register struct BitMap *bm;

 if(depth > 8)
   return NULL;

 if (width > 32768 || height > 32768)
   return NULL;

 bm = (struct BitMap*)AllocMem(sizeof(struct BitMap), MEMF_CLEAR);
 if ( bm == NULL)
   return NULL;

 InitBitMap(bm, depth, width, height);

 /* takes care of freeing bitmap struct if it fails */
 if ( get_rasters(bm, width, height) == NULL)
   return NULL;

 return bm;
}   /*	end of getbitmap()  */



/* NOTICE : This code is pretty much straight out of the Transactor
 * volume 1, issue 3.  I did modify it a bit however.
 *
 * It will nicely allocate all of the required bit plane pointers for your
 * specified bitmap structure.	Return NULL if something screws up.
 *
 * This is an EzLib private function.  You shouldn't use it (hence the lower
 * case name).
 */
get_rasters(struct BitMap *bm, int width, int height)
{
 register int i;
 register long size;

 size = bm->Rows * bm->BytesPerRow;

 for (i=0; i < bm->Depth; i++)
  {
   bm->Planes[i] = (PLANEPTR) AllocRaster( width, height);

   if (bm->Planes[i] == NULL)
    {
      if (Output())
	MSG("No mem for BitMap data.  Exiting.\n");
     return FreeBitMap(bm, width, height);
    }

   BltClear((char *)bm->Planes[i], ((width/8) * height), 1L);
  }
 return 1;
}    /*  end of AllocRasters()  */


/* This function frees a bitmap and all its associated memory.
 *
 *    Arguments :
 *	  bm : a BitMap pointer that you would like freed
 *	  width,height : width and height of the bitmap to free
 */
FreeBitMap(struct BitMap *bm, int width, int height)
{
 register int i;

 if (bm == NULL)
   return NULL;

 /* if a plane pointer is null, this for loop exits */
 for (i=0; bm->Planes[i] && i < bm->Depth; i++) {
       FreeRaster(bm->Planes[i], (LONG)width, (LONG)height);
 }

 FreeMem(bm, sizeof(struct BitMap));
 return NULL;
}   /*	end of FreeRasters()  */


/* This function will free up the resources associated with a custom
 * screen.  It frees any custom bitmaps if necessary.
 *
 *  Arguments :
 *     screen : a pointer to the screen you would like closed and freed.
 */
void KillScreen(struct Screen *screen)
{
 register struct BitMap *bm = NULL;
 int width, height;

 /* just to make sure we aren't getting garbage */
 if(screen < (struct Screen *)100)
   return;

 while(screen->FirstWindow != NULL)  /* still got windows on this screen */
   Delay(50L);    /* wait a while for the window to go away */


 if (screen->BitMap.Depth > 2) {
   bm = (struct BitMap *)screen->ExtData;
   width = screen->Width; height = screen->Height;
  }

 CloseScreen(screen);    /* do this first. */

 if(bm != NULL)
   FreeBitMap(bm, width, height);
}


