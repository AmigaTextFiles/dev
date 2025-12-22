#include <stdio.h>
#include <exec/types.h>
#include <lex.h>
#include <def.h>
#include <3d.h>
#include <vecmat.h>
#include <textures.h>
#include <string.h>


static LEX_item *lookahead;
static int polynum = 0;

/*
** Free the current level and all allocated storage
*/
void LEVEL_Free(void)
{
	if (CurrentLevel) {
		if (CurrentLevel->firstcell) {
			free(CurrentLevel->firstcell);
		}
		if (CurrentLevel->map) {
			free(CurrentLevel->map);
		}
		free(CurrentLevel);
		CurrentLevel = NULL;
		TEXTURE_FreeAll();
	}
}

/*
** Create a new level
*/
static BOOL LEVEL_Create(int sizex, int sizey)
{
	if (CurrentLevel) LEVEL_Free();

	CurrentLevel = malloc(sizeof(level));
	if (!CurrentLevel) return FALSE;

	CurrentLevel->sizex = sizex;
	CurrentLevel->sizey = sizey;

	CurrentLevel->firstcell = malloc(sizex*sizey*sizeof(cell));
	if (!CurrentLevel->firstcell) {
		LEVEL_Free();
		return FALSE;
	}
	bzero(CurrentLevel->firstcell, sizex*sizey*sizeof(cell));

	CurrentLevel->map = malloc(sizex*sizey*sizeof(mapcell));
	if (!CurrentLevel->map) {
		LEVEL_Free();
		return FALSE;
	}
	bzero(CurrentLevel->map, sizex*sizey*sizeof(mapcell));

	return TRUE;
}

/*
** Get the cell address given a pair of coordinates
** which is treated as the number of cells across and
** down.
*/
cell* LEVEL_GetCell(int x, int y)
{
	int p;
	char *c;

	p= y * CurrentLevel->sizex + x;
	c= (char *)(CurrentLevel->firstcell)+p*sizeof(cell);
	return (cell*)c;
}

/*
** Get the mapcell address of a cell
*/
mapcell* LEVEL_GetMapCell(int x, int y)
{
	int p;
	char *c;

	p= y * CurrentLevel->sizex + x;
	c= (char *)(CurrentLevel->map)+p*sizeof(mapcell);
	return (mapcell*)c;
}

/*
** Given the floating point coordinates in world
** coordinates, get the cell this point is on.
** Coordinates are actually x/z, projected onto the ground plane
*/
cell* LEVEL_FindCell(float x, float y)
{
	int xx,yy;

	xx = (int)(x/64.f);
	yy = (int)(y/64.f);

	return LEVEL_GetCell(xx,yy);
}

#define SCALE 1.f

/*
** Read in the POINTS section of a level file
**
** Assumes that the initial POINTS keyword has already been read
** and is the current lookahead item.
** If the current item is not POINTS, returns immediately
*/
static BOOL LEVEL_ReadPoints(LEX_Context* c)
{
	int pt=0;

	if (lookahead->item != ITEM_Points) return FALSE;
	do {
		lookahead = LEX_Get(c);
		if (lookahead->item == ITEM_End) break;

		if (lookahead->item != ITEM_Number) return FALSE;
		points[pt].x = lookahead->value*SCALE;

		lookahead = LEX_Get(c);
		if (lookahead->item != ITEM_Number) return FALSE;
		points[pt].y = lookahead->value*SCALE;

		lookahead = LEX_Get(c);
		if (lookahead->item != ITEM_Number) return FALSE;
		points[pt].z = lookahead->value*SCALE;

		lookahead = LEX_Get(c);
		if (lookahead->item != ITEM_Number) return FALSE;
		light[pt].x = lookahead->value;

		lookahead = LEX_Get(c);
		if (lookahead->item != ITEM_Number) return FALSE;
		light[pt].y = lookahead->value;

		lookahead = LEX_Get(c);
		if (lookahead->item != ITEM_Number) return FALSE;
		light[pt].z = lookahead->value;


		++pt;
	} while (pt<MAX_POINTS);

	if (pt==MAX_POINTS) return FALSE;

	return TRUE;
}

