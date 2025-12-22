;/*
sc Bitmap.c LINK
quit
*/

/* This example shows ReAction's bitmap.image
 */

#include <dos/dos.h>
#include <reaction/reaction.h>
#include <reaction/reaction_macros.h>

#include <images/bitmap.h>
#include <gadgets/layout.h>
#include <classes/window.h>

#include <proto/intuition.h>

#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <clib/intuition_protos.h>

#include <proto/bitmap.h>
#include <proto/button.h>
#include <proto/layout.h>
#include <proto/window.h>

struct Library *BitMapBase,
               *ButtonBase,
               *LayoutBase,
               *WindowBase;

static struct Image *image;
static struct Screen *screen;
static struct Gadget *gadget;

int main( void )
{  Object *Win_Object;
   struct Window *window;
   struct Image *image1=NULL,*image2=NULL,*image3=NULL;
   struct BitMap *bitmap;
   ULONG result,signal;
   BOOL done=FALSE;

   /* Open the classes we will use. Note, reaction.lib SAS/C or DICE autoinit
    * can do this for you automatically.
    */
   if ((WindowBase = OpenLibrary("window.class",          0L))
   &&  (LayoutBase = OpenLibrary("gadgets/layout.gadget", 0L))
   &&  (ButtonBase = OpenLibrary("gadgets/button.gadget", 0L))
   &&  (BitMapBase = OpenLibrary("images/bitmap.image",   0L))
   )
   {
      if(screen=LockPubScreen(NULL))
      {  
         /* Make an image out of an IFF file.
          * The image will be included in the window layout, and is
          * used to clip two other images from
          */
         image1=BitMapObject,
            BITMAP_SourceFile,"PROGDIR:buttons.iff",
            BITMAP_Screen,screen,
         EndImage;

         if(image1)
         {  
            /* Get the bitmap of the image
             */
            GetAttr(BITMAP_BitMap,image1,(ULONG *)&bitmap);

            Win_Object = WindowObject,
               WA_ScreenTitle, "ReAction",
               WA_Title, "ReAction Bitmap Example",
               WA_SizeGadget, TRUE,
               WA_Left, 40,
               WA_Top, 30,
               WA_InnerWidth,100,
               WA_DepthGadget, TRUE,
               WA_DragBar, TRUE,
               WA_CloseGadget, TRUE,
               WA_Activate, TRUE,
               WA_PubScreen,screen,
               WINDOW_ParentGroup, VGroupObject,
                  LAYOUT_SpaceOuter, TRUE,
                  LAYOUT_HorizAlignment,LALIGN_CENTER,
                  
                  StartImage,image1,
                  CHILD_NoDispose,TRUE,

                  LAYOUT_AddChild, HLayoutObject,
                     StartMember, ButtonObject,
                        GA_Image, image2 = BitMapObject,
                           BITMAP_BitMap,        bitmap,
                           BITMAP_OffsetX,       2,
                           BITMAP_OffsetY,       2,
                           BITMAP_Width,         21,
                           BITMAP_Height,        15,
                           BITMAP_SelectBitMap,  bitmap,
                           BITMAP_SelectOffsetX, 25,
                           BITMAP_SelectOffsetY, 2,
                           BITMAP_SelectWidth,   21,
                           BITMAP_SelectHeight,  15,
                        EndImage,
                     EndMember,
                     CHILD_WeightedWidth,        0,
                     CHILD_WeightedHeight,       0,
                     StartMember, ButtonObject,
                        GA_Image, image3 = BitMapObject,
                           BITMAP_BitMap,        bitmap,
                           BITMAP_OffsetX,       48,
                           BITMAP_OffsetY,       2,
                           BITMAP_Width,         21,
                           BITMAP_Height,        15,
                           BITMAP_SelectBitMap,  bitmap,
                           BITMAP_SelectOffsetX, 71,
                           BITMAP_SelectOffsetY, 2,
                           BITMAP_SelectWidth,   21,
                           BITMAP_SelectHeight,  15,
                        EndImage,
                     EndMember,
                     CHILD_WeightedWidth,        0,
                     CHILD_WeightedHeight,       0,
                  LayoutEnd,
               EndMember,
            EndWindow;
             /*  Object creation sucessful?
             */
            if( Win_Object )
            {
               /*  Open the window.
                */
               if( window = (struct Window *) RA_OpenWindow(Win_Object) )
               {
                  ULONG wait;
               
                  /* Obtain the window wait signal mask.
                   */
                  GetAttr( WINDOW_SigMask, Win_Object, &signal );
                   /* Input Event Loop
                   */
                  while( !done )
                  {
                     wait = Wait(signal|SIGBREAKF_CTRL_C);

                     if (wait & SIGBREAKF_CTRL_C) done = TRUE;
                     else
                      while ((result = RA_HandleInput(Win_Object,NULL)) != WMHI_LASTMSG)
                     {
                        switch(result)
                        {
                           case WMHI_CLOSEWINDOW:
                              done = TRUE;
                              break;
                        }
                     }
                  }
               }
                /* Disposing of the window object will
                * also close the window if it is
                * already opened and it will dispose of
                * all objects attached to it.
                */
               DisposeObject( Win_Object );
            }
            
            /* Dispose the images ourselves as button.gadget doesn't
             * do this for its GA_Image...
             */
            if(image2) DisposeObject(image2);
            if(image3) DisposeObject(image3);
            if(image1) DisposeObject(image1);
            
         }

         UnlockPubScreen(NULL,screen);
      }
   }

   /* Close the classes.
    */
   if (BitMapBase) CloseLibrary( (struct Library *)BitMapBase );
   if (ButtonBase) CloseLibrary( (struct Library *)ButtonBase );
   if (LayoutBase) CloseLibrary( (struct Library *)LayoutBase );
   if (WindowBase) CloseLibrary( (struct Library *)WindowBase );
   
}

