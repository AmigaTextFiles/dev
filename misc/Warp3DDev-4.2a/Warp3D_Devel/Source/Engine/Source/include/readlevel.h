#ifndef __READLEVEL_H
#define __READLEVEL_H

#include <3d.h>

void LEVEL_Free(void);                  // Dispose the current level
BOOL LEVEL_Read(char*);                 // Read in a level description
cell* LEVEL_GetCell(int x, int y);      // Find the cell ptr at x,y
cell* LEVEL_FindCell(float x, float y); // Find the cell with this ground point
mapcell* LEVEL_GetMapCell(int x, int y);

#endif
