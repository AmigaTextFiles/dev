
/*
 *  Y = LineIntX(x0,y0,dx,dy) at x = 0  dx must be non-zero
 *  X = LineIntY(x0,y0,dx,dy) at y = 0  dy must be non-zero
 */

#ifndef MATHLIB_H
#define MATHLIB_H

#define LineIntXAxis(x0,y0,dx,dy) ((y0) - MulDiv(x0,dy,dx))
#define LineIntYAxis(x0,y0,dx,dy) ((x0) - MulDiv(y0,dx,dy))
#define SwapInt(i0,i1)  { register long tmp = i0; i0 = i1; i1 = tmp; }

typedef struct {
    long x0;
    long y0;
    long x1;
    long y1;
} B2;

typedef struct {
    long x;
    long y;
} C2;

#endif
