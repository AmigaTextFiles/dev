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
 ** sipp.h - Public inteface to the sipp rendering library.
 **/


#ifndef _SIPP_H
#define _SIPP_H

#include <geometric.h>


#ifndef M_PI
#define M_PI 3.1415926535897932384626
#endif

#ifndef FALSE
typedef int bool;
#define FALSE  0
#define TRUE   1
#endif 

/*
 * Customize for those that don't have memcpy() and friends, but
 * have bcopy() instead.
 */

#ifdef NOMEMCPY
#define memcpy(to, from, n) bcopy((from), (to), (n))
#endif


/*
 * The macro RANDOM() should return a random number
 * in the range [-1, 1].
 */
#include <stdlib.h>
#include <machine/limits.h>
#define RANDOM()  (2.0 * ((float)random())/((float)LONG_MAX) - 1.0)


/*
 * Modes for rendering
 */
#define PHONG      0
#define GOURAUD    1
#define FLAT       2
#define LINE       3


/*
 * Field definition.
 */
#define EVEN   0
#define ODD    1
#define BOTH   2


/*
 * Types of lightsources.
 */
#define LIGHT_DIRECTION    0
#define LIGHT_POINT        1

/*
 * Types of spotlights (actually lightsource types too).
 */
#define SPOT_SHARP   2
#define SPOT_SOFT    3


/*
 * Interface to shader functions.
 */
typedef void Shader();


/*
 * Colors are handled as an rgb-triple
 * with values between 0 and 1.
 */
typedef struct {
    double   red;
    double   grn;
    double   blu;
} Color;


/*
 * Structure storing the vertices in surfaces. The vertices for a
 * surface are stored in a binary tree sorted first on x, then y and last z.
 */
typedef struct vertex_t {
    Vector            pos;    /* vertex position */
    Vector            normal;    /* average normal at vertex */
    Vector            texture;    /* texture parameters (if any) */
    struct vertex_t  *big, *sml;  /* pointers to children in the tree */
} Vertex;


/*
 * Polygon definition. A polygon is defined by a list of
 * references to its vertices (counterclockwize order).
 */
typedef struct polygon_t {
    int         nvertices;
    Vertex    **vertex;
    bool        backface;   /* polygon is backfacing (used at rendering) */
    struct polygon_t *next;
} Polygon;


/*
 * Surface definition. Each surface consists of a vertex tree, 
 * a polygon list, a pointer to a surface description and a pointer
 * to a shader function.
 */
typedef struct surface_t {
    Vertex           *vertices;          /* vertex tree */
    Polygon          *polygons;          /* polygon list */
    void             *surface;           /* surface description */
    Shader           *shader;            /* shader function */
/*    Vector            max, min;          / * Bounding box (Future use) */
    int               ref_count;         /* no of references to this surface */
    struct surface_t *next;              /* next surface in the list */
} Surface;


/*
 * Object definition. Object consists of one or more
 * surfaces and/or one or more subojects. Each object
 * has its own transformation matrix that affects itself
 * and all its subobjects.
 */
typedef struct object_t {
    Surface         *surfaces;       /* List of surfaces */
    struct object_t *sub_obj;        /* List of subobjects */
    Transf_mat       transf;         /* Transformation matrix */
    int              ref_count;      /* No of references to this object */
    struct object_t *next;           /* Next object in this list */
} Object;



/*
 * Information needed in a lightsource to generate
 * shadows.
 */
typedef struct {
    Transf_mat  matrix;
    double      fov_factor;
    double      bias;
    bool        active;
    float      *d_map;
} Shadow_info;


/*
 * Public part of lightsource definition.
 * Used for both normal lightsources and spotlights.
 */
typedef struct lightsource_t {
    Color                 color;      /* Color of the lightsource */
    bool                  active;     /* Is the light on? */
    int                   type;       /* Type of lightsource */
    void                 *info;       /* Type dependent info */
    Shadow_info           shadow;     /* Shadow information */
    struct lightsource_t *next;       /* next lightsource in the list */
} Lightsource;


