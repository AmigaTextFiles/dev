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
 ** pixel.h - Interface to pixel.c
 **/

#ifndef _PIXEL_H
#define _PIXEL_H


#include <sipp.h>


extern Color     sipp_bgcol;

extern void      pixels_setup();
extern void      pixels_free();
extern void      pixels_reinit();
extern bool      pixel_visible();
extern int       pixel_insert();
extern Color    *pixel_collect();


#endif 
