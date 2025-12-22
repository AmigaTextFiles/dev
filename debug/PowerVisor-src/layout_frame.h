//===============================================//
// Layout manager classes                        //
// Frame header file                             //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#ifndef LAYOUT_FRAME_H
#define LAYOUT_FRAME_H 1

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_COMPOSITE_H
#include "layout_composite.h"
#endif

class Frame : public composite
{
	struct Image *image;

public:
	Frame (Shell* shell, char *name, composite *parent = NULL);
	virtual ~Frame ();

	virtual void expose ();
	virtual void resize ();
	virtual GeometryResult query_geometry (GeometryRequest& answer);
	virtual GeometryResult geometry_manager (primitive *child, GeometryRequest *request,
					GeometryRequest *answer);
	virtual void change_managed ();
};

#endif
