//===============================================//
// Layout manager classes                        //
// Primitive header file                         //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#ifndef LAYOUT_PRIMITIVE_H
#define LAYOUT_PRIMITIVE_H 1

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_BOX_H
#include "layout_box.h"
#endif

typedef box GeometryRequest;

enum GeometryResult
{
	GeometryNo,						// Requested geometry is not acceptable (for geometry_manager only)
	GeometryNoChange,			// Requested geometry is acceptable, no difference with current geometry
	GeometryYes,					// Requested geometry is acceptable, it differed with current geometry (if geometry_manager, caller should perform changes)
	GeometryAlmost,				// Not acceptable, answer contains good geometry
	GeometryDone					// Requested geometry is accepted, I have made the change (for geometry_manager only)
};

typedef int GeometryMask;
#define GeometryX 1
#define GeometryY 2
#define GeometryW 4
#define GeometryH 8
#define GeometryAll 15

enum YtResource
{
	YtNend,
	YtNx,								// For all objects: x position
	YtNy,								// For all objects: y position
	YtNwidth,						// For all objects: width
	YtNheight,					// For all objects: height
	YtNbox,							// For all objects: box (x, y, width, height)
	YtNpropVisible,			// For scrollbar: the visible size of the prop
	YtNpropTotal,				// For scrollbar: the total size of the scrollbar
	YtNpropTop,					// For scrollbar: the top position of the prop
	YtNpropOrientation,	// For scrollbar: the orientation (FREEVERT, FREEHORIZ)
	YtNpropNewLook,			// For scrollbar: newlook or not
	YtNgadgDisabled,		// For gadget disabled or not
	YtNgadgID,					// For gadget: the gadget id
	YtNgadgImmediate,		// For gadget
	YtNgadgRelVerify,		// For gadget
	YtNgadgTabCycle,		// For gadget
	YtNtfMaxChars,			// For textfield: maximum number of chars
	YtNfont,						// For textfield and textarea: the font
	YtNmaxLines					// For textarea: the maximum number of lines
};

enum YtCallback
{
	YtNnoCallback,
	YtNnewValueCallback,// For scrollbar: new value
	YtNslidingCallback,	// For scrollbar: new value while sliding
	YtNactivateCallback	// For textfield and button: activation
};

class primitive;
typedef boolean (*YtCallbackFun)(primitive* obj, void* data, void* user);

union ResourceVal
{
	long l;
	int i;
	char c;
	void* p;
	box* b;
};

enum ResourceType
{
	ResourceUnknown,
	ResourceLong,
	ResourceInt,
	ResourceChar,
	ResourceVoidPtr,
	ResourceBox
};

class composite;
class Shell;

// Conventions
//		No chaining: the method need not call the base class method
//		Front chaining: the method should call the base class method before
//				doing anything else
//		Back chaining: the method should call the base class method at the end
//		Conditional chaining: the method should call the base class method if it
//				doesn't know how to handle a certain condition

class primitive : public box
{
	friend class composite;

	char *name;
	composite *parent;
	primitive *next;
	primitive *prev;
	Shell* shell;

	//-------
	// Called by primitive::YtSetValues() to indicate if a *::resize() is needed
	//		old: the old position of the object (is used if parent doesn't allow resize)
	//		->   returns TRUE if primitive should be redrawn
	boolean set_values (box& old);

protected:
	//-------
	// Called by primitive::primitive() to give this primitive the right parent
	//		parent: the parent object
	void parent_me (composite *parent);

	//-------
	// Called by primitive::YtSetValues() to determine the type of a resource.
	// Conditional chaining (doesn't recognize type of resource)
	//		r: resource type enumeration (YtN...)
	//		-> returns the type of the resource (ResourceInt, ResourceBox, ...)
	virtual ResourceType GetResourceType (YtResource r);

	//-------
	// Called by primitive::YtSetValues() to set one specific resource.
	// This method my perform the change immediatelly or buffer the change
	// for later (*::EndResources()).
	// Conditional chaining (doesn't recognize resource)
	//		r: resource type enumeration (YtN...)
	//		v: resource value union
	virtual void SetResource (YtResource r, ResourceVal& v);

	//-------
	// Called by primitive::YtSetValues() to end the resource settings.
	// This method is useful to buffer a set of resources.
	// Front chaining
	virtual void EndResources ();

public:
	primitive (Shell* shell, char *name, composite *parent = NULL);
	virtual ~primitive ();

	//-------
	// Pure virtual function.
	// Redraw the primitive.
	// No chaining (or conditional chaining)
	virtual void expose () = 0;

	//-------
	// Pure virtual function.
	// Recalculate graphics and children after a size change.
	// Called from within primitive::YtSetValues() and from within parents.
	// No chaining (or conditional chaining)
	virtual void resize () = 0;

	//-------
	// Pure virtual function.
	// Typically called by parent.
	// Return the prefered size of this primitive. The caller may propose a
	// size but this child may ignore it completely.
	// No chaining (or conditional chaining)
	//		answer: contains a new proposal for the size before the call and
	//						contains the new size after the call
	//		->      GeometryNo, GeometryYes, ...
	virtual GeometryResult query_geometry (GeometryRequest& answer) = 0;

	//-------
	// Handle an Intuition event for this primitive. Called by Shell::DispatchEvent().
	// No chaining (or conditional chaining)
	//		clas:  Intuition class
	//		code:  Intuition code
	//		qual:  Intuition qualifier
	//		iaddr: Intuition IAddress
	//		->		 returns TRUE if application should quit
	virtual int HandleEvent (unsigned long clas, unsigned short code, unsigned short qual, void* iaddr);

	//-------
	// Clear the graphics queue (no furthur processing needed).
	// No chaining
	virtual void ClearQueue ();

	//-------
	// Play the graphics queue.
	// No chaining
	virtual void PlayQueue ();

	//-------
	// Primitive information functions
	primitive*	get_next ()		{ return next; }
	primitive*	get_prev ()		{ return prev; }
	char*				get_name ()		{ return name; }
	composite*	get_parent ()	{ return parent; }
	Shell*			get_shell ()	{ return shell; }

	//-------
	// Set a bunch of resources for this primitive
	//		r: resource type
	//		-> returns TRUE if success
	boolean YtSetValues (YtResource r ...);

	//-------
	// Add a callback to this primitive.
	// Callback functions are called from within the *::HandleEvent() method.
	// Conditional chaining (if unknown callback type)
	//		cbt:  callback type (YtN...Callback)
	//		cbf:  callback function
	//		user:	user data
	//		->    returns TRUE if success
	virtual boolean YtAddCallback (YtCallback cbt, YtCallbackFun cbf, void* user = NULL);
};

#endif
