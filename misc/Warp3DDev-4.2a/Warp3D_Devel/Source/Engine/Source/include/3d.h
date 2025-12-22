#ifndef __3D_H
#define __3D_H

#include <math.h>
#include <vecmat.h>
#include <def.h>
#include <exec/types.h>

/*
** Contains typedef's for the 3D data structures
*/

typedef struct {
	vm_vector vec;      // Vector after translation/rotation
	float sx,sy;        // Projected screen coordinates
	float tu,tv;        // Temporary u/v values for clipping
	vm_vector tcolor;   // Temporary color vector for clipping
	UBYTE ccodes;       // Clipping codes
} vertex;

#define CC_OFF_LEFT     0x001
#define CC_OFF_RIGHT    0x002
#define CC_OFF_TOP      0x004
#define CC_OFF_BOT      0x008
#define CC_BEHIND       0x010

typedef struct {
	short type;
	int numedges;
	int points[MAX_EDGES];
	int normal;
	union {
		vm_vector color;
		struct {
			int texture;
			float u[MAX_EDGES];
			float v[MAX_EDGES];
		} texinfo;
	} render;
} surface;

enum {POLYTYPE_Flat, POLYTYPE_Tex};     // Might grow (?)

typedef struct {
	int openvec;    // How the cell is open for vision
	int numpoly;    // Number of polygons in this cell
	int firstpoly;  // index of the first polygon into the faces[] array
} cell;

typedef struct {
	cell *here;
	int mark;
	int queue;
} mapcell;

#define COPEN_NORTH 1
#define COPEN_EAST  2
#define COPEN_SOUTH 4
#define COPEN_WEST  8

typedef struct {
	int sizex;
	int sizey;
	cell *firstcell;
	mapcell* map;
} level;

extern vm_vector points[];
extern vm_vector normals[];
extern vm_vector light[];
extern surface   faces[];

extern vertex    vertices[];
extern short     projected[];

extern void*     textures[];

extern level* CurrentLevel;


// Set Camera to pos, angles in degrees
void l3_set_camera(float x, float y, float z, float el, float az);

// Set the camera position
void l3_set_camera_pos(float x, float y, float z);

// Transform a point to camera space
void l3_transform_point(vm_vector *op, vm_vector *ip);

// Project vertex to screen
void l3_project_vertex(vertex* v);

// Check for a given point and normal vector if the
// Plane defined is seen front on
BOOL l3_check_visible(vm_vector *P, vm_vector *N);

BOOL l3_check_cell(vm_vector* view, vm_vector* P);
void l3_rot_y(vm_vector *v, float angle);

// Set the window and precalc some values
void l3_set_window(float bx, float by, float width, float height, float near_plane);

// Clip a polygon given by a set of points
// returns the number of points in the new polygon
int l3_clip_polygon(int** outpt, int facenum, UBYTE codes_or);

#endif

