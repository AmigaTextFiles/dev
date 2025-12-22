//===============================================//
// Layout manager classes                        //
// Context header file                           //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#ifndef LAYOUT_CONTEXT_H
#define LAYOUT_CONTEXT_H 1

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_COMPOSITE_H
#include "layout_composite.h"
#endif

#ifndef LAYOUT_SHELL_H
#include "layout_shell.h"
#endif

class screenctxt : public composite
{
public:
	screenctxt (char* name);
	~screenctxt ();

	virtual void expose ();
	virtual void resize ();
	virtual GeometryResult query_geometry (GeometryRequest& answer);
	virtual GeometryResult geometry_manager (primitive *child, GeometryRequest *request,
					GeometryRequest *answer);
	virtual void change_managed ();

	void Wait ();
};

#endif
