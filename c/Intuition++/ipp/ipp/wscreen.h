///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : wscreen.h             ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
//	Class WScreen :
//
//		- Simple screen and event handling.
//
//		- Inherits 'CScreen' and 'Waiter'.
//
//		- When you link some windows to this type of screen, you can
//		pass control to it and let him manage all your application.
//
//	See 'Waiter.h for further detail.


#ifndef __WSCREEN__
#define __WSCREEN__

#include <ipp/gscreen.h>
#include <ipp/waiter.h>


class WScreen : public virtual CScreen, public virtual Waiter
{
public:
	WScreen();
	WScreen(struct NewScreen *newscreen);
	WScreen(struct ExtNewScreen *extnewscreen);
	WScreen(struct NewScreen *newscreen, struct TagItem *tags);
	~WScreen();

	virtual BOOL open();
	virtual void close();

	virtual BOOL linkwindow(MsgWindow& window);
	virtual MsgWindow * rmwindow(MsgWindow& window);
	virtual void rmwindows();
};


#endif //__GSCREEN__
