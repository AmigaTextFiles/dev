#include "exec/types.h"
#include "stdlib.h"
#include "stdio.h"
#include "string.h"
#include "dos/dos.h"
#include "proto/dos.h"
#include "pragmas/dos_pragmas.h"

#define NB_CHAR_FICNAME					130

#define ERROR 								0
#define NO_ERROR							1
#define NO_ERROR_ADDED					1
#define NO_ERROR_CREATED				2

#define NDEF								0

struct InfoHit
{
	LONG nb_hit;
	UBYTE *FileName;
	LONG Hunk;
	LONG Offset;

	UWORD mode;
		#define MODE_UNDEFINE	0
		#define MODE_SYMBOL		1
		#define MODE_OK			2
	UBYTE *SourceName; /* Or symboleName */
	LONG LineNumber;
};

#include "prototypes.h"
