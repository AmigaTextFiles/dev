/*  Polygon.h
 *  Definitionsmodul
 */

#ifndef FILLEDPOLYGON_H
#define FILLEDPOLYGON_H

#ifndef POLAR_H
#include "Polar.h"
#endif

#include "bresenham.h"

// Funktionsprototypen:

void ZeichnePolygon(struct raster_bitmap *bm, int n, double r, int xc, int yc);

#endif
