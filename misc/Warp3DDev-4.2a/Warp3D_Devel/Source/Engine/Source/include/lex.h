#ifndef __LEX_H
#define __LEX_H

#include <math.h>
#include <exec/types.h>


typedef struct {
	int item;       // Item number, see enum below
	float value;
} LEX_item;

typedef struct {
	char* Buffer;
	FILE* f;
	LEX_item current;
} LEX_Context;

enum {
	ITEM_Error = 0,
	ITEM_Number,
	ITEM_Size,
	ITEM_Camera,
	ITEM_Points,
	ITEM_End,
	ITEM_Normals,
	ITEM_Textures,
	ITEM_Cell,
	ITEM_Dot,
	ITEM_String,
	ITEM_EOF
};

LEX_Context* LEX_Open(FILE *f);
LEX_item *LEX_Get(LEX_Context* c);
void LEX_Close(LEX_Context* c);

#endif

