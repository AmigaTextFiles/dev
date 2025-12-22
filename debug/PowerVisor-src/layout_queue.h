//===============================================//
// Layout manager classes                        //
// Queue header file                             //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#ifndef LAYOUT_QUEUE_H
#define LAYOUT_QUEUE_H 1

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_PRIMITIVE_H
#include "layout_primitive.h"
#endif

enum QueueOp
{
	QONOP = -1,
	QORefreshGadget,
	QOSetGadgetAttr,
	QOSetImageAttr
};

union QueueArg
{
	int i;
	long l;
	void* p;
};

struct QueueCmd
{
	QueueCmd* next;
	QueueOp op;
	QueueArg a1, a2, a3, a4;
};

class Queue
{
	primitive* parent;

protected:
	QueueCmd* last;
	QueueCmd* first;
	QueueCmd* AddQO (QueueOp op);
	virtual void Optimize ();

public:
	Queue (primitive* parent) { first = last = NULL; Queue::parent = parent; }
	~Queue () { Clear (); }

	void Clear ();
	primitive* get_parent () { return parent; }
};

#endif
