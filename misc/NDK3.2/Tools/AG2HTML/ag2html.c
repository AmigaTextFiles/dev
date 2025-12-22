/*
 * $Id: ag2html.c 1.2 1998/10/02 17:07:13 olsen Exp olsen $
 *
 * :ts=4
 */

#include <exec/lists.h>
#include <exec/nodes.h>
#include <exec/memory.h>

#include <datatypes/pictureclass.h>

#include <dos/dosextens.h>
#include <dos/rdargs.h>

#include <clib/datatypes_protos.h>
#include <clib/utility_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/alib_protos.h>

#include <pragmas/exec_sysbase_pragmas.h>
#include <pragmas/datatypes_pragmas.h>
#include <pragmas/utility_pragmas.h>
#include <pragmas/dos_pragmas.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <signal.h>

/******************************************************************************/

#include "AG2HTML_rev.h"

/******************************************************************************/

#define ZERO (0L)

/******************************************************************************/

enum AGV34CMD
{
	AGV34CMD_Bold,
	AGV34CMD_UnBold,
	AGV34CMD_Italic,
	AGV34CMD_UnItalic,
	AGV34CMD_UnUnderline,	/* note reverse order; see below */
	AGV34CMD_Underline,
	AGV34CMD_Foreground,
	AGV34CMD_Background,

	AGV34CMD_COUNT
};

const STRPTR v39Commands[AGV34CMD_COUNT] =
{
	"b",
	"ub",
	"i",
	"ui",
	"uu",	/* "uu" comes before "u" in order to avoid mistaking "uu" for two "u" commands */
	"u",
	"fg ",
	"bg "
};
	
/******************************************************************************/

const STRPTR VersionTag = VERSTAG;

/******************************************************************************/

const STRPTR FormatVersion = "1.1";

/******************************************************************************/

BOOL IsAmigaGuideV39 = FALSE;

/******************************************************************************/

extern struct Library * DataTypesBase;
extern struct Library * SysBase;
extern struct Library * DOSBase;
extern struct Library * UtilityBase;

/******************************************************************************/

typedef long ERRORCODE;

/******************************************************************************/

BPTR PushDir(BPTR dirLock);
VOID PopDir(VOID);
VOID ForbidBreak(VOID);
VOID PermitBreak(VOID);
VOID ExitTrap(VOID);
VOID Initialize(VOID);
APTR AllocVecPooled(LONG bytes, ULONG flags);
VOID FreeVecPooled(APTR address);
BOOL ParseString(const STRPTR key, const STRPTR params, STRPTR *args, const STRPTR string);
BOOL ParseAndTrashString(const STRPTR params, STRPTR *args, STRPTR string);
struct Node *FindIName(const struct List *lh, const STRPTR name);
LONG Compare(const STRPTR a, const STRPTR b, LONG len);
VOID StrcpyN(LONG MaxLen, STRPTR To, const STRPTR From);
STRPTR CopyString(const STRPTR string);
LONG MeasureCommandLen(const STRPTR buffer);
ERRORCODE FindLink(const STRPTR linkName, struct DocumentNode * thisDn,LONG linkLine, struct GuideLinkNode *gn);
ERRORCODE BuildCrossReferences(struct DocumentNode *dn, BOOL *newDocumentsAdded);
ERRORCODE ScanDocumentForCommands(struct DocumentNode *dn);
ERRORCODE ReadDocument(const STRPTR masterFileName, const STRPTR name, struct DocumentNode **resultPtr);
int main(void);

/******************************************************************************/

#define SAME	(0)
#define OK		(0)
#define CANNOT	!
#define NOT		!
#define NO		!

/******************************************************************************/

#define MAX_PATHNAME_LEN (256)
#define MAX_FILENAME_LEN (30)	/* according to documentation, this should be 31, but that's already too much */

/******************************************************************************/

#define OPEN_BRACE	'{'
#define CLOSE_BRACE	'}'

/******************************************************************************/

#define NUM_ELEMENTS(t) (sizeof(t) / sizeof(t[0]))

/******************************************************************************/

struct RDArgs * GlobalRDArgs;
BPTR GlobalLastDir,GlobalTargetDir;

/******************************************************************************/

struct List DocumentList;

/******************************************************************************/

struct RDArgs * RDArgs;

/******************************************************************************/

APTR Pool;

/******************************************************************************/

/* for reading single lines of text */
UBYTE LineBuffer[1000];

/* for translating text into HTML */
UBYTE LineTranslationBuffer[4 * sizeof(LineBuffer)];

/* for translating names into a proper URL */
UBYTE URLTranslationBuffer[3 * MAX_PATHNAME_LEN];

/******************************************************************************/

struct DocumentNode
{
	struct Node	dn_Node;			/* dn_Node.ln_Name is name of document */
	struct List	dn_NodeList;
	BOOL		dn_IsAmigaGuide;
	BOOL		dn_IsPicture;
	BOOL		dn_Done;
	BOOL		dn_Stable;
	BOOL		dn_WordWrap;
	STRPTR		dn_MasterFile;		/* name of master database file */
	STRPTR		dn_MasterTemplate;
	ULONG		dn_PicNumber;	/* picture number */
};

struct AmigaGuideNode
{
	struct Node				an_Node;		/* an_Node.ln_Name is complete node name */
	struct DocumentNode *	an_Document;	/* points back to containing document */
	STRPTR					an_TOC;			/* name of table of contents */
	struct GuideLinkNode *	an_TOCLink;
	LONG					an_TOCLine;
	STRPTR					an_Index;		/* name of index node */
	struct GuideLinkNode *	an_IndexLink;
	LONG					an_IndexLine;
	STRPTR					an_Next;		/* name of next node */
	struct GuideLinkNode *	an_NextLink;
	LONG					an_NextLine;
	STRPTR					an_Prev;		/* name of previous node */
	struct GuideLinkNode *	an_PrevLink;
	LONG					an_PrevLine;
	STRPTR					an_Title;		/* node title */
	ULONG					an_Number;		/* node number */
	struct List				an_Lines;
};

struct LineNode
{
	struct Node				ln_Node;		/* ln_Node.ln_Name is line text */
	LONG					ln_Len;			/* line length */
	LONG					ln_LineNumber;	/* number of this line */
	struct AmigaGuideNode *	ln_GuideNode;	/* points back to containing node */
	struct List				ln_Commands;	/* list of commands in this line */
	BOOL					ln_HasCommands;	/* TRUE if there are embedded commands, such as links, on this line */
	BOOL					ln_NeedsAnchor;	/* TRUE if pointed to by a node */
};

struct GuideLinkNode
{
	struct MinNode			gn_MinNode;
	STRPTR					gn_Command;		/* offset into line, pointing to link command */
	LONG					gn_CommandLen;	/* number of characters in command */
	struct AmigaGuideNode *	gn_GuideNode;	/* points to referenced node */
	struct LineNode *		gn_Line;		/* line to display, NULL if top of file */
	LONG					gn_LineNumber;	/* the number of the line to display */
};

/******************************************************************************/

BOOL
IsLocal(STRPTR name)
{
	BOOL result = FALSE;
	BPTR fileLock;

	fileLock = Lock(name,SHARED_LOCK);
	if(fileLock != ZERO)
	{
		UnLock(fileLock);

		result = TRUE;
	}

	return(result);
}

/******************************************************************************/

struct ImageData
{
	STRPTR	id_FileName;
	UBYTE *	id_Data;
	LONG	id_Size;
};

