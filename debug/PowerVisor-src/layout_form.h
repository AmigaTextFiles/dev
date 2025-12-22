//===============================================//
// Layout manager classes                        //
// Form header file                              //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#ifndef LAYOUT_FORM_H
#define LAYOUT_FORM_H 1

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

enum FormLinkType
{
	LinkAttachNone,
	LinkAttachForm,
	LinkAttachChild,
	LinkAttachProp
};

struct SimpleLink
{
	FormLinkType link;
	primitive* linked_child;
	int distance;	// Distance or proportion
};

struct FormLink
{
	FormLink* next, * prev;
	primitive* child;
	SimpleLink links[4];
};

class form : public composite
{
	FormLink* FirstLink;

	void del_link (FormLink* l);
	FormLink* find_link (FormLink* start, primitive* child);
	int scan_links (FormLink* link, DirType dir, int spanI);

public:
	form (Shell* shell, char* name, composite* parent = NULL);
	virtual ~form ();

	void add_link (primitive* child, DirType dir, FormLinkType link, primitive* linked_child, int distance);
	virtual void expose ();
	virtual void resize ();
	virtual GeometryResult query_geometry (GeometryRequest& answer);
	virtual GeometryResult geometry_manager (primitive* child, GeometryRequest* request,
					GeometryRequest* answer);
	virtual void change_managed ();
};

#endif
