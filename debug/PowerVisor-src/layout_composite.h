//===============================================//
// Layout manager classes                        //
// Composite header file                         //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#ifndef LAYOUT_COMPOSITE_H
#define LAYOUT_COMPOSITE_H 1

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_BOX_H
#include "layout_box.h"
#endif

#ifndef LAYOUT_PRIMITIVE_H
#include "layout_primitive.h"
#endif

class primitive;

class composite : public primitive
{
	friend class primitive;

protected:
	primitive *children;
	int numChildren;

public:
	composite (Shell* shell, char *name, composite *parent);
	virtual ~composite ();

	virtual GeometryResult geometry_manager (primitive *child, GeometryRequest *request,
					GeometryRequest *answer) = 0;													// Handle resize requests from children (only from within set_values)
	virtual void change_managed () = 0;														// Manages layout of children when a child is (un)managed
	virtual void insert_child (primitive *child);
	virtual void delete_child (primitive *child);

	virtual void ClearQueue ();
	virtual void PlayQueue ();
};

#endif