/*
 * Virtual camera definition
 */
typedef struct {
    Vector position;     /* camera position */
    Vector lookat;       /* point to look at */
    Vector up;           /* Up direction in the view */ 
    double focal_ratio;
} Camera;


/*
 * Surface description used by the basic shader. This shader
 * does simple shading of surfaces of a single color.
 */
typedef struct {
    double  ambient;       /* Fraction of color visible in ambient light */
    double  specular;      /* Fraction of colour specularly reflected */
    double  c3;            /* "Shinyness" 0 = shiny,  1 = dull */
    Color   color;         /* Colour of the surface */
    Color   opacity;       /* Opacity of the surface */
} Surf_desc;


extern char  * SIPP_VERSION;


/*
 * The world that is rendered. Defined in objects.c
 */
extern Object  *sipp_world;


/*
 * The internal (default) camera.
 */
extern Camera  *sipp_camera;


/*
 * This defines all public functions implemented in sipp.
 */

/* Global initialization and configuration functions. */
extern void          sipp_init();
extern void          sipp_show_backfaces();
extern void          sipp_shadows();
extern void          sipp_background();

/* Functions for handling surfaces and objects. */
extern void          vertex_push();
extern void          vertex_tx_push();
extern void          polygon_push();
extern Surface      *surface_create();
extern Surface      *surface_basic_create();
extern void          surface_set_shader();
extern void          surface_basic_shader();
extern Object       *object_create();
extern Object       *object_instance();
extern Object       *object_dup();
extern Object       *object_deep_dup();
extern void          object_delete();
extern void          object_add_surface();
extern void          object_sub_surface();
extern void          object_add_subobj();
extern void          object_sub_subobj();

/* Functions for handling transforming objects. */
extern void          object_set_transf();
extern Transf_mat   *object_get_transf();
extern void          object_clear_transf();
extern void          object_transform();
extern void          object_rot_x();
extern void          object_rot_y();
extern void          object_rot_z();
extern void          object_rot();
extern void          object_scale();
extern void          object_move();

/* Functions for handling lightsources and spotlights. */
extern Lightsource  *lightsource_create();
extern Lightsource  *spotlight_create();
extern void          light_destruct();
extern void          lightsource_put();
extern void          spotlight_pos();
extern void          spotlight_at();
extern void          spotlight_opening();
extern void          spotlight_shadows();
extern void          light_color();
extern void          light_active();
extern double        light_eval();

/* Functions for handling the viewpoint and virtual cameras. */
extern Camera       *camera_create();
extern void          camera_destruct();
extern void          camera_pos();
extern void          camera_at();
extern void          camera_up();
extern void          camera_focal();
extern void          camera_params();
extern void          camera_use();

/* Functions to render an image. */
extern void          render_image_file();
extern void          render_image_func();
extern void          render_field_file();
extern void          render_field_func();

/* The basic shader. */
extern void          basic_shader();


/*
 * The following macros are provided for backward compatibility.
 * We plan to remove them from future releases though,
 * so we don't encourage use of them.
 */
#define object_install(obj)    object_add_subobj(sipp_world, obj);
#define object_uninstall(obj)  object_sub_subobj(sipp_world, obj);
#define view_from(x, y, z)     camera_position(sipp_camera, x, y, z)
#define view_at(x, y, z)       camera_look_at(sipp_camera, x, y, z)
#define view_up(x, y, z)       camera_up(sipp_camera, x, y, z)
#define view_focal(fr)         camera_focal(sipp_camera, fr)
#define viewpoint(x, y, z, x2, y2, z2, ux, uy, uz, fr)\
    camera_params(sipp_camera, x, y, z, x2, y2, z2, ux, uy, uz, fr)
#define lightsource_push(x, y, z, i) \
    lightsource_create(x, y, z, i, i, i, LIGHT_DIRECTION)
#define render_image_pixmap(w, h, p, f, m, o) \
    render_image_func(w, h, f, p, m, o)

#endif /* _SIPP_H */
