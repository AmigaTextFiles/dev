///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : gfxwindow.h           ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
//	Class GfxWindow :
//
//		- Simple graphic window handling.
//
//		- Inherits 'CWindow' and 'CRastPortHdl'


#ifndef __GFXWINDOW__
#define __GFXWINDOW__

#include <ipp/cwindow.h>
#include <ipp/crastporthdl.h>


class GfxWindow : public virtual CWindow, public virtual CRastPortHdl
{
public:
	GfxWindow();
	GfxWindow(struct NewWindow *newwindow);
	GfxWindow(struct ExtNewWindow *extnewwindow);
	GfxWindow(struct NewWindow *newwindow, struct TagItem *tags);
	~GfxWindow();

	virtual BOOL open();
	virtual void close();
	virtual void clear();
};


#endif //__GFXWINDOW__