/*
** Read in the NORMALS section of a file.
** Same rules apply as with ReadPoints
*/
static BOOL LEVEL_ReadNormals(LEX_Context *c)
{
	int pt=0;

	if (lookahead->item != ITEM_Normals) return FALSE;
	do {
		lookahead = LEX_Get(c);
		if (lookahead->item == ITEM_End) break;

		if (lookahead->item != ITEM_Number) return FALSE;
		normals[pt].x = lookahead->value;

		lookahead = LEX_Get(c);
		if (lookahead->item != ITEM_Number) return FALSE;
		normals[pt].y = lookahead->value;

		lookahead = LEX_Get(c);
		if (lookahead->item != ITEM_Number) return FALSE;
		normals[pt].z = lookahead->value;

		++pt;
	} while (pt<MAX_POINTS);

	if (pt==MAX_POINTS) return FALSE;

	return TRUE;
}

/*
** Read the textures descriptions of a level
** Assumes the initial TEXTURE item has already been read
*/
static BOOL LEVEL_ReadTextures(LEX_Context* c)
{
	int tnum = 0;
	static char buffer[250];

	if (lookahead->item != ITEM_Textures) return FALSE;
	do {
		lookahead = LEX_Get(c);
		if (lookahead->item == ITEM_End) break;
		if (lookahead->item != ITEM_String) return FALSE;
		strcpy(buffer, c->Buffer+1);
		buffer[strlen(buffer)-1] = 0;
		if (FALSE == TEXTURE_MakeTexturePNG(tnum++, buffer)) return FALSE;
	} while (tnum < MAX_TEXTURES);

	if (tnum == MAX_TEXTURES) return FALSE;
	return TRUE;
}


#define GETNUM \
	lookahead = LEX_Get(c); \
	if (lookahead->item != ITEM_Number) return FALSE

#define LAINT (int)(lookahead->value)
#define LAFLOAT (lookahead->value)

#define GETNEXT \
	lookahead = LEX_Get(c); \
	if (lookahead->item == ITEM_Error) return FALSE

/*
** Read in one cell description
** Currently, only untextured polygons are read
**
** Assumes the CELL lookahead has already been read
** returns on the next CELL read, or an END
*/
static BOOL LEVEL_ReadCell(LEX_Context* c)
{
	cell* here;
	mapcell* yonder;
	int nr, x, z, opn, ope, ops, opw;
	int i;
	int tnum;

	if (lookahead->item != ITEM_Cell) return FALSE;
	// Read x and z
	GETNUM;
	x = LAINT;
	GETNUM;
	z = LAINT;

	here = LEVEL_GetCell(x,z);
	if (!here) {
		printf("Cell out of range at %d,%d\n",x,z);
		return FALSE;
	}
	yonder = LEVEL_GetMapCell(x,z);
	yonder->mark = 0;
	yonder->here = here;

	// Read open vector
	GETNUM;
	opn = LAINT;
	GETNUM;
	ope = LAINT;
	GETNUM;
	ops = LAINT;
	GETNUM;
	opw = LAINT;

	here->openvec = 0;
	here->numpoly = 0;

	if (opn) here->openvec |= COPEN_NORTH;
	if (ope) here->openvec |= COPEN_EAST;
	if (ops) here->openvec |= COPEN_SOUTH;
	if (opw) here->openvec |= COPEN_WEST;

	here->firstpoly = polynum;

	// -- Proceed by reading the polygon descriptions
	do {
		GETNEXT;
		if (lookahead->item == ITEM_End ||
			lookahead->item == ITEM_EOF ||
			lookahead->item == ITEM_Cell) {
			return TRUE;
		} else if (lookahead->item == ITEM_Dot) { // Read an unmapped polygon
			GETNUM;
			nr = LAINT;     // Read # of points
			if (nr>MAX_EDGES || nr < 1) {
				printf("Illegal number of edges: %d\n", nr);
				return FALSE;
			}
			faces[polynum].type = POLYTYPE_Flat;
			faces[polynum].numedges = nr;
			here->numpoly++;
			i=0;
			while (nr) {
				GETNUM;
				faces[polynum].points[i++] = LAINT;
				nr--;
			}
			GETNUM; // Read normal vector
			nr = LAINT;
			faces[polynum].normal = nr;

			GETNUM;
			faces[polynum].render.color.x = LAFLOAT;

			GETNUM;
			faces[polynum].render.color.y = LAFLOAT;

			GETNUM;
			faces[polynum].render.color.z = LAFLOAT;
			polynum++;
		} else {
			// read a textured polygon
			ULONG size;
			BOOL dummy;
			tnum = LAINT;
			TEXTURE_GetSize(tnum, &size, &dummy);
			if (size == 0) {
				printf("Illegal Texture\n");
				return FALSE;
			}
			faces[polynum].render.texinfo.texture = tnum;
			GETNUM;
			nr = LAINT;
			if (nr > MAX_EDGES || nr < 1) {
				printf("Illegal number of edges: %d\n", nr);
				return FALSE;
			}
			faces[polynum].type = POLYTYPE_Tex;
			faces[polynum].numedges = nr;
			here->numpoly++;
			i=0;
			size--;
			while (nr) {
				GETNUM; // Get point nr
				faces[polynum].points[i] = LAINT;
				GETNUM; // Get U coordinate
				faces[polynum].render.texinfo.u[i] = LAFLOAT;
				faces[polynum].render.texinfo.u[i] *= (float)size;
				GETNUM; // Get V coordinate
				faces[polynum].render.texinfo.v[i] = LAFLOAT;
				faces[polynum].render.texinfo.v[i] *= (float)size;
				nr--; i++;
			}
			GETNUM; // Read normal vector
			nr = LAINT;
			faces[polynum].normal = nr;
			polynum++;
		}
	} while (lookahead->item != ITEM_End);
	return TRUE;
}

