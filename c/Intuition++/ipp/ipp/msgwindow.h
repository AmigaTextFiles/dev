///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : msgwindow.h           ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
//	Class MsgWindow :
//
//		- Simple event-driven handling for Intuition windows.
//		Link gadgets and menu you created to this object and
//		link any message it could get with its corresponding gadget
//		or menu item and the function you want to be called when
//		receiving appropriate message.
//		  Then give control to the window with softcontrol() or
//		hardcontrol().
//
//		- softcontrol() returns the current message only if the
//		object get a message wich as not been handled by it,
//		 i.e. there is no link made by you for this message.
//
//		- hardcontrol() never returns !!!
//
//		- If you don't wish to give control to the object you can
//		handle messages yourself with getImsg() or waitImsg() or
//		filterImsg() wich executes the appropriate callback linked
//		by you or return the message if it's inapropriate.


#ifndef __MSGWINDOW__
#define __MSGWINDOW__

#include <ipp/cwindow.h>
#include <ipp/imessage.h>


class MsgWindow : public virtual CWindow
{
protected:
	struct Menu *menu;
	IEvent *events;
	virtual void update();
	IMessage * readImsg(struct IntuiMessage *intuimessage, IMessage& imessage);
public:
	MsgWindow();
	MsgWindow(struct NewWindow *newwindow);
	MsgWindow(struct ExtNewWindow *extnewwindow);
	MsgWindow(struct NewWindow *newwindow, struct TagItem *tags);
	~MsgWindow();

	virtual BOOL open();
	virtual void close();
	ULONG setIDCMPflags(ULONG idcmpflags);
	ULONG getIDCMPflags();

	struct Gadget * linkgadgets(struct Gadget *gadgetlist);
	struct Gadget * rmgadgets();
	void refreshgadgets(struct Gadget *gadgetlist);
	void refreshglist(struct Gadget *gadgetlist, WORD count);
	BOOL activategadget(struct Gadget *gadget);
	void ongadget(struct Gadget *gadget);
	void offgadget(struct Gadget *gadget);

	struct Menu * linkmenu(struct Menu *menu);
	struct Menu * rmmenu();
	void onmenu(UWORD menunumber);
	void offmenu(UWORD menunumber);

	void reportmouse(BOOL yesorno);

	BOOL linkIevent(ULONG iclass, ULONG icode, ULONG iqualifier, void *object, void (*callback)(IMessage&));
	void rmIevents();

	IMessage * getImsg(IMessage& imessage);
	IMessage * waitImsg(IMessage& imessage);
	void clearImsg();
	IMessage * filterImsg(IMessage& imessage);
	IMessage * softcontrol(IMessage& imessage);
	void hardcontrol();
};


#endif //__MSGWINDOW__