ERRORCODE
CreateImages(BPTR targetDir)
{
	STATIC UBYTE help_gif_data[166] =
	{
		0x47,0x49,0x46,0x38,0x37,0x61,0x3F,0x00,0x16,0x00,0xF1,0x00,0x00,0xAA,0xAA,0xAA,
		0x00,0x00,0x00,0xFF,0xFF,0xFF,0x65,0x8A,0xBA,0x2C,0x00,0x00,0x00,0x00,0x3F,0x00,
		0x16,0x00,0x01,0x02,0x7F,0x94,0x8F,0xA9,0xCB,0xED,0x1B,0x0C,0x98,0xB4,0xDA,0x8B,
		0xB3,0xDE,0x35,0x44,0xC1,0x85,0xE2,0xA8,0x79,0x12,0x89,0xA6,0x9B,0x09,0xAA,0xEE,
		0x0B,0xB0,0x6A,0x60,0xD1,0x99,0x0D,0xC7,0xDF,0x5C,0x97,0xF9,0x24,0x4B,0xE1,0x80,
		0x14,0x0F,0xCE,0x46,0xF3,0xCC,0x76,0xC2,0x5E,0xAC,0x48,0xD4,0x45,0x49,0x41,0x94,
		0xF1,0x3A,0x45,0x66,0x85,0x4C,0xAB,0xF3,0xAA,0x7D,0x4E,0x47,0x55,0xEA,0xF7,0x12,
		0x16,0x53,0xBB,0xE6,0xCE,0x56,0xAC,0x54,0x93,0xD9,0x64,0xA7,0xEE,0x48,0x8C,0x5B,
		0xE9,0x3F,0xDF,0xAB,0xDC,0xE7,0xE7,0x02,0x18,0x88,0x31,0xC4,0x75,0x52,0xA8,0xD8,
		0xC1,0xB7,0x18,0x48,0xE8,0xD8,0x07,0x19,0x99,0x63,0x02,0x76,0x89,0x99,0xA9,0xB9,
		0xC9,0x79,0x59,0x00,0x00,0x3B
	};

	STATIC UBYTE help_d_gif_data[205] =
	{
		0x47,0x49,0x46,0x38,0x37,0x61,0x3F,0x00,0x16,0x00,0xF1,0x00,0x00,0xAA,0xAA,0xAA,
		0x00,0x00,0x00,0xFF,0xFF,0xFF,0x65,0x8A,0xBA,0x2C,0x00,0x00,0x00,0x00,0x3F,0x00,
		0x16,0x00,0x01,0x02,0xA6,0x94,0x8F,0xA9,0xCB,0xED,0x1B,0x4C,0x00,0x74,0x56,0x0A,
		0x6C,0xC6,0xBA,0xF3,0x7F,0x85,0x9B,0x68,0x05,0x91,0x40,0x82,0xE3,0xEA,0xA5,0x2E,
		0xAB,0x9A,0x67,0x0B,0xBF,0xF4,0x1D,0xE7,0xD9,0x69,0xEB,0xF5,0x8F,0xB3,0x99,0x24,
		0x3E,0xCF,0x24,0xB8,0x39,0x16,0x75,0x43,0x14,0x70,0xA9,0xEC,0x49,0x59,0x4D,0xA4,
		0x11,0x68,0x4A,0xEE,0xB6,0xD3,0x12,0xEF,0xD9,0x3B,0x7A,0x43,0x59,0x2E,0x78,0x37,
		0x5B,0x5E,0x64,0xEC,0xCA,0x58,0xEC,0xEE,0xBA,0x0D,0xF2,0x94,0xB8,0x3D,0x2A,0x97,
		0xCF,0x32,0xA2,0x3C,0x9A,0x77,0xA5,0x57,0xA2,0xD6,0x54,0x07,0x03,0xC7,0x35,0x66,
		0x66,0x55,0xA5,0xA6,0x75,0x93,0xA5,0x24,0x69,0x05,0x62,0xC8,0xF7,0xD8,0xB2,0x57,
		0xE9,0x96,0x76,0xC8,0xA9,0x98,0x39,0xE7,0x04,0x5A,0x1A,0xF7,0xE9,0xF8,0x29,0xAA,
		0xBA,0x43,0x87,0xC9,0xFA,0x4A,0xE5,0x19,0x6B,0xCA,0x7A,0x59,0x4B,0xBB,0x8A,0x26,
		0xC0,0xD6,0xEB,0xFB,0x0B,0x1C,0x2C,0x3C,0x6C,0x52,0x00,0x00,0x3B
	};

	STATIC UBYTE index_gif_data[171] =
	{
		0x47,0x49,0x46,0x38,0x37,0x61,0x3F,0x00,0x16,0x00,0xF1,0x00,0x00,0xAA,0xAA,0xAA,
		0x00,0x00,0x00,0xFF,0xFF,0xFF,0x65,0x8A,0xBA,0x2C,0x00,0x00,0x00,0x00,0x3F,0x00,
		0x16,0x00,0x01,0x02,0x84,0x94,0x8F,0xA9,0xCB,0xED,0x1B,0x0C,0x98,0xB4,0xDA,0x8B,
		0xB3,0xDE,0x35,0x44,0xC1,0x85,0xE2,0xA8,0x79,0x12,0x89,0xA6,0x9B,0x09,0xAA,0xEE,
		0x0B,0xB0,0x63,0x20,0xD2,0x70,0x26,0xD7,0xFA,0x8D,0xE5,0xA1,0x4D,0xF3,0x74,0x82,
		0x14,0x0F,0xB0,0x83,0xF2,0x71,0x80,0xC7,0xD8,0x44,0xE8,0x7C,0x4A,0xA3,0x24,0xE5,
		0x6A,0x1A,0xB5,0x65,0x8B,0x45,0x6D,0xF5,0x33,0xC3,0x36,0xB3,0x46,0x2D,0x34,0x09,
		0xDE,0x99,0xC5,0x58,0x2E,0x75,0x96,0xFE,0xB1,0xC9,0x6C,0xAF,0xF7,0x17,0x5F,0xCE,
		0x63,0xC4,0x27,0xD4,0x8E,0x76,0xC2,0x33,0xB8,0x92,0x47,0x78,0x38,0x24,0x88,0xB8,
		0xC8,0xA7,0xC8,0x78,0x68,0xF5,0x38,0x18,0x29,0x79,0x43,0x59,0xF9,0x62,0x52,0xB6,
		0xC9,0xD9,0xE9,0xF9,0x09,0x1A,0xEA,0x51,0x00,0x00,0x3B
	};

	STATIC UBYTE index_d_gif_data[206] =
	{
		0x47,0x49,0x46,0x38,0x37,0x61,0x3F,0x00,0x16,0x00,0xF1,0x00,0x00,0xAA,0xAA,0xAA,
		0x00,0x00,0x00,0xFF,0xFF,0xFF,0x65,0x8A,0xBA,0x2C,0x00,0x00,0x00,0x00,0x3F,0x00,
		0x16,0x00,0x01,0x02,0xA7,0x94,0x8F,0xA9,0xCB,0xED,0x1B,0x0C,0x00,0x61,0x52,0x5B,
		0x67,0xBE,0x1A,0xFB,0x0E,0x72,0xE2,0x46,0x06,0x91,0x40,0x7E,0xA3,0x9A,0x86,0xED,
		0xEA,0x6A,0x67,0x4C,0xC3,0xF6,0x8B,0xB3,0xA6,0x91,0xD7,0xFD,0xCD,0x0A,0x52,0x66,
		0x40,0x9F,0xA7,0xF2,0x4B,0x62,0x76,0x28,0xE1,0x05,0xE9,0x54,0x1A,0x41,0xCC,0x29,
		0xC7,0x64,0xBA,0x42,0x91,0xD9,0x61,0x54,0x77,0x52,0x72,0xB9,0xD4,0x4C,0x37,0x4B,
		0x2E,0x6A,0x25,0x6A,0xB3,0xFB,0xF9,0x7C,0x0F,0xA1,0x56,0x2C,0xEF,0x9B,0x3E,0x7F,
		0xB0,0x58,0xD9,0xB7,0xCC,0x26,0x75,0xB6,0x15,0x47,0xD3,0xD5,0xC6,0x24,0xE6,0xB5,
		0x28,0x37,0x68,0x06,0x37,0x55,0xD5,0xE6,0xC7,0x48,0xD8,0xB7,0x38,0x29,0x13,0xF6,
		0x97,0xD9,0xD9,0x23,0x29,0xE5,0xC9,0x89,0x93,0x38,0x6A,0x5A,0x27,0x04,0x7A,0x2A,
		0x8A,0xAA,0x79,0xD7,0xCA,0xCA,0xAA,0x0A,0x1B,0x5A,0xBB,0xB4,0x49,0xBB,0x6A,0x3B,
		0x84,0xC2,0xE7,0xFB,0x0B,0x1C,0x2C,0x3C,0x4C,0x1C,0x50,0x00,0x00,0x3B
	};

	STATIC UBYTE next_gif_data[184] =
	{
		0x47,0x49,0x46,0x38,0x37,0x61,0x3F,0x00,0x16,0x00,0xF1,0x00,0x00,0xAA,0xAA,0xAA,
		0x00,0x00,0x00,0xFF,0xFF,0xFF,0x65,0x8A,0xBA,0x2C,0x00,0x00,0x00,0x00,0x3F,0x00,
		0x16,0x00,0x01,0x02,0x91,0x94,0x8F,0xA9,0xCB,0xED,0x1B,0x0C,0x98,0xB4,0xDA,0x8B,
		0xB3,0xDE,0x35,0x44,0xC1,0x85,0xE2,0xA8,0x79,0x12,0x89,0xA6,0x9B,0x09,0xAA,0xEE,
		0x0B,0xB0,0x9D,0xE7,0xC1,0x36,0x26,0x53,0x41,0x77,0xF7,0x53,0xFE,0xE3,0xC5,0x86,
		0xB1,0x1A,0xF1,0xB8,0x2B,0xCE,0x92,0x24,0xE0,0x91,0x68,0x64,0xEE,0xA4,0x3A,0x68,
		0xF0,0x3A,0xCB,0x38,0x69,0x46,0x64,0xD5,0x0A,0xFE,0x3E,0xB3,0x96,0xAD,0x90,0x7A,
		0x4D,0xAA,0x75,0x52,0xEE,0x8A,0x59,0x3C,0x61,0xC3,0xE8,0xE9,0x10,0x1E,0x2E,0xE1,
		0xE3,0xAD,0xF9,0x1A,0x8B,0xE6,0x45,0x77,0xD1,0x55,0xF6,0xB1,0xD4,0x05,0x47,0x23,
		0xF4,0x54,0xB8,0x88,0xE2,0xE4,0x23,0x39,0x23,0x37,0x69,0xC9,0x77,0x99,0x19,0x99,
		0xD9,0xB3,0xC9,0x69,0xE3,0xF9,0xF9,0x12,0x2A,0xAA,0x62,0xC2,0x85,0x9A,0xAA,0xBA,
		0xCA,0xDA,0xEA,0xEA,0x51,0x00,0x00,0x3B
	};

	STATIC UBYTE next_d_gif_data[213] =
	{
		0x47,0x49,0x46,0x38,0x37,0x61,0x3F,0x00,0x16,0x00,0xF1,0x00,0x00,0xAA,0xAA,0xAA,
		0x00,0x00,0x00,0xFF,0xFF,0xFF,0x65,0x8A,0xBA,0x2C,0x00,0x00,0x00,0x00,0x3F,0x00,
		0x16,0x00,0x01,0x02,0xAE,0x94,0x8F,0xA9,0xCB,0xED,0x1B,0x4C,0x00,0x74,0x56,0x0A,
		0x6C,0xC6,0xBA,0xF3,0x7F,0x85,0x9B,0x68,0x05,0x91,0x40,0x82,0xE3,0xEA,0xA5,0x2E,
		0xAB,0x9A,0x67,0x0B,0xBF,0xF4,0x1D,0xE7,0xD9,0x69,0xEB,0xF5,0x8F,0xB3,0x99,0x24,
		0x1C,0x59,0x10,0xE8,0x3B,0xB6,0x86,0xA8,0xCD,0xA4,0xA4,0x4C,0x4A,0x85,0xB3,0x58,
		0xC9,0x69,0x74,0x6A,0x9F,0xA6,0x91,0xAC,0x17,0x62,0x5E,0x9E,0x15,0x2E,0xF9,0x9C,
		0xE3,0x82,0xBB,0x24,0x66,0x27,0xBB,0x3E,0x5F,0xC7,0x5B,0x10,0xDB,0xCB,0xAB,0xEF,
		0xEA,0xF2,0x30,0xB4,0xF8,0xE5,0x72,0x27,0x43,0xD4,0x16,0x67,0xE6,0xA7,0x25,0xB8,
		0x94,0x87,0xB6,0x87,0x06,0xC9,0xB7,0x87,0x34,0xC9,0xE2,0x06,0x38,0x88,0xA9,0xD4,
		0x05,0x35,0x47,0x29,0x46,0x19,0x1A,0x05,0x66,0x59,0x45,0x3A,0x2A,0x3A,0x05,0x8A,
		0xCA,0x3A,0x05,0x74,0x79,0xEA,0xDA,0xBA,0x68,0x10,0x6B,0x9B,0x4A,0x55,0x88,0xBB,
		0x3B,0x8B,0x57,0xCB,0x2B,0x1B,0xDC,0x16,0x61,0x54,0x6C,0x7C,0x8C,0x9C,0xAC,0xBC,
		0x6C,0x52,0x00,0x00,0x3B
	};

	STATIC UBYTE prev_gif_data[185] =
	{
		0x47,0x49,0x46,0x38,0x37,0x61,0x3F,0x00,0x16,0x00,0xF1,0x00,0x00,0xAA,0xAA,0xAA,
		0x00,0x00,0x00,0xFF,0xFF,0xFF,0x65,0x8A,0xBA,0x2C,0x00,0x00,0x00,0x00,0x3F,0x00,
		0x16,0x00,0x01,0x02,0x92,0x94,0x8F,0xA9,0xCB,0xED,0x1B,0x0C,0x98,0xB4,0xDA,0x8B,
		0xB3,0xDE,0x35,0x44,0xC1,0x85,0xE2,0xA8,0x79,0x12,0x89,0xA6,0x9B,0x09,0xAA,0xEE,
		0x0B,0xB0,0x9D,0xE7,0xC1,0x36,0x26,0x53,0x41,0x77,0xF7,0x53,0xFE,0xE3,0xC5,0x86,
		0xB1,0x1A,0xF1,0xB8,0x2B,0xCE,0x92,0x24,0xE0,0x91,0x68,0x64,0xEE,0xA4,0x3A,0x68,
		0xF0,0x8A,0x63,0xFE,0x3E,0x4B,0x23,0xB2,0x6A,0x0D,0x83,0x9F,0x3A,0x6D,0xF9,0x84,
		0x15,0x53,0xC3,0xD2,0x36,0xCD,0xE2,0xBD,0x38,0xB5,0xC9,0xB5,0x75,0x4A,0xAE,0x73,
		0xE2,0xE7,0x56,0x5A,0x8F,0x65,0xB7,0x06,0x48,0x36,0x03,0xC7,0x55,0xF6,0xF6,0x17,
		0x67,0xA7,0x94,0x98,0xE2,0xE4,0x23,0x39,0x83,0x36,0x69,0x59,0x54,0x79,0x29,0x19,
		0xA9,0xD9,0xC3,0xD9,0x69,0xF3,0x09,0xFA,0x22,0x3A,0xAA,0x62,0x42,0x93,0xAA,0xBA,
		0xCA,0xDA,0xEA,0xFA,0xFA,0x5A,0x00,0x00,0x3B
	};

	STATIC UBYTE prev_d_gif_data[214] =
	{
		0x47,0x49,0x46,0x38,0x37,0x61,0x3F,0x00,0x16,0x00,0xF1,0x00,0x00,0xAA,0xAA,0xAA,
		0x00,0x00,0x00,0xFF,0xFF,0xFF,0x65,0x8A,0xBA,0x2C,0x00,0x00,0x00,0x00,0x3F,0x00,
		0x16,0x00,0x01,0x02,0xAF,0x94,0x8F,0xA9,0xCB,0xED,0x1B,0x0C,0x00,0x61,0x52,0x5B,
		0x67,0xBE,0x1A,0xFB,0x0E,0x72,0xE2,0x46,0x06,0x91,0x40,0x7E,0xA3,0x9A,0x86,0xED,
		0xEA,0x6A,0x67,0x4C,0xC3,0xF6,0x8B,0xB3,0xA6,0x91,0xD7,0xFD,0xCD,0x0A,0x52,0x66,
		0x17,0x93,0x11,0xE8,0x13,0x22,0x47,0x3B,0x94,0x2E,0x09,0x5D,0xF6,0x9A,0x9D,0x4A,
		0xC6,0x54,0x94,0x5D,0x85,0x58,0x6D,0x57,0xDA,0xC4,0x5D,0xB7,0xD5,0xAC,0x95,0x83,
		0x3D,0x9F,0x5D,0x64,0x6A,0xD1,0xA8,0x36,0xBF,0x41,0x69,0x29,0x86,0x3C,0x3C,0x89,
		0xA1,0xF5,0xEE,0xD1,0x0A,0xC7,0x44,0xE3,0x16,0x37,0x24,0xA7,0x06,0x08,0x78,0x17,
		0xE5,0x77,0xA7,0xF7,0x64,0x37,0x18,0xB7,0x26,0x88,0x46,0x94,0xD8,0x67,0xB9,0x35,
		0x29,0xE3,0xF8,0xF5,0x63,0xC4,0xA3,0x04,0x3A,0x5A,0x2A,0x29,0x11,0x99,0x4A,0xEA,
		0x13,0x66,0xAA,0xEA,0x3A,0x75,0x09,0x3B,0xCB,0xA8,0xF3,0x58,0x8B,0xFB,0x4A,0x27,
		0x9B,0xBB,0xAA,0x9B,0x27,0xDA,0x4B,0xAB,0xBB,0x03,0x67,0x7C,0x8C,0x9C,0xAC,0xBC,
		0xCC,0x6C,0x52,0x00,0x00,0x3B
	};

	STATIC UBYTE retrace_gif_data[187] =
	{
		0x47,0x49,0x46,0x38,0x37,0x61,0x3F,0x00,0x16,0x00,0xF1,0x00,0x00,0xAA,0xAA,0xAA,
		0x00,0x00,0x00,0xFF,0xFF,0xFF,0x65,0x8A,0xBA,0x2C,0x00,0x00,0x00,0x00,0x3F,0x00,
		0x16,0x00,0x01,0x02,0x94,0x94,0x8F,0xA9,0xCB,0xED,0x1B,0x0C,0x98,0xB4,0xDA,0x8B,
		0xB3,0xDE,0x35,0x44,0xC1,0x85,0xE2,0xA8,0x79,0x12,0x89,0xA6,0x9B,0x09,0xAA,0xEE,
		0x0B,0xB0,0xAB,0xE7,0xAD,0x70,0x28,0x97,0x9D,0x7E,0xCF,0x67,0x16,0xD8,0x4D,0x68,
		0xC3,0x5A,0x30,0x18,0xAB,0x51,0x88,0x4B,0x25,0x26,0x07,0x14,0x22,0x63,0xC3,0x62,
		0xF5,0x3A,0x45,0x66,0x81,0x9F,0x19,0x93,0x8A,0xBD,0x5A,0xB4,0x97,0xED,0xB3,0xCB,
		0x03,0x27,0x99,0xE4,0xA6,0x72,0xEA,0x76,0x8E,0xD1,0xD1,0xA5,0xD8,0xAE,0x36,0xC3,
		0xEF,0xDC,0xDF,0x53,0x8A,0xD7,0x96,0x27,0x26,0xB8,0xD7,0xE4,0x57,0x26,0xB4,0xD6,
		0xA4,0xB6,0xA8,0x25,0xF7,0x55,0x46,0xD7,0x43,0x59,0x32,0x59,0x89,0xD9,0x71,0x99,
		0x99,0x09,0xC5,0xC9,0xE9,0xF9,0x89,0x19,0x2A,0x4A,0x49,0x5A,0x7A,0x63,0x42,0xB3,
		0xCA,0xDA,0xEA,0xFA,0x0A,0x1B,0x1B,0x5B,0x00,0x00,0x3B
	};

	STATIC UBYTE retrace_d_gif_data[219] =
	{
		0x47,0x49,0x46,0x38,0x37,0x61,0x3F,0x00,0x16,0x00,0xF1,0x00,0x00,0xAA,0xAA,0xAA,
		0x00,0x00,0x00,0xFF,0xFF,0xFF,0x65,0x8A,0xBA,0x2C,0x00,0x00,0x00,0x00,0x3F,0x00,
		0x16,0x00,0x01,0x02,0xB4,0x94,0x8F,0xA9,0xCB,0xED,0x1B,0x0C,0x00,0x61,0x52,0x5B,
		0x67,0xBE,0x1A,0xFB,0x0E,0x72,0xE2,0x46,0x06,0x91,0x40,0x7E,0xA3,0x9A,0x86,0xED,
		0xEA,0x6A,0x67,0x4C,0xC3,0xF6,0x8B,0xB3,0xA6,0x91,0xD7,0xFD,0xCD,0x0A,0x52,0x66,
		0x37,0x93,0x49,0x78,0xF4,0x09,0x8B,0xA7,0x5C,0x25,0x93,0x1C,0x41,0x97,0xBF,0xD6,
		0x4E,0xA0,0x94,0xC9,0x8C,0xC3,0x27,0x87,0x7B,0x01,0x77,0xA3,0xA5,0x66,0xD0,0x3B,
		0x0C,0x87,0xA1,0x53,0x50,0xF2,0xE8,0x45,0x7F,0x89,0x38,0x63,0x0F,0xBE,0x7A,0xB6,
		0x81,0x5B,0xDE,0x59,0xAD,0xC7,0xF5,0x86,0x61,0xA7,0xD5,0x61,0x27,0xC7,0x26,0xC1,
		0x97,0x06,0x83,0x17,0xB7,0x96,0x25,0x65,0x16,0x83,0xF6,0x18,0xC9,0xF7,0x06,0x99,
		0x28,0xB3,0x58,0xC5,0x06,0x76,0xD9,0x95,0x26,0x86,0xA8,0x43,0xC9,0x58,0x45,0xB5,
		0xEA,0x46,0xC7,0x9A,0xFA,0xFA,0x89,0xAA,0x2A,0x49,0x9B,0xE9,0x5A,0x1B,0xAB,0xEB,
		0x72,0x65,0xEB,0xBB,0xEB,0x88,0x0B,0x9B,0x4B,0x3C,0xE9,0x57,0xFC,0x8B,0xDC,0x89,
		0xC8,0xDC,0xEC,0xFC,0x0C,0x1D,0xCD,0x5C,0x00,0x00,0x3B
	};

	STATIC UBYTE toc_gif_data[192] =
	{
		0x47,0x49,0x46,0x38,0x37,0x61,0x3F,0x00,0x16,0x00,0xF1,0x00,0x00,0xAA,0xAA,0xAA,
		0x00,0x00,0x00,0xFF,0xFF,0xFF,0x65,0x8A,0xBA,0x2C,0x00,0x00,0x00,0x00,0x3F,0x00,
		0x16,0x00,0x01,0x02,0x99,0x94,0x8F,0xA9,0xCB,0xED,0x1B,0x0C,0x98,0xB4,0xDA,0x8B,
		0xB3,0xDE,0x35,0x44,0xC1,0x85,0xE2,0xA8,0x79,0x12,0x89,0xA6,0x9B,0x09,0xAA,0xEE,
		0x0B,0xB0,0x99,0xE7,0xA5,0x01,0x7A,0x73,0xF2,0x95,0x4F,0xBD,0xF8,0x0B,0x05,0x31,
		0xBB,0x4E,0xA9,0xE6,0x8B,0xE5,0x68,0x3E,0x64,0x4C,0xD9,0x5C,0x0E,0x95,0x27,0x23,
		0x91,0x22,0x4D,0x3E,0xB7,0x5B,0xE4,0x52,0x3B,0x2C,0x62,0x67,0x63,0xEE,0xD7,0xAC,
		0xED,0xA6,0x79,0x1F,0x1E,0x19,0x5C,0x96,0x32,0xD1,0xE6,0xA9,0x78,0x6D,0x55,0xC3,
		0xB9,0x65,0x7D,0x1F,0xDB,0xE6,0x16,0x37,0xB8,0xD7,0x73,0xA6,0x77,0x08,0x58,0x65,
		0x41,0xF3,0x33,0x47,0xE7,0xE5,0x64,0xD8,0x44,0xC9,0xB6,0x08,0x83,0x29,0x14,0x98,
		0xC9,0xB9,0xB2,0xD9,0x09,0xCA,0xF8,0x19,0x4A,0x7A,0x47,0x0A,0x6A,0x7A,0xCA,0x99,
		0xAA,0x8A,0x69,0xD2,0x08,0x1B,0x2B,0x3B,0x4B,0x5B,0x6B,0xEB,0x51,0x00,0x00,0x3B
	};

	STATIC UBYTE toc_d_gif_data[223] =
	{
		0x47,0x49,0x46,0x38,0x37,0x61,0x3F,0x00,0x16,0x00,0xF1,0x00,0x00,0xAA,0xAA,0xAA,
		0x00,0x00,0x00,0xFF,0xFF,0xFF,0x65,0x8A,0xBA,0x2C,0x00,0x00,0x00,0x00,0x3F,0x00,
		0x16,0x00,0x01,0x02,0xB8,0x94,0x8F,0xA9,0xCB,0xED,0x1B,0x4C,0x00,0x74,0x56,0x0A,
		0x6C,0xC6,0xBA,0xF3,0x7F,0x85,0x9B,0x68,0x05,0x91,0x40,0x82,0xE3,0xEA,0xA5,0x2E,
		0xAB,0x9A,0x67,0x0B,0xBF,0xF4,0x1D,0xE7,0xD9,0x69,0xEB,0xF5,0x8F,0xB3,0x99,0x24,
		0x31,0x59,0x90,0x55,0xF2,0x4D,0x96,0xBA,0x21,0x0A,0x79,0x61,0xF6,0x76,0xCA,0x6A,
		0xC5,0xE9,0x91,0x22,0x99,0xCB,0x92,0x69,0x27,0xBB,0x7E,0x8D,0xDD,0x96,0x73,0x4A,
		0x4D,0x7F,0x47,0xE3,0x4D,0x59,0x7D,0x75,0x73,0xB0,0x1F,0xAD,0x37,0xCE,0x85,0x87,
		0xD6,0x6D,0x3E,0xE8,0x0C,0x34,0x17,0x57,0x33,0x66,0xA4,0x96,0x34,0xD8,0x41,0x17,
		0x45,0x78,0x97,0xE7,0xB7,0xE7,0x18,0xB8,0x63,0x40,0x92,0xD4,0x95,0xF8,0xF7,0x78,
		0x18,0x29,0x27,0x46,0x64,0x19,0x26,0x26,0xC7,0x55,0x28,0xCA,0xF7,0x26,0xCA,0xC6,
		0x33,0xD9,0x7A,0xF4,0x5A,0x34,0x63,0xE5,0x3A,0x0B,0x4B,0xF9,0x64,0x4B,0x8B,0xF6,
		0xBA,0xA8,0xEB,0x9B,0x6B,0xC6,0x0A,0x5C,0x4B,0x1C,0x0A,0xFA,0x5B,0x8C,0x7C,0xBB,
		0x9B,0x3C,0x6C,0x4C,0x06,0x1D,0x2D,0x3D,0x4D,0x5D,0x0D,0x5D,0x00,0x00,0x3B
	};

	STATIC struct ImageData ImageDataTable[] =
	{
		"images/help.gif",		help_gif_data,		NUM_ELEMENTS(help_gif_data),
		"images/help_d.gif",	help_d_gif_data,	NUM_ELEMENTS(help_d_gif_data),
		"images/index.gif",		index_gif_data,		NUM_ELEMENTS(index_gif_data),
		"images/index_d.gif",	index_d_gif_data,	NUM_ELEMENTS(index_d_gif_data),
		"images/next.gif",		next_gif_data,		NUM_ELEMENTS(next_gif_data),
		"images/next_d.gif",	next_d_gif_data,	NUM_ELEMENTS(next_d_gif_data),
		"images/prev.gif",		prev_gif_data,		NUM_ELEMENTS(prev_gif_data),
		"images/prev_d.gif",	prev_d_gif_data,	NUM_ELEMENTS(prev_d_gif_data),
		"images/retrace.gif",	retrace_gif_data,	NUM_ELEMENTS(retrace_gif_data),
		"images/retrace_d.gif",	retrace_d_gif_data,	NUM_ELEMENTS(retrace_d_gif_data),
		"images/toc.gif",		toc_gif_data,		NUM_ELEMENTS(toc_gif_data),
		"images/toc_d.gif",		toc_d_gif_data,		NUM_ELEMENTS(toc_d_gif_data)
	};

	ERRORCODE error = OK;
	BPTR newDir;

	PushDir(targetDir);

	newDir = CreateDir("images");
	if(newDir != ZERO)
	{
		UnLock(newDir);
	}
	else
	{
		error = IoErr();
		if(error == ERROR_OBJECT_EXISTS)
			error = OK;
	}

	if(error == OK)
	{
		BPTR fileLock;
		int i;

		for(i = 0 ; error == OK && i < NUM_ELEMENTS(ImageDataTable) ; i++)
		{
			fileLock = Lock(ImageDataTable[i].id_FileName,SHARED_LOCK);
			if(fileLock == ZERO)
			{
				error = IoErr();
				if(error == ERROR_OBJECT_NOT_FOUND)
				{
					error = OK;
				}

				if(error == OK)
				{
					FILE * out;

					UnLock(fileLock);

					out = fopen(ImageDataTable[i].id_FileName,"wb");
					if(out != NULL)
					{
						if(fwrite(ImageDataTable[i].id_Data,ImageDataTable[i].id_Size,1,out) < 0)
						{
							error = -1;
						}
	
						fclose(out);
					}
					else
					{
						error = -1;
					}
				}
			}
			else
			{
				UnLock(fileLock);
			}
		}
	}

	PopDir();

	return(error);
}

