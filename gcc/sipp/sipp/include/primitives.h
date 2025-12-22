/**
 ** sipp - SImple Polygon Processor
 **
 **  A general 3d graphic package
 **
 **  Copyright Equivalent Software HB  1992
 **
 ** This program is free software; you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation; either version 1, or any later version.
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 ** You can receive a copy of the GNU General Public License from the
 ** Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 **/

/**
 ** primitives.h - Interface to the various primitive object functions.
 **/

#ifndef PRIMITIVES_H
#define PRIMITIVES_H

#include <sipp.h>


/*
 * Types of texture coordinates.
 */
#define WORLD         0
#define CYLINDRICAL   1
#define SPHERICAL     2
#define NATURAL       3


extern Object *sipp_torus();
extern Object *sipp_cone();
extern Object *sipp_cylinder();
extern Object *sipp_ellipsoid();
extern Object *sipp_sphere();
extern Object *sipp_prism();
extern Object *sipp_block();
extern Object *sipp_cube();
extern Object *sipp_bezier_file();
extern Object *sipp_bezier_patches();
extern Object *sipp_bezier_rotcurve();


#endif /* PRIMITIVES_H */
