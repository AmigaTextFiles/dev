//===============================================//
// Layout manager classes                        //
// Pushbutton header file                        //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#ifndef LAYOUT_PUSHBUTTON_H
#define LAYOUT_PUSHBUTTON_H 1

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_BOX_H
#include "layout_box.h"
#endif

#ifndef LAYOUT_PRIMITIVE_H
#include "layout_primitive.h"
#endif

class pushbutton : public primitive
{
public:
	pushbutton (Shell* shell, char *name, composite *parent = NULL);
	virtual ~pushbutton () { D db("pushbutton::~pushbutton", get_name ()); }

	virtual void expose ();
	virtual void resize ();
	virtual GeometryResult query_geometry (GeometryRequest& answer);
};

#endif
