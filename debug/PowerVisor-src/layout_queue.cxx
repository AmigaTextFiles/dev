//===============================================//
// Layout manager classes                        //
// Queue   																			 //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

#include <exec/types.h>
#include <proto/intuition.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>
#include <intuition/classusr.h>

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_QUEUE_H
#include "layout_queue.h"
#endif

#ifndef LAYOUT_SHELL_H
#include "layout_shell.h"
#endif

//-----------------------------------------------------------------//
// QUEUE                                                           //
//-----------------------------------------------------------------//

void Queue::Clear ()
{
	D db("Queue::Clear for", parent->get_name ());
	QueueCmd* next;
	while (first)
	{
		next = first->next;
		delete first;
		first = next;
	}
	last = NULL;
}


void Queue::Optimize ()
{
	D db("Queue::Optimize for", parent->get_name ());
}


QueueCmd* Queue::AddQO (QueueOp op)
{
	D db("Queue::AddQO for", parent->get_name ());
	QueueCmd* qc = new QueueCmd;
	qc->next = NULL;
	qc->op = op;
	if (last)
	{
		last->next = qc;
	}
	last = qc;
	if (!first) first = qc;
	return qc;
}

