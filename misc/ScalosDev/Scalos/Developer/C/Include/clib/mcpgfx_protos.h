#ifndef CLIB_MCPGFX_H
#define CLIB_MCPGFX_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef LIBRARIES_MCPGFX_H
#include <libraries/mcpgfx.h>
#endif

#ifndef GRAPHICS_RASTPORT_H
#include <graphics/rastport.h>
#endif

#ifndef INTUITION_SCREENS_H
#include <intuition/screens.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

VOID				mcpPaintSysIGad(APTR SysImageObject, struct DrawInfo *DrawInfo, WORD GadgetNumber, WORD Width, WORD Height);
VOID				mcpRectFillA(struct RastPort *RastPort, WORD x1, WORD y1, WORD x2, WORD y2, CONST struct TagItem *TagList);
VOID				mcpRectFill(struct RastPort *RastPort, WORD x1, WORD y1, WORD x2, WORD y2, Tag tag1, ...);
VOID				mcpDrawFrameA(struct RastPort *RastPort, WORD x1, WORD y1, WORD x2, WORD y2, TagList);
VOID				mcpDrawFrame(struct RastPort *RastPort, WORD x1, WORD y1, WORD x2, WORD y2, Tag tag1, ...);
struct ExtDrawInfo	*mcpGetExtDrawInfo(struct Screen *Screen, struct DrawInfo *DrawInfo);
struct FrameSize	*mcpGetFrameSize(struct DrawInfo *DrawInfo, WORD FrameType);
VOID				mcpSetGFXAttrsA(struct TagItem *TagList);
VOID				mcpSetGFXAttrsA(Tag tag1, ...);

#endif /* CLIB_MCPGFX_H */