/******************************************************************************/

BPTR
PushDir(BPTR dirLock)
{
	if(GlobalLastDir == ZERO)
	{
		GlobalLastDir = CurrentDir(dirLock);
	}

	return(GlobalLastDir);
}

VOID
PopDir(VOID)
{
	if(GlobalLastDir != ZERO)
	{
		CurrentDir(GlobalLastDir);
		GlobalLastDir = ZERO;
	}
}

/******************************************************************************/

STATIC LONG BreakNestCount = 0;

VOID
ForbidBreak(VOID)
{
	if(BreakNestCount++ == 0)
	{
		signal(SIGINT,SIG_IGN);
	}
}

VOID
PermitBreak(VOID)
{
	if(--BreakNestCount == 0)
	{
		signal(SIGINT,SIG_DFL);
	}
}

/******************************************************************************/

VOID
ExitTrap(VOID)
{
	if(GlobalTargetDir != ZERO)
	{
		if(GlobalLastDir != ZERO)
		{
			CurrentDir(GlobalLastDir);
			GlobalLastDir = ZERO;
		}

		UnLock(GlobalTargetDir);
		GlobalTargetDir = ZERO;
	}

	if(GlobalRDArgs != NULL)
	{
		FreeArgs(GlobalRDArgs);
		GlobalRDArgs = NULL;
	}

	if(RDArgs != NULL)
	{
		FreeArgs(RDArgs);
		FreeDosObject(DOS_RDARGS,RDArgs);

		RDArgs = NULL;
	}

	if(Pool != NULL)
	{
		DeletePool(Pool);
		Pool = NULL;
	}
}

/******************************************************************************/

VOID
Initialize(VOID)
{
	atexit(ExitTrap);

	NewList(&DocumentList);

	Pool = CreatePool(MEMF_ANY|MEMF_PUBLIC,4096,4096);
	if(Pool == NULL)
	{
		printf("AG2HTML: Unable to create memory pool.\n");
		exit(RETURN_FAIL);
	}
}

/******************************************************************************/

