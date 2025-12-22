///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : wgscreen.h            ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
//	Class WGScreen :
//
//		- Complete graphic screen with event handling.
//
//		- Inherits 'GScreen' and 'WScreen'
//
//	See 'GSCreen.h' and 'WScreen.h' for further detail.


#ifndef __WGSCREEN__
#define __WGSCREEN__

#include <ipp/gscreen.h>
#include <ipp/wscreen.h>


class WGScreen : public virtual GScreen, public virtual WScreen
{
public:
	WGScreen();
	WGScreen(struct NewScreen *newscreen);
	WGScreen(struct ExtNewScreen *extnewscreen);
	WGScreen(struct NewScreen *newscreen, struct TagItem *tags);
	~WGScreen();

	virtual BOOL open();
	virtual void close();

	virtual BOOL linkwindow(MsgWindow& window);
	virtual MsgWindow * rmwindow(MsgWindow& window);
	virtual void rmwindows();
};


#endif //__WGSCREEN__
