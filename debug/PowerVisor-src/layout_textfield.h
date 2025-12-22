//===============================================//
// Layout manager classes                        //
// Textfield header file                         //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#ifndef LAYOUT_TEXTFIELD_H
#define LAYOUT_TEXTFIELD_H 1

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_GADGET_H
#include "layout_gadget.h"
#endif

struct YtTextfieldCBdata
{
	char* buffer;
};

class textfield : public gadget
{
	struct Image *NormalImage;
	char buffer[256];
	YtCallbackFun activateCB; void* activateCBuser;

protected:
	virtual ResourceType GetResourceType (YtResource r);
	virtual void SetResource (YtResource r, ResourceVal& v);

public:
	textfield (Shell* shell, char* name, composite* parent = NULL);
	virtual ~textfield ();

	virtual prefered_width () { return 100; }
	virtual prefered_height () { return 20; }

	virtual void resize ();
	virtual int HandleEvent (unsigned long clas, unsigned short code, unsigned short qual, void* iaddr);

	// User interface functions
	virtual boolean YtAddCallback (YtCallback cbt, YtCallbackFun cbf, void* user = NULL);
};

#endif
