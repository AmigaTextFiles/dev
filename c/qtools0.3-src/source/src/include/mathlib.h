/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Library General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#ifndef MATHLIB_H
#define MATHLIB_H
/* mathlib.h */
#ifdef	HAVE_MATH_H
# include <math.h>
#endif

#if defined(HAVE_SCALW) || defined(HAVE_SCALB)
#ifndef __HAVE_68881__
#undef	HAVE_SCALB
#undef	HAVE_SCALW
#endif
#endif

#ifndef	HAVE_SCALW
#ifdef	HAVE_SCALB
#define	scalw(x, y)	scalb((x), (y))
#else
#define	scalw(x, y)	(((y) >= 0) ? ((x) * (1 << (y))) : ((x) / (1 << (-(y)))))
#endif
#endif

#ifndef	VEC_IS_DOUBLE
# define	VEC_PREC	float
# define	VEC_CONV1D	"%g"
# define	VEC_CONV3D	"%g %g %g"
# define	VEC_POSMAX	FLT_MAX
# define	VEC_POSMIN	FLT_MIN
# define	VEC_NEGMAX	-FLT_MAX
# define	VEC_NEGMIN	-FLT_MIN
#else
# define	VEC_PREC	double
# define	VEC_CONV1D	"%lg"
# define	VEC_CONV3D	"%lg %lg %lg"
# define	VEC_POSMAX	DBL_MAX
# define	VEC_POSMIN	DBL_MIN
# define	VEC_NEGMAX	-DBL_MAX
# define	VEC_NEGMIN	-DBL_MIN
#endif

typedef VEC_PREC vec1D;
typedef vec1D	 vec3D[3];

#define	VecZero(vec)						\
  (sizeof(          int) == sizeof(VEC_PREC) ?			\
	((          int *)vec) :				\
   sizeof(     long int) == sizeof(VEC_PREC) ?			\
	((     long int *)vec) :				\
   sizeof(long long int) == sizeof(VEC_PREC) ?			\
	((long long int *)vec) :				\
	(		  vec))

#define	VecEqual(ve1, ve2)					\
  (sizeof(          int) == sizeof(VEC_PREC) ?			\
	((          int *)ve1) == ((          int *)ve2) :	\
   sizeof(     long int) == sizeof(VEC_PREC) ?			\
	((     long int *)ve1) == ((     long int *)ve2) :	\
   sizeof(long long int) == sizeof(VEC_PREC) ?			\
	((long long int *)ve1) == ((long long int *)ve2) :	\
	(                 ve1) == (                 ve2))

#define	SIDE_FRONT		 0
#define	SIDE_BACK		 1
#define	SIDE_ON			 2
#define	SIDE_CROSS		-2

#define	Q_PI	3.14159265358979323846

#define	EQUAL_EPSILON	0.001

#define VectorCompare(v1, v2)		(((v1[0] != v2[0]) || (v1[1] != v2[1]) || (v1[2] != v2[2])) ? FALSE : TRUE)
#define VectorZero(v1)			((v1[0] == 0) && (v1[1] == 0) && (v1[2] == 0))

#define DotProduct(x, y)		(x[0] * y[0] + x[1] * y[1] + x[2] * y[2])
#define VectorSubtract(a, b, c)		{c[0] = a[0] - b[0]; c[1] = a[1] - b[1]; c[2] = a[2] - b[2];}
#define VectorAdd(a, b, c)		{c[0] = a[0] + b[0]; c[1] = a[1] + b[1]; c[2] = a[2] + b[2];}
#define VectorScale(in, scale, out)	{out[0] = in[0] * scale; out[1] = in[1] * scale; out[2] = in[2] * scale;}
#define VectorCopy(a, b)		{b[0] = a[0]; b[1] = a[1]; b[2] = a[2];}
#define VectorClear(x)			{x[0] = x[1] = x[2] = 0;}
#define	VectorNegate(x)			{x[0] = -x[0]; x[1] = -x[1]; x[2] = -x[2];}
#define	VectorNegateTo(x, y)		{y[0] = -x[0]; y[1] = -x[1]; y[2] = -x[2];}
#define	VectorAbs(x)			{x[0] = fabs(x[0]); x[1] = fabs(x[1]); x[2] = fabs(x[2]);}

#define _DotProduct			DotProduct
#define _VectorSubtract			VectorSubtract
#define _VectorAdd			VectorAdd
#define _VectorCopy			VectorCopy
#define VectorInverse			VectorNegate

#define VectorDist(v)			(v[0] * v[0] + v[1] * v[1] + v[2] * v[2])
#define VectorLength(v)			(sqrt(VectorDist(v)))

void VectorMA(vec3D veca, double scale, vec3D vecb, vec3D vecc);
void CrossProduct(vec3D v1, vec3D v2, vec3D cross);
vec1D VectorNormalize(vec3D v);

extern inline void VectorMA(vec3D veca, double scale, vec3D vecb, vec3D vecc)
#ifndef	PROFILE
{
  vecc[0] = veca[0] + scale * vecb[0];
  vecc[1] = veca[1] + scale * vecb[1];
  vecc[2] = veca[2] + scale * vecb[2];
}
#endif
;

extern inline void CrossProduct(vec3D v1, vec3D v2, vec3D cross)
#ifndef	PROFILE
{
  cross[0] = v1[1] * v2[2] - v1[2] * v2[1];
  cross[1] = v1[2] * v2[0] - v1[0] * v2[2];
  cross[2] = v1[0] * v2[1] - v1[1] * v2[0];
}
#endif
;

extern inline vec1D VectorNormalize(vec3D v)
#ifndef	PROFILE
{
  vec1D len;

  if ((len = VectorLength(v))) {
    v[0] /= len;
    v[1] /= len;
    v[2] /= len;
  }
  return len;
}
#endif
;

#endif
