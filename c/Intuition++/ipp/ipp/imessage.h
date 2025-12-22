///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : imessage.h            ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
//	Class IMessage :
//
//		- Encapsulation of IntuiMessage for C++
//
//
//	Class IEvent :
//
//		- Simple event handling for 'MsgWindow'
//


#ifndef __IMESSAGE__
#define __IMESSAGE__

#include <intuition/intuition.h>

class IMessage
{
public:
	IMessage();
	~IMessage();

	void clear();
	ULONG iclass;
	ULONG icode;
	ULONG iqualifier;
	void * iaddress;
	int imousex;
	int imousey;
	ULONG iseconds;
	ULONG imicros;
};

class IEvent
{
protected:
	void nothing();
public:
	IEvent();
	~IEvent();

	void clear();
	ULONG eclass;
	ULONG ecode;
	ULONG equalifier;
	void *eitem;
	void (*ecallback)(IMessage *);
	IEvent *nextevent;
};

#define NOMESSAGE	IDCMP_NOMESSAGE
#define IDCMP_NOMESSAGE		0x00000000

#endif //__IMESSAGE__