APTR
AllocVecPooled(LONG bytes,ULONG flags)
{
	APTR result = NULL;

	if(Pool != NULL && bytes > 0)
	{
		ULONG * mem;

		mem = AllocPooled(Pool,sizeof(*mem) + bytes);
		if(mem != NULL)
		{
			(*mem++) = sizeof(*mem) + bytes;

			if(flags & MEMF_CLEAR)
				memset(mem,0,bytes);

			result = mem;
		}
	}

	return(result);
}

VOID
FreeVecPooled(APTR address)
{
	if(address != NULL)
	{
		ULONG * mem = (ULONG *)(((ULONG)address) - sizeof(*mem));

		FreePooled(Pool,mem,(*mem));
	}
}

/******************************************************************************/

VOID
StripBackslashes(STRPTR string)
{
	STRPTR to;
	BOOL hasEscape = FALSE;

	to = string;

	while((*string) != '\0')
	{
		switch((*string))
		{
			case '\\':

				hasEscape ^= TRUE;

				if(NOT hasEscape)
				{
					(*to++) = (*string);
				}

				break;

			default:

				(*to++) = (*string);

				hasEscape = FALSE;

				break;
		}

		string++;
	}

	(*to) = '\0';
}

/******************************************************************************/

BOOL
ParseString(
	const STRPTR	key,
	const STRPTR	params,
	STRPTR *		args,
	const STRPTR	string)
{
	BOOL success = FALSE;

	if(RDArgs != NULL)
	{
		FreeArgs(RDArgs);
	}
	else
	{
		RDArgs = AllocDosObjectTagList(DOS_RDARGS,NULL);
	}

	if(RDArgs != NULL)
	{
		if(params != NULL)
		{
			STATIC UBYTE localString[sizeof(LineBuffer)+1];
			STRPTR skip;

			skip = string + strlen(key);
	
			while((*skip) == ' ')
				skip++;
	
			strcpy(localString,skip);
			strcat(localString,"\n");
	
			RDArgs->RDA_Source.CS_Buffer	= localString;
			RDArgs->RDA_Source.CS_Length	= strlen(RDArgs->RDA_Source.CS_Buffer);
			RDArgs->RDA_Source.CS_CurChr	= 0;
			RDArgs->RDA_Flags				= RDAF_NOPROMPT;
	
			if(ReadArgs((STRPTR)params,(LONG *)args,RDArgs))
			{
				success = TRUE;
			}
		}
		else
		{
			success = TRUE;
		}
	}

	return(success);
}

BOOL
ParseAndTrashString(
	const STRPTR	params,
	STRPTR *		args,
	STRPTR			string)
{
	BOOL success = FALSE;

	if(RDArgs != NULL)
	{
		FreeArgs(RDArgs);
	}
	else
	{
		RDArgs = AllocDosObjectTagList(DOS_RDARGS,NULL);
	}

	if(RDArgs != NULL)
	{
		strcat(string,"\n");
	
		RDArgs->RDA_Source.CS_Buffer	= string;
		RDArgs->RDA_Source.CS_Length	= strlen(RDArgs->RDA_Source.CS_Buffer);
		RDArgs->RDA_Source.CS_CurChr	= 0;
		RDArgs->RDA_Flags				= RDAF_NOPROMPT;
	
		if(ReadArgs((STRPTR)params,(LONG *)args,RDArgs))
		{
			success = TRUE;
		}
	}

	return(success);
}

/******************************************************************************/

struct Node *
FindIName(const struct List * lh,const STRPTR name)
{
	struct Node * result = NULL;
	struct Node * node;

	for(node = lh->lh_Head ;
	    node->ln_Succ != NULL ;
	    node = node->ln_Succ)
	{
		if(Stricmp(node->ln_Name,(STRPTR)name) == SAME)
		{
			result = node;
			break;
		}
	}

	return(result);
}

VOID
MoveList(struct List * from,struct List * to)
{
	struct Node * node;
	struct Node * next;

	for(node = from->lh_Head ;
	   (next = node->ln_Succ) != NULL ;
	    node = next)
	{
		AddTail(to,node);
	}

	NewList(from);
}

/******************************************************************************/

LONG
Compare(const STRPTR a,const STRPTR b,LONG len)
{
	LONG result;

	if(len == -1)
	{
		result = Strnicmp(a,b,strlen(b));
	}
	else
	{
		result = Strnicmp(a,b,len);
	}

	return(result);
}

/******************************************************************************/

VOID
StrcpyN(LONG MaxLen,STRPTR To,const STRPTR From)
{
	if(MaxLen > 0)
	{
		LONG Len = strlen(From);

		if(Len >= MaxLen)
			Len = MaxLen - 1;

		strncpy(To,From,Len);
		To[Len] = '\0';
	}
}

/******************************************************************************/

STRPTR
CopyString(const STRPTR string)
{
	STRPTR result;

	result = AllocVecPooled(strlen(string)+1,MEMF_ANY);
	if(result != NULL)
	{
		strcpy(result,string);
	}

	return(result);
}

/******************************************************************************/

LONG
MeasureCommandLen(const STRPTR buffer)
{
	BOOL inEscape = FALSE;
	BOOL inQuote = FALSE;
	LONG result;
	LONG len;
	LONG i;

	len = strlen(buffer);

	result = len;

	for(i = 2 ; i < len ; i++)
	{
		if(buffer[i] == '\\')
		{
			inEscape ^= TRUE;
		}
		else
		{
			if(NOT inEscape && NOT inQuote && buffer[i] == CLOSE_BRACE)
			{
				result = i;
				break;
			}

			if(buffer[i] == '\"')
			{
				inQuote ^= TRUE;
			}

			inEscape = FALSE;
		}
	}

	return(result);
}

/******************************************************************************/

ERRORCODE
AssignNodeNumbers(VOID)
{
	struct DocumentNode * dn;
	ERRORCODE error = OK;
	ULONG picNumber = 0;

	for(dn = (struct DocumentNode *)DocumentList.lh_Head ;
	    (error == OK) && (dn->dn_Node.ln_Succ != NULL) ;
	    dn = (struct DocumentNode *)dn->dn_Node.ln_Succ)
	{
		struct AmigaGuideNode * an;
		ULONG number = 0;
		
		if(dn->dn_IsPicture)
			dn->dn_PicNumber = ++picNumber;

		for(an = (struct AmigaGuideNode *)dn->dn_NodeList.lh_Head ;
		    an->an_Node.ln_Succ != NULL ;
		    an = (struct AmigaGuideNode *)an->an_Node.ln_Succ)
		{
			an->an_Number = number++;

			/* drop circular links; this kind of trouble is quite common
			 * in the RKM text which in the index files has most of the
			 * @next/@prev commands point back to the nodes they are
			 * declared in
			 */
			if(an->an_NextLink != NULL && an->an_NextLink->gn_GuideNode == an)
			{
				an->an_NextLink = NULL;
			}

			if(an->an_PrevLink != NULL && an->an_PrevLink->gn_GuideNode == an)
			{
				an->an_PrevLink = NULL;
			}

			if(an->an_Next == NULL && an->an_Node.ln_Succ->ln_Succ != NULL)
			{
				an->an_NextLink = AllocVecPooled(sizeof(*an->an_NextLink),MEMF_CLEAR);
				if(an->an_NextLink != NULL)
				{
					an->an_NextLink->gn_GuideNode = (struct AmigaGuideNode *)an->an_Node.ln_Succ;
				}
				else
				{
					error = ERROR_NO_FREE_STORE;
					break;
				}
			}

			if(an->an_Prev == NULL && an->an_Node.ln_Pred->ln_Pred != NULL)
			{
				an->an_PrevLink = AllocVecPooled(sizeof(*an->an_NextLink),MEMF_CLEAR);
				if(an->an_PrevLink != NULL)
				{
					an->an_PrevLink->gn_GuideNode = (struct AmigaGuideNode *)an->an_Node.ln_Pred;
				}
				else
				{
					error = ERROR_NO_FREE_STORE;
					break;
				}
			}
		}
	}

	return(error);
}

ERRORCODE
AssignNameTemplates(VOID)
{
	UBYTE baseNameBuffer[MAX_PATHNAME_LEN];
	UBYTE localBuffer[MAX_PATHNAME_LEN];
	struct DocumentNode * dn;
	ERRORCODE error = OK;

	for(dn = (struct DocumentNode *)DocumentList.lh_Head ;
	    (error == OK) && (dn->dn_Node.ln_Succ != NULL) ;
	    dn = (struct DocumentNode *)dn->dn_Node.ln_Succ)
	{
		int len;
		int i;

		StrcpyN(sizeof(baseNameBuffer),baseNameBuffer,FilePart(dn->dn_MasterFile));

		for(i = strlen(baseNameBuffer)-1 ; i >= 0 ; i--)
		{
			if((baseNameBuffer[i] == '.') && (Stricmp(&baseNameBuffer[i],".guide") == SAME))
			{
				baseNameBuffer[i] = '\0';
			}
		}



		strcpy(localBuffer,baseNameBuffer);

		len = strlen(localBuffer);
		if(len + strlen(".html") > MAX_FILENAME_LEN)
		{
			len = MAX_FILENAME_LEN - strlen(".html");

			localBuffer[len] = '\0';
		}

		strcat(localBuffer,".html");
		dn->dn_MasterFile = CopyString(localBuffer);



		strcpy(localBuffer,baseNameBuffer);

		len = strlen(localBuffer);
		if(len + strlen("_guide") > MAX_FILENAME_LEN)
		{
			len = MAX_FILENAME_LEN - strlen("_guide");

			localBuffer[len] = '\0';
		}

		strcat(localBuffer,"_guide/node%04X.html");

		dn->dn_MasterTemplate = CopyString(localBuffer);
		if(dn->dn_MasterFile == NULL || dn->dn_MasterTemplate == NULL)
		{
			error = ERROR_NO_FREE_STORE;
		}
	}

	return(error);
}

/******************************************************************************/

VOID
EncodeToHTML(
	LONG			maxLen,
	STRPTR			buffer,
	const STRPTR	constSource)
{
	STATIC UBYTE mustEncode[256];
	STATIC BOOL tableReady = FALSE;

	/* set up the encoding table; every character that gets
	 * marked for encoding will be translated into the typical
	 * HTML decimal Latin 1 encoding sequence
	 */
	if(NOT tableReady)
	{
		STATIC const STRPTR specialChars = "<>&\"";
		int i;

		for(i = 0 ; i < strlen(specialChars) ; i++)
		{
			mustEncode[specialChars[i]] = TRUE;
		}

		for(i = 127 ; i < 256 ; i++)
		{
			mustEncode[i] = TRUE;
		}

		tableReady = TRUE;
	}

	if(maxLen > 1)
	{
		STRPTR source = (STRPTR)constSource;

		maxLen--;

		while(maxLen > 0 && (*source) != '\0')
		{
			if((*source) >= '\t')
			{
				if(mustEncode[(*source)])
				{
					UBYTE encoding[8];
					int len;

					sprintf(encoding,"&#%03d;",(*source));
					len = strlen(encoding);

					if(len <= maxLen)
					{
						strncpy(buffer,encoding,len);

						buffer += len;
						maxLen -= len;
					}
					else
					{
						break;
					}
				}
				else
				{
					(*buffer++) = (*source);
					maxLen--;
				}
			}

			source++;
		}

		(*buffer) = '\0';
	}
}

/******************************************************************************/

VOID
EncodeToURL(
	LONG			maxLen,
	STRPTR			buffer,
	const STRPTR	format,
					...)
{
	STATIC UBYTE mustEncode[256];
	STATIC BOOL tableReady = FALSE;
	UBYTE localBuffer[MAX_PATHNAME_LEN*2];
	va_list varArgs;

	va_start(varArgs,format);
	vsprintf(localBuffer,format,varArgs);
	va_end(varArgs);

	/* set up the encoding table; every character that gets
	 * marked for encoding will be translated into the typical
	 * URL encoding sequence
	 */
	if(NOT tableReady)
	{
		/* never translate the slash; names submitted to this routine
		 * will always use the slash correctly
		 */
		STATIC const STRPTR normalChars = "$-_.+!*'()/";
		int i;

		memset(mustEncode,TRUE,sizeof(mustEncode));

		for(i = 0 ; i < strlen(normalChars) ; i++)
		{
			mustEncode[normalChars[i]] = FALSE;
		}

		for(i = 'a' ; i <= 'z' ; i++)
		{
			mustEncode[i] = FALSE;
		}

		for(i = 'A' ; i <= 'Z' ; i++)
		{
			mustEncode[i] = FALSE;
		}

		for(i = '0' ; i <= '9' ; i++)
		{
			mustEncode[i] = FALSE;
		}

		tableReady = TRUE;
	}

	if(maxLen > 1)
	{
		STRPTR source = (STRPTR)localBuffer;

		maxLen--;

		while(maxLen > 0 && (*source) != '\0')
		{
			if((*source) >= '\t')
			{
				if(mustEncode[(*source)])
				{
					UBYTE encoding[8];
					int len;

					sprintf(encoding,"%%%02X",(*source));
					len = strlen(encoding);

					if(len <= maxLen)
					{
						strncpy(buffer,encoding,len);

						buffer += len;
						maxLen -= len;
					}
					else
					{
						break;
					}
				}
				else
				{
					(*buffer++) = (*source);
					maxLen--;
				}
			}

			source++;
		}

		(*buffer) = '\0';
	}
}

