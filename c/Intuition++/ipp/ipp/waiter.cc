///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : waiter.cc             ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////


#include <clib/exec_protos.h>

//extern "C" int Wait(unsigned long);


#include "waiter.h"


Waiter :: Waiter()
{
	mwlist=NULL;
}


Waiter :: ~Waiter()
{
	rmwindows();
}


BOOL Waiter :: linkwindow(MsgWindow& window)
{
MsgWNode *node;
	if ((node=new MsgWNode)==NULL) return FALSE;
	node->wn=&window;
	node->nextwnode=mwlist;
	mwlist=node;
	return TRUE;
}


MsgWindow * Waiter :: rmwindow(MsgWindow& window)
{
MsgWNode *oldnode,*n;
	if (mwlist==NULL) return NULL;
	if (mwlist->wn==&window)
	{
		oldnode=mwlist;
		mwlist=mwlist->nextwnode;
		delete oldnode;
		return &window;
	}
	for (n=mwlist;n->nextwnode;n=n->nextwnode)
	{
		if (n->nextwnode->wn==&window)
		{
			oldnode=n->nextwnode;;
			n->nextwnode=n->nextwnode->nextwnode;
			delete oldnode;
			return &window;
		}
	}
	return NULL;
}


void Waiter :: rmwindows()
{
MsgWNode *nextnode;
	while (mwlist)
	{
		nextnode=mwlist->nextwnode;
		delete mwlist;
		mwlist=nextnode;
	}
}


MsgWindow * Waiter :: softcontrol(IMessage &message)
{
MsgWNode *n;
MsgWindow *concerned;
unsigned long sig;
IMessage *mess;
	for (;;)
	{
		message.clear();
		for (n=mwlist,waitingmask=0;n;n=n->nextwnode)
			if (n->wn->isopen())
				waitingmask|=1<<n->wn->wind->UserPort->mp_SigBit;
		sig=Wait(waitingmask);
		if (sig==0) return NULL;
		for (n=mwlist,concerned=NULL;n;n=n->nextwnode)
			if (n->wn->isopen())
				if (sig & (1<<n->wn->wind->UserPort->mp_SigBit))
				{
					concerned=n->wn;
					break;
				}
		if (concerned)
		{
			mess=concerned->getImsg(message);
			if (mess)
			{
				mess=concerned->filterImsg(message);
				if (mess) return concerned;
			}
		}
	}
}


void Waiter :: hardcontrol()
{
MsgWNode *n;
MsgWindow *concerned;
unsigned long sig;
IMessage *mess,message;
	for (;;)
	{
		message.clear();
		for (n=mwlist,waitingmask=0;n;n=n->nextwnode)
			if (n->wn->isopen())
				waitingmask|=1<<n->wn->wind->UserPort->mp_SigBit;
		sig=Wait(waitingmask);
		if (sig==0) continue;
		for (n=mwlist,concerned=NULL;n;n=n->nextwnode)
			if (n->wn->isopen())
				if (sig & (1<<n->wn->wind->UserPort->mp_SigBit))
				{
					concerned=n->wn;
					break;
				}
		if (concerned)
		{
			mess=concerned->getImsg(message);
			if (mess) mess=concerned->filterImsg(message);
		}
	}
}


MsgWNode :: MsgWNode()
{
	wn=NULL;
	nextwnode=NULL;
}


MsgWNode :: ~MsgWNode() {}

