///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : mgwindow.h            ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
//	Class MGWindow :
//
//		- Complete window with graphics and message handling.
//
//		- Inherits 'MsgWindow' and 'GfxWindow'
//
//	See 'MsgWindow.h' and 'GfxWindow.h' for further detail.

#ifndef __MGWINDOW__
#define __MGWINDOW__

#include <ipp/gfxwindow.h>
#include <ipp/msgwindow.h>


class MGWindow : public MsgWindow, public GfxWindow
{
public:
	MGWindow();
	MGWindow(struct NewWindow *newwindow);
	MGWindow(struct ExtNewWindow *extnewwindow);
	MGWindow(struct NewWindow *newwindow, struct TagItem *tags);
	~MGWindow();
	virtual BOOL open();
	virtual void close();
};

#endif //__MGWINDOW__

