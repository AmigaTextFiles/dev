#include <exec/types.h>
#include <def.h>
#include <vecmat.h>
#include <3d.h>


// -- Static Level data

vm_vector points[MAX_POINTS];       // The level's vertices
vm_vector normals[MAX_NORMALS];     // The level's normals
vm_vector light[MAX_POINTS];        // The level's lights

surface   faces[MAX_POLYS];         // The level's polyons

void*     textures[MAX_TEXTURES];   // Texture handles

// -- Non-Static data

vertex    vertices[MAX_POINTS+10];  // Rotated/projected vertices
short     projected[MAX_POINTS+10]; // Markers

level* CurrentLevel;
