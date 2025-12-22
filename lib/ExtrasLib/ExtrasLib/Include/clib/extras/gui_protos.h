#ifndef CLIB_EXTRAS_GUI_PROTOS_H
#define CLIB_EXTRAS_GUI_PROTOS_H

#ifndef EXTRAS_GUI_H
#include <extras/gui.h>
#endif

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef INTUITION_SCREENS_H
#include <intuition/screens.h>
#endif

#ifndef GRAPHICS_TEXT_H
#include <graphics/text.h>
#endif

#ifndef GRAPHICS_RASTPORT_H
#include <graphics/rastport.h>
#endif

LONG  gui_StrFontLen(struct TextFont *Font, STRPTR Str);
LONG  gui_StrLength (Tag Tags, ... );
ULONG gui_MaxStrFontLen(struct TextFont *Font, ULONG Chars, UBYTE LowChar, UBYTE HighChar);

void  gui_GhostRect(struct RastPort *RP, ULONG Pen, WORD X0, WORD Y0, WORD X1, WORD Y1);

LONG  gui_RenderText(struct RastPort *RP, STRPTR String, Tag Tags, ... );
LONG  gui_RenderTextA(struct RastPort *RP, STRPTR String, struct TagItem *TagList);


/* The following is Obsolete */
void DrawBevelBoxes(struct Window *Win, APTR VI, struct BevelBox *BBox,
                    LONG NumBoxes, float XScale, float YScale);

BOOL GetGUIScale(struct TextAttr   *TA,
                 struct GUI_String *Strings,
                 float  *XScale,
                 float  *YScale);

BOOL CheckWindowSize(struct Screen *Scr,
                     WORD Width,
                     WORD Height,
                     float XScale,
                     float YScale);

BOOL CheckInnerWindowSize(struct Screen *Scr,
                     WORD Width,
                     WORD Height,
                     float XScale,
                     float YScale);


#endif /* CLIB_EXTRAS_GUI_PROTOS_H */