/*
** Read all cell descriptions successively
*/
static BOOL LEVEL_ReadCells(LEX_Context* c)
{
	if (lookahead->item != ITEM_Cell) return FALSE;
	do {
		if (FALSE == LEVEL_ReadCell(c)) return FALSE;
		if (lookahead->item == ITEM_End) {  // Done reading cells
			GETNEXT;
			return TRUE;
		} else if (lookahead->item != ITEM_Cell) {
			// No end-of-cells marker was found, so assume error
			return FALSE;
		}
	} while (1);

}

#undef GETNUM
#undef LAINT
#undef LAFLOAT
#undef GETNEXT

#define GETNUM \
	lookahead = LEX_Get(lc); \
	if (lookahead->item != ITEM_Number) goto panic

#define LAINT (int)(lookahead->value)
#define LAFLOAT (lookahead->value)

#define GETNEXT \
	lookahead = LEX_Get(lc); \
	if (lookahead->item == ITEM_Error) goto panic


BOOL LEVEL_Read(char* name)
{
	FILE*           f   =   NULL;
	LEX_Context*    lc  =   NULL;
	int             lx,ly;

	f=fopen(name,"r");
	if (!f) return FALSE;

	lc = LEX_Open(f);
	if (!lc) goto panic;

	// Read the level size
	GETNEXT;
	if (lookahead->item != ITEM_Size) {
		printf("SIZE Expected\n");
		goto panic;
	}

	GETNUM;
	lx = LAINT;
	GETNUM;
	ly = LAINT;

	if (FALSE == LEVEL_Create(lx,ly)) {
		printf("Failed to create level sized %d×%d\n", lx,ly);
		goto panic;
	}

	GETNEXT;
	if (FALSE == LEVEL_ReadPoints(lc)) {
		printf("POINTS expected\n");
		goto panic;
	}

	GETNEXT;
	if (FALSE == LEVEL_ReadNormals(lc)) {
		printf("NORMALS expected\n");
		goto panic;
	}

	GETNEXT;
	if (FALSE == LEVEL_ReadTextures(lc)) {
		printf("TEXTURES expected\n");
		goto panic;
	}

	GETNEXT;
	if (FALSE == LEVEL_ReadCells(lc)) {
		printf("CELLS expected\n");
		goto panic;
	}

	LEX_Close(lc);
	fclose(f);
	return TRUE;

panic:
	LEVEL_Free();
	if (lc) LEX_Close(lc);
	if (f) fclose(f);
	return FALSE;
}

