//===============================================//
// Layout manager classes                        //
// Scrollbar header file                         //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#ifndef LAYOUT_SCROLLBAR_H
#define LAYOUT_SCROLLBAR_H 1

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_PRIMITIVE_H
#include "layout_primitive.h"
#endif

#ifndef LAYOUT_GADGET_H
#include "layout_gadget.h"
#endif

struct YtScrollbarCBdata
{
	unsigned short pos;
};

class scrollbar : public gadget
{
	YtCallbackFun newValueCB; void* newValueCBuser;
	YtCallbackFun slidingCB;  void* slidingCBuser;
	boolean sliding;
	int horiz;

protected:
	virtual ResourceType GetResourceType (YtResource r);
	virtual void SetResource (YtResource r, ResourceVal& v);

public:
	scrollbar (Shell* shell, char* name, composite* parent = NULL);
	virtual ~scrollbar ();

	virtual prefered_width () { return horiz ? 100 : 10; }
	virtual prefered_height () { return horiz ? 10 : 100; }

	virtual int HandleEvent (unsigned long clas, unsigned short code, unsigned short qual, void* iaddr);

	// User interface functions
	virtual boolean YtAddCallback (YtCallback cbt, YtCallbackFun cbf, void* user = NULL);
};

#endif