/******************************************************************************/

ERRORCODE
WriteHTMLHeader(
	FILE *							out,
	const struct AmigaGuideNode *	an,
	const STRPTR					title,
	const struct GuideLinkNode *	toc,
	const struct GuideLinkNode *	index,
	const struct GuideLinkNode *	prev,
	const struct GuideLinkNode *	next,
	BOOL							wordWrap,
	BOOL							isTopNode)
{
	UBYTE localBuffer[MAX_PATHNAME_LEN];
	ERRORCODE error = OK;
	STRPTR parent;

	if(isTopNode)
	{
		parent = "";
	}
	else
	{
		parent = "../";
	}

	if(fprintf(out,"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2 Final//EN\">\n<HTML>\n") < 0)
	{
		fprintf(stderr,"Error writing doctype tag.\n");
		error = -1;
	}

	if(error == OK && isTopNode)
	{
		if(fprintf(out,"<!-- Automatically generated from AmigaGuide documentation with %s (%s), written by Olaf Barthel <olsen@sourcery.han.de> -->\n",VERS,DATE) < 0)
		{
			fprintf(stderr,"Error writing comment tag.\n");
			error = -1;
		}
	}

	if(error == OK)
	{
		if(fprintf(out,"<!-- AG2HTML: CONVERTER=AG2HTML/%s FORMAT=AMIGAGUIDE/%s FILE=\"%s\" NODE=\"%s\"",FormatVersion,IsAmigaGuideV39 ? "39.2" : "34.11",an->an_Document->dn_Node.ln_Name,an->an_Node.ln_Name) < 0)
		{
			error = -1;
		}

		if(error == OK && an->an_Node.ln_Name != (char *)an->an_Title)
		{
			if(Stricmp(an->an_Node.ln_Name,an->an_Title) != SAME)
			{
				if(fprintf(out," TITLE=\"%s\"",an->an_Title) < 0)
					error = -1;
			}
		}

		if(error == OK && an->an_TOC != NULL)
		{
			if(fprintf(out," TOC=\"%s\"",an->an_TOC) < 0)
				error = -1;
		}

		if(error == OK && an->an_Index != NULL)
		{
			if(fprintf(out," INDEX=\"%s\"",an->an_Index) < 0)
				error = -1;
		}

		if(error == OK && an->an_Next != NULL)
		{
			if(fprintf(out," NEXT=\"%s\"",an->an_Next) < 0)
				error = -1;
		}

		if(error == OK && an->an_Prev != NULL)
		{
			if(fprintf(out," PREV=\"%s\"",an->an_Prev) < 0)
				error = -1;
		}

		if(error == OK && an->an_Document->dn_IsPicture)
		{
			UBYTE localBuffer[MAX_PATHNAME_LEN];
			int i;

			sprintf(localBuffer,an->an_Document->dn_MasterTemplate,an->an_Number);

			for(i = strlen(localBuffer)-1 ; i >= 0 ; i--)
			{
				if(localBuffer[i] == '.')
				{
					strcpy(&localBuffer[i],".gif");
					break;
				}
			}

			if(fprintf(out," PICTURE=\"%s\"",localBuffer) < 0)
				error = -1;
		}

		if(error == OK && fprintf(out," -->\n") < 0)
		{
			error = -1;
		}

		if(error != OK)
		{
			fprintf(stderr,"Error writing comment tag.\n");
		}
	}

	if(title != NULL)
	{
		EncodeToHTML(sizeof(LineTranslationBuffer),LineTranslationBuffer,title);

		if(error == OK && fprintf(out,"<head>\n<title>%s</title>\n</head>\n",LineTranslationBuffer) < 0)
		{
			fprintf(stderr,"Error writing head tag.\n");
			error = -1;
		}
	}

	if(error == OK && fprintf(out,"<body%s>\n",IsAmigaGuideV39 ? " text=\"#000000\" bgcolor=\"#AAAAAA\"" : "") < 0)
	{
		fprintf(stderr,"Error writing body tag.\n");
		error = -1;
	}

	if(toc != NULL)
	{
		sprintf(localBuffer,toc->gn_GuideNode->an_Document->dn_MasterTemplate,toc->gn_GuideNode->an_Number);

		EncodeToURL(sizeof(URLTranslationBuffer),URLTranslationBuffer,"%s%s",parent,localBuffer);

		if(error == OK && fprintf(out,"<a href=\"%s\"><img src=\"%simages/toc.gif\" alt=\"[Contents]\" border=0></a>\n",URLTranslationBuffer,parent) < 0)
		{
			fprintf(stderr,"Error writing toc tag.\n");
			error = -1;
		}
	}
	else
	{
		if(error == OK && fprintf(out,"<img src=\"%simages/toc_d.gif\" alt=\"[Contents]\">\n",parent) < 0)
		{
			fprintf(stderr,"Error writing toc tag.\n");
			error = -1;
		}
	}

	if(index != NULL)
	{
		sprintf(localBuffer,index->gn_GuideNode->an_Document->dn_MasterTemplate,index->gn_GuideNode->an_Number);

		EncodeToURL(sizeof(URLTranslationBuffer),URLTranslationBuffer,"%s%s",parent,localBuffer);

		if(error == OK && fprintf(out,"<a href=\"%s\"><img src=\"%simages/index.gif\" alt=\"[Index]\" border=0></a>\n",URLTranslationBuffer,parent) < 0)
		{
			fprintf(stderr,"Error writing index tag.\n");
			error = -1;
		}
	}
	else
	{
		if(error == OK && fprintf(out,"<img src=\"%simages/index_d.gif\" alt=\"[Index]\">\n",parent) < 0)
		{
			fprintf(stderr,"Error writing index tag.\n");
			error = -1;
		}
	}

	if(error == OK && fprintf(out,"<img src=\"%simages/help_d.gif\" alt=\"[Help]\">\n",parent) < 0)
	{
		fprintf(stderr,"Error writing help tag.\n");
		error = -1;
	}

	if(error == OK && fprintf(out,"<img src=\"%simages/retrace_d.gif\" alt=\"[Retrace]\">\n",parent) < 0)
	{
		fprintf(stderr,"Error writing retrace tag.\n");
		error = -1;
	}

	if(prev != NULL)
	{
		sprintf(localBuffer,prev->gn_GuideNode->an_Document->dn_MasterTemplate,prev->gn_GuideNode->an_Number);

		EncodeToURL(sizeof(URLTranslationBuffer),URLTranslationBuffer,"%s%s",parent,localBuffer);

		if(error == OK && fprintf(out,"<a href=\"%s\"><img src=\"%simages/prev.gif\" alt=\"[Browse &#060;]\" border=0></a>\n",URLTranslationBuffer,parent) < 0)
		{
			fprintf(stderr,"Error writing prev tag.\n");
			error = -1;
		}
	}
	else
	{
		if(error == OK && fprintf(out,"<img src=\"%simages/prev_d.gif\" alt=\"[Browse &#060;]\">\n",parent) < 0)
		{
			fprintf(stderr,"Error writing prev tag.\n");
			error = -1;
		}
	}

	if(next != NULL)
	{
		sprintf(localBuffer,next->gn_GuideNode->an_Document->dn_MasterTemplate,next->gn_GuideNode->an_Number);

		EncodeToURL(sizeof(URLTranslationBuffer),URLTranslationBuffer,"%s%s",parent,localBuffer);

		if(error == OK && fprintf(out,"<a href=\"%s\"><img src=\"%simages/next.gif\" alt=\"[Browse &#062;]\" border=0></a>\n",URLTranslationBuffer,parent) < 0)
		{
			fprintf(stderr,"Error writing next tag.\n");
			error = -1;
		}
	}
	else
	{
		if(error == OK && fprintf(out,"<img src=\"%simages/next_d.gif\" alt=\"[Browse &#062;]\">\n",parent) < 0)
		{
			fprintf(stderr,"Error writing next tag.\n");
			error = -1;
		}
	}

	if(error == OK && fprintf(out,"<hr>\n") < 0)
	{
		fprintf(stderr,"Error writing rule tag.\n");
		error = -1;
	}

	if(error == OK && NOT wordWrap)
	{
		if(error == OK && fprintf(out,"<pre>\n") < 0)
		{
			fprintf(stderr,"Error writing pre tag.\n");
			error = -1;
		}
	}

	if(error == OK)
	{
		if(fprintf(out,"<!-- AG2HTML: BODY=START -->\n") < 0)
		{
			fprintf(stderr,"Error writing start comment tag.\n");
			error = -1;
		}
	}

	return(error);
}

ERRORCODE
WriteHTMLFooter(
	FILE *	out,
	BOOL	wordWrap)
{
	ERRORCODE error = OK;

	if(fprintf(out,"<!-- AG2HTML: BODY=END -->\n") < 0)
	{
		fprintf(stderr,"Error writing end comment tag.\n");
		error = -1;
	}

	if(error == OK && NO wordWrap)
	{
		if(fprintf(out,"</pre>\n") < 0)
		{
			fprintf(stderr,"Error footer tags.\n");
			error = -1;
		}
	}

	if(error == OK)
	{
		if(fprintf(out,"</body>\n</html>\n") < 0)
		{
			fprintf(stderr,"Error footer tags.\n");
			error = -1;
		}
	}

	return(error);
}

/******************************************************************************/

