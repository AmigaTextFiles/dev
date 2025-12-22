///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : msgwindow.cc          ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////


#include <intuition/intuitionbase.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <exec/ports.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <clib/exec_protos.h>


//extern "C" struct IntuiMessage *WaitPort();
//extern "C" struct IntuiMessage *GetMsg();
//extern "C" void ReplyMsg();


#include "msgwindow.h"


MsgWindow :: MsgWindow()
{
	menu=NULL;
	events=NULL;
}


MsgWindow :: MsgWindow(struct NewWindow *neww) : CWindow(neww)
{
	menu=NULL;
	events=NULL;
}


MsgWindow :: MsgWindow(struct ExtNewWindow *neww) : CWindow(neww)
{
	menu=NULL;
	events=NULL;
}


MsgWindow :: MsgWindow(struct NewWindow *neww, struct TagItem *tags) : CWindow(neww, tags)
{
	menu=NULL;
	events=NULL;
}


MsgWindow :: ~MsgWindow()
{
	if (wind) ClearMenuStrip(wind);
	rmIevents();
	clearImsg();
}


BOOL MsgWindow :: open()
{
	CWindow::open();
	if (menu && wind) SetMenuStrip(wind,menu);
	return isopen();
}


void MsgWindow :: close()
{
	if (wind) ClearMenuStrip(wind);
	CWindow::close();
}


void MsgWindow :: update()
{
	CWindow::update();
	if (menu && wind) SetMenuStrip(wind,menu);
}


ULONG MsgWindow :: setIDCMPflags(ULONG flags)
{
	ULONG oldf=newwind->IDCMPFlags;
	newwind->IDCMPFlags=flags;
	if (wind) ModifyIDCMP(wind,flags);
	return oldf;

}


ULONG MsgWindow :: getIDCMPflags()
{
	return newwind->IDCMPFlags;
}


struct Gadget * MsgWindow :: linkgadgets(struct Gadget *newg)
{
struct Gadget *oldg;
	oldg=newwind->FirstGadget;
	newwind->FirstGadget=newg;
	update();
	return oldg;
}


struct Gadget * MsgWindow :: rmgadgets()
{
struct Gadget *oldg;
	oldg=newwind->FirstGadget;
	newwind->FirstGadget=NULL;
	update();
	return oldg;
}


void MsgWindow :: refreshgadgets(struct Gadget *gads)
{
	if (!isopen()) return;
	RefreshGadgets(gads,wind,NULL);
}


void MsgWindow :: refreshglist(struct Gadget *gads, WORD num)
{
	if (!isopen()) return;
	RefreshGList(gads,wind,NULL,num);
}


BOOL MsgWindow :: activategadget(struct Gadget *gad)
{
	if (!isopen()) return FALSE;
	return ActivateGadget(gad, wind, NULL);
}


void MsgWindow :: ongadget(struct Gadget *gad)
{
	if (!isopen()) return;
	OnGadget(gad, wind, NULL);
}


void MsgWindow :: offgadget(struct Gadget *gad)
{
	if (!isopen()) return;
	OffGadget(gad, wind, NULL);
}


struct Menu * MsgWindow :: linkmenu(struct Menu *newm)
{
struct Menu *oldm;
	oldm=menu;
	menu=newm;
	update();
	return oldm;
}


struct Menu * MsgWindow :: rmmenu()
{
struct Menu *oldm;
	oldm=menu;
	menu=NULL;
	update();
	return oldm;
}


void MsgWindow :: onmenu(UWORD num)
{
	if (!isopen()) return;
	OnMenu(wind, num);
}


void MsgWindow :: offmenu(UWORD num)
{
	if (!isopen()) return;
	OffMenu(wind, num);
}


void MsgWindow :: reportmouse(BOOL ok)
{
	ReportMouse(ok,wind);
}


IMessage * MsgWindow :: readImsg(struct IntuiMessage *mess ,IMessage& imessage)
{
	if (mess)
	{
		imessage.iclass=mess->Class;
		imessage.icode=mess->Code;
		imessage.iqualifier=mess->Qualifier;
		imessage.iaddress=(void *)mess->IAddress;
		imessage.imousex=mess->MouseX;
		imessage.imousey=mess->MouseY;
		imessage.iseconds=mess->Seconds;
		imessage.imicros=mess->Micros;
		ReplyMsg((struct Message *)mess);
	}
	else imessage.clear();
	return &imessage;
}


IMessage * MsgWindow :: getImsg(IMessage& imessage)
{
	if (!isopen()) return NULL;
	return (IMessage *)readImsg((struct IntuiMessage *)GetMsg(wind->UserPort),imessage);
}


IMessage * MsgWindow :: waitImsg(IMessage& imessage)
{
	if (!isopen()) return NULL;
	WaitPort(wind->UserPort);
	return (IMessage *)readImsg((struct IntuiMessage *)GetMsg(wind->UserPort),imessage);
}


void MsgWindow :: clearImsg()
{
IMessage *mess;
	if (!isopen()) return;
	while (mess=(IMessage *)GetMsg(wind->UserPort)) ReplyMsg((struct Message *)mess);
}


BOOL MsgWindow :: linkIevent(	ULONG niclass,
				ULONG nicode,
				ULONG niqualifier,
				void *nitem,
				void (*ncallback)(IMessage&))
{
IEvent *event;
	if (niclass==NOMESSAGE) return FALSE;
	if (ncallback==NULL) return FALSE;
	event = new IEvent;
	event->eclass=niclass;
	event->ecode=nicode;
	event->equalifier=niqualifier;
	event->eitem=nitem;
	event->ecallback=(void (*)(IMessage *))ncallback;
	event->nextevent=events;
	events=event;
	return TRUE;
}

void MsgWindow :: rmIevents()
{
IEvent *event;
	if (events==NULL) return;
	while (events)
	{
		event=events->nextevent;
		delete events;
		events=event;
	}
}


IMessage * MsgWindow :: filterImsg(IMessage &imessage)
{
IEvent *event;
	if (events==NULL) return NULL;
	if (imessage.iclass==NOMESSAGE) return &imessage;
	for (event=events;event;event=event->nextevent)
	{
		if (imessage.iclass!=event->eclass) continue;
		switch(imessage.iclass)
		{
			case GADGETUP:
			case GADGETDOWN:
				if (imessage.iaddress==event->eitem)
				{
					event->ecallback(&imessage);
					return NULL;
				}
				else continue;
				break;

			case MENUPICK:
				if (event->eitem==(char *)ItemAddress(menu,imessage.icode))
				{
					event->ecallback(&imessage);
					return NULL;
				}
				else continue;
				break;

			case RAWKEY:
			case VANILLAKEY:
			case MOUSEBUTTONS:
				if (imessage.icode==event->ecode)
				{
					if (event->equalifier==0)
					{
						event->ecallback(&imessage);
						return NULL;
					}
					else
					{
						if (imessage.iqualifier & event->equalifier)
						{
							event->ecallback(&imessage);
							return NULL;
						}
						else continue;
					}
				}
				else continue;
				break;

			default:
				event->ecallback(&imessage);
				return NULL;
		}
	}
	return &imessage;
}


IMessage * MsgWindow :: softcontrol(IMessage& imessage)
{
	if (!isopen()) return NULL;
	for (;;)
	{
		imessage.clear();
		waitImsg(imessage);
		if (filterImsg(imessage)) return &imessage;
	}
}


void MsgWindow :: hardcontrol()
{
IMessage imessage;
	if (!isopen()) return;
	for (;;) imessage.clear(), waitImsg(imessage), filterImsg(imessage);
}


