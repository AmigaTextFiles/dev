/*
 * Bresehnah_Demo
 *
 * Demoprogramm für Bresenham-Algorithmus
 *
 * Autor: Norman Walter
 * Datum: 5.4.2008
 *
 */

#include <stdlib.h>

#include <pragma/cybergraphics_lib.h>

#include <cybergraphx/cybergraphics.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include <proto/graphics.h>

#include "bresenham.h"
#include "Polygon.h"

#define BMWIDTH 256
#define BMHEIGHT 256

struct Library *CyberGfxBase;

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

	int i;
	ULONG x,y;

	struct raster_bitmap *bm24;

   CyberGfxBase = OpenLibrary(CYBERGFXNAME,41L);

	bm24 = AllocRasterBitmap(BMWIDTH,BMHEIGHT,PIXFMT_RGB24);

	if (win = OpenWindowTags (NULL,
		WA_Title,"Bresenham",
		WA_InnerWidth,BMWIDTH,
		WA_InnerHeight,BMHEIGHT,
		WA_Flags,WFLG_CLOSEGADGET|WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_ACTIVATE,
		WA_IDCMP,IDCMP_CLOSEWINDOW|IDCMP_MOUSEBUTTONS|IDCMP_VANILLAKEY,
		TAG_END))
	{

	SetColorRGBA(bm24,0xFF,0xFF,0xFF,0xFF);
	DrawSierpinski(bm24);

	WritePixelArray(bm24->data, 0, 0,
						 bm24->BytesPerRow,
						 win->RPort,
						 win->BorderLeft,
						 win->BorderTop,
						 BMWIDTH,BMHEIGHT,
						 RECTFMT_RGB);

	Delay(250);

		for (i=0; i<256; i+=32)
		{
			SetColorRGBA(bm24,i%128,i%64,i,0xFF);
			ClearRaster(bm24);

	WritePixelArray(bm24->data, 0, 0,
						 bm24->BytesPerRow,
						 win->RPort,
						 win->BorderLeft,
						 win->BorderTop,
						 BMWIDTH,BMHEIGHT,
						 RECTFMT_RGB);
		}

			SetColorRGBA(bm24,0,0,0,0xFF);
			ClearRaster(bm24);

      SetColorRGBA(bm24,0xFF,0x00,0x00,0xFF);
		ZeichnePolygon(bm24,3,40,128,128);
		SetColorRGBA(bm24,0x00,0xFF,0x00,0xFF);
		ZeichnePolygon(bm24,4,60,128,128);
		SetColorRGBA(bm24,0xFF,0x00,0xFF,0xFF);;
		ZeichnePolygon(bm24,5,80,128,128);
		SetColorRGBA(bm24,0xFF,0xFF,0x00,0xFF);
		ZeichnePolygon(bm24,6,100,128,128);
		SetColorRGBA(bm24,0x00,0xFF,0xFF,0xFF);
		ZeichnePolygon(bm24,7,120,128,128);
		SetColorRGBA(bm24,0x00,0x55,0xFF,0xFF);
		ZeichnePolygon(bm24,8,140,128,128);

	WritePixelArray(bm24->data, 0, 0,
						 bm24->BytesPerRow,
						 win->RPort,
						 win->BorderLeft,
						 win->BorderTop,
						 BMWIDTH,BMHEIGHT,
						 RECTFMT_RGB);

		Delay(250);

		SetColorRGBA(bm24,0xFF,0xFF,0xFF,0xFF);
      ClearRaster(bm24);

		for (y=0; y < bm24->height; y++)
		{
			for (x=0; x < bm24->width; x++)
			{
				SetColorRGBA(bm24,(UBYTE)x,(UBYTE)y,0,0xFF);
				setpixel(bm24,x,y);
			}
		}

	WritePixelArray(bm24->data, 0, 0,
						 bm24->BytesPerRow,
						 win->RPort,
						 win->BorderLeft,
						 win->BorderTop,
						 BMWIDTH,BMHEIGHT,
						 RECTFMT_RGB);


		Delay(250);

		SetColorRGBA(bm24,0xFF,0xFF,0xFF,0xFF);
      ClearRaster(bm24);

		for (i=2; i<=160; i+=4)
		{
		   SetColorRGBA(bm24,i,i,0,0xFF);
			rasterCircle(bm24,bm24->width/2,bm24->height/2,i);
		}

	WritePixelArray(bm24->data, 0, 0,
						 bm24->BytesPerRow,
						 win->RPort,
						 win->BorderLeft,
						 win->BorderTop,
						 BMWIDTH,BMHEIGHT,
						 RECTFMT_RGB);

	WaitPort (win->UserPort);

	while (msg = GetMsg (win->UserPort))
		ReplyMsg (msg);

	CloseWindow (win);

	FreeRasterBitmap(bm24);

	if (CyberGfxBase != NULL)
	{
		CloseLibrary(CyberGfxBase);
	}

	}

return (0);
}

