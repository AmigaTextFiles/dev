
#include <stdlib.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include <proto/graphics.h>

#include "bresenham.h"
#include "Polygon.h"

#define BMWIDTH 320
#define BMHEIGHT 256

// Funktion zum Zeichnen des Sierpinski-Fraktals
void DrawSierpinski(struct raster_bitmap *bm)
{
	int iterate;
   SHORT x1, y1, x2, y2;

   x1 = x2 = bm->width/2;
   y1 = y2 = 0;

   // Schleife zum Iterieren und Zeichnen der Pixel
   for(iterate = 0; iterate < 10000; iterate++)
   {
      // Zufallswerte erzeugen/
      switch (rand()%3)
      {
         case 0: x1 = (x2 + bm->width/2) / 2;
                 y1 = y2 / 2;
         break;

         case 1: x1 = x2 / 2;
                 y1 = (y2 + bm->height) / 2;
         break;

         case 2: x1 = (x2 + bm->width) / 2;
                 y1 = (y2 + bm->height) / 2;
         break;
      }

      setpixel(bm, x1, y1);

      x2 = x1;
      y2 = y1;
   }

}

int main (void)
{
	struct Window *win;
	struct Message *msg;
	struct RastPort temprp;

	int i;

	struct raster_bitmap *bm;

	bm = AllocRasterBitmap(BMWIDTH,BMHEIGHT);

	if (win = OpenWindowTags (NULL,
		WA_Title,"Bresenham",
		WA_InnerWidth,BMWIDTH + 20,
		WA_InnerHeight,BMHEIGHT + 20,
		WA_Flags,WFLG_CLOSEGADGET|WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_ACTIVATE,
		WA_IDCMP,IDCMP_CLOSEWINDOW|IDCMP_MOUSEBUTTONS|IDCMP_VANILLAKEY,
		TAG_END))
	{

	temprp = *win->RPort;
	temprp.Layer = NULL;

	if (temprp.BitMap = AllocBitMap (BMWIDTH,1,8,0,NULL))
	{
		for (i=1; i<=64; i++)
		{

			ClearRaster(bm,i%16);

			WritePixelArray8 (win->RPort,win->BorderLeft + 10,win->BorderTop + 10,
				win->BorderLeft + BMWIDTH + 9,win->BorderTop + BMHEIGHT + 9,bm->data,&temprp);
		}

		SetColor(bm,2);
	   DrawSierpinski(bm);

		WritePixelArray8 (win->RPort,win->BorderLeft + 10,win->BorderTop + 10,
			win->BorderLeft + BMWIDTH + 9,win->BorderTop + BMHEIGHT + 9,bm->data,&temprp);

		Delay(250);

		ClearRaster(bm,2);

      SetColor(bm,1);
		ZeichnePolygon(bm,3,40,160,128);
		ZeichnePolygon(bm,4,60,160,128);
		ZeichnePolygon(bm,5,80,160,128);
		ZeichnePolygon(bm,6,100,160,128);
		ZeichnePolygon(bm,7,120,160,128);
		ZeichnePolygon(bm,8,140,160,128);

		WritePixelArray8 (win->RPort,win->BorderLeft + 10,win->BorderTop + 10,
			win->BorderLeft + BMWIDTH + 9,win->BorderTop + BMHEIGHT + 9,bm->data,&temprp);

		Delay(250);
      ClearRaster(bm,2);

		for (i=2; i<=160; i+=2)
		{
		   SetColor(bm,i%16);
			rasterCircle(bm,160,128,i);
		}

		WritePixelArray8 (win->RPort,win->BorderLeft + 10,win->BorderTop + 10,
			win->BorderLeft + BMWIDTH + 9,win->BorderTop + BMHEIGHT + 9,bm->data,&temprp);

		FreeBitMap (temprp.BitMap);
	}

	WaitPort (win->UserPort);

	while (msg = GetMsg (win->UserPort))
		ReplyMsg (msg);

	CloseWindow (win);

	FreeRasterBitmap(bm);

	}

return (0);
}

