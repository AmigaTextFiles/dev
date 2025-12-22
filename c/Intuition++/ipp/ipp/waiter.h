///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : waiter.h              ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
//	Class WNode :
//
//		- Node for multiple windows handling
//
//
//	Class Waiter :
//
//		- Object to wich you can link different windows and pass control
//		to it, for it can wait for and dispatch messages to their owner.
//
//		- softcontrol() and hardcontrol() as the same effect that those
//		in 'MsgWindow' but for multiple windows.
//
//	See 'MsgWindow.h for further detail.



#ifndef __WAITER__
#define __WAITER__

#include <ipp/msgwindow.h>


class MsgWNode
{
public:
	MsgWindow *wn;
	MsgWNode *nextwnode;

	MsgWNode();
	~MsgWNode();
};


class Waiter
{
protected:
	MsgWNode *mwlist;
	unsigned long waitingmask;
public:
	Waiter();
	~Waiter();
	virtual BOOL linkwindow(MsgWindow& window);
	virtual MsgWindow * rmwindow(MsgWindow& window);
	virtual void rmwindows();
	MsgWindow * softcontrol(IMessage& messagenothandled);
	void hardcontrol();
};

#endif //__WAITER__
