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
 ** sipp_pixmap.h - Interface to sipp_pixmap.c.
 **/

#ifndef SIPP_PIXMAP_H
#define SIPP_PIXMAP_H


#include <sys/types.h>

/* The generic pixel setter usable for any pixmap type. */
typedef void   (*Pixmap_set_pixel_func)();


/* The SIPP pixmap and its associated functions. */

typedef struct {
    int       width;
    int       height;
    u_char  * buffer;
} Sipp_pixmap;


extern Sipp_pixmap  * sipp_pixmap_create();
extern void           sipp_pixmap_destruct();
extern void           sipp_pixmap_set_pixel();
extern void           sipp_pixmap_write();


#endif /* SIPP_PIXMAP_H */
