#ifndef LIBRARIES_GAMESUPPORT_H
#define LIBRARIES_GAMESUPPORT_H

#ifndef DEVICES_INPUTEVENT_H
#include <devices/inputevent.h>
#endif

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

/************************************************************************/

#ifndef INTUITION_INTUITIONBASE_H
struct IntuitionBase;
#endif

#ifndef DOS_DOSEXTENS_H
struct DosLibrary;
#endif

#ifndef GRAPHICS_GFXBASE_H
struct GfxBase;
#endif

#ifndef EXEC_EXECBASE_H
struct ExecBase;
#endif

/************************************************************************/

struct GameSupportBase
{
  struct Library Library;

  struct ExecBase *SysBase;			/* V39 */
  struct DosLibrary *DOSBase;			/* V39 */
  struct GfxBase *GfxBase;			/* V39 */
  struct IntuitionBase *IntuitionBase;		/* V39 */
  struct Library *UtilityBase;			/* V39 */
  struct Library *LocaleBase;			/* V38 */
  struct Library *LayersBase;			/* V39 */
  struct Library *KeymapBase;			/* V39 */

  struct
    {
      struct IOStdReq Request;
      struct InputEvent Event;
    } Joystick;
};

/************************************************************************/

struct GS_ScoreDef
{
  struct Hook *CompareHook;
  const char *GameName;
  ULONG TableSize[3];
  LONG ChunkCount;
  /* struct GS_ScoreChunkDef [] */
};

struct GS_ScoreChunkDef
{
  ULONG ChunkID;
  UWORD Flags;
  UWORD Size;
};

#define GS_SCOREDEFF_INTEGER	(1<<0)		/* item is ULONG */

/* The CompareHook is invoked with	*/
/*   a0 -> struct Hook *Hook		*/
/*   a1 -> void *Score2			*/
/*   a2 -> void *Score1			*/
/* It is expected to return		*/
/*   <0 if Score1 < Score2		*/
/*    0 if Score1 == Score2		*/
/*   >0 if Score1 > Score2		*/

struct GS_ScoreList
{
  ULONG Count;			/* number of nodes in List */
  struct MinList List;		/* list of Count GS_Score nodes */
};

struct GS_Score
{
  struct MinNode Node;
  const char *Name;		/* NULL for "unknown" */
  ULONG TimeStamp;
  /* array of ChunkCount entries. If the entry is void* and not FIXSIZE, then ULONG size is the first thing */
};

#define GS_SCORE_ROLL		(0)
#define GS_SCORE_TODAY		(1)
#define GS_SCORE_PERSONAL	(2)

/************************************************************************/

struct GS_Color
{
  ULONG Red;
  ULONG Green;
  ULONG Blue;
  LONG Pen;
};

struct GS_ColorDef
{
  ULONG ColorCount;			/* how many colors are in Colors[] */
  ULONG DistinctColors;			/* how many distinct pens did we get? */
  struct GS_Color Colors[1];
};

#define GS_COLORDEF(Name,Size) struct GS_ColorDef Name; struct GS_Color __##Name [Size-1]

/************************************************************************/

struct GS_Sprite
{
  struct BitMap *Image;
  struct BitMap *Mask;
  WORD Width, Height;
  ULONG Flags;
};

struct GS_Sprites
{
  ULONG SpriteCount;
  struct GS_Sprite *Sprites;
  struct GS_ColorDef Colors;
};

/************************************************************************/

struct GS_User
{
  struct MinNode Node;
  const char *Name;
  UWORD GameCount;
  struct
    {
      UWORD GameNumber;
      ULONG TimeStamp;
    } GameInfo[1];
};

/************************************************************************/

#endif  /* LIBRARIES_GAMESUPPORT_H */