ERRORCODE
WriteLines(
	FILE *			out,
	struct List *	lh,
	BOOL			isTopNode,
	BOOL			isAmigaGuide,
	BOOL			wordWrap)
{
	ERRORCODE error = OK;
	struct LineNode * ln;
	LONG lineNumber;
	STRPTR parent;
	BOOL isFirstLine;

	if(isTopNode)
	{
		parent = "";
	}
	else
	{
		parent = "../";
	}

	isFirstLine = TRUE;

	for(ln = (struct LineNode *)lh->lh_Head, lineNumber = 1 ;
	    (error == OK) && (ln->ln_Node.ln_Succ != NULL) ;
	    ln = (struct LineNode *)ln->ln_Node.ln_Succ, lineNumber++)
	{
		if(wordWrap)
		{
			UBYTE c = (UBYTE)ln->ln_Node.ln_Name[0];

			if((c == ' ' || c == 160 || c == '\t') && (NOT isFirstLine))
			{
				STRPTR head;

				if(fprintf(out,"<br>") < 0)
				{
					fprintf(stderr,"Error writing line break tag.\n");
					error = -1;
				}

				head = (STRPTR)ln->ln_Node.ln_Name;
				while((*head) == ' ' || (*head) == 160)
				{
					(*head++) = 160;
				}
			}
		}

		if(error == OK && ln->ln_NeedsAnchor)
		{
			if(fprintf(out,"<a name=\"line%ld\">",lineNumber) < 0)
			{
				fprintf(stderr,"Error line anchor.\n");
				error = -1;
			}
		}

		/* special case: lines to ignore will be skipped */
		if(ln->ln_Node.ln_Name[0] == '\a' && ln->ln_Len == 1)
		{
			continue;
		}

		isFirstLine = FALSE;

		if(error == OK)
		{
			if(ln->ln_HasCommands)
			{
				struct GuideLinkNode * gn;
				STRPTR buffer;
				int i,len;

				gn = (struct GuideLinkNode *)ln->ln_Commands.lh_Head;

				len = 0;

				buffer = ln->ln_Node.ln_Name;

				for(i = 0 ; (error == OK) && (i < ln->ln_Len) ; i++)
				{
					if(gn != NULL && gn->gn_Command == &buffer[i])
					{
						/* flush the old buffer */
						if(len > 0)
						{
							LineBuffer[len] = '\0';

							if(isAmigaGuide)
								StripBackslashes(LineBuffer);

							EncodeToHTML(sizeof(LineTranslationBuffer),LineTranslationBuffer,LineBuffer);

							if(fprintf(out,"%s",LineTranslationBuffer) < 0)
							{
								fprintf(stderr,"Error writing line text.\n");
								error = -1;
							}

							len = 0;
						}

						if(error == OK)
						{
							STRPTR start = NULL;
							STRPTR stop = NULL;
							int j;

							for(j = i ; j < i+gn->gn_CommandLen ; j++)
							{
								if(buffer[j] == '\"')
								{
									if(start == NULL)
									{
										start = &buffer[j+1];
									}
									else if(stop == NULL)
									{
										stop = &buffer[j-1];
										break;
									}
								}
							}

							if(start != NULL && stop != NULL && start < stop)
							{
								ULONG len = ((ULONG)stop - (ULONG)start) + 1;
								STRPTR finalLineBuffer;
								int frontSpaces = 0;
								int backSpaces = 0;
								int k;

								strncpy(LineBuffer,start,len);
								LineBuffer[len] = '\0';

								if(isAmigaGuide)
									StripBackslashes(LineBuffer);

								finalLineBuffer = LineBuffer;
								while((*finalLineBuffer) == ' ')
								{
									frontSpaces++;

									finalLineBuffer++;
								}

								for(k = strlen(finalLineBuffer) - 1 ; k >= 0 ; k--)
								{
									if(finalLineBuffer[k] == ' ')
									{
										finalLineBuffer[k] = '\0';
										backSpaces++;
									}
									else
									{
										break;
									}
								}

								if(finalLineBuffer[0] == '\0')
								{
									if(frontSpaces > 0)
										frontSpaces--;
									else if (backSpaces > 0)
										backSpaces--;

									strcpy(finalLineBuffer," ");
								}

								EncodeToHTML(sizeof(LineTranslationBuffer),LineTranslationBuffer,finalLineBuffer);

								for(k = 0 ; (error == OK) && (k < frontSpaces) ; k++)
								{
									if(fprintf(out," ") < 0)
									{
										fprintf(stderr,"Error writing href tag.\n");
										error = -1;
									}
								}

								if(error == OK)
								{
									if(gn->gn_GuideNode != NULL)
									{
										UBYTE localBuffer[MAX_PATHNAME_LEN];
	
										sprintf(localBuffer,gn->gn_GuideNode->an_Document->dn_MasterTemplate,gn->gn_GuideNode->an_Number);
	
										if(gn->gn_Line != NULL)
										{
											EncodeToURL(sizeof(URLTranslationBuffer),URLTranslationBuffer,"%s%s",parent,localBuffer);
		
											if(fprintf(out,"<a href=\"%s#line%ld\">%s</a>",URLTranslationBuffer,gn->gn_LineNumber,LineTranslationBuffer) < 0)
											{
												fprintf(stderr,"Error writing href tag.\n");
												error = -1;
											}
										}
										else
										{
											EncodeToURL(sizeof(URLTranslationBuffer),URLTranslationBuffer,"%s%s",parent,localBuffer);
		
											if(fprintf(out,"<a href=\"%s\">%s</a>",URLTranslationBuffer,LineTranslationBuffer) < 0)
											{
												fprintf(stderr,"Error writing href tag.\n");
												error = -1;
											}
										}
									}
									else
									{
										if(fprintf(out,"%s",LineTranslationBuffer) < 0)
										{
											fprintf(stderr,"Error writing line buffer.\n");
											error = -1;
										}
									}
								}

								for(k = 0 ; (error == OK) && (k < backSpaces) ; k++)
								{
									if(fprintf(out," ") < 0)
									{
										fprintf(stderr,"Error writing href tag.\n");
										error = -1;
									}
								}
							}
							else
							{
								start = NULL;

								for(j = i+2 ; j < i+gn->gn_CommandLen ; j++)
								{
									if(buffer[j] != ' ')
									{
										start = &buffer[j];
										break;
									}
								}

								if(start != NULL)
								{
									enum AGV34CMD k;

									for(k = 0 ; k < NUM_ELEMENTS(v39Commands) ; k++)
									{
										if(Strnicmp(start,v39Commands[k],strlen(v39Commands[k])) == SAME)
										{
											STATIC const STRPTR colourNames[][2] =
											{
												"text",			"#000000",	/* black */
												"shine",		"#FFFFFF",	/* white */
												"shadow",		"#000000",	/* black */
												"filltext",		"#000000",	/* black */
												"fill",			"#6688BB",	/* baby blue */
											//	"background",	"#AAAAAA",	/* gray */
											//	"back",			"#AAAAAA",	/* gray */
												"highlight",	"#FFFFFF",	/* white */

												NULL						/* terminator */
											};

											UBYTE localBuffer[80];
											STRPTR cmd = NULL;
											STRPTR colour;
											int m;

											switch(k)
											{
												case AGV34CMD_Bold:

													cmd = "<b>";
													break;

												case AGV34CMD_UnBold:

													cmd = "</b>";
													break;

												case AGV34CMD_Italic:

													cmd = "<i>";
													break;

												case AGV34CMD_UnItalic:

													cmd = "</i>";
													break;

												case AGV34CMD_Underline:

													cmd = "<u>";
													break;

												case AGV34CMD_UnUnderline:

													cmd = "</u>";
													break;

												case AGV34CMD_Foreground:

													colour = NULL;

													for(m = 3 ; m < gn->gn_CommandLen ; m++)
													{
														if(start[m] != ' ')
														{
															colour = &start[m];
															break;
														}
													}

													if(colour != NULL)
													{
														for(m = 0 ; colourNames[m][0] != NULL ; m++)
														{
															if(Strnicmp(colour,colourNames[m][0],strlen(colourNames[m][0])) == SAME)
															{
																sprintf(localBuffer,"<font color=\"%s\">",colourNames[m][1]);
																cmd = localBuffer;
																break;
															}
														}
													}

													break;

												case AGV34CMD_Background:

													/* there is no HTML command for changing the background colour */
													break;
											}

											if(cmd != NULL)
											{
												if(fprintf(out,"%s",cmd) < 0)
												{
													fprintf(stderr,"Error writing text attribute.\n");
													error = -1;
												}
											}

											break;
										}
									}
								}
							}

							/* one less than the entire command length
							 * since the for(..) loop will increment
							 * the position by one.
							 */
							i += gn->gn_CommandLen;	/* ZZZ does this really work? */
						}

						if(gn->gn_MinNode.mln_Succ->mln_Succ != NULL)
						{
							gn = (struct GuideLinkNode *)gn->gn_MinNode.mln_Succ;
						}
						else
						{
							gn = NULL;
						}
					}
					else
					{
						LineBuffer[len++] = buffer[i];
					}
				}

				if(error == OK && len > 0)
				{
					LineBuffer[len] = '\0';

					if(isAmigaGuide)
						StripBackslashes(LineBuffer);

					EncodeToHTML(sizeof(LineTranslationBuffer),LineTranslationBuffer,LineBuffer);

					if(fprintf(out,"%s",LineTranslationBuffer) < 0)
					{
						fprintf(stderr,"Error writing line buffer.\n");
						error = -1;
					}
				}
			}
			else
			{
				if(isAmigaGuide)
					StripBackslashes(ln->ln_Node.ln_Name);

				EncodeToHTML(sizeof(LineTranslationBuffer),LineTranslationBuffer,ln->ln_Node.ln_Name);

				if(fprintf(out,"%s",LineTranslationBuffer) < 0)
				{
					fprintf(stderr,"Error writing line buffer.\n");
					error = -1;
				}
			}
		}

		if(error == OK && wordWrap && ln->ln_Len == 0)
		{
			if(fprintf(out,"<p>") < 0)
			{
				fprintf(stderr,"Error writing line terminator.\n");
				error = -1;
			}
		}

		if(error == OK)
		{
			STRPTR terminator;

			if(ln->ln_NeedsAnchor)
				terminator = "</a>\n";
			else
				terminator = "\n";

			if(fprintf(out,terminator) < 0)
			{
				fprintf(stderr,"Error writing line terminator.\n");
				error = -1;
			}
		}
	}

	return(error);
}

ERRORCODE
ConvertFile(struct DocumentNode * dn,BPTR targetDir)
{
	UBYTE localBuffer[MAX_PATHNAME_LEN];
	STRPTR path;
	ERRORCODE error = OK;
	struct AmigaGuideNode * an;
	FILE * out;
	BOOL isTopNode;
	char * name;
	LONG numNodes;
	LONG nodesSoFar;
	LONG percent;
	LONG lastPercent;
	BOOL thisIsMain;
	BOOL copiedMain;
	int i;

	strcpy(localBuffer,dn->dn_MasterTemplate);
	path = PathPart(localBuffer);
	(*path) = '\0';

	numNodes = 0;

	for(an = (struct AmigaGuideNode *)dn->dn_NodeList.lh_Head ;
	    an->an_Node.ln_Succ != NULL ;
	    an = (struct AmigaGuideNode *)an->an_Node.ln_Succ)
	{
		numNodes++;
	}

	PushDir(targetDir);

	UnLock(CreateDir(localBuffer));

	PopDir();
	
	nodesSoFar = 0;
	lastPercent = -1;

	copiedMain = FALSE;

	an = (struct AmigaGuideNode *)dn->dn_NodeList.lh_Head;

	while((error == OK) && (an->an_Node.ln_Succ != NULL))
	{
		PushDir(targetDir);

		if(NOT an->an_Document->dn_Done && Stricmp(an->an_Node.ln_Name,"MAIN") == SAME && NOT copiedMain)
		{
			out = fopen(name = dn->dn_MasterFile,"wb");
			isTopNode = TRUE;

			thisIsMain = TRUE;
		}
		else
		{
			sprintf(localBuffer,dn->dn_MasterTemplate,an->an_Number);
			out = fopen(name = localBuffer,"wb");
			isTopNode = FALSE;

			thisIsMain = FALSE;
		}

		PopDir();

		if(out != NULL)
		{
			error = WriteHTMLHeader(out,
				an,
				an->an_Title,
				an->an_TOCLink,
				an->an_IndexLink,
				an->an_PrevLink,
				an->an_NextLink,
				an->an_Document->dn_WordWrap,
				isTopNode);

			if(error == OK)
			{
				if(an->an_Document->dn_IsPicture)
				{
					extern BOOL ConvertPicture(BPTR fromDir,STRPTR from,STRPTR to,int *pWidth,int *pHeight);

					int width,height;
					BPTR oldDir;

					sprintf(localBuffer,dn->dn_MasterTemplate,an->an_Number);

					for(i = strlen(localBuffer)-1 ; i >= 0 ; i--)
					{
						if(localBuffer[i] == '.')
						{
							strcpy(&localBuffer[i],".gif");
							break;
						}
					}

					ForbidBreak();

					oldDir = PushDir(targetDir);

					if(ConvertPicture(oldDir,an->an_Document->dn_Node.ln_Name,localBuffer,&width,&height))
					{
						STRPTR parent;

						if(isTopNode)
							parent = "";
						else
							parent = "../";

						if(fprintf(out,"<img src=\"%s%s\" width=%d height=%d border=1 alt=\"Illustration #%ld\">\n",parent,localBuffer,width,height,an->an_Document->dn_PicNumber) < 0)
						{
							fprintf(stderr,"Error writing image tag.\n");
							error = -1;
						}
					}
					else
					{
						fprintf(stderr,"Error converting picture \"%s\".\n",an->an_Document->dn_Node.ln_Name);
						error = -1;
					}

					PopDir();

					PermitBreak();
				}
				else
				{
					struct LineNode * ln;

					/* strip heading blank lines */
					while(NOT IsListEmpty(&an->an_Lines))
					{
						ln = (struct LineNode *)an->an_Lines.lh_Head;
						if(ln->ln_Len == 0)
						{
							RemHead(&an->an_Lines);
						}
						else
						{
							break;
						}
					}

					/* strip trailing blank lines */
					while(NOT IsListEmpty(&an->an_Lines))
					{
						ln = (struct LineNode *)an->an_Lines.lh_TailPred;
						if(ln->ln_Len == 0)
						{
							RemTail(&an->an_Lines);
						}
						else
						{
							break;
						}
					}

					error = WriteLines(out,&an->an_Lines,isTopNode,an->an_Document->dn_IsAmigaGuide,an->an_Document->dn_WordWrap);
				}
			}

			if(error == OK)
			{
				error = WriteHTMLFooter(out,an->an_Document->dn_WordWrap);
			}

			fclose(out);
		}
		else
		{
			fprintf(stderr,"Error opening file \"%s\".\n",name);
			error = -1;
		}

		if(NOT thisIsMain)
		{
			nodesSoFar++;

			if(error == OK)
			{
				percent = (100 * nodesSoFar) / numNodes;
				if(lastPercent != percent)
				{
					printf(" (%d%% done)\r",percent);
					fflush(stdout);
					lastPercent = percent;
				}
			}

			an = (struct AmigaGuideNode *)an->an_Node.ln_Succ;
		}
		else
		{
			copiedMain = TRUE;
		}
	}

	if(lastPercent != -1)
	{
		printf("\n");
	}

	return(error);
}

/******************************************************************************/

ERRORCODE
FindLink(
	const STRPTR			linkName,
	struct DocumentNode *	thisDn,
	LONG					linkLine,
	struct GuideLinkNode *	gn)
{
	UBYTE fileName[MAX_PATHNAME_LEN];
	STRPTR nodeName;
	STRPTR path;
	struct DocumentNode * dn;
	BOOL found = FALSE;
	ERRORCODE error = OK;

	StrcpyN(sizeof(fileName),fileName,linkName);
	path = PathPart(fileName);
	(*path) = '\0';

	nodeName = FilePart(linkName);

	for(dn = (struct DocumentNode *)DocumentList.lh_Head ;
	    (error == OK) && (dn->dn_Node.ln_Succ != NULL) ;
	    dn = (struct DocumentNode *)dn->dn_Node.ln_Succ)
	{
		if((thisDn == dn && Stricmp(nodeName,"MAIN") != SAME) || (Stricmp(dn->dn_Node.ln_Name,fileName) == SAME))
		{
			struct AmigaGuideNode * an;
		
			for(an = (struct AmigaGuideNode *)dn->dn_NodeList.lh_Head ;
			    (error == OK) && (an->an_Node.ln_Succ != NULL) ;
			    an = (struct AmigaGuideNode *)an->an_Node.ln_Succ)
			{
				if(Stricmp(an->an_Node.ln_Name,nodeName) == SAME)
				{
					gn->gn_GuideNode = an;

					if(linkLine > 1)
					{
						struct Node * node;
						LONG whichLine;

						for(node = (struct Node *)an->an_Lines.lh_Head, whichLine = 1;
						    node->ln_Succ != NULL ;
						    node = node->ln_Succ, whichLine++)
						{
							if(whichLine == linkLine)
							{
								gn->gn_Line = (struct LineNode *)node;
								gn->gn_Line->ln_NeedsAnchor = TRUE;
								gn->gn_LineNumber = whichLine;

								break;
							}
						}
					}

					found = TRUE;
					break;
				}
			}
		}
	}

