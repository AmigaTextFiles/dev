//===============================================//
// Layout manager classes                        //
// Leftright Header file                         //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#ifndef LAYOUT_LEFTRIGHT_H
#define LAYOUT_LEFTRIGHT_H 1

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_BOX_H
#include "layout_box.h"
#endif

#ifndef LAYOUT_PRIMITIVE_H
#include "layout_primitive.h"
#endif

#ifndef LAYOUT_COMPOSITE_H
#include "layout_composite.h"
#endif

class leftright : public composite
{
public:
	leftright (Shell* shell, char *name, composite *parent = NULL);
	virtual ~leftright () { D db("leftright::~leftright", get_name ()); }

	virtual void expose ();
	virtual void resize ();
	virtual GeometryResult query_geometry (GeometryRequest& answer);
	virtual GeometryResult geometry_manager (primitive *child, GeometryRequest *request,
					GeometryRequest *answer);
	virtual void change_managed ();
};

#endif
