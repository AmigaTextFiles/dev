/*
** $VER: ImageBackFill.h 1.13 (19.3.95)
**
** Tests backfill hooks in screens
**
** (W) 1992-95 by Pierre Carrette & Walter Dörwald
*/

#include <intuition/screens.h>
#include <datatypes/pictureclass.h>
#include <clib/macros.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/datatypes.h>
#include <string.h>

struct BackFillOptions
{
	WORD MaxCopyWidth;  // maximum width for the copy
	WORD MaxCopyHeight; // maximum height for the copy
	BOOL CenterX;       // center the tiles horizontally?
	BOOL CenterY;       // center the tiles vertically?
	WORD OffsetX;       // offset to add
	WORD OffsetY;       // offset to add
	BOOL OffsetTitleY;  // add the screen titlebar height to the vertical offset?
};

struct BackFillInfo
{
	struct Hook            Hook;
	struct Screen         *Screen;
	Object                *PictureObject;
	struct BitMapHeader   *BitMapHeader;
	struct BitMap         *BitMap;
	WORD                   CopyWidth;
	WORD                   CopyHeight;
	struct BackFillOptions Options;
};

BOOL LoadBackgroundImage(struct BackFillInfo *BFI,STRPTR PicName,struct Screen *Scr,struct BackFillOptions *BFO);
void UnloadBackgroundImage(struct BackFillInfo *BFI);