	if(NOT found)
	{
		error = ERROR_OBJECT_NOT_FOUND;
	}

	return(error);
}

/******************************************************************************/

ERRORCODE
EstablishLink(
	struct DocumentNode *	dn,
	struct GuideLinkNode *	gn,
	STRPTR					name,
	LONG					line,
	const STRPTR			documentName,
	BOOL *					newDocumentsAdded)
{
	ERRORCODE error;

	error = FindLink(name,dn,line,gn);
	if(error == ERROR_OBJECT_NOT_FOUND)
	{
		UBYTE fileName[MAX_PATHNAME_LEN];
		STRPTR path;
		struct DocumentNode * newDn;
	
		StrcpyN(sizeof(fileName),fileName,name);
		path = PathPart(fileName);
		(*path) = '\0';
	
		printf("Reading document \"%s\"...\n",fileName);
	
		error = ReadDocument(dn->dn_MasterFile,fileName,&newDn);
		if(error == OK)
		{
			(*newDocumentsAdded) = TRUE;
	
			printf("Scanning document \"%s\" for commands...\n",newDn->dn_Node.ln_Name);
	
			error = ScanDocumentForCommands(newDn);
		}
	}

	return(error);
}

ERRORCODE
EstablishSingleLink(
	struct DocumentNode *	dn,
	STRPTR					name,
	struct GuideLinkNode **	gnPtr,
	const STRPTR			documentName,
	BOOL *					newDocumentsAdded)
{
	ERRORCODE error = OK;

	if(name != NULL && (*gnPtr) == NULL)
	{
		UBYTE fileName[MAX_PATHNAME_LEN];
		struct GuideLinkNode * gn;

		if(FilePart(documentName) == documentName && NOT IsLocal(documentName))
		{
			StrcpyN(sizeof(fileName),fileName,documentName);
			if(AddPart(fileName,name,sizeof(fileName)))
			{
				name = fileName;
			}
			else
			{
				error = IoErr();
			}
		}

		if(error == OK)
		{
			gn = AllocVecPooled(sizeof(*gn),MEMF_CLEAR);
			if(gn != NULL)
			{
				error = EstablishLink(dn,gn,name,0,documentName,newDocumentsAdded);
				if(error == OK)
				{
					(*gnPtr) = gn;
				}
				else
				{
					FreeVecPooled(gn);
				}
			}
			else
			{
				error = ERROR_NO_FREE_STORE;
			}
		}
	}

	return(error);
}

ERRORCODE
BuildCrossReferences(
	struct DocumentNode *	dn,
	BOOL *					newDocumentsAdded)
{
	ERRORCODE error = OK;
	BOOL hadAnError = FALSE;

	(*newDocumentsAdded) = FALSE;

	if(dn->dn_IsAmigaGuide)
	{
		struct AmigaGuideNode * an;
		
		for(an = (struct AmigaGuideNode *)dn->dn_NodeList.lh_Head ;
		    (error == OK) && (an->an_Node.ln_Succ != NULL) ;
		    an = (struct AmigaGuideNode *)an->an_Node.ln_Succ)
		{
			struct LineNode * ln;
			BOOL hasLinkError = FALSE;
			LONG linkLine = 0;
			STRPTR linkName = NULL;
			STRPTR linkType = NULL;
	
			for(ln = (struct LineNode *)an->an_Lines.lh_Head ;
			    (error == OK) && (ln->ln_Node.ln_Succ != NULL) ;
			    ln = (struct LineNode *)ln->ln_Node.ln_Succ)
			{
				if(ln->ln_HasCommands)
				{
					struct GuideLinkNode * gn;
	
					for(gn = (struct GuideLinkNode *)ln->ln_Commands.lh_Head ;
					    (error == OK) && (gn->gn_MinNode.mln_Succ != NULL) ;
					    gn = (struct GuideLinkNode *)gn->gn_MinNode.mln_Succ)
					{
						if(gn->gn_GuideNode == NULL)
						{
							STATIC UBYTE localBuffer[sizeof(LineBuffer)];
							STRPTR args[5];
		
							strncpy(localBuffer,&gn->gn_Command[2],gn->gn_CommandLen-2);
							localBuffer[gn->gn_CommandLen-2] = '\0';
		
							memset(args,0,sizeof(args));
		
							if(ParseAndTrashString("1LABEL/A,2COMMAND,3NAME,4LINE,OTHER/F",args,localBuffer))
							{
								STRPTR command = args[1];
	
								if((command != NULL) && (Stricmp(command,"LINK") == SAME))
								{
									STRPTR name = args[2];
		
									if(name != NULL)
									{
										UBYTE localBuffer[MAX_PATHNAME_LEN];
										LONG line = 0;
		
										if(args[3] != NULL)
										{
											StrToLong(args[3],&line);
										}

										/* take care of local links without complete
										 * qualified path names
										 */
										if(FilePart(name) == name && NOT IsLocal(name))
										{
											StrcpyN(sizeof(localBuffer),localBuffer,an->an_Document->dn_Node.ln_Name);
											if(AddPart(localBuffer,name,sizeof(localBuffer)))
											{
												name = localBuffer;
											}
										}

										error = EstablishLink(dn,gn,name,line,dn->dn_Node.ln_Name,newDocumentsAdded);
										if(error != OK)
										{		
											UBYTE errorName[100];
											int i;

											Fault(error,NULL,errorName,sizeof(errorName));
											for(i = strlen(errorName)-1 ; i >= 0 ; i--)
											{
												if(errorName[i] == '\n')
												{
													errorName[i] = '\0';
												}
											}

											fprintf(stderr,"%s:%d:%s, |%s|\n",dn->dn_Node.ln_Name,ln->ln_LineNumber,errorName,ln->ln_Node.ln_Name);
										}
									}
								}
								else
								{
									if(NOT IsAmigaGuideV39)
									{
										STRPTR label;
										int i;
	
										label = args[0];
										while((*label) == ' ')
											label++;
	
										for(i = 0 ; i < NUM_ELEMENTS(v39Commands) ; i++)
										{
											if(Strnicmp(label,v39Commands[i],strlen(v39Commands[i])) == SAME)
											{
												IsAmigaGuideV39 = TRUE;
												break;
											}
										}
									}
								}
							}
						}

						if(error == ERROR_OBJECT_NOT_FOUND)
						{
							hadAnError = TRUE;
							error = OK;
						}
					}
				}
			}

			if(error == OK)
			{
				error = EstablishSingleLink(dn,an->an_TOC,&an->an_TOCLink,dn->dn_Node.ln_Name,newDocumentsAdded);
				if(error != OK)
				{
					hasLinkError = TRUE;
					linkLine = an->an_TOCLine;
					linkName = an->an_TOC;
					linkType = "@TOC";
				}
			}

			if(error == OK)
			{
				error = EstablishSingleLink(dn,an->an_Index,&an->an_IndexLink,dn->dn_Node.ln_Name,newDocumentsAdded);
				if(error != OK)
				{
					hasLinkError = TRUE;
					linkLine = an->an_IndexLine;
					linkName = an->an_Index;
					linkType = "@INDEX";
				}
			}

			if(error == OK)
			{
				error = EstablishSingleLink(dn,an->an_Next,&an->an_NextLink,dn->dn_Node.ln_Name,newDocumentsAdded);
				if(error != OK)
				{
					hasLinkError = TRUE;
					linkLine = an->an_NextLine;
					linkName = an->an_Next;
					linkType = "@NEXT";
				}
			}

			if(error == OK)
			{
				error = EstablishSingleLink(dn,an->an_Prev,&an->an_PrevLink,dn->dn_Node.ln_Name,newDocumentsAdded);
				if(error != OK)
				{
					hasLinkError = TRUE;
					linkLine = an->an_PrevLine;
					linkName = an->an_Prev;
					linkType = "@PREV";
				}
			}

			if(hasLinkError)
			{
				UBYTE errorName[100];
				int i;

				Fault(error,NULL,errorName,sizeof(errorName));
				for(i = strlen(errorName)-1 ; i >= 0 ; i--)
				{
					if(errorName[i] == '\n')
					{
						errorName[i] = '\0';
					}
				}

				fprintf(stderr,"%s:%d:%s, |%s %s|\n",dn->dn_Node.ln_Name,linkLine,errorName,linkType,linkName);
			}

			if(error == ERROR_OBJECT_NOT_FOUND)
			{
				hadAnError = TRUE;
				error = OK;
			}
		}
	}

	if(hadAnError && error == OK)
	{
		error = ERROR_OBJECT_NOT_FOUND;
	}

	return(error);
}

ERRORCODE
ScanDocumentForCommands(struct DocumentNode * dn)
{
	ERRORCODE error = OK;

	if(dn->dn_IsAmigaGuide)
	{
		struct AmigaGuideNode * an;
	
		for(an = (struct AmigaGuideNode *)dn->dn_NodeList.lh_Head ;
		    (error == OK) && (an->an_Node.ln_Succ != NULL) ;
		    an = (struct AmigaGuideNode *)an->an_Node.ln_Succ)
		{
			struct LineNode * ln;

			for(ln = (struct LineNode *)an->an_Lines.lh_Head ;
			    (error == OK) && (ln->ln_Node.ln_Succ != NULL) ;
			    ln = (struct LineNode *)ln->ln_Node.ln_Succ)
			{
				BOOL inEscape = FALSE;
				STRPTR buffer;
				LONG i;

				buffer = ln->ln_Node.ln_Name;
				for(i = 0 ; i < ln->ln_Len-1 ; i++)
				{
					if(buffer[i] == '\\')
					{
						inEscape ^= TRUE;
					}
					else
					{
						if((buffer[i] == '@') && (buffer[i+1] == OPEN_BRACE))
						{
							if(NOT inEscape)
							{
								LONG commandLen;

								commandLen = MeasureCommandLen(&buffer[i]);
								//if(commandLen > 3)
								{
									struct GuideLinkNode * gn;

									gn = AllocVecPooled(sizeof(*gn),MEMF_CLEAR);
									if(gn != NULL)
									{
										gn->gn_Command = &buffer[i];
										gn->gn_CommandLen = commandLen;
	
										ln->ln_HasCommands = TRUE;
										AddTail(&ln->ln_Commands,(struct Node *)gn);
									}
									else
									{
										error = ERROR_NO_FREE_STORE;
										break;
									}
								}

								/* one less than the entire command length
								 * since the for(..) loop will increment
								 * the position by one.
								 */
								i += commandLen-1;
							}
						}

						inEscape = FALSE;
					}
				}
			}
		}
	}

	return(error);
}

ERRORCODE
ReadDocument(
	const STRPTR			masterFileName,
	const STRPTR			name,
	struct DocumentNode **	resultPtr)
{
	ERRORCODE error = OK;

	if(resultPtr != NULL)
	{
		(*resultPtr) = NULL;
	}

