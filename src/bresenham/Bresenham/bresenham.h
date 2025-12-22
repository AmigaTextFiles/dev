/*
 *  bresenham.h
 *
 *  Grafikfunktionen zum Zeichnen von Linien und Keisen mit Hilfe des
 *  Bresenham Algorithmus.
 *
 *  Autor: Norman Walter
 *  Datum: 30.3.2008
 *
 */

#ifndef BRESENHAM_H
#define BRESENHAM_H

#include <exec/types.h>

#include <proto/exec.h>

#define SGN(x) (x > 0) ? 1 : (x < 0) ? -1 : 0

/*
 *  struct raster_bitmap
 *
 *  In dieser Struktur sind die Parameter für das Bitmap zusammengefasst.
 *  Nachdem mit Hilfe der Funktion AllocRasterBitmap eine Instanz dieser Struktur
 *  erzeugt wurde, zeigt der Zeiger *data auf den Speicherbereich, in dem das
 *  eigentliche Bitmap mit der Größe size Byte liegt.
 *
 *  Die Funktionen ClearRaster, setpixel, rasterLine und rasterCircle schreiben
 *  ihre Daten in diesen Speicherbereich. Der Zeiger *date kann anschließend
 *  mit Hilfe der Funktion WritePixelArray8 aus der graphics.library in einen
 *  RastPort geschrieben werden.
 *
 */
struct raster_bitmap
{
  unsigned int width;   // Breite des Bitmaps
  unsigned int height;  // Höhe des Bitmaps
  UBYTE color;          // Aktuelle Pen Nummer
  ULONG size;           // Größe des bitmapy in Byte
  UBYTE *data;          // Bilddaten des Bitmaps
};

/*
 *  AllocRaster
 *
 *  Legt eine raster_bitmap-Struktur an und initialisiert diese
 *
 *  Eingabe:	 unsigned int width  - Breite des Bitmaps in Pixel
 *           	 unsigned int height - Höhe des Bitmaps in Pixel
 *
 *  Rückgabe:    ein Zeiger auf eine raster_bitmap Struktur
 *
 */
struct raster_bitmap * AllocRasterBitmap(unsigned int width, unsigned int height);

/*
 *  FreeRasterBitmap
 *
 *  Gibt den Speicher einer raster_bitmap Struktur wieder frei.
 *
 *  Einganbe:	struct raster_bitmap *bm - Zeiger auf raster_bitmap Struktur
 *
 */
void FreeRasterBitmap(struct raster_bitmap *bm);

/*
 *  rasterLine
 *
 *  Zeichnet eine Linie von xstart, ystart nach xend, yend in der angegebenen
 *  raster_bitmap Struktur bm.
 *
 *  Eingabe:	struct raster_bitmap *bm - Zeiger auf raster_bitmal Struktur
 *		int xstart,ystart - Koordinaten des Anfangspunkts der Linie
 *              int xend, yend - Koordinaten des Endpunkts der Linie
 *
 */
void rasterLine(struct raster_bitmap *bm,int xstart,int ystart,int xend,int yend);

/*
 *  ClearRaster
 *
 *  Löscht den Inhalt des raster_bitmap bm mit der Farbe col.
 *
 *  Eingabe:	struct raster_bitmap *bm - Zeiger auf raster_bitmal Struktur
 *		UBYTE col - Pen Nr.
 *
 */
void ClearRaster(struct raster_bitmap *bm,UBYTE col);

/*
 *  SetColor
 *
 *  Stellt die Zeichenfarbe des raster_bitmap für Zeichenoperationen ein.
 *
 *  Eingabe:	struct raster_bitmap *bm - Zeiger auf raster_bitmal Struktur
 *		UBYTE col - Pen Nr.
 *
 */
void SetColor(struct raster_bitmap *bm, UBYTE col);

/*
 *  setpixel
 *
 *  Setzt den Bildpunkt x,y in der Farbe des eingestellten Pens.
 *
 *  Eingabe:	struct raster_bitmap *bm - Zeiger auf raster_bitmal Struktur
 *		unsigned int x,y - Koordinaten des Bildpunkts
 *
 */
void setpixel(struct raster_bitmap *bm, unsigned int  x, unsigned int y);

/*
 *  rasterCircle
 *
 *  Zeichnet einen Kreis mit Radius radius um den Kreismittelpunkt x0,y0.
 *
 *  Eingabe:	struct raster_bitmap *bm - Zeiger auf raster_bitmal Struktur
 *		int y0,y0 - Koordinaten des Kreismittelpunks.
 *              int radius - Radius des Kreises
 *
 */
void rasterCircle(struct raster_bitmap *bm, int x0, int y0, int radius);

#endif
