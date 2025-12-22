/*
 * MAGIC Image Tester - does a negative effect on default public image.
 *
 * Written by Thomas Krehbiel
 *
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <libraries/dos.h>
#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <clib/dos_protos.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include <magic/magic.h>
#include <magic/magic_protos.h>
#include <magic/magic_pragmas.h>


struct MagicBase *MagicBase;


void __regargs negative (UBYTE *s, int n)
{
   while (n--) {
      *s = 255 - *s;
      s++;
   }
}

void main (void)
{
   struct MagicHandle *mh;
   UBYTE *data;
   int w, h, d;
   int j;

   /*
    * Open the magic.library.
    */
   if (MagicBase = (struct MagicBase *)OpenLibrary(MAGIC_NAME, 34)) {

      /*
       * Open the default MAGIC image.  We don't need to provide a
       * message port since we won't be around long enough to worry
       * about it, and most of the messages are for applications with
       * interfaces.
       */
      if (mh = OpenMagicImage(NULL, NULL, TAG_END)) {
         w = mh->Object->Width;
         h = mh->Object->Height;
         d = mh->Object->Depth;
         if (data = AllocMem(w, MEMF_CLEAR)) {
            /*
             * Obtain a write lock on the image before starting
             */
            if (AttemptLockMagicImage(mh, LMI_Write)) {
               /*
                * Save a copy as an undo buffer in case the user changes
                * his mind.
                */
               SaveMagicImage(mh, 0, 0, w, h);
               /*
                * Convert the image, a line at a time.
                */
               for (j = 0; j < h; j++) {
                  if (GetMagicImageData(mh, j, 1, GMI_Red, data, TAG_END)) {
                     negative(data, w);
                     PutMagicImageData(mh, j, 1, GMI_Red, data, TAG_END);
                  }
                  if (d > 1) {
                     if (GetMagicImageData(mh, j, 1, GMI_Green, data, TAG_END)) {
                        negative(data, w);
                        PutMagicImageData(mh, j, 1, GMI_Green, data, TAG_END);
                     }
                     if (GetMagicImageData(mh, j, 1, GMI_Blue, data, TAG_END)) {
                        negative(data, w);
                        PutMagicImageData(mh, j, 1, GMI_Blue, data, TAG_END);
                     }
                  }
               }
               /*
                * Redraw so the user can see what happened.
                */
               RedrawMagicImage(mh, 0, 0, w, h);
               /*
                * Release our lock.
                */
               UnlockMagicImage(mh);
            }
            else {
               printf("Default Image is locked.\n");
            }
            FreeMem(data, w);
         }
         CloseMagicImage(mh);
      }

      CloseLibrary((struct Library *)MagicBase);
   }
   else {
      printf("Magic server not running.\n");
   }
}
