/*  Polygon.c
 *
 *  Implementierungsmodul
 *
 */

#ifndef POLYGON_H
#include "Polygon.h"
#endif

#include "bresenham.h"

/*   Zeichnet im RastPort rp ein regelm‰ﬂiges n-Eck
 *   mit Radius r und dem Mittelpunkt (xc/yc)
 */
void ZeichnePolygon(struct raster_bitmap *bm, int n, double r, int xc, int yc)
{
   double phi,xd,yd,alpha,beta;
   int x0,y0,x1,y1;

   alpha=360.0/(double)n; // Winkel

   for (phi=0.0;phi<360.0;phi+=alpha)
   {
      PolarKart(r,DEG2RAD(phi),xd,yd);
      x0=(int)xd+xc;
      y0=(int)yd+yc;

      beta=phi+alpha;

      PolarKart(r,DEG2RAD(beta),xd,yd);
      x1=(int)xd+xc;
      y1=(int)yd+yc;

      rasterLine(bm,x0,y0,x1,y1);
   }

}
