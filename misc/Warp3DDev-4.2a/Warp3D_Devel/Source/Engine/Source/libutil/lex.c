#include <stdio.h>
#include <ctype.h>
#include <exec/types.h>
#include <lex.h>
#include <string.h>

#define LEX_BUFLEN 255

static char LineBuffer[LEX_BUFLEN];

/*
** Close a LEX_Context
** Does free everything allocated by LEX
** Does *NOT* close the file handle
*/
void LEX_Close(LEX_Context* c)
{
	if (c->Buffer) free(c->Buffer);
	free(c);
}

/*
** Create a LEX_Context
*/
LEX_Context* LEX_Open(FILE *f)
{
	LEX_Context *c = malloc(sizeof(LEX_Context));
	if (!c) return NULL;

	bzero(c, sizeof(LEX_Context));

	c->Buffer = malloc(LEX_BUFLEN);
	if (!c->Buffer) {
		free(c);
		return NULL;
	}

	c->f = f;
	c->current.item  = ITEM_Error;
	c->current.value = 0.0f;

	return c;
}

/*
** Skips to end of line
*/
void LEX_SkipEOL(LEX_Context *lc)
{
	int c = fgetc(lc->f);
	while (c != '\n') {
		c=fgetc(lc->f);
		if (c==EOF) break;
	}
}

/*
** Reads a space/whitespace delimited token into the LineBuffer.
*/
char *LEX_ReadToken(LEX_Context* lc)
{
	int c;
	int i;

start:
	c=fgetc(lc->f);

	if (c==EOF) {
		LineBuffer[0] = -1;
		LineBuffer[1] = 0;
		return LineBuffer;
	}

	do {
		if (c == '\n') c=fgetc(lc->f);
		else if (isspace(c)) c=fgetc(lc->f);
		else if (c==EOF) return NULL;
		else break;
	} while (1);

	if (c=='#') {
		LEX_SkipEOL(lc);
		goto start;
	}

	i=0;
	do {
		LineBuffer[i++] = (char)c;
		c=fgetc(lc->f);
		if (c=='\n') break;
		if (isspace(c)) break;
		if (c==EOF) break;
		if (i==LEX_BUFLEN) {
			printf("Error: Buffer Overflow\n");
			return NULL;
		}
	} while (1);
	LineBuffer[i] = 0;
	return LineBuffer;
}

#define DB(x) //printf(x); printf(" ")

int LEX_GetItemType(char *buffer)
{
	int bufl = strlen(buffer);

	if (buffer[0] == '.' && bufl == 1)      {DB("DOT"); return ITEM_Dot;       }
	if (buffer[0] == -1)                    {DB("EOF"); return ITEM_EOF;       }
	if (isdigit(buffer[0]))                 {DB("NUM"); return ITEM_Number;    }
	if (buffer[0] == '-' && isdigit(buffer[1]))
											{DB("NUM"); return ITEM_Number;    }
	if (buffer[0] == '.' && isdigit(buffer[1]))
											{DB("NUM"); return ITEM_Number;    }
	if (buffer[0] == '"' && buffer[bufl-1] == '"')
											{DB("STR"); return ITEM_String;    }
	if (0 == stricmp(buffer, "SIZE"))       {DB("SIZ"); return ITEM_Size;      }
	if (0 == stricmp(buffer, "CAMERA"))     {DB("CAM"); return ITEM_Camera;    }
	if (0 == stricmp(buffer, "POINTS"))     {DB("POI"); return ITEM_Points;    }
	if (0 == stricmp(buffer, "END"))        {DB("END"); return ITEM_End;       }
	if (0 == stricmp(buffer, "NORMALS"))    {DB("NOR"); return ITEM_Normals;   }
	if (0 == stricmp(buffer, "TEXTURES"))   {DB("TEX"); return ITEM_Textures;  }
	if (0 == stricmp(buffer, "CELL"))       {DB("CEL"); return ITEM_Cell;      }
	return ITEM_Error;
}

LEX_item *LEX_Get(LEX_Context* c)
{
	char *b = LEX_ReadToken(c);
	if (b == NULL) {
		printf("Syntax error\n");
		return NULL;
	}


	c->current.item = LEX_GetItemType(b);
	if (c->current.item == ITEM_Number) {
		sscanf(b, "%f", &(c->current.value));
	} else {
		c->current.value = 0.f;
	}
	c->Buffer = b;
	return &(c->current);
}
