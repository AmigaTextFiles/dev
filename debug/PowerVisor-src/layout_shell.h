//===============================================//
// Layout manager classes                        //
// Shell header file                             //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#ifndef LAYOUT_SHELL_H
#define LAYOUT_SHELL_H 1

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_BOX_H
#include "layout_box.h"
#endif

#ifndef LAYOUT_COMPOSITE_H
#include "layout_composite.h"
#endif

#ifndef LAYOUT_PRIMITIVE_H
#include "layout_primitive.h"
#endif

#ifndef LAYOUT_CONTEXT_H
#include "layout_context.h"
#endif

class screenctxt;

class Shell : public composite
{
	struct Event
	{
		Event* next, * prev;
		primitive* obj;
	};

	struct Window *win;
	struct RastPort *rp;
	Event* events;

	struct Event* FindEvent (primitive* obj);

public:
	Shell (char *name, composite* parent);
	virtual ~Shell ();

	virtual void expose ();
	virtual void resize ();
	virtual GeometryResult query_geometry (GeometryRequest& answer);
	virtual GeometryResult geometry_manager (primitive *child, GeometryRequest *request,
					GeometryRequest *answer);
	virtual void change_managed ();
	virtual int HandleEvent (unsigned long clas, unsigned short code, unsigned short qual, void* iaddr);

	struct RastPort* get_rp () { return rp; }
	struct Window* get_win () { return win; }
	void draw_box (int x, int y, int w, int h);
	void draw_box (box& box) { draw_box (box.left(), box.top (), box.width (), box.height ()); }
	void clear_box (int x, int y, int w, int h);
	void clear_box (box& box) { clear_box (box.left(), box.top (), box.width (), box.height ()); }
	void clear ();

	void RegisterEvent (primitive* obj);
	void UnregisterEvent (primitive* obj);
	int DispatchEvent (unsigned long clas, unsigned short code, unsigned short qual, void* iaddr);
};

#endif
