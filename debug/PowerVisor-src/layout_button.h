//===============================================//
// Layout manager classes                        //
// Button header file                            //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#ifndef LAYOUT_BUTTON_H
#define LAYOUT_BUTTON_H 1

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_GADGET_H
#include "layout_gadget.h"
#endif

class button : public gadget
{
	struct Image *SelectImage;
	struct Image *NormalImage;
	YtCallbackFun activateCB; void* activateCBuser;

public:
	button (Shell* shell, char* name, composite* parent = NULL);
	virtual ~button ();

	virtual prefered_width () { return 60; }
	virtual prefered_height () { return 14; }

	virtual void resize ();

	virtual int HandleEvent (unsigned long clas, unsigned short code, unsigned short qual, void* iaddr);
	virtual void ClearQueue ();

	// User interface functions
	virtual boolean YtAddCallback (YtCallback cbt, YtCallbackFun cbf, void* user = NULL);
};

#endif