	if(CANNOT FindIName(&DocumentList,name))
	{
		FILE * in;

		in = fopen(name,"rb");
		if(in != NULL)
		{
			struct DocumentNode * dn;

			dn = AllocVecPooled(sizeof(*dn) + strlen(name)+1,MEMF_CLEAR);
			if(dn != NULL)
			{
				BOOL isFirstLine = TRUE;
				BOOL createNewNode = FALSE;
				struct AmigaGuideNode * an = NULL;
				STRPTR nodeName = NULL;
				STRPTR nodeTitle = NULL;
				STRPTR indexName = NULL;
				BOOL finished;
				BPTR fileLock;
				BOOL eaten;
				int len;

				dn->dn_Node.ln_Name = (char *)(dn + 1);

				strcpy(dn->dn_Node.ln_Name,name);
				NewList(&dn->dn_NodeList);

				dn->dn_MasterFile = masterFileName;

				AddTail(&DocumentList,(struct Node *)dn);

				finished = FALSE;

				ForbidBreak();

				fileLock = Lock((STRPTR)name,SHARED_LOCK);
				if(fileLock != NULL)
				{
					struct DataType * dtn;

					/* check whether DataTypes believes that the
					 * file in question is a picture
					 */
					dtn = ObtainDataTypeA(DTST_FILE,(APTR)fileLock,NULL);
					if(dtn != NULL)
					{
						if(dtn->dtn_Header->dth_GroupID == GID_PICTURE)
						{
							Object * pictureObject;

							/* since false-detection of files may lead
							 * to trouble lateron, we insist that
							 * datatypes opens and processes the file
							 * it believes to be a picture file, just
							 * to see whether the assumption was correct
							 */
							pictureObject = NewDTObject(name,
								DTA_SourceType,	DTST_FILE,
								DTA_GroupID,	GID_PICTURE,
								PDTA_Remap,		FALSE,
							TAG_DONE);

							if(pictureObject != NULL)
							{
								struct FrameInfo fri;

								memset(&fri,0,sizeof(fri));

								if(DoMethod(pictureObject,DTM_FRAMEBOX,NULL,&fri,&fri,sizeof(fri),0) && fri.fri_Dimensions.Depth > 0)
								{
									if(DoMethod(pictureObject,DTM_PROCLAYOUT,NULL,TRUE))
									{
										/* ok, so it was a readable picture
										 * after all
										 */
										dn->dn_IsPicture = TRUE;
									}
								}

								DisposeDTObject(pictureObject);
							}
						}

						ReleaseDataType(dtn);
					}

					UnLock(fileLock);
				}

				PermitBreak();

				if(dn->dn_IsPicture)
				{
					an = AllocVecPooled(sizeof(*an),MEMF_CLEAR);
					if(an != NULL)
					{
						an->an_Document = dn;

						NewList(&an->an_Lines);

						nodeName = "MAIN";
						nodeTitle = (STRPTR)name;

						if(nodeName != NULL)
						{
							an->an_Node.ln_Name = CopyString(nodeName);
							if(an->an_Node.ln_Name == NULL)
							{
								FreeVecPooled(an);
								an = NULL;
							}
						}

						if(nodeTitle != NULL && an != NULL)
						{
							an->an_Title = CopyString(nodeTitle);
							if(an->an_Title == NULL)
							{
								FreeVecPooled(an);
								an = NULL;
							}
						}

						if(an != NULL)
						{
							AddTail(&dn->dn_NodeList,(struct Node *)an);
							finished = TRUE;
						}
					}

					if(an == NULL)
					{
						error = ERROR_NO_FREE_STORE;
					}
				}

				if(NOT finished)
				{
					LONG lineNumber = 0;

					while(fgets(LineBuffer,sizeof(LineBuffer)-1,in) != NULL)
					{
						lineNumber++;

						eaten = FALSE;

						len = strlen(LineBuffer);

						while(   (len > 0)
						      && (   LineBuffer[len-1] == '\n'
						          || LineBuffer[len-1] == '\t'
						          || LineBuffer[len-1] == ' '))
						{
							LineBuffer[--len] = '\0';
						}

						if(len > 0)
						{
							if(isFirstLine)
							{
								if(Compare(LineBuffer,"@database",-1) == SAME)
								{
									dn->dn_IsAmigaGuide = TRUE;
								}
								else
								{
									createNewNode = TRUE;
								}

								isFirstLine = FALSE;
							}

							if(dn->dn_IsAmigaGuide)
							{
								/* ignore these */
								if(   Compare(LineBuffer,"@master",-1) == SAME
								   || Compare(LineBuffer,"@remark",-1) == SAME
								   || Compare(LineBuffer,"@database",-1) == SAME
								   || Compare(LineBuffer,"@author",-1) == SAME
								   || Compare(LineBuffer,"@(c)",-1) == SAME
								   || Compare(LineBuffer,"@$VER: ",-1) == SAME
								   || Compare(LineBuffer,"@font",-1) == SAME
								   || Compare(LineBuffer,"@help",-1) == SAME)
								{
									eaten = TRUE;
								}
		
								if(an != NULL && Compare(LineBuffer,"@title",-1) == SAME)
								{
									STRPTR title = NULL;

									if(ParseString("@title","1NAME/A",&title,LineBuffer))
									{
										if(an->an_Title != NULL)
										{
											FreeVecPooled(an->an_Title);
										}

										an->an_Title = CopyString(title);
									}

									eaten = TRUE;
								}

								if(Compare(LineBuffer,"@wordwrap",-1) == SAME)
								{
									IsAmigaGuideV39 = TRUE;
									dn->dn_WordWrap = TRUE;
									eaten = TRUE;
								}

								if(Compare(LineBuffer,"@index",-1) == SAME)
								{
									STRPTR name = NULL;

									if(ParseString("@index","1NAME/A",&name,LineBuffer))
									{
										indexName = CopyString(name);
									}

									eaten = TRUE;
								}

								if(an != NULL && Compare(LineBuffer,"@toc",-1) == SAME)
								{
									STRPTR name = NULL;

									if(ParseString("@toc","1NAME/A",&name,LineBuffer))
									{
										if(an->an_TOC != NULL)
										{
											FreeVecPooled(an->an_TOC);
										}

										an->an_TOC = CopyString(name);
										an->an_TOCLine = lineNumber;
									}

									eaten = TRUE;
								}

								if(an != NULL && Compare(LineBuffer,"@prev",-1) == SAME)
								{
									STRPTR name = NULL;

									if(ParseString("@prev","1NAME/A",&name,LineBuffer))
									{
										if(an->an_Prev != NULL)
										{
											FreeVecPooled(an->an_Prev);
										}

										an->an_Prev = CopyString(name);
										an->an_PrevLine = lineNumber;
									}

									eaten = TRUE;
								}

								if(an != NULL && Compare(LineBuffer,"@next",-1) == SAME)
								{
									STRPTR name = NULL;

									if(ParseString("@next","1NAME/A",&name,LineBuffer))
									{
										if(an->an_Next != NULL)
										{
											FreeVecPooled(an->an_Next);
										}

										an->an_Next = CopyString(name);
										an->an_NextLine = lineNumber;
									}

									eaten = TRUE;
								}

								if(Compare(LineBuffer,"@endnode",-1) == SAME)
								{
									an = NULL;

									eaten = TRUE;
								}
		
								if(Compare(LineBuffer,"@node",-1) == SAME)
								{
									STRPTR args[2];

									memset(args,0,sizeof(args));
		
									if(ParseString("@node","1NAME/A,2TITLE",args,LineBuffer))
									{
										nodeName = args[0];
										nodeTitle = nodeName;
		
										if(args[1] != NULL)
										{
											nodeTitle = args[1];
										}
		
										createNewNode = TRUE;
									}

									eaten = TRUE;
								}
							}
						}

						if(createNewNode)
						{
							an = AllocVecPooled(sizeof(*an),MEMF_CLEAR);
							if(an != NULL)
							{
								an->an_Document = dn;

								NewList(&an->an_Lines);

								if(dn->dn_IsAmigaGuide)
								{
									an->an_Index = indexName;
									an->an_IndexLine = lineNumber;
								}
								else
								{
									nodeName = "MAIN";
									nodeTitle = (STRPTR)name;
								}

								if(nodeName != NULL)
								{
									an->an_Node.ln_Name = CopyString(nodeName);
									if(an->an_Node.ln_Name == NULL)
									{
										FreeVecPooled(an);
										an = NULL;
									}
								}

								if(nodeTitle != NULL && an != NULL)
								{
									an->an_Title = CopyString(nodeTitle);
									if(an->an_Title == NULL)
									{
										FreeVecPooled(an);
										an = NULL;
									}
								}

								if(an != NULL)
								{
									AddTail(&dn->dn_NodeList,(struct Node *)an);
								}
							}

							if(an == NULL)
							{
								error = ERROR_NO_FREE_STORE;
								break;
							}

							createNewNode = FALSE;
						}

						if(an != NULL)
						{
							struct LineNode * ln;

							if(eaten)
							{
								strcpy(LineBuffer,"\a");
							}

							ln = AllocVecPooled(sizeof(*ln) + strlen(LineBuffer)+1,MEMF_CLEAR);
							if(ln != NULL)
							{
								ln->ln_Node.ln_Name = (char *)(ln + 1);
								strcpy(ln->ln_Node.ln_Name,LineBuffer);

								ln->ln_Len = strlen(ln->ln_Node.ln_Name);
								ln->ln_GuideNode = an;
								ln->ln_LineNumber = lineNumber;
								NewList(&ln->ln_Commands);

								AddTail(&an->an_Lines,(struct Node *)ln);
							}
							else
							{
								error = ERROR_NO_FREE_STORE;
								break;
							}
						}
					}
				}
			}
			else
			{
				error = ERROR_NO_FREE_STORE;
			}

			if(error == OK)
			{
				if(resultPtr != NULL)
				{
					(*resultPtr) = dn;
				}
			}

			fclose(in);
		}
		else
		{
			error = ERROR_OBJECT_NOT_FOUND;
		}
	}
	else
	{
		error = ERROR_OBJECT_NOT_FOUND;
	}

	return(error);
}

/******************************************************************************/

ERRORCODE
AmigaGuide2HTML(
	STRPTR *	files,
	LONG		numFiles,
	BPTR		targetDir)
{
	ERRORCODE error = OK;
	LONG i;

	Initialize();

	for(i = 0 ; (error == OK) && (i < numFiles) ; i++)
	{
		printf("Reading document \"%s\"...\n",files[i]);

		error = ReadDocument(files[i],files[i],NULL);
	}

	if(error == OK)
	{
		struct DocumentNode * dn;

		for(dn = (struct DocumentNode *)DocumentList.lh_Head ;
		    (error == OK) && (dn->dn_Node.ln_Succ != NULL) ;
		    dn = (struct DocumentNode *)dn->dn_Node.ln_Succ)
		{
			printf("Scanning document \"%s\" for commands...\n",dn->dn_Node.ln_Name);

			error = ScanDocumentForCommands(dn);
		}
	}

	if(error == OK)
	{
		struct DocumentNode * dn;
		BOOL newDocumentsAdded;

		dn = (struct DocumentNode *)DocumentList.lh_Head;

		while((error == OK) && (dn->dn_Node.ln_Succ != NULL))
		{
			newDocumentsAdded = FALSE;

			if(NOT dn->dn_Stable)
			{
				printf("Resolving cross references in file \"%s\"...\n",dn->dn_Node.ln_Name);

				error = BuildCrossReferences(dn,&newDocumentsAdded);

				if(NO newDocumentsAdded)
				{
					dn->dn_Stable = TRUE;
				}
			}

			if(newDocumentsAdded)
			{
				printf("New documents added; restarting.\n");

				dn = (struct DocumentNode *)DocumentList.lh_Head;
			}
			else
			{
				dn = (struct DocumentNode *)dn->dn_Node.ln_Succ;
			}
		}
	}

	if(error == OK)
	{
		for(i = 0 ; i < numFiles ; i++)
		{
			struct DocumentNode * dn;
			struct DocumentNode * thisDn;

			thisDn = NULL;

			for(dn = (struct DocumentNode *)DocumentList.lh_Head ;
			    dn->dn_Node.ln_Succ != NULL ;
			    dn = (struct DocumentNode *)dn->dn_Node.ln_Succ)
			{
				if(dn->dn_MasterFile == (STRPTR)files[i])
				{
					thisDn = dn;
					break;
				}
			}

			if(thisDn != NULL)
			{
				struct DocumentNode * nextDn;

				do
				{
					nextDn = NULL;

					for(dn = (struct DocumentNode *)DocumentList.lh_Head ;
					    dn->dn_Node.ln_Succ != NULL ;
					    dn = (struct DocumentNode *)dn->dn_Node.ln_Succ)
					{
						if(dn != thisDn && NOT dn->dn_Done && dn->dn_MasterFile == (STRPTR)files[i])
						{
							nextDn = dn;
							break;
						}
					}

					if(nextDn != NULL)
					{
						MoveList(&nextDn->dn_NodeList,&thisDn->dn_NodeList);

						nextDn->dn_Done = TRUE;
					}
				}
				while(nextDn != NULL);
			}
		}

		printf("Assigning node numbers...\n");
		error = AssignNodeNumbers();

		if(error == OK)
		{
			printf("Assigning name templates...\n");
			error = AssignNameTemplates();
		}
	}

	if(error == OK)
	{
		struct DocumentNode * dn;

		CreateImages(targetDir);

		for(dn = (struct DocumentNode *)DocumentList.lh_Head ;
		    (error == OK) && (dn->dn_Node.ln_Succ != NULL) ;
		    dn = (struct DocumentNode *)dn->dn_Node.ln_Succ)
		{
			if(NOT dn->dn_Done)
			{
				printf("Writing document \"%s\"...\n",dn->dn_MasterFile);

				error = ConvertFile(dn,targetDir);
			}
		}
	}

	return(error);
}

/******************************************************************************/

int
main(void)
{
	struct
	{
		STRPTR *	Files;
		STRPTR		To;
	} params;

	struct RDArgs * rdargs;
	int result = RETURN_OK;

	memset(&params,0,sizeof(params));

	rdargs = ReadArgs("FILES/M,TO/K",(LONG *)&params,NULL);
	if(rdargs != NULL)
	{
		LONG numFiles,i;

		numFiles = 0;
		for(i = 0 ; params.Files[i] != NULL ; i++)
		{
			numFiles++;
		}

		if(numFiles > 0)
		{
			STRPTR targetDirName;
			BPTR targetDir;
	
			if(params.To != NULL)
				targetDirName = params.To;
			else
				targetDirName = "";
	
			targetDir = Lock(targetDirName,SHARED_LOCK);
			if(targetDir != ZERO)
			{
				ERRORCODE error;

				GlobalLastDir	= ZERO;
				GlobalTargetDir	= targetDir;
				GlobalRDArgs	= rdargs;

				error = AmigaGuide2HTML(params.Files,numFiles,targetDir);
				if(error != OK)
				{
					PrintFault(error,"AG2HTML");
					result = RETURN_ERROR;
				}

				GlobalLastDir	= ZERO;
				GlobalTargetDir	= ZERO;
				GlobalRDArgs	= NULL;

				UnLock(targetDir);
			}
			else
			{
				PrintFault(IoErr(),targetDirName);
				result = RETURN_ERROR;
			}
		}
		else
		{
			PrintFault(ERROR_REQUIRED_ARG_MISSING,"AG2HTML");
			result = RETURN_ERROR;
		}

		FreeArgs(rdargs);
	}
	else
	{
		PrintFault(IoErr(),"AG2HTML");
		result = RETURN_WARN;
	}

	return(result);
}
