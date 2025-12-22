/*
 *  bresenham.c
 *
 *  Autor: Norman Walter
 *  Datum: 5.4.2008
 *
 */

#ifndef BRESENHAM_H
#include "bresenham.h"
#endif

struct raster_bitmap * AllocRasterBitmap(unsigned int width, unsigned int height, ULONG PixFmt)
{
   struct raster_bitmap *bm;

   bm = (struct raster_bitmap *)AllocVec(sizeof(struct raster_bitmap),NULL);

   bm->width = width;
   bm->height = height;
   bm->PixFmt = PixFmt;

   switch (PixFmt)
   {
	case PIXFMT_RGB24:
	case PIXFMT_BGR24:
		bm->Depth = 24;
		bm->BytesPerPixel = 3;
	break;

	case PIXFMT_ARGB32:
	case PIXFMT_BGRA32:
	case PIXFMT_RGBA32:
		bm->Depth = 32;
		bm->BytesPerPixel = 4;
	break;

	default:
		bm->Depth = 8;
		bm->BytesPerPixel = 1;		
   }

   bm->BytesPerRow = bm->width * bm->BytesPerPixel;
   bm->size = bm->BytesPerRow * bm->height;
   bm->color = 1;

   // RGBA-Komponenten für die Zeichenfarbe setzen
   bm->Alpha = 0xFF;
   bm->Red = 0xFF;
   bm->Green = 0xFF;
   bm->Blue = 0xFF;

   bm->data = (UBYTE *)AllocVec(bm->size, MEMF_CLEAR);

   return bm;
}

void FreeRasterBitmap(struct raster_bitmap *bm)
{
   FreeVec(bm->data);
   FreeVec(bm);
}

void ClearRaster(struct raster_bitmap *bm)
{
   ULONG x,y;
   
   for (x=0; x < bm->width; x++)
   {
	for (y=0; y < bm->height; y++)
	{
		setpixel(bm,x,y);
	}
   }

}

void SetColor(struct raster_bitmap *bm, UBYTE col)
{
    bm->color = col;
}

void SetColorRGBA(struct raster_bitmap *bm, UBYTE r, UBYTE g, UBYTE b, UBYTE a)
{
    bm->Red = r;
    bm->Green = g;
    bm->Blue = b;
    bm->Alpha = a;
}

void setpixel(struct raster_bitmap *bm, unsigned int x, unsigned int y)
{
    ULONG pos = (bm->width * y + x) * bm->BytesPerPixel;

    if (x >= 0 && x < bm->width && y >= 0 && y < bm->height)
    {
	switch (bm->PixFmt)
	{
		case PIXFMT_RGB24:
			bm->data[pos] = bm->Red;
			bm->data[pos + 1] = bm->Green;
			bm->data[pos + 2] = bm->Blue;
		break;

		case PIXFMT_BGR24:
			bm->data[pos] = bm->Blue;
			bm->data[pos + 1] = bm->Green;
			bm->data[pos + 2] = bm->Red;
		break;

		case PIXFMT_RGBA32:
			bm->data[pos] = bm->Red;
			bm->data[pos + 1] = bm->Green;
			bm->data[pos + 2] = bm->Blue;
			bm->data[pos + 3] = bm->Alpha;
		break;

		case PIXFMT_ARGB32:
			bm->data[pos] = bm->Alpha;
			bm->data[pos + 1] = bm->Red;
			bm->data[pos + 2] = bm->Green;
			bm->data[pos + 3] = bm->Blue;
		break;

		case PIXFMT_BGRA32:
			bm->data[pos] = bm->Blue;
			bm->data[pos + 1] = bm->Green;
			bm->data[pos + 2] = bm->Red;
			bm->data[pos + 3] = bm->Alpha;
		break;

		default:
			bm->data[pos] = bm->color;
	}

    }
}

void rasterLine(struct raster_bitmap *bm,int xstart,int ystart,int xend,int yend)
{
   int x, y, t, dx, dy, incx, incy, pdx, pdy, ddx, ddy, es, el, err;
 
/* Entfernung in beiden Dimensionen berechnen */
   dx = xend - xstart;
   dy = yend - ystart;
 
/* Vorzeichen des Inkrements bestimmen */
   incx = SGN(dx);
   incy = SGN(dy);
   if(dx<0) dx = -dx;
   if(dy<0) dy = -dy;
 
/* feststellen, welche Entfernung größer ist */
   if (dx>dy)
   {
      /* x ist schnelle Richtung */
      pdx=incx; pdy=0;    /* pd. ist Parallelschritt */
      ddx=incx; ddy=incy; /* dd. ist Diagonalschritt */
      es =dy;   el =dx;   /* Fehlerschritte schnell, langsam */
   }
   else
   {
      /* y ist schnelle Richtung */
      pdx=0;    pdy=incy; /* pd. ist Parallelschritt */
      ddx=incx; ddy=incy; /* dd. ist Diagonalschritt */
      es =dx;   el =dy;   /* Fehlerschritte schnell, langsam */
   }
 
/* Initialisierungen vor Schleifenbeginn */
   x = xstart;
   y = ystart;
   err = el/2;
   setpixel(bm,x,y);
 
/* Pixel berechnen */
   for(t=0; t<el; ++t) /* t zaehlt die Pixel, el ist auch Anzahl */
   {
      /* Aktualisierung Fehlerterm */
      err -= es; 
      if(err<0)
      {
          /* Fehlerterm wieder positiv (>=0) machen */
          err += el;
          /* Schritt in langsame Richtung, Diagonalschritt */
          x += ddx;
          y += ddy;
      }
      else
      {
          /* Schritt in schnelle Richtung, Parallelschritt */
          x += pdx;
          y += pdy;
      }

      setpixel(bm,x,y);
   }
} /* gbham() */

void rasterCircle(struct raster_bitmap *bm, int x0, int y0, int radius)
{
    int f = 1 - radius;
    int ddF_x = 0;
    int ddF_y = -2 * radius;
    int x = 0;
    int y = radius;
 
    setpixel(bm, x0, y0 + radius);
    setpixel(bm, x0, y0 - radius);
    setpixel(bm, x0 + radius, y0);
    setpixel(bm, x0 - radius, y0);
 
    while(x < y) 
    {
      if(f >= 0) 
      {
        y--;
        ddF_y += 2;
        f += ddF_y;
      }
      x++;
      ddF_x += 2;
      f += ddF_x + 1;
 
      setpixel(bm, x0 + x, y0 + y);
      setpixel(bm, x0 - x, y0 + y);
      setpixel(bm, x0 + x, y0 - y);
      setpixel(bm, x0 - x, y0 - y);
      setpixel(bm, x0 + y, y0 + x);
      setpixel(bm, x0 - y, y0 + x);
      setpixel(bm, x0 + y, y0 - x);
      setpixel(bm, x0 - y, y0 - x);
    }
}
