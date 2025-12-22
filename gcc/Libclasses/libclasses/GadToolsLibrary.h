
#ifndef _GADTOOLSLIBRARY_H
#define _GADTOOLSLIBRARY_H

#include <exec/types.h>
#include <intuition/intuition.h>
#include <utility/tagitem.h>
#include <libraries/gadtools.h>

class GadToolsLibrary
{
public:
	GadToolsLibrary();
	~GadToolsLibrary();

	static class GadToolsLibrary Default;

	struct Gadget * CreateGadgetA(ULONG kind, struct Gadget * gad, CONST struct NewGadget * ng, CONST struct TagItem * taglist);
	VOID FreeGadgets(struct Gadget * gad);
	VOID GT_SetGadgetAttrsA(struct Gadget * gad, struct Window * win, struct Requester * req, CONST struct TagItem * taglist);
	struct Menu * CreateMenusA(CONST struct NewMenu * newmenu, CONST struct TagItem * taglist);
	VOID FreeMenus(struct Menu * menu);
	BOOL LayoutMenuItemsA(struct MenuItem * firstitem, APTR vi, CONST struct TagItem * taglist);
	BOOL LayoutMenusA(struct Menu * firstmenu, APTR vi, CONST struct TagItem * taglist);
	struct IntuiMessage * GT_GetIMsg(struct MsgPort * iport);
	VOID GT_ReplyIMsg(struct IntuiMessage * imsg);
	VOID GT_RefreshWindow(struct Window * win, struct Requester * req);
	VOID GT_BeginRefresh(struct Window * win);
	VOID GT_EndRefresh(struct Window * win, LONG complete);
	struct IntuiMessage * GT_FilterIMsg(CONST struct IntuiMessage * imsg);
	struct IntuiMessage * GT_PostFilterIMsg(struct IntuiMessage * imsg);
	struct Gadget * CreateContext(struct Gadget ** glistptr);
	VOID DrawBevelBoxA(struct RastPort * rport, LONG left, LONG top, LONG width, LONG height, CONST struct TagItem * taglist);
	APTR GetVisualInfoA(struct Screen * screen, CONST struct TagItem * taglist);
	VOID FreeVisualInfo(APTR vi);
	LONG GT_GetGadgetAttrsA(struct Gadget * gad, struct Window * win, struct Requester * req, CONST struct TagItem * taglist);

private:
	struct Library *Base;
};

GadToolsLibrary GadToolsLibrary::Default;

#endif

